local cmd = vim.api.nvim_command
local config = require("lvim-focus.config")
local M = {}

M.buffers = {}

M.copy_table = function(orig)
    local orig_type = type(orig)
    local copy
    if orig_type == "table" then
        copy = {}
        for orig_key, orig_value in next, orig, nil do
            copy[M.copy_table(orig_key)] = M.copy_table(orig_value)
        end
        setmetatable(copy, M.copy_table(getmetatable(orig)))
    else
        copy = orig
    end
    return copy
end

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

M.ignore_by_ft = function(ft)
    for _, type in pairs(config.blacklist_ft) do
        if type == ft then
            return 1
        end
    end
end

M.ignore_by_bt = function(bt)
    for _, type in pairs(config.blacklist_bt) do
        if type == bt then
            return 1
        end
    end
end

M.ignore_by_float = function()
    local current_config = vim.api.nvim_win_get_config(0)
    if current_config["relative"] ~= "" then
        return 1
    end
end

M.valid_buffers = function(tbl)
    for i, v in ipairs(tbl) do
        if type(v) == "table" then
            M.valid_buffers(v)
        else
            if type(v) == "number" then
                local ft = vim.api.nvim_buf_get_option(vim.api.nvim_win_get_buf(v), "filetype")
                local bt = vim.api.nvim_buf_get_option(vim.api.nvim_win_get_buf(v), "buftype")
                if M.ignore_by_ft(ft) == 1 or M.ignore_by_bt(bt) == 1 then
                    tbl[i - 1] = nil
                    tbl[i] = nil
                else
                    table.insert(M.buffers, v)
                end
            end
        end
    end
end

M.is_contains_number = function(tbl)
    for _, v in ipairs(tbl) do
        if type(v) == "table" then
            M.is_contains_number(v)
        else
            if type(v) == "number" then
                M.contains_number = true
            end
        end
    end
end

M.cleaning_table = function(tbl)
    for i, v in ipairs(tbl) do
        if type(v) == "table" then
            M.contains_number = false
            M.is_contains_number(v)
            if M.contains_number == false then
                table.remove(tbl, i)
            else
                M.cleaning_table(v)
            end
        end
    end
end

M.tbl_set = function(tbl)
    local set = {}
    for _, l in ipairs(tbl) do
        set[l] = true
    end
    return set
end

return M
