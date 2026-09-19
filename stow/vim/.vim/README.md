# Vim configuration

## Architecture

`.vimrc` owns core options and appearance. `plugins.vim` owns third-party
integrations and declarations; `mappings.vim` holds the other general mappings.

Vim has four filetype levels:

1. Noesis and Achiever own rich, task-specific behavior.
2. Standard filetypes retain Vim's runtime behavior by default. First-party
   overrides are exceptional and must document their reason; quickfix wrapping
   is the current small example.
3. Supported Ops filetypes use Vim's runtime plus the shared ALE interface for
   linting and manual formatting.
4. Unknown filetypes retain the global configuration without additional
   filetype-specific overrides.

Self-contained personal plugins live under `pack/local/start`. Each one owns
its detection, commands, mappings, and documentation so it can later move to a
dedicated repository without changing the rest of the runtime.

## Editing policy

Vim is the lightweight terminal editor; full IDE and code-generation workflows
live elsewhere. Native tags and textual `rg` searches belong in Vim. Language
servers, semantic completion, debugging, refactoring, and rich workspace
navigation do not. Adding an IDE plugin or server requires an explicit new
justification.

An `after/ftplugin` is permitted only when Vim's runtime and ALE cannot express
a needed behavior. It must document that reason. Do not add language-specific
compile, run, test, debugger, snippet, automatic tag generation, LSP,
completion, or automatic-formatting behavior.

## Ops linting and formatting

ALE linting runs when a supported non-sensitive Ops buffer opens, its filetype
changes, or it is saved; it never runs while typing. Formatting is manual.
Terraform formatting is configured without a project config, while YAML
formatting requires a repository yamlfmt configuration. The linter and fixer
selections live in `plugins.vim`.

Automatic integrations must exclude a sensitive buffer where they actually
process or serialize its contents, including work queued before the buffer
became sensitive. This configuration applies that rule to ALE and GitGutter.

Project yamllint and Hadolint configuration is passed explicitly to the
corresponding linter when found inside the repository. Checkmake uses its
defaults because its current ALE integration does not safely quote configured
paths. Project configuration files are trusted as policy, but ALE resolves all
linter and fixer executables from `PATH`; it never runs executables supplied by
the checkout. Systemd files use Vim's runtime; run `systemd-analyze verify`
manually for the appropriate system or user scope. Run `terraform validate`
manually from the project directory; ALE's built-in integration does not bind
that command to the buffer's directory. TFLint does.

## Search and tags

Find searches recursively below Vim's working directory (`:pwd`). Use `:lcd`
to narrow it to a subtree, or `:lcd %:p:h` to start from the current file's
directory. Noesis retains its note-specific search paths. Native find uses
`wildignore`, not `.gitignore`, and does not automatically traverse hidden
directories. Traversal is synchronous and has no configured time limit.

Generate project tags explicitly, for example with optional `universal-ctags`:

```sh
ctags -R .
```

Project grep requires `rg`, includes hidden files such as `.github`, and
excludes VCS, dependency, and build directories. Native find and `:grep` share
their directory exclusions from `.vimrc`; ripgrep also honors project ignore
files. Visual search extracts text without clipboard or yank hooks.

## Persistent undo

Undo history is stored only in `$XDG_STATE_HOME/vim/undo`, defaulting to
`~/.local/state/vim/undo`. The directory is created or corrected to mode
`0700`. If it remains unavailable, Vim silently disables persistent undo for
existing and new buffers; in-memory undo remains available. Fix the directory
and reload to enable persistence again for the current and new buffers;
sensitive buffers remain excluded. Only swap keeps a `/tmp` fallback.

## Reloading

Sourcing `.vimrc` does not reapply ftplugins to the current buffer. Restart Vim
after changes that remove mappings.

## Clipboard

Vim uses `clipboard` from the `scripts` package for explicit copy and local
paste. Remote clipboard reads are unsupported. Clipboard access exports text
outside Vim's persistence protections, and `system()` may use temporary files.
See the [repository clipboard guide](../../../README.md#clipboard-across-local-and-ssh-sessions).

## Dependencies and updates

The configuration targets terminal Vim on Unix-like systems. Windows portability
is not a design goal. Core implementation assumptions include `/bin/sh`, `/tmp`,
and Unix permission bits. Some explicit commands additionally use `tmux`,
`sudo`, macOS or Unix clipboard tools, and Bash for the GPG test harness.

Vim 8.2.0807 or newer is supported. Encrypted files require jobs and channels.
Vim is required. Git is required to install and update plugins. Optional `rg`
enables project and Noesis search. Linters, formatters, `universal-ctags`, and
clipboard providers are also optional and discovered through `$PATH`.

Downloaded vim-plug plugins and generated state are stored outside `~/.vim`.
Declarations pin each plugin to a validated commit. To update deliberately,
choose and review an upstream commit, replace its pin, run `:PlugUpdate`, then
run the repository checks and commit the new hash.
