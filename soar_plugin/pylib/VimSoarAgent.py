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
    def __init__(self, writer, config_filename=None):
        SoarAgent.__init__(self, config_filename=config_filename, 
                print_handler = lambda message: writer.write(message, VimWriter.DEBUGGER_WIN),
                spawn_debugger=False, write_to_stdout=True)

        if self.messages_file != None:
            with open(self.messages_file, 'r') as f:
                vim.command("let g:rosie_messages = [\"" + "\",\"".join([ line.rstrip('\n') for line in f.readlines()]) + "\"]")

        self.connectors["language"] = VimLanguageConnector(self, writer)
        self.connectors["language"].register_message_callback(lambda message: writer.write(message, VimWriter.MESSAGES_WIN))

        self.connectors["action_stack"] = ActionStackConnector(self, writer)

