<h1 align="center">
	CONFIG
</h1>

<h3 align="center">
	<a href="#Summary">Summary</a>
	<span> · </span>
	<a href="#Prereq">Summary</a>
	<span> · </span>
	<a href="#Usage">Usage</a>
	<span> · </span>
	<a href="#Tester">Tester</a>
	<span> · </span>
	<a href="#Misc">Tools</a>
</h3>

## Summary

The configuration of my everyday tools.

## Prereq

Install Zsh and Tmux

``` bash
sudo apt update
sudo apt install zsh tmux
```

Build Alacritty

``` bash
# install deps
sudo apt update
sudo apt install rustup
rustup override set stable
rustup update stable
apt install cmake pkg-config libfreetype6-dev libfontconfig1-dev libxcb-xfixes0-dev libxkbcommon-dev python3
# clone the repo
git clone https://github.com/alacritty/alacritty.git && cd alacritty
# build
cargo build --release

echo "\nPost Build:"
echo "https://github.com/alacritty/alacritty/blob/master/INSTALL.md#post-build"
```

Build Vim

``` bash
# install deps
sudo apt install git make clang libtool-bin python3-dev
# clone the repo
git clone https://github.com/vim/vim.git && cd vim
# configure
./configure --with-features=huge --enable-python3interp=yes --with-python3-config-dir=$(python3-config --configdir) --prefix=/usr/local
# build
make && sudo make install
```

## Usage

```bash
bash deploy.sh
```

## Misc

[Iosevka Customizer](https://typeof.net/Iosevka/customizer)
