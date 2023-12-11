" @filename  go.vim
" @created   230522 18:04:16  by  clem9nt@imac
" @updated   230522 18:04:16  by  clem9nt@imac
" @author    Clément Vidon

"   options


setlocal norelativenumber
setlocal laststatus=2
setlocal autoread
setlocal path=.,, " ./**

let maplocalleader="gh"

let g:gutentags_enabled = 1
let b:surround_45='("\r");'

"   mappings


nn <buffer> <LocalLeader> <nop>

"   execute
nn <buffer> <LocalLeader>e :write<CR>:!clear && go run %<CR>

"   format
nn <buffer> <LocalLeader>f :write<CR>:silent !clear && go fmt<CR>:redraw!<CR>

"   settings
nn <buffer> <LocalLeader>, :write<CR>:e $DOTVIM/ftplugin/go.vim<CR>

"   test
nn <buffer> <LocalLeader>t :write<CR>:!clear && go test -cover<CR>

"   benchmark
nn <buffer> <LocalLeader>b :write<CR>:!clear && go test -bench=.<CR>
