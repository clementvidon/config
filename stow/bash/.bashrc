# ~/.bashrc

# =============================================================================
# Vi mode
# =============================================================================

set -o vi

if [[ $- == *i* ]]; then
  # Readline has no Vim visual mode; avoid opening an external editor.
  bind -m vi-command '"v": ""'
  bind -m vi-command '"V": ""'

  # Navigate history by prefix with j/k in normal mode.
  bind -m vi-command '"k": history-search-backward'
  bind -m vi-command '"j": history-search-forward'
  bind -m vi-insert '"\C-r": reverse-search-history'
  bind -m vi-command '"\C-r": reverse-search-history'

  # macOS system Readline does not expose the Escape timeout.
  if bind -v | command grep -q '^set keyseq-timeout '; then
    bind 'set keyseq-timeout 10'
  fi
fi


# =============================================================================
# Aliases
# =============================================================================

# Platform-specific.
if [[ "$OSTYPE" == darwin* ]]; then
  alias ls='ls -G'
  alias la='ls -G -la'

elif [[ "$OSTYPE" == linux* ]]; then
  alias ls='ls --color=auto'
  alias la='ls --color=auto -la'

  alias dush='du -h --max-depth=1 . | sort -rh'
  alias shred='shred -uzn9'
fi

# Search.
alias grep='grep --color=auto'

# Editors.
alias nv='nvim'
alias vi='vim'
alias nano='vim'

# Git.
if [[ $OSTYPE == darwin* && $(type -P git) == /usr/bin/git &&
      -x /Library/Developer/CommandLineTools/usr/bin/git ]]; then
  hash -p /Library/Developer/CommandLineTools/usr/bin/git git
fi

alias gad='git add'
alias gap='git add --patch'
alias gau='git add --update'
alias gbr='git branch'
alias gca='git commit --amend'
alias gch='git checkout'
alias gcl='git clone'
alias gcm='git commit -m'
alias gco='git commit'
alias gcv='git commit -v'
alias gdi='git diff'
alias gds='git diff --staged'
alias gfo='git fetch origin'
alias gpl='git pull'
alias gps='git push'
alias gri='git rebase --interactive'
alias gre='git reset'
alias gsh='git show'
alias gs='git status -s --show-stash --ignore-submodules=untracked'
alias gst='git status'
alias gsw='git switch'
alias gsc='git switch -c'

# Misc.
alias python='python3'
alias tf='terraform'
alias awake='systemd-inhibit --what=idle:sleep:handle-lid-switch:sleep --mode=block --who="Clément" --why="Computer is working" sleep infinity'

# =============================================================================
# Command help
# =============================================================================

# Use cheat.sh for examples; builtin help still provides Bash documentation.
help() {
  if [[ $# != 1 ]]; then
    printf 'Usage: help <command>\n' >&2
    return 2
  fi
  curl -fsS "https://cheat.sh/$1"
}

# =============================================================================
# Git functions
# =============================================================================

# Compact Git log.
glo() {
  [[ "$1" =~ ^-[0-9]+$ ]] || set -- -12 "$@"

  git -c color.ui=always log "$@" \
    --pretty=format:"%C(yellow)%h%Creset %Cgreen(%cd)%Creset %s" \
    --date=format:"%Y-%m-%d %H:%M"
}

# =============================================================================
# Navigation functions
# =============================================================================

# Change to an adjacent sibling directory without parsing command output.
_cd_sibling() {
  local offset="$1"
  local parent="${PWD%/*}"
  local sibling index target
  local -a siblings

  siblings=()
  for sibling in "${parent:-/}"/*; do
    [[ -d "$sibling" ]] && siblings+=("$sibling")
  done

  for ((index = 0; index < ${#siblings[@]}; index++)); do
    [[ "${siblings[index]}" -ef "$PWD" ]] || continue

    target=$((index + offset))
    ((target >= 0 && target < ${#siblings[@]})) || return 1

    builtin cd -- "${siblings[target]}" || return
    pwd
    return
  done

  return 1
}

cdn() {
  _cd_sibling 1
}

cdp() {
  _cd_sibling -1
}


# =============================================================================
# Local settings
# =============================================================================

# Defaults
export NOESIS_ROOT="${NOESIS_ROOT:-$HOME/noesis}"
export VIM_GPG_RECIPIENT="${VIM_GPG_RECIPIENT:-B8AE5479C3DE72D291F1E923B32613620A074922}"
export NOTES_FILE="${NOTES_FILE:-$HOME/notes.md}"
export TODOS_FILE="${TODOS_FILE:-$HOME/todos.md}"
export PASSWORD_STORE_DIR="${PASSWORD_STORE_DIR:-$HOME/pass}"

# Local overrides
[[ -f "$HOME/.shellrc.private" && -r "$HOME/.shellrc.private" ]] && source "$HOME/.shellrc.private"
[[ -f "$HOME/.shellrc.local" && -r "$HOME/.shellrc.local" ]] && source "$HOME/.shellrc.local"
