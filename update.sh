#!/bin/sh

set -e

REPO=$(pwd)

backup() {
  mkdir -p $(dirname $2)
  cp -R "$1" "$2"
}

backup $HOME/.bin/choose_browser $REPO/bin/choose_browser
backup $HOME/.bin/loadpass $REPO/bin/loadpas
backup $HOME/.bin/playclipboard $REPO/bin/playclipboard
backup $HOME/.bin/playtwitch $REPO/bin/playtwitch
backup $HOME/.bin/radio $REPO/bin/radio
backup $HOME/.bin/renderhtml $REPO/bin/renderhtml
backup $HOME/.bin/setup_keyboard $REPO/bin/setup_keyboard
backup $HOME/.bin/setup_screen $REPO/bin/setup_screen
backup $HOME/.bin/twtxtsh $REPO/bin/twtxtsh
backup $HOME/.bin/up $REPO/bin/up
backup $HOME/.bin/youtube-download-mp3 $REPO/bin/youtube-download-mp3

backup $HOME/.Xdefaults $REPO/Xdefaults
backup $HOME/.config/i3/config $REPO/i3/
backup $HOME/.config/i3status $REPO/config/i3status
backup $HOME/.config/fontconfig $REPO/config/fontconfig
backup $HOME/.gitconfig $REPO/gitconfig
backup $HOME/.pythonrc $REPO/pythonrc
backup $HOME/.tmux.conf $REPO/tmux.conf
backup $HOME/.tmux.conf $REPO/tmux.conf
backup $HOME/.wallpaper.png $REPO/wallpaper.png
backup $HOME/.lockscreen.png $REPO/lockscreen.png
backup $HOME/.xinitrc $REPO/xinitrc
backup $HOME/.xsession $REPO/xsession
backup $HOME/.zshrc.local $REPO/zshrc.local
backup $HOME/.gtkrc-2.0 $REPO/gtkrc-2.0
backup $HOME/.newsboat $REPO/newsboat

# No aliases, cache or secrets
backup $HOME/.mutt/README $REPO/mutt/README
backup $HOME/.mutt/gpg $REPO/mutt/gpg
backup $HOME/.mutt/colors $REPO/mutt/colors
backup $HOME/.mutt/mailcap $REPO/mutt/mailcap
backup $HOME/.mutt/signature $REPO/mutt/signature
backup $HOME/.mutt/muttrc.phusiatynski $REPO/mutt/muttrc.phusiatynski
