#!/bin/sh
systemctl --user disable --now pulseaudio.socket

systemctl --user enable --now dbus.socket
systemctl --user enable --now audioserver_pulseaudio.service
systemctl --user enable --now audioserver_shairport.service
systemctl --user enable --now audioserver_to_icecast.service
systemctl --user enable --now audioserver_to_snapcast.service
systemctl --user enable --now audioserver_restart_broadcast.timer
#systemctl --user enable audioserver_reload_mopidy.timer
#systemctl --user enable audioserver_rygel.service
systemctl --user enable --now audioserver_mopidy.service

echo 1 > /home/audioserver/user.version
