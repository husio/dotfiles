#!/bin/sh

#xrandr --output eDP --mode 1280x720

telegram-desktop -startintray &

feh --bg-center /home/piotr/.wallpaper.png

/home/piotr/.bin/setup_keyboard


clear

exec i3
