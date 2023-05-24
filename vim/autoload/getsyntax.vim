" autoload/getsyntax
" Created: 230524 19:36:41 by clem9nt@imac
" Updated: 230524 19:36:41 by clem9nt@imac
" Maintainer: Clément Vidon
" See: vim -c 'help syntax'

function s:getSyntaxID()
    return synID(line('.'), col('.'), 1)
endfunction
function s:getSyntaxParentID()
    return synIDtrans(s:getSyntaxID())
endfunction
function getsyntax#()
    echo synIDattr(s:getSyntaxID(), 'name')
    execute "highlight ".synIDattr(s:getSyntaxParentID(), 'name')
endfunction
