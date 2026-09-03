" @filename  motoko.vim
" @created   230522 18:23:04  by  clem9nt@imac
" @updated   230522 18:23:04  by  clem9nt@imac
" @author    Clément Vidon

"   options


setlocal autoindent
setlocal cindent
setlocal expandtab
setlocal formatprg="mo-fmt %"
setlocal makeprg="make --no-print-directory --jobs -C " . fnamemodify(findfile('Makefile', '.;'), ":h") . " $*"
setlocal shiftwidth=2
setlocal softtabstop=2
setlocal tabstop=2
setlocal textwidth=80
