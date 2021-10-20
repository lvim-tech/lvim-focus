local config = require("lvim-focus.config")
local utils = require("lvim-focus.utils")
local autocmd = require("lvim-focus.autocmd")

local M = {}

M.setup = function(options)
    local default_blacklist_ft = {
        "NvimTree",
        "Trouble",
        "dashboard",
        "vista",
        "spectre_panel",
        "diffviewfiles",
        "qf"
    } -- ToDo - add other ft
    local default_blacklist_bt = {
        "nofile",
        "prompt"
    }

    config["blacklist_ft"] = default_blacklist_ft
    config["blacklist_bt"] = default_blacklist_bt
    if options ~= nil then
        for ind, opt in pairs(options) do
            if ind == "blacklist_ft" then
                local all_blacklist_ft = utils.table_concat(config["blacklist_ft"], opt)
                opt = utils.remove_duplicates(all_blacklist_ft)
            elseif ind == "blacklist_bt" then
                local all_blacklist_bt = utils.table_concat(config["blacklist_bt"], opt)
                opt = utils.remove_duplicates(all_blacklist_bt)
            end
            config[ind] = opt
        end
    end

    M.init()
end

M.init = function()
    autocmd.init()
end

return M
