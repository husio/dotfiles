#!/bin/bash

theme_file="/home/piotrek/.config/awesome/themes/blue/theme"
info_file="/home/piotrek/.awesomeinfo"

#color_light=`cat $theme_file | sed -n -e "s/fg_light[ ]*\=[ ]*\(\#.*\)/\1/p"`
color_light="#D2D2D2"
#color_normal=`cat $theme_file | sed -n -e "s/fg_normal[ ]*\=[ ]*\(\#.*\)/\1/p"`
color_normal="#A7A7A7"
#color_separator=`cat $theme_file | sed -n -e "s/fg_dark[ ]*\=[ ]*\(\#.*\)/\1/p"`
color_separator="#6D6D6D"

awesomeclient="/usr/bin/awesome-client"
