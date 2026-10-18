" Preview files from Netrw while keeping focus in the tree.

let s:usage_file = expand('<sfile>:p:h:h:h') . '/usage/netrw.txt'

function! s:SelectedDirectory() abort
  if get(w:, 'netrw_liststyle', 0) != 3
    return b:netrw_curdir
  endif
  let l:path = netrw#Call('NetrwTreePath', w:netrw_treetop)
  if getline('.') =~# '/$'
    " Directory rows resolve to the selected directory itself.
    return fnamemodify(substitute(l:path, '/$', '', ''), ':h')
  endif
  return l:path
endfunction

function! vim_config#netrw#open_without_jump(islocal) abort
  if !a:islocal
    let l:tree = win_getid()
    try
      execute "normal \<CR>"
    finally
      call win_gotoid(l:tree)
    endtry
    return
  endif

  let l:path = netrw#fs#ComposePath(s:SelectedDirectory(),
        \ netrw#Call('NetrwGetWord'))
  if isdirectory(l:path)
    call netrw#LocalBrowseCheck(netrw#Call('NetrwBrowseChgDir', 1,
          \ netrw#Call('NetrwGetWord'), 1))
    return
  endif

  let l:tree = win_getid()
  let l:target = win_getid(get(g:, 'netrw_chgwin', -1))
  if l:target == 0 || l:target == l:tree
    let l:target = 0
    for l:window in getwininfo()
      if l:window.tabnr == tabpagenr() && l:window.winid != l:tree
            \ && getbufvar(l:window.bufnr, '&filetype') !=# 'netrw'
        let l:target = l:window.winid
        break
      endif
    endfor
  endif
  if l:target == 0
    rightbelow vnew
    let l:target = win_getid()
    call win_gotoid(l:tree)
  endif
  call win_execute(l:target, 'edit ' . fnameescape(l:path))
endfunction

function! vim_config#netrw#show_usage(...) abort
  if !filereadable(s:usage_file)
    echoerr 'Netrw usage file is unavailable'
    return
  endif

  call vim_config#popup#show(readfile(s:usage_file))
endfunction
