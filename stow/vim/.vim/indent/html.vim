" @filename  html.vim
" @created   230522 18:07:29  by  clem9nt@imac
" @updated   230522 18:07:29  by  clem9nt@imac
" @author    Clément Vidon

if &filetype ==# 'html'

"   options


setlocal shiftwidth=2
setlocal tabstop=2
setlocal formatprg="tidy -q -w -i --show-warnings 0 --show-errors 0 --tidy-mark no"


endif " prevent vim from loading this config for related filetypes (markdown)
