import sys
import vim

from string import digits

from VimWriter import VimWriter

class Message:
    def __init__(self, message, num):
        self.message = message.strip()
        self.num = num

        self.message_id = None
        self.added = False

    def is_added(self):
        return self.added

    def add_to_wm(self, parent_id):
        if self.added:
            self.remove_from_wm()

        self.message_id = parent_id.CreateIdWME("sentence")
        self.message_id.CreateIntWME("sentence-number", self.num)
        self.message_id.CreateStringWME("complete-sentence", self.message)
        self.message_id.CreateStringWME("spelling", "*")

        punct = '.'
        if self.message[-1] in ".!?":
            punct = self.message[-1]
            self.message = self.message[:-1]

        quote = None
        begin_quote = self.message.find('"')
        end_quote = self.message.find('"', begin_quote+1)
        if begin_quote != -1 and end_quote != -1:
            quote = self.message[begin_quote+1:end_quote]
            self.message = self.message[:begin_quote] + "_XXX_" + self.message[end_quote+1:]

        next_id = self.message_id.CreateIdWME("next")
        words = self.message.split()
        for word in words:
            if len(word) == 0:
                continue
            if word == "_XXX_":
                word = quote
                next_id.CreateStringWME("quoted", "true")
            next_id.CreateStringWME("spelling", word.lower())
            next_id = next_id.CreateIdWME("next")
        
        next_id.CreateStringWME("spelling", str(punct))
        next_id.CreateStringWME("next", "nil")
        self.added = True

    def update_wm(self):
        pass

    def remove_from_wm(self):
        if not self.added or self.message_id == None:
            return
        self.message_id.DestroyWME()
        self.message_id = None
        self.added = False

class LanguageConnector:
    def __init__(self, agent):
        self.agent = agent
        self.connected = False
        self.output_handler_ids = { "send-message": -1 }

        self.current_message = None
        self.next_message_id = 1
        self.language_id = None

        if self.agent.config.messages_file != None:
            with open(self.agent.config.messages_file, 'r') as f:
                vim.command("let g:rosie_messages = [\"" + "\",\"".join([ line.rstrip('\n') for line in f.readlines()]) + "\"]")

        self.messages_to_remove = set()

    def connect(self):
        if self.connected:
            return

        for command_name in self.output_handler_ids:
            self.output_handler_ids[command_name] = self.agent.agent.AddOutputHandler(
                    command_name, LanguageConnector.output_event_handler, self)

        self.connected = True

    def disconnect(self):
        if not self.connected:
            return

        for command_name in self.output_handler_ids:
            self.agent.agent.RemoveOutputHandler(self.output_handler_ids[command_name])
            self.output_handler_ids[command_name] = -1

        self.connected = False

    def on_init_soar(self):
        if self.current_message != None:
            self.current_message.remove_from_wm()
        if self.language_id != None:
            self.language_id.DestroyWME()
            self.language_id = None

    def send_message(self, message):
        self.agent.writer.write("Instr: " + message, VimWriter.MESSAGES_WIN)
        if self.current_message != None:
            self.messages_to_remove.add(self.current_message)
        self.current_message = Message(message, self.next_message_id)
        self.next_message_id += 1

    def on_input_phase(self, input_link):
        if self.language_id == None:
            self.language_id = input_link.CreateIdWME("language")

        if self.current_message != None and not self.current_message.is_added():
            self.current_message.add_to_wm(self.language_id)

        for msg in self.messages_to_remove:
            msg.remove_from_wm()
        if len(self.messages_to_remove) > 0:
            self.messages_to_remove = set()

    @staticmethod
    def output_event_handler(self, agent_name, att_name, wme):
        try:
            if wme.IsJustAdded() and wme.IsIdentifier():
                root_id = wme.ConvertToIdentifier()
                self.on_output_event(att_name, root_id)
        except:
            print "ERROR IN OUTPUT EVENT HANDLER"
            print sys.exc_info()

    def on_output_event(self, att_name, root_id):
        self.agent.writer.write("Output Handler Callback: " + att_name)
        if att_name == "send-message":
            self.process_output_link_message(root_id)

    def process_output_link_message(self, root_id):
        if root_id.GetNumberChildren() == 0:
            root_id.CreateStringWME("status", "error")
            self.agent.writer.write("LanguageConnector: Error - message has no children")
            return

        for i in range(root_id.GetNumberChildren()):
            child_wme = root_id.GetChild(i)
            if child_wme.GetAttribute() == "type":
                self.agent.writer.write("Rosie: " + child_wme.GetValueAsString(), VimWriter.MESSAGES_WIN)
                break
        root_id.CreateStringWME("status", "complete")
