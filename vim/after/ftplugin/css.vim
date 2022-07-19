augroup filetype_css
    autocmd!
    " --------------------------------- HIGHLIGHTS {{{
    " }}}
    " --------------------------------- OPTIONS {{{
    au FileType css let &l:formatprg="prettier --stdin-filepath %"
    au FileType css setl pa+=$DOTVIM/after/ftplugin/
    " }}}
    " --------------------------------- PLUGINS {{{
    "   ALE
    au FileType css let g:ale_linters = {'css': ['stylelint']}
    " }}}
    " --------------------------------- MAPPINGS {{{
    "   CLEANUP
    au Filetype css nn <buffer> <Space>= Mmmgo=G:silent! :%s/\s\+$//e<CR>`mzz3<C-O>
    "   FORMAT
    au Filetype css nn <buffer> gqq mmGgqgo`m
    " }}}
augroup END
