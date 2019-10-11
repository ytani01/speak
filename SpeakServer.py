#!/usr/bin/env python3
#
# (c) 2019 Yoichi Tanibayashi
#
from Speak import Speak
import threading
import queue
import socketserver
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
    l = logger.getChild(name)
    if debug:
        l.setLevel(DEBUG)
    else:
        l.setLevel(INFO)
    return l

#####
DEF_PORT = 12349

#####
class SpeakWorker(threading.Thread):
    def __init__(self, debug=False):
        self.debug = debug
        self.logger = get_logger(__class__.__name__, self.debug)
        self.logger.debug('')

        self.msgq = queue.Queue()
        self.speak = Speak(debug=self.debug)
        self.running = False

        super().__init__(daemon=True)

    def send_msg(self, msg=''):
        self.logger.debug('msg=\'%s\'', msg)

        self.msgq.put(msg)

    def recv_msg(self):
        self.logger.debug('')
        msg = self.msgq.get()
        self.logger.debug('msg=\'%s\'', msg)
        return msg

    def __del__(self):
        self.logger.debug('')
        self.end()

    def end(self):
        self.logger.debug('')
        self.running = False
        while not self.msgq.empty():
            self.recv_msg()
        self.send_msg('')
        self.join()
        
    def run(self):
        self.logger.debug('')

        self.running = True
        while self.running:
            msg = self.recv_msg()
            self.logger.debug('msg=\'%s\'', msg)
            if msg == '':
                continue
            word = msg.split()
            self.logger.debug('word=%s', word)
            self.speak.speak(word)
                 
        self.logger.debug('done')

#####
class SpeakHandler(socketserver.StreamRequestHandler):
    def __init__(self, request, client_address, server):
        self.debug = server.debug
        self.logger = get_logger(__class__.__name__, self.debug)
        self.logger.debug('client_address: %s', client_address)

        return super().__init__(request, client_address, server)

    def setup(self):
        self.logger.debug('')
        return super().setup()

    def net_write(self, msg):
        self.logger.debug('msg=%a', msg)
        try:
            self.wfile.write(msg)
        except:
            pass

    def handle(self):
        self.logger.debug('')

        # Telnet Protocol
        #
        # mode character
        # 0xff IAC
        # 0xfd D0
        # 0x22 LINEMODE
        #self.net_write(b'\xff\xfd\x22')
        self.net_write('#Ready\r\n'.encode('utf-8'))

        flag_continue = True
        while flag_continue:
            try:
                net_data = self.request.recv(512)
            except BaseException as e:
                self.logger.info('BaseException:%s:%s.', type(e), e)
                return
            else:
                self.logger.debug('net_data:%a', net_data)

            try:
                decoded_data = net_data.decode('utf-8')
            except UnicodeDecodeError as e:
                self.logger.warn('%s:%s .. ignored', type(e), e)
                continue
            else:
                self.logger.debug('decoded_data:%a', decoded_data)

            self.net_write('\r\n'.encode('utf-8'))

            data=''
            for ch in decoded_data:
                if ord(ch) >= 0x20:
                    data += ch
            self.logger.debug('data:%a', data)
            self.net_write(('#' + data + '\r\n#OK\r\n').encode('utf-8'))
            if len(data) == 0:
                self.logger.debug('No data ..disconect')
                self.net_write('No data .. disconnect\r\n'.encode('utf-8'))
                break

            self.server.sw.send_msg(data)
            '''
            # Speak
            word = data.split()
            self.logger.debug('work=%s', word)
            self.server.speak.speak(word)
            '''

#####
class SpeakServer(socketserver.TCPServer):
    def __init__(self, port=DEF_PORT, debug=False):
        self.debug = debug
        self.logger = get_logger(__class__.__name__, debug)

        self.port  = port
        self.sw = SpeakWorker(debug=debug)

        try:
            super().__init__(('', self.port), SpeakHandler)
        except:
            return None

    def serve_forever(self):
        self.logger.debug('')
        self.sw.start()
        time.sleep(1)
        super().serve_forever()

    def end(self):
        self.logger.debug('')
        self.sw.end()

    def __del__(self):
        self.logger.debug('')
        self.end()
        
#####
class Sample:
    def __init__(self, port, debug=False):
        self.debug = debug
        self.logger = get_logger(__class__.__name__, debug)
        self.logger.debug('port=%d', port)

        self.port   = port
        self.server = SpeakServer(self.port, debug=debug)

    def main(self):
        self.logger.debug('start server')
        self.server.serve_forever()

    def end(self):
        self.logger.debug('')
        self.server.end()
        self.logger.debug('done')
        
        
#####
CONTEXT_SETTINGS = dict(help_option_names=['-h', '--help'])
@click.command(context_settings=CONTEXT_SETTINGS)
@click.argument('port', type=int, default=DEF_PORT)
@click.option('--debug', '-d', 'debug', is_flag=True, default=False,
              help='debug flag')
def main(port, debug):
    logger = get_logger('', debug)
    logger.debug('port=%d', port)

    obj = Sample(port, debug=debug)
    try:
        obj.main()
    finally:
        logger.debug('finally')
        obj.end()

if __name__ == '__main__':
    main()
