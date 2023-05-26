" @filename  vim.vim
" @created   230522 20:00:37  by  clem9nt@imac
" @updated   230523 14:49:53  by  cvidon@e3r2p17.clusters.42paris.fr
" @author    Clément Vidon

"   options


setlocal textwidth=80
setlocal path+=$DOTVIM/autoload/**,
            \$DOTVIM/**,

let maplocalleader="gh"


"   mappings


nn <silent><buffer> <LocalLeader> <nop>

"   clear
nn <silent><buffer> <LocalLeader> Mmmgo=G`mzz3<C-O>

"   docstring skeletong
nn <silent><buffer> <LocalLeader>D mdj
            \
            \:keeppatterns ?function.*(.*)$<CR>
            \O<Esc>O"    @brief <Esc>==A
