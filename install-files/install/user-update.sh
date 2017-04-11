#!/bin/sh
user_version=$(cat /settings/user.version)
case $system_version in
    1)
        echo 'Latest version of user settings. No update required'
        ;;
    *)
        echo 'Unknown version of user settings. No update performed'
esac
