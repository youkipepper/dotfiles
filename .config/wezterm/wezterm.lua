local wezterm = require("wezterm")

local config = wezterm.config_builder()
local act = wezterm.action
local mux = wezterm.mux

local startup_window = {
  cols = 120,
  rows = 36,
  x = 100,
  y = 60,
}

config.font = wezterm.font_with_fallback({
  { family = "Maple Mono NF CN" },
  "Symbols Nerd Font Mono",
})
config.font_size = 13.0
config.harfbuzz_features = { "calt=1", "liga=1" }
config.line_height = 1.15
config.cell_width = 1.0

config.color_scheme = "Catppuccin Mocha"
config.window_background_opacity = 0.88
config.macos_window_background_blur = 30
config.window_decorations = "RESIZE"
config.initial_cols = startup_window.cols
config.initial_rows = startup_window.rows
config.window_padding = {
  left = 12,
  right = 12,
  top = 10,
  bottom = 10,
}

config.default_cursor_style = "SteadyBar"
config.cursor_blink_rate = 0
config.hide_mouse_cursor_when_typing = true
config.audible_bell = "Disabled"

config.scrollback_lines = 10000000
config.automatically_reload_config = true
config.use_ime = true
config.use_dead_keys = false
config.send_composed_key_when_left_alt_is_pressed = false
config.send_composed_key_when_right_alt_is_pressed = false

config.window_frame = {
  font = wezterm.font({ family = "Maple Mono NF CN" }),
  font_size = 12.0,
  active_titlebar_bg = "#1E1E2E",
  inactive_titlebar_bg = "#181825",
}

config.colors = {
  split = "#2a2a3a",
  tab_bar = {
    background = "#11111B",
    active_tab = {
      bg_color = "#CBA6F7",
      fg_color = "#11111B",
      intensity = "Bold",
    },
    inactive_tab = {
      bg_color = "#181825",
      fg_color = "#CDD6F4",
    },
    inactive_tab_hover = {
      bg_color = "#313244",
      fg_color = "#CDD6F4",
    },
    new_tab = {
      bg_color = "#11111B",
      fg_color = "#CDD6F4",
    },
    new_tab_hover = {
      bg_color = "#313244",
      fg_color = "#CDD6F4",
    },
  },
}

config.keys = {
  { key = "n", mods = "CMD", action = act.SpawnCommandInNewWindow({}) },
  { key = "t", mods = "CMD", action = act.SpawnTab("CurrentPaneDomain") },

  { key = "d", mods = "CMD", action = act.SplitHorizontal({ domain = "CurrentPaneDomain" }) },
  { key = "d", mods = "CMD|SHIFT", action = act.SplitVertical({ domain = "CurrentPaneDomain" }) },
  { key = "w", mods = "CMD", action = act.CloseCurrentPane({ confirm = true }) },
  { key = "w", mods = "CMD|OPT", action = act.CloseCurrentTab({ confirm = true }) },

  { key = "[", mods = "CMD", action = act.ActivatePaneDirection("Prev") },
  { key = "]", mods = "CMD", action = act.ActivatePaneDirection("Next") },
  { key = "LeftArrow", mods = "CMD|OPT", action = act.ActivatePaneDirection("Left") },
  { key = "RightArrow", mods = "CMD|OPT", action = act.ActivatePaneDirection("Right") },
  { key = "UpArrow", mods = "CMD|OPT", action = act.ActivatePaneDirection("Up") },
  { key = "DownArrow", mods = "CMD|OPT", action = act.ActivatePaneDirection("Down") },
  { key = "Enter", mods = "CMD|SHIFT", action = act.TogglePaneZoomState },
  { key = "LeftArrow", mods = "CMD|CTRL", action = act.AdjustPaneSize({ "Left", 5 }) },
  { key = "RightArrow", mods = "CMD|CTRL", action = act.AdjustPaneSize({ "Right", 5 }) },
  { key = "UpArrow", mods = "CMD|CTRL", action = act.AdjustPaneSize({ "Up", 3 }) },
  { key = "DownArrow", mods = "CMD|CTRL", action = act.AdjustPaneSize({ "Down", 3 }) },

  { key = "k", mods = "CMD", action = act.ClearScrollback("ScrollbackAndViewport") },
  { key = "f", mods = "CMD", action = act.Search({ CaseSensitiveString = "" }) },
  { key = ",", mods = "CMD|SHIFT", action = act.ReloadConfiguration },

  { key = "s", mods = "CMD", action = act.SendString("\x1b:w\r") },
  { key = "p", mods = "CMD", action = act.SendString(":Telescope find_files\r") },
  { key = "f", mods = "CMD|SHIFT", action = act.SendString(":Telescope live_grep\r") },
  { key = "b", mods = "CMD", action = act.SendString(":Neotree toggle\r") },

  { key = "1", mods = "CMD", action = act.SendString("\x00" .. "1") },
  { key = "2", mods = "CMD", action = act.SendString("\x00" .. "2") },
  { key = "3", mods = "CMD", action = act.SendString("\x00" .. "3") },
  { key = "4", mods = "CMD", action = act.SendString("\x00" .. "4") },
  { key = "5", mods = "CMD", action = act.SendString("\x00" .. "5") },
  { key = "6", mods = "CMD", action = act.SendString("\x00" .. "6") },
  { key = "7", mods = "CMD", action = act.SendString("\x00" .. "7") },
  { key = "8", mods = "CMD", action = act.SendString("\x00" .. "8") },
  { key = "9", mods = "CMD", action = act.SendString("\x00" .. "9") },
}

config.mouse_bindings = {
  {
    event = { Up = { streak = 1, button = "Left" } },
    mods = "NONE",
    action = act.CompleteSelection("Clipboard"),
  },
}

wezterm.on("gui-startup", function(cmd)
  local args = cmd or {}
  args.width = startup_window.cols
  args.height = startup_window.rows
  args.position = {
    x = startup_window.x,
    y = startup_window.y,
    origin = "MainScreen",
  }

  mux.spawn_window(args)
end)

-- Ghostty-only preferences without a direct WezTerm equivalent:
-- window-save-state, balanced padding, display-p3 colorspace, quick terminal,
-- paste protection, and custom app icon.

return config
