" autoload/eatchar
" Created: 230524 19:35:24 by clem9nt@imac
" Updated: 230524 19:35:24 by clem9nt@imac
" Maintainer: Clément Vidon
" See: vim -c 'helpgrep Eatchar'

function eatchar#(pat)
    let c = nr2char(getchar(0))
    return (c =~ a:pat) ? '' : c
endfunction
