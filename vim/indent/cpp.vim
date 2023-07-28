" @filename  cpp.vim
" @created   230522 18:02:54  by  clem9nt@imac
" @updated   230522 18:02:58  by  clem9nt@imac
" @author    Clément Vidon

if &filetype ==# 'cpp'

"   options


setlocal autoindent
setlocal cindent
setlocal expandtab
setlocal formatoptions=tcrqjnp
setlocal formatprg="clang-format --style=file"
setlocal shiftwidth=2
setlocal softtabstop=2
setlocal tabstop=2
setlocal textwidth=80


endif " prevent vim from loading this config for related filetypes
