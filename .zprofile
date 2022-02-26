export PATH=$PATH:"$HOME/.local/bin"

## 42
#####

if [[ "${HOME}" = "/mnt/nfs/homes/cvidon" ]]
then
    export PATH=$PATH:"$HOME/.linuxbrew/bin"
fi

## i3
#####

if [[ "$OSTYPE" == "linux"* ]] && [[ ! $DISPLAY && $XDG_VTNR -eq 1 ]]
then
    startx
fi
