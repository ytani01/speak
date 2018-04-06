#!/bin/sh
# -*- coding: utf-8 -*-
# 日本語

PATH="/home/pi/bin:${PATH}"

speak.sh こんにちは
speak.sh IPアドレスをチェックします。

while true; do
    IPSTR=`hostname -I | grep '^[0-9]*\.[0-9]' | sed 's/ .*//'`
    if [ "X${IPSTR}" != "X" ]; then
        break
    fi
    speakipaddr.sh
    sleep 1
done
exec speakipaddr.sh repeat
