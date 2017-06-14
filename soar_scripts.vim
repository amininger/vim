""""""""""""""""""" SOAR FUNCTIONS """""""""""""""""""

" Look for a source file in the current directory (named <dir>_source.soar)
" Append a soar command to source the current file to that source file
function! AddFileToSoarSource()
	let dir = expand('%:p:h')
	let source_file = dir."/".expand('%:p:h:t')."_source.soar"
	let file = expand('%:t')
	execute ":call system(\"echo \'\nsource ".file."\' >> ".source_file."\")"
	echo "Added ".file." to ".expand('%:p:h:t')."_source.soar"
endfunction

" Will search file for #!# and remove them and go to insert mode
function! FindNextInsert()
  execute "normal! gg/#!#\<cr>"
  call feedkeys("c3l")
endfunction


function! InsertSoarPreference(...)
  let directory = expand('%:p:h:t')
  let filename = substitute(expand('%:t'), "\.soar", "", "g")
  let templateFile = $MY_VIM_DIR."/soar-templates/preference"

  execute("r ".templateFile)

  let state_name = directory
  if a:0 > 1
    let state_name = a:2
  endif

  execute("%s/__STATE__NAME__/".state_name."/g")
endfunction
	
function! InsertOperatorProposal(...)
  let directory = expand('%:p:h:t')
  let filename = substitute(expand('%:t'), "\.soar", "", "g")
  let templateFile = $MY_VIM_DIR."/soar-templates/proposal"

  execute("r ".templateFile)

  let op_name = filename
  if a:0 > 0
    let op_name = a:1
  endif

  let state_name = directory
  if a:0 > 1
    let state_name = a:2
  endif

  execute("%s/__STATE__NAME__/".state_name."/g")
  execute("%s/__OP__NAME__/".op_name."/g")
endfunction
	
function! InsertOperatorApplication(...)
  let directory = expand('%:p:h:t')
  let filename = substitute(expand('%:t'), "\.soar", "", "g")
  let templateFile = $MY_VIM_DIR."/soar-templates/application"

  execute("r ".templateFile)

  let op_name = filename
  if a:0 > 0
    let op_name = a:1
  endif

  let state_name = directory
  if a:0 > 1
    let state_name = a:2
  endif

  execute("%s/__STATE__NAME__/".state_name."/g")
  execute("%s/__OP__NAME__/".op_name."/g")
endfunction
