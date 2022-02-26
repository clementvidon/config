augroup FILETYPE_QF
    autocmd!
    " --------------------------------- HIGHLIGHTS {{{
    " }}}
    " --------------------------------- OPTIONS {{{
    au FileType qf setl pa+=$DOTVIM/after/ftplugin/
    " }}}
    " --------------------------------- PLUGINS {{{
    " }}}
    " --------------------------------- MAPPINGS {{{
    au FileType qf wincmd J
    " }}}
augroup END
