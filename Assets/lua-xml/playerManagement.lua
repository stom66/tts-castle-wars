--[[
    Player management functions
--]]

function onPlayerChangeColor(player_color)
    --check if player has chosen an invalid color
    if not player_isValid(player_color) then
        --ignore grey
        if player_color:lower() == "grey" then return end

        --message player to let them know to choose a seat
        bToColor(lang.invalid_player_color, player_color, "Red")
    end
end