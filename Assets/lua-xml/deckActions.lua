--[[
    Deck management

 --]]


function deck_lockDeck(player_color, obj)
    --[[
        Called when the deck has passed the checkDeck function
        Sets deck_locked to true and updates the deck_obj ref
    --]]

    if data.debug then log("deck_lockDeck("..player_color..", "..obj.getGUID()..")", nil, "info") end

    --ignore if the deck is already locked
    if data[player_color].deck_locked then return false end

    --lock in the deck
    data[player_color].deck_locked           = true
    data[player_color].deck_obj              = obj
    data[player_color].deck_obj.interactable = false
    data[player_color].deck_obj.setLock(true)

    --update the deckpad buttons
    deckpad_drawButtons(player_color)

    --move the deck to the center of the pad
    local deck_pad = data[player_color].deck_pad_obj

    obj.setRotation(deck_pad.getRotation():add(Vector(180, 180, 0)))
    obj.setPositionSmooth(deck_pad.getPosition():add(Vector(0, obj.getBounds().size.y / 2, 0)))
end

function deck_unlockDeck(obj, player_color, alt_click)
    --[[
        Called by either Global OR by a player clicking the onboard button
        Sets deckLock to true and updates the deckObj ref to whatever global said it should be
        Calls global either way to make sure the otehr game important stuff happens
    --]]

    --determine who owns the deckpad that was clicked
    if obj then
        player_color = obj_getOwner(obj)
    end

    --check the deck was locked. if not, abort. shouldn't happen but eh, what do i know?
    if not data[player_color].deck_locked then return false end

    if data.game_state == "active" then
        if data.debug then log("deck_unlockDeck(): Player "..player_color.." unlocked their deck. Triggering game_stop()", nil, "info") end
        game_stop()
    end

    --return any cards in the players hand to their deck
    player_returnCardsToDeck(player_color)

    --mark the deck as invalid
    data[player_color].deck_valid = false

    --if there's a registered deck obj then unlock it and make it interactable
    if data[player_color].deck_obj then
        data[player_color].deck_locked = false
        data[player_color].deck_obj.setLock(false)
        data[player_color].deck_obj.interactable = true
        deckpad_drawButtons(player_color)

        if data.debug then log("deck_unlockDeck("..obj.getGUID()..", "..player_color..") unlocked", nil, "info") end
    else
        if data.debug then log("deck_unlockDeck("..obj.getGUID()..", "..player_color..") couldn't unlock, no deck_obj", nil, "error") end
        print("Can't unlock deck for owner "..player_color..", no deck_obj registered")
    end
end


function deck_spawnDeck(i, player_color)
    --[[
        Spawns a new deck for th eplayer by first cloning the stock deck hidden under the table
        Then we cycle through that cloned deck and remove the cards needed to match the requested deck
    --]]

    if data.debug then
        log("deck_spawnDeck("..decks.names[i]..", "..player_color..")", nil, player_color)
    end

    --get a reference to the deckpad obj
    local obj = data[player_color].deck_pad_obj

    --get reference to the stock deck
    local stock_deck       = getObjectFromGUID("deck01")

    --work out position and rotation of the clone deck
    local deck_position    = obj.getPosition():add(obj.getTransformUp() * 15)
    if not debug then
        deck_position:add(obj.getTransformRight() * -4)
    end
    local deck_rotation    = obj.getRotation():add(Vector(180, 180, 0))

    --spawn a copy of the full deck
    local deck             = stock_deck.clone({
        position           = deck_position,
        rotation           = deck_rotation,
        snap_to_grid       = false,
    })

    --unlock the cloned deck
    deck.setLock(false)

    --make a new table of cardIDs with the number to be removed
    local toRemove = {}
    for k,v in pairs(decks.cards) do
        toRemove[k] = 5 - v[i]
    end

    --remove the cards above from the new deck
    for _,v in ipairs(deck.getData().ContainedObjects) do
        if toRemove[v.CardID] and toRemove[v.CardID] > 0 then
            toRemove[v.CardID] = toRemove[v.CardID] - 1
            deck.takeObject({
                position          = {0, 5, 0},
                smooth            = false,
                guid              = v.GUID,
                callback_function = function(obj)
                    obj.destruct()
                end,
            })
        end
    end
end


function deck_checkDeck(obj, player_color)
    --[[
         checks if the specified object is a valid deck or not
         called by the deckpad_findDeck
            - checks not > max numbers of cards
            - checks not > max_cards_in_deck
            - checks not > max_card_duplicates
        a valid deck results in the round countdown being triggered
    --]]

    --get table of cards in the decks
    local cards = obj.getData().ContainedObjects

    --check total card in deck doesn't exceed max_cards_in_deck
    if #cards > data.max_cards_in_deck then
        --too many cards in the deck, alert and abort
        bToColor(lang.deck_too_large, player_color, "Red")

        if data.debug then
            log("deck_checkDeck("..#cards..", "..player_color.."): failed, too many cards", nil, player_color)
        end
        return false
    end

    --check counts of individual cards does not exceed max_card_duplicates
    local cardCount = {}
    local id
    for _,v in ipairs(cards) do
        id = v.CardID
        if cardCount[id] then
            --if we have an existing count for this id then increment it by one
            cardCount[id] = cardCount[id] + 1

            --check we don't have too many of this card
            if cardCount[id] > data.max_card_duplicates then
                --too many duplicates of one card, alert the user and abort
                bToColor(lang.too_many_duplicate_cards(card_getName(id)), player_color, "Red")

                if data.debug then
                    log("deck_checkDeck("..#cards..", "..player_color.."): failed, too many duplicated of Card ID: "..id.." "..card_getName(id), nil, player_color)
                end

                return false
            end
        else
            --we don't have a count yet for this card ID, so intitialise one
            cardCount[id] = 1
        end
    end
    if data.debug then
        log("deck_checkDeck("..#cards..", "..player_color.."): valid", nil, player_color)
    end

    --if we reach this point it's a valid deck
    data[player_color].deck_valid = true

    --alert the user, or print to chat
    bToColor(lang.deck_valid, player_color, "Green")

    --call "lockDeck" on their deck_pad
    deck_lockDeck(player_color, obj)

    --start the round countdown
    game_countdown()
end