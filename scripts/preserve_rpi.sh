#!/bin/bash
# ============================================================
#  RPi Interface Preservation — HEADLESS VERSION ONLY
#  Ensures SSH, RPI Connect, GPIO, I2C, SPI, UART, VNC
#  are all left completely intact and enabled
# ============================================================

CONFIG="/boot/firmware/config.txt"
[ -f /boot/config.txt ] && CONFIG="/boot/config.txt"

echo "[rpi-preserve] Ensuring all RPi interfaces remain enabled..."

# ── SSH ──────────────────────────────────────────────────────
systemctl enable ssh 2>/dev/null && echo "[✔] SSH: enabled"
systemctl start ssh 2>/dev/null || true

# ── RPI Connect ──────────────────────────────────────────────
if systemctl list-unit-files | grep -q rpi-connect; then
  systemctl enable rpi-connect 2>/dev/null && echo "[✔] RPI Connect: enabled"
  systemctl start rpi-connect 2>/dev/null || true
else
  echo "[i] RPI Connect not installed — skipping"
fi

# ── VNC ──────────────────────────────────────────────────────
if systemctl list-unit-files | grep -q vncserver; then
  systemctl enable vncserver-x11-serviced 2>/dev/null && echo "[✔] VNC: enabled"
fi
if command -v raspi-config &>/dev/null; then
  raspi-config nonint do_vnc 0 2>/dev/null && echo "[✔] VNC: enabled via raspi-config"
fi

# ── I2C ──────────────────────────────────────────────────────
if ! grep -q "^dtparam=i2c_arm=on" "$CONFIG"; then
  echo "dtparam=i2c_arm=on" >> "$CONFIG"
fi
modprobe i2c-dev 2>/dev/null || true
echo "[✔] I2C: enabled"

# ── SPI ──────────────────────────────────────────────────────
if ! grep -q "^dtparam=spi=on" "$CONFIG"; then
  echo "dtparam=spi=on" >> "$CONFIG"
fi
echo "[✔] SPI: enabled"

# ── UART ─────────────────────────────────────────────────────
if ! grep -q "^enable_uart=1" "$CONFIG"; then
  echo "enable_uart=1" >> "$CONFIG"
fi
echo "[✔] UART: enabled"

# ── GPIO (pigpiod) ───────────────────────────────────────────
if command -v pigpiod &>/dev/null; then
  systemctl enable pigpiod 2>/dev/null && echo "[✔] GPIO daemon: enabled"
fi

# ── Camera ───────────────────────────────────────────────────
if ! grep -q "^start_x=1" "$CONFIG" && ! grep -q "^camera_auto_detect" "$CONFIG"; then
  echo "camera_auto_detect=1" >> "$CONFIG"
fi
echo "[✔] Camera: preserved"

# ── Audio ────────────────────────────────────────────────────
if ! grep -q "^dtparam=audio=on" "$CONFIG"; then
  echo "dtparam=audio=on" >> "$CONFIG"
fi
echo "[✔] Audio: enabled"

# ── USB OTG ──────────────────────────────────────────────────
if grep -q "dtoverlay=dwc2" "$CONFIG"; then
  echo "[✔] USB OTG: already configured"
fi

# ── Confirm no display outputs were disabled ──────────────────
sed -i '/^hdmi_blanking=1/d' "$CONFIG" 2>/dev/null || true

echo ""
echo "[rpi-preserve] ✔ All RPi interfaces preserved and active"
echo "[rpi-preserve] SSH port: 22 (default)"
echo "[rpi-preserve] VNC port: 5900 (default)"
