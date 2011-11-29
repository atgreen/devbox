#!/bin/sh

# Make sure that we are root
if [ `whoami` != 'root' ]; then
  echo "permission denied. (sudo su -)"
  exit
fi

# This is me
USER=green

# Double check that we're fully up-to-date
yum -y update

# Create my user
/usr/sbin/useradd $USER

# Make me all powerful
/bin/echo '$USER  ALL=(ALL)  NOPASSWD: ALL' >> /etc/sudoers

# Download the mighty emacs config
sudo su - $USER -c "git clone git://github.com/atgreen/emacs && mv emacs .emacs.d && rm .emacs && touch .emacs.d/private.el"

# Install the proprietary but nevertheless useful dropbox
sudo su - $USER -c "wget -O - http://www.dropbox.com/download?plat=lnx.x86_64 | tar xzf -"

# Install quicklisp
sudo su - $USER -c "wget http://beta.quicklisp.org/quicklisp.lisp"
sudo su - $USER -c "sbcl --load quicklisp.lisp --eval '(progn (quicklisp-quickstart:install) (sb-ext:quit))'"



