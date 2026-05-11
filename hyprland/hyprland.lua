-- Found through `hyprctl monitors`
local mon1 = "HDMI-A-1"
local mon2 = "eDP-1"
local mod = "SUPER"
local terminal = "foot"
local border_flash_colors = {
    "rgba(4488ddee)",
    "rgba(3366a6f2)",
    "rgba(22446ff7)",
    "rgba(112237fb)",
    "rgba(000000ff)",
}
local border_normal = border_flash_colors[#border_flash_colors]
local border_flash_index = 0
local border_flash_timer

local function exec(cmd)
    return hl.dsp.exec_cmd(cmd)
end

local function flash_border_step()
    border_flash_index = border_flash_index + 1
    local color = border_flash_colors[border_flash_index]

    if not color then
        border_flash_timer:set_enabled(false)
        return
    end

    hl.dispatch(hl.dsp.window.set_prop({ prop = "active_border_color", value = color }))
end

border_flash_timer = hl.timer(flash_border_step, { timeout = 75, type = "repeat" })
border_flash_timer:set_enabled(false)

local function flash_border()
    border_flash_index = 0
    border_flash_timer:set_enabled(false)
    flash_border_step()
    border_flash_timer:set_enabled(true)
end

local function change_zoom(multiplier)
    local zoom = hl.get_config("cursor.zoom_factor")

    if type(zoom) ~= "number" then
        return
    end

    hl.config({
        cursor = {
            zoom_factor = math.max(zoom * multiplier, 1.0),
        },
    })
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
            active_border = border_normal,
            inactive_border = border_normal,
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
    hl.exec_cmd("wl-paste --watch cliphist store")
end)

for _, event in ipairs({
    "window.active",
    "workspace.active",
    "workspace.move_to_monitor",
    "monitor.focused",
    "keybinds.submap",
}) do
    hl.on(event, flash_border)
end

-- Keybindings
hl.bind(mod .. " + Return", exec(terminal))
hl.bind(mod .. " + SHIFT + W", hl.dsp.window.close())
hl.bind(mod .. " + D", exec("pidof wofi || wofi"))
hl.bind(mod .. " + SHIFT + C", exec("cliphist list | wofi -S dmenu | cliphist decode | wl-copy"))
hl.bind(mod .. " + F", hl.dsp.window.fullscreen({ action = "toggle" }))
hl.bind(mod .. " + SHIFT + Space", hl.dsp.window.float({ action = "toggle" }))
hl.bind(mod .. " + Space", hl.dsp.window.cycle_next({}))

-- Whole-screen zoom
hl.bind(mod .. " + mouse_down", function() change_zoom(2.0) end, { mouse = true })
hl.bind(mod .. " + mouse_up", function() change_zoom(0.5) end, { mouse = true })
hl.bind(mod .. " + mouse:274", function()
    hl.config({
        cursor = {
            zoom_factor = 1.0,
        },
    })
end, { mouse = true })

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
hl.bind(mod .. " + W", function()
    hl.dispatch(hl.dsp.group.toggle())
    flash_border()
end)
hl.bind(mod .. " + S", function()
    hl.dispatch(hl.dsp.layout("togglesplit"))
    flash_border()
end)
hl.bind(mod .. " + SHIFT + S", exec("dunstctl set-paused toggle && pkill -RTMIN+1 waybar"))

hl.bind(mod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind(mod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })
