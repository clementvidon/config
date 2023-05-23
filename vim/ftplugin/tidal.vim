" @filename  tidal.vim
" @created   230522 19:58:24  by  clem9nt@imac
" @updated   230522 19:58:24  by  clem9nt@imac
" @author    Clément Vidon

"   options


setlocal path+=$DOTVIM/ftplugin/

let g:tidal_no_mappings=1

let maplocalleader="gh"


"   mappings


nn <silent><buffer> <LocalLeader> <nop>

nm <silent><buffer> <LocalLeader>c <Plug>TidalConfig
xm <silent><buffer> <LocalLeader>e <Plug>TidalRegionSend
nm <silent><buffer> <LocalLeader>e <Plug>TidalParagraphSend
nm <silent><buffer> <LocalLeader>s <Plug>TidalLineSend
nn <silent><buffer> <LocalLeader>h :TidalHush<cr>
