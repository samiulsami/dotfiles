local wezterm = require("wezterm")

local config = {}

config.colors = {
	background = "#000000",
	foreground = "#CECECE",
}

config.window_padding = {
	left = 0,
	right = 0,
	top = 0,
	bottom = 0,
}
config.window_decorations = "NONE"
config.window_background_opacity = 0.92

config.font_size = 11
config.harfbuzz_features = { "calt=0", "liga=0", "dlig=0" }

config.scrollback_lines = 100000
config.enable_csi_u_key_encoding = true

config.enable_tab_bar = false

config.inactive_pane_hsb = {
	saturation = 1,
	brightness = 1,
}

config.animation_fps = 1
config.cursor_blink_ease_in = "Linear"
config.cursor_blink_ease_out = "Linear"
config.visual_bell = {}
config.text_blink_rate = 0

return config
