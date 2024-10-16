" plugin/mappings
" Created: 231229 16:44:16 by clem@spectre
" Updated: 231229 16:44:16 by clem@spectre
" Maintainer: Clément Vidon (clemedon)

let mapleader=" "


"   file / buffer (s)


nn s  <nop>
nn gs <nop>
nn sT <nop>
nn sh <nop>
nn sv <nop>

"   write / quit
no mw  :write<CR>
nn mvv :write !sudo tee %<CR>
no mmw :write!<CR>
no mW  :wall<CR>
no mmW :wall!<CR>
no mq  :quit<CR>
no mmq :quit!<CR>
no mQ  :quitall<CR>
no mmQ :quitall!<CR>
no md  :bn\|bd#<CR>
no mmd :bn!\|bd! #<CR>
no <silent> mso :let view = winsaveview() \| write \| source $HOME/.vimrc\|e \| call winrestview(view)<CR>

"   find
nn sf  :fin<Space>
nn ssf :fin!<Space>
nn sTf :tabf<Space>
nn shf :sf<Space>
nn svf :vert sf<Space>

"   edit
nn se  :e<Space>
nn sse :e!<Space>
nn sTe :tabe<Space>
nn she :sp<Space>
nn sve :vert<Space>

"   prev
nn sp :e #<CR>
nn sTp :tabe #<CR>
nn shp :sp #<CR>
nn svp :vert #<CR>

"   cwd edit
nn s.  :lc %:h<CR>:e<Space>
nn ss. :lc %:h<CR>:e!<Space>
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
nn <silent> sne :let @s=@/<CR>:e $NOESIS/english.noe<CR>?##  Voca<CR>zt:let @/=@s<CR>
nn <silent> snf :let @s=@/<CR>:e $NOESIS/french.noe<CR>?##  Voca<CR>zt:let @/=@s<CR>

" nn <silent> snt :let @s=@/<CR>:e $NOESIS/todo.noe<CR>:silent! /\s\d\{6}\s<CR>:let @/=@s<CR>0zz
nn <silent> snt :e $NOESIS/todo.noe<CR>gi<Esc>zz
nn <silent> snh :e $NOESIS/done.gpg.noe<CR>
nn <silent> snj :e $NOESIS/journal.gpg.noe<CR>
nn <silent> snn :e $NOESIS/notes.noe<CR>
nn <silent> snh :echo "NOP try snj"<CR>

"  config
nn <silent> sc  <nop>
nn <silent> scv :e $HOME/.vimrc<CR>gi<Esc>
nn <silent> scA :e $HOME/git/config/vim/init/autocmd.vim<CR>gi<Esc>
nn <silent> scC :e $HOME/git/config/vim/init/command.vim<CR>gi<Esc>
nn <silent> scO :e $HOME/git/config/vim/init/option.vim<CR>gi<Esc>
nn <silent> scP :e $HOME/git/config/vim/init/plugin.vim<CR>gi<Esc>
nn <silent> scM :e $HOME/git/config/vim/plugin/mappings.vim<CR>gi<Esc>
nn <silent> sca :e $HOME/.config/alacritty/alacritty.toml<CR>gi<Esc>
nn <silent> scz :e $HOME/.zshrc<CR>gi<Esc>
nn <silent> sce :e $HOME/.zshenv<CR>gi<Esc>
nn <silent> sct :e $HOME/.tmux.conf<CR>gi<Esc>


"   git


