augroup FILETYPE_HTML
    autocmd!
    " --------------------------------- HIGHLIGHTS {{{
    au FileType html hi MatchParen ctermbg=darkgrey guibg=darkgrey
    " }}}
    " --------------------------------- OPTIONS {{{
    au FileType html setl shiftwidth=2 tabstop=2
    au FileType html let &l:formatprg="tidy -q -w -i --show-warnings 0 --show-errors 0 --tidy-mark no"
    au FileType html setl pa+=$DOTVIM/after/ftplugin/
    " }}}
    " --------------------------------- PLUGINS {{{
    "   ALE
    au FileType html let g:ale_linters = {'html': ['tidy']}
    " }}}
    " --------------------------------- MAPPINGS {{{
    "   CLEANUP
    au Filetype html nn <buffer> <Space>= Mmmgo=G:silent! :%s/\s\+$//e<CR>`mzz3<C-O>
    "   FORMAT
    au Filetype html nn <buffer> gqq mmGgqgo`m
    " }}}
augroup END
