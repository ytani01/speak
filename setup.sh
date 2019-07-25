#!/bin/sh -x
#
# (c) 2019 Yoichi Tanibayashi
#

PKGS="open-jtalk open-jtalk-mecab-naist-jdic hts-voice-nitech-jp-atr503-m001 
expect telnet"

sudo apt install -y ${PKGS}
