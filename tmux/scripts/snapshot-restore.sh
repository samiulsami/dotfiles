#!/usr/bin/env sh

data_dir=${XDG_DATA_HOME:-$HOME/.local/share}/tmux/resurrect
restore=${XDG_CONFIG_HOME:-$HOME/.config}/tmux/plugins/tmux-named-snapshot/scripts/restore-snapshot.sh

selected=$(for path in "$data_dir"/*; do
    [ -L "$path" ] || continue
    name=${path##*/}
    [ "$name" = last ] && continue
    printf '%s\n' "$name"
done | sort | fzf --prompt='Restore snapshot: ' --height=100% --reverse \
    --bind="ctrl-x:execute-silent(rm -f -- \$(readlink -f -- $data_dir/{}) $data_dir/{})+abort")

[ -n "$selected" ] || exit 0

"$restore" "$selected" && tmux set-option -gq @named-snapshot-current "$selected"
