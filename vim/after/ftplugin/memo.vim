" --------------------------------- FUNCTIONS >>>
"   @brief Print the time difference between two tasks.
"
"   @param line1 first task.
"   @param line2 second task.

function! MemoTimeDiff(line1, line2)
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

    " hh:mm version
    " let l:min=trunc(fmod(l:diff,3600) / 60)
    " let l:hrs=trunc(l:diff / 3600)
    " " Replace the line with the result.
    " call append(a:line2, printf("%02.0f:%02.0f", l:hrs,l:min))

    " mm version
    let l:min=trunc((fmod(l:diff,3600) / 60) + (l:diff / 3600 * 60))
    call append(a:line2, printf(" %0.0f", l:min))

endfunction

command! -range MemoTimeDiff :call MemoTimeDiff(<line1>,<line2>)

"   @brief Open the link location into the current buffer.
"          Jump to the first line matching the optionally given '#pattern'
"          (Like web URLs)

function! MemoNavigate()
    " One 'path' in the current line
    if count(getline('.'), "@") == 1
        " Path extraction
        let l:path = getline('.')
        let l:chr = stridx(l:path, "@", 0) + 1
        let l:path = strpart(l:path, l:chr, strlen(l:path))
        if count(l:path, " ") >= 1
            let l:chr = stridx(l:path, " ", 0)
            let l:path = strpart(l:path, 0, l:chr)
        endif
        " If the path comes with a line pattern or not
        if count(l:path, "#") == 1
            " Line pattern extraction
            let l:path = split(l:path, "#")
            let l:file = l:path[0]
            let l:line = substitute(l:path[1], '_', '\\ ', "g")
            " If the line pattern is a number only or a string
            exec 'silent find +/^\\(.*\ @.*#\\)\\@!.*' . l:line . ' ' . l:file
            exec 'normal z.'
        else
            exec 'silent find ' . l:path
            exec 'normal z.'
        endif
        " TODO
        " Multiple 'path' in the current line
        " elseif count(getline('.'), "@") > 1
        " expand("<cword>")
    endif
endfunction

"   @brief Archive 'todo' Today done tasks to 'history' and replace it with
"          Tomorrow ones.

