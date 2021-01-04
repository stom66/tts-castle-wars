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

    --unlock the deck
    deck.interactable = true
    deck.setLock(false)

    --put the object back in the deck after 1 frame
    Wait.frames(function()
        deck.putObject(card)
    end, 1)
    
    --re-lock the deck after another frame
    Wait.frames(function()
        deck.interactable = false
        deck.setLock(true)
    end, 2)

    --shuffle the deck
    Wait.time(function()
        deck.randomize()
    end, 1.1)
end


function cards_updateScales(player_color)
    local cards = Player[player_color].getHandObjects()
    for _,card in ipairs(cards) do
        if playerCanAffordCard(player_color, card_getID(card)) then
            card.setScale({1, 1, 1})
        else
            card.setScale({0.75, 1, 0.75})
        end
    end
end


--[[
    Card actions

    These are the actual actions triggered by the cards when they're played
 --]]

function card_addBuff(player, value)
    data[player]["buff_"..value] = true
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
        target = otherPlayer(player)
    end
    data[target].all_produce = value
end

function card_attack(player, damage, bypass_wall)
    local target = otherPlayer(player)

    --check for attack buffs
    if data[player].buff_attack then
        damage = damage * 2
        data[player].buff_attack = false
    end
    
    --check for defence buffs
    if data[target].buff_defence then
        damage = 0
        data[target].buff_defence = false
    end

    if data[target].wall > 0 and not bypass_wall then
        data[target].wall = data[target].wall - damage
        if data[target].wall < 0 then
            damage = math.abs(data[target].wall)
            data[target].wall = 0
        else
            damage = 0
        end
        updateWallHeight(target)
    end
    if damage > 0 then
        data[target].castle = data[target].castle - damage
        updateCastleHeight(target)
    end
end

function card_buildCastle(player, value)
    --check for building buffs
    if data[player].buff_build then
        value = value * 2
        data[player].buff_build = false
    end
    data[player].castle = data[player].castle + value
    updateCastleHeight(player)
end

function card_buildWall(player, value)
    --check for building buffs
    if data[player].buff_build then
        value = value * 2
        data[player].buff_build = false
    end

    data[player].wall = data[player].wall + value
    updateWallHeight(player)
end

function card_curse(player, value)
    --remove 1 of everything from the opponents and grant it to the player
    --applies to everything: resources, workers, castle and wall
    local target = otherPlayer(player)

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
    local target = otherPlayer(player)
    if value=="all" then
        card_removeBuff(player, "build")
        card_removeBuff(player, "defence")
        card_removeBuff(player, "attack")
        card_removeBuff(player, "resources")
    else
        data[target]["buff_"..value] = false
    end
end

function card_removeResource(player, value)
    local target = otherPlayer(player)

    --check for building buffs
    if data[target].buff_resources then
        value = {0, 0, 0}
        data[target].buff_resources = false
    end

    --remove resources from the opponent
    removeResources(target, value)
end

function card_sabotage(player, value)
end

function card_stealWorker(player, value)
    --add workers to player
    card_addWorker(player, value)

    --remove players workers from target, leaving a minimum of 1
    local target = otherPlayer(player)
    data[target].builders = math.max(1, data[target].builders - value[1])
    data[target].mages    = math.max(1, data[target].mages - value[2])
    data[target].soldiers = math.max(1, data[target].soldiers - value[3])
end

function card_thief(player, value)
    local target = otherPlayer(player)

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
    local target = otherPlayer(player)
    card_attack(target, 6, true)
    updateCastleHeight(target)
end
