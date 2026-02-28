#!/usr/bin/env bash
set -u

# Get the interface used for the default route
iface=$(ip route get 8.8.8.8 2>/dev/null | awk '/dev/ {for(i=1;i<=NF;i++) if($i=="dev") print $(i+1)}' | head -n1)
if [ -z "$iface" ]; then
  iface=$(ip -4 addr show scope global | awk '/inet/ {print $NF; exit}')
fi

# Get IPv4 address
ipaddr=$(ip -4 -o addr show dev "$iface" 2>/dev/null | awk '{print $4}' | cut -d/ -f1 || true)
if [ -z "$ipaddr" ]; then
  ipaddr="N/A"
fi

# Try to find SSID, frequency and signal (prefer nmcli, fallback to iw/iwgetid)
ssid=""
signal=""
freq=""
if command -v nmcli >/dev/null 2>&1; then
  ssid=$(nmcli -t -f ACTIVE,SSID dev wifi 2>/dev/null | awk -F: '$1=="yes"{print $2; exit}' || true)
  signal=$(nmcli -t -f IN-USE,SIGNAL dev wifi 2>/dev/null | awk -F: '/\*/{print $2; exit}' || true)
fi
if [ -z "$ssid" ] && command -v iwgetid >/dev/null 2>&1; then
  ssid=$(iwgetid -r 2>/dev/null || true)
fi
if [ -z "$freq" ] && command -v iw >/dev/null 2>&1 && [ -n "$iface" ]; then
  # try to read frequency (MHz) and convert to GHz if needed
  f=$(iw dev "$iface" info 2>/dev/null | awk '/channel/ {print $2; exit}' || true)
  if [ -n "$f" ]; then
    if [[ "$f" -gt 1000 ]]; then
      freq=$(awk "BEGIN {printf \"%.3f\", $f/1000}")
    else
      freq="$f"
    fi
  fi
fi
if [ -z "$signal" ] && command -v iwconfig >/dev/null 2>&1; then
  s=$(iwconfig "$iface" 2>/dev/null | awk -F"=" '/Signal level/ {print $3; exit}' | sed 's/ dBm//' || true)
  signal="$s"
fi

# Compose tooltip lines
line1="ip: $ipaddr"
line2=""
if [ -n "$ssid" ]; then
  line2="$ssid"
  if [ -n "$freq" ]; then line2="$line2 ($freq GHz)"; fi
  if [ -n "$signal" ]; then line2="$line2 $signal%"; fi
fi

# Build JSON output for Waybar custom module (return-type: json)
tooltip="$line1"
if [ -n "$line2" ]; then
  tooltip="$tooltip\n$line2"
fi

printf '%s\n' "{\"text\":\"\",\"tooltip\":\"$tooltip\"}"
