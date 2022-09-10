local M = {
	active_plugin = 1,
	size_stabilize = true,
	cursorcolumn = false,
	cursorline = false,
	signcolumn = false,
	signcolumn_value = "yes",
	colorcolumn = false,
	colorcolumn_value = "120",
	number = false,
	relativenumber = true,
	cmdheight = 1,
	winhighlight = true,
	custom = {
		active = false,
		inactive = false,
	},
	blacklist_ft = {
		"ctrlspace",
		"ctrlspace_help",
		"packer",
		"undotree",
		"diff",
		"Outline",
		"NvimTree",
		"LvimHelper",
		"floaterm",
		"toggleterm",
		"Trouble",
		"dashboard",
		"vista",
		"spectre_panel",
		"DiffviewFiles",
		"flutterToolsOutline",
		"log",
		"qf",
		"dapui_scopes",
		"dapui_breakpoints",
		"dapui_stacks",
		"dapui_watches",
		"calendar",
		"org",
		"tex",
		"octo",
		"neo-tree",
		"neo-tree-popup",
	},
	blacklist_bt = {
		"nofile",
		"nowrite",
		"quickfix",
		"help",
		"terminal",
		"directory",
		"scratch",
		"unlisted",
		"prompt",
	},
}

return M
