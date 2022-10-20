augroup filetype_json
    autocmd!
    " --------------------------------- HIGHLIGHTS >>>
    " <<<
    " --------------------------------- OPTIONS >>>
    au FileType json let &l:formatprg="prettier --stdin-filepath %"
    au FileType json setl pa+=$DOTVIM/after/ftplugin/
    " <<<
    " --------------------------------- PLUGINS >>>
    "   ALE
    au FileType json let g:ale_linters = {'json': ['jsonlint']}
    " <<<
    " --------------------------------- MAPPINGS >>>
	au Filetype json nn <silent><buffer> <Space>F :%!jq '.'<CR>
    " <<<
augroup END
