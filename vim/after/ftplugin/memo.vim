" --------------------------------- FUNCTIONS >>>

"   @brief  Return a HH:MM timestamp with the minutes rounded to the closest
"           multiple of 5.

function! RoundedTime()
    let time = strftime('%H:%M')
    let minutes = str2nr(split(time, ':')[1])
    let rounded_minutes = (minutes + 2) / 5 * 5
    let rounded_time = printf('%02d:%02d', str2nr(split(time, ':')[0]), rounded_minutes)
    return rounded_time
endfunction

"   @brief  Print the time difference between time1 and time2 in minutes.
"           time1 and time2 should be in the [HH:MM HH:MM] format.

function MemoTimeDiff()
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

function! MemoTaskCheck()
    let timestamp = RoundedTime()
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

function! MemoTaskReCheck()
    let timestamp = RoundedTime()
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

function! MemoArchiveDay()
    if expand('%:t:r') . '.' . expand('%:e') != 'todo.md'
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
    exec 'silent edit ' . expand('%:p:h') . '/history.gpg.md'
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
    call append(line('$'), '[07:00] wake up + stretch / breath / @noesis/todo update journal')

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
    call append(line('$'), ' - diner: anise masala infusion')
    call append(line('$'), ' - lunch:')
    call append(line('$'), ' - break:')
    call append(line('$'), '')
    call append(line('$'), 'workout')
    call append(line('$'), ' - warming up               10x8    x1 beg')
    call append(line('$'), ' - calfraises + elastiband  50      x2')
    call append(line('$'), ' - legflexion + gripring    15x2    x2')
    call append(line('$'), ' - abs                      30      x2')
    call append(line('$'), ' - pushup                   20      x2')
    call append(line('$'), ' - elastiband               40      x2')
    call append(line('$'), ' - bicyclecrunch            4x15    x2')
    call append(line('$'), ' - paintcanlift             25      x2')
    call append(line('$'), ' - stretches                15sx5   x1 end')
    call append(line('$'), '')
    call append(line('$'), '    journal')
    call append(line('$'), '')
    call append(line('$'), 'morning')
    call append(line('$'), '- psyc:')
    call append(line('$'), '- soma:')
    call append(line('$'), '- life:')
    call append(line('$'), '- work:')
    call append(line('$'), '')
    call append(line('$'), 'evening')
    call append(line('$'), '- psyc:')
    call append(line('$'), '- soma:')
    call append(line('$'), '- life:')
    call append(line('$'), '- work:')
    call append(line('$'), '')
    call append(line('$'), '    diary')
    call append(line('$'), '')

    call append(line('$'), l:tmrrw_content)
    call winrestview(l:save_view)
    call setpos('.', cursor_pos)
    write
    return 0
endfunction


" <<<

