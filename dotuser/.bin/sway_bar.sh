#!/usr/bin/env bash

sep="     "
date=$(date "+ %d.%m.%Y ")
time=$(date "+ %H:%M")

volume=$(pactl get-sink-volume @DEFAULT_SINK@ | grep -Po '\d+(?=%)' | head -n 1)
is_muted=$(pactl get-sink-mute @DEFAULT_SINK@ | awk '{print $2}')
if [ "$is_muted" = "yes" ]; then
    audio="🔈Muted"
else
    audio=" ${volume}%"
fi

bluetooth_headphones=$(upower --show-info $(upower --enumerate | grep 'headset_dev') | awk '/percentage/ {print $2}')
if ! [ -z $bluetooth_headphones ]; then
  model=$(upower --show-info $(upower --enumerate | grep 'headset_dev') | grep model | cut -d ':' -f 2- | xargs)
  audio=" $bluetooth_headphones ($model) $sep $audio"
fi

battery=$(upower --show-info $(upower --enumerate | grep 'BAT') | awk ' /percentage/ {print $2}')
if [ $(upower --show-info $(upower --enumerate | grep 'BAT') | awk ' /state/ {print $2}') = "discharging" ]; then
  battery="🔋 $battery"
else
  battery=" $battery"
fi

wifi_essid=$(iw dev wlp1s0 link | awk '/SSID:/ { print $2 }')
if [ $wifi_essid ]; then
  network=" $wifi_essid"
else
  network="-"
fi


echo "$network $sep $audio $sep $battery $sep $date $sep $time $sep"
