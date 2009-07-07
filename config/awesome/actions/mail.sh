#!/bin/bash

. $HOME/.config/awesome/actions/action.sh


mail_boxes=(
#    /home/piotrek/.Mail/arch
    /home/piotrek/.Mail/phusiatynski
#    /home/piotrek/.Mail/piotrhusiatynski
    /home/piotrek/.Mail/wsisiz
    /home/piotrek/.Mail/python
)


new_mail_numeber=0
for mailbox in ${mail_boxes[@]} ; do
    new_mail_numeber=$(( new_mail_numeber + `ls $mailbox/new | wc -l`))
done
if [[ $new_mail_numeber > 0 ]]; then
    if [[ $new_mail_numeber = 1 ]]; then
        new_mail_numeber="<span color=\"red\">$new_mail_numeber nowy mail</span>"
    else
        new_mail_numeber="<span color=\"red\">$new_mail_numeber nowe maile</span>"
    fi
else
    new_mail_numeber="<span color=\"$color_light\">$new_mail_numeber</span>"
fi

mail_info="<span color=\"$color_normal\">mail: </span>$new_mail_numeber"


echo "mymailbox.text = '$mail_info'" | $awesomeclient -
