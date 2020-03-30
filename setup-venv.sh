#!/bin/sh
#
# (c) 2019 Yoichi Tanibayashi
#
MYNAME=`basename $0`
MYDIR=`dirname $0`

CMDS="Speak.py SpeakClient.py SpeakServer.py speakipaddr2.sh wait_button.sh"

PKGS="open-jtalk open-jtalk-mecab-naist-jdic hts-voice-nitech-jp-atr503-m001 
expect telnet"

#
# init
#
cd ${MYDIR}
BASEDIR=`pwd`
echo "BASEDIR=${BASEDIR}"

cd ..
ENVDIR=`pwd`
if [ ! -f bin/activate ]; then
    echo "${ENVDIR}: invalid venv directory"
    exit 1
fi
echo "ENVDIR=${ENVDIR}"

BINDIR="${ENVDIR}/bin"
echo "BINDIR=${BINDIR}"

#
# main
#

#
# activate Python venv
#
echo "* activate venv"
. ${BINDIR}/activate

#
# install packages
#
echo "* install packages"
sudo apt install -y ${PKGS}

#
# make symbolic links
#
echo "* make symbolic links in ${BINDIR}"
cd ${BINDIR}
for f in ${CMDS}; do
    ln -sfv ${BASEDIR}/$f .
done
