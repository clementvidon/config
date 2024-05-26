" autoload/task_fix
" Created: 230806 10:34:24 by clem@spectre
" Updated: 230806 10:34:24 by clem@spectre
" Maintainer: Clément Vidon

"   @brief  Return the position of the next line matching the given pattern
"
"   This function is used to find the next line matching a given pattern within
"   the same paragraph (until the first emptyline encountered). It can be used
"   to find a sibling task by passing it a pattern that identify this task.
"
"   @param  from_line     The line number to start searching from
"   @param  to_pattern    The pattern to search for (regex)
"   @param  abort_pattern Pattern that abort the searching encountered (regex)
"   @param  step          Step size for searching, can be negative.
"   @return The line number of the next matching line, or 0 if no match is found
"
"   @note   Don't forget that if the pattern match the current line, this one
"           will be returned.

function! s:findMatchingLine(start_line, to_pattern, abort_pattern, step)
    let line = a:start_line
    " Loop through lines in function of the step
    while line >= 1 && line <= line('$')
        " Check if the line matches the wanted pattern
        if getline(line) =~ a:to_pattern
            return line
        elseif getline(line) =~ a:abort_pattern
            break
        endif
        " Move to the next line
        let line += a:step
    endwhile

    " Return 0 if no match is found
    return 0
endfunction

"   @brief  Re-link the current task's timestamp to its sibling one.
"   @param  option  The ts part of the current task to fix "time_beg" or "time_end"

function! task_fix#(option)
    let cursor_pos = getpos('.')

    " Get the current task
    let dst_line = line('.')
    let dst_task = getline(dst_line)

    " Super-tasks (bottom-top)
    if dst_task =~ '^[-~=*] \d\{6} \d\d:\d\d\( \d\d:\d\d\)\? [^0-9]'          " 000000 00:00 or 000000 00:00 00:00
        let task_ts_pattern = '^[-~=*] \d\{6} \d\d:\d\d\( \d\d:\d\d\)\? ' " 000000 00:00 or 000000 00:00 00:00
        let abort_pattern = '^$'
        if a:option == "time_beg"
            let step = 1
            let src_task_pattern = '^[-~=*] \d\{6} \d\d:\d\d \d\d:\d\d '       " 000000 00:00 00:00
            let src_time_pattern = '^[-~=*] \d\{6} \d\d:\d\d \zs\d\d:\d\d\ze ' " 000000 00:00 <00:00>
            let dst_time_pattern = '^[-~=*] \d\{6} \zs\d\d:\d\d\ze '           " 000000 <00:00>
        elseif a:option == "time_end"
            let step = -1
            let src_task_pattern = '^[-~=*] \d\{6} \d\d:\d\d '                 " 000000 00:00
            let src_time_pattern = '^[-~=*] \d\{6} \zs\d\d:\d\d\ze '           " 000000 <00:00>
            let dst_time_pattern = '^[-~=*] \d\{6} \d\d:\d\d \zs\d\d:\d\d\ze ' " 000000 00:00 <00:00>
        endif
    " Sub-tasks (top-bottom)
    elseif dst_task =~ '^  [-~=*] \d\d:\d\d\( \d\d:\d\d\)\? [^0-9]'           " 00:00 or 00:00 00:00
        let task_ts_pattern = '^  [-~=*] \d\d:\d\d\( \d\d:\d\d\)\? '        " 00:00 or 00:00 00:00
        let abort_pattern = '\(^$\|^#\)'
        if a:option == "time_beg"
            let step = -1
            let src_task_pattern = '^  [-~=*] \d\d:\d\d \d\d:\d\d '              " 00:00 00:00
            let src_time_pattern = '^  [-~=*] \d\d:\d\d \zs\d\d:\d\d\ze '        " 00:00 <00:00>
            let dst_time_pattern = '^  [-~=*] \zs\d\d:\d\d\ze '                  " <00:00>
        elseif a:option == "time_end"
            let step = 1
            let src_task_pattern = '^  [-~=*] \d\d:\d\d '                        " 00:00
            let src_time_pattern = '^  [-~=*] \zs\d\d:\d\d\ze '                  " <00:00>
            let dst_time_pattern = '^  [-~=*] \d\d:\d\d \zs\d\d:\d\d\ze '        " 00:00 <00:00>
        endif
    else
        echo "task_fix: The current line is not a valid task."
    endif

    if exists('step')
        " Find the sibling task
        let src_task_line = s:findMatchingLine(dst_line + step, src_task_pattern, abort_pattern, step)
        let src_task = getline(src_task_line)
        if src_task_line == 0
            echo "task_fix: Close sibling note found for this task."
            return 1
        endif
        " Replace the ts part of the current task with the ts part from the src task
        let src_time  = matchstr(src_task, src_time_pattern)
        let dst_time  = matchstr(dst_task, dst_time_pattern)
        if src_time == dst_time
            echo "task_fix: Nothing to be done."
            return 1
        endif
        let new_curr_task = substitute(dst_task, dst_time, src_time, '')
        " Replace the old line with the new one
        call setline('.', new_curr_task)
        echom "task_fix: " . matchstr(new_curr_task, task_ts_pattern)
    endif
    call setpos('.', cursor_pos)
endfunction
