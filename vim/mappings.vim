" Leaders : <Space> \ <Bs> <CR> <C-k> <C-j>
" Available : mq mw me mr mt ma ms md mf mg mz mx mc mv mb
"             m, m. m' m; m/ m<CR> m<Space> m<BS> m<Tab> m= m[ m]
"             '<Tab> '<Space> `<Tab> `<Space>
"             dc ds dy d! d= d< d> yc yd yo ys y! y= =p =P cd cs co cp
"             z

let mapleader = " "
" --------------------------------- NAV (s gs sh sv) >>>
"                       FILE
"   FIND
nn sf :fin<Space>
nn gsf :fin!<Space>
nn sTf :tabf<Space>
nn shf :sf<Space>
nn svf :vert sf<Space>
"   EDIT
nn se :e *
nn gse :e! *
nn sTe :tabe *
nn she :sp *
nn sve :vert *
"   CD EDIT
nn s. :cd %:h<CR>:e *
nn gs. :cd %:h<CR>:e! *
nn sT. :cd %:h<CR>:tabe *
nn sh. :cd %:h<CR>:sp *
nn sv. :cd %:h<CR>:vert *

"                       BUFFER
"   PREV
nn ss :b#<CR>
nn gss :b!#<CR>
nn shs :sbu#<CR>
nn svs :vert sbu#<CR>
"   NAV
nn [b :bp<CR>
nn ]b :bn<CR>
nn [B :bf<CR>
nn ]B :bl<CR>
"   BUFLIST
nn sb :ls<CR>:b<Space>
"   MRU
nn so :bro old<CR>
"   MISC
"                       GREP
nn sg :grep -r<Space>
"                       TAG
nn st :tag /
nn sij :ijump /
nn sil :ilist /
nn sis :isearch /

"                       MEMO
nn sl  <nop>
nn slt :e $MEMO/Resources/todo.md<CR>gi<Esc>z.
nn sle :e $MEMO/Resources/english.md<CR>?##  Voca<CR>
nn slf :e $MEMO/Lists/french.md<CR>?##  Voca<CR>
nn slp :e $MEMO/Lists/post-it.md<CR>gi<Esc>
nn sla :e $MEMO/Archives/Archives.md<CR>gi<Esc>
" <<<
" --------------------------------- CMDLINE (gl) >>>
"                       OPTIONS
"   CURSORCOLUMN
nn glcc :set cursorcolumn!<CR>
"   CD
nn gllc :lc %:h<CR>
nn glcd :cd %:h<CR>
"   CURSORLINE
nn glcl :set cursorline!<CR>
"   HLSEARCH
nn glhl :set hlsearch!<CR>
"   KEYWORDPRG man/help toggle ( kp= )
nn glkp :if &keywordprg == ":help" <BAR> set keywordprg=man <BAR>
            \ else <BAR> set keywordprg=:help <BAR>
            \ endif <BAR> set keywordprg?<CR>
"   LIST
nn glli :set list!<CR>
"   NUMBERS
nn glnu :set number!<CR>
"   PASTE MODE
nn glpa :set paste!<CR>
"   REDRAW
nn glre :redraw!<CR>
"   RNUMBERS
nn glrn :set relativenumber!<CR>
"   SCROLLBIND
nn glsb :set scrollbind!<CR>
"   SCROLLOFF
nn <silent> glsc :exec ':set scrolloff=' . 999*(&scrolloff == 0)<CR>
"   START OF LINE
nn glsl :set startofline!<CR>
"   SOURCE VIMRC
nn glso :silent write\|source $MYVIMRC\|e<CR>zR
"   SPELL
nn <silent> glsp :set spell!<CR>
"   VIRTUAL EDIT
nn <silent> glve :if &virtualedit == "" <BAR> set virtualedit=all <BAR>
            \ else <BAR> set virtualedit= <BAR>
            \ endif <BAR> set virtualedit?<CR>
