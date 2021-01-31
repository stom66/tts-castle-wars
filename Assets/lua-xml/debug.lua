function checkForDebug()
    --[[
        Simple function to enable debug and logging when a dev is hosting the game
    --]]

    for _,player in ipairs(Player.getPlayers()) do
        local sid = tonumber(player.steam_id)

        --loop thorugh seated players, comparing Steam IDs, looking for either of the devs
        if player.host and (sid == 76561198007319873 or sid == 76561198445295410) then

            --enable debug mode
            data.debug = true

            --set some logging styles
            setLogStyles()

            --alert the players that debug is enabled
            bToAll("Dev detected. Debug enabled.", "Green")
            return
        end
    end
end

function setLogStyles()
    --table of logging styles
    local styles = {
        --tag, tint, prefix, postfix
        {"error", "Orange"},
        {"info",  "Teal"},
        {"red",   "Red"},
        {"blue",  "Blue"},
    }
    for _,v in ipairs(styles) do
        logStyle(v[1], v[2], v[3], v[4])
    end

    log("setLogStyles(): enabled", nil, "info")
end

