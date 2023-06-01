" init/command
" Created: 230524 19:45:01 by clem9nt@imac
" Updated: 230524 19:45:01 by clem9nt@imac
" Maintainer: Clément Vidon

"   search without moving cursor position
command! -nargs=+ -bar StaticSearch execute ":let @/=expand('<args>')" | set hlsearch | redraw!

"   sudo write
command! W :execute ':silent w !sudo tee %>/dev/null' | :edit!

"   bufonly
command! BufOnly execute '%bdelete | edit # | normal `"'

"   translate
command! -nargs=+ -bar Fr execute ' read! trans "<args>" -from en -to fr -brief 2> /dev/null'
command! -nargs=+ -bar En execute ' read! trans "<args>" -from fr -to en -brief 2> /dev/null'
command! -nargs=+ -bar Au execute '! clear; trans "<args>" -from fr -to en -brief 2> /dev/null -play'

"   synonym (X4s8FmmkYqgU1LIcjEBA)
command! -nargs=+ -bar Sy execute '! clear; synonym "<args>"'

"   tmux sendkey
command! -nargs=+ -bar S0 execute 'silent ! tmux send-keys -t 0 "<args>" Enter' | redraw!
