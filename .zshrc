#  ~/.zshrc
#  Maintainer: Clément Vidon

######################################## Vi mode

bindkey -v                                                          # enable vim keybinding ( $ bindkey -l )
export EDITOR=vim
export KEYTIMEOUT=1                                                 # 10ms vi MODES transition

autoload -U history-search-end                                      # navigate history with NORMAL 'j' and 'k'
zle -N history-beginning-search-backward-end history-search-end
zle -N history-beginning-search-forward-end history-search-end

bindkey -M vicmd 'k' history-beginning-search-backward-end
bindkey -M vicmd 'j' history-beginning-search-forward-end

######################################## Completion

skip_global_compinit=1
autoload -Uz compinit
for dump in ~/.zcompdump(N.mh+24); do
    compinit
done
compinit -C

zstyle ':completion:*' menu select                                  # highlight suggestion
zmodload zsh/complist                                               # <S-Tab> reverse navigation
bindkey -M menuselect '^[[Z' reverse-menu-complete

######################################## History

bindkey "^R" history-incremental-search-backward                    # enable Ctrl-R i-search-bck
export HISTSIZE=9999
export SAVEHIST=$HISTSIZE
export HISTFILE=$HOME/.zsh_history
setopt hist_ignore_all_dups
setopt hist_ignore_space

######################################## Ctrl-D

set -o ignoreeof

######################################## Prompt

# %n username %m hostname %? exitcode %~ fullcwd %1~ cwdbasename

setopt PROMPT_SUBST

autoload -Uz vcs_info && precmd() { vcs_info }                      # Load version control information
zstyle ':vcs_info:git:*' formats ' %b '                             # Format the vcs_info_msg_0_ variable

PROMPT='%n@%m%{%F{102}%}${vcs_info_msg_0_}%{%F{none}%}%# '

######################################## Aliases

if [[ "$OSTYPE" == "darwin"* ]]; then
    alias ls="ls -G"
    alias la="ls -G -la"
    alias latr="ls -G -latr"
elif [[ "$OSTYPE" == "linux"* ]]; then
    alias ls="ls --color=auto"
    alias la="ls --color=auto -la"
    alias latr="ls --color=auto -latr"
fi

if ! (( $+commands[ag] )); then
    alias ag='grep -rI --color=auto'
    alias agc='grep -rI -c --color=auto'
else
    alias ag='ag --hidden'
    alias agc='ag -c --hidden'
fi

alias dush="du -h --max-depth=1 . | sort -rh"
alias grep='grep --color=auto'
alias shred="shred -uzn9"

# Vim
alias nv='nvim'
alias vi='vim'
alias iv="vim -c 'call Private()'"
alias nano="vim"

# Git

alias gs="git status -s --show-stash --ignore-submodules=untracked"
alias gad="git add"
alias gbr="git branch"
alias gch="git checkout"
alias gcl="git clone"
alias gco="git commit"
alias gdi="git diff"
alias gfe="git fetch"
alias glo="git log"
alias gme="git merge"
alias gpl="git pull"
alias gps="git push"
alias grb="git rebase"
alias gre="git reset"
alias gsh="git show"
alias gst="git status"
alias gsw="git switch"

# alias gad="git add"
# alias gap="git add --patch"
# alias gau="git add --update"
# alias gbr="git branch"
# alias gca="git commit --amend"
# alias gch="git checkout"
# alias gcl="git clone"
# alias gcm="git commit -m"
# alias gco="git commit"
# alias gcp="git commit -p"
# alias gcv="git commit -v"
# alias gdi="git diff"
# alias gds="git diff --staged"
# alias gfe="git fetch origin"
# alias glo="git log --oneline -10"
# alias gpl="git pull"
# alias gpl="git pull"
# alias gps="git push"
# alias grb="git rebase --interactive"
# alias gre="git restore"
# alias grm="git rm"
# alias grs="git reset"
# alias gsh="git show"
# alias gst="git status -s --show-stash --ignore-submodules=untracked"
# alias gs="git status"
# alias gsw="git switch"
# alias gswc="git switch -c"

alias rebase="git fetch && git rebase origin/master && git push --force-with-lease"
alias pullboth="git fetch origin; git fetch gitlab; git merge origin; git merge gitlab"

# Misc
alias python='python3'

# Locations
alias ricoh="cd ~/Documents/Images/RicohGR/ && pwd"

######################################## Functions

# Copy the given file content to clipboard.
function    copy()
{
    file=$1
    if [[ "$OSTYPE" == "darwin"* ]]; then
        pbcopy < $file
    elif [[ "$OSTYPE" == "linux"* ]]; then
        cat $file | xclip -selection clipboard
    fi
}

# Git add-commit-push an update.
function    gup()
{
    custom_message=$@
    default_message="Update"
    if [[ "$message" == "" ]]; then
        git status -s --show-stash --ignore-submodules=untracked
        git add -u
        git commit -m "$default_message"
        git push
        git status
    else
        git status -s --show-stash --ignore-submodules=untracked
        git add -u
        git commit -m "$custom_message"
        git push
        git status
    fi
}

# Change to next directory in parent folder (cd next)
cdn()
{
    local next_dir=$(ls -1 .. | grep -A 1 "$(basename "$(pwd)")$" | tail -n 1)
    cd "../${next_dir}"
    pwd
}

# Change to prev directory in parent folder (cd prev)
cdp()
{
    local next_dir=$(ls -1 .. | grep -B 1 "$(basename "$(pwd)")$" | head -n 1)
    cd "../${next_dir}"
    pwd
}

# Replace all occurrences of string recursively
replace_all()
{
    if [[ "$1" == "" ]]; then
        echo "Replace all 'old' into 'new' for all the files found in the 'path' tree."
        echo "Usage: replace PATH OLD NEW"
        return
    fi
    find "$1" -type f -exec sed -i "s/$2/$3/g" {} +
}

start_kub() {
    alias k='kubectl'
    source <(kubectl completion zsh)
    source <(minikube completion zsh)
}

start_node() {
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
    [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
    node --version
}

# pnpm
export PNPM_HOME="/home/clem/.local/share/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end
