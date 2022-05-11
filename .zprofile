## General
##########

export PATH=$PATH:"$HOME/.local/bin"
export PATH=$PATH:"$HOME/.local/script"

export NOTES=$HOME/git/Notes
export DOTVIM=$HOME/.config/vim

[ -r "$HOME/.zoffline" ] && source $HOME/.zoffline
[ -r $HOME/.zshrc ] && source $HOME/.zshrc

## Home
#######

if [[ "${LOGNAME}" = "clem" ]] || [[ "${LOGNAME}" = "clemedon" ]]; then
    export GPG_TTY=$(tty)
    export GNUPGHOME=$HOME/.gnupg
    export PATH=$HOME/.npm/bin:$PATH
    export PATH=$PATH:"$HOME/node_modules/.bin"
fi

## 42
#####

if [[ "${LOGNAME}" = "cvidon" ]]
then
    export PATH=$PATH:"$HOME/.linuxbrew/bin"
    export PATH=$PATH:"/mnt/nfs/homes/cvidon/.linuxbrew/sbin"
    export PATH="/sgoinfre/goinfre/Perso/cvidon/.poetry/bin:$PATH"
fi

## i3
#####

if [[ "$OSTYPE" == "linux"* ]] && [[ ! $DISPLAY && $XDG_VTNR -eq 1 ]]
then
    startx
fi
