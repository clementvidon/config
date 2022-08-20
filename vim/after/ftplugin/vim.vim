augroup filetype_vim
    autocmd!
    " --------------------------------- HIGHLIGHTS >>>
    " <<<
    " --------------------------------- OPTIONS >>>
    au FileType vim setl foldmethod=marker
    au FileType vim setl foldmarker=>>>,<<<
    au FileType vim setl textwidth=80
    au FileType vim setl pa+=$DOTVIM/after/ftplugin/,$DOTVIM
    " <<<
    " --------------------------------- PLUGINS >>>
    " <<<
    " --------------------------------- MAPPINGS >>>
    au Filetype vim nn <silent><buffer> gq Mmmgo=G`mzz3<C-O>
    au Filetype vim nn <silent><buffer> <space>D mdj
                \
                \:keeppatterns ?function.*)$<CR>
                \O<Esc>O"    @brief <Esc>==A
    " <<<
augroup END
