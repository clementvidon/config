#!/usr/bin/env bash
# Run the GPG plugin tests with a disposable home and keyring.

set -Eeuo pipefail

PLUGIN_ROOT="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd -P)"
TEST_ROOT="$(mktemp -d "${TMPDIR:-/tmp}/vim-gpg-test.XXXXXX")"

cleanup() {
  if [[ -n "${GNUPGHOME:-}" && -d "$GNUPGHOME" ]] \
    && command -v gpgconf >/dev/null 2>&1; then
    gpgconf --kill gpg-agent >/dev/null 2>&1 || true
  fi
  rm -rf -- "$TEST_ROOT"
}

trap cleanup EXIT

command -v vim >/dev/null 2>&1 || {
  printf '[ERROR] Vim GPG tests require vim\n' >&2
  exit 1
}
command -v gpg >/dev/null 2>&1 || {
  printf '[ERROR] Vim GPG tests require gpg\n' >&2
  exit 1
}
command -v gpgconf >/dev/null 2>&1 || {
  printf '[ERROR] Vim GPG tests require gpgconf\n' >&2
  exit 1
}
command -v gpg-connect-agent >/dev/null 2>&1 || {
  printf '[ERROR] Vim GPG tests require gpg-connect-agent\n' >&2
  exit 1
}

mkdir -m 700 "$TEST_ROOT/gnupg"
mkdir -p "$TEST_ROOT/home" "$TEST_ROOT/bin" "$TEST_ROOT/work"
export HOME="$TEST_ROOT/home"
export GNUPGHOME="$TEST_ROOT/gnupg"
export VIM_GPG_TEST_ROOT="$TEST_ROOT"
export VIM_GPG_PLUGIN_ROOT="$PLUGIN_ROOT"
export VIM_GPG_REAL_GPG="$(command -v gpg)"
gpg_agent_ready=false
for _ in 1 2 3 4 5 6 7 8 9 10; do
  gpgconf --launch gpg-agent >/dev/null 2>&1 || true
  if gpg-connect-agent /bye >/dev/null 2>&1; then
    gpg_agent_ready=true
    break
  fi
  sleep 0.1
done
$gpg_agent_ready || {
  printf '[ERROR] Vim GPG tests could not start gpg-agent\n' >&2
  exit 1
}

cat >"$TEST_ROOT/key.conf" <<'EOF'
Key-Type: RSA
Key-Length: 2048
Name-Real: Vim GPG Test
Name-Email: vim-gpg@example.invalid
Expire-Date: 0
%no-protection
%commit
EOF
gpg --batch --quiet --generate-key "$TEST_ROOT/key.conf"
VIM_GPG_TEST_RECIPIENT="$(gpg --batch --with-colons --list-secret-keys \
  | awk -F: '$1 == "fpr" { print $10; exit }')"
export VIM_GPG_TEST_RECIPIENT

cat >"$TEST_ROOT/bin/gpg" <<'EOF'
#!/usr/bin/env sh
if [ "${VIM_GPG_TEST_FAIL:-0}" = 1 ]; then
  for argument do
    [ "$argument" = --encrypt ] && exit 70
  done
fi
if [ "${VIM_GPG_TEST_INVALID:-0}" = 1 ]; then
  for argument do
    if [ "$argument" = --encrypt ]; then
      cat >/dev/null
      printf 'not encrypted\n'
      exit 0
    fi
  done
fi
if [ "${VIM_GPG_TEST_SWAP_ON_DECRYPT:-0}" = 1 ]; then
  for argument do
    if [ "$argument" = --decrypt ]; then
      cp -- "$VIM_GPG_TEST_SWAP_SOURCE" "$VIM_GPG_TEST_SWAP_TARGET"
      break
    fi
  done
fi
exec "$VIM_GPG_REAL_GPG" "$@"
EOF
chmod +x "$TEST_ROOT/bin/gpg"
export PATH="$TEST_ROOT/bin:$PATH"

printf 'alpha\nbeta\n' >"$TEST_ROOT/work/source.txt"
gpg --batch --yes --trust-model always --armor \
  --recipient "$VIM_GPG_TEST_RECIPIENT" \
  --output "$TEST_ROOT/work/existing.gpg.txt" \
  --encrypt "$TEST_ROOT/work/source.txt"
chmod 0640 "$TEST_ROOT/work/existing.gpg.txt"
printf 'not ciphertext\n' >"$TEST_ROOT/work/invalid.gpg.txt"

printf 'race version A\n' >"$TEST_ROOT/work/race-a.txt"
printf 'race version B\n' >"$TEST_ROOT/work/race-b.txt"
gpg --batch --yes --trust-model always --armor \
  --recipient "$VIM_GPG_TEST_RECIPIENT" \
  --output "$TEST_ROOT/work/race.gpg.txt" \
  --encrypt "$TEST_ROOT/work/race-a.txt"
gpg --batch --yes --trust-model always --armor \
  --recipient "$VIM_GPG_TEST_RECIPIENT" \
  --output "$TEST_ROOT/work/race-replacement.gpg.txt" \
  --encrypt "$TEST_ROOT/work/race-b.txt"

cp "$TEST_ROOT/work/existing.gpg.txt" "$TEST_ROOT/work/symlink-a.gpg.txt"
cp "$TEST_ROOT/work/race-replacement.gpg.txt" "$TEST_ROOT/work/symlink-b.gpg.txt"
ln -s symlink-a.gpg.txt "$TEST_ROOT/work/file-link.gpg.txt"
mkdir "$TEST_ROOT/work/parent-a" "$TEST_ROOT/work/parent-b"
cp "$TEST_ROOT/work/existing.gpg.txt" "$TEST_ROOT/work/parent-a/parent.gpg.txt"
cp "$TEST_ROOT/work/race-replacement.gpg.txt" "$TEST_ROOT/work/parent-b/parent.gpg.txt"
ln -s parent-a "$TEST_ROOT/work/parent-link"

if ! vim -Nu NONE -i NONE -es -V1"$TEST_ROOT/vim.log" \
  -S "$PLUGIN_ROOT/test/test.vim"; then
  cat -- "$TEST_ROOT/vim.log" >&2
  exit 1
fi
