augroup FILETYPE_YML
    autocmd!
    " --------------------------------- HIGHLIGHTS {{{
    " }}}
    " --------------------------------- OPTIONS {{{
    au FileType yml let &l:formatprg="prettier --stdin-filepath %"
    au FileType yml setl pa+=$DOTVIM/after/ftplugin/
    " }}}
    " --------------------------------- PLUGINS {{{
    " }}}
    " --------------------------------- MAPPINGS {{{
    " }}}
augroup END
