#!/bin/bash
# ============================================================
#  Desktop UI: macOS 26.1 style
#  - Top menu bar (tint2)
#  - Bottom dock (tint2 or plank)
#  - Rofi spotlight-style app launcher
#  - Picom compositor (blur, shadows, transparency)
#  - Wallpaper
# ============================================================

ACTUAL_USER="$1"
USER_HOME="$2"

mkdir -p "$USER_HOME/.config/tint2"
mkdir -p "$USER_HOME/.config/rofi"
mkdir -p "$USER_HOME/.config/picom"
mkdir -p "$USER_HOME/.config/plank"
mkdir -p "$USER_HOME/.local/share/applications"
mkdir -p "$USER_HOME/Pictures/Wallpapers"

# ── TINT2: TOP MENU BAR ─────────────────────────────────────
cat > "$USER_HOME/.config/tint2/menubar.tint2rc" << 'T2EOF'
# MacOS 26.1 Style Top Menu Bar

# Panel geometry
panel_size = 100% 28
panel_position = top center horizontal
panel_margin = 0 0
panel_padding = 4 0 4
panel_background_id = 1
panel_layer = top
panel_monitor = all

# Autohide
autohide = 0

# Strut: push windows below the bar
strut_policy = follow_size

# Wm menu
wm_menu = 0

# Taskbar
taskbar_mode = multi_desktop
taskbar_padding = 0 0 4
taskbar_background_id = 0
taskbar_active_background_id = 2

# Tasks
task_centered = 1
task_maximum_size = 160 22
task_padding = 4 2 4
task_background_id = 0
task_active_background_id = 3
task_text = 1
task_icon = 1
task_icon_asb = 100 0 0
task_font = Inter Bold 10
task_font_color = #1a1a1a 100
task_active_font_color = #1a1a1a 100
urgent_nb_of_blink = 8
task_tooltip = 1

# Clock
time1_format = %H:%M
time1_font = Inter SemiBold 11
time1_timezone =
time1_font_color = #1a1a1a 100
time2_format = %a %b %d
time2_font = Inter 9
time2_font_color = #1a1a1a 75
clock_padding = 6 0
clock_background_id = 0
clock_tooltip = %A %d %B %Y
clock_lclick_command =

# System tray
systray_padding = 4 4 4
systray_background_id = 0
systray_sort = ascending
systray_icon_size = 18
systray_icon_asb = 100 0 0
systray_monitor = 1

# Battery
battery = 1
battery_hide = 99
battery_low_threshold = 20
battery_low_cmd = notify-send "Battery low"
battery_font_color = #1a1a1a 100
battery_font = Inter 9
battery_padding = 4 0
battery_background_id = 0

# Launcher (Apple logo → app launcher)
launcher_padding = 6 4 6
launcher_background_id = 0
launcher_icon_background_id = 0
launcher_icon_size = 18
launcher_icon_asb = 100 0 0
launcher_icon_theme = WhiteSur
launcher_tooltip = 1

launcher_item_app = /usr/share/applications/rofi-launcher.desktop

# Panel items: Apple menu | tasks | tray | battery | clock
panel_items = LTSC

# Backgrounds
rounded = 0
border_width = 0
background_color = #f0f0f0 92
border_color = #cccccc 100

# BG 1: Menu bar
rounded = 0
border_width = 0
background_color = #ececec 94
border_color = #d0d0d0 80

# BG 2: Desktop switcher active
rounded = 4
border_width = 0
background_color = #d5d5d5 80
border_color = #aaaaaa 60

# BG 3: Active task
rounded = 6
border_width = 0
background_color = #0071e3 15
border_color = #0071e3 30

# Separator
separator_color = #aaaaaa 60
T2EOF

# ── TINT2: BOTTOM DOCK BAR ──────────────────────────────────
cat > "$USER_HOME/.config/tint2/dock.tint2rc" << 'DOCKEOF'
# MacOS 26.1 Style Dock (bottom bar)

panel_size = 65% 60
panel_position = bottom center horizontal
panel_margin = 0 8
panel_padding = 8 4 8
panel_background_id = 1
panel_layer = top
panel_monitor = primary
strut_policy = none

autohide = 1
autohide_show_timeout = 0.1
autohide_hide_timeout = 1.0
autohide_height = 2

# No taskbar in dock
taskbar_mode = none

# Launcher icons only
launcher_padding = 6 4 6
launcher_background_id = 0
launcher_icon_background_id = 2
launcher_icon_size = 46
launcher_icon_asb = 100 0 0
launcher_icon_theme = WhiteSur
launcher_tooltip = 1

launcher_item_app = /usr/share/applications/nemo.desktop
launcher_item_app = /usr/share/applications/gnome-terminal.desktop
launcher_item_app = /usr/share/applications/chromium-browser.desktop
launcher_item_app = /usr/share/applications/mousepad.desktop
launcher_item_app = /usr/share/applications/vlc.desktop
launcher_item_app = /usr/share/applications/pavucontrol.desktop

