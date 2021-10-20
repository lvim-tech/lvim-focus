if !has('nvim-0.5') || exists('g:loaded_lvimfocus') | finish | endif

let s:save_cpo = &cpo
set cpo&vim

let &cpo = s:save_cpo
unlet s:save_cpo

set winminwidth=15

let g:loaded_lvimfocus = 1
