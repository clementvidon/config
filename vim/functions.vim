" --------------------------------- COMMANDS {{{
"   SUDO :WRITE
com! W :execute ':silent w !sudo tee % > /dev/null' | :edit!

"   BUFONLY
com! BufOnly execute '%bdelete|edit #|normal `"'

"   TRANSLATOR
com! -nargs=+ Fr exec '! clear; trans "<args>" -from en -to fr -brief 2> /dev/null'
com! -nargs=+ En exec '! clear; trans "<args>" -from fr -to en -brief -play 2> /dev/null'
"   SYNONYM ('-l fr salut' for french Syn) (APIKEY:K4f8SzzxLdtH1YVpwRON)
com! -nargs=+ Sy exec '! clear; synonym <args>' | redraw!

"   GET HILIGHT
fu! GetSyntaxID()
    return synID(line('.'), col('.'), 1)
endfun
fu! GetSyntaxParentID()
    return synIDtrans(GetSyntaxID())
endfun
fu! GetSyntax()
    echo synIDattr(GetSyntaxID(), 'name')
    exec "hi ".synIDattr(GetSyntaxParentID(), 'name')
endfun

"   GPG
"   transparently encrypt/decrypt
augroup GPG
    au!
    au BufReadPre,FileReadPre *.gpg.* setl viminfo=""
    au BufReadPre,FileReadPre *.gpg.* setl noswapfile noundofile nobackup
    au BufReadPost,FileReadPost *.gpg.* if getline('1') == '-----BEGIN PGP MESSAGE-----' |
                \ exec 'silent %!gpg --decrypt 2>/dev/null' | setl title titlestring='ENCRYPTED' |
                \ endif
    au BufWritePre,FileWritePre *.gpg.* let g:view = winsaveview() | keeppatterns %s/\s\+$//e |
                \exec 'silent %!gpg --default-recipient Clem9nt --armor --encrypt 2>/dev/null'
    au BufWritePost,FileWritePost *.gpg.* exec "normal! u"|
                \ call winrestview(g:view) | setl title!
augroup END

"   NOTRACE
"   vim -c 'call Notrace()'
fu! Notrace()
    set history=0
    set nobackup
    set nowritebackup
    set nomodeline
    set noshelltemp
    set noswapfile
    set noundofile
    set viminfo=""
    set secure
endfun

"   TRAILING SPACES
function! StripTrailingSpaces()
    if !&binary && &filetype != 'diff'
        let l:view = winsaveview()
        keeppatterns %s/\s\+$//e
        call winrestview(l:view)
    endif
endfun
augroup TRAILING_SPACES
    au!
    au BufWritePre,FileWritePre * :call StripTrailingSpaces()
augroup END
" augroup RETAB
"     au!
"     au BufWritePre,FileWritePre * if &expandtab ==# "noexpandtab" | execute ':%retab' | endif
" augroup END
" }}}
" --------------------------------- OPTIMIZE {{{
"   SILENT SHELL CMD
com! -nargs=+ S exec 'silent !<args>' | redraw!
" }}}
" --------------------------------- TOGGLE {{{
"   TOGGLE DRAWER
"nn s<CR> :call Drawer('todo.md')<CR>
"nn SC :call Drawer('calendar.md')<CR>
"nn SI :call Drawer('INDEX.md')<CR>
"nn SE :call Drawer('english.md')<CR>
"nn SF :call Drawer('french.md')<CR>
"nn SP :call Drawer('post-it.md')<CR>
"nn SS :call Drawer('shopping-list.md')<CR>
let s:open = 0
fu! Drawer(name)
    "                                                   CLOSE DRAWER
    if s:open == 1 && a:name != expand('%:t')   "       if out of the view
        let s:open = 0
    endif
    "                                                   CLOSE DRAWER
    if s:open == 1 && a:name == expand('%:t')
        setlocal wig+=$NOTES/**
        if  &mod == 1
            exec 'silent write'
        endif
        exec 'silent b#'
        let s:open = 0
        exec 'echo "["a:name": CLOSE ]"'
    elseif s:open == 0 && a:name != expand('%:t') "     OPEN DRAWER
        setlocal path+=$NOTES/**
        let s:open = 1
        if  &mod == 1
            exec 'silent write'
        endif "                                         OTHER DRAWER
        exec 'normal! mX'
        exec 'nn xx `X:no xx <nop><CR>:echo <CR>'
        exec 'silent find '. a:name
        exec 'normal! 5G'
        if a:name == "todo.md"
            exec 'normal! GM'
            exec 'normal! z.'
        endif
        if a:name == "english.md"
            exec '?\#\# '
            exec 'normal! z.'
        endif
        if a:name == "french.md"
            exec '/\#\# '
            exec 'normal! z.'
        endif
        exec 'echo "["a:name": OPEN ]"'
    endif
endfun

"   TOGGLE COLORS
fu! ColorSwitch(clight, cdark)
    if &background ==# "dark"
        exec 'silent !sed -i --follow-symlinks "s/^color.*/color ' . a:clight . ' | set bg=light/g" ~/.config/vim/options.vim'
        exec 'silent set bg=light'
        exec 'colors ' . a:clight
        exec 'hi Normal ctermbg=NONE'
        exec 'silent !cp ~/.config/alacritty/colors/' . a:clight .'.yml ~/.config/alacritty/colors.yml'
    elseif &background ==# "light"
        exec 'silent !sed -i --follow-symlinks "s/^color.*/color ' . a:cdark . ' | set bg=dark/g" ~/.config/vim/options.vim'
        exec 'silent set bg=dark'
        exec 'colors ' . a:cdark
        exec 'hi Normal ctermbg=NONE'
        exec 'silent !cp ~/.config/alacritty/colors/'. a:cdark .'.yml ~/.config/alacritty/colors.yml'
    endif
endfun
" }}}
