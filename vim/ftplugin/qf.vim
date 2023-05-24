" Quickfix
" Created: 230524 16:33:25  by clem9nt@imac
" Updated: 230524 16:33:25  by clem9nt@imac
" Maintainer: Clément Vidon

"   options


setlocal wrap
setlocal path+=$DOTVIM/ftplugin/


"   auto commands


" quickfix cd to project root
augroup changeQfCmdDirectory
    autocmd!
    autocmd QuickFixCmdPre make execute "lc " . fnamemodify(findfile('Makefile', '.;'), ":h")
augroup END
