# Exports

Application settings restored manually, independently of `install.sh`.

## GNOME

Requires `dconf-cli`. Run from the repository root in an active GNOME session,
as the desktop user:

```sh
dconf dump / > ~/ubuntu-settings-before-import.conf
dconf load / < exports/ubuntu/ubuntu-settings-backup.conf
```

The import applies the exported settings, including machine-specific values.
To reapply the values saved in the backup:

```sh
dconf load / < ~/ubuntu-settings-before-import.conf
```
