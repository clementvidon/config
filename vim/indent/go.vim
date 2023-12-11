" indent/go
" Created: 231205 11:18:00 by clem@spectre
" Updated: 231205 11:18:00 by clem@spectre
" Maintainer: Clément Vidon

if &filetype ==# 'go'

"   options


setlocal autoindent
setlocal cindent
setlocal expandtab
setlocal formatoptions=tcrqjnp
setlocal formatprg="gofmt"
setlocal shiftwidth=4
setlocal softtabstop=4
setlocal tabstop=4
setlocal textwidth=80


endif " prevent vim from loading this config for related filetypes
