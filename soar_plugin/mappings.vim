
""""""""""""" util.vim """""""""""""""""""""
nnoremap ;add :call AddFileToSoarSource()<CR>


"""""""""""""" parsing.vim """""""""""""""""
" delete production
nnoremap ;dp :call DeleteCurrentSoarRule()<CR>
" yank production (to vim buffer)
nnoremap ;yp :let @" = GetCurrentSoarRuleBody()<CR>
" yank rule name (to vim buffer)
nnoremap ;yr :let @" = GetStrippedCurrentWord()<CR>
" copy production (to clipboard)
nnoremap ;cp :let @+ = GetCurrentSoarRuleBody()<CR>
" copy rule name (to clipboard)
nnoremap ;cr :let @+ = GetStrippedCurrentWord()<CR>

"""""""""""""""" templates.vim """"""""""""""""""
nnoremap ;tprop :call InsertOperatorProposal()<CR>
nnoremap ;tpref :call InsertSoarPreference()<CR>
nnoremap ;tapp :call InsertOperatorApplication()<CR>
nnoremap ;telab :call InsertStateElaboration()<CR>
nnoremap ;trej :call InsertOperatorRejection()<CR>

nnoremap <C-P> :call FindNextInsert()<CR>
inoremap <C-P> <ESC>:call FindNextInsert()<CR>

"""""""""""" debugger.vim """"""""""""""""""""

nnoremap ;la :call LaunchSoarAgent()<CR>
nnoremap ;lr :call LaunchRosieAgent()<CR>
nnoremap ;lt :call LaunchRosieThorAgent()<CR>
nnoremap ;ia :python agent.execute_command("init-soar")<CR>
nnoremap ;ka :python close_debugger()<CR>
nnoremap ;ra :python reset_agent()<CR>
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

" Source the current file
nnoremap ;sc :call ExecuteSoarCommand("source ".expand('%:p'))<CR>
" Source a specified file
nnoremap ;sf :call SourceSoarFile()<CR>

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
