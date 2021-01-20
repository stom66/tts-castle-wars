
function table.count(t)
    local c = 0
    for _,_ in pairs(t) do c = c + 1 end
    return c
end

function table.contains(table, value)
    for _,v in pairs(table) do
        if value==v then return true end
    end
    return false
end

function table.merge(t1, t2)
    for k,v in pairs(t2) do
        t1[k] = v
    end
    return t1
end