# ~/.zshrc

# =============================================================================
# Environment
# =============================================================================

[[ -n "${TTY:-}" ]] && export GPG_TTY="$TTY"

autoload -Uz add-zsh-hook


# =============================================================================
# Vi mode
# =============================================================================

bindkey -v
KEYTIMEOUT=1  # 10 ms vi mode transition

# Navigate history with j/k in normal mode.
autoload -U history-search-end

zle -N history-beginning-search-backward-end history-search-end
zle -N history-beginning-search-forward-end history-search-end

bindkey -M vicmd 'k' history-beginning-search-backward-end
bindkey -M vicmd 'j' history-beginning-search-forward-end


# =============================================================================
# Completion
# =============================================================================

autoload -Uz compinit
compinit -C

zstyle ':completion:*' menu select

zmodload zsh/complist
bindkey -M menuselect '^[[Z' reverse-menu-complete  # Shift-Tab


# =============================================================================
# History
# =============================================================================

HISTFILE="$HOME/.zsh_history"
HISTSIZE=1000
SAVEHIST=$HISTSIZE

setopt hist_ignore_all_dups
setopt hist_ignore_space
setopt append_history

bindkey '^R' history-incremental-search-backward

# Load pinned commands.
if [[ -f "$HOME/.zsh_history_pinned" ]]; then
  fc -R "$HOME/.zsh_history_pinned"
fi

# Pin a command to persistent history.
pin() {
  print -r -- "$*" >> "$HOME/.zsh_history_pinned"
  print -s "$*"
}

# Never store LLM commands in shell history.
_llm_history_filter() {
  local line="${1%%$'\n'}"

  if [[ "$line" =~ '(^|[[:space:];|&()])(llm|ref|toe|tof|syn|ant|lex|equ|_llm_words|_llm_input)([[:space:];|&()]|$)' ]]; then
    return 1
  fi

  return 0
}

add-zsh-hook zshaddhistory _llm_history_filter


# =============================================================================
# Shell behavior
# =============================================================================

setopt ignore_eof


# =============================================================================
# Prompt
# =============================================================================

setopt PROMPT_SUBST

typeset -g git_prompt=''

_update_git_prompt() {
  local dir="$PWD"
  local dotgit gitdir head

  git_prompt=''

  # Find the nearest .git directory or file.
  while true; do
    dotgit="$dir/.git"

    if [[ -d "$dotgit" || -f "$dotgit" ]]; then
      break
    fi

    [[ "$dir" == "/" ]] && return
    dir="${dir:h}"
  done

  # Normal repository.
  if [[ -d "$dotgit" ]]; then
    gitdir="$dotgit"

  # Worktree/submodule: .git points to the actual Git directory.
  else
    local gitfile
    gitfile="$(<"$dotgit")"
    gitdir="${gitfile#gitdir: }"

    if [[ "$gitdir" != /* ]]; then
      gitdir="${dotgit:h}/$gitdir"
    fi
  fi

  [[ -r "$gitdir/HEAD" ]] || return

  head="$(<"$gitdir/HEAD")"

  if [[ "$head" == "ref: refs/heads/"* ]]; then
    git_prompt=" ${head#ref: refs/heads/} "
  else
    git_prompt=" ${head[1,8]} "
  fi
}

add-zsh-hook precmd _update_git_prompt

PROMPT='%n@%m%{%F{102}%}${git_prompt}%{%f%}%# '


# =============================================================================
# Aliases
# =============================================================================

# Platform-specific.
if [[ "$OSTYPE" == darwin* ]]; then
  alias ls='ls -G'
  alias la='ls -G -la'
  alias latr='ls -G -latr'

elif [[ "$OSTYPE" == linux* ]]; then
  alias ls='ls --color=auto'
  alias la='ls --color=auto -la'
  alias latr='ls --color=auto -latr'

  alias dush='du -h --max-depth=1 . | sort -rh'
  alias shred='shred -uzn9'
fi

# Search.
alias ag='ag --hidden'
alias agc='ag -c --hidden'
alias grep='grep --color=auto'

# Editors.
alias nv='nvim'
alias vi='vim'
alias iv="vim -c 'call Private()'"
alias nano='vim'

# Git.
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
alias gfe='git fetch origin'
alias gpl='git pull'
alias gps='git push'
alias grb='git rebase --interactive'
alias gre='git reset'
alias gsh='git show'
alias gs='git status -s --show-stash --ignore-submodules=untracked'
alias gst='git status'
alias gsw='git switch'
alias gsc='git switch -c'

# Misc.
alias python='python3'
alias tf='terraform'
alias refresh='hash -r'
alias types="find . -maxdepth 1 -type f | sed 's/.*\.//' | sort -u"
alias magick='convert'

# Locations.
alias ricoh='cd "$HOME/Documents/Images/RicohGR" && pwd'


# =============================================================================
# Git functions
# =============================================================================

# Compact Git log with shortstat.
glof() {
  [[ "$1" =~ ^-[0-9]+$ ]] || set -- -12 "$@"

  git -c color.ui=always log "$@" \
    --pretty=format:"%C(yellow)%h%Creset %Cgreen(%cd)%Creset %C(cyan)%s%Creset" \
    --date=format:"%Y-%m-%d %H:%M" \
    --shortstat |
    awk '
      NF == 0 { next }

      /files? changed/ {
        match($0, /[0-9]+ file[s]? changed/)
        print prev " | " substr($0, RSTART, RLENGTH)
      }

      { prev = $0 }
    '
}

# Compact Git log.
glo() {
  [[ "$1" =~ ^-[0-9]+$ ]] || set -- -12 "$@"

  git -c color.ui=always log "$@" \
    --pretty=format:"%C(yellow)%h%Creset %Cgreen(%cd)%Creset %s" \
    --date=format:"%Y-%m-%d %H:%M"
}

# Git add, commit and push.
gup() {
  local message="${*:-Update}"

  git status -s --show-stash --ignore-submodules=untracked &&
    git add -u &&
    git commit -m "$message" &&
    git push &&
    git status
}


# =============================================================================
# Navigation functions
# =============================================================================

# Change to an adjacent sibling directory without parsing command output.
_cd_sibling() {
  local offset="$1"
  local index target
  local -a siblings

  siblings=("${PWD:h}"/*(/N))

  for ((index = 1; index <= ${#siblings}; index++)); do
    [[ "${siblings[index]:A}" == "${PWD:A}" ]] || continue

    target=$((index + offset))
    ((target >= 1 && target <= ${#siblings})) || return 1

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
# Optional environments
# =============================================================================

start_kub() {
  alias k='kubectl'

  source <(kubectl completion zsh)
  source <(minikube completion zsh)
}

start_node() {
  export NVM_DIR="$HOME/.nvm"

  if [[ ! -s "$NVM_DIR/nvm.sh" ]]; then
    print -u2 -- "NVM is not installed in $NVM_DIR"
    return 1
  fi

  source "$NVM_DIR/nvm.sh"

  [[ -s "$NVM_DIR/bash_completion" ]] &&
    source "$NVM_DIR/bash_completion"

  (( $+commands[node] )) || {
    print -u2 -- 'Node.js is not installed'
    return 1
  }

  node --version
}


# =============================================================================
# LLM helpers
# =============================================================================

_llm_input() {
  if [[ $# -gt 0 ]]; then
    printf '%s' "$*"
  else
    cat
  fi
}

_llm_words() {
  local kind="$1"
  local n=10

  shift

  # Usage: syn -5 word
  if [[ "${1:-}" =~ ^-[0-9]+$ ]]; then
    n="${1#-}"
    shift
  fi

  _llm_input "$@" |
    llm \
      -m gpt-5.4-nano \
      -o reasoning_effort none \
      -s "Given the input word or expression, return up to $n $kind.
Return only the words or expressions, one per line.
No numbering, bullets, explanations, or introductory text.
Use the same language as the input."
}

ref() {
  _llm_input "$@" |
    llm \
      -m gpt-5.4-nano \
      -o reasoning_effort none \
      -s "Refine the input text with the smallest possible changes.
Fix spelling, grammar, punctuation, and awkward phrasing only when necessary.
Preserve the original meaning, tone, vocabulary, structure, and level of formality as much as possible.
Make the text clear, natural, digestible, and acceptable.
Do not embellish, rewrite stylistically, or add information.
Return only the refined text."
}

toe() {
  _llm_input "$@" |
    llm \
      -m gpt-5.4-nano \
      -o reasoning_effort none \
      -s "Translate the input to natural English.
Preserve the meaning, tone, and level of formality.
Return only the translation."
}

tof() {
  _llm_input "$@" |
    llm \
      -m gpt-5.4-nano \
      -o reasoning_effort none \
      -s "Translate the input to natural French.
Preserve the meaning, tone, and level of formality.
Return only the translation."
}

syn() {
  _llm_words "synonyms" "$@"
}

ant() {
  _llm_words "antonyms" "$@"
}

lex() {
  _llm_words "words or expressions from the lexical field surrounding the input" "$@"
}

equ() {
  _llm_words "close equivalents or alternative expressions with a similar meaning" "$@"
}


# =============================================================================
# VS Code
# =============================================================================

if [[ "$TERM_PROGRAM" == vscode ]]; then
  export GIT_EDITOR='code --wait'
else
  export GIT_EDITOR='vim'
fi
