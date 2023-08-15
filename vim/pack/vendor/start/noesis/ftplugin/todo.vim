" ftplugin/todo
" Created: 230727 21:56:39 by clem@spectre
" Updated: 230806 11:19:56 by clem@spectre
" Maintainer: Clément Vidon

"   options


let g:todo_schedule_option = "home"


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


iabbr <silent><buffer> mma maingoal:
iabbr <silent><buffer> ssi sidework:
iabbr <silent><buffer> wwo work_env:
iabbr <silent><buffer> wwou work_env: update
iabbr <silent><buffer> wwouc work_env: update config
iabbr <silent><buffer> wwouca work_env: update config achiever
iabbr <silent><buffer> wwoucn work_env: update config noesis
iabbr <silent><buffer> wwoucv work_env: update config vim
iabbr <silent><buffer> lli life_env:
iabbr <silent><buffer> sse self_rel:
iabbr <silent><buffer> ssec self_rel: chill
iabbr <silent><buffer> sso soc_rela:
iabbr <silent><buffer> ffa fam_rela:
