# Vim

Terminal Vim 8.2.0807+ on macOS and Ubuntu. Install Git for plugin downloads,
then run from the repository root to deploy and install the pinned plugins:

```sh
./install.sh install vim
vim +PlugInstall
```

## Configuration

`.vimrc` contains core settings, [plugins.vim](plugins.vim) configures plugins,
and [mappings.vim](mappings.vim) contains general key bindings. The leader key
is Space; the local leader is `gh`. Restart Vim after configuration changes.

Local plugins have their own usage instructions under `pack/local/start`.
Set their configuration variables in `plugins.vim`, including the GPG recipient
and note export author when using those features.

## Dates

`glpd` opens a date menu in any buffer. Press `1` through `4` to insert the
chosen format below the current line, without pressing Enter; `Esc` cancels.
You can type the sequence directly, such as `glpd1`. The menu shows the current
local date and time; weekday and month names follow Vim's locale.

| Choice | Example |
| --- | --- |
| `1` | `Sun 27 Sep 2026` |
| `2` | `260927` |
| `3` | `Sun 27 Sep 2026 at 20:17` |
| `4` | `260927201710` |

## Search and formatting

`:find` searches below the working directory. Use `:lcd %:p:h` to search from
the current file's directory. `:grep pattern` uses ripgrep (`rg`) and respects
project ignore files. Optional project tags can be generated with `ctags -R .`.

ALE runs the linters selected in `plugins.vim` when a supported file opens or
is saved. Install those tools on `PATH`. Run `:ALEFix` for manual formatting;
YAML formatting requires a project yamlfmt configuration. `:ALEInfo` shows the
active tools. Run `terraform validate` and `systemd-analyze verify` manually
from the appropriate project or system context.

## Clipboard

Install the helper and keep `~/.local/bin` on `PATH`:

```sh
./install.sh install scripts
printf 'example' | clipboard copy
clipboard paste
```

Local access uses macOS clipboard tools, `wl-clipboard`, or `xclip`. Over SSH,
copy uses OSC 52 and requires terminal support; paste through the client
terminal. For tmux, deploy the `tmux` package and reload it with
`tmux source-file ~/.tmux.conf` in each nested server; the helper requires
tmux 3.2+ for clipboard forwarding. Copies can persist in tmux buffers and
Vim's `system()` temporary files.

## State and plugin updates

State lives under `$XDG_STATE_HOME/vim` (default `~/.local/state/vim`), and
plugin downloads under `$XDG_DATA_HOME/vim` (default `~/.local/share/vim`).
Persistent undo requires a writable `undo` directory with mode `0700`;
otherwise it is disabled until the directory is fixed and Vim is reloaded.
Sensitive buffers are excluded from persistent undo and automatic integrations.

To update a third-party plugin, review the upstream commit, change its pin in
`plugins.vim`, run `:PlugUpdate`, then run `./install.sh check`.
