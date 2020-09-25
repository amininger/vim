let &runtimepath.=','.$MY_VIM_DIR

set term=xterm-256color

syntax on

" ######### ENABLE PYTHON ##############
" Make sure python is installed (either python2 or python3)
if has('python')
	command! -nargs=1 Python python <args>
elseif has('python3')
	command! -nargs=1 Python python3 <args>
else
	echo 'Error: python not installed'
endif

" ######### VUNDLE ########
"
set nocompatible
filetype off

set rtp+=$MY_VIM_DIR/bundle/Vundle.vim
call vundle#begin()

Plugin 'VundleVim/Vundle.vim'

Plugin 'christoomey/vim-tmux-navigator'

Plugin 'amininger/vim-soar-plugin'

Plugin 'suan/vim-instant-markdown'

Plugin 'junegunn/fzf'

Plugin 'itchyny/lightline.vim'

Plugin 'tpope/vim-surround'

Plugin 'aserebryakov/vim-todo-lists'

call vundle#end()

filetype plugin indent on
au BufRead,BufNewFile *.md set filetype=markdown

"command! -nargs=0 NoMarkdown let g:instant_markdown_autostart = 0

let g:default_rosie_agent = $DEFAULT_ROSIE_AGENT
let g:root_agent_directory = $ROSIE_HOME."/agent"

command! -nargs=0 EvalFindTest :call vim_soar_plugin#OpenRosieDebugger("mobilesim", $ROSIE_EVAL."/find-test/agent/rosie.find-test.config")
command! -nargs=0 EvalRandMove :call vim_soar_plugin#OpenRosieDebugger("mobilesim", $ROSIE_EVAL."/rand-move/agent/rosie.rand-move.config")

function! OpenTaskTestDebugger(test_name)
	let config_file = $ROSIE_HOME."/test-agents/task-tests/".a:test_name."/agent/rosie.".a:test_name.".config"
	call vim_soar_plugin#OpenRosieDebugger("internal", config_file)
	Python agent.agent.ExecuteCommandLine("trace 1")
endfunction
command! -nargs=1 DebugTaskTest :call OpenTaskTestDebugger(<f-args>)

function! OpenSubtaskDir(task_name)
	let subtask_dir = $ROSIE_HOME."/agent/problem-space/action/task-implementations/op_".a:task_name
	exec "tabnew ".subtask_dir
endfunction
command! -nargs=1 Subtask :call OpenSubtaskDir(<f-args>)
" ####### END VUNDLE #######

" ####### lightline ######

set laststatus=2 " Forces status line on single page vim instances
set noshowmode   " Redundant status is included with lightline, don't need the default


" File navigation stuff
let g:netrw_liststyle=3
let g:netrw_fastbrowse=0

" ####### TABBING ######
set tabstop=4
set softtabstop=4
set shiftwidth=4
set smarttab
set autoindent
set backspace=indent,eol,start

"runtime indent/soar.vim


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

" Folding
" default is all folds open (hack)
" Use H and L to close/open folds
"set foldmethod=indent
"set foldlevelstart=20
"nnoremap H zc
"nnoremap L zo

set hlsearch

" ############# MAPPINGS #################
" Options to remap
"CF - Full Page Down (OPTION)
"H - Go to # lines from top (OPTION)
"L - go to # lines from bottom (OPTION)
"M - Center Vertically (OPTION)
"CQ - TERMINAL (OPTION) [pausing]
"CS - TERMINAL (OPTION) [pausing]
"U - undo line (OPTION)

" ############### SCRIPTS #################

so $MY_VIM_DIR/scripts
so $MY_VIM_DIR/netrw_extensions.vim

" Mappings for scripting functions
nnoremap <C-E> :FZF<CR>

" Navigating through grep results 
nnoremap <S-K> :call OpenPrevFileInWindow()<CR>
nnoremap <S-J> :call OpenNextFileInWindow()<CR>

" Custom file explorer navigation 
"nnoremap <C-E> :call OpenFileInTmuxPane()<CR>

" Mappings for the vim debugger and rosie
nnoremap M :call SendMessageToRosie()<CR>
