#!/bin/sh
system_version=$(cat /settings/system.version)
case $system_version in
    1)
        echo 'Latest version of system settings. No update required'
        ;;
    *)
        echo 'Unknown version of system settings. No update performed'
esac
