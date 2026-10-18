" Render ALE hover Markdown without changing its underlying documentation.

if &l:filetype !=# 'ale-preview.message'
  finish
endif

runtime! syntax/markdown.vim
syntax match markdownEscape /\\\ze[[:punct:]]/ conceal containedin=ALL
syntax match aleDocInlineTag +</\?\%(code\|em\|strong\|b\|i\)>+ conceal containedin=ALL
syntax region markdownCode matchgroup=markdownCodeDelimiter start=/`/ end=/`/ oneline concealends

let b:current_syntax = 'markdown'
