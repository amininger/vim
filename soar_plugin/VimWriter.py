import vim

class VimWriter:
    MAIN_PANE = 1
    SIDE_PANE_TOP = 2
    SIDE_PANE_MID = 3
    SIDE_PANE_BOT = 4

    window_names = { 
        MAIN_PANE: "__MAIN_PANE__",
        SIDE_PANE_TOP: "__SIDE_PANE_TOP__",
        SIDE_PANE_MID: "__SIDE_PANE_MID__",
        SIDE_PANE_BOT: "__SIDE_PANE_BOT__"
    }

    def __init__(self):
        self.win_map = {}
        for window in vim.windows:
            for win_id, win_name in VimWriter.window_names.items():
                if win_name in window.buffer.name:
                    self.win_map[win_id] = window
                    break

    def clear_all_windows(self):
        for window in vim.windows:
            for name in VimWriter.window_names.values():
                if name in window.buffer.name:
                    del window.buffer[:]
                    break

    def write(self, message, win_num=MAIN_PANE, clear=False, scroll=True):
        window = self.win_map[win_num]
        if clear:
            del window.buffer[:]
        for line in message.split("\n"):
            window.buffer.append(line)
        if scroll:
            window.cursor = (len(window.buffer), 0)
        if win_num != VimWriter.MAIN_PANE:
            prev_win = vim.current.window
            vim.current.window = window
            vim.command("redraw!")
            vim.current.window = prev_win

    def get_window(self, win_num):
        return self.win_map[win_num]

