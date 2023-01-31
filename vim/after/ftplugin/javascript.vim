augroup filetype_javascript
    autocmd!
    " --------------------------------- HIGHLIGHTS >>>
    " <<<
    " --------------------------------- OPTIONS >>>
    au FileType qf setl wrap
    au FileType javascript setl expandtab tabstop=2 shiftwidth=2 textwidth=80
    au FileType javascript setl softtabstop=2 autoindent
    au FileType javascript setl formatprg=prettier\ --stdin-filepath\ %
    " <<<
    " --------------------------------- PLUGINS >>>
    "   ALE
    au FileType javascript let g:ale_linters = {'javascript': ['eslint']}
    " <<<
    " --------------------------------- MAPPINGS >>>
    "   RUN FILE
    au FileType javascript nn <buffer> ghr :w\|lc %:h<CR>:!clear; node %<CR>

    "   CLEANUP
    au Filetype javascript nn <buffer> <Space>= Mmmgo=G:silent! :%s/\s\+$//e<CR>`mzz3<C-O>

    "   Format
    au Filetype javascript nn <silent><buffer> ghf :call FormatCurrentFile()<CR>

    "   PRINT
    au Filetype javascript nn <silent><buffer> ghpr oconsole.log()<Esc>==f)i

    "   PRINT WRAP
    au Filetype javascript nn <silent><buffer> ghpw 0<<V:norm f;Di<Esc>Iconsole.log(<Esc>A);<Esc>==f)h

    "   PRINT EXPR VALUE
    au FileType javascript nn <buffer> ghpv :lc %:h<CR>
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
    " <<<
augroup END
