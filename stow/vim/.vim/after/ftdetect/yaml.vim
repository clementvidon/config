" Refine YAML filetypes from explicit Ansible paths or Kubernetes manifest keys.

autocmd BufRead,BufNewFile *.yml,*.yaml
      \ if &l:filetype ==# 'yaml'
      \ && (expand('<afile>:p') =~# '/\%(playbooks\|group_vars\|host_vars\)/'
      \     || expand('<afile>:p') =~# '/roles/[^/]\+/\%(tasks\|handlers\|defaults\|vars\|meta\)/'
      \     || expand('<afile>:t') =~# '^playbook\.ya\?ml$')
      \ | setlocal filetype=yaml.ansible | endif

autocmd BufRead *.yml,*.yaml
      \ if &l:filetype ==# 'yaml'
      \ && match(getline(1, 100), '^apiVersion:\s*\S') >= 0
      \ && match(getline(1, 100), '^kind:\s*\S') >= 0
      \ | setlocal filetype=yaml.kubernetes | endif
