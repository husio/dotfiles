#!/bin/bash


ENV_FILE=$HOME/.Xdbus

touch $ENV_FILE
chmod 600 $ENV_FILE
env | grep -E '(DBUS_SESSION_BUS_ADDRESS|XAUTHORITY|DISPLAY)' > $ENV_FILE
gnome-keyring-daemon --start >> $ENV_FILE



function delay {
    sleep $1
    shift 1
    source $ENV_FILE
    $@
}

function network_dependent {
    sleep $1
    shift 1
    ping -c2 google.com
    if [[ $? -eq 0 ]]
    then
        source $ENV_FILE
        $@
    fi
}


xset m 5 1
xset r rate 250 35
xset -b
setxkbmap -option caps:escape
setxkbmap pl


nm-applet --sm-disable &
delay 2 thunar --daemon &
#feh --bg-center ~/.wallpaper.png &
feh --bg-scale ~/.wallpaper.png &

network_dependent 15 gajim &


#exec awesome --no-argb
exec awesome
exit
