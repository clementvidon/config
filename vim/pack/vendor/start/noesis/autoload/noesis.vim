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

    " - 000000 11:11 22:22  => - 000000 11:11 33:33
    if line =~ '\s\{0,1}[-~] \d\{6} \d\d:\d\d \d\d:\d\d .'
        call setline('.', substitute(getline('.'), '\s\{0,1}[-~] \d\{6} \d\d:\d\d \zs\d\d:\d\d\ze .', timestamp, ''))
        " - 11:11           => - 000000 11:11 22:22
    elseif line =~ '^\s\{0,1}[-~] \d\d:\d\d .'
        call setline('.', substitute(getline('.'), '\s\{0,1}[-~] \d\d:\d\d\zs \ze.', ' ' . timestamp . ' ', ''))
        call setline('.', substitute(getline('.'), '\s\{0,1}[-~]\zs \ze\d\d:\d\d .', ' ' . datestamp . ' ', ''))
        " - (Whatever)      => - 11:11
    elseif line =~ '^\s\{0,1}[-~] (.*) .'
        call setline('.', substitute(line, '^\s\{0,1}[-~] \zs(.*)\ze .', timestamp, ''))
        " -                 => - 11:11
    elseif line =~ '^\s\{0,1}[-~] .'
        normal 0
        call setline('.', substitute(getline('.'), '\s\{0,1}[-~]\zs \ze.', ' ' . timestamp . ' ', ''))
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

    " call append(line('$'), '- 21:00 read book / listen podcast / sleep')
    " call append(line('$'), '- 20:50 21:00 meditate')
    " call append(line('$'), '- 20:40 20:50 @noesis/todo evening report')
    " call append(line('$'), '- 19:40 20:40 misc')
    " call append(line('$'), ' - TODO')
    " call append(line('$'), '- 19:00 19:40 dine with moupou')
    " call append(line('$'), '- 14:00 19:00 @42/ft_irc TODO')
    " call append(line('$'), '- 13:50 14:00 meditate')
    " call append(line('$'), '- 12:40 13:50 misc')
    " call append(line('$'), ' - TODO')
    " call append(line('$'), '- 12:00 12:40 lunch with moupou')
    " call append(line('$'), '- 11:20 12:00 warmup / run { TODO } / stretch / prepare')
    " call append(line('$'), '- 07:00 11:20 @42/ft_irc TODO')
    " call append(line('$'), '- 06:50 07:00 @noesis/todo fill morning report')
    " call append(line('$'), '- 06:40 06:50 meditate')
    " call append(line('$'), '- 06:00 06:40 get up / breakfast + read book')

    " home

    call append(line('$'), '- 21:00 read magazine / listen podcast / sleep')
    call append(line('$'), '- 20:50 21:00 meditate')
    call append(line('$'), '- 20:40 20:50 @noesis/todo evening report')
    call append(line('$'), '- 19:00 20:40 cook / dine / misc')
    call append(line('$'), ' - TODO')
    call append(line('$'), '- 14:00 19:00 @42/ft_irc TODO')
    call append(line('$'), '- 13:50 14:00 meditate')
    call append(line('$'), '- 12:00 13:50 cook / lunch / misc')
    call append(line('$'), ' - TODO')
    call append(line('$'), '- 08:00 12:00 @42/ft_irc TODO')
    call append(line('$'), '- 07:50 08:00 @noesis/todo fill morning report')
    call append(line('$'), '- 07:40 07:50 meditate')
    call append(line('$'), '- 06:40 07:40 warmup / run { TODO } / stretch / prepare')
    call append(line('$'), '- 06:00 07:40 get up / breakfast + read book')

    "  42

    " call append(line('$'), '- 21:00 listen podcast / sleep')
    " call append(line('$'), '- 20:50 21:00 meditate')
    " call append(line('$'), '- 20:40 20:50 @noesis/todo evening report')
    " call append(line('$'), '- 18:30 20:40 cook / dine / misc')
    " call append(line('$'), ' - TODO')
    " call append(line('$'), '- 17:45 18:30 move to home')
    " call append(line('$'), '- 13:45 17:45 @42/ft_irc TODO')
    " call append(line('$'), '- 13:10 13:45 move to 42')
    " call append(line('$'), '- 13:00 13:10 meditate')
    " call append(line('$'), '- 12:00 13:00 cook / lunch / read book')
    " call append(line('$'), '- 08:00 12:00 @42/ft_irc TODO')
    " call append(line('$'), '- 07:50 08:00 @noesis/todo fill morning report')
    " call append(line('$'), '- 07:40 07:50 meditate')
    " call append(line('$'), '- 06:40 07:40 warmup / run { TODO } / stretch / prepare')
    " call append(line('$'), '- 06:00 06:40 get up / breakfast + read book')

    "   Set Today
    call append(line('$'), '')
    call append(line('$'), '##  Today')
    call append(line('$'), '')
    call append(line('$'), 'intakes')
    call append(line('$'), '- morning:')
    call append(line('$'), '- noonday:')
    call append(line('$'), '- daytime:')
    call append(line('$'), '- evening:')
    call append(line('$'), '')
    call append(line('$'), 'morning report')
    call append(line('$'), '- life:')
    call append(line('$'), '- work:')
    call append(line('$'), '- psyc:')
    call append(line('$'), '- soma:')
    call append(line('$'), '')
    call append(line('$'), 'evening report')
    call append(line('$'), '- life:')
    call append(line('$'), '- work:')
    call append(line('$'), '- psyc:')
    call append(line('$'), '- soma:')
    call append(line('$'), '')

    call append(line('$'), l:tmrrw_content)
    call winrestview(l:save_view)
    call setpos('.', cursor_pos)
    write
    return 0
endfunction
