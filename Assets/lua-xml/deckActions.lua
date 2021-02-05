--[[
    Deck management

 --]]


function deck_lockDeck(player_color, obj)
    --[[
        Called when the deck has passed the checkDeck function
        Sets deck_locked to true and updates the deck_obj ref
    --]]

    if data.debug then
        log("deck_lockDeck("..player_color..", "..obj.getGUID()..")", nil, player_color)
    end

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
    local deck_pad = data[player_color].deckzone_obj

    obj.setRotation(deck_pad.getRotation():add(Vector(180, 180, 0)))
    obj.setPositionSmooth(deck_pad.getPosition():add(Vector(0, obj.getBounds().size.y / 2, 0)))
end

function deck_unlockDeck(obj, player_color, alt_click)
    --[[
        Called by either Global OR by a player clicking the onboard button
        Sets deckLock to true and updates the deckObj ref to whatever global said it should be
        Calls global either way to make sure the otehr game important stuff happens
    --]]

    --declare obj_guid for use in debug statment
    local obj_guid = "NO_GUID"

    --determine who owns the deckpad that was clicked
    if obj then
        player_color = obj_getOwner(obj)
        obj_guid = obj.getGUID()
    end

    --if the game is in progress then stop it
    if data.game_state == "active" and not alt_click then
        bToColor(lang.cant_unlock_during_round, player_color, "Orange")
        return
    elseif data.game_state == "active" and alt_click then
        game_stop()
        if data.debug then
            log("deck_unlockDeck("..obj_guid..", "..player_color.."): Player "..player_color.." deck was unlocked. Triggering game_stop()", nil, player_color)
        end
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

        if data.debug then
            log("deck_unlockDeck("..obj_guid..", "..player_color..") unlocked", nil, player_color)
        end
    else
        if data.debug then
            log("deck_unlockDeck("..obj_guid..", "..player_color..") couldn't unlock, no deck_obj", nil, "error")
        end
        print("Can't unlock deck for owner "..player_color..", no deck_obj registered")
    end
end


function deck_spawnDeck(i, player_color, card_count)
    --[[
        Spawns a new deck for the player by first cloning the stock deck hidden under the table
        Then we cycle through that cloned deck and remove the cards needed to match the requested deck
    --]]

    if data.debug then
        log("deck_spawnDeck("..i..", "..player_color..")", nil, player_color)
    end

    --make a local table of the card quantities we want to end up with
    local cardCounts = {}
    if i > 0 then
        --if we specified an index/id then copy the quantities from the prefab decks
        for k,v in pairs(decks.cards) do
            cardCounts[k] = v[i]
        end
    else
        --otherwise if index = 0 then use the supplied card_count, or bug out
        if not card_count then return false end
        cardCounts = card_count
        if data.debug then log(card_count) end
    end

    --make a local table of cardIDs with the number to be removed from the stock deck
    local toRemove = {}
    for cardID,v in pairs(cardCounts) do
        toRemove[cardID] = 5 - v
    end

    --get reference to the stock deck
    local stock_deck = getObjectFromGUID("deck01")

    --work out intended position and rotation of the clone deck
    local deck_position, deck_rotation

    --check if we're spawning for one of the seated players, or by white/black
    if player_isValid(player_color) then
        --get a reference to the deckpad obj
        local obj = data[player_color].deckzone_obj

        deck_position = obj.getPosition():add(obj.getTransformUp() * 15)
        if not data.debug then
            deck_position:add(obj.getTransformRight() * -4)
        end
        deck_rotation    = obj.getRotation():add(Vector(0, 0, 180))
    else
        deck_position = Vector(0, 4, 32)
        deck_rotation = Vector(0, 0, 180)
    end

    --spawn a copy of the full deck
    local deck             = stock_deck.clone({
        position           = deck_position,
        rotation           = deck_rotation,
        snap_to_grid       = false,
    })

    --unlock the cloned deck
    deck.setLock(false)

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

    --check total card in deck meets min_cards_in_deck
    if #cards < data.min_cards_in_deck then
        --too many cards in the deck, alert and abort
        bToColor(lang.deck_too_small, player_color, "Red")

        if data.debug then
            log("deck_checkDeck("..#cards..", "..player_color.."): failed, too few cards", nil, player_color)
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