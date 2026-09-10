" GPG-backed encrypted buffers and plaintext persistence protection.

"   bootstrap

if exists('g:loaded_personal_gpg')
  finish
endif
let g:loaded_personal_gpg = 1
let s:save_cpoptions = &cpoptions
set cpoptions&vim

"   sensitive-session protection

function! s:ProtectSensitive() abort
  let g:vim_sensitive_session = 1
  let b:vim_sensitive_buffer = 1
  setlocal noswapfile noundofile
  set nobackup nowritebackup viminfo=
  if exists('#User#VimGPGSensitive')
    doautocmd <nomodeline> User VimGPGSensitive
  endif
endfunction

function! s:ProtectManaged() abort
  call s:ProtectSensitive()
  let b:vim_gpg_managed_buffer = 1
endfunction

function! s:GuardWrite(filename) abort
  if !get(b:, 'vim_gpg_managed_buffer', 0)
    return
  endif
  let l:name = fnamemodify(a:filename, ':t')
  if l:name !~# '\.gpg\..\+$'
    throw 'vim-gpg: refusing to write decrypted text to an unencrypted file'
  endif
endfunction

function! s:Reprotect() abort
  if get(g:, 'vim_sensitive_session', 0)
    set nobackup nowritebackup viminfo=
  endif
  if get(b:, 'vim_sensitive_buffer', 0)
    setlocal noswapfile noundofile
  endif
endfunction

function! s:PrepareRead(whole) abort
  if a:whole
    call s:ProtectManaged()
    let b:gpg_read_failed = 1
    unlet! b:gpg_disk_name b:gpg_disk_path b:gpg_disk_hash
  else
    call s:ProtectSensitive()
  endif
endfunction

"   GPG process I/O

function! s:Recipient() abort
  let l:recipient = get(g:, 'vim_gpg_recipient', '')
  if empty(l:recipient)
    throw 'vim-gpg: set g:vim_gpg_recipient before encrypting'
  endif
  return l:recipient
endfunction

function! s:Run(arguments, lines) abort
  if !executable('gpg') || !has('job') || !has('channel')
    throw 'vim-gpg: gpg and Vim job/channel support are required'
  endif
  " A memory-only snapshot feeds the pipe asynchronously. Sending a large
  " string synchronously can deadlock when GPG fills its output pipe.
  let l:input = bufadd('')
  call bufload(l:input)
  call setbufvar(l:input, '&buftype', 'nofile')
  call setbufvar(l:input, '&swapfile', 0)
  call setbufvar(l:input, '&undofile', 0)
  let l:output = ''
  try
    call setbufline(l:input, 1, empty(a:lines) ? [''] : a:lines)
    " Drain stdin even when GPG rejects the request immediately, so Vim has
    " no pending writes to a closed pipe. Arguments remain separate from code.
    let l:job = job_start(['/bin/sh', '-c',
          \ 'gpg "$@"; gpg_status=$?; cat >/dev/null; exit "$gpg_status"', 'vim-gpg'] + a:arguments,
          \ {'in_io': 'buffer', 'in_buf': l:input, 'noblock': 1,
          \ 'out_mode': 'raw', 'err_io': 'null'})
    if job_status(l:job) ==# 'fail'
      throw 'vim-gpg: could not start gpg'
    endif
    let l:channel = job_getchannel(l:job)
    while ch_status(l:channel, {'part': 'out'}) !=# 'closed'
      let l:output .= ch_readraw(l:channel, {'timeout': 100})
    endwhile
    while job_status(l:job) ==# 'run'
      sleep 10m
    endwhile
    if job_info(l:job).exitval != 0
      throw 'vim-gpg: gpg failed; buffer and destination left unchanged'
    endif
  finally
    if exists('l:job') && job_status(l:job) ==# 'run'
      call job_stop(l:job)
    endif
    if exists('l:channel') && ch_status(l:channel) !=# 'closed'
      call ch_close(l:channel)
    endif
    execute 'silent! bwipeout! ' . l:input
  endtry
  return split(substitute(l:output, '\n$', '', ''), "\n", 1)
endfunction

"   buffer replacement and disk fingerprinting

function! s:Replace(first, last, lines) abort
  let l:view = winsaveview()
  let l:lines = empty(a:lines) ? [''] : a:lines
  " Replace a range without overwriting the following lines.
  call setline(a:first, l:lines[0])
  if a:last > a:first
    silent! undojoin
    call deletebufline('%', a:first + 1, a:last)
  endif
  if len(l:lines) > 1
    silent! undojoin
    call append(a:first, l:lines[1:])
  endif
  call winrestview(l:view)
endfunction

function! s:Fingerprint(filename) abort
  if filereadable(a:filename)
    return sha256(join(readfile(a:filename, 'b'), "\n"))
  endif
  if !empty(getftype(a:filename))
    throw 'vim-gpg: cannot fingerprint existing destination'
  endif
  return ''
endfunction

