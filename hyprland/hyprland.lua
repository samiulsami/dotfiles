local mon1 = "HDMI-A-1"
local mon2 = "eDP-1"
local mod = "SUPER"
local terminal = "foot"

local function exec(cmd)
    return hl.dsp.exec_cmd(cmd)
end

-- Monitor config (adjust to your setup)
-- Use `hyprctl monitors` to find names
hl.monitor({ output = mon1, mode = "preferred@60", position = "0x0", scale = 1 })
hl.monitor({ output = mon2, mode = "preferred@60", position = "1920x0", scale = 1 })
hl.monitor({ output = "", mode = "preferred", position = "auto", scale = 1 })

hl.workspace_rule({ workspace = "1", monitor = mon1, default = true })
hl.workspace_rule({ workspace = "4", monitor = mon2, default = true })

-- Nvidia specific (remove if not on Nvidia)
hl.env("LIBVA_DRIVER_NAME", "nvidia")
hl.env("__GLX_VENDOR_LIBRARY_NAME", "nvidia")
hl.env("NVD_BACKEND", "direct")
hl.env("ELECTRON_OZONE_PLATFORM_HINT", "auto")

hl.config({
    -- General
    cursor = {
        no_hardware_cursors = 1,
    },

    general = {
        gaps_in = 0,
        gaps_out = 0,
        border_size = 1,
        col = {
            active_border = "rgba(000000ff)",
            inactive_border = "rgba(000000ff)",
        },
        layout = "dwindle",
    },

    decoration = {
        rounding = 0,
        blur = {
            enabled = false,
        },
        shadow = {
            enabled = false,
        },
    },

    -- Animations
    animations = {
        enabled = false,
    },

    -- Input
    input = {
        kb_layout = "us",
        follow_mouse = 1,
        accel_profile = "flat",
        sensitivity = 0,
        repeat_rate = 50,
        repeat_delay = 300,
        touchpad = {
            natural_scroll = true,
            tap_and_drag = false,
        },
    },

    dwindle = {
        preserve_split = true,
    },

    -- Misc
    misc = {
        disable_hyprland_logo = true,
        disable_splash_rendering = true,
        disable_autoreload = true,
    },
})

-- Found the name through: hyprctl devices | grep -i -A 2 'touchpad'
hl.device({
    name = "elan1203:00-04f3:307a-touchpad",
    sensitivity = 1.0,
})

-- Autostart
hl.on("hyprland.start", function()
    hl.exec_cmd("hyprpaper")
    hl.exec_cmd("dbus-update-activation-environment --all")
    hl.exec_cmd("systemctl --user start hyprpolkitagent")
    hl.exec_cmd("gnome-keyring-daemon --start --components=secrets")
    hl.exec_cmd("dunst")
    hl.exec_cmd("waybar")
    hl.exec_cmd("hypridle")
    hl.exec_cmd("$XDG_CONFIG_HOME/hypr/border-flash.sh")
    hl.exec_cmd("wl-paste --watch cliphist store")
end)

-- Keybindings
hl.bind(mod .. " + Return", exec(terminal))
hl.bind(mod .. " + SHIFT + W", hl.dsp.window.close())
hl.bind(mod .. " + D", exec("pidof wofi || wofi"))
hl.bind(mod .. " + SHIFT + C", exec("cliphist list | wofi -S dmenu | cliphist decode | wl-copy"))
hl.bind(mod .. " + F", hl.dsp.window.fullscreen({ action = "toggle" }))
hl.bind(mod .. " + SHIFT + Space", hl.dsp.window.float({ action = "toggle" }))
hl.bind(mod .. " + Space", hl.dsp.window.cycle_next({}))

-- Whole-screen zoom
hl.bind(
    mod .. " + mouse_down",
    exec("hyprctl -q keyword cursor:zoom_factor $(hyprctl getoption cursor:zoom_factor -j | jq '.float * 2')"),
    { mouse = true }
)
hl.bind(
    mod .. " + mouse_up",
    exec("hyprctl -q keyword cursor:zoom_factor $(hyprctl getoption cursor:zoom_factor -j | jq '[(.float / 2), 1] | max')"),
    { mouse = true }
)
hl.bind(mod .. " + mouse:274", exec("hyprctl -q keyword cursor:zoom_factor 1.0"), { mouse = true })

-- Vim navigation
for _, pair in ipairs({
    { key = "H", dir = "l" },
    { key = "J", dir = "d" },
    { key = "K", dir = "u" },
    { key = "L", dir = "r" },
}) do
    hl.bind(mod .. " + " .. pair.key, hl.dsp.focus({ direction = pair.dir }))
    -- Move windows
    hl.bind(mod .. " + SHIFT + " .. pair.key, hl.dsp.window.move({ direction = pair.dir }))
end

-- Workspaces
for i = 1, 10 do
    local key = tostring(i % 10)
    local workspace = tostring(i)

    hl.bind(mod .. " + " .. key, hl.dsp.focus({ workspace = workspace }))
    -- Move to workspace (and follow)
    hl.bind(mod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = workspace }))
