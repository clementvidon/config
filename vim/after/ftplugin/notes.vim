augroup FILETYPE_NOTES
    autocmd!
    " --------------------------------- OPTIONS {{{
    au BufRead,BufNewFile *.md,*.markdown
                \   set filetype=notes
                \ | setl textwidth=80
                \ | setl suffixesadd+=.md
                \ | setl suffixesadd+=.gpg.md
                \ | setl path+=$DOTVIM/after/ftplugin/**
                \ | setl path+=$NOTES
                \ | setl path+=$NOTES/Lists/**
                \ | setl path+=$NOTES/Areas/**
                \ | setl path+=$NOTES/Projects/**
                \ | setl path+=$NOTES/Resources/**
                \ | setl expandtab
    au BufRead,BufNewFile $NOTES/Lists/*.md setl textwidth=0

    " GPG
    au BufReadPre,FileReadPre *.gpg.* setl viminfo=""
    au BufReadPre,FileReadPre *.gpg.* setl noswapfile noundofile nobackup
    au BufReadPost,FileReadPost *.gpg.* if getline('1') == '-----BEGIN PGP MESSAGE-----' |
                \ exec 'silent %!gpg --decrypt 2>/dev/null' | setl title titlestring='ENCRYPTED' |
                \ endif
    au BufWritePre,FileWritePre *.gpg.* let g:view = winsaveview() | keeppatterns %s/\s\+$//e |
                \exec 'silent %!gpg --default-recipient Clem9nt --armor --encrypt 2>/dev/null'
    au BufWritePost,FileWritePost *.gpg.* exec "normal! u"|
                \ call winrestview(g:view) | setl title!
    " }}}
    " --------------------------------- PLUGINS {{{
    " }}}
    " --------------------------------- FUNCTIONS {{{
    function! TimeDiff(line1, line2)
        " Get line content and extract the time
        let l:t1List = split(getline(a:line1), " ")
        let l:t2List = split(getline(a:line1), " ")
        let l:t1List = split((l:t1List[2]), ":")
        let l:t2List = split((l:t2List[1]), ":")
        " Get the diff in minutes between the timestamps.
        let l:diff = 0
        let l:time1 = l:t1List[0] * 3600 + l:t1List[1] * 60
        let l:time2 = l:t2List[0] * 3600 + l:t2List[1] * 60
        if l:time1 > l:time2
            let l:diff = l:time1 - l:time2
        elseif l:time1 < l:time2
            let l:diff = (24 * 3600) - (l:time2 - l:time1)
        endif
        let l:min=trunc(fmod(l:diff,3600) / 60)
        let l:hrs=trunc(l:diff / 3600)
        " Replace the line with the result.
        call append(a:line2, printf("%02.0f:%02.0f", l:hrs,l:min))
    endfunction
    command! -range TimeDiff :call TimeDiff(<line1>,<line2>)

    "   Like vim gF but works with pattern (ie. todo:today)
    fu! NotesGF()
        if count(getline('.'), ":") == 1
            let l:line = split(getline('.'), ":")
            let l:file = substitute(l:line[0], '>', '', "g")
            let l:pattern = substitute(l:line[1], ' ', '\\ ', "g")
            echo l:file
            if l:pattern =~# '^\d\+$'
                exec 'normal gF'
            else
                exec 'find +/' . l:pattern . ' ' . l:file
            endif
        else
            exec 'normal gf'
        endif
    endfun

    fu! NotesArchiveDay()
        let l:save = winsaveview()
        "   Check file
        if expand('%:t:r') . "." . expand('%:e') != "todo.md"
            echom ">>> Not in \"todo.md\" <<<"
            return 1
        endif
        "   Check END
        if strlen(getline(searchpos("^\\[.*\\]\\[END\\]")[0])) != 19
            echom ">>> Unchecked \"END\" <<<"
            return 1
        endif
        "   Check stats
        if strlen(getline(searchpos("^\\[-\\]\\[ST\\]")[0])) != 33
            echom ">>> Incomplete stats \"ST\" <<<"
            return 1
        endif
        "   Check day
        let l:checkday = 0
        if strpart(getline(line('$') - 1), 1, 6) == strftime('%y%m%d')
            let l:checkday = 1
        endif
        "   Locate today and tomorrow
        let l:today_loc = searchpos("##  Today")[0]
        let l:tomorrow_loc = searchpos("##  Tomorrow")[0]
        "   Insert fancy date
        if getline(l:today_loc + 1) == ""
            call setline(l:today_loc + 1, "#[ " . strftime('%a %d %b %Y') . " ]")
        else
            call append(l:today_loc, "#[ " . strftime('%a %d %b %Y') . " ]")
        endif
        "   Fill the date placeholders
        execute "silent " . l:today_loc . ",$s/^\\[-/\\[" . strftime('%y%m%d') . "/g"
        "   Hide the >> section
        execute l:today_loc . ",$g/\\[>>\\]/norm g??"
        "   Delete the END section
        execute l:today_loc . ",$g/\\[END\\]/norm dd"
        "   Copy today
        let l:today_tasks = getline(l:today_loc + 1, line('$'))
        "   Copy and reset SLEEP
        let l:today_sleep = getline(line('$'))
        let l:today_sleep = substitute(
                    \l:today_sleep, strpart(l:today_sleep, 1, 6), "-", "")
        "   Archive it
        write
        execute "silent edit $NOTES/Lists/history.gpg.md"
        call append(5, l:today_tasks)
        write
        "   Delete today
        execute "silent edit #"
        execute "silent " . l:today_loc . ",$delete"
        delete
        "   Update Today
        call append(line('$'), l:today_sleep)
        call append(l:tomorrow_loc + 1, "[][END]")
        call append(l:tomorrow_loc + 1, "[-][>>]")
        call append(l:tomorrow_loc + 1, "[-][>>] (-)")
        call append(l:tomorrow_loc + 1, "[-][>>] (+)")
        call append(l:tomorrow_loc + 1, "[-][ST] ph en mi st fo yi")
        call append(l:tomorrow_loc + 1, "")
        call append(l:tomorrow_loc + 1, "##  Today")
        call append(l:tomorrow_loc + 1, "")
        if l:checkday == 0
            call append(line('$') - 2, "[][Note upd] history")
        endif
        "   Tomorrow template
        call append(l:tomorrow_loc + 1, "[][Life] prepare; transport")
        call append(l:tomorrow_loc + 1, "[][Life] transport; prepare")
        write
        call winrestview(l:save)
        return 0
    endfun

    " }}}
    " --------------------------------- MAPPINGS {{{
    au BufRead,BufNewFile $NOTES/Lists/* nn <silent><buffer> <Space>? :echo "
                \\n
                \================[Notes]================\n
                \                                      \|\n
                \ HTML_EXPORT       : Space X          \|\n
                \                                      \|\n
                \ PUSH_NOTES        : ghps             \|\n
                \ PULL_NOTES        : ghpl             \|\n
                \                                      \|\n
                \ NOTES_NAV FOR     : Space CR         \|\n
                \ NOTES_NAV BAC     : Space Tab        \|\n
                \ INDEX_GEN         : Space #          \|\n
                \ INDEX_NAV         : Space 3          \|\n
                \ NOTES_GREP        : :Grep            \|\n
                \                                      \|\n
                \ MD_LINK           : Space L          \|\n
                \                                      \|\n
                \ GPG_ENC           : Space E          \|\n
                \ GPG_DEC           : Space C          \|\n
                \                                      \|\n
                \"<CR>

    au BufRead,BufNewFile $NOTES/Lists/todo.md nn <silent><buffer> <Space>? :echo "
                \\n
                \================[Todos]================\n
                \                                      \|\n
                \ TASK_ADD_TAG      : Tab   …          \|\n
                \ TASK_FOCUS_TAG    : Tab   \\          \|\n
                \ TASK_ADD_ACT      : \\     …          \|\n
                \ TASK_FOCUS_ACT    : \\     Tab        \|\n
                \                                      \|\n
                \ TASK_CHECK        : Space Space      \|\n
                \ TASK_RECHECK      : Space r          \|\n
                \ TASK_NOW          : Space n          \|\n
                \ TASK_REPEAT       : Space .          \|\n
                \ TASK_BREAK        : Space b          \|\n
                \ TASK_BREAK_REPEAT : Space B          \|\n
                \ TASK_POSTPONE_TOP : Space P          \|\n
                \ TASK_POSTPONE_BOT : Space p          \|\n
                \ TASK_CLEAR        : Space c          \|\n
                \ TASK_FIX          : Space f          \|\n
                \ ARCHIVE_DAY       : Space A          \|\n
                \                                      \|\n
                \ TIME_DIFF         : Space T          \|\n
                \ GF_PATTERN        : Space GF         \|\n
                \                                      \|\n
                \"<CR>


    "                       SAFETY :

    au BufRead,BufNewFile *.md nn <silent><buffer> <space>= <nop>
    au BufRead,BufNewFile *.md vn <silent><buffer> <space>= <nop>
    au BufRead,BufNewFile *.md vn <silent><buffer> = <nop>
    au BufRead,BufNewFile *.md nn <silent><buffer> = <nop>
    au BufRead,BufNewFile *.md vn <silent><buffer> gq <nop>
    au BufRead,BufNewFile *.md nn <silent><buffer> gq <nop>
    au BufRead,BufNewFile *.md nn <silent><buffer> gwG <nop>
    au BufRead,BufNewFile *.md nn <silent><buffer> gwgo <nop>
    au BufRead,BufNewFile *.md nn <silent><buffer> gwgg <nop>


    "                       GENERAL :

    "   HTML_EXPORT
    au BufRead,BufNewFile *.md nn <silent><buffer> <Space>X :set term=xterm-256color<CR>:TOhtml<CR>
                \
                \/--><CR>Oa { color: hotpink; }<Esc>go
                \:%s/background-color: \#000000; }$/background-color: \#2e333f; }/g<CR>
                \:%s/\* { font-size: 1em; }$/\* { font-size: 1.1em; }/g<CR>
                \:%s/\.notesH1 { color: #5fffaf; }$/.notesH1 { color: #5fffaf; font-size: 120%; }/g<CR>
                \:%s/\.notesUrl { color: #ff5faf; text-decoration: underline; }$/.notesUrl { color: #ff5faf; text-decoration: underline; font-size: 90%; }/g<CR>
                \go/<span class="notesBlockquote">&gt; </span><CR>cc<span class="notesBlockquote">&gt; </span> cvidon@student.42.fr<Esc>go
                \:fix}}<Esc>

    "   PULL_NOTES
    au BufRead,BufNewFile $NOTES/Lists/*.md nn <silent><buffer> ghpl :cd %:h\|sil !git pull<CR>:redraw!<CR>

    "   PUSH_NOTES
    au BufRead,BufNewFile $NOTES/Lists/*.md nn <silent><buffer> ghps :echo "Push"<CR>:w\|lc %:h<CR>
                \:sil !rm $DOTVIM/.swp/*%*.swp<CR>
                \:sil cd $NOTES/<CR>
                \:sil !git add -f INDEX.md Lists Areas Projects Resources Archives<CR>
                \:sil !git commit -m "Push"<CR>:sil !git push origin main<CR>
                \:q<CR>:redr!<CR>


    "   NOTES_NAV
    au BufRead,BufNewFile *.md nn <silent><buffer> <Space><Tab> :silent write<CR>gogF
    au BufRead,BufNewFile *.md nn <silent><buffer> <Space><CR> mm:silent write<CR>`m0:call NotesGF()<CR>

    "   INDEX_GEN
    au BufRead,BufNewFile *.md nn <silent><buffer> <Space># :silent
                \
                \ :let @a=""<CR>:keeppatterns g/^##/y A<CR>3Gpo#INDEX<CR>------<Esc>0k

    "   INDEX_NAV
    au BufRead,BufNewFile *.md nn <silent><buffer> <Space>3 :keeppatterns /<C-R>=getline('.')<CR>$<CR>zt

    "   NOTES_GREP
    au BufRead,BufNewFile $NOTES/* com! -nargs=+ Grep exec 'grep! -i <args> $NOTES/**/*.md' | cw

    "   MD_LINK
    au BufRead,BufNewFile *.md nn <silent><buffer> <Space>L 0/ttp.*\/\/\\|ww\..*\.<CR>Ea)<Esc>:let @/ = ""<CR>Bi[](<Left><Left>


    "   GPG ENC
    au BufRead,BufNewFile *.gpg.md nn <buffer><silent> <Space>E :silent %!gpg --default-recipient Clem9nt -ae 2>/dev/null<CR>
    "   GPG DEC
    au BufRead,BufNewFile *.gpg.md nn <buffer><silent> <Space>D :silent %!gpg -d 2>/dev/null<CR>


    "                       TODO LIST :

    "   TASK_ADD_TAG
    au BufRead,BufNewFile $NOTES/Lists/* nn <silent><buffer> <Tab>[ O[][]<Esc><<2f]i
    au BufRead,BufNewFile $NOTES/Lists/* nn <silent><buffer> <Tab>li O[][Life]<Esc><<$
    au BufRead,BufNewFile $NOTES/Lists/* nn <silent><buffer> <Tab>ad O[][Admi]<Esc><<$
    au BufRead,BufNewFile $NOTES/Lists/* nn <silent><buffer> <Tab>fi O[][Fina]<Esc><<$
    au BufRead,BufNewFile $NOTES/Lists/* nn <silent><buffer> <Tab>co O[][Comp]<Esc><<$
    au BufRead,BufNewFile $NOTES/Lists/* nn <silent><buffer> <Tab>mo O[][Phon]<Esc><<$
    au BufRead,BufNewFile $NOTES/Lists/* nn <silent><buffer> <Tab>no O[][Note]<Esc><<$
    au BufRead,BufNewFile $NOTES/Lists/* nn <silent><buffer> <Tab>in O[][Inet]<Esc><<$
    au BufRead,BufNewFile $NOTES/Lists/* nn <silent><buffer> <Tab>co O[][Code]<Esc><<$
    au BufRead,BufNewFile $NOTES/Lists/* nn <silent><buffer> <Tab>cr O[][Crea]<Esc><<$
    au BufRead,BufNewFile $NOTES/Lists/* nn <silent><buffer> <Tab>mi O[][Misc]<Esc><<$
    "   Tags/Life
    au BufRead,BufNewFile $NOTES/Lists/* nn <silent><buffer> <Tab>br O[][Life] break<Esc><<A<Space>
    au BufRead,BufNewFile $NOTES/Lists/* nn <silent><buffer> <Tab>di O[][Life] dinner<Esc><<A<Space>
    au BufRead,BufNewFile $NOTES/Lists/* nn <silent><buffer> <Tab>id O[][Life] idle<Esc><<$
    au BufRead,BufNewFile $NOTES/Lists/* nn <silent><buffer> <Tab>lo O[][Life] lostmyway<Esc><<$
    au BufRead,BufNewFile $NOTES/Lists/* nn <silent><buffer> <Tab>lu O[][Life] lunch<Esc><<A<Space>
    au BufRead,BufNewFile $NOTES/Lists/* nn <silent><buffer> <Tab>sp O[][Life] sport<Esc><<$
    au BufRead,BufNewFile $NOTES/Lists/* nn <silent><buffer> <Tab>tr O[][Life] transport (From -> To)<Esc><<$
    au BufRead,BufNewFile $NOTES/Lists/* nn <silent><buffer> <Tab>un O[][Life] unable<Esc><<$
    au BufRead,BufNewFile $NOTES/Lists/* nn <silent><buffer> <Tab>va O[][Life] vacation<Esc><<$
    au BufRead,BufNewFile $NOTES/Lists/* nn <silent><buffer> <Tab>? :echo "
                \\n
                \===========================[Tags]=========================\n
                \                                                         \|\n
                \ Tags:     Life → Life                                   \|\n
                \           Admi → Administrative                         \|\n
                \           Fina → Finance                                \|\n
                \           Comp → Computer                               \|\n
                \           Phon → Phone                                  \|\n
                \           Note → Notes                                  \|\n
                \           Inet → Internet                               \|\n
                \           Code → Coding                                 \|\n
                \           Crea → Creative                               \|\n
                \           Misc → Miscellaneous                          \|\n
                \                                                         \|\n
                \ Life:     break, dinner, idle, lostmyway, lunch, sport, \|\n
                \           transport, unable, vacation                   \|\n
                \                                                         \|\n
                \"<CR>

    "   TASK_FOCUS_TAG
    au BufRead,BufNewFile $NOTES/Lists/* nn <silent><buffer> <Tab>\ 0f[l

    "   TASK_ADD_ACT
    au BufRead,BufNewFile $NOTES/Lists/* nn <silent><buffer> \ch 0f[f]i chk<Esc>A<Space>
    au BufRead,BufNewFile $NOTES/Lists/* nn <silent><buffer> \di 0f[f]i dig<Esc>A<Space>
    au BufRead,BufNewFile $NOTES/Lists/* nn <silent><buffer> \st 0f[f]i std<Esc>A<Space>
    au BufRead,BufNewFile $NOTES/Lists/* nn <silent><buffer> \pr 0f[f]i prx<Esc>A<Space>
    au BufRead,BufNewFile $NOTES/Lists/* nn <silent><buffer> \th 0f[f]i thk<Esc>A<Space>

    au BufRead,BufNewFile $NOTES/Lists/* nn <silent><buffer> \se 0f[f]i stp<Esc>A<Space>
    au BufRead,BufNewFile $NOTES/Lists/* nn <silent><buffer> \up 0f[f]i upd<Esc>A<Space>
    au BufRead,BufNewFile $NOTES/Lists/* nn <silent><buffer> \fi 0f[f]i fix<Esc>A<Space>
    au BufRead,BufNewFile $NOTES/Lists/* nn <silent><buffer> \cl 0f[f]i cln<Esc>A<Space>
    au BufRead,BufNewFile $NOTES/Lists/* nn <silent><buffer> \re 0f[f]i rvw<Esc>A<Space>

    au BufRead,BufNewFile $NOTES/Lists/* nn <silent><buffer> \me 0f[f]i mee<Esc>A<Space>
    au BufRead,BufNewFile $NOTES/Lists/* nn <silent><buffer> \ca 0f[f]i cal<Esc>A<Space>
    au BufRead,BufNewFile $NOTES/Lists/* nn <silent><buffer> \ms 0f[f]i msg<Esc>A<Space>
    au BufRead,BufNewFile $NOTES/Lists/* nn <silent><buffer> \? :echo "
                \\n
                \===========[Actions]==========\n
                \                             \|\n
                \ Actions:  chk → check       \|\n
                \           dig → dig         \|\n
                \           std → study       \|\n
                \           prx → practice    \|\n
                \           thk → think       \|\n
                \                             \|\n
                \           stp → setup       \|\n
                \           upd → update      \|\n
                \           fix → fix         \|\n
                \           cln → cleanup     \|\n
                \           rvw → review      \|\n
                \                             \|\n
                \           mee → meet        \|\n
                \           cal → call        \|\n
                \           msg → msg         \|\n
                \                             \|\n
                \  ONLY FOR PRODUCTIVE TASKS  \|\n
                \                             \|\n
                \"<CR>

    "   TASK_FOCUS_ACT
    au BufRead,BufNewFile $NOTES/Lists/* nn <silent><buffer> \<Tab> 0f[f l


    "   TASK_CHECK
    au BufRead,BufNewFile $NOTES/Lists/*.md nn <silent><silent><buffer> <Space><Space> :silent let @d=strftime('%y%m%d') \| let @t=strftime('%H:%M')<CR>
                \
                \?^##\s\sToday$<CR>VG<Esc>$?\%V\[\]\\|\%V\[(.*)\]<CR>mm
                \:sil ec "go to next"<CR>
                \0di["dPa<Space><C-R>t<Esc>0
                \2j2k/^[<CR>f:t[v0f:3lc<Space><C-R>t]<Esc>'m
                \:sil ec "datestamp check"<CR>
                \:let @/ = ""<CR>:write<CR>02f]l

    "   TASK_RECHECK
    au BufRead,BufNewFile $NOTES/Lists/*.md nn <silent><silent><buffer> <Space>r mn
                \
                \:silent let @d=strftime('%y%m%d') \| let @t=strftime('%H:%M')<CR>
                \:sil ec "save current date and time"<CR>
                \GV?^##\s\sToday$<CR><Esc>$/\%V\[\d\d\d.*\]\[<CR>mm
                \:sil ec "goto current"<CR>
                \0di["dPa<Space><C-R>t<Esc>0
                \2j2k/^[<CR>f:t[v0f:3lc<Space><C-R>t]<Esc>'m
                \:sil ec "datestamp check"<CR>
                \:let @/ = ""<CR>:write<CR>`n

    "   TASK_NOW
    au BufRead,BufNewFile $NOTES/Lists/*.md nn <silent><buffer> <Space>n GV?^##\s\sToday$<CR><esc>$/\%V\[\d\d\d.*\]\[<CR>2f]2l:let @/ = ""<CR>

    "   TASK_REPEAT
    au BufRead,BufNewFile $NOTES/Lists/*.md nn <silent><buffer> <Space>. mmY
                \
                \GV?^##\s\sToday$<CR><esc>$/\%V\[\d\d\d.*\]\[<CR>:let @/ = ""<CR>
                \Pdi[$`mk

    "   TASK_BREAK
    au BufRead,BufNewFile $NOTES/Lists/*.md nn <silent><buffer> <Space>b :silent let @d=strftime('%y%m%d') \| let @t=strftime('%H:%M')<CR>
                \
                \GV?^##\s\sToday$<CR><esc>$/\%V\[\d\d\d.*\]\[<CR>
                \:sil ec "goto next"<CR>
                \O[][BREAK]<Space><Esc>mm
                \:sil ec "insert [break]"<CR>
                \0di["dPa<Space><C-R>t<Esc>0
                \2j2k/^[<CR>f:t[v0f:3lc<Space><C-R>t]<Esc>'m
                \:sil ec "datestamp check"<CR>
                \:let @/ = ""<CR>:write<CR>A<Space><Esc>

    "   TASK_BREAK_REPEAT
    au BufRead,BufNewFile $NOTES/Lists/*.md nn <silent><buffer> <Space>B :silent let @d=strftime('%y%m%d') \| let @t=strftime('%H:%M')<CR>
                \
                \GV?^##\s\sToday$<CR><esc>$/\%V\[\d\d\d.*\]\[<CR>
                \:sil ec "goto next"<CR>
                \O[][BREAK]<Space><Esc>mm
                \:sil ec "insert [break]"<CR>
                \0di["dPa<Space><C-R>t<Esc>0
                \2j2k/^[<CR>f:t[v0f:3lc<Space><C-R>t]<Esc>'m
                \:sil ec "datestamp check"<CR>
                \jYGV?^##\s\sToday$<CR><esc>$/\%V\[\d\d\d.*\]\[<CR>Pdi[$
                \:sil ec "clone current"<CR>
                \:let @/ = ""<CR>:write<CR>jA<Space>

    "   TASK_POSTPONE_TOP
    au BufRead,BufNewFile $NOTES/Lists/*.md nn <silent><buffer> <Space>P kmmj
                \jk
                \0di[V/\[.*\]<CR>kd?^##  Tomorrow$<CR>/\[TRANSITION\]<CR>p`m:let @/ = ""<CR>

    "   TASK_POSTPONE_BOT
    au BufRead,BufNewFile $NOTES/Lists/*.md nn <silent><buffer> <Space>p kmmj
                \jk
                \0di[V/\[.*\]<CR>kd?^##  Tomorrow$<CR>/\[TRANSITION\]<CR>nP`m:let @/ = ""<CR>

    "   TASK_CLEAR
    au BufRead,BufNewFile $NOTES/Lists/*.md nn <silent><buffer> <Space>c mm0di[`m

    "   TASK_FIX
    au BufRead,BufNewFile $NOTES/Lists/*.md nn <silent><buffer> <Space>f mm0
                \
                \jf:f:f]f]0
                \:sil ec "check next line"<CR>
                \l"dyawt]vT<Space>"ty
                \:sil ec "copy date and end of prev task"<CR>
                \k0a0<Esc>vaw"dpa<Space><Esc>v/\s\\|\]<CR>h"tp
                \:sil ec "paste to target task"<CR>
                \`m:let @/ = ""\|write<CR>

    "                       HISTORY

    "   TIME_DIFF
    au BufRead,BufNewFile *.md nn <buffer><silent> <Space>T V:TimeDiff<CR>J$daW0f]P<esc>0

    "   ARCHIVE_DAY
    au BufRead,BufNewFile *.md nn <buffer><silent> <Space>a :call NotesArchiveDay()<CR>

    " }}}
    " --------------------------------- DIGRAPHS {{{
    execute "digraphs as " . 0x2090
    execute "digraphs es " . 0x2091
    execute "digraphs hs " . 0x2095
    execute "digraphs is " . 0x1D62
    execute "digraphs js " . 0x2C7C
    execute "digraphs ks " . 0x2096
    execute "digraphs ls " . 0x2097
    execute "digraphs ms " . 0x2098
    execute "digraphs ns " . 0x2099
    execute "digraphs os " . 0x2092
    execute "digraphs ps " . 0x209A
    execute "digraphs rs " . 0x1D63
    execute "digraphs ss " . 0x209B
    execute "digraphs ts " . 0x209C
    execute "digraphs us " . 0x1D64
    execute "digraphs vs " . 0x1D65
    execute "digraphs xs " . 0x2093

    execute "digraphs aS " . 0x1d43
    execute "digraphs bS " . 0x1d47
    execute "digraphs cS " . 0x1d9c
    execute "digraphs dS " . 0x1d48
    execute "digraphs eS " . 0x1d49
    execute "digraphs fS " . 0x1da0
    execute "digraphs gS " . 0x1d4d
    execute "digraphs hS " . 0x02b0
    execute "digraphs iS " . 0x2071
    execute "digraphs jS " . 0x02b2
    execute "digraphs kS " . 0x1d4f
    execute "digraphs lS " . 0x02e1
    execute "digraphs mS " . 0x1d50
    execute "digraphs nS " . 0x207f
    execute "digraphs oS " . 0x1d52
    execute "digraphs pS " . 0x1d56
    execute "digraphs rS " . 0x02b3
    execute "digraphs sS " . 0x02e2
    execute "digraphs tS " . 0x1d57
    execute "digraphs uS " . 0x1d58
    execute "digraphs vS " . 0x1d5b
    execute "digraphs wS " . 0x02b7
    execute "digraphs xS " . 0x02e3
    execute "digraphs yS " . 0x02b8
    execute "digraphs zS " . 0x1dbb

    execute "digraphs AS " . 0x1D2C
    execute "digraphs BS " . 0x1D2E
    execute "digraphs DS " . 0x1D30
    execute "digraphs ES " . 0x1D31
    execute "digraphs GS " . 0x1D33
    execute "digraphs HS " . 0x1D34
    execute "digraphs IS " . 0x1D35
    execute "digraphs JS " . 0x1D36
    execute "digraphs KS " . 0x1D37
    execute "digraphs LS " . 0x1D38
    execute "digraphs MS " . 0x1D39
    execute "digraphs NS " . 0x1D3A
    execute "digraphs OS " . 0x1D3C
    execute "digraphs PS " . 0x1D3E
    execute "digraphs RS " . 0x1D3F
    execute "digraphs TS " . 0x1D40
    execute "digraphs US " . 0x1D41
    execute "digraphs VS " . 0x2C7D
    execute "digraphs WS " . 0x1D42
    " }}}
augroup END
