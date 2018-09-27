#!/bin/sh

PATH="/home/pi/bin:${PATH}"

SPEAK_CMD="speak.py"

MSG0="IPアドレス 検出"
MSG1="読み上げます"
MSG2="繰り返します"
MSG_ERR="IPアドレスを検出できません"
MSG_INTR="読上げを中断します"

#####
speak () {
    for s in $*; do
	s2=`echo $s | sed 's/\([0-9]\)/\1 /g'`
	${SPEAK_CMD} "$s2"
	if [ `gpio -g read 17` -eq 0 ]; then
	    echo "!"
	    ${SPEAK_CMD} ${MSG_INTR}
	    exit 0
	fi
    done
}

##### main

IPSTR=`hostname -I | grep '^[0-9]*\.[0-9]' | sed 's/ .*//'`
echo ${IPSTR}
if [ "X${IPSTR}" = "X" ]; then
    speak.sh ${MSG_ERR}
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
