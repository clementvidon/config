augroup FILETYPE_MARKDOWN
    autocmd!
    " --------------------------------- HIGHLIGHTS {{{
    " }}}
    " --------------------------------- OPTIONS {{{
    au FileType markdown let &l:formatprg="prettier --stdin-filepath %"
    au FileType markdown setl pa+=$DOTVIM/after/ftplugin/
    " }}}
    " --------------------------------- PLUGINS {{{
    " }}}
    " --------------------------------- MAPPINGS {{{
    " }}}
augroup END

