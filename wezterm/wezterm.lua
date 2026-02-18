local wezterm = require("wezterm")

local config = {}

config.colors = {
	foreground = "#CECECE",
	background = "#000000",
	cursor_bg = "#CECECE",
	cursor_fg = "#000000",
	cursor_border = "#CECECE",
	selection_fg = "#000000",
	selection_bg = "#CECECE",
	ansi = {
		"#000000", -- black
		"#cc6666", -- red
		"#b5bd68", -- green
		"#f0c674", -- yellow
		"#81a2be", -- blue
		"#b294bb", -- magenta
		"#8abeb7", -- cyan
		"#c5c8c6", -- white
	},
	brights = {
		"#4a4a4a", -- bright black
		"#d54e53", -- bright red
		"#b9ca4a", -- bright green
		"#e7c547", -- bright yellow
		"#7aa6da", -- bright blue
		"#c397d8", -- bright magenta
		"#70c0b1", -- bright cyan
		"#eaeaea", -- bright white
	},
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
