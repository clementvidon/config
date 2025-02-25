#  @filename  install.sh
#  @created   230523 14:49:45  by  cvidon@e3r2p17.clusters.42paris.fr
#  @updated   230524 14:05:51  by  clem9nt@imac
#  @author    Clément Vidon

#!/bin/zsh

if [[ "$(uname -s)" == "Darwin" ]]; then
	VIMPATH="config/vim"
else
	VIMPATH=$(realpath --relative-to="$HOME" $(dirname -- "${BASH_SOURCE:-$0}"))
fi

# vim
if [ -f $HOME/.vimrc ]; then
	rm -i $HOME/.vimrc
fi
echo "source \$HOME/$VIMPATH/init.vim" > $HOME/.vimrc
echo "~/.vimrc created:"
cat $HOME/.vimrc

# nvim
# if [ -f $HOME/.config/nvim/init.vim ]; then
# 	rm -i $HOME/.config/nvim/init.vim
# fi
# mkdir -p $HOME/.config/nvim
# echo "source \$HOME/$VIMPATH/init.vim" > $HOME/.config/nvim/init.vim
# echo "~/.config/nvim/init.vim created:"
# cat $HOME/.config/nvim/init.vim
