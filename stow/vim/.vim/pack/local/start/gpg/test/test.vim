" Headless security regression checks for the Vim GPG plugin.

set nomore
set noloadplugins

let s:root = $VIM_GPG_TEST_ROOT
let s:work = s:root . '/work'
let g:vim_gpg_recipient = $VIM_GPG_TEST_RECIPIENT
execute 'source ' . fnameescape($VIM_GPG_PLUGIN_ROOT . '/plugin/gpg.vim')

function! s:Path(name) abort
  return resolve(fnamemodify(a:name, ':p'))
endfunction

function! s:Encrypted(path) abort
  return filereadable(a:path)
        \ && get(readfile(a:path), 0, '') ==# '-----BEGIN PGP MESSAGE-----'
endfunction

function! s:Decrypt(path) abort
  return systemlist(shellescape($VIM_GPG_REAL_GPG)
        \ . ' --batch --quiet --decrypt ' . shellescape(a:path))
endfunction

function! s:DecryptRaw(path) abort
  return system(shellescape($VIM_GPG_REAL_GPG) . ' --batch --quiet --decrypt '
        \ . shellescape(a:path))
endfunction

function! s:Stages() abort
  return glob(s:work . '/.vim-gpg-*', 0, 1)
endfunction

function! s:AssertProtected() abort
  call assert_false(&l:swapfile)
  call assert_false(&l:undofile)
  call assert_false(&backup)
  call assert_false(&writebackup)
  call assert_equal('', &viminfo)
  call assert_true(get(b:, 'vim_gpg_managed_buffer', 0))
  call assert_true(get(b:, 'vim_sensitive_buffer', 0))
endfunction

function! s:AssertFails(command, pattern) abort
  let l:exception = ''
  try
    execute a:command
  catch
    let l:exception = v:exception
  endtry
  call assert_match(a:pattern, l:exception)
endfunction

let s:buf_pre = 0
let s:buf_post = 0
let s:file_pre = 0
let s:file_post = 0

function! s:CountBufPre() abort
  let s:buf_pre += 1
endfunction

function! s:CountBufPost() abort
  let s:buf_post += 1
endfunction

function! s:CountFilePre() abort
  let s:file_pre += 1
endfunction

function! s:CountFilePost() abort
  let s:file_post += 1
endfunction

function! s:FailPre() abort
  throw 'test write-pre failure'
endfunction

function! s:ChangeRangeMarks() abort
  normal! ggA-pre-hook
endfunction

function! s:SwitchWriteBuffer() abort
  execute 'buffer ' . s:hook_other_buffer
endfunction

function! s:CaptureEventFilename() abort
  let s:event_filename = expand('<afile>')
endfunction

function! s:AppendWholeBufferLine() abort
  call append(line('$'), 'added by BufWritePre')
endfunction

" Protection is installed from explicitly enabled persistence settings.
setlocal swapfile undofile
set backup writebackup viminfo='100
call assert_true(&l:swapfile)
call assert_true(&l:undofile)
call assert_true(&backup)
call assert_true(&writebackup)
call assert_notequal('', &viminfo)

" A normal encrypted read records the exact path represented by its hash.
let s:existing = s:work . '/existing.gpg.txt'
execute 'edit ' . fnameescape(s:existing)
call assert_equal(['alpha', 'beta'], getline(1, '$'))
call s:AssertProtected()
call assert_equal(s:Path(s:existing), b:gpg_disk_path)

" Whole-buffer hooks run once around a successful atomic replacement.
augroup vim_gpg_test_events
  autocmd!
  autocmd BufWritePre * call s:CountBufPre()
  autocmd BufWritePost * call s:CountBufPost()
augroup END
call setline(1, ['alpha', 'beta', 'gamma'])
write
call assert_equal(1, s:buf_pre)
call assert_equal(1, s:buf_post)
call assert_true(s:Encrypted(s:existing))
call assert_equal(['alpha', 'beta', 'gamma'], s:Decrypt(s:existing))
call assert_equal("alpha\nbeta\ngamma\n", s:DecryptRaw(s:existing))
call assert_equal('rw-r-----', getfperm(s:existing))
call assert_equal(s:Path(s:existing), b:gpg_disk_path)
call assert_equal([], s:Stages())

