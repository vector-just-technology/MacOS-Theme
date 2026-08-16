#!/bin/bash
# ============================================================
#  Openbox WM config — macOS 26.1 look
#  Window decorations, keybindings, right-click menu
# ============================================================

ACTUAL_USER="$1"
USER_HOME="$2"
OB_DIR="$USER_HOME/.config/openbox"
mkdir -p "$OB_DIR"

# ── rc.xml — main Openbox config ───────────────────────────
cat > "$OB_DIR/rc.xml" << 'OBEOF'
<?xml version="1.0" encoding="UTF-8"?>
<openbox_config xmlns="http://openbox.org/3.4/rc">
  <theme>
    <name>WhiteSur-Light</name>
    <titleLayout>LIMC</titleLayout>
    <keepBorder>yes</keepBorder>
    <animateIconify>no</animateIconify>
    <font place="ActiveWindow">
      <name>Inter</name>
      <size>11</size>
      <weight>Bold</weight>
      <slant>Normal</slant>
    </font>
    <font place="InactiveWindow">
      <name>Inter</name>
      <size>11</size>
      <weight>Normal</weight>
      <slant>Normal</slant>
    </font>
  </theme>

  <desktops>
    <number>4</number>
    <firstdesk>1</firstdesk>
    <names>
      <name>Home</name>
      <name>Work</name>
      <name>Web</name>
      <name>Media</name>
    </names>
    <popupTime>875</popupTime>
  </desktops>

  <resize>
    <drawContents>yes</drawContents>
    <popupShow>Nonpixel</popupShow>
    <popupPosition>Center</popupPosition>
  </resize>

  <focus>
    <focusNew>yes</focusNew>
    <followMouse>no</followMouse>
    <focusLast>yes</focusLast>
    <underMouse>no</underMouse>
    <focusDelay>200</focusDelay>
    <raiseOnFocus>no</raiseOnFocus>
  </focus>

  <placement>
    <policy>Smart</policy>
    <center>yes</center>
    <monitor>Primary</monitor>
    <primaryMonitor>1</primaryMonitor>
  </placement>

  <mouse>
    <dragThreshold>8</dragThreshold>
    <doubleClickTime>500</doubleClickTime>
    <screenEdgeWarpTime>400</screenEdgeWarpTime>
    <screenEdgeWarpMouse>false</screenEdgeWarpMouse>
    <context name="Frame">
      <mousebind button="A-Left" action="Press">
        <action name="Focus"/>
        <action name="Raise"/>
      </mousebind>
      <mousebind button="A-Left" action="Click">
        <action name="Unshade"/>
      </mousebind>
      <mousebind button="A-Left" action="Drag">
        <action name="Move"/>
      </mousebind>
      <mousebind button="A-Right" action="Press">
        <action name="Focus"/>
        <action name="Raise"/>
      </mousebind>
      <mousebind button="A-Right" action="Drag">
        <action name="Resize"/>
      </mousebind>
      <mousebind button="A-Middle" action="Press">
        <action name="Lower"/>
        <action name="FocusToBottom"/>
        <action name="Unfocus"/>
      </mousebind>
      <mousebind button="A-Up" action="Click">
        <action name="GoToDesktop"><to>previous</to></action>
      </mousebind>
      <mousebind button="A-Down" action="Click">
        <action name="GoToDesktop"><to>next</to></action>
      </mousebind>
    </context>
    <context name="Titlebar">
      <mousebind button="Left" action="Drag">
        <action name="Move"/>
      </mousebind>
      <mousebind button="Left" action="DoubleClick">
        <action name="MaximizeFull"/>
      </mousebind>
      <mousebind button="Up" action="Click">
        <action name="GoToDesktop"><to>previous</to></action>
      </mousebind>
      <mousebind button="Down" action="Click">
        <action name="GoToDesktop"><to>next</to></action>
      </mousebind>
    </context>
    <context name="Desktop">
      <mousebind button="Up" action="Click">
        <action name="GoToDesktop"><to>previous</to></action>
      </mousebind>
      <mousebind button="Down" action="Click">
        <action name="GoToDesktop"><to>next</to></action>
      </mousebind>
      <mousebind button="Right" action="Press">
        <action name="ShowMenu"><menu>root-menu</menu></action>
      </mousebind>
    </context>
  </mouse>

  <keyboard>
    <!-- macOS-style shortcuts -->
    <keybind key="Super_L">
      <action name="Execute"><command>rofi -show drun -theme ~/.config/rofi/macos.rasi</command></action>
    </keybind>
    <keybind key="Super-space">
      <action name="Execute"><command>rofi -show drun -theme ~/.config/rofi/macos.rasi</command></action>
    </keybind>
    <keybind key="Super-Return">
      <action name="Execute"><command>gnome-terminal</command></action>
    </keybind>
    <keybind key="Super-e">
      <action name="Execute"><command>nemo</command></action>
    </keybind>
    <keybind key="Super-b">
      <action name="Execute"><command>chromium-browser</command></action>
    </keybind>
    <keybind key="Super-l">
      <action name="Execute"><command>i3lock-color 2>/dev/null || xlock 2>/dev/null || slock 2>/dev/null</command></action>
    </keybind>
    <!-- Screenshot (Cmd+Shift+3 = full, Cmd+Shift+4 = select) -->
    <keybind key="Super-S-3">
      <action name="Execute"><command>scrot ~/Pictures/screenshot_%Y%m%d_%H%M%S.png</command></action>
    </keybind>
    <keybind key="Super-S-4">
      <action name="Execute"><command>scrot -s ~/Pictures/screenshot_%Y%m%d_%H%M%S.png</command></action>
    </keybind>
    <!-- Mission Control style overview -->
    <keybind key="Super-F3">
      <action name="ShowDesktop"/>
    </keybind>
    <!-- Window management -->
    <keybind key="Super-q">
      <action name="Close"/>
    </keybind>
    <keybind key="Super-m">
      <action name="MaximizeFull"/>
    </keybind>
    <keybind key="Super-h">
      <action name="Iconify"/>
    </keybind>
    <!-- Virtual desktops -->
    <keybind key="C-Super-Left">
      <action name="GoToDesktop"><to>previous</to><wrap>yes</wrap></action>
    </keybind>
    <keybind key="C-Super-Right">
      <action name="GoToDesktop"><to>next</to><wrap>yes</wrap></action>
    </keybind>
    <keybind key="Super-1">
      <action name="GoToDesktop"><to>1</to></action>
    </keybind>
    <keybind key="Super-2">
      <action name="GoToDesktop"><to>2</to></action>
    </keybind>
    <keybind key="Super-3">
      <action name="GoToDesktop"><to>3</to></action>
    </keybind>
    <keybind key="Super-4">
      <action name="GoToDesktop"><to>4</to></action>
    </keybind>
    <!-- Window snap (like Stage Manager) -->
    <keybind key="Super-Left">
      <action name="MoveResizeTo"><x>0</x><y>30</y><width>50%</width><height>-30</height></action>
    </keybind>
    <keybind key="Super-Right">
      <action name="MoveResizeTo"><x>50%</x><y>30</y><width>50%</width><height>-30</height></action>
    </keybind>
    <keybind key="Super-Up">
      <action name="MaximizeFull"/>
    </keybind>
    <keybind key="Super-Down">
      <action name="Unmaximize"/>
    </keybind>
    <!-- Volume keys -->
    <keybind key="XF86AudioRaiseVolume">
      <action name="Execute"><command>pactl set-sink-volume @DEFAULT_SINK@ +5%</command></action>
    </keybind>
    <keybind key="XF86AudioLowerVolume">
      <action name="Execute"><command>pactl set-sink-volume @DEFAULT_SINK@ -5%</command></action>
    </keybind>
    <keybind key="XF86AudioMute">
      <action name="Execute"><command>pactl set-sink-mute @DEFAULT_SINK@ toggle</command></action>
    </keybind>
    <!-- Brightness keys -->
    <keybind key="XF86MonBrightnessUp">
      <action name="Execute"><command>brightnessctl set +10%</command></action>
    </keybind>
    <keybind key="XF86MonBrightnessDown">
      <action name="Execute"><command>brightnessctl set 10%-</command></action>
    </keybind>
    <!-- Openbox config reload -->
    <keybind key="Super-F5">
      <action name="Reconfigure"/>
    </keybind>
  </keyboard>

  <applications>
    <!-- All windows: no shadows on their own, picom handles it -->
    <application class="*">
      <decor>yes</decor>
      <focus>yes</focus>
    </application>
    <!-- Float small utility windows -->
    <application class="Pavucontrol">
      <floating>yes</floating>
      <position force="yes"><x>center</x><y>center</y></position>
    </application>
    <application class="Lxappearance">
      <floating>yes</floating>
      <position force="yes"><x>center</x><y>center</y></position>
    </application>
    <!-- Pin system monitor to workspace 4 -->
    <application class="Htop">
      <desktop>4</desktop>
    </application>
  </applications>
