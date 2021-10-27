local cmd = vim.api.nvim_command

local M = {}

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

M.table_concat = function(tbl1, tbl2)
    for i = 1, #tbl2 do
        table.insert(tbl1, tbl2[i])
    end
    return tbl1
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
