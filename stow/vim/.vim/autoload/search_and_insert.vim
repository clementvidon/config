" autoload/search_and_insert
" Created: 231114 15:07:16 by clem@spectre
" Updated: 231114 15:07:16 by clem@spectre
" Maintainer: Clément Vidon

" TODO locate lines matching a pattern and insert a new string into it.

" :call search_and_insert#()
function! search_and_insert#()
    " Start from the first line
    let currentline = 1
    let tomatch = "+.*PHP"
    let toinsert = " fichierpatient"

    while currentline <= line("$")
        if getline(currentline) =~# tomatch
            let linecontent = getline(currentline)
            if linecontent !~# toinsert
                let modifiedline = linecontent . repeat(' ', 15 - len(linecontent)) . toinsert
                " Set the modified line in the buffer
                call setline(currentline, modifiedline)
            endif
        endif
        let currentline += 1
    endwhile
endfunction
