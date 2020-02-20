#!/bin/sh

set -x

REPO=`pwd`


backup() {
	mkdir -p `dirname $2`
	cp -R "$1" "$2"
}


backup $HOME/.bin/radio $REPO/bin/radio
backup $HOME/.bin/setup_keyboard $REPO/bin/setup_keyboard
backup $HOME/.bin/setup_mouse $REPO/bin/setup_mouse
backup $HOME/.bin/setup_screen $REPO/bin/setup_screen
backup $HOME/.bin/up $REPO/bin/up
backup $HOME/.bin/youtube-download-mp3 $REPO/bin/youtube-download-mp3
backup $HOME/.bin/playtwitch $REPO/bin/playtwitch

backup $HOME/.Xdefaults $REPO/Xdefaults
backup $HOME/.config/i3/config $REPO/i3/
backup $HOME/.gitconfig $REPO/gitconfig
backup $HOME/.i3status.conf $REPO/i3status.conf
backup $HOME/.pythonrc $REPO/pythonrc
backup $HOME/.tmux.conf $REPO/tmux.conf
backup $HOME/.tmux.conf $REPO/tmux.conf
backup $HOME/.wallpaper.png $REPO/wallpaper.png
backup $HOME/.xinitrc $REPO/xinitrc
backup $HOME/.xsession $REPO/xsession
backup $HOME/.zshrc.local $REPO/zshrc.local
backup $HOME/.gtkrc-2.0 $REPO/gtkrc-2.0
