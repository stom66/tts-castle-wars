--[[
    Contains the function triggered by card context menus, eg:
        trigger_playCard
        trigger_discardCard
--]]

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