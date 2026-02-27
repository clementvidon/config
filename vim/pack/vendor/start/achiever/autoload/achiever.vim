" autoload/achiever
" Created: 230806 10:28:31 by clem@spectre
" Updated: 241008 16:37:10 by clem@spectre
" Maintainer: Clément Vidon

" SUMMARY
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" achiever#task_check() to check a task with a timestamp
" achiever#task_clear() to clear a task from its timestamp
" achiever#task_fix() to link a task timestamp to a sibling's one
" achiever#task_duration() to print the duration of a task
" achiever#task_detail#toggle_view() wrap/unwrap the task details
" achiever#task_detail#add_prefix() auto-prefix new line from task detail

" TASK CHECK
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"   @brief  Check a task with a timestamp, the task should look like '[] i am a
"           task' and the timestamp will look like this: [00:00] if called once
"           and [00:00 00:00] if called twice.

function! achiever#task_check() abort
    let cursor_pos = getpos('.')
    let timestamp = s:RoundTime()
    let datestamp = strftime('%y%m%d')
    let line = getline('.')

    " Task '- 000000 11:11 22:22 task'

    if line =~ '^- \d\{6} \d\d:\d\d \d\d:\d\d \a' " - 000000 11:11 22:22 task  => - 000000 11:11 33:33 task
        let newline = substitute(getline('.'), '^- \d\{6} \d\d:\d\d \zs\d\d:\d\d\ze.', timestamp, '')

    elseif line =~ '^- \d\{6} \d\d:\d\d \a' "       - 000000 11:11 task        => - 000000 11:11 22:22 task
        let newline = substitute(getline('.'), '^- \d\{6} \d\d:\d\d\zs \ze.', ' ' . timestamp . ' ', '')

    elseif line =~ '^- (.\{-}) \a' "                - ( 00:00 00:00 ) task     => - 000000 11:11 task
        let newline = substitute(line, '^- \zs(.\{-})\ze.', datestamp . ' ' . timestamp, '')

    elseif line =~ '^- \a' "                        - task                     => - 000000 11:11 task
        let newline = substitute(getline('.'), '^-\zs \ze.', ' ' . datestamp . ' ' . timestamp . ' ', '')

    " Sub-task '  - 11:11 22:22 sub-task'

    elseif line =~ '^  - \d\d:\d\d \d\d:\d\d \a' "  - task 11:11 22:22 task    => - 11:11 33:33 task
        let newline = substitute(getline('.'), '^  - \d\d:\d\d \zs\d\d:\d\d\ze.', timestamp, '')

    elseif line =~ '^  - \d\d:\d\d \a' "            - task 11:11               => - 11:11 22:22 task
        let newline = substitute(getline('.'), '^  - \d\d:\d\d\zs \ze.', ' ' . timestamp . ' ', '')

    elseif line =~ '^  - \a' "                      - task                     => - 11:11 task
        let newline = substitute(getline('.'), '^  -\zs \ze.', ' ' . timestamp . ' ', '')

    endif
    if exists('newline')
        call setline('.', newline)
        echom "task check: " . datestamp . " " . timestamp
    endif
    call setpos('.', cursor_pos)
endfunction

"   @brief  Return a HH:MM timestamp with the minutes rounded to the closest
"   multiple of 5.

function! s:RoundTime() abort
    let time = strftime('%H:%M')
    let hour = str2nr(split(time, ':')[0])
    let minutes = str2nr(split(time, ':')[1])
    let rounded_minutes = (minutes + 2) / 5 * 5
    let rounded_hour = hour
    if rounded_minutes >= 60
        let rounded_hour += 1
        let rounded_minutes = 0
    endif
    if rounded_hour == 24
        let rounded_hour = 0
    endif
    let rounded_time = printf('%02d:%02d', rounded_hour, rounded_minutes)
    return rounded_time
endfunction

" TASK CLEAR
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"   @brief  Uncheck a task: clear it from its timestamp.

function! achiever#task_clear() abort
    " Clear the matching patterns from the current line
    call setline('.', substitute(getline('.'), '-\zs \d\d\d\d\d\d \d\d:\d\d \d\d:\d\d\ze.', '', 'e'))
    call setline('.', substitute(getline('.'), '-\zs \d\d\d\d\d\d \d\d:\d\d\ze.', '', 'e'))
endfunction

" TASK FIX
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"   @brief  Re-link the current task's timestamp to its sibling one.
"   @param  option  The ts part of the current task to fix "time_beg" or "time_end"

function! achiever#task_fix(option) abort
    let cursor_pos = getpos('.')

    " Get the current task
    let dst_line = line('.')
    let dst_task = getline(dst_line)

    if dst_task =~ '^- \d\{6} \d\d:\d\d\( \d\d:\d\d\)\? [^0-9]'             " 000000 00:00 or 000000 00:00 00:00
        let task_ts_pattern = '^- \d\{6} \d\d:\d\d\( \d\d:\d\d\)\? '        " 000000 00:00 or 000000 00:00 00:00
        let abort_pattern = '^$'
        if a:option == "time_beg"
            let step = 1
            let src_task_pattern = '^- \d\{6} \d\d:\d\d \d\d:\d\d '         " 000000 00:00 00:00
            let src_time_pattern = '^- \d\{6} \d\d:\d\d \zs\d\d:\d\d\ze '   " 000000 00:00 <00:00>
            let dst_time_pattern = '^- \d\{6} \zs\d\d:\d\d\ze '             " 000000 <00:00>
        elseif a:option == "time_end"
            let step = -1
            let src_task_pattern = '^- \d\{6} \d\d:\d\d '                   " 000000 00:00
            let src_time_pattern = '^- \d\{6} \zs\d\d:\d\d\ze '             " 000000 <00:00>
            let dst_time_pattern = '^- \d\{6} \d\d:\d\d \zs\d\d:\d\d\ze '   " 000000 00:00 <00:00>
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

