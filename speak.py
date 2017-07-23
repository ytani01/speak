#!/usr/bin/env python3
# -*- coding:utf-8 -*-

import subprocess
import sys
from datetime import datetime

open_jtalk_cmd='open_jtalk'
wav_file='/tmp/open_jtalk.wav'
dic_dir='/var/lib/mecab/dic/open-jtalk/naist-jdic'

voice_file='/home/ytani/open_jtalk/MMDAgent_Example-1.7/Voice/mei/mei_normal.htsvoice'
#voice_file='/home/ytani/open_jtalk/Voices/miku/miku-delta.htsvoice'
#voice_file='/home/ytani/open_jtalk/Voices/なないろニジ_1.0/なないろニジ.htsvoice'
#voice_file='/home/ytani/open_jtalk/Voices/遠藤愛_1.0/遠藤愛.htsvoice'
#voice_file='/home/ytani/open_jtalk/Voices/京歌カオル_1.0/京歌カオル.htsvoice'
#voice_file='/home/ytani/open_jtalk/Voices/沙音ほむ_1.0/沙音ほむ.htsvoice'
#voice_file='/home/ytani/open_jtalk/Voices/想音いくる_1.0/想音いくる.htsvoice'
#voice_file='/home/ytani/open_jtalk/Voices/蒼歌ネロ_1.0/蒼歌ネロ.htsvoice'
#voice_file='/home/ytani/open_jtalk/Voices/桃音モモ_1.0/桃音モモ.htsvoice'
#voice_file='/home/ytani/open_jtalk/Voices/遊音一莉_1.0/遊音一莉.htsvoice'

aplay_cmd='aplay'

def speak(str):
    opt_dic=['-x',dic_dir]
    opt_speed=['-r','1.0']
    opt_htsvoice=['-m', voice_file]
    opt_outwav=['-ow',wav_file]
    cmd=[open_jtalk_cmd]+opt_dic+opt_htsvoice+opt_speed+opt_outwav
    #print(cmd)

    print(str)
    c = subprocess.Popen(cmd,stdin=subprocess.PIPE)
    c.stdin.write(str.encode('utf-8'))
    c.stdin.close()
    c.wait()

    cmd = [aplay_cmd,'-q',wav_file]
    #print(cmd)
    c = subprocess.Popen(cmd)
    c.wait()

def speak_datetime():
    d = datetime.now()
    text = '%s月%s日、%s時%s分%s秒' % (d.month, d.day, d.hour, d.minute, d.second)
    #print(text)
    speak(text)

if __name__ == '__main__':
    argv = sys.argv
    #print(len(argv))
    #print(argv)
    if len(argv) < 2:
        speak_datetime()
        speak('引数に、しゃべる文字列を指定して下さい')
    else:
        argv.pop(0)
        #print(argv)
        for w in argv:
            speak(w)
