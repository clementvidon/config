" autoload/archive_day
" Created: 230806 10:39:15 by clem@spectre
" Updated: 231210 08:26:26 by clem@spectre
" Maintainer: Clément Vidon

"   @brief  Daily Schedule

function! AppendSchedule(option)

    if a:option == "temp"
        call append(line('$'), '')

        " inna 231206 to
        call append(line('$'), '- ( 19:30 23:00 ) soc_rela: spend time with innaraz')
        call append(line('$'), '- ( 19:20 19:30 ) achiever: update journal')
        call append(line('$'), '- ( 16:00 19:20 ) maingoal: @employment/basic_saas study golang ( quii go-with-tests / X )')
        call append(line('$'), '- ( 15:30 16:00 ) life_env: take care of yuki ( meal, walk )')
        call append(line('$'), '- ( 12:30 15:30 ) soc_rela: spend time with innaraz')
        call append(line('$'), '- ( 12:00 12:30 ) life_env: prepare to go out ( shower )')
        call append(line('$'), '- ( 09:00 12:00 ) maingoal: @employment/basic_saas study golang ( quii go-with-tests / X )')
        call append(line('$'), '- ( 08:50 09:00 ) life_env: prepare to work ( tea )')
        call append(line('$'), '- ( 08:15 08:50 ) life_env: take care of yuki ( meal, walk ) & visit bakery')
        call append(line('$'), '- ( 08:00 08:15 ) soc_rela: chill with innaraz')

        " inna 231206 to 231212
        " call append(line('$'), '- ( 19:30 22:30 ) soc_rela: spend time with innaraz')
        " call append(line('$'), '- ( 19:00 19:30 ) achiever: update journal')
        " call append(line('$'), '- ( 16:30 19:00 ) maingoal: @employment/basic_saas study golang ( quii go-with-tests / X )')
        " call append(line('$'), '- ( 15:30 16:30 ) maingoal: @employment apply to job offers')
        " call append(line('$'), '- ( 12:30 15:30 ) soc_rela: spend time with innaraz')
        " call append(line('$'), '- ( 12:00 12:30 ) life_env: prepare to go out ( shower )')
        " call append(line('$'), '- ( 10:30 12:00 ) maingoal: @employment practice coding tests ( hackerrank.com / c )')
        " call append(line('$'), '- ( 08:30 10:30 ) maingoal: @employment read cracking the coding interview')
        " call append(line('$'), '- ( 08:00 08:30 ) maingoal: @employment read the pragmatic programmer')
        " call append(line('$'), '- ( 07:50 08:00 ) life_env: prepare to work ( tea )')
        " call append(line('$'), '- ( 07:40 07:50 ) soc_rela: chill with innaraz')
        " call append(line('$'), '- TODO 23:00 07:40 life_env: sleep')

        " " home 231206 to
        " call append(line('$'), '- ( 21:00 21:30 ) self_rel: exercise ( stretch )')
        " call append(line('$'), '= ( 20:00 21:00 ) maingoal: @employment read pragmatic programmer')
        " call append(line('$'), '= ( 19:30 21:00 ) life_env: cook & dine')
        " call append(line('$'), '- ( 19:00 19:30 ) achiever: update journal')
        " call append(line('$'), '- ( 15:30 19:00 ) maingoal: @employment/basic_saas study golang ( quii go-with-tests / X )')
        " call append(line('$'), '- ( 14:30 15:30 ) maingoal: @employment apply to job offers')
        " call append(line('$'), '- ( 14:10 14:30 ) self_rel: meditate ( focus meditation + cardiac coherence )')
        " call append(line('$'), '- ( 13:00 14:10 ) achiever: clear X notes')
        " call append(line('$'), '= ( 12:30 13:00 ) maingoal: @employment read pragmatic programmer')
        " call append(line('$'), '= ( 12:10 13:00 ) life_env: cook & lunch')
        " call append(line('$'), '- ( 12:00 12:10 ) life_env: prepare ( shower )')
        " call append(line('$'), '- ( 10:30 12:00 ) maingoal: @employment practice coding tests ( hackerrank.com / c )')
        " call append(line('$'), '- ( 08:00 10:30 ) maingoal: @employment read cracking the coding interview')
        " call append(line('$'), '- ( 06:50 08:00 ) self_rel: exercise ( walk and swim )')
        " call append(line('$'), '- TODO 22:00 06:50 life_env: sleep')

        "" bda 231109 to 231206
        " call append(line('$'), '- ( 21:10 21:30 ) self_rel: exercise ( stretch )')
        " call append(line('$'), '- ( 20:45 21:00 ) achiever: update journal')
        " call append(line('$'), '- ( 19:45 21:45 ) achiever: clear X notes')
        " call append(line('$'), '- ( 19:00 19:45 ) fam_rela: dine with moupou')
        " call append(line('$'), '- ( 14:00 19:00 ) maingoal: @employment X')
        " call append(line('$'), '- ( 14:10 14:30 ) self_rel: meditate ( focus meditation + cardiac coherence )')
        " call append(line('$'), '- ( 12:40 14:05 ) achiever: clear X notes')
        " call append(line('$'), '- ( 12:00 12:40 ) fam_rela: lunch with moupou')
        " call append(line('$'), '- ( 11:45 12:00 ) life_env: prepare ( shower )')
        " call append(line('$'), '- ( 11:30 11:45 ) self_rel: exercise ( workout )')
        " call append(line('$'), '- ( 08:00 11:30 ) maingoal: @employment X')
        " call append(line('$'), '- ( 07:50 08:00 ) achiever: update journal')
        " call append(line('$'), '- ( 07:10 07:45 ) maingoal: @employment read the pragmatic programmer ( 2% )')
        " call append(line('$'), '- ( 07:00 07:10 ) life_env: prepare ( workspace, tea)')
        " call append(line('$'), '- ( 06:50 07:00 ) self_rel: exercise ( warm up )')
        " call append(line('$'), '- ( 06:45 06:50 ) self_rel: chill')
        " call append(line('$'), '- TODO 22:30 06:45 life_env: sleep')

        "" home paris
        " call append(line('$'), '- ( 20:30 21:00 ) self_rel: exercise ( stretch )')
        " call append(line('$'), '- ( 20:30 20:30 ) achiever: update journal')
        " call append(line('$'), '- ( 19:30 20:00 ) self_rel: read X')
        " call append(line('$'), '- ( 19:00 19:30 ) life_env: cook')
        " call append(line('$'), '- ( 14:00 19:00 ) maingoal: @employment X')
        " call append(line('$'), '- ( 13:40 14:00 ) self_rel: meditate ( cardiac coherence )')
        " call append(line('$'), '- ( 13:00 13:40 ) maingoal: @employment X')
        " call append(line('$'), '- ( 12:30 13:00 ) self_rel: read X')
        " call append(line('$'), '- ( 12:00 12:30 ) life_env: cook')
        " call append(line('$'), '- ( 08:00 12:00 ) maingoal: @42/exam06 study')
        " call append(line('$'), '- ( 07:50 08:00 ) achiever: update achiever journal')
        " call append(line('$'), '- ( 06:50 07:50 ) self_rel: exercise ( walk and swim )')
        " call append(line('$'), '- TODO life_env: sleep')

        "" bda
        "call append(line('$'), '- ( 21:00 21:15 ) self_rel: exercise ( stretch )')
        "call append(line('$'), '- ( 20:30 21:00 ) work_env: update achiever')
        "call append(line('$'), '- ( 19:45 20:30 ) maingoal: @employment X')
        "call append(line('$'), '- ( 19:00 19:45 ) fam_rela: dine with moupou')
        "call append(line('$'), '- ( 14:00 19:00 ) maingoal: @employment X')
        "call append(line('$'), '- ( 13:40 14:00 ) self_rel: meditate ( cardiac coherence )')
        "call append(line('$'), '- ( 12:40 13:35 ) maingoal: @employment X')
        "call append(line('$'), '- ( 12:00 12:40 ) fam_rela: lunch with moupou')
        "call append(line('$'), '- ( 11:45 12:00 ) life_env: prepare')
        "call append(line('$'), '- ( 11:15 11:45 ) self_rel: exercise ( workout )')
        "call append(line('$'), '- ( 08:00 11:10 ) maingoal: @42/exam06 study')
        "call append(line('$'), '- ( 07:50 08:00 ) work_env: update achiever journal')
        "call append(line('$'), '- ( 07:00 07:45 ) self_rel: read X')
        "call append(line('$'), '- ( 06:45 06:55 ) self_rel: exercise ( stretch )')
        "call append(line('$'), '- TODO life_env: sleep')

    elseif a:option == "bda"
        call append(line('$'), '')
        call append(line('$'), '- ( 21:00 21:15 ) self_rel: exercise ( stretch )')
        call append(line('$'), '- ( 20:30 21:00 ) work_env: update achiever journal and schedule')
        call append(line('$'), '- ( 19:45 20:30 ) sidework: @employment X')
        call append(line('$'), '- ( 19:00 19:45 ) fam_rela: dine with moupou')
        call append(line('$'), '- ( 14:00 19:00 ) maingoal: @42/inception X')
        call append(line('$'), '- ( 13:50 14:00 ) self_rel: meditate ( cardiac coherence )')
        call append(line('$'), '- ( 12:45 13:45 ) sidework: @employment X')
        call append(line('$'), '- ( 12:00 12:45 ) fam_rela: lunch with moupou')
        call append(line('$'), '- ( 10:00 12:00 ) maingoal: @42/inception X')
        call append(line('$'), '- ( 09:40 10:00 ) life_env: prepare')
        call append(line('$'), '- ( 09:10 09:40 ) self_rel: exercise ( run )')
        call append(line('$'), '- ( 07:00 09:00 ) maingoal: @42/inception X')
        call append(line('$'), '- ( 06:50 07:00 ) work_env: update achiever journal')
        call append(line('$'), '- ( 06:20 06:50 ) maingoal: @42/inception study docker ( book )')
        call append(line('$'), '- ( 06:00 06:10 ) self_rel: meditate ( cardiac coherence )')
        call append(line('$'), '- ( 05:50 06:00 ) self_rel: exercise ( stretch )')
    elseif a:option == "42"
        call append(line('$'), '')
        call append(line('$'), '- ( 21:20 21:15 ) self_rel: exercise ( 15min stretch )')
        call append(line('$'), '- ( 20:50 21:20 ) work_env: update achiever journal')
        call append(line('$'), '- ( 20:20 20:50 ) self_rel: read the pragmatic programmer')
        call append(line('$'), '- ( 20:00 20:20 ) life_env: cook')
        call append(line('$'), '- ( 19:45 20:00 ) self_rel: meditate ( 10min mindfulness )')
        call append(line('$'), '- ( 19:00 19:45 ) maingoal: @42/ft_transcendence move to home')
        call append(line('$'), '- ( 14:30 19:00 ) maingoal: @42/ft_transcendence X')
        call append(line('$'), '- ( 13:45 14:30 ) maingoal: @42/ft_transcendence move to 42')
        call append(line('$'), '- ( 13:30 13:45 ) work_env: update achiever journal')
        call append(line('$'), '- ( 13:00 13:30 ) maingoal: @42/inception study docker ( book ) + lunch')
        call append(line('$'), '- ( 12:30 13:00 ) life_env: cook')
        call append(line('$'), '- ( 12:20 12:30 ) life_env: prepare')
        call append(line('$'), '- ( 11:20 12:20 ) self_rel: exercise ( 20min walk, 20min swim, 20min walk )')
        call append(line('$'), '- ( 09:20 11:20 ) maingoal: @42/inception X')
        call append(line('$'), '- ( 09:10 09:20 ) self_rel: chill')
        call append(line('$'), '- ( 07:10 09:10 ) maingoal: @42/inception X')
        call append(line('$'), '- ( 07:00 07:10 ) work_env: update achiever journal and schedule')
        call append(line('$'), '- ( 06:15 07:00 ) maingoal: @42/inception study docker ( book )')
        call append(line('$'), '- ( 06:00 06:15 ) self_rel: meditate ( 10min mindfulness )')
        call append(line('$'), '- ( 05:50 06:00 ) self_rel: exercise ( 10min stretch )')
    elseif a:option == "home"
        call append(line('$'), '')
        call append(line('$'), '- ( 21:00 21:15 ) self_rel: exercise ( stretch )')
        call append(line('$'), '- ( 20:10 21:00 ) life_env: cook and dine')
        call append(line('$'), '- ( 20:00 20:10 ) work_env: update achiever journal and schedule')
        call append(line('$'), '- ( 19:00 20:00 ) sidework: @employment X')
        call append(line('$'), '- ( 14:00 19:00 ) maingoal: @42/inception X')
        call append(line('$'), '- ( 13:40 14:00 ) self_rel: meditate ( cardiac coherence )')
        call append(line('$'), '- ( 13:30 13:40 ) work_env: update achiever journal')
        call append(line('$'), '- ( 12:30 13:30 ) life_env: cook and lunch')
        call append(line('$'), '- ( 08:00 12:30 ) maingoal: @42/inception X')
        call append(line('$'), '- ( 07:50 08:00 ) life_env: prepare')
        call append(line('$'), '- ( 06:50 07:50 ) self_rel: exercise ( walk and swim )')
        call append(line('$'), '- ( 06:10 06:50 ) maingoal: @42/inception study docker ( book )')
        call append(line('$'), '- ( 06:00 06:10 ) work_env: update achiever journal')
        call append(line('$'), '- ( 05:50 06:00 ) life_env: get up')
    elseif a:option == "dinard"
        call append(line('$'), '')
        call append(line('$'), '- ( 21:30 21:45 ) self_rel: exercise ( 15min stretch )')
        call append(line('$'), '- ( 21:00 21:30 ) work_env: update achiever journal and schedule')
        call append(line('$'), '- ( 20:00 21:00 ) fam_rela: dine with mom and adam')
        call append(line('$'), '- ( 18:00 20:00 ) maingoal: @42 X')
        call append(line('$'), '- ( 17:45 18:00 ) self_rel: chill')
        call append(line('$'), '- ( 16:00 17:45 ) maingoal: @42 X')
        call append(line('$'), '- ( 15:45 16:00 ) self_rel: chill')
        call append(line('$'), '- ( 14:00 15:45 ) maingoal: @42 X')
        call append(line('$'), '- ( 13:45 14:00 ) self_rel: meditate ( 10min void )')
        call append(line('$'), '- ( 13:00 13:45 ) fam_rela: lunch with mom and adam')
        call append(line('$'), '- ( 10:30 13:00 ) maingoal: @42 X')
        call append(line('$'), '- ( 10:20 10:30 ) self_rel: chill')
        call append(line('$'), '- ( 08:20 10:20 ) maingoal: @42 X')
        call append(line('$'), '- ( 08:05 08:20 ) life_env: prepare')
        call append(line('$'), '- ( 07:45 08:05 ) work_env: update achiever journal and schedule')
        call append(line('$'), '- ( 07:15 07:45 ) self_rel: exercise ( 30min run )')
        call append(line('$'), '- ( 06:15 07:15 ) maingoal: @42/inception study docker ( book )')
        call append(line('$'), '  * wake up adam at 06:45')
        call append(line('$'), '- ( 06:00 06:15 ) self_rel: meditate ( 10min mindfulness )')
        call append(line('$'), '- ( 05:50 06:00 ) self_rel: exercise ( 10min stretch )')
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
    call append(line('$'), '  Day Start')
    call append(line('$'), '    Sleep           : X')
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
    call append(line('$'), '  Work Feedback')
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
    call append(line('$'), '  - plank        : X ( 30s )')
    call append(line('$'), '  - scissor kick : X ( 40 )')
    call append(line('$'), '  - flexion      : X ( 20 )')
    call append(line('$'), '  - push up      : X ( 15 )')
    call append(line('$'), '  - high kick    : X ( 2x15 )')
    call append(line('$'), '  - wheel        : X ( 10 )')
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
    if search('^#       HISTORY$', 'n') == 0
        echo "Encrypted file, archive aborted."
        return
    endif
    call append(search('^#       HISTORY$', 'n'), l:today_content)
    call append(search('^#       HISTORY$', 'n'), '')
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
