#!/usr/bin/env sh

original=$(tmux display-message -p '#S')
sessions=$(tmux list-sessions)
current_line=$(printf '%s\n' "$sessions" | grep -n "^$original:" | cut -d: -f1)

selected=$(printf '%s\n' "$sessions" | fzf \
    --bind="load:pos($current_line)" \
    --bind='ctrl-x:transform:echo "execute(echo {} | cut -d: -f1 | xargs tmux kill-session -t)+reload(tmux list-sessions)+pos($FZF_POS)"' \
    --bind='focus:execute-silent(tmux switch-client -t {1})' \
    --delimiter=':' | cut -d: -f1)

tmux switch-client -t "$original"
[ -n "$selected" ] && tmux switch-client -t "$selected"