augroup filetype_memo
    autocmd!
    " --------------------------------- OPTIONS >>>

    au FileType markdown set filetype=memo
    au FileType memo
                \   setl textwidth=80
                \ | setl suffixesadd+=.md
                \ | setl suffixesadd+=.gpg.md
                \ | setl path+=$DOTVIM
                \ | setl path+=$DOTVIM/after/ftplugin/**
                \ | setl path+=$MEMO
                \ | setl path+=$MEMO/Lists/**
                \ | setl path+=$MEMO/Areas/**
                \ | setl path+=$MEMO/Projects/**
                \ | setl path+=$MEMO/Resources/**
                \ | setl expandtab
                \ | let maplocalleader = "gh"
    "           \ | syntax sync fromstart

    " au FileType memo
    "             \   setl formatoptions+=ro
    "             \ | setl comments+=s:[],m:[],e:[]

    au BufReadPre,FileReadPre *.gpg.* setl viminfo=""
    au BufReadPre,FileReadPre *.gpg.* setl noswapfile noundofile nobackup
    au BufReadPost,FileReadPost *.gpg.* if getline('1') == '-----BEGIN PGP MESSAGE-----' |
                \ exec 'silent %!gpg --decrypt 2>/dev/null' | setl title titlestring='ENCRYPTED' |
                \ endif
    au BufWritePre,FileWritePre *.gpg.* let g:view = winsaveview() | keeppatterns %s/\s\+$//e |
                \ exec 'silent %!gpg --default-recipient $GPG_KEY --armor --encrypt 2>/dev/null'
    au BufWritePost,FileWritePost *.gpg.* exec "normal! u" |
                \ call winrestview(g:view) | setl title!

    " <<<
    " --------------------------------- MAPPINGS >>>


    "                       SAFETY :

    au FileType memo nn <buffer><silent> <LocalLeader> <nop>
    au FileType memo nn <silent><buffer> <space>= <nop>
    au FileType memo vn <silent><buffer> <space>= <nop>
    au FileType memo vn <silent><buffer> = <nop>
    au FileType memo nn <silent><buffer> = <nop>
    au FileType memo vn <silent><buffer> gq <nop>
    au FileType memo nn <silent><buffer> gq <nop>
    au FileType memo nn <silent><buffer> gwG <nop>
    au FileType memo nn <silent><buffer> gwgo <nop>
    au FileType memo nn <silent><buffer> gwgg <nop>

    "   Mapping Info
    au BufRead,BufNewFile $MEMO/Lists/* nn <silent><buffer> <LocalLeader>? :echo "
                \\n
                \================[Memo]================\n
                \                                      \|\n
                \ HTML_EXPORT       : Space X          \|\n
                \                                      \|\n
                \ PUSH_MEMO         : ghps             \|\n
                \ PULL_MEMO         : ghpl             \|\n
                \                                      \|\n
                \ MEMO_NAV FOR      : Space CR         \|\n
                \ MEMO_NAV BAC      : Space Tab        \|\n
                \ INDEX_GEN         : Space #          \|\n
                \ INDEX_NAV         : Space 3          \|\n
                \ MEMO_GREP         : :Grep            \|\n
                \                                      \|\n
                \ MD_LINK           : Space L          \|\n
                \                                      \|\n
                \ GPG_ENC           : ghe              \|\n
                \ GPG_DEC           : ghd              \|\n
                \                                      \|\n
                \"<CR>


    "                       GENERAL :

    "   Html Export TODO MemoToHtml()
    au FileType memo nn <silent><buffer> <LocalLeader>X :set term=xterm-256color<CR>:TOhtml<CR>
                \
                \/--><CR>Oa { color: hotpink; }<Esc>go
                \:%s/background-color: \#000000; }$/background-color: \#2e333f; }/g<CR>
                \:%s/\* { font-size: 1em; }$/\* { font-size: 1.1em; }/g<CR>
                \:%s/\.memoH1 { color: #5fffaf; }$/.memoH1 { color: #5fffaf; font-size: 120%; }/g<CR>
                \:%s/\.memoUrl { color: #ff5faf; text-decoration: underline; }$/.memoUrl { color: #ff5faf; text-decoration: underline; font-size: 90%; }/g<CR>
                \go/<span class="memoBlockquote">&gt; </span><CR>cc<span class="memoBlockquote">&gt; </span> cvidon@student.42.fr<Esc>go
                \:fix}}<Esc>

    "   Pull Memo TODO MemoGitPull()
    " au BufRead,BufNewFile $MEMO/Lists/*.md nn <silent><buffer> ghpl :cd %:h\|sil !git pull<CR>:redraw!<CR>
    au FileType memo nn <silent><buffer> <LocalLeader>pl :cd %:h\|sil !git pull<CR>:redraw!<CR>

    "   Push Memo TODO MemoGitPush()
    " au BufRead,BufNewFile $MEMO/Lists/*.md nn <silent><buffer> ghps :echo "Push"<CR>:w\|lc %:h<CR>
    au FileType memo nn <silent><buffer> <LocalLeader>ps :echo "Push"<CR>:w\|lc %:h<CR>
                \
                \:sil !rm $DOTVIM/.swp/*%*.swp<CR>
                \:sil cd $MEMO/<CR>
                \:sil !git add -f INDEX.md Lists Areas Projects Resources Archives<CR>
                \:sil !git commit -m "Push"<CR>:sil !git push origin main<CR>
                \:q<CR>:redr!<CR>

    "   Index Gen TODO MemoIndexGen() (regen if exist)
    au FileType memo nn <silent><buffer> <LocalLeader>I :silent
                \
                \ :let @a=""<CR>:keeppatterns g/^##/y A<CR>3Gpo#INDEX<CR>------<Esc>0k

    "   Index Nav TODO MemoIndexNav()
    au FileType memo nn <silent><buffer> <LocalLeader>i :keeppatterns /<C-R>=getline('.')<CR>$<CR>zt5<C-y>

    "   Markdown link
    au FileType memo nn <silent><buffer> <LocalLeader>l 0/ttp.*\/\/\\|ww\..*\.<CR>Ea)<Esc>:let @/=""<CR>Bi[](<Left><Left>

    "   Memo Grep
    au BufRead,BufNewFile $MEMO/* com! -nargs=+ Grep exec 'grep! -i <args> $MEMO/**/*.md' | cw


    "   GPG ENC
    au BufRead,BufNewFile *.gpg.md nn <buffer><silent> <LocalLeader>enc :silent %!gpg --default-recipient Clem9nt -ae 2>/dev/null<CR>
    "   GPG DEC
    au BufRead,BufNewFile *.gpg.md nn <buffer><silent> <LocalLeader>dec :silent %!gpg -d 2>/dev/null<CR>

    "   Gpg enc/dec
    au FileType memo vn <silent><buffer> <LocalLeader>ga :!gpg -ca<CR>:echo "gpg -ca # --symetric --armor"
    au FileType memo vn <silent><buffer> <LocalLeader>gs :!gpg -ae<CR>dd:echo "gpg -ae # --"
    au FileType memo vn <silent><buffer> <LocalLeader>gd :!gpg -qd<CR>:echo "gpg -qd"


    "                       TOD0 :

    "   Archive Day
    au BufRead,BufNewFile $MEMO/Lists/todo.md nn <buffer><silent> <LocalLeader>A :call MemoArchiveDay()<CR>
                \:sil cd $MEMO/<CR>
                \:sil !git add -f INDEX.md Lists Areas Projects Resources Archives<CR>
                \:sil !git commit -m "Archive"<CR>:redraw!<CR>

    "   Task New
    au BufRead,BufNewFile $MEMO/Lists/* nn <silent><buffer> <Leader>t O[]<Esc><<$A<Space>
    au BufRead,BufNewFile $MEMO/Lists/* nn <silent><buffer> <Leader>T o[] tmp<Esc><<:call MemoTaskCheck()<CR>ftC

    "   Task Check
    au FileType memo nn <silent><buffer> <Leader>k :call MemoTaskCheck()<CR>
                \
                \:let @/=""<CR>:write<CR>02f]l

    "   Task Recheck
    au FileType memo nn <silent><buffer> <Leader>r :call MemoTaskReCheck()<CR>
                \
                \:let @/=""<CR>:write<CR>02f]l

    "   Task Check Next
    au FileType memo nn <silent><buffer> <Leader><Space> G$
                \
                \?\(^\[.*] .*\)\&\(^\[\d\d\d\d\d\d \d\d:\d\d \d\d:\d\d] .*\)\@!<CR>
                \:call MemoTaskCheck()<CR>
                \:let @/=""<CR>:write<CR>02f]l
    " au FileType memo nn <silent><buffer> <Leader><Space> /^##  Today$<CR>VG$<Esc>
    "             \
    "             \?\(^\[.*] .*\)\&\(^\[\d\d\d\d\d\d \d\d:\d\d \d\d:\d\d] .*\)\@!<CR>
    "             \:call MemoTaskCheck()<CR>
    "             \:let @/=""<CR>:write<CR>02f]l
    " \?\%V\(^-\\|^\[\]\\|^\[\d\{6} \d\{2}:\d\{2}]\) <CR>


    "   Task Now
    au FileType memo nn <silent><buffer> <Leader>. /^##  Today$<CR>VG$<Esc>
                \
                \?\%V\(^-\\|^\[\]\\|^\[\d\d:\d\d\]\) <CR>

    "   Task Clear
    au FileType memo nn <silent><buffer> <Leader>c mm0di[`m

    "   Task Switch
    au FileType memo nn <buffer><silent> <LocalLeader>s 0f]lv$hdj0f]lv$hpk$p
    au FileType memo nn <buffer><silent> <LocalLeader>S 0f]lv$hdk0f]lv$hpj$p

    "                       HISTORY

    "   rot
    au FileType memo nn <buffer><silent> <LocalLeader>r Mmm
                \
                \:keeppatterns g/^\s/norm g??<CR>
                \`mzz3<C-O>

    " <<<
    " --------------------------------- DIGRAPHS >>>

    au FileType memo cno <C-K>% <Nop>
    au FileType memo ino <C-K>% <Nop>

    au FileType memo exec "digraphs es " . 0x2091
    au FileType memo exec "digraphs hs " . 0x2095
    au FileType memo exec "digraphs is " . 0x1D62
    au FileType memo exec "digraphs js " . 0x2C7C
    au FileType memo exec "digraphs ks " . 0x2096
    au FileType memo exec "digraphs ls " . 0x2097
    au FileType memo exec "digraphs ms " . 0x2098
    au FileType memo exec "digraphs ns " . 0x2099
    au FileType memo exec "digraphs os " . 0x2092
    au FileType memo exec "digraphs ps " . 0x209A
    au FileType memo exec "digraphs rs " . 0x1D63
    au FileType memo exec "digraphs ss " . 0x209B
    au FileType memo exec "digraphs ts " . 0x209C
    au FileType memo exec "digraphs us " . 0x1D64
    au FileType memo exec "digraphs vs " . 0x1D65
    au FileType memo exec "digraphs xs " . 0x2093

    au FileType memo exec "digraphs aS " . 0x1d43
    au FileType memo exec "digraphs bS " . 0x1d47
    au FileType memo exec "digraphs cS " . 0x1d9c
    au FileType memo exec "digraphs dS " . 0x1d48
    au FileType memo exec "digraphs eS " . 0x1d49
    au FileType memo exec "digraphs fS " . 0x1da0
    au FileType memo exec "digraphs gS " . 0x1d4d
    au FileType memo exec "digraphs hS " . 0x02b0
    au FileType memo exec "digraphs iS " . 0x2071
    au FileType memo exec "digraphs jS " . 0x02b2
    au FileType memo exec "digraphs kS " . 0x1d4f
    au FileType memo exec "digraphs lS " . 0x02e1
    au FileType memo exec "digraphs mS " . 0x1d50
    au FileType memo exec "digraphs nS " . 0x207f
    au FileType memo exec "digraphs oS " . 0x1d52
    au FileType memo exec "digraphs pS " . 0x1d56
    au FileType memo exec "digraphs rS " . 0x02b3
    au FileType memo exec "digraphs sS " . 0x02e2
    au FileType memo exec "digraphs tS " . 0x1d57
    au FileType memo exec "digraphs uS " . 0x1d58
    au FileType memo exec "digraphs vS " . 0x1d5b
    au FileType memo exec "digraphs wS " . 0x02b7
    au FileType memo exec "digraphs xS " . 0x02e3
    au FileType memo exec "digraphs yS " . 0x02b8
    au FileType memo exec "digraphs zS " . 0x1dbb

    au FileType memo exec "digraphs AS " . 0x1D2C
    au FileType memo exec "digraphs BS " . 0x1D2E
    au FileType memo exec "digraphs DS " . 0x1D30
    au FileType memo exec "digraphs ES " . 0x1D31
    au FileType memo exec "digraphs GS " . 0x1D33
    au FileType memo exec "digraphs HS " . 0x1D34
    au FileType memo exec "digraphs IS " . 0x1D35
    au FileType memo exec "digraphs JS " . 0x1D36
    au FileType memo exec "digraphs KS " . 0x1D37
    au FileType memo exec "digraphs LS " . 0x1D38
    au FileType memo exec "digraphs MS " . 0x1D39
    au FileType memo exec "digraphs NS " . 0x1D3A
    au FileType memo exec "digraphs OS " . 0x1D3C
    au FileType memo exec "digraphs PS " . 0x1D3E
    au FileType memo exec "digraphs RS " . 0x1D3F
    au FileType memo exec "digraphs TS " . 0x1D40
    au FileType memo exec "digraphs US " . 0x1D41
    au FileType memo exec "digraphs VS " . 0x2C7D
    au FileType memo exec "digraphs WS " . 0x1D42

    " <<<
augroup END
