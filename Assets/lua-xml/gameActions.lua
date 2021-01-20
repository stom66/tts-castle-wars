
--[[
    Game controls

    Starting, stopping, and end function
--]]

function game_stop()
    Turns.enable    = false
    data.game_state = "stopped"
    broadcastToAll(lang.game_stopped, "Yellow")
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
    if Player[winner].seated then 
        broadcastToColor(lang.game_won, winner, "Green")
    else
        print(winner..": "..lang.game_won)
    end
    if Player[loser].seated then 
        broadcastToColor(lang.game_lost, loser, "Red")
    else
        print(loser..": "..lang.game_lost)
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
        --data.Blue = player_defaultData("Blue")
        --data.Red  = player_defaultData("Red")

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

    --Set the buildings to the right heights
    updateBuildingHeights("Blue", 0, true)
    updateBuildingHeights("Red", 0, true)

    --Deal cads after one second delay to allow shuffling
    player_dealCards("Blue", data.max_cards_in_hand)
    player_dealCards("Red", data.max_cards_in_hand)
end

