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

Keep extensible choices in native options or data lists. A new tool or language
should not require another branch in a custom function. Prefer functions whose
decisions can be separated from editor state changes when that keeps them clear.

Local plugins have their own usage instructions under `pack/local/start`.
Set their configuration variables in `plugins.vim`. The GPG recipient can also
be set with `VIM_GPG_RECIPIENT` in the environment before Vim starts.

The personal note and task shortcuts use `NOTES_FILE` and `TODOS_FILE`, defaulting
to `~/notes.md` and `~/todos.md`. Their parent directories must exist. The task
shortcut activates Achiever after opening the file.
Set `NOESIS_ROOT` for personal vocabulary files; it defaults to `~/noesis`.

See the [mapping guide](MAPPINGS.md) for the mapping model
and remapping examples. Namespace help shows available actions.
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
[usage notes](usage/netrw.txt). Previews reuse an editing split and preserve
auxiliary windows such as help and terminals.

`:grep pattern` uses ripgrep (`rg`) and respects project ignore files. Optional
project tags can be generated with `ctags -R .`.

Opening a file in VS Code requires its `code` launcher on `PATH`;
see the [command-line setup](https://code.visualstudio.com/docs/configure/command-line#launching-from-command-line).
Use `:map glv` to discover the bindings. VS Code opens the version on disk;
unsaved Vim edits are not written automatically.

## Language tools

In Ansible and Terraform files, `K` requests contextual documentation from the
language server. Install the selected server on `PATH`. Documentation opens
in a bottom preview split with Markdown highlighting and concealed markup.
Focus stays in the source window; use `Ctrl-W P` to enter the preview, then
normal Vim navigation and search. Press `q` there to close it, or use
`:pclose` from the source window. No documentation is shown
when the server has no information at the cursor. For full Ansible module
documentation outside Vim, use `ansible-doc <module>`.

YAML stays generic unless file detection recognizes an Ansible path or a
Kubernetes manifest. Compound filetypes keep YAML support and add the relevant
specialization. Check `:set filetype?`; for an unrecognized Ansible file, use
`:setlocal filetype=yaml.ansible`. Use `yaml` to return to generic YAML.

ALE starts disabled; Space `at` toggles it globally. Once enabled, it runs the
selected linters when a supported buffer is entered or saved. Install those tools
on `PATH`. Start Vim at the project root and check `:pwd`: tools use their
native configuration discovery and defaults.
ALE does not install tools. `:ALEInfo` lists selected integrations separately
from executable checks and command results. Run `:ALEFix` for manual
formatting. Opening an existing file needs no extra save for linting.
File-based linters inspect disk contents, so save subsequent edits before
checking their diagnostics. Other integrations can inspect unsaved contents;
the configured automatic checks run on buffer entry and save.
`.tf` always means Terraform here, including new files. Run `terraform validate`
and `systemd-analyze verify` manually from the appropriate project or system
context.

Generic HCL, including Terragrunt, has its own filetype and highlighting after
plugin installation. These files are not sent to `terraform-ls`, which
[supports Terraform configurations only](https://github.com/hashicorp/terraform-ls/blob/main/docs/USAGE.md).

Install the selected language servers and linters on `PATH`; enabling ALE also
starts the servers applicable to the filetype. Vim's omni completion
(`Ctrl-X Ctrl-O`) uses the server once active. Ansible validation runs through
ALE's ansible-lint integration; server-side validation is disabled to avoid
duplicate diagnostics. Kubernetes files currently use generic YAML tools.
`:ALEDisableBuffer` suspends ALE in the current buffer; `:ALEEnableBuffer`
resumes it. `<Leader>al` requests an immediate lint when ALE is enabled.

## Git changes

GitGutter starts disabled; Space `gt` toggles it for the current buffer.
It compares buffers with `HEAD`, so signs include both staged and
unstaged changes without distinguishing them. Its hunk staging and undo
commands require an index-based diff; use Git directly for those operations.
Use `:map <Leader>g` to discover Git shortcuts. Line blame shows the last
commit's author, date, title, and abbreviated hash; uncommitted lines have no
committed attribution.

Primary-branch comparisons use the saved file on disk. They prefer the local
`main` or `master` branch designated by `origin/HEAD`; otherwise `main` takes
precedence over `master`. A local branch must exist. Unsaved edits are not
written automatically.

## Spelling

Vim needs compiled `.spl` word lists; Hunspell `.aff`/`.dic` pairs are compiled
with [`:mkspell`](https://vimhelp.org/spell.txt.html#spell-mkspell). To install
French from [Grammalecte](https://www.grammalecte.net/) and combined US/GB English
from [ESDB/SCOWL](https://wordlist.aspell.net/dicts/),
run from the repository root:

```sh
./scripts/install-vim-spell.sh
```

Requires Bash, Vim with spell support, `curl`, and `unzip`. Downloads are
temporary; compiled dictionaries go to
`${XDG_DATA_HOME:-$HOME/.local/share}/vim/spell` and take precedence over Vim's
bundled dictionaries. Rerunning replaces the installed French and English
dictionaries. This supplies word spelling and suggestions; grammar checking
requires a separate tool.

For a corporate proxy, configure `https_proxy`; for a corporate certificate
authority, point `CURL_CA_BUNDLE` to the approved CA file before running the
script.

Restart Vim, enable spelling, and inspect the loaded dictionaries:

```vim
:setlocal spell
:spellinfo
```

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
integrations. Plaintext temporary exports of sensitive buffers are refused.
Queued ALE linting is refused if its target buffer has become sensitive, even
when another buffer is current.

To update a third-party plugin, review the upstream commit, change its pin in
`plugins.vim`, run `:PlugUpdate`, then run `./install.sh check`.
