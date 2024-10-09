" plugin/achiever
" Created: 230524 20:45:19 by clem9nt@imac
" Updated: 241008 16:36:57 by clem@spectre
" Maintainer: Clément Vidon

if exists('g:loaded_achiever')
    finish
endif
let g:loaded_achiever = 1

" Set default achiever local leader
if !exists('g:achiever_localleader')
    let g:achiever_localleader = 'gh'
endif

" Set default achiever file name
if !exists('g:achiever_filename')
    let g:achiever_filename = 'achiever'
endif

" Set default achiever mappings
if !exists('g:achiever_mappings')
    let g:achiever_mappings = {
                \ 'k': 'achiever#task_check()',
                \ 'c': 'achiever#task_clear()',
                \ 'F': 'achiever#task_fix("time_end")',
                \ 'f': 'achiever#task_fix("time_beg")',
                \ 't': 'achiever#task_duration(getline("."))',
                \ }
endif

augroup achiever_settings
    autocmd!
    execute 'autocmd BufRead,BufNewFile ' . g:achiever_filename . ' call s:AchieverInit()'
augroup END

function! s:AchieverInit() abort
    try

        " Import settings
        if !exists('b:achiever_localleader')
            let b:achiever_localleader = get(g:, 'achiever_localleader')
        endif
        if !exists('b:achiever_mappings')
            let b:achiever_mappings = get(g:, 'achiever_mappings')
        endif

        " Set local leader
        let g:maplocalleader = b:achiever_localleader

        " Set indentation
        setlocal textwidth=0
        setlocal expandtab
        setlocal shiftwidth=2
        setlocal softtabstop=2
        setlocal tabstop=2

        " Set mappings
        nnoremap <silent><buffer> <LocalLeader> <Nop>
        for [key, cmd] in items(b:achiever_mappings)
            execute 'nnoremap <silent><buffer> <LocalLeader>' . key . ' :call ' . cmd . '<CR>'
        endfor

        " Abbreviations
        iabbrev <silent><buffer> mma - main:
        iabbrev <silent><buffer> ssi - side:
        iabbrev <silent><buffer> lli - life:

        " Set syntax after filetype syntax has been loaded
        augroup achiever_syntax
            autocmd!
            autocmd Syntax <buffer> call s:AchieverSyntax()
        augroup END

    catch /Vim\%((\a\+)\)\=:E\(\d\+\):/
        echoerr 'Achiever Plugin Error: ' . v:exception
    endtry
endfunction

function! s:AchieverSyntax() abort

    syn match achieverTaskTimestamp /\(\s\)\zs\(\d\d\d\d\d\d\s\d\d:\d\d\)\ze\(\s\)/               " ' <000000 00:00> '
    syn match achieverTaskTimestamp /\(\s\d\d\d\d\d\d\s\d\d:\d\d\s\)\@<=\(\d\d:\d\d\)\ze\(\s\)/   " ' 000000 00:00 <00:00> '
    syn match achieverTaskPrefixWork /\(^-.*\)\@<=\(\smain:\s\)/                                  " ' <main:> '
    syn match achieverTaskPrefixSide /\(^-.*\)\@<=\(\sside:\s\)/                                  " ' <side:> '
    syn match achieverTaskPrefixLife /\(^-.*\)\@<=\(\slife:\s\)/                                  " ' <life:> '
    syn match achieverTaskEstimate /\(\s\(main\|side\|life\):\s\)\@<=\(\d\d\d\d\|\/\/\/\/\)\s/    " ' main: <0000> '
    syn match achieverTaskDetail /\(^-.*\s\a\a\a\a:\s.*\)\@<=\(\s--\s.*$\)/                       " ' main: foobar <-- bar>'
    syn match achieverTaskDetail /\(^-.*\s\a\a\a\a:\s.*$\n\)\@<=\(\(\s\s--\s.*$\n\)\{1,10}\)\ze/  " '  line above is a task'

    if &background ==# 'dark'
        highlight achieverTaskTimestamp      ctermfg=103
        highlight achieverTaskPrefixWork     ctermfg=211
        highlight achieverTaskPrefixSide     ctermfg=175
        highlight achieverTaskPrefixLife     ctermfg=139
        highlight achieverTaskEstimate       ctermfg=103
        highlight achieverTaskDetail         ctermfg=146
    elseif &background ==# 'dark'
        highlight achieverTaskTimestamp      ctermfg=103
        highlight achieverTaskPrefixWork     ctermfg=205
        highlight achieverTaskPrefixSide     ctermfg=170
        highlight achieverTaskPrefixLife     ctermfg=134
        highlight achieverTaskEstimate       ctermfg=103
        highlight achieverTaskDetail         ctermfg=146
    endif
endfunction
