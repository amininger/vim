" My custom vim configuration settings
" Assumes the environment variable $MY_VIM_DIR is set to this directory
"
let &runtimepath.=','.$MY_VIM_DIR

" Turn on terminal colors
set term=xterm-256color

" Enable file-specific syntax highlighting
syntax on

" ############ PYTHON ##############
" Make sure python is installed (either python2 or python3)
"
if has('python')
	command! -nargs=1 Python python <args>
elseif has('python3')
	command! -nargs=1 Python python3 <args>
else
	echo 'Error: python not installed'
endif

" ######### VUNDLE PLUGINS ########
"
set nocompatible
filetype off

set rtp+=$MY_VIM_DIR/bundle/Vundle.vim
call vundle#begin()

" Vundle - plugin manager
Plugin 'VundleVim/Vundle.vim'

" vim-tmux-navgiator - allows seamless combination of tmux and vim panes
Plugin 'christoomey/vim-tmux-navigator'

" vim-soar-plugin - soar editor and debugger plugin
Plugin 'amininger/vim-soar-plugin'

" vim-instant-markdown - opens live browser preview when editing markdown
Plugin 'suan/vim-instant-markdown'

" fzf - integrates fzf into vim, quickly finding files through fuzzy search
Plugin 'junegunn/fzf'

" lightline - does a nice looking footer at the bottom of the window
Plugin 'itchyny/lightline.vim'

" vim-surround - utility to change 'surroundings' (parents, brackets, quotes)
"    add: ys[text_obj][sym], change: cs[old_sym][new_sym], delete: ds[sym]
"    where sym can be ' " ( ) [ ]
Plugin 'tpope/vim-surround'

" vim-todo-list - plugin to allow creating/editing todo lists
Plugin 'aserebryakov/vim-todo-lists'

call vundle#end()

filetype plugin indent on

" ######### VIM-INSTANT-MARKDOWN SETTINGS ###########

au BufRead,BufNewFile *.md set filetype=markdown

"command! -nargs=0 NoMarkdown let g:instant_markdown_autostart = 0


" ######### LIGHTLINE SETTINGS ############

set laststatus=2 " Forces status line on single page vim instances
set noshowmode   " Redundant status is included with lightline, don't need the default


" ####### TABBING ######
set tabstop=4
set softtabstop=4
set shiftwidth=4
set smarttab
set autoindent
set backspace=indent,eol,start


" ############ NAVIGATION ##############

" newrw navigation settings
"so $MY_VIM_DIR/netrw_extensions.vim
let g:netrw_liststyle=3
let g:netrw_fastbrowse=0

" Don't scroll within X lines of top/bottom
set scrolloff=10

" Navigate between panes (done in tmux settings)
"nnoremap <C-J> <C-W>j
"nnoremap <C-K> <C-W>k
"nnoremap <C-H> <C-W>h
"nnoremap <C-L> <C-W>l

" Navigate between tabs
nnoremap <C-B> :tabnew<CR>
nnoremap <C-F> :tabprev<CR>
nnoremap <C-N> :tabnext<CR>

set hlsearch


" ############### SCRIPTS + MAPPINGS #################
so $MY_VIM_DIR/scripts

" Mappings for scripting functions
nnoremap <C-E> :FZF<CR>

" Navigating through grep results 
nnoremap <S-K> :call OpenPrevFileInWindow()<CR>
nnoremap <S-J> :call OpenNextFileInWindow()<CR>

" Custom file explorer navigation 
"nnoremap <C-E> :call OpenFileInTmuxPane()<CR>

" Mappings for the vim debugger and rosie
nnoremap M :call SendMessageToRosie()<CR>


" ########## ROSIE-SPECIFIC SETTINGS ##############

let g:default_rosie_agent = $DEFAULT_ROSIE_AGENT
let g:root_agent_directory = $ROSIE_HOME."/agent"

command! -nargs=0 FindTestEval :call vim_soar_plugin#OpenRosieDebugger("mobilesim", $ROSIE_EVAL."/find-test/agent/rosie.find-test.config")
command! -nargs=0 RandMoveEval :call vim_soar_plugin#OpenRosieDebugger("mobilesim", $ROSIE_EVAL."/rand-move/agent/rosie.rand-move.config")
command! -nargs=0 InteriorGuardEval :call vim_soar_plugin#OpenRosieDebugger("internal", $ROSIE_EVAL."/interior-guard/agent/rosie.interior-guard.config")
command! -nargs=0 FormEval2 :call vim_soar_plugin#OpenRosieDebugger("internal", $ROSIE_EVAL."/formulations/agent/rosie.formulations.config")
command! -nargs=0 Modifiers :call vim_soar_plugin#OpenRosieDebugger("internal", $ROSIE_EVAL."/modifiers/agent/rosie.modifiers.config")

function! OpenTaskTestDebugger(test_name)
	let config_file = $ROSIE_HOME."/test-agents/task-tests/".a:test_name."/agent/rosie.".a:test_name.".config"
	call vim_soar_plugin#OpenRosieDebugger("internal", config_file)
	Python agent.agent.ExecuteCommandLine("trace 1")
endfunction
command! -nargs=1 DebugTaskTest :call OpenTaskTestDebugger(<f-args>)
command! -nargs=0 Maintenance :call OpenTaskTestDebugger("maintenance")
command! -nargs=0 Conditionals :call OpenTaskTestDebugger("conditionals")

function! OpenSubtaskDir(task_name)
	let subtask_dir = $ROSIE_HOME."/agent/problem-space/action/task-implementations/op_".a:task_name
	exec "tabnew ".subtask_dir
endfunction
command! -nargs=1 Subtask :call OpenSubtaskDir(<f-args>)

