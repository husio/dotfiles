
modkey = "Mod4"
terminal = "xterm"
editor = os.getenv("EDITOR") or "vim"
editor_cmd = terminal .. " -e " .. editor

theme_path = os.getenv("HOME") .. "/.config/awesome/themes/gray/theme"
