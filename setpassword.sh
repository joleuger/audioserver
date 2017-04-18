#!/bin/sh
export MACHINE_PASSWORD=$1
echo replace MACHINE_PASSWORD by $MACHINE_PASSWORD

find ./mysettings -type f -exec sed -i -e 's/MACHINE_PASSWORD/$MACHINE_PASSWORD/g' {} \;
