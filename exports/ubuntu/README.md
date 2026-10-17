# Ubuntu keyboard navigation

On Ubuntu 25.04 or later, install [keyd](https://github.com/rvaiya/keyd) and
enable it from the repository root:

```sh
sudo apt install keyd
sudo mkdir -p /etc/keyd
sudo cp -n exports/ubuntu/keyd.conf /etc/keyd/default.conf
sudo systemctl enable keyd
sudo systemctl restart keyd
```

If `/etc/keyd/default.conf` already exists, merge the configuration instead;
`cp -n` leaves it untouched. Avoid overlapping device matches in `/etc/keyd/`.

If a configuration prevents keyboard use, press Backspace, Escape, and Enter
together to stop keyd. See the keyd documentation for earlier Ubuntu versions.
