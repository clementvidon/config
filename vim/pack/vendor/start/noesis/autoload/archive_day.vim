" autoload/archive_day
" Created: 230806 10:39:15 by clem@spectre
" Updated: 230823 21:19:27 by clem@spectre
" Maintainer: Clément Vidon

"   @brief  Daily Schedule

function! AppendSchedule(option)
    if a:option == "bda"
        call append(line('$'), '')
        call append(line('$'), '- ( 21:40 21:50 ) self_rel: exercise ( 10min stretch )')
        call append(line('$'), '- ( 20:50 21:40 ) sidework: study transactional analysis')
        call append(line('$'), '- ( 20:40 20:50 ) achiever: update journal')
        call append(line('$'), '- X')
        call append(line('$'), '- ( 19:45 20:15 ) achiever: update journal')
        call append(line('$'), '- ( 19:00 19:45 ) fam_rela: dine with moupou')
        call append(line('$'), '- maingoal: @42 X')
        call append(line('$'), '- ( 16:45 17:00 ) self_rel: chill')
        call append(line('$'), '- maingoal: @42 X')
        call append(line('$'), '- ( 13:45 14:00 ) self_rel: meditate ( 10min void )')
        call append(line('$'), '- X')
        call append(line('$'), '- ( 12:40 13:00 ) achiever: update journal')
        call append(line('$'), '- ( 12:00 12:40 ) fam_rela: lunch with moupou')
        call append(line('$'), '- ( 11:50 12:00 ) self_rel: prepare')
        call append(line('$'), '- ( 11:20 11:50 ) self_rel: exercise ( 30min run )')
        call append(line('$'), '- ( 11:10 11:20 ) self_rel: chill')
        call append(line('$'), '- maingoal: @42 X')
        call append(line('$'), '- ( 09:00 09:05 ) self_rel: chill')
        call append(line('$'), '- maingoal: @42 X')
        call append(line('$'), '- ( 06:55 07:05 ) achiever: update journal')
        call append(line('$'), '- ( 06:15 06:55 ) sidework: study transactional analysis')
        call append(line('$'), '- ( 06:00 06:15 ) self_rel: meditate ( 10min mindfulness )')
        call append(line('$'), '- ( 05:50 06:00 ) self_rel: exercise ( 10min warm-up )')
    elseif a:option == "home"
        call append(line('$'), '')
        call append(line('$'), '- ( 21:20 21:15 ) self_rel: exercise ( 15min stretch )')
        call append(line('$'), '- ( 20:50 21:20 ) achiever: update journal')
        call append(line('$'), '- ( 20:20 20:50 ) sidework: study transactional analysis + dine')
        call append(line('$'), '- ( 20:00 20:20 ) life_env: cook')
        call append(line('$'), '- ( 19:45 20:00 ) self_rel: meditate ( 10min mindfulness )')
        call append(line('$'), '- maingoal: @42 X')
        call append(line('$'), '- ( 17:45 18:00 ) self_rel: chill')
        call append(line('$'), '- maingoal: @42 X')
        call append(line('$'), '- ( 15:45 16:00 ) self_rel: chill')
        call append(line('$'), '- maingoal: @42 X')
        call append(line('$'), '- ( 13:45 14:00 ) self_rel: meditate ( 10min void )')
        call append(line('$'), '- ( 13:30 13:45 ) achiever: update journal')
        call append(line('$'), '- ( 13:00 13:30 ) sidework: study transactional analysis + lunch')
        call append(line('$'), '- ( 12:30 13:00 ) life_env: cook')
        call append(line('$'), '- ( 12:20 12:30 ) self_rel: prepare')
        call append(line('$'), '- ( 11:20 12:20 ) self_rel: exercise ( 20min walk, 20min swim, 20min walk )')
        call append(line('$'), '- maingoal: @42 X')
        call append(line('$'), '- ( 09:10 09:20 ) self_rel: chill')
        call append(line('$'), '- maingoal: @42 X')
        call append(line('$'), '- ( 07:00 07:10 ) achiever: update journal')
        call append(line('$'), '- ( 06:15 07:00 ) sidework: study transactional analysis')
        call append(line('$'), '- ( 06:00 06:15 ) self_rel: meditate ( 10min mindfulness )')
        call append(line('$'), '- ( 05:50 06:00 ) self_rel: exercise ( 10min warm-up )')
    elseif a:option == "dinard"
        call append(line('$'), '')
        call append(line('$'), '- ( 21:30 21:45 ) self_rel: exercise ( 15min stretch )')
        call append(line('$'), '- ( 21:00 21:30 ) achiever: update journal')
        call append(line('$'), '- ( 20:00 21:00 ) fam_rela: dine with mom, adam, nath')
        call append(line('$'), '- maingoal: @42 X')
        call append(line('$'), '- ( 17:45 18:00 ) self_rel: chill')
        call append(line('$'), '- maingoal: @42 X')
        call append(line('$'), '- ( 15:45 16:00 ) self_rel: chill')
        call append(line('$'), '- maingoal: @42 X')
        call append(line('$'), '- ( 13:45 14:00 ) self_rel: meditate ( 10min void )')
        call append(line('$'), '- ( 13:00 13:45 ) fam_rela: lunch with mom, adam, nath')
        call append(line('$'), '- maingoal: @42 X')
        call append(line('$'), '- ( 10:20 10:30 ) self_rel: chill')
        call append(line('$'), '- maingoal: @42 X')
        call append(line('$'), '- ( 08:05 08:20 ) self_rel: prepare')
        call append(line('$'), '- ( 07:45 08:05 ) achiever: update journal')
        call append(line('$'), '- ( 07:15 07:45 ) self_rel: exercise ( 30min run )')
        call append(line('$'), '- ( 06:15 07:15 ) maingoal: @42/inception study docker ( book )')
        call append(line('$'), '  * wake up adam at 06:45')
        call append(line('$'), '- ( 06:00 06:15 ) self_rel: meditate ( 10min mindfulness )')
        call append(line('$'), '- ( 05:50 06:00 ) self_rel: exercise ( 10min warm-up )')
    endif
