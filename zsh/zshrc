#!/bin/zsh

[[ -f ~/.profile ]] && . ~/.profile

# use hard limits, except for a smaller stack and no core dumps
unlimit
limit stack 8192
limit core 0
limit -s

ulimit -S -c 0 > /dev/null 2>&1

# do not autorrect mistakes
export NOCOR=1
. /etc/zsh/zshrc

. ~/.zsh/exports
. ~/.zsh/colors
. ~/.zsh/zsettings
. ~/.zsh/functions
. ~/.zsh/alias
. ~/.zsh/prompt
. ~/.zsh/bindings
