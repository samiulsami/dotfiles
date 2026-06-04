#!/usr/bin/env sh

current=$1
i=1

tmux list-sessions -F '#{session_name}' | while read -r s; do
    if [ "$s" = "$current" ]; then
        printf '#[fg=green,bold][%d]: %s ' "$i" "$s"
    else
        printf '#[fg=colour242][%d]: %s ' "$i" "$s"
    fi
    i=$((i + 1))
done
