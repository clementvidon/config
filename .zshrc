# @file     .zshrc
# @brief    Zsh configuration file.
# @author   clemedon (Clément Vidon)

#------------------------------------------------------------------------------#
#                  vi mode                                                     #
#------------------------------------------------------------------------------#

bindkey -v                                                          # enable vim keybinding ( $ bindkey -l )
export EDITOR=vim
export KEYTIMEOUT=1                                                 # 10ms vi MODES transition

autoload -U history-search-end                                      # navigate history with NORMAL 'j' and 'k'
zle -N history-beginning-search-backward-end history-search-end
zle -N history-beginning-search-forward-end history-search-end

bindkey -M vicmd 'k' history-beginning-search-backward-end
bindkey -M vicmd 'j' history-beginning-search-forward-end

#------------------------------------------------------------------------------#
#                  completion                                                  #
#------------------------------------------------------------------------------#

skip_global_compinit=1
autoload -Uz compinit
for dump in ~/.zcompdump(N.mh+24); do
  compinit
done
compinit -C

zstyle ':completion:*' menu select                                  # highlight suggestion
zmodload zsh/complist                                               # <S-Tab> reverse navigation
bindkey -M menuselect '^[[Z' reverse-menu-complete

#------------------------------------------------------------------------------#
#                  history                                                     #
#------------------------------------------------------------------------------#

bindkey "^R" history-incremental-search-backward                    # enable Ctrl-R i-search-bck
export HISTSIZE=9999
export SAVEHIST=$HISTSIZE
export HISTFILE=$HOME/.zsh_history
setopt hist_ignore_all_dups
setopt hist_ignore_space

#------------------------------------------------------------------------------#
#                  Ctrl-D                                                      #
#------------------------------------------------------------------------------#

set -o ignoreeof

#------------------------------------------------------------------------------#
#                  prompt                                                      #
#------------------------------------------------------------------------------#

# %n username %m hostname %? exitcode %~ fullcwd %1~ cwdbasename

setopt PROMPT_SUBST

autoload -Uz vcs_info && precmd() { vcs_info }                      # Load version control information
zstyle ':vcs_info:git:*' formats ' %b '                             # Format the vcs_info_msg_0_ variable

PROMPT='%n@%m%{%F{102}%}${vcs_info_msg_0_}%{%F{none}%}%# '

#------------------------------------------------------------------------------#
#                  aliases                                                     #
#------------------------------------------------------------------------------#

if [[ "$OSTYPE" == "darwin"* ]]; then
    alias ls="ls -G"
    alias la="ls -G -la"
    alias latr="ls -G -latr"
elif [[ "$OSTYPE" == "linux"* ]]; then
    alias ls="ls --color=auto"
    alias la="ls --color=auto -la"
    alias latr="ls --color=auto -latr"
    alias wifi="nmcli device wifi list --rescan yes && nmcli device wifi connect iPhone"
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
alias val="valgrind -q --trace-children=yes --leak-check=yes --show-leak-kinds=all"
alias shred="shred -uzn9"

if (( $+commands[nvim] )); then
    # alias vi='nvim'
    # alias iv="nvim -c 'call Private()'"
else
    alias vi='vim'
    alias iv="vim -c 'call Private()'"
fi

#       [ git ]
alias gad="git add"
alias gap="git add --patch"
alias gau="git add --update"
alias gbr="git branch"
alias gca="git commit --amend"
alias gch="git checkout"
alias gcl="git clone"
alias gcm="git commit -m"
alias gco="git commit"
alias gcp="git commit -p"
alias gcv="git commit -v"
alias gdi="git diff"
alias gds="git diff --staged"
alias gfe="git fetch origin"
alias glo="git log --oneline -10"
alias gpl="git pull"
alias gps="git push"
alias grb="git rebase --interactive"
alias gre="git restore"
alias grm="git rm"
alias grs="git reset"
alias gsh="git show"
alias gst="git status -s --show-stash --ignore-submodules=untracked"
alias gsw="git switch"

alias rebase="git fetch && git rebase origin/master && git push --force-with-lease"

#       [ Make ]
alias mm='make'
alias mc='make clean'
alias mf='make fclean'
alias mr='make re'

alias ms='make sure'
alias ma='make asan'
alias ml='make leak'
alias me='make exec'
alias mt='make test'

#       [ Misc ]
alias please='sudo'
alias python='python3'

#------------------------------------------------------------------------------#
#                  functions                                                   #
#------------------------------------------------------------------------------#

# @brief        Kill a process by giving its name
# @param[in]    proc the name of the proc to kill.

function    k()
{
    proc=$1
    kill -9 $(pgrep $proc)
}

# @brief        Copy the given file content to clipboard.
# @param[in]    file a file

function    copy()
{
    file=$1
    if [[ "$OSTYPE" == "darwin"* ]]; then
        pbcopy < $file
    elif [[ "$OSTYPE" == "linux"* ]]; then
        cat $file | xclip -selection clipboard
    fi
}

# @brief        Git add-commit-push an update.
# @param[in]    message a message that suffixes "Update…"

function    gup()
{
    message=$@
    if [[ "$message" == "" ]]; then
        git status -s --show-stash --ignore-submodules=untracked
        git add -u
        git commit
        git push
        git status
    else
        git status -s --show-stash --ignore-submodules=untracked
        git add -u
        git commit -m "$message"
        git push
        git status
    fi
}

# @brief        Change to the next / prev directory in parent folder

function cdn()
{
    local next_dir=$(ls -1 .. | grep -A 1 "$(basename "$(pwd)")$" | tail -n 1)
    cd "../${next_dir}"
    pwd
}

function cdp()
{
    local next_dir=$(ls -1 .. | grep -B 1 "$(basename "$(pwd)")$" | head -n 1)
    cd "../${next_dir}"
    pwd
}

function repl()
{
    if [[ "$1" == "" ]]; then
        echo "Replace all 'old' into 'new' for all the files found in the 'path' tree."
        echo "Usage: repl path old new"
        return
    fi
    find "$1" -type f -exec sed -i "s/$2/$3/g" {} +
}

#------------------------------------------------------------------------------#
#                  functions                                                   #
#------------------------------------------------------------------------------#

# source <(kubectl completion zsh)
# source <(minikube completion zsh)
# eval "$(scw autocomplete script shell=zsh)"

alias pcu='cd ~/git/scw/pcu/'
alias cur='cd /home/pro/git/scw/pcu/product-catalog/cmd/producer-cron'
alias k='kubectl'
