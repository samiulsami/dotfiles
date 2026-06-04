#!/usr/bin/env sh

dir=$(zoxide query -l | fzf --bind='ctrl-x:execute(echo {} | xargs zoxide remove)+reload(zoxide query -l)')
[ -n "$dir" ] || exit 0

base=$(basename "$dir" | tr . _)
existing=$(tmux list-sessions -F '#{session_name}:#{session_path}' 2>/dev/null | grep ":${dir}$" | cut -d: -f1 | head -1)

if [ -n "$existing" ]; then
    tmux switch-client -t "$existing"
    exit 0
fi

name=$base
i=1
while tmux has-session -t "$name" 2>/dev/null; do
    name="${base}@$i"
    i=$((i + 1))
done

tmux new-session -d -s "$name" -c "$dir" && tmux switch-client -t "$name"
