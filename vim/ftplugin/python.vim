" @filename  python.vim
" @created   230522 19:09:16  by  clem9nt@imac
" @updated   230522 19:09:16  by  clem9nt@imac
" @author    Clément Vidon

"   options


setlocal cindent
setlocal expandtab
setlocal formatprg="black --quiet - 2>/tmp/vim_format_errors"
setlocal showmatch
setlocal tw=80

let maplocalleader="gh"


"   mappings


nn <silent><buffer> <LocalLeader> <nop>

"   format
nn <silent><buffer> <LocalLeader>f :let g:save=winsaveview()<CR>
            \:try <BAR>
            \undojoin \| silent exec "%!black --quiet - 2>/tmp/vim_gq_err" <BAR>
            \catch /^Vim\%((\a\+)\)\=:E790/ <BAR>
            \finally <BAR>
            \silent exec "%!black --quiet - 2>/tmp/vim_gq_err" <BAR>
            \endtry <CR>
            \:silent call winrestview(g:save)<CR>
            \:if v:shell_error != 0 <BAR>
            \exec "!clear;cat /tmp/vim_gq_err" <BAR>
            \else <BAR>
            \echo expand("%") . " formatted" <BAR>
            \endif <CR>

"   execute file
nn <silent><buffer> <LocalLeader>x :w\|lcd %:h<CR>
            \:!clear; /usr/bin/python3 %<CR>

"   execute program
au FileType python nn <silent><buffer> <LocalLeader>X :w\|lc %:h<CR>
            \:!clear; /usr/bin/python3 main.py<CR>

"   print
au Filetype python nn <silent><buffer> <LocalLeader>p oprint ()<Esc>==f)i

"   print wrap
au Filetype python nn <silent><buffer> <LocalLeader>w 0iprint (<Esc>A)<Esc>==f)h

"   put expr value
nn <silent><buffer> <LocalLeader>e :lc %:h<CR>
            \
            \:sil ec "Duplicate the line."<CR>
            \0Yp
            \:sil ec "Wrap the current line expression into a print."<CR>
            \iprint(<Esc>A=<Esc>V:s/=.*//<CR>A)<Esc>:w<CR>
            \:sil ec "Print its value in a comment"<CR>
            \:undojoin \| r!/usr/bin/python3 % 2>/dev/null<CR>`[V`]<C-V>0I#>> <Esc>
            \:sil ec "Delete line"<CR>
            \kdd
