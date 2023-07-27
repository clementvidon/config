" ftplugin/note
" Created: 230727 21:56:38 by clem@spectre
" Updated: 230727 21:56:38 by clem@spectre
" Maintainer: Clément Vidon

"   mappings


"   export as html TODO func
nn <silent><buffer> <LocalLeader>X :set term=xterm-256color<CR>:TOhtml<CR>
            \
            \/--><CR>Oa { color: hotpink; }<Esc>go
            \:%s/background-color: \#000000; }$/background-color: \#2e333f; }/g<CR>
            \:%s/\* { font-size: 1em; }$/\* { font-size: 1.1em; }/g<CR>
            \:%s/\.noesisH1 { color: #5fffaf; }$/.noesisH1 { color: #5fffaf; font-size: 120%; }/g<CR>
            \:%s/\.noesisUrl { color: #ff5faf; text-decoration: underline; }$/.noesisUrl { color: #ff5faf; text-decoration: underline; font-size: 90%; }/g<CR>
            \go/<span class="noesisBlockquote">&gt; </span><CR>cc<span class="noesisBlockquote">&gt; </span> cvidon@student.42.fr<Esc>go
            \:fix}}<Esc>

"   index generator TODO func (or update existing)
nn <silent><buffer> <LocalLeader>I :silent
            \
            \ :let @a=''<CR>:keeppatterns g/^##/y A<CR>3Gpo#INDEX<CR>------<Esc>0k

"   index nav TODO func
nn <silent><buffer> <LocalLeader>i :keeppatterns /<C-R>=getline('.')<CR>$<CR>zt5<C-y>
