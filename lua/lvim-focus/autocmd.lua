local config = require("lvim-focus.config")
local utils = require("lvim-focus.utils")

local M = {}

function M.enable()
    local blacklist = utils.serialize(config.blacklist_ft)
    local autocmds = {}

    if config.resize then
        autocmds["lvim_focus_resize"] = {
            {
                "WinEnter,BufEnter,BufWinEnter,TabEnter,BufLeave,WinLeave,WinClosed,BufDelete,VimResized",
                "*",
                'lua vim.schedule(function() require"lvim-focus.resizer".resize() end)'
            }
        }
    end

    if config.signcolumn then
        autocmds["lvim_focus_signcolumn"] = {
            {"BufEnter,WinEnter", "*", 'if index(luaeval("' .. blacklist .. '"), &ft) < 0 | setlocal signcolumn=yes'},
            {"BufLeave,WinLeave", "*", 'if index(luaeval("' .. blacklist .. '"), &ft) < 0 | setlocal signcolumn=no'}
        }
    end

    if config.cursorline then
        autocmds["lvim_focus_cursorline"] = {
            {"BufEnter,WinEnter", "*", 'if index(luaeval("' .. blacklist .. '"), &ft) < 0 | setlocal cursorline'},
            {"BufLeave,WinLeave", "*", 'if index(luaeval("' .. blacklist .. '"), &ft) < 0 | setlocal nocursorline'}
        }
    end

    if config.cursorcolumn then
        autocmds["lvim_focus_cursorcolumn"] = {
            {"BufEnter,WinEnter", "*", 'if index(luaeval("' .. blacklist .. '"), &ft) < 0 | setlocal cursorcolumn'},
            {"BufLeave,WinLeave", "*", 'if index(luaeval("' .. blacklist .. '"), &ft) < 0 | setlocal nocursorcolumn'}
        }
    end

    if config.colorcolumn then
        autocmds["lvim_focus_colorcolumn"] = {
            {
                "BufEnter,WinEnter",
                "*",
                'if index(luaeval("' .. blacklist .. '"), &ft) < 0 | setlocal colorcolumn=' .. config.colorcolumn_width
            },
            {"BufLeave,WinLeave", "*", 'if index(luaeval("' .. blacklist .. '"), &ft) < 0 | setlocal colorcolumn=0'}
        }
    end

    if config.number then
        autocmds["lvim_focus_number"] = {
            {"BufEnter,WinEnter", "*", 'if index(luaeval("' .. blacklist .. '"), &ft) < 0 | setlocal number'},
            {"BufLeave,WinLeave", "*", 'if index(luaeval("' .. blacklist .. '"), &ft) < 0 | setlocal nonumber'}
        }
    end

    if config.relativenumber then
        autocmds["lvim_focus_relativenumber"] = {
            {
                "BufEnter,WinEnter",
                "*",
                'if index(luaeval("' .. blacklist .. '"), &ft) < 0 | setlocal nonumber relativenumber'
            },
            {
                "BufLeave,WinLeave",
                "*",
                'if index(luaeval("' .. blacklist .. '"), &ft) < 0 | setlocal nonumber norelativenumber'
            }
        }
    end

    if config.hybridnumber then
        autocmds["lvim_focus_hybridnumber"] = {
            {
                "BufEnter,WinEnter",
                "*",
                'if index(luaeval("' .. blacklist .. '"), &ft) < 0 | setlocal number relativenumber'
            },
            {
                "BufLeave,WinLeave",
                "*",
                'if index(luaeval("' .. blacklist .. '"), &ft) < 0 | setlocal nonumber norelativenumber'
            }
        }
    end

    -- prevent add number to TelescopePrompt
    autocmds["focus_telescope_prompt"] = {
        {"FileType", "TelescopePrompt", "set nonumber norelativenumber"}
    }

    utils.create_augroups(autocmds)
end

function M.disable()
    local autocmds = {}

    autocmds["lvim_focus_signcolumn"] = {}
    autocmds["lvim_focus_cursorline"] = {}
    autocmds["lvim_focus_cursorcolumn"] = {}
    autocmds["lvim_focus_colorcolumn"] = {}
    autocmds["lvim_focus_number"] = {}
    autocmds["lvim_focus_relativenumber"] = {}
    autocmds["lvim_focus_hybridnumber"] = {}
    autocmds["lvim_focus_resize"] = {}
    autocmds["focus_telescope_prompt"] = {}

    utils.create_augroups(autocmds)
