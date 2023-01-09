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
	custom = {
		active = false,
		inactive = false,
	},
	blacklist_ft = {
		"DiffviewFiles",
		"LvimHelper",
		"NvimTree",
		"Outline",
		"Trouble",
		"calendar",
		"ctrlspace",
		"ctrlspace_help",
		"dapui_breakpoints",
		"dapui_scopes",
		"dapui_stacks",
		"dapui_watches",
		"dashboard",
		"diff",
		"floaterm",
		"flutterToolsOutline",
		"log",
		"neo-tree",
		"neo-tree-popup",
		"netrw",
		"noice",
		"octo",
		"org",
		"packer",
		"qf",
		"spectre_panel",
		"tex",
		"toggleterm",
		"undotree",
		"vista",
		"oil",
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
