" init/option
" Created: 230524 19:45:03 by clem9nt@imac
" Updated: 230524 19:45:03 by clem9nt@imac
" Maintainer: Clément Vidon

if has('nvim')
    set shada='100,<50,s10,h,n$DOTVIM/.shada        " shared data
    set undodir=$DOTVIM/.undo/nvim//,/tmp//         " undo files location
else
    set viminfo='100,<50,s10,h,n$DOTVIM/.viminfo    " shared data
    set undodir=$DOTVIM/.undo/vim//,/tmp//          " undo files location
    set listchars=tab:>\ ,trail:-                   " strings to use for :list command (vim)
    set switchbuf+=uselast                          " load the quickfix item into lastused split (vim)
    set ttimeoutlen=0                               " esc delay fix (vim)
    set history=1000                                " cmdline history (vim)
    set belloff=all                                 " sound off (vim)
    set wildmenu                                    " displays possible completion matches (vim)
    set showcmd                                     " cursor pos%[y:x] in statusline (vim)
    set ruler                                       " cursor pos [y:x] n% in statusline (vim)
endif

syntax on
filetype plugin indent on

set fillchars=stl:\ ,stlnc:\ ,vert:\ ,fold:·,diff:- " split separator decoration
set guicursor=n-v-c-i:block                         " cursor style
set shortmess=filnxtToOF                            " see ':h shortmess'
set ignorecase smartcase                            " ignore case except if uppercase used
set noincsearch                                     " disable incremental search (neo)
set nowrap                                          " screen line wrapping
set relativenumber                                  " number column
set showmatch                                       " set showmatch
set spellfile=$DOTVIM/.spell/custom.utf-8.add       " dictionary location
set autoindent                                      " auto indent
set expandtab                                       " insert spaces instead tab
set formatoptions=tcrqjnp                           " see ':h fo-table'
set shiftround                                      " indent to the nearest tab mark
set shiftwidth=4 tabstop=4                          " shift and tab width in spaces
set softtabstop=4                                   " simulate tabs for backspaces too
set nomodeline                                      " disables modelines
set secure                                          " disables shell access
set undofile                                        " enable undo
set directory=$DOTVIM/.swap//,/tmp//                " undo files directory
set path=.,,$DOTVIM/init/,$DOTVIM/plugin/           " :find path
set wildignore=.git                                 " wildmenu results to hide
