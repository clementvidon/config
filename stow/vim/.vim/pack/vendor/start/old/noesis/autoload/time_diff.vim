" autoload/time_diff
" Created: 230806 10:16:14 by clem@spectre
" Updated: 230806 10:16:14 by clem@spectre
" Maintainer: Clément Vidon

"   @Brief   Print the time difference between time1 and time2 in minutes. Sum
"            up the results to 's:total_difference_seconds' and print the sum at
"            each use.
"
"   @Usage   Run ':call ExtractTimeRangeFromLine(getline('.'))' with the cursor
"            on a line that comprise a time in this format: 'HH:MM HH:MM', like:
"            'I am a valid10:58 03:09input.'

let s:total_difference_seconds = 0

function! FormatSeconds(seconds) abort
    let hours = a:seconds / 3600
    let minutes = (a:seconds % 3600) / 60
    return printf('%02d:%02d', hours, minutes)
endfunction

function! time_diff#(line)
    let line = getline('.')
    let time_pair = matchstr(a:line, '\d\d:\d\d\s\d\d:\d\d')
    if (empty(time_pair))
        if s:total_difference_seconds != 0
            echo "s:total_difference_seconds = " . FormatSeconds(s:total_difference_seconds)
            let choice = input("No time range found. Reset total difference? y/n ")
            if tolower(choice) == 'y'
                let s:total_difference_seconds = 0
            endif
        else
            echo "No time range found in the line."
        endif
        return
    endif
    let [time1, time2] = split(time_pair)
    let timestamp1 = strptime('%H:%M', time1)
    let timestamp2 = strptime('%H:%M', time2)
    if timestamp1 > timestamp2
        let timestamp2 += 24 * 60 * 60
    endif
    let time_difference_seconds = timestamp2 - timestamp1
    let s:total_difference_seconds += time_difference_seconds

    let formatted_time_difference = FormatSeconds(time_difference_seconds)
    let formatted_total_difference = FormatSeconds(s:total_difference_seconds)

    echo "This duration: " . formatted_time_difference
    echo "All durations: " . formatted_total_difference
endfunction

nn <Space>g :call ExtractTimeRangeFromLine(getline('.'))<CR>
