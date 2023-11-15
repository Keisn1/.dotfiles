export XDG_CONFIG_HOME="$HOME/.config"

fpath+=${ZDOTDIR:-~}/.zsh_functions

# eval $(keychain --eval $HOME/.ssh/kaypro-MacBookPro-Ubuntu_rsa)
# Ensure agent is running
ssh-add -l &>/dev/null
if [ "$?" = 2 ]; then
    # Could not open a connection to your authentication agent.

    # Load stored agent connection info.
    test -r ~/.ssh-agent && \
        eval "$(<~/.ssh-agent)" >/dev/null

    ssh-add -l &>/dev/null
    if [ "$?" = 2 ]; then
        # Start agent and store agent connection info.
        (umask 066; ssh-agent > ~/.ssh-agent)
        eval "$(<~/.ssh-agent)" >/dev/null
        eval $(keychain --eval $HOME/.ssh/kaypro-MacBookPro-Ubuntu_rsa)
    fi
fi

# Load identities
ssh-add -l &>/dev/null
if [ "$?" = 1 ]; then
    # The agent has no identities.
    # Time to add one.
    ssh-add -t 4h
fi

# echo $SSH_AGENT_PID
# echo "hello"
# if ! [ $(echo $SSH_AGENT_PID | wc -w) -gt 0 ] ; then
#     eval $(ssh-agent -s)
#     echo "hello2"
#     eval $(keychain --eval $HOME/.ssh/kaypro-MacBookPro-Ubuntu_rsa)
# fi

export PATH=$PATH:$HOME/programs/lastpass-cli/build/

PATH=$PATH:/home/kaypro/.local/bin

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

export PATH=$PATH:$HOME/.config/emacs/bin

source "$HOME/.cargo/env"

export STARSHIP_CONFIG=~/.config/starship/starship.toml
ZSH_THEME=""
#Star Ship
eval "$(starship init zsh)"

plugins=(git colored-man-pages  zsh-autosuggestions zsh-vi-mode)

export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
if command -v pyenv 1>/dev/null 2>&1; then
 eval "$(pyenv init --path)"
fi

export PIPENV_VENV_IN_PROJECT=1

PATH=$PATH:$HOME/.dotfiles/bin

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

export CLASSPATH=$CLASSPATH:$HOME/.config/jdtls/bin/jdtls

export PATH=$PATH:/usr/local/go/bin

export PATH=$PATH:$(go env GOPATH)/bin

export PATH=$PATH:/opt/gradle/gradle-8.4/bin

export PATH=$PATH:/opt/intelliJ/idea-IC-232.10072.27/bin

eval "$(direnv hook zsh)"

alias lsla='ls -la'

alias eclient='emacsclient -c'
alias edaemon='emacs --bg-daemon'
alias kedaemon='eclient -e "(kill-emacs)"'

alias r='ranger'
alias ranger='ranger --choosedir=$HOME/.rangerdir; LASTDIR=`cat $HOME/.rangerdir`; cd "$LASTDIR"'

alias dps='docker ps'
alias dpsa='docker ps -a'
alias dst='docker stop'

source $HOME/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

source $ZSH/oh-my-zsh.sh

# tmux
