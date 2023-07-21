" --------------------------------- FUNCTIONS >>>

"   @brief  Return a HH:MM timestamp with the minutes rounded to the closest
"           multiple of 5.

function! noesis#RoundedTime()
    let time = strftime('%H:%M')
    let minutes = str2nr(split(time, ':')[1])
    let rounded_minutes = (minutes + 2) / 5 * 5
    let rounded_time = printf('%02d:%02d', str2nr(split(time, ':')[0]), rounded_minutes)
    return rounded_time
endfunction

"   @brief  Print the time difference between time1 and time2 in minutes.
"           time1 and time2 should be in the [HH:MM HH:MM] format.
"
" TODO update for the new task style:
" - 02:00 10:00 task
" - 02:00 10:00 (=08:00) task

function noesis#NoesisTimeDiff()
    let time_str = getline('.')
    let time1 = strptime('%H:%M', matchstr(time_str, '\[\zs\d\{2}:\d\{2}'))
    let time2 = strptime('%H:%M', matchstr(time_str,  '\d\{2}:\d\{2}\ze\]'))
    if time1 > time2
        let time2 += 24*60*60
    endif
    let mindiff = str2nr(strftime('%s', time2) - strftime('%s', time1)) / 60
    let new_str = substitute(time_str, '\[\d\{2}:\d\{2} \d\{2}:\d\{2}\]', '[' . mindiff . ']', 'g')
    call setline('.', new_str)
    return 0
endfunction


"   @brief  Check a task with a timestamp, the task should look like '[] i am a
"           task' and the timestamp will look like this: [00:00] if called once
"           and [00:00 00:00] if called twice.

function! noesis#NoesisTaskCheck()
    let timestamp = noesis#RoundedTime()
    let datestamp = strftime('%y%m%d')
    let cursor_pos = getpos('.')
    let line = getline('.')

    if line =~ '^[-~] \d\{6} \d\d:\d\d \d\d:\d\d .' " - 000000 11:11 22:22 task  => - 000000 11:11 33:33 task
        call setline('.', substitute(getline('.'), '^[-~] \d\{6} \d\d:\d\d \zs\d\d:\d\d\ze .', timestamp, ''))
        echom "1"

    elseif line =~ '^[-~] \d\{6} \d\d:\d\d .' "      - 000000 11:11 task        => - 000000 11:11 22:22 task
        call setline('.', substitute(getline('.'), '^[-~] \d\{6} \d\d:\d\d\zs \ze.', ' ' . timestamp . ' ', ''))
        echom "2"

    elseif line =~ '^[-~] (.*) .' "                  - ( WHATEVER ) task        => - 000000 11:11 task
        call setline('.', substitute(line, '^[-~] \zs(.*)\ze .', datestamp . ' ' . timestamp, ''))
        echom "3"

    elseif line =~ '^[-~] .' "                       - task                     => - 000000 11:11 task
        normal 0
        call setline('.', substitute(getline('.'), '^[-~]\zs \ze.', ' ' . datestamp . ' ' . timestamp . ' ', ''))
        echom "4"

    endif
    call setpos('.', cursor_pos)
endfunction


function! noesis#NoesisTaskFix(option)
    let cursor_line = getline('.')
    let cursor_pos = getpos('.')
    if a:option == "down" && getline(search('.') + 1) =~ '^[-~] \d\d\d\d\d\d \d\d:\d\d \d\d:\d\d .'
        normal h
        let down_line = getline(search('.') + 1)
        let down_time = substitute(down_line, '^[-~] \d\d\d\d\d\d \d\d:\d\d \d\d:\d\d\zs.*', '', 'e')
        let down_time = substitute(down_time, '^[-~] \d\d\d\d\d\d \d\d:\d\d \ze\d\d:\d\d', '', 'e')
        let new_line = substitute(cursor_line, '^[-~] \d\d\d\d\d\d \zs\d\d:\d\d\ze.', down_time, 'e')
        call setline('.', new_line)
    elseif a:option == "up" && getline(search('.') - 1) =~ '^[-~] \d\d\d\d\d\d \d\d:\d\d \d\d:\d\d .'
        normal h
        let up_line = getline(search('.') - 1)
        let up_time = substitute(up_line, '^[-~] \d\d\d\d\d\d \d\d:\d\d\zs.*', '', 'e')
        let up_time = substitute(up_time, '^[-~] \d\d\d\d\d\d \ze\d\d:\d\d', '', 'e')
        let new_line = substitute(cursor_line, '^[-~] \d\d\d\d\d\d \d\d:\d\d \zs\d\d:\d\d\ze.', up_time, 'e')
        call setline('.', new_line)
    else
        return 1
    endif
    call setpos('.', cursor_pos)
    echo "Timestamp fixed"
    return 0
endfunction


"   @brief  Archive Today into history and set Today with Tomorrow tasks.

