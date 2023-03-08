" --------------------------------- COMMANDS >>>
"   SUDO :WRITE
com! W :execute ':silent w !sudo tee % > /dev/null' | :edit!

"   BUFONLY
com! BufOnly execute '%bdelete | edit # | normal `"'

"   TRANSLATOR (add -play flag to hear pronunciation)
com! -nargs=+ -bar Fr exec ' r! trans "<args>" -from en -to fr -brief 2> /dev/null'
com! -nargs=+ -bar En exec ' r! trans "<args>" -from fr -to en -brief 2> /dev/null'
com! -nargs=+ -bar Enp exec '! clear; trans "<args>" -from fr -to en -brief 2> /dev/null -play'
"   SYNONYM ('-l fr salut' for french Syn) (APIKEY:K4f8SzzxLdtH1YVpwRON)
com! -nargs=+ -bar Sy exec '! clear; synonym <args>' | redraw!

"   TMUX SENDKEY
com! -nargs=+ -bar Sl exec 'silent ! tmux send-keys -t left "<args>" Enter' | redraw!
com! -nargs=+ -bar Sr exec 'silent ! tmux send-keys -t right "<args>" Enter' | redraw!
com! -nargs=+ -bar S0 exec 'silent ! tmux send-keys -t 0 "<args>" Enter' | redraw!
com! -nargs=+ -bar S1 exec 'silent ! tmux send-keys -t 1 "<args>" Enter' | redraw!
com! -nargs=+ -bar S2 exec 'silent ! tmux send-keys -t 2 "<args>" Enter' | redraw!
com! -nargs=+ -bar S3 exec 'silent ! tmux send-keys -t 3 "<args>" Enter' | redraw!
com! -nargs=+ -bar S4 exec 'silent ! tmux send-keys -t 4 "<args>" Enter' | redraw!
com! -nargs=+ -bar S5 exec 'silent ! tmux send-keys -t 5 "<args>" Enter' | redraw!

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
    elseif &background ==# "light" exec 'silent !sed -i --follow-symlinks "s/^    color.*/    color ' . a:cdark . ' | set bg=dark/g" ~/.config/vim/options.vim'
        exec 'silent set bg=dark'
        exec 'colors ' . a:cdark
        exec 'hi Normal ctermbg=NONE'
        exec 'silent !cp ~/.config/alacritty/colors/'. a:cdark .'.yml ~/.config/alacritty/colors.yml'
    endif
endfunction
"   TOGGLE QUICKFIX NAV
let s:qfnav=1
function! QFNav()
    if s:qfnav
        echo "QF Nav enabled."
        nn <Up> :cprev<CR>
        nn <Down> :cnext<CR>
    else
        echo "QF Nav disabled."
        unm <Up>
        unm <Down>
    endif
    let s:qfnav = !s:qfnav
endfunction
" <<<
" --------------------------------- IMPROVE >>>

"   @brief  Format the whole file according to formatprg.
"
"   @see    ':formatprg'
"

function! FormatCurrentFile()
    let l:view = winsaveview()
    exec 'normal gggqG'
    " exec 'undojoin | normal gggqG'
    call winrestview(l:view)
endfunction

"   @brief  Vim 'gF' extension to make it accept a string pattern as a cursor
"           position in the target file.
"
"   @see    gf, gF
"
"           TODO
"           See ':h isfname'
"  use      echo col('.')

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

"   @brief Highlight multiple words.
"          TODO

function! Highlighter(n)
    " Save our location.
    normal! mz

    " Yank the current word into the z register.
    " normal! "zyiw
    " Yank the current line into the z register.
    " normal! "zyy

    " Calculate an arbitrary match ID.  Hopefully nothing else is using it.
    let mid = 77750 + a:n
    " Clear existing matches, but don't worry if they don't exist.
    "silent! call matchdelete(mid)
    try
        call matchdelete(mid)
        catch 'E803'
            " Construct a literal pattern that has to match at boundaries.
            let pat = '\V\<' . escape(@z, '\') . '\>'
            " Actually match the words.
            call matchadd("Highlighter" . a:n, pat, 1, mid)
        endtry
        " Move back to our original location.
        normal! `z
endfunction

"clear all highlighting
function! ClearAllHi()
    for i in range(1,6)
        let mid = 77750 + i
        silent! call matchdelete(mid)
    endfor
endfunction

nnoremap <silent> <leader>0 :call ClearAllHi()<cr>
nnoremap <silent> <leader>1 :call Highlighter(1)<cr>
nnoremap <silent> <leader>2 :call Highlighter(2)<cr>
nnoremap <silent> <leader>3 :call Highlighter(3)<cr>
nnoremap <silent> <leader>4 :call Highlighter(4)<cr>
nnoremap <silent> <leader>5 :call Highlighter(5)<cr>
nnoremap <silent> <leader>6 :call Highlighter(6)<cr>

hi def Highlighter1 guifg=#000000 ctermfg=16 guibg=#ffa724 ctermbg=214
hi def Highlighter2 guifg=#000000 ctermfg=16 guibg=#aeee00 ctermbg=154
hi def Highlighter3 guifg=#000000 ctermfg=16 guibg=#8cffba ctermbg=121
hi def Highlighter4 guifg=#000000 ctermfg=16 guibg=#b88853 ctermbg=137
hi def Highlighter5 guifg=#000000 ctermfg=16 guibg=#ff9eb8 ctermbg=211
hi def Highlighter6 guifg=#000000 ctermfg=16 guibg=#ff2c4b ctermbg=195

"   Useful to remove the :abbreviate finale space
"   Cf. :helpgrep Eatchar

function Eatchar(pat)
    let c = nr2char(getchar(0))
    return (c =~ a:pat) ? '' : c
endfunction

" <<<
