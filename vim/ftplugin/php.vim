" @filename  php.vim
" @created   230522 18:32:16  by  clem9nt@imac
" @updated   230522 18:32:16  by  clem9nt@imac
" @author    Clément Vidon

"   options


setlocal foldmethod=syntax
setlocal pa+=$DOTVIM/ftplugin/
setlocal path+=**
setlocal suffixesadd+=.php

let maplocalleader="gh"

"   php max fold level
let g:php_folding=2

"   php documentor
let g:pdv_cfg_Package = 'App'
let g:pdv_cfg_ClassTags = ['package']

"   php namespace
let g:php_namespace_sort_after_insert = 1

"   yss- surround
let b:surround_45 = "<?php \r ?>"


"   mappings


nn <silent><buffer> <LocalLeader> <nop>

"   php documentor
nn <silent><buffer> <LocalLeader>d :call PhpDoc()<CR>?/\*\*<CR>jee:let @/=""<CR>
vn <silent><buffer> <LocalLeader>d :call PhpDocRange()<CR>?/\*\*<CR>jee:let @/=""<CR>

"   php namespace
nn <silent><buffer> <LocalLeader>u :call PhpInsertUse()<CR>
nn <silent><buffer> <LocalLeader>e :call PhpExpandClass()<CR>

"   execute
nn <silent><buffer> <LocalLeader>x :w!<CR>:!/usr/bin/php %<CR>

"   tags
nn <silent><buffer> <LocalLeader>T :Silent !ctags -R --PHP-kinds=cfi<CR>

"   vardump
nn <silent><buffer> <LocalLeader>V oecho '<pre>';<CR>var_dump();<CR>echo '</pre>';<CR>exit;<Esc>2k$ba

"   format (html indent + php indent and fix)
nn <silent><buffer> <LocalLeader>f mm:set ft=html<CR>gg=G`m:set ft=php<CR>mmgggqG`m:silent write<CR>
