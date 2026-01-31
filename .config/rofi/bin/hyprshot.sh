#!/usr/bin/env bash

chosen=$(printf "󰩬   Region\n󰨇   Output\n󰹑   Window\n󰍹   Active" | rofi -dmenu -i -p "Screenshot")

case "$chosen" in
    "󰩬   Region") hyprshot -m region ;;
    "󰨇   Output") hyprshot -m output ;;
    "󰹑   Window") hyprshot -m window ;;
    "󰍹   Active") sleep 0.5 && hyprshot --mode active --mode window ;;
esac