panel_items = L

# Separator
separator_color = #ffffff 30

# BG 1: Dock pill
rounded = 16
border_width = 1
background_color = #f5f5f5 82
border_color = #d0d0d0 60

# BG 2: Icon hover
rounded = 10
border_width = 0
background_color = #0071e3 15
border_color = #0071e3 0
DOCKEOF

# ── ROFI: SPOTLIGHT-STYLE APP LAUNCHER ──────────────────────
cat > "$USER_HOME/.config/rofi/macos.rasi" << 'ROFIEOF'
/* MacOS 26.1 Spotlight Style — Rofi Theme */

* {
    font:                   "Inter 13";
    background-color:       transparent;
    text-color:             #1a1a1a;
    border-color:           transparent;
}

window {
    transparency:           "real";
    background-color:       rgba(245,245,245,0.92);
    border-radius:          12px;
    border:                 1px solid rgba(180,180,180,0.8);
    width:                  600px;
    location:               center;
    y-offset:               -100;
    padding:                0;
    children:               [mainbox];
    /* macOS-style box shadow via border */
}

mainbox {
    background-color:       transparent;
    children:               [inputbar, listview];
    spacing:                0;
    padding:                0;
}

inputbar {
    background-color:       transparent;
    border:                 0 0 1px 0;
    border-color:           rgba(180,180,180,0.5);
    children:               [prompt, entry];
    padding:                12px 16px;
    spacing:                8px;
}

prompt {
    font:                   "Inter SemiBold 14";
    text-color:             #0071e3;
    background-color:       transparent;
    vertical-align:         0.5;
}

entry {
    font:                   "Inter 14";
    background-color:       transparent;
    text-color:             #1a1a1a;
    placeholder:            "Search apps, files, web…";
    placeholder-color:      rgba(100,100,100,0.6);
    vertical-align:         0.5;
    cursor:                 text;
}

listview {
    background-color:       transparent;
    lines:                  7;
    columns:                1;
    spacing:                2px;
    padding:                8px;
    scrollbar:              false;
    dynamic:                true;
}

element {
    background-color:       transparent;
    border-radius:          8px;
    padding:                8px 12px;
    spacing:                10px;
    children:               [element-icon, element-text];
    orientation:            horizontal;
}

element selected {
    background-color:       rgba(0,113,227,0.15);
}

element-icon {
    size:                   28px;
    background-color:       transparent;
}

element-text {
    font:                   "Inter 12";
    background-color:       transparent;
    text-color:             inherit;
    vertical-align:         0.5;
    highlight:              bold #0071e3;
}

element-text selected {
    text-color:             #1a1a1a;
}

scrollbar {
    background-color:       transparent;
    handle-color:           rgba(100,100,100,0.5);
    handle-width:           4px;
    border:                 0;
}
ROFIEOF

# Rofi config
mkdir -p "$USER_HOME/.config/rofi"
cat > "$USER_HOME/.config/rofi/config.rasi" << 'RCONFEOF'
configuration {
  modi:           "drun,run,window";
  show-icons:     true;
  icon-theme:     "WhiteSur";
  drun-display-format: "{name}";
  display-drun:   " Apps";
  display-run:    " Run";
  display-window: " Windows";
  sidebar-mode:   false;
  sort:           true;
  sorting-method: "fzf";
  matching:       "fuzzy";
}
RCONFEOF

# ── PICOM COMPOSITOR ────────────────────────────────────────
cat > "$USER_HOME/.config/picom/picom.conf" << 'PICOMEOF'
# ── MacOS 26.1 style picom ──────────────────────────────────

# Shadows
shadow = true;
shadow-radius = 20;
shadow-offset-x = -10;
shadow-offset-y = -5;
shadow-opacity = 0.25;
shadow-exclude = [
  "class_g = 'Cairo-clock'",
  "class_g = 'tint2'",
  "_GTK_FRAME_EXTENTS@:c",
  "window_type = 'dock'",
  "window_type = 'desktop'",
  "window_type = 'notification'",
  "name = 'Notification'",
];

# Fading
fading = true;
fade-delta = 6;
fade-in-step = 0.05;
fade-out-step = 0.05;
no-fading-openclose = false;
no-fading-destroyed-argb = true;

# Transparency / Opacity
inactive-opacity = 0.97;
active-opacity = 1.0;
frame-opacity = 1.0;
inactive-opacity-override = false;

# Blur background (macOS frosted glass)
blur-method = "dual_kawase";
blur-strength = 8;
blur-kern = "3x3box";
blur-background = true;
blur-background-frame = false;
blur-background-fixed = false;
blur-background-exclude = [
  "window_type = 'dock'",
  "window_type = 'desktop'",
  "_GTK_FRAME_EXTENTS@:c",
];

