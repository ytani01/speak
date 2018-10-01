#!/bin/sh
# -*- coding: utf-8 -*-
# 日本語

PATH="/home/pi/bin:${PATH}"

STOP_FILE=${HOME}/BUTTON_INPUT
GPIO_PIN="13 17"
WAIT_BUTTON_CMD="wait_button.sh"

SPEAK_CMD="speak.py"

MSG_YES="はい"
MSG_INTR="おしゃべりをやめます"

#####
speak () {
    for s in $*; do
	if [ -e ${STOP_FILE} ]; then
	    echo "!"
	    ${SPEAK_CMD} ${MSG_YES}
	    rm ${STOP_FILE}
	    ${SPEAK_CMD} ${MSG_INTR}
	    exit 0
	fi
	s2=`echo $s | sed 's/\([0-9]\)/\1 /g'`
	${SPEAK_CMD} "$s2"
    done
}

##### main
${WAIT_BUTTON_CMD} ${STOP_FILE} ${GPIO_PIN} &

speak "こんにちは IPアドレスをチェックします"

pkill ${WAIT_BUTTON_CMD}

while true; do
    IPSTR=`hostname -I | grep '^[0-9]*\.[0-9]' | sed 's/ .*//'`
    if [ "X${IPSTR}" != "X" ]; then
        break
    fi
    speakipaddr.sh
    sleep 1
done
exec speakipaddr.sh repeat
