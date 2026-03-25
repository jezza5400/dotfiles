#!/bin/sh
# Waybar battery + power profile module with accurate time remaining
# Icons preserved exactly as provided by Jeremy

# --- Find battery directory ---
bdir=""
for d in /sys/class/power_supply/*; do
  [ -f "$d/type" ] || continue
  case "$(cat "$d/type")" in
    Battery|battery) bdir="$d"; break ;;
  esac
done
[ -z "$bdir" ] && bdir="/sys/class/power_supply/BAT0"

# --- Read basic battery info ---
capacity="?"
status="Unknown"

[ -r "$bdir/capacity" ] && capacity=$(cat "$bdir/capacity")
[ -r "$bdir/status" ] && status=$(cat "$bdir/status")

# --- Detect AC adapter state ---
plugged=0
for ac in /sys/class/power_supply/*; do
  [ -f "$ac/type" ] || continue
  if grep -qi "mains" "$ac/type"; then
    if [ "$(cat "$ac/online")" = "1" ]; then
      plugged=1
    fi
  fi
done

# --- Time remaining calculation ---
time_remaining=""

# Detect charge-based or energy-based reporting
if [ -r "$bdir/charge_now" ] && [ -r "$bdir/current_now" ]; then
  now=$(cat "$bdir/charge_now")
  full=$(cat "$bdir/charge_full")
  rate=$(cat "$bdir/current_now")
elif [ -r "$bdir/energy_now" ] && [ -r "$bdir/power_now" ]; then
  now=$(cat "$bdir/energy_now")
  full=$(cat "$bdir/energy_full")
  rate=$(cat "$bdir/power_now")
else
  rate=0
fi

# Normalize negative rates (charging)
rate=${rate#-}

if [ "$rate" -gt 0 ]; then
  if [ "$status" = "Discharging" ]; then
    seconds=$(( now * 3600 / rate ))
  else
    remaining=$(( full - now ))
    [ "$remaining" -lt 0 ] && remaining=0
    seconds=$(( remaining * 3600 / rate ))
  fi

  hours=$(( seconds / 3600 ))
  mins=$(( (seconds % 3600) / 60 ))
  time_remaining="${hours}h ${mins}m"
fi

# --- Battery low notifications ---
warn_levels="20 15 10 5 2 1"
state_dir="${XDG_RUNTIME_DIR:-/tmp}/battery-warn"
mkdir -p "$state_dir"
state_file="$state_dir/last"

last=""
[ -f "$state_file" ] && last=$(cat "$state_file")

for lvl in $warn_levels; do
  if [ "$capacity" -eq "$lvl" ] && [ "$last" != "$lvl" ]; then
    notify-send -u critical "Battery low" "Battery at ${capacity}%"
    printf "%s" "$lvl" > "$state_file"
    break
  fi
done

# --- Power profile detection ---
profiles=$(powerprofilesctl get 2>/dev/null)
profile=$(printf "%s" "$profiles" | awk '/\*/{print $1; exit}')
[ -z "$profile" ] && profile=$(printf "%s" "$profiles" | awk 'NR==1{print $1}')
[ -z "$profile" ] && profile="balanced"

# --- Icons ---
icon="󰁹" # balanced default
case "$profile" in
  performance)
    icon="󰂄"
    ;;
  "power-saver"|powersave*|power_saver)
    icon="󱈑"
    ;;
  balanced)
    icon="󰁹"
    ;;
  *)
    icon="󰁹"
    ;;
esac

plug_icon=""
[ "$plugged" -eq 1 ] && plug_icon=" "

# --- JSON escaping ---
json_escape() {
  printf '%s' "$1" | sed \
    -e 's/\\/\\\\/g' \
    -e 's/"/\\"/g' \
    -e ':a;N;$!ba;s/\n/\\n/g'
}

# --- Output JSON ---
text="${plug_icon}${icon} ${capacity}%"
tooltip="Profile: ${profile}
Status: ${status}"
[ -n "$time_remaining" ] && tooltip="$tooltip
Time: $time_remaining"

printf '{"text":"%s","alt":"%s","tooltip":"%s"}\n' \
  "$(json_escape "$text")" \
  "$(json_escape "$icon")" \
  "$(json_escape "$tooltip")"
