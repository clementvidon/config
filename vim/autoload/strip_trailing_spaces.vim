" autoload/strip_trailing_spaces
" Created: 230524 19:44:01 by clem9nt@imac
" Updated: 230524 19:44:01 by clem9nt@imac
" Maintainer: Clément Vidon

function strip_trailing_spaces#()
    if !&binary && &filetype != 'diff'
        let l:view = winsaveview()
        keeppatterns %s/\s\+$//e
        call winrestview(l:view)
    endif
endfunction
