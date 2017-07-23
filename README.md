# speak
speak command and library for Python3

## Description
OpenJTalkを利用し、指定した文字列をしゃべるコマンドおよびPython3ライブラリ(クラス)。

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
