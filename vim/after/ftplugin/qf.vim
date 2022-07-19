augroup filetype_qf
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
