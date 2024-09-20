" autoload/colorswitch
" Created: 230524 19:34:19 by clem9nt@imac
" Updated: 230524 19:34:19 by clem9nt@imac
" Maintainer: Clément Vidon

function colorswitch#(clight, cdark)
    if system("uname -s") == "Darwin\n"
        if &bg == "dark"
            execute 'color seoul256-light | set bg=light'
        else
            execute 'color nord | set bg=dark'
        endif
        colors
    elseif system("uname -s") == "Linux\n"
        if &background ==# "dark"
            execute 'silent !sed -i --follow-symlinks "s/   color .*/   color ' . a:clight . ' | set bg=light/g" $DOTVIM/init/option.vim'
            execute 'silent set bg=light'
            execute 'colors ' . a:clight
            execute 'highlight Normal ctermbg=NONE'
            execute 'silent !cp ~/.config/alacritty/colors/' . a:clight .'.toml ~/.config/alacritty/colors.toml'
        elseif &background ==# "light"
            execute 'silent !sed -i --follow-symlinks "s/   color .*/   color ' . a:cdark . ' | set bg=dark/g" $DOTVIM/init/option.vim'
            execute 'silent set bg=dark'
            execute 'colors ' . a:cdark
            execute 'highlight Normal ctermbg=NONE'
            execute 'silent !cp ~/.config/alacritty/colors/'. a:cdark .'.toml ~/.config/alacritty/colors.toml'
        endif
    endif
endfunction
