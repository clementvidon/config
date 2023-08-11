" autoload/archive_day
" Created: 230806 10:39:15 by clem@spectre
" Updated: 230806 10:39:15 by clem@spectre
" Maintainer: Clément Vidon

"   @brief  Daily Schedule

function! AppendSchedule(option)
    if a:option == "bda"
        call append(line('$'), '')
        call append(line('$'), '- ( 21:50 ) fall asleep')
        call append(line('$'), '- ( 21:40 21:50 ) self_rel: exercise ( 10min stretch )')
        call append(line('$'), '- ( 20:50 21:40 ) sidework: study transactional analysis')
        call append(line('$'), '- ( 20:30 20:50 ) work_env: update achiever')
        call append(line('$'), '- ( 19:40 20:30 ) X')
        call append(line('$'), '- ( 19:00 19:40 ) fam_rela: dine with moupou')
        call append(line('$'), '- ( 17:00 19:00 ) maingoal: @42 X')
        call append(line('$'), '- ( 16:45 17:00 ) self_rel: chill')
        call append(line('$'), '- ( 14:00 16:45 ) maingoal: @42 X')
        call append(line('$'), '- ( 13:45 14:00 ) self_rel: meditate ( 10min void )')
        call append(line('$'), '- ( 13:00 13:45 ) X')
        call append(line('$'), '- ( 12:40 13:00 ) work_env: update achiever')
        call append(line('$'), '- ( 12:00 12:40 ) fam_rela: lunch with moupou')
        call append(line('$'), '- ( 11:50 12:00 ) prepare')
        call append(line('$'), '- ( 11:20 11:50 ) self_rel: exercise ( 5min warm-up, 20min run, 5min stretch )')
        call append(line('$'), '- ( 11:10 11:20 ) self_rel: chill')
        call append(line('$'), '- ( 09:05 11:10 ) maingoal: @42 X')
        call append(line('$'), '- ( 09:00 09:05 ) self_rel: chill')
        call append(line('$'), '- ( 07:05 09:00 ) maingoal: @42 X')
        call append(line('$'), '- ( 07:00 07:05 ) work_env: update achiever')
        call append(line('$'), '- ( 06:15 07:00 ) sidework: study transactional analysis')
        call append(line('$'), '- ( 06:00 06:15 ) self_rel: meditate ( 10min mindfulness )')
        call append(line('$'), '- ( 05:50 06:00 ) self_rel: exercise ( 10min warm-up )')
    elseif a:option == "home"
        " call append(line('$'), '- ( 21:30 ) listen podcast / sleep')
        " call append(line('$'), '- ( 21:20 21:30 ) exercise ( 10min stretch )')
        " call append(line('$'), '- ( 21:00 21:20 ) update journal')
        " call append(line('$'), '- ( 20:30 21:00 ) dine + study psycho')
        " call append(line('$'), '- ( 20:10 20:30 ) cook + study psycho')
        " call append(line('$'), '- ( 20:00 20:10 ) meditate ( 10min mindfulness )')
        " call append(line('$'), '- ( 14:00 20:00 ) @42 X')
        " call append(line('$'), '- ( 13:50 14:00 ) meditate ( 10min void )')
        " call append(line('$'), '- ( 13:00 13:50 ) lunch + study psycho')
        " call append(line('$'), '- ( 12:30 13:00 ) cook  + study psycho')
        " call append(line('$'), '- ( 12:20 12:30 ) prepare + listen breaking news')
        " call append(line('$'), '- ( 11:20 12:20 ) exercise ( 20min walk, 20min swim, 20min walk )')
        " call append(line('$'), '- ( 07:00 11:20 ) @42 X')
        " call append(line('$'), '- ( 06:50 07:00 ) meditate ( 10min mindfulness )')
        " call append(line('$'), '- ( 06:10 06:50 ) study psycho')
        " call append(line('$'), '- ( 05:50 06:10 ) wake up / exercise ( 10min warm-up )')
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
    call append(line('$'), '  Determination               : -     ( - )')
    call append(line('$'), '')
    call append(line('$'), 'DIET')
    call append(line('$'), '  Night List      00 → 06     : -')
    call append(line('$'), '  Morning List    06 → 12     : -')
    call append(line('$'), '  Afternoon List  12 → 18     : -')
    call append(line('$'), '  Evening         18 → 24     : -')
    call append(line('$'), '')
    call append(line('$'), 'DEVELOPMENT')
    call append(line('$'), '  Cognition                   : -     ( - )')
    call append(line('$'), '  Discipline                  : -     ( - )')
    call append(line('$'), '')
    call append(line('$'), 'ENVIRONMENT')
    call append(line('$'), '  Environment Time            : --:-- ( - )')
    call append(line('$'), '  Living Space Cleanliness    : -     ( - )')
    call append(line('$'), '  Work Env Conduciveness      : -     ( - )')
    call append(line('$'), '')
    call append(line('$'), 'PRODUCTIVITY')
    call append(line('$'), '  Main Goal Time              : --:-- ( - )')
    call append(line('$'), '  Main Goal Engagement        : -     ( - )')
    call append(line('$'), '  Main Goal Satisfaction      : -     ( - )')
    call append(line('$'), '  Side Work Time              : --:-- ( - )')
    call append(line('$'), '  Side Work Engagement        : -     ( - )')
    call append(line('$'), '  Side Work Satisfaction      : -     ( - )')
    call append(line('$'), '')
    call append(line('$'), 'WELL-BEING')
    call append(line('$'), '  Family Relations            : -     ( - )')
    call append(line('$'), '  Social Relations            : -     ( - )')
    call append(line('$'), '  Meditation Time             : --:-- ( - )')
    call append(line('$'), '  Exercise Time               : --:-- ( - )')
    call append(line('$'), '  Repose Time                 : --:-- ( - )')
    call append(line('$'), '  Happiness                   : -     ( - )')
    call append(line('$'), '  Anxiety                     : -     ( - )')
    call append(line('$'), '')
    call append(line('$'), 'DUSK STATE')
    call append(line('$'), '  Vitality                    : -     ( - )')
    call append(line('$'), '  Physical Wellness           : -     ( - )')
    call append(line('$'), '  Mood                        : -     ( - )')
    call append(line('$'), '  Stress                      : -     ( - )')
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
    call append(line('$'), '  Miscellaneous              Eur: -   ( - )')
    call append(line('$'), '')
    call append(line('$'), 'DAILY SELF ADVICE TODO')
    call append(line('$'), '')
    call append(line('$'), 'REPORT TODO')
    call append(line('$'), '')
    call append(line('$'), '<<<-')
    call append(line('$'), '')
endfunction

"   @brief  Archive Today into history and set Today with Tomorrow tasks.

function! archive_day#(schedule)
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
