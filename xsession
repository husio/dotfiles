#!/bin/bash

# run ssh agent
eval $(ssh-agent -s)
# ssh-add  $HOME/.ssh/id_rsa
export SSH_AUTH_SOCK

/home/piotr/.bin/setup_screen
/home/piotr/.bin/setup_keyboard

feh --bg-center .wallpaper.png

telegram-desktop -startintray &

clear
exec i3
