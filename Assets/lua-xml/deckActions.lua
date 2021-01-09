--[[
    Deck management

 --]]

 function unlockDeck(t)
    local player = t.owner
    data[player].valid_deck = false
    data[player].deck_obj.setLock(false)
    data[player].deck_obj.interactable = true

    if data.game_state == "active" then
        game_stop()
        player_returnCardsToDeck("Blue")
        player_returnCardsToDeck("Red")
    elseif data.game_state == "ended" then

    end
end


function checkDeck(obj, player_color)
    --[[
         checks if the specified object is a valid deck or not
         called by the two deck_pads belonging to each player
            - checks not > max numbers of cards
            - checks not > max_cards_in_deck
            - checks not > max_card_duplicates
        a valid deck results in the round coutndown being triggered
    --]]

    --if the first param is a table then this function was called by another object
    if type(obj)=="table" then 
        player_color = obj.player
        obj = obj.obj
    end

    --check the object is actually a deck
    if obj.tag~="Deck" then return false end
    
    --read and count cards in the deck
    local cards = obj.getData().ContainedObjects
    if #cards > data.max_cards_in_deck then
        if Player[player_color].seated then
            broadcastToColor(lang.deck_too_large, player_color, "Red")
        else
            print(lang.deck_too_large)
        end
        return false
    end

    --check counts of individual cards does not exceed max_card_duplicates
    local cardCount = {}
    local cardId
    for i,v in ipairs(cards) do
        cardId = v.CardID
        if cardCount[cardId] then
            cardCount[cardId] = cardCount[cardId] + 1
        else 
            cardCount[cardId] = 1
        end
        if cardCount[cardId] > data.max_card_duplicates then
            if Player[player_color].seated then
                broadcastToColor(lang.too_many_duplicate_cards(card_getName(cardId)), player_color, "Red")
            else
                print(lang.too_many_duplicate_cards(card_getName(cardId)))
            end
            return false
        end
    end

    --if we reach this point it's a valid deck
    data[player_color].valid_deck = true
    
    --lock in the deck
    data[player_color].deck_obj              = obj
    data[player_color].deck_obj.interactable = false
    data[player_color].deck_obj.setLock(true)
    
    --alert the user, or print to chat
    if Player[player_color].seated then
        broadcastToColor(lang.deck_valid, player_color, "Green")
    else
        print(player_color..": "..lang.deck_valid)
    end
    
    --call "lockDeck" on their deck_pad
    data[player_color].deck_pad_obj.call("lockDeck", {obj = obj})

    --start the round countdown
    game_countdown()
end