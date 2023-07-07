import os
from .targets.file_target import FileTarget
from .actions.send_to_vim_in_tmux_pane_action import SendToVimInTmuxPaneAction
from .actions.action import Action
from .targets.target_payload import EditorOpenable

class VimRemoteOpen(Action):
    def __init__(self, target_payload: EditorOpenable):
        self.target_payload = target_payload

    def perform(self):
        path = self.target_payload.file_path

        if self.target_payload.line_number:
            path += f':{self.target_payload.line_number}'

        os.system(f'nvim --server ~/.cache/nvim/server.pipe --remote {path}')

FileTarget.primary_action = VimRemoteOpen
