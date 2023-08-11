" @filename  javascript.vim
" @created   230522 18:11:05  by  clem9nt@imac
" @updated   230522 18:11:05  by  clem9nt@imac
" @author    Clément Vidon

"   options


setlocal indentexpr=GetTypescriptIndent()
setlocal indentkeys=0{,0},0),0],0\,,!^F,o,O,e
setlocal autoindent
setlocal expandtab
setlocal formatprg=prettier\ --stdin-filepath\ %
setlocal shiftwidth=2
setlocal softtabstop=2
setlocal tabstop=2
setlocal textwidth=80
