"function! GetEditCommandForFile()
"	let line_arr = split(getline('.'), "|")
"	let filename = line_arr[0]
"	let lineno = line_arr[1]
"	return "e +".lineno." ".filename
"endfunction
"	
"function! OpenFileUnderCursorInUpperWindow()
"	let editcmd=GetEditCommandForFile()
"	wincmd k
"	execute(editcmd)
"endfunction
"
"nmap <silent> ;n :call OpenFileUnderCursorInUpperWindow()<CR>
"
"function! OpenPrevFileInWindow()
"	wincmd j
"	execute "normal! k"
"	let editcmd=GetEditCommandForFile()
"	wincmd k
"	execute(editcmd)
"endfunction
"
"function! OpenNextFileInWindow()
"	wincmd j
"	execute "normal! j"
"	let editcmd=GetEditCommandForFile()
"	wincmd k
"	execute(editcmd)
"endfunction
"
"nnoremap <C-Up> :call OpenPrevFileInWindow()<CR>
"nnoremap <C-Down> :call OpenNextFileInWindow()<CR>

function! InsertProposal(...)
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

nnoremap <silent> ;p :call InsertProposal()<CR>


