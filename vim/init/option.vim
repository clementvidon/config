" init/option
" Created: 230524 19:45:03 by clem9nt@imac
" Updated: 230524 19:45:03 by clem9nt@imac
" Maintainer: Clément Vidon

"   gui


filetype plugin indent on
set fillchars=stl:\ ,stlnc:\ ,vert:\ ,fold:·,diff:- " split separator decoration
set guicursor=n-v-c-i:block                         " cursor style
set shortmess=filnxtToOF                            " see ':h shortmess'
set showcmd                                         " cursor pos%[y:x] in statusline (vim)


"   ergonomy


set belloff=all                                     " sound off (vim)
set history=1000                                    " cmdline history (vim)
set ignorecase smartcase                            " ignore case except if uppercase used
set listchars=tab:>\ ,trail:-                       " strings to use for :list command (vim)
set noincsearch                                     " disable incremental search (neo)
set nowrap                                          " screen line wrapping
set relativenumber                                  " number column
set ruler                                           " cursor pos [y:x] n% in statusline (vim)
set showmatch                                       " set showmatch
set spellfile=$DOTVIM/.spell/custom.utf-8.add       " dictionary location
set switchbuf+=uselast                              " load the quickfix item into prev used split (vim)
set ttimeoutlen=0                                   " esc delay fix (vim)
set wildmenu                                        " displays possible completion matches (vim)


"   indentation


set autoindent                                      " auto indent
set expandtab                                       " insert spaces instead tab
set formatoptions=tcqjnp                            " see ':h fo-table'
set shiftround                                      " indent to the nearest tab mark
set shiftwidth=4 tabstop=4                          " shift and tab width in spaces
set softtabstop=4                                   " simulate tabs for backspaces too


"   security


set directory=$DOTVIM/.swap//,/tmp//                " undo files directory
set nomodeline                                      " disables modelines
set secure                                          " disables shell access
set undofile                                        " enable undo


"   path


set path=.,,$DOTVIM/init/                           " :find path
set wildignore=.git                                 " wildmenu results to hide


"   other


if executable('ag')                                 " faster grep
    set grepformat^=%f:%l:%c:%m
    set grepprg=ag\ --vimgrep\ $*
endif
