" autoload/todo
" Created: 230729 09:22:26 by clem@spectre
" Updated: 230802 15:24:00 by cvidon@paul-f5Br5s5.clusters.42paris.fr
" Maintainer: Clément Vidon

"   @brief  Return a HH:MM timestamp with the minutes rounded to the closest
"           multiple of 5.

function! todo#RoundTime()
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

function! todo#TaskCheck()
    let timestamp = todo#RoundTime()
    let datestamp = strftime('%y%m%d')
    let cursor_pos = getpos('.')
    let line = getline('.')

    if line =~ '^[-~] \d\{6} \d\d:\d\d \d\d:\d\d .' " - 000000 11:11 22:22 task  => - 000000 11:11 33:33 task
        call setline('.', substitute(getline('.'), '^[-~] \d\{6} \d\d:\d\d \zs\d\d:\d\d\ze .', timestamp, ''))

    elseif line =~ '^[-~] \d\{6} \d\d:\d\d .' "      - 000000 11:11 task        => - 000000 11:11 22:22 task
        call setline('.', substitute(getline('.'), '^[-~] \d\{6} \d\d:\d\d\zs \ze.', ' ' . timestamp . ' ', ''))

    elseif line =~ '^[-~] (.*) .' "                  - ( WHATEVER ) task        => - 000000 11:11 task
        call setline('.', substitute(line, '^[-~] \zs(.*)\ze .', datestamp . ' ' . timestamp, ''))

    elseif line =~ '^[-~] .' "                       - task                     => - 000000 11:11 task
        normal 0
        call setline('.', substitute(getline('.'), '^[-~]\zs \ze.', ' ' . datestamp . ' ' . timestamp . ' ', ''))

    endif
    call setpos('.', cursor_pos)
endfunction


function! todo#TaskFix(option)
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

