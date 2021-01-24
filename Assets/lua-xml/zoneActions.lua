
--[[
    Zone controls
--]]

function onObjectEnterScriptingZone(zone, obj)
    --get the zone owner
    local wait_id = zone.getGUID()..obj.getGUID()
    local owner   = obj_getOwner(zone)

    --ignore zones that don't belong to anyone (can't really happen unless someone messes with a zone, but ok)
    if not owner then return false end

    --ignore anything that isn't a card
    if obj and obj.tag=="Card" then
        if zone==data[owner].playzone_zone then
            zoneWaits[wait_id] = Wait.condition(
                function()
                    player_playCard(obj, owner)
                end,
                function()
                    return (obj.resting and not obj.held_by_color)
                end
            )
        elseif zone==data[owner].discardzone_zone then
            zoneWaits[wait_id] = Wait.condition(
                function()
                    player_discardCard(obj, owner)
                end,
                function()
                    return (obj.resting and not obj.held_by_color)
                end
            )
        end
    end
end

function onObjectLeaveScriptingZone(zone, obj)
    --[[
        Triggered when an object leaves a scripting zone
        Used to cancel Wait.conditions that are waiting to play or discard cards dropped in zones
    --]]

    --
    local wait_id = zone.getGUID()..obj.getGUID()

    if zoneWaits[wait_id] then
        Wait.stop(zoneWaits[wait_id])

        if data.debug then
            log("Cancelling Wait.condition ID "..wait_id, nil, "info")
        end
    end
end

function zone_containsObject(obj, zone)
    --checks if an object is present in a zone

    --Get the zone contents
    local zoneContents = zone.getObjects()

    --Retunr false instantly if the zone is empty
    if #zoneContents < 1 then return false end

    --Loop through contained objects looking for a match
    for _,zobj in ipairs(zoneContents) do
        if zobj==obj then return true end
    end

    --Return false if no match found
    return false
end

function handzone_containsObject(obj, player_color)
    --checks if an object is present in a players handzone

    return zone_containsObject(obj, data[player_color].handzone_zone)
end