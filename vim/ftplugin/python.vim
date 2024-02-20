" @filename  python.vim
" @created   230522 19:09:16  by  clem9nt@imac
" @updated   230522 19:09:16  by  clem9nt@imac
" @author    Clément Vidon

"   options


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

"   execute single-file
nn <buffer> <LocalLeader>e :write<CR>:!clear && /usr/bin/python3 %<CR>

"   execute program
nn <buffer> <LocalLeader>E :write<CR>:!clear && /usr/bin/python3 main.py<CR>

"   test
" nn <buffer> <LocalLeader>t :write<CR>:!clear && pytest -v<CR>
" nn <buffer> <LocalLeader>T :write<CR>:!clear && pytest -v %<CR>
nn <buffer> <LocalLeader>t :write<CR>:!clear && python3 -m unittest -v<CR>
nn <buffer> <LocalLeader>T :write<CR>:!clear && python3 -m unittest -v %<CR>

"   print
nn <silent><buffer> <LocalLeader>p oprint ()<Esc>==f)i

"   print wrap
nn <silent><buffer> <LocalLeader>P 0iprint (<Esc>A)<Esc>==f)h

"   put expr value
nn <silent><buffer> <LocalLeader>x :lc %:h<CR>
            \
            \:sil ec "Duplicate the line."<CR>
            \0Yp
            \:sil ec "Wrap the current line expression into a print."<CR>
            \iprint(<Esc>A=<Esc>V:s/=.*//<CR>A)<Esc>:w<CR>
            \:sil ec "Print its value in a comment"<CR>
            \:undojoin \| r!/usr/bin/python3 % 2>/dev/null<CR>`[V`]<C-V>0I#>> <Esc>
            \:sil ec "Delete line"<CR>
            \kdd
