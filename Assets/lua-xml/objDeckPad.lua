function onLoad()
    --[[
        This script doesn't do much except draw some buttons and call the checkDeck function in Global
    --]]
    cards        = Global.getTable("cards")
    deckLock     = false
    deckObj      = false
    decks        = getDeckData()
    owner        = "Blue"
    showDeckMenu = false

    if self.getGUID()~="blu007" then owner = "Red" end
    drawButtons()

    --for testing only, automatically lock the deck 1 second after loading the game
    Wait.time(function()
        spawnNewDeck(1, owner)
    end, 1)
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
        origin    = self.getPosition():add(Vector(0, size.y/2, 0)),
        type      = 3,
        size      = size,
        direction = {0, 1, 0}
    })

    --check cast objects for first Deck found and pass it to global
    for k,obj in ipairs(objs) do
        if obj.hit_object.tag=="Deck" then
            Global.call("checkDeck", {player = owner, obj = obj.hit_object})
            log("Passed deck "..obj.hit_object.getGUID().." to Global checkDeck()")
            foundDeck = true
            break
        end
    end

    --warn user if no deck found
    if not foundDeck and clickee then
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

    --move the deck to the center of the pad
    local target_pos = self.getPosition():add(Vector(0, deckObj.getBounds().size.y / 2, 0))
    deckObj.setRotation(self.getRotation():add(Vector(180, 180, 0)))
    deckObj.setPositionSmooth(target_pos)
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
            owner = owner
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
        position       = {-0.775, 0.05, 1.8},
        width          = 520,
        height         = 220,
        font_size      = 150,
        color          = {0.3, 0.3, 0.3},
        font_color     = {0.75, 0.75, 0.75},
    }
    if deckLock then
        btn.font_color, btn.color = btn.color, btn.font_color
        btn.label          = "Unlock"
        btn.click_function = "unlockDeck"
    end
    self.createButton(btn)

    btn.label          = "New Deck"
    btn.width          = 780
    btn.position[1]    = 0.55
    btn.click_function = "newDeckMenu"
    if deckLock then
        btn.font_color, btn.color = btn.color, btn.font_color
    end
    self.createButton(btn)


    if showDeckMenu then
        btn.position[1] = 2.5
        for i,v in ipairs(decks.names) do
            btn.position[3]    = 2.3 - (i*0.5)
            btn.click_function = "newDeck_"..i
            btn.label          = v
            self.createButton(btn)

            _G["newDeck_"..i] = function(obj, player_color, id)
                showDeckMenu = false
                drawButtons()
                spawnNewDeck(i, player_color)
            end
        end
    end
end

function newDeckMenu()
    showDeckMenu = not showDeckMenu
    drawButtons()
end

function spawnNewDeck(i, player_color)
    print("Spawning new deck "..decks.names[i].." for player "..player_color)

    --spawn a copy of the full deck
    local stock_deck       = getObjectFromGUID("deck01")
    local deck_position    = self.getPosition():add(self.getTransformRight() * -4):add(self.getTransformUp() * 10)
    local deck_rotation    = self.getRotation():add(Vector(180, 180, 0))
    local deck             = stock_deck.clone({
        position           = deck_position,
        rotation           = deck_rotation,
        snap_to_grid       = false,
    })
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

function table.count(t)
    local c = 0
    for _,_ in pairs(t) do c = c + 1 end
    return c
end



require("CastleWars/Assets/lua-xml/deckData")