function! todo#ArchiveDay()
    if expand('%:t:r') . '.' . expand('%:e') != 'todo.noe'
        return 1
    endif
    let cursor_pos = getpos('.')
    let l:save_view = winsaveview()
    "   Insert the dates
    let l:today_loc = searchpos('^TODAY$')[0]
    call append(l:today_loc + 1, strftime('%a %d %b %Y'))
    call append(l:today_loc + 2, '================================================================================')
    let l:today_content = getline(l:today_loc + 2, line('$'))
    "   Archive today
    write
    exec 'silent edit ' . expand('%:p:h') . '/history.gpg.noe'
    call append(search('^#       HISTORY$', 'n'), l:today_content)
    call append(search('^#       HISTORY$', 'n'), '')
    write
    exec 'silent edit #'
    "   Save Tomorrow content
    let l:today_loc = searchpos('^TODAY$')[0]
    let l:tmrrw_loc = searchpos('^TOMORROW$')[0]
    let l:tmrrw_content = getline(l:tmrrw_loc + 2, l:today_loc - 3)
    "   Delete Today and Tomorrow
    exec 'silent ' . (l:tmrrw_loc + 1) . ',$delete'
    "   Set Tomorrow

    " bda

    " call append(line('$'), '')
    " call append(line('$'), '- ( 20:30 ) study psycho / sleep')
    " call append(line('$'), '- ( 20:50 21:00 ) exercise ( 10min stretch )')
    " call append(line('$'), '- ( 20:30 20:50 ) update journal')
    " call append(line('$'), '- ( 19:40 20:30 ) X')
    " call append(line('$'), '- ( 19:00 19:40 ) dine')
    " call append(line('$'), '- ( 14:40 19:00 ) @42/ft_transcendence X')
    " call append(line('$'), '- ( 14:30 14:40 ) meditate ( 10min void )')
    " call append(line('$'), '- ( 12:50 14:30 ) X')
    " call append(line('$'), '- ( 12:40 12:50 ) update journal')
    " call append(line('$'), '- ( 12:00 12:40 ) lunch')
    " call append(line('$'), '- ( 11:50 12:00 ) prepare + listen to the news')
    " call append(line('$'), '- ( 11:20 11:50 ) exercise ( 5min warm-up, 20min run, 5min stretch )')
    " call append(line('$'), '- ( 07:00 11:20 ) @42/inception X')
    " call append(line('$'), '- ( 06:50 07:00 ) meditate ( 10min mindfulness )')
    " call append(line('$'), '- ( 06:10 06:50 ) study psycho')
    " call append(line('$'), '- ( 05:50 06:10 ) wake-up / exercise ( 10min warm-up )')

    " home

    call append(line('$'), '- ( 21:30 ) study psycho / sleep')
    call append(line('$'), '- ( 21:20 21:30 ) exercise ( 10min stretch )')
    call append(line('$'), '- ( 21:00 21:20 ) update journal')
    call append(line('$'), '- ( 20:30 21:00 ) dine + study psycho')
    call append(line('$'), '- ( 20:10 20:30 ) cook + study psycho')
    call append(line('$'), '- ( 20:00 20:10 ) meditate ( 10min mindfulness )')
    call append(line('$'), '- ( 14:00 20:00 ) @42 X')
    call append(line('$'), '- ( 13:50 14:00 ) meditate ( 10min void )')
    call append(line('$'), '- ( 13:00 13:50 ) lunch + study psycho')
    call append(line('$'), '- ( 12:30 13:00 ) cook  + study psycho')
    call append(line('$'), '- ( 12:20 12:30 ) prepare + study breaking news')
    call append(line('$'), '- ( 11:20 12:20 ) exercise ( 20min walk, 20min swim, 20min walk )')
    call append(line('$'), '- ( 07:00 11:20 ) @42 X')
    call append(line('$'), '- ( 06:50 07:00 ) meditate ( 10min mindfulness )')
    call append(line('$'), '- ( 06:10 06:50 ) study psycho')
    call append(line('$'), '- ( 05:50 06:10 ) wake up / exercise ( 10min warm-up )')

    "   Set Today
    call append(line('$'), '')
    call append(line('$'), '')
    call append(line('$'), 'TODAY')
    call append(line('$'), '================================================================================')
    call append(line('$'), '                                                                            ->>>')
    call append(line('$'), 'SLEEP QUALITY')
    call append(line('$'), '  Sleep Started At              Time: X')
    call append(line('$'), '  Sleep Duration                Time: X')
    call append(line('$'), '  Sleep Quality                 Rate: X')
    call append(line('$'), '')
    call append(line('$'), 'SLEEP-RELATED MENTAL RECOVERY')
    call append(line('$'), '  Mood                          Rate: X')
    call append(line('$'), '  Stress Level                  Rate: X')
    call append(line('$'), '  Anxiety Level                 Rate: X')
    call append(line('$'), '')
    call append(line('$'), 'PHYSICAL HEALTH')
    call append(line('$'), '  Night Intake     00 → 06      List: X')
    call append(line('$'), '  Morning Intake   06 → 12      List: X')
    call append(line('$'), '  Afternoon Intake 12 → 18      List: X')
    call append(line('$'), '  Evening Intake   18 → 24      List: X')
    call append(line('$'), '  Exercise                      Time: X')
    call append(line('$'), '  General Feeling               Rate: X')
    call append(line('$'), '')
    call append(line('$'), 'MENTAL HEALTH')
    call append(line('$'), '  Mood                          Rate: X')
    call append(line('$'), '  Stress Level                  Rate: X')
    call append(line('$'), '  Anxiety Level                 Rate: X')
    call append(line('$'), '')
    call append(line('$'), 'EMOTIONAL WELL-BEING')
    call append(line('$'), '  Happiness Level               Rate: X')
    call append(line('$'), '  Self Confidence               Rate: X')
    call append(line('$'), '  Social Interactions Quality   Rate: X')
    call append(line('$'), '  Mindfulness or Meditation     Time: X')
    call append(line('$'), '  Gratitude                     List: X')
    call append(line('$'), '')
    call append(line('$'), 'MAIN PROJECTS PRODUCTIVITY')
    call append(line('$'), '  Focus Quality                 Rate: X')
    call append(line('$'), '  Engagement Level              Rate: X')
    call append(line('$'), '  Main Projects                 List: X')
    call append(line('$'), '  Main Projects Development     Time: X')
    call append(line('$'), '')
    call append(line('$'), 'SIDE PROJECTS PRODUCTIVITY')
    call append(line('$'), '  Focus Quality                 Rate: X')
    call append(line('$'), '  Engagement Level              Rate: X')
    call append(line('$'), '  Side Projects                 List: X')
    call append(line('$'), '  Side Projects Development     Time: X')
    call append(line('$'), '')
    call append(line('$'), 'PERSONAL DEVELOPMENT')
    call append(line('$'), '  New Skills Development        List: X')
    call append(line('$'), '  Leisure                       List: X')
    call append(line('$'), '  Discipline Level              Rate: X')
    call append(line('$'), '  Creativity Level              Rate: X')
    call append(line('$'), '  Learning Level                Rate: X')
    call append(line('$'), '')
    call append(line('$'), 'ENVIRONMENT')
    call append(line('$'), '  Environment Development       Time: X')
    call append(line('$'), '  Living Space Cleanliness      Rate: X')
    call append(line('$'), '  Work Env Conduciveness        Rate: X')
    call append(line('$'), '')
    call append(line('$'), 'REPORT X')
    call append(line('$'), '')
    call append(line('$'), '<<<-')
    call append(line('$'), l:tmrrw_content)
    call winrestview(l:save_view)
    call setpos('.', cursor_pos)
    write
    return 0
endfunction
