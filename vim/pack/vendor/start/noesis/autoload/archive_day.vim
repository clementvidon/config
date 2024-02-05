" autoload/archive_day
" Created: 230806 10:39:15 by clem@spectre
" Updated: 231224 20:12:38 by clem@spectre
" Maintainer: Clément Vidon

"   @brief  Daily Schedule

function! AppendSchedule(schedule)

    if a:schedule == "temp"
        call append(line('$'), '')

        " bda + scaleway TODO

        " bda before scaleway 240204

        call append(line('$'), '- ( 20:40 21:30 ) sidework: @gea board -- daily point with mervaonu, catlic and antoninboi')
        call append(line('$'), '- ( 19:40 20:40 ) achiever: update journal')
        call append(line('$'), '- ( 19:40 21:00 ) achiever: update schedule')
        call append(line('$'), '- ( 19:00 19:40 ) life_env: dine -- with grand parents')
        call append(line('$'), '#------------------- stop')
        call append(line('$'), '- ( 14:00 19:00 ) mainwork: @scaleway get started -- X')
        call append(line('$'), '#------------------- start')
        call append(line('$'), '- ( 12:40 14:00 ) achiever: save notes -- phone')
        call append(line('$'), '- ( 12:00 12:40 ) life_env: dine -- with grand parents')
        call append(line('$'), '#------------------- stop')
        call append(line('$'), '- ( 08:00 12:00 ) mainwork: @scaleway get started -- X')
        call append(line('$'), '#------------------- start')
        call append(line('$'), '- ( 07:30 08:00 ) achiever: update journal')
        call append(line('$'), '- ( 07:00 07:30 ) life_env: prepare -- wash, dress, breakfast')
        call append(line('$'), '- ( 06:30 07:00 ) life_env: exercise -- run in the forest')
        call append(line('$'), '- ( 22:30 06:30 ) life_env: sleep')

        " paris with inna 240123
        " call append(line('$'), '- life_env: relax -- with innaraz')
        " call append(line('$'), '#------------------- stop')
        " call append(line('$'), '- achiever: update journal')
        " call append(line('$'), '- achiever: update schedule')
        " call append(line('$'), '- mainwork: X')
        " call append(line('$'), '#------------------- start')
        " call append(line('$'), '- life_env: relax -- with innaraz')
        " call append(line('$'), '- life_env: prepare -- wash, dress')
        " call append(line('$'), '#------------------- stop')
        " call append(line('$'), '- mainwork: X')
        " call append(line('$'), '- achiever: save notes -- phone')
        " call append(line('$'), '- achiever: update journal')
        " call append(line('$'), '#------------------- start')
        " call append(line('$'), '- life_env: get up')
        " call append(line('$'), '- TODO life_env: sleep')

        " saverne with innaraz and 4 days training before scaleway tech interview
        " call append(line('$'), '- ( 19:30 22:00 ) life_env: relax -- end of day')
        " call append(line('$'), '#------------------- stop')
        " call append(line('$'), '- ( 19:00 19:30 ) achiever: update journal')
        " call append(line('$'), '- ( 19:00 19:30 ) achiever: update schedule')
        " call append(line('$'), '- ( 14:30 19:00 ) mainwork: @employment X')
        " call append(line('$'), '- ( 14:30 19:00 ) mainwork: @42 X')
        " call append(line('$'), '#------------------- start')
        " call append(line('$'), '- ( 12:30 14:30 ) life_env: relax -- lunch break')
        " call append(line('$'), '#------------------- stop')
        " call append(line('$'), '- ( 07:30 12:30 ) mainwork: @employment X')
        " call append(line('$'), '- ( 07:30 12:30 ) mainwork: @42 X')
        " call append(line('$'), '- ( 07:10 07:30 ) achiever: save phone notes')
        " call append(line('$'), '- ( 07:10 07:30 ) achiever: update journal')
        " call append(line('$'), '#------------------- start')
        " call append(line('$'), '- ( 07:00 07:10 ) life_env: get up')
        " call append(line('$'), '- ( 23:00 07:00 ) TODO life_env: sleep')


        " " saverne with plaster and friends 231227 to
        " call append(line('$'), '#------------------- life_env ↓')
        " call append(line('$'), '- ( 21:00 23:00 ) life_env: chill with X')
        " call append(line('$'), '- ( 19:30 21:00 ) life_env: dine with X')
        " call append(line('$'), '#------------------- achiever ↓')
        " call append(line('$'), '- ( 19:00 19:30 ) achiever: clear journal')
        " call append(line('$'), '- ( 19:00 19:30 ) achiever: update journal')
        " call append(line('$'), '- ( 19:00 19:30 ) achiever: update schedule')
        " call append(line('$'), '#------------------- mainwork ↓')
        " call append(line('$'), '- ( 15:00 19:00 ) mainwork: @employment X')
        " call append(line('$'), '#------------------- life_env ↓')
        " call append(line('$'), '- ( 12:45 15:00 ) life_env: lunch with family')
        " call append(line('$'), '#------------------- mainwork ↓')
        " call append(line('$'), '- ( 10:45 12:45 ) mainwork: @employment X')
        " call append(line('$'), '- ( 10:00 10:45 ) life_env: chill with innaraz')
        " call append(line('$'), '- ( 07:45 10:00 ) mainwork: @employment X')
        " call append(line('$'), '#------------------- achiever ↓')
        " call append(line('$'), '- ( 07:20 07:45 ) achiever: save phone notes')
        " call append(line('$'), '- ( 07:20 07:45 ) achiever: update journal')
        " call append(line('$'), '#------------------- life_env ↓')
        " call append(line('$'), '- ( 07:00 07:20 ) life_env: prepare ( wash )')
        " call append(line('$'), '- TODO 22:30 06:00 life_env: sleep')

        " " saverne with plaster 231217 to
        " call append(line('$'), '#------------------- life_env ↓')
        " call append(line('$'), '- ( 21:00 22:00 ) life_env: chill with family')
        " call append(line('$'), '- ( 20:00 21:00 ) life_env: dine with family')
        " call append(line('$'), '- ( 19:30 20:00 ) life_env: chill with family')
        " call append(line('$'), '#------------------- achiever ↓')
        " call append(line('$'), '- ( 19:00 19:30 ) achiever: update journal')
        " call append(line('$'), '- ( 19:00 19:30 ) achiever: update schedule')
        " call append(line('$'), '- ( 19:00 19:30 ) achiever: clear journal')
        " call append(line('$'), '#------------------- mainwork ↓')
        " call append(line('$'), '- ( 14:00 19:00 ) mainwork: @employment practice go and tdd ( leetcode / X )')
        " call append(line('$'), '- ( 14:00 19:00 ) mainwork: @employment study dsa ( neetcode / X )')
        " call append(line('$'), '#------------------- life_env ↓')
        " call append(line('$'), '- ( 13:40 14:00 ) life_env: meditate ( cardiac coherence + introspection )')
        " call append(line('$'), '- ( 12:45 13:40 ) life_env: lunch with family')
        " call append(line('$'), '#------------------- mainwork ↓')
        " call append(line('$'), '- ( 07:45 12:45 ) mainwork: @employment/basic_saas study go and tdd ( quii go-with-tests / X )')
        " call append(line('$'), '#------------------- achiever ↓')
        " call append(line('$'), '- ( 07:30 07:45 ) achiever: save phone notes')
        " call append(line('$'), '- ( 07:30 07:45 ) achiever: update journal')
        " call append(line('$'), '#------------------- life_env ↓')
        " call append(line('$'), '- ( 07:10 07:30 ) life_env: prepare ( wash )')
        " call append(line('$'), '- ( 06:50 07:10 ) life_env: exercise ( stretch, warm-up )')
        " call append(line('$'), '- TODO 22:30 06:45 life_env: sleep')

        " " saverne with innaraz 231217 to 231223
        " call append(line('$'), '- ( 21:00 22:30 ) life_env: chill with innaraz')
        " call append(line('$'), '- ( 20:00 21:00 ) life_env: dine with family')
        " call append(line('$'), '- ( 19:00 20:00 ) life_env: chill with innaraz')
        " call append(line('$'), '- ( 14:00 19:00 ) mainwork: @employment study go and tdd ( quii go-with-tests / X )')
        " call append(line('$'), '- ( 13:45 14:00 ) life_env: meditate ( focus meditation + cardiac coherence )')
        " call append(line('$'), '- ( 13:15 13:45 ) achiever: clear X notes')
        " call append(line('$'), '- ( 12:30 13:15 ) life_env: lunch with family')
        " call append(line('$'), '- ( 07:45 12:30 ) mainwork: @employment study dsa ( neetcode / X )')
        " call append(line('$'), '- ( 07:30 07:45 ) achiever: update journal ; save phone notes')
        " call append(line('$'), '- ( 07:20 07:30 ) life_env: make breakfast')
        " call append(line('$'), '- ( 07:05 07:20 ) life_env: prepare ( wash )')
        " call append(line('$'), '- ( 06:45 07:05 ) life_env: exercise ( warm-up )')
        " call append(line('$'), '- TODO 22:30 06:45 life_env: sleep')

        " " saverne 231217 to
        " call append(line('$'), '- ( 22:00 22:15 ) life_env: exercise ( stretch )')
        " call append(line('$'), '- ( 21:00 22:00 ) life_env: play board games with family')
        " call append(line('$'), '- ( 19:30 21:00 ) life_env: dine with family')
        " call append(line('$'), '- ( 14:30 19:30 ) mainwork: @employment study go and tdd ( quii go-with-tests / X )')
        " call append(line('$'), '- ( 14:15 14:30 ) life_env: meditate ( focus meditation + cardiac coherence )')
        " call append(line('$'), '- ( 13:30 14:15 ) achiever: clear X notes')
        " call append(line('$'), '- ( 12:30 13:30 ) life_env: lunch with family')
        " call append(line('$'), '- ( 08:30 12:30 ) mainwork: @employment practice competitive programming ( leetcode / X )')
        " call append(line('$'), '- ( 08:15 08:30 ) achiever: update journal ; save phone notes')
        " call append(line('$'), '- ( 07:25 08:15 ) mainwork: @employment read the pragmatic programmer ( 3% )')
        " call append(line('$'), '- ( 07:15 07:25 ) life_env: make breakfast')
        " call append(line('$'), '- ( 07:00 07:15 ) life_env: prepare ( wash )')
        " call append(line('$'), '- ( 06:45 07:00 ) life_env: exercise ( warm-up )')
        " call append(line('$'), '- TODO 22:30 06:45 life_env: sleep')

        " " inna 231206 to
        " call append(line('$'), '- ( 19:30 23:00 ) life_env: spend time with innaraz')
        " call append(line('$'), '- ( 19:20 19:30 ) achiever: update journal')
        " call append(line('$'), '- ( 16:00 19:20 ) mainwork: @employment study go and tdd ( quii go-with-tests / X )')
        " call append(line('$'), '- ( 15:30 16:00 ) life_env: manage yuki ( meal, walk )')
        " call append(line('$'), '- ( 12:30 15:30 ) life_env: spend time with innaraz')
        " call append(line('$'), '- ( 12:00 12:30 ) life_env: prepare ( wash, dress )')
        " call append(line('$'), '- ( 09:00 12:00 ) mainwork: @employment study go and tdd ( quii go-with-tests / X )')
        " call append(line('$'), '- ( 08:50 09:00 ) achiever: update journal')
        " call append(line('$'), '- ( 08:15 08:50 ) life_env: make tea ; manage yuki ( meal, walk )')
        " call append(line('$'), '- ( 08:00 08:15 ) life_env: chill with innaraz')
        " call append(line('$'), '- TODO 23:00 08:00 life_env: sleep')

        " " home 231206 to
        " call append(line('$'), '- ( 21:00 21:30 ) life_env: exercise ( stretch )')
        " call append(line('$'), '= ( 20:00 21:00 ) mainwork: @employment read pragmatic programmer')
        " call append(line('$'), '= ( 19:30 21:00 ) life_env: cook ; dine')
        " call append(line('$'), '- ( 19:00 19:30 ) achiever: update journal')
        " call append(line('$'), '- ( 15:30 19:00 ) mainwork: @employment study go and tdd ( quii go-with-tests / X )')
        " call append(line('$'), '- ( 14:30 15:30 ) mainwork: @employment apply to job offers')
        " call append(line('$'), '- ( 14:10 14:30 ) life_env: meditate ( focus meditation + cardiac coherence )')
        " call append(line('$'), '- ( 13:00 14:10 ) achiever: clear X notes')
        " call append(line('$'), '= ( 12:30 13:00 ) mainwork: @employment read pragmatic programmer')
        " call append(line('$'), '= ( 12:10 13:00 ) life_env: cook ; lunch')
        " call append(line('$'), '- ( 12:00 12:10 ) life_env: prepare ( wash, dress )')
        " call append(line('$'), '- ( 10:30 12:00 ) mainwork: @employment practice competitive programming ( leetcode / X )')
        " call append(line('$'), '- ( 08:00 10:30 ) mainwork: @employment read cracking the coding interview')
        " call append(line('$'), '- ( 06:50 08:00 ) life_env: exercise ( walk and swim )')
        " call append(line('$'), '- TODO 22:00 06:50 life_env: sleep')

    endif
