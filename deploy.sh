#!/bin/bash
# @file     deploy.sh
# @brief    Configuration deployment script.
# @author   clemedon (Clément Vidon)

mkdir -pv $HOME/.fonts
ln -fsv $HOME/git/config/.fonts/*.ttc                   $HOME/.fonts/
mkdir -pv $HOME/.icons
ln -fsv $HOME/git/config/.icons/*                       $HOME/.icons/

if command -v git &> /dev/null; then
    ln -fsv $HOME/git/config/.gitmessage                $HOME/.gitmessage
    ln -fsv $HOME/git/config/.gitconfig                 $HOME/.gitconfig
    ln -fsv $HOME/git/config/.gitignore                 $HOME/.gitignore
fi

if command -v zsh &> /dev/null; then
    ln -fsv $HOME/git/config/.zshrc                     $HOME/.zshrc
    ln -fsv $HOME/git/config/.zprofile                  $HOME/.zprofile
fi

if command -v bash &> /dev/null; then
    ln -fsv $HOME/git/config/.bashrc                    $HOME/.bashrc
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
    ln -fsv $HOME/git/config/i3/config                  $HOME/.config/i3/
    ln -fsv $HOME/git/config/.xinitrc                   $HOME/.xinitrc
    ln -fsv $HOME/git/config/.Xresources                $HOME/.Xresources
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
    vim -c ':PlugInstall'
fi