"   WRAPSCAN TODO ???
nn glws :set wrapscan!<CR>
"                       TRICKS
"   FUNC CALL
nn glca :call<Space>
"   PRINT DATE
nn glpd :put=strftime('%a %d %b %Y')<CR>
"   COPY PATH
nn glpw :let @+=@%<CR>
"   QF NAV
nn glqn :call QFNav()<CR>
"   RUN CURRENT LINE
nn glru :exe getline(".")<CR>
vn glru :<C-w>exe join(getline("'<","'>"),'<Bar>')<CR>
"   RESOLVE SYMLINK
nn <silent> glsy :exec 'file ' . fnameescape(resolve(expand('%:p')))<CR>:lc %:h<CR>
"   GET SYNTAX
nn glss :StaticSearch<Space>
"   GET SYNTAX
nn glsy :call GetSyntax()<CR>
"   TIME STAMP
nn glts :put=strftime('%y%m%d%H%M%S')<CR>
"   ROT%
nn gl? GVgog?g;g;
"   CHANGE COLORS
if system("uname -s") == "Darwin\n"
    nn <silent> <Space>C :if &bg == "dark" <BAR> exec 'color seoul256-light \| set bg=light' <BAR>
                \ else <BAR> exec 'color nord \| set bg=dark' <BAR>
                \ endif <BAR> colors<CR>
elseif system("uname -s") == "Linux\n"
    nn <Space>C :call ColorSwitch('seoul256-light', 'nord')<CR>
endif
"                       TERMINAL
"   TAGS
nn glta :S ctags -R<CR>
"   BC
nn glbc V:!bc<CR>
"   FRAQ XRL
nn glsr :noau w<CR>:S0 \!\!<CR>
"   SEND KEY REPEAT
nn glsk :noau w<CR>:S0<Space>
" <<<
" --------------------------------- PLUGINS (gy-szcn) >>>
"                       GITGUTTER
nn gy <nop>
"   NAV
nm gy; <Plug>(GitGutterNextHunk)
nm gy, <Plug>(GitGutterPrevHunk)
no gyg :GitGutterToggle<CR>
nn gyq :GitGutterQuickFix\|10cw<CR>
"   ACTIONS : diff, add, status, log, commit, reset, undo, pull, push
nm gyd <Plug>(GitGutterPreviewHunk)
nn gyD :!git difftool %<CR>
nm gya <Plug>(GitGutterStageHunk)
nn gyA :!clear; git add -p %<CR>
nn gys :!clear; git status<CR>
nn gyl :!clear; git log --oneline<CR>
nn gyL :!clear; git log -p %<CR>
nn gyc <nop>
nn gycm :!git commit -m ""<Left>
nn gycv :!git commit -v <CR>
nn gyca :!git commit -v --amend<CR>
nn gyr :silent !clear; git reset %<CR>:redr!<CR>
nm gyu <Plug>(GitGutterUndoHunk)
nn gyp <nop>
nn gypl :!git pull<CR>
nn gyps :!git push<CR>
"   TEXT OBJECT : hunk
om ih <Plug>(GitGutterTextObjectInnerPending)
om ah <Plug>(GitGutterTextObjectOuterPending)
xm ih <Plug>(GitGutterTextObjectInnerVisual)
xm ah <Plug>(GitGutterTextObjectOuterVisual)
"   FOLD : zr to unfold 3 context lines
nn gyf :GitGutterFold<CR>

