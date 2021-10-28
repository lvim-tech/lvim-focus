# LVIM FOCUS

![LVIM FOCUS](https://github.com/lvim-tech/lvim-focus/blob/main/media/lvim-focus.png)

[![License](https://img.shields.io/badge/License-BSD%203--Clause-blue.svg)](https://github.com/lvim-tech/lvim-helper/blob/main/LICENSE)

## Description

- Auto resize windows
- Optimal size (width and height) for active window
- Uniform size (width and height) for inactive windows
- Hide `cursorcolumn`, `cursorline`, `signcolumn`, `colorcolumn`, `number`, `relativenumber`, `hybridnumber` for inactive windows
- Add `winhighlight` for active window (hi `LvimFocus` - add to your colorscheme)
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

- [neovim (>=0.5.0)](https://github.com/neovim/neovim/wiki/Installing-Neovim)

## Install

```lua
use {
    'lvim-tech/lvim-focus',
    config = function()
        require("focus").setup()
    end
}
```

## Default config

```lua
{
    active_plugin = 1,
    resize = true,
    cursorcolumn = true,
    cursorline = true,
    signcolumn = true,
    colorcolumn = true,
    colorcolumn_width = 80,
    number = false,
    relativenumber = false,
    hybridnumber = true,
    winhighlight = true,
    blacklist_ft = {
        "ctrlspace",
        "packer",
        "Outline",
        "NvimTree",
        "LvimHelper",
        "Trouble",
        "dashboard",
        "vista",
        "spectre_panel",
        "diffviewfiles",
        "qf"
    }
}
```

## Command

```
-- activate / deactivate of the plugin

:LvimFocusToggle
```
