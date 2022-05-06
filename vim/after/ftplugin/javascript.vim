augroup FILETYPE_JAVASCRIPT
    autocmd!
    " --------------------------------- HIGHLIGHTS {{{
    " }}}
    " --------------------------------- OPTIONS {{{
    au FileType qf setl wrap
    au FileType javascript setl autoindent expandtab textwidth=80
    au FileType javascript setl shiftwidth=2 tabstop=2
    au FileType javascript let &l:formatprg="prettier --stdin-filepath %"
    au FileType javascript setl pa+=$DOTVIM/after/ftplugin/
    " }}}
    " --------------------------------- PLUGINS {{{
    "   ALE
    au FileType javascript let g:ale_linters = {'javascript': ['eslint']}
    " }}}
    " --------------------------------- MAPPINGS {{{
    "   RUN FILE
    au FileType javascript nn <buffer> <Space>5 :w\|lc %:h<CR>:!clear; node %<CR>

    "   PRINT EXPR VALUE
    au FileType javascript nn <buffer> <Space>3 :lc %:h<CR>
                \
                \:sil ec "Cleanup the line."<CR>
                \0f;C;<Esc>
                \:sil ec "Duplicate the line."<CR>
                \0lYp
                \:sil ec "Wrap the current line expression into a print."<CR>
                \0<<Iconsole.log(<Esc>$i)<Esc>:w<CR>
                \:sil ec "Print its value in a comment"<CR>
                \:undojoin \| r!node % 2>/dev/null<CR>`[V`]<C-V>0I//> <Esc>
                \:sil ec "Delete line"<CR>
                \kddkJ

    "   CLEANUP
    au Filetype javascript nn <buffer> <Space>= Mmmgo=G:silent! :%s/\s\+$//e<CR>`mzz3<C-O>

    "   PRINT
    au Filetype javascript nn <silent><buffer> <Space>p oconsole.log()<Esc>==f)i

    "   PRINT WRAP
    au Filetype javascript nn <silent><buffer> <Space>P 0<<V:norm f;Di<Esc>Iconsole.log(<Esc>A);<Esc>==f)h
    " }}}
augroup END
