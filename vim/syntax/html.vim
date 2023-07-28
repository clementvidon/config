" syntax/html
" Created: 230524 19:50:59 by clem9nt@imac
" Updated: 230524 19:50:59 by clem9nt@imac
" Maintainer: Clément Vidon

if &filetype ==# 'html'

"   highlight


hi MatchParen ctermbg=darkgrey guibg=darkgrey


endif " prevent vim from loading this config for related filetypes (markdown)
