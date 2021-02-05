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

    --setup a New Deck button
    local btn = {
        function_owner = Global,
        click_function = "deckpad_toggleXmlDeckBuilder",
        label          = "New Deck",
        position       = {0.55, 0.075, 1.775},
        width          = 780,
        height         = 220,
        font_size      = 150,
        color          = {0.3, 0.3, 0.3},
        font_color     = {0.75, 0.75, 0.75},
        alignment      = 2,
    }

    --Create the new deck button
    obj.createButton(btn)

    --Next create the Lock/Unlock button, depending on current state
    btn.width          = 520
    btn.position[1]    = -0.775

    if data[player_color].deck_locked then
        btn.font_color, btn.color = btn.color, btn.font_color
        btn.label          = "Unlock"
        btn.click_function = "deck_unlockDeck"
    else
        btn.label          = "Lock"
        btn.click_function = "deckpad_findDeck"
    end

    --create the Lock/Unlock button
    obj.createButton(btn)
end

function deckpad_toggleXmlDeckBuilder(obj, player_color, alt_click)
    --[[
        Triggerd by the Lua buttons on the deckpad_obj
        Toggles the XML Deck Builder
    --]]
    local pc = player_color:lower()
    xml_toggleElement(pc.."_deckBuilder", pc)
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
    if clickee ~= owner and not data.debug then
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