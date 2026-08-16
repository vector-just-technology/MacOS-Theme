#!/bin/bash
# ============================================================
#  LightDM — macOS 26.1 style login screen
# ============================================================

# Set default session to openbox
cat > /etc/lightdm/lightdm.conf << 'LDMEOF'
[Seat:*]
autologin-user=
autologin-user-timeout=0
user-session=openbox
greeter-session=lightdm-gtk-greeter
session-wrapper=/etc/X11/Xsession
LDMEOF

# GTK greeter config — macOS style
cat > /etc/lightdm/lightdm-gtk-greeter.conf << 'GEOF'
[greeter]
theme-name = WhiteSur-Light
icon-theme-name = WhiteSur
cursor-theme-name = WhiteSur-cursors
background = /usr/share/backgrounds/macos26-login.jpg
font-name = Inter 12
indicators = ~clock;~spacer;~session;~power
clock-format = %H:%M · %A %d %B %Y
position = 50%,center 50%,center
panel-position = top
hide-user-image = false
round-user-image = true
user-image = /usr/share/pixmaps/faces/user-generic.png
GEOF

# Download or create login background
mkdir -p /usr/share/backgrounds
if [ -f "$HOME/Pictures/Wallpapers/macos26.jpg" ]; then
  cp "$HOME/Pictures/Wallpapers/macos26.jpg" /usr/share/backgrounds/macos26-login.jpg
else
  # Generate with ImageMagick as fallback
  command -v convert &>/dev/null && \
    convert -size 1920x1080 gradient:"#9bc4ea-#1d4e89" \
    /usr/share/backgrounds/macos26-login.jpg 2>/dev/null || \
    cp /usr/share/pixmaps/debian-logo.png /usr/share/backgrounds/macos26-login.jpg 2>/dev/null || true
fi

# Enable LightDM
systemctl enable lightdm 2>/dev/null || true

echo "[lightdm] ✔ Login screen configured"
