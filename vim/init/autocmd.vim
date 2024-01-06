" init/autocmd
" Created: 230524 19:44:57 by clem9nt@imac
" Updated: 230524 19:44:57 by clem9nt@imac
" Maintainer: Clément Vidon

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
