" Netrw tree actions that keep the editing pane and selected path in sync.

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
  let g:netrw_chgwin = win_id2win(l:target)
  call win_execute(l:target, 'edit ' . fnameescape(l:path))
endfunction

function! vim_config#netrw#delete(islocal) abort
  if !a:islocal || get(w:, 'netrw_liststyle', 0) != 3
    execute "normal \<Del>"
    return
  endif

  " Netrw's D mapping captures the last expanded directory, not this tree row.
  call netrw#Call('NetrwLocalRm', s:SelectedDirectory())
endfunction
