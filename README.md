# Config

Dotfiles for macOS and Ubuntu, deployed into `$HOME` with
[GNU Stow](https://www.gnu.org/software/stow/).

## Install

Install GNU Stow (`brew install stow` on macOS, `sudo apt install stow` on
Ubuntu), then run these commands from the cloned repository:

```sh
./install.sh list                     # discover available packages
./install.sh --dry-run                # preview the default installation
./install.sh                         # install all packages for this platform
```

To select packages:

```sh
./install.sh install zsh git tmux
./install.sh remove zsh git tmux
```

The installer deploys configuration; install the applications separately.
If an existing file blocks installation, move it aside and rerun the command.
Keep the repository in place: the installed links point into it.
See `./install.sh --help` for options.

## Local shell settings

Bash and interactive Zsh load `~/.shellrc.private` for secrets, followed by
`~/.shellrc.local` for machine-specific overrides. Both files are optional and
use shell syntax. Export variables needed by applications, for example:

```sh
export NOESIS_ROOT="$HOME/noesis"
export NOTES_FILE="$NOESIS_ROOT/Inbox/inbox.md"
export TODOS_FILE="$NOESIS_ROOT/Achiever/achiever.md"
```

Keep private settings out of the repository. Local settings are not loaded by
non-interactive shells; configure their environment separately when needed.
See the [Vim configuration](stow/vim/.vim/README.md) for note and task paths.

## Layout

- `stow/<package>/`: configuration paths relative to `$HOME`.
- `assets/`: bundled assets used by the installer.
- `exports/`: application exports with [manual restore instructions](exports/README.md).
- `scripts/`: repository maintenance commands.

For example, `stow/zsh/.zshrc` is linked to `~/.zshrc`: edits to the source are
reflected through that link. Tool-specific usage lives alongside its configuration.

See the [Vim mapping guide](stow/vim/.vim/MAPPINGS.md) for keyboard namespaces and
plugin shortcuts.

## Contribute

Add a package under `stow/<package>/`, mirroring its destination paths below
`$HOME`. The installer discovers packages automatically.

Run the checks and preview deployment:

```sh
./install.sh check
./install.sh --dry-run
git diff --check
```

Checks cover configuration syntax and isolated installation/removal. Missing
optional tools are reported as skips; CI runs the same checks on both platforms.

To enable fast checks before each commit:

```sh
git config core.hooksPath .githooks
```
