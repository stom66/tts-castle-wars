--[[
    Xml UI Management
--]]

function xml_updateCastleHeight(player, value, id)
    --[[
        DEV FEATURE
        Only used when the XML slider inputs are enabled to allow manually changing the castle height
    --]]
    data.Blue.castle = tonumber(value)
    updateCastleHeight("Blue")

    if data.debug then
        log("Updating castle to height "..value, "xml_updateCastleHeight", "info")
    end
end

function xml_updateWallHeight(player, value, id)
    --[[
        DEV FEATURE
        Only used when the XML slider inputs are enabled to allow manually changing the wall height
    --]]
    data.Blue.wall = tonumber(value)
    updateWallHeight("Blue")

    if data.debug then
        log("Updating wall to height "..value, "xml_updateWallHeight", "info")
    end
end

function xml_updateNames()
    --[[
        Updates the player names shown in the player panels
    --]]
    local name_blue, name_red = "Player Blue", "Player Red"
    if Player["Blue"].seated then
        name_blue = Player["Blue"].steam_name
    end
    if Player["Red"].seated then
        name_red = Player["Red"].steam_name
    end

    UI.setAttribute("ui1_blue_playerName", "text", name_blue)
    UI.setAttribute("ui2_blue_playerName", "text", name_blue)
    UI.setAttribute("ui1_red_playerName", "text", name_red)
    UI.setAttribute("ui2_red_playerName", "text", name_red)

    if data.debug then
        log("Updating XML Player Names to: "..name_blue.." and "..name_red)
    end
end

function xml_update(player_color)
    --[[
        Called at the start of every turn for both players
        Loops through each of the player's stats shown in the XML panels and updates their values
        Any values that have changed trigger the difference to be shown
    --]]

    if data.debug then
        log("xml_update("..player_color..")", nil, player_color)
    end

    --update player names, just in case
    xml_updateNames()

    --work out element id prefix
    local prefix = player_color:lower()

    --define list of stats to change
    local stats = {
        "builders", "bricks",
        "soldiers", "swords",
        "mages",    "crystals",
        "wall",     "castle",
    }

    --blank table to store current stat values in, used for checking if differences need to be shown
    local values = {}

    --record current values of the stats so we can compare the new values and look for changes
    for _,v in ipairs(stats) do
        values[v] = tonumber(UI.getAttribute("ui1_"..prefix.."_"..v, "text"))
        values[v] = tonumber(UI.getAttribute("ui2_"..prefix.."_"..v, "text"))
    end

    --Update basic stats
    for _,v in ipairs(stats) do
        UI.setAttribute("ui1_"..prefix.."_"..v, "text", tostring(data[player_color][v]))
        UI.setAttribute("ui2_"..prefix.."_"..v, "text", tostring(data[player_color][v]))
    end

    --Update buff icons
    for buff,value in pairs(data[player_color].buff) do
        UI.setAttribute("ui1_"..prefix.."_buff_"..buff, "color", xml_buffToColor(value))
        UI.setAttribute("ui2_"..prefix.."_buff_"..buff, "color", xml_buffToColor(value))
    end

    --Update resource Icons (all_produce)
    local resources = {"bricks", "crystals", "swords"}
    for _,resource in ipairs(resources) do
        UI.setAttribute("ui1_"..prefix.."_icon_"..resource, "color", xml_resToColor(data[player_color].all_produce, resource))
        UI.setAttribute("ui2_"..prefix.."_icon_"..resource, "color", xml_resToColor(data[player_color].all_produce, resource))
    end

    --Check for differences in values and show value in the change column
    for _,v in ipairs(stats) do
        if data[player_color][v]~=values[v] then
            --A value has changed!
            local diff = data[player_color][v] - values[v]

            --build the string
            if diff > 0 then
                diff = "+"..diff
            end

            --update the element and trigger the show animation
            UI.setAttribute("ui1_"..prefix.."_"..v.."_change", "text", diff)
            UI.setAttribute("ui2_"..prefix.."_"..v.."_change", "text", diff)
            UI.show("ui1_"..prefix.."_"..v.."_change")
            UI.show("ui2_"..prefix.."_"..v.."_change")

            --hide the element after a few seconds delay
            Wait.time(function()
                UI.hide("ui1_"..prefix.."_"..v.."_change")
                UI.hide("ui2_"..prefix.."_"..v.."_change")
            end, 6)
        end
    end
end

function xml_buffToColor(active)
    if active then
        return ("#eeeeee")
    else
        return ("#333333")
    end
end

function xml_resToColor(all_produce, resource)
    if all_produce == resource or all_produce == "all" then
        return ("#e19a02")
    elseif all_produce == "none" then
        return ("#333333")
    else
        return ("#eeeeee")
    end
end

function btn_info_wiki(player, value, id)
    if not player_isValid(player.color) then return false end
    tablet_goToPage(player.color, "wiki")
end
function btn_info_tutorial(player, value, id)
    if not player_isValid(player.color) then return false end
    tablet_goToPage(player.color, "tutorial")
end
function btn_info_workshop(player, value, id)
    if not player_isValid(player.color) then return false end
    tablet_goToPage(player.color, "workshop")
end



--[[
    Show/hide controls for the various panels
--]]

function xml_toggleInfo(player, value, id) xml_toggleElement("info", player.color) end
function xml_showInfo(player, value, id) xml_showElement("info", player.color) end
function xml_hideInfo(player, value, id) xml_hideElement("info", player.color) end

function xml_showWinner(player, value, id) xml_showElement("winner", player.color) end
function xml_hideWinner(player, value, id) xml_hideElement("winner", player.color) end

function xml_showLoser(player, value, id) xml_showElement("loser", player.color) end
function xml_hideLoser(player, value, id) xml_hideElement("loser", player.color) end


function xml_toggleElement(id, player_color)
    player_color = player_color:lower()
    if table.contains(data.xml_visibility[id], player_color) then
        xml_hideElement(id, player_color)
    else
        xml_showElement(id, player_color)
    end
end

function xml_hideElement(id, player_color)
    if data.debug then
        log("xml_hideElement("..id..", "..player_color..")")
    end
    
    player_color = player_color:lower()

    local contains = table.contains(data.xml_visibility[id], player_color)
    if contains then
        table.remove(data.xml_visibility[id], contains)
    end
    xml_updateVisibility(id, player_color)
end

function xml_showElement(id, player_color)
    if data.debug then
        log("xml_showElement("..id..", "..player_color..")")
    end

    player_color = player_color:lower()
    if not table.contains(data.xml_visibility[id], player_color) then
        table.insert(data.xml_visibility[id], player_color)
    end
    xml_updateVisibility(id, player_color)
end

function xml_updateVisibility(id)
    local visible_to
    if #data.xml_visibility[id] > 0 then
        visible_to = table.concat(data.xml_visibility[id], "|")
        UI.setAttribute(id, "active", true)
        UI.setAttribute(id, "visibility", visible_to)
    else
        visible_to = "None"
        UI.setAttribute(id, "active", false)
    end

    if data.debug then
        log("xml_updateVisibility("..id.."): "..visible_to)
    end
end