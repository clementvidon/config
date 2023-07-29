" ftdetect/noesis
" Created: 230524 20:44:12 by clem9nt@imac
" Updated: 230524 20:44:12 by clem9nt@imac
" Maintainer: Clément Vidon

function! SetNoesisFiletype()
    if expand('%:t') =~# '^\(history\.gpg\|todo\)\.noe$'
        setlocal filetype=noesis.todo
    else
        setlocal filetype=noesis.note
    endif
endfunction

autocmd BufRead,BufNewFile *.noe call SetNoesisFiletype()
