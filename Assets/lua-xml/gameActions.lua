
--[[
    Game controls

    Starting, stopping, and end function
--]]

function game_stop()
    Turns.enable = false
    data.game_state = "stopped"
    broadcastToAll(lang.game_stopped, "Yellow")
end

function game_end()
    local winner, loser
    if data.Blue.castle >= 100 or data.Red.castle < 1 then
        winner, loser = "Blue", "Red"
    elseif data.Red.castle >= 100 or data.Blue.castle < 1 then
        winner, loser = "Red", "Blue"
    end

    broadcastToColor(lang.game_won, winner, "Green")
    broadcastToColor(lang.game_lost, loser, "red")
end


function game_countdown()
    --[[
        Start the countdown that will end with the game beginning. 
        Relies on both users having a valid deck locked in.
    ]]

    if data.Red.valid_deck and data.Blue.valid_deck then

        --print the various remaining time messages
        for i=1,data.delay_before_start do
            Wait.time(function()
                if data.Red.valid_deck and data.Blue.valid_deck then
                    broadcastToAll(lang.game_starts_in(i), "Orange")
                else
                    broadcastToAll(lang.game_start_cancelled, "Yellow")
                end
            end, data.delay_before_start-i)
        end

        --print the start of game message and trigger the first round
        Wait.time(function()
            if data.Red.valid_deck and data.Blue.valid_deck then
                broadcastToAll(lang.game_started, "Green")
                game_start()
            else
                broadcastToAll(lang.game_start_cancelled, "Yellow")
            end
        end, data.delay_before_start)
    end
end

function game_start()

    --Setup the player turns
    Turns.type   = 2
    Turns.order  = {
        "Blue", "Red"
    }
    Turns.enable = true

    --update the game state
    data.game_state = "active"

    --Set the buildings to the right heights
    updateBuildingHeights("Blue")
    updateBuildingHeights("Red")

    --Shuffle both players decks cards to players
    data.Blue.deck_obj.randomize()
    data.Red.deck_obj.randomize()

    --Deal cads after one second delay to allow shuffling
    player_dealCards("Blue", data.max_cards_in_hand)
    player_dealCards("Red", data.max_cards_in_hand)
end

