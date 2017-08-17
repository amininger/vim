let &runtimepath.=','.$MY_VIM_DIR

set term=xterm-256color

syntax on

" ######### VUNDLE ########
"
set nocompatible
filetype off

set rtp+=$MY_VIM_DIR/bundle/Vundle.vim
call vundle#begin()

Plugin 'VundleVim/Vundle.vim'

Plugin 'christoomey/vim-tmux-navigator'


call vundle#end()

filetype plugin indent on

" ####### END VUNDLE #######

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
nnoremap <C-B> :tabnew<Enter>
nnoremap <C-N> :tabprev<Enter>
nnoremap <C-M> :tabnext<Enter>

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
"CI - Next Jump [jumplist] (OPTION)
"L - go to # lines from bottom (OPTION)
"M - Center Vertically (OPTION)
"CQ - TERMINAL (OPTION) [pausing]
"CS - TERMINAL (OPTION) [pausing]
"U - undo line (OPTION)


"nnoremap <C-F> :echo "STEP"<CR>
"nnoremap LR :echo "LIST RULE"<CR>
"nnoremap LWW :echo "LIST WME"<CR>
"nnoremap LW2 :echo "LIST WME -d 2"<CR>
"nnoremap LW3 :echo "LIST WME -d 3"<CR>
"nnoremap LW4 :echo "LIST WME -d 4"<CR>
"nnoremap LM :echo "LIST MATCHES"<CR>

" ############### SCRIPTS #################

so $MY_VIM_DIR/scripts
so $MY_VIM_DIR/netrw_extensions.vim
so $MY_VIM_DIR/soar_plugin/load_plugin.vim

" Mappings for scripting functions

" Navigating through grep results 
nnoremap <S-K> :call OpenPrevFileInWindow()<CR>
nnoremap <S-J> :call OpenNextFileInWindow()<CR>

" Custom file explorer navigation 
nnoremap <C-E> :call OpenFileInTmuxPane()<CR>

command FO call OpenFileInTmuxPane()
command -nargs=1 FC call CreateFileInCurrentDirectory(<f-args>)
command -nargs=1 FRN call RenameFileUnderCursor(<f-args>)
command FDEL call DeleteFileUnderCursor()

" Mappings for Soar Scripts "

nnoremap <silent> ;prop :call InsertOperatorProposal()<CR>
nnoremap <silent> ;pref :call InsertSoarPreference()<CR>
nnoremap <silent> ;app :call InsertOperatorApplication()<CR>

command SRC call AddFileToSoarSource()

nnoremap <C-P> :call FindNextInsert()<CR>
inoremap <C-P> <ESC>:call FindNextInsert()<CR>
