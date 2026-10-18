# Vim

Terminal Vim 8.2.2957+ on macOS and Ubuntu. Install Git for plugin downloads,
then run from the repository root to deploy and install the pinned plugins:

```sh
./install.sh install vim
vim +PlugInstall
```

## Configuration

Use `mso` to reload the configuration and the current buffer's filetype after
configuration changes. Restart Vim after changing plugin installation or lifecycle.

Local plugins have their own usage instructions under `pack/local/start`.
Set their configuration variables in `plugins.vim`. The GPG recipient can also
be set with `VIM_GPG_RECIPIENT` in the environment before Vim starts.

The personal note and task shortcuts use `NOTES_FILE` and `TODOS_FILE`, defaulting
to `~/notes.md` and `~/todos.md`. Their parent directories must exist. The task
shortcut activates Achiever after opening the file.

See the [mapping guide](MAPPINGS.md) for the mapping model
and remapping examples. Namespace help lists the current bindings.
Wrapping is off by default; `glwr` toggles it in the current window.

Markdown remains the file format. [Noesis](pack/local/start/noesis/README.md)
provides the note environment for Markdown beneath a directory named `noesis`
(case-insensitive), or all Markdown when its global activation option is enabled.
Other Markdown files keep Vim's standard behavior. [Achiever](pack/local/start/achiever/README.md)
adds optional task editing to either environment. See [GPG](pack/local/start/gpg/README.md)
for encrypted editing.

## Navigation and search

File searches use Vim's working directory. `sf` opens native `:find` with an
empty query. Type a filename prefix or a pattern such as `*.md`, then use Tab
to select a match before pressing Enter. `ssf`, `shf`, and `svf` use the same
search with forced editing or a split. Use `:lcd %:p:h` to search from the
current file's directory. `sr` starts fzf and `sR` opens its command line for
options. Install `fzf` 0.53.0 or newer on
`PATH` for interactive file search; see the
[fzf Vim documentation](https://github.com/junegunn/fzf/blob/master/README-VIM.md)
for available options. Press `?` in netrw for
[usage notes](usage/netrw.txt).

`:grep pattern` uses ripgrep (`rg`) and respects project ignore files. Optional
project tags can be generated with `ctags -R .`.

Install `ansible-doc` on `PATH` for documentation in YAML files. `K` looks up
the keyword under the cursor; `gK` looks up a module, including its full
collection name when the cursor is on any part of it. A missing entry stays
silent. Documentation opens in a temporary split; press `q` to close it.
Other YAML files can use the same shortcuts without enabling Ansible
linting or a language server.

ALE runs the linters selected in `plugins.vim` when a supported file opens or
is saved. Install those tools on `PATH`. Run `:ALEFix` for manual formatting;
YAML formatting requires a project yamlfmt configuration. `:ALEInfo` shows the
active tools. `.tf` always means Terraform here, including new files. Run
`terraform validate` and `systemd-analyze verify` manually
from the appropriate project or system context.

Install `terraform-ls` for Terraform or `ansible-language-server` for Ansible
on `PATH` when needed. Run `:TerraformLSP` in a Terraform buffer or
`:AnsibleLSP` in a YAML buffer to enable its server for that buffer. Other YAML
buffers keep their normal linting. Vim's omni completion (`Ctrl-X Ctrl-O`) uses
the server once active. `:ALEDisableBuffer` suspends ALE in the current buffer;
`:ALEEnableBuffer` resumes it. `<Leader>al` runs `:ALELint` immediately; normal
linting already runs on file open and save.

## Git changes

GitGutter compares buffers with `HEAD`, so signs include both staged and
unstaged changes without distinguishing them. Its hunk staging and undo
commands require an index-based diff; use Git directly for those operations.
Use `:map <Leader>g` to discover Git shortcuts. Line blame shows the last
commit's author, date, title, and abbreviated hash; uncommitted lines have no
committed attribution.

## LLM text actions

`gllm` opens a menu of `llm-text` actions. Option `0` accepts a free-form
prompt and opens its answer in a temporary split. Other choices prompt for
text to process. Refinement and translation append text below the current
line; word-list actions show a dismissible popup and accept an optional
leading count, such as `-5 example`. Submitted text goes to the configured
`llm` provider.

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
Sensitive buffers are excluded from persistent undo, GitGutter, and automatic
integrations.
Queued ALE linting is refused if its target buffer has become sensitive, even
when another buffer is current.

To update a third-party plugin, review the upstream commit, change its pin in
`plugins.vim`, run `:PlugUpdate`, then run `./install.sh check`.