# Rounded corners (macOS 26.1 style)
corner-radius = 12;
rounded-corners-exclude = [
  "window_type = 'dock'",
  "window_type = 'desktop'",
];

# Backend
backend = "glx";
vsync = true;
mark-wmwin-focused = true;
mark-ovredir-focused = true;
detect-rounded-corners = true;
detect-client-opacity = true;
detect-transient = true;
detect-client-leader = true;
use-damage = true;
log-level = "warn";

# GLX options
glx-no-stencil = true;
glx-copy-from-front = false;
glx-use-copysubbuffermesa = false;
glx-no-rebind-pixmap = false;

# Window type rules
wintypes:
{
  tooltip = { fade = true; shadow = true; opacity = 0.95; focus = true; full-shadow = false; };
  dock = { shadow = false; clip-shadow-above = true; };
  dnd = { shadow = false; };
  popup_menu = { opacity = 0.97; shadow = true; };
  dropdown_menu = { opacity = 0.97; shadow = true; };
};
PICOMEOF

# ── WALLPAPER DOWNLOAD ──────────────────────────────────────
echo "[ui] Downloading macOS 26.1 style wallpaper..."
# macOS 26 Tahoe / Sequoia style — use a gradient script if download fails
cat > "$USER_HOME/Pictures/Wallpapers/generate_wallpaper.sh" << 'WPEOF'
#!/bin/bash
# Generates a macOS 26.1 Tahoe-style gradient wallpaper
python3 << 'PYEOF'
try:
    from PIL import Image, ImageDraw, ImageFilter
    import math

    w, h = 1920, 1080
    img = Image.new("RGB", (w, h))
    draw = ImageDraw.Draw(img)

    # macOS 26 Tahoe palette — deep lake blues + golden hour
    for y in range(h):
        t = y / h
        if t < 0.35:
            # Sky: ice blue to cerulean
            r = int(180 - t/0.35 * 60)
            g = int(210 - t/0.35 * 30)
            b = int(240 - t/0.35 * 20)
        elif t < 0.65:
            # Mountain zone: deep blue
            tt = (t - 0.35) / 0.30
            r = int(120 - tt * 40)
            g = int(180 - tt * 60)
            b = int(220 - tt * 40)
        else:
            # Lake reflection: dark deep blue
            tt = (t - 0.65) / 0.35
            r = int(80 - tt * 20)
            g = int(120 - tt * 40)
            b = int(180 - tt * 60)
        draw.line([(0, y), (w, y)], fill=(r, g, b))

    img = img.filter(ImageFilter.GaussianBlur(radius=2))
    img.save(os.path.expanduser("~/Pictures/Wallpapers/tahoe.png"))
    print("Wallpaper generated")
except ImportError:
    import subprocess
    subprocess.run(["convert", "-size", "1920x1080",
        "gradient:#b4d4f0-#1a4a8c",
        os.path.expanduser("~/Pictures/Wallpapers/tahoe.png")],
        check=False)
PYEOF
WPEOF
chmod +x "$USER_HOME/Pictures/Wallpapers/generate_wallpaper.sh"

# Try to download actual macOS wallpaper
WALLPAPER="$USER_HOME/Pictures/Wallpapers/macos26.jpg"
if ! curl -s --max-time 15 -o "$WALLPAPER" \
  "https://raw.githubusercontent.com/vinceliuice/WhiteSur-gtk-theme/master/assets/wallpapers/WhiteSur-d.jpg" 2>/dev/null; then
  echo "[ui] Wallpaper download failed — will generate on first boot"
  # Create a simple script to set fallback
  cat > "$USER_HOME/Pictures/Wallpapers/macos26.jpg" << 'EOF' 2>/dev/null || true
EOF
fi

# ── ROFI LAUNCHER DESKTOP ENTRY ─────────────────────────────
cat > /usr/share/applications/rofi-launcher.desktop << 'APPEOF'
[Desktop Entry]
Name=App Launcher
Exec=rofi -show drun -theme ~/.config/rofi/macos.rasi
Icon=system-search
Type=Application
Categories=Utility;
APPEOF

# Fix permissions
chown -R "$ACTUAL_USER:$ACTUAL_USER" "$USER_HOME/.config/tint2"
chown -R "$ACTUAL_USER:$ACTUAL_USER" "$USER_HOME/.config/rofi"
chown -R "$ACTUAL_USER:$ACTUAL_USER" "$USER_HOME/.config/picom"
chown -R "$ACTUAL_USER:$ACTUAL_USER" "$USER_HOME/Pictures"

echo "[ui] ✔ Desktop UI configured (tint2 bar + dock, rofi, picom)"
