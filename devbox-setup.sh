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

CMDFILE=`mktemp`
cat > $CMDFILE <<EOF
#!/bin/sh

cd /home/$USER
pwd

# Download the mighty emacs config
git clone git://github.com/atgreen/emacs 
mv emacs .emacs.d 
rm .emacs 
touch .emacs.d/private.el

# Install the proprietary but nevertheless useful dropbox..
wget -O - http://www.dropbox.com/download?plat=lnx.x86_64 | tar xzf -

# Install quicklisp
wget http://beta.quicklisp.org/quicklisp.lisp
sbcl --load quicklisp.lisp --eval '(progn (quicklisp-quickstart:install) (sb-ext:quit))'
EOF
chmod 755 $CMDFILE

su - $USER -c "$CMDFILE"





