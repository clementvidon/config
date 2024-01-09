" plugin/mappings
" Created: 231229 16:44:16 by clem@spectre
" Updated: 231229 16:44:16 by clem@spectre
" Maintainer: Clément Vidon (clemedon)

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
nn <silent> sna :let @s=@/<CR>:e $NOESIS/Lists/achiever.noe<CR>G:silent! ?\s\d\{6}\s\d\d:\d\d\s\D<CR>:let @/=@s<CR>0
nn <silent> snt :e $NOESIS/Lists/todo.gpg.noe<CR>
nn <silent> snj :e $NOESIS/Lists/journal.gpg.noe<CR>
nn <silent> snc :e $NOESIS/Lists/schedule.gpg.noe<CR>
nn <silent> snp :e $NOESIS/Lists/post-it.noe<CR>gi<Esc>

"  config
nn <silent> scv :e $HOME/.vimrc<CR>gi<Esc>
nn <silent> scA :e $HOME/git/config/vim/init/autocmd.vim<CR>gi<Esc>
nn <silent> scC :e $HOME/git/config/vim/init/command.vim<CR>gi<Esc>
nn <silent> scO :e $HOME/git/config/vim/init/option.vim<CR>gi<Esc>
nn <silent> scP :e $HOME/git/config/vim/init/plugin.vim<CR>gi<Esc>
nn <silent> scM :e $HOME/git/config/vim/plugin/mappings.vim<CR>gi<Esc>
nn <silent> sca :e $HOME/.config/alacritty/alacritty.yml<CR>gi<Esc>
nn <silent> scz :e $HOME/.zshrc<CR>gi<Esc>
nn <silent> sce :e $HOME/.zshenv<CR>gi<Esc>
nn <silent> sct :e $HOME/.tmux.conf<CR>gi<Esc>
nn <silent> sci :e $HOME/.config/i3/config<CR>gi<Esc>


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
nn glcc :set cursorcolumn!<CR>
nn glcd :cd %:h<CR>
nn glcl :set cursorline!<CR>
nn glco :call colorswitch#('seoul256-light', 'nord')<CR>
nn glen :En<Space>
nn glex :exe getline(".")<CR>
nn glfr :Fr<Space>
nn glhl :set hls!<CR>
nn gllc :lc %:h<CR>
nn glli :set list!<CR>
nn glve :set virtualedit=all
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
