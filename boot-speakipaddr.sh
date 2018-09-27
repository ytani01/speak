#!/bin/sh
# -*- coding: utf-8 -*-
# 日本語

PATH="/home/pi/bin:${PATH}"

GPIO_PIN=17

SPEAK_CMD="speak.py"

MSG_INTR="おしゃべりをやめます"

#####
speak () {
    for s in $*; do
	if [ `gpio -g read ${GPIO_PIN}` -eq 0 ]; then
	    echo "!"
	    ${SPEAK_CMD} ${MSG_INTR}
	    exit 0
	fi
	s2=`echo $s | sed 's/\([0-9]\)/\1 /g'`
	${SPEAK_CMD} "$s2"
    done
}

##### main
gpio -g mode 17 input

speak "こんにちは IPアドレスをチェックします"
speak "　"

while true; do
    IPSTR=`hostname -I | grep '^[0-9]*\.[0-9]' | sed 's/ .*//'`
    if [ "X${IPSTR}" != "X" ]; then
        break
    fi
    speakipaddr.sh
    sleep 1
done
exec speakipaddr.sh repeat
