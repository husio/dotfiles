#!/bin/bash


REPO=`pwd`

cp $HOME/.Xdefaults $REPO/Xdefaults
cp $HOME/.xinitrc $REPO/xinitrc
cp $HOME/.xsession $REPO/xsession
cp $HOME/.tmux.conf $REPO/tmux.conf
cp $HOME/.hgrc $REPO/hgrc
cp $HOME/.gitconfig $REPO/gitconfig

mkdir $REPO/config 2> /dev/null

mkdir $REPO/config/awesome 2> /dev/null
cp $HOME/.config/awesome/rc.lua $REPO/config/awesome/rc.lua
cp $HOME/.config/awesome/themes/theme.lua $REPO/config/awesome/theme.lua
