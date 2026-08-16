#!/bin/bash
# Install the custom Openbox MacOS traffic-light theme
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
THEME_SRC="$SCRIPT_DIR/../themes/openbox-macos"
THEME_DEST="/usr/share/themes/MacOS-26/openbox-3"

mkdir -p "$THEME_DEST"
cp "$THEME_SRC/themerc" "$THEME_DEST/themerc"
echo "[ob-theme] ✔ Openbox macOS traffic-light theme installed"
