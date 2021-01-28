cheats = {
    addBricks = function(player, amount)
        addResources(player, {amount or 10, 0, 0})
    end,
    addCrystals = function(player, amount)
        addResources(player, {0, amount or 10, 0})
    end,
    addSwords = function(player, amount)
        addResources(player, {0, 0, amount or 10})
    end,
    addWall = function(player, amount)
        card_buildWall(player, amount or 10)
    end,
    addCastle = function(player, amount)
        card_buildCastle(player, amount or 10)
    end,
    delWall = function(player, amount)
        card_attack(player, amount or 10)
    end,
    delCastle = function(player, amount)
        card_attack(player, amount or 10, true)
    end,
    maxHealth = function(player, amount)
        data[player].wall = 99
        data[player].castle = 99
        updateBuildingHeights(player)
        xml_update(player)
    end,
    minHealth = function(player, amount)
        data[player].wall = 1
        data[player].castle = 1
        updateBuildingHeights(player)
        xml_update(player)
    end
}

function onChat(message, player)
    if not player_isValid(player.color) then return false end
    if message:sub(1, 1) == "!" then
        local params = message:split()
        local command = params[1]:gsub("!", "")

        if cheats[command] then
            cheats[command](player.color, params[2])
        end
    end
end