endfunction

"   @brief  Journal and Metrics

function! AppendJournal()
    call append(line('$'), '')
    call append(line('$'), '')
    call append(line('$'), 'TODAY')
    call append(line('$'), '================================================================================')
    call append(line('$'), '')
    call append(line('$'), 'JOURNAL->>>')
    call append(line('$'), '')
    call append(line('$'), '  MIN -2 -1  0  1  2  MAX')
    call append(line('$'), '    0  -  <  =  >  +  1')
    call append(line('$'), '')
    call append(line('$'), '  Last Night')
    call append(line('$'), '    Falling Ease    : X')
    call append(line('$'), '    Sleep Quality   : X')
    call append(line('$'), '    Awakening Ease  : X')
    call append(line('$'), '    Dreams Loudness : X')
    call append(line('$'), '    Self Sabotaging : X')
    call append(line('$'), '    Env Constraints : X')
    call append(line('$'), '')
    call append(line('$'), '    Comments: X')
    call append(line('$'), '')
    call append(line('$'), '  First Keystrokes')
    call append(line('$'), '    At              : X')
    call append(line('$'), '    Mood            : X')
    call append(line('$'), '    Stress          : X')
    call append(line('$'), '    Wellness        : X')
    call append(line('$'), '    Self Sabotaging : X')
    call append(line('$'), '    Env Constraints : X')
    call append(line('$'), '')
    call append(line('$'), '    Comments: X')
    call append(line('$'), '')
    call append(line('$'), '  Last Keystrokes')
    call append(line('$'), '    At              : X')
    call append(line('$'), '    Mood            : X')
    call append(line('$'), '    Stress          : X')
    call append(line('$'), '    Wellness        : X')
    call append(line('$'), '    Self Sabotaging : X')
    call append(line('$'), '    Env Constraints : X')
    call append(line('$'), '')
    call append(line('$'), '    Comments: X')
    call append(line('$'), '')
    call append(line('$'), '  Work Day')
    call append(line('$'), '    Focus           : X')
    call append(line('$'), '    Mental          : X')
    call append(line('$'), '    Productivity    : X')
    call append(line('$'), '    Self Sabotaging : X')
    call append(line('$'), '    Env Constraints : X')
    call append(line('$'), '')
    call append(line('$'), '    Comments: X')
    call append(line('$'), '')
    call append(line('$'), '  Thoughts: X')
    call append(line('$'), '')
    call append(line('$'), '  Advices: X')
    call append(line('$'), '')
    call append(line('$'), '<<<-')
endfunction

"   @brief  Archive Today journal and set Today with Tomorrow tasks.

function! archive_day#(schedule) " cf. achiever.vim
    if expand('%:t:r') . '.' . expand('%:e') != 'achiever.noe'
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