function! s:BufferFingerprint(first, last) abort
  let l:separator = &l:fileformat ==# 'dos' ? "\r\n"
        \ : &l:fileformat ==# 'mac' ? "\r" : "\n"
  let l:contents = join(getline(a:first, a:last), l:separator)
  if a:last == line('$') && &l:endofline
    let l:contents .= l:separator
  endif
  return sha256(l:contents)
endfunction

function! s:CanonicalPath(filename) abort
  return resolve(fnamemodify(a:filename, ':p'))
endfunction

function! s:LogicalPath(filename) abort
  return simplify(fnamemodify(a:filename, ':p'))
endfunction

function! s:RememberDiskState(filename, ...) abort
  let b:gpg_disk_name = s:LogicalPath(a:filename)
  let b:gpg_disk_path = s:CanonicalPath(a:filename)
  let b:gpg_disk_hash = a:0 ? a:1 : s:Fingerprint(b:gpg_disk_path)
endfunction

function! s:ProtectNamedBuffer() abort
  if get(b:, 'vim_gpg_managed_buffer', 0)
    call s:ProtectSensitive()
    return
  endif
  call s:ProtectManaged()
  let b:gpg_read_failed = filereadable(expand('%:p'))
  if b:gpg_read_failed
    unlet! b:gpg_disk_name b:gpg_disk_path b:gpg_disk_hash
  else
    call s:RememberDiskState(expand('%:p'))
  endif
endfunction

"   read path

function! s:Read(first, last, whole) abort
  if a:whole
    call s:ProtectManaged()
  else
    call s:ProtectSensitive()
  endif
  try
    let l:ciphertext = getline(a:first, a:last)
    if a:whole
      let l:name = s:LogicalPath(expand('%:p'))
      let l:path = s:CanonicalPath(l:name)
      let l:cipher_hash = s:BufferFingerprint(a:first, a:last)
      if l:cipher_hash !=# s:Fingerprint(l:path)
        throw 'vim-gpg: encrypted file changed while reading; reload and retry'
      endif
    endif
    let l:cleartext = s:Run(['--decrypt'], l:ciphertext)
    if a:whole && l:cipher_hash !=# s:Fingerprint(l:path)
      throw 'vim-gpg: encrypted file changed during decryption; reload and retry'
    endif
  catch /^vim-gpg:/
    echohl ErrorMsg
    echomsg v:exception
    echohl None
    return
  endtry
  call s:Replace(a:first, a:last, l:cleartext)
  if a:whole
    let b:gpg_read_failed = 0
    call s:RememberDiskState(l:name, l:cipher_hash)
    setlocal nomodified
  endif
endfunction

"   write path

function! s:RestoreWriteContext(buffer, window) abort
  if !bufexists(a:buffer)
    throw 'vim-gpg: write buffer was deleted by an autocommand'
  endif
  if win_getid() != a:window && win_id2win(a:window)
    call win_gotoid(a:window)
  endif
  if bufnr('') != a:buffer
    execute 'silent noautocmd keepalt buffer ' . a:buffer
  endif
endfunction

function! s:EmitWriteEvent(event, filename) abort
  " Spaces and percent signs are literal to :doautocmd.  Escape only Ex
  " separators so <afile> remains the exact Unix filename seen by native hooks.
  execute 'silent doautocmd <nomodeline> ' . a:event . ' '
        \ . escape(a:filename, "|\n\r")
endfunction

