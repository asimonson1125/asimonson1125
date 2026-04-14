#!/bin/bash
# Toggle floating. When a window becomes floating, fill the workable area
# (full width, full height below the bar) with no gaps.

hyprctl dispatch togglefloating

sleep 0.1

win=$(hyprctl -j activewindow)
is_floating=$(echo "$win" | jq '.floating')

if [ "$is_floating" = "true" ]; then
    mon=$(hyprctl -j monitors | jq '.[] | select(.focused == true)')
    log_w=$(echo "$mon" | jq '(.width / .scale) | round')
    log_h=$(echo "$mon" | jq '(.height / .scale) | round')
    reserved_top=$(echo "$mon" | jq '.reserved[1]')

    work_w=$log_w
    work_h=$((log_h - reserved_top))

    hyprctl dispatch resizeactive exact "$work_w" "$work_h"
    hyprctl dispatch moveactive exact 0 "$reserved_top"
fi
