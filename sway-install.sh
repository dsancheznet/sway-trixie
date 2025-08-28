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
echo $PASSWORD | sudo -S apt update
echo $PASSWORD | sudo -S apt upgrade --yes


### Let's install a few interesting (mostly needed) packets here...
echo $PASSWORD | sudo -S apt install rar unrar ace unace p7zip-full p7zip-rar git curl cryptsetup pv imagemagick imagemagick-doc ffmpeg ffmpeg-doc python3-pip python-is-python3 mycli httpie mc eza  --yes


### Let's remove some unwanted menu entries...
echo $PASSWORD | sudo -S rm '/usr/share/applications/display-im6.q16.desktop'
echo $PASSWORD | sudo -S rm /usr/share/applications/mc.desktop
echo $PASSWORD | sudo -S rm /usr/share/applications/mcedit.desktop


### Show the software selection
SELCT=$(whiptail --title "Instalar paquetes" --checklist --separate-output "Choose the packets you want to install:" 30 78 23 \
"ONLYOFFICE"        "OnlyOffice Packet"                             off \
"FIREFOX"           "Mozilla Firefox Browser"                       off \
"VLC"               "VLC Multimedia Player"                         off \
"KODI"              "Kodi mediacenter"                              off \
"YOUTDL"            "yt-dlp Video Downloader"                       off \
"TORRENT"           "Transmission Bittorrent client"                off \
"LIBRECAD"          "LibreCAD 2D Editor"                            off \
"FREECAD"           "FreeCAD 3D Editor"                             off \
"CURA"              "Cura Slicer"                                   off \
"TELEGRAM"          "Telegram Desktop Messenger"                    off \
"BLENDER"           "Blender 3D Editor"                             off \
"GIMP"              "Gimp Imge Manipulation Program"                off \
"INKSCAPE"	    "Inkscape Vector Drawing Program"		    off \
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
                flatpak install --user org.onlyoffice.desktopeditors -y
                ;;
            FIREFOX)
                flatpak install --user org.mozilla.firefox -y
                flatpak uninstall org.gnome.Epiphany -y
                ;;
            VLC)
                flatpak install --user org.videolan.VLC -y
                ;;
            KODI)
                flatpak install --user tv.kodi.Kodi -y
                ;;
            TORRENT)
                flatpak install --user com.transmissionbt.Transmission -y
                ;;
            LIBRECAD)
                echo $PASSWORD | sudo -S apt install --yes librecad
                ;;
            FREECAD)
                flatpak install --user org.freecad.FreeCAD -y
                ;;
            CURA)
                flatpak install com.ultimaker.cura --user -y
                ;;
            TELEGRAM)
                flatpak install --user org.telegram.desktop -y
                ;;
            BLENDER)
                flatpak install --user org.blender.Blender -y
                ;;
            GIMP)
                flatpak install --user org.gimp.GIMP -y
                ;;
            INKSCAPE)
                flatpak install --user org.inkscape.Inkscape -y
                ;;
            JOPLIN)
                flatpak install --user net.cozic.joplin_desktop -y
                ;;
            RUSTDESK)
		flatpak install --user com.rustdesk.RustDesk -y
  		;;
        esac
        flatpak install --user com.github.tchx84.Flatseal -y
    done
else
    clear
    echo "Cancelled by the user"
    exit 0
fi


Show the reboot dialog
if (whiptail --title "Reboot" --yesno "We're done, do you want to clean up and reboot? " 8 78); then
    echo $PASSWORD | sudo -S apt autoremove
    echo $PASSWORD | sudo -S reboot
else
    clear
    echo $PASSWORD | sudo -S apt autoremove
    echo "You chose not to reboot. Cleaning is done. Finishing script... bye.. "
fi
