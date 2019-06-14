import traceback

import BigWorld
import game
from gui.shared import g_eventBus
from predefined_hosts import g_preDefinedHosts
from gui.Scaleform.daapi.view.meta.LobbyHeaderMeta import LobbyHeaderMeta
from helpers import dependency
from skeletons.connection_mgr import IConnectionManager

from xfw import *
from xfw_actionscript.python import *

from xvm_main.python.consts import *
from xvm_main.python.logger import *
from xvm_main.python.config import config_data, get

import random
import time
import sys

from overrider import Overrider

o = Overrider()

def override_values(e=None):
    o.override_values()

def start():
    g_eventBus.addListener(XVM_EVENT.RELOAD_CONFIG, override_values)
    g_eventBus.addListener(XVM_EVENT.CONFIG_LOADED, o.override_values)
    # g_eventBus.addListener(XFW_COMMAND.XFW_CMD, on_xfw_command)
    o.override_values()

BigWorld.callback(0, start)

@registerEvent(game, 'fini')
def fini():
    g_eventBus.removeListener(XVM_EVENT.RELOAD_CONFIG, override_values)
    g_eventBus.removeListener(XVM_EVENT.CONFIG_LOADED, o.override_values)
    # g_eventBus.removeListener(XFW_COMMAND.XFW_CMD, on_xfw_command)

def on_xfw_command(cmd, *args):
    print "===> on_xfw_command, cmd = '{}'".format(cmd)
    return (None, True)
