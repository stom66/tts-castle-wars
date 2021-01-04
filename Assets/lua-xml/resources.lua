
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
    local position = data[player_color].castle_obj.getPosition()
    if data[player_color].castle < 1 then
        position.y = -1
    else
        position.y = data.castle_min_height + (data[player_color].castle * data.castle_increment)
    end
    data[player_color].castle_obj.setPositionSmooth(position)

end