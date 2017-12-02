#!/bin/sh

PATH="/home/pi/bin:${PATH}"

STR0="IPアドレス 検出"
STR1="読み上げます"
STR2="繰り返します"
ERRMSG="IPアドレスを検出できません"

IPSTR=`hostname -I | grep '^[0-9]*\.[0-9]' | sed 's/ .*//'`
echo $IPSTR
if [ "X${IPSTR}" = "X" ]; then
    speak.sh ${ERRMSG}
    exit 1
fi

speak.sh ${STR0}

IPSTR4=${IPSTR}
IPSTR1=`echo ${IPSTR4} | sed 's/\..*$//'`
IPSTR4=`echo ${IPSTR4} | sed 's/^[0-9]*\.//'`
IPSTR2=`echo ${IPSTR4} | sed 's/\..*$//'`
IPSTR4=`echo ${IPSTR4} | sed 's/^[0-9]*\.//'`
IPSTR3=`echo ${IPSTR4} | sed 's/\..*$//'`
IPSTR4=`echo ${IPSTR4} | sed 's/^[0-9]*\.//'`
echo ${IPSTR1} ${IPSTR2} ${IPSTR3} ${IPSTR4}

speak.sh ${STR1}
speak.sh `echo ${IPSTR1} | sed 's/\([0-9]\)/\1 /g'`
speak.sh `echo ${IPSTR2} | sed 's/\([0-9]\)/\1 /g'`
speak.sh `echo ${IPSTR3} | sed 's/\([0-9]\)/\1 /g'`
speak.sh `echo ${IPSTR4} | sed 's/\([0-9]\)/\1 /g'`

if [ X$1 = X ]; then
  exit 0
fi
speak.sh ${STR2}
speak.sh `echo ${IPSTR1} | sed 's/\([0-9]\)/\1 /g'`
speak.sh `echo ${IPSTR2} | sed 's/\([0-9]\)/\1 /g'`
speak.sh `echo ${IPSTR3} | sed 's/\([0-9]\)/\1 /g'`
speak.sh `echo ${IPSTR4} | sed 's/\([0-9]\)/\1 /g'`
exit
