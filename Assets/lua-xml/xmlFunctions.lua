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

    if data.debug then log("Updating castle to height "..value) end
end

function xml_updateWallHeight(player, value, id)
    --[[
        DEV FEATURE
        Only used when the XML slider inputs are enabled to allow manually changing the wall height
    --]]
    data.Blue.wall = tonumber(value)
    updateWallHeight("Blue")

    if data.debug then log("Updating wall to height "..value) end
end

function xml_update(player_color)
    --[[
        Called at the start of every turn for both players
        Loops through each of the player's stats shown in the XML panels and updates their values
        Any values that have changed trigger the difference to be shown
    --]]

    if data.debug then log("xml_update("..player_color..")") end

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
        values[v] = tonumber(UI.getAttribute(prefix.."_"..v, "text"))
    end

    --Update basic stats
    for _,v in ipairs(stats) do
        UI.setAttribute(prefix.."_"..v, "text", tostring(data[player_color][v]))
    end

    --Update buff icons
    for buff,value in pairs(data[player_color].buff) do
        UI.setAttribute(prefix.."_buff_"..buff, "color", xml_buffToColor(value))
    end

    --Update resource Icons (all_produce)
    local resources = {"bricks", "crystals", "swords"}
    for _,resource in ipairs(resources) do
        UI.setAttribute(prefix.."_icon_"..resource, "color", xml_resToColor(data[player_color].all_produce, resource))
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
            UI.setAttribute(prefix.."_"..v.."_change", "text", diff)
            UI.show(prefix.."_"..v.."_change")

            --hide the element after a few seconds delay
            Wait.time(function()
                UI.hide(prefix.."_"..v.."_change")
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
        return ("#ffffff")
    end
end