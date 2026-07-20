#!/usr/bin/env sh

current=$1
i=1

tmux list-sessions -F '#{session_name}|#{session_alerts}' | while IFS='|' read -r s alerts; do
    if [ "$s" = "$current" ]; then
        printf '#[fg=green,bold][%d]: %s #[default]' "$i" "$s"
    else
        case "$alerts" in
            *'!'*)
                printf '#[fg=black,bg=grey,bold][%d]: %s! #[default]' "$i" "$s"
                ;;
            *)
                printf '#[fg=colour242][%d]: %s #[default]' "$i" "$s"
                ;;
        esac
    fi
    printf ' '
    i=$((i + 1))
done
