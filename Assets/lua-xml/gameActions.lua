
--[[
    Game controls

    Starting, stopping, and end function
--]]

function game_stop()
    if data.debug then log("game_stop()", nil, info) end
    broadcastToAll(lang.game_stopped, "Yellow")
    game_end()
end

function game_end()
    if data.debug then log("game_end()") end

    --define blank vars for winner and loser, assigned in for players loop
    local winner, loser

    --update game state
    data.game_state = "ended"
    Turns.enable    = false

    --loop through players performing various end-game actions
    for _,player in ipairs(players) do

        --work out who won and lost
        if data[player].castle >= 100 or data[playerOpponent(player)].castle < 1 then
            --this player won!
            bToColor(lang.game_won, player, "Green")
            triggerEffect(player, "win")
        else
            --this player lost :(
            bToColor(lang.game_lost, player, "Red")
            triggerEffect(player, "lose")
        end

        --update their XML ui
        xml_update(player)

        --return all cards in hand to decks and unlock decks
        player_returnCardsToDeck(player)

        --Trigger unlockDeck
        Wait.time(function()
            deck_unlockDeck(nil, player)
        end, 2)
    end
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

