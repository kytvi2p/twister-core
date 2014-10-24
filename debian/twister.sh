#!/bin/sh

set -e

umask 077

basedir="$HOME/.twister"
dbfile="$basedir/DB_CONFIG"
cfgfile="$basedir/twister.conf"

[ -e "$basedir" ] || mkdir "$basedir"


# twister does not clean up DB log files by default
[ -e "$dbfile" ] || echo 'set_flags DB_LOG_AUTOREMOVE' > "$dbfile"

# create default twister config and set up web interface
if [ ! -e $cfgfile ] && [ ! $(id -nu) = 'twister' ]; then
    cat > $cfgfile << EOF
rpcuser=user
rpcpassword=pwd
daemon=1
server=1
EOF
    if [ -d /usr/share/twister-html ]; then
        printf 'htmldir=/usr/share/twister-html\n' >> $cfgfile
        printf 'Twister should be accessible at http://user:pwd@127.0.0.1:28332\n'
        printf '\n(This message will only be shown once)\n'
    fi
fi
exec /usr/lib/twister/twisterd "$@"
