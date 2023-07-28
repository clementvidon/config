" @filename  c.vim
" @created   230522 18:00:31  by  clem9nt@imac
" @updated   230522 18:02:48  by  clem9nt@imac
" @author    Clément Vidon

if &filetype ==# 'c'

"   options


setlocal autoindent
setlocal cindent
setlocal expandtab
setlocal formatoptions=tcrqjnp
setlocal formatprg="clang-format --style=file"
setlocal makeprg="make --no-print-directory --jobs -C " . fnamemodify(findfile('Makefile', '.;'), ":h") . " $*"
setlocal shiftwidth=2
setlocal softtabstop=2
setlocal tabstop=2
setlocal textwidth=80


endif " prevent vim from loading this config for related filetypes