" A failing whole-buffer Pre hook aborts before encryption and suppresses Post.
let s:before = readfile(s:existing, 'b')
call setline(1, ['must', 'not', 'land'])
let s:buf_pre = 0
let s:buf_post = 0
augroup vim_gpg_test_events
  autocmd!
  autocmd BufWritePre * call s:FailPre()
  autocmd BufWritePost * call s:CountBufPost()
augroup END
call s:AssertFails('write', 'test write-pre failure')
call assert_equal(s:before, readfile(s:existing, 'b'))
call assert_equal(0, s:buf_post)
call assert_equal([], s:Stages())
edit!

" FileWrite hooks have the same semantics for partial encrypted writes.
let s:partial = s:work . '/partial.gpg.txt'
let s:file_pre = 0
let s:file_post = 0
augroup vim_gpg_test_events
  autocmd!
  autocmd FileWritePre * call s:CountFilePre()
  autocmd FileWritePost * call s:CountFilePost()
augroup END
execute '1write ' . fnameescape(s:partial)
call assert_equal(1, s:file_pre)
call assert_equal(1, s:file_post)
call assert_equal(['alpha'], s:Decrypt(s:partial))
let s:partial_before = readfile(s:partial, 'b')
let s:file_post = 0
augroup vim_gpg_test_events
  autocmd!
  autocmd FileWritePre * call s:FailPre()
  autocmd FileWritePost * call s:CountFilePost()
augroup END
call s:AssertFails('execute "1write! " . fnameescape(s:partial)',
      \ 'test write-pre failure')
call assert_equal(s:partial_before, readfile(s:partial, 'b'))
call assert_equal(0, s:file_post)
call assert_equal([], s:Stages())
augroup vim_gpg_test_events
  autocmd!
augroup END

" FileWritePre cannot redirect a captured range by changing '[ and '] marks.
let s:range_target = s:work . '/range-hooks.gpg.txt'
augroup vim_gpg_test_events
  autocmd!
  autocmd FileWritePre * call s:ChangeRangeMarks()
augroup END
execute '2,3write ' . fnameescape(s:range_target)
call assert_equal(['beta', 'gamma'], s:Decrypt(s:range_target))
call assert_equal('alpha-pre-hook', getline(1))
execute 'edit! ' . fnameescape(s:existing)

" Whole-buffer writes include lines legitimately added by BufWritePre.
augroup vim_gpg_test_events
  autocmd!
  autocmd BufWritePre * call s:AppendWholeBufferLine()
augroup END
write
call assert_equal(['alpha', 'beta', 'gamma', 'added by BufWritePre'],
      \ s:Decrypt(s:existing))
execute 'edit! ' . fnameescape(s:existing)

" A Pre hook may change buffers, but the source buffer remains the write input.
set hidden
let s:hook_source_buffer = bufnr('')
call setline(1, ['source buffer', 'secret'])
call deletebufline('%', 3, '$')
enew!
let s:hook_other_buffer = bufnr('')
call setline(1, 'other buffer')
execute 'buffer ' . s:hook_source_buffer
augroup vim_gpg_test_events
  autocmd!
  autocmd BufWritePre * call s:SwitchWriteBuffer()
augroup END
write
call assert_equal(s:hook_source_buffer, bufnr(''))
call assert_equal(['source buffer', 'secret'], s:Decrypt(s:existing))

" Manually emitted hooks receive the exact filename, including spaces and %.
let s:event_filename = ''
let s:event_target = s:work . '/event name%literal.gpg.txt'
augroup vim_gpg_test_events
  autocmd!
  autocmd FileWritePre * call s:CaptureEventFilename()
