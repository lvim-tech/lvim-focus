# LVIM FOCUS

![LVIM FOCUS](https://github.com/lvim-tech/lvim-focus/blob/main/media/lvim-focus.png)

[![License](https://img.shields.io/badge/License-BSD%203--Clause-blue.svg)](https://github.com/lvim-tech/lvim-helper/blob/main/LICENSE)

## Description

- Auto resize windows
- Optimal size (width and height) for windows
- Hide `cursorcolumn`, `cursorline`, `signcolumn`, `colorcolumn`, `number`, `relativenumber` for inactive windows
- Add `winhighlight` for active window (hi `LvimFocusNormal` - add to your colorscheme)
- Blacklist of filetypes
- Deactivate of the plugin on startup with option `active_plugin = 0`
- Dynamic activate / deactivate of the plugin whit command `:LvimFocusToggle`
- The main advantage over other similar plugins - correct resize

<details>
<summary>Screenshots</summary>

![01](https://github.com/lvim-tech/lvim-focus/blob/main/media/screenshot_1.png)

![02](https://github.com/lvim-tech/lvim-focus/blob/main/media/screenshot_2.png)

![03](https://github.com/lvim-tech/lvim-focus/blob/main/media/screenshot_3.png)

</details>

## Requirements

- [neovim (>=0.7.0)](https://github.com/neovim/neovim/wiki/Installing-Neovim)

## Install

```lua
use {
    'lvim-tech/lvim-focus',
    config = function()
        require("lvim-focus").setup()
    end
}
```

## Default config

```lua
{
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
		active = false, -- or function
		inactive = false, -- or function
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
		"octo",
		"neo-tree",
		"neo-tree-popup",
		"noice",
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
```

## Command

```
-- activate / deactivate of the plugin

:LvimFocusToggle
```
