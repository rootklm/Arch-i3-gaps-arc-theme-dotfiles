#
# ~/.bash_profile
#

[[ -f ~/.bashrc ]] && . ~/.bashrc
# MPD daemon start (if no other user instance exists)
[ ! -s ~/.config/mpd/pid ] && mpd
# Start x server and thus i3
[[ -z $DISPLAY && $XDG_VTNR -eq 1 ]] && exec startx
