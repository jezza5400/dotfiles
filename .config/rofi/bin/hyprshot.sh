#!/usr/bin/env bash

chosen=$(printf "󰩬   Region\n󰹑   Window\n󰍹   Active\n󰨇   Output\n󱄽   Text" | rofi -dmenu -i -p "Screenshot")

case "$chosen" in
	"󰩬   Region") hyprshot -m region ;;
	"󰹑   Window") hyprshot -m window ;;
	"󰍹   Active") sleep 0.5 && hyprshot -m active -m window ;;
	"󰨇   Output") hyprshot -m output ;;
	"󱄽   Text") ~/.config/rofi/bin/ocrshot;;
esac
