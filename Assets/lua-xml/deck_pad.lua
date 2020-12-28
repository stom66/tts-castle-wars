function onLoad()
    deckLock = false
    deckObj  = false
    player   = "blue"
    if self.getGUID()~="blu007" then player = "red" end

    drawButtons()
end


function lockDeck(t)
    if deckLock then return false end
    log("Deck locked")
    deckLock = true
    deckObj = t.obj
    drawButtons()
end

function unlockDeck()
    if not deckLock then return false end
    log("Deck unlocked")
    deckLock = false
    if deckObj then
        deckObj.setLock(false)
        deckObj.interactable = true
    end
    drawButtons()
end

function drawButtons()
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



function checkDeck(obj, player_color)
    local foundDeck = false
    local size    = self.getBounds().size
          size.y  = 4
    local objs    = Physics.cast({
        origin    = self.getPosition() + vector(0, size.y/2, 0),
        type      = 3,
        size      = size,
        direction = {0, 1, 0},
        debug     = true
    })

    for k,obj in ipairs(objs) do
        if obj.hit_object.tag=="Deck" then
            Global.call("checkDeck", {player = player, obj = obj.hit_object})
            log("Passed deck "..obj.hit_object.getGUID().." to Global checkDeck()")
            foundDeck = true
            break
        end
    end
    if not foundDeck then 
        broadcastToColor("You must place a deck in the zone to check", player_color, "Red")
    end
end