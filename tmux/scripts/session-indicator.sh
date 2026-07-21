#!/usr/bin/env sh

current=$1
i=1

tmux list-sessions -F '#{session_id}|#{session_name}|#{session_alerts}' | while IFS='|' read -r id s alerts; do
    if [ "$s" = "$current" ]; then
        printf '#[range=session|%s]#[fg=green,bold][%d]: %s#[norange]#[default] ' "$id" "$i" "$s"
    else
        case "$alerts" in
            *'!'*)
                printf '#[range=session|%s]#[fg=black,bg=grey,bold][%d]: %s!#[norange]#[default] ' "$id" "$i" "$s"
                ;;
            *)
                printf '#[range=session|%s]#[fg=colour242][%d]: %s#[norange]#[default] ' "$id" "$i" "$s"
                ;;
        esac
    fi
    i=$((i + 1))
done
