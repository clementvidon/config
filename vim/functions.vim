" --------------------------------- COMMANDS {{{
"   SUDO :WRITE
com! W :execute ':silent w !sudo tee % > /dev/null' | :edit!

"   BUFONLY
com! BufOnly execute '%bdelete | edit # | normal `"'

"   TRANSLATOR
com! -nargs=+ Fr exec '! clear; trans "<args>" -from en -to fr -brief 2> /dev/null'
com! -nargs=+ En exec '! clear; trans "<args>" -from fr -to en -brief -play 2> /dev/null'
"   SYNONYM ('-l fr salut' for french Syn) (APIKEY:K4f8SzzxLdtH1YVpwRON)
com! -nargs=+ Sy exec '! clear; synonym <args>' | redraw!

"   GET HILIGHT
function! GetSyntaxID()
    return synID(line('.'), col('.'), 1)
endfunction
function! GetSyntaxParentID()
    return synIDtrans(GetSyntaxID())
endfunction
function! GetSyntax()
    echo synIDattr(GetSyntaxID(), 'name')
    exec "hi ".synIDattr(GetSyntaxParentID(), 'name')
endfunction

"   NOTRACE
"   vim -c 'call Notrace()'
function! Notrace()
    set history=0
    set nobackup
    set nowritebackup
    set nomodeline
    set noshelltemp
    set noswapfile
    set noundofile
    set viminfo=""
    set secure
endfunction

"   TRAILING SPACES
function! StripTrailingSpaces()
    if !&binary && &filetype != 'diff'
        let l:view = winsaveview()
        keeppatterns %s/\s\+$//e
        call winrestview(l:view)
    endif
endfunction
augroup trailing_spaces
    au!
    au BufWritePre,FileWritePre * :call StripTrailingSpaces()
augroup END
" augroup retab
"     au!
"     au BufWritePre,FileWritePre * if &expandtab ==# "noexpandtab" | execute ':%retab' | endif
" augroup END
" }}}
" --------------------------------- OPTIMIZE {{{
"   SILENT SHELL CMD
com! -nargs=+ S exec 'silent !<args>' | redraw!
" }}}
" --------------------------------- TOGGLE {{{
"   TOGGLE COLORS
function! ColorSwitch(clight, cdark)
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
endfunction
" }}}
