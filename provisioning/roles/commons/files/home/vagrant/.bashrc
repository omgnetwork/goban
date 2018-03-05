[[ $- != *i* ]] && return
[[ -s /etc/bash.bashrc ]] && source /etc/bash.bashrc
[[ -s ~/.bash_aliases ]] && source ~/.bash_aliases

shopt -s checkwinsize
shopt -s histappend
HISTCONTROL=ignoreboth
HISTSIZE=1000
HISTFILESIZE=2000

PS1="\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ "

alias ls='ls --color=auto'
alias ll='ls -l'
alias la='ls -A'
alias l='ls -CF'

alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'

[[ $- != *c* ]] && cd /vagrant
