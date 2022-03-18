local api = vim.api
local config = require("lvim-focus.config")
local utils = require("lvim-focus.utils")

local M = {}

local GOLDEN_RATIO = 1.7

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
    local current_config = api.nvim_win_get_config(0)
    if current_config["relative"] ~= "" then
        return 1
    end
end

M.sizes = {
    columns = {},
    columns_ignored = {},
    calculate_error = false,
    current_window = nil,
    current_window_position = {},
    max_width = 0,
    max_height = 0
}

M.clear_sizes = function()
    M.sizes.columns = {}
    M.sizes.columns_ignored = {}
    M.sizes.calculate_error = false
    M.sizes.current_window = nil
    M.sizes.current_window_position = {}
    M.sizes.max_width = 0
    M.sizes.max_height = 0
end

M.resize = function()
    M.clear_sizes()
    local layout = api.nvim_call_function("winlayout", {})
    M.sizes.current_window = api.nvim_call_function("win_getid", {})
    local ft = api.nvim_buf_get_option(api.nvim_win_get_buf(M.sizes.current_window), "filetype")
    local bt = api.nvim_buf_get_option(api.nvim_win_get_buf(M.sizes.current_window), "buftype")
    if M.ignore_by_float() == 1 and M.ignore_by_bt(bt) == 1 then
        -- ignore
        return
    elseif M.ignore_by_ft(ft) == 1 then
        if ft ~= "ctrlspace" and ft ~= "floaterm" and ft ~= "toggleterm" then
            api.nvim_exec([[exe "normal \<C-W>\="]], true)
        end
    elseif type(layout[2]) == "table" then
        if layout[1] == "row" then
            M.calculate_columns(layout[2])
        end
    end
end

M.calculate_columns = function(tbl)
    local ft, ft1, ft2
    local temp_table = {}
    local temp_in_table = {}
    for i = 1, #tbl do
        if tbl[i][1] == "leaf" then
            ft = api.nvim_buf_get_option(api.nvim_win_get_buf(tbl[i][2]), "filetype")
            if M.ignore_by_ft(ft) ~= 1 then
                table.insert(temp_table, {"leaf", tbl[i][2]})
            end
        elseif tbl[i][1] == "col" and #tbl[i][2] <= 2 then
            for y = 1, #tbl[i][2] do
                if tbl[i][2][y][1] == "leaf" then
                    ft = api.nvim_buf_get_option(api.nvim_win_get_buf(tbl[i][2][y][2]), "filetype")
                    if M.ignore_by_ft(ft) == 1 then
                        M.sizes.calculate_error = true
                    else
                        table.insert(temp_in_table, {"cols", tbl[i][2][y][2]})
                    end
                elseif tbl[i][2][y][1] == "row" then
                    if #tbl[i][2][y][2] > 2 then
                        M.sizes.calculate_error = true
                    else
                        if tbl[i][2][y][2][1][1] == "leaf" and tbl[i][2][y][2][2][1] == "leaf" then
                            ft1 = api.nvim_buf_get_option(api.nvim_win_get_buf(tbl[i][2][y][2][1][1]), "filetype")
                            ft2 = api.nvim_buf_get_option(api.nvim_win_get_buf(tbl[i][2][y][2][2][1]), "filetype")
                            if M.ignore_by_ft(ft1) == 1 or M.ignore_by_ft(ft2) == 1 then
                                M.sizes.calculate_error = true
                            else
                                table.insert(temp_in_table, {"rows", {tbl[i][2][y][2][1][2], tbl[i][2][y][2][2][2]}})
                            end
                        else
                            M.sizes.calculate_error = true
                        end
                    end
                end
            end
            table.insert(temp_table, temp_in_table)
            temp_in_table = {}
        else
            M.sizes.calculate_error = true
        end
        utils.concat(M.sizes.columns, temp_table)
        temp_table = {}
    end
    if M.sizes.calculate_error then
        api.nvim_exec([[exe "normal \<C-W>\="]], true)
    else
        M.calculate_columns_size()
        M.resize_columns()
    end
end

