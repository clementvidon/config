" init/autocmd
" Created: 230524 19:44:57 by clem9nt@imac
" Updated: 230524 19:44:57 by clem9nt@imac
" Maintainer: Clément Vidon

augroup vim_startup
    autocmd!
    let $MEMO=$HOME . "/git/Memo"
    autocmd VimEnter * if @% == '' | setlocal path+=$DOTVIM/**,$MEMO/*/** | endif
    autocmd VimEnter * if @% == '' | nn <buffer><silent> <CR> :e $MEMO/Lists/todo.md<CR>GMz. | endif
augroup END

augroup custom_highlight
    autocmd!
    autocmd ColorScheme * syntax enable maxlines=400
    autocmd ColorScheme * highlight LineNr ctermbg=NONE
    autocmd ColorScheme * highlight CursorLine gui=underline cterm=underline ctermbg=NONE
    autocmd ColorScheme * highlight Comment term=bold ctermfg=103
augroup END

augroup gpg_auto_encryption
    autocmd!
    autocmd BufReadPre,FileReadPre *.gpg.* setlocal viminfo="" shada=""
    autocmd BufReadPre,FileReadPre *.gpg.* setlocal noswapfile noundofile nobackup nowritebackup
    autocmd BufReadPost,FileReadPost *.gpg.* if getline('1') == '-----BEGIN PGP MESSAGE-----' |
                \ execute 'silent %!gpg --decrypt 2>/dev/null' | setlocal title titlestring='ENCRYPTED' | endif
    autocmd BufWritePre,FileWritePre *.gpg.* let g:view=winsaveview() | keeppatterns %s/\s\+$//e |
                \ execute 'silent %!gpg --default-recipient $GPG_KEY --armor --encrypt 2>/dev/null'
    autocmd BufWritePost,FileWritePost *.gpg.* execute "normal! u" | call winrestview(g:view) | setlocal title!
augroup END

augroup strip_trailing_spaces
    autocmd!
    autocmd BufWritePre,FileWritePre * :call strip_trailing_spaces#()
augroup END