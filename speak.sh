#!/bin/sh
#
# $Id: speek.sh,v 1.2 2017/05/23 09:31:49 ytani Exp ytani $
#

TMPDIR=/tmp
TMPWAV=${TMPDIR}/.voice.wav

STAT_FILE=/proc/asound/card0/pcm0p/sub0/status
HTS_DIR=/home/ytani/open_jtalk/MMDAgent_Example-1.7/Voice
DICDIR="/var/lib/mecab/dic/open-jtalk/naist-jdic"


OPTS="-s 48000"
OPTS=""
HTS_VOICE="${HTS_DIR}/mei/mei_normal.htsvoice"
#HTS_VOICE="${HTS_DIR}/mei/mei_angry.htsvoice"
#HTS_VOICE="${HTS_DIR}/mei/mei_bashful.htsvoice"
#HTS_VOICE="${HTS_DIR}/mei/mei_happy.htsvoice"
#HTS_VOICE="${HTS_DIR}/mei/mei_sad.htsvoice"

while [ -f ${TMPWAV} ]; do
    rm -f ${TMPWAV}
done
echo $* | open_jtalk ${OPTS} -m ${HTS_VOICE} -x ${DICDIR} -ow ${TMPWAV}

while [ "X`fuser /dev/snd/pcmC* 2>&1`" != "X" ]; do
#    echo -n '!'
    pulseaudio -k
done
while [ "`head -1 ${STAT_FILE}`" != "closed" ]; do
#    echo -n '.'
    sleep 1
done
aplay --quiet ${TMPWAV}
rm -f ${TMPWAV}
