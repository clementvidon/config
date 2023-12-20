" autoload/archive_day
" Created: 230806 10:39:15 by clem@spectre
" Updated: 231210 08:26:26 by clem@spectre
" Maintainer: Clément Vidon

"   @brief  Daily Schedule

function! AppendSchedule(option)

    if a:option == "temp"
        call append(line('$'), '')

        " saverne 231217 to
        call append(line('$'), '- ( 22:00 22:30 ) self_rel: exercise ( stretch )')
        call append(line('$'), '- ( 21:00 22:00 ) fam_rela: play board games with family')
        call append(line('$'), '- ( 19:30 21:00 ) fam_rela: dine with family')
        call append(line('$'), '- ( 14:30 19:30 ) maingoal: @employment/basic_saas study go and tdd ( quii go-with-tests / X )')
        call append(line('$'), '- ( 14:15 14:30 ) self_rel: meditate ( focus meditation + cardiac coherence )')
        call append(line('$'), '- ( 13:30 14:15 ) achiever: clear X notes')
        call append(line('$'), '- ( 12:30 13:30 ) fam_rela: lunch with family')
        call append(line('$'), '- ( 08:30 12:30 ) maingoal: @employment practice  ( leetcode.com / X )')
        call append(line('$'), '- ( 08:15 08:30 ) achiever: update journal ; import phone notes')
        call append(line('$'), '- ( 07:25 08:15 ) maingoal: @employment read the pragmatic programmer ( 3% )')
        call append(line('$'), '- ( 07:15 07:25 ) life_env: make breakfast')
        call append(line('$'), '- ( 07:00 07:15 ) life_env: prepare ( wash )')
        call append(line('$'), '- ( 06:45 07:00 ) self_rel: exercise ( warm-up )')
        call append(line('$'), '- TODO 22:30 06:45 life_env: sleep')

        " inna 231206 to
        " call append(line('$'), '- ( 19:30 23:00 ) soc_rela: spend time with innaraz')
        " call append(line('$'), '- ( 19:20 19:30 ) achiever: update journal')
        " call append(line('$'), '- ( 16:00 19:20 ) maingoal: @employment/basic_saas study go and tdd ( quii go-with-tests / X )')
        " call append(line('$'), '- ( 15:30 16:00 ) life_env: manage yuki ( meal, walk )')
        " call append(line('$'), '- ( 12:30 15:30 ) soc_rela: spend time with innaraz')
        " call append(line('$'), '- ( 12:00 12:30 ) life_env: prepare ( wash, dress )')
        " call append(line('$'), '- ( 09:00 12:00 ) maingoal: @employment/basic_saas study go and tdd ( quii go-with-tests / X )')
        " call append(line('$'), '- ( 08:50 09:00 ) achiever: update journal')
        " call append(line('$'), '- ( 08:15 08:50 ) life_env: make tea ; manage yuki ( meal, walk )')
        " call append(line('$'), '- ( 08:00 08:15 ) soc_rela: chill with innaraz')
        " call append(line('$'), '- TODO 23:00 08:00 life_env: sleep')

        " " home 231206 to
        " call append(line('$'), '- ( 21:00 21:30 ) self_rel: exercise ( stretch )')
        " call append(line('$'), '= ( 20:00 21:00 ) maingoal: @employment read pragmatic programmer')
        " call append(line('$'), '= ( 19:30 21:00 ) life_env: cook ; dine')
        " call append(line('$'), '- ( 19:00 19:30 ) achiever: update journal')
        " call append(line('$'), '- ( 15:30 19:00 ) maingoal: @employment/basic_saas study go and tdd ( quii go-with-tests / X )')
        " call append(line('$'), '- ( 14:30 15:30 ) maingoal: @employment apply to job offers')
        " call append(line('$'), '- ( 14:10 14:30 ) self_rel: meditate ( focus meditation + cardiac coherence )')
        " call append(line('$'), '- ( 13:00 14:10 ) achiever: clear X notes')
        " call append(line('$'), '= ( 12:30 13:00 ) maingoal: @employment read pragmatic programmer')
        " call append(line('$'), '= ( 12:10 13:00 ) life_env: cook ; lunch')
        " call append(line('$'), '- ( 12:00 12:10 ) life_env: prepare ( wash, dress )')
        " call append(line('$'), '- ( 10:30 12:00 ) maingoal: @employment practice coding challenges ( leetcode.com / X )')
        " call append(line('$'), '- ( 08:00 10:30 ) maingoal: @employment read cracking the coding interview')
        " call append(line('$'), '- ( 06:50 08:00 ) self_rel: exercise ( walk and swim )')
        " call append(line('$'), '- TODO 22:00 06:50 life_env: sleep')

    endif
