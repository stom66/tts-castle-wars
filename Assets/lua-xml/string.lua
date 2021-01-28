function string:split(sep)
    local sep = sep or "([^%s]+)"
    local t = {}
    for s in string.gmatch(self, sep) do
        table.insert(t, s)
    end
    return t
end