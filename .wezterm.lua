local wezterm = require("wezterm")
local config = wezterm.config_builder()

-- General
config.font_size = 16
config.line_height = 1
config.font = wezterm.font("Zx Proto")
config.color_scheme = "tokyonight_night"

config.window_decorations = 'RESIZE'
config.enable_tab_bar = true

-- Cursor
config.default_cursor_style = 'BlinkingBar'

-- Window size
config.initial_cols = 150
config.initial_rows = 35

return config
