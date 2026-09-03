#!/usr/bin/env bash
#
# Purpose: Validate repository structure, shell scripts, and Stow installation.

set -Eeuo pipefail

REPO_ROOT="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd -P)"
readonly REPO_ROOT
TEST_ROOT=""

usage() {
  cat <<'EOF'
Usage: check.sh [-h|--help]

Run syntax, interface, configuration, and isolated installation checks for
this dotfiles repository.

Options:
  -h, --help  Show this help
EOF
}

info() {
  printf '[CHECK] %s\n' "$*"
}

skip() {
  printf '[SKIP] %s\n' "$*"
}

die() {
  printf '[ERROR] %s\n' "$*" >&2
  exit 1
}

cleanup() {
  if [[ -n "$TEST_ROOT" && -d "$TEST_ROOT" ]]; then
    rm -rf -- "$TEST_ROOT"
  fi
}

trap cleanup EXIT

parse_args() {
  while [[ $# -gt 0 ]]; do
    case "$1" in
      -h | --help)
        usage
        exit 0
        ;;
      *)
        die "Unknown argument: $1"
        ;;
    esac
  done
}

check_shell_syntax() {
  local script

  info 'Bash syntax'
  bash -n "$REPO_ROOT/install.sh"
  while IFS= read -r -d '' script; do
    bash -n "$script"
  done < <(find "$REPO_ROOT/scripts" -maxdepth 1 -type f -name '*.sh' -print0)
  while IFS= read -r -d '' script; do
    bash -n "$script"
  done < <(find "$REPO_ROOT/stow/scripts/.local/bin" -type f -print0)

  zsh -n \
    "$REPO_ROOT/stow/zsh/.zshenv" \
    "$REPO_ROOT/stow/zsh/.zprofile" \
    "$REPO_ROOT/stow/zsh/.zshrc"

  if command -v shellcheck >/dev/null 2>&1; then
    info 'ShellCheck validation'
    shellcheck --shell=bash \
      "$REPO_ROOT/install.sh" \
      "$REPO_ROOT/scripts/"*.sh

    shellcheck --severity=error --shell=bash \
      "$REPO_ROOT/stow/bash/.bashrc" \
      "$REPO_ROOT/stow/scripts/.local/bin/"*
  else
    skip 'ShellCheck validation (shellcheck is unavailable)'
  fi
}

check_script_interfaces() {
  local script header
  local -a scripts=("$REPO_ROOT/install.sh")

  info 'Script headers and help interfaces'

  while IFS= read -r -d '' script; do
    scripts+=("$script")
  done < <(find "$REPO_ROOT/scripts" -maxdepth 1 -type f -name '*.sh' -print0)

  while IFS= read -r -d '' script; do
    scripts+=("$script")
  done < <(find "$REPO_ROOT/stow/scripts/.local/bin" -type f -print0)

  for script in "${scripts[@]}"; do
    [[ -x "$script" ]] || die "Script is not executable: $script"
    [[ "$(sed -n '1p' "$script")" == '#!/usr/bin/env bash' ]] \
      || die "Script does not use the standard Bash shebang: $script"

    header="$(sed -n '3p' "$script")"
    [[ "$header" == '# Purpose: '* ]] || die "Script has no purpose header: $script"

    "$script" -h | grep -q '^Usage:' || die "Script -h help failed: $script"
    "$script" --help | grep -q '^Usage:' || die "Script --help failed: $script"
  done

  if command -v shfmt >/dev/null 2>&1; then
    info 'shfmt validation'
    shfmt -d -i 2 -ci -bn "${scripts[@]}"
  else
    skip 'shfmt validation (shfmt is unavailable)'
  fi
}

