#!/bin/bash

. $HOME/.config/awesome/actions/action.sh

date_info="<span color=\"$color_normal\">date: </span><span color=\"$color_light\">`date +'%a, %d.%m.%G'`</span>"


echo "mydatebox.text = '$date_info'" | $awesomeclient -