function! s:findMatchingLine(start_line, to_pattern, abort_pattern, step) abort
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

" TASK DIFF
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"   @Brief   Print the time difference between time1 and time2 in minutes. Sum
"            up the results to 's:total_difference_seconds' and print the sum at
"            each use.
"
"   @Usage   Run ':call achiever#task_duration(getline('.'))' with the cursor on
"           a line that contain a time range in this format: 'HH:MM HH:MM'.
"
"   @Example 'I am a valid range 10:58 03:09:)' gives 'This duration: 16:11'

let s:total_difference_seconds = 0

function! achiever#task_duration(line) abort
    let line = getline('.')
    let time_pair = matchstr(a:line, '\d\d:\d\d\s\d\d:\d\d')
    if (empty(time_pair))
        if s:total_difference_seconds != 0
            echo "s:total_difference_seconds = " . s:FormatSeconds(s:total_difference_seconds)
            let choice = input("No time range found. Reset total difference? y/n ")
            if tolower(choice) == 'y'
                let s:total_difference_seconds = 0
            endif
        else
            echo "No time range found in the line."
        endif
        return
    endif
    let [time1, time2] = split(time_pair)
    let timestamp1 = strptime('%H:%M', time1)
    let timestamp2 = strptime('%H:%M', time2)
    if timestamp1 > timestamp2
        let timestamp2 += 24 * 60 * 60
    endif
    let duration_seconds = timestamp2 - timestamp1
    let s:total_difference_seconds += duration_seconds

    let formatted_duration = s:FormatSeconds(duration_seconds)
    let formatted_total_difference = s:FormatSeconds(s:total_difference_seconds)

    echo "This duration: " . formatted_duration
    echo "All durations: " . formatted_total_difference
endfunction

"   @brief  Convert N seconds into NN:NN hours and minutes format.
"   @param  seconds  The seconds to convert

function! s:FormatSeconds(seconds) abort
    let hours = a:seconds / 3600
    let minutes = (a:seconds % 3600) / 60
    return printf('%02d:%02d', hours, minutes)
endfunction

" TASK DETAIL TOGGLE VIEW
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"   @Brief   Wrap/Unwrap the tasks' details.

function! achiever#task_detail_toggle_view(prefix) abort
    " Get the current line and line number
    let l:current_line = getline('.')
    let l:lnum = line('.')

    " Check if the line contains 'life:' or 'work:'
    if l:current_line =~ " work: " || l:current_line =~ " life: "
        " Check if the current line contains at least two details prefixes

        if len(split(l:current_line, ' ' . a:prefix . ' ')) > 2
            " Split the line into parts based on 'prefix'
            let l:parts = split(l:current_line, ' ' . a:prefix . ' ')

            " Replace the current line with the first part
            call setline(l:lnum, l:parts[0] . ' -- ' . l:parts[1])

            " Add each detail part as a new line below with a prefix
            if len(l:parts) > 1
                call append(l:lnum, map(l:parts[2:], {_, val -> '  ' . a:prefix . ' ' . val}))
            endif
        else
            " Otherwise, check if there are multiline details below
            let l:next_lines = []
            let l:current_lnum = l:lnum + 1
            let l:start_delete = l:current_lnum

            " Loop through the following lines until a non prefixed line is found
            while getline(l:current_lnum) =~ '^\s\+'. a:prefix . ' '
                call add(l:next_lines, substitute(getline(l:current_lnum), '^\s\+' . a:prefix . ' ', '', ''))
                let l:current_lnum += 1
            endwhile

            let l:end_delete = l:current_lnum - 1

            " Delete the lines from l:start_delete to l:end_delete
            if l:end_delete >= l:start_delete
                call deletebufline('', l:start_delete, l:end_delete)
            endif

            " Join the details and append them to the current task line
            if len(l:next_lines) > 0
                let l:joined = ' -- ' . join(l:next_lines, ' -- ')
                call setline(l:lnum, l:current_line . l:joined)
            endif

        endif
    endif
endfunction

" TASK DETAIL ADD PREFIX
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"   @Brief   Auto-prefix new line from task detail.

"   TODO handle case of a CR from the middle of a task detail.

" function! achiever#task_detail_add_prefix(prefix) abort
"     let l:current_line = getline('.')
"     l:current_line =~ " work: " || l:current_line =~ " life: "
"         let l:line = getline(line('.') - 1)
"         if l:line =~ ' ' . a:prefix . ' '
"             call setline('.', '  ' . a:prefix . ' ')
"         endif
"     endif
" endfunction
