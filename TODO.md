# TODO

- Create a `config_init.sh` script which clone the repos, install the packages
  etc. deploy with:

```bash
git clone git@github.com:clementvidon/config.git $HOME/config && cd !$
curl -o- https://raw.githubusercontent.com/clementvidon/config/deploy.sh | bash
```
