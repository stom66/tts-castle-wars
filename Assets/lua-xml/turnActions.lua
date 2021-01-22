--[[
    Turn actions
    Contains all the function related to turn actions and turn managements
]]


function turn_next()
    --[[
        Move turn to next player manually, emulates clicking "End Turn" button
        Triggers the stock TTS event onplayerTurn

        Triggered by:
            - player_playCard
                - a card entering the playzone
                - scripting buttons
                - card context menu action
    --]]

    --abort if the game isn't in progress
    if data.game_state ~= "active" then return false end

    --manually advance to the next players turn
    Turns.turn_color = playerOpponent(Turns.turn_color)
end

function onPlayerTurn(player)
    --[[
        Stock TTS API Event

        Triggerd by either:
            - the player clicking "End Turn"
            - the above function turn_next()
    --]]

    --stop the next_turn from triggering if there's not a valid players turn being taken
    if not player.color or player.color == "" then
        if data.debug then log("onPlayerTurn(player): player was nil or blank") end

        print("A player unlocked their deck! Aborting.")
        game_stop()
        return false
    end

    --abort if the game isn't in progress
    if data.game_state ~= "active" then return false end

    -- Trigger the "turn_start" for the current player
    turn_start(player.color)

    -- Trigger "turn end" for the previous player if appropriate
    if data.turn_count > 1 then
        turn_end(playerOpponent(player.color))
    end
end


function turn_start(player_color)
    --[[
        Triggered by the stock TTS event onPlayerTurn at the start of each players turn
        Performs various actions:
            - increments resources
            - triggers scaling of cards in hand
            - triggers an update to the XML UI of both players
    --]]

    --abort if the game isn't in progress
    if data.game_state ~= "active" then return false end

    --increment turn count
    data.turn_count = data.turn_count + 1
    if data.debug then log("turn_start("..player_color.."): turn "..data.turn_count.." has started") end

    --increment resources, but only after each player's first turen
    if data.turn_count > 2 then
        local inc = {
            bricks   = data[player_color].builders,
            crystals = data[player_color].mages,
            swords   = data[player_color].soldiers
        }

        -- is there a productions buff enabled?
        if data[player_color].all_produce then

            local total_production = inc.bricks + inc.crystals + inc.swords

            if data[player_color].all_produce == "all" then
                -- buff "all" doubles everything
                inc.bricks   = inc.bricks * 2
                inc.crystals = inc.crystals * 2
                inc.swords   = inc.swords * 2
            else
                --other buffs put all production toward something or "none"
                --set buffs to 0, pre-empting buff "none"
                inc.bricks, inc.crystals, inc.swords = 0, 0, 0

                --check if the buff exists as a key in the table of increments
                --if it does, set that key to be equal to the total_production
                if inc[data[player_color].all_produce] then
                    inc[data[player_color].all_produce] = total_production
                end
            end

            --de-activate the buff for future turns, except the "none" buff which is disabled on turn_end to 
            --prevent the roadblock animation being de-activated immediately
            if data[player_color].all_produce ~= "none" then
                data[player_color].all_produce = false
            end
        end

        -- increment resources by the determined amounts
        addResources(player_color, {
            inc.bricks,
            inc.crystals,
            inc.swords
        })

    end

    --update card scales
    cards_updateScales(player_color)

    --update the xml
    xml_update(player_color)
end

function turn_end(player_color)
    --[[
        Triggered by the stock TTS event onPlayerTurn at the start of each players turn

        Checks the last player has no outstanding actions to be processed
        If so it's because they discarded cards, or manually ended their turn
        Deals replacement cards for the previous player if they have insufficient cards
    --]]

    --abort if the game isn't in progress
    if data.game_state ~= "active" then return false end

    --if the previous player discarded cards then broadcast that
    if data[player_color].discards > 0 then
        bToAll(lang.player_discarded_cards(player_color, data[player_color].discards), player_color)
    end

    --reset discard count and action_taken flag
    data[player_color].action_taken = false
    data[player_color].discards = 0

    --if the player has a buff "none", eg roadblock is in action, trigger the removal of the roadblock animation and clear their buff
    if data[player_color].all_produce == "none" then
        triggerEffect(playerOpponent(player_color), "roadblock_off")
        data[player_color].all_produce = false
    end

    --update the xml
    xml_update(player_color)

    -- Needs a delay to allow the played card enough time to return to the deck
    -- Otherwise causes conflicts and cards to not re-enter the deck properly
    Wait.time(function()
        player_checkCardsInHand(player_color)
    end, 1.5)
end