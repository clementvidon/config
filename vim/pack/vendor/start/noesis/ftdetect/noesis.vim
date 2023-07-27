" ftdetect/noesis
" Created: 230524 20:44:12 by clem9nt@imac
" Updated: 230524 20:44:12 by clem9nt@imac
" Maintainer: Clément Vidon

au BufRead,BufNewFile *.noe set filetype=noesis.note
au BufRead,BufNewFile *.md set filetype=noesis.note

au BufRead,BufNewFile todo.noe set filetype=noesis.todo
au BufRead,BufNewFile history.noe set filetype=noesis.todo
