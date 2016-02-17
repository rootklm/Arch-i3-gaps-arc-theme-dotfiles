#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'

# Make sure locales are set properly
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8
export LANGUAGE=en_US.UTF-8

# Initial line of your shell
PS1='[\u@\h \W]\$ '

# Add things to your shell
export PATH=$HOME/bin:$PATH
if [ -d "$HOME/.local/bin" ]; then
	PATH="$HOME/.local/bin:$PATH"
fi

# Enable powerline in bash
powerline-daemon -q
POWERLINE_BASH_CONTINUATION=1
POWERLINE_BASH_SELECT=1
. /home/rklm/.local/lib/python3.5/site-packages/powerline/bindings/bash/powerline.sh
