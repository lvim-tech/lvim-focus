local config = require("lvim-focus.config")
local utils = require("lvim-focus.utils")
local autocmd = require("lvim-focus.autocmd")

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
    end
end

M.toggle = function()
    if config.active_plugin == 1 then
        config.active_plugin = 0
        autocmd.disable()
    elseif config.active_plugin == 0 then
        config.active_plugin = 1
        autocmd.enable()
    end
end

return M
