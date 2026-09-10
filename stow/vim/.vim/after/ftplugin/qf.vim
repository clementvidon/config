" Wrap quickfix entries so long diagnostics remain readable in narrow terminals.

"   buffer configuration

setlocal wrap

"   undo

let b:undo_ftplugin = get(b:, 'undo_ftplugin', '')
      \ . (!empty(get(b:, 'undo_ftplugin', '')) ? '|' : '')
      \ . 'setlocal wrap<'
