" autoload/count_occurrances
" Created: 231113 20:27:27 by clem@spectre
" Updated: 231113 20:27:27 by clem@spectre
" Maintainer: Clément Vidon

" :call count_occurrences#()

function! s:printOccurrences(occurrences)
    let sorted_list = sort(keys(a:occurrences)) " TODO sort
    for word in sorted_list
        call append(line('$'), a:occurrences[word] . ' ' . word)
    endfor
endfunction

function! s:countWord(occurrences, word)
    if has_key(a:occurrences, a:word)
        let a:occurrences[a:word] += 1
    else
        let a:occurrences[a:word] = 1
    endif
    return ''
endfunction

function! count_occurrences#()
    let occurrences = {}

    " Loop through each strings
    " let pattern = '\v<([^ ]+)>'
    let pattern = '@\v<([^ ]+)>'
    execute '%s/' . pattern . '/\=s:countWord(occurrences, submatch(1))/gn'

    call s:printOccurrences(occurrences)
endfunction
