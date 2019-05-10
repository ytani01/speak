#!/bin/sh
# (c) 2018 Yoichi Tanibayashi

PATH="/home/pi/bin:${PATH}:."

STOP_FILE=${HOME}/BUTTON_INPUT
#GPIO_PIN="13 17"
GPIO_PIN="21"
WAIT_BUTTON_CMD="wait_button.sh"

#SPEAK_CMD="speak.py"
SPEAK_CMD="Speak.py"

MSG0="IPアドレス 検出しました"
MSG1="読み上げます"
MSG2="繰り返します"
MSG_ERR="IPアドレスを検出できません"
MSG_YES="はい"
MSG_INTR="おしゃべりをやめます"

#####
speak () {
    for s in $*; do
	if [ -e ${STOP_FILE} ]; then
	    echo "!"
	    ${SPEAK_CMD} ${MSG_YES}
	    rm -f ${STOP_FILE}
	    ${SPEAK_CMD} ${MSG_INTR}
	    exit 0
	fi
	s2=`echo $s | sed 's/\([0-9]\)/\1 /g'`
	${SPEAK_CMD} "$s2"
    done
}

exit_ () {
    pkill ${WAIT_BUTTON_CMD}
    rm -f ${STOP_FILE}
    exit $1
}

##### main
${WAIT_BUTTON_CMD} ${STOP_FILE} ${GPIO_PIN} &

IPSTR=`hostname -I | grep '^[0-9]*\.[0-9]' | sed 's/ .*//'`
echo ${IPSTR}
if [ "X${IPSTR}" = "X" ]; then
    ${SPEAK_CMD} ${MSG_ERR}
    exit_ 1
fi

speak ${MSG0}

IPSTR2=`echo ${IPSTR} | sed 's/\./てん /g'`
echo ${IPSTR2}

speak ${MSG1}
speak ${IPSTR2}

if [ X$1 = X ]; then
    exit_ 0
fi

speak ${MSG2}
speak ${IPSTR2}

exit_ 0