endfunction

"   @brief  Journal and Metrics

function! AppendJournal()
    call append(line('$'), '')
    call append(line('$'), '')
    call append(line('$'), 'TODAY JOURNAL')
    call append(line('$'), '================================================================================')
    call append(line('$'), '')
    call append(line('$'), 'TODO METRICS->>>')
    call append(line('$'), '')
    call append(line('$'), '  -3 -2 -1  0  1  2  3')
    call append(line('$'), '   0  -  <  =  >  +  1')
    call append(line('$'), '')
    call append(line('$'), '  Night')
    call append(line('$'), '    Sleep           : X')
    call append(line('$'), '    Dreams Keywords : X')
    call append(line('$'), '    Self Sabotaging : X')
    call append(line('$'), '    Env Constraints : X')
    call append(line('$'), '')
    call append(line('$'), '  Day Start')
    call append(line('$'), '    Mood            : X')
    call append(line('$'), '    Stress          : X')
    call append(line('$'), '    Wellbeing       : X')
    call append(line('$'), '    Self Sabotaging : X')
    call append(line('$'), '    Env Constraints : X')
    call append(line('$'), '')
    call append(line('$'), '  Day End')
    call append(line('$'), '    Mood            : X')
    call append(line('$'), '    Stress          : X')
    call append(line('$'), '    Wellbeing       : X')
    call append(line('$'), '    Self Sabotaging : X')
    call append(line('$'), '    Env Constraints : X')
    call append(line('$'), '')
    call append(line('$'), '  Work')
    call append(line('$'), '    Focus           : X')
    call append(line('$'), '    Productivity    : X')
    call append(line('$'), '    Consistency     : X')
    call append(line('$'), '    Resilience      : X')
    call append(line('$'), '    Self Sabotaging : X')
    call append(line('$'), '    Env Constraints : X')
    call append(line('$'), '')
    call append(line('$'), '<<<-')
    call append(line('$'), 'TODO REPORTS->>>')
    call append(line('$'), '')
    call append(line('$'), '  Daily Report: X')
    call append(line('$'), '')
    call append(line('$'), '  Daily Advice: X')
    call append(line('$'), '')
    call append(line('$'), '  Sport Report:')
    call append(line('$'), '  - plank        : X')
    call append(line('$'), '  - scissor kick : X')
    call append(line('$'), '  - flexion      : X')
    call append(line('$'), '  - push up      : X')
    call append(line('$'), '  - high kick    : X')
    call append(line('$'), '')
    call append(line('$'), '<<<-')
endfunction

"   @brief  Archive Today into history and set Today with Tomorrow tasks.

function! archive_day#(schedule) " cf. todo.vim
    if expand('%:t:r') . '.' . expand('%:e') != 'todo.noe'
        return 1
    endif
    let cursor_pos = getpos('.')
    let l:save_view = winsaveview()

    "   Insert the dates

    let l:today_loc = searchpos('^TODAY JOURNAL$')[0]
    call append(l:today_loc + 1, strftime('%a %d %b %Y'))
    call append(l:today_loc + 2, '================================================================================')
    let l:today_content = getline(l:today_loc + 2, line('$'))

    "   Archive today

    write
    exec 'silent edit ' . expand('%:p:h') . '/history.gpg.noe'
    if search('^#       JOURNAL HISTORY$', 'n') == 0
        echo "Encrypted file, archive aborted."
        return
    endif
    call append(search('^#       JOURNAL HISTORY$', 'n'), l:today_content)
    call append(search('^#       JOURNAL HISTORY$', 'n'), '')
    write
    exec 'silent edit #'

    "   Save Tomorrow content

    let l:today_loc = searchpos('^TODAY JOURNAL$')[0]
    let l:tmrrw_loc = searchpos('^TOMORROW SCHEDULE$')[0]
    let l:tmrrw_content = getline(l:tmrrw_loc + 2, l:today_loc - 3)

    "   Delete Today and Tomorrow

    exec 'silent ' . (l:tmrrw_loc + 2) . ',$delete'

    "   Set Tomorrow

    call AppendSchedule(a:schedule)

    "   Set Today

    call AppendJournal()
    call append(line('$'), l:tmrrw_content)
    call winrestview(l:save_view)
    call setpos('.', cursor_pos)
    write
    return 0
endfunction
