let &runtimepath.=','.$MY_VIM_DIR

set nocompatible

filetype plugin indent on
:syntax on

syntax on


set expandtab
set tabstop=2
set shiftwidth=2
set smarttab
set autoindent
set backspace=indent,eol,start

nnoremap <C-J> <C-W>j
nnoremap <C-K> <C-W>k
nnoremap <C-H> <C-W>h
nnoremap <C-L> <C-W>l
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
so $MY_VIM_DIR/soar_scripts.vim

let g:netrw_liststyle=3

"runtime indent/soar.vim