check_script_behaviors() {
  local fixture="$TEST_ROOT/script-behaviors"
  local stub_bin="$fixture/bin"
  local source="$fixture/source"
  local clipboard="$fixture/clipboard.txt"
  local tmux_log="$fixture/tmux.log"
  local archive_output="$fixture/archive-output"
  local backup_destination="$fixture/backup-destination"
  local ssh_environment="$fixture/ssh-agent.env"
  local copy_script="$REPO_ROOT/stow/scripts/.local/bin/copy"
  local encrypt_script="$REPO_ROOT/stow/scripts/.local/bin/encrypt-this"
  local backup_script="$REPO_ROOT/stow/scripts/.local/bin/backup-all"
  local sendkey_script="$REPO_ROOT/stow/scripts/.local/bin/sendkey"
  local sshagent_script="$REPO_ROOT/stow/scripts/.local/bin/sshagent"
  local tjm_script="$REPO_ROOT/stow/scripts/.local/bin/tjm"
  local agent_output reused_output agent_socket agent_pid tjm_output

  info 'Script behavior regressions'
  mkdir -p "$stub_bin" "$source/nested"

  # These single-quoted strings are literal source code for test doubles.
  # shellcheck disable=SC2016
  printf '%s\n' \
    '#!/usr/bin/env bash' \
    'cat >"$COPY_CAPTURE"' >"$stub_bin/pbcopy"
  chmod +x "$stub_bin/pbcopy"

  printf 'keep\n' >"$source/nested/keep.txt"
  printf 'drop\n' >"$source/nested/drop.txt"
  printf 'nested/drop.txt\n' >"$fixture/ignore"

  PATH="$stub_bin:/usr/bin:/bin" COPY_CAPTURE="$clipboard" \
    "$copy_script" --ignore "$fixture/ignore" "$source/"

  grep -q 'keep' "$clipboard" || die 'copy omitted a non-ignored file'
  if grep -q 'drop' "$clipboard"; then
    die 'copy did not apply a root-relative ignore with a trailing slash source'
  fi

  rm -f -- "$clipboard"
  if PATH="$stub_bin:/usr/bin:/bin" COPY_CAPTURE="$clipboard" \
    "$copy_script" "$source/nested/keep.txt" "$fixture/missing" >/dev/null 2>&1; then
    die 'copy accepted a missing source'
  fi
  [[ ! -e "$clipboard" ]] || die 'copy changed the clipboard before validating every source'

  # shellcheck disable=SC2016
  printf '%s\n' \
    '#!/usr/bin/env bash' \
    'printf "<%s>\\n" "$@" >>"$TMUX_LOG"' \
    'exit 0' >"$stub_bin/tmux"
  chmod +x "$stub_bin/tmux"

  PATH="$stub_bin:/usr/bin:/bin" TMUX_LOG="$tmux_log" \
    "$sendkey_script" 'app:0.1' 'printf "%s" "$HOME"'

  grep -Fxq '<printf "%s" "$HOME">' "$tmux_log" \
    || die 'sendkey did not preserve the command literally'
  [[ "$(grep -Fxc '<send-keys>' "$tmux_log")" -eq 2 ]] \
    || die 'sendkey did not emit exactly two send-keys calls'

  tjm_output="$("$tjm_script" 3000)"
  [[ "$tjm_output" == *'TJM:      280'* && "$tjm_output" == *'THM:      35'* ]] \
    || die 'tjm returned an unexpected estimate'
  if "$tjm_script" 'not-a-number' >/dev/null 2>&1; then
    die 'tjm accepted an invalid amount'
  fi

  # shellcheck disable=SC2016
  printf '%s\n' \
    '#!/usr/bin/env bash' \
    'if [[ "${1:-}" == "-d" ]]; then' \
    '  for argument in "$@"; do archive="$argument"; done' \
    '  cat -- "$archive"' \
    'else' \
    '  cat' \
    'fi' >"$stub_bin/age"
  chmod +x "$stub_bin/age"

  mkdir -p "$archive_output"
  (
    cd -- "$archive_output"
    PATH="$stub_bin:/usr/bin:/bin" "$encrypt_script" "$source/nested/keep.txt" >/dev/null
  )
  [[ -s "$archive_output/keep.txt-$(date +%y%m%d).tar.age" ]] \
    || die 'encrypt-this did not create a verified archive'

  # shellcheck disable=SC2016
  printf '%s\n' \
    '#!/usr/bin/env bash' \
    'for argument in "$@"; do target="$argument"; done' \
    'base="${target##*/}"' \
    'printf "archive for %s\\n" "$target" >"$base-$(date +%y%m%d).tar.age"' \
    >"$stub_bin/encrypt-this"
  chmod +x "$stub_bin/encrypt-this"
  mkdir -p "$backup_destination"

  PATH="$stub_bin:/usr/bin:/bin" BACKUP_ENCRYPT_COMMAND="$stub_bin/encrypt-this" \
    "$backup_script" --destination "$backup_destination" "$source" >/dev/null

  [[ -s "$backup_destination/backup-$(date +%y%m%d)/SHA256SUMS.txt" ]] \
    || die 'backup-all did not publish a checksummed backup'

  if command -v ssh-agent >/dev/null 2>&1 && command -v ssh-add >/dev/null 2>&1; then
    agent_output="$(SSH_AGENT_ENV_FILE="$ssh_environment" SSH_AUTH_SOCK= SSH_AGENT_PID= \
      "$sshagent_script" --no-add)"
    agent_socket="$(printf '%s\n' "$agent_output" | sed -n 's/^export SSH_AUTH_SOCK=//p')"
    agent_pid="$(printf '%s\n' "$agent_output" | sed -n 's/^export SSH_AGENT_PID=//p')"

    if ! reused_output="$(
      unset SSH_AGENT_PID
      SSH_AGENT_ENV_FILE="$ssh_environment" SSH_AUTH_SOCK="$agent_socket" \
        "$sshagent_script" --no-add
    )"; then
      SSH_AUTH_SOCK="$agent_socket" SSH_AGENT_PID="$agent_pid" ssh-agent -k >/dev/null
      die 'sshagent did not reuse an agent without a local PID'
    fi

    SSH_AUTH_SOCK="$agent_socket" SSH_AGENT_PID="$agent_pid" ssh-agent -k >/dev/null
    [[ "$reused_output" == *'unset SSH_AGENT_PID'* ]] \
      || die 'sshagent emitted a stale PID for a forwarded agent'
  else
    skip 'sshagent behavior (OpenSSH client tools are unavailable)'
  fi
}

