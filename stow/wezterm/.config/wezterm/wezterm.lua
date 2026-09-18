local wezterm = require("wezterm")
local config = wezterm.config_builder()

-- Terminal
config.term = "xterm-256color"
config.audible_bell = "Disabled"

config.default_prog = {
  "/bin/bash",
  "-lc",
  "exec tmux new-session -A -s main",
}

-- Window
config.initial_cols = 80
config.initial_rows = 24
config.window_background_opacity = 1
config.scrollback_lines = 10000
config.enable_tab_bar = false
config.window_decorations = "TITLE | RESIZE"

config.adjust_window_size_when_changing_font_size = false

-- Font
config.font_size = 12.0
if wezterm.target_triple:find("apple") then
  config.font_dirs = { wezterm.home_dir .. "/Library/Fonts" }
elseif wezterm.target_triple:find("linux") then
  config.font_dirs = { wezterm.home_dir .. "/.local/share/fonts" }
end
config.font = wezterm.font("Iosevka Term", {
  weight = "DemiBold",
  stretch = "Expanded",
})

config.bold_brightens_ansi_colors = true

-- Colors
config.colors = {
  foreground = "#d8dee9",
  background = "#2e3340",
  cursor_bg = "#d8dee9",
  cursor_fg = "#2e3440",
  cursor_border = "#d8dee9",
  selection_fg = "none",
  selection_bg = "#4c566a",
  ansi = {
    "#3b4252",
    "#bf616a",
    "#a3be8c",
    "#ebcb8b",
    "#81a1c1",
    "#b48ead",
    "#88c0d0",
    "#e5e9f0",
  },
  brights = {
    "#4c566a",
    "#bf616a",
    "#a3be8c",
    "#ebcb8b",
    "#81a1c1",
    "#b48ead",
    "#8fbcbb",
    "#eceff4",
  },
}

-- Key bindings
config.disable_default_key_bindings = true

config.keys = {
  -- Clipboard
  {
    key = "C",
    mods = "CTRL|SHIFT",
    action = wezterm.action.CopyTo("Clipboard"),
  },
  {
    key = "V",
    mods = "CTRL|SHIFT",
    action = wezterm.action.PasteFrom("Clipboard"),
  },

  -- Font zoom
  {
    key = "-",
    mods = "CTRL",
    action = wezterm.action.DecreaseFontSize,
  },
  {
    key = "=",
    mods = "CTRL",
    action = wezterm.action.IncreaseFontSize,
  },
  {
    key = "0",
    mods = "CTRL",
    action = wezterm.action.ResetFontSize,
  },

  -- Diagnostics
  {
    key = "L",
    mods = "CTRL|SHIFT",
    action = wezterm.action.ShowDebugOverlay,
  },
}

return config
