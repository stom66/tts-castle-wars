--[[
    Xml UI Management
--]]

function xml_updateCastleHeight(player, value, id)
    data.Blue.castle = tonumber(value)
    log("Updating castle to height "..value)
    updateCastleHeight("Blue")
end
function xml_updateWallHeight(player, value, id)
    data.Blue.wall = tonumber(value)
    log("Updating wall to height "..value)
    updateWallHeight("Blue")
end




function xml_update(player_color)
    local prefix = player_color:lower()
    log("Updating XML for player "..prefix)

    --decalre a table of stats to read and change
    local stats = {
        "builders", "bricks",
        "soldiers", "swords",
        "mages",    "crystals",
        "wall",     "castle",
    }

    --Get ther current values of the stats so we can compare the new values and look for changes
    local values = {}
    for _,v in ipairs(stats) do
        values[v] = tonumber(UI.getAttribute(prefix.."_"..v, "text"))
    end
    log("XML values:")
    log(values)

    --Update basic stats
    for _,v in ipairs(stats) do
        UI.setAttribute(prefix.."_"..v, "text", tostring(data[player_color][v]))
    end

    --Update buff icons
    local buffs = {"attack", "build", "defence", "resources"}
    for _,buff in ipairs(buffs) do
        UI.setAttribute(prefix.."_buff_"..buff, "color", xml_buffToColor(data[player_color]["buff_"..buff]))
    end

    --Update resource Icons (all_produce)
    local resources = {"bricks", "crystals", "swords"}
    for _,resource in ipairs(resources) do
        UI.setAttribute(prefix.."_icon_"..resource, "color", xml_resToColor(data[player_color].all_produce, resource))
    end

    --Check for differences in values and show value in the change column
    for _,v in ipairs(stats) do
        if v~=values[v] then
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
            end, 2)
        else
        
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