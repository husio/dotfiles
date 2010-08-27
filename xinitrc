#!/bin/bash

#rm ~/.serverauth.* 2> /dev/null

#xcompmgr -Ccf -O 0.08 -I0.08 & &> /dev/null 

xkbcomp $HOME/.Xkb $DISPLAY &> /dev/null
xmodmap ~/.xmodmap &
xset r rate 170 30 &


dbuslaunch="`which dbus-launch 2>/dev/null`"
if [ -n "$dbuslaunch" ] && [ -x "$dbuslaunch" ] && [ -z "$DBUS_SESSION_BUS_ADDRESS" ]; then
    eval `$dbuslaunch --sh-syntax --exit-with-session` 
fi


#xscreensaver &
#irexec -d ~/.lircrc
#vala-fan &
#gajim &
#gnome-power-manager &
#feh --bg-scale ~/.wallpaper.png &

start-pulseaudio-x11


#xpad &
gnome-keyring-daemon --daemonize --login &
nm-applet --sm-disable &
empathy &
sonata --hidden &

# if [[ `xrandr -q | grep "VGA connected"` ]]
# then
#     xrandr --output LVDS --mode 1280x800 --auto --output VGA  --mode 1280x1024 --auto --right-of LVDS
#     #xrandr --output LVDS --mode 1280x800 --auto --output VGA  --mode 1024x768 --auto --right-of LVDS
# fi

# replace esc with caps lock
# setxkbmap -option caps:swapescape &

ck-launch-session awesome
#dbus-launch --exit-with-session awesome
