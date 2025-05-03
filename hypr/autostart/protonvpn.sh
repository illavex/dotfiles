#!/bin/bash
su 


CHOICE=$(echo -e "Connect\nDisconnect\nStatus" | rofi -dmenu -p "ProtonVPN")
case "$CHOICE" in
    Connect) protonvpn-cli c ;;
    Disconnect) protonvpn-cli d ;;
    Status) protonvpn-cli s ;;
esac