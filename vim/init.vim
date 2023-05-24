" vim/init
" Created: 230524 19:57:11 by clem9nt@imac
" Updated: 230524 19:57:11 by clem9nt@imac
" Maintainer: Clément Vidon

let $NOESIS=$HOME . "/git/Noesis"
let $DOTVIM=$HOME . "/git/config/vim"
set runtimepath^=$DOTVIM
set packpath+=$DOTVIM

if empty(glob($DOTVIM . "/.undo/vim"))  | exec 'silent !mkdir -p $DOTVIM/.undo/vim'  | endif
if empty(glob($DOTVIM . "/.undo/nvim")) | exec 'silent !mkdir -p $DOTVIM/.undo/nvim' | endif
if empty(glob($DOTVIM . "/.spell")) | exec 'silent !mkdir $DOTVIM/.spell' | endif
if empty(glob($DOTVIM . "/.swap"))  | exec 'silent !mkdir $DOTVIM/.swap'  | endif

if !has('nvim')
    set viminfo='100,<50,s10,h,n$DOTVIM/.viminfo
    set undodir=$DOTVIM/.undo/vim//,/tmp//
else
    set shada='100,<50,s10,h,n$DOTVIM/.shada
    set undodir=$DOTVIM/.undo/nvim//,/tmp//
endif

source $DOTVIM/init/option.vim
source $DOTVIM/init/autocmd.vim
source $DOTVIM/init/command.vim
source $DOTVIM/init/plugin.vim
