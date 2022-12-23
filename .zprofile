# @file     .zprofile
# @brief    Zsh profile.
# @author   clemedon (Clément Vidon)

## General
##########

export PATH=$PATH:"$HOME/.local/bin"
export PATH=$PATH:"$HOME/.local/script"

export MEMO=$HOME/git/Memo
export DOTVIM=$HOME/.config/vim

[ -r "$HOME/.zoffline" ] && source $HOME/.zoffline
[ -r $HOME/.zshrc ] && source $HOME/.zshrc

## Home
#######

if [[ "$LOGNAME" = "clem"* ]]; then
    export GPG_TTY=$(tty)
    export GPG_KEY=Clem9nt
    export GNUPGHOME=$HOME/.gnupg
    export PATH=$HOME/.npm/bin:$PATH
    export PATH=$PATH:"$HOME/node_modules/.bin"
    if [[ "$OSTYPE" == "darwin"* ]]; then
        export MallocNanoZone=0
    fi
fi

## 42
#####

if [[ "$LOGNAME" = "cvidon" ]]
then
    export PATH=$PATH:"$HOME/.linuxbrew/bin"
    export PATH=$PATH:"/mnt/nfs/homes/cvidon/.linuxbrew/sbin"
    export PATH="/sgoinfre/goinfre/Perso/cvidon/.poetry/bin:$PATH"
    export PATH=$HOME/.npm/bin:$PATH
    export PATH=$PATH:"$HOME/node_modules/.bin"
fi

## i3
#####

if [[ "$OSTYPE" == "linux"* ]] && [[ ! $DISPLAY && $XDG_VTNR -eq 1 ]]
then
    startx
fi

export PATH=$PATH:"$HOME/processing"

export GOROOT=/usr/local/go
export GOPATH=$HOME/go
export PATH=$PATH:$GOROOT/bin
