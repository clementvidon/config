" @filename  motoko.vim
" @created   230522 18:23:04  by  clem9nt@imac
" @updated   230522 18:23:04  by  clem9nt@imac
" @author    Clément Vidon

"   options


" TODO ftdetect?-> au FileType motoko,mo,gdmo set filetype=motoko
set syntax=go
setlocal autoindent
setlocal cindent
setlocal expandtab
setlocal formatprg="mo-fmt %"
setlocal laststatus=2
setlocal makeprg="make --no-print-directory --jobs -C " . fnamemodify(findfile('Makefile', '.;'), ":h") . " $*"
setlocal shiftwidth=2
setlocal softtabstop=2
setlocal tabstop=2
setlocal textwidth=80

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
