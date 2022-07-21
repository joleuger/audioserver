#!/bin/sh

export DEBIAN_FRONTEND=noninteractive

apt-get update -qq

#setup systemd (from https://github.com/solita/docker-systemd/blob/master/Dockerfile)
apt-get install -qy systemd dbus libpam-systemd systemd-container net-tools tzdata
#find /etc/systemd/system \
#         /lib/systemd/system \
#         -path '*.wants/*' \
#         -not -name '*journald*' \
#         -not -name '*systemd-tmpfiles*' \
#         -not -name '*systemd-user-sessions*' \
#         -exec rm \{} \;
systemctl set-default multi-user.target
mkdir -p /etc/systemd/system/
cp /install-files/install/system-first-run.service /etc/systemd/system/system-first-run.service
cp /install-files/install/system-update.service /etc/systemd/system/system-update.service
systemctl enable system-first-run.service
systemctl enable system-update.service
chmod 755 /install-files/install/system-first-run.sh
chmod 755 /install-files/install/system-update.sh
chmod 755 /install-files/install/user-first-run.sh
chmod 755 /install-files/install/user-update.sh
chmod 755 /install-files/settings/audioserver_restart_broadcast.sh
mkdir -p /etc/systemd/network
ln -s /settings/60-host0.network /etc/systemd/network --force
ln -s /settings/hostname /etc/hostname --force
systemctl enable systemd-networkd.service
systemctl enable systemd-resolved.service

#ln -s ../system-first-run.service /etc/systemd/system/multi-user.target.wants/

# create config directory
mkdir -p /settings
cp -Rf /install-files/settings/* /settings/
mkdir -p /media/music/playlists
cp -Rf /install-files/playlists/* /media/music/playlists
cp /etc/timezone /settings
ln -sf /settings/timezone /etc/timezone

# setup basic stuff and build tools
apt-get install -qy build-essential pulseaudio libpam-systemd git autotools-dev autoconf libtool gettext gawk gperf libunistring-dev libsqlite3-dev libavcodec-dev libavformat-dev libavfilter-dev libswscale-dev libavutil-dev libasound2-dev libpulse-dev libevent-dev libavahi-client-dev
#apt-get install -qy dbus-user-session # this can be used instead of custom user dbus.socket
mkdir -p /build

# setup icecast
apt-get install -qy gstreamer1.0-plugins-ugly lame gstreamer1.0-plugins-good ffmpeg gstreamer1.0-pulseaudio
mkdir /etc/icecast2
apt-get install -qy icecast2
ln -sf /settings/icecast.xml /etc/icecast2/
chmod 755 /settings/icecast.xml
ffmpeg -f lavfi -i aevalsrc=0 -t 5 /usr/share/icecast2/web/silence.mp3
sed -i -e 's/false/true/g' /etc/default/icecast2
#systemctl enable icecast2


# setup snapcast
apt-get install -qy libasound2-dev libvorbisidec-dev libvorbis-dev libflac-dev alsa-utils libavahi-client-dev avahi-daemon
cd /build
git clone https://github.com/badaix/snapcast.git
cd snapcast
git checkout tags/v0.15.0
cd externals
git submodule update --init --recursive
cd ../server
make
cp snapserver /usr/local/bin


# setup librespot
apt-get install -qy portaudio19-dev cmake python2.7 wget
#cd /build
#git clone https://github.com/rust-lang/rust.git
#cd rust
#git checkout tags/1.17.0
#./configure
#make && make install
cd /build
wget https://static.rust-lang.org/rustup/rustup-init.sh
chmod +x rustup-init.sh
./rustup-init.sh -y --default-toolchain stable 
export PATH="$HOME/.cargo/bin:$PATH"
cd /build
git clone https://github.com/plietar/librespot.git
cd librespot
#git checkout d95c0b3fcd2ddfa9d09a189d73b82090420d7f56
cargo build --release  --features "pulseaudio-backend"
cp target/release/librespot /usr/local/bin


# setup mopidy
apt-get install -qy python-dev python-gst-1.0 gir1.2-gstreamer-1.0 gir1.2-gst-plugins-base-1.0 gstreamer1.0-plugins-good gstreamer1.0-plugins-ugly gstreamer1.0-tools wget python-setuptools gstreamer1.0-pulseaudio libffi-dev python-dbus
#apt-get install -qy python-pip
cd /build
#pip install -U Mopidy==2.1.0
#pip install -U Mopidy-Iris==2.13.12 Mopidy-Local-SQLite==1.0.0 Mopidy-Moped==0.7.0
#pip install -U Mopidy-MPRIS==1.3.1
apt-get install -qy python-pip
pip install -U Mopidy
pip install -U Mopidy-Iris Mopidy-Local-SQLite Mopidy-Moped Mopidy-MPRIS

# setup way to control Mopidy with command line
apt-get install -qy python3-pip mpc
pip3 install -U pydbus
cp /install-files/install/control_mopidy_mpc.py /usr/local/bin
cp /install-files/install/control_mopidy_dbus.py /usr/local/bin


# setup shairport-sync
apt-get install -qy shairport-sync


# setup systemd configurations
ln -s /run/systemd/resolve/resolv.conf /etc/resolv.conf --force
mkdir -p /etc/systemd/journald.conf.d
echo [Journal] > /etc/systemd/journald.conf.d/limit-size.conf
echo SystemMaxUse=100M >> /etc/systemd/journald.conf.d/limit-size.conf
echo RuntimeMaxUse=100M >> /etc/systemd/journald.conf.d/limit-size.conf

# setup user audioserver
adduser --disabled-password --gecos "" audioserver
ln -s /settings/home_audioserver_.config /home/audioserver/.config
mkdir -p /home/audioserver/.config/systemd/user/default.target.wants/
ln -s ../user-first-run.service /home/audioserver/.config/systemd/user/default.target.wants/
ln -s ../user-update.service /home/audioserver/.config/systemd/user/default.target.wants/
ln -s /settings/home_audioserver_.asoundrc /home/audioserver/.asoundrc
chown -R audioserver:audioserver /settings/home_audioserver_.config
chown -R audioserver:audioserver /settings/home_audioserver_.asoundrc
chown -R audioserver:audioserver /home/audioserver/.config
chown -R audioserver:audioserver /home/audioserver/.asoundrc
chmod 755 /settings/home_audioserver_.config
mkdir -p /settings/audioserver
chown -R audioserver:audioserver /settings/audioserver
chmod 755 /settings/audioserver
cp /install-files/install/etc_security_limits_d_audioserver.conf /etc/security/limits.d/

rm -rf /build

exit
