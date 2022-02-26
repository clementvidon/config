if !empty(glob($DOTVIM . "/run.vim"))
    source $DOTVIM/run.vim
else
    echo "Missing file: run.vim"
endif
