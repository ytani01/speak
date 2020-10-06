#!/bin/sh -x
#
# (c) 2019 Yoichi Tanibayashi
#
MYNAME=`basename $0`
MYDIR=`dirname $0`

cd $MYDIR
TOPDIR=`pwd`

SPEAKDIR="${TOPDIR}"

BINDIR="${HOME}/bin"
CMDS="Speak.py SpeakClient.py SpeakServer.py speakipaddr2.sh wait_button.sh"

PKGS="open-jtalk open-jtalk-mecab-naist-jdic hts-voice-nitech-jp-atr503-m001 
expect telnet"

### install packages
sudo apt install -y ${PKGS}

### check python venv
if [ -z "${VIRTUAL_ENV}" ]; then
    echo "Please activate python venv and execute again"
    exit 1
fi

### update pip
pip install -U pip
hash -r

### install python packages
pip install -r requirements.txt

### install CMDS
if [ ! -d ${BINDIR} ]; then
	mkdir ${BINDIR}
fi

cd ${BINDIR}
for f in ${CMDS}; do
	ln -sfv ${TOPDIR}/$f .
done

### make symbolic link to `speak` dir
cd $HOME
ln -sfv ${SPEAKDIR} .
