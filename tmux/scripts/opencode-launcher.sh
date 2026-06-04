#!/usr/bin/env sh

tmux select-window -t ':opencode' 2>/dev/null && exit 0

tmux new-window -n opencode -c "$(tmux display-message -p '#{pane_current_path}')"
tmux send-keys -t ':opencode' opencode Enter
