#!/bin/bash

function delay {
    sleep $1
    shift 1
    $@
}

#rm ~/.serverauth.* 2> /dev/null

#xcompmgr -Ccf -O 0.08 -I0.08 & &> /dev/null

xkbcomp $HOME/.Xkb $DISPLAY &> /dev/null
xmodmap ~/.xmodmap &
xset r rate 250 35 &
#xset dpms 0 0 30

# privoxy
#export http_proxy='127.0.0.1:8118'

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

#start-pulseaudio-x11


function dualscreen() {
#     xrandr --output LVDS --mode 1280x800 --auto --output VGA  --mode 1280x1024 --auto --right-of LVDS
#     #xrandr --output LVDS --mode 1280x800 --auto --output VGA  --mode 1024x768 --auto --right-of LVDS
      xrandr --output VGA1 --mode 1280x1024 --rate 75 --right-of LVDS1 --output LVDS1 --mode 1280x800
      sonata &
      feh --bg-scale $HOME/.wallpapers/dualscreen_stones.jpg
      nm-applet &
}


# replace esc with caps lock
# setxkbmap -option caps:swapescape &

#ck-launch-session awesome
#dbus-launch --exit-with-session awesome
exec ck-launch-session sh ~/.xsession
