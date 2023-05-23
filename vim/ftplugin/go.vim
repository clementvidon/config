" @filename  go.vim
" @created   230522 18:04:16  by  clem9nt@imac
" @updated   230522 18:04:16  by  clem9nt@imac
" @author    Clément Vidon

"   options


let maplocalleader="gh"


"   mappings


nn <silent><buffer> <LocalLeader> <nop>

"   execute
nn <LocalLeader>x :!clear && go run main.go<CR>
