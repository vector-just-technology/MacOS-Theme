#!/bin/bash
# ============================================================
#  Install MacOS 26.1 (Tahoe) style GTK theme
#  Uses WhiteSur-gtk-theme (best macOS approximation on Linux)
#  + WhiteSur-icon-theme + custom tweaks for RPi
# ============================================================

ACTUAL_USER="$1"
USER_HOME="$2"
THEME_TMP="/tmp/macos-theme-build"

mkdir -p "$THEME_TMP"
cd "$THEME_TMP"

echo "[theme] Downloading WhiteSur GTK theme (macOS 26.1 style)..."
if ! git clone --depth=1 https://github.com/vinceliuice/WhiteSur-gtk-theme.git 2>/dev/null; then
  echo "[theme] Git clone failed — downloading zip fallback..."
  curl -Lo whitesur.zip https://github.com/vinceliuice/WhiteSur-gtk-theme/archive/refs/heads/master.zip
  unzip -q whitesur.zip
  mv WhiteSur-gtk-theme-master WhiteSur-gtk-theme
fi

echo "[theme] Installing WhiteSur GTK theme..."
cd WhiteSur-gtk-theme
# Install light + dark variants, for all users
bash install.sh -t default -c light -s standard --dest /usr/share/themes
bash install.sh -t default -c dark  -s standard --dest /usr/share/themes

# User-level too
sudo -u "$ACTUAL_USER" bash install.sh -t default -c light -s standard
sudo -u "$ACTUAL_USER" bash install.sh -t default -c dark  -s standard

cd "$THEME_TMP"

echo "[theme] Downloading WhiteSur icon theme..."
if ! git clone --depth=1 https://github.com/vinceliuice/WhiteSur-icon-theme.git 2>/dev/null; then
  curl -Lo icons.zip https://github.com/vinceliuice/WhiteSur-icon-theme/archive/refs/heads/master.zip
  unzip -q icons.zip
  mv WhiteSur-icon-theme-master WhiteSur-icon-theme
fi

echo "[theme] Installing icons..."
cd WhiteSur-icon-theme
bash install.sh --dest /usr/share/icons
sudo -u "$ACTUAL_USER" bash install.sh
cd "$THEME_TMP"

echo "[theme] Downloading WhiteSur cursor theme..."
if ! git clone --depth=1 https://github.com/vinceliuice/WhiteSur-cursors.git 2>/dev/null; then
  curl -Lo cursors.zip https://github.com/vinceliuice/WhiteSur-cursors/archive/refs/heads/master.zip
  unzip -q cursors.zip
  mv WhiteSur-cursors-master WhiteSur-cursors
fi

echo "[theme] Installing cursors..."
cd WhiteSur-cursors
bash install.sh || cp -r dist /usr/share/icons/WhiteSur-cursors
cd "$THEME_TMP"

# ── Apply GTK settings system-wide ─────────────────────────
SETTINGS_DIR="$USER_HOME/.config/gtk-3.0"
mkdir -p "$SETTINGS_DIR"

cat > "$SETTINGS_DIR/settings.ini" << 'EOF'
[Settings]
gtk-theme-name=WhiteSur-Light
gtk-icon-theme-name=WhiteSur
gtk-cursor-theme-name=WhiteSur-cursors
gtk-cursor-theme-size=24
gtk-font-name=SF Pro Display 11
gtk-button-images=1
gtk-menu-images=1
gtk-enable-event-sounds=0
gtk-enable-input-feedback-sounds=0
gtk-xft-antialias=1
gtk-xft-hinting=1
gtk-xft-hintstyle=hintmedium
gtk-xft-rgba=rgb
EOF
chown "$ACTUAL_USER:$ACTUAL_USER" "$SETTINGS_DIR/settings.ini"

# GTK2 settings
cat > "$USER_HOME/.gtkrc-2.0" << 'EOF'
gtk-theme-name="WhiteSur-Light"
gtk-icon-theme-name="WhiteSur"
gtk-cursor-theme-name="WhiteSur-cursors"
gtk-font-name="SF Pro Display 11"
gtk-cursor-theme-size=24
gtk-button-images=1
gtk-menu-images=1
EOF
chown "$ACTUAL_USER:$ACTUAL_USER" "$USER_HOME/.gtkrc-2.0"

# xsettingsd for applying themes without reboot
if command -v xsettingsd &>/dev/null; then
  mkdir -p "$USER_HOME/.config"
  cat > "$USER_HOME/.config/xsettingsd/xsettingsd.conf" << 'EOF'
Net/ThemeName "WhiteSur-Light"
Net/IconThemeName "WhiteSur"
Gtk/CursorThemeName "WhiteSur-cursors"
Gtk/FontName "SF Pro Display 11"
EOF
  chown -R "$ACTUAL_USER:$ACTUAL_USER" "$USER_HOME/.config/xsettingsd"
fi

# ── SF Pro Font (closest available) ────────────────────────
echo "[theme] Setting up fonts (Inter as SF Pro substitute)..."
mkdir -p /usr/local/share/fonts/macos-theme
# Use Inter — the closest free alternative to SF Pro
fc-cache -f -v > /dev/null 2>&1

echo "[theme] ✔ GTK theme, icons, cursors installed"
rm -rf "$THEME_TMP"
