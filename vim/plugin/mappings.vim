" plugin/mappings
" Created: 230524 19:49:28 by clem9nt@imac
" Updated: 230604 22:31:45 by clem9nt@imac
" Maintainer: Clément Vidon

let mapleader=" "


"   file / buffer (s)


nn s  <nop>
nn ss  <nop>
nn gs <nop>
nn sT <nop>
nn sh <nop>
nn sv <nop>
nn sn <nop>
nn sp <nop>

"   write / quit
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
no so  :silent write\|source $DOTVIM/init.vim\|e<CR>zR

"   find
nn sf  :fin<Space>
nn gsf :fin!<Space>
nn sTf :tabf<Space>
nn shf :sf<Space>
nn svf :vert sf<Space>

"   edit
nn se  :e<Space>
nn gse :e!<Space>
nn sTe :tabe<Space>
nn she :sp<Space>
nn sve :vert<Space>

"   prev
nn sp  :e #<CR>
nn gsp :e! #<CR>
nn sTp :tabe #<CR>
nn shp :sp #<CR>
nn svp :vert #<CR>

"   cwd edit
nn s.  :lc %:h<CR>:e<Space>
nn gs. :lc %:h<CR>:e!<Space>
nn sT. :lc %:h<CR>:tabe<Space>
nn sh. :lc %:h<CR>:sp<Space>
nn sv. :lc %:h<CR>:vert<Space>

"   buffer list
nn sb :ls<CR>:b<Space>

"   tag
nn st :tag /
nn sij :ijump /
nn sil :ilist /
nn sis :isearch /

"   grep
nn sg :grep -r<Space>

"   noesis
nn sn  <nop>
nn sni :e $NOESIS/INDEX.noe<CR>/Lists<CR>
nn sne :e $NOESIS/Resources/english.noe<CR>?##  Voca<CR>
nn snf :e $NOESIS/Resources/french.noe<CR>?##  Voca<CR>
nn snt :e $NOESIS/Lists/todo.noe<CR>G
" $:silent! ?^- \(\(.*\d\d\d\d\d\d.*\)\@!.\)*$<CR>z.:let @/=""<CR>
nn snh :e $NOESIS/Lists/history.gpg.noe<CR>
nn snp :e $NOESIS/Lists/post-it.noe<CR>gi<Esc>
nn sna :e $NOESIS/Archives/Archives.noe<CR>gi<Esc>
"   config
nn scv :e $HOME/.vimrc<CR>
nn scz :e $HOME/.zshrc<CR>
nn sce :e $HOME/.zshenv<CR>
nn sct :e $HOME/.tmux.conf<CR>

"   cmdline (gl)


nn gl <nop>
nn glbc V:!bc<CR>
nn glbn :call toggle_nav#(":bnext", ":bprev")<CR>
nn glcc :set cursorcolumn!<CR>
nn glcd :cd %:h<CR>
nn glcl :set cursorline!<CR>
nn glco :call colorswitch#('seoul256-light', 'nord')<CR>
nn glen :En<Space>
nn glex :exe getline(".")<CR>
nn glfr :Fr<Space>
nn glhl :set hls!<CR>
nn gllc :lc %:h<CR>
nn glln :call toggle_nav#(":lprev", ":lnext")<CR>
nn glnu :set number!<CR>
nn glpd :put=strftime('%a %d %b %Y')<CR>
nn glqn :call toggle_nav#(":cprev", ":cnext")<CR>
nn glrn :set relativenumber!<CR>
nn glsb :set scrollbind!<CR>
nn glsc :exec ':set scrolloff=' . 999*(&scrolloff == 0)<CR>
nn glsp :set spell!<CR>
nn glss :StaticSearch<Space>
nn glst :set startofline!<CR>
nn glsy :call getsyntax#()<CR>
nn glts :put=strftime('%y%m%d%H%M%S')<CR>



"   improvements


"   windows ( CTRL-W aemABCDE G I MNO Q UVWXYZ)

no <Leader>w <C-W>
no <Leader>wM <C-W>_\|<C-W><BAR>
no <Leader>wX <C-W>x\|<C-W>_\|<C-W><BAR>
tno <Leader>w <C-W>
tno <Leader>wM <C-W>_\|<C-W><BAR>
tno <Leader>wX <C-W>x\|<C-W>_\|<C-W><BAR>
"   grow split size
no <Leader>wE :resize <C-R>=&lines * 0.66<CR><CR>
no <Leader>we :vertical resize <C-R>=&columns * 0.66<CR><CR>
nn <S-Left> <C-W>5<
nn <S-Up> <C-W>5+
nn <S-Right> <C-W>5>
nn <S-Down> <C-W>5-
tno <S-Left> <C-W><
tno <S-Up> <C-W>+
tno <S-Right> <C-W>>
tno <S-Down> <C-W>-


"   cmdline
no x :

"   eye level cursor
no z, z.15<C-e>

"   static search
no g8 *N
no g3 #N

"   paste without copy
vno P pgvy

"   spell
nn 2s 2z=
nn 1s 1z=

"   indent
nn <silent> <Leader>= Mmmgo=G`mzz
"3<C->

"   clipboard
nn <silent> <Leader>y :call system("xclip -sel clip", getreg("\""))<CR>
no "+Y V:!xclip -f -sel clip<CR>
vn "+y :!xclip -f -sel clip<CR>
no "+p :r!xclip -o -sel clip<CR>
no "+P :-1r!xclip -o -sel clip<CR>

"   guard rails
nn Q :echo "!Q"<CR>

"   header
nn <Leader>e :call header#()<CR>

ino jf <Esc>
ino fj <Esc>
