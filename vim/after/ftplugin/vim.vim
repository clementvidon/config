augroup filetype_vim
    autocmd!
    " --------------------------------- HIGHLIGHTS {{{
    " }}}
    " --------------------------------- OPTIONS {{{
    au FileType vim setl foldmethod=marker
    au FileType vim setl foldmarker={{{,}}}
    au FileType vim setl textwidth=200
    au FileType vim setl pa+=$DOTVIM/after/ftplugin/
    " }}}
    " --------------------------------- PLUGINS {{{
    " }}}
    " --------------------------------- MAPPINGS {{{
    au Filetype vim nn <silent><buffer> gq Mmmgo=G`mzz3<C-O>
    " }}}
augroup END
