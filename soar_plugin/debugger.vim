if !has('python')
	finish
endif

function! LaunchSoarAgent()
	call inputsave()
	let config_file = input('Enter config file: ', "", "file")
	echo config_file
	call inputrestore()
	call SetupDebuggerPanes()
	call LaunchSoarAgentFromConfig(config_file)
endfunction

function! LaunchRosieAgent()
	call inputsave()
	let agent_name = input('Enter config file: ', 'aaai18eval')
	let config_file = $ROSIE_HOME."/test-agents/".agent_name."/agent/rosie.".agent_name.".config"
	echo config_file
	call inputrestore()
	call SetupDebuggerPanes()
	call LaunchSoarAgentFromConfig(config_file)
endfunction

function! SetupDebuggerPanes()
	exec "e debugging.soar"
	call feedkeys("ggVGd")
	exec "vs"
	exec "wincmd l"
	exec "e messages"
	exec "sp"
	exec "wincmd j"
	exec "e actions"
	exec "sp"
	exec "wincmd j"
	exec "e states"
	exec "wincmd h"
endfunction

function! LaunchSoarAgentFromConfig(config_file)
	let file_name = a:config_file

python << EOF
import sys
import os

print os.environ["PYTHONPATH"]

from SoarAgent import AgentConfig
from SoarAgent import SoarAgent
from VimWriter import VimWriter

import vim

writer = VimWriter()
config = AgentConfig(vim.eval("file_name"))
agent = SoarAgent(config, writer)

def step(num):
	agent.agent.RunSelf(num)

def startstop():
	if agent.is_running:
		agent.stop()
	else:
		agent.start()

def send_message(msg):
    if len(msg.strip()) > 0:
	    agent.language_connector.send_message(msg)

def resize_windows():
	vim.current.window = writer.get_window(VimWriter.DEBUGGER_WIN)
	vim.command("let cur_winh = winheight(0)")
	height = int(vim.eval("cur_winh"))

	vim.command("let cur_winw1 = winwidth(0)")
	width = int(vim.eval("cur_winw1"))

	vim.current.window = writer.get_window(VimWriter.MESSAGES_WIN)
	vim.command("let cur_winw2 = winwidth(0)")
	width += int(vim.eval("cur_winw2"))

	vim.command("resize " + str(int(height/3)))
	vim.command("vertical resize " + str(int(width/3)))

	vim.current.window = writer.get_window(VimWriter.ACTIONS_WIN)
	vim.command("resize " + str(int(height/3)))

	vim.current.window = writer.get_window(VimWriter.DEBUGGER_WIN)

def kill_agent():
	agent.kill()
	while len(vim.windows) > 1:
		vim.command("q!")
	vim.command("e! temp")

resize_windows()
EOF

endfunction


function! ExecuteUserSoarCommand()
	call inputsave()
	let cmd = input('Enter command: ')
	call inputrestore()
	python agent.execute_command(vim.eval("cmd"))
endfunction

function! SourceSoarFile()
	call inputsave()
	let filename = input('Enter soar file name: ', "", "file")
	call inputrestore()
	call ExecuteSoarCommand("source ".filename)
endfunction

function! ListRosieMessages(A,L,P)
	if !exists("g:rosie_messages")
		let msgs = []
	else
		let msgs = g:rosie_messages
	endif

	let res = []
	let pattern = "^".a:A
	for msg in msgs
		if msg =~ pattern
			call add(res, msg)
		endif
	endfor
	return res
endfunction


function! SendMessageToRosie()
	call inputsave()
	let msg = input('Enter message: ', "", "customlist,ListRosieMessages")
	call inputrestore()
	python send_message(vim.eval("msg"))
endfunction

function! ExecuteSoarCommand(cmd)
	python agent.execute_command(vim.eval("a:cmd"))
endfunction

