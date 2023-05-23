" @filename  init.vim
" @created   230523 16:46:41  by  cvidon@e3r2p17.clusters.42paris.fr
" @updated   230523 16:46:41  by  cvidon@e3r2p17.clusters.42paris.fr
" @author    Clément Vidon


let $DOTVIM=$HOME . "/git/config/vim"
set runtimepath^=$DOTVIM
set packpath+=$DOTVIM

if empty(glob($DOTVIM . "/.undo/vim"))  | exec 'silent !mkdir -p $DOTVIM/.undo/vim'  | endif
if empty(glob($DOTVIM . "/.undo/nvim")) | exec 'silent !mkdir -p $DOTVIM/.undo/nvim' | endif
if empty(glob($DOTVIM . "/.spell")) | exec 'silent !mkdir $DOTVIM/.spell' | endif
if empty(glob($DOTVIM . "/.swap"))  | exec 'silent !mkdir $DOTVIM/.swap' | endif

if !has('nvim')
    set viminfo='100,<50,s10,h,n$DOTVIM/.viminfo
    set undodir=$DOTVIM/.undo/vim//,/tmp//
else
    set shada='100,<50,s10,h,n$DOTVIM/.shada
    set undodir=$DOTVIM/.undo/nvim//,/tmp//
endif

"   startup screen

augroup startup
    autocmd!
    let $MEMO=$HOME . "/git/Memo"
    autocmd VimEnter * if @% == '' | setlocal path+=$DOTVIM/**,$MEMO/*/** | endif
    autocmd VimEnter * if @% == '' | nn <buffer><silent> <CR> :e $MEMO/Lists/todo.md<CR>GMz. | endif
augroup END

source $DOTVIM/init/plugins.vim
source $DOTVIM/init/options.vim
