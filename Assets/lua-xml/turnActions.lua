--[[
    Turn actions
    Contains all the function related to turn actions and turn managements
]]


function turn_next()
    --[[
        Move turn to next player manually, emulates clicking "End Turn" button
        Triggers the stock TTS event onplayerTurn
        Triggered by player_playCard, which is triggered by the playzone, scripting buttons, and the context menu
    --]]
    Turns.turn_color = playerOpponent(Turns.turn_color)
end

function onPlayerTurn(player)
    --[[
        Stock TTS API Event
    --]]
    turn_start(player.color)
    turn_end(playerOpponent(player.color))
end


function turn_start(player_color)
    --[[
        Triggered by the stock TTS event onPlayerTurn at the start of each players turn
        Performs various actions:
            - increments resources
            - triggers scaling of cards in hand
            - triggers an update to the XML UI of both players
    --]]

    --increment turn count
    data.turn_count = data.turn_count + 1

    --increment resources after each player's first turen
    if data.turn_count > 2 then
        local inc = {
            bricks   = data[player_color].builders, 
            crystals = data[player_color].mages, 
            swords   = data[player_color].soldiers
        }

        -- is there a productions buff enabled?
        if data[player_color].all_produce then
            log("Buff active: "..tostring(data[player_color].all_produce))
            local total_production = inc.bricks + inc.crystals + inc.swords

            -- buff all doubles everything
            if data[player_color].all_produce == "all" then
                inc.bricks   = inc.bricks * 2
                inc.crystals = inc.crystals * 2
                inc.swords   = inc.swords * 2
            else --other buffs put all production toward something
                inc.bricks   = 0
                inc.crystals = 0
                inc.swords   = 0

                if data[player_color].all_produce == "bricks" then
                    inc.bricks = total_production
                elseif data[player_color].all_produce == "crystals" then
                    inc.crystals = total_production
                elseif data[player_color].all_produce == "swords" then
                    inc.swords = total_production
                end                
                --its also possible that all_produce is "none", in which case they all stay at 0
            end

            data[player_color].all_produce = false
        end

        -- increment resources by the determined amounts
        data[player_color].bricks   = data[player_color].bricks + inc.bricks
        data[player_color].crystals = data[player_color].crystals + inc.crystals
        data[player_color].swords   = data[player_color].swords + inc.swords
    end

    --update card scales
    cards_updateScales(player_color)

    --update the xml
    xml_update(player_color)
    xml_update(playerOpponent(player_color))
end

function turn_end(player_color)
    --[[
        Triggered by the stock TTS event onPlayerTurn at the start of each players turn

        Checks the last player has no outstanding actions to be processed
        If so it's because they discarded cards, or manually ended their turn
        Deals replacement cards for the previous player if they have insufficient cards
    --]]

    --reset discard count and action_taken flag
    data[player_color].action_taken = false
    data[player_color].discards = 0

    --check the player has the right amount of cards in their hand
    local hand_objs = Player[player_color].getHandObjects()
    if #hand_objs < data.max_cards_in_hand then
        player_dealCards(player_color, data.max_cards_in_hand - #hand_objs)
    end
end