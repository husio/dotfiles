#!/bin/bash

. $HOME/.config/awesome/actions/action.sh


time_info="<span color=\"$color_normal\">time: </span><span color=\"$color_light\">`date +'%H:%M'`</span>"

echo "mytimebox.text = '$time_info'" | $awesomeclient -
