# speak
speak command and library and server for Python3

## 1. Description
OpenJTalkを利用し、指定した文字列をしゃべるコマンド、Python3ライブラリ(クラス)、および、サーバー

文字列をOpenJTalkで、音声ファイル(wav)に変換してから、再生します。
一度音声ファイルに変換した文字列は、以下のディレトリに保存され蓄積し、次からは変換処理が省略されます。

${HOME}/tmp/Speak_wav/

## 2. Install

### 2.1 Open JTalkのインストール

```bash
$ sudo apt install -y open-jtalk open-jtalk-mecab-naist-jdic hts-voice-nitech-jp-atr503-m001
```

### 2.2 その他のインストール

for speak2.sh install 'expect' command as follows
```bash
$ sudo apt install -y expect
```

## 3. Usage

### 3.1 command line

```bash
$ Speak.py [str]...
```
指定した文字列(str)をしゃべります。strが無い場合は、時刻をしゃべります。


### 3.2 python3 library

```python
#!/usr/bin/env python3

# import this class library
from Speak import Speak

# オブジェクトの作成
s = Speak()

# Example 1
word = 'こんにちは'
s.speak(word)

# Example 2
word_list = ['みなさん', 'こんにちは']
s.speak(word_list)
```

### 3.3 Speakサーバー「SpeakServer.py」… いろいろと(?)効率がよい


```bash
$ SpeakServer.py &
$ speak2.sh こんにちは
$ echo こんにちは | telnet localhost 12349
```