M.calculate_columns_size = function()
    local tbl = M.sizes.columns
    local max_width = 0
    local max_height = 0
    local _max_height
    for i = 1, #tbl do
        if tbl[i][1] == "leaf" then
            max_width = max_width + api.nvim_win_get_width(tbl[i][2])
            _max_height = api.nvim_win_get_height(tbl[i][2])
            if _max_height > max_height then
                max_height = _max_height
            end
            if tbl[i][2] == M.sizes.current_window then
                M.sizes.current_window_position = {i, 0, 0, "leaf"}
            end
        elseif tbl[i][1][1] == "cols" and tbl[i][2][1] == "cols" then
            max_width = max_width + api.nvim_win_get_width(tbl[i][1][2])
            _max_height = api.nvim_win_get_height(tbl[i][1][2]) + api.nvim_win_get_height(tbl[i][2][2])
            if _max_height > max_height then
                max_height = _max_height
            end
            if tbl[i][1][2] == M.sizes.current_window then
                M.sizes.current_window_position = {i, 1, 0, "cols-cols"}
            elseif tbl[i][2][2] == M.sizes.current_window then
                M.sizes.current_window_position = {i, 2, 0, "cols-cols"}
            end
        elseif tbl[i][1][1] == "cols" and tbl[i][2][1] == "rows" then
            max_width = max_width + api.nvim_win_get_width(tbl[i][1][2])
            _max_height = api.nvim_win_get_height(tbl[i][1][2]) + api.nvim_win_get_height(tbl[i][2][2][1])
            if _max_height > max_height then
                max_height = _max_height
            end
            if tbl[i][1][2] == M.sizes.current_window then
                M.sizes.current_window_position = {i, 1, 0, "cols-rows"}
            elseif tbl[i][2][2][1] == M.sizes.current_window then
                M.sizes.current_window_position = {i, 2, 1, "cols-rows"}
            elseif tbl[i][2][2][2] == M.sizes.current_window then
                M.sizes.current_window_position = {i, 2, 2, "cols-rows"}
            end
        elseif tbl[i][1][1] == "rows" and tbl[i][2][1] == "cols" then
            max_width = max_width + api.nvim_win_get_width(tbl[i][2][2])
            _max_height = api.nvim_win_get_height(tbl[i][2][2]) + api.nvim_win_get_height(tbl[i][1][2][1])
            if _max_height > max_height then
                max_height = _max_height
            end
            if tbl[i][2][2] == M.sizes.current_window then
                M.sizes.current_window_position = {i, 2, 0, "rows-cols"}
            elseif tbl[i][1][2][1] == M.sizes.current_window then
                M.sizes.current_window_position = {i, 1, 1, "rows-cols"}
            elseif tbl[i][1][2][2] == M.sizes.current_window then
                M.sizes.current_window_position = {i, 1, 2, "rows-cols"}
            end
        elseif tbl[i][1][1] == "rows" and tbl[i][2][1] == "rows" then
            max_width = max_width + api.nvim_win_get_width(tbl[i][1][2][1]) + api.nvim_win_get_width(tbl[i][1][2][2])
            _max_height = api.nvim_win_get_height(tbl[i][1][2][1]) + api.nvim_win_get_height(tbl[i][2][2][1])
            if _max_height > max_height then
                max_height = _max_height
            end
            if tbl[i][1][2][1] == M.sizes.current_window then
                M.sizes.current_window_position = {i, 1, 1, "rows-rows"}
            elseif tbl[i][1][2][2] == M.sizes.current_window then
                M.sizes.current_window_position = {i, 1, 2, "rows-rows"}
            elseif tbl[i][2][2][1] == M.sizes.current_window then
                M.sizes.current_window_position = {i, 2, 1, "rows-rows"}
            elseif tbl[i][2][2][2] == M.sizes.current_window then
                M.sizes.current_window_position = {i, 2, 2, "rows-rows"}
            end
        end
    end
    M.sizes.max_width = max_width
    M.sizes.max_height = max_height
end

