#!/bin/bash
# Removes any previous MacOS theme installs to ensure clean state

USER_HOME=${USER_HOME:-$HOME}

echo "[purge] Removing old MacOS GTK themes..."
rm -rf /usr/share/themes/WhiteSur* 2>/dev/null
rm -rf /usr/share/themes/Mc* 2>/dev/null
rm -rf /usr/share/themes/macOS* 2>/dev/null
rm -rf /usr/share/themes/Mac* 2>/dev/null
rm -rf "$USER_HOME/.themes/WhiteSur*" 2>/dev/null
rm -rf "$USER_HOME/.themes/macOS*" 2>/dev/null
rm -rf "$USER_HOME/.themes/Mac*" 2>/dev/null
rm -rf "$USER_HOME/.local/share/themes/WhiteSur*" 2>/dev/null
rm -rf "$USER_HOME/.local/share/themes/macOS*" 2>/dev/null

echo "[purge] Removing old MacOS icon themes..."
rm -rf /usr/share/icons/WhiteSur* 2>/dev/null
rm -rf /usr/share/icons/macOS* 2>/dev/null
rm -rf "$USER_HOME/.local/share/icons/WhiteSur*" 2>/dev/null

echo "[purge] Removing old plank/dock configs..."
rm -rf "$USER_HOME/.config/plank" 2>/dev/null

echo "[purge] Removing old tint2/openbox MacOS configs..."
rm -f "$USER_HOME/.config/tint2/macos*" 2>/dev/null
rm -f "$USER_HOME/.config/openbox/macos*" 2>/dev/null

echo "[purge] Removing old rofi MacOS configs..."
rm -f "$USER_HOME/.config/rofi/macos*" 2>/dev/null

echo "[purge] Removing old wallpaper scripts..."
rm -f /usr/local/bin/macos-wallpaper* 2>/dev/null
rm -f /usr/local/bin/macos-theme* 2>/dev/null

echo "[purge] Done — system clean for fresh install."
