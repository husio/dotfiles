#!/bin/sh

feh --bg-center /home/piotr/.wallpaper.png
/home/piotr/.bin/setup_keyboard

telegram-desktop -startintray &

if xrandr | grep -q 'HDMI-A-0 connected'; then
  xrandr --output 'HDMI-A-0' --right-of eDP --output eDP --auto
fi

clear

exec i3
