" plugin/mappings Created: 230524 19:49:28 by clem9nt@imac
" Updated: 230604 22:31:45 by clem9nt@imac
" Maintainer: Clément Vidon

let mapleader=" "


"   file / buffer (s)


nn s  <nop>
nn ss <nop>
nn sT <nop>
nn sh <nop>
nn sv <nop>
nn sn <nop>
nn sp <nop>
nn gk <nop>

nn sw :echohl WarningMsg \| echo "Nop!" \| echohl None<CR>
nn sq :echohl WarningMsg \| echo "Nop!" \| echohl None<CR>

"   write / quit
no mw  :write<CR>
nn mvv :write !sudo tee %<CR>
no gmw :write!<CR>
no mW  :wall<CR>
no gmW :wall!<CR>
no mq  :quit<CR>
no gmq :quit!<CR>
no mQ  :quitall<CR>
no gmQ :quitall!<CR>
no md  :bn\|bd#<CR>
no gmd :bn!\|bd! #<CR>
no <silent> mso :let view = winsaveview() \| write \| source $DOTVIM/init.vim\|e \| call winrestview(view)<CR>
no mse :source %<CR>

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
nn <silent> sn  <nop>
nn <silent> sni :e $NOESIS/INDEX.noe<CR>/Lists<CR>
nn <silent> sne :let @s=@/<CR>:e $NOESIS/Resources/english.noe<CR>?##  Voca<CR>:let @/=@s<CR>
nn <silent> snf :let @s=@/<CR>:e $NOESIS/Resources/french.noe<CR>?##  Voca<CR>:let @/=@s<CR>
nn <silent> snt :let @s=@/<CR>:e $NOESIS/Lists/todo.noe<CR>G:silent! ?\s\d\{6}\s\d\d:\d\d\s\D<CR>:let @/=@s<CR>0
nn <silent> snh :e $NOESIS/Lists/history.gpg.noe<CR>
nn <silent> snp :e $NOESIS/Lists/post-it.noe<CR>gi<Esc>
nn <silent> sna :e $NOESIS/Archives/Archives.noe<CR>gi<Esc>
"  config
nn <silent> scv :e $HOME/.vimrc<CR>
nn <silent> scz :e $HOME/.zshrc<CR>
nn <silent> sce :e $HOME/.zshenv<CR>
nn <silent> sct :e $HOME/.tmux.conf<CR>

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
nn glln :call toggle_nav#(":lnext", ":lprev")<CR>
nn glnu :set number!<CR>
nn glpd :put=strftime('%a %d %b %Y')<CR>
nn glqn :call toggle_nav#(":cnext", ":cprev")<CR>
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
nn <Leader>wE :resize <C-R>=&lines * 0.66<CR><CR>
nn <Leader>we :vertical resize <C-R>=&columns * 0.66<CR><CR>
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
inoremap <c-q> <c-g>u<esc>[s1z=`]a<c-g>u

"   indent
nn <silent> <Leader>= :let view = winsaveview() \| execute 'normal! gg=G' \| call winrestview(view)<CR>
nn <silent> <Leader>H :let view = winsaveview() \| execute 'normal! ggg?G' \| call winrestview(view)<CR>

"   clipboard
nn <silent> <Leader>y :call system("xclip -sel clip", getreg('"'))<CR>
no "+Y V:!  xclip -f -sel clip<CR>
vn "+y :!   xclip -f -sel clip<CR>
no "+p :r!  xclip -o -sel clip<CR>
no "+P :-1r!xclip -o -sel clip<CR>

"   guard rails
nn Q :echo "!Q"<CR>

"   header
nn <Leader>e :call header#()<CR>

ino jf <Esc>
ino fj <Esc>

"   prevent cmdline c-u deletion
cno <C-U> <Nop>
