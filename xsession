#!/bin/bash

# run ssh agent
eval $(ssh-agent -s)
eval $(/usr/bin/gnome-keyring-daemon --start --components=pkcs11,secrets,ssh)
export SSH_AUTH_SOCK

#eval $(/usr/bin/gnome-keyring-daemon --start --components=pkcs11,secrets,ssh)

feh --bg-center .wallpaper.png

/home/piotr/.bin/setup_keyboard
/home/piotr/.bin/setup_screen

nm-applet &

~/.TelegramDesktop/Telegram -startintray &

#start-pulseaudio-x11 &

exec ck-launch-session dbus-launch i3
clear
exit
