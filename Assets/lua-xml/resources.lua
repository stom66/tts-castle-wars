
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
    local position = data[player_color].wall_obj.getPosition()
    if data[player_color].wall < 1 then
        position.y = -1
    else
        position.y = data.wall_min_height + (data[player_color].wall * data.wall_increment)
    end
    data[player_color].wall_obj.setPositionSmooth(position)
end

function updateCastleHeight(player_color)
    if data[player_color].castle >= 100 or data[player_color].castle < 1 then
        game_end()
        return false
    end
    
    local height = data[player_color].castle

    --work out height for the base
    
    --table of possible heights for the base
    local base_steps = {0, 10.5, 15, 17}
    
    --how often should the height of the base go up
    local base_step_interval = 10

    --work out which height to use from the table
    local index         = math.min(math.max(math.floor(height/base_step_interval), 0), #base_steps)

    --work out target position
    local base_position = data[player_color].castle_base_obj.getPosition()
    base_position.y     = base_steps[index]

    --move base to right height
    data[player_color].castle_base_obj.setPositionSmooth(base_position)


    --work out height for the tower
    local tower_min = 17.0
    local tower_max = 64
    local tower_inc = 0.1
    local tower_height = tower_min + (height*tower_inc)

    --work out target position
    local tower_position =  data[player_color].castle_tower_obj.getPosition()
    tower_position.y = math.min(tower_height, tower_max)

    --move tower to right height
    data[player_color].castle_tower_obj.setPositionSmooth(tower_position)

end