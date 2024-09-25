#!/bin/zsh
# @file     deploy.sh
# @brief    Configuration deployment script.
# @author   clemedon (Clément Vidon)

echo "Before to continue, make sure that 'config/' is located in your home directory."
read -p "Continue? y/n " choice
if [[ "$choice" == "n" ]]; then
    exit 0
fi

if command -v bash &> /dev/null; then
    {
        ln -fsv "$HOME/config/.bashrc"                    "$HOME/.bashrc"
    } 1>/dev/null
    echo "bash         OK"
fi

if command -v zsh &> /dev/null; then
    {
#        ln -fsv "$HOME/config/.ideavim"                   "$HOME/.ideavim"
        ln -fsv "$HOME/config/.zshrc"                     "$HOME/.zshrc"
        ln -fsv "$HOME/config/.zshenv"                    "$HOME/.zshenv"
        mkdir -pv "$HOME/.local/script"
        ln -fsv "$HOME/config/.local/script/"*            "$HOME/.local/script/"
    } 1>/dev/null
    echo "zsh          OK"
fi

if command -v git &> /dev/null; then
    {
        ln -fsv "$HOME/config/.gitmessage"                "$HOME/.gitmessage"
        ln -fsv "$HOME/config/.gitconfig"                 "$HOME/.gitconfig"
        ln -fsv "$HOME/config/.gitignore"                 "$HOME/.gitignore"
    } 1>/dev/null
    echo "git          OK"
fi

if command -v tmux &> /dev/null; then
    {
        ln -fsv "$HOME/config/.tmux.conf"                 "$HOME/.tmux.conf"
    } 1>/dev/null
    echo "tmux         OK"
fi

if command -v alacritty &> /dev/null; then
    {
        mkdir -pv "$HOME/.fonts"
        ln -fsv "$HOME/config/.fonts/"*.ttc               "$HOME/.fonts/"
        mkdir -pv "$HOME/.config/alacritty/colors"
        ln -fsv "$HOME/config/alacritty/"*.toml           "$HOME/.config/alacritty/"
        ln -fsv "$HOME/config/alacritty/colors/"*.toml    "$HOME/.config/alacritty/colors/"
    } 1>/dev/null
    echo "alacritty    OK"
fi

if command -v vim &> /dev/null || command -v nvim &> /dev/null; then
    {
        bash vim/vimrc_gen.sh
    } 1>/dev/null
    vim -c ':PlugUpdate | :q | :q'
    echo "vim          OK"
fi

echo "Installation DONE"
