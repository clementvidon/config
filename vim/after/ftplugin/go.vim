augroup filetype_go
    autocmd!
    " --------------------------------- MAPPINGS >>>
    "   RUN
    au Filetype go nn <Space>5 :!clear && go run main.go<CR>
    " <<<
augroup END
