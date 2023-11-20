" autoload/task_fix
" Created: 230806 10:34:24 by clem@spectre
" Updated: 230806 10:34:24 by clem@spectre
" Maintainer: Clément Vidon

"   @brief  Connect time1 of the current task with time2 of the previous one,
"           or time2 of the current task with time1 of the next one

function! task_fix#(option)
    let cursor_line = getline('.')
    let cursor_pos = getpos('.')
    if a:option == "down" && getline(search('.') + 1) =~ '^[-~+=] \d\d\d\d\d\d \d\d:\d\d \d\d:\d\d .'
        normal h
        let down_line = getline(search('.') + 1)
        let down_time = substitute(down_line, '^[-~+=] \d\d\d\d\d\d \d\d:\d\d \d\d:\d\d\zs.*', '', 'e')
        let down_time = substitute(down_time, '^[-~+=] \d\d\d\d\d\d \d\d:\d\d \ze\d\d:\d\d', '', 'e')
        let new_line = substitute(cursor_line, '^[-~+=] \d\d\d\d\d\d \zs\d\d:\d\d\ze.', down_time, 'e')
        call setline('.', new_line)
    elseif a:option == "up" && getline(search('.') - 1) =~ '^[-~+=] \d\d\d\d\d\d \d\d:\d\d .'
        normal h
        let up_line = getline(search('.') - 1)
        let up_time = substitute(up_line, '^[-~+=] \d\d\d\d\d\d \d\d:\d\d\zs.*', '', 'e')
        let up_time = substitute(up_time, '^[-~+=] \d\d\d\d\d\d \ze\d\d:\d\d', '', 'e')
        let new_line = substitute(cursor_line, '^[-~+=] \d\d\d\d\d\d \d\d:\d\d \zs\d\d:\d\d\ze.', up_time, 'e')
        call setline('.', new_line)
    else
        return 1
    endif
    call setpos('.', cursor_pos)
    echo "Timestamp fixed"
    return 0
endfunction
