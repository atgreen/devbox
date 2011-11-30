#!/bin/sh

echo AAAA

# Make sure that we are root
if [ `whoami` != 'root' ]; then
  echo "permission denied. (sudo su -)"
  exit
fi

echo BBBB
# This is me
USER=green

# Double check that we're fully up-to-date
yum -y update
echo CCCC

# Create my user
/usr/sbin/useradd $USER
echo DDDD

# Make me all powerful
/bin/echo '$USER  ALL=(ALL)  NOPASSWD: ALL' >> /etc/sudoers

echo EEEE
# Download the mighty emacs config
su - $USER -c "git clone git://github.com/atgreen/emacs && mv emacs .emacs.d && rm .emacs && touch .emacs.d/private.el"

echo FFFF
# Install the proprietary but nevertheless useful dropbox
su - $USER -c "wget -O - http://www.dropbox.com/download?plat=lnx.x86_64 | tar xzf -"

echo GGGG
# Install quicklisp
su - $USER -c "wget http://beta.quicklisp.org/quicklisp.lisp"
echo HHHH
su - $USER -c "sbcl --load quicklisp.lisp --eval '(progn (quicklisp-quickstart:install) (sb-ext:quit))'"
echo IIII



