#  @filename  install.sh
#  @created   230523 14:49:45  by  cvidon@e3r2p17.clusters.42paris.fr
#  @updated   230523 14:49:45  by  cvidon@e3r2p17.clusters.42paris.fr
#  @author    Clément Vidon

#!/bin/zsh

# vim
if [ -f $HOME/.vimrc ]; then
	rm -i $HOME/.vimrc
fi
echo "source $(dirname -- "$(readlink -f "${BASH_SOURCE}")")/init/init.vim" > $HOME/.vimrc
echo "~/.vimrc created:"
cat $HOME/.vimrc

# nvim
if [ -f $HOME/.config/nvim/init.vim ]; then
	rm -i $HOME/.vimrc
fi
mkdir -p $HOME/.config/nvim
echo "source $(dirname -- "$(readlink -f "${BASH_SOURCE}")")/init/init.vim" > $HOME/.config/nvim/init.vim
echo "~/.config/nvim/init.vim created:"
cat $HOME/.config/nvim/init.vim
