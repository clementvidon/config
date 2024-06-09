" autoload/remindme
" Created: 240526 21:25:49 by pro@sw
" Updated: 240526 21:25:49 by pro@sw
" Maintainer: Clément Vidon (clemedon)

function! remindme#(date, message)
    let l:current_date = strftime("%y%m%d")

    " The input matches the date (240526) format
    if a:date == l:current_date
        echohl ErrorMsg
        echo a:message
        echohl None
        return
    endif

    " The input matches fully or partialy the date (Sun 26 May 2024) format
    if a:date =~ '\u'
        let l:current_date = strftime("%a %d %b %Y")
        if l:current_date =~ a:date
            echohl ErrorMsg
            echo a:message
            echohl None
        endif
    endif
endfunction
