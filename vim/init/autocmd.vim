" init/autocmd
" Created: 230524 19:44:57 by clem9nt@imac
" Updated: 240911 16:09:02 by clem@spectre
" Maintainer: Clément Vidon

augroup gpg_auto_encryption
    autocmd!
    " Check GPG card status on reading gpg files
    autocmd BufReadPre,FileReadPre *.gpg.* execute "silent! gpg --card-status" | execute "redraw!"

    " Disable swap file, undo file, viminfo, and shada for gpg files
    autocmd BufReadPre,FileReadPre *.gpg.* setlocal viminfo="" shada=""
    autocmd BufReadPre,FileReadPre *.gpg.* setlocal noswapfile noundofile nobackup nowritebackup

    " Handle decryption when reading gpg files
    autocmd BufReadPost,FileReadPost *.gpg.* if getline('1') == '-----BEGIN PGP MESSAGE-----' |
                \ execute 'silent %!gpg --decrypt 2>/dev/null' |
                \ redraw! |
                \ endif

    " Prepare buffer before writing (encrypt)
    autocmd BufWritePre,FileWritePre *.gpg.* let g:view=winsaveview() |
                \ keeppatterns %s/\s\+$//e |
                \ execute 'silent %!gpg --armor --encrypt --default-recipient ' . $GPGID . ' 2>/dev/null'

    " After writing the file, restore the buffer and update title
    autocmd BufWritePost,FileWritePost *.gpg.* execute "normal! u" |
                \ call winrestview(g:view) |
                \ let strtime = strftime('%y%m%d at %H:%M:%S', getftime(expand('%'))) |
                \ setlocal title titlestring=Last\ ENCRYPTION\ on\ %{strtime}

    " Change title when leaving or entering buffers
    autocmd BufEnter *.gpg.* let strtime = strftime('%y%m%d at %H:%M:%S', getftime(expand('%'))) |
                \ setlocal title titlestring=last\ ENCRYPTION\ on\ %{strtime}
    autocmd BufLeave *.gpg.* if &filetype != 'gpg' | setlocal title! | endif
augroup END

augroup strip_trailing_spaces
    autocmd!
    autocmd BufWritePre,FileWritePre * :call strip_trailing_spaces#()
augroup END

augroup remind_me
    autocmd!
    autocmd VimEnter * :call remindme#("Mon ", "Weekly Review")
    autocmd VimEnter * :call remindme#("Sun ", "Weekly Review")
    autocmd VimEnter * :call remindme#(" 01 ", "Monthy Review")
    autocmd VimEnter * :call remindme#("240618", "Resilier abonnement audible")
augroup END
