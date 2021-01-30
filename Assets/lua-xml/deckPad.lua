--[[
    Contains all functions used to manage the player's deck pad
--]]


function deckpad_drawButtons(player_color)
    --[[
        Draws the two buttons for Locking and unLocking.
    --]]

    --get a reference to the deckpad obj
    local obj = data[player_color].deckzone_obj

    --remove the existing buttons
    obj.clearButtons()

    --setup a default button
    local btn = {
        function_owner = Global,
        click_function = "deckpad_findDeck",
        label          = "Lock",
        position       = {-0.775, 0.075, 1.775},
        width          = 520,
        height         = 220,
        font_size      = 150,
        color          = {0.3, 0.3, 0.3},
        font_color     = {0.75, 0.75, 0.75},
        alignment      = 2,
    }

    --flip the font and button colours if the deck is locked
    if data[player_color].deck_locked then
        btn.font_color, btn.color = btn.color, btn.font_color
        btn.label          = "Unlock"
        btn.click_function = "deck_unlockDeck"
    end

    --create the Lock/Unlock button
    obj.createButton(btn)

    --setup the "New Deck" button
    btn.label          = "New Deck"
    btn.width          = 780
    btn.position[1]    = 0.55
    btn.click_function = "deckpad_newDeckMenu"
    if data[player_color].deck_locked then
        btn.font_color, btn.color = btn.color, btn.font_color
    end
    obj.createButton(btn)

    --create the buttons for spawning the various decks
    if data[player_color].show_deck_menu then
        btn.position[1] = 2.75
        btn.width       = 900
        for i,v in ipairs(decks.names) do
            btn.position[3]    = 2.3 - (i*0.5)
            btn.click_function = "deck_spawnDeck_"..player_color..i
            btn.label          = v
            obj.createButton(btn)

            _G["deck_spawnDeck_"..player_color..i] = function(obj, clickee, id)
                data[player_color].show_deck_menu = false
                deckpad_drawButtons(player_color)
                deck_spawnDeck(i, player_color)
            end
        end
    end
end

function deckpad_newDeckMenu(obj, player_color, alt_click)
    -- Toggles the "New Deck" menu which shows the decks possible to spawn
    local owner = obj_getOwner(obj)
    data[owner].show_deck_menu = not data[owner].show_deck_menu
    deckpad_drawButtons(owner)
end


function deckpad_findDeck(obj, clickee)
    --[[
        Called whenever a user clicks the onboard "Lock" button.
        Checks for a deck object sitting on its face (heh) and calls the checkDeck function
        to see if it's a legit deck. If it passes, Global will trigger the lockDeck function on this object.
    --]]

    --work out the deck pads owner
    local owner = obj_getOwner(obj)
    if data.debug then
        log("deckpad_findDeck("..obj.getGUID()..", "..clickee..")", nil, owner)
    end

    --check if the action was performed by the right user, or if we're in debug
    if clickee ~= owner and not debug then
        broadcastToColor(lang.deck_not_yours(owner), clickee, "Red")
        return false
    end

    --simple flag
    local foundDeck = false

    --set cast params
    local size    = obj.getBounds().size
          size.y  = 4

    local objs    = Physics.cast({
        origin    = obj.getPosition():add(Vector(0, size.y/2, 0)),
        type      = 3,
        size      = size,
        direction = {0, 10, 0},
        debug     = data.debug
    })

    --check cast objects for first Deck found and pass it to global
    for _,o in ipairs(objs) do
        if o.hit_object.tag=="Deck" then
            deck_checkDeck(o.hit_object, owner)
            foundDeck = true
            break
        end
    end

    --warn user if no deck found
    if not foundDeck and clickee then
        broadcastToColor(lang.deck_not_in_zone, clickee, "Red")
    end

end