</openbox_config>
OBEOF

# ── menu.xml — right-click desktop menu ────────────────────
cat > "$OB_DIR/menu.xml" << 'MENUEOF'
<?xml version="1.0" encoding="UTF-8"?>
<openbox_menu xmlns="http://openbox.org/3.4/menu">
  <menu id="root-menu" label="Desktop">
    <separator label="MacOS 26.1 — Raspberry Pi"/>
    <item label="Open Terminal">
      <action name="Execute"><command>gnome-terminal</command></action>
    </item>
    <item label="Open Files">
      <action name="Execute"><command>nemo</command></action>
    </item>
    <item label="App Launcher">
      <action name="Execute"><command>rofi -show drun -theme ~/.config/rofi/macos.rasi</command></action>
    </item>
    <separator/>
    <menu id="apps-menu" label="Applications">
      <item label="Web Browser">
        <action name="Execute"><command>chromium-browser</command></action>
      </item>
      <item label="Text Editor">
        <action name="Execute"><command>mousepad</command></action>
      </item>
      <item label="Image Viewer">
        <action name="Execute"><command>gpicview</command></action>
      </item>
      <item label="Media Player">
        <action name="Execute"><command>vlc</command></action>
      </item>
    </menu>
    <menu id="settings-menu" label="System Preferences">
      <item label="Appearance">
        <action name="Execute"><command>lxappearance</command></action>
      </item>
      <item label="Sound">
        <action name="Execute"><command>pavucontrol</command></action>
      </item>
      <item label="Network">
        <action name="Execute"><command>nm-connection-editor</command></action>
      </item>
    </menu>
    <separator/>
    <item label="Take Screenshot">
      <action name="Execute"><command>scrot ~/Pictures/screenshot_%Y%m%d_%H%M%S.png &amp;&amp; notify-send "Screenshot saved"</command></action>
    </item>
    <separator/>
    <item label="Reload Theme">
      <action name="Reconfigure"/>
    </item>
    <item label="Restart Openbox">
      <action name="Restart"/>
    </item>
    <separator/>
    <item label="Logout">
      <action name="Exit"/>
    </item>
    <item label="Reboot">
      <action name="Execute"><command>systemctl reboot</command></action>
    </item>
    <item label="Shutdown">
      <action name="Execute"><command>systemctl poweroff</command></action>
    </item>
  </menu>
</openbox_menu>
MENUEOF

chown -R "$ACTUAL_USER:$ACTUAL_USER" "$OB_DIR"
echo "[openbox] ✔ Openbox config installed"
