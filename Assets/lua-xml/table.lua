
function table.count(t)
    local c = 0
    for _,_ in pairs(t) do c = c + 1 end
    return c
end

function table.contains(table, value)
    if not table or not value then return false end
    for k,v in pairs(table) do
        if value==v then return k end
    end
    return false
end

function table.merge(t1, t2)
    for k,v in pairs(t2) do
        t1[k] = v
    end
    return t1
end

function table.clone(t1)
    local t2 = {}
    for k,v in pairs(t1) do
        if type(v) == "Table" then
            t2[k] = table.clone(v)
        else
            t2[k] = v
        end
    end
    return t2
end