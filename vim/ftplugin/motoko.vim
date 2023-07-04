" @filename  motoko.vim
" @created   230522 18:23:04  by  clem9nt@imac
" @updated   230522 18:23:04  by  clem9nt@imac
" @author    Clément Vidon

"   options


" TODO ftdetect?-> au FileType motoko,mo,gdmo set filetype=motoko
set syntax=go
setlocal laststatus=2

let maplocalleader = "gh"

let b:surround_45 = '("\r");'


"   mappings


nn <silent><buffer> <LocalLeader> <nop>

"   make
nn <silent><buffer> mm :w<CR>
            \:!clear<CR>
            \:make!<CR>
            \:cwindow<CR>

"   format
nn <silent><buffer> <LocalLeader>f :w<CR>:!mo-fmt %<CR>