endfunction

"   @brief  Journal and Metrics

function! AppendJournal()
    call append(line('$'), '')
    call append(line('$'), '')
    call append(line('$'), 'TODAY')
    call append(line('$'), '================================================================================')
    call append(line('$'), '                                                                            ->>>')
    call append(line('$'), 'LEGEND')
    call append(line('$'), '  Item                        : Value ( Factors )')
    call append(line('$'), '')
    call append(line('$'), 'SLEEP')
    call append(line('$'), '  Went To Bed At              : --:-- ( - )')
    call append(line('$'), '  Felt Asleep At              : --:-- ( - )')
    call append(line('$'), '  Sleep Time                  : --:-- ( - )')
    call append(line('$'), '  Sleep Quality               : -     ( - )')
    call append(line('$'), '  Dreams Quality              : -     ( - )')
    call append(line('$'), '')
    call append(line('$'), 'DAWN STATE')
    call append(line('$'), '  Vitality                    : -     ( - )')
    call append(line('$'), '  Physical Wellness           : -     ( - )')
    call append(line('$'), '  Mood                        : -     ( - )')
    call append(line('$'), '  Stress                      : -     ( - )')
    call append(line('$'), '  Anxiety                     : -     ( - )')
    call append(line('$'), '  Determination               : -     ( - )')
    call append(line('$'), '')
    call append(line('$'), 'DIET')
    call append(line('$'), '  Night List      00 → 06     : -')
    call append(line('$'), '  Morning List    06 → 12     : -')
    call append(line('$'), '  Afternoon List  12 → 18     : -')
    call append(line('$'), '  Evening         18 → 24     : -')
    call append(line('$'), '')
    call append(line('$'), 'DEVELOPMENT')
    call append(line('$'), '  Discipline                  : -     ( - )')
    call append(line('$'), '  Cognition                   : -     ( - )')
    call append(line('$'), '  Focus                       : -     ( - )')
    call append(line('$'), '')
    call append(line('$'), 'PRODUCTIVITY')
    call append(line('$'), '  Main Goal Time              : --:-- ( - )')
    call append(line('$'), '  Main Goal Engagement        : -     ( - )')
    call append(line('$'), '  Main Goal Satisfaction      : -     ( - )')
    call append(line('$'), '  Side Work Time              : --:-- ( - )')
    call append(line('$'), '  Side Work Engagement        : -     ( - )')
    call append(line('$'), '  Side Work Satisfaction      : -     ( - )')
    call append(line('$'), '  Work Env Time               : --:-- ( - )')
    call append(line('$'), '  Work Env Engagement         : -     ( - )')
    call append(line('$'), '  Work Env Satisfaction       : -     ( - )')
    call append(line('$'), '')
    call append(line('$'), 'WELL-BEING')
    call append(line('$'), '  Meditation Time             : --:-- ( - )')
    call append(line('$'), '  Exercise Time               : --:-- ( - )')
    call append(line('$'), '')
    call append(line('$'), 'ENVIRONMENT')
    call append(line('$'), '  Living Space Cleanliness    : -     ( - )')
    call append(line('$'), '  Work Env Conduciveness      : -     ( - )')
    call append(line('$'), '')
    call append(line('$'), 'DUSK STATE')
    call append(line('$'), '  Vitality                    : -     ( - )')
    call append(line('$'), '  Physical Wellness           : -     ( - )')
    call append(line('$'), '  Mood                        : -     ( - )')
    call append(line('$'), '  Stress                      : -     ( - )')
    call append(line('$'), '  Anxiety                     : -     ( - )')
    call append(line('$'), '  Determination               : -     ( - )')
    call append(line('$'), '')
    call append(line('$'), 'WEMWBS [0 Never, 1 Rarely, 2 Sometimes, 3 Often, 4 Always]')
    call append(line('$'), "  Today I've…")
    call append(line('$'), '  …been feeling optimistic about the future?           : -')
    call append(line('$'), '  …been feeling useful?                                : -')
    call append(line('$'), '  …been feeling relaxed?                               : -')
    call append(line('$'), '  …been feeling interested in other people?            : -')
    call append(line('$'), '  …had energy to spare?                                : -')
    call append(line('$'), '  …been dealing with problems well?                    : -')
    call append(line('$'), '  …been thinking clearly?                              : -')
    call append(line('$'), '  …been feeling good about myself?                     : -')
    call append(line('$'), '  …been feeling close to other people?                 : -')
    call append(line('$'), '  …been feeling confident?                             : -')
    call append(line('$'), '  …been able to make up my own mind about things?      : -')
    call append(line('$'), '  …been feeling loved?                                 : -')
    call append(line('$'), '  …been interested in new things?                      : -')
    call append(line('$'), '  …been feeling cheerful?                              : -')
    call append(line('$'), '')
    call append(line('$'), 'ESSENTIAL EXPENSES')
    call append(line('$'), '  Housing                    Eur: -   ( - )')
    call append(line('$'), '  Transportation             Eur: -   ( - )')
    call append(line('$'), '  Household                  Eur: -   ( - )')
    call append(line('$'), '  Utilities                  Eur: -   ( - )')
    call append(line('$'), '  Insurance                  Eur: -   ( - )')
    call append(line('$'), '  Medical & Healthcare       Eur: -   ( - )')
    call append(line('$'), '  Saving & Investing         Eur: -   ( - )')
    call append(line('$'), 'NON-ESSENTIAL EXPENSES                ( - )')
    call append(line('$'), '  Personal Spending          Eur: -   ( - )')
    call append(line('$'), '  Entertainment              Eur: -   ( - )')
    call append(line('$'), '  Education                  Eur: -   ( - )')
    call append(line('$'), '  Misc                       Eur: -   ( - )')
    call append(line('$'), '')
    call append(line('$'), 'DAILY SELF ADVICE TODO')
    call append(line('$'), '')
    call append(line('$'), 'REPORT TODO')
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
    call append(line('$'), "SKIPPED TASKS")
    call winrestview(l:save_view)
    call setpos('.', cursor_pos)
    write
    return 0
endfunction
