local wezterm = require 'wezterm'
local config = wezterm.config_builder()

config.default_prog = { '/usr/bin/tmux' }
config.color_scheme = 'Kanagawa (Gogh)'
config.enable_tab_bar = false
config.skip_close_confirmation_for_processes_named = {}

return config
