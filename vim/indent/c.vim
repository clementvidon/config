" @filename  c.vim
" @created   230522 18:00:31  by  clem9nt@imac
" @updated   230522 18:02:48  by  clem9nt@imac
" @author    Clément Vidon

if &filetype ==# 'c'

"   options


setlocal autoindent
setlocal cindent
setlocal expandtab
" setlocal formatoptions=tcrqjnp
setlocal makeprg="make --no-print-directory --jobs -C " . fnamemodify(findfile('Makefile', '.;'), ":h") . " $*"
setlocal shiftwidth=4
setlocal softtabstop=4
setlocal tabstop=4
setlocal textwidth=120


endif " prevent vim from loading this config for related filetypes
