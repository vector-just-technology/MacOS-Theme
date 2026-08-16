#!/bin/bash
# ============================================================
#  MacOS 26.1 Theme for Raspberry Pi — MONITOR VERSION
#  vector-just-technology/MacOS-Theme
#  Full desktop transformation + overclock
# ============================================================

set -e
RED='\033[0;31m'; GREEN='\033[0;32m'; YELLOW='\033[1;33m'; CYAN='\033[0;36m'; NC='\033[0m'
log()    { echo -e "${GREEN}[✔]${NC} $1"; }
warn()   { echo -e "${YELLOW}[!]${NC} $1"; }
err()    { echo -e "${RED}[✘]${NC} $1"; exit 1; }
banner() { echo -e "\n${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n  $1\n━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}\n"; }

[ "$EUID" -ne 0 ] && err "Run as root: sudo bash install.sh"

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
USER_HOME=$(eval echo ~${SUDO_USER:-$USER})
ACTUAL_USER=${SUDO_USER:-$USER}

banner "MacOS 26.1 Theme — Monitor Edition"
echo "Target user : $ACTUAL_USER"
echo "Home        : $USER_HOME"
echo "Mode        : MONITOR (full desktop)"
echo ""

# ── 1. SYSTEM UPDATE ────────────────────────────────────────
banner "1/9 — System Update"
apt-get update -qq
apt-get upgrade -y -qq
log "System updated"

# ── 2. REMOVE OLD MacOS REMNANTS ────────────────────────────
banner "2/9 — Purging Previous MacOS Theme Installs"
bash "$SCRIPT_DIR/scripts/purge_old_macos.sh"
log "Old MacOS remnants removed"

# ── 3. INSTALL DEPENDENCIES ─────────────────────────────────
banner "3/9 — Installing Dependencies"
apt-get install -y -qq \
  openbox obconf obmenu \
  xorg xserver-xorg xinit x11-xserver-utils \
  lightdm lightdm-gtk-greeter \
  picom \
  tint2 \
  rofi \
  feh \
  nitrogen \
  lxappearance \
  gtk2-engines-murrine gtk2-engines-pixbuf \
  sassc \
  libglib2.0-dev-bin \
  fonts-inter \
  fonts-noto \
  papirus-icon-theme \
  thunar \
  mousepad \
  eog \
  vlc \
  gnome-terminal \
  nemo \
  plank \
  xdotool \
  wmctrl \
  unclutter \
  network-manager-gnome \
  pavucontrol \
  lm-sensors \
  htop \
  curl wget git jq \
  build-essential \
  python3 python3-pip \
  xdg-utils \
  dunst \
  scrot \
  gpicview
log "All packages installed"

# ── 4. OVERCLOCK ─────────────────────────────────────────────
banner "4/9 — Applying Overclock (CPU 2.9GHz + GPU)"
bash "$SCRIPT_DIR/scripts/overclock.sh"
log "Overclock config written"

# ── 5. MACVINTOSH GTK THEME (macOS 26.1 style) ───────────────
banner "5/9 — Installing MacOS 26.1 GTK Theme"
bash "$SCRIPT_DIR/scripts/install_theme.sh" "$ACTUAL_USER" "$USER_HOME"
log "GTK theme installed"

# ── 6. OPENBOX CONFIG ────────────────────────────────────────
banner "6/9 — Configuring Openbox WM"
bash "$SCRIPT_DIR/scripts/setup_openbox.sh" "$ACTUAL_USER" "$USER_HOME"
log "Openbox configured"

# ── 7. DOCK + APP LAUNCHER + TOP BAR ─────────────────────────
banner "7/9 — Setting Up Dock, Menu Bar & App Launcher"
bash "$SCRIPT_DIR/scripts/setup_desktop_ui.sh" "$ACTUAL_USER" "$USER_HOME"
log "Desktop UI configured"

# ── 8. LIGHTDM LOGIN SCREEN ──────────────────────────────────
banner "8/9 — Configuring LightDM Login Screen (MacOS style)"
bash "$SCRIPT_DIR/scripts/setup_lightdm.sh"
log "Login screen configured"

# ── 9. AUTOSTART ─────────────────────────────────────────────
banner "9/9 — Setting Up Autostart"
bash "$SCRIPT_DIR/scripts/setup_autostart.sh" "$ACTUAL_USER" "$USER_HOME" "monitor"
log "Autostart configured"

# ── DONE ──────────────────────────────────────────────────────
echo ""
echo -e "${GREEN}╔══════════════════════════════════════════╗${NC}"
echo -e "${GREEN}║  MacOS 26.1 Theme — Install Complete!    ║${NC}"
echo -e "${GREEN}║  Reboot to apply overclock + full theme  ║${NC}"
echo -e "${GREEN}╚══════════════════════════════════════════╝${NC}"
echo ""
read -p "Reboot now? [Y/n] " ans
[[ "${ans,,}" != "n" ]] && reboot
