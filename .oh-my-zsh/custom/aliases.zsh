#!/usr/bin/env zsh

# ergonomics
alias cl='clear'

# ssh
alias ssha='eval $(ssh-agent) && $(ssh-add)'

# tmux
alias tm='tmux'
alias tn='tmux_new_session'
alias ta='tmux attach -d -t'
alias tl='tmux list-session'
alias tkk='tmux kill-session'
alias tkt='tmux kill-session -t'
alias tks='tmux_kill_session'
alias tka='tmux kill-server'
alias tkao='tmux kill-session -a'
alias td='tmux detach'

alias tf='~/.local/bin/tmux-sessionizer.zsh'

# reflector
alias reflrefr="reflector --country France --age 12 --protocol https --sort rate --save /etc/pacman.d/mirrorlist"

# yay
alias yayforeign="yay -Qm" # -m, --foreign ,list installed packages not found in sync db(s) [filter]

# ranger
alias r='ranger'
alias ranger='ranger --choosedir=$HOME/.rangerdir; LASTDIR=`cat $HOME/.rangerdir`; cd "$LASTDIR"'

# pipenv
pipenv_activate() {
    source "$(pipenv --venv)/bin/activate"
}

# important alias to redirect program names
alias clangd-16='clangd'

