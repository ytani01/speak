# speak
speak command and library and server for Python3

## 1. Description
OpenJTalkを利用し、指定した文字列をしゃべるコマンド、Python3ライブラリ(クラス)、および、サーバー

文字列をOpenJTalkで、音声ファイル(wav)に変換してから、再生します。
一度音声ファイルに変換した文字列は、以下のディレトリに蓄積し、次からは変換処理が省略されます。

${HOME}/tmp/Speak_wav/

## 2. Install

```bash
$ cd ~
~ $ python3 -m venv env1
~ $ cd ~/env1
~/env1 $ . ./bin/activate
(env1)~/env1 $ git clone https://www.github.com/ytani01/speak.git
(env1)~/env1 $ cd speak
(env1)~/env1/speak $ ./setup.sh
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

# まずは、Speakオブジェクトを作成
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
# サーバー起動
$ SpeakServer.py &

# Example 1
$ speak2.sh こんにちは

# Example 2 (telnetコマンド使用)
$ echo こんにちは | telnet localhost 12349
```
