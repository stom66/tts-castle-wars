
--[[
    Zone controls
--]]

function onObjectEnterScriptingZone(zone, obj)
    --get the zone owner
    local zone_guid = zone.getGUID()
    local owner = zone_getOwner(zone.guid)

    --ignore zones that don't belong to anyone (can't really happen unless someone messes with a zone, but ok)
    if not owner then return false end

    --ignore anything that isn't a card
    if obj and obj.tag=="Card" then
        zoneWaits[zone_guid] = Wait.condition(
            function() 
                if zone_containsObject(obj, zone) then
                    player_playCard(obj, owner)
                end
            end,
            function() return obj.resting end)
    end
end

function onObjectLeaveScriptingZone(zone, obj)
    local zone_guid = zone.getGUID()
    if zoneWaits[zone_guid] then 
        if data.debug then log("Cancelling current wait") end
        Wait.stop(zoneWaits[zone_guid])
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

function handzone_containsObject(obj, player)
    --checks if an object is present in a zone
    local zoneContents = Player[player].getHandObjects()
    if #zoneContents < 1 then return false end
    for _,zobj in ipairs(zoneContents) do
        if zobj==obj then return true end
    end
    return false
end