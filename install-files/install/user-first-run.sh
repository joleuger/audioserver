#!/bin/sh
systemctl --user disable pulseaudio.socket

systemctl --user enable dbus.socket
systemctl --user enable audioserver_pulseaudio.service
systemctl --user enable audioserver_shairport.service
systemctl --user enable audioserver_to_icecast.service
systemctl --user enable audioserver_to_snapcast.service
systemctl --user enable audioserver_restart_broadcast.timer
systemctl --user enable audioserver_reload_mopidy.timer
#systemctl --user enable audioserver_rygel.service
systemctl --user enable audioserver_mopidy.service

echo 1 > /home/audioserver/user.version
