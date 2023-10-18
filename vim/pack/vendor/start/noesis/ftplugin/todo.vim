" ftplugin/todo
" Created: 230727 21:56:39 by clem@spectre
" Updated: 230806 11:19:56 by clem@spectre
" Maintainer: Clément Vidon

"   options


let g:todo_schedule_option = "temp"


"   mappings


nn <silent><buffer> <LocalLeader>k :call task_check#()<CR>:write<CR>0
nn <silent><buffer> <LocalLeader>F :call task_fix#("up")<CR>
nn <silent><buffer> <LocalLeader>f :call task_fix#("down")<CR>
nn <buffer><silent> <LocalLeader>t :call time_diff#(getline('.'))<CR>
nn <buffer><silent> <LocalLeader>A :call archive_day#(g:todo_schedule_option)<CR>
            \
            \:sil cd $NOESIS/<CR>
            \:sil !git add -f INDEX.noe Lists Areas Projects Resources Archives<CR>
            \:sil !git commit -m "Archive"<CR>:redraw!<CR>

"   task un-parenthesis
nn <silent><buffer> <LocalLeader>K <Esc>
            \
            \:call setline('.', substitute(getline('.'), '\s\{0,1}[-~] \zs( \ze.', '', 'e'))<CR>
            \:call setline('.', substitute(getline('.'), '\s\{0,1}[-~] \d\d:\d\d\zs )\ze.', '', 'e'))<CR>
            \:call setline('.', substitute(getline('.'), '\s\{0,1}[-~] \d\d:\d\d \d\d:\d\d\zs )\ze.', '', 'e'))<CR>
            \:call setline('.', substitute(getline('.'), '\s\{0,1}[-~]\zs \ze.', ' ' . strftime('%y%m%d') . ' ', ''))<CR>
            \:write<CR>0

"   task clear
nn <silent><buffer> <LocalLeader>c <Esc>
            \
            \:call setline('.', substitute(getline('.'), '\s\{0,1}[-~]\zs \d\d\d\d\d\d \d\d:\d\d \d\d:\d\d\ze.', '', 'e'))<CR>
            \:call setline('.', substitute(getline('.'), '\s\{0,1}[-~]\zs \d\d\d\d\d\d \d\d:\d\d\ze.', '', 'e'))<CR>
            \:call setline('.', substitute(getline('.'), '\s\{0,1}[-~]\zs \d\d:\d\d\ze', '', 'g'))<CR>
            \:call setline('.', substitute(getline('.'), '\s\{0,1}[-~]\zs \d\d:\d\d\ze', '', 'e'))<CR>
            \:call setline('.', substitute(getline('.'), '\s\{0,1}[-~]\zs \d\d\d\d\d\d\ze.', '', 'e'))<CR>
            \:write<CR>0


"   abbreviations


iabbr <silent><buffer> aac achiever<Left><Esc>
iabbr <silent><buffer> mma maingoal<Left><Esc>
iabbr <silent><buffer> ssi sidework<Left><Esc>
iabbr <silent><buffer> vvi virt_env<Left><Esc>
iabbr <silent><buffer> pph phys_env<Left><Esc>
iabbr <silent><buffer> sse self_rel<Left><Esc>
iabbr <silent><buffer> sso soc_rela<Left><Esc>
iabbr <silent><buffer> ffa fam_rela<Left><Esc>
iabbr <silent><buffer> iaac achiever:
iabbr <silent><buffer> imma maingoal:
iabbr <silent><buffer> issi sidework:
iabbr <silent><buffer> ivvi virt_env:
iabbr <silent><buffer> ipph phys_env:
iabbr <silent><buffer> isse self_rel:
iabbr <silent><buffer> isso soc_rela:
iabbr <silent><buffer> iffa fam_rela:
