#!/usr/bin/env sh

fd_type=$1
pane_id=$2
pane_pid=$3
pane_path=$4
script_dir=${XDG_CONFIG_HOME:-$HOME/.config}/tmux/scripts

nvim_pid=$(pgrep -P "$pane_pid" -x nvim 2>/dev/null | head -1)
if [ -n "$nvim_pid" ]; then
    embed_pid=$(pgrep -P "$nvim_pid" 2>/dev/null | head -1)
    sock="/run/user/$(id -u)/nvim.${embed_pid}.0"
    if [ -S "$sock" ]; then
        dir=$(nvim --server "$sock" --remote-expr 'expand("%:p:h")' 2>/dev/null)
        if [ -z "$dir" ] || [ "${dir#*://}" != "$dir" ] || [ ! -d "$dir" ]; then
            dir=$(nvim --server "$sock" --remote-expr 'getcwd()' 2>/dev/null)
        fi
        mode=$(nvim --server "$sock" --remote-expr 'mode()' 2>/dev/null)
        case "$mode" in
            i*|c*|t*) can_send=1 ;;
            *) can_send=0 ;;
        esac
    fi
fi

picker_path=${dir:-$pane_path}
can_send=${can_send:-1}

tmux display-popup -E -w 80% -h 60% -d "$picker_path" \
    "TMUX_PICK_TYPE='$fd_type' TMUX_PICK_PANE='$pane_id' TMUX_PICK_SEND='$can_send' TMUX_PICK_PROMPT='$picker_path/' '$script_dir/nvim-aware-picker-popup.sh'"
