augroup FILETYPE_JSON
    autocmd!
    " --------------------------------- HIGHLIGHTS {{{
    " }}}
    " --------------------------------- OPTIONS {{{
    au FileType json let &l:formatprg="prettier --stdin-filepath %"
    au FileType json setl pa+=$DOTVIM/after/ftplugin/
    " }}}
    " --------------------------------- PLUGINS {{{
    "   ALE
    au FileType json let g:ale_linters = {'json': ['jsonlint']}
    " }}}
    " --------------------------------- MAPPINGS {{{
    " }}}
augroup END
