local M = {
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
        "qf"
    },
    blacklist_bt = {
        "nofile"
    }
}

return M
