#!/bin/sh

PATH="/home/pi/bin:${PATH}"

while true; do
    IPSTR=`hostname -I | grep '^[0-9]*\.[0-9]' | sed 's/ .*//'`
    if [ "X${IPSTR}" != "X" ]; then
        break
    fi
    speakipaddr.sh
    sleep 1
done
exec speakipaddr.sh repeat
