local config = require("lvim-focus.config")

local M = {}

local GOLDEN_RATIO = 1.618

M.ignore_by_ft = function(ft)
    for _, type in pairs(config.blacklist_ft) do
        if type == ft then
            return 1
        end
    end
end

M.ignore_by_bt = function(bt)
    for _, type in pairs(config.blacklist_bt) do
        if type == ft then
            return 1
        end
    end
end

-- M.ignore_float_windows = function()
--     local current_config = vim.api.nvim_win_get_config(0)
--     if current_config["relative"] ~= "" then
--         return 1
--     end
-- end

M.resize = function()
    -- local bt = vim.api.nvim_buf_get_option(vim.api.nvim_win_get_buf(0), 'buftype')
    -- if M.ignore_by_bt(bt) == 1 then
    --     print("bt")
    --     --ignore
    -- else
    -- end
    M.resize_layout()
end

M.resize_layout = function()
    local layout = vim.api.nvim_call_function("winlayout", {})
    local active_window_id = vim.api.nvim_call_function("win_getid", {})
    local max_width = vim.api.nvim_get_option("columns")
    local max_height = vim.api.nvim_get_option("lines")
    local _golden_width = math.floor(max_width / GOLDEN_RATIO)
    local _golden_height = math.floor(max_height / GOLDEN_RATIO)
    local remaining_total_width = max_width - _golden_width
    local remaining_total_height = max_height - _golden_height
    local horizontal_win_count, vertical_win_count = unpack(M.count_window_splits(active_window_id))
    local remaining_width_for_window = remaining_total_width
    local remaining_height_for_window = remaining_total_height
    if horizontal_win_count > 1 then
        remaining_height_for_window = math.floor(remaining_total_height / horizontal_win_count)
    end
    if vertical_win_count > 1 then
        remaining_width_for_window = math.floor(remaining_total_width / vertical_win_count)
    end
    if layout[1] == "row" then
        M.process_windows_row(
            layout[2],
            active_window_id,
            remaining_width_for_window - 1,
            remaining_height_for_window - 1
        )
    elseif layout[1] == "col" then
        M.process_windows_col(
            layout[2],
            active_window_id,
            remaining_width_for_window - 1,
            remaining_height_for_window - 1
        )
    end
end

M.count_row = function(blocks, result, active_window_id)
    for _, v in ipairs(blocks) do
        local block_key = v[1]
        if block_key == "leaf" then
            local window_id = v[2]
            ft = vim.api.nvim_buf_get_option(vim.api.nvim_win_get_buf(window_id), 'filetype')
            -- bt = vim.api.nvim_buf_get_option(vim.api.nvim_win_get_buf(window_id), 'buftype')
            if M.ignore_by_ft(ft) == 1 then
                --ignore
            -- elseif M.ignore_by_bt(bt) == 1 then
            --     --ignore
            elseif window_id == active_window_id then
                -- 
            else
                result[2] = result[2] + 1
            end
        elseif block_key == "col" then
            M.count_col(v[2], result, active_window_id)
        end
    end
end

M.count_col = function(blocks, result, active_window_id)
    for _, v in ipairs(blocks) do
        local block_key = v[1]
        if block_key == "leaf" then
            local window_id = v[2]
            ft = vim.api.nvim_buf_get_option(vim.api.nvim_win_get_buf(window_id), 'filetype')
            -- bt = vim.api.nvim_buf_get_option(vim.api.nvim_win_get_buf(window_id), 'buftype')
            if M.ignore_by_ft(ft) == 1 then
                --ignore
            -- elseif M.ignore_by_bt(bt) == 1 then
            --     --ignore
            elseif window_id == active_window_id then
                --ignore
            else
                result[1] = result[1] + 1
            end
        elseif block_key == "row" then
            M.count_row(v[2], result, active_window_id)
        end
    end
end

M.count_window_splits = function(active_window_id)
    local layout = vim.api.nvim_call_function("winlayout", {})
    local result = {0, 0}
    if layout[1] == "row" then
        M.count_row(layout[2], result, active_window_id)
    elseif layout[1] == "col" then
        M.count_col(layout[2], result, active_window_id)
    end
    -- print(vim.inspect(result))
    return result
end

M.process_windows_row = function(blocks, active_window_id, remaining_width_for_window, remaining_height_for_window)
    local ft, bt
    for _, v in ipairs(blocks) do
        local block_key = v[1]
        if block_key == "leaf" then
            local window_id = v[2]
            ft = vim.api.nvim_buf_get_option(vim.api.nvim_win_get_buf(window_id), 'filetype')
            -- bt = vim.api.nvim_buf_get_option(vim.api.nvim_win_get_buf(window_id), 'buftype')
            if M.ignore_by_ft(ft) == 1 then
                --ignore
            -- elseif M.ignore_by_bt(bt) == 1 then
            --     --ignore
            elseif window_id == active_window_id then
                local max_width = vim.api.nvim_get_option("columns")
                local _golden_width = math.floor(max_width / GOLDEN_RATIO)
                vim.api.nvim_win_set_width(active_window_id, _golden_width)
            else
                vim.api.nvim_win_set_width(window_id, remaining_width_for_window)
            end
        elseif block_key == "col" then
            M.process_windows_col(v[2], active_window_id, remaining_width_for_window, remaining_height_for_window)
        end
    end
end

M.process_windows_col = function(blocks, active_window_id, remaining_width_for_window, remaining_height_for_window)
    local ft
    for _, v in ipairs(blocks) do
        local block_key = v[1]
        if block_key == "leaf" then
            local window_id = v[2]
            ft = vim.api.nvim_buf_get_option(vim.api.nvim_win_get_buf(window_id), 'filetype')
            -- bt = vim.api.nvim_buf_get_option(vim.api.nvim_win_get_buf(window_id), 'buftype')
            if M.ignore_by_ft(ft) == 1 then
                --ignore
            -- elseif M.ignore_by_bt(bt) == 1 then
            --     --ignore
            elseif window_id == active_window_id then
                local max_height = vim.api.nvim_get_option("lines")
                local _golden_height = math.floor(max_height / GOLDEN_RATIO)
                vim.api.nvim_win_set_height(window_id, _golden_height)
            else
                vim.api.nvim_win_set_height(window_id, remaining_height_for_window)
            end
        elseif block_key == "row" then
            M.process_windows_row(v[2], active_window_id, remaining_width_for_window, remaining_height_for_window)
        end
    end
end

return M