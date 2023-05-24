" autoload/qf_nav
" Created: 230524 19:42:20 by clem9nt@imac
" Updated: 230524 19:42:20 by clem9nt@imac
" Maintainer: Clément Vidon

let s:qfnav=1
function qf_nav#()
    if s:qfnav
        echo "Use Up and Down arrows to cycle the Quickfix list."
        nn <Up> :cprev<CR>
        nn <Down> :cnext<CR>
    else
        echo "QF Nav disabled."
        unmap <Up>
        unmap <Down>
    endif
    let s:qfnav = !s:qfnav
endfunction
