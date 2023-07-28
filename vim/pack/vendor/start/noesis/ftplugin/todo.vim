" ftplugin/todo
" Created: 230727 21:56:39 by clem@spectre
" Updated: 230727 21:56:39 by clem@spectre
" Maintainer: Clément Vidon

"   time diff
nn <buffer><silent> <Leader>m :call todo#TimeDiff()<CR>

"   archive day
nn <buffer><silent> <Leader>A :call todo#ArchiveDay()<CR>
            \:sil cd $NOESIS/<CR>
            \:sil !git add -f INDEX.md Lists Areas Projects Resources Archives<CR>
            \:sil !git commit -m "Archive"<CR>:redraw!<CR>

"   task new
nn <silent><buffer> <Leader>t O- tmp<Esc><<:call todo#TaskCheck()<CR>ftC

"   task check
nn <silent><buffer> <Leader>k :call todo#TaskCheck()<CR>:write<CR>0

"   task fix
nn <silent><buffer> <Leader>F :call todo#TaskFix("up")<CR>
nn <silent><buffer> <Leader>f :call todo#TaskFix("down")<CR>

"   task un-parenthesis
nn <silent><buffer> <Leader>K <Esc>
            \
            \:call setline('.', substitute(getline('.'), '\s\{0,1}[-~] \zs( \ze.', '', 'e'))<CR>
            \:call setline('.', substitute(getline('.'), '\s\{0,1}[-~] \d\d:\d\d\zs )\ze.', '', 'e'))<CR>
            \:call setline('.', substitute(getline('.'), '\s\{0,1}[-~] \d\d:\d\d \d\d:\d\d\zs )\ze.', '', 'e'))<CR>
            \:call setline('.', substitute(getline('.'), '\s\{0,1}[-~]\zs \ze.', ' ' . strftime('%y%m%d') . ' ', ''))<CR>
            \:write<CR>0

"   task now TODO update
nn <silent><buffer> <Leader>. :silent! ?^- \(\(.*\d\d\d\d\d\d.*\)\@!.\)*$<CR>z.:let @/=""<CR>

"   task clear
nn <silent><buffer> <Leader>c <Esc>
            \
            \:call setline('.', substitute(getline('.'), '\s\{0,1}[-~]\zs \d\d\d\d\d\d \d\d:\d\d \d\d:\d\d\ze.', '', 'e'))<CR>
            \:call setline('.', substitute(getline('.'), '\s\{0,1}[-~]\zs \d\d\d\d\d\d \d\d:\d\d\ze.', '', 'e'))<CR>
            \:call setline('.', substitute(getline('.'), '\s\{0,1}[-~]\zs \d\d:\d\d\ze', '', 'g'))<CR>
            \:call setline('.', substitute(getline('.'), '\s\{0,1}[-~]\zs \d\d:\d\d\ze', '', 'e'))<CR>
            \:call setline('.', substitute(getline('.'), '\s\{0,1}[-~]\zs \d\d\d\d\d\d\ze.', '', 'e'))<CR>
            \:write<CR>0

"   rot
nn <buffer><silent> <LocalLeader>r Mmm
            \
            \:keeppatterns g/^\s/norm g??<CR>
            \`mzz3<C-O>
