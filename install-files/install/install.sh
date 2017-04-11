#!/bin/sh

apt-get update -qq

#setup systemd (from https://github.com/solita/docker-systemd/blob/master/Dockerfile)
apt-get install -qy systemd dbus libpam-systemd systemd-container
#find /etc/systemd/system \
#         /lib/systemd/system \
#         -path '*.wants/*' \
#         -not -name '*journald*' \
#         -not -name '*systemd-tmpfiles*' \
#         -not -name '*systemd-user-sessions*' \
#         -exec rm \{} \;
systemctl set-default multi-user.target
mkdir -p /etc/systemd/system/
cp /install-files/install/audioserver-system-first-run.service /etc/systemd/system/audioserver-system-first-run.service
cp /install-files/install/audioserver-system-update.service /etc/systemd/system/audioserver-system-update.service
systemctl enable audioserver-system-first-run.service
systemctl enable audioserver-system-update.service
chmod 755 /install-files/install/system-first-run.sh
chmod 755 /install-files/install/system-update.sh
chmod 755 /install-files/install/user-first-run.sh
chmod 755 /install-files/install/user-update.sh
#ln -s ../audioserver-system-first-run.service /etc/systemd/system/multi-user.target.wants/

# create config directory
mkdir -p /settings
cp -Rf /install-files/settings/* /settings/
mkdir -p /media/music/playlists
cp -Rf /install-files/playlists/* /media/music/playlists

# link configurations
mkdir -p /etc/systemd/network
ln -s /settings/60-host0.network /etc/systemd/network --force
ln -s /run/systemd/resolve/resolv.conf /etc/resolv.conf --force
ln -s /settings/hostname /etc/hostname --force
systemctl enable systemd-networkd.service
systemctl enable systemd-resolved.service

# setup basic stuff and build tools
apt-get install -qy build-essential pulseaudio libpam-systemd git autotools-dev autoconf libtool gettext gawk gperf libunistring-dev libsqlite3-dev libavcodec-dev libavformat-dev libavfilter-dev libswscale-dev libavutil-dev libasound2-dev libpulse-dev libevent-dev libavahi-client-dev
mkdir -p /tmp/build

# setup icecast
apt-get install -qy gstreamer1.0-plugins-ugly lame gstreamer1.0-plugins-good ffmpeg
mkdir /etc/icecast2
apt-get install -qy icecast2
ln -sf /settings/icecast.xml /etc/icecast2/
ffmpeg -f lavfi -i aevalsrc=0 -t 5 /usr/share/icecast2/web/silence.mp3
#systemctl enable icecast2


# setup snapcast
apt-get install -qy libasound2-dev libvorbisidec-dev libvorbis-dev libflac-dev alsa-utils libavahi-client-dev avahi-daemon
cd /tmp/build
git fetch https://github.com/badaix/snapcast.git
cd snapcast
git checkout tags/v0.11.1
cd externals
git submodule update --init --recursive
cd ../server
make
cp snapserver /usr/local/bin


# setup librespot
apt-get install -qy cargo
cd /tmp
git fetch https://github.com/plietar/librespot.git
cd librespot
git checkout d551d194d38ad89f6b4c842537b7c3f534b3bf89
cargo build --release


# setup mopidy
apt-get install -qy python-dev python-gst-1.0 gir1.2-gstreamer-1.0 gir1.2-gst-plugins-base-1.0 gstreamer1.0-plugins-good gstreamer1.0-plugins-ugly gstreamer1.0-tools wget
cd /tmp/build
wget https://pypi.python.org/packages/11/b6/abcb525026a4be042b486df43905d6893fb04f05aac21c32c638e939e447/pip-9.0.1.tar.gz#md5=35f01da33009719497f01a4ba69d63c9
easy_install pip-9.0.1
pip install -U Mopidy==2.1.0
pip install -U Mopidy-Iris==2.13.12 Mopidy-Local-SQLite==1.0.0 Mopidy-Moped==0.7.0



# setup user audioserver
adduser --disabled-password --gecos "" audioserver
mkdir -p /home/audioserver/.config/systemd/user/default.target.wants/
ln -s ../audioserver-user-first-run.service /home/audioserver/.config/systemd/user/default.target.wants/
ln -s ../audioserver-user-update.service /home/audioserver/.config/systemd/user/default.target.wants/
ln -s /settings/home_audioserver_.config /home/audioserver/.config
ln -s /settings/home_audioserver_.asoundrc /home/audioserver/.asoundrc
chown -R audioserver:audioserver /settings/home_audioserver_.config
chown -R audioserver:audioserver /settings/home_audioserver_.asoundrc
chown -R audioserver:audioserver /home/audioserver/.config
chown -R audioserver:audioserver /home/audioserver/.asoundrc

#rm -rf /tmp/build

exit
