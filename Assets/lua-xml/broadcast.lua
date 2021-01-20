--[[
    Wrapper functions for the built-in broadcast tools with fall back in case a player isn't seated
--]]

function bToAll(message, text_color)
    --[[
        Broadcasts to all player, defaulting to the color Orange
   -- ]]
    text_color = text_color or "Orange"
    broadcastToAll(message, text_color)
end

function bToColor(message, player_color, text_color)
    --[[
        Broadcasts to a sepcific player. If they are not seated the message is instead printed to chat with 
        the player's prefix player, defaulting to the color Orange
    --]]

    text_color = text_color or "Orange"

    if Player[player_color].seated then
        broadcastToColor(message, player_color, text_color)
    else
        bToAll(player_color..": "..message, text_color)
    end
end