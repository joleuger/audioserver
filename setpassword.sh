#!/bin/sh
export AUDIOSERVERPASSWORD=$1
echo replace AUDIOSERVERPASSWORD by $AUDIOSERVERPASSWORD

find ./mysettings -type f -exec sed -i -e 's/AUDIOSERVERPASSWORD/$AUDIOSERVERPASSWORD/g' {} \;
