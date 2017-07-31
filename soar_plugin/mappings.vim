
""""""""""""" util.vim """""""""""""""""""""
command SRC call AddFileToSoarSource()


"""""""""""""" parsing.vim """""""""""""""""
" delete production
nnoremap ;dp :call DeleteCurrentSoarRule()<CR>
" copy production
nnoremap ;cp :let @" = GetCurrentSoarRuleBody()<CR>
" copy rule name
nnoremap ;cr :let @" = GetStrippedCurrentWord()<CR>

"""""""""""""""" templates.vim """"""""""""""""""
command PROP call InsertOperatorProposal()<CR>
command PREF call InsertSoarPreference()<CR>
command APP call InsertOperatorApplication()<CR>

nnoremap <C-P> :call FindNextInsert()<CR>
inoremap <C-P> <ESC>:call FindNextInsert()<CR>

"""""""""""" debugger.vim """"""""""""""""""""

command! STOP python kill_agent()
command! START call LaunchRosieAgent()
nnoremap <C-I> :python startstop()<CR>
nnoremap H :python step(1)<CR>
nnoremap U :python step(10)<CR>
nnoremap ;re :python agent.execute_command("run 1 -e")<CR>

nnoremap # :call ExecuteUserSoarCommand()<CR>
nnoremap M :call SendMessageToRosie()<CR>

nnoremap ;mm :python agent.execute_command("matches")<CR>

" source production
nnoremap ;sp :call ExecuteSoarCommand(GetCurrentSoarRuleBody())<CR>
" matches production
nnoremap ;mp :call ExecuteSoarCommand("matches ".GetCurrentSoarRuleName())<CR>
" excise production
nnoremap ;ep :call ExecuteSoarCommand("excise ".GetCurrentSoarRuleName())<CR>

" print rule by name
nnoremap ;pr :call ExecuteSoarCommand("p ".GetStrippedCurrentWord())<CR>
" matches rule name
nnoremap ;mr :call ExecuteSoarCommand("matches ".GetStrippedCurrentWord())<CR>
" excise rule name
nnoremap ;er :call ExecuteSoarCommand("excise ".GetStrippedCurrentWord())<CR>

" print wmes
nnoremap ;p1 :<C-U>call ExecuteSoarCommand("p ".GetStrippedCurrentWord())<CR>
nnoremap ;p2 :<C-U>call ExecuteSoarCommand("p ".GetStrippedCurrentWord()." -d 2")<CR>
nnoremap ;p3 :<C-U>call ExecuteSoarCommand("p ".GetStrippedCurrentWord()." -d 3")<CR>
nnoremap ;p4 :<C-U>call ExecuteSoarCommand("p ".GetStrippedCurrentWord()." -d 4")<CR>
nnoremap ;p5 :<C-U>call ExecuteSoarCommand("p ".GetStrippedCurrentWord()." -d 5")<CR>
nnoremap ;p6 :<C-U>call ExecuteSoarCommand("p ".GetStrippedCurrentWord()." -d 6")<CR>
nnoremap ;p7 :<C-U>call ExecuteSoarCommand("p ".GetStrippedCurrentWord()." -d 7")<CR>
nnoremap ;p8 :<C-U>call ExecuteSoarCommand("p ".GetStrippedCurrentWord()." -d 8")<CR>
nnoremap ;p9 :<C-U>call ExecuteSoarCommand("p ".GetStrippedCurrentWord()." -d 9")<CR>
