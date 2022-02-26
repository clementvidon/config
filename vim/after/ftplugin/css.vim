augroup FILETYPE_CSS
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
    " }}}
augroup END
