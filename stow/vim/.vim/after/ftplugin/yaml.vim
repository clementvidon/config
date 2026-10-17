" Use ansible-doc through Vim's keyword lookup in YAML files.

setlocal keywordprg=:AnsibleKeyword
setlocal omnifunc=ale#completion#OmniFunc
command! -buffer -nargs=1 AnsibleKeyword call vim_config#ansible#keyword(<q-args>)
nnoremap <buffer> <silent> gK :call vim_config#ansible#module_under_cursor()<CR>
command! -buffer AnsibleLSP let b:ale_disable_lsp = 0
      \ <bar> let b:ale_linter_aliases = 'ansible'
      \ <bar> let b:ale_linters = ['language_server'] <bar> ALELint

let b:undo_ftplugin = get(b:, 'undo_ftplugin', '')
      \ . (!empty(get(b:, 'undo_ftplugin', '')) ? '|' : '')
      \ . 'setlocal keywordprg< omnifunc< | delcommand AnsibleKeyword'
      \ . ' | delcommand AnsibleLSP'
      \ . ' | silent! nunmap <buffer> gK'
