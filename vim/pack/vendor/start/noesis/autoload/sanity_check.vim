" autoload/sanity_check
" Created: 230816 15:44:00 by clem@spectre
" Updated: 230816 15:44:00 by clem@spectre
" Maintainer: Clément Vidon

"   @brief  Check that After section is less than 50 lines

function! sanity_check#after()
    let view = winsaveview()
    let after_line = search("^LATER$")
    let tomorrow_line = search("^TOMORROW$")
    if after_line > 0 && tomorrow_line > 0 && (tomorrow_line - after_line - 2) > 50
        echohl WarningMsg | echo "CLEAN UP YOUR TO-DO LIST!" | echohl None
    endif
    call winrestview(view)
endfunction
