eval $(keychain --eval ~/.ssh/KayProAsusUbuntu_rsa)

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

PATH=$PATH:~/.config/emacs/bin

ZSH_THEME=""
#Star Ship
eval "$(starship init zsh)"

plugins=(git colored-man-pages zsh-syntax-highlighting zsh-autosuggestions zsh-vi-mode)

source $ZSH/oh-my-zsh.sh

export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
if command -v pyenv 1>/dev/null 2>&1; then
 eval "$(pyenv init --path)"
fi

export PIPENV_VENV_IN_PROJECT=1

PATH=$PATH:~/.dotfiles/bin

alias lsla='ls -la'
