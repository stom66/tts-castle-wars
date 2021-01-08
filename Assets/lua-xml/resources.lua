
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


function updateBuildingHeights(player_color)
    updateWallHeight(player_color)
    updateCastleHeight(player_color)
end

function updateWallHeight(player_color)
    --[[
        Updates the wall's position based on the current size
        TODO: Also triggers the wall animation (particle effects)
    --]]
    local wall_increment  = 0.15
    local wall_min_height = 5
    local wall_position   = data[player_color].wall_obj.getPosition()
    local gate_position   = data[player_color].gate_obj.getPosition()

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

    --move the wall and gate to the new heights
    data[player_color].wall_obj.setPositionSmooth(wall_position)
    data[player_color].gate_obj.setPositionSmooth(gate_position)


    --now compare the old height to new height and play the right animation
    local new_y_pos = math.round(wall_position.y, 2)
    log("old: new = "..old_y_pos..": "..new_y_pos)
    if new_y_pos > old_y_pos then
        --going up
        data[player_color].effects_wall_obj.AssetBundle.playTriggerEffect(1)
    elseif new_y_pos < old_y_pos then
        --going down
        data[player_color].effects_wall_obj.AssetBundle.playTriggerEffect(0)
    end
end

function updateCastleHeight(player_color)
    if data[player_color].castle >= 100 or data[player_color].castle < 1 then
        game_end()
        return false
    end

    local height = data[player_color].castle

    --table of possible heights for the base & tower
    local base_steps = {0, 10.5, 15, 17}
    local tower_steps = {6.75, 7.5, 10, 9}

    --height at which to move between height steps
    local step_interval = 10

    --work out which height to use from the table
    local index = math.min(math.ceil((height+1)/step_interval), #base_steps)
          index = math.min(index, #base_steps)
          index = math.max(index, 1)

    --work out new base position and move to it
    local base_position = data[player_color].castle_base_obj.getPosition()
    base_position:setAt("y", base_steps[index])
    data[player_color].castle_base_obj.setPositionSmooth(base_position)

    --work out height for the tower
    local tower_inc    = 0.25
    local tower_max    = 64
    local tower_height = tower_steps[index] + (height*tower_inc)

    --work out target position
    local tower_position = data[player_color].castle_tower_obj.getPosition()
    tower_position.y     = math.min(tower_height, tower_max)

    --move tower to right height
    data[player_color].castle_tower_obj.setPositionSmooth(tower_position)

end