#!/bin/bash

. $HOME/.config/awesome/actions/action.sh

rss_info="<span color=\"$color_normal\">rss: </span><span color=\"$color_light\">`canto -a | tail -n1`</span>"

echo "myrssbox.text = '$rss_info'" | $awesomeclient -
