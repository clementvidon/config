" Noesis workspace defaults, commands and public mapping API.

" # BOOTSTRAP AND ROOT

if exists('g:loaded_noesis')
  finish
endif
let g:loaded_noesis = 1

if !exists('g:noesis_root')
  let g:noesis_root = empty($NOESIS_ROOT)
        \ ? expand('~/noesis')
        \ : expand($NOESIS_ROOT)
endif

" # COMMANDS

" # MAPPING API

nnoremap <silent> <Plug>(noesis-export) :<C-U>call noesis#export_html()<CR>
nnoremap <silent> <Plug>(noesis-index) :<C-U>call noesis#index()<CR>
nnoremap <silent> <Plug>(noesis-index-jump) :<C-U>call noesis#index_jump()<CR>
nnoremap <silent> <Plug>(noesis-heading-1) :<C-U>call noesis#heading(1)<CR>
nnoremap <silent> <Plug>(noesis-heading-2) :<C-U>call noesis#underline()<CR>
nnoremap <silent> <Plug>(noesis-heading-3) :<C-U>call noesis#heading(3)<CR>
nnoremap <silent> <Plug>(noesis-heading-4) :<C-U>call noesis#heading(4)<CR>
nnoremap <silent> <Plug>(noesis-heading-5) :<C-U>call noesis#heading(5)<CR>
nnoremap <silent> <Plug>(noesis-heading-6) :<C-U>call noesis#heading(6)<CR>
nnoremap <silent> <Plug>(noesis-italic) :<C-U>call noesis#italic(0)<CR>
xnoremap <silent> <Plug>(noesis-italic) <Cmd>call noesis#italic(1)<CR>
nnoremap <silent> <Plug>(noesis-bold) :<C-U>call noesis#bold(0)<CR>
xnoremap <silent> <Plug>(noesis-bold) <Cmd>call noesis#bold(1)<CR>
nnoremap <silent> <Plug>(noesis-code) :<C-U>call noesis#code(0)<CR>
xnoremap <silent> <Plug>(noesis-code) <Cmd>call noesis#code(1)<CR>
nnoremap <silent> <Plug>(noesis-link) :<C-U>call noesis#link(0)<CR>
xnoremap <silent> <Plug>(noesis-link) <Cmd>call noesis#link(1)<CR>
nnoremap <silent> <Plug>(noesis-quote) :<C-U>call noesis#quote(0)<CR>
xnoremap <silent> <Plug>(noesis-quote) <Cmd>call noesis#quote(1)<CR>
