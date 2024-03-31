# ========== [ vi mode ]

set -o vi
bind -m vi-command 'Control-l: clear-screen'
bind -m vi-insert 'Control-l: clear-screen'

# ========== [ aliases ]

if [[ "$OSTYPE" == "darwin"* ]]; then
    alias ls="ls -G"
    alias la="ls -G -la"
    alias latr="ls -G -latr"
elif [[ "$OSTYPE" == "linux"* ]]; then
    alias ls="ls --color=auto"
    alias la="ls --color=auto -la"
    alias latr="ls --color=auto -latr"
fi

alias vi='vim'
alias code=''
alias grep='grep --color=auto'
alias ag='grep -r --color=auto'
alias nt="vim -c 'call Notrace()'"
alias dush="du -sh * | grep \"M\|G\" | sort -h; du -sh .* | grep \"M\|G\" | sort -h"
. "$HOME/.local/share/dfx/env"
