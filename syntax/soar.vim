if exists("b:current_syntax")
  finish
endif

syn match syntaxElementMatch "\nsp " contains=syntaxElement1 nextgroup=syntaxElement2
