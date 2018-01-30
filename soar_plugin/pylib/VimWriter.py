import vim

class VimWriter:
    DEBUGGER_WIN = 1
    MESSAGES_WIN = 2
    ACTIONS_WIN = 3
    STATE_WIN = 4

    def __init__(self):
        self.win_map = {}
        for window in vim.windows:
            if "debugging" in window.buffer.name:
                self.win_map[VimWriter.DEBUGGER_WIN] = window
            elif "messages" in window.buffer.name:
                self.win_map[VimWriter.MESSAGES_WIN] = window
            elif "actions" in window.buffer.name:
                self.win_map[VimWriter.ACTIONS_WIN] = window
            elif "state" in window.buffer.name:
                self.win_map[VimWriter.STATE_WIN] = window

    def write(self, message, win_num=DEBUGGER_WIN, clear=False):
        window = self.win_map[win_num]
        if clear:
            del window.buffer[:]
        for line in message.split("\n"):
            window.buffer.append(line)
        if win_num == VimWriter.DEBUGGER_WIN:
            window.cursor = (len(window.buffer), 0)

    def get_window(self, win_num):
        return self.win_map[win_num]
