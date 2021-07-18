--[[
    This file contains the various player actions, eg actions the player can perform directly

    This includes
    - Playing Cards
    - Discarding Cards

    It also includes some hand management functions, such as dealing fresh cards to the player

]]


function player_discardCard(card, player_color)
    --check the player actually has a deck
    if not data[player_color].deck_obj then
        bToColor(lang.deck_not_locked2, player_color, "Red")
    end

    --check it's the players turn, otherwise return card to their hand and warn them
    if Turns.turn_color ~= player_color or data[player_color].action_taken then
        --check if the card needs to be returned to their hand
        if not handzone_containsObject(card, player_color) then
            card.deal(1, player_color)
        end
        bToColor(lang.not_your_turn, player_color)
        return false
    end

    --reject non-card objects
    if card.tag~="Card" and card.tag~="Deck" then
        bToColor(lang.cant_play_non_card, player_color, "Red")
        return false
    end

    if card.tag == "Card" then
        --check we're below the round limit for discarding cards
        if data[player_color].discards < data.max_discard_per_turn then
            data[player_color].discards = data[player_color].discards + 1
            card_addToDeck(card, data[player_color].deck_obj)
        end
    elseif card.tag == "Deck" then
        local deck_count = #card.getObjects()
        --check we're below the round limit for discarding cards
        if data[player_color].discards < data.max_discard_per_turn and
           data[player_color].discards + deck_count <= data.max_discard_per_turn then
            data[player_color].discards = data[player_color].discards + deck_count
            card_addToDeck(card, data[player_color].deck_obj)
        else
            --discarding these cards would put them voer the limit, do return them to their hand
            if deck_count <= data.max_discard_per_turn then
                bToColor(lang.already_discarded_cards(data[player_color].discards), player_color)
            end

            bToColor(lang.max_discards_reached, player_color)
            card.deal(deck_count, player_color)
            return
        end
    end

    --check if we've reached the max number of discards, if so then we can trigger the next turn
    if data[player_color].discards >= data.max_discard_per_turn then
        turn_next()
    else
        local count = data.max_discard_per_turn - data[player_color].discards
        bToColor(lang.may_discard_x_more(count), player_color)
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
        --check if the card needs to be returned to their hand
        if not handzone_containsObject(card, player_color) then
            card.deal(1, player_color)
        end

        --alert the user that they can't play a card after discarding and
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
    bToAll("Turn "..(data.turn_count)..": "..lang.card_played(Player[player_color].steam_name, cards[cardId].name), player_color)

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
        Wait.time(function()
            if Turns.turn_color == player_color then
                turn_next()
            end
        end, (delay + 1.5))
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
    local cards = player_getCardsInHand(player_color)
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
    local cards = player_getCardsInHand(player_color)

    local missing = data.max_cards_in_hand - #cards
    if missing > 0 then
        if data.debug then
            log("player_checkCardsInHand("..player_color.."): is missing "..missing.." cards", nil, player_color)
        end
        player_dealCards(player_color, missing)
    elseif missing < 0 then
        if data.debug then
            log("player_checkCardsInHand("..player_color.."): has "..math.abs(missing).." extra cards!", nil, player_color)
        end
    end
end

function player_getCardsInHand(player_color)
    --[[
        returns a table of card objects in the players current hand zone
    --]]
    local results = {}
    local objs = data[player_color].handzone_zone.getObjects()
    for _,obj in ipairs(objs) do
        if obj.tag == "Card" then
            table.insert(results, obj)
        end
    end
    return results
end