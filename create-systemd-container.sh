#!/bin/sh

UBUNTU_VERSION=yakkety
debootstrap --variant=minbase --arch=amd64 yakkety container http://archive.ubuntu.com/ubuntu/
echo deb http://archive.ubuntu.com/ubuntu/ $UBUNTU_VERSION main restricted universe multiverse > container/etc/apt/sources.list
echo deb http://archive.ubuntu.com/ubuntu/ $UBUNTU_VERSION-updates main restricted universe multiverse >> container/etc/apt/sources.list
echo deb http://security.ubuntu.com/ubuntu/ $UBUNTU_VERSION-security main restricted universe multiverse >> container/etc/apt/sources.list

cp -Rf ./install-files container/install-files
systemd-nspawn -M audioserver -D container -- chmod +x /install-files/install/install.sh
sleep 1
systemd-nspawn -M audioserver -D container -- /install-files/install/install.sh

#systemd-firstboot --root=container --copy-locale --copy-timezone

# Copy initial files to fresh bind
mkdir mysettings
systemd-nspawn -M audioserver -D container --bind=$(pwd)/mysettings:/mysettings -- /bin/bash -c "cp -Rn /settings/* /mysettings/"

# To boot the new machine,
#    systemd-nspawn -M audioserver -D container --bind=$(pwd)/mysettings:/settings -b
# To boot with an own ip, see setup-bridge.sh
#    systemd-nspawn -M audioserver -D container --bind=$(pwd)/mysettings:/settings --network-bridge=br_wired -b

# To access the audioserver, you simply need to run for root access
#    machinectl shell audioserver
# or for user access
#    machinectl shell audioserver@audioserver

