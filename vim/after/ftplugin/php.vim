augroup FILETYPE_PHP
    autocmd!
    " --------------------------------- HIGHLIGHTS {{{
    " }}}
    " --------------------------------- OPTIONS {{{
    au FileType php let &l:formatprg="~/vendor/bin/phpcbf --standard=PSR12 -"
    au FileType php let g:php_folding=2             " folding level max
    au FileType php setl foldmethod=syntax
    au FileType php setl path+=**                   " find any project file
    au FileType php setl pa+=$DOTVIM/after/ftplugin/
    au FileType php setl suffixesadd+=.php          " gf to filename even without.ext
    " }}}
    " --------------------------------- PLUGINS {{{
    "   ALE
    au FileType php let g:ale_linters = {'phpcs': ['php']}
    "   PHP DOCUMENTOR
    let g:pdv_cfg_Package = 'App'
    let g:pdv_cfg_ClassTags = ['package']
    au FileType php nn \d :call PhpDoc()<CR>?/\*\*<CR>jee:let @/ = ""<CR>
    au FileType php vn \d :call PhpDocRange()<CR>?/\*\*<CR>jee:let @/ = ""<CR>
    "   PHP NAMESPACE
    let g:php_namespace_sort_after_insert = 1
    " Auto-import the class or function under the cursor with a 'use' statement.
    au FileType php nn \u :call PhpInsertUse()<CR>
    " Expands the name under cursor to its fully qualified name.
    au FileType php nn \e :call PhpExpandClass()<CR>
    "   VIM SURROUND
    au FileType php let b:surround_45 = "<?php \r ?>" " yss-
    " }}}
    " --------------------------------- MAPPINGS {{{
    "   RUN
    au FileType php nn <buffer> <Space>5 :w!<CR>:!/usr/bin/php %<CR>
    "   TAGS GEN
    au FileType php nn <buffer> <Space><Space>t :Silent !ctags -R --PHP-kinds=cfi<CR>
    "   VARDUMP
    au FileType php nn <buffer> <Space><Space>v oecho '<pre>';<CR>var_dump();<CR>echo '</pre>';<CR>exit;<Esc>2k$ba
    "   FT SWITCH php<->html
    au FileType php nn <buffer> <Space><Space>ft :call Tgfiletype("php","html")<CR>
    "   BEAUTIFY html indent then php indent and fix
    au FileType php nn <buffer> <Space><Space>gq mm:set ft=html<CR>gg=G`m:set ft=php<CR>mmgggqG`m:silent write\|echo "html indented, php indented and fixed --"<CR>
    " }}}
augroup END
