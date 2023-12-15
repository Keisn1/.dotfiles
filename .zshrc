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
source /usr/share/fzf/key-bindings.zsh
source /usr/share/fzf/completion.zsh

# Setup ssh
# https://wiki.archlinux.org/title/SSH_keys
if ! pgrep -u "$USER" ssh-agent > /dev/null; then
    ssh-agent -t 1h > "$XDG_RUNTIME_DIR/ssh-agent.env"
fi
if [[ ! -f "$SSH_AUTH_SOCK" ]]; then
    source "$XDG_RUNTIME_DIR/ssh-agent.env" >/dev/null
fi

# Path
PATH=$PATH:$HOME/.config/.doom-emacs/bin

# opening stuff with emacs
export ALTERNATE_EDITOR=""
export EDITOR="emacsclient -c -s doom"
export VISUAL="emacsclient -c -s doom"

# keychain
# https://wiki.archlinux.org/title/SSH_keys#Configuration
eval $(keychain --eval --quiet id_ed25519 )
