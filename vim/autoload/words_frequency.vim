" autoload/words_frequency
" Created: 231113 20:27:27 by clem@spectre
" Updated: 231114 13:18:31 by clem@spectre
" Maintainer: Clément Vidon

" :call words_frequency#()

function s:sort_result()
endfunction

function s:print_result(occurrences)
    let sorted_list = sort(keys(a:occurrences)) " TODO sort
    call append(line('$'), '')
    call append(line('$'), 'WORD FREQUENCY OUTPUT')
    call append(line('$'), '')
    for word in sorted_list
        call append(line('$'), a:occurrences[word] . ' ' . word)
    endfor
   execute search("WORDS FREQUENCY") . "+2,$sort! n"
endfunction

function s:count_occurrences(occurrences, word)
    if has_key(a:occurrences, a:word)
        let a:occurrences[a:word] += 1
    else
        let a:occurrences[a:word] = 1
    endif
    return ''
endfunction

function words_frequency#()
    let occurrences = {}

    let word_pattern = '\v<([^ ]+)>'
    execute '%s/' . word_pattern . '/\=s:count_occurrences(occurrences, submatch(1))/gn'

    call s:print_result(occurrences)
endfunction
