#!/bin/bash

. action.sh

fan_speed_info="<span color=\"$color_normal\">fan: </span><span color=\"$color_light\">`/usr/bin/fan`</span>"

echo "myfanbox.text = '$fan_speed_info'" | $awesomeclient -
