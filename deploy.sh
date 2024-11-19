#!/bin/bash
# @file     deploy.sh
# @brief    Configuration deployment script.
# @author   clemedon (Clément Vidon)

echo "Before to continue, make sure that 'config/' is located in your home directory."
read -p "Continue? y/n " choice
if [[ "$choice" == "n" ]]; then
    exit 0
fi

deploy_bash() {
    if command -v bash &> /dev/null; then
        {
            ln -fsv "$HOME/config/.bashrc"                    "$HOME/.bashrc"
        } 1>/dev/null
        echo "bash         OK"
    fi
}

deploy_zsh() {
    if command -v zsh &> /dev/null; then
        {
            sudo chsh -s /usr/bin/zsh clem
            ln -fsv "$HOME/config/.zshrc"                     "$HOME/.zshrc"
            ln -fsv "$HOME/config/.zshenv"                    "$HOME/.zshenv"
            mkdir -pv "$HOME/.local/bin"
            ln -fsv "$HOME/config/.local/bin/"*               "$HOME/.local/bin/"
        } 1>/dev/null
        echo "zsh          OK"
    fi
}

deploy_git() {
    if command -v git &> /dev/null; then
        {
            ln -fsv "$HOME/config/.gitmessage"                "$HOME/.gitmessage"
            ln -fsv "$HOME/config/.gitconfig"                 "$HOME/.gitconfig"
            ln -fsv "$HOME/config/.gitignore"                 "$HOME/.gitignore"
        } 1>/dev/null
        echo "git          OK"
    fi
}

deploy_tmux() {
    if command -v tmux &> /dev/null; then
        {
            ln -fsv "$HOME/config/.tmux.conf"                 "$HOME/.tmux.conf"
        } 1>/dev/null
        echo "tmux         OK"
    fi
}

deploy_alacritty() {
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
}

deploy_vim() {
    if command -v vim &> /dev/null || command -v nvim &> /dev/null; then
        {
            bash "$HOME/config/vim/vimrc_gen.sh"
        } 1>/dev/null
        vim -c ':PlugUpdate | :q | :q'
        echo "vim          OK"
    fi
}

if [[ $# -eq 0 ]]; then
    deploy_bash
    deploy_zsh
    deploy_git
    deploy_tmux
    deploy_alacritty
    deploy_vim
else
    case "$1" in
        bash)
            deploy_bash
            ;;
        zsh)
            deploy_zsh
            ;;
        git)
            deploy_git
            ;;
        tmux)
            deploy_tmux
            ;;
        alacritty)
            deploy_alacritty
            ;;
        vim)
            deploy_vim
            ;;
        *)
            echo "Invalid option: $1"
            echo "Usage: $0 {bash|zsh|git|tmux|alacritty|vim}"
            exit 1
            ;;
    esac
fi

echo "Installation DONE"
