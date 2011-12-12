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
/bin/echo $USER "  ALL=(ALL)  NOPASSWD: ALL" >> /etc/sudoers

# Run a series of commands as me...

# Download the mighty emacs config
su - $USER -c "cd /home/$USER && git clone git://github.com/atgreen/emacs.git"
su - $USER -c "cd /home/$USER && mv emacs .emacs.d && rm .emacs && touch .emacs.d/private.el"

# Install the proprietary but nevertheless useful dropbox.
su - $USER -c "cd /home/$USER && wget -O - http://www.dropbox.com/download?plat=lnx.x86_64 | tar xzf -"

# Install quicklisp
su - $USER -c "cd /home/$USER && wget http://beta.quicklisp.org/quicklisp.lisp"
# su - $USER -c "cd /home/$USER && sbcl --load quicklisp.lisp --eval '(progn (quicklisp-quickstart:install) (sb-ext:quit))'"

# Set up .screenrc
cat > /home/$USER/.screenrc <<EOF
startup_message off
defscrollback 10000
hardstatus alwayslastline "%{.bW}%-w%{.rW}%n %t%{-}%+w"
shell /bin/bash
escape ^za
autodetach on
screen -t Emacs emacs -nw
screen -t Shell 0 bash
select 1
EOF

cat > /home/$USER/.gitconfig <<EOF
[user]
        name = Anthony Green
        email = green@moxielogic.com
[color]
        ui = auto
EOF

cat >> /home/$USER/.bashrc <<EOF
alias e="emacsclient -t"
alias qli="sbcl --load quicklisp.lisp --eval '(progn (quicklisp-quickstart:install) (sb-ext:quit))'"
EOF

chown -R $USER.$USER /home/$USER/.emacs.d
chown -R $USER.$USER /home/$USER/.dropbox-dist
chown -R $USER.$USER /home/$USER/.screenrc
chown -R $USER.$USER /home/$USER/.gitconfig


