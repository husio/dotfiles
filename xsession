function delay {
    sleep $1
    shift 1
    DBUS_SESSION_BUS_ADDRESS=`cat $HOME/.dbus_session_bus_address` $@
}

function network_dependent {
    sleep $1
    shift 1
    ping -c2 google.com

    if [[ $? -eq 0 ]]
    then
        DBUS_SESSION_BUS_ADDRESS=`cat $HOME/.dbus_session_bus_address` $@
    fi
}

echo $DBUS_SESSION_BUS_ADDRESS > $HOME/.dbus_session_bus_address


xset m 5 1
xset r rate 250 35
xset -b
setxkbmap -option caps:escape
setxkbmap pl
gnome-keyring-daemon --daemonize --login &


nm-applet --sm-disable &
#delay 1 blueman-applet &
#delay 2 thunar --daemon &
network_dependent 10 gajim &
network_dependent 10 skype &

feh --bg-scale ~/.wallpaper.jpg

exec awesome
exit
