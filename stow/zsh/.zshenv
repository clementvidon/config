# ~/.zshenv

# =============================================================================
# Path
# =============================================================================

# Keep PATH entries unique.
typeset -U path PATH

# Must be defined early to prevent global completion initialization where used.
skip_global_compinit=1

path=(
  "$HOME/.local/bin"
  "$HOME/bin"
  "$HOME/go/bin"
  $path
)


# =============================================================================
# Environment
# =============================================================================

export EDITOR='vim'


# =============================================================================
# Password Store
# =============================================================================

export PASSWORD_STORE_DIR="$HOME/pass"
export PASSWORD_STORE_CLIP_TIME=10
export PASSWORD_STORE_GENERATED_LENGTH=32

if [[ "$OSTYPE" == linux* ]]; then
  export PASSWORD_STORE_X_SELECTION='primary'
fi
