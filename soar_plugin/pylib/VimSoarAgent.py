import sys
import vim

from threading import Thread
import time

import Python_sml_ClientInterface as sml

from pysoarlib import SoarAgent

from VimLanguageConnector import VimLanguageConnector
from ActionStackConnector import ActionStackConnector
from VimWriter import VimWriter


current_time_ms = lambda: int(round(time.time() * 1000))

class VimSoarAgent(SoarAgent):
    def __init__(self, config_file, writer):
        SoarAgent.__init__(self, config_file, lambda message: writer.write(message, VimWriter.DEBUGGER_WIN))

        if self.config.messages_file != None:
            with open(self.config.messages_file, 'r') as f:
                vim.command("let g:rosie_messages = [\"" + "\",\"".join([ line.rstrip('\n') for line in f.readlines()]) + "\"]")

        self.connectors["language"] = VimLanguageConnector(self, writer)
        self.connectors["language"].register_message_callback(lambda message: writer.write(message, VimWriter.MESSAGES_WIN))

        self.connectors["action_stack"] = ActionStackConnector(self, writer)

