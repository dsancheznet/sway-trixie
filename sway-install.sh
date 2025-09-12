#!/bin/env bash

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
echo $PASSWORD | sudo -S apt install rar unrar ace unace p7zip-full p7zip-rar git curl php-cli php-sqlite3 sqlite3-tools sqlite3 php-curl cryptsetup pv imagemagick ffmpeg python3-pip python-is-python3 mycli httpie mc eza rust-all pkg-config libssl-dev libc++1 grim jq wl-clipboard --yes


### Let's install starhip ( bash prompt ) htps://starship.rs
echo "  ▗       ▌ ▘  "
echo "▛▘▜▘▀▌▛▘▛▘▛▌▌▛▌"
echo "▄▌▐▖█▌▌ ▄▌▌▌▌▙▌"
echo "             ▌ "
curl -sS https://starship.rs/install.sh | sh
cat <<EOF> ~/.bashrc
## Activate starship
eval "$(starship init bash)"
EOF


### Let's remove some unwanted menu entries...
echo $PASSWORD | sudo -S rm '/usr/share/applications/display-im6.q16.desktop'
echo $PASSWORD | sudo -S rm /usr/share/applications/mc.desktop
echo $PASSWORD | sudo -S rm /usr/share/applications/mcedit.desktop
echo ------------------------------ 


### Let's install and configure ly display manager
echo "▜   "
echo "▐ ▌▌"
echo "▐▖▙▌"
echo "  ▄▌"
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
echo $PASSWORD | sudo -S apt install sway sway-backgrounds swaybg swayidle swayimg swaykbdd swaylock sway-notification-center swayosd swaysome xdg-desktop-portal-wlr pulseaudio-utils xwayland --yes
mkdir -p ~/.config/waybar
cp /etc/xdg/waybar/* ~/.config/waybar/
echo ------------------------------ 


### Let's install the icons
echo "▄▖        "
echo "▐ ▛▘▛▌▛▌▛▘"
echo "▟▖▙▖▙▌▌▌▄▌"
cd ~
git clone https://github.com/zayronxio/Zafiro-Nord-Dark.git
mkdir -p .local/share/icons/
mv Zafiro-Nord-Dark .local/share/icons/
echo ------------------------------ 


### Let's install the fonts
echo "▖ ▖     ▌  ▄▖    ▗   "
echo "▛▖▌█▌▛▘▛▌  ▙▖▛▌▛▌▜▘▛▘"
echo "▌▝▌▙▖▌ ▙▌  ▌ ▙▌▌▌▐▖▄▌"
curl https://raw.githubusercontent.com/dsancheznet/terminal-utilities/refs/heads/main/font_installer.sh | bash
echo ------------------------------ 


### Let's install gtk themes
echo "  ▗ ▌   ▄▖▌          "
echo "▛▌▜▘▙▘  ▐ ▛▌█▌▛▛▌█▌▛▘"
echo "▙▌▐▖▛▖  ▐ ▌▌▙▖▌▌▌▙▖▄▌"
echo "▄▌                   "
echo $PASSWORD | sudo -S apt install gtk2-engines-aurora gtk2-engines-murrine gtk2-engines-pixbuf gtk2-engines nwg-look --yes
echo ------------------------------ 


### Let's install waybar
echo "       ▌     "
echo "▌▌▌▀▌▌▌▛▌▀▌▛▘"
echo "▚▚▘█▌▙▌▙▌█▌▌ "
echo "     ▄▌      "
echo $PASSWORD | sudo -S apt install waybar power-profiles-daemon --yes
echo ------------------------------ 


### Let's configure the keyboard
echo "▌     ▌        ▌"
echo "▙▘█▌▌▌▛▌▛▌▀▌▛▘▛▌"
echo "▛▖▙▖▙▌▙▌▙▌█▌▌ ▙▌"
echo "    ▄▌          "
echo ------------------------------ 


### Let's configure the mouse
echo "▛▛▌▛▌▌▌▛▘█▌"
echo "▌▌▌▙▌▙▌▄▌▙▖"
echo ------------------------------ 


### Let's configure ulauncher
echo "  ▜         ▌     "
echo "▌▌▐ ▀▌▌▌▛▌▛▘▛▌█▌▛▘"
echo "▙▌▐▖█▌▙▌▌▌▙▖▌▌▙▖▌ "
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
echo $PASSWORD | sudo -S apt install wlogout  --yes
echo ------------------------------ 


### Let's install vim and some plugins
echo "  ▘           ▜     ▘    "
echo "▌▌▌▛▛▌  ▟▖  ▛▌▐ ▌▌▛▌▌▛▌▛▘"
echo "▚▘▌▌▌▌  ▝   ▙▌▐▖▙▌▙▌▌▌▌▄▌"
echo "            ▌     ▄▌     "
echo $PASSWORD | sudo -S apt install vim vim-tiny vim-runtime vim-common vim-autopairs vim-airline vim-airline-themes vim-addon-manager --yes
echo ------------------------------ 


### Let's install and configure kitty 
echo "▌ ▘▗ ▗   "
echo "▙▘▌▜▘▜▘▌▌"
echo "▛▖▌▐▖▐▖▙▌"
echo "       ▄▌"
echo $PASSWORD | sudo -S apt install kitty kitty-shell-integration kitty-terminfo --yes
echo ------------------------------ 


### Let's install bpytop
echo "▌     ▗     "
echo "▛▌▛▌▌▌▜▘▛▌▛▌"
echo "▙▌▙▌▙▌▐▖▙▌▙▌"
echo "  ▌ ▄▌    ▌ "
echo $PASSWORD | sudo -S apt install bpytop --yes
echo ------------------------------ 


### Let's install kew
echo "▌      "
echo "▙▘█▌▌▌▌"
echo "▛▖▙▖▚▚▘"
echo $PASSWORD | sudo -S apt install kew --yes
echo ------------------------------ 


### Let's install nemo 
echo "                   ▐▘  "
echo "▛▌█▌▛▛▌▛▌  ▟▖  ▛▌▌▌▜▘▛▘"
echo "▌▌▙▖▌▌▌▙▌  ▝   ▙▌▚▘▐ ▄▌"
echo "               ▄▌      "
echo $PASSWORD | sudo -S apt install nemo nemo-compare nemo-data nemo-fileroller nemo-gtkhash nemo-python --yes
echo ------------------------------ 


### Let's install glow
echo "  ▜     "
echo "▛▌▐ ▛▌▌▌▌"
echo "▙▌▐▖▙▌▚▚▘"
echo "▄▌       "
echo $PASSWORD | sudo -S apt install glow --yes
echo ------------------------------ 


### Let's install batcat
echo "▌   ▗     ▗ "
echo "▛▌▀▌▜▘▛▘▀▌▜▘"
echo "▙▌█▌▐▖▙▖█▌▐▖"
echo $PASSWORD | sudo -S apt install bat --yes
echo ------------------------------ 


### Let's install flatpak
echo "▐▘▜   ▗     ▌       ▐▘▜   ▗ ▌   ▌ "
echo "▜▘▐ ▀▌▜▘▛▌▀▌▙▘  ▟▖  ▜▘▐ ▀▌▜▘▛▌▌▌▛▌"
echo "▐ ▐▖█▌▐▖▙▌█▌▛▖  ▝   ▐ ▐▖█▌▐▖▌▌▙▌▙▌"
echo "        ▌                         "
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

