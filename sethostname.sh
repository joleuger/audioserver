#!/bin/sh
export AUDIOSERVERHOSTNAME=$1
echo replace AUDIOSERVERHOSTNAME by $AUDIOSERVERHOSTNAME

find ./mysettings -type f -exec sed -i -e 's/AUDIOSERVERHOSTNAME/$AUDIOSERVERHOSTNAME/g' {} \;
