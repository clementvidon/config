#  ~/.zshenv
#  Maintainer: Clément Vidon

export PATH=$PATH:"$HOME/.local/bin"
export PATH=$PATH:"$HOME/.local/script"

######################################## Go

export GOROOT=/usr/local/go
export GOPATH=$HOME/go
export PATH=$PATH:$GOROOT/bin:$GOPATH/bin

######################################## GnuPG

export GPG_TTY=$(tty)
export GNUPGHOME=$HOME/.gnupg

######################################## NVM & Node

export NVM_DIR="$HOME/.nvm"
export PATH=$HOME/.npm/bin:$PATH
export PATH=$PATH:"$HOME/node_modules/.bin"

######################################## Snap

if (( $+commands[snap] )); then
    export PATH=$PATH:/snap/bin
fi

######################################## Password Store

if (( $+commands[pass] )); then
    export PASSWORD_STORE_DIR=$HOME/pass
    export PASSWORD_STORE_CLIP_TIME=10
    export PASSWORD_STORE_CLIPBOARD=primary
    export PASSWORD_STORE_GENERATED_LENGTH=32
    export EDITOR="/bin/vim"
fi

######################################## Internet Computer

if (( $+commands[dfx] )); then
    export PATH=$PATH:"$(dfx cache show)"
fi

# [ -r $HOME/.zshrc ] && source $HOME/.zshrc TODO
