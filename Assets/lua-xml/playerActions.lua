--[[
    This file contains the various player actions, eg actions the player can perform directly

    This includes
    - Playing Cards
    - Discarding Cards

    It also includes some hand management functions, such as dealing fresh cards to the player

]]


function trigger_playCard(player_color)
    --[[
        Activated by either the context menu shortcut, the scripting buttons shortcut, or by the card falling into the play zone
        Checks the following:
            - player has a deck
            - object is a card
            - card is in player's handzone

        If checks pass, pass it on to the player_playCard function
    ]]

    --check the player actually has a deck
    if not data[player_color].deck_obj then
        bToColor(lang.deck_not_locked, player_color, "Red")
        return false
    end

    --get the objects they have selected
    local objs = Player[player_color].getSelectedObjects()

    --if they have no objects selected then check for object they're hovering over
    if #objs < 1 then
        objs = {Player[player_color].getHoverObject()}
    end

    --check we have at least 1 object before continuing
    if #objs < 1 then
        return false
    end

    --reject multiple cards
    if #objs > 1 or #objs < 1 then
        bToColor(lang.cant_play_multiple_cards, player_color, "Red")
        return false
    end

    --reject non-card objects
    if objs[1].tag~="Card" then
        bToColor(lang.cant_play_non_card, player_color, "Red")
        return false
    end

    --ensure the player owns the card
    if not handzone_containsObject(objs[1], player_color) then
        bToColor(lang.card_not_in_hand, player_color, "Red")
        return false
    end

    --if we made it this far then we have a single card in the player's hand-zone, so play it
    player_playCard(objs[1], player_color)
end


function trigger_discardCard(player_color)
    --check the player actually has a deck
    if not data[player_color].deck_obj then
        bToColor(lang.deck_not_locked2, player_color, "Red")
    end

    if Turns.turn_color ~= player_color or data[player_color].action_taken then
        --not their turn, return card to their hand and warn them
        bToColor(lang.not_your_turn, player_color)
        return false
    end

    local objs = Player[player_color].getSelectedObjects()

    --if they have no objects selected then check for object they're hovering over
    if #objs < 1 then
        objs = {Player[player_color].getHoverObject()}
    end

    --check we have at least 1 object before continuing
    if #objs < 1 then
        return false
    end

    --check we're not going to exceed the max number of discards per turn
    if #objs > data.max_discard_per_turn
    or (data[player_color].discards + #objs) > data.max_discard_per_turn then
        bToColor(lang.max_discards_reached, player_color, "Red")
        return false
    end

    --loop through each of the objects and check it's suitable
    for _,card in ipairs(objs) do

        --reject non-card objects
        if card.tag~="Card" then
            bToColor(lang.cant_play_non_card, player_color, "Red")
            return false
        end

        --ensure the player owns the card
        if not handzone_containsObject(card, player_color) then
            bToColor(lang.card_not_in_hand, player_color, "Red")
            return false
        end

        --check it's a card and we're below the round limit for discarding cards
        if data[player_color].discards < data.max_discard_per_turn then
            data[player_color].discards = data[player_color].discards + 1
            card_addToDeck(card, data[player_color].deck_obj)
        end
    end

    --check if we've reached the max number of discards, if so then we can trigger the next turn
    if data[player_color].discards >= data.max_discard_per_turn then
        turn_next()
    end
end



function player_playCard(card, player_color)
    --[[
        Triggerd by a player dropping a card into their scriptingzone play areas
        or by them right clicking on a card and choosing "Play Card"
    --]]

    -- Check it's the player's turn
    if Turns.turn_color ~= player_color or data[player_color].action_taken then
        --not their turn, return card to thei hand and warn them
        card.deal(1, player_color)
        bToColor(lang.not_your_turn, player_color, "Orange")
        return false
    else
        -- It is their turn, so set action_taken flag to true to prevent playing multiple cards at once
        data[player_color].action_taken = true
    end

    -- Check the player hasn't discarded cards this round
    if data[player_color].discards > 0 then
        bToColor(lang.cant_play_after_discard, player_color, "Red")
        data[player_color].action_taken = false
        return false
    end

    -- Get the CardID
    local cardId = card_getID(card)
    if not cards[cardId] then
        broadcastToAll(lang.card_unknown(cardId), "Red")
        return false
    end

    -- Check the player can afford it
    if not player_canAffordCard(player_color, cardId) then
        --alert the user
        bToColor(lang.cant_afford_card, player_color, "Red")

        --return the card to their hand
        card.deal(1, player_color)

        --unset the action_taken flag
        data[player_color].action_taken = false
        return false
    else
        removeResources(player_color, cards[cardId].cost)
    end

    -- Player played a valid card
    bToAll(lang.card_played(Player[player_color].steam_name, cards[cardId].name), player_color)

    -- Trigger the animation for the card
    triggerEffect(player_color, cards[cardId].name)

    -- Trigger the cards action
    local value  = cards[cardId].value or 0
    local bypass = cards[cardId].bypass or false
    local delay  = tonumber(cards[cardId].delay) or 0
    _G["card_"..cards[cardId].action](player_color, value, bypass, delay)

    -- Put the played card back in the deck
    card_addToDeck(card, data[player_color].deck_obj)

    -- Trigger the next player's turn, unless the sabotage card was played
    if cards[cardId].action ~= "sabotage" then
        Wait.time(turn_next, (delay + 1.5))
    end
end

function player_dealCards(player_color, count)
    --check we got a valid player_color
    if not player_color or player_color == "" then return false end

    local deck = data[player_color].deck_obj
    for i=1, count do
        Wait.time(function()
            deck.deal(1, player_color)
        end, i * data.deal_interval)
    end
    Wait.time(function()
        cards_updateScales(player_color)
    end, (count * data.deal_interval)+1)
end

function player_returnCardsToDeck(player_color)
    --check we got a valid player_color
    if not player_color or player_color == "" then return false end

    local deck = data[player_color].deck_obj
    local cards = data[player_color].handzone_obj.getObjects()
    for _,card in ipairs(cards) do
        card_addToDeck(card, deck)
    end
end


function player_checkCardsInHand(player_color)
    --[[
        Checks the player has the right amount of cards in their hand and deals replacements if any are missing
    --]]

    --check we got a valid player_color
    if not player_color or player_color == "" then return false end

    --check we actually have a player seated
    if not Player[player_color].seated then return false end

    --check the game is in progress
    if data.game_state ~= "active" then return false end

    --get the number of objects in hand and work out the difference
    local hand_objs = data[player_color].handzone_obj.getObjects()

    local missing = data.max_cards_in_hand - #hand_objs
    if missing > 0 then
        if data.debug then log("player_checkCardsInHand("..player_color.."): is missing "..missing.." cards") end
        player_dealCards(player_color, missing)
    elseif missing < 0 then
        if data.debug then log("player_checkCardsInHand("..player_color.."): has "..math.abs(missing).." extra cards!") end
    end
end