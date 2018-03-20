if !has('python')
	finish
endif

function! LaunchSoarAgent()
	call inputsave()
	let config_file = input('Enter config file: ', "", "file")
	echo config_file
	call inputrestore()
	call SetupDebuggerPanes()
	call SetupAgentMethods(config_file)
	python agent = create_agent()
	python agent.connect()
endfunction

function! LaunchRosieAgent()
	call inputsave()
	let agent_name = input('Enter config file: ', 'aaai18eval')
	let config_file = $ROSIE_HOME."/test-agents/".agent_name."/agent/rosie.".agent_name.".config"
	echo config_file
	call inputrestore()
	call SetupDebuggerPanes()
	call SetupAgentMethods(config_file)
	python agent = create_agent()
	python agent.connect()
endfunction

function! LaunchRosieThorAgent()
	call inputsave()
	let agent_name = input('Enter config file: ', 'ai2thor')
	let config_file = $ROSIE_HOME."/test-agents/".agent_name."/agent/rosie.".agent_name.".config"
	echo config_file
	call inputrestore()
	call SetupDebuggerPanes()
	call SetupAgentMethods(config_file)
	python agent = create_agent()
	call LaunchAi2ThorSimulator()
	python agent.connect()
endfunction

function! SetupDebuggerPanes()
	exec "e _DEBUGGING_WIN_"
	exec "setlocal buftype=nofile"
	exec "setlocal bufhidden=hide"
	exec "setlocal noswapfile"
	call feedkeys("ggVGd")
	exec "vs"
	exec "wincmd l"
	exec "e _MESSAGES_WIN_"
	exec "setlocal buftype=nofile"
	exec "setlocal bufhidden=hide"
	exec "setlocal noswapfile"
	exec "sp"
	exec "wincmd j"
	exec "e _ACTIONS_WIN_"
	exec "setlocal buftype=nofile"
	exec "setlocal bufhidden=hide"
	exec "setlocal noswapfile"
	exec "sp"
	exec "wincmd j"
	exec "e _STATES_WIN_"
	exec "setlocal buftype=nofile"
	exec "setlocal bufhidden=hide"
	exec "setlocal noswapfile"
	exec "wincmd h"

python << EOF

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

EOF
endfunction

function! SetupAgentMethods(config_file)
	let file_name = a:config_file

python << EOF
import sys
import os

from VimSoarAgent import VimSoarAgent
from VimWriter import VimWriter

import vim

writer = VimWriter()
config_filename = vim.eval("file_name")

def create_agent():
	return VimSoarAgent(config_filename, writer)

def step(num):
	agent.agent.RunSelf(num)

def startstop():
	if agent.is_running:
		agent.stop()
	else:
		agent.start()

def send_message(msg):
	if len(msg.strip()) > 0:
		writer.write("Instr: " + msg, VimWriter.MESSAGES_WIN)
		agent.connectors["language"].send_message(msg)

def reset_agent():
	writer.clear_all_windows()
	agent.reset()

def close_debugger():
	agent.kill()
	while len(vim.windows) > 1:
		vim.command("q!")
	vim.command("e! temp")

resize_windows()
EOF

endfunction

function! LaunchAi2ThorSimulator()
python << EOF

from rosiethor import Ai2ThorSimulator, PerceptionConnector, ActuationConnector

simulator = Ai2ThorSimulator()

agent.connectors["perception"] = PerceptionConnector(agent, simulator)
agent.connectors["perception"].print_handler = lambda message: writer.write(message)
agent.connectors["actuation"] = ActuationConnector(agent, simulator)
agent.connectors["actuation"].print_handler = lambda message: writer.write(message)

simulator.start()

EOF
endfunction

function! ResetAgent()
	python 

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

function! ControlAi2ThorRobot()
	let key = getchar()
	"Loop until either ESC or X is pressed
	while key != 27 && key != 120
		if key == 119 "W
			python if simulator: simulator.exec_simple_command("MoveAhead")
		elseif key == 97 "A
			python if simulator: simulator.exec_simple_command("MoveLeft")
		elseif key == 115 "S
			python if simulator: simulator.exec_simple_command("MoveBack")
		elseif key == 100 "D
			python if simulator: simulator.exec_simple_command("MoveRight")
		elseif key == 113 "Q
			python if simulator: simulator.exec_simple_command("RotateLeft")
		elseif key == 101 "E
			python if simulator: simulator.exec_simple_command("RotateRight")
		elseif key == 114 "R
			python if simulator: simulator.exec_simple_command("LookUp")
		elseif key == 102 "F
			python if simulator: simulator.exec_simple_command("LookDown")
		endif
		let key = getchar()
	endwhile
endfunction

function! SaveSimulatorState()
	python if simulator: simulator.save()
endfunction


