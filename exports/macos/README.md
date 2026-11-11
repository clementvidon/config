# Karabiner-Elements

Karabiner-Elements keeps its configuration in a regular file and may update it
while running. Quit the application, then restore this export from the
repository root after installing it:

```sh
mkdir -p "$HOME/.config/karabiner"
install -m 600 exports/macos/karabiner.json \
  "$HOME/.config/karabiner/karabiner.json"
```

Move any existing configuration file or link aside before restoring; a copy
could overwrite local changes. To keep changes made in the application,
copy its current `karabiner.json` back to this export when desired.
