#!/bin/sh

set -x

# Make sure that we are root
if [ `whoami` != 'root' ]; then
  echo "permission denied. (sudo su -)"
  exit
fi

# This is me
export USER=green

# Double check that we're fully up-to-date
yum -y update

# Create my user
/usr/sbin/useradd $USER

# Make me all powerful
/bin/echo '$USER  ALL=(ALL)  NOPASSWD: ALL' >> /etc/sudoers

# Run a series of commands as me...

# Download the mighty emacs config
su - $USER -c "cd /home/$USER && git clone git://github.com/atgreen/emacs.git && mv emacs .emacs.d && rm .emacs && touch .emacs.d/private.el"

# Install the proprietary but nevertheless useful dropbox.
su - $USER -c "cd /home/$USER && wget -O - http://www.dropbox.com/download?plat=lnx.x86_64 | tar xzf -"

# Install quicklisp
su - $USER -c "cd /home/$USER && wget http://beta.quicklisp.org/quicklisp.lisp"
#sbcl --load quicklisp.lisp --eval '(progn (quicklisp-quickstart:install) (sb-ext:quit))'

# Set up .screenrc
cat > /home/$USER/.screenrc <<DOTFILE
startup_message off
defscrollback 10000
hardstatus alwayslastline "%{.bW}%-w%{.rW}%n %t%{-}%+w 
shell -$RHEL
escape ^za
autodetach on
screen -t Shell 0 bash
screen -t Emacs em
select 0
DOTFILE

chown -R $USER.$USER /home/$USER/.emacs.d
chown -R $USER.$USER /home/$USER/.dropbox-dist
chown -R $USER.$USER /home/$USER/.screenrc





