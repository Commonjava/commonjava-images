# .bashrc

# User specific aliases and functions

alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'

source /usr/local/bin/setup-user.sh

# Source global definitions
if [ -f /etc/bashrc ]; then
 . /etc/bashrc
fi
