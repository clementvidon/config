# Config

Personal dotfiles for macOS and Ubuntu, deployed with
[GNU Stow](https://www.gnu.org/software/stow/).

External tools are documented alongside the configuration that uses them.
Platform differences stay close to the relevant configuration.

## Deploy

GNU Stow is required.
This repository deploys configuration only; install external tools separately.

Preview the default deployment:

```bash
./install.sh --dry-run
```

Deploy every configuration package supported by the current platform:

```bash
./install.sh
```

Deploy or remove selected configuration packages:

```bash
./install.sh install zsh git tmux
./install.sh remove zsh git tmux
```

Existing unmanaged files are left unchanged.

Installing the `zsh` package does not alter the account login shell. When zsh
is available but not yet the login shell, the installer prints the command to
make that explicit account-level change.

Useful commands:

```bash
./install.sh list
./install.sh check
./scripts/set-login-shell.sh
```

`./install.sh check` runs every structural check available in the local
environment and reports explicit skips for optional tools. CI installs the
security-regression dependencies and the plugin commits declared by Vim, then
runs the same entry point, including the GPG security suite.

Enable the repository's pre-commit checks once after cloning:

```bash
git config core.hooksPath .githooks
```

The hook runs only fast whitespace, layout, and configuration syntax checks.
It never blocks pushes. `./install.sh check` remains the complete validation
used by CI and for manual verification of sensitive or structural changes.

## Layout

```text
config/
├── stow/       files deployed into $HOME, grouped by tool
├── assets/     binary assets used by the configuration
├── exports/    application exports restored manually
├── scripts/    repository maintenance commands
└── install.sh
```

Each Stow package mirrors its destination relative to `$HOME`:

```text
stow/alacritty/.config/alacritty/alacritty.toml
                    ↓
       ~/.config/alacritty/alacritty.toml
```

The installer discovers packages automatically. Karabiner is macOS-only and is
the one non-Stow deployment: its configuration must be a real file for reliable
change detection, while Karabiner's generated files remain in its writable
directory. Its package-level ignore also prevents accidental deployment by a
raw Stow command. The installer copies the repository source and keeps an
ownership snapshot under `~/.local/state/config-installer`; it refuses to
overwrite a configuration changed outside the installer.

The `scripts` package contains small personal commands deployed in
`~/.local/bin`. Checks cover their Stow deployment, not their interfaces or
behavior.

The default deployment includes the `fonts` package, which links the bundled
font into `~/Library/Fonts` on macOS and
`~/.local/share/fonts` on Ubuntu.

## VS Code

The shared settings live in `stow/vscode/.config/Code/User/settings.json`.
`./install.sh install vscode` links them to VS Code's Ubuntu path. On macOS,
VS Code reads a different path; link it to the Stow-managed file after moving
aside any existing settings:

```bash
./install.sh install vscode
mac_settings="$HOME/Library/Application Support/Code/User/settings.json"
if [ -f "$mac_settings" ] && [ ! -L "$mac_settings" ]; then
  mv "$mac_settings" "$mac_settings.before-config"
fi
ln -s "$HOME/.config/Code/User/settings.json" "$mac_settings"
```

Keep project-specific ESLint options in each project's `.vscode/settings.json`.

## Clipboard across local and SSH sessions

Deploy the shared command with the configurations that use it:

```bash
./install.sh install scripts vim tmux
printf 'clipboard example' | clipboard copy
clipboard paste
```

Keep `~/.local/bin` on `PATH`, including in SSH sessions. Vim and `copy` use
`clipboard` for raw clipboard transport. Locally it selects macOS tools,
Wayland tools when `WAYLAND_DISPLAY` is set, X11 `xclip`, then Wayland as a
fallback. Copy falls back to OSC 52 when no desktop provider is installed.

With `SSH_CONNECTION`, `SSH_TTY` or `MOSH_CONNECTION` set, copy always targets
the client via OSC 52, never the remote desktop. Outside tmux it uses `base64`
and the controlling terminal; inside tmux it uses `load-buffer -w` (tmux 3.2+).
tmux copy-mode `y`/`Y` uses native OSC 52 directly. Every intervening tmux server
must load this configuration, and the outer terminal must accept OSC 52 writes.
WezTerm and current Windows Terminal support this; not every terminal does.
For tmux commands with multiple attached clients, clipboard delivery may target
the most recently active client. Avoid this workflow for confidential text.

Remote paste deliberately does not query the client's clipboard: use the
terminal's paste action instead. OSC 52 has no delivery acknowledgement and
terminal-dependent size limits; confirm large copies before relying on them.

`set-clipboard on` allows applications inside tmux to overwrite the clipboard
and create tmux paste buffers. Treat remote output as untrusted and inspect
text before pasting it into a shell. This does not enable clipboard reads.
All copying is explicit, but clipboard contents leave Vim's protection:
`system()` may use temporary files, `copy` builds a temporary labeled document,
and tmux retains copied text in its paste buffers. The raw `clipboard` helper
does not create temporary files itself.

After deployment, restart Vim and reload tmux with `tmux source-file ~/.tmux.conf`.
Detach/reattach if an existing client still has stale terminal capabilities.
No running tmux sessions need to be killed.

## Add a package

1. Create `stow/<tool>/`.
2. Mirror the exact destination path below it.
3. Run `./install.sh check` and `./install.sh --dry-run`.

Do not store caches, secrets, generated state or downloaded plugin clones in
`stow/`.
