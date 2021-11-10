if !has('nvim-0.5') || exists('g:loaded_lvimfocus')
    finish
endif
let g:loaded_lvimfocus = 1

command! LvimFocusToggle lua require'lvim-focus'.toggle()
command! LvimRestoreEnableCurrent lua require'lvim-focus'.restore_enable_current()
