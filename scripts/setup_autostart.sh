#!/bin/bash
# ============================================================
#  Autostart — handles both monitor and headless modes
# ============================================================

ACTUAL_USER="$1"
USER_HOME="$2"
MODE="$3"  # "monitor" or "headless"

OB_AUTOSTART="$USER_HOME/.config/openbox/autostart"
mkdir -p "$USER_HOME/.config/openbox"

# ── OPENBOX AUTOSTART ────────────────────────────────────────
cat > "$OB_AUTOSTART" << ASEOF
#!/bin/bash
# MacOS 26.1 Theme — Openbox Autostart
# Mode: $MODE

# ── Display environment ─────────────────────────────────────
xset s off &
xset -dpms &
xset s noblank &
xrandr --dpi 96 &

# ── Hide mouse cursor when idle ─────────────────────────────
unclutter --idle 3 --root &

# ── Compositor (frosted glass, shadows, rounded corners) ────
sleep 0.5 && picom --config ~/.config/picom/picom.conf --daemon &

# ── Wallpaper ───────────────────────────────────────────────
WALLPAPER=~/Pictures/Wallpapers/macos26.jpg
if [ ! -f "\$WALLPAPER" ] || [ ! -s "\$WALLPAPER" ]; then
  bash ~/Pictures/Wallpapers/generate_wallpaper.sh 2>/dev/null || true
  WALLPAPER=~/Pictures/Wallpapers/tahoe.png
fi
feh --bg-fill "\$WALLPAPER" 2>/dev/null || \
  nitrogen --set-scaled "\$WALLPAPER" 2>/dev/null &

# ── Top menu bar ────────────────────────────────────────────
sleep 0.5 && tint2 -c ~/.config/tint2/menubar.tint2rc &

# ── Bottom dock ─────────────────────────────────────────────
sleep 0.8 && tint2 -c ~/.config/tint2/dock.tint2rc &

# ── Notification daemon ─────────────────────────────────────
dunst &

# ── Network manager applet ──────────────────────────────────
if command -v nm-applet &>/dev/null; then
  sleep 1 && nm-applet &
fi

# ── Apply GTK theme via xsettingsd ──────────────────────────
if command -v xsettingsd &>/dev/null; then
  xsettingsd &
fi

# ── Mode-specific ────────────────────────────────────────────
if [ "$MODE" = "headless" ]; then
  # VNC server for remote access
  if command -v vncserver &>/dev/null; then
    vncserver :1 -geometry 1920x1080 -depth 24 2>/dev/null &
  fi
fi

# ── Done notification ────────────────────────────────────────
sleep 2 && notify-send "MacOS 26.1" "Welcome to your Raspberry Pi desktop" \
  --icon=computer --urgency=low &
ASEOF

chmod +x "$OB_AUTOSTART"
chown "$ACTUAL_USER:$ACTUAL_USER" "$OB_AUTOSTART"

# ── .XINITRC for startx fallback ─────────────────────────────
cat > "$USER_HOME/.xinitrc" << 'XEOF'
#!/bin/bash
exec openbox-session
XEOF
chmod +x "$USER_HOME/.xinitrc"
chown "$ACTUAL_USER:$ACTUAL_USER" "$USER_HOME/.xinitrc"

# ── HEADLESS: systemd service for Xvfb + Openbox ────────────
if [ "$MODE" = "headless" ]; then
  cat > /etc/systemd/system/macos-desktop.service << SVCEOF
[Unit]
Description=MacOS Theme — Headless Desktop (Xvfb + Openbox)
After=network.target
After=systemd-user-sessions.service

[Service]
User=$ACTUAL_USER
Environment=DISPLAY=:0
ExecStartPre=/usr/bin/Xvfb :0 -screen 0 1920x1080x24 &
ExecStart=/usr/bin/openbox-session
Restart=on-failure
RestartSec=5

[Install]
WantedBy=multi-user.target
SVCEOF

  # Better headless: use X wrapper script
  cat > /usr/local/bin/macos-headless-start << HEOF
#!/bin/bash
export DISPLAY=:0
Xvfb :0 -screen 0 1920x1080x24 -ac +extension GLX &
XPID=\$!
sleep 1
sudo -u $ACTUAL_USER DISPLAY=:0 openbox-session &
wait \$XPID
HEOF
  chmod +x /usr/local/bin/macos-headless-start

  systemctl daemon-reload
  systemctl enable macos-desktop.service
  echo "[autostart] ✔ Headless systemd service installed"
fi

# ── DUNST notification config ───────────────────────────────
mkdir -p "$USER_HOME/.config/dunst"
cat > "$USER_HOME/.config/dunst/dunstrc" << 'DUNSTEOF'
[global]
monitor = 0
follow = mouse
geometry = "380x5-20+40"
indicate_hidden = yes
shrink = no
transparency = 8
notification_height = 0
separator_height = 2
padding = 12
horizontal_padding = 14
frame_width = 1
frame_color = "#d0d0d0"
separator_color = frame
sort = yes
idle_threshold = 120
font = Inter 11
line_height = 0
markup = full
format = "<b>%s</b>\n%b"
alignment = left
vertical_alignment = center
show_age_threshold = 60
word_wrap = yes
ellipsize = middle
ignore_newline = no
stack_duplicates = true
hide_duplicate_count = false
show_indicators = yes
icon_position = left
min_icon_size = 24
max_icon_size = 32
icon_path = /usr/share/icons/WhiteSur/
sticky_history = yes
history_length = 20
browser = /usr/bin/chromium-browser --new-window
always_run_script = true
title = Dunst
class = Dunst
corner_radius = 10
ignore_dbusclose = false
force_xwayland = false
force_xinerama = false
mouse_left_click = close_current
mouse_middle_click = do_action, close_current
mouse_right_click = close_all

[urgency_low]
background = "#f5f5f5ee"
foreground = "#1a1a1a"
frame_color = "#d0d0d0"
timeout = 5
icon = dialog-information

[urgency_normal]
background = "#f5f5f5ee"
foreground = "#1a1a1a"
frame_color = "#d0d0d0"
timeout = 8
icon = dialog-information

[urgency_critical]
background = "#ff3b30ee"
foreground = "#ffffff"
frame_color = "#cc2a20"
timeout = 0
icon = dialog-error
DUNSTEOF

chown -R "$ACTUAL_USER:$ACTUAL_USER" "$USER_HOME/.config/dunst"
echo "[autostart] ✔ Autostart + notifications configured"
