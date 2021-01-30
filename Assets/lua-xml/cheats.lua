cheats = {
    addBricks = function(player, amount)
        addResources(player.color, {amount or 10, 0, 0})
    end,
    addCrystals = function(player, amount)
        addResources(player.color, {0, amount or 10, 0})
    end,
    addSwords = function(player, amount)
        addResources(player.color, {0, 0, amount or 10})
    end,
    addWall = function(player, amount)
        card_buildWall(player.color, amount or 10)
    end,
    addCastle = function(player, amount)
        card_buildCastle(player.color, amount or 10)
    end,
    delWall = function(player, amount)
        card_attack(player.color, amount or 10)
    end,
    delCastle = function(player, amount)
        card_attack(player.color, amount or 10, true)
    end,
    maxHealth = function(player, amount)
        data[player.color].wall = 99
        data[player.color].castle = 99
        updateBuildingHeights(player.color)
        xml_update(player.color)
    end,
    minHealth = function(player, amount)
        data[player.color].wall = 1
        data[player.color].castle = 1
        updateBuildingHeights(player.color)
        xml_update(player.color)
    end,
    showWinner = function(player)
        xml_showWinner(player)
    end,
    showLoser = function(player)
        xml_showLoser(player)
    end
}

function onChat(message, player)
    if not player_isValid(player.color) and not player.admin then return end
    if message:sub(1, 1) == "!" then
        local params = message:split()
        local command = params[1]:gsub("!", "")

        if cheats[command] then
            cheats[command](player, params[2])
        end
    end
end
