#!/bin/sh
set -xe

apt-get update
apt-get install -y \
        apt-transport-https \
        ca-certificates \
        curl \
        dirmngr \
        gnupg2 \
        software-properties-common

#
# Docker
#

curl -fsSL https://download.docker.com/linux/debian/gpg | apt-key add -
add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/debian $(lsb_release -cs) stable"
apt-get update
apt-get install -y \
        docker-ce \
        docker-compose

systemctl enable docker
systemctl start docker
usermod -aG docker vagrant


#
# Google Cloud SDK
#

curl -fsSL https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -
apt-add-repository "deb [arch=amd64] http://packages.cloud.google.com/apt cloud-sdk-$(lsb_release -c -s) main"
apt-get update
apt-get install -y google-cloud-sdk


#
# Chrony
#

apt-get update
apt-get install -y chrony

systemctl enable chrony
systemctl start chrony


#
# System configuration
#

cat <<EOF > /etc/default/locale
LANG="en_US.UTF-8"
LC_ALL=en_US.UTF-8
EOF


#
# User configuration
#

chsh -s /bin/bash vagrant
sudo -u vagrant sh <<EOF
cd "\$HOME" || exit
rm -f \
   .bashrc \
   .cshrc \
   .lesshst \
   .login \
   .login-e \
   .login_conf \
   .mail_aliases \
   .mailrc \
   .profile \
   .profile-e \
   .rhosts \
   .rnd \
   .shrc

cat <<EOS > "\$HOME/.profile"
#!/bin/sh

PATH=/sbin:/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin; export PATH
EDITOR=vim; export EDITOR
PAGER=less; export PAGER
LANG=en_US.UTF-8; export LANG

if [ -n "\\\$BASH_VERSION" ]; then
  if [ -f "\\\$HOME/.bashrc" ]; then
    . "\\\$HOME/.bashrc"
  fi
fi
EOS

cat <<EOS > "\$HOME/.bashrc"
#!/bin/bash

[[ \\\$- != *i* ]] && return
[[ -s /etc/bash.bashrc ]] && source /etc/bash.bashrc
[[ -s ~/.bash_aliases ]] && source ~/.bash_aliases

shopt -s checkwinsize
shopt -s histappend

HISTCONTROL=ignoreboth
HISTSIZE=1000
HISTFILESIZE=2000

PS1="\\[\\033[01;32m\\]\\u@\\h\\[\\033[00m\\]:\\[\\033[01;34m\\]\\w\\[\\033[00m\\]\\\$ "

alias ls='ls --color=auto'
alias ll='ls -l'
alias la='ls -A'
alias l='ls -CF'

alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'

[[ \\\$- != *c* ]] && cd /vagrant
EOS
EOF
