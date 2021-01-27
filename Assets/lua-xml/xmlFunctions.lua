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

function xml_update(player_color)
    --[[
        Called at the start of every turn for both players
        Loops through each of the player's stats shown in the XML panels and updates their values
        Any values that have changed trigger the difference to be shown
    --]]

    if data.debug then
        log("xml_update("..player_color..")", nil, player_color)
    end

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
    tablet_showPage("wiki")
end
function btn_info_tutorial(player, value, id)
    tablet_showPage("tutorial")
end
function btn_info_workshop(player, value, id)
    tablet_showPage("workshop")
end



--[[
    Show/hide controls for the various panels
--]]

function xml_showInfo(player, value, id) xml_showElement("info", player.color) end
function xml_hideInfo(player, value, id) xml_hideElement("info", player.color) end

function xml_showWin(player, value, id) xml_showElement("win", player.color) end
function xml_hideWin(player, value, id) xml_hideElement("win", player.color) end

function xml_showLose(player, value, id) xml_showElement("lose", player.color) end
function xml_hideLose(player, value, id) xml_hideElement("lose", player.color) end


function xml_hideElement(id, player_color)
    if data.debug then
        log("xml_hideElement("..id..", "..player_color..")")
    end

    local contains = table.contains(data.xml_visibility[id], player_color)
    if contains then
        data.xml_visibility[id][contains] = nil
    end
    xml_updateVisibility(id, player_color)
end

function xml_showElement(id, player_color)
    if data.debug then
        log("xml_showElement("..id..", "..player_color..")")
    end

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