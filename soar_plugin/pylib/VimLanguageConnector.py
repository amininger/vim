import sys
import vim

from string import digits

from pysoarlib import LanguageConnector
from VimWriter import VimWriter

class VimLanguageConnector(LanguageConnector):
    def __init__(self, agent, vim_writer):
        LanguageConnector.__init__(self, agent, lambda message: vim_writer.write(message, VimWriter.DEBUGGER_WIN))

        self.rosie_message_callback = lambda message: vim_writer.write(message, VimWriter.MESSAGES_WIN)
