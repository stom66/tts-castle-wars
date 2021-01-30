
--[[
    Game controls

    Starting, stopping, and end function
--]]

function game_stop()
    if data.debug then
        log("game_stop()", nil, info)
    end
    data.game_state = "stopped"
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
        if data[player].castle >= 100 or data[player_opponent(player)].castle < 1 then
            --this player won!
            bToColor(lang.game_won, player, "Green")
            triggerEffect(player, "win")
        elseif data[player_opponent(player)].castle >= 100 or data[player].castle < 1 then
            --this player lost :(
            bToColor(lang.game_lost, player, "Red")
            triggerEffect(player, "lose")
        end

        --check if we need to de-activte either the shield or the roadblock
        if data[player].buff.defence then
            triggerEffect(player, "magic_defence_off")
        end
        if data[player].all_produce == "none" then
            triggerEffect(player_opponent(player), "roadblock_off")
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


        for _,player_color in ipairs(players) do

            --reset the player data
            data[player_color] = table.merge(data[player_color], player_defaultStats())

            --Shuffle both players decks cards to players
            data[player_color].deck_obj.randomize()
        end

        startLuaCoroutine(Global, "game_countdown_coroutine")
    end
end

function game_countdown_coroutine()
    local time_start = Time.time --time the countdown was started
    local time_end   = time_start + data.delay_before_start --time the countdown should end
    local time_last  = time_start - 1 --time elapsed since last message

    while Time.time < time_end do
        time_last = Time.time
        local time_remaining = math.floor(os.difftime(time_end, time_last-0.1))
        bToAll(lang.game_starts_in(time_remaining), "Orange")

        while Time.time < time_last + 1 do

            --check both decks are still valid
            if not data.Red.deck_valid or not data.Blue.deck_valid then
                bToAll(lang.game_start_cancelled, "Yellow")
                return 1
            end

            coroutine.yield(0)
        end

    end

    bToAll(lang.game_started, "Green")
    game_start()
    return 1
end

function game_start()

    --update the game state
    data.game_state = "active"

    --set the basic game stats
    data.turn_count = 0

    --Setup the player turns
    Turns.type   = 2
    Turns.order  = {"Blue", "Red"}
    Turns.enable = true

    --for both Blue and Red:
    for _,player_color in ipairs(players) do
        --Set the buildings to the right heights
        updateBuildingHeights(player_color, 0, true)

        --Deal cards
        player_checkCardsInHand(player_color)

        --Update the player's XML
        xml_update(player_color)
    end
end

