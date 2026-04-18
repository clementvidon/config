#!/bin/bash
# @file     deploy.sh
# @brief    Configuration deployment script.
# @author   clemedon (Clément Vidon)

prereq() {
    echo "Before to continue, make sure that 'config/' is located in your home directory."
    read -p "Continue? y/n " choice
    if [[ "$choice" == "n" ]]; then
        exit 0
    fi
}

usage() {
    echo "Usage: $0 {all|bash|zsh|scripts|git|tmux|alacritty|vim}"
}

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
        } 1>/dev/null
        echo "zsh          OK"
    fi
}

deploy_scripts() {
    if command -v zsh &> /dev/null; then
        {
            mkdir -pv "$HOME/.local/bin"
            for file in "$HOME"/config/.local/bin/*; do
                if [ -f "$file" ]; then
                    chmod +x "$file"
                    target="$HOME/.local/bin/$(basename "$file")"
                    ln -fsv "$(realpath "$file")" "$target"
                fi
            done
        } 1>/dev/null
        echo "scripts      OK"
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

deploy_all() {
    deploy_bash
    deploy_zsh
    deploy_scripts
    deploy_git
    deploy_tmux
    deploy_alacritty
    deploy_vim
}

if [[ $# -eq 0 || -z "$1" ]]; then
    usage
    exit 1
fi

case "$1" in
    all)
        prereq
        deploy_all
        ;;
    bash)
        prereq
        deploy_bash
        ;;
    zsh)
        prereq
        deploy_zsh
        ;;
    scripts)
        prereq
        deploy_scripts
        ;;
    git)
        prereq
        deploy_git
        ;;
    tmux)
        prereq
        deploy_tmux
        ;;
    alacritty)
        prereq
        deploy_alacritty
        ;;
    vim)
        prereq
        deploy_vim
        ;;
    *)
        echo "Invalid option: $1"
        usage
        exit 1
        ;;
esac

echo "Installation DONE"
