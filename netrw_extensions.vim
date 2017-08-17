nnoremap <C-E> :call OpenFileInTmuxPane()<CR>

command FO call OpenFileInTmuxPane()
command -nargs=1 FC call CreateFileInCurrentDirectory(<f-args>)
command -nargs=1 FRN call RenameFileUnderCursor(<f-args>)
command FDEL call DeleteFileUnderCursor()

let g:netrw_liststyle=3
let g:netrw_fastbrowse=0

""""""""""""""""""" FILE EXPLORER """""""""""""""""""
" These functions are used within the file explorer
"   To expand its functionality

"""""
" ExtractDirectoryName(line:string)
"   Given a line in the file explorer buffer
"   This will return the directory name
"   (Whitespace and arrow symbols removed)

function! ExtractDirectoryName(line)
  return TrimString(substitute(a:line, '▾\|▸', '', ''))
endfunction


"""""
" IsOpenDir(line:string)
"   Given a line in the file explorer buffer
"   Returns true if it represents an open directory

function! IsOpenDir(line)
  return (a:line =~ '▾')
endfunction


"""""
" IsClosedDir(line:string)
"   Given a line in the file explorer buffer
"   Returns true if it represents a closed directory

function! IsClosedDir(line)
  return (a:line =~ '▸')
endfunction


"""""
" IsDir(line:string)
"   Given a line in the file explorer buffer
"   Returns true if it represents a directory

function! IsDir(line)
  return IsOpenDir(a:line) || IsClosedDir(a:line)
endfunction


"""""
" ValidateFile(line:string)
"   Will try to make sure the given line is a valid file
"   Returns true if so, Returns false and prints error if not

function! ValidateFile(line)
  " If it is a directory, don't open
  if IsDir(a:line)
    echom "ValidateFile FAIL: Tried to open directory as file"
    return 0
  endif

  " If there is no indent, it is also not a file
  if indent(a:line) == 0
    echom "ValidateFile FAIL: Tried to open file at 0 indentation"
    return 0
  endif

  " If the line is empty, it is not a file
  if strlen(a:line) == 0
    echom "ValidateFile FAIL: Tried to open an empty file"
    return 0
  endif

  return 1
endfunction


"""""
" GetCurrentExplorerDirectory()
"   Given the cursor at a line in the file explorer buffer
"   This returns the fully qualified directory that cursor is at (if a dir)
"     or the directory the file is in (if a file)

function! GetCurrentExplorerDirectory()
  let line_no = line('.')
  let indent_level = indent(line_no)

  " Check if the cursor is at a directory
  let dir = ""
  if IsDir(getline('.'))
    let line = getline(line_no)
    let dir = ExtractDirectoryName(line)
  endif

  while indent_level > 2 && line_no > 0
    " Keep going up the file until we are out of the tree or at the top of the page
    let line_no = line_no - 1
    
    if (IsOpenDir(getline(line_no))) && (indent(line_no) + 4 == indent_level)
      " We are at an expanded directory at the proper indentation, add it to the dir list
      let folder = ExtractDirectoryName(getline(line_no))
      let dir = folder.dir
      let indent_level = indent_level - 2
    endif
  endwhile

  " Return the fully qualitifed directory
  return expand('%:p:h')."/".dir
endfunction


"""""
" OpenFileInTmuxPane()
"   If the cursor is on a file in the file explorer,
"   Then open that file in a vim server called tmux

function! OpenFileInTmuxPane()
  let line_no = line('.')
  let cur_line = TrimString(getline(line_no))

  if (!ValidateFile(cur_line))
    return
  endif

  let dir = GetCurrentExplorerDirectory()
  let filename = cur_line
  let file = dir.filename

  let opencmd=":silent !vim --servername tmux --remote-tab ".file
  execute opencmd | redraw!
endfunction


"""""
" CreateFileInCurrentDirectory(filename:string)
"   Creates a file with the given name in the 
"     current directory and opens it in tmux pane

function! CreateFileInCurrentDirectory(filename)
  let line_no = line('.')
  let cur_dir = expand('%:p:h')

  let dir = GetCurrentExplorerDirectory()
  let file = dir.a:filename

  " Create the file
  execute ":silent !touch ".file

  " Open it in the tmux tab
  execute ":silent !vim --servername tmux --remote-tab ".file

  " Redraw
  redraw!

  " Refresh the file"
  call feedkeys("r")
endfunction

"""""
" RenameFileUnderCursor(new_filename:string)
"   Creates a file with the given name in the 
"     current directory and opens it in tmux pane

function! RenameFileUnderCursor(new_filename)
  let line_no = line('.')
  let cur_line = getline('.')
  let cur_dir = expand('%:p:h')

  " Make sure its a file
  if !ValidateFile(cur_line)
    return
  endif

  let dir = GetCurrentExplorerDirectory()
  let old_file = dir.TrimString(cur_line)
  let new_file = dir.a:new_filename

  " Create the file
  execute ":silent !mv ".old_file." ".new_file

  " Redraw
  redraw!

  " Refresh the file"
  call feedkeys("kr")
endfunction

"""""
" DeleteFileUnderCursor()
"   Deletes the file under the cursor

function! DeleteFileUnderCursor()
  let line_no = line('.')
  let cur_line = getline('.')
  let cur_dir = expand('%:p:h')

  " Make sure its a file
  if !ValidateFile(cur_line)
    return
  endif

  let dir = GetCurrentExplorerDirectory()
  let filename = TrimString(cur_line)
  let file = dir.filename

  " Remove the file
  execute ":silent !rm ".file
  
  " Redraw
  redraw!

  " Refresh the file"
  call feedkeys("kr")
endfunction

