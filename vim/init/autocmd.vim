" init/autocmd
" Created: 230524 19:44:57 by clem9nt@imac
" Updated: 230524 19:44:57 by clem9nt@imac
" Maintainer: Clément Vidon

augroup gpg_auto_encryption
    autocmd!
    autocmd BufReadPre,FileReadPre *.gpg.* setlocal viminfo="" shada=""
    autocmd BufReadPre,FileReadPre *.gpg.* setlocal noswapfile noundofile nobackup nowritebackup
    autocmd BufReadPost,FileReadPost *.gpg.* if getline('1') == '-----BEGIN PGP MESSAGE-----' |
                \ execute 'silent %!gpg --decrypt 2>/dev/null' | setlocal title titlestring='ENCRYPTED' | redraw! | endif
    autocmd BufWritePre,FileWritePre *.gpg.* let g:view=winsaveview() | keeppatterns %s/\s\+$//e |
                \ execute 'silent %!gpg --armor --encrypt --default-recipient ' . $GPGID . ' 2>/dev/null'
    autocmd BufWritePost,FileWritePost *.gpg.* execute "normal! u" | call winrestview(g:view) | setlocal title!
augroup END

augroup strip_trailing_spaces
    autocmd!
    autocmd BufWritePre,FileWritePre * :call strip_trailing_spaces#()
augroup END

augroup remind_me
    autocmd!
    autocmd BufEnter todos.noe :call remindme#("Sun ", "Weekly Review")
    autocmd BufEnter todos.noe :call remindme#(" 01 ", "Monthy Review")
augroup END
