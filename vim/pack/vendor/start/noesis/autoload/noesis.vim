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

    " [000000 11:11 22:22]
    if line =~ '^\[\d\{6} \d\{2}:\d\{2} \d\{2}:\d\{2}] '
        call setline('.', line[0:12] . ' ' . timestamp . line[19:])
        " [000000 11:11]
    elseif line =~ '^\[\d\{6} \d\{2}:\d\{2}] '
        call setline('.', line[0:12] . ' ' . timestamp . line[13:])
        " []
    elseif line =~ '^\[\] '
        normal 0
        call setline('.', '[' . datestamp . ' ' . timestamp . ']' . line[2:])
        " [Whatever 007]
    elseif line =~ '^\[.*\]\ze .'
        call setline('.', '[' . datestamp . ' ' . timestamp . ']' . substitute(line, '\[.*\]', '', ''))
    elseif line =~ '^- '
        call setline('.', '+ ' . line[2:])
    endif
    call setpos('.', cursor_pos)
endfunction

"   @brief  Recheck an already checked task:
"           00:00       -> 11:11
"           00:00 00:00 -> 00:00 11:11

function! noesis#NoesisTaskReCheck()
    let timestamp = noesis#RoundedTime()
    let datestamp = strftime('%y%m%d')
    let cursor_pos = getpos('.')
    let line = getline('.')

    if line =~ '^\[\d\{6} \d\{2}:\d\{2}] '
        call setline('.', line[0:7] . timestamp . line[13:])
    elseif line =~ '^\[\d\{6} \d\{2}:\d\{2} \d\{2}:\d\{2}] '
        call setline('.', line[0:13] . timestamp . line[19:])
    endif
    call setpos('.', cursor_pos)
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
    " exec 'silent! ' . l:today_loc . ',$s/^\[/\[' . strftime('%y%m%d') . ' /g'
    " exec 'silent! ' . l:today_loc . ',$s/ \] /\] /g'
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

    " BDA
    " call append(line('$'), '[21:00] meditate (5min) / fall asleep')
    " call append(line('$'), '[20:40] @noesis/todo update')
    " call append(line('$'), '***[19:40] 1h free***')
    " call append(line('$'), '[19:00] dine with moupou')
    " call append(line('$'), '***[14:00] 5h main***')
    " call append(line('$'), '[13:50] breath (5min)')
    " call append(line('$'), '[13:40] @noesis/todo update')
    " call append(line('$'), '***[12:40] 1h free***')
    " call append(line('$'), '[11:20] run (20min) / prepare / lunch with moupou')
    " call append(line('$'), '***[07:00] 4h main***')
    " call append(line('$'), '[06:55] @noesis/todo update')
    " call append(line('$'), '[06:00] wake up + stretch / breakfast + read / breath (5min)')

    "  42

    call append(line('$'), '[21:00] meditate / read / fall asleep')
    call append(line('$'), '[20:30] @noesis/todo update journal / prepare tomorrow')
    call append(line('$'), '[18:00] @motoko_bootcamp study + cook + dine')
    call append(line('$'), '[17:30] move to home')
    call append(line('$'), '[13:30] @42 TODO')
    call append(line('$'), '[12:30] lunch / read')
    call append(line('$'), '[08:30] @42 TODO')
    call append(line('$'), '[08:00] move to 42')
    call append(line('$'), '[07:30] workout / prepare')
    call append(line('$'), '[07:15] @noesis/todo update journal')
    call append(line('$'), '[07:00] wake up + stretch / breath')

    " call append(line('$'), '21:30] meditate / fall asleep')
    " call append(line('$'), '20:10] cook / prepare tomorrow / dine')
    " call append(line('$'), '20:00] @noesis/todo update journal')
    " call append(line('$'), '18:00] @motoko_bootcamp    TODO')
    " call append(line('$'), '17:30] move to home')
    " call append(line('$'), '13:30] @42                 TODO')
    " call append(line('$'), '12:30] lunch / read')
    " call append(line('$'), '08:30] @42                 TODO')
    " call append(line('$'), '08:00] move to 42')
    " call append(line('$'), '07:30] workout / prepare')
    " call append(line('$'), '06:30] read + drink tea / @noesis/todo update journal')
    " call append(line('$'), '06:15] wake up + stretch / breath')

    "  PARIS TODO
    " call append(line('$'), '[21:20] fall asleep')
    " call append(line('$'), '[21:10] meditate (gratitude)')
    " call append(line('$'), '[20:40] @noesis/todo clear and update')
    " call append(line('$'), '[19:40] dine + watch alfred hitchcock presents')
    " call append(line('$'), '[19:00] cook (chat with friends)')
    " call append(line('$'), '[16:15] X')
    " call append(line('$'), '[16:00] pause (move, stretch)')
    " call append(line('$'), '[14:00] X')
    " call append(line('$'), '[13:50] meditate (empty mind)')
    " call append(line('$'), '[13:40] @noesis/todo clear and update')
    " call append(line('$'), '[12:40] lunch + study icp')
    " call append(line('$'), '[12:00] cook + study icp')
    " call append(line('$'), '[11:50] prepare + listen breaking news')
    " call append(line('$'), '[11:40] workout (home) + listen tech news')
    " call append(line('$'), '[09:30] X')
    " call append(line('$'), '[09:15] pause (move, stretch)')
    " call append(line('$'), '[07:00] X')
    " call append(line('$'), '[06:50] meditate (mindfulness)')
    " call append(line('$'), '[06:30] breakfast (@noesis/todo update)')
    " call append(line('$'), '[06:20] wake up (stretch)')

    "   Set Today
    call append(line('$'), '')
    call append(line('$'), '##  Today')
    call append(line('$'), '')
    call append(line('$'), '    tracking')
    call append(line('$'), '')
    call append(line('$'), 'allergy')
    call append(line('$'), ' - other: magnesium')
    call append(line('$'), ' - snack:')
    call append(line('$'), ' - diner: anise infusion')
    call append(line('$'), ' - lunch:')
    call append(line('$'), ' - break:')
    call append(line('$'), '')
    call append(line('$'), 'workout')
    call append(line('$'), ' - warming up               3min    x1 beg')
    call append(line('$'), ' - calfraises + elastiband  2x25    x1')
    call append(line('$'), ' - bicyclecrunch            2x30    x2')
    call append(line('$'), ' - pushup                   20      x2')
    call append(line('$'), ' - legflexion + gripring    20      x2')
    call append(line('$'), ' - abs                      30      x2')
    call append(line('$'), ' - paintcanlift             20      x2')
    call append(line('$'), ' - bicyclecrunch            2x30    x2')
    call append(line('$'), ' - stretches                3min    x1 end')
    call append(line('$'), '')
    call append(line('$'), '    journal')
    call append(line('$'), '')
    call append(line('$'), 'morning')
    call append(line('$'), '- life:')
    call append(line('$'), '- work:')
    call append(line('$'), '- psyc:')
    call append(line('$'), '- soma:')
    call append(line('$'), '')
    call append(line('$'), 'evening')
    call append(line('$'), '- life:')
    call append(line('$'), '- work:')
    call append(line('$'), '- psyc:')
    call append(line('$'), '- soma:')
    call append(line('$'), '')
    call append(line('$'), '    diary')
    call append(line('$'), '')

    call append(line('$'), l:tmrrw_content)
    call winrestview(l:save_view)
    call setpos('.', cursor_pos)
    write
    return 0
endfunction
