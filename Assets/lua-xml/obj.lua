--[[
    Misc function for dealing with objects
--]]

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