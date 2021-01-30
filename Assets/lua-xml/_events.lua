--[[
    Contains all the stock TTS events that are watched by the game
 --]]


--[[
    Add scripting key shortcuts
--]]
function onScriptingButtonDown(index, player_color)
    if player_isValid(player_color) then
        if index == 1 then
            trigger_playCard(player_color)
        elseif index == 10 then
            trigger_discardCard(player_color)
        end
    end
end

--[[
    Check if player is entering a command in chat
--]]

function onChat(message, player)
    if not player_isValid(player.color) and not player.admin then return end
    if message:sub(1, 1) == "!" then
        doCheat(message, player)
    end
end




--[[
    Add suitable context menu items to Cards when they are spawned.
--]]
function onObjectSpawn(obj)
    obj_addContextMenuItems(obj)
end


--[[
    Alert players if they have chosen a wrong color
    Also updates names shown in the XML UI
--]]
function onPlayerChangeColor(player_color)
    --update the names shown in the XML UI
    xml_updateNames()

    --check if player has chosen an invalid color
    if (not Player["Blue"].seated or not Player["Red"].seated) and not player_isValid(player_color) then
        --ignore grey
        if player_color:lower() == "grey" then return end

        --message player to let them know to choose a seat
        bToColor(lang.invalid_player_color, player_color, "Red")
    end
end