# ~/.bashrc

# =============================================================================
# Vi mode
# =============================================================================

set -o vi


# =============================================================================
# Aliases
# =============================================================================

alias vi='vim'


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
