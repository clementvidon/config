" ftdetect/noesis
" Created: 230524 20:44:12 by clem9nt@imac
" Updated: 230524 20:44:12 by clem9nt@imac
" Maintainer: Clément Vidon

function! SetNoesisFiletype()
    if expand('%:t') =~# '^(history|todo)\.md$'
        setlocal filetype=noesis.note
    else
        setlocal filetype=noesis.todo
    endif
endfunction

autocmd BufRead,BufNewFile *.md call SetNoesisFiletype()
