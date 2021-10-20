local config = require('lvim-focus.config')
local utils = require('lvim-focus.utils')
local autocmd = require('lvim-focus.autocmd')

local M = {}

M.setup = function(options)
    local default_blacklist = {
        "Trouble",
        'NvimTree',
        'dashboard',
        'vista',
        'spectre_panel',
        'diffviewfiles',
        'qf'
    } -- ToDo - add all ft

    if options ~= nil then
		for ind, opt in pairs(options) do
            if ind == 'blacklist' then
                local all_blacklist = utils.table_concat(config.blacklist, opt)
                opt = utils.remove_duplicates(all_blacklist)
            end
			config[ind] = opt
		end
        if options["blacklist"] == nil then
            config["blacklist"] = default_blacklist
        end
    else
        config["blacklist"] = default_blacklist
	end

    M.init()
end

M.init = function()
    autocmd.init()
end


return M