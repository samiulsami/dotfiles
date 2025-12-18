#!/usr/bin/env bash
# Flash active border blue on layout changes

readonly TIMEOUT=0.5  # seconds to show blue border
readonly BLUE="rgba(4488ddee)"
readonly BLACK="rgba(000000ff)"

# Track the PID of the pending restore operation
RESTORE_PID=""
# Track last active window address to filter out title-only changes
LAST_WINDOW=""

handle() {
    case $1 in
        # Workspace operations
        workspacev2\>*|focusedmonv2\>*|moveworkspacev2\>*|activespecialv2\>*)
            flash_border ;;

        # Window operations
        movewindowv2\>*|closewindow\>*|changefloatingmode\>*|urgent\>*)
            flash_border ;;

        # Active window changed - only flash if window address actually changed
        activewindowv2\>*)
            # Format: activewindowv2>>WINDOW_ADDRESS,WINDOW_TITLE
            window_addr="${1#activewindowv2>>}"
            window_addr="${window_addr%%,*}"
            if [[ "$window_addr" != "$LAST_WINDOW" ]]; then
                LAST_WINDOW="$window_addr"
                flash_border
            fi
            ;;

        # Group operations (tabbed/stacked layout manipulation)
        togglegroup\>*|moveintogroup\>*|moveoutofgroup\>*)
            flash_border ;;

        # Submap changes (e.g., entering resize mode)
        submap\>*)
            flash_border ;;
    esac
}

flash_border() {
    if [[ -n "$RESTORE_PID" ]] && kill -0 "$RESTORE_PID" 2>/dev/null; then
        kill "$RESTORE_PID" 2>/dev/null
    fi

    hyprctl -q keyword general:col.active_border "$BLUE"

    (sleep "$TIMEOUT" && hyprctl -q keyword general:col.active_border "$BLACK") &
    RESTORE_PID=$!
}

# Listen to Hyprland event socket
# https://wiki.hyprland.org/IPC/
socat -U - "UNIX-CONNECT:$XDG_RUNTIME_DIR/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.socket2.sock" | \
    while read -r line; do handle "$line"; done
