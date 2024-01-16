" autoload/task_fix
" Created: 230806 10:34:24 by clem@spectre
" Updated: 230806 10:34:24 by clem@spectre
" Maintainer: Clément Vidon

"   @brief  Connect time1 of the current task with time2 of the previous one,
"           or time2 of the current task with time1 of the next one

" function! task_fix#(option)
"     let cursor_line = getline('.')
"     let cursor_pos = getpos('.')
"     normal 0
"     if a:option == "down" && getline(search('.') + 1) =~ '^[-~+=] \d\d\d\d\d\d \d\d:\d\d \d\d:\d\d .'
"         let down_line = getline(search('.') + 1)
"         let down_time = substitute(down_line, '^[-~+=] \d\d\d\d\d\d \d\d:\d\d \d\d:\d\d\zs.*', '', 'e')
"         let down_time = substitute(down_time, '^[-~+=] \d\d\d\d\d\d \d\d:\d\d \ze\d\d:\d\d', '', 'e')
"         let new_line = substitute(cursor_line, '^[-~+=] \d\d\d\d\d\d \zs\d\d:\d\d\ze.', down_time, 'e')
"         call setline('.', new_line)
"     elseif a:option == "up" && getline(search('.') - 1) =~ '^[-~+=] \d\d\d\d\d\d \d\d:\d\d .'
"         let up_line = getline(search('.') - 1)
"         let up_time = substitute(up_line, '^[-~+=] \d\d\d\d\d\d \d\d:\d\d\zs.*', '', 'e')
"         let up_time = substitute(up_time, '^[-~+=] \d\d\d\d\d\d \ze\d\d:\d\d', '', 'e')
"         let new_line = substitute(cursor_line, '^[-~+=] \d\d\d\d\d\d \d\d:\d\d \zs\d\d:\d\d\ze.', up_time, 'e')
"         call setline('.', new_line)
"     else
"         return 1
"     endif
"     call setpos('.', cursor_pos)
"     echo "Timestamp fixed"
"     return 0
" endfunction

function! task_fix#(option)
    let curr_pos = getpos('.')

    let curr_lnum = line('.')
    let curr_task = getline(curr_lnum)
    if curr_task !~ 's\d\d\d\d\d\d\s\d\d:\d\d\s' && curr_lnum == line('$')
        echo "task_fix: No timestamp found"
        return 0
    endif

    if a:option == "down"
        " For each line between the next one and last one


        if getline(curr_lnum) =~ '^[-~=] \d\{6} \d\d:\d\d ' " - 000000 00:00 00:00 task
            for lnum in range(curr_lnum + 1, line('$'))
                " Get the content of the current line
                let prev_task = getline(lnum)
                " Check if there is a timestamp '00:00 00:00'
                if prev_task =~ ' \d\{6} \d\d:\d\d \d\d:\d\d '
                    " Update current task starting time with the previous task ending time
                    let prev_task_time = matchstr(prev_task, ' \d\{6} \d\d:\d\d \zs\d\d:\d\d\ze ')
                    let new_curr_task = substitute(curr_task, ' \d\{6} \zs\d\d:\d\d\ze ', prev_task_time, '')
                    call setline(curr_lnum, new_curr_task)
                    break
                endif
            endfor

        elseif getline(curr_lnum) =~ '^  [-~=] \d\d:\d\d ' " - 00:00 00:00 task
            let upper_line = getline(search('.') - 1)
            let upper_time = substitute(upper_line, '^[-~+=] \d\d:\d\d\zs.*', '', 'e')
            let upper_time = substitute(upper_time, '^[-~+=] \ze\d\d:\d\d', '', 'e')
            let new_line = substitute(curr_line, '^[-~+=] \d\d:\d\d \zs\d\d:\d\d\ze.', upper_time, 'e')
            call setline('.', new_line)
        endif

        call setpos('.', curr_pos)
        echo "task_fix: Timestamp fixed"
        return 0
endfunction
