## General
##########

export PATH=$PATH:"$HOME/.local/bin"
export PATH=$PATH:"$HOME/.local/script"

export NOTES=$HOME/git/Notes
export DOTVIM=$HOME/.config/vim

[ -f "$HOME/.zsecret" ] && source $HOME/.zsecret

[ -r $HOME/.zshrc ] && source $HOME/.zshrc

## Home
#######

if [[ "${LOGNAME}" = "clem" ]] || [[ "${LOGNAME}" = "clemedon" ]]; then
    export GPG_TTY=$(tty)
    export GNUPGHOME=$HOME/.gnupg
fi

## 42
#####

if [[ "${LOGNAME}" = "cvidon" ]]
then
    if [[ "$OSTYPE" == "darwin"* ]]; then
        ## Sbb (Jekyll)
        export PATH=$PATH:"$HOME/.gem/ruby/2.3.0/bin"
    elif [[ "$OSTYPE" == "linux"* ]]; then
        export PATH=$PATH:"$HOME/.linuxbrew/bin"
        export PATH=$PATH:"/mnt/nfs/homes/cvidon/.linuxbrew/sbin"
        ## Sbb (Jekyll)
        eval "$(direnv hook zsh)"
        export PATH=$PATH:"$HOME/.gem/ruby/2.7.0/bin"
        export GEM_HOME=$PATH:"$HOME/gems"
        export PATH=$PATH:"$HOME/gems/bin"
    fi
fi

## i3
#####

if [[ "$OSTYPE" == "linux"* ]] && [[ ! $DISPLAY && $XDG_VTNR -eq 1 ]]
then
    startx
fi
