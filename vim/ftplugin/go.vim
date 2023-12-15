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
nn <buffer> <LocalLeader>t :write<CR>:!clear && go test<CR>
nn <buffer> <LocalLeader>T :write<CR>:!clear && go test -v<CR>

"   benchmark
nn <buffer> <LocalLeader>b :write<CR>:!clear && go test -bench=.<CR>

"   coverage
nn <buffer> <LocalLeader>c :write<CR>
            \:!go test -covermode=count -coverprofile=/tmp/countcoverprofile.out<CR>
            \:!clear && go tool cover -func=/tmp/countcoverprofile.out<CR>
