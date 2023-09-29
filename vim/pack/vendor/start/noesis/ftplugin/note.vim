" ftplugin/note
" Created: 230727 21:56:38 by clem@spectre
" Updated: 230727 21:56:38 by clem@spectre
" Maintainer: Clément Vidon

"   mappings


"   export as html TODO func
nn <silent><buffer> <LocalLeader>X :set term=xterm-256color<CR>:TOhtml<CR>
            \
            \:silent! %s/\.noesisItalic { .\{-} }$/.noesisItalic { color: #87AFFF; font-style: italic; }/g<CR>
            \:silent! %s/\.noesisBold { .\{-} }$/.noesisBold { color: #EBCB8B; font-weight: bold; }/g<CR>
            \:silent! %s/background-color: \#000000; }$/background-color: \#2e333f; }/g<CR>
            \/--><CR>Oa { color: #8787af; font-size: inherit; }<CR>
            \footer { font-style: italic; font-size: inherit; font-size: 0.8em; }<Esc>
            \:silent! g/\.noesis.\{-} { .\{-} }$/norm f}clfont-size: inherit; }<CR>
            \:silent! %s/\* { font-size: 1em; }$/\* { font-size: 1.1em; }/g<CR>
            \go/title<CR>o<meta name="author" content="Clement VIDON"><Esc>
            \o<meta name="copyright" content="&copy; Clément VIDON. All Rights Reserved."><Esc>
            \G?body<CR>o<footer><CR><a href="https://github.com/clemedon">
            \Contact:<!-- --cv-- --> cvidon<!-- c--v -->@student.<!-- cv -->42.fr - Copyright: &copy; Clément VIDON. All Rights Reserved.
            \</a><CR></footer>
            \<Esc>

"   index generator TODO func (or update existing)
nn <silent><buffer> <LocalLeader>I :silent
            \
            \ :let @a=''<CR>:keeppatterns g/^##/y A<CR>:let @a=''<CR>3Gpo#INDEX<CR>------<Esc>0k

"   index nav TODO func
nn <silent><buffer> <LocalLeader>i :keeppatterns /<C-R>=getline('.')<CR>$<CR>zt5<C-y>
