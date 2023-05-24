" autoload/cpp_defswap
" Created: 230524 19:34:42 by clem9nt@imac
" Updated: 230524 19:34:42 by clem9nt@imac
" Maintainer: Clément Vidon

function cpp_defswap#()
    if  (expand('%:t:r') =~# "[A-Z]")
        if match(expand('%:e'), 'cpp')
            execute 'find ' . expand("%:t:r") . '.cpp'
        elseif match(expand('%:e'), 'hpp')
            execute 'find ' . expand("%:t:r") . '.hpp'
        endif
    endif
endfunction
