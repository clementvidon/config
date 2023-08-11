" autoload/toggle_navigation
" Created: 230731 14:07:51 by clem@spectre
" Updated: 230731 14:07:51 by clem@spectre
" Maintainer: Clément Vidon

" Brief:  Use the same commands for all your navigation needs.  Define
" 'navleaders' the navigation commands and call 'toggle_nav' with the new wanted
" behavior for these navleaders, each call to 'toggle_nav' will toggle
" 'navleaders' between their default vim behavior and the custom one, the one
" given as a parameter. ( bufnext, bufprev, cnext, cprev… )
" Usage: :call toggle_nav#(':bnext', ':bprev')

" Set nav leaders
let s:navleader_next = 'gn'
let s:navleader_prev = 'gp'

" Check if a command has a custom mapping.

function! HasCustomMapping(cmd) abort
    let mapping = maparg(a:cmd, 'n')
    if !empty(mapping)
        return 1
    endif
    return 0
endfunction

" Toggle navleaders between their default behavior and the one passed in
" argument.

function! toggle_nav#(cmd_next, cmd_prev) abort
    " Check if the command has a custom mapping
    if HasCustomMapping(s:navleader_next) || HasCustomMapping(s:navleader_prev)
        execute 'silent! nunmap' s:navleader_next
        execute 'silent! nunmap' s:navleader_prev
        echo "Custom nav ( " a:cmd_next a:cmd_prev " ) OFF"
    else
        execute 'nnoremap' s:navleader_next a:cmd_next '<CR>'
        execute 'nnoremap' s:navleader_prev a:cmd_prev '<CR>'
        echo "Custom nav ( gn / gp ) ON"
    endif
endfunction
