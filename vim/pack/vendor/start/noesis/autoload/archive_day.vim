" autoload/archive_day
" Created: 230806 10:39:15 by clem@spectre
" Updated: 230806 10:39:15 by clem@spectre
" Maintainer: Clément Vidon

"   @brief  Daily Schedule

function! AppendSchedule(option)
    if a:option == "bda"
        call append(line('$'), '')
        call append(line('$'), '- ( 20:30 ) listen podcast / sleep')
        call append(line('$'), '- ( 20:50 21:00 ) exercise ( 10min stretch )')
        call append(line('$'), '- ( 20:30 20:50 ) update journal')
        call append(line('$'), '- ( 19:40 20:30 ) X')
        call append(line('$'), '- ( 19:00 19:40 ) dine')
        call append(line('$'), '- ( 14:40 19:00 ) @42/ft_transcendence X')
        call append(line('$'), '- ( 14:30 14:40 ) meditate ( 10min void )')
        call append(line('$'), '- ( 12:50 14:30 ) X')
        call append(line('$'), '- ( 12:40 12:50 ) update journal')
        call append(line('$'), '- ( 12:00 12:40 ) lunch')
        call append(line('$'), '- ( 11:50 12:00 ) prepare + study psycho')
        call append(line('$'), '- ( 11:20 11:50 ) exercise ( 5min warm-up, 20min run, 5min stretch ) + study psycho')
        call append(line('$'), '- ( 07:00 11:20 ) @42/inception X')
        call append(line('$'), '- ( 06:50 07:00 ) meditate ( 10min mindfulness )')
        call append(line('$'), '- ( 06:10 06:50 ) study psycho')
        call append(line('$'), '- ( 05:50 06:10 ) wake-up / exercise ( 10min warm-up )')
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
    call append(line('$'), '')
    call append(line('$'), '  Ask                       Unit: <Say>  / <Details>')
    call append(line('$'), '')
    call append(line('$'), 'SLEEP')
    call append(line('$'), '  Go To Bed At              Time: X      / X')
    call append(line('$'), '  Sleep Started At          Time: X      / X')
    call append(line('$'), '  Sleep Duration            Time: X      / X')
    call append(line('$'), '  Sleep Quality             Rate: X      / X')
    call append(line('$'), '  Dreams                    Rate: X      / X')
    call append(line('$'), '')
    call append(line('$'), 'DAWN STATE')
    call append(line('$'), '  Vitality                  Rate: X      / X')
    call append(line('$'), '  Wellness                  Rate: X      / X')
    call append(line('$'), '  Anxiety                   Rate: X      / X')
    call append(line('$'), '  Stress                    Rate: X      / X')
    call append(line('$'), '  Determination             Rate: X      / X')
    call append(line('$'), '  Mood                      Rate: X      / X')
    call append(line('$'), '')
    call append(line('$'), 'PHYSICAL HEALTH')
    call append(line('$'), '  Night Diet      00 → 06   List: X')
    call append(line('$'), '  Morning Diet    06 → 12   List: X')
    call append(line('$'), '  Afternoon Diet  12 → 18   List: X')
    call append(line('$'), '  Evening Diet    18 → 24   List: X')
    call append(line('$'), '  Exercise                  Time: X      / X')
    call append(line('$'), '')
    call append(line('$'), 'EMOTIONAL HEALTH')
    call append(line('$'), '  Happiness                 Rate: X      / X')
    call append(line('$'), '  Self Confidence           Rate: X      / X')
    call append(line('$'), '  Social Interactions       Rate: X      / X')
    call append(line('$'), '  Family Interactions       Rate: X      / X')
    call append(line('$'), '  Meditation                Time: X      / X')
    call append(line('$'), '  Gratitude                 List: X')
    call append(line('$'), '  Leisure                   List: X')
    call append(line('$'), '')
    call append(line('$'), 'PRODUCTIVITY')
    call append(line('$'), '  Main Project              Time: X      / X')
    call append(line('$'), '  Side Project              Time: X      / X')
    call append(line('$'), '  Main Project Engagement   Rate: X      / X')
    call append(line('$'), '  Side Project Engagement   Rate: X      / X')
    call append(line('$'), '')
    call append(line('$'), 'ENVIRONMENT')
    call append(line('$'), '  Environment               Time: X      / X')
    call append(line('$'), '  Living Space Cleanliness  Rate: X      / X')
    call append(line('$'), '  Work Env Conduciveness    Rate: X      / X')
    call append(line('$'), '')
    call append(line('$'), 'DEVELOPMENT')
    call append(line('$'), '  Discipline                Rate: X      / X')
    call append(line('$'), '  Consistency               Rate: X      / X')
    call append(line('$'), '  Creativity                Rate: X      / X')
    call append(line('$'), '  Cognition                 Rate: X      / X')
    call append(line('$'), '  Learning                  Rate: X      / X')
    call append(line('$'), '  Focus                     Rate: X      / X')
    call append(line('$'), '  New Skills                List: X')
    call append(line('$'), '')
    call append(line('$'), 'DUSK STATE')
    call append(line('$'), '  Vitality                  Rate: X      / X')
    call append(line('$'), '  Wellness                  Rate: X      / X')
    call append(line('$'), '  Anxiety                   Rate: X      / X')
    call append(line('$'), '  Stress                    Rate: X      / X')
    call append(line('$'), '  Determination             Rate: X      / X')
    call append(line('$'), '  Mood                      Rate: X      / X')
    call append(line('$'), '')
    call append(line('$'), 'WEMWBS')
    call append(line('$'), '( 0 Never / 1 Rarely / 2 Sometimes / 3 Often / 4 Always )')
    call append(line('$'), "  I've been feeling optimistic about the future?      : X")
    call append(line('$'), "  I've been feeling useful?                           : X")
    call append(line('$'), "  I've been feeling relaxed?                          : X")
    call append(line('$'), "  I've been feeling interested in other people?       : X")
    call append(line('$'), "  I've had energy to spare?                           : X")
    call append(line('$'), "  I've been dealing with problems well?               : X")
    call append(line('$'), "  I've been thinking clearly?                         : X")
    call append(line('$'), "  I've been feeling good about myself?                : X")
    call append(line('$'), "  I've been feeling close to other people?            : X")
    call append(line('$'), "  I've been feeling confident?                        : X")
    call append(line('$'), "  I've been able to make up my own mind about things? : X")
    call append(line('$'), "  I've been feeling loved?                            : X")
    call append(line('$'), "  I've been interested in new things?                 : X")
    call append(line('$'), "  I've been feeling cheerful?                         : X")
    call append(line('$'), '')
    call append(line('$'), 'ESSENTIAL EXPENSES')
    call append(line('$'), '  Housing                   Eur: X')
    call append(line('$'), '  Transportation            Eur: X')
    call append(line('$'), '  Household                 Eur: X')
    call append(line('$'), '  Utilities                 Eur: X')
    call append(line('$'), '  Insurance                 Eur: X')
    call append(line('$'), '  Medical & Healthcare      Eur: X')
    call append(line('$'), '  Saving & Investing        Eur: X')
    call append(line('$'), 'NON-ESSENTIAL EXPENSES')
    call append(line('$'), '  Personal Spending         Eur: X')
    call append(line('$'), '  Entertainment             Eur: X')
    call append(line('$'), '  Miscellaneous             Eur: X')
    call append(line('$'), '')
    call append(line('$'), 'DAILY SELF ADVICE X')
    call append(line('$'), '')
    call append(line('$'), 'REPORT X')
    call append(line('$'), '')
    call append(line('$'), '<<<-')
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
    call winrestview(l:save_view)
    call setpos('.', cursor_pos)
    write
    return 0
endfunction
