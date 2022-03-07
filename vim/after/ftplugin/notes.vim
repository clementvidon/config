augroup FILETYPE_NOTES
    autocmd!
    " --------------------------------- OPTIONS {{{
    au BufRead,BufNewFile *.md
                \   set filetype=notes
                \ | setl textwidth=70
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
        "    let l:t1List = split(getline(a:line1), " ")
        "    let l:t2List = split(getline(a:line2), " ")
        "    let l:t1List = split((l:t1List[1]), ":")
        "    let l:t2List = split((l:t2List[1]), ":")
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
        let l:line = split(getline('.'), ":")
        let l:file = substitute(l:line[0], '>', '', "g")
        let l:pattern = substitute(l:line[1], ' ', '\\ ', "g")
        if l:pattern =~# '^\d\+$'
            exec 'gF'
        else
            exec 'find +/' . l:pattern . ' ' . l:file
        endif
    endfun
    command! -range NotesGF :call NotesGF()
    " }}}
    " --------------------------------- MAPPINGS {{{
    au BufRead,BufNewFile $NOTES/Lists/* nn <silent><buffer> <Space>? :echo "
                \\n
                \================[Notes]================\n
                \                                      \|\n
                \ MOVE_LINES        : gj gk            \|\n
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

    "   MOVE_LINES
    au BufRead,BufNewFile *.md nn <silent><buffer> gj :m .+1<CR>
    au BufRead,BufNewFile *.md nn <silent><buffer> gk :m .-2<CR>
    au BufRead,BufNewFile *.md vn <silent><buffer> gj :m '>+1<CR>gv
    au BufRead,BufNewFile *.md vn <silent><buffer> gk :m '<-2<CR>gv

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
    au BufRead,BufNewFile *.md nn <silent><buffer> <Space>L 0/s:\/\/<CR>Ea)<Esc>:let @/ = ""<CR>Bi[](<Left><Left>


    "   GPG ENC
    au BufRead,BufNewFile *.gpg.md nn <buffer><silent> <Space>E :silent %!gpg --default-recipient Clem9nt -ae 2>/dev/null<CR>
    "   GPG DEC
    au BufRead,BufNewFile *.gpg.md nn <buffer><silent> <Space>D :silent %!gpg -d 2>/dev/null<CR>


    "                       TODO LIST :

    "   TASK_ADD_TAG
    au BufRead,BufNewFile $NOTES/Lists/* nn <silent><buffer> <Tab><Tab> O[][]<Esc><<2f]i
    "   Projects
    au BufRead,BufNewFile $NOTES/Lists/* nn <silent><buffer> <Tab>no O[][Notes]<Esc><<$
    au BufRead,BufNewFile $NOTES/Lists/* nn <silent><buffer> <Tab>sb O[][Sbb]<Esc><<$
    au BufRead,BufNewFile $NOTES/Lists/* nn <silent><buffer> <Tab>4  O[][42]<Esc><<$
    "   Areas
    au BufRead,BufNewFile $NOTES/Lists/* nn <silent><buffer> <Tab>bu O[][Business]<Esc><<$
    au BufRead,BufNewFile $NOTES/Lists/* nn <silent><buffer> <Tab>pc O[][Computer]<Esc><<$
    au BufRead,BufNewFile $NOTES/Lists/* nn <silent><buffer> <Tab>fi O[][Finance]<Esc><<$
    au BufRead,BufNewFile $NOTES/Lists/* nn <silent><buffer> <Tab>he O[][Health]<Esc><<$
    au BufRead,BufNewFile $NOTES/Lists/* nn <silent><buffer> <Tab>fa O[][Family]<Esc><<$
    au BufRead,BufNewFile $NOTES/Lists/* nn <silent><buffer> <Tab>so O[][Social]<Esc><<$
    au BufRead,BufNewFile $NOTES/Lists/* nn <silent><buffer> <Tab>ad O[][Admin]<Esc><<$
    au BufRead,BufNewFile $NOTES/Lists/* nn <silent><buffer> <Tab>pt O[][Photo]<Esc><<$
    au BufRead,BufNewFile $NOTES/Lists/* nn <silent><buffer> <Tab>ph O[][Phone]<Esc><<$
    au BufRead,BufNewFile $NOTES/Lists/* nn <silent><buffer> <Tab>ho O[][Home]<Esc><<$
    au BufRead,BufNewFile $NOTES/Lists/* nn <silent><buffer> <Tab>mi O[][Misc]<Esc><<$
    au BufRead,BufNewFile $NOTES/Lists/* nn <silent><buffer> <Tab>se O[][Self]<Esc><<$
    au BufRead,BufNewFile $NOTES/Lists/* nn <silent><buffer> <Tab>mi O[][Art]<Esc><<$
    au BufRead,BufNewFile $NOTES/Lists/* nn <silent><buffer> <Tab>we O[][Web]<Esc><<$
    "   Special
    au BufRead,BufNewFile $NOTES/Lists/* nn <silent><buffer> <Tab>lo O[][LOSTMYWAY]<Esc><<$
    au BufRead,BufNewFile $NOTES/Lists/* nn <silent><buffer> <Tab>de O[][DEADTIME]<Esc><<$
    au BufRead,BufNewFile $NOTES/Lists/* nn <silent><buffer> <Tab>va O[][VACATION]<Esc><<$
    au BufRead,BufNewFile $NOTES/Lists/* nn <silent><buffer> <Tab>tr O[][TRANSIT]<Esc><<$
    au BufRead,BufNewFile $NOTES/Lists/* nn <silent><buffer> <Tab>tv O[][TRAVEL]from -> to<Esc><<$
    au BufRead,BufNewFile $NOTES/Lists/* nn <silent><buffer> <Tab>un O[][UNABLE]<Esc><<$
    au BufRead,BufNewFile $NOTES/Lists/* nn <silent><buffer> <Tab>br O[][BREAK]<Esc><<A
    au BufRead,BufNewFile $NOTES/Lists/* nn <silent><buffer> <Tab>sp O[][SPORT]<Esc><<$
    au BufRead,BufNewFile $NOTES/Lists/* nn <silent><buffer> <S-Tab> :echo "
                \\n
                \=============================[Tags]=============================\n
                \                                                               \|\n
                \ Projects: Notes    →                                          \|\n
                \           Sbb      →                                          \|\n
                \           42       →                                          \|\n
                \                                                               \|\n
                \ Areas:    Business → management, marketing, clients, products \|\n
                \           Computer →                                          \|\n
                \           Finance  → ledger, assets                           \|\n
                \           Health   → eat, drugs                               \|\n
                \           Family   →                                          \|\n
                \           Social   →                                          \|\n
                \           Admin    → urssaf, impots, casvp                    \|\n
                \           Photo    →                                          \|\n
                \           Phone    →                                          \|\n
                \           Home     →                                          \|\n
                \           Misc     →                                          \|\n
                \           Self     →                                          \|\n
                \           Art      →                                          \|\n
                \           Web      →                                          \|\n
                \                                                               \|\n
                \ LOSTMYWAY DEADTIME VACATION TRANSIT TRAVEL UNABLE BREAK SPORT \|\n
                \                                                               \|\n
                \"<CR>

    "   TASK_FOCUS_TAG
    au BufRead,BufNewFile $NOTES/Lists/* nn <silent><buffer> <Tab>\ 0f[l

    "   TASK_ADD_ACT
    au BufRead,BufNewFile $NOTES/Lists/* nn <silent><buffer> \th 0f[f]i think<Esc>A<Space>
    au BufRead,BufNewFile $NOTES/Lists/* nn <silent><buffer> \ch 0f[f]i check<Esc>A<Space>
    au BufRead,BufNewFile $NOTES/Lists/* nn <silent><buffer> \st 0f[f]i study<Esc>A<Space>
    au BufRead,BufNewFile $NOTES/Lists/* nn <silent><buffer> \pr 0f[f]i practice<Esc>A<Space>
    au BufRead,BufNewFile $NOTES/Lists/* nn <silent><buffer> \di 0f[f]i dig<Esc>A<Space>

    au BufRead,BufNewFile $NOTES/Lists/* nn <silent><buffer> \cr 0f[f]i create<Esc>A<Space>
    au BufRead,BufNewFile $NOTES/Lists/* nn <silent><buffer> \up 0f[f]i update<Esc>A<Space>
    au BufRead,BufNewFile $NOTES/Lists/* nn <silent><buffer> \cl 0f[f]i cleanup<Esc>A<Space>
    au BufRead,BufNewFile $NOTES/Lists/* nn <silent><buffer> \re 0f[f]i review<Esc>A<Space>
    au BufRead,BufNewFile $NOTES/Lists/* nn <silent><buffer> \se 0f[f]i setup<Esc>A<Space>
    au BufRead,BufNewFile $NOTES/Lists/* nn <silent><buffer> \fk 0f[f]i fix<Esc>A<Space>

    au BufRead,BufNewFile $NOTES/Lists/* nn <silent><buffer> \me 0f[f]i meet<Esc>A<Space>
    au BufRead,BufNewFile $NOTES/Lists/* nn <silent><buffer> \ca 0f[f]i call<Esc>A<Space>
    au BufRead,BufNewFile $NOTES/Lists/* nn <silent><buffer> \ms 0f[f]i msg<Esc>A<Space>
    au BufRead,BufNewFile $NOTES/Lists/* nn <silent><buffer> <BAR> :echo "
                \\n
                \=[Actions]=\n
                \          \|\n
                \ think    \|\n
                \ check    \|\n
                \ study    \|\n
                \ practice \|\n
                \ dig      \|\n
                \          \|\n
                \ create   \|\n
                \ update   \|\n
                \ cleanup  \|\n
                \ review   \|\n
                \ setup    \|\n
                \ fix      \|\n
                \          \|\n
                \ meet     \|\n
                \ call     \|\n
                \ msg      \|\n
                \          \|\n
                \"<CR>

    "   TASK_FOCUS_ACT
    au BufRead,BufNewFile $NOTES/Lists/* nn <silent><buffer> \<Tab> 0f[f l


    "   TASK_CHECK
    au BufRead,BufNewFile $NOTES/Lists/*.md nn <silent><silent><buffer> <Space><Space> :silent let @d=strftime('%y%m%d') \| let @t=strftime('%H:%M')<CR>
                \
                \?#\s\s[\sTOD<CR>VG<esc>$?\%V\[\]\\|\[(.*)\]<CR>mm
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
                \GV?#\s\s[\sTOD<CR><esc>$/\%V\[\d\d\d.*\]\[<CR>mm
                \:sil ec "goto current"<CR>
                \0di["dPa<Space><C-R>t<Esc>0
                \2j2k/^[<CR>f:t[v0f:3lc<Space><C-R>t]<Esc>'m
                \:sil ec "datestamp check"<CR>
                \:let @/ = ""<CR>:write<CR>`n

    "   TASK_NOW
    au BufRead,BufNewFile $NOTES/Lists/*.md nn <silent><buffer> <Space>n GV?#\s\s[\sTOD<CR><esc>$/\%V\[\d\d\d.*\]\[<CR>2f]2l:let @/ = ""<CR>

    "   TASK_REPEAT
    au BufRead,BufNewFile $NOTES/Lists/*.md nn <silent><buffer> <Space>. mmY
                \
                \GV?#\s\s[\sTOD<CR><esc>$/\%V\[\d\d\d.*\]\[<CR>:let @/ = ""<CR>
                \Pdi[$`mk

    "   TASK_BREAK
    au BufRead,BufNewFile $NOTES/Lists/*.md nn <silent><buffer> <Space>b :silent let @d=strftime('%y%m%d') \| let @t=strftime('%H:%M')<CR>
                \
                \GV?#\s\s[\sTOD<CR><esc>$/\%V\[\d\d\d.*\]\[<CR>
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
                \GV?#\s\s[\sTOD<CR><esc>$/\%V\[\d\d\d.*\]\[<CR>
                \:sil ec "goto next"<CR>
                \O[][BREAK]<Space><Esc>mm
                \:sil ec "insert [break]"<CR>
                \0di["dPa<Space><C-R>t<Esc>0
                \2j2k/^[<CR>f:t[v0f:3lc<Space><C-R>t]<Esc>'m
                \:sil ec "datestamp check"<CR>
                \jYGV?#\s\s[\sTOD<CR><esc>$/\%V\[\d\d\d.*\]\[<CR>Pdi[$
                \:sil ec "clone current"<CR>
                \:let @/ = ""<CR>:write<CR>jA<Space>

    "   TASK_POSTPONE_TOP
    au BufRead,BufNewFile $NOTES/Lists/*.md nn <silent><buffer> <Space>P kmmj
                \jk
                \0di[V/\[.*\]<CR>kd?[ TOM<CR>/\[TRANSIT\]<CR>p`m:let @/ = ""<CR>

    "   TASK_POSTPONE_BOT
    au BufRead,BufNewFile $NOTES/Lists/*.md nn <silent><buffer> <Space>p kmmj
                \jk
                \0di[V/\[.*\]<CR>kd?[ TOM<CR>/\[TRANSIT\]<CR>nP`m:let @/ = ""<CR>

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

    "   ARCHIVE_DAY
    au BufRead,BufNewFile $NOTES/Lists/todo.md nn <silent><buffer> <Space>A /\[\d.*\]\[END\]<CR>
                \:sil ec "check that end is checked"<CR>
                \
                \G?^#\s\s[\sTOD<CR>
                \:sil ec "go to '[ today ]'"<CR>
                \
                \:let @d= '#[ ' . strftime('%a %d %b %Y') . ' ]'<CR>o<Esc>"dp
                \:sil ec "paste the current date under '[ today ]'"<CR>
                \
                \:let @d=strftime('%y%m%d')<CR>
                \:sil ec "yank a datestamp into 'd'"<CR>
                \
                \?#\s\s[\sTOD<CR>VG<Esc>$
                \?\%VSLEEP]<CR>"lY?STAT]<CR>"sY
                \:sil ec "yank 'sleep'line -> 'l' and 'stat'line -> 's'"<CR>
                \
                \:g/^\[\-/norm lv"dp<CR>
                \:sil ec "datestamp 'sleep' and 'stat' lines"<CR>
                \
                \?^#  [ TOM<CR>jV/^#  [ TOD<CR>kdO<Esc>
                \:sil ec "cut '[ tomorrow ]' tasks"<CR>
                \
                \i[-][>>]<CR>[][END]<Esc>
                \o[][TRANSIT] dinner, goto bed<CR>[][TRANSIT] getup, shower<Esc>
                \:sil ec "insert '[ tomorrow ]' template"<CR>
                \
                \/\[\d.*\]\[END\]<CR>"_dd
                \:sil ec "delete today [end]"<CR>
                \
                \:g/>>]/norm g??<CR>GV?^#[<CR>p
                \:sil ec "hide [>>] content - paste tomorrow - cut today"<CR>
                \
                \O[-][STAT] ph en mi st fo yi<esc>G"lp<Esc>
                \:sil ec "paste stat and sleep"<CR>
                \
                \?#\s\s[\sTOD<CR>VG<Esc>$
                \:g/\%V\[\d\d\d\d\d\d\]/norm lciw-<CR>
                \:sil ec "replace stamps with - , add [end]"<CR>
                \
                \:write<CR>:e $NOTES/Lists/history.gpg.md<CR>go/#====<CR>"1p:write<CR>:b#<CR>
                \:sil ec "write and go to 'history.gpg.md' - paste under '#==' write and comeback to 'todo.md'"<CR>
                \
                \:write\|redraw!<CR>G


    "                       HISTORY

    "   TIME_DIFF
    au BufRead,BufNewFile *.md nn <buffer><silent> <Space>T V:TimeDiff<CR>J$daW0f]P<esc>0

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
