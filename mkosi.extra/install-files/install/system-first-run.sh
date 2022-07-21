#!/bin/sh
systemctl disable --now shairport-sync
systemctl stop shairport-sync

loginctl enable-linger audioserver
echo 1 > /settings/system.version
