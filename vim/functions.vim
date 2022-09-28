" --------------------------------- COMMANDS >>>
"   SUDO :WRITE
com! W :execute ':silent w !sudo tee % > /dev/null' | :edit!

"   BUFONLY
com! BufOnly execute '%bdelete | edit # | normal `"'

"   TRANSLATOR (add -play flag to hear pronunciation)
com! -nargs=+ Fr exec '! clear; trans "<args>" -from en -to fr -brief 2> /dev/null'
com! -nargs=+ En exec '! clear; trans "<args>" -from fr -to en -brief 2> /dev/null'
"   SYNONYM ('-l fr salut' for french Syn) (APIKEY:K4f8SzzxLdtH1YVpwRON)
com! -nargs=+ Sy exec '! clear; synonym <args>' | redraw!

"   TMUX SENDKEY
com! -nargs=+ Sl exec 'silent ! tmux send-keys -t left "<args>" Enter' | redraw!
com! -nargs=+ Sr exec 'silent ! tmux send-keys -t right "<args>" Enter' | redraw!
com! -nargs=+ S0 exec 'silent ! tmux send-keys -t 0 "<args>" Enter' | redraw!
com! -nargs=+ S1 exec 'silent ! tmux send-keys -t 1 "<args>" Enter' | redraw!
com! -nargs=+ S2 exec 'silent ! tmux send-keys -t 2 "<args>" Enter' | redraw!
com! -nargs=+ S3 exec 'silent ! tmux send-keys -t 3 "<args>" Enter' | redraw!
com! -nargs=+ S4 exec 'silent ! tmux send-keys -t 4 "<args>" Enter' | redraw!
com! -nargs=+ S5 exec 'silent ! tmux send-keys -t 5 "<args>" Enter' | redraw!

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
" <<<
" --------------------------------- OPTIMIZE >>>
"   SILENT SHELL CMD
com! -nargs=+ S exec 'silent !<args>' | redraw!
" <<<
" --------------------------------- TOGGLE >>>
"   TOGGLE COLORS
function! ColorSwitch(clight, cdark)
    if &background ==# "dark"
        exec 'silent !sed -i --follow-symlinks "s/^    color.*/    color ' . a:clight . ' | set bg=light/g" ~/.config/vim/options.vim'
        exec 'silent set bg=light'
        exec 'colors ' . a:clight
        exec 'hi Normal ctermbg=NONE'
        exec 'silent !cp ~/.config/alacritty/colors/' . a:clight .'.yml ~/.config/alacritty/colors.yml'
    elseif &background ==# "light"
        exec 'silent !sed -i --follow-symlinks "s/^    color.*/    color ' . a:cdark . ' | set bg=dark/g" ~/.config/vim/options.vim'
        exec 'silent set bg=dark'
        exec 'colors ' . a:cdark
        exec 'hi Normal ctermbg=NONE'
        exec 'silent !cp ~/.config/alacritty/colors/'. a:cdark .'.yml ~/.config/alacritty/colors.yml'
    endif
endfunction
" <<<
" --------------------------------- IMPROVE >>>

"   @brief  Vim 'gF' extension to make it accept a string pattern as a cursor
"           position in the target file.
"
"   @see    gf, gF
"
"           TODO
"           See ':h isfname'

function! GFPattern()
    " One 'path' in the current line
    if count(getline('.'), "@") == 1
        " Path extraction
        let l:path = getline('.')
        let l:chr = stridx(l:path, "@", 0) + 1
        let l:path = strpart(l:path, l:chr, strlen(l:path))
        if count(l:path, " ") >= 1
            let l:chr = stridx(l:path, " ", 0)
            let l:path = strpart(l:path, 0, l:chr)
        endif
        " If the path comes with a line pattern or not
        if count(l:path, "#") == 1
            " Line pattern extraction
            let l:path = split(l:path, "#")
            let l:file = l:path[0]
            let l:line = substitute(l:path[1], '_', '\\ ', "g")
            " If the line pattern is a number only or a string
            exec 'silent find +/' . l:line . ' ' . l:file
            exec 'normal z.'
        else
            exec 'silent find ' . l:path
            exec 'normal z.'
        endif
        " TODO
        " Multiple 'path' in the current line
        " elseif count(getline('.'), "@") > 1
        " expand("<cword>")
    endif
endfunction
" <<<
