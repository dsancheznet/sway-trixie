#!/bin/env bash

### Capture command line arguments
while getopts d option
do
    case "${option}"
        in
        d)DEBUGOPT="ON";; # This option allows to stop after each step.
    esac
done

if [[ $DEBUGOPT = "ON" ]]; then
    echo "Debugging is set $DEBUGOPT";
else
    echo "DEbugging is not set. ";
fi



### Set version
VERSION="v1.0"


### Get username we are running as
USER=`whoami`


### Set colors for whiptail
export NEWT_COLORS=''


### Show welcome message
TERM=ansi whiptail --title "Sway install Script $VERSION" --msgbox "Written by...\n\n8888888b.   .d8888b.                             888                       \n888  \"Y88b d88P  Y88b                            888                       \n888    888 Y88b.                                 888                       \n888    888  \"Y888b.    8888b.  88888b.   .d8888b 88888b.   .d88b. 88888888 \n888    888     \"Y88b.     \"88b 888 \"88b d88P\"    888 \"88b d8P  Y8b   d88P  \n888    888       \"888 .d888888 888  888 888      888  888 88888888  d88P   \n888  .d88P Y88b  d88P 888  888 888  888 Y88b.    888  888 Y8b.     d88P    \n8888888P\"   \"Y8888P\"  \"Y888888 888  888  \"Y8888P 888  888  \"Y8888 88888888 \n\n                                              ...for Debian Trixie (13)" 18 79


### Read the sudo password
PASSWORD=$(whiptail --title "Administration password" --passwordbox "Please input your admin password" 10 50 3>&1 1>&2 2>&3)
STS=$?
if [ $STS = 1 ]; then
    clear
    echo "Cancelled by the user..."
    exit 0
fi


### Let's first update the system
echo $PASSWORD | sudo -S sed -i 's\non-free-firmware\non-free-firmware non-free contrib\' /etc/apt/sources.list
echo $PASSWORD | sudo -S apt update
echo $PASSWORD | sudo -S apt upgrade --yes


### Let's install a few interesting (mostly needed) packets here...
echo "▄▖    ▗   ▜ ▜ ▘      ▄▖    ▜   "
echo "▐ ▛▌▛▘▜▘▀▌▐ ▐ ▌▛▌▛▌  ▐ ▛▌▛▌▐ ▛▘"
echo "▟▖▌▌▄▌▐▖█▌▐▖▐▖▌▌▌▙▌  ▐ ▙▌▙▌▐▖▄▌"
echo "                 ▄▌            "
echo "Installing tools..."
echo $PASSWORD | sudo -S apt install rar unrar ace unace p7zip-full p7zip-rar git curl php-cli php-sqlite3 sqlite3-tools sqlite3 php-curl cryptsetup pv imagemagick ffmpeg python3-pip python-is-python3 mycli httpie mc eza rust-all pkg-config libssl-dev libc++1 grim jq wl-clipboard --yes


### Let's remove some unwanted menu entries this has created...
echo "Removing menu entries..."
echo $PASSWORD | sudo -S rm '/usr/share/applications/display-im6.q16.desktop'
echo $PASSWORD | sudo -S rm /usr/share/applications/mc.desktop
echo $PASSWORD | sudo -S rm /usr/share/applications/mcedit.desktop
echo ------------------------------ 


### Let's install starship ( bash prompt ) htps://starship.rs
echo "  ▗       ▌ ▘  "
echo "▛▘▜▘▀▌▛▘▛▘▛▌▌▛▌"
echo "▄▌▐▖█▌▌ ▄▌▌▌▌▙▌"
echo "             ▌ "
echo "Installing Starship..."
curl -sS https://starship.rs/install.sh | sh
cat <<"EOF"> ~/.bashrc
## Activate starship
eval "$(starship init bash)"
EOF
# Load a cool preset find more at https://starship.rs/presets/
mkdir -p ~/.config
starship preset gruvbox-rainbow -o ~/.config/starship.toml



