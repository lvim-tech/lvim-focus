local config = require('lvim-focus.modules.config')
local utlis = require('lvim-focus.modules.utils')

local M = {}


M.setup = function(options)
    local default_blacklist = {
        'dashboard',
        'vista',
        'NvimTree',
        'spectre_panel',
        'diffviewfiles',
        'qf'
    } -- ToDo - add all ft

    if options ~= nil then
		for ind, opt in pairs(options) do
            if ind == 'blacklist' then
                local all_blacklist = utlis.table_concat(config.blacklist, opt)
                opt = utlis.remove_duplicates(all_blacklist)
            end
			config[ind] = opt
		end
	end
    print(config.colorcolumn_width)
end

return M