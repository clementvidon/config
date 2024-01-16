" autoload/sanity_check
" Created: 240113 12:23:20 by clem@spectre
" Updated: 240113 12:23:20 by clem@spectre
" Maintainer: Clément Vidon (clemedon)

"   @brief  Check that a chunk of text corresponding to pending tasks to do is
"           less than 50 lines

function! sanity_check#(start, end)
    let view = winsaveview()
    let beg_line = search(a:start)
    let end_line = search(a:end)
    if beg_line > 0 && end_line > 0 && (end_line - beg_line - 2) > 50
        echohl WarningMsg | echo "CLEAN UP " . a:start . " SECTION!" | echohl None
    endif
    call winrestview(view)
endfunction
