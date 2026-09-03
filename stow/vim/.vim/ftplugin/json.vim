" @filename  json.vim
" @created   230522 18:18:18  by  clem9nt@imac
" @updated   230522 18:18:18  by  clem9nt@imac
" @author    Clément Vidon

"   options


let maplocalleader="gh"


"   mappings


nn <silent><buffer> <LocalLeader> <nop>

"   format
nn <silent><buffer> <LocalLeader>f :%!jq '.'<CR>