augroup END
execute '1write ' . fnameescape(s:event_target)
call assert_equal(s:event_target, s:event_filename)
call assert_equal(['source buffer'], s:Decrypt(s:event_target))
augroup vim_gpg_test_events
  autocmd!
augroup END

" Opening a new encrypted name installs protection before plaintext is entered.
let s:new = s:work . '/brand-new.gpg.noe'
execute 'edit! ' . fnameescape(s:new)
call s:AssertProtected()
call assert_equal(s:Path(s:new), b:gpg_disk_path)
call assert_equal('', b:gpg_disk_hash)
call setline(1, ['new', 'secret'])
write
call assert_true(s:Encrypted(s:new))
call assert_equal('rw-------', getfperm(s:new))
call assert_equal(['new', 'secret'], s:Decrypt(s:new))
call assert_equal(s:Path(s:new), b:gpg_disk_path)

" Naming an empty buffer protects it before the first plaintext insertion.
enew!
setlocal swapfile undofile
let s:named = s:work . '/named-after-enew.gpg.noe'
execute 'file ' . fnameescape(s:named)
call s:AssertProtected()
call assert_equal(s:Path(s:named), b:gpg_disk_path)
call assert_equal('', b:gpg_disk_hash)
call assert_false(get(b:, 'gpg_read_failed', 1))
call setline(1, ['named', 'secret'])
write
call assert_equal(['named', 'secret'], s:Decrypt(s:named))
execute 'edit! ' . fnameescape(s:new)

" Alternate encrypted writes do not replace the current file's remembered path.
let s:alternate = s:work . '/alternate.gpg.noe'
execute 'write ' . fnameescape(s:alternate)
call assert_true(s:Encrypted(s:alternate))
call assert_equal(['new', 'secret'], s:Decrypt(s:alternate))
call assert_equal(s:Path(s:new), b:gpg_disk_path)

" Save-as to plaintext is rejected before any plaintext reaches disk.
let s:saveas_plain = s:work . '/saveas-escaped.txt'
call s:AssertFails('execute "saveas! " . fnameescape(s:saveas_plain)',
      \ 'vim-gpg: refusing to write decrypted text')
call assert_false(filereadable(s:saveas_plain))

" Save-as cannot compare the old path's hash against the new current path.
let s:renamed = s:work . '/renamed.gpg.noe'
execute 'saveas! ' . fnameescape(s:renamed)
call assert_true(s:Encrypted(s:renamed))
call assert_equal(['new', 'secret'], s:Decrypt(s:renamed))
call assert_equal(s:Path(s:renamed), b:gpg_disk_path)
call setline(1, ['renamed', 'secret'])
write
call assert_true(s:Encrypted(s:renamed))
call assert_equal(['renamed', 'secret'], s:Decrypt(s:renamed))
call assert_equal(s:Path(s:renamed), b:gpg_disk_path)

" A change to an alternate path does not poison the current path fingerprint.
execute 'edit! ' . fnameescape(s:existing)
let s:other = s:work . '/other.gpg.txt'
execute 'write ' . fnameescape(s:other)
call writefile(['changed alternate'], s:other)
call setline(1, ['same path remains valid'])
call deletebufline('%', 2, '$')
write
call assert_equal(['same path remains valid'], s:Decrypt(s:existing))

" External modification of the remembered path is still rejected.
call writefile(['external replacement'], s:existing)
call setline(1, ['must not overwrite external data'])
call s:AssertFails('write', 'vim-gpg: destination changed on disk')
call assert_equal(['external replacement'], readfile(s:existing))
call assert_equal([], s:Stages())

" Native writes and filters cannot leak plaintext from a managed buffer.
execute 'edit! ' . fnameescape(s:new)
let s:plain = s:work . '/escaped.txt'
call s:AssertFails('execute "write " . fnameescape(s:plain)',
      \ 'vim-gpg: refusing to write decrypted text')
