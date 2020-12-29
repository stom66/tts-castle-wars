function onLoad()
    --[[
        This script doesn't do much except draw some buttons and call the checkDeck function in Global
    --]]
    deckLock = false
    deckObj  = false
    owner    = "blue"
    if self.getGUID()~="blu007" then owner = "red" end
    drawButtons()
end

function checkDeck(obj, clickee)
    --[[
        Main function. Called whenever a user clicks the onboard "Lock" button. 
        Checks for a deck object sitting on its face (heh) and calls the checkDeck function in Global
        to see if it's a legit deck. If it passes, Global will trigger the lockDeck function on this object.
    --]]

    --simple flag
    local foundDeck = false

    --set cast params
    local size    = self.getBounds().size
          size.y  = 4
    local objs    = Physics.cast({
        origin    = self.getPosition() + vector(0, size.y/2, 0),
        type      = 3,
        size      = size,
        direction = {0, 1, 0}
    })

    --check cast objects for first Deck found and pass it to global
    for k,obj in ipairs(objs) do
        if obj.hit_object.tag=="Deck" then
            Global.call("checkDeck", {owner = owner, obj = obj.hit_object})
            log("Passed deck "..obj.hit_object.getGUID().." to Global checkDeck()")
            foundDeck = true
            break
        end
    end

    --warn user if no deck found
    if not foundDeck then 
        broadcastToColor("You must place a deck in the zone to check", clickee, "Red")
    end
end

function lockDeck(t)
    --[[
        Called by Global when the deck has passed the checkDeck function
        Sets deckLock to true and updates the deckObj ref to whatever global said it should be
    --]]

    if deckLock then return false end
    log("Deck locked")
    deckLock = true
    deckObj = t.obj
    drawButtons()
end

function unlockDeck()
    --[[
        Called by either Global OR by a player clicking the onboard button
        Sets deckLock to true and updates the deckObj ref to whatever global said it should be
        Calls global either way to make sure the otehr game important stuff happens
    --]]
    if not deckLock then return false end
    if deckObj then
        Global.call("unlockDeck", {
            owner = owner:lower()
        })
        deckLock = false
        drawButtons()
    else
        print("Can't unlock deck for owner "..owner..", no deckObj registered")
    end
end

function drawButtons()
    --[[
        Draws the two buttons for Locking and unLocking.
    --]]
    self.clearButtons()
    local btn = {
        function_owner = self,
        click_function = "checkDeck",
        label          = "Lock",
        position       = {-0.7, 0.05, 1.8},
        width          = 520,
        height         = 220,
        font_size      = 160,
        color          = {0.3, 0.3, 0.3},
        font_color     = {1, 1, 1},
    }
    if not deckLock then
        btn.font_color, btn.color = btn.color, btn.font_color
    end
    self.createButton(btn)
    
    btn.label          = "Unlock"
    btn.click_function = "unlockDeck"
    btn.width          = 640
    btn.position[1]    = 0.6
    btn.font_color, btn.color = btn.color, btn.font_color
    self.createButton(btn)
end