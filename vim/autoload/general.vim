"   get syntax id
function s:getSyntaxID()
    return synID(line('.'), col('.'), 1)
endfunction
function s:getSyntaxParentID()
    return synIDtrans(s:getSyntaxID())
endfunction
function general#GetSyntax()
    echo synIDattr(s:getSyntaxID(), 'name')
    execute "highlight ".synIDattr(s:getSyntaxParentID(), 'name')
endfunction

"   vim private ( vim -c 'call Private() )
function general#Private()
    set history=0
    set nobackup
    set nowritebackup
    set nomodeline
    set noshelltemp
    set noswapfile
    set noundofile
    set secure
    set shada=""
    set viminfo=""
endfunction

"   strip trailing spaces
function general#StripTrailingSpaces()
    if !&binary && &filetype != 'diff'
        let l:view = winsaveview()
        keeppatterns %s/\s\+$//e
        " keeppatterns v/\_s*\S/d
        call winrestview(l:view)
    endif
endfunction

"   toggle colors
function general#ColorSwitch(clight, cdark)
    if system("uname -s") == "Darwin\n"
        if &bg == "dark"
            exec 'color seoul256-light | set bg=light'
        else
            exec 'color nord | set bg=dark'
        endif
        colors
    elseif system("uname -s") == "Linux\n"
        if &background ==# "dark"
            exec 'silent !sed -i --follow-symlinks "s/^color .*/color ' . a:clight . ' | set bg=light/g" ~/.config/vim/options.vim'
            exec 'silent set bg=light'
            exec 'colors ' . a:clight
            exec 'highlight Normal ctermbg=NONE'
            exec 'silent !cp ~/.config/alacritty/colors/' . a:clight .'.yml ~/.config/alacritty/colors.yml'
        elseif &background ==# "light"
            exec 'silent !sed -i --follow-symlinks "s/^color .*/color ' . a:cdark . ' | set bg=dark/g" ~/.config/vim/options.vim'
            exec 'silent set bg=dark'
            exec 'colors ' . a:cdark
            exec 'highlight Normal ctermbg=NONE'
            exec 'silent !cp ~/.config/alacritty/colors/'. a:cdark .'.yml ~/.config/alacritty/colors.yml'
        endif
    endif
endfunction

"   toggle quickfix nav
let s:qfnav=1
function general#QFNav()
    if s:qfnav
        echo "QF Nav enabled."
        nn <Up> :cprev<CR>
        nn <Down> :cnext<CR>
    else
        echo "QF Nav disabled."
        unmap <Up>
        unmap <Down>
    endif
    let s:qfnav = !s:qfnav
endfunction

"   header
function general#Header()
    let cmmt = &commentstring
    let user = trim(system('whoami')) . "@" . trim(system('hostname'))
    let time = strftime('%y%m%d %H:%M:%S')
    let seal = time . "  by  " . user
    if  (getline(2) =~ ' @created' && getline(3) =~ ' @updated')
        call setline(3, substitute(cmmt, '%s', ' @updated', '') . "   " . seal)
    else
        silent! call append(line("0"), "")
        silent! call append(line("0"), substitute(cmmt, '%s', ' @author    ', '') . "Clément Vidon")
        silent! call append(line("0"), substitute(cmmt, '%s', ' @updated   ', '') . seal)
        silent! call append(line("0"), substitute(cmmt, '%s', ' @created   ', '') . seal)
        silent! call append(line("0"), substitute(cmmt, '%s', ' @filename  ', '') . expand("%:t"))
    endif
endfunction

"   clang-format
function general#ClangFormat()
    if executable('clang-format')
        let save_cursor = getpos(".")
        let save_view = winsaveview()
        set modifiable
        let buffer_content = getline(1, '$')
        let formatted_content = system('clang-format', buffer_content)
        let formatted_lines = split(formatted_content, "\n")
        let num_extra_lines = line('$') - len(formatted_lines)
        if num_extra_lines > 0
            let extra_lines = repeat([''], num_extra_lines)
            let formatted_lines += extra_lines
        endif
        call setline(1, formatted_lines)
        keeppatterns %s/\s\+$//e " trailing spaces
        keeppatterns v/\_s*\S/d  " trailing lines
        set nomodified
        call winrestview(save_view)
        call setpos('.', save_cursor)
    endif
endfunction

"   remove 'abbreviate' termination space ( :helpgrep Eatchar )
function general#Eatchar(pat)
    let c = nr2char(getchar(0))
    return (c =~ a:pat) ? '' : c
endfunction
