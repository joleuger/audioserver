#!/bin/sh

if [ $1 ]
then
PREFIX=$1
else
PREFIX=$(pwd)
fi

CONTAINER_DIR=$PREFIX/newimage
SETTINGS_DIR=$PREFIX/newsettings
STORAGE_DIR=$PREFIX/newstorage

mkosi -t directory -o $CONTAINER_DIR --force --with-network

#systemd-firstboot --root=container --copy-locale --copy-timezone

# Copy initial files to fresh bind
mkdir $SETTINGS_DIR
systemd-nspawn -M $MACHINE_NAME -D $CONTAINER_DIR --bind=$SETTINGS_DIR:/tmp/mysettings -- /bin/bash -c "cp -Rpn /settings/* /tmp/mysettings/"

# To boot the new machine (of course, parameters must be adapted),
#    systemd-nspawn -M audioserver -D container --bind=$(pwd)/mysettings:/settings -b
# To boot with an own ip, see setup-bridge.md
#    systemd-nspawn -M audioserver -D container --bind=$(pwd)/mysettings:/settings --network-bridge=br_wired -b

# To access the audioserver, you simply need to run for root access
#    machinectl shell audioserver
# or for user access
#    machinectl shell audioserver@audioserver

# Set timezone "dpkg-reconfigure tzdata"
