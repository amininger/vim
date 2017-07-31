""""""""""""""" FUNCTIONS """"""""""""""""""

" Will search file for #!# and remove them and go to insert mode
function! FindNextInsert()
	if search("#!#") != 0
	    execute "normal! gg/#!#\<cr>"
	    call feedkeys("c3l")
	endif
endfunction


function! InsertSoarPreference(...)
  let directory = expand('%:p:h:t')
  let filename = substitute(expand('%:t'), "\.soar", "", "g")
  let templateFile = $MY_VIM_DIR."/soar_plugin/templates/preference"

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
  let templateFile = $MY_VIM_DIR."/soar_plugin/templates/proposal"

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
  let templateFile = $MY_VIM_DIR."/soar_plugin/templates/application"

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
