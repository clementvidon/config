# VS Code

This configuration is intended for Vim users in both the editor and the
integrated terminal. Install [VSCodeVim](https://github.com/VSCodeVim/Vim)
for modal editing in the editor. Its key handling determines which shortcuts
belong to Vim and which remain available to VS Code.

Terminal applications use their own configurations. VS Code's
[`terminal.integrated.commandsToSkipShell`](https://code.visualstudio.com/docs/terminal/advanced#_keyboard-shortcuts-and-the-shell)
controls which shortcuts VS Code intercepts while the terminal has focus.
Release application shortcuts there; keep any necessary explicit forwarding
in the terminal's keybindings. Vim and shell configurations remain independent
of VS Code.

Use **Developer: Toggle Keyboard Shortcuts Troubleshooting** to see which
command receives a key. If VS Code never receives it, inspect the operating
system's shortcuts and keyboard remapping tools.

## Remote terminals and tmux

In a [Remote SSH terminal](https://code.visualstudio.com/docs/remote/ssh#_opening-a-terminal-on-a-remote-host),
the `code` CLI opens remote files and folders in the connected editor.

Persistent tmux sessions can retain a connection to a closed VS Code window.
Deploy the tmux package and reload configuration changes with
`tmux source-file ~/.tmux.conf`. After reconnecting VS Code, attach to the
session from a fresh integrated terminal. New panes inherit the refreshed
editor connection. Existing shells retain their environment; refresh the
current shell after reattaching:

```sh
eval "$(tmux show-environment -s VSCODE_IPC_HOOK_CLI)"
```

## Deployment

Stow installs the user configuration under `~/.config/Code/User/`. On macOS,
move aside existing `settings.json` and `keybindings.json` in
`~/Library/Application Support/Code/User/`, then link those paths to their
counterparts in `~/.config/Code/User/`.
