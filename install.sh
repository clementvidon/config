#!/bin/bash

prereq() {
    echo "Before to continue, make sure that 'config/' is located in your home directory."
    read -p "Continue? y/n " choice
    if [[ "$choice" == "n" ]]; then
        exit 0
    fi
}

usage() {
    echo "Usage: $0 {all|bash|zsh|scripts|git|tmux|alacritty|vim|llm}"
}

install_bash() {
    if command -v bash &> /dev/null; then
        {
            ln -fsv "$HOME/config/.bashrc"                    "$HOME/.bashrc"
        } 1>/dev/null
        echo "bash         OK"
    fi
}

install_zsh() {
    if command -v zsh &> /dev/null; then
        {
            sudo chsh -s /usr/bin/zsh clem
            ln -fsv "$HOME/config/.zshrc"                     "$HOME/.zshrc"
            ln -fsv "$HOME/config/.zshenv"                    "$HOME/.zshenv"
        } 1>/dev/null
        echo "zsh          OK"
    fi
}

install_scripts() {
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

install_git() {
    if command -v git &> /dev/null; then
        {
            ln -fsv "$HOME/config/.gitmessage"                "$HOME/.gitmessage"
            ln -fsv "$HOME/config/.gitconfig"                 "$HOME/.gitconfig"
            ln -fsv "$HOME/config/.gitignore"                 "$HOME/.gitignore"
        } 1>/dev/null
        echo "git          OK"
    fi
}

install_tmux() {
    if command -v tmux &> /dev/null; then
        {
            ln -fsv "$HOME/config/.tmux.conf"                 "$HOME/.tmux.conf"
        } 1>/dev/null
        echo "tmux         OK"
    fi
}

install_alacritty() {
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

install_vim() {
    if command -v vim &> /dev/null || command -v nvim &> /dev/null; then
        {
            bash "$HOME/config/vim/vimrc_gen.sh"
        } 1>/dev/null
        vim -c ':PlugUpdate | :q | :q'
        echo "vim          OK"
    fi
}

install_llm() {
    if ! command -v uv &> /dev/null; then
        if ! command -v curl &> /dev/null; then
            echo "llm          SKIP (curl not installed)"
            return 1
        fi

        curl -LsSf https://astral.sh/uv/install.sh | sh
        export PATH="$HOME/.local/bin:$PATH"
    fi

    uv tool install llm
    echo "llm          OK"
}

install_all() {
    install_bash
    install_zsh
    install_scripts
    install_git
    install_tmux
    install_alacritty
    install_vim
    install_llm
}

if [[ $# -eq 0 || -z "$1" ]]; then
    usage
    exit 1
fi

case "$1" in
    all)
        prereq
        install_all
        ;;
    bash)
        prereq
        install_bash
        ;;
    zsh)
        prereq
        install_zsh
        ;;
    scripts)
        prereq
        install_scripts
        ;;
    git)
        prereq
        install_git
        ;;
    tmux)
        prereq
        install_tmux
        ;;
    alacritty)
        prereq
        install_alacritty
        ;;
    vim)
        prereq
        install_vim
        ;;
    llm)
        prereq
        install_llm
        ;;
    *)
        echo "Invalid option: $1"
        usage
        exit 1
        ;;
esac

echo "Installation DONE"
