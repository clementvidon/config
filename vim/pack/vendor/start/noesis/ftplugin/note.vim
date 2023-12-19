" ftplugin/note
" Created: 230727 21:56:38 by clem@spectre
" Updated: 231018 13:33:43 by clem@spectre
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

"   index generator TODO func
nn <silent><buffer> <LocalLeader>I :let @a=''<CR>zR
            \
            \:silent! keeppatterns g/^\nINDEX\n=*\n->>>/norm V}}jd<CR>
            \:silent! keeppatterns g/^\(-\\|=\)\{40,80}/-1y A<CR>
            \3G"apo<CR>INDEX<CR><Esc>80i=<Esc>o<Esc>0O->>><Esc>}}o<<<-<Esc>kk
            \:let @a=""<CR>
            \vip>gv:g/[a-z][a-z]\C/norm >><CR>
            \:let @/=""<CR>
            \zMzo


"   index nav TODO func
nn <silent><buffer> <LocalLeader>i :let @a=trim(getline('.'))<CR>
            \
            \:silent! keeppatterns /^\s\{0,4}<C-R>a$<CR>
            \zt5<C-y>
            \:let @a=''<CR>
            " \zOzt5<C-y>
