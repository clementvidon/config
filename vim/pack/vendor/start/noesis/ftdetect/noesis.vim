" ftdetect/noesis
" Created: 230524 20:44:12 by clem9nt@imac
" Updated: 230816 15:08:19 by clem@spectre
" Maintainer: Clément Vidon

function! SetNoesisFiletype()
    setlocal filetype=noesis
endfunction

autocmd BufRead,BufNewFile *.md,*.noe call SetNoesisFiletype()
