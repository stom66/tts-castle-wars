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
        if Player[player_color].seated then
            broadcastToColor("You must have a valid locked deck to play a card", player_color, "Red")
        else
            print(player_color..": You must have a valid locked deck to play a card")
        end
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
        if Player[player_color].seated then
            broadcastToColor(lang.cant_play_multiple_cards, player_color)
        else
            print(player_color..": "..lang.cant_play_multiple_cards)
        end
        return false
    end

    --reject non-card objects
    if objs[1].tag~="Card" then
        if Player[player_color].seated then
            broadcastToColor(lang.cant_play_non_card, player_color)
        else
            print(player_color..": "..lang.cant_play_non_card)
        end
        return false
    end

    --ensure the player owns the card
    if not handzone_containsObject(objs[1], player_color) then
        if Player[player_color].seated then
            broadcastToColor(lang.card_not_in_hand, player_color)
        else
            print(player_color..": "..lang.card_not_in_hand)
        end
        return false
    end

    --if we made it this far then we have a single card in the player's hand-zone, so play it
    player_playCard(objs[1], player_color)
end


function trigger_discardCard(player_color)
    --check the player actually has a deck
    if not data[player_color].deck_obj then
        if Player[player_color].seated then
            broadcastToColor("You must have a valid locked deck to discard a card", player_color, "Red")
        else
            print(player_color..": You must have a valid locked deck to discard a card")
        end
        return false
    end

    if Turns.turn_color ~= player_color or data[player_color].action_taken then
        --not their turn, return card to their hand and warn them
        if Player[player_color].seated then
            broadcastToColor(lang.not_your_turn, player_color, "Orange")
        else
            print(player_color..": "..lang.not_your_turn)
        end
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
        if Player[player_color].seated then
            broadcastToColor(lang.max_discards_reached, player_color)
        else
            print(player_color..": "..lang.max_discards_reached)
        end
        return false
    end

    --loop through each of the objects and check it's suitable
    for _,card in ipairs(objs) do

        --reject non-card objects
        if card.tag~="Card" then
            if Player[player_color].seated then
                broadcastToColor(lang.cant_play_non_card, player_color)
            else
                print(player_color..": "..lang.cant_play_non_card)
            end
            return false
        end

        --ensure the player owns the card
        if not handzone_containsObject(card, player_color) then
            if Player[player_color].seated then
                broadcastToColor(lang.card_not_in_hand, player_color)
            else
                print(player_color..": "..lang.card_not_in_hand)
            end
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
        if Player[player_color].seated then
            broadcastToColor(lang.not_your_turn, player_color, "Orange")
        else
            print(player_color..": "..lang.not_your_turn)
        end
        return false
    else
        -- It is their turn, so set action_taken flag to true to prevent playing multiple cards at once
        data[player_color].action_taken = true
    end

    -- Check the player hasn't discarded cards this round
    if data[player_color].discards > 0 then
        if Player[player_color].seated then
            broadcastToColor(lang.cant_play_after_discard, player_color, "Red")
        else
            print(player_color..": "..lang.cant_play_after_discard)
        end
        data[player_color].action_taken = false
        return false
    end

    -- Get the CardID
    local cardId = card_getID(card)
    if not cards[cardId] then
        broadcastToAll("Unknown card played! ID "..cardId, "Red")
        return false
    end

    -- Check the player can afford it
    if not playerCanAffordCard(player_color, cardId) then
        --alert the user
        if Player[player_color].seated then
            broadcastToColor(lang.cant_afford_card, player_color, "Red")
        else
            print(player_color..": "..lang.cant_afford_card)
        end

        --return the card to their hand
        card.deal(1, player_color)

        --unset the action_taken flag
        data[player_color].action_taken = false
        return false
    else
        removeResources(player_color, cards[cardId].cost)
    end

    -- Player played a valid card
    if Player[player_color].seated then
        broadcastToAll(Player[player_color].steam_name.." played card "..cards[cardId].name, player_color)
    else
        print(player_color.." played card "..cards[cardId].name)
    end

    -- Trigger the cards action
    local value = cards[cardId].value or 0
    local bypass = cards[cardId].bypass or false
    _G["card_"..cards[cardId].action](player_color, value, bypass)

    -- Deal a new card from the deck
    --player_dealCards(player_color, 1) --covered by turn_end

    -- Put the played card back in the deck
    card_addToDeck(card, data[player_color].deck_obj)

    -- Trigger the next player's turn
    Wait.time(turn_next, 1.5)

end

function player_dealCards(player_color, count)
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
    local deck = data[player_color].deck_obj
    for _,card in ipairs(Player[player_color].getHandObjects()) do
        card_addToDeck(card, deck)
    end
end