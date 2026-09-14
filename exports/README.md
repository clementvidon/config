# Exports

Application backups kept as references and never deployed by GNU Stow. These
are manual exports: creating, reviewing and restoring them are all manual
operations.

- `keyboard/`: keyboard configuration export;
- `ubuntu/`: Ubuntu and GNOME settings export.

Review every export before importing it on another machine. It may contain
host-specific paths or values.

## Restore GNOME settings

From an active GNOME session, without `sudo`, save the current settings and
then import the Ubuntu export:

```bash
dconf dump / > ~/ubuntu-settings-before-import.conf
dconf load / < exports/ubuntu/ubuntu-settings-backup.conf
```

Install `dconf-cli` first if `dconf` is unavailable.
