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

## Add a package

1. Create `stow/<tool>/`.
2. Mirror the exact destination path below it.
3. Run `./install.sh check` and `./install.sh --dry-run`.

Do not store caches, secrets, generated state or downloaded plugin clones in
`stow/`.
