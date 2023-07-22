" Vim Notes:
" getpos('.') -> [ buf, line, col, x ], col('.'), line('.')
" getline(N) , setline(N, S)
" len(S), str[i], str[i:j], split(S, Pattern)

" Given a string and an index into that string,
" Splits the string into 3 parts:
" Before the left bracket, inside the brackets, after the right bracket
function! SplitSurroundingBrackets(str, index)
	" Find the left bracket
	let left_bracket = a:index
	while left_bracket >= 0 && a:str[left_bracket] != '['
		let left_bracket = left_bracket - 1
	endwhile

	" Find the right bracket
	let right_bracket = a:index - 1
	while right_bracket <= len(a:str) && a:str[right_bracket] != ']'
		let right_bracket = right_bracket + 1
	endwhile

	" Split str into 3 parts (before, inner, after)
	let before = ""
	if left_bracket > 0
		let before = a:str[:left_bracket-1]
	endif
	let inner = a:str[left_bracket+1:right_bracket-1]
	let after = a:str[right_bracket+1:]
	return [ before, inner, after ]
endfunction

" Latex_FormatMatrix()
"   Replaces an array expression at the cursor position
"   With a Latex Math formatted version
"   Example: [ rcc 1 0 0, 0 1 0, 0 0 1 ]
function! Latex_FormatMatrix()
	" Split the line into 3 parts relative to the containing brackets
	let line = getline(line('.'))
	let line_parts = SplitSurroundingBrackets(line, col('.'))

	let rows = split(line_parts[1], ",")
	let cols = substitute(rows[0], " ", "", "g")
	let rows = rows[1:]

	let i = 0
	while i < len(rows)
		" Put & in between elements
		let rows[i] = join(split(rows[i]), " & ")   
		let i = i + 1
	endwhile

	" Generate the
	let begin = "\\left[ \\begin{array}{".cols."}"
	let inner = join(rows, " \\\\ ")
	let end = "\\end{array} \\right]"

	let line_parts[1] = begin." ".inner." ".end

	call setline('.', join(line_parts, ""))
endfunction


" Latex_FormatVector()
"   Replaces a vector expression at the cursor position
"   With a Latex Math formatted version
"   Example: [ 1, 2, 3 ]
function! Latex_FormatVector()
	" Split the line into 3 parts relative to the containing brackets
	let line = getline(line('.'))
	let line_parts = SplitSurroundingBrackets(line, col('.'))

	echo line_parts

	let elements = split(line_parts[1], ",")
	let rows = join(elements, " \\\\ ")

	" Generate the latex
	let latex = "\\left[ \\begin{array}{c} ".rows." \\end{array} \\right]"
	let line_parts[1] = latex

	call setline('.', join(line_parts, ""))
endfunction


