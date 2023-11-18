#!/usr/bin/env zsh


# tmux-functions
tmux_new_session () {
    read "session_name?Session name: "
    tmux new -s $session_name
}
tmux_kill_session () {
    read "session_target?target: "
    tmux kill-session -t $session_target
}
# end of tmux-functions
