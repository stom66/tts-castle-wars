--[[
    This file contains the various player actions, eg fucntion for performing actions the player can perform directly

    This includes
    - Card context menu actions

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
        broadcastToColor("You must have a valid locked deck to discard a card", player_color, "Red")
        return false
    end

    --get the objects they have selected
    local objs = Player[player_color].getSelectedObjects()

    --reject multiple cards
    if #objs > 1 or #objs < 1 then  
        broadcastToColor(lang.cant_play_multiple_cards, player_color)
        return false
    end

    --reject non-card objects
    if objs[1].tag~="Card" then
        broadcastToColor(lang.cant_play_non_card, player_color)
        return false
    end

    --ensure the player owns the card 
    if not handzone_containsObject(objs[1], player_color) then
        broadcastToColor(lang.card_not_in_hand, player_color)
        return false
    end

    --if we made it this far then we have a single card in the player's hand-zone, so play it
    player_playCard(objs[1], player_color)
end

function trigger_discardCard(player_color, objs)
    --check the player actually has a deck    
    if not data[player_color].deck_obj then
        broadcastToColor("You must have a valid locked deck to discard a card", player_color, "Red")
        return false
    end
    
    if Turns.turn_color != player_color or data[player_color].action_taken then
        --not their turn, return card to thei hand and warn them
        broadcastToColor(lang.not_your_turn, player_color, "Orange")
        return false
    end

    --check we're not going to exceed the max number of discards per turn
    if #objs > data.max_discard_per_turn
    or (data[player_color].discards + #objs) > data.max_discard_per_turn then
        broadcastToColor(lang.max_discards_reached, player_color)
        return false
    end
    
    --loop through each of the objects and check it's suitable
    for _,card in ipairs(objs) do
        
        --reject non-card objects
        if card.tag~="Card" then
            broadcastToColor(lang.cant_play_non_card, player_color)
            return false
        end

        --ensure the player owns the card 
        if not handzone_containsObject(card, player_color) then
            broadcastToColor(lang.card_not_in_hand, player_color)
            return false
        end

        --check it's a card and we're below the round limit for discarding cards
        if data[player_color].discards < data.max_discard_per_turn then
            data[player_color].discards = data[player_color].discards + 1
            card_addToDeck(card, data[player_color].deck_obj)
        end
    end
    
    --shuffle the deck
    Wait.time(function()
        data[player_color].deck_obj.randomize()
    end, 1.5)
end



function player_playCard(card, player_color)
    --[[
        Triggerd by a player dropping a card into their scriptingzone play areas
        or by them right clicking on a card and choosing "Play Card"
    --]]
    
    log("Checkin player turn")
    -- Check it's the player's turn
    if Turns.turn_color != player_color or data[player_color].action_taken then
        --not their turn, return card to thei hand and warn them
        card.deal(1, player_color)
        broadcastToColor(lang.not_your_turn, player_color, "Orange")
        return false
    else
        -- It is their turn, so set action_taken flag to true to prevent playing multiple cards at once
        data[player_color].action_taken = true
    end

    -- Check the player hasn't discarded cards this round
    if data[player_color].discards > 0 then
        broadcastToColor(lang.cant_play_after_discard, player_color, "Red")
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
        broadcastToColor(lang.cant_afford_card, player_color, "Red")
        
        --return the card to their hand
        card.deal(1, player_color)

        --unset the action_taken flag
        data[player_color].action_taken = false
        return false
    else
        removeResources(player_color, cards[cardId].cost)
    end

    -- Player played a valid card
    broadcastToAll(Player[player_color].steam_name.." played card "..cards[cardId].name, player_color)

    -- Trigger the cards action
    local value = cards[cardId].value or 0
    local bypass = cards[cardId].bypass or false
    _G["card_"..cards[cardId].action](player_color, value, bypass)

    -- Deal a new card from the deck
    local deck = data[player_color].deck_obj
    deck.deal(1, player_color)
    
    -- Put the played card back in the deck
    card_addToDeck(card, deck)

    -- Trigger the next player's turn
    Wait.frames(triggerNextTurn, 10)
    
    Wait.time(function()
        scaleCardsInHand(player_color)
        data[player_color].deck_obj.randomize()
    end, 1.5)

end