export PATH=$PATH:"$HOME/.local/bin"
export PATH=$PATH:"$HOME/.local/script"

## 42
#####

if [[ "${HOME}" = "/mnt/nfs/homes/cvidon" ]]
then
    ## Ubuntu
    export PATH=$PATH:"$HOME/.linuxbrew/bin"
    ## Sbb (Jekyll)
    eval "$(direnv hook zsh)"
    export PATH=$PATH:"$HOME/.gem/ruby/2.7.0/bin"
    export GEM_HOME="$HOME/gems" >> ~/.bashrc
    export PATH="$HOME/gems/bin:$PATH"
fi

## i3
#####

if [[ "$OSTYPE" == "linux"* ]] && [[ ! $DISPLAY && $XDG_VTNR -eq 1 ]]
then
    startx
fi
