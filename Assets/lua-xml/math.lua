--[[
    math.range
    clamps n to be no less than min and more more than max
--]]
function math.range(n, min, max)
    local min = tonumber(min) or 0
    local max = tonumber(max) or 1
    return math.max(math.min((tonumber(n) or min), max), min)
end

--[[
    math.round
    rounds n to d decimal places
--]]
function math.round(n, d)
    local m = 10^(tonumber(d) or 0)
    return math.floor((tonumber(n) or 0)*m+0.5)/m
end