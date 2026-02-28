#!/usr/bin/env bash

chosen=$(printf " Lock\n󰗼 Logout\n󰜉 Reboot\n Shutdown" | rofi -dmenu -i -p "Power")

case "$chosen" in
    " Lock") hyprlock ;;
    "󰗼 Logout") hyprshutdown -t 'Exiting Hyprland...' ;;
    "󰜉 Reboot") hyprshutdown -t 'Rebooting...' --post-cmd 'reboot' ;;
    " Shutdown") hyprshutdown -t 'Shutting down...' --post-cmd 'shutdown -P 0' ;;
esac
