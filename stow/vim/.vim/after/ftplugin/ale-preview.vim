" Keep hover documentation readable in a bottom preview split.

if &l:filetype !=# 'ale-preview.message'
  finish
endif

setlocal wrap linebreak conceallevel=2 concealcursor=nvic
wincmd J

let b:undo_ftplugin = get(b:, 'undo_ftplugin', '')
      \ . (!empty(get(b:, 'undo_ftplugin', '')) ? '|' : '')
      \ . 'setlocal wrap< linebreak< conceallevel< concealcursor<'
