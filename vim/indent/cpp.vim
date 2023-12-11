" indent/cpp
" Created: 231205 11:18:02 by clem@spectre
" Updated: 231205 11:18:02 by clem@spectre
" Maintainer: Clément Vidon

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
