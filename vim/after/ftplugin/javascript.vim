augroup FILETYPE_JAVASCRIPT
    autocmd!
    " --------------------------------- HIGHLIGHTS {{{
    " }}}
    " --------------------------------- OPTIONS {{{
    au FileType qf setl wrap
    au FileType javascript setl noexpandtab cindent tw=80
    au FileType javascript let &l:formatprg="prettier --stdin-filepath %"
    au FileType javascript setl pa+=$DOTVIM/after/ftplugin/
    " }}}
    " --------------------------------- PLUGINS {{{
    "   ALE
    au FileType javascript let g:ale_linters = {'javascript': ['eslint']}
    " }}}
    " --------------------------------- MAPPINGS {{{
    "   COMPILE & RUN % & C-Z
    au FileType javascript nn <buffer> <Space>5 :w\|lc %:h<CR>:!clear; node %<CR>

    "   CLEANUP
    au Filetype javascript nn <buffer> <Space>= Mmmgo=G:silent! :%s/\s\+$//e<CR>`mzz3<C-O>
    " --------------------------------- ABBREV {{{
    "   CONSOLE.LOG
    au Filetype javascript inorea <buffer> con console.log();<esc>F(
    " }}}
augroup END
