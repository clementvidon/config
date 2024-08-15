#!/bin/zsh
# @file     deploy.sh
# @brief    Configuration deployment script.
# @author   clemedon (Clément Vidon)

echo "Before to continue, make sure that 'config/' is located in '~/git/' directory."
read -p "Continue? y/n " choice
if [[ "$choice" == "n" ]]; then
    exit 0
fi

#if command -v bash &> /dev/null; then
#    {
#        ln -fsv "$HOME/git/config/.bashrc"                    "$HOME/.bashrc"
#    } 1>/dev/null
#    echo "bash         OK"
#fi

if command -v zsh &> /dev/null; then
    {
#        ln -fsv "$HOME/git/config/.ideavim"                   "$HOME/.ideavim"
        ln -fsv "$HOME/git/config/.zshrc"                     "$HOME/.zshrc"
        ln -fsv "$HOME/git/config/.zshenv"                    "$HOME/.zshenv"
        mkdir -pv "$HOME/.local/script"
        ln -fsv "$HOME/git/config/.local/script/"*            "$HOME/.local/script/"
    } 1>/dev/null
    echo "zsh          OK"
fi

if command -v git &> /dev/null; then
    {
        ln -fsv "$HOME/git/config/.gitmessage"                "$HOME/.gitmessage"
        ln -fsv "$HOME/git/config/.gitconfig"                 "$HOME/.gitconfig"
        ln -fsv "$HOME/git/config/.gitignore"                 "$HOME/.gitignore"
    } 1>/dev/null
    echo "git          OK"
fi

if command -v tmux &> /dev/null; then
    {
        ln -fsv "$HOME/git/config/.tmux.conf"                 "$HOME/.tmux.conf"
    } 1>/dev/null
    echo "tmux         OK"
fi

if command -v alacritty &> /dev/null; then
    {
        mkdir -pv "$HOME/.fonts"
        ln -fsv "$HOME/git/config/.fonts/"*.ttc               "$HOME/.fonts/"
        mkdir -pv "$HOME/.config/alacritty/colors"
        ln -fsv "$HOME/git/config/alacritty/"*.toml           "$HOME/.config/alacritty/"
        ln -fsv "$HOME/git/config/alacritty/colors/"*.toml    "$HOME/.config/alacritty/colors/"
    } 1>/dev/null
    echo "alacritty    OK"
fi

#if command -v i3 &> /dev/null; then
#    {
#        ln -fsv "$HOME/git/config/.xinitrc"                   "$HOME/.xinitrc"
#        ln -fsv "$HOME/git/config/.Xresources"                "$HOME/.Xresources"
#        mkdir -pv "$HOME/.config/i3/"
#        ln -fsv "$HOME/git/config/i3/config"                  "$HOME/.config/i3/"
#        mkdir -pv "$HOME/.local/script/i3"
#        ln -fsv "$HOME/git/config/.local/script/i3/"*         "$HOME/.local/script/i3/"
#        mkdir -pv "$HOME/.icons"
#        ln -fsv "$HOME/git/config/.icons/"*                   "$HOME/.icons/"
#    } 1>/dev/null
#    echo "i3           OK"
#fi

if command -v vim &> /dev/null || command -v nvim &> /dev/null; then
    {
        bash vim/vimrc_gen.sh
    } 1>/dev/null
    vim -c ':PlugUpdate | :q | :q'
    echo "vim          OK"
fi

#if command -v clang-format &> /dev/null; then
#    {
#        echo "1"
#        mkdir -pv "$HOME/.config/clang-format/"
#        echo "2"
#        ln -fsv "$HOME/git/config/clang-format/".clang-format-* "$HOME/.config/clang-format/"
#        echo "3"
#        echo "clang-format OK"
#        echo "4"
#    } 1>/dev/null
#fi
echo "Installation DONE"
