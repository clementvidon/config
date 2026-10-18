" Keep the personal buffer-indent shortcut out of Noesis notes.

nnoremap <silent><buffer> <Space>= <Nop>
xnoremap <silent><buffer> <Space>= <Nop>

let b:undo_ftplugin = get(b:, 'undo_ftplugin', '')
      \ . (!empty(get(b:, 'undo_ftplugin', '')) ? '|' : '')
      \ . 'silent! nunmap <buffer> <Space>=|silent! xunmap <buffer> <Space>='
