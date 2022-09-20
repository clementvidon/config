" Leaders : <Space> \ <Bs> <CR> <C-k> <C-j>
" Available : mq mw me mr mt ma ms md mf mg mz mx mc mv mb
"             m, m. m' m; m/ m<CR> m<Space> m<BS> m<Tab> m= m[ m]
"             '<Tab> '<Space> `<Tab> `<Space>
"             dc ds dy d! d= d< d> yc yd yo ys y! y= =p =P cd cs co cp
"             z
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
nn sd :bn\|bd#<CR>
nn gsd :bn!\|bd! #<CR>
"                       GREP
nn sg :grep -r<Space>
"                       TAG
nn st :tag /
nn sij :ijump /
nn sil :ilist /
nn sis :isearch /

"                       NOTES
nn sl :e $NOTES/Lists/todo.md<CR>gi<Esc>z.
nn xe :e $NOTES/Lists/english.md<CR>/##  Voca<CR>
nn xf :e $NOTES/Lists/french.md<CR>/##  Voca<CR>
nn xp :e $NOTES/Lists/post-it.md<CR>gi<Esc>
"                       CONF
nn xxv :e ~/.vimrc<CR>gi<Esc>
nn xxz :e ~/.zshrc<CR>gi<Esc>
nn xxa :e ~/.config/alacritty/alacritty.yml<CR>gi<Esc>
nn xxi :e ~/.config/i3/config<CR>gi<Esc>
nn xxx :e ~/.Xresources<CR>gi<Esc>
nn xxt :e ~/.tmux.conf<CR>gi<Esc>
nn xxn :!sudo vi /etc/netplan/00-installer-config.yaml<CR>
" <<<
" --------------------------------- CMDLINE (gl) >>>
"                       OPTIONS
"   FUNC CALL
nn glca :call<Space>
"   CURSORCOLUMN
nn glcc :set cursorcolumn!<CR>
"   LCD
nn glcd :lc %:h<CR>
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
"   PASTE MODE
nn glpa :set paste!<CR>
"   PRINT DATE
nn glpd :put=strftime('%a %d %b %Y')<CR>
"   COPY PATH
nn glpw :let @+=@%<CR>
"   REDRAW
nn glre :redraw!<CR>
"   SCROLLBIND
nn glsb :set scrollbind!<CR>
"   SCROLLOFF
nn <silent> glsc :exec ':set scrolloff=' . 999*(&scrolloff == 0)<CR>

"   SOURCE VIMRC
nn glso :silent write\|source $MYVIMRC\|e<CR>zR
"   SPELL
nn <silent> glsp :set spell!<CR>
"   VIRTUAL EDIT
nn <silent> glve :if &virtualedit == "" <BAR> set virtualedit=all <BAR>
            \ else <BAR> set virtualedit= <BAR>
            \ endif <BAR> set virtualedit?<CR>
"   WRAPSCAN
nn glws :set wrapscan!<CR>
"                       FUNCTIONS
"   RUN CURRENT LINE
nn glru :exe getline(".")<CR>
vn glru :<C-w>exe join(getline("'<","'>"),'<Bar>')<CR>
"   RESOLVE SYMLINK
nn <silent> glsl :exec 'file ' . fnameescape(resolve(expand('%:p')))<CR>:lc %:h<CR>
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
"   REMOVE CURRENT FILE
nn glrm :cd %:h<CR>:!rm -f %<CR>:q<CR>
"   TAGS
nn glta :S ctags -R<CR>
"   BC
nn glbc V:!bc<CR>
" <<<
" --------------------------------- PLUGINS (g h-ltyszcn) >>>
"                       GITGUTTER
"   NAV
nm ]g <Plug>(GitGutterNextHunk)
nm [g <Plug>(GitGutterPrevHunk)
nn gh <nop>
no ghg :GitGutterToggle<CR>
nn ghq :GitGutterQuickFix\|10cw<CR>
"   ACTIONS : diff, add, status, log, commit, reset, undo, pull, push
nm ghd <Plug>(GitGutterPreviewHunk)
nn ghD :!git difftool %<CR>
nm gha <Plug>(GitGutterStageHunk)
nn ghA :!clear; git add -p %<CR>
nn ghs :!clear; git status<CR>
nn ghl :!clear; git log --oneline<CR>
nn ghc <nop>
nn ghcm :!git commit -m ""<Left>
nn ghcv :!git commit -v <CR>
nn ghca :!git commit -v --amend<CR>
nn ghr :silent !clear; git reset %<CR>:redr!<CR>
nm ghu <Plug>(GitGutterUndoHunk)
nn ghp <nop>
nn ghpl :!git pull<CR>
nn ghps :!git push<CR>
"   TEXT OBJECT : hunk
om ih <Plug>(GitGutterTextObjectInnerPending)
om ah <Plug>(GitGutterTextObjectOuterPending)
xm ih <Plug>(GitGutterTextObjectInnerVisual)
xm ah <Plug>(GitGutterTextObjectOuterVisual)
"   FOLD : zr to unfold 3 context lines
nn ghf :GitGutterFold<CR>

"                       ALE
"   NAV
nn ]a :ALENext<CR>
nn [a :ALEPrevious<CR>

"                       QUICKFIX
"   NAV
nn <Space>Q :cw<CR>
nn ]q :cnext<CR>
nn [q :cprev<CR>
" <<<
" --------------------------------- IMPROVEMENTS >>>
"   QUICK CMDLINE
no ; :
cno <c-h> <left>
cno <c-l> <right>
"   EYES LEVEL CURSOR AND VIEW
no z, z.10<C-e>

"                       SPACE
"   INDENT
nn <Space>= Mmmgo=G`mzz3<C-O>

"   WINDOWS
no <Space>w <C-W>
no <Space>wM <C-W>_\|<C-W><BAR>
no <Space>wX <C-W>x\|<C-W>_\|<C-W><BAR>
tno <Space>w <C-W>
tno <Space>wM <C-W>_\|<C-W><BAR>
tno <Space>wX <C-W>x\|<C-W>_\|<C-W><BAR>
nn <S-Left> <C-W><
nn <S-Up> <C-W>+
nn <S-Right> <C-W>>
nn <S-Down> <C-W>-
tno <S-Left> <C-W><
tno <S-Up> <C-W>+
tno <S-Right> <C-W>>
tno <S-Down> <C-W>-

"   CLIPBOARD
nn <silent> <Space>y :call system("xclip -sel clip", getreg("\""))<CR>
"   TAGS
nn <space>t <c-t>
nn <space>] <c-]>
"   VISUAL BLOCK
nn <space>v <c-v>
"   SUSPEND
nn <space>z <c-z>


"                       GUARD RAIL
no x :echo "!x"<CR>
no s :echo "!s"<CR>
no X :echo "!x"<CR>
nn S :echo "!s"<CR>
nn Q :echo "!q"<CR>

"                       R_CTRL ALIASES
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

"                       QWERTZU HOME
" TODO  operator pending
" juste pour les top ones

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

" <<<