call assert_false(filereadable(s:plain))
let s:filtered = s:work . '/filtered.txt'
call s:AssertFails('execute "write !cat >" . shellescape(s:filtered)',
      \ 'vim-gpg: refusing to write decrypted text')
call assert_false(filereadable(s:filtered))
call s:AssertFails('execute "write >> " . fnameescape(s:alternate)',
      \ 'vim-gpg: appending encrypted files is not supported')

" Existing destinations that cannot be read cannot be replaced safely.
let s:unreadable = s:work . '/unreadable.gpg.txt'
call writefile(['unreadable destination'], s:unreadable)
call setfperm(s:unreadable, '---------')
if !filereadable(s:unreadable)
  call s:AssertFails('execute "write! " . fnameescape(s:unreadable)',
        \ 'vim-gpg: cannot fingerprint existing destination')
endif
call setfperm(s:unreadable, 'rw-------')
call assert_equal(['unreadable destination'], readfile(s:unreadable))

" GPG failures and invalid output leave the original destination untouched.
let s:before = readfile(s:new, 'b')
call setline(1, ['failed encryption'])
let $VIM_GPG_TEST_FAIL = '1'
call s:AssertFails('write', 'vim-gpg: gpg failed')
let $VIM_GPG_TEST_FAIL = '0'
call assert_equal(s:before, readfile(s:new, 'b'))
call assert_equal([], s:Stages())
let $VIM_GPG_TEST_INVALID = '1'
call s:AssertFails('write', 'vim-gpg: invalid encrypted output')
let $VIM_GPG_TEST_INVALID = '0'
call assert_equal(s:before, readfile(s:new, 'b'))
call assert_equal([], s:Stages())

" Failed initial decryption prevents any overwrite of the invalid input.
let s:invalid_path = s:work . '/invalid.gpg.txt'
execute 'silent! edit! ' . fnameescape(s:invalid_path)
call assert_true(get(b:, 'gpg_read_failed', 0))
let s:invalid = readfile(s:invalid_path, 'b')
execute 'read ' . fnameescape(s:new)
call assert_true(index(getline(1, '$'), 'new') >= 0)
call assert_true(index(getline(1, '$'), 'secret') >= 0)
call assert_true(get(b:, 'gpg_read_failed', 0))
call s:AssertFails('write!',
      \ 'vim-gpg: refusing to overwrite a file that could not be decrypted')
call assert_equal(s:invalid, readfile(s:invalid_path, 'b'))

" A ciphertext replacement during decrypt never becomes the buffer fingerprint.
let s:race = s:work . '/race.gpg.txt'
let $VIM_GPG_TEST_SWAP_SOURCE = s:work . '/race-replacement.gpg.txt'
let $VIM_GPG_TEST_SWAP_TARGET = s:race
let $VIM_GPG_TEST_SWAP_ON_DECRYPT = '1'
let s:race_read = execute('edit! ' . fnameescape(s:race))
let $VIM_GPG_TEST_SWAP_ON_DECRYPT = '0'
call assert_true(get(b:, 'gpg_read_failed', 0))
call assert_false(exists('b:gpg_disk_path'))
call assert_false(exists('b:gpg_disk_hash'))
call assert_match('encrypted file changed during decryption; reload and retry',
      \ s:race_read)
call assert_equal(['race version B'], s:Decrypt(s:race))
let s:race_before = readfile(s:race, 'b')
call setline(1, 'must not replace version B')
call s:AssertFails('write!',
      \ 'vim-gpg: refusing to overwrite a file that could not be decrypted')
call assert_equal(s:race_before, readfile(s:race, 'b'))
execute 'edit! ' . fnameescape(s:race)
call assert_equal(['race version B'], getline(1, '$'))
call assert_false(get(b:, 'gpg_read_failed', 1))

