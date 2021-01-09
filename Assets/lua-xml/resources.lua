
--[[
    Resource Management

    Functions for managing resources as well as setting building heights
--]]

function addResources(player_color, resources)
    data[player_color].bricks   = math.max(0, data[player_color].bricks + resources[1])
    data[player_color].crystals = math.max(0, data[player_color].crystals + resources[2])
    data[player_color].swords   = math.max(0, data[player_color].swords + resources[3])
end

function removeResources(player_color, resources)
    data[player_color].bricks   = math.max(0, data[player_color].bricks - resources[1])
    data[player_color].crystals = math.max(0, data[player_color].crystals - resources[2])
    data[player_color].swords   = math.max(0, data[player_color].swords - resources[3])
    data[player_color].wall     = math.max(0, data[player_color].wall - (resources[4] or 0))
end


function updateBuildingHeights(player_color, delay, skip_animation)
    updateWallHeight(player_color, delay, skip_animation)
    updateCastleHeight(player_color, delay, skip_animation)
end

function updateWallHeight(player_color, delay, skip_animation)
    --[[
        Updates the wall's position based on the current size
        TODO: Also triggers the wall animation (particle effects)
    --]]
    local wall_increment  = 0.15
    local wall_min_height = 5
    local wall_position   = data[player_color].wall_obj.getPosition()
    local gate_position   = data[player_color].gate_obj.getPosition()
          delay           = tonumber(delay) or 0

    --store the old height for checking changes
    local old_y_pos = math.round(wall_position.y, 2)

    --if no wall then hide it, otherwise move it to height + min_height
    if data[player_color].wall < 1 then
        wall_position:setAt("y", -1)
        gate_position:setAt("y", -1)
        scaleEffects(playerOpponent(player_color), 1.5)
    else
        wall_position:setAt("y", wall_min_height + (data[player_color].wall * wall_increment))
        gate_position:setAt("y", 4)
        scaleEffects(playerOpponent(player_color), 1)
    end


    --move the wall and gate to the new heights, after delay if provided
    Wait.time(function()
        --compare the old height to new height and play the right animation
        if not skip_animation then
            local new_y_pos = math.round(wall_position.y, 2)
            if new_y_pos > old_y_pos then
                --going up
                data[player_color].effects_wall_obj.AssetBundle.playTriggerEffect(1)
            elseif new_y_pos < old_y_pos then
                --going down
                data[player_color].effects_wall_obj.AssetBundle.playTriggerEffect(0)
            end
        end
        Wait.time(function()
            --set the position of the base and tower after 1 second, to allow 
            --first part of above animation to play
            data[player_color].wall_obj.setPositionSmooth(wall_position)
            data[player_color].gate_obj.setPositionSmooth(gate_position)
        end, 1)
    end, delay or 0)
end

function updateCastleHeight(player_color, delay, skip_animation)
    --local reference to castle height
    local height = data[player_color].castle
          delay  = tonumber(delay) or 0

    --check for win/loss criteria
    if height >= 100 or height < 1 then
        game_end()
    end

    --define table of possible heights for the base & tower
    local base_steps  = {0, 10.5, 15, 17}
    local tower_steps = {6.75, 7.5, 10, 10}
    local tower_inc   = 0.25
    local tower_max   = 64

    --height at which to move between the above height steps
    local step_interval = 10

    --work out which min-height to use from the tables
    local index = math.ceil((height+1)/step_interval)
          index = math.range(index, 1, #base_steps)

    --get the current base and tower position
    local base_position = data[player_color].castle_base_obj.getPosition()
    local tower_position = data[player_color].castle_tower_obj.getPosition()

    --store the old height for checking changes
    local old_y_pos = math.round(tower_position.y, 2)

    --work out new base and tower positions
    base_position:setAt("y", base_steps[index])
    tower_position:setAt("y", math.min(tower_steps[index] + (height*tower_inc), tower_max))

    --move the base and tower to the new heights, after delay if provided
    Wait.time(function()
        --work out the new height for checking changes
        local new_y_pos = math.round(tower_position.y, 2)

        --compare the old height to new height and play the right animation
        if not skip_animation then
            log("Castle height old/new: "..old_y_pos.." / "..new_y_pos)
            if new_y_pos > old_y_pos then  --going up
                data[player_color].effects_castle_obj.AssetBundle.playTriggerEffect(1)
            elseif new_y_pos < old_y_pos then  --going down
                data[player_color].effects_castle_obj.AssetBundle.playTriggerEffect(0)
            end
        end

        Wait.time(function()
            --set the position of the base and tower after 1 second, to allow 
            --first part of above animation to play
            data[player_color].castle_base_obj.setPositionSmooth(base_position)
            data[player_color].castle_tower_obj.setPositionSmooth(tower_position)
        end, 1)
    end, delay)
end