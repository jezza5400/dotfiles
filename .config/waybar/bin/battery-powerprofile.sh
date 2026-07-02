#!/bin/sh
# Waybar battery + power profile module

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
capacity=$(cat "$bdir/capacity" 2>/dev/null); capacity=${capacity:-"?"}
status=$(cat "$bdir/status"    2>/dev/null); status=${status:-"Unknown"}

# --- Detect AC adapter ---
plugged=0
for ac in /sys/class/power_supply/*; do
	[ -f "$ac/type" ]                           || continue
	grep -qi "mains" "$ac/type"                 || continue
	[ "$(cat "$ac/online" 2>/dev/null)" = "1" ] && { plugged=1; break; }
done

# --- Time remaining ---
time_remaining=""
rate=0
if [ -r "$bdir/charge_now" ] && [ -r "$bdir/charge_full" ] && [ -r "$bdir/current_now" ]; then
	now=$(cat "$bdir/charge_now")
	full=$(cat "$bdir/charge_full")
	rate=$(cat "$bdir/current_now")
elif [ -r "$bdir/energy_now" ] && [ -r "$bdir/energy_full" ] && [ -r "$bdir/power_now" ]; then
	now=$(cat "$bdir/energy_now")
	full=$(cat "$bdir/energy_full")
	rate=$(cat "$bdir/power_now")
fi
rate=${rate#-}   # some kernels report negative rate when charging
rate=${rate:-0}
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
# warn_levels must be highest → lowest; we keep the last matching level so
# skipped thresholds still advance to the next lower warning.
warn_levels="20 15 10 5 2 1"
state_dir="${XDG_RUNTIME_DIR:-/tmp}/battery-warn-$(id -u)"
mkdir -p "$state_dir"
state_file="$state_dir/last"

last=""
[ -f "$state_file" ] && last=$(cat "$state_file")
case "$last" in
	''|*[!0-9]*) last="" ;;
esac

# Reset when no longer discharging or back above highest threshold
if [ "$status" != "Discharging" ] || { [ "$capacity" != "?" ] && [ "$capacity" -gt 20 ]; }; then
	: > "$state_file"
	last=""
fi

if [ "$status" = "Discharging" ] && [ "$capacity" != "?" ]; then
	target_lvl=""
	for lvl in $warn_levels; do
		if [ "$capacity" -le "$lvl" ]; then
			target_lvl="$lvl"
		fi
	done

	if [ -n "$target_lvl" ] && { [ -z "$last" ] || [ "$target_lvl" -lt "$last" ]; }; then
		body="${capacity}%"
		[ -n "$time_remaining" ] && body="${capacity}% · ${time_remaining} left"
		case "$target_lvl" in
			20)    notify-send --app-name="Battery" --icon="battery-low"                      "Battery" "$body" ;;
			15|10) notify-send --app-name="Battery" --icon="battery-caution"                  "Battery" "$body" ;;
			5)     notify-send --app-name="Battery" --icon="battery-empty"                    "Battery" "$body" ;;
			*)     notify-send --app-name="Battery" --icon="battery-empty" --urgency=critical "Battery" "$body" ;;
		esac
		printf "%s\n" "$target_lvl" > "$state_file"
	fi
fi

# --- Power profile ---
profile=$(powerprofilesctl get 2>/dev/null)
profile=${profile:-balanced}

# --- Waybar icons (Nerd Font) ---
case "$profile" in
	performance)                         icon="󰂄" ;;
	power-saver*|powersave*|power_saver) icon="󱈑" ;;
	*)                                   icon="󰁹" ;;
esac

plug_icon=""
[ "$plugged" -eq 1 ] && plug_icon=" "

# --- JSON escape ---
json_escape() {
	printf '%s' "$1" | sed \
		-e 's/\\/\\\\/g' \
		-e 's/"/\\"/g' \
		-e ':a;N;$!ba;s/\n/\\n/g'
}

# --- Build output ---
tooltip="Profile: ${profile}
Status: ${status}"
[ -n "$time_remaining" ] && tooltip="${tooltip}
Time: ${time_remaining}"

text="${plug_icon}${icon} ${capacity}%"
printf '{"text":"%s","alt":"%s","tooltip":"%s"}\n' \
	"$(json_escape "$text")" \
	"$(json_escape "$icon")" \
	"$(json_escape "$tooltip")"
