" plugin/achiever
" Created: 210101 01:01:01 by clem@spectre
" Updated: 241013 16:24:19 by clem@spectre
" Maintainer: Clément Vidon (clemedon)
" Description: The most efficient and simple to-do framework for Vim users.
" Version: 1.0

if exists('g:loaded_achiever')
    finish
endif
let g:loaded_achiever = 1

" Set default achiever local leader
if !exists('g:achiever_localleader')
    let g:achiever_localleader = 'gh'
endif

" Set default achiever filenames
if !exists('g:achiever_filenames')
    let g:achiever_filenames = [ 'achiever', '.achiever_history' ]
endif

" Set default achiever details' prefix
if !exists('g:achiever_task_detail_prefix')
    let g:achiever_task_detail_prefix = '--'
endif

" Set default achiever mappings
if !exists('g:achiever_mappings')
    let g:achiever_mappings = {
                \ 'k': 'achiever#task_check()',
                \ 'c': 'achiever#task_clear()',
                \ 'F': 'achiever#task_fix("time_end")',
                \ 'f': 'achiever#task_fix("time_beg")',
                \ 't': 'achiever#task_duration(getline("."))',
                \ 'x': 'achiever#task_detail_toggle_view("' . g:achiever_task_detail_prefix . '")',
                \ }
endif

augroup achiever_settings
    autocmd!
    let s:achiever_filenames = join(map(g:achiever_filenames, 'fnameescape(v:val)'), ',')
    execute 'autocmd BufRead,BufNewFile ' . s:achiever_filenames . ' call s:AchieverInit()'
augroup END

function! s:AchieverInit() abort
    try

        " Import settings
        if !exists('b:achiever_localleader')
            let b:achiever_localleader = get(g:, 'achiever_localleader')
        endif
        if !exists('b:achiever_task_detail_prefix')
            let b:achiever_task_detail_prefix = get(g:, 'achiever_task_detail_prefix')
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
        setlocal spellcapcheck=

        " Set mappings
        nnoremap <silent><buffer> <LocalLeader> <Nop>
        for [key, cmd] in items(b:achiever_mappings)
            execute 'nnoremap <silent><buffer> <LocalLeader>' . key . ' :call ' . cmd . '<CR>'
        endfor
        execute 'nnoremap <silent><buffer> o o<Esc>:call achiever#task_detail_add_prefix("' . b:achiever_task_detail_prefix . '")<CR>A'
        execute 'inoremap <silent><buffer> <CR> <CR><Esc>:call achiever#task_detail_add_prefix("' . b:achiever_task_detail_prefix . '")<CR>A'

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

    " Append 'achiever' to the existing filetype TODO

    " let s:current_ft = &l:filetype
    " if s:current_ft == ''
    "     setlocal filetype=achiever
    " elseif s:current_ft !~# '\<achiever\>'
    "     let s:new_ft = s:current_ft . '.achiever'
    "     execute 'setlocal filetype=' . s:new_ft
    " endif

    " Or without the use of a filetype ? TODO

    syn match achieverTaskNamespaceSign /\(\s\a\a\a\a:\s\)\@<=\(@\)/                                " TODO
    syn match achieverTaskNamespace /\(\s\a\a\a\a:\s@\)\@<=[a-zA-Z0-9/_.\-~]\{-}\(\ze\s\|$\)/       " TODO
    syn match achieverTaskTimestamp /\(\s\)\zs\(\d\d\d\d\d\d\s\d\d:\d\d\)\ze\(\s\)/                 " ' <000000 00:00> '
    syn match achieverTaskTimestamp /\(\s\d\d\d\d\d\d\s\d\d:\d\d\s\)\@<=\(\d\d:\d\d\)\ze\(\s\)/     " ' 000000 00:00 <00:00> '
    syn match achieverTaskPrefixMain /\(\smain:\s\)/                                                " ' <main:> '
    syn match achieverTaskPrefixSide /\(\sside:\s\)/                                                " ' <side:> '
    syn match achieverTaskPrefixLife /\(\slife:\s\)/                                                " ' <life:> '
    syn match achieverTaskDetail /\(^-.*\s\a\a\a\a:\s.*\)\@<=\(\s--\s.*$\)/                         " ' main: foobar <-- bar>'
    syn match achieverTaskDetail /\(^\s\s--\s.*$\)\ze/                                                " '  line above is a task'

    if &background ==# 'dark'
        highlight default achieverTaskNamespaceSign     ctermfg=105
        highlight default achieverTaskNamespace         ctermfg=141

        highlight default achieverTaskTimestamp         ctermfg=103
        highlight default achieverTaskPrefixMain        ctermfg=211
        highlight default achieverTaskPrefixSide        ctermfg=175
        highlight default achieverTaskPrefixLife        ctermfg=139
        highlight default achieverTaskDetail            ctermfg=146
    elseif &background ==# 'light'
        " highlight default achieverTaskNamespaceSign     ctermfg=TODO
        " highlight default achieverTaskNamespace         ctermfg=TODO
        highlight default achieverTaskTimestamp         ctermfg=103
        highlight default achieverTaskPrefixMain        ctermfg=205
        highlight default achieverTaskPrefixSide        ctermfg=170
        highlight default achieverTaskPrefixLife        ctermfg=134
        highlight default achieverTaskDetail            ctermfg=146
    endif
endfunction