end

-- Reload config
hl.bind(mod .. " + SHIFT + R", exec("hyprctl reload"))

-- Resize submap
hl.bind(mod .. " + R", hl.dsp.submap("resize"))

hl.define_submap("resize", function()
    hl.bind("H", hl.dsp.window.resize({ x = -20, y = 0, relative = true }), { repeating = true })
    hl.bind("J", hl.dsp.window.resize({ x = 0, y = 20, relative = true }), { repeating = true })
    hl.bind("K", hl.dsp.window.resize({ x = 0, y = -20, relative = true }), { repeating = true })
    hl.bind("L", hl.dsp.window.resize({ x = 20, y = 0, relative = true }), { repeating = true })
    hl.bind("Return", hl.dsp.submap("reset"))
    hl.bind("Escape", hl.dsp.submap("reset"))
end)

-- Screenshot (grim + slurp)
hl.bind("Print", exec("grim -g \"$(slurp)\" - | swappy -f -"))
hl.bind(mod .. " + Print", exec("grim - | satty -f - --fullscreen --init-tool crop --copy-command \"wl-copy\""))

-- Brightness (repeatable when held)
hl.bind(
    mod .. " + SHIFT + B",
    exec("brightnessctl set 5%+ && notify-send -h string:x-dunst-stack-tag:brightness \"Brightness: +5%\""),
    { repeating = true }
)
hl.bind(
    mod .. " + B",
    exec("brightnessctl set 5%- && notify-send -h string:x-dunst-stack-tag:brightness \"Brightness: -5%\""),
    { repeating = true }
)

-- Volume (repeatable when held) - capped at 200%
hl.bind(
    mod .. " + SHIFT + V",
    exec("vol=$(pactl get-sink-volume @DEFAULT_SINK@ | grep -Po '\\d+(?=%)' | head -1); [ \"$vol\" -lt 200 ] && pactl set-sink-volume @DEFAULT_SINK@ +5%; notify-send -h string:x-dunst-stack-tag:audio \"Volume: $(pactl get-sink-volume @DEFAULT_SINK@ | grep -Po '\\d+(?=%)' | head -1)%\""),
    { repeating = true }
)
hl.bind(
    mod .. " + V",
    exec("pactl set-sink-volume @DEFAULT_SINK@ -5% && notify-send -h string:x-dunst-stack-tag:audio \"Volume: $(pactl get-sink-volume @DEFAULT_SINK@ | grep -Po '\\d+(?=%)' | head -1)%\""),
    { repeating = true }
)
hl.bind(mod .. " + M", exec("pactl set-sink-mute @DEFAULT_SINK@ toggle && notify-send -h string:x-dunst-stack-tag:audio \"Audio Muted: $(pactl get-sink-mute @DEFAULT_SINK@ | awk '{print $2}')\""))
hl.bind(mod .. " + SHIFT + M", exec("pactl set-source-mute @DEFAULT_SOURCE@ toggle && notify-send -h string:x-dunst-stack-tag:audio \"Mic Muted: $(pactl get-source-mute @DEFAULT_SOURCE@ | awk '{print $2}')\""))

-- Microphone volume (repeatable when held) - capped at 200%
hl.bind(
    mod .. " + SHIFT + I",
    exec("vol=$(pactl get-source-volume @DEFAULT_SOURCE@ | grep -Po '\\d+(?=%)' | head -1); [ \"$vol\" -lt 200 ] && pactl set-source-volume @DEFAULT_SOURCE@ +5%; notify-send -h string:x-dunst-stack-tag:audio \"Mic Volume: $(pactl get-source-volume @DEFAULT_SOURCE@ | grep -Po '\\d+(?=%)' | head -1)%\""),
    { repeating = true }
)
hl.bind(
    mod .. " + I",
    exec("pactl set-source-volume @DEFAULT_SOURCE@ -5% && notify-send -h string:x-dunst-stack-tag:audio \"Mic Volume: $(pactl get-source-volume @DEFAULT_SOURCE@ | grep -Po '\\d+(?=%)' | head -1)%\""),
    { repeating = true }
)

-- Dunst controls
hl.bind(mod .. " + N", exec("dunstctl history-pop"))
hl.bind(mod .. " + P", exec("dunstctl close"))
hl.bind(mod .. " + A", exec("dunstctl action"))
hl.bind(mod .. " + C", exec("dunstctl close-all"))

-- Lock screen (triggers hypridle lock_cmd which turns off display)
hl.bind(mod .. " + Escape", exec("loginctl lock-session"))

-- Group/tabbed layout
hl.bind(mod .. " + W", hl.dsp.group.toggle())
hl.bind(mod .. " + S", hl.dsp.layout("togglesplit"))
hl.bind(mod .. " + SHIFT + S", exec("dunstctl set-paused toggle && pkill -RTMIN+1 waybar"))

hl.bind(mod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind(mod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })
