set expandtab
set shiftwidth=4
set tabstop=4

set cursorline
set conceallevel=2
"setlocal spell spelllang=en_us


let g:vim_markdown_strikethrough = 1

""" FOLDING

" Disables markdown folding at all
let g:vim_markdown_folding_disabled = 0

" Sets the current markdown folding level
let g:vim_markdown_folding_level = 3

set nofoldenable

" Collapse/Open current fold
nnoremap <space> za


""" CONCEALING (hiding certain markdown symbols)

" Don't conceal ``` blocks
let g:vim_markdown_conceal_code_blocks = 0

let g:vim_markdown_emphasis_multiline = 0
"let g:vim_markdown_fenced_languages = ['python=py']

""" FORMATTING TABLES
" formats the table under the cursor
nnoremap ;f :TableFormat<CR>

"let s:green       = { "gui": "#98c379", "cterm": "114" }
exec "hi mkdInlinecode ctermfg=255 ctermbg=238"
exec "hi htmlHighlight ctermfg=242 ctermbg=184"
exec "hi mkdBlockquote ctermbg=23"
exec "hi mkdLink ctermbg=130 cterm=underline"
exec "hi mkdTable ctermbg=130 cterm=underline"


""" LATEX MATH MODE
let g:vim_markdown_math = 1
"let g:tex_conceal = ""


""" YAML FRONTMATTER
let g:vim_markdown_frontmatter = 1


""" TABLE OF CONTENTS
" Let the TOC shrink to fit text
let g:vim_markdown_toc_autofit = 1

" :Toc - open the table of contents
nnoremap ;t :Toc<CR>


""" NAVIGATING HEADERS
" ]] - go to next header
" [[ - go to previous header


""" NAVIGATING LINKS

" Lets you create links without an explicit .md in the address
let g:vim_markdown_no_extensions_in_markdown = 1

" Save the current file when following a link
let g:vim_markdown_autowrite = 1

" Open a link in a new tab
let g:vim_markdown_edit_url_in = 'tab'

nnoremap ;e <Plug>Markdown_EditUrlUnderCursor<CR>

" Mappings
" gx - Markdown_OpenUrlUnderCursor - opens link in browser
" ge - Markdown_EditUrlUnderCurstor - edits the link under cursor


""" MARP SLIDE COMMANDS
nnoremap ;h :call Marp_GoToTopOfSlide()<CR>
nnoremap ;k :call Marp_GoToPrevSlide()<CR>
nnoremap ;j :call Marp_GoToNextSlide()<CR>
nnoremap ;y :call Marp_CopySlide()<CR>
nnoremap ;d :call Marp_DeleteSlide()<CR>
nnoremap ;a :call Marp_AppendSlide()<CR>
nnoremap ;c :call Marp_DuplicateSlide()<CR>

nnoremap ;m :call Latex_FormatMatrix()<CR>
nnoremap ;v :call Latex_FormatVector()<CR>

