#!/bin/bash
# ============================================================
#  Overclock: CPU → 2.9GHz | GPU → 750MHz
#  Supports RPi 4 and RPi 5
# ============================================================

CONFIG="/boot/firmware/config.txt"
[ -f /boot/config.txt ] && CONFIG="/boot/config.txt"

# Backup
cp "$CONFIG" "${CONFIG}.backup_macos_$(date +%Y%m%d_%H%M%S)"

# Detect Pi model
PI_MODEL=$(cat /proc/device-tree/model 2>/dev/null || echo "Unknown")

# Remove old overclock lines
sed -i '/^over_voltage=/d' "$CONFIG"
sed -i '/^arm_freq=/d' "$CONFIG"
sed -i '/^gpu_freq=/d' "$CONFIG"
sed -i '/^arm_boost=/d' "$CONFIG"
sed -i '/^force_turbo=/d' "$CONFIG"
sed -i '/^cpu_freq_max=/d' "$CONFIG"

echo "" >> "$CONFIG"
echo "# ── MacOS Theme Overclock ─────────────────────" >> "$CONFIG"

if echo "$PI_MODEL" | grep -q "Raspberry Pi 5"; then
  echo "# Raspberry Pi 5 overclock" >> "$CONFIG"
  echo "arm_freq=2900" >> "$CONFIG"
  echo "over_voltage=6" >> "$CONFIG"
  echo "gpu_freq=750" >> "$CONFIG"
  # Pi 5 uses force_turbo differently — use arm_boost
  echo "arm_boost=1" >> "$CONFIG"
  echo "[Overclock] Pi 5 → CPU 2.9GHz, GPU 750MHz applied"
elif echo "$PI_MODEL" | grep -q "Raspberry Pi 4"; then
  echo "# Raspberry Pi 4 overclock" >> "$CONFIG"
  echo "over_voltage=6" >> "$CONFIG"
  echo "arm_freq=2000" >> "$CONFIG"
  # Pi 4 max stable is ~2.1GHz; we push to 2.1 safely, note below
  echo "gpu_freq=750" >> "$CONFIG"
  echo "force_turbo=1" >> "$CONFIG"
  echo ""
  echo -e "\033[1;33m[!] RPi 4 detected: CPU set to 2.0GHz (hardware max ~2.1GHz)."
  echo -e "    2.9GHz is only achievable on RPi 5. GPU set to 750MHz.\033[0m"
else
  echo "# Generic / RPi 3 overclock (conservative)" >> "$CONFIG"
  echo "over_voltage=4" >> "$CONFIG"
  echo "arm_freq=1400" >> "$CONFIG"
  echo "gpu_freq=500" >> "$CONFIG"
  echo ""
  echo -e "\033[1;33m[!] Unknown model — conservative overclock applied.\033[0m"
fi

echo "# ── End Overclock ─────────────────────────────" >> "$CONFIG"

# GPU memory split — give more to GPU for display
sed -i '/^gpu_mem=/d' "$CONFIG"
echo "gpu_mem=256" >> "$CONFIG"

echo -e "\033[0;32m[✔] Overclock written to $CONFIG\033[0m"
echo -e "\033[0;32m[✔] GPU memory: 256MB\033[0m"
echo -e "\033[1;33m[!] A heatsink + fan is STRONGLY recommended.\033[0m"
