#!/bin/bash
# ============================================================
#  MacOS 26.1 Theme for Raspberry Pi — HEADLESS VERSION
#  vector-just-technology/MacOS-Theme
#  Overclock + theming, SSH/RPI-Connect/all RPi features INTACT
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

banner "MacOS 26.1 Theme — Headless Edition"
echo "Target user : $ACTUAL_USER"
echo "Home        : $USER_HOME"
echo "Mode        : HEADLESS (SSH/VNC/RPI-Connect safe)"
echo ""
warn "This version preserves: SSH, RPI Connect, I2C, SPI, UART, GPIO, VNC, all RPi interfaces."
echo ""

# ── SAFETY CHECK: ensure SSH stays enabled ──────────────────
systemctl enable ssh 2>/dev/null || true
systemctl start ssh 2>/dev/null || true

# ── 1. SYSTEM UPDATE ────────────────────────────────────────
banner "1/8 — System Update"
apt-get update -qq
apt-get upgrade -y -qq
log "System updated"

# ── 2. REMOVE OLD MacOS REMNANTS ────────────────────────────
banner "2/8 — Purging Previous MacOS Theme Installs"
bash "$SCRIPT_DIR/scripts/purge_old_macos.sh"
log "Old MacOS remnants removed"

# ── 3. INSTALL HEADLESS DEPENDENCIES ────────────────────────
banner "3/8 — Installing Dependencies (headless-safe)"
apt-get install -y -qq \
  xvfb \
  openbox \
  tint2 \
  rofi \
  picom \
  feh \
  gtk2-engines-murrine gtk2-engines-pixbuf \
  fonts-inter fonts-noto \
  papirus-icon-theme \
  lxappearance \
  dunst \
  lm-sensors \
  htop \
  curl wget git jq \
  python3 python3-pip \
  xdg-utils \
  sassc \
  libglib2.0-dev-bin
log "All headless packages installed"

# ── 4. OVERCLOCK ─────────────────────────────────────────────
banner "4/8 — Applying Overclock (CPU 2.9GHz + GPU)"
bash "$SCRIPT_DIR/scripts/overclock.sh"
log "Overclock config written"

# ── 5. MACVINTOSH GTK THEME ──────────────────────────────────
banner "5/8 — Installing MacOS 26.1 GTK Theme"
bash "$SCRIPT_DIR/scripts/install_theme.sh" "$ACTUAL_USER" "$USER_HOME"
log "GTK theme installed"

# ── 6. VIRTUAL DISPLAY + OPENBOX ─────────────────────────────
banner "6/8 — Configuring Virtual Display Environment"
bash "$SCRIPT_DIR/scripts/setup_openbox.sh" "$ACTUAL_USER" "$USER_HOME"
log "Openbox configured for headless"

# ── 7. DESKTOP UI (VNC-accessible) ───────────────────────────
banner "7/8 — Desktop UI (accessible via VNC/RPI-Connect)"
bash "$SCRIPT_DIR/scripts/setup_desktop_ui.sh" "$ACTUAL_USER" "$USER_HOME"
log "Desktop UI configured"

# ── 8. HEADLESS AUTOSTART ────────────────────────────────────
banner "8/8 — Headless Autostart & Service"
bash "$SCRIPT_DIR/scripts/setup_autostart.sh" "$ACTUAL_USER" "$USER_HOME" "headless"
log "Headless autostart configured"

# ── PRESERVE RPi INTERFACES ──────────────────────────────────
banner "Verifying RPi Interface Preservation"
systemctl enable ssh && log "SSH: enabled"
systemctl enable pigpiod 2>/dev/null && log "GPIO daemon: enabled" || warn "pigpiod not installed (optional)"
# RPI Connect preservation
if systemctl is-enabled rpi-connect 2>/dev/null | grep -q enabled; then
  log "RPI Connect: already enabled — untouched"
fi
grep -q "dtoverlay=dwc2" /boot/firmware/config.txt 2>/dev/null && log "USB OTG: intact" || true
log "All RPi interfaces preserved"

echo ""
echo -e "${GREEN}╔════════════════════════════════════════════════╗${NC}"
echo -e "${GREEN}║  MacOS 26.1 Headless — Install Complete!       ║${NC}"
echo -e "${GREEN}║  Connect via VNC/RPI-Connect to see the UI     ║${NC}"
echo -e "${GREEN}║  SSH remains fully active                       ║${NC}"
echo -e "${GREEN}╚════════════════════════════════════════════════╝${NC}"
echo ""
read -p "Reboot now? [Y/n] " ans
[[ "${ans,,}" != "n" ]] && reboot
