#!/bin/sh
# (c) Yoichi Tanibayashi
#
# Install 'expect' command
#
#    $ sudo apt install -y expect
#

MYNAME=`basename $0`

SPEAK_HOST="localhost"
SPEAK_PORT=12349

TELNET_CMD="telnet ${SPEAK_HOST} ${SPEAK_PORT}"

my_echo () {
    echo "${MYNAME}: $*"
}

MSG=$*
my_echo "\"${MSG}\""

COUNT=0
while [ ${COUNT} -lt 10 ]; do
    expect -c "
set timeout 60
spawn ${TELNET_CMD}
expect {
\"#Ready\" { sleep 1; send \"${MSG}\"}
\"refused\" { exit 1}
}
expect {
\"#OK\" { send \r}
}"
    if [ $? -eq 0 ]; then
        exit 0
    fi

    COUNT=`expr ${COUNT} + 1`
    echo
    my_echo "COUNT=${COUNT}"
    sleep 2
done
