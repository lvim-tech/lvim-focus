local config = require("lvim-focus.config")
local utils = require("lvim-focus.utils")
local autocmd = require("lvim-focus.autocmd")
local resizer = require("lvim-focus.resizer")

local M = {}

M.setup = function(user_config)
    if user_config ~= nil then
        utils.merge(config, user_config)
    end
    vim.schedule(function()
        M.init()
    end)
end

M.init = function()
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
