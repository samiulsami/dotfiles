#!/usr/bin/env sh

selected=$(fd --type "$TMUX_PICK_TYPE" --hidden --exclude .git | fzf --prompt "$TMUX_PICK_PROMPT")
[ -n "$selected" ] || exit 0
[ "$TMUX_PICK_SEND" = 1 ] || exit 0

quoted=$(printf "%s" "$selected" | sed "s/'/'\\\\''/g; 1s/^/'/; \$s/\$/'/")
tmux send-keys -t "$TMUX_PICK_PANE" -- "$quoted"
