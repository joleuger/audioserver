#!/bin/sh
export MACHINE_HOSTNAME=$1
echo replace MACHINE_HOSTNAME by $MACHINE_HOSTNAME

find ./mysettings -type f -exec sed -i -e 's/MACHINE_HOSTNAME/$MACHINE_HOSTNAME/g' {} \;