function! s:Write(filename, whole) abort
  call s:ProtectSensitive()
  let l:source_buffer = bufnr('')
  let l:source_window = win_getid()
  let l:first = a:whole ? 1 : line("'[")
  let l:last = a:whole ? line('$') : line("']")
  if get(b:, 'gpg_read_failed', 0)
    throw 'vim-gpg: refusing to overwrite a file that could not be decrypted'
  endif
  let l:target_name = s:LogicalPath(a:filename)
  let l:current_name = s:LogicalPath(expand('%:p'))
  let l:target = s:CanonicalPath(l:target_name)
  let l:own_file = l:target_name ==# l:current_name
  if l:own_file
    let b:vim_gpg_managed_buffer = 1
    if get(b:, 'gpg_disk_name', '') ==# l:current_name
          \ && get(b:, 'gpg_disk_path', '') !=# l:target
      throw 'vim-gpg: destination identity changed; reload or save as another name'
    endif
  endif
  let l:disk_hash = s:Fingerprint(l:target)
  if !v:cmdbang && (&readonly || (filereadable(l:target) && !l:own_file))
    throw 'vim-gpg: destination is read-only or already exists; use :write! explicitly'
  endif
  let l:event = a:whole ? 'BufWrite' : 'FileWrite'
  try
    call s:EmitWriteEvent(l:event . 'Pre', a:filename)
  finally
    call s:RestoreWriteContext(l:source_buffer, l:source_window)
  endtry
  let l:lines = a:whole
        \ ? getbufline(l:source_buffer, 1, '$')
        \ : getbufline(l:source_buffer, l:first, l:last)
  let l:encrypted = s:Run(['--armor', '--encrypt', '--recipient', s:Recipient()], l:lines)
  if empty(l:encrypted) || l:encrypted[0] !=# '-----BEGIN PGP MESSAGE-----'
    throw 'vim-gpg: invalid encrypted output; destination left unchanged'
  endif
  " Stage ciphertext on the destination filesystem, then replace atomically.
  let l:stage = fnamemodify(l:target, ':h') . '/.vim-gpg-' . fnamemodify(tempname(), ':t')
  if !mkdir(l:stage, '', 0700)
    throw 'vim-gpg: could not create encrypted staging directory'
  endif
  try
    let l:temporary = l:stage . '/ciphertext'
    call writefile(l:encrypted, l:temporary)
    let l:permissions = filereadable(l:target) ? getfperm(l:target) : 'rw-------'
    if !setfperm(l:temporary, l:permissions)
      throw 'vim-gpg: could not preserve file permissions'
    endif
    if l:disk_hash !=# s:Fingerprint(l:target)
          \ || (get(b:, 'gpg_disk_path', '') ==# l:target
          \ && get(b:, 'gpg_disk_hash', '') !=# l:disk_hash)
      throw 'vim-gpg: destination changed on disk; reload before writing'
    endif
    if rename(l:temporary, l:target) != 0
      throw 'vim-gpg: could not replace destination'
    endif
  finally
    call delete(l:stage . '/ciphertext')
    call delete(l:stage, 'd')
  endtry
  if l:own_file && a:whole
    call s:RememberDiskState(l:target_name,
          \ sha256(join(l:encrypted, "\n") . "\n"))
    setlocal nomodified
    call s:UpdateTitle()
  endif
  try
    call s:EmitWriteEvent(l:event . 'Post', a:filename)
  finally
    call s:RestoreWriteContext(l:source_buffer, l:source_window)
  endtry
endfunction

"   window title

function! s:UpdateTitle() abort
  if !exists('b:gpg_saved_title')
    let b:gpg_saved_title = [&title, &titlestring]
  endif
  set title
  let l:time = getftime(expand('%'))
  let &titlestring = l:time < 0
        \ ? 'Not encrypted yet'
        \ : 'Last encryption: ' . strftime('%y%m%d %H:%M:%S', l:time)
endfunction

function! s:RestoreTitle() abort
  if exists('b:gpg_saved_title')
    let [&title, &titlestring] = b:gpg_saved_title
    unlet b:gpg_saved_title
  endif
endfunction

"   manual transforms

function! s:Transform(first, last, operation) abort
  call s:ProtectSensitive()
  let l:args = a:operation ==# 'decrypt' ? ['--decrypt']
        \ : a:operation ==# 'symmetric' ? ['--symmetric', '--armor']
        \ : ['--encrypt', '--armor', '--recipient', s:Recipient()]
  let l:result = s:Run(l:args, getline(a:first, a:last))
  call s:Replace(a:first, a:last, l:result)
endfunction

"   agent control

function! s:RestartAgent() abort
  if !executable('gpgconf')
    throw 'vim-gpg: gpgconf is not installed'
  endif
  call system('gpgconf --kill gpg-agent')
  if v:shell_error
    throw 'vim-gpg: could not restart gpg-agent'
  endif
endfunction

"   autocommands

augroup personal_gpg
  autocmd!
  autocmd BufReadPre *.gpg.* call s:PrepareRead(1)
  autocmd FileReadPre *.gpg.* call s:PrepareRead(0)
  autocmd BufNewFile *.gpg.* call s:ProtectManaged()
  autocmd BufNewFile *.gpg.* call s:RememberDiskState(expand('<afile>'))
  autocmd BufFilePost *.gpg.* call s:ProtectNamedBuffer()
  autocmd BufReadPost *.gpg.* call s:Read(1, line('$'), 1)
  autocmd FileReadPost *.gpg.* call s:Read(line("'["), line("']"), 0)
  autocmd BufWriteCmd *.gpg.* call s:Write(expand('<afile>'), 1)
  autocmd FileWriteCmd *.gpg.* call s:Write(expand('<afile>'), 0)
  autocmd FileAppendCmd *.gpg.* throw 'vim-gpg: appending encrypted files is not supported'
  autocmd BufWritePre,FileWritePre,FileAppendPre,FilterWritePre *
        \ call s:GuardWrite(expand('<afile>'))
  autocmd BufEnter *.gpg.* call s:UpdateTitle()
  autocmd BufLeave *.gpg.* call s:RestoreTitle()
  autocmd SourcePost * call s:Reprotect()
augroup END

"   mappings

nnoremap <silent> glgd :call <SID>Transform(1, line('$'), 'decrypt')<CR>
nnoremap <silent> glgr :call <SID>RestartAgent()<CR>
xnoremap <silent> glgs :<C-U>call <SID>Transform(line("'<"), line("'>"), 'symmetric')<CR>
xnoremap <silent> glga :<C-U>call <SID>Transform(line("'<"), line("'>"), 'encrypt')<CR>
xnoremap <silent> glgd :<C-U>call <SID>Transform(line("'<"), line("'>"), 'decrypt')<CR>

let &cpoptions = s:save_cpoptions
unlet s:save_cpoptions