check_managed_configs() {
  local socket="$TEST_ROOT/tmux.sock"

  info 'Managed configuration syntax'

  info 'Git configuration validation'
  git config --file "$REPO_ROOT/stow/git/.gitconfig" --list >/dev/null

  info 'Karabiner JSON validation'
  python3 -m json.tool \
    "$REPO_ROOT/stow/karabiner/.config/karabiner/karabiner.json" >/dev/null

  if command -v wezterm >/dev/null 2>&1; then
    info 'WezTerm configuration validation'
    wezterm \
      --config-file "$REPO_ROOT/stow/wezterm/.config/wezterm/wezterm.lua" \
      show-keys >/dev/null
  else
    skip 'WezTerm configuration validation (wezterm is unavailable)'
  fi

  if command -v tmux >/dev/null 2>&1; then
    info 'tmux configuration validation'
    tmux -S "$socket" -f "$REPO_ROOT/stow/tmux/.tmux.conf" new-session -d
    tmux -S "$socket" kill-server
  else
    skip 'tmux configuration validation (tmux is unavailable)'
  fi
}

check_stale_paths() {
  local matches=""
  # This is a regex for the literal text "$HOME".
  # shellcheck disable=SC2016
  local pattern='(\$HOME/(git/)?config|/home/[^/]+/config|/Users/[^/]+/config|config/vim)'

  info 'No repository-location assumptions in managed files'
  if command -v rg >/dev/null 2>&1; then
    matches="$(rg -n "$pattern" "$REPO_ROOT/stow" || true)"
  else
    matches="$(grep -REn "$pattern" "$REPO_ROOT/stow" || true)"
  fi

  [[ -z "$matches" ]] || {
    printf '%s\n' "$matches" >&2
    die 'Managed files still reference the old repository location'
  }
}

