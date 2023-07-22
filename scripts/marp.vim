" Marp_GetPrevDelim(line_num)
"   Returns the line number of the closest marp slide delimeter (---)
"   above the given line_num (default = cursor)
function! Marp_GetPrevDelim(...)
	let line_num = a:0 > 0 ? a:1 : line('.')

	" Search backward until we find a --- line
	let cur_line_num = line_num
	while cur_line_num >= 0
		if getline(cur_line_num) =~ "^---\s*$"
			return cur_line_num
		endif
		let cur_line_num = cur_line_num - 1
	endwhile

	" Hit beginning of file
	return 0
endfunction

" Marp_GetNextDelim(line_num)
"   Returns the line number of the closest marp slide delimeter (---)
"   after the given line_num (default = cursor)
function! Marp_GetNextDelim(...)
	let line_num = a:0 > 0 ? a:1 : line('.')

	" Search forward until we find a --- line (or EOF)
	let cur_line_num = line_num + 1
	while cur_line_num <= line('$')
		if getline(cur_line_num) =~ "^---\s*$"
			return cur_line_num
		endif
		let cur_line_num = cur_line_num + 1
	endwhile
	
	" Hit end of file
	return line('$')
endfunction

" Marp_GoToTopOfSlide(...)
"    Moves the cursor to the first line in the current slide
function! Marp_GoToTopOfSlide(...)
	let line_num = a:0 > 0 ? a:1 : line('.')
	let cur_slide = Marp_GetPrevDelim(line_num)
	execute "normal! ".(cur_slide+1)."gg"
endfunction

" Marp_GoToPrevSlide(...)
"    Moves the cursor to the first line in the previous slide
function! Marp_GoToPrevSlide(...)
	let line_num = a:0 > 0 ? a:1 : line('.')
	let cur_slide = Marp_GetPrevDelim(line_num)
	let prev_slide = Marp_GetPrevDelim(cur_slide-1)
	execute "normal! ".(prev_slide+1)."gg"
endfunction

" GoToNextMarpSlide(...)
"    Moves the cursor to the first line in the next slide
function! Marp_GoToNextSlide(...)
	let line_num = a:0 > 0 ? a:1 : line('.')
	let next_slide = Marp_GetNextDelim(line_num)
	execute "normal! ".(next_slide+1)."gg"
endfunction

" Marp_CopySlide(line_num)
"   Copies the slide at the given line number
"   (or cursor position if no line_num is given)
function! Marp_CopySlide(...)
	let line_num = a:0 > 0 ? a:1 : line('.')
	let slide_begin = Marp_GetPrevDelim(line_num)
	let slide_end = Marp_GetNextDelim(line_num)-1
	execute ":".slide_begin.",".slide_end."y"
endfunction

" Marp_DeleteSlide(line_num)
"   Deletes the slide at the given line number
"   (or cursor position if no line_num is given)
function! Marp_DeleteSlide(...)
	let line_num = a:0 > 0 ? a:1 : line('.')
	let slide_begin = Marp_GetPrevDelim(line_num)
	let slide_end = Marp_GetNextDelim(line_num)-1
	execute ":".slide_begin.",".slide_end."d"
endfunction

" Marp_AppendSlide(line_num)
"   Creates a new, blank slide after the current slide
function! Marp_AppendSlide(...)
	let line_num = a:0 > 0 ? a:1 : line('.')
	let slide_end = Marp_GetNextDelim(line_num)-1
	call append(slide_end, [ "---", "", "" ])
	execute "normal! ".(slide_end+2)."gg"
endfunction

" Marp_DuplicateSlide(line_num)
"   Duplicates and appends the current slide
function! Marp_DuplicateSlide(...)
	let line_num = a:0 > 0 ? a:1 : line('.')
	call Marp_CopySlide(line_num)
	let slide_end = Marp_GetNextDelim(line_num)-1
	execute "normal! ".slide_end."gg"
	execute "normal! p"
	execute "normal! j"
endfunction

