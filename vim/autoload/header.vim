" autoload/header
" Created: 230524 19:37:48 by clem9nt@imac
" Updated: 230529 16:50:36 by clem9nt@imac
" Maintainer: Clément Vidon

function header#()
    let cmmt = &commentstring
    let user = trim(system('whoami')) . "@" . trim(system('hostname'))
    let time = strftime('%y%m%d %H:%M:%S')
    let seal = time . " by " . user
    if  (getline(2) =~ ' Created:' && getline(3) =~ ' Updated:')
        call setline(3, substitute(cmmt, '%s', ' Updated: ' . seal . ' ', ''))
        write
    else
        silent! call append(line("0"), "")
        silent! call append(line("0"), substitute(cmmt, '%s', ' Maintainer: Clément Vidon ', ''))
        silent! call append(line("0"), substitute(cmmt, '%s', ' Updated: ' . seal . ' ', ''))
        silent! call append(line("0"), substitute(cmmt, '%s', ' Created: ' . seal . ' ', ''))
        silent! call append(line("0"), substitute(cmmt, '%s', ' ' . expand('%:p:h:t') . '/' . expand('%:t:r') . ' ', ''))
    endif
endfunction