end

function M.restore_enable()
    local blacklist = utils.serialize(config.blacklist)
    if config.signcolumn then
        vim.cmd([[windo if index(luaeval("]] .. blacklist .. [["), &ft) < 0 | setlocal signcolumn=no]])
    end

    if config.cursorline then
        vim.cmd([[windo if index(luaeval("]] .. blacklist .. [["), &ft) < 0 | setlocal nocursorline]])
    end

    if config.cursorcolumn then
        vim.cmd([[windo if index(luaeval("]] .. blacklist .. [["), &ft) < 0 | setlocal nocursorcolumn]])
    end

    if config.colorcolumn then
        vim.cmd([[windo if index(luaeval("]] .. blacklist .. [["), &ft) < 0 | setlocal nocursorcolumn]])
    end

    if config.number then
        vim.cmd([[windo if index(luaeval("]] .. blacklist .. [["), &ft) < 0 | setlocal nonumber]])
    end

    if config.relativenumber then
        vim.cmd([[windo if index(luaeval("]] .. blacklist .. [["), &ft) < 0 | setlocal norelativenumber]])
    end

    if config.hybridnumber then
        vim.cmd([[windo if index(luaeval("]] .. blacklist .. [["), &ft) < 0 | setlocal nonumber norelativenumber]])
    end
end

function M.restore_enable_current()
    local blacklist = utils.serialize(config.blacklist)
    if config.signcolumn then
        vim.cmd([[if index(luaeval("]] .. blacklist .. [["), &ft) < 0 | setlocal signcolumn=yes]])
    end

    if config.cursorline then
        vim.cmd([[if index(luaeval("]] .. blacklist .. [["), &ft) < 0 | setlocal cursorline]])
    end

    if config.cursorcolumn then
        vim.cmd([[if index(luaeval("]] .. blacklist .. [["), &ft) < 0 | setlocal cursorcolumn]])
    end

    if config.colorcolumn then
        vim.cmd(
            [[if index(luaeval("]] ..
                blacklist .. [["), &ft) < 0 | setlocal colorcolumn=]] .. config.colorcolumn_width .. [[]]
        )
    end

    if config.number then
        vim.cmd([[if index(luaeval("]] .. blacklist .. [["), &ft) < 0 | setlocal number]])
    end

    if config.relativenumber then
        vim.cmd([[if index(luaeval("]] .. blacklist .. [["), &ft) < 0 | setlocal relativenumber]])
    end

    if config.hybridnumber then
        vim.cmd([[if index(luaeval("]] .. blacklist .. [["), &ft) < 0 | setlocal number relativenumber]])
    end
end

function M.restore_disable()
    local blacklist = utils.serialize(config.blacklist)
    if config.signcolumn then
        vim.cmd([[windo if index(luaeval("]] .. blacklist .. [["), &ft) < 0 | setlocal signcolumn=yes]])
    end

    if config.cursorline then
        vim.cmd([[windo if index(luaeval("]] .. blacklist .. [["), &ft) < 0 | setlocal cursorline]])
    end

    if config.cursorcolumn then
        vim.cmd([[windo if index(luaeval("]] .. blacklist .. [["), &ft) < 0 | setlocal cursorcolumn]])
    end

    if config.colorcolumn then
        vim.cmd(
            [[windo if index(luaeval("]] ..
                blacklist .. [["), &ft) < 0 | setlocal colorcolumn=]] .. config.colorcolumn_width .. [[]]
        )
    end

    if config.number then
        vim.cmd([[windo if index(luaeval("]] .. blacklist .. [["), &ft) < 0 | setlocal number]])
    end

    if config.relativenumber then
        vim.cmd([[windo if index(luaeval("]] .. blacklist .. [["), &ft) < 0 | setlocal relativenumber]])
    end

    if config.hybridnumber then
        vim.cmd([[windo if index(luaeval("]] .. blacklist .. [["), &ft) < 0 | setlocal number relativenumber]])
    end
end

return M
