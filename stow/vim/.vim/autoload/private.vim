" autoload/private
" Created: 230524 19:38:24 by clem9nt@imac
" Updated: 230524 19:38:24 by clem9nt@imac
" Maintainer: Clément Vidon
" Usage: vim -c 'call private#()'

function private#()
    set history=0
    set nobackup
    set nomodeline
    set noshelltemp
    set noswapfile
    set noundofile
    set nowritebackup
    set secure
    if has('nvim')
        set shada=""
    else
        set viminfo=""
    endif
    echom "VIM - Vi IMprivate"
endfunction
