" ftdetect/noesis
" Created: 230524 20:44:12 by clem9nt@imac
" Updated: 241008 12:26:21 by clem@spectre
" Maintainer: Clément Vidon

function! SetNoesisFiletype()
    setlocal filetype=noesis
endfunction

autocmd BufRead,BufNewFile *.noe call SetNoesisFiletype()
