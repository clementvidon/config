" vim/init
" Created: 230524 19:57:11 by clem9nt@imac
" Updated: 230802 15:42:37 by cvidon@paul-f5Br5s5.clusters.42paris.fr
" Maintainer: Clément Vidon

let $NOESIS=$HOME . "/git/noesis"
let $DOTVIM=$HOME . "/git/config/vim"

if empty(glob($DOTVIM . "/.undo/vim"))  | exec 'silent !mkdir -p $DOTVIM/.undo/vim'  | endif
if empty(glob($DOTVIM . "/.undo/nvim")) | exec 'silent !mkdir -p $DOTVIM/.undo/nvim' | endif
if empty(glob($DOTVIM . "/.spell")) | exec 'silent !mkdir $DOTVIM/.spell' | endif
if empty(glob($DOTVIM . "/.swap"))  | exec 'silent !mkdir $DOTVIM/.swap'  | endif

source $DOTVIM/init/option.vim
source $DOTVIM/init/autocmd.vim
source $DOTVIM/init/command.vim
source $DOTVIM/init/plugin.vim

" TODO DELETE


"   @brief  format a number of seconds to HH:MM string time format.

function! FormatSeconds(seconds) abort
    let hours = a:seconds / 3600
    let minutes = (a:seconds % 3600) / 60
    return printf('%02d:%02d', hours, minutes)
endfunction

" Brief:  Print the time difference between time1 and time2 in minutes.
"         time1 and time2 should be in the [HH:MM HH:MM] format.
"
" Example: I am a valid10:58 03:09line.

let g:total_difference_seconds = 0
function! ExtractTimeRangeFromLine(line)
    let line = getline('.')
    let time_pair = matchstr(a:line, '\d\d:\d\d\s\d\d:\d\d')
    if (empty(time_pair))
        if g:total_difference_seconds != 0
            echo "g:total_difference_seconds = " . FormatSeconds(g:total_difference_seconds)
            let choice = input("No time range found. Reset total difference? y/n ")
            if tolower(choice) == 'y'
                let g:total_difference_seconds = 0
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
    let g:total_difference_seconds += time_difference_seconds

    let formatted_time_difference = FormatSeconds(time_difference_seconds)
    let formatted_total_difference = FormatSeconds(g:total_difference_seconds)

    echo "This duration: " . formatted_time_difference
    echo "All durations: " . formatted_total_difference
endfunction
nn <Space>g :call ExtractTimeRangeFromLine(getline('.'))<CR>
