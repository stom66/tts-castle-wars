
--[[
    Game controls

    Starting, stopping, and end function
--]]

function game_stop()
    broadcastToAll(lang.game_stopped, "Yellow")
    game_end()
end

function game_end()

    --update game state
    data.game_state = "ended"
    Turns.enable    = false

    --work out who won and lost
    local winner, loser
    if data.Blue.castle >= 100 or data.Red.castle < 1 then
        winner, loser = "Blue", "Red"
    elseif data.Red.castle >= 100 or data.Blue.castle < 1 then
        winner, loser = "Red", "Blue"
    end

    --send messages
    if winner and loser then
        --second alert to players
        bToColor(lang.game_won, winner, "Green")
        bToColor(lang.game_lost, winner, "Red")

        --trigger the animations
        triggerEffect(winner, "won")
        triggerEffect(loser, "lost")
    end

    --return all cards in hand to decks and unlock decks
    player_returnCardsToDeck("Red")
    player_returnCardsToDeck("Blue")

    --Trigger unlockDeck
    Wait.time(function()
        deck_unlockDeck(nil, "Blue")
        deck_unlockDeck(nil, "Red")
    end, 2)
end


function game_countdown()
    --[[
        Start the countdown that will end with the game beginning.
        Relies on both users having a valid deck locked in.
    ]]

    if data.Red.deck_valid and data.Blue.deck_valid then

        --update the game state
        data.game_state = "countdown"

        --reset the player data
        data.Blue = table.merge(data.Blue, player_defaultStats())
        data.Red  = table.merge(data.Red, player_defaultStats())

        --Shuffle both players decks cards to players
        data.Blue.deck_obj.randomize()
        data.Red.deck_obj.randomize()

        --print the various remaining time messages
        for i=1,data.delay_before_start do
            Wait.time(function()
                if data.Red.deck_valid and data.Blue.deck_valid then
                    broadcastToAll(lang.game_starts_in(i), "Orange")
                else
                    broadcastToAll(lang.game_start_cancelled, "Yellow")
                end
            end, data.delay_before_start-i)
        end

        --print the start of game message and trigger the first round
        Wait.time(function()
            if data.Red.deck_valid and data.Blue.deck_valid then
                broadcastToAll(lang.game_started, "Green")
                game_start()
            else
                broadcastToAll(lang.game_start_cancelled, "Yellow")
            end
        end, data.delay_before_start)
    end
end

function game_start()

    --update the game state
    data.game_state = "active"

    --set the basic game stats
    data.turn_count = 0

    --Setup the player turns
    Turns.type  = 2
    Turns.order = {
        "Blue", "Red"
    }
    Turns.enable = true

    --for both Blue and Red:
    for _,player_color in ipairs(Turns.order) do
        --Set the buildings to the right heights
        updateBuildingHeights(player_color, 0, true)

        --Deal cards 
        player_checkCardsInHand(player_color)

        --Update the player's XML
        xml_update(player_color)
    end
end

