"options.vim @filename  options.vim
" @created   230522 20:24:15  by  clem9nt@imac
" @updated   230522 20:24:15  by  clem9nt@imac
" @author    Clément Vidon

"   gui


augroup custom_highlight
    autocmd!
    autocmd ColorScheme * syntax enable maxlines=400
    autocmd ColorScheme * highlight LineNr ctermbg=NONE
    autocmd ColorScheme * highlight CursorLine gui=underline cterm=underline ctermbg=NONE
    autocmd ColorScheme * highlight Comment term=bold ctermfg=103
augroup END

filetype plugin indent on
color nord | set bg=dark
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


set path=$DOTVIM/init                               " :find path
set wildignore=.git                                 " wildmenu results to hide


"   other


augroup changeQfCmdDirectory                        " quickfix cd
    autocmd!
    autocmd QuickFixCmdPre make execute "lc " . fnamemodify(findfile('Makefile', '.;'), ":h")
augroup END

if executable('ag')                                 " faster grep
    set grepformat^=%f:%l:%c:%m
    set grepprg=ag\ --vimgrep\ $*
endif

augroup toggleGpgEncryption                         " toggle gpg encryption on *.gpg.* files
    autocmd!
    autocmd BufReadPre,FileReadPre *.gpg.* setlocal viminfo="" shada=""
    autocmd BufReadPre,FileReadPre *.gpg.* setlocal noswapfile noundofile nobackup nowritebackup
    autocmd BufReadPost,FileReadPost *.gpg.* if getline('1') == '-----BEGIN PGP MESSAGE-----' |
                \ execute 'silent %!gpg --decrypt 2>/dev/null' | setlocal title titlestring='ENCRYPTED' |
                \ endif
    autocmd BufWritePre,FileWritePre *.gpg.* let g:view=winsaveview() | keeppatterns %s/\s\+$//e |
                \ execute 'silent %!gpg --default-recipient $GPG_KEY --armor --encrypt 2>/dev/null'
    autocmd BufWritePost,FileWritePost *.gpg.* exec "normal! u" |
                \ call winrestview(g:view) | setlocal title!
augroup END

augroup trailing_spaces
    autocmd!
    autocmd BufWritePre,FileWritePre * :call general#StripTrailingSpaces()
augroup END



"   search without moving cursor position
command! -nargs=+ -bar StaticSearch execute ":let @/=expand('<args>')" | set hlsearch | redraw!

"   sudo write
command! W :execute ':silent w !sudo tee %>/dev/null' | :edit!

"   bufonly
command! BufOnly execute '%bdelete | edit # | normal `"'

"   translate
command! -nargs=+ -bar Fr execute ' read! trans "<args>" -from en -to fr -brief 2> /dev/null'
command! -nargs=+ -bar En execute ' read! trans "<args>" -from fr -to en -brief 2> /dev/null'
command! -nargs=+ -bar Enp execute '! clear; trans "<args>" -from fr -to en -brief 2> /dev/null -play'

"   synonym (X4s8FmmkYqgU1LIcjEBA)
command! -nargs=+ -bar Sy execute '! clear; synonym "<args>"'

"   tmux sendkey
command! -nargs=+ -bar Sl execute 'silent ! tmux send-keys -t left "<args>" Enter' | redraw!
command! -nargs=+ -bar Sr execute 'silent ! tmux send-keys -t right "<args>" Enter' | redraw!
command! -nargs=+ -bar S0 execute 'silent ! tmux send-keys -t 0 "<args>" Enter' | redraw!
command! -nargs=+ -bar S1 execute 'silent ! tmux send-keys -t 1 "<args>" Enter' | redraw!
