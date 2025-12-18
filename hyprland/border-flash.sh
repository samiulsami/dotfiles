#!/usr/bin/env bash
# Flash active border blue on layout changes

readonly TIMEOUT=0.5  # seconds to show blue border
readonly BLUE="rgba(4488ddee)"
readonly BLACK="rgba(000000ff)"

# Track the PID of the pending restore operation
RESTORE_PID=""

handle() {
    case $1 in
        # Workspace operations
        workspace\>*|workspacev2\>*|focusedmon\>*|focusedmonv2\>*|\
        moveworkspace\>*|moveworkspacev2\>*|activespecial\>*|activespecialv2\>*)
            flash_border ;;

        # Window operations
        activewindow\>*|activewindowv2\>*|movewindow\>*|movewindowv2\>*|\
        openwindow\>*|closewindow\>*|fullscreen\>*|changefloatingmode\>*|\
        urgent\>*|pin\>*)
            flash_border ;;

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
