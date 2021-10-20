local config = require('lvim-focus.config')
local utils = require('lvim-focus.utils')
local cmd = vim.api.nvim_command

local M = {}

function M.init()

	local autocmds = {}

	if config.resize then
		autocmds['focus_resize'] = {
			{"BufEnter,WinEnter", "*", "lua vim.schedule(function() require('lvim-focus.resizer').init() end)"}
		}
	end

	-- if config.signcolumn then
	-- 	autocmds['focus_signcolumn'] = {
	-- 		{ 'BufEnter,WinEnter', '*', 'if index(luaeval("' .. blacklist .. '"), &ft) < 0 | setlocal signcolumn=' .. get_sign_column() },
	-- 		{ 'BufLeave,WinLeave', '*', 'if index(luaeval("' .. blacklist .. '"), &ft) < 0 | setlocal signcolumn=no' },
	-- 	}
	-- end

	-- if config.cursorline then
	-- 	autocmds['focus_cursorline'] = {
	-- 		{ 'BufEnter,WinEnter', '*', 'if index(luaeval("' .. blacklist .. '"), &ft) < 0 | setlocal cursorline' },
	-- 		{ 'BufLeave,WinLeave', '*', 'if index(luaeval("' .. blacklist .. '"), &ft) < 0 | setlocal nocursorline' },
	-- 	}
	-- end

	-- if config.cursorcolumn then
	-- 	autocmds['focus_cursorcolumn'] = {
	-- 		{ 'BufEnter,WinEnter', '*', 'if index(luaeval("' .. blacklist .. '"), &ft) < 0 | setlocal cursorcolumn' },
	-- 		{ 'BufLeave,WinLeave', '*', 'if index(luaeval("' .. blacklist .. '"), &ft) < 0 | setlocal nocursorcolumn' },
	-- 	}
	-- end

	-- if config.colorcolumn.enable then
	-- 	autocmds['focus_colorcolumn'] = {
	-- 		{ 'BufEnter,WinEnter', '*', 'if index(luaeval("' .. blacklist .. '"), &ft) < 0 | setlocal colorcolumn=' .. config.colorcolumn.width },
	-- 		{ 'BufLeave,WinLeave', '*', 'if index(luaeval("' .. blacklist .. '"), &ft) < 0 | setlocal colorcolumn=0' },
	-- 	}
	-- end
	
	-- -- FIXME: Disable line numbers on startify buffer, add user config?
	-- if config.number then
	-- 	autocmds['number'] = {
	-- 		{ 'BufEnter,WinEnter', '*', 'if index(luaeval("' .. blacklist .. '"), &ft) < 0 | set number' },
	-- 		{ 'BufLeave,WinLeave', '*', 'if index(luaeval("' .. blacklist .. '"), &ft) < 0 | setlocal nonumber' },
	-- 	}
	-- end
	-- if config.relativenumber then
	-- 	autocmds['focus_relativenumber'] = {
	-- 		{ 'BufEnter,WinEnter', '*', 'if index(luaeval("' .. blacklist .. '"), &ft) < 0 | set nonumber relativenumber' },
	-- 		{ 'BufLeave,WinLeave', '*', 'if index(luaeval("' .. blacklist .. '"), &ft) < 0 | setlocal nonumber norelativenumber' },
	-- 	}
	-- end

	-- if config.hybridnumber then
	-- 	autocmds['focus_hybridnumber'] = {
	-- 		{ 'BufEnter,WinEnter', '*', 'if index(luaeval("' .. blacklist .. '"), &ft) < 0 | set number relativenumber' },
	-- 		{ 'BufLeave,WinLeave', '*', 'if index(luaeval("' .. blacklist .. '"), &ft) < 0 | setlocal nonumber norelativenumber' },
	-- 	}
	-- end

	utils.create_augroups(autocmds)
end

return M
