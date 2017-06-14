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

set expandtab
set tabstop=4
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
so $MY_VIM_DIR/soar_scripts.vim

" Mappings for scripting functions
nnoremap <C-Up> :call OpenPrevFileInWindow()<CR>
nnoremap <C-Down> :call OpenNextFileInWindow()<CR>
nnoremap <C-Right> :call OpenCurrentFileInWindow()<CR>

nnoremap <C-E> :call OpenFileInTmuxPane()<CR>

command FO call OpenFileInTmuxPane()
command -nargs=1 FC call CreateFileInCurrentDirectory(<f-args>)
command -nargs=1 FRN call RenameFileUnderCursor(<f-args>)
command FDEL call DeleteFileUnderCursor()

command PREF call AddRuleTemplateToFile("preference-rule.soar")
command PROP call AddRuleTemplateToFile("proposal-rule.soar")
command APPLY call AddRuleTemplateToFile("application-rule.soar")
command COMMPROP call AddRuleTemplateToFile("comment-proposal.soar")
command COMMAPP call AddRuleTemplateToFile("comment-application.soar")

nnoremap <C-P> :call FindNextInsert()<CR>
inoremap <C-P> <ESC>:call FindNextInsert()<CR>

let g:netrw_liststyle=3
let g:netrw_fastbrowse=0
"runtime indent/soar.vim
