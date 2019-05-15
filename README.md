# speak
speak command and library and server for Python3

## 1. Description
OpenJTalkを利用し、指定した文字列をしゃべるコマンドおよびPython3ライブラリ(クラス)、およびサーバー

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
$ speak.py [str]
```
指定した文字列(str)をしゃべります。strが無い場合は、時刻をしゃべります。

### 3.2 python3 library

```python
#!/usr/bin/env python3

# import this class library
import speak

# Example 1
speak.speak('こんにちは')

# Example 2
str = 'こんにちは'
speak.speak(str)
```

### 3.3 SpeakServer.py

```bash
$ SpeakServer.py &
$ speak2.sh こんにちは
$ echo こんにちは | telnet localhost 12349
```
