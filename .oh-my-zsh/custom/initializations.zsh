#!/usr/bin/env zsh

# pyenv init
if command -v pyenv 1>/dev/null 2>&1; then
   eval "$(pyenv init -)"
fi

# Cargo
. "$HOME/.cargo/env"
