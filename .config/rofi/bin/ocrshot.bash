#!/usr/bin/env bash

# Take region screenshot
hyprshot -s -o "/tmp" -f "ocrshot.png" -m region

# OCR it
TEXT=$(tesseract "/tmp/ocrshot.png" - 2>/dev/null)

rm "/tmp/ocrshot.png"

if [[ -z "$TEXT" ]]; then
	notify-send "OCR" "No text detected"
else
	printf "%s" "$TEXT" | wl-copy
	notify-send "OCR" "Extracted text copied to clipboard"
fi
