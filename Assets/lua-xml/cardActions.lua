--[[
    Card  functions

    Some general utilities for dealing with cards
--]]

function card_getID(obj)
    -- return the CardID value for any card, or false if not a card
    return obj.getData().CardID or false
end

function card_getName(id)
    --get the name of a card from it's ID. References the global card table
    return cards[id].name or "Unknown Card"
end

function card_addToDeck(card, deck)
    --[[
        puts a card in a specified deck
        expects both params to be obj references
     --]]

    if data.debug then log("Attempting to putObject "..card.getGUID().." into deck "..deck.getGUID()) end

    --unlock the deck and return the card
    deck.interactable = true
    deck.setLock(false)
    deck.putObject(card)
    deck.shuffle()

    --re-lock the deck after another frame
    --Wait.frames(function()
        deck.interactable = false
        deck.setLock(true)
    --end, 1)

    --shuffle the deck
end

function cards_updateScales(player_color)
    --[[
        Updates the scales of cards in the player hands based on if the player can 
        afford to play them or not
    --]]

    --abort if the game isn't in progress
    if data.game_state ~= "active" or player_color=="" then return false end

    --Get a table of all cards in the players hand

    if data.debug then
        log("cards_updateScales: "..player_color)
        log("handzone GUID: "..data[player_color].handzone_obj.getGUID())
    end
    local cards = data[player_color].handzone_obj.getObjects()



    --log("cards_updateScales for player "..player_color.." found "..#cards.." cards in hand")
    --log(cards)

    --Loop though, adjusting scale of each card in hand
    for _,card in ipairs(cards) do
        local cardId = card_getID(card)
        if cardId then
            if player_canAffordCard(player_color, cardId) then
                card.setScale({1, 1, 1})
            else
                card.setScale({0.75, 1, 0.75})
            end
        end
    end
end


--[[
    Card game actions

    These are the actual actions triggered by the cards when they're played, eg attacks, 
    construction, buffs, etc

 --]]

function card_addBuff(player, value)
    data[player].buff[value] = true
end

function card_addResource(player, value)
    addResources(player, value)
end

function card_addWorker(player, value)
    data[player].builders = data[player].builders + value[1]
    data[player].mages    = data[player].mages + value[2]
    data[player].soldiers = data[player].soldiers + value[3]
end

function card_allProduce(player, value)
    local target = player
    if value == "none" then
        target = playerOpponent(player)
    end
    data[target].all_produce = value
end

function card_attack(player, damage, bypass_wall, delay)
    local target = playerOpponent(player)

    --check for attack buffs
    if data[player].buff.attack then
        damage = damage * 2
        data[player].buff.attack = false
    end

    --check for defence buffs
    if data[target].buff.defence then
        damage = 0
        data[target].buff.defence = false
    end

    if data[target].wall > 0 and not bypass_wall then
        data[target].wall = data[target].wall - damage
        if data[target].wall < 0 then
            damage = math.abs(data[target].wall)
            data[target].wall = 0
        else
            damage = 0
        end
        updateWallHeight(target, delay)
    end
    if damage > 0 then
        data[target].castle = math.max(0, data[target].castle - damage)
        Wait.time(function()
            updateCastleHeight(target)
        end, delay or 0)
    end
end

function card_buildCastle(player, value, bypass, delay)
    --check for building buffs
    if data[player].buff.build then
        value = value * 2
        data[player].buff.build = false
    end
    data[player].castle = data[player].castle + value
    updateBuildingHeights(player, delay, bypass)
end

function card_buildWall(player, value, bypass, delay)
    --check for building buffs
    if data[player].buff.build then
        value = value * 2
        data[player].buff.build = false
    end

    --update the value and trigger the wall move
    data[player].wall = data[player].wall + value
    updateBuildingHeights(player, delay, bypass)
end

function card_curse(player, value)
    --remove 1 of everything from the opponents and grant it to the player
    --applies to everything: resources, workers, castle and wall
    local target = playerOpponent(player)

    --steal workers
    card_stealWorker(player, {1, 1, 1})

    --steal resources
    card_removeResource(player, {1, 1, 1})
    card_addResource(player, {1, 1, 1})

    --steal castle height
    card_buildCastle(player, 1)
    card_attack(player, 1, true)

    --steal wall (even if they don't have it)
    card_buildWall(player, 1)
    card_attack(player, 1)
end

function card_removeBuff(player, value)
    --removes a buff from the other player
    local target = playerOpponent(player)
    if value=="all" then
        card_removeBuff(player, "build")
        card_removeBuff(player, "defence")
        card_removeBuff(player, "attack")
        card_removeBuff(player, "resources")
    else
        data[target].buff[value] = false
    end
end

function card_removeResource(player, value)
    local target = playerOpponent(player)

    --check for the "protect resources" buff
    if data[target].buff.resources then
        value = {0, 0, 0}
        data[target].buff.resources = false
    end

    --remove resources from the opponent
    removeResources(target, value)

    --add them to the player
    --addResources(player, value)
end

function card_sabotage(player_color, value)

    --take all cards from targets hand and move them to behind our player's hand
    local target = playerOpponent(player_color)

    --Check we've got a player in the seat
    if not Player[player_color].seated then
        log("Can't invoke method card_sabotage for non-existant player "..player_color)
        return false
    end
    if not Player[target].seated then
        log("Can't invoke method card_sabotage for non-existant player "..target)
        return false
    end

    --get a table of all the cards in the targets handzone and loop through them
    local cards = data[target].handzone_obj.getObjects()
    for _,card in ipairs(cards) do

        --add a reference to the card GUID in the player data
        table.insert(data[player_color].discard_objs, card.getGUID())

        --move the card to the other side of the table and rotate it
        local pos = card.getPosition()
        pos:setAt("x", pos.x * -1.16):setAt("z", pos.z * -1)
        card.setPosition(pos)
        card.setRotation(card.getRotation():add(Vector(0, 180, 0)))

        --create a button on the card to trigger a discard
        card.createButton({
            click_function = "card_sabotage_discard",
            label          = "DISCARD",
            position       = {0, 0.1, 1.85},
            width          = 1000,
            height         = 300,
            fontSize       = 280,
            hover_color    = {0.2, 0.2, 0.2},
            color          = {0.1, 0.1, 0.1},
            font_color     = {1, 1, 1},
        })
    end

    --move the player camera to look at the choice of cards to discard
    local hand_pos = Player[player_color].getHandTransform()
    Player[player_color].lookAt({
        position = hand_pos.position * 1.16,
        pitch    = 45,
        yaw      = hand_pos.rotation.y,
        distance = 20,
    })

    --message the players to explain what's going on
    broadcastToColor(lang.discard_wait_for_player, target, "Red")
    broadcastToColor(lang.discard_choose_card, player_color, "Green")
end

    function card_sabotage_discard(obj, player, alt_click)
        --the function triggered by clicking the "Discard" button on a card
        local target = playerOpponent(player)

        --check if the right player is trying to discard
        if not table.contains(data[player].discard_objs, obj.getGUID()) then
            if table.contains(data[target].discard_objs, obj.getGUID()) then
                player, target = target, player
            else
               print("There was an error, the card you are trying to discard is not registered to anyone!") 
            end
        end

        --loop through the objects stored in the discard_objs table
        local card_guids = data[player].discard_objs
        for _,g in ipairs(card_guids) do

            --create a local reference to the card object
            local card = getObjectFromGUID(g)

            --remove the buttons from it
            card.clearButtons()

            --if the card is the one that was clicked then return it to the target players deck
            if g == obj.getGUID() then
               card_addToDeck(card, data[target].deck_obj)
            else --otherwise return it to their hand
                card.deal(1, target)
            end
        end

        --reset the table of discard_objs
        data[player].discard_objs = {}

        --deal a single replacement card to the target
        player_dealCards(target, 1)

        --trigger the next turn
        Wait.time(turn_next, 1.5)
    end


function card_stealWorker(player, value)
    --add workers to player
    card_addWorker(player, value)

    --remove players workers from target, leaving a minimum of 1
    local target = playerOpponent(player)
    data[target].builders = math.max(1, data[target].builders - value[1])
    data[target].mages    = math.max(1, data[target].mages - value[2])
    data[target].soldiers = math.max(1, data[target].soldiers - value[3])
end

function card_thief(player, value)
    local target = playerOpponent(player)
    
    --add 6 of each resource, or however many the oponent has, whichever is smaller
    card_addResource(player, {
        math.min(6, data[target].bricks),
        math.min(6, data[target].crystals),
        math.min(6, data[target].swords)
    })

    --remove those resources
    card_removeResource(player, {6, 6, 6})
end

function card_wain(player, value)
    --build our castle
    card_buildCastle(player, 6)
    updateCastleHeight(player)

    --lower oponent castle
    local target = playerOpponent(player)
    card_attack(player, 6, true)
    updateCastleHeight(target)
end
