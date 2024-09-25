#  clem/.zshenv
#  Created: 230828 14:48:02 by clem@spectre
#  Updated: 230828 14:48:02 by clem@spectre
#  Maintainer: Clément Vidon

export PATH=$PATH:"$HOME/bin"
export PATH=$PATH:"$HOME/.local/bin"
export PATH=$PATH:"$HOME/.local/script"

export GOROOT=/usr/local/go
export GOPATH=$HOME/go
export PATH=$PATH:$GOROOT/bin:$GOPATH/bin

export PATH=$PATH:/snap/bin

export PATH=$HOME/.npm/bin:$PATH
export PATH=$PATH:"$HOME/node_modules/.bin"

export PATH=$PATH:"$HOME/.cargo/bin"
export PATH="${KREW_ROOT:-$HOME/.krew}/bin:$PATH"


[ -r $HOME/.zshrc ] && source $HOME/.zshrc

######################################## GnuPG

export GPG_TTY=$(tty)
export GNUPGHOME=$HOME/.gnupg

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
. "$HOME/.cargo/env"
