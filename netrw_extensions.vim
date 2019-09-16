"nnoremap <C-E> :call OpenFileInTmuxPane()<CR>

command FO call OpenFileInTmuxPane()
command -nargs=1 FC call CreateFileInCurrentDirectory(<f-args>)
command -nargs=1 DC call CreateNewDirInCurrentDirectory(<f-args>)
command -nargs=1 FRN call RenameFileUnderCursor(<f-args>)
command FDEL call DeleteFileUnderCursor()
command DDEL call DeleteDirUnderCursor()
command GETDIR call GetCurrentExplorerDirectory()
command GSF call GenerateSoarSourceFile()

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

  " Check if the cursor is at a directory
  let dir = ""
  if !IsDir(getline('.'))
	" Go backwards until you find a valid directory
	let indent_level = indent(line_no) - 4
	while line_no > 0 && indent(line_no) != indent_level
		let line_no = line_no - 1
	endwhile
  endif
  let dir = ExtractDirectoryName(getline(line_no))

  let indent_level = indent(line_no)
  " Keep unwinding the directory stack until you reach the top (no indent)
  while indent_level > 0 && line_no > 0
	  let line_no = line_no - 1
	  if IsOpenDir(getline(line_no)) && indent(line_no) == indent_level - 2
		let parent_dir = ExtractDirectoryName(getline(line_no))
		let dir = parent_dir.dir
		let indent_level = indent_level - 2
	 endif
  endwhile

  " Return the fully qualitifed directory
  let dir = expand('%:p:h')."/".dir
  return dir
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
" CreateNewDirInCurrentDirectory(filename:string)
"   Creates a new directory with the given name in the 
"     current directory 

function! CreateNewDirInCurrentDirectory(dir_name)
  let line_no = line('.')
  let cur_dir = expand('%:p:h')

  let dir = GetCurrentExplorerDirectory()
  let new_dir = dir.a:dir_name

  echom new_dir

  " Create the file
  execute ":silent !mkdir ".new_dir

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

"""""
" DeleteDirUnderCursor()
"   Deletes the directory under the cursor

function! DeleteDirUnderCursor()
  let line_no = line('.')
  let cur_line = getline('.')
  let cur_dir = expand('%:p:h')

  " Make sure its a file
  if !IsDir(cur_line)
    return
  endif

  let dir = GetCurrentExplorerDirectory()

  " Remove the file
  execute ":silent !rm -r ".dir
  
  " Redraw
  redraw!

  " Refresh the file"
  call feedkeys("kr")
endfunction

Python << EOF

from pathlib import Path

def generate_soar_source_file(dir_name):
	cur_dir = Path(dir_name)
	if not cur_dir.is_dir():
		return

	source_file = cur_dir.joinpath(Path(cur_dir.name + "_source.soar"))
	if not source_file.exists():
		source_file.touch()

	dirs =  sorted([ d.name for d in cur_dir.iterdir() if d.is_dir() ])
	files = sorted([ f.name for f in cur_dir.iterdir() if f.is_file() and f.suffix == ".soar" and f != source_file ])

	source_file_contents = []
	for f in files:
		source_file_contents.append("source " + f + "\n")

	for d in dirs:
		source_file_contents.append("pushd " + d)
		source_file_contents.append("source " + d + "_source.soar")
		source_file_contents.append("popd\n")

	source_file.write_text("\n".join(source_file_contents))
EOF

""""
" GenerateSoarSourceFile()
"   Creates or modifies a soar source file in the current directory
"   of the name dir_name_source.soar and will source all the current files and
"   subdirectories

function! GenerateSoarSourceFile()
  let dir = GetCurrentExplorerDirectory()
  execute ":Python generate_soar_source_file(\"".dir."\")"

  " Refresh the file"
  redraw!
  call feedkeys("r")
endfunction
