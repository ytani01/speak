#!/usr/bin/env python3
#
# (c) 2019 Yoichi Tanibayashi
#
import subprocess
import os
import time

import click
from logging import getLogger, StreamHandler, Formatter, DEBUG, INFO, WARN
logger = getLogger(__name__)
logger.setLevel(INFO)
console_handler = StreamHandler()
console_handler.setLevel(DEBUG)
handler_fmt = Formatter(
    '%(asctime)s %(levelname)s %(name)s.%(funcName)s> %(message)s',
    datefmt='%H:%M:%S')
console_handler.setFormatter(handler_fmt)
logger.addHandler(console_handler)
logger.propagate = False


def get_logger(name, debug):
    _log = logger.getChild(name)
    if debug:
        _log.setLevel(DEBUG)
    else:
        _log.setLevel(INFO)
    return _log


HOME_DIR       = os.environ['HOME']
TMP_DIR        = HOME_DIR + '/tmp'
WAV_DIR        = TMP_DIR + '/Speak_wav'
OPEN_JTALK_CMD = 'open_jtalk'
DIC_DIR        = '/var/lib/mecab/dic/open-jtalk/naist-jdic'
VOICE_FILE     = HOME_DIR + '/speak/Voice/mei/mei_normal.htsvoice'
SPEAD          = '1.0'
OPEN_JTALK_CMDLINE = [OPEN_JTALK_CMD,
                      '-x', DIC_DIR,
                      '-r', SPEAD,
                      '-m', VOICE_FILE, '-ow']
PLAY_CMD       = 'aplay'


class Speak:
    def __init__(self, debug=False):
        self.debug = debug
        self.logger = get_logger(__class__.__name__, debug)

        os.makedirs(WAV_DIR, exist_ok=True)

    def isfloat(self, s1):
        self.logger.debug('str=%s', s1)

        try:
            float(s1)
            return True
        except ValueError:
            return False

    def speak(self, word):
        self.logger.debug('word=%s', word)

        if type(word) == str:
            self.logger.debug('word is string')
            self.speak1(word)
        elif type(word) == int:
            self.logger.debug('word is integer')
            self.speak1(str(word))
        elif word[0] == 'sleep' and self.isfloat(word[1]):
            self.logger.debug('Sleep %.1f sec.', float(word[1]))
            time.sleep(float(word[1]))
        else:
            for w in word:
                self.speak1(str(w))

    def word2wavfile(self, word):
        self.logger.debug('word=%s', word)

        wav_file = WAV_DIR + '/' + word + '.wav'
        self.logger.debug('wav_file=%s', wav_file)

        return wav_file

    def speak1(self, word):
        self.logger.debug('word=%s', word)

        wav_file = self.word2wavfile(word)

        if not os.path.isfile(wav_file):
            self.gen_wav(word)

        self.play_wav(word)

    def gen_wav(self, word):
        self.logger.debug('word=%s', word)

        wav_file = self.word2wavfile(word)

        cmdline = OPEN_JTALK_CMDLINE + [wav_file]
        self.logger.debug('cmdline=%s', cmdline)

        ret = subprocess.Popen(cmdline, stdin=subprocess.PIPE)
        ret.stdin.write(word.encode('utf-8'))
        ret.stdin.close()
        ret.wait()

    def play_wav(self, word):
        self.logger.debug('word=%s', word)

        wav_file = self.word2wavfile(word)

        if not os.path.isfile(wav_file):
            self.logger.debug('%s: no such file', wav_file)
            return

        cmdline = [PLAY_CMD, wav_file]
        self.logger.debug('cmdline=%s', cmdline)

        ret = subprocess.run(cmdline)
        if ret.returncode != 0:
            self.logger.error('error:%s', ret)

    def end(self):
        self.logger.debug('')


class Sample:
    def __init__(self, word, debug=False):
        self.debug = debug
        self.logger = get_logger(__class__.__name__, debug)
        self.logger.debug('word=%s', word)

        self.word = word
        self.spk = Speak(debug=debug)

    def main(self):
        self.logger.debug('')

        if self.word != ():
            self.spk.speak(self.word)
        else:
            tm = time.localtime()
            word = '%s月%s日 %s時%s分' % (
                tm.tm_mon, tm.tm_mday, tm.tm_hour, tm.tm_min)
            self.logger.debug('word=%s', word)
            self.spk.speak(word)

    def end(self):
        self.logger.debug('')
        self.spk.end()


CONTEXT_SETTINGS = dict(help_option_names=['-h', '--help'])


@click.command(context_settings=CONTEXT_SETTINGS)
@click.argument('word', type=str, nargs=-1)
@click.option('--debug', '-d', 'debug', is_flag=True, default=False,
              help='debug flag')
def main(word, debug):
    logger = get_logger('', debug)
    logger.debug('word=%s', word)

    obj = Sample(word, debug=debug)
    try:
        obj.main()
    finally:
        logger.debug('finally')
        obj.end()


if __name__ == '__main__':
    main()
