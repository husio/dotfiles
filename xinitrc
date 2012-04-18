#!/bin/bash


xkbcomp $HOME/.Xkb $DISPLAY &> /dev/null
xmodmap ~/.xmodmap &
xset r rate 250 35 &

# privoxy
#export http_proxy='127.0.0.1:8118'

function dualscreen() {
      xrandr --output VGA1 --mode 1280x1024 --rate 75 --right-of LVDS1 --output LVDS1 --mode 1280x800
      sonata &
      feh --bg-scale $HOME/.wallpapers/dualscreen_stones.jpg
      nm-applet &
}


# replace esc with caps lock
# setxkbmap -option caps:swapescape &

#ck-launch-session awesome
#dbus-launch --exit-with-session awesome
#exec ck-launch-session sh ~/.xsession

# D-Bus
if which dbus-launch >/dev/null && test -z "$DBUS_SESSION_BUS_ADDRESS"; then
    eval "$(dbus-launch --sh-syntax --exit-with-session)"
fi


#exec ck-launch-session dbus-launch sh ~/.xsession
exec ck-launch-session sh $HOME/.xsession
