# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
# ZSH_THEME="robbyrussell"

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in $ZSH/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Update mode
zstyle ':omz:update' mode auto      # update automatically without asking

# Plugins
plugins=(
    git
    zsh-autosuggestions
    archlinux
    colored-man-pages
    zsh-vi-mode
    docker
    docker-compose
    docker-machine
    dotenv
    firewalld
    fd
)

source $ZSH/oh-my-zsh.sh

# Starship
eval "$(starship init zsh)"

# source fzf files
source /opt/homebrew/Cellar/fzf/0.53.0/shell/key-bindings.zsh
source /opt/homebrew/Cellar/fzf/0.53.0/shell/completion.zsh

# # Setup ssh
# # https://wiki.archlinux.org/title/SSH_keys
# if ! pgrep -u "$USER" ssh-agent > /dev/null; then
#     ssh-agent -t 1h > "~/Library/Caches/TemporaryItems/ssh-agent.env"
# fi
# if [[ ! -f "$SSH_AUTH_SOCK" ]]; then
#     source "~/Library/Caches/TemporaryItems/ssh-agent.env" >/dev/null
# fi

# keychain
# https://wiki.archlinux.org/title/SSH_keys#Configuration
# eval $(keychain --eval --quiet id_ed25519 )


# Path
PATH=$PATH:$HOME/.config/.doom-emacs/bin
PATH=$PATH:$HOME/.local/bin
PATH=$PATH:$HOME/go/bin

# opening stuff with emacs
export ALTERNATE_EDITOR=""
export EDITOR="emacsclient -c -s doom"
export VISUAL="emacsclient -c -s doom"

# nvm
source $(brew --prefix nvm)/nvm.sh

# direnv
eval "$(direnv hook zsh)"

# always use this
export OLLAMA_MODELS=/home/kay/.ollama/models

# fixing doom doctor error
# In .zshrc/.bashrc
if [ -d "$(brew --prefix)/opt/grep/libexec/gnubin" ]; then
    PATH="$(brew --prefix)/opt/grep/libexec/gnubin:$PATH"
fi

