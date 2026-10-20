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

Stow installs the user configuration under `~/.config/Code/User/`. On macOS,
move aside existing `settings.json` and `keybindings.json` in
`~/Library/Application Support/Code/User/`, then link those paths to their
counterparts in `~/.config/Code/User/`.