nn <Leader>gg :echo system('
            \
            \ git status -s --show-stash --ignore-submodules=untracked &&
            \ git diff -U0 \| grep "^+\\|^-" \| grep -v "^+++\\s\\|^---\\s" &&
            \ echo "" && git log --oneline -5')
            \\|echo "                                                                             Max len msg ↓"
            \<CR>:!git add . && git commit --allow-empty -m ""<Left>

nn <Leader>g? :!clear
            \
            \ && git status -s --show-stash --ignore-submodules=untracked
            \ && git diff -U0 && git show -U0
            \ && git log --oneline -10<CR>

nn <Leader>gcm :echo system('git log --oneline -5')
            \
            \\|echo "                                                                   Max len msg ↓"
            \<CR>:!git commit -m ""<Left>

nn <Leader>gap :!clear && git add --patch<CR>
nn <Leader>gau :!clear && git add --update && git status -s --show-stash --ignore-submodules=untracked<CR>
nn <Leader>gca :!clear && git commit --amend<CR>
nn <Leader>gco :!clear && git commit<CR>
nn <Leader>gdi :!clear && git diff<CR>
nn <Leader>gds :!clear && git diff --staged<CR>
nn <Leader>glo :!clear && git log --oneline -10<CR>
nn <Leader>gre :!clear && git restore<Space>
nn <Leader>grs :!clear && git reset<Space>
nn <Leader>gsh :!clear && git show<CR>
nn <Leader>gst :!clear && git status -s --show-stash --ignore-submodules=untracked<CR>


"   cmdline (gl)


nn gl <nop>
nn glbc V:!bc<CR>
nn glbn :call toggle_nav#(":bnext", ":bprev")<CR>
nn glcc :set cursorcolumn!<CR>:set cursorcolumn?<CR>
nn glcd :cd %:h<CR>
nn glcl :set cursorline!<CR>:set cursorline?<CR>
nn glco :call colorswitch#('seoul256-light', 'nord')<CR>
vn glen :'<,'>!trans -b :fr
nn glex :exe getline(".")<CR>
vn glfr :'<,'>!trans -b :en
nn glhl :set hls!<CR>:set hls?<CR>
nn gllc :lc %:h<CR>
nn glli :set list!<CR>:set list?<CR>
nn glve :set virtualedit=all
nn glln :call toggle_nav#(":lnext", ":lprev")<CR>
nn glnu :set number!<CR>:set number?<CR>
nn glpd :put=strftime('%a %d %b %Y')<CR>
nn glqn :call toggle_nav#(":cnext", ":cprev")<CR>
nn glrn :set relativenumber!<CR>:set relativenumber?<CR>
nn glsb :set scrollbind!<CR>:set scrollbind?<CR>
nn glsc :exec ':set scrolloff=' . 999*(&scrolloff == 0)<CR>
nn glsp :set spell!<CR>:set spell?<CR>
nn glss :StaticSearch<Space>
nn glst :set startofline!<CR>:set startofline?<CR>
nn glsy :call getsyntax#()<CR>
nn glts :put=strftime('%y%m%d%H%M%S')<CR>


"   gpg enc / dec
nn glge :silent %!gpg --quiet --encrypt --armor --recipient $GPGID<CR>
nn glgd :silent %!gpg --quiet --decrypt<CR>
" nn glge :silent %!gpg --encrypt --armor --recipient $GPGID 2>/dev/null<CR>
" nn glgd :silent %!gpg --decrypt 2>/dev/null<CR>

"   restart
nn glgr :silent !gpgconf --kill gpg-agent<CR>:redraw!<CR>

"   gpg enc / dec selection
vn glgs :!gpg --symmetric --armor<CR>
vn glga :!gpg --encrypt --armor --recipient $GPGID<CR>
vn glgd :!gpg --quiet --decrypt<CR>



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
nn <silent> <Leader>? :let view = winsaveview() \| execute 'set nospell' \| execute 'normal! ggg?G' \| call winrestview(view)<CR>

"   clipboard
nn <silent> <Leader>y :call system("xclip -sel clip", getreg('"'))<CR>
no "+Y V:!  xclip -f -sel clip<CR>
vn "+y :!   xclip -f -sel clip<CR>
no "+p :r!  xclip -o -sel clip<CR>
no "+P :-1r!xclip -o -sel clip<CR>

"   guard rails
nn Q :echo "!Q"<CR>

"   header
nn <Leader>H :call header#()<CR>

ino jf <Esc>
ino fj <Esc>

"   prevent cmdline c-u deletion
cno <C-U> <Nop>


no <space>p "+p

no <space>z <C-z>
no <space>r <C-r>
" no <space>o <C-o>
" no <space>i <C-i>
no <space>v <C-v>
no <space>u <C-u>
no <space>d <C-d>

"   edition gi

"   move the rest of the line down
nn <space>o i<CR><Esc><S-j>


nn <space>sq Q
nn <space>sw W
nn <space>se E
nn <space>sr R
nn <space>st T
nn <space>sy Y
nn <space>su U
nn <space>si I
nn <space>so O
nn <space>sp P
nn <space>sa A
nn <space>ss S
nn <space>sd D
nn <space>sf F
nn <space>sg G
nn <space>sh H
nn <space>sj J
nn <space>sk K
nn <space>sl L
nn <space>sz Z
nn <space>sx X
nn <space>sc C
nn <space>sv V
nn <space>sb B
nn <space>sn N
nn <space>sm M

nn <space>s` ~
nn <space>s1 !
nn <space>s2 @
nn <space>s3 #
nn <space>s4 $
nn <space>s5 %
nn <space>s6 ^
nn <space>s7 &
nn <space>s8 *
nn <space>s9 (
nn <space>s0 )
nn <space>s- _
nn <space>s= +

nn <space>s[ {
nn <space>s] }
nn <space>s<BS> <BAR>
nn <space>s; :
nn <space>s' "
nn <space>s, <
nn <space>s. >
nn <space>s/ ?
