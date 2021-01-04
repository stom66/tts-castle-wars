--[[
    Xml UI Management
--]]


function xml_update(player_color)
    local prefix = player_color:lower()
    log("Updating XML for player "..prefix)
    
    --Basic stats
    UI.setAttribute(prefix.."_builders", "text", tostring(data[player_color].builders))
    UI.setAttribute(prefix.."_bricks",   "text", tostring(data[player_color].bricks))
    UI.setAttribute(prefix.."_soldiers", "text", tostring(data[player_color].soldiers))
    UI.setAttribute(prefix.."_swords",   "text", tostring(data[player_color].swords))
    UI.setAttribute(prefix.."_mages",    "text", tostring(data[player_color].mages))
    UI.setAttribute(prefix.."_crystals", "text", tostring(data[player_color].crystals))
    UI.setAttribute(prefix.."_wall",     "text", tostring(data[player_color].wall))
    UI.setAttribute(prefix.."_castle",   "text", tostring(data[player_color].castle))

    --Buff icons
    local buffs = {"attack", "build", "defence", "resources"}
    for _,buff in ipairs(buffs) do
        UI.setAttribute(prefix.."_buff_"..buff, "color", xml_buffToColor(data[player_color]["buff_"..buff]))
    end

    --Resource Icons (all_produce)
    local resources = {"bricks", "crystals", "swords"}
    for _,resource in ipairs(resources) do
        UI.setAttribute(prefix.."_icon_"..resource, "color", xml_resToColor(data[player_color].all_produce, resource))
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
    else
        return ("#ffffff")
    end
end