# ========== [ tmux ]

if [[ $DISPLAY ]] || [[ "$OSTYPE" == "darwin"* ]]; then
    if command -v tmux &> /dev/null && [ -n "$PS1" ] && [[ ! "$TERM" =~ screen ]] && [[ ! "$TERM" =~ tmux ]] && [ -z "$TMUX" ]; then
        exec tmux
        # exec '/mnt/nfs/homes/cvidon/.linuxbrew/bin/tmux'
    fi
fi

# ========== [ vim ]

bindkey -v                                                          # enable vim keybinding ( $ bindkey -l )
export EDITOR=vim
export KEYTIMEOUT=1                                                 # 10ms vi MODES transition
autoload -U history-search-end                                      # navigate history with NORMAL 'j' and 'k'
zle -N history-beginning-search-backward-end history-search-end
zle -N history-beginning-search-forward-end history-search-end
bindkey -M vicmd 'k' history-beginning-search-backward-end
bindkey -M vicmd 'j' history-beginning-search-forward-end

# ========== [ completion ]

autoload -Uz compinit && compinit                                   # commands completion
zstyle ':completion:*' menu select                                  # highlight suggestion
zmodload zsh/complist                                               # <S-Tab> reverse navigation
bindkey -M menuselect '^[[Z' reverse-menu-complete

# ========== [ history ]

bindkey "^R" history-incremental-search-backward                    # enable Ctrl-R i-search-bck
export HISTSIZE=9999
export SAVEHIST=$HISTSIZE
export HISTFILE=$HOME/.zsh_history
setopt hist_ignore_all_dups
setopt hist_ignore_space

# ========== [ prompt ]

# setopt PROMPT_SUBST && PROMPT='%n@%m: ${(%):-%~} '

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
alias val="valgrind -q --trace-children=yes --leak-check=yes --show-leak-kinds=all"
alias gad="git add"
alias gap="git add -p"
alias gca="git commit --amend"
alias gcm="git commit -m"
alias gcp="git commit -p"
alias gcv="git commit -v"
alias gdi="git diff"
alias glo="git log --oneline"
alias gpl="git pull"
alias gpla="bash $HOME/git/utils/pull_all.zsh"
alias gps="git push"
alias gpsa="bash $HOME/git/utils/push_all.zsh"
alias grs="git reset"
alias grb="git rebase --interactive"
alias grm="git rm"
alias gst="git status"
alias gsw="git switch"
alias gsh="git show"
alias gsta="bash $HOME/git/utils/status_all.zsh"

alias km="kill -9 $(pgrep minishell)"
