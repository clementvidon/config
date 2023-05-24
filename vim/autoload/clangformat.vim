" autoload/clangformat
" Created: 230524 19:34:16 by clem9nt@imac
" Updated: 230524 19:34:16 by clem9nt@imac
" Maintainer: Clément Vidon

function clangformat#()
    if executable('clang-format')
        let save_cursor = getpos(".")
        let save_view = winsaveview()
        set modifiable
        let buffer_content = getline(1, '$')
        let formatted_content = system('clang-format', buffer_content)
        let formatted_lines = split(formatted_content, "\n")
        let num_extra_lines = line('$') - len(formatted_lines)
        if num_extra_lines > 0
            let extra_lines = repeat([''], num_extra_lines)
            let formatted_lines += extra_lines
        endif
        call setline(1, formatted_lines)
        keeppatterns %s/\s\+$//e " trailing spaces
        keeppatterns v/\_s*\S/d  " trailing lines
        set nomodified
        call winrestview(save_view)
        call setpos('.', save_cursor)
    endif
endfunction
