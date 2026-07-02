#!/bin/sh

chosen=$(printf "󰩬   Region\n󰹑   Window\n󰍹   Active\n󰨇   Output\n󱄽   Text\n󰴱   Colour" | rofi -dmenu -i -p "Screenshot")

case "$chosen" in
	"󰩬   Region") hyprshot -m region ;;
	"󰹑   Window") hyprshot -m window ;;
	"󰍹   Active") sleep 0.2 && hyprshot -m active -m window ;;
	"󰨇   Output") hyprshot -m output ;;
	"󱄽   Text") ~/.config/rofi/bin/ocrshot.bash ;;
	"󰴱   Colour") sleep 0.2 && hyprpicker ;;
esac
