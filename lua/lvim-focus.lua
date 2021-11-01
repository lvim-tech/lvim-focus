local config = require("modules.config")
local utils = require("modules.utils")
local autocmd = require("modules.autocmd")
local resizer = require("modules.resizer")

local M = {}

M.setup = function(options)
    if options ~= nil then
        for ind, opt in pairs(options) do
            if ind == "blacklist_ft" then
                local all_blacklist_ft = utils.table_concat(config.blacklist_ft, opt)
                opt = utils.remove_duplicates(all_blacklist_ft)
            elseif ind == "blacklist_bt" then
                local all_blacklist_bt = utils.table_concat(config.blacklist_bt, opt)
                opt = utils.remove_duplicates(all_blacklist_bt)
            end
            config[ind] = opt
        end
    end
    if config.active_plugin == 1 then
        autocmd.enable()
        if config.winhighlight then
            vim.cmd("hi link FocusedWindow LvimFocus")
            vim.cmd("hi link UnfocusedWindow Normal")
            vim.wo.winhighlight = "Normal:FocusedWindow,NormalNC:UnfocusedWindow"
        end
    end
end

M.toggle = function()
    if config.active_plugin == 1 then
        config.active_plugin = 0
        if config.winhighlight then
            vim.cmd("hi link FocusedWindow Normal")
            vim.cmd("hi link UnfocusedWindow Normal")
            vim.wo.winhighlight = "Normal:FocusedWindow,NormalNC:UnfocusedWindow"
        end
        autocmd.disable()
        autocmd.restore_disable()
        vim.api.nvim_exec([[exe "normal \<C-W>\="]], true)
    elseif config.active_plugin == 0 then
        config.active_plugin = 1
        if config.winhighlight then
            vim.cmd("hi link FocusedWindow LvimFocus")
            vim.cmd("hi link UnfocusedWindow Normal")
            vim.wo.winhighlight = "Normal:FocusedWindow,NormalNC:UnfocusedWindow"
        end
        autocmd.enable()
        autocmd.restore_enable()
        autocmd.restore_enable_current()
        resizer.resize()
    end
end

return M
