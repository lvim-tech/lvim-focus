local cmd = vim.api.nvim_command

local M = {}

M.merge = function(t1, t2)
    for k, v in pairs(t2) do
        if (type(v) == "table") and (type(t1[k] or false) == "table") then
            if M.is_array(t1[k]) then
                t1[k] = M.concat(t1[k], v)
            else
                M.merge(t1[k], t2[k])
            end
        else
            t1[k] = v
        end
    end
    return t1
end

M.concat = function(t1, t2)
    for i = 1, #t2 do
        table.insert(t1, t2[i])
    end
    return t1
end

M.is_array = function(t)
    local i = 0
    for _ in pairs(t) do
        i = i + 1
        if t[i] == nil then
            return false
        end
    end
    return true
end

M.create_augroups = function(definitions)
    for group_name, definition in pairs(definitions) do
        cmd("augroup " .. group_name)
        cmd("autocmd!")
        for _, def in ipairs(definition) do
            local command = table.concat(vim.tbl_flatten({"autocmd", def}), " ")
            cmd(command)
        end
        cmd("augroup END")
    end
end

M.serialize = function(tbl)
    local serializedValues = {}
    local value, serializedValue
    for i = 1, #tbl do
        value = tbl[i]
        serializedValue = type(value) == "table" and M.serialize(value) or value
        serializedValue = "'" .. serializedValue .. "'"
        table.insert(serializedValues, serializedValue)
    end
    return string.format("{ %s }", table.concat(serializedValues, ", "))
end

M.remove_duplicates = function(tbl)
    local hash = {}
    local res = {}
    for _, v in ipairs(tbl) do
        if (not hash[v]) then
            res[#res + 1] = v
            hash[v] = true
        end
    end
    return res
end

M.has_value = function(tbl, val)
    for _, value in ipairs(tbl) do
        if value == val then
            return true
        end
    end
    return false
end

return M