" Retargeting the current file's symlink cannot redirect a later write.
let s:file_link = s:work . '/file-link.gpg.txt'
let s:link_a = s:work . '/symlink-a.gpg.txt'
let s:link_b = s:work . '/symlink-b.gpg.txt'
execute 'edit! ' . fnameescape(s:file_link)
call assert_equal(['alpha', 'beta'], getline(1, '$'))
call assert_equal(simplify(s:file_link), b:gpg_disk_name)
call assert_equal(s:Path(s:link_a), b:gpg_disk_path)
let s:link_a_before = readfile(s:link_a, 'b')
let s:link_b_before = readfile(s:link_b, 'b')
call delete(s:file_link)
call system('ln -s ' . shellescape(fnamemodify(s:link_b, ':t'))
      \ . ' ' . shellescape(s:file_link))
call assert_equal(0, v:shell_error)
call setline(1, ['must not reach retargeted file'])
call s:AssertFails('write', 'vim-gpg: destination identity changed')
call s:AssertFails('write!', 'vim-gpg: destination identity changed')
call assert_equal(s:link_a_before, readfile(s:link_a, 'b'))
call assert_equal(s:link_b_before, readfile(s:link_b, 'b'))

" The same identity check covers a retargeted parent-directory symlink.
let s:parent_link = s:work . '/parent-link'
let s:parent_file = s:parent_link . '/parent.gpg.txt'
let s:parent_a = s:work . '/parent-a/parent.gpg.txt'
let s:parent_b = s:work . '/parent-b/parent.gpg.txt'
execute 'edit! ' . fnameescape(s:parent_file)
call assert_equal(['alpha', 'beta'], getline(1, '$'))
let s:parent_a_before = readfile(s:parent_a, 'b')
let s:parent_b_before = readfile(s:parent_b, 'b')
call system('unlink ' . shellescape(s:parent_link))
call assert_equal(0, v:shell_error)
call system('ln -s parent-b ' . shellescape(s:parent_link))
call assert_equal(0, v:shell_error)
call setline(1, ['must not reach retargeted directory'])
call s:AssertFails('write', 'vim-gpg: destination identity changed')
call s:AssertFails('write!', 'vim-gpg: destination identity changed')
call assert_equal(s:parent_a_before, readfile(s:parent_a, 'b'))
call assert_equal(s:parent_b_before, readfile(s:parent_b, 'b'))
call assert_equal([], s:Stages())

" Manual transforms protect plaintext state without claiming managed storage.
let s:manual = s:work . '/manual.txt'
call writefile(['manual secret'], s:manual)
execute 'edit! ' . fnameescape(s:manual)
setlocal swapfile undofile
set backup writebackup viminfo='100
normal! gg0v$
call feedkeys('glga', 'xt')
call assert_true(get(b:, 'vim_sensitive_buffer', 0))
call assert_false(get(b:, 'vim_gpg_managed_buffer', 0))
call assert_false(&l:swapfile)
call assert_false(&l:undofile)
call assert_false(&backup)
call assert_false(&writebackup)
call assert_equal('', &viminfo)
write
call assert_true(s:Encrypted(s:manual))
call assert_equal(['manual secret'], s:Decrypt(s:manual))

" Resourcing configuration cannot weaken an already-sensitive session.
execute 'edit! ' . fnameescape(s:new)
setlocal swapfile undofile
set backup writebackup viminfo='100
call writefile(['let g:vim_gpg_resourced = 1'], s:root . '/resourced.vim')
execute 'source ' . fnameescape(s:root . '/resourced.vim')
call s:AssertProtected()

" Low-compressibility data exercises substantial traffic in both pipe directions.
let s:large_path = s:work . '/large.gpg.txt'
execute 'edit! ' . fnameescape(s:large_path)
let s:large = map(range(0, 8191),
      \ 'printf("%08d:%s", v:val, sha256("vim-gpg-large-" . v:val))')
call setline(1, s:large)
write
call assert_true(getfsize(s:large_path) > 200 * 1024)
call assert_equal(s:large, s:Decrypt(s:large_path))
call assert_equal([], s:Stages())

if !empty(v:errors)
  call writefile(v:errors, '/dev/stderr')
  cquit
endif
quitall!
