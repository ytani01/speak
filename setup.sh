#!/bin/sh -x
#
# (c) 2019 Yoichi Tanibayashi
#

TOPDIR="${HOME}/speak"
BINDIR="${HOME}/bin"
CMDS="Speak.py SpeakClient.py SpeakServer.py speakipaddr2.sh wait_button.sh"

PKGS="open-jtalk open-jtalk-mecab-naist-jdic hts-voice-nitech-jp-atr503-m001 
expect telnet"

sudo apt install -y ${PKGS}

if [ ! -d ${BINDIR} ]; then
	mkdir ${BINDIR}
fi

cd ${BINDIR}
for f in ${CMDS}; do
	ln -s ${TOPDIR}/$f .
done
