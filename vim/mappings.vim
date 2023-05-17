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
nn se :e<Space>
nn gse :e!<Space>
nn sTe :tabe<Space>
nn she :sp<Space>
nn sve :vert<Space>
"   PREV
nn ss :e #<CR>
nn gss :e! #<CR>
nn shs :sp #<CR>
nn svs :vert #<CR>
"   CD EDIT
nn s. :lc %:h<CR>:e<Space>
nn gs. :lc %:h<CR>:e!<Space>
nn sT. :lc %:h<CR>:tabe<Space>
nn sh. :lc %:h<CR>:sp<Space>
nn sv. :lc %:h<CR>:vert<Space>
"   CD NAV
nn sne :lc %:h<CR>:sil r! ls -1 \| grep -A 1 "%" \| tail -n 1<CR>v$h"yyu:e <C-r>y<CR>
nn spe :lc %:h<CR>:sil r! ls -1 \| grep -B 1 "%" \| head -n 1<CR>v$h"yyu:e <C-r>y<CR>

"                       BUFFER
"   NAV
nn spb :bp<CR>
nn snb :bn<CR>
nn sPb :bf<CR>
nn sNb :bl<CR>
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
nn sln :e $MEMO/INDEX.md<CR>/Lists<CR>
nn sle :e $MEMO/Resources/english.md<CR>?##  Voca<CR>
nn slf :e $MEMO/Resources/french.md<CR>?##  Voca<CR>
nn slt :e $MEMO/Lists/todo.md<CR>G$?\(\[\]\\|\[\d\d:\d\d\]\) <CR>z.:let @/=""<CR>
nn slp :e $MEMO/Lists/post-it.md<CR>gi<Esc>
nn sla :e $MEMO/Archives/Archives.md<CR>gi<Esc>
" <<<
" --------------------------------- CMDLINE (gl) >>>
"                       OPTIONS

nn glca :call<Space>
nn glcc :set cursorcolumn!<CR>
nn glcd :cd %:h<CR>
nn glcl :set cursorline!<CR>
nn glco :call ColorSwitch('seoul256-light', 'nord')<CR>
nn glfr :Fr<Space>
nn glen :En<Space>
nn glhe :call Header("#")<Left><Left>
nn glhl :set hlsearch!<CR>
nn glkp :if &kp == ":help" \| set kp=man \| else \| set kp=:help \| endif \| set kp?<CR>
nn gllc :lc %:h<CR>
nn glli :set list!<CR>
nn glnu :set number!<CR>
nn glpa :set paste!<CR>
nn glpd :put=strftime('%a %d %b %Y')<CR>
nn glqn :call QFNav()<CR>
nn glre :redraw!<CR>
nn glrn :set relativenumber!<CR>
nn glro GVgog?g;g;
nn glru :exe getline(".")<CR>
nn glsb :set scrollbind!<CR>
nn glsc :exec ':set scrolloff=' . 999*(&scrolloff == 0)<CR>
nn glsl :set startofline!<CR>
nn glso :silent write\|source $MYVIMRC\|e<CR>zR
nn glsp :set spell!<CR>
nn glss :StaticSearch<Space>
nn glsy :call GetSyntax()<CR>
" nn glsy <silent> :exec 'file ' . fnameescape(resolve(expand('%:p')))<CR>:lc %:h<CR>
nn glts :put=strftime('%y%m%d%H%M%S')<CR>
nn glve :if &ve == "" \| set ve=all \| else <BAR> set ve= \| endif \| set ve?<CR>
nn glws :set wrapscan!<CR>
vn glru :<C-w>exe join(getline("'<","'>"),'<Bar>')<CR>

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

" <<<
" --------------------------------- IMPROVEMENTS >>>
"   QUICK WRITE
" no mW :noautocmd write<CR>
no sw  :write<CR>
no gsw :write!<CR>

no sW  :wall<CR>
no gsW :wall!<CR>

no sq  :quit<CR>
no gsq :quit!<CR>

no sQ  :quitall<CR>
no gsQ :quitall!<CR>

nn sd  :bn\|bd#<CR>
nn gsd :bn!\|bd! #<CR>

"   QUICK CMDLINE
no x :
" no ; :
" no : ;

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

ino jf <esc>
