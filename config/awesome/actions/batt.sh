#!/bin/bash

. $HOME/.config/awesome/actions/action.sh


battery_info="<span color=\"$color_normal\">batt: </span><span color=\"$color_light\">`acpi  | awk '{ print $4 }'`</span>"

echo "mybattbox.text = '$battery_info'" | $awesomeclient -
