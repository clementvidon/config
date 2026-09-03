" autoload/header
" Created: 230524 19:37:48 by clem9nt@imac
" Updated: 230529 16:50:36 by clem9nt@imac
" Maintainer: Clément Vidon (clemedon)

function header#()
    let cmmt = &commentstring
    let user = trim(system('whoami')) . "@" . trim(system('hostname'))
    let date = strftime('%y%m%d')
    silent! call append(line("0"), "")
    silent! call append(line("0"), substitute(cmmt, '%s', ' Author: Clément Vidon (clementvidon)', ''))
    silent! call append(line("0"), substitute(cmmt, '%s', ' Updated: ' . date, ''))
    silent! call append(line("0"), substitute(cmmt, '%s', ' Created: ' . date, ''))
    silent! call append(line("0"), substitute(cmmt, '%s', ' ' . expand('%:p:h:t') . '/' . expand('%:t:r') . ' ', ''))
endfunction
