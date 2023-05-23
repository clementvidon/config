" @filename  html.vim
" @created   230522 18:07:29  by  clem9nt@imac
" @updated   230522 18:07:29  by  clem9nt@imac
" @author    Clément Vidon

"   options


setlocal shiftwidth=2
setlocal tabstop=2
setlocal formatprg="tidy -q -w -i --show-warnings 0 --show-errors 0 --tidy-mark no"
setlocal path+=$DOTVIM/ftplugin/

let maplocalleader="gh"


"   mappings


nn <silent><buffer> <LocalLeader> <nop>

"   clear
nn <silent><buffer> <LocalLeader>= Mmmgo=G:silent! :%s/\s\+$//e<CR>`mzz3<C-O>

"   format
nn <silent><buffer> <LocalLeader>f mmGgqgo`m


"   colors


highlight MatchParen ctermbg=darkgrey guibg=darkgrey