check_package_layout() {
  local actual
  local package
  local known
  local -a expected=(
    bash
    zsh
    git
    tmux
    vim
    ideavim
    alacritty
    wezterm
    karabiner
    clang-format
    scripts
  )

  info 'Stow package layout'
  for package in "${expected[@]}"; do
    [[ -d "$REPO_ROOT/stow/$package" ]] || die "Missing Stow package: $package"

    if ! find "$REPO_ROOT/stow/$package" \( -type f -o -type l \) -print -quit | grep -q .; then
      die "Empty Stow package: $package"
    fi
  done

  while IFS= read -r actual; do
    known=false
    for package in "${expected[@]}"; do
      if [[ "$actual" == "$package" ]]; then
        known=true
        break
      fi
    done

    $known || die "Unexpected Stow package: $actual"
  done < <(find "$REPO_ROOT/stow" -mindepth 1 -maxdepth 1 -type d -exec basename {} \;)

  if find "$REPO_ROOT/stow" -mindepth 1 -maxdepth 1 ! -type d -print -quit | grep -q .; then
    die 'Only package directories may exist at the top level of stow/'
  fi

  if find "$REPO_ROOT/stow" -name .git -print -quit | grep -q .; then
    die 'Nested Git repositories must not be stored in Stow packages'
  fi
}

check_platform() {
  local platform="$1"
  local home="$TEST_ROOT/$platform/home"
  local first_links
  local second_links

  info "Install and remove in a temporary $platform HOME"
  mkdir -p "$home"

  "$REPO_ROOT/install.sh" install \
    --platform "$platform" \
    --target "$home" >/dev/null

  first_links="$(find "$home" -type l -print | sort)"
  [[ -n "$first_links" ]] || die "No links created for $platform"

  "$REPO_ROOT/install.sh" install \
    --platform "$platform" \
    --target "$home" >/dev/null

  second_links="$(find "$home" -type l -print | sort)"
  [[ "$first_links" == "$second_links" ]] || die "Second $platform apply changed the link set"

  if [[ "$platform" == "ubuntu" ]]; then
    [[ -L "$home/.config/wezterm/wezterm.lua" ]] || die 'Ubuntu did not install WezTerm configuration'
    [[ ! -e "$home/.config/karabiner/karabiner.json" ]] \
      || die 'Ubuntu unexpectedly installed Karabiner configuration'
    [[ -L "$home/.local/share/fonts/iosevka-semibold.ttc" ]] || die 'Ubuntu font target is wrong'
  else
    [[ -L "$home/.config/wezterm/wezterm.lua" ]] || die 'macOS did not install WezTerm configuration'
    [[ -L "$home/.config/karabiner/karabiner.json" ]] \
      || die 'macOS did not install Karabiner configuration'
    [[ -L "$home/Library/Fonts/iosevka-semibold.ttc" ]] || die 'macOS font target is wrong'
  fi

  [[ -L "$home/.zprofile" ]] || die "$platform package did not install .zprofile"

  "$REPO_ROOT/install.sh" remove \
    --platform "$platform" \
    --target "$home" >/dev/null

  if find "$home" -type l -print -quit | grep -q .; then
    find "$home" -type l -print >&2
    die "Removal left managed links in the $platform HOME"
  fi
}

check_dry_run() {
  local home="$TEST_ROOT/dry-run/home"
  local output

  info 'Dry run reaches Stow preflight without mutation'
  mkdir -p "$home"
  output="$("$REPO_ROOT/install.sh" install \
    --dry-run \
    --platform macos \
    --target "$home")"

  [[ "$output" == *'Stow installation preview passed'* ]] \
    || die 'Dry run did not reach the Stow preflight'
  [[ -z "$(find "$home" -mindepth 1 -print -quit)" ]] \
    || die 'Dry run changed the target HOME'
}

