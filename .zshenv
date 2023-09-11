#  clem/.zshenv
#  Created: 230828 14:48:02 by clem@spectre
#  Updated: 230828 14:48:02 by clem@spectre
#  Maintainer: Clément Vidon

export PATH=$PATH:"$HOME/bin"
export PATH=$PATH:"$HOME/.local/bin"
export PATH=$PATH:"$HOME/.local/script"

[ -r $HOME/.zshrc ] && source $HOME/.zshrc

######################################## Home

if [[ "$LOGNAME" = "clem" ]]; then
    export GPG_TTY=$(tty)
    export GPG_KEY=Clem9nt
    export GNUPGHOME=$HOME/.gnupg
    export PATH=$HOME/.npm/bin:$PATH
    export PATH=$PATH:"$HOME/node_modules/.bin"
    if [[ "$OSTYPE" == "darwin"* ]]; then
        export MallocNanoZone=0
    fi
fi

######################################## Alacritty

export PATH=$PATH:"$HOME/.cargo/bin"

######################################## Password Store

if (( $+commands[pass] )); then
    export PASSWORD_STORE_CLIPBOARD=primary
    export PASSWORD_STORE_CLIP_TIME=5
    export PASSWORD_STORE_GENERATED_LENGTH=32
    export EDITOR="/bin/vim"
fi

######################################## i3-wm

if (( $+commands[i3] )); then
    if [[ ! $DISPLAY && $XDG_VTNR -eq 1 ]]; then
        export GDK_SCALE=2
        startx
    fi
    export GOROOT=/usr/local/go
    export GOPATH=$HOME/go
    export PATH=$PATH:$GOROOT/bin
fi

######################################## Internet Computer

if (( $+commands[dfx] )); then
    export PATH=$PATH:"$(dfx cache show)"
fi
