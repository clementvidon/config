augroup FILETYPE_NOTES
    autocmd!
    " --------------------------------- OPTIONS {{{
    au BufRead,BufNewFile *.md
                \   set filetype=notes
                \ | setl textwidth=70
                \ | setl suffixesadd+=.md
                \ | setl path+=$NOTES/**,$DOTVIM/after/ftplugin/
                \ | setl expandtab
    au BufRead,BufNewFile $NOTES/_Areas/_Lists/todo.md setl textwidth=0
    au BufRead,BufNewFile $NOTES/_Areas/_Lists/history.gpg.md setl textwidth=0
    " }}}
    " --------------------------------- PLUGINS {{{
    " }}}
    " --------------------------------- MAPPINGS {{{
    au BufRead,BufNewFile $NOTES/_Areas/* nn <silent><buffer> <Space>? :echo "
                \\n
                \================[Notes]===============+\n
                \                                      \|\n
                \               [GENERAL]              \|\n
                \                                      \|\n
                \ MOVE_LINES        : gj gk            \|\n
                \ HTML_EXPORT       : Space E          \|\n
                \                                      \|\n
                \ PUSH_NOTES        : ghps             \|\n
                \ PULL_NOTES        : ghpl             \|\n
                \                                      \|\n
                \ NOTES_NAV FOR     : Space CR         \|\n
                \ NOTES_NAV BAC     : Space Tab        \|\n
                \ INDEX_GEN         : Space #          \|\n
                \ INDEX_NAV         : Space 3          \|\n
                \ NOTES GREP        : :Grep            \|\n
                \                                      \|\n
                \              [TODO LIST]             \|\n
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
                \                                      \|\n
                \ ARCHIVE_DAY       : Space A          \|\n
                \ TIME_DIFF         : Space T          \|\n
                \ JSONIFY           : Space J          \|\n
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
    au BufRead,BufNewFile *.md nn <silent><buffer> <Space>E :set term=xterm-256color<CR>:TOhtml<CR>
                \
                \/--><CR>Oa { color: hotpink; }<Esc>go
                \:%s/background-color: \#000000; }$/background-color: \#2e333f; }/g<CR>
                \:%s/\* { font-size: 1em; }$/\* { font-size: 1.1em; }/g<CR>
                \:%s/\.notesH1 { color: #5fffaf; }$/.notesH1 { color: #5fffaf; font-size: 120%; }/g<CR>
                \:%s/\.notesUrl { color: #ff5faf; text-decoration: underline; }$/.notesUrl { color: #ff5faf; text-decoration: underline; font-size: 90%; }/g<CR>
                \go/<span class="notesBlockquote">&gt; </span><CR>cc<span class="notesBlockquote">&gt; </span> cvidon@student.42.fr<Esc>go
                \:fix}}<Esc>

    "   PULL_NOTES
    au BufRead,BufNewFile $NOTES/_Areas/_Lists/todo.md nn <silent><buffer> ghpl :cd %:h\|sil !git pull<CR>:redraw!<CR>

    "   PUSH_NOTES
    au BufRead,BufNewFile $NOTES/_Areas/_Lists/todo.md nn <silent><buffer> ghps :echo "Push"<CR>:w\|lc %:h<CR>
                \:sil !rm $DOTVIM/.swp/*%*.swp<CR>
                \:sil cd $NOTES/<CR>
                \:sil !git add -f INDEX.md _Areas _Projects _Resources _Archives<CR>
                \:sil !git commit -m "Push"<CR>:sil !git push origin main<CR>
                \:q<CR>:redr!


    "   NOTES_NAV
    au BufRead,BufNewFile *.md nn <silent><buffer> <Space><Tab> :silent write<CR>gogf
    au BufRead,BufNewFile *.md nn <silent><buffer> <Space><CR> mm:silent write<CR>`m0gf5G

    "   INDEX_GEN
    au BufRead,BufNewFile *.md nn <silent><buffer> <Space># :silent
                \
                \ :let @a=""<CR>:keeppatterns g/^##/y A<CR>3Gpo#INDEX<CR>------<Esc>0k

    "   INDEX_NAV
    au BufRead,BufNewFile *.md nn <silent><buffer> <Space>3 :keeppatterns /<C-R>=getline('.')<CR>$<CR>zt

    "   GREP
    au BufRead,BufNewFile $NOTES/* com! -nargs=+ Grep exec 'grep! -i <args> $NOTES/**/*.md' | cw


    "                       TASKS    :


    "   TASK_ADD_TAG
    au BufRead,BufNewFile $NOTES/_Areas/* nn <silent><buffer> <Tab>so O[][@Social]<Space><Esc><<
    au BufRead,BufNewFile $NOTES/_Areas/* nn <silent><buffer> <Tab>mi O[][@Misc]<Space><Esc><<
    au BufRead,BufNewFile $NOTES/_Areas/* nn <silent><buffer> <Tab>ho O[][@Home]<Space><Esc><<
    au BufRead,BufNewFile $NOTES/_Areas/* nn <silent><buffer> <Tab>co O[][@Computer]<Space><Esc><<
    au BufRead,BufNewFile $NOTES/_Areas/* nn <silent><buffer> <Tab>mo O[][@Mobile]<Space><Esc><<
    au BufRead,BufNewFile $NOTES/_Areas/* nn <silent><buffer> <Tab>we O[][@Web]<Space><Esc><<
    au BufRead,BufNewFile $NOTES/_Areas/* nn <silent><buffer> <Tab>cf O[][@Config@]<Esc><<2f@a
    au BufRead,BufNewFile $NOTES/_Areas/* nn <silent><buffer> <Tab>ad O[][@Adm]<Space><Esc><<
    au BufRead,BufNewFile $NOTES/_Areas/* nn <silent><buffer> <Tab>ph O[][@Photo]<Space><Esc><<
    au BufRead,BufNewFile $NOTES/_Areas/* nn <silent><buffer> <Tab>he O[][@Health]<Space><Esc><<
    au BufRead,BufNewFile $NOTES/_Areas/* nn <silent><buffer> <Tab>fi O[][@Finance]<Space><Esc><<
    au BufRead,BufNewFile $NOTES/_Areas/* nn <silent><buffer> <Tab>re O[][@Resources@]<Esc><<2f@a
    au BufRead,BufNewFile $NOTES/_Areas/* nn <silent><buffer> <Tab>ft O[][@42]<Space><Esc><<
    au BufRead,BufNewFile $NOTES/_Areas/* nn <silent><buffer> <Tab>no O[][@Notes]<Space><Esc><<
    au BufRead,BufNewFile $NOTES/_Areas/* nn <silent><buffer> <Tab>me O[][@Medium]<Space><Esc><<
    au BufRead,BufNewFile $NOTES/_Areas/* nn <silent><buffer> <Tab>lo O[][LOSTMYWAY]<Space><Esc><<
    au BufRead,BufNewFile $NOTES/_Areas/* nn <silent><buffer> <Tab>va O[][VACATION]<Space><Esc><<
    au BufRead,BufNewFile $NOTES/_Areas/* nn <silent><buffer> <Tab>de O[][DEADTIME]<Space><Esc><<
    au BufRead,BufNewFile $NOTES/_Areas/* nn <silent><buffer> <Tab>tr O[][TRANSIT]<Space><Esc><<
    au BufRead,BufNewFile $NOTES/_Areas/* nn <silent><buffer> <Tab>tv O[][TRAVEL]<Space>from -> to<Esc><<
    au BufRead,BufNewFile $NOTES/_Areas/* nn <silent><buffer> <Tab>sp O[][SPORT]<Space><Esc><<
    au BufRead,BufNewFile $NOTES/_Areas/* nn <silent><buffer> <Tab>si O[][SICK]<Space><Esc><<
    au BufRead,BufNewFile $NOTES/_Areas/* nn <silent><buffer> <Tab>br O[][BREAK]<Space><Esc><<A
    au BufRead,BufNewFile $NOTES/_Areas/* nn <silent><buffer> <S-Tab> :echo "
                \\n
                \=======================[Tags]==========================+\n
                \ @ConFig   @HOme   @REsources @ADm     @WEb    @SOcial \|\n
                \ @COmputer @MObile @PHoto     @FInance @HEalth @MIsc   \|\n
                \ @FAmily                                               \|\n
                \                                                       \|\n
                \ @FT    @NOtes    @MEdium                              \|\n
                \                                                       \|\n
                \ @BREAK    @DEADTIME   @TRAVEL @SICK @SPORT            \|\n
                \ @TRANSIT  @LOSTMYWAY                                  \|\n
                \"<CR>

    "   TASK_FOCUS_TAG
    au BufRead,BufNewFile $NOTES/_Areas/* nn <silent><buffer> <Tab>\ 0f@l

    "   TASK_ADD_ACT
    au BufRead,BufNewFile $NOTES/_Areas/* nn <silent><buffer> \ch 0f@f]i#check<Esc>A
    au BufRead,BufNewFile $NOTES/_Areas/* nn <silent><buffer> \cl 0f@f]i#cleanup<Esc>A
    au BufRead,BufNewFile $NOTES/_Areas/* nn <silent><buffer> \cr 0f@f]i#create<Esc>A
    au BufRead,BufNewFile $NOTES/_Areas/* nn <silent><buffer> \fi 0f@f]i#fix<Esc>A
    au BufRead,BufNewFile $NOTES/_Areas/* nn <silent><buffer> \me 0f@f]i#meet<Esc>A
    au BufRead,BufNewFile $NOTES/_Areas/* nn <silent><buffer> \ms 0f@f]i#msg<Esc>A
    au BufRead,BufNewFile $NOTES/_Areas/* nn <silent><buffer> \pr 0f@f]i#praxis<Esc>A
    au BufRead,BufNewFile $NOTES/_Areas/* nn <silent><buffer> \re 0f@f]i#review<Esc>A
    au BufRead,BufNewFile $NOTES/_Areas/* nn <silent><buffer> \sr 0f@f]i#search<Esc>A
    au BufRead,BufNewFile $NOTES/_Areas/* nn <silent><buffer> \se 0f@f]i#setup<Esc>A
    au BufRead,BufNewFile $NOTES/_Areas/* nn <silent><buffer> \st 0f@f]i#study<Esc>A
    au BufRead,BufNewFile $NOTES/_Areas/* nn <silent><buffer> \up 0f@f]i#update<Esc>A
    au BufRead,BufNewFile $NOTES/_Areas/* nn <silent><buffer> \ca 0f@f]i#call<Esc>A
    au BufRead,BufNewFile $NOTES/_Areas/* nn <silent><buffer> \th 0f@f]i#think<Esc>A
    au BufRead,BufNewFile $NOTES/_Areas/* nn <silent><buffer> \so 0f@f]i#solve<Esc>A
    au BufRead,BufNewFile $NOTES/_Areas/* nn <silent><buffer> <BAR> :echo "
                \\n
                \======================[Actions]=================+\n
                \ #STudy #CLeanup #UPdate #SEtup  #CReate #FIx   \|\n
                \ #MEet  #MSg     #REview #PRaxis #SeaRch #CHeck \|\n
                \ new:   #CAll    #THink  #SOlve                 \|\n
                \"<CR>

    "   TASK_FOCUS_ACT
    au BufRead,BufNewFile $NOTES/_Areas/* nn <silent><buffer> \<Tab> 0f@f#l


    "   TASK_CHECK
    au BufRead,BufNewFile $NOTES/**/*todo.md nn <silent><silent><buffer> <Space><Space> :silent let @d=strftime('%y%m%d') \| let @t=strftime('%H:%M')<CR>
                \
                \?#\s\s[\sTOD<CR>VG<esc>$?\%V\[\]\\|\[(.*)\]<CR>mm
                \:sil ec "go to next"<CR>
                \0di["dPa<Space><C-R>t<Esc>0
                \2j2k/^[<CR>f:t[v0f:3lc<Space><C-R>t]<Esc>'m
                \:sil ec "datestamp check"<CR>
                \:let @/ = ""<CR>:write<CR>02f]l

    "   TASK_RECHECK
    au BufRead,BufNewFile $NOTES/**/*todo.md nn <silent><silent><buffer> <Space>r mn
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
    au BufRead,BufNewFile $NOTES/**/*todo.md nn <silent><buffer> <Space>n GV?#\s\s[\sTOD<CR><esc>$/\%V\[\d\d\d.*\]\[<CR>2f]2l:let @/ = ""<CR>

    "   TASK_REPEAT
    au BufRead,BufNewFile $NOTES/**/*todo.md nn <silent><buffer> <Space>. mmY
                \
                \GV?#\s\s[\sTOD<CR><esc>$/\%V\[\d\d\d.*\]\[<CR>:let @/ = ""<CR>
                \Pdi[$`mk

    "   TASK_BREAK
    au BufRead,BufNewFile $NOTES/**/*todo.md nn <silent><buffer> <Space>b :silent let @d=strftime('%y%m%d') \| let @t=strftime('%H:%M')<CR>
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
    au BufRead,BufNewFile $NOTES/**/*todo.md nn <silent><buffer> <Space>B :silent let @d=strftime('%y%m%d') \| let @t=strftime('%H:%M')<CR>
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
                \:let @/ = ""<CR>:write<CR>jA<Space><Esc>

    "   TASK_POSTPONE_TOP
    au BufRead,BufNewFile $NOTES/**/*todo.md nn <silent><buffer> <Space>P kmmj
                \jk
                \0di[V/\[.*\]<CR>kd?[ TOM<CR>/\[TRANSIT\]<CR>p`m:let @/ = ""<CR>

    "   TASK_POSTPONE_BOT
    au BufRead,BufNewFile $NOTES/**/*todo.md nn <silent><buffer> <Space>p kmmj
                \jk
                \0di[V/\[.*\]<CR>kd?[ TOM<CR>/\[TRANSIT\]<CR>nP`m:let @/ = ""<CR>

    "   TASK_CLEAR
    au BufRead,BufNewFile $NOTES/**/*todo.md nn <silent><buffer> <Space>c mm0di[`m

    "   TASK_FIX
    au BufRead,BufNewFile $NOTES/**/*todo.md nn <silent><buffer> <Space>f mm0
                \
                \jf:f:f]f]0
                \:sil ec "check next line"<CR>
                \l"dyawt]vT<Space>"ty
                \:sil ec "copy date and end of prev task"<CR>
                \k0a0<Esc>vaw"dpa<Space><Esc>v/\s\\|\]<CR>h"tp
                \:sil ec "paste to target task"<CR>
                \`m:let @/ = ""\|write<CR>

    "   ARCHIVE_DAY
    au BufRead,BufNewFile $NOTES/_Areas/_Lists/todo.md nn <silent><buffer> <Space>A /\[\d.*\]\[END\]<CR>
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
                \o[][TRANSIT] dinner, series, goto bed<CR>[][TRANSIT] getup, shower, breakfast<Esc>
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
                \:write<CR>:e $NOTES/_Areas/_Lists/history.gpg.md<CR>go/#====<CR>"1p:write<CR>:b#<CR>
                \:sil ec "write and go to 'history.gpg.md' - paste under '#==' write and comeback to 'todo.md'"<CR>
                \
                \:write\|redraw!<CR>G

    "   TIME_DIFF
    au BufRead,BufNewFile $NOTES/_Areas/_Lists/{history.gpg.md,todo.md} nn <buffer> <Space>T V:TimeDiff<CR>J$daW0f]P<esc>0

    "   JSONIFY
    "   TODO replace all " with ' before to start.
    au BufRead,BufNewFile $NOTES/_Areas/_Lists/tmp.gpg.md no <silent><buffer> <Space>J :echo "Jsonify"<CR>
                \
                \:sil ec "selects the tasks and erases dates"<CR>
                \go/#\[<CR>nkV?>>?+1<CR>
                \<C-V>f old
                \:sil ec "jsonify 'from', 'to' and 'tag'"<CR>
                \gv:'<,'>norm cl"0": { "from": "<CR>
                \gv:'<,'>norm 3f:f cl", "to": "<CR>
                \gv:'<,'>norm f]2cl", "tag": "<CR>
                \gv:'<,'>norm 2f,3f"lea",<CR>
                \:sil ec "erases the remaining '@'"<CR>
                \gv:'<,'>norm f]F,F@dl<CR>
                \:sil ec "jsonify 'subtag'"<CR>
                \gv:'<,'>norm f]F,a "subtag": "", <CR>
                \gv:'<,'>norm f@ldwF"P<CR>
                \:sil ec "jsonify 'action'"<CR>
                \gv:'<,'>norm f]F,a "action": "", <CR>
                \gv:'<,'>norm f#ldwF"P<CR>
                \:sil ec "remove the remaining '@' and '#'"<CR>
                \gv:'<,'>norm f]F#dl<CR>
                \gv:'<,'>norm f]F@dl<CR>
                \:sil ec "jsonify 'description'"<CR>
                \gv:'<,'>norm f]F,a "description": ""<CR>
                \gv:'<,'>norm f]2ldg_F"P<CR>
                \:sil ec "cleanup EOL ']'"<CR>
                \gv:'<,'>norm $T"Da },<CR>
                \:sil ec "reverse order and set indexes"<CR>
                \gv:!tac<CR>
                \gv0o0f:g<C-a>gv<C-x>
                \:sil ec "wrap into 'Task'"<CR>
                \gv:join<CR>$cl }<Esc>I"Tasks": { <Esc>
                \:sil ec "select '>>' (Notes)"<CR>
                \gv?#\[<CR>/>><CR>ok<Esc>
                \:sil ec "jsonify 'Notes'"<CR>
                \gv:'<,'>norm dt>df i"0": "<CR>
                \gv:'<,'>norm A",<CR>
                \gv0o0f:g<C-a>gv<C-x>
                \gv:join<CR>$cl },<Esc>I"Notes": { <Esc>
                \:sil ec "jsonify 'Stats'"<CR>
                \0kldiw:pu!<CR>
                \jct "Stats": { "ph":<Esc>w2dlw.w.w.w.w.5bi"<C-o>a",
                \<C-o>a"en": "<C-o>a",
                \<C-o>a"mi": "<C-o>a",
                \<C-o>a"st": "<C-o>a",
                \<C-o>a"fo": "<C-o>a",
                \<C-o>a"yi": "<C-o>a" },<Esc>
                \:sil ec "jsonify 'Data'"<CR>
                \0ki"Date": "<C-o>A",<Esc>
                \:sil ec "wrap the day"<CR>
                \V/^"Task<CR>:join<CR>A },<Esc>I{ <Esc>:-1d<CR>
                \:fix}}<Esc>

    " }}}
    " --------------------------------- FUNCTIONS {{{
    fu! GetTimeDiff(line1, line2)
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
    endfun
    " Create a user-defined command.
    command! -range TimeDiff :call GetTimeDiff(<line1>,<line2>)
    " }}}
    " --------------------------------- OLD MAPPINGS {{{

    "   PUSH_ENC_NOTES {{{
    " au BufRead,BufNewFile $NOTES/_Areas/_Lists/todo.md nn <silent><buffer> <Space>P :echo "Push"<CR>
    "             \
    "             \:sil cd $NOTES/<CR>:sil !mkdir Notes; cp -r INDEX.md _Areas _Projects _Resources _Archives Notes<CR>
    "             \:sil ec "COPY 'Notes/' FOLDER"<CR>
    "             \
    "             \:sil !tar -cvzf - Notes\|gpg --symmetric --cipher-algo TWOFISH > Notes.tar.gz.gpg<CR>
    "             \:sil ec "ARCHIVE - ZIP - ENCRYPT 'Notes/' COPY"<CR>
    "             \
    "             \:sil !git add -f Notes.tar.gz.gpg open.sh<CR>:sil !git commit -m"ARCHIVE DAY"<CR>:sil !git push origin main<CR>
    "             \:sil ec "GIT ADD COMMIT PUSH"<CR>
    "             \
    "             \:sil !rm -rf Notes Notes.tar Notes.tar.gz.gpg<CR>
    "             \:sil ec "cleanup"<CR>:redraw!<CR>

    " open.sh
    " #!/bin/sh
    " # Forget a wrong password: gpgconf --kill gpg-agent
    " # git clone git@github.com:clem9nt/Notes.git
    " cd Notes
    " gpg -d Notes.tar.gz.gpg | tar -xvzf -
    " mv Notes/* .
    " rm -rf Notes Notes.tar.gz.gpg
    " export NOTES=$PWD
    " vi INDEX.md
    " }}}
    " }}}
    " --------------------------------- digraphs {{{
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