function! noesis#NoesisArchiveDay()
    if expand('%:t:r') . '.' . expand('%:e') != 'todo.noe'
        return 1
    endif
    let cursor_pos = getpos('.')
    let l:save_view = winsaveview()
    "   Insert the dates
    let l:today_loc = searchpos('##  Today')[0]
    call append(l:today_loc + 1, '#[ ' . strftime('%a %d %b %Y') . ' ]')
    call append(l:today_loc + 2, '')
    let l:today_content = getline(l:today_loc + 2, line('$'))
    "   Archive today
    write
    exec 'silent edit ' . expand('%:p:h') . '/history.gpg.noe'
    call append(search('#=====================#', 'n'), '')
    call append(search('#=====================#', 'n'), l:today_content)
    write
    exec 'silent edit #'
    "   Save Tomorrow content
    let l:today_loc = searchpos('##  Today')[0]
    let l:tmrrw_loc = searchpos('##  Tomorrow')[0]
    let l:tmrrw_content = getline(l:tmrrw_loc + 2, l:today_loc - 2)
    "   Delete Today and Tomorrow
    exec 'silent ' . (l:tmrrw_loc + 2) . ',$delete'
    "   Set Tomorrow

    " bda

    " call append(line('$'), '- ( 21:00 ) read / listen podcast / sleep')
    " call append(line('$'), '- ( 20:50 21:00 ) meditate')
    " call append(line('$'), '- ( 20:40 20:50 ) @noesis/todo update')
    " call append(line('$'), '- ( 19:40 20:40 ) TODO')
    " call append(line('$'), '- ( 19:00 19:40 ) dine with moupou')
    " call append(line('$'), '- ( 14:00 19:00 ) @42/ft_irc TODO')
    " call append(line('$'), '- ( 13:50 14:00 ) meditate')
    " call append(line('$'), '- ( 12:40 13:50 ) TODO')
    " call append(line('$'), '- ( 12:00 12:40 ) lunch with moupou')
    " call append(line('$'), '- ( 11:20 12:00 ) warm up / run { TODO } / stretch / prepare')
    " call append(line('$'), '- ( 07:00 11:20 ) @42/ft_irc TODO')
    " call append(line('$'), '- ( 06:50 07:00 ) @noesis/todo update')
    " call append(line('$'), '- ( 06:40 06:50 ) meditate')
    " call append(line('$'), '- ( 06:00 06:40 ) get up / breakfast + read')

    " home

    " call append(line('$'), '- ( 21:00 ) listen podcast / sleep')
    " call append(line('$'), '- ( 20:50 21:00 ) meditate')
    " call append(line('$'), '- ( 20:40 20:50 ) @noesis/todo update')
    " call append(line('$'), '- ( 20:00 20:40 ) TODO')
    " call append(line('$'), '- ( 19:00 20:00 ) cook / dine + read')
    " call append(line('$'), '- ( 14:00 19:00 ) @42/ft_irc TODO')
    " call append(line('$'), '- ( 13:50 14:00 ) meditate')
    " call append(line('$'), '- ( 13:00 13:50 ) TODO')
    " call append(line('$'), '- ( 12:00 13:00 ) cook / lunch + read')
    " call append(line('$'), '- ( 08:30 12:00 ) @42/ft_irc TODO')
    " call append(line('$'), '- ( 08:20 08:30 ) meditate')
    " call append(line('$'), '- ( 06:40 08:20 ) workout / prepare')
    " call append(line('$'), '    * walk + read ( 20min )')
    " call append(line('$'), '    * swim        ( 30min )')
    " call append(line('$'), '    * walk + read ( 20min )')
    " call append(line('$'), '    * stretch     ( 10min )')
    " call append(line('$'), '- ( 06:30 06:40 ) @noesis/todo update')
    " call append(line('$'), '- ( 05:50 06:30 ) get up / breakfast + read')

    "  42

    call append(line('$'), '- ( 21:00 ) listen podcast / sleep')
    call append(line('$'), '- ( 20:00 21:00 ) cook / dine')
    call append(line('$'), '- ( 19:50 20:00 ) meditate')
    call append(line('$'), '- ( 19:00 19:50 ) move to home + read')
    call append(line('$'), '- ( 18:45 19:00 ) @noesis/todo update')
    call append(line('$'), '- ( 14:45 18:45 ) @42/ TODO')
    call append(line('$'), '- ( 13:45 14:45 ) @42/ TODO')
    call append(line('$'), '- ( 13:00 13:45 ) move to 42 + read')
    call append(line('$'), '- ( 12:10 13:00 ) cook / lunch + read')
    call append(line('$'), '- ( 12:00 12:10 ) @noesis/todo update')
    call append(line('$'), '- ( 08:00 12:00 ) @42/ TODO')
    call append(line('$'), '- ( 06:40 08:00 ) workout / prepare')
    call append(line('$'), '    * walk + read ( 20min )')
    call append(line('$'), '    * swim        ( 20min )')
    call append(line('$'), '    * walk + read ( 20min )')
    call append(line('$'), '    * snack + tea ( whole-grain toast, egg, greek yogurt )')
    call append(line('$'), '- ( 06:10 06:40 ) read')
    call append(line('$'), '    * snack + tea ( banana, peanut butter )')
    call append(line('$'), '- ( 06:00 06:10 ) meditate')
    call append(line('$'), '- ( 05:50 06:00 ) get up + stretch')


    "   Set Today
    call append(line('$'), '')
    call append(line('$'), '##  Today')
    call append(line('$'), '')
    call append(line('$'), '- 00to12_intake:')
    call append(line('$'), '- 12to18_intake:')
    call append(line('$'), '- 18to24_intake:')
    call append(line('$'), '')
    call append(line('$'), '- am_status: mind x body x life x work x')
    call append(line('$'), '- am_report:')
    call append(line('$'), '')
    call append(line('$'), '- pm_status: mind x body x life x work x')
    call append(line('$'), '- pm_report:')
    call append(line('$'), '')

    call append(line('$'), l:tmrrw_content)
    call winrestview(l:save_view)
    call setpos('.', cursor_pos)
    write
    return 0
endfunction
