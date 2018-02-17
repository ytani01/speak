# speak
speak command and library for Python3

## Description
OpenJTalkを利用し、指定した文字列をしゃべるコマンドおよびPython3ライブラリ(クラス)。

## Open JTalkのインストール

```bash
$ sudo apt -y install open-jtalk open-jtalk-mecab-naist-jdic hts-voice-nitech-jp-atr503-m001
```

## Usage (command line)

```bash
$ speak.py [str]
```
指定した文字列(str)をしゃべります。strが無い場合は、時刻をしゃべります。

## Usage (python3 library)

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
