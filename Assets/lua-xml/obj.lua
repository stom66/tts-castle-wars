--[[
    Misc function for dealing with objects
--]]


function obj_addContextMenuItems(obj)
    --[[
        Adds suitable context menu items to Cards when they are spawned. 
        Ignores non-card objects.
    --]]

    if obj.tag == "Card" then
        obj.addContextMenuItem("Play Card", trigger_playCard)
        obj.addContextMenuItem("Discard Card", trigger_discardCard)
    end
end


function obj_getOwner(obj)
    --[[
        Works out which Player Color owns a particular object, based on it's GUID
    --]]
    if not obj then return false end

    local g = obj.getGUID()
    if g:find("blu") then
        return "Blue"
    elseif g:find("red") then
        return "Red"
    else
        return false
    end
end

function onObjectDestroy(obj)
    --[[
        see if the tablet was removed
    --]]
    if obj == data.tablet_obj then
        data.tablet_obj = nil
    end
end