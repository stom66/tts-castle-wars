function checkForDebug()
    --[[ 
        Simple function to enable debug and logging when a dev is hosting the game 
    --]]
    for _,color in ipairs(getSeatedPlayers()) do
        local player = Player[color]
        if (tonumber(player.steam_id) == 76561198007319873 and player.host) or --stom
           (tonumber(player.steam_id) == 76561198445295410 and player.host) then --searanger
            data.debug = true
            broadcastToAll("Dev detected. Debug enabled.", "Green")
            return
        end
    end
end