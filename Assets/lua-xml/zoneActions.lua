
--[[
    Zone controls
--]]

function onObjectEnterScriptingZone(zone, obj)
    --get the zone owner
    local wait_id = zone.getGUID()..obj.getGUID()
    local owner   = zone_getOwner(zone.guid)

    --ignore zones that don't belong to anyone (can't really happen unless someone messes with a zone, but ok)
    if not owner then return false end

    --ignore anything that isn't a card
    if obj and obj.tag=="Card" then
        zoneWaits[wait_id] = Wait.condition(
            function() 
                player_playCard(obj, owner)
            end,
            function() 
                return (obj.resting and not obj.held_by_color)
            end)
    end
end

function onObjectLeaveScriptingZone(zone, obj)
    local wait_id = zone.getGUID()..obj.getGUID()

    if zoneWaits[wait_id] then 
        if data.debug then log("Cancelling current wait") end
        Wait.stop(zoneWaits[wait_id])
    end
end

function zone_getOwner(zone_guid)
    if zone_guid == data.Blue.zone_obj.getGUID() then
        return "Blue"
    elseif zone_guid == data.Red.zone_obj.getGUID() then
        return "Red"
    else return false end
end

function zone_containsObject(obj, zone)
    --checks if an object is present in a zone
    local zoneContents = zone.getObjects()
    if #zoneContents < 1 then return false end
    for _,zobj in ipairs(zoneContents) do
        if zobj==obj then return true end
    end
    return false
end

function handzone_containsObject(obj, player_color)
    --checks if an object is present in a zone
    local zoneContents = data[player_color].handzone_obj.getObjects()
    if #zoneContents < 1 then return false end
    for _,zobj in ipairs(zoneContents) do
        if zobj==obj then return true end
    end
    return false
end