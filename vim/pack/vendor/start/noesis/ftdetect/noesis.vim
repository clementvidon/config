" ftdetect/noesis
" Created: 230524 20:44:12 by clem9nt@imac
" Updated: 230816 15:08:19 by clem@spectre
" Maintainer: Clément Vidon

function! SetNoesisFiletype()
    if expand('%:t') =~# '^\(history\.gpg\|todo\|later\.gpg\)\.noe$'
        setlocal filetype=noesis.todo
    else
        setlocal filetype=noesis.note
    endif
endfunction

autocmd BufRead,BufNewFile *.md,*.noe call SetNoesisFiletype()
