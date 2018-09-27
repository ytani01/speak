#!/bin/sh

PATH="/home/pi/bin:${PATH}"

GPIO_PIN=17

SPEAK_CMD="speak.py"

MSG0="IPアドレス 検出"
MSG1="読み上げます"
MSG2="繰り返します"
MSG_ERR="IPアドレスを検出できません"
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
gpio -g mode ${GPIO_PIN} input

IPSTR=`hostname -I | grep '^[0-9]*\.[0-9]' | sed 's/ .*//'`
echo ${IPSTR}
if [ "X${IPSTR}" = "X" ]; then
    ${SPEAK_CMD} ${MSG_ERR}
    exit 1
fi

speak ${MSG0}

IPSTR2=`echo ${IPSTR} | sed 's/\./ てん /g'`
echo ${IPSTR2}

speak ${MSG1}
speak ${IPSTR2}

if [ X$1 = X ]; then
    exit 0
fi

speak ${MSG2}
speak ${IPSTR2}

exit 0
