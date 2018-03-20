import vim

class VimWriter:
    DEBUGGER_WIN = 1
    MESSAGES_WIN = 2
    ACTIONS_WIN = 3
    STATE_WIN = 4

    window_names = { 
        DEBUGGER_WIN: "_DEBUGGING_WIN_",
        MESSAGES_WIN: "_MESSAGES_WIN_",
        ACTIONS_WIN: "_ACTIONS_WIN_",
        STATE_WIN: "_STATES_WIN_"
    }


    def __init__(self):
        self.win_map = {}
        for window in vim.windows:
            for win_id, win_name in VimWriter.window_names.iteritems():
                if win_name in window.buffer.name:
                    self.win_map[win_id] = window
                    break

    def clear_all_windows(self):
        for window in vim.windows:
            for name in VimWriter.window_names.values():
                if name in window.buffer.name:
                    del window.buffer[:]
                    break

    def write(self, message, win_num=DEBUGGER_WIN, clear=False):
        window = self.win_map[win_num]
        if clear:
            del window.buffer[:]
        for line in message.split("\n"):
            window.buffer.append(line)
        if win_num != VimWriter.STATE_WIN:
            window.cursor = (len(window.buffer), 0)
            if win_num != VimWriter.DEBUGGER_WIN:
                prev_win = vim.current.window
                vim.current.window = window
                vim.command("redraw!")
                vim.current.window = prev_win

    def get_window(self, win_num):
        return self.win_map[win_num]

