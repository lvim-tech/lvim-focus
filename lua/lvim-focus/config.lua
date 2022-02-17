local M = {
    active_plugin = 1,
    resize = true,
    cursorcolumn = false,
    cursorline = true,
    signcolumn = false,
    colorcolumn = false,
    colorcolumn_width = 80,
    number = false,
    relativenumber = false,
    hybridnumber = false,
    winhighlight = false,
    blacklist_ft = {
        "ctrlspace",
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
        "dapui_watches"
    },
    blacklist_bt = {
        "nofile"
    }
}

return M
