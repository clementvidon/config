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

Common packages are `bash`, `zsh`, `git`, `tmux`, `vim`, `ideavim`,
`alacritty`, `wezterm`, `clang-format` and `scripts`. The `karabiner` package
is deployed only on macOS.

The `scripts` package installs these personal commands in `~/.local/bin`:

| Command | Purpose |
| --- | --- |
| `backup-all` | Build and publish verified encrypted backups |
| `copy` | Copy labeled file contents to the clipboard |
| `encrypt-this` | Create and verify one age-encrypted archive |
| `sendkey` | Send one literal command to a tmux pane |
| `sshagent` | Reuse or start a persistent SSH agent |
| `tjm` | Estimate gross freelance daily and hourly rates |

Every command supports `-h` and `--help`.

The default deployment includes the `fonts` package, which links the bundled
font into `~/Library/Fonts` on macOS and
`~/.local/share/fonts` on Ubuntu.

## Add a package

1. Create `stow/<tool>/`.
2. Mirror the exact destination path below it.
3. Add the package to the package lists in `install.sh` and to the checks.
4. Run `./install.sh check` and `./install.sh --dry-run`.

Do not store caches, secrets, generated state or downloaded plugin clones in
`stow/`.