### Let's install and configure ly display manager
echo "▜   "
echo "▐ ▌▌"
echo "▐▖▙▌"
echo "  ▄▌"
echo "Installing ly..."
cd ~
echo $PASSWORD | sudo -S apt install build-essential libpam0g-dev libxcb-xkb-dev xauth xserver-xorg brightnessctl git --yes
wget "https://ziglang.org/builds/zig-x86_64-linux-0.16.0-dev.43+99b2b6151.tar.xz"
tar xvf zig-x86_64-linux-0.16.0-dev.43+99b2b6151.tar.xz
git clone https://codeberg.org/fairyglade/ly.git
cd ly
echo $PASSWORD | sudo -S ../zig-x86_64-linux-0.16.0-dev.43+99b2b6151/zig build
echo $PASSWORD | sudo -S ../zig-x86_64-linux-0.16.0-dev.43+99b2b6151/zig build installexe -Dinit_system=systemd
echo $PASSWORD | sudo -S systemctl enable ly.service
cd ~
sudo rm -rf ly/
echo $PASSWORD | sudo -S rm -rf zig*
echo ------------------------------ 


### Let's install and configure sway display manager
echo "▄▖       " 
echo "▚ ▌▌▌▀▌▌▌"
echo "▄▌▚▚▘█▌▙▌"
echo "       ▄▌"
echo "Installing Sway..."
echo $PASSWORD | sudo -S apt install sway sway-backgrounds swaybg swayidle swayimg swaykbdd swaylock sway-notification-center swayosd swaysome xdg-desktop-portal-wlr pulseaudio-utils xwayland --yes
mkdir -p ~/.config/sway
cat <<"EOF"> ~/.config/sway/config
# DSanchez' config for sway
#
# Copy this to ~/.config/sway/config and edit it to your liking.
#
# Read `man 5 sway` for a complete reference.

### Variables
#
# Logo key. Use Mod1 for Alt.
set $mod Mod4

# Home row direction keys, like vim
set $left h
set $down j
set $up k
set $right l

# Your preferred terminal emulator
set $term kitty

# Your preferred application launcher
set $menu ulauncher-toggle

