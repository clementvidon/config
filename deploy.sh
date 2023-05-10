#!/bin/zsh
# @file     deploy.sh
# @brief    Configuration deployment script.
# @author   clemedon (Clément Vidon)

if command -v zsh &> /dev/null; then
    ln -fsv $HOME/git/config/.zshrc                     $HOME/.zshrc
    ln -fsv $HOME/git/config/.zshenv                    $HOME/.zshenv
fi

if command -v bash &> /dev/null; then
    ln -fsv $HOME/git/config/.bashrc                    $HOME/.bashrc
fi

mkdir -pv $HOME/.fonts
ln -fsv $HOME/git/config/.fonts/*.ttc                   $HOME/.fonts/
mkdir -pv $HOME/.icons
ln -fsv $HOME/git/config/.icons/*                       $HOME/.icons/
mkdir -pv $HOME/.local/script
ln -fsv $HOME/git/config/.local/script/*                $HOME/.local/script/

if command -v git &> /dev/null; then
    ln -fsv $HOME/git/config/.gitmessage                $HOME/.gitmessage
    ln -fsv $HOME/git/config/.gitconfig                 $HOME/.gitconfig
    ln -fsv $HOME/git/config/.gitignore                 $HOME/.gitignore
fi

if command -v tmux &> /dev/null; then
    ln -fsv $HOME/git/config/.tmux.conf                 $HOME/.tmux.conf
fi

if command -v alacritty &> /dev/null; then
    mkdir -pv $HOME/.config/alacritty/colors
    ln -fsv $HOME/git/config/alacritty/*.yml            $HOME/.config/alacritty/
    ln -fsv $HOME/git/config/alacritty/colors/*.yml     $HOME/.config/alacritty/colors
fi

if command -v i3 &> /dev/null; then
    mkdir -pv $HOME/.config/i3/
    mkdir -pv $HOME/.local/script/i3
    ln -fsv $HOME/git/config/.local/script/i3/*         $HOME/.local/script/i3
    ln -fsv $HOME/git/config/i3/config                  $HOME/.config/i3/
    ln -fsv $HOME/git/config/.xinitrc                   $HOME/.xinitrc
    ln -fsv $HOME/git/config/.Xresources                $HOME/.Xresources
fi

if command -v clang-format &> /dev/null; then
    ln -fsv $HOME/git/config/.clang-format              $HOME
fi

if command -v vim &> /dev/null; then
    mkdir -pv $HOME/.config/vim/autoload
    mkdir -pv $HOME/.config/vim/autoload/plugin
    mkdir -pv $HOME/.config/vim/after/ftplugin
    mkdir -pv $HOME/.config/vim/syntax
    ln -fsv $HOME/git/config/.vimrc                     $HOME/.vimrc
    ln -fsv $HOME/git/config/vim/*.vim                  $HOME/.config/vim/
    ln -fsv $HOME/git/config/vim/autoload/plug.vim      $HOME/.config/vim/autoload/plug.vim
    ln -fsv $HOME/git/config/vim/autoload/plugin/*.vim  $HOME/.config/vim/autoload/plugin/
    ln -fsv $HOME/git/config/vim/after/ftplugin/*.vim   $HOME/.config/vim/after/ftplugin/
    ln -fsv $HOME/git/config/vim/syntax/*.vim           $HOME/.config/vim/syntax/
fi

echo ""
echo ">>> Config is installed!"
echo ">>> Do not forget to run:"
echo "zsh"
echo "source ~/.zshrc"
echo "source ~/.zshenv"
echo "vim -c ':PlugInstall'"