"                       ALE
"   NAV
nn ]a :ALENext<CR>
nn [a :ALEPrevious<CR>
" <<<
" --------------------------------- IMPROVEMENTS >>>
"   QUICK WRITE
" no mW :noautocmd write<CR>
no sw :write<CR>
no sgw :write!<CR>
no sW :wall<CR>
no sgW :wall!<CR>
no sq :quit<CR>
no sgq :quit!<CR>
no sQ :wall<CR>:qall<CR>
no sgQ :wall!<CR>:qall!<CR>
nn sd :bn\|bd#<CR>
nn sgd :bn!\|bd! #<CR>
no sS :silent write\|source $MYVIMRC\|e<CR>zR

"   QUICK CMDLINE
no ; :
no : ;

"   PASTE WITHOUT OVERWRITING

vno P pgvy

"   EYES LEVEL CURSOR AND VIEW
no z, z.15<C-e>

"   STATIC SEARCH

no g8 *N
no g3 #N

"   PASTE WITHOUT MOVING CURSOR POSITION

no gP P`[
vn gP P`[
no gp p`[
vn gp p`[

no z, z.15<C-e>

" TODO
" :exec 'normal z.'. string(&lines / 5) .'<C-y>'

"                       SPACE
"   SPELL
nn 2s 2z=
nn 1s 1z=

"   INDENT
nn <Space>= Mmmgo=G`mzz3<C-O>

"   WINDOWS
no <Space>w <C-W>
no <Space>wM <C-W>_\|<C-W><BAR>
no <Space>wX <C-W>x\|<C-W>_\|<C-W><BAR>
tno <Space>w <C-W>
tno <Space>wM <C-W>_\|<C-W><BAR>
tno <Space>wX <C-W>x\|<C-W>_\|<C-W><BAR>
nn g<S-Left> <C-W><
nn g<S-Up> <C-W>+
nn g<S-Right> <C-W>>
nn g<S-Down> <C-W>-
nn <S-Left> <C-W>5<
nn <S-Up> <C-W>5+
nn <S-Right> <C-W>5>
nn <S-Down> <C-W>5-
tno <S-Left> <C-W><
tno <S-Up> <C-W>+
tno <S-Right> <C-W>>
tno <S-Down> <C-W>-

no <Space>we :exec 'vertical resize '. string(&columns * 0.66)<CR>
no <Space>wE :exec 'vertical resize '. string(&columns * 0.33)<CR>

"   CLIPBOARD
nn <silent> <Space>y :call system("xclip -sel clip", getreg("\""))<CR>
"   CLIPBOARD
no "+Y V:!xclip -f -sel clip<CR>
vn "+y :!xclip -f -sel clip<CR>
no "+p :r!xclip -o -sel clip<CR>
no "+P :-1r!xclip -o -sel clip<CR>

"                       GUARD RAIL
no x :echo "!x"<CR>
no s :echo "!s"<CR>
no X :echo "!x"<CR>
nn S :echo "!s"<CR>
nn Q :echo "!q"<CR>

"                       R_CTRL ALIASES

function! RightCtrlArrow()
    ino <Right>q <c-q>
    no <Right>q <c-q>
    ino <Right>w <c-w>
    no <Right>w <c-w>
    ino <Right>e <c-e>
    no <Right>e <c-e>
    ino <Right>r <c-r>
    no <Right>r <c-r>
    ino <Right>t <c-t>
    no <Right>t <c-t>
    ino <Right>a <c-a>
    no <Right>a <c-a>
    ino <Right>s <c-s>
    no <Right>s <c-s>
    ino <Right>d <c-d>
    no <Right>d <c-d>
    ino <Right>f <c-f>
    no <Right>f <c-f>
    ino <Right>g <c-g>
    no <Right>g <c-g>
    ino <Right>z <c-z>
    no <Right>z <c-z>
    ino <Right>x <c-x>
    no <Right>x <c-x>
    ino <Right>c <c-c>
    no <Right>c <c-c>
    ino <Right>v <c-v>
    no <Right>v <c-v>
    ino <Right>b <c-b>
    no <Right>b <c-b>
    ino <Right>xf <c-x><c-f>
endfunction

"                       QWERTZU HOME
" TODO  operator pending
" juste pour les top ones

function! SwissKeyboard()
    if system("uname -s") == "Darwin\n"
        cno <C-K>§ <C-K>`
        ino <C-K>§ <C-K>`
        ino § `
        ino ± ~
        no § `
        no ± ~
        ino § `
        ino ± ~
        ono § `
        ono ± ~
        tno § `
        tno ± ~
        cno § `
        cno ± ~
        no § `
        no ± ~
        no f§ f`
        no F§ F`
    elseif system("uname -s") == "Linux\n"
        cno <C-K>< <C-K>`
        ino <C-K>< <C-K>`
        no < `
        no > ~
        ino < `
        ino > ~
        ono < `
        ono > ~
        tno < `
        tno > ~
        cno < `
        cno > ~
        no f< f`
        no F< F`
        ino \, <
        ino \. >
        ono \, <
        ono \. >
        tno \, <
        tno \. >
        cno \, <
        cno \. >
    endif
    ino `6 ^
    ino `7 &
    ino `8 *
    ino `9 (
    ino `0 )
    ino `- _
    ino `= +
    ino `[ {
    ino `] }
    ino `' "
    ino `\\ \|
    ino `, <
    ino `. >
    ino `/ ?
    ino `y Y
    ino `u U
    ino `i I
    ino `o O
    ino `p P
    ino `h H
    ino `j J
    ino `k K
    ino `l L
    ino `b B
    ino `n N
    ino `m M
    no `6 ^
    no `7 &
    no `8 *
    no `9 (
    no `0 )
    no `- _
    no `= +
    no `[ {
    no `] }
    no `' "
    no `\\ \|
    no `, <
    no `. >
    no `/ ?
    no `y Y
    no `u U
    no `i I
    no `o O
    no `p P
    no `h H
    no `j J
    no `k K
    no `l L
    no `b B
    no `n N
    no `m M
endfunction
" <<<
