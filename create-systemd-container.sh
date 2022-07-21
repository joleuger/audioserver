#!/bin/sh

if [ $1 ]
then
PREFIX=$1
else
PREFIX=$(pwd)
fi

UBUNTU_VERSION=jammy
CONTAINER_DIR=$PREFIX/image-$UBUNTU_VERSION
SETTINGS_DIR=$PREFIX/settings-$UBUNTU_VERSION
MACHINE_NAME=audioserver

debootstrap --variant=minbase --arch=amd64 $UBUNTU_VERSION $CONTAINER_DIR http://archive.ubuntu.com/ubuntu/
echo deb http://archive.ubuntu.com/ubuntu/ $UBUNTU_VERSION main restricted universe multiverse > $CONTAINER_DIR/etc/apt/sources.list
echo deb http://archive.ubuntu.com/ubuntu/ $UBUNTU_VERSION-updates main restricted universe multiverse >> $CONTAINER_DIR/etc/apt/sources.list
echo deb http://security.ubuntu.com/ubuntu/ $UBUNTU_VERSION-security main restricted universe multiverse >> $CONTAINER_DIR/etc/apt/sources.list

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
