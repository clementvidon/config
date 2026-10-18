" Expose ALE's Terraform documentation and native Vim omni completion.

setlocal omnifunc=ale#completion#OmniFunc
nnoremap <buffer> <silent> K :ALEHover<CR>

let b:undo_ftplugin = get(b:, 'undo_ftplugin', '')
      \ . (!empty(get(b:, 'undo_ftplugin', '')) ? '|' : '')
      \ . 'setlocal omnifunc<'
      \ . ' | silent! nunmap <buffer> K'
