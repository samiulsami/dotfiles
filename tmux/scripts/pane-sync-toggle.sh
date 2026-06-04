#!/usr/bin/env sh

if [ "$(tmux show -w synchronize-panes)" = 'synchronize-panes on' ]; then
    tmux setw synchronize-panes off
    tmux set -g pane-border-style fg=default
    tmux set -g pane-active-border-style fg=green
    exit 0
fi

panes=$(tmux display -p '#{window_panes}')
zoomed=$(tmux display -p '#{window_zoomed_flag}')
copy=$(tmux display -p '#{pane_in_mode}')

[ "$panes" -gt 1 ] && [ "$zoomed" = 0 ] && [ "$copy" = 0 ] || exit 0

tmux setw synchronize-panes on
tmux set -g pane-border-style fg=red
tmux set -g pane-active-border-style fg=red
