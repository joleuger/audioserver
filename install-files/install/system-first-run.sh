#!/bin/sh
loginctl enable-linger audioserver
rm -f /settings/firstrun ; rm -f /settings/firstrun.txt
echo 1 > /settings/system.version
