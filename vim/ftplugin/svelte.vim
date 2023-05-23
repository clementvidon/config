" @filename  svelte.vim
" @created   230522 19:52:35  by  clem9nt@imac
" @updated   230522 19:52:35  by  clem9nt@imac
" @author    Clément Vidon

"   options


setlocal autoindent
setlocal expandtab
setlocal formatprg="prettier --stdin-filepath %"
setlocal shiftwidth=2
setlocal softtabstop=2
setlocal tabstop=2
setlocal textwidth=80

let maplocalleader="gh"


"   mappings


nn <silent><buffer> <LocalLeader> <nop>

"   clean
nn <silent><buffer> <LocalLeader>= Mmmgo=G:silent! :%s/\s\+$//e<CR>`mzz3<C-O>

"   format
nn <silent><buffer> <LocalLeader>f gq
