#!/bin/bash

chosen=$(echo -e "🔒 Lock\n⏻ Shutdown\n🔁 Reboot\n🚪 Logout" | rofi -dmenu -p "Power Menu" -theme-str '
window {
    width: 20%;
}
listview {
    columns: 2;
    lines: 2;
}
')

case "$chosen" in
    "🔒 Lock")     loginctl lock-session ;;
    "⏻ Shutdown") systemctl poweroff ;;
    "🔁 Reboot")   systemctl reboot ;;
    "🚪 Logout")   hyprctl dispatch exit ;;
esac
