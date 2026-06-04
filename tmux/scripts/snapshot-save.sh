#!/usr/bin/env sh

current_name=$(tmux show-option -gqv @named-snapshot-current)
script=${XDG_CONFIG_HOME:-$HOME/.config}/tmux/plugins/tmux-named-snapshot/scripts/save-snapshot.sh

tmux command-prompt -I "$current_name" -p 'Snapshot name:' \
    "run-shell \"$script %1\"; set-option -gq @named-snapshot-current \"%1\""