function! MemoArchiveDay()
    let l:save = winsaveview()
    "   Check file
    if expand('%:t:r') . "." . expand('%:e') != "todo.md"
        echom ">>> Not in \"todo.md\" <<<"
        return 1
    endif
    "   Check stats TODO check if there is no ? instead the len
    " if strlen(getline(searchpos("^\\[-\\]\\[pm\\]")[0])) =~ 'X'
    "     echom ">>> Incomplete \"pm\" stats <<<"
    "     return 1
    " endif
    " if strlen(getline(searchpos("^\\[-\\]\\[am\\]")[0])) =~ 'X'
    "     echom ">>> Incomplete \"am\" stats <<<"
    "     return 1
    " endif
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
    "   Copy today
    let l:today_tasks = getline(l:today_loc + 1, line('$'))
    "   Copy and reset SLEEP
    let l:today_sleep = getline(line('$'))
    let l:today_sleep = substitute(
                \l:today_sleep, strpart(l:today_sleep, 1, 6), "-", "")
    "   Archive it
    write
    execute "silent edit $MEMO/Lists/history.gpg.md"
    call append(5, l:today_tasks)
    write
    "   Delete today
    execute "silent edit #"
    execute "silent " . l:today_loc . ",$delete"
    delete
    "   Update Today
    call append(line('$'), l:today_sleep)
    call append(l:tomorrow_loc + 1, "[-][>>] diary:")
    call append(l:tomorrow_loc + 1, "[-][>>]")

    " bda

    " call append(l:tomorrow_loc + 1, "[-][>>] ingestion_break: water, X ,genmaicha tea")
    " call append(l:tomorrow_loc + 1, "[-][>>] ingestion_lunch: water, bread, X, coffee, chocolate")
    " call append(l:tomorrow_loc + 1, "[-][>>] ingestion_diner: water, bread, X")
    " call append(l:tomorrow_loc + 1, "[-][>>] ingestion_snack:")
    " call append(l:tomorrow_loc + 1, "[-][>>] ingestion_other:")
    " call append(l:tomorrow_loc + 1, "[-][>>]")
    " call append(l:tomorrow_loc + 1, "[-][>>] workout:   pullup                   5       xX")
    " call append(l:tomorrow_loc + 1, "[-][>>] workout: during the day")
    " call append(l:tomorrow_loc + 1, "[-][>>] workout:")
    " call append(l:tomorrow_loc + 1, "[-][>>] workout:   elastiband               40      x2")
    " call append(l:tomorrow_loc + 1, "[-][>>] workout:   abWheel                  5       x2")
    " call append(l:tomorrow_loc + 1, "[-][>>] workout:   pushup                   12      x2")
    " call append(l:tomorrow_loc + 1, "[-][>>] workout:   abs                      20      x2")
    " call append(l:tomorrow_loc + 1, "[-][>>] workout:   legflexion (+ gripring)  10x2    x2")
    " call append(l:tomorrow_loc + 1, "[-][>>] workout:   calfRaises (+ gripRing)  20x2    x2")
    " call append(l:tomorrow_loc + 1, "[-][>>] workout: series")

    " home

    call append(l:tomorrow_loc + 1, "[-][>>] ingestion_break: water, X, genmaicha tea")
    call append(l:tomorrow_loc + 1, "[-][>>] ingestion_lunch: water, X, genmaicha tea")
    call append(l:tomorrow_loc + 1, "[-][>>] ingestion_diner: water, X, anis infusion")
    call append(l:tomorrow_loc + 1, "[-][>>] ingestion_snack: water, X")
    call append(l:tomorrow_loc + 1, "[-][>>] ingestion_other: magnesium, X")
    call append(l:tomorrow_loc + 1, "[-][>>]")
    call append(l:tomorrow_loc + 1, "[-][>>] workout:   elastiband               50      x2")
    call append(l:tomorrow_loc + 1, "[-][>>] workout:   BicycleCrunch            4x10    x2")
    call append(l:tomorrow_loc + 1, "[-][>>] workout:   pushup                   20      x2")
    call append(l:tomorrow_loc + 1, "[-][>>] workout:   abs                      30      x2")
    call append(l:tomorrow_loc + 1, "[-][>>] workout:   legflexion (+ gripring)  15x2    x2")
    call append(l:tomorrow_loc + 1, "[-][>>] workout:   calfRaises (+ warmUp)    30x2    x2")
    call append(l:tomorrow_loc + 1, "[-][>>] workout: series")


    call append(l:tomorrow_loc + 1, "[-][>>]")
    call append(l:tomorrow_loc + 1, "[-][>>] pm_keywords:")
    call append(l:tomorrow_loc + 1, "[-][>>] pm_breaches:")
    call append(l:tomorrow_loc + 1, "[-][>>] pm_feedback: fo X yi X co X")
    call append(l:tomorrow_loc + 1, "[-][>>] pm_end: ph X me X mo X st X")
    call append(l:tomorrow_loc + 1, "[-][>>] pm_beg: ph X me X mo X st X")
    call append(l:tomorrow_loc + 1, "[-][>>]")
    call append(l:tomorrow_loc + 1, "[-][>>] am_keywords:")
    call append(l:tomorrow_loc + 1, "[-][>>] am_breaches:")
    call append(l:tomorrow_loc + 1, "[-][>>] am_feedback: fo X yi X co X")
    call append(l:tomorrow_loc + 1, "[-][>>] am_end: ph X me X mo X st X")
    call append(l:tomorrow_loc + 1, "[-][>>] am_beg: ph X me X mo X st X")
    call append(l:tomorrow_loc + 1, "")
    call append(l:tomorrow_loc + 1, "##  Today")
    call append(l:tomorrow_loc + 1, "")
    if l:checkday == 0
        call append(line('$') - 2, "[][1] XXX broken history XXX")
    endif

    "   bda

    " call append(l:tomorrow_loc + 1, "[(06:20)][0] wake up + practice mental rehearsal")
    " call append(l:tomorrow_loc + 1, "[(06:30)][0] breakfast + @noesis update todo notes")
    " call append(l:tomorrow_loc + 1, "[(06:55)][0] practice loving-kindness meditation")
    " call append(l:tomorrow_loc + 1, "")
    " call append(l:tomorrow_loc + 1, "[(09:15)][0] pause (stretch)")
    " call append(l:tomorrow_loc + 1, "")
    " call append(l:tomorrow_loc + 1, "[(11:30)][0] practice home workout 20min + listen civilisation mésopotamienne podcast")
    " call append(l:tomorrow_loc + 1, "[(11:50)][0] prepare")
    " call append(l:tomorrow_loc + 1, "[(12:00)][0] lunch with poumou")
    " call append(l:tomorrow_loc + 1, "[(12:40)][0] watch tv + interact with socialmedia + @noesis import phone notes")
    " call append(l:tomorrow_loc + 1, "[(12:40)][0] watch tv + interact with socialmedia + @noesis clear X notes")
    " call append(l:tomorrow_loc + 1, "[(12:40)][0] watch tv + interact with socialmedia + @noesis update todo tasks design")
    " call append(l:tomorrow_loc + 1, "[(13:40)][0] practice empty mind meditation {}")
    " call append(l:tomorrow_loc + 1, "")
    " call append(l:tomorrow_loc + 1, "[(16:00)][0] pause (stretch)")
    " call append(l:tomorrow_loc + 1, "")
    " call append(l:tomorrow_loc + 1, "[(19:00)][0] dine with poumou")
    " call append(l:tomorrow_loc + 1, "[(19:40)][0] watch tv + interact with socialmedia + @noesis clear X notes")
    " call append(l:tomorrow_loc + 1, "[(20:00)][0] watch tv + interact with socialmedia + @noesis update todo tasks design")
    " call append(l:tomorrow_loc + 1, "[(20:40)][0] practice body scan meditation")
    " call append(l:tomorrow_loc + 1, "[(20:45)][0] practice gratitude meditation")
    " call append(l:tomorrow_loc + 1, "[(20:50)][0] fall asleep (plane mode) + listen civilisation mésopotamienne podcast")

    "   paris home

    call append(l:tomorrow_loc + 1, "[(06:20)][0] wake up + practice mental rehearsal")
    call append(l:tomorrow_loc + 1, "[(06:30)][0] breakfast + @noesis update todo notes")
    call append(l:tomorrow_loc + 1, "[(06:55)][0] practice loving-kindness meditation")
    call append(l:tomorrow_loc + 1, "")
    call append(l:tomorrow_loc + 1, "[(09:15)][0] pause (stretch)")
    call append(l:tomorrow_loc + 1, "")
    call append(l:tomorrow_loc + 1, "[(11:30)][0] practice home workout + listen civilisation mésopotamienne podcast")
    call append(l:tomorrow_loc + 1, "[(11:40)][0] prepare")
    call append(l:tomorrow_loc + 1, "[(11:50)][0] cook + listen civilisation mésopotamienne podcast")
    call append(l:tomorrow_loc + 1, "[(12:20)][0] lunch + listen civilisation mésopotamienne podcast")
    call append(l:tomorrow_loc + 1, "[(12:40)][0] interact with socialmedia + @noesis import phone notes")
    call append(l:tomorrow_loc + 1, "[(12:40)][0] interact with socialmedia + @noesis clear X notes")
    call append(l:tomorrow_loc + 1, "[(12:40)][0] interact with socialmedia + @noesis update todo tasks design")
    call append(l:tomorrow_loc + 1, "[(13:40)][0] practice empty mind meditation {}")
    call append(l:tomorrow_loc + 1, "")
    call append(l:tomorrow_loc + 1, "[(16:00)][0] pause (stretch)")
    call append(l:tomorrow_loc + 1, "")
    call append(l:tomorrow_loc + 1, "[(18:50)][0] cook + listen civilisation mésopotamienne podcast")
    call append(l:tomorrow_loc + 1, "[(19:20)][0] dine + listen civilisation mésopotamienne podcast")
    call append(l:tomorrow_loc + 1, "[(19:40)][0] interact with socialmedia + @noesis import phone notes")
    call append(l:tomorrow_loc + 1, "[(19:40)][0] interact with socialmedia + @noesis clear X notes")
    call append(l:tomorrow_loc + 1, "[(19:40)][0] interact with socialmedia + @noesis update todo tasks design")
    call append(l:tomorrow_loc + 1, "[(20:40)][0] practice body scan meditation")
    call append(l:tomorrow_loc + 1, "[(20:45)][0] practice gratitude meditation")
    call append(l:tomorrow_loc + 1, "[(20:50)][0] fall asleep (plane mode) + listen civilisation mésopotamienne podcast")

    "   42

    " call append(l:tomorrow_loc + 1, '[][0] get up')
    " call append(l:tomorrow_loc + 1, '[][0] breakfast + book')
    " call append(l:tomorrow_loc + 1, '[][0] home sport Xmin + news tech')
    " call append(l:tomorrow_loc + 1, '[][0] prepare + news tech')
    " call append(l:tomorrow_loc + 1, '[][0] transport + X')
    " call append(l:tomorrow_loc + 1, '[][0] cc')
    " call append(l:tomorrow_loc + 1, '[][0] lunch + X')
    " call append(l:tomorrow_loc + 1, '[][0] cc')
    " call append(l:tomorrow_loc + 1, '[][0] transport + X')
    " call append(l:tomorrow_loc + 1, '[][0] dine + X')
    " call append(l:tomorrow_loc + 1, '[][0] bed + podcast')

    write
    call winrestview(l:save)
    return 0
