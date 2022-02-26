augroup FILETYPE_HTML
    autocmd!
    " --------------------------------- HIGHLIGHTS {{{
    au FileType html hi MatchParen ctermbg=darkgrey guibg=darkgrey
    " }}}
    " --------------------------------- OPTIONS {{{
    au FileType html let &l:formatprg="tidy -q -w -i --show-warnings 0 --show-errors 0 --tidy-mark no"
    au FileType html setl pa+=$DOTVIM/after/ftplugin/
    " }}}
    " --------------------------------- PLUGINS {{{
    "   ALE
    au FileType html let g:ale_linters = {'html': ['tidy']}
    " }}}
    " --------------------------------- MAPPINGS {{{
    " }}}
augroup END
