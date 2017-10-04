#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Basic usage example of the nesctrl module
"""
from __future__ import print_function, division
import nesctrl
import sys
nesctrl.setup(22, 17, 4)

DEBUG = sys.flags.debug or False
def debug(*args):
    '''funciona como print, mas só é executada se sys.flags.debug == 1'''
    if not DEBUG:
        return ;
    print(*args)


import socket
import sys

sock = socket.socket(socket.AF_INET, socket.SOCK_DGRAM) # UDP

# Connect the socket to the port where the server is listening
server_address = ('192.168.0.3', 5001)
print('OK!')
state = nesctrl.read_controller_state()
try:

    while 1:
        newState = nesctrl.read_controller_state()
        for x in newState:
            if newState[x] != state[x]:
                debug("changed x:", x)
                sendMsg = x
                if state[x]:
                    sendMsg = sendMsg.lower()
                debug("sendMsg:", sendMsg)
                sock.sendto((sendMsg+'0').encode('utf-8'), server_address)
                state[x] = newState[x]
except KeyboardInterrupt:
    pass

nesctrl.cleanup()