endfunction

" <<<

augroup filetype_memo
    autocmd!
    " --------------------------------- OPTIONS >>>
    au BufRead,BufNewFile *.md,*.markdown,*.MD,*.MARKDOWN set filetype=memo
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
                \ | syntax sync fromstart

    au FileType memo
                \   setl formatoptions+=ro
                \ | setl comments+=s:[-][>>],m:[-][>>],e:[-][>>]

    au BufRead,BufNewFile $MEMO/Lists/history.gpg.md setl textwidth=0 " TODO doesnt work

    " GPG
    au BufReadPre,FileReadPre *.gpg.* setl viminfo=""
    au BufReadPre,FileReadPre *.gpg.* setl noswapfile noundofile nobackup
    au BufReadPost,FileReadPost *.gpg.* if getline('1') == '-----BEGIN PGP MESSAGE-----' |
                \ exec 'silent %!gpg --decrypt 2>/dev/null' | setl title titlestring='ENCRYPTED' |
                \ endif
    au BufWritePre,FileWritePre *.gpg.* let g:view = winsaveview() | keeppatterns %s/\s\+$//e |
                \exec 'silent %!gpg --default-recipient $GPG_KEY --armor --encrypt 2>/dev/null'
    au BufWritePost,FileWritePost *.gpg.* exec "normal! u"|
                \ call winrestview(g:view) | setl title!
    " <<<
    " --------------------------------- MAPPINGS >>>

    au FileType memo let maplocalleader = "gh"
    au FileType memo nn <buffer><silent> <LocalLeader> <nop>

    "   MemoTimeDiff
    au FileType memo nn <buffer><silent> <LocalLeader>D V:MemoTimeDiff<CR>J$daW0f]P<esc>0

    "   ArchiveDay
    au FileType memo nn <buffer><silent> <LocalLeader>A :call MemoArchiveDay()<CR>
                \:sil cd $MEMO/<CR>
                \:sil !git add -f INDEX.md Lists Areas Projects Resources Archives<CR>
                \:sil !git commit -m "Archive"<CR>:redraw!<CR>

    "   MappingInfo
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
                \ GPG_ENC           : Space E          \|\n
                \ GPG_DEC           : Space C          \|\n
                \                                      \|\n
                \"<CR>

    au BufRead,BufNewFile $MEMO/Lists/todo.md nn <silent><buffer> <LocalLeader>? :echo "
                \\n
                \================[Todos]================\n
                \                                      \|\n
                \ TASK_TAG_HELP     : Tab   ?          \|\n
                \ TASK_ADD_TAG      : Tab   …          \|\n
                \                                      \|\n
                \ TASK_CHECK        : Space Space      \|\n
                \ TASK_RECHECK      : Space r          \|\n
                \ TASK_NOW          : Space n          \|\n
                \ TASK_PAUSE        : Space p          \|\n
                \ TASK_PAUSE_REPEAT : Space P          \|\n
                \ TASK_POSTPONE     : Space ↑          \|\n
                \ TASK_CLEAR        : Space c          \|\n
                \ TASK_FIX          : Space f          \|\n
                \                                      \|\n
                \ ARCHIVE_DAY       : Space A          \|\n
                \ TIME_DIFF         : Space T          \|\n
                \                                      \|\n
                \ ROT >>            : Space g13        \|\n
                \                                      \|\n
                \"<CR>


    "                       SAFETY :

    au FileType memo nn <silent><buffer> <space>= <nop>
    au FileType memo vn <silent><buffer> <space>= <nop>
    au FileType memo vn <silent><buffer> = <nop>
    au FileType memo nn <silent><buffer> = <nop>
    au FileType memo vn <silent><buffer> gq <nop>
    au FileType memo nn <silent><buffer> gq <nop>
    au FileType memo nn <silent><buffer> gwG <nop>
    au FileType memo nn <silent><buffer> gwgo <nop>
    au FileType memo nn <silent><buffer> gwgg <nop>


    "                       GENERAL :

    "   HTML_EXPORT
    au FileType memo nn <silent><buffer> <LocalLeader>X :set term=xterm-256color<CR>:TOhtml<CR>
                \
                \/--><CR>Oa { color: hotpink; }<Esc>go
                \:%s/background-color: \#000000; }$/background-color: \#2e333f; }/g<CR>
                \:%s/\* { font-size: 1em; }$/\* { font-size: 1.1em; }/g<CR>
                \:%s/\.memoH1 { color: #5fffaf; }$/.memoH1 { color: #5fffaf; font-size: 120%; }/g<CR>
                \:%s/\.memoUrl { color: #ff5faf; text-decoration: underline; }$/.memoUrl { color: #ff5faf; text-decoration: underline; font-size: 90%; }/g<CR>
                \go/<span class="memoBlockquote">&gt; </span><CR>cc<span class="memoBlockquote">&gt; </span> cvidon@student.42.fr<Esc>go
                \:fix}}<Esc>

    "   PULL_MEMO
    au BufRead,BufNewFile $MEMO/Lists/*.md nn <silent><buffer> ghpl :cd %:h\|sil !git pull<CR>:redraw!<CR>

    "   PUSH_MEMO
    au BufRead,BufNewFile $MEMO/Lists/*.md nn <silent><buffer> ghps :echo "Push"<CR>:w\|lc %:h<CR>
                \:sil !rm $DOTVIM/.swp/*%*.swp<CR>
                \:sil cd $MEMO/<CR>
                \:sil !git add -f INDEX.md Lists Areas Projects Resources Archives<CR>
                \:sil !git commit -m "Push"<CR>:sil !git push origin main<CR>
                \:q<CR>:redr!<CR>


    "   MemoNavigate
    au FileType memo nn <silent><buffer> <LocalLeader>g :silent write<CR>gogF
    au FileType memo nn <silent><buffer> <LocalLeader>h mm:silent write<CR>`m0:call MemoNavigate()<CR>

    "   INDEX_GEN
    au FileType memo nn <silent><buffer> <LocalLeader>I :silent
                \
                \ :let @a=""<CR>:keeppatterns g/^##/y A<CR>3Gpo#INDEX<CR>------<Esc>0k

    "   INDEX_NAV
    au FileType memo nn <silent><buffer> <LocalLeader>i :keeppatterns /<C-R>=getline('.')<CR>$<CR>zt

    "   MEMO_GREP
    au BufRead,BufNewFile $MEMO/* com! -nargs=+ Grep exec 'grep! -i <args> $MEMO/**/*.md' | cw

    "   MD_LINK
    au FileType memo nn <silent><buffer> <LocalLeader>l 0/ttp.*\/\/\\|ww\..*\.<CR>Ea)<Esc>:let @/ = ""<CR>Bi[](<Left><Left>


    "   GPG ENC
    au BufRead,BufNewFile *.gpg.md nn <buffer><silent> <LocalLeader>enc :silent %!gpg --default-recipient Clem9nt -ae 2>/dev/null<CR>
    "   GPG DEC
    au BufRead,BufNewFile *.gpg.md nn <buffer><silent> <LocalLeader>dec :silent %!gpg -d 2>/dev/null<CR>

    "                       TODO LIST :

    "   TASK_ADD
    au BufRead,BufNewFile $MEMO/Lists/* nn <silent><buffer> <Leader>t O[][1]<Esc><<$A<Space>

    "   TASK_CHECK
    au BufRead,BufNewFile $MEMO/Lists/*.md nn <silent><silent><buffer> <Space><Space> :silent let @d=strftime('%y%m%d') \| let @t=strftime('%H:%M')<CR>
                \
                \?^##\s\sToday$<CR>VG<Esc>$?\%V\[\]\\|\%V\[(.*)\]<CR>mm
                \:sil ec "go to next"<CR>
                \0di["dPa<Space><C-R>t<Esc>0
                \2j2k/^[<CR>f:t[v0f:3lc<Space><C-R>t]<Esc>'m
                \:sil ec "datestamp check"<CR>
                \:let @/ = ""<CR>:write<CR>02f]l

    "   TASK_RECHECK
    au BufRead,BufNewFile $MEMO/Lists/*.md nn <silent><silent><buffer> <Leader>r mn
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
    au BufRead,BufNewFile $MEMO/Lists/*.md nn <silent><buffer> <Leader>. GV?^##\s\sToday$<CR><esc>$/\%V\[\d\d\d.*\]\[<CR>2f]2l:let @/ = ""<CR>

    "   TASK_PAUSE
    au BufRead,BufNewFile $MEMO/Lists/*.md nn <silent><buffer> <Leader>p :silent let @d=strftime('%y%m%d') \| let @t=strftime('%H:%M')<CR>
                \
                \GV?^##\s\sToday$<CR><esc>$/\%V\[\d\d\d.*\]\[<CR>
                \:sil ec "goto next"<CR>
                \O[][1] pause<Space><Esc>mm
                \:sil ec "insert pause"<CR>
                \0di["dPa<Space><C-R>t<Esc>0
                \2j2k/^[<CR>f:t[v0f:3lc<Space><C-R>t]<Esc>'m
                \:sil ec "datestamp check"<CR>
                \:let @/ = ""<CR>:write<CR>A<Space><Space><Esc>

    "   TASK_PAUSE_REPEAT
    au BufRead,BufNewFile $MEMO/Lists/*.md nn <silent><buffer> <Leader>P :silent let @d=strftime('%y%m%d') \| let @t=strftime('%H:%M')<CR>
                \
                \GV?^##\s\sToday$<CR><esc>$/\%V\[\d\d\d.*\]\[<CR>
                \:sil ec "goto next"<CR>
                \O[][1] pause<Space><Esc>mm
                \:sil ec "insert [pause]"<CR>
                \0di["dPa<Space><C-R>t<Esc>0
                \2j2k/^[<CR>f:t[v0f:3lc<Space><C-R>t]<Esc>'m
                \:sil ec "datestamp check"<CR>
                \jYGV?^##\s\sToday$<CR><esc>$/\%V\[\d\d\d.*\]\[<CR>Pdi[$
                \:sil ec "clone current"<CR>
                \:let @/ = ""<CR>:write<CR>jA<Space><Space><Esc>

    "   TASK_POSTPONE
    au BufRead,BufNewFile $MEMO/Lists/*.md nn <silent><buffer> <LocalLeader>k <LocalLeader><Up> kmmj
                \jk
                \0di[V/\[.*\]<CR>kd?^##  Today$<CR>?[wake<CR>P`m:let @/ = ""<CR>

    "   TASK_CLEAR
    au BufRead,BufNewFile $MEMO/Lists/*.md nn <silent><buffer> <Leader>c mm0di[`m

    "   TASK_FIX
    au BufRead,BufNewFile $MEMO/Lists/*.md nn <silent><buffer> <Leader>f mm0
                \
                \jf:f:f]f]0
                \:sil ec "check next line"<CR>
                \l"dyawt]vT<Space>"ty
                \:sil ec "copy date and end of prev task"<CR>
                \k0a0<Esc>vaw"dpa<Space><Esc>v/\s\\|\]<CR>h"tp
                \:sil ec "paste to target task"<CR>
                \`m:let @/ = ""\|write<CR>

    "                       HISTORY

    "   ROT
    au FileType memo nn <buffer><silent> <LocalLeader>R Mmm
                \
                \:keeppatterns g/\[>>\]/norm g??<CR>
                \`mzz3<C-O>

    " <<<
    " --------------------------------- DIGRAPHS >>>
    "
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


"   task switch
au FileType memo nn <buffer><silent> <LocalLeader>s 02f]lv$hdj02f]lv$hpk$p
au FileType memo nn <buffer><silent> <LocalLeader>S 02f]lv$hdk02f]lv$hpj$p

"   task merge (or unite, union, join, aggregate, unify..)
au FileType memo nn <buffer><silent> <LocalLeader>m  mm
            \0di[jf]B"yyt]
            \k0a<C-e><C-e><C-e><C-e><C-e><C-e><Space>
            \<C-r>y<Space><C-r>y<Esc>
            \`mk

"   weekly review
au FileType memo vn <buffer><silent> <LocalLeader>wr go
            \VG:norm d3f<Space><CR>
            \gv:norm f]D<CR>
            \gvk:norm A+<CR>
            \gvjgJ


"   task group
" au FileType memo nn <buffer><silent> <Space>g mm0jyf]kvf]pk`m
" au FileType memo nn <buffer><silent> <Space>G mm0kyf]jvf]pk`m
