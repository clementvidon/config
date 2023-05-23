" @filename  json.vim
" @created   230522 18:18:18  by  clem9nt@imac
" @updated   230522 18:18:18  by  clem9nt@imac
" @author    Clément Vidon

"   options


setlocal autoindent
setlocal expandtab
setlocal formatprg="prettier --stdin-filepath %"
setlocal path+=$DOTVIM/ftplugin/
setlocal shiftwidth=2
setlocal softtabstop=2
setlocal tabstop=2

let maplocalleader="gh"


"   mappings


nn <silent><buffer> <LocalLeader> <nop>

"   format
nn <silent><buffer> <LocalLeader>f :%!jq '.'<CR>
