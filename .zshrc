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

autoload -Uz compinit && compinit                                   # commands completion
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

#       [ Bash prompt ]

# PROMPT='%n@%m:%~$ '

#       [ Exit value ]

# RPROMPT='[%?]'

#       [ Zsh prompt + git branch ]

autoload -Uz vcs_info && precmd() { vcs_info }                      # Load version control information
zstyle ':vcs_info:git:*' formats ' %b '                             # Format the vcs_info_msg_0_ variable

PROMPT='%m%{%F{102}%}${vcs_info_msg_0_}%{%F{none}%}%# '

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
    alias wifi="nmcli device wifi list --rescan yes && nmcli device wifi connect C"
fi

alias ag='grep -r --color=auto'
alias dush="du -sh * | grep \"M\|G\" | sort -h; du -sh .* | grep \"M\|G\" | sort -h"
alias grep='grep --color=auto'
alias val="valgrind -q --trace-children=yes --leak-check=yes --show-leak-kinds=all"
alias vi='vim'
alias iv="vim -c 'call Notrace()'"

#       [ git ]
alias gad="git add"
alias gap="git add -p"
alias gau="git add -u"
alias gbr="git branch"
alias gca="git commit --amend"
alias gch="git checkout"
alias gcl="git clone"
alias gcm="git commit -m"
alias gco="git commit"
alias gcp="git commit -p"
alias gcv="git commit -v"
alias gdi="git diff"
alias glo="git log --oneline --name-only"
alias gpl="git pull"
alias gps="git push"
alias grb="git rebase --interactive"
alias gre="git restore"
alias grm="git rm"
alias grs="git reset"
alias gsh="git show"
alias gst="git status -s --show-stash --ignore-submodules=untracked"
alias gsw="git switch"

#       [ Make ]
alias mal='make all'
alias mcl='make clean'
alias mre='make re'
alias mas='make asan'
alias mru='make run'

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
        cat $file | xclip -sel clip
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
