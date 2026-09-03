# Config

Personal dotfiles for macOS and Ubuntu, deployed with
[GNU Stow](https://www.gnu.org/software/stow/).

The repository installs configuration files, not the applications they target.
Platform differences stay close to the relevant configuration.

## Install

Preview the default installation:

```bash
./install.sh --dry-run
```

Install every package supported by the current platform:

```bash
./install.sh
```

Install or remove selected packages:

```bash
./install.sh install zsh git tmux
./install.sh remove zsh git tmux
```

The installer can install GNU Stow through Homebrew or APT after confirmation.
It never overwrites an unknown user file.

Useful commands:

```bash
./install.sh list
./install.sh check
./scripts/set-login-shell.sh
```

## External tools

`install.sh` deploys configuration; selecting `vim`, `tmux` or another package
does not install the application with the same name. The only things it can
provision are GNU Stow (after confirmation) and the bundled font.

Configuration targets:

| Stow package | Required application |
| --- | --- |
| `bash` | Bash |
| `zsh` | Zsh |
| `git` | Git |
| `tmux` | tmux |
| `vim` | Vim |
| `ideavim` | a JetBrains IDE with the IdeaVim plugin |
| `alacritty` | Alacritty and tmux |
| `wezterm` | WezTerm and tmux |
| `karabiner` (macOS) | Karabiner-Elements |
| `clang-format` | clang-format |
| `x11` (Ubuntu) | an X11 session or tools that read `.Xresources` |
| `scripts` | Bash; individual commands have the optional dependencies below |

Install the applications you choose with Homebrew on macOS or APT/Snap on
Ubuntu before or after running `install.sh`. There is deliberately no hidden
`resolve_packages()` application provisioning: that function only resolves
which configuration packages Stow will deploy.

Optional integrations referenced by the shell configuration and personal
commands are:

- `ag`, Neovim, Terraform, ImageMagick, NVM/Node.js, kubectl, minikube and VS
  Code for their corresponding aliases or helper functions;
- `pbcopy` (included with macOS), `wl-copy` or `xclip` for clipboard support in
  tmux and `copy`;
- `age` for `encrypt-this`, with `pass` and `age-keygen` when using a key from
  the password store;
- GNU `coreutils` and GNU `tar` for the currently Linux-oriented backup
  commands.

The Zsh LLM helpers use Simon Willison's
[LLM CLI](https://github.com/simonw/llm). It is the sole optional application
with a repository installer because the helpers depend on it and its `uv`
installation is the same on both supported platforms:

```bash
./scripts/install-llm.sh
llm keys set openai
```

All other external tools remain explicit, user-selected prerequisites.

## Layout

```text
config/
├── stow/       files deployed into $HOME, grouped by tool
├── assets/     binary assets used during installation
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
is installed only on macOS; `x11` is installed only on Ubuntu.

The bundled font is installed in `~/Library/Fonts` on macOS and
`~/.local/share/fonts` on Ubuntu.

## Add a package

1. Create `stow/<tool>/`.
2. Mirror the exact destination path below it.
3. Add the package to `resolve_packages()`, `list_packages()` and the checks.
4. Run `./install.sh check` and `./install.sh --dry-run`.

Do not store caches, secrets, generated state or downloaded plugin clones in
`stow/`.
