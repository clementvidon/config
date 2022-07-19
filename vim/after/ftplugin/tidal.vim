augroup filetype_tidal
    autocmd!
    " --------------------------------- HIGHLIGHTS {{{
    " }}}
    " --------------------------------- OPTIONS {{{
    au Filetype tidal let maplocalleader="\\"
    au Filetype tidal let g:tidal_no_mappings = 1
    au FileType tidal setl pa+=$DOTVIM/after/ftplugin/
    " }}}
    " --------------------------------- PLUGINS {{{
    " }}}
    " --------------------------------- MAPPINGS {{{
    au Filetype tidal nm <buffer> <Space>c <Plug>TidalConfig
    au Filetype tidal xm <buffer> <Space>e <Plug>TidalRegionSend
    au Filetype tidal nm <buffer> <Space>e <Plug>TidalParagraphSend
    au Filetype tidal nm <buffer> <Space>s <Plug>TidalLineSend
    au Filetype tidal nn <buffer> <Space>h :TidalHush<cr>
    " }}}
augroup END

