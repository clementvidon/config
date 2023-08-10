" autoload/task_check
" Created: 230806 10:28:31 by clem@spectre
" Updated: 230806 10:28:31 by clem@spectre
" Maintainer: Clément Vidon

"   @brief  Return a HH:MM timestamp with the minutes rounded to the closest
"           multiple of 5.

function! RoundTime()
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

"   @brief  Check a task with a timestamp, the task should look like '[] i am a
"           task' and the timestamp will look like this: [00:00] if called once
"           and [00:00 00:00] if called twice.

function! task_check#()
    let timestamp = RoundTime()
    let datestamp = strftime('%y%m%d')
    let cursor_pos = getpos('.')
    let line = getline('.')

    if line =~ '^[-~] \d\{6} \d\d:\d\d \d\d:\d\d .' " - 000000 11:11 22:22 task => - 000000 11:11 33:33 task
        call setline('.', substitute(getline('.'), '^[-~] \d\{6} \d\d:\d\d \zs\d\d:\d\d\ze .', timestamp, ''))

    elseif line =~ '^[-~] \d\{6} \d\d:\d\d .' "      - 000000 11:11 task        => - 000000 11:11 22:22 task
        call setline('.', substitute(getline('.'), '^[-~] \d\{6} \d\d:\d\d\zs \ze.', ' ' . timestamp . ' ', ''))

    elseif line =~ '^[-~] (.\{-}) .' "                  - ( WHATEVER ) task        => - 000000 11:11 task
        call setline('.', substitute(line, '^[-~] \zs(.\{-})\ze .', datestamp . ' ' . timestamp, ''))

    elseif line =~ '^[-~] .' "                       - task                     => - 000000 11:11 task
        normal 0
        call setline('.', substitute(getline('.'), '^[-~]\zs \ze.', ' ' . datestamp . ' ' . timestamp . ' ', ''))

    endif
    call setpos('.', cursor_pos)
endfunction