check_font_ownership() {
  local home="$TEST_ROOT/fonts/home"
  local font="$home/Library/Fonts/iosevka-semibold.ttc"

  info 'Bundled font belongs only to the fonts package'
  mkdir -p "$home"

  "$REPO_ROOT/install.sh" install --platform macos --target "$home" wezterm >/dev/null
  [[ ! -e "$font" && ! -L "$font" ]] || die 'WezTerm installation touched the bundled font'

  "$REPO_ROOT/install.sh" install --platform macos --target "$home" fonts >/dev/null 2>&1
  [[ -L "$font" ]] || die 'Fonts package did not install the bundled font'

  "$REPO_ROOT/install.sh" remove --platform macos --target "$home" wezterm >/dev/null
  [[ -L "$font" ]] || die 'WezTerm removal touched the bundled font'

  "$REPO_ROOT/install.sh" remove --platform macos --target "$home" fonts >/dev/null
  [[ ! -e "$font" && ! -L "$font" ]] || die 'Fonts package did not remove its font link'

  mkdir -p "$(dirname "$font")"
  printf 'user-owned font\n' >"$font"
  "$REPO_ROOT/install.sh" install --platform macos --target "$home" fonts >/dev/null 2>&1
  [[ "$(<"$font")" == 'user-owned font' ]] || die 'Fonts installation changed an unowned font'

  "$REPO_ROOT/install.sh" remove --platform macos --target "$home" fonts >/dev/null
  [[ "$(<"$font")" == 'user-owned font' ]] || die 'Fonts removal changed an unowned font'
}

check_font_preflight() {
  local fixture="$TEST_ROOT/missing-font/repository"
  local home="$TEST_ROOT/missing-font/home"

  info 'Missing bundled font fails before Stow changes'
  mkdir -p "$fixture/assets/fonts" "$home"
  cp "$REPO_ROOT/install.sh" "$fixture/install.sh"
  cp -R "$REPO_ROOT/stow" "$fixture/stow"

  if "$fixture/install.sh" install --dry-run \
    --platform macos --target "$home" >/dev/null 2>&1; then
    die 'Installation dry run succeeded without the bundled font'
  fi

  if "$fixture/install.sh" install \
    --platform macos --target "$home" >/dev/null 2>&1; then
    die 'Normal installation succeeded without the bundled font'
  fi

  [[ -z "$(find "$home" -mindepth 1 -print -quit)" ]] \
    || die 'Missing font failure happened after target HOME changes'
}

check_platform_guard() {
  local home="$TEST_ROOT/platform-guard/home"

  info 'Forced platform requires an explicit alternate HOME'
  mkdir -p "$home"

  if HOME="$home" "$REPO_ROOT/install.sh" --dry-run --platform ubuntu >/dev/null 2>&1; then
    die 'Forced platform was accepted against HOME without --target'
  fi

  if HOME="$home" "$REPO_ROOT/install.sh" --dry-run \
    --platform ubuntu --target "$home" >/dev/null 2>&1; then
    die 'Forced platform was accepted when --target was HOME'
  fi
}

check_conflict_protection() {
  local home="$TEST_ROOT/conflict/home"
  local marker='user-owned bashrc'

  info 'Refuse to overwrite an unmanaged file'
  mkdir -p "$home"
  printf '%s\n' "$marker" >"$home/.bashrc"

  if "$REPO_ROOT/install.sh" install \
    --platform macos \
    --target "$home" \
    --no-font \
    bash >/dev/null 2>&1; then
    die 'Installer unexpectedly overwrote an unmanaged .bashrc'
  fi

  [[ "$(<"$home/.bashrc")" == "$marker" ]] || die 'Conflict test changed the unmanaged .bashrc'
}

main() {
  parse_args "$@"

  command -v stow >/dev/null 2>&1 || die 'GNU Stow is required'

  TEST_ROOT="$(mktemp -d "${TMPDIR:-/tmp}/config-check.XXXXXX")"

  check_shell_syntax
  check_script_interfaces
  check_script_behaviors
  check_stale_paths
  check_package_layout
  check_managed_configs

  check_dry_run
  check_font_preflight
  check_font_ownership
  check_platform_guard
  check_platform macos
  check_platform ubuntu
  check_conflict_protection

  info 'All structural checks passed'
}

main "$@"
