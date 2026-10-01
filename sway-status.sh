#!/bin/sh
# Status line for swaybar: battery + volume + date/time
bat=/sys/class/power_supply/macsmc-battery

while :; do
    cap=$(cat "$bat/capacity")
    case $(cat "$bat/status") in
        Charging)    icon="⚡" ;;
        Discharging) icon="🔋" ;;
        *)           icon="🔌" ;;
    esac
    echo "$icon $cap% | $(date +'%Y-%m-%d %X')"
    sleep 1
done