M.resize_columns = function()
    local current_window = M.sizes.current_window
    local tbl = M.sizes.columns
    local max_width = M.sizes["max_width"]
    local max_height = M.sizes["max_height"]
    local max_height_half = math.floor(max_height / 2)
    local golden_width = math.floor(max_width / GOLDEN_RATIO)
    local golden_width_half = math.floor(golden_width / 2)
    local golden_width_half_active = math.floor(golden_width / 2.5)
    local golden_width_half_not_active = math.floor(golden_width / 1.5)
    local widht_average = math.floor((max_width - golden_width) / (#tbl - 1))
    local widht_average_half = math.floor(widht_average / 2)
    local golden_height = math.floor(max_height / GOLDEN_RATIO)
    local height_average = math.floor(max_height - golden_height)

    if #tbl > 3 then
        api.nvim_exec([[exe "normal \<C-W>\="]], true)
    else
        if #tbl ~= 1 then
            for i = 1, #tbl do
                if tbl[i][1] == "leaf" then
                    if tbl[i][2] == current_window then
                        api.nvim_win_set_width(tbl[i][2], golden_width)
                    else
                        api.nvim_win_set_width(tbl[i][2], widht_average)
                    end
                    api.nvim_win_set_height(tbl[i][2], max_height)
                elseif tbl[i][1][1] == "cols" and tbl[i][2][1] == "cols" then
                    if tbl[i][1][2] == current_window or tbl[i][2][2] == current_window then
                        api.nvim_win_set_width(tbl[i][1][2], golden_width)
                        api.nvim_win_set_width(tbl[i][2][2], golden_width)
                        if tbl[i][1][2] == current_window then
                            api.nvim_win_set_height(tbl[i][1][2], golden_height)
                            api.nvim_win_set_height(tbl[i][2][2], height_average)
                        else
                            api.nvim_win_set_height(tbl[i][1][2], height_average)
                            api.nvim_win_set_height(tbl[i][2][2], golden_height)
                        end
                    else
                        api.nvim_win_set_width(tbl[i][1][2], widht_average)
                        api.nvim_win_set_width(tbl[i][2][2], widht_average)
                        api.nvim_win_set_height(tbl[i][1][2], max_height_half)
                        api.nvim_win_set_height(tbl[i][2][2], max_height_half)
                    end
                elseif tbl[i][1][1] == "cols" and tbl[i][2][1] == "rows" then
                    if
                        tbl[i][1][2] == current_window or tbl[i][2][2][1] == current_window or
                            tbl[i][2][2][2] == current_window
                     then
                        api.nvim_win_set_width(tbl[i][1][2], golden_width)
                        if tbl[i][1][2] == current_window then
                            api.nvim_win_set_width(tbl[i][2][2][1], golden_width_half)
                            api.nvim_win_set_width(tbl[i][2][2][2], golden_width_half)

                            api.nvim_win_set_height(tbl[i][1][2], golden_height)
                            api.nvim_win_set_height(tbl[i][2][2][2], height_average)
                            api.nvim_win_set_height(tbl[i][2][2][1], height_average)
                        elseif tbl[i][2][2][1] == current_window or tbl[i][2][2][2] == current_window then
                            if tbl[i][2][2][1] == current_window then
                                api.nvim_win_set_width(tbl[i][2][2][2], golden_width_half_active)
                                api.nvim_win_set_width(tbl[i][2][2][1], golden_width_half_not_active)
                            else
                                api.nvim_win_set_width(tbl[i][2][2][1], golden_width_half_active)
                                api.nvim_win_set_width(tbl[i][2][2][2], golden_width_half_not_active)
                            end
                            api.nvim_win_set_height(tbl[i][1][2], height_average)
                            api.nvim_win_set_height(tbl[i][2][2][2], golden_height)
                            api.nvim_win_set_height(tbl[i][2][2][1], golden_height)
                        end
                    else
                        api.nvim_win_set_width(tbl[i][1][2], widht_average)
                        api.nvim_win_set_width(tbl[i][2][2][1], widht_average_half)
                        api.nvim_win_set_width(tbl[i][2][2][2], widht_average_half)
                        api.nvim_win_set_height(tbl[i][1][2], max_height_half)
                        api.nvim_win_set_height(tbl[i][2][2][1], max_height_half)
                        api.nvim_win_set_height(tbl[i][2][2][2], max_height_half)
                    end
                elseif tbl[i][1][1] == "rows" and tbl[i][2][1] == "cols" then
                    if
                        tbl[i][2][2] == current_window or tbl[i][1][2][1] == current_window or
                            tbl[i][1][2][2] == current_window
                     then
                        api.nvim_win_set_width(tbl[i][2][2], golden_width)
                        if tbl[i][2][2] == current_window then
                            api.nvim_win_set_width(tbl[i][1][2][1], golden_width_half)
                            api.nvim_win_set_width(tbl[i][1][2][2], golden_width_half)

                            api.nvim_win_set_height(tbl[i][2][2], golden_height)
                            api.nvim_win_set_height(tbl[i][1][2][2], height_average)
                            api.nvim_win_set_height(tbl[i][1][2][1], height_average)
                        elseif tbl[i][1][2][1] == current_window or tbl[i][1][2][2] == current_window then
                            if tbl[i][1][2][1] == current_window then
                                api.nvim_win_set_width(tbl[i][1][2][2], golden_width_half_active)
                                api.nvim_win_set_width(tbl[i][1][2][1], golden_width_half_not_active)
                            else
                                api.nvim_win_set_width(tbl[i][1][2][1], golden_width_half_active)
                                api.nvim_win_set_width(tbl[i][1][2][2], golden_width_half_not_active)
                            end
                            api.nvim_win_set_height(tbl[i][2][2], height_average)
                            api.nvim_win_set_height(tbl[i][1][2][2], golden_height)
                            api.nvim_win_set_height(tbl[i][1][2][1], golden_height)
                        end
                    else
                        api.nvim_win_set_width(tbl[i][2][2], widht_average)
                        api.nvim_win_set_width(tbl[i][1][2][1], widht_average_half)
                        api.nvim_win_set_width(tbl[i][1][2][2], widht_average_half)
                        api.nvim_win_set_height(tbl[i][2][2], max_height_half)
                        api.nvim_win_set_height(tbl[i][1][2][1], max_height_half)
                        api.nvim_win_set_height(tbl[i][1][2][2], max_height_half)
                    end
                elseif tbl[i][1][1] == "rows" and tbl[i][2][1] == "rows" then
                    if tbl[i][1][2][1] == current_window then
                        api.nvim_win_set_width(tbl[i][1][2][1], golden_width_half_not_active)
                        api.nvim_win_set_width(tbl[i][1][2][2], golden_width_half_active)
                        api.nvim_win_set_width(tbl[i][2][2][1], golden_width_half)
                        api.nvim_win_set_width(tbl[i][2][2][2], golden_width_half)

                        api.nvim_win_set_height(tbl[i][1][2][1], golden_height)
                        api.nvim_win_set_height(tbl[i][1][2][2], golden_height)
                        api.nvim_win_set_height(tbl[i][2][2][1], height_average)
                        api.nvim_win_set_height(tbl[i][2][2][2], height_average)
                    elseif tbl[i][1][2][2] == current_window then
                        api.nvim_win_set_width(tbl[i][1][2][1], golden_width_half_active)
                        api.nvim_win_set_width(tbl[i][1][2][2], golden_width_half_not_active)
                        api.nvim_win_set_width(tbl[i][2][2][1], golden_width_half)
                        api.nvim_win_set_width(tbl[i][2][2][2], golden_width_half)

                        api.nvim_win_set_height(tbl[i][1][2][1], golden_height)
                        api.nvim_win_set_height(tbl[i][1][2][2], golden_height)
                        api.nvim_win_set_height(tbl[i][2][2][1], height_average)
                        api.nvim_win_set_height(tbl[i][2][2][2], height_average)
                    elseif tbl[i][2][2][1] == current_window then
                        api.nvim_win_set_width(tbl[i][2][2][1], golden_width_half_not_active)
                        api.nvim_win_set_width(tbl[i][2][2][2], golden_width_half_active)
                        api.nvim_win_set_width(tbl[i][1][2][1], golden_width_half)
                        api.nvim_win_set_width(tbl[i][1][2][2], golden_width_half)

                        api.nvim_win_set_height(tbl[i][2][2][1], golden_height)
                        api.nvim_win_set_height(tbl[i][2][2][2], golden_height)
                        api.nvim_win_set_height(tbl[i][1][2][1], height_average)
                        api.nvim_win_set_height(tbl[i][1][2][2], height_average)
                    elseif tbl[i][2][2][2] == current_window then
                        api.nvim_win_set_width(tbl[i][2][2][1], golden_width_half_active)
                        api.nvim_win_set_width(tbl[i][2][2][2], golden_width_half_not_active)
                        api.nvim_win_set_width(tbl[i][1][2][1], golden_width_half)
                        api.nvim_win_set_width(tbl[i][1][2][2], golden_width_half)

                        api.nvim_win_set_height(tbl[i][2][2][1], golden_height)
                        api.nvim_win_set_height(tbl[i][2][2][2], golden_height)
                        api.nvim_win_set_height(tbl[i][1][2][1], height_average)
                        api.nvim_win_set_height(tbl[i][1][2][2], height_average)
                    else
                        api.nvim_win_set_width(tbl[i][1][2][1], widht_average_half)
                        api.nvim_win_set_width(tbl[i][1][2][2], widht_average_half)
                        api.nvim_win_set_width(tbl[i][2][2][1], widht_average_half)
                        api.nvim_win_set_width(tbl[i][2][2][2], widht_average_half)

                        api.nvim_win_set_height(tbl[i][1][2][1], max_height_half)
                        api.nvim_win_set_height(tbl[i][1][2][2], max_height_half)
                        api.nvim_win_set_height(tbl[i][2][2][1], max_height_half)
                        api.nvim_win_set_height(tbl[i][2][2][2], max_height_half)
                    end
                end
            end
        end
    end
end

return M
