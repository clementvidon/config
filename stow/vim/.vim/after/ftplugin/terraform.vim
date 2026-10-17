" Expose ALE's Terraform documentation and native Vim omni completion.

setlocal omnifunc=ale#completion#OmniFunc
nnoremap <buffer> <silent> K :ALEHover<CR>
command! -buffer TerraformLSP let b:ale_disable_lsp = 0 <bar> ALELint

let b:undo_ftplugin = get(b:, 'undo_ftplugin', '')
      \ . (!empty(get(b:, 'undo_ftplugin', '')) ? '|' : '')
      \ . 'setlocal omnifunc< | delcommand TerraformLSP'
      \ . ' | silent! nunmap <buffer> K'
