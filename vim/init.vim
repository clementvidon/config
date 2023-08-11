" vim/init
" Created: 230524 19:57:11 by clem9nt@imac
" Updated: 230802 15:42:37 by cvidon@paul-f5Br5s5.clusters.42paris.fr
" Maintainer: Clément Vidon

let $NOESIS=$HOME . "/git/noesis"
let $DOTVIM=$HOME . "/git/config/vim"

if empty(glob($DOTVIM . "/.undo/vim"))  | exec 'silent !mkdir -p $DOTVIM/.undo/vim'  | endif
if empty(glob($DOTVIM . "/.undo/nvim")) | exec 'silent !mkdir -p $DOTVIM/.undo/nvim' | endif
if empty(glob($DOTVIM . "/.spell")) | exec 'silent !mkdir $DOTVIM/.spell' | endif
if empty(glob($DOTVIM . "/.swap"))  | exec 'silent !mkdir $DOTVIM/.swap'  | endif

set runtimepath^=$DOTVIM
set runtimepath+=$DOTVIM/after
set packpath+=$DOTVIM

source $DOTVIM/init/autocmd.vim
source $DOTVIM/init/plugin.vim
source $DOTVIM/init/option.vim
source $DOTVIM/init/command.vim
