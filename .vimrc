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

set tabstop=4
set softtabstop=4
set shiftwidth=4
set smarttab
set autoindent
set backspace=indent,eol,start

"nnoremap <C-J> <C-W>j
"nnoremap <C-K> <C-W>k
"nnoremap <C-H> <C-W>h
"nnoremap <C-L> <C-W>l
nnoremap <C-N> <C-W>n

nnoremap <C-B> :tabnew<Enter>
nnoremap <C-N> :tabprev<Enter>
nnoremap <C-M> :tabnext<Enter>

" Folding
" default is all folds open (hack)
" Use H and L to close/open folds
set foldmethod=indent
set foldlevelstart=20
nnoremap H zc
nnoremap L zo

set hlsearch

so $MY_VIM_DIR/scripts
so $MY_VIM_DIR/netrw_extensions.vim
so $MY_VIM_DIR/soar_plugin/load_plugin.vim

" Mappings for scripting functions
nnoremap <S-K> :call OpenPrevFileInWindow()<CR>
nnoremap <S-J> :call OpenNextFileInWindow()<CR>

