#!/bin/sh
/bin/systemctl --user stop audioserver_to_icecast.service audioserver_to_snapcast.service audioserver_snapcast.service audioserver_mopidy.service

dd if=/run/user/1000/snapfifo iflag=nonblock of=/dev/null

/bin/systemctl --user start audioserver_to_icecast.service audioserver_to_snapcast.service audioserver_snapcast.service audioserver_mopidy.service

#sleep 15
#/usr/bin/python3 /usr/local/bin/control_mopidy_dbus.py

BROADCAST_ON_LAN=$(pactl list short sinks | grep broadcast_on_lan | cut -f1)
pactl set-sink-volume $BROADCAST_ON_LAN 70%

exit 0
