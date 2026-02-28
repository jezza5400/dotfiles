#!/bin/sh
# cycle powerprofiles: performance -> balanced -> power-saver -> performance

profiles=$(powerprofilesctl get 2>/dev/null)

# current profile (line with *)
cur=$(printf "%s" "$profiles" | awk '/\*/{print $1; exit}')

# fallback: first profile
[ -z "$cur" ] && cur=$(printf "%s" "$profiles" | awk 'NR==1{print $1}')

case "$cur" in
  performance) next=balanced ;;
  balanced) next=power-saver ;;
  power-saver|powersave*|power_saver) next=performance ;;
  *) next=balanced ;;
esac

powerprofilesctl set "$next" >/dev/null 2>&1

# refresh waybar (SIGRTMIN+7)
pgrep -x waybar | while read -r pid; do
  kill -s SIGRTMIN+7 "$pid" 2>/dev/null
done