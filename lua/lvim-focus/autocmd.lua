local utils = require("lvim-focus.utils")
local actions = require("lvim-focus.actions")

local M = {}

M.layout = {}

M.enable = function()
	local group = vim.api.nvim_create_augroup("LvimFocus", {
		clear = true,
	})
	vim.api.nvim_create_autocmd({
		"BufEnter",
		"WinEnter",
		"BufLeave",
		"WinLeave",
		"WinClosed",
		"VimResized",
	}, {
		callback = function()
			vim.schedule(function()
				local ft = vim.api.nvim_buf_get_option(vim.api.nvim_win_get_buf(0), "filetype")
				if ft ~= "ctrlspace" and ft ~= "ctrlspace_help" then
					M.enable_action()
				end
			end)
		end,
		group = group,
	})
	M.enable_action()
end

M.enable_action = function()
	local layout = vim.api.nvim_call_function("winlayout", {})
	if type(layout[2]) == table then
		M.layout = utils.copy_table(layout[2])
	else
		M.layout = utils.copy_table(layout)
	end
	if type(M.layout) == "table" then
		utils.buffers = {}
		utils.valid_buffers(M.layout)
		utils.cleaning_table(M.layout)
		actions.win_options()
	end
end

M.disable = function()
	vim.api.nvim_del_augroup_by_name("LvimFocus")
	actions.win_default()
end

return M
