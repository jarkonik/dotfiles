local wezterm = require 'wezterm'
local config = wezterm.config_builder()

config.default_prog = { '/usr/bin/tmux' }
config.color_scheme = 'Kanagawa (Gogh)'
config.enable_tab_bar = false

return config
