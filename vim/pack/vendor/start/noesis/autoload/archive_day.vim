" autoload/archive_day
" Created: 230806 10:39:15 by clem@spectre
" Updated: 230823 21:19:27 by clem@spectre
" Maintainer: Clément Vidon

"   @brief  Daily Schedule

function! AppendSchedule(option)

    if a:option == "temp"
        call append(line('$'), '')

        "" bda 231109
        call append(line('$'), '- ( 21:05 21:20 ) self_rel: exercise ( stretch )')
        call append(line('$'), '- ( 20:45 21:00 ) work_env: update achiever')
        call append(line('$'), '- ( 19:45 20:45 ) life_env: clear X notes')
        call append(line('$'), '- ( 19:00 19:45 ) fam_rela: dine with moupou')
        call append(line('$'), '- ( 17:00 19:00 ) maingoal: @42/exam06 study')
        call append(line('$'), '- ( 16:40 17:00 ) self_rel: chill ( snack )')
        call append(line('$'), '- ( 14:00 16:40 ) maingoal: @employment X')
        call append(line('$'), '- ( 13:40 14:00 ) self_rel: meditate ( cardiac coherence )')
        call append(line('$'), '- ( 12:40 13:35 ) life_env: clear X notes')
        call append(line('$'), '- ( 12:00 12:40 ) fam_rela: lunch with moupou')
        call append(line('$'), '- ( 11:45 12:00 ) life_env: prepare')
        call append(line('$'), '- ( 11:15 11:45 ) self_rel: exercise ( workout )')
        call append(line('$'), '- ( 10:00 11:10 ) sidework: study svelte')
        call append(line('$'), '- ( 08:00 10:00 ) sidework: study nestjs')
        call append(line('$'), '- ( 07:50 08:00 ) work_env: update achiever journal')
        call append(line('$'), "- ( 07:00 07:45 ) sidework: read l'analyse transactionnelle")
        call append(line('$'), '- ( 06:45 06:55 ) self_rel: exercise ( stretch )')
        call append(line('$'), '- TODO 22:30 06:45 life_env: sleep')

        "" home paris
        " call append(line('$'), '- ( 20:30 21:00 ) self_rel: exercise ( stretch )')
        " call append(line('$'), '- ( 20:30 20:30 ) work_env: update achiever journal and schedule')
        " call append(line('$'), '- ( 19:30 20:00 ) self_rel: read X')
        " call append(line('$'), '- ( 19:00 19:30 ) life_env: cook')
        " call append(line('$'), '- ( 14:00 19:00 ) maingoal: @employment X')
        " call append(line('$'), '- ( 13:40 14:00 ) self_rel: meditate ( cardiac coherence )')
        " call append(line('$'), '- ( 13:00 13:40 ) maingoal: @employment X')
        " call append(line('$'), '- ( 12:30 13:00 ) self_rel: read X')
        " call append(line('$'), '- ( 12:00 12:30 ) life_env: cook')
        " call append(line('$'), '- ( 08:00 12:00 ) maingoal: @42/exam06 study')
        " call append(line('$'), '- ( 07:50 08:00 ) work_env: update achiever journal')
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
        "call append(line('$'), '- ( 07:00 07:45 ) sidework: read X')
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
        call append(line('$'), '- ( 20:20 20:50 ) sidework: study transactional analysis + dine')
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
    call append(line('$'), 'TODAY')
    call append(line('$'), '================================================================================')
    call append(line('$'), '')
    call append(line('$'), 'TODO SLEEP ->>>')
    call append(line('$'), '  Sleep            Duration  : --:--')
    call append(line('$'), '  Dreams           Keywords  : -')
    call append(line('$'), '  Sleep Quality    Level     : 5')
    call append(line('$'), '  Self Sabotaging  Keywords  : -')
    call append(line('$'), '  Env Constraints  Keywords  : -')
    call append(line('$'), '<<<-')
    call append(line('$'), 'TODO LIFE MORNING BEGIN ->>>')
    call append(line('$'), '  Mood             Level     : 5')
    call append(line('$'), '  Stress           Level     : 5')
    call append(line('$'), '  Wellbeing        Level     : 5')
    call append(line('$'), 'TODO WORK MORNING END')
    call append(line('$'), '  Focus            Level     : 5')
    call append(line('$'), '  Mental Strength  Level     : 5')
    call append(line('$'), '  Productivity     Level     : 5')
    call append(line('$'), '  Self Sabotaging  Keywords  : -')
    call append(line('$'), '  Env Constraints  Keywords  : -')
    call append(line('$'), '<<<-')
    call append(line('$'), 'TODO LIFE AFTERNOON BEGIN ->>>')
    call append(line('$'), '  Mood             Level     : 5')
    call append(line('$'), '  Stress           Level     : 5')
    call append(line('$'), '  Wellbeing        Level     : 5')
    call append(line('$'), 'TODO WORK AFTERNOON END')
    call append(line('$'), '  Focus            Level     : 5')
    call append(line('$'), '  Mental Strength  Level     : 5')
    call append(line('$'), '  Productivity     Level     : 5')
    call append(line('$'), '  Self Sabotaging  Keywords  : -')
    call append(line('$'), '  Env Constraints  Keywords  : -')
    call append(line('$'), '<<<-')
    call append(line('$'), 'TODO REPORT ->>>')
    call append(line('$'), '')
    call append(line('$'), '  Daily Advice: -')
    call append(line('$'), '')
    call append(line('$'), '  Daily Report:')
    call append(line('$'), '  - --:--')
    call append(line('$'), '')
    call append(line('$'), '  Sport Report:')
    call append(line('$'), '  - ventral sheathing :')
    call append(line('$'), '  - bicycle kick      :')
    call append(line('$'), '  - push ups          :')
    call append(line('$'), '  - flexions          :')
    call append(line('$'), '  - kicks             :')
    call append(line('$'), '  - wheel             :')
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

    let l:today_loc = searchpos('^TODAY$')[0]
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

    let l:today_loc = searchpos('^TODAY$')[0]
    let l:tmrrw_loc = searchpos('^TOMORROW$')[0]
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
