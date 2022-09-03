local config = require("lvim-focus.config")
local utils = require("lvim-focus.utils")

local M = {}

M.win_options = function()
	local win_current = vim.api.nvim_call_function("win_getid", {})
	local tbl_set = utils.tbl_set(utils.buffers)
	for _, v in ipairs(utils.buffers) do
		if config.cursorcolumn then
			vim.api.nvim_win_set_option(v, "cursorcolumn", false)
			if tbl_set[win_current] then
				vim.api.nvim_win_set_option(win_current, "cursorcolumn", true)
			end
		end
		if config.cursorline then
			vim.api.nvim_win_set_option(v, "cursorline", false)
			if tbl_set[win_current] then
				vim.api.nvim_win_set_option(win_current, "cursorline", true)
			end
		end
		if config.signcolumn then
			vim.api.nvim_win_set_option(v, "signcolumn", "no")
			if tbl_set[win_current] then
				vim.api.nvim_win_set_option(win_current, "signcolumn", config.signcolumn_value)
			end
		end
		if config.colorcolumn then
			vim.api.nvim_win_set_option(v, "colorcolumn", "0")
			if tbl_set[win_current] then
				vim.api.nvim_win_set_option(win_current, "colorcolumn", config.colorcolumn_value)
			end
		end
		if config.number then
			vim.api.nvim_win_set_option(v, "number", false)
			if tbl_set[win_current] then
				vim.api.nvim_win_set_option(win_current, "number", true)
			end
		end
		if config.relativenumber then
			vim.api.nvim_win_set_option(v, "relativenumber", false)
			if tbl_set[win_current] then
				vim.api.nvim_win_set_option(win_current, "relativenumber", true)
			end
		end
		if type(config.custom.active) == "function" then
			if tbl_set[win_current] then
				config.custom.active(win_current)
			end
		end
		if type(config.custom.inactive) == "function" then
			config.custom.inactive(v)
		end
	end
	if config.size_stabilize then
		vim.cmd("wincmd=")
		vim.opt.cmdheight = config.cmdheight
	end
	if config.winhighlight then
		for _, win in ipairs(vim.api.nvim_list_wins()) do
			if utils.is_floating(win) then
				vim.api.nvim_win_set_option(win, "winhighlight", "Normal:LvimFocusFloat")
			end
		end
	end
end

M.win_default = function()
	for _, v in ipairs(utils.buffers) do
		if config.cursorcolumn then
			vim.api.nvim_win_set_option(v, "cursorcolumn", true)
		end
		if config.cursorline then
			vim.api.nvim_win_set_option(v, "cursorline", true)
		end
		if config.signcolumn then
			vim.api.nvim_win_set_option(v, "signcolumn", config.signcolumn_value)
		end
		if config.colorcolumn then
			vim.api.nvim_win_set_option(v, "colorcolumn", config.colorcolumn_value)
		end
		if config.number then
			vim.api.nvim_win_set_option(v, "number", true)
		end
		if config.relativenumber then
			vim.api.nvim_win_set_option(v, "relativenumber", true)
		end
		if type(config.custom.inactive) == "function" then
			config.custom.inactive(v)
		end
	end
end

return M