# Include other configs
include /etc/sway/config-vars.d/*

### Output configuration
#
# Default wallpaper (more resolutions are available in /usr/share/backgrounds/sway/)
# This is commented in Debian, because the Sway wallpaper files are in a separate
# package `sway-backgrounds`. Installing this package drops a config file to
# /etc/sway/config.d/
# output * bg /usr/share/backgrounds/sway/Sway_Wallpaper_Blue_1920x1080.png fill
#
# Example configuration:
#
#   output HDMI-A-1 resolution 1920x1080 position 1920,0
#
# You can get the names of your outputs by running: swaymsg -t get_outputs

#output * bg /home/dominik/Imagenes/Wallpapers/serene_voyage-wallpaper-1366x768.jpg fit
#output eDP-1 resolution 1366x768 position 1336,0
#output eDP-1 bg /home/dominik/Imagenes/Wallpapers/serene_voyage-wallpaper-1366x768.jpg stretch

### Idle configuration
#
# Example configuration:
#
# exec swayidle -w \
#          timeout 300 'swaylock -f -c 000000' \
#          timeout 600 'swaymsg "output * power off"' resume 'swaymsg "output * power on"' \
#          before-sleep 'swaylock -f -c 000000'
#
# This will lock your screen after 300 seconds of inactivity, then turn off
# your displays after another 300 seconds, and turn your screens back on when
# resumed. It will also lock your screen before your computer goes to sleep.
exec swayidle -w timeout 60 'grim /tmp/ss.png && convert -blur 0x20 /tmp/ss.png /tmp/ss.png && swaylock -i /tmp/ss.png' \
              -w timeout 90 'foot -F "cmatrix"' \

### Input configuration ( you will have to edit this to your convenience )
#
# Example configuration:
#
#   input "2:14:SynPS/2_Synaptics_TouchPad" {
#       dwt enabled
#       tap enabled
#       natural_scroll enabled
#       middle_emulation enabled
#   }
#
# You can get the names of your inputs by running: swaymsg -t get_inputs
# Read `man 5 sway-input` for more information about this section.

# Touchpad options
input "2:14:ETPS/2_Elantech_Touchpad" {
	dwt enabled
	tap enabled
	middle_emulation enabled
}

# Keyboard default layout
input "1:1:AT_Translated_Set_2_keyboard" {
   xkb_layout es
}


### Key bindings
#
# Basics:
#
    # Start a terminal
    bindsym $mod+Return exec $term

    # Kill focused window
    bindsym $mod+Shift+q kill

    # Start your launcher
    bindsym $mod+space exec $menu

    # Drag floating windows by holding down $mod and left mouse button.
    # Resize them with right mouse button + $mod.
    # Despite the name, also works for non-floating windows.
    # Change normal to inverse to use left mouse button for resizing and right
    # mouse button for dragging.
    floating_modifier $mod normal

    # Reload the configuration file
    bindsym $mod+Shift+c reload

    # Exit sway (logs you out of your Wayland session)
    bindsym $mod+Shift+e exec swaynag -t warning -m 'You pressed the exit shortcut. Do you really want to exit sway? This will end your Wayland session.' -B 'Yes, exit sway' 'swaymsg exit'


#
# Moving around:
#
    # Move your focus around
    bindsym $mod+$left focus left
    bindsym $mod+$down focus down
    bindsym $mod+$up focus up
    bindsym $mod+$right focus right
    # Or use $mod+[up|down|left|right]
    bindsym $mod+Left focus left
    bindsym $mod+Down focus down
    bindsym $mod+Up focus up
    bindsym $mod+Right focus right

    # Move the focused window with the same, but add Shift
    bindsym $mod+Shift+$left move left
    bindsym $mod+Shift+$down move down
    bindsym $mod+Shift+$up move up
    bindsym $mod+Shift+$right move right
    # Ditto, with arrow keys
    bindsym $mod+Shift+Left move left
    bindsym $mod+Shift+Down move down
    bindsym $mod+Shift+Up move up
    bindsym $mod+Shift+Right move right
#
# Workspaces:
#
    # Switch to workspace
    bindsym $mod+1 workspace number 1
    bindsym $mod+2 workspace number 2
    bindsym $mod+3 workspace number 3
    bindsym $mod+4 workspace number 4
    bindsym $mod+5 workspace number 5
    bindsym $mod+6 workspace number 6
    bindsym $mod+7 workspace number 7
    bindsym $mod+8 workspace number 8
    bindsym $mod+9 workspace number 9
    bindsym $mod+0 workspace number 10

    # Move focused container to workspace
    bindsym $mod+Shift+1 move container to workspace number 1
    bindsym $mod+Shift+2 move container to workspace number 2
    bindsym $mod+Shift+3 move container to workspace number 3
    bindsym $mod+Shift+4 move container to workspace number 4
    bindsym $mod+Shift+5 move container to workspace number 5
    bindsym $mod+Shift+6 move container to workspace number 6
    bindsym $mod+Shift+7 move container to workspace number 7
    bindsym $mod+Shift+8 move container to workspace number 8
    bindsym $mod+Shift+9 move container to workspace number 9
    bindsym $mod+Shift+0 move container to workspace number 10
    # Note: workspaces can have any name you want, not just numbers.
    # We just use 1-10 as the default.
#
# Layout stuff:
#
    # You can "split" the current object of your focus with
    # $mod+b or $mod+v, for horizontal and vertical splits
    # respectively.
    bindsym $mod+b splith
    bindsym $mod+v splitv

    # Switch the current container between different layout styles
    bindsym $mod+s layout stacking
    bindsym $mod+w layout tabbed
    bindsym $mod+e layout toggle split

    # Make the current focus fullscreen
    bindsym $mod+f fullscreen

    # Toggle the current focus between tiling and floating mode
    bindsym $mod+Shift+space floating toggle

    # Swap focus between the tiling area and the floating area
    bindsym $mod+t focus mode_toggle

    # Move focus to the parent container
    bindsym $mod+a focus parent
#
# Scratchpad:
#
    # Sway has a "scratchpad", which is a bag of holding for windows.
    # You can send windows there and get them back later.

    # Move the currently focused window to the scratchpad
    bindsym $mod+Shift+minus move scratchpad

    # Show the next scratchpad window or hide the focused scratchpad window.
    # If there are multiple scratchpad windows, this command cycles through them.
    bindsym $mod+minus scratchpad show
#
# Resizing containers:
#
mode "resize" {
    # left will shrink the containers width
    # right will grow the containers width
    # up will shrink the containers height
    # down will grow the containers height
    bindsym $left resize shrink width 10px
    bindsym $down resize grow height 10px
    bindsym $up resize shrink height 10px
    bindsym $right resize grow width 10px

    # Ditto, with arrow keys
    bindsym Left resize shrink width 10px
    bindsym Down resize grow height 10px
    bindsym Up resize shrink height 10px
    bindsym Right resize grow width 10px

    # Return to default mode
    bindsym Return mode "default"
    bindsym Escape mode "default"
}
bindsym $mod+r mode "resize"

#
# Screenshots:
# Rectangle
  bindsym $mod+Ctrl+Print exec ~/.local/bin/screenshot.sh rectangle 
# Rectangle to clipboard
  bindsym $mod+Shift+Ctrl+Print exec ~/.local/bin/screenshot.sh clp-rectangle 
# Fullscreen
  bindsym $mod+Print exec ~/.local/bin/screenshot.sh fullscreen
# Fullscreen to clipboard
  bindsym $mod+Shift+Print exec ~/.local/bin/screenshot.sh clp-fullscreen
# Colorpicker
  bindsym $mod+Alt+Print exec ~/.local/bin/screenshot.sh colorpick

#
# Utilities:
#
    # Special keys to adjust volume via PulseAudio
    bindsym --locked XF86AudioMute exec pactl set-sink-mute \@DEFAULT_SINK@ toggle
    bindsym --locked XF86AudioLowerVolume exec pactl set-sink-volume \@DEFAULT_SINK@ -5%
    bindsym --locked XF86AudioRaiseVolume exec pactl set-sink-volume \@DEFAULT_SINK@ +5%
    bindsym --locked XF86AudioMicMute exec pactl set-source-mute \@DEFAULT_SOURCE@ toggle
    # Special keys to adjust brightness via brightnessctl
    bindsym --locked XF86MonBrightnessDown exec brightnessctl set 5%-
    bindsym --locked XF86MonBrightnessUp exec brightnessctl set 5%+
    # Special key to take a screenshot with grim
    #bindsym Print exec grim

#
# Status Bar:
#
# Read `man 5 sway-bar` for more information about this section.
#bar {
#    position top

    # When the status_command prints a new line to stdout, swaybar updates.
    # The default just shows the current date and time.
#    status_command while date +'%Y-%m-%d %X'; do sleep 1; done

#    colors {
#        statusline #ffffff
#        background #323232
#        inactive_workspace #32323200 #32323200 #5c5c5c
#    }
#}


# Window Adjustments
for_window [class="firefox"] border no

#Autostarts
exec ulauncher --hide-window
exec waybar


# Test configurations

#smart_borders on
gaps inner 4
gaps outer 4
default_border pixel 2
client.focused #D65D0E #3c3836 #ffffff

include /home/dominik/.config/sway/config.d/*
EOF
echo ------------------------------ 


### Let's install the icons
echo "▄▖        "
echo "▐ ▛▘▛▌▛▌▛▘"
echo "▟▖▙▖▙▌▌▌▄▌"
echo "Installing Icons..."
cd ~
git clone https://github.com/zayronxio/Zafiro-Nord-Dark.git
mkdir -p .local/share/icons/
mv Zafiro-Nord-Dark .local/share/icons/
echo ------------------------------ 


### Let's install the fonts
echo "▖ ▖     ▌  ▄▖    ▗   "
echo "▛▖▌█▌▛▘▛▌  ▙▖▛▌▛▌▜▘▛▘"
echo "▌▝▌▙▖▌ ▙▌  ▌ ▙▌▌▌▐▖▄▌"
echo "Installing Nerd Fonts..."
curl https://raw.githubusercontent.com/dsancheznet/terminal-utilities/refs/heads/main/font_installer.sh | bash
echo ------------------------------ 


### Let's install gtk themes
echo "  ▗ ▌   ▄▖▌          "
echo "▛▌▜▘▙▘  ▐ ▛▌█▌▛▛▌█▌▛▘"
echo "▙▌▐▖▛▖  ▐ ▌▌▙▖▌▌▌▙▖▄▌"
echo "▄▌                   "
echo "Installing gtk Themes..."
echo $PASSWORD | sudo -S apt install gtk2-engines-aurora gtk2-engines-murrine gtk2-engines-pixbuf gtk2-engines nwg-look --yes
echo ------------------------------ 


### Let's install waybar
echo "       ▌     "
echo "▌▌▌▀▌▌▌▛▌▀▌▛▘"
echo "▚▚▘█▌▙▌▙▌█▌▌ "
echo "     ▄▌      "
echo "Installing Waybar..."
echo $PASSWORD | sudo -S apt install waybar power-profiles-daemon --yes
mkdir -p ~/.config/waybar
cp /etc/xdg/waybar/* ~/.config/waybar/
echo ------------------------------ 


### Let's configure the keyboard
echo "▌     ▌        ▌"
echo "▙▘█▌▌▌▛▌▛▌▀▌▛▘▛▌"
echo "▛▖▙▖▙▌▙▌▙▌█▌▌ ▙▌"
echo "    ▄▌          "
echo "Configuring Keyboard..."
# read https://github.com/swaywm/sway/wiki#keyboard-layout
echo ------------------------------ 


### Let's configure the mouse
echo "▛▛▌▛▌▌▌▛▘█▌"
echo "▌▌▌▙▌▙▌▄▌▙▖"
echo "Configuring mouse..."
echo ------------------------------ 


### Let's configure ulauncher
echo "  ▜         ▌     "
echo "▌▌▐ ▀▌▌▌▛▌▛▘▛▌█▌▛▘"
echo "▙▌▐▖█▌▙▌▌▌▙▖▌▌▙▖▌ "
echo "Installing ulauncher..."
echo $PASSWORD | sudo -S apt update && sudo apt install -y gnupg
gpg --keyserver keyserver.ubuntu.com --recv 0xfaf1020699503176
gpg --export 0xfaf1020699503176 | sudo tee /usr/share/keyrings/ulauncher-archive-keyring.gpg > /dev/null
echo "deb [signed-by=/usr/share/keyrings/ulauncher-archive-keyring.gpg] \
          http://ppa.launchpad.net/agornostal/ulauncher-dev/ubuntu jammy main" \
          | sudo tee /etc/apt/sources.list.d/ulauncher-dev-jammy.list
echo $PASSWORD | sudo -S apt update && echo $PASSWORD | sudo -S apt install ulauncher --yes
echo ------------------------------ 


### Let's install the logout menu
echo "   ▜         ▗ "
echo "▌▌▌▐ ▛▌▛▌▛▌▌▌▜▘"
echo "▚▚▘▐▖▙▌▙▌▙▌▙▌▐▖"
echo "       ▄▌      "
echo "Installing logout..."
echo $PASSWORD | sudo -S apt install wlogout  --yes
mkdir -p ~/.config/wlogout
cat <<"EOF"> ~/.config/wlogout/style.css
* {
	background-image: none;
	box-shadow: none;
}

window {
	background-color: rgba(12, 12, 12, 0.5);
}

button {
  border-radius: 0px;
  border-color: black;
	text-decoration-color: #FFFFFF;
  color: #FFFFFF;
	background-color: #1E1E1E;
	border-style: solid;
	border-width: 1px;
  border-color: #ffffff;
	background-repeat: no-repeat;
  border-left: none;
  border-right: none;
	background-position: center;
	background-size: 50%;
}

button:focus, button:active, button:hover {
	background-color: #D65D0E;
	outline-style: none;
}

#lock {
    border-top-left-radius: 20px;
    border-bottom-left-radius: 20px;
    background-image: image(url("/usr/share/wlogout/icons/lock.png"), url("/usr/local/share/wlogout/icons/lock.png"));
    border-left: 1px solid #ffffff;
}

#logout {
    background-image: image(url("/usr/share/wlogout/icons/logout.png"), url("/usr/local/share/wlogout/icons/logout.png"));
}

#suspend {
    background-image: image(url("/usr/share/wlogout/icons/suspend.png"), url("/usr/local/share/wlogout/icons/suspend.png"));
}

#hibernate {
    background-image: image(url("/usr/share/wlogout/icons/hibernate.png"), url("/usr/local/share/wlogout/icons/hibernate.png"));
}

#reboot {
    background-image: image(url("/usr/share/wlogout/icons/reboot.png"), url("/usr/local/share/wlogout/icons/reboot.png"));
}

#shutdown {
    border-top-right-radius: 20px;
    border-bottom-right-radius: 20px;
    background-image: image(url("/usr/share/wlogout/icons/shutdown.png"), url("/usr/local/share/wlogout/icons/shutdown.png"));
    border-right: 1px solid #ffffff;
}
EOF
cat <<"EOF"> ~/.config/wlogout/layout
{
    "label" : "lock",
    "action" : "/$HOMEDIR/.config/wlogout/lock.sh",
    "text" : "Lock",
    "keybind" : "l"
}
{
    "label" : "hibernate",
    "action" : "systemctl hibernate",
    "text" : "Hibernate",
    "keybind" : "h"
}
{
    "label" : "suspend",
    "action" : "systemctl suspend",
    "text" : "Suspend",
    "keybind" : "u"
}
{
    "label" : "logout",
    "action" : "loginctl terminate-user $USER",
    "text" : "Logout",
    "keybind" : "e"
}
{
    "label" : "reboot",
    "action" : "systemctl reboot",
    "text" : "Reboot",
    "keybind" : "r"
}
{
    "label" : "shutdown",
    "action" : "systemctl poweroff",
    "text" : "Shutdown",
    "keybind" : "s"
}
EOF
cat <<"EOF"> ~/.config/wlogout/lock.sh
#!/bin/env bash
grim /tmp/ss.png && convert -blur 0x20 /tmp/ss.png /tmp/ss.png && swaylock -i /tmp/ss.png
EOF
chmod +x ~/.config/wlogout/lock.sh
echo ------------------------------ 


### Let's install vim and some plugins
echo "  ▘           ▜     ▘    "
echo "▌▌▌▛▛▌  ▟▖  ▛▌▐ ▌▌▛▌▌▛▌▛▘"
echo "▚▘▌▌▌▌  ▝   ▙▌▐▖▙▌▙▌▌▌▌▄▌"
echo "            ▌     ▄▌     "
echo "Installing vim+plugins..."
echo $PASSWORD | sudo -S apt install vim vim-tiny vim-runtime vim-common vim-autopairs vim-airline vim-airline-themes vim-addon-manager --yes
# Download updated version of vimrc configuration file.
wget -O ~/.vimrc "https://raw.githubusercontent.com/dsancheznet/terminal-utilities/refs/heads/main/.vimrc"
echo ------------------------------ 


### Let's install and configure kitty 
echo "▌ ▘▗ ▗   "
echo "▙▘▌▜▘▜▘▌▌"
echo "▛▖▌▐▖▐▖▙▌"
echo "       ▄▌"
echo "Installing kitty..."
echo $PASSWORD | sudo -S apt install kitty kitty-shell-integration kitty-terminfo --yes
mkdir -p ~/.config/kitty
wget "https://raw.githubusercontent.com/dsancheznet/terminal-utilities/refs/heads/main/kitty.conf" -O ~/.config/kitty/kitty.conf
echo ------------------------------ 


### Let's install bpytop
echo "▌     ▗     "
echo "▛▌▛▌▌▌▜▘▛▌▛▌"
echo "▙▌▙▌▙▌▐▖▙▌▙▌"
echo "  ▌ ▄▌    ▌ "
echo "Installing bpytop..."
echo $PASSWORD | sudo -S apt install bpytop --yes
echo ------------------------------ 


### Let's install kew
echo "▌      "
echo "▙▘█▌▌▌▌"
echo "▛▖▙▖▚▚▘"
echo "Installing kew..."
echo $PASSWORD | sudo -S apt install kew --yes
echo ------------------------------ 


### Let's install nemo 
echo "                   ▐▘  "
echo "▛▌█▌▛▛▌▛▌  ▟▖  ▛▌▌▌▜▘▛▘"
echo "▌▌▙▖▌▌▌▙▌  ▝   ▙▌▚▘▐ ▄▌"
echo "               ▄▌      "
echo "Installign nemo and gvfs..."
echo $PASSWORD | sudo -S apt install nemo nemo-compare nemo-data nemo-fileroller nemo-gtkhash nemo-python --yes
echo ------------------------------ 


### Let's install glow
echo "  ▜     "
echo "▛▌▐ ▛▌▌▌▌"
echo "▙▌▐▖▙▌▚▚▘"
echo "▄▌       "
echo "Installing glow..."
echo $PASSWORD | sudo -S apt install glow --yes
echo ------------------------------ 


### Let's install batcat
echo "▌   ▗     ▗ "
echo "▛▌▀▌▜▘▛▘▀▌▜▘"
echo "▙▌█▌▐▖▙▖█▌▐▖"
echo "Installing batcat..."
echo $PASSWORD | sudo -S apt install bat --yes
echo ------------------------------ 


### Let's install flatpak
echo "▐▘▜   ▗     ▌       ▐▘▜   ▗ ▌   ▌ "
echo "▜▘▐ ▀▌▜▘▛▌▀▌▙▘  ▟▖  ▜▘▐ ▀▌▜▘▛▌▌▌▛▌"
echo "▐ ▐▖█▌▐▖▙▌█▌▛▖  ▝   ▐ ▐▖█▌▐▖▌▌▙▌▙▌"
echo "        ▌                         "
echo "Installing flatpak and flathub..."
echo $PASSWORD | sudo -S apt install flatpak --yes
flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
echo ------------------------------ 


### Show the software selection
SELCT=$(whiptail --title "Instalar paquetes flatpak" --checklist --separate-output "Choose the packets you want to install:" 30 78 23 \
"ONLYOFFICE"        "OnlyOffice Packet"                             off \
"FIREFOX"           "Mozilla Firefox Browser"                       off \
"VLC"               "VLC Multimedia Player"                         off \
"KODI"              "Kodi mediacenter"                              off \
"YOUTDL"            "yt-dlp Video Downloader"                       off \
"TORRENT"           "Transmission Bittorrent client"                off \
"FREECAD"           "FreeCAD 3D Editor"                             off \
"CURA"              "Cura Slicer"                                   off \
"TELEGRAM"          "Telegram Desktop Messenger"                    off \
"BLENDER"           "Blender 3D Editor"                             off \
"GIMP"              "Gimp Imge Manipulation Program"                off \
"INKSCAPE"	        "Inkscape Vector Drawing Program"		            off \
"JOPLIN"            "Joplin Markdown Notes"                         off \
"RUSTDESK"          "Rustdesk remote utility"                       off \
3>&1 1>&2 2>&3 )
#Read back exit status
STS=$?
#Did the user accept the dialog?
if [ $STS = 0 ]; then
    #YES - Iterate over items
    for ITEM in $SELCT
    do
        #Check for selections (42 items)
        case $ITEM in
            ONLYOFFICE)
                flatpak install org.onlyoffice.desktopeditors -y
                ;;
            FIREFOX)
                flatpak install org.mozilla.firefox -y
                ;;
            VLC)
                flatpak install org.videolan.VLC -y
                ;;
            KODI)
                flatpak install tv.kodi.Kodi -y
                ;;
            TORRENT)
                flatpak install com.transmissionbt.Transmission -y
                ;;
            FREECAD)
                flatpak install org.freecad.FreeCAD -y
                ;;
            CURA)
                flatpak install com.ultimaker.cura -y
                ;;
            TELEGRAM)
                flatpak install org.telegram.desktop -y
                ;;
            BLENDER)
                flatpak install org.blender.Blender -y
                ;;
            GIMP)
                flatpak install org.gimp.GIMP -y
                ;;
            INKSCAPE)
                flatpak install org.inkscape.Inkscape -y
                ;;
            JOPLIN)
                flatpak install net.cozic.joplin_desktop -y
                ;;
            RUSTDESK)
		            flatpak install com.rustdesk.RustDesk -y
  		          ;;
        esac
    done
	# Install flatseal anyway
	flatpak install com.github.tchx84.Flatseal -y
else
#    clear
    echo "Cancelled by the user"
    exit 0
fi

# Configuring Desktop Stuff
cd ~
mkdir Documents Downloads Developer Images

# Show the reboot dialog
if (whiptail --title "Reboot" --yesno "We're done, do you want to clean up and reboot? " 8 78); then
    echo $PASSWORD | sudo -S apt autoremove --yes
    echo $PASSWORD | sudo -S reboot
else
# clear
    echo $PASSWORD | sudo -S apt autoremove --yes
    echo "You chose not to reboot. Cleaning is done. Finishing script... bye.. "
fi

### Notes for future enhancements
# Change ly for greetd + tuigreet
# https://wiki.archlinux.org/title/Greetd
# https://github.com/apognu/tuigreet
#

