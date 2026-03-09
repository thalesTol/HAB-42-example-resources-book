local M = {}
local auxFuncs = require("ferramentasAuxiliares")
----------------------------------------------------------
-- COLOCAR HISTÓRICO -------------------------------------
----------------------------------------------------------
function M.copyFileHistorico( srcName, srcPath, dstName, dstPath, overwrite )
		
	local results = false
	local function doesFileExist( fname, path )

		local results = false
	 
		-- Path for the file
		local filePath = path .. "/"..fname
		
		if ( filePath ) then
			local file, errorString = io.open( filePath, "r" )
			if not file then
				-- Error occurred; output the cause
				print( "File error: " .. errorString )
			else
				-- File exists!
				print( "File found: " .. fname )
				results = true
				-- Close the file handle
				file:close()
			end
		end
		return results
	end
	local fileExists = doesFileExist( srcName, srcPath )
	
	if ( fileExists == false ) then
		return nil  -- nil = Source file not found
	end
	
 
	-- Check to see if destination file already exists
	if not ( overwrite ) then
		if ( fileLib.doesFileExist( dstName, dstPath ) ) then
			return 1  -- 1 = File already exists (don't overwrite)
		end
	end
	
	-- Copy the source file to the destination file
	local rFilePath = srcPath.."/"..srcName
	--local wFilePath = system.pathForFile( dstName, dstPath )
	local wFilePath = dstPath .. "/" .. dstName
	local rfh = io.open( rFilePath, "rb" )
	local wfh, errorString = io.open( wFilePath, "wb" )
	
	if not ( wfh ) then
		-- Error occurred; output the cause
		print( "File error: " .. errorString )
		return false
	else
		-- Read the file and write to the destination directory
		local data = rfh:read( "*a" )
		if not ( data ) then
			print( "Read error!" )
			return false
		else
			if not ( wfh:write( data ) ) then
				print( "Write error!" )
				return false
			end
		end
	end
 
	results = 2  -- 2 = File copied successfully!
 
	-- Close file handles
	rfh:close()
	wfh:close()
 
	return results
end

function M.escreverNoHistorico(atrib,texto,vetorJson)
	local tipoSistema = auxFuncs.checarSistema()
	print("Escrevendo no histórico: ",atrib.tela.temHistorico,texto)
	if atrib.tela.temHistorico == true then
		local date = os.date( "*t" )
		local dataHistorico = date.day.."|"..date.month.."|"..date.year.."|"..date.hour..":"..date.min..":"..date.sec.."|||"
		
		local path = system.pathForFile( "historico.txt", system.DocumentsDirectory )
		local file, errorString = io.open( path, "a" )
		file:write(dataHistorico..texto.."\n")
		io.close( file )
		file = nil
		local tipoSistemaMac = system.getInfo("platform")

		if vetorJson then
			local vetorJsonAux = auxFuncs.loadTable("historico.json")
			
			if not vetorJsonAux then vetorJsonAux = {} end
			--vetorJson.sessao_id = dataHistorico
			vetorJson.data = os.date("!%Y-%m-%dT%TZ")--date.year.."-"..date.month.."-"..date.day.." "..date.hour..":"..date.min..":"..date.sec..".0"
			
			table.insert(vetorJsonAux,vetorJson)
			

			auxFuncs.saveTable( vetorJsonAux, "historico.json")
		end
		
		if auxFuncs.fileExistsDiretorioBase("historico offline.txt",system.DocumentsDirectory) then
			if tipoSistema == "android" then
				M.copyFileHistorico( "historico offline.txt", string.gsub(system.pathForFile("historico offline.txt",system.DocumentsDirectory),"historico offline.txt",""), "historico offline.txt", "/sdcard", true )
			elseif tipoSistema == "PC" then
				if tipoSistemaMac == "macos" then
					require "ssk2.loadSSK"
					_G.ssk.init( { measure = false } )
					M.copyFileHistorico( "historico offline.txt", string.gsub(system.pathForFile("historico offline.txt",system.DocumentsDirectory),"historico offline.txt",""), "historico offline.txt", ssk.files.desktop.getDesktopRoot(), true )
				else
					M.copyFileHistorico( "historico offline.txt", string.gsub(system.pathForFile("historico offline.txt",system.DocumentsDirectory),"historico offline.txt",""), "historico offline.txt", "C:/!E-book Hipermidia!", true )
				end
			end
		end
	end
end

function M.Historico_video(atrib,historicoTxT,vetorJson)
	vetorJson.subtipo = atrib.subtipo or nil
	vetorJson.tempo_total = atrib.tempo_total or nil -- youtube e nativo
	vetorJson.tempo_total_executado = atrib.tempo_total_executado or nil -- nativo
	vetorJson.tempo_total_repetindo = atrib.tempo_total_repetindo or nil -- nativo
	vetorJson.tempo_atual_video = atrib.tempo_atual_video or nil -- nativo
	vetorJson.link = atrib.link or nil -- youtube
	-- iniciar relatório
	local relatorio = vetorJson.data
	-- verificar se é rodapé
	if vetorJson.rodape then 
		relatorio = relatorio .. "| No rodapé " .. vetorJson.rodape 
		historicoTxT.texto = historicoTxT.texto .. "Rodapé " .. vetorJson.rodape
	elseif vetorJson.card then
		relatorio = relatorio .. "| No Card " .. vetorJson.card 
		historicoTxT.texto = historicoTxT.texto .. "Card " .. vetorJson.card
	end
	
	if vetorJson.acao == "executar" then
		if vetorJson.subtipo then 
			if vetorJson.subtipo == "youtube" then
				relatorio = relatorio .. "| Realizou ação de executar o vídeo ".. vetorJson.objeto_id .."de youtube da página "..vetorJson.pagina_Livro.. " às ".. vetorJson.hora.."."
				
				historicoTxT.texto = historicoTxT.texto ..  "Página "..vetorJson.pagina_Livro.."|||Video|||Youtube|executar|Video "..vetorJson.objeto_id
				if atrib.link then
					relatorio = relatorio.."| Abriu o link do vídeo ".. vetorJson.objeto_id .." do youtube na página "..vetorJson.pagina_Livro.. " às ".. vetorJson.hora.."."
					
					historicoTxT.texto = historicoTxT.texto ..  "Página "..vetorJson.pagina_Livro.."|||Video|||Youtube|Link|Video "..vetorJson.objeto_id
				end
			elseif vetorJson.subtipo == "no livro" then
				relatorio = relatorio .. "| Executou o vídeo ".. vetorJson.objeto_id .." dentro do livro na página "..vetorJson.pagina_Livro.. " às ".. vetorJson.hora..". O tempo total do vídeo é de: "..auxFuncs.SecondsToClock(vetorJson.tempo_total).."."
				
				historicoTxT.texto = historicoTxT.texto ..  "Página "..vetorJson.pagina_Livro.."|||Video|||Interno|executar|Video "..vetorJson.objeto_id.."|Tempo: "..vetorJson.tempo_atual_video.."|Total: "..tostring(vetorJson.tempo_total)
			elseif vetorJson.subtipo == "nativo" then
				relatorio = relatorio .. "| Executou o vídeo ".. vetorJson.objeto_id .." na página "..vetorJson.pagina_Livro.. " às ".. vetorJson.hora.."."
				
				historicoTxT.texto = historicoTxT.texto ..  "Página "..vetorJson.pagina_Livro.."|||Video|||Nativo|executar|Video "..vetorJson.objeto_id
			end
		end
	elseif vetorJson.acao == "pausar" then
		if vetorJson.subtipo then
			if vetorJson.subtipo == "youtube" then
				relatorio = relatorio .. "| Realizou ação de pausar o vídeo ".. vetorJson.objeto_id .."de youtube da página "..vetorJson.pagina_Livro.. " às ".. vetorJson.hora.."."
			
				historicoTxT.texto = historicoTxT.texto ..  "Página "..vetorJson.pagina_Livro.."|||Video|||Youtube|pausar|Video "..vetorJson.objeto_id
			elseif vetorJson.subtipo == "no livro" then
				relatorio = relatorio .. "| Pausou o vídeo ".. vetorJson.objeto_id .." aos "..auxFuncs.SecondsToClock(vetorJson.tempo_atual_video).." de execução na página "..vetorJson.pagina_Livro.. " às ".. vetorJson.hora.."."
				
				historicoTxT.texto = historicoTxT.texto ..  "Página "..vetorJson.pagina_Livro.."|||Video|||Interno|pausar|Video "..vetorJson.objeto_id.."|orientação|Tempo: "..vetorJson.tempo_atual_video.."|Total: "..tostring(vetorJson.tempo_total)
			end
		end
	elseif vetorJson.acao == "despausar" then
		if vetorJson.subtipo then 
			if vetorJson.subtipo == "no livro" then
				relatorio = relatorio .. "| Despausou o vídeo ".. vetorJson.objeto_id .." dentro do livro aos "..auxFuncs.SecondsToClock(vetorJson.tempo_atual_video).." na página "..vetorJson.pagina_Livro.. " às ".. vetorJson.hora.."."
				
				historicoTxT.texto = historicoTxT.texto ..  "Página "..vetorJson.pagina_Livro.."|||Video|||Interno|despausar|Video "..vetorJson.objeto_id.."|Tempo: "..vetorJson.tempo_atual_video.."|Total: "..tostring(vetorJson.tempo_total)
			end
		end
	elseif vetorJson.acao == "terminar" then
		if vetorJson.subtipo then 
			if vetorJson.subtipo == "youtube" then
				relatorio = relatorio .. "| Terminou o vídeo ".. vetorJson.objeto_id .."de youtube da página "..vetorJson.pagina_Livro.. " às ".. vetorJson.hora.."."
				
				historicoTxT.texto = historicoTxT.texto ..  "Página "..vetorJson.pagina_Livro.."|||Video|||Youtube|terminar|Video "..vetorJson.objeto_id
			elseif vetorJson.subtipo == "no livro" then
				relatorio = relatorio .. "| Terminou de assistir o vídeo ".. vetorJson.objeto_id .." na página "..vetorJson.pagina_Livro.. " às ".. vetorJson.hora..". O tempo total de execução do video foi de: "..auxFuncs.SecondsToClock(vetorJson.tempo_total_repetindo).."."
				
				historicoTxT.texto = historicoTxT.texto ..  "Página "..vetorJson.pagina_Livro.."|||Video|||Interno|terminar|Video "..vetorJson.objeto_id.."|Total: "..tostring(vetorJson.tempo_total_repetindo)
			elseif vetorJson.subtipo == "nativo" then
				relatorio = relatorio .. "| Terminou o vídeo ".. vetorJson.objeto_id .." na página "..vetorJson.pagina_Livro.. " às ".. vetorJson.hora.."."
				
				historicoTxT.texto = historicoTxT.texto ..  "Página "..vetorJson.pagina_Livro.."|||Video|||Nativo|terminar|Video "..vetorJson.objeto_id
			end
		end
	elseif vetorJson.acao == "cancelar" then
		if vetorJson.subtipo then 
			if vetorJson.subtipo == "nativo" then
				relatorio = relatorio .. "| Cancelou o vídeo ".. vetorJson.objeto_id .." na página "..vetorJson.pagina_Livro.. " às ".. vetorJson.hora.."."
				
				historicoTxT.texto = historicoTxT.texto ..  "Página "..vetorJson.pagina_Livro.."|||Video|||Nativo|cancelar|Video "..vetorJson.objeto_id
			elseif vetorJson.subtipo == "no livro" then
				relatorio = relatorio .. "| Cancelou a execução do vídeo ".. vetorJson.objeto_id .." aos "..auxFuncs.SecondsToClock(vetorJson.tempo_atual_video).." na página "..vetorJson.pagina_Livro.. " às ".. vetorJson.hora..".O tempo total gasto no vídeo foi de: "..SecondsToClock(vetorJson.tempo_total_repetindo).."."
				
				historicoTxT.texto = historicoTxT.texto ..  "Página "..vetorJson.pagina_Livro.."|||Video|||Interno|cancelar|Video "..vetorJson.objeto_id.."|Tempo: "..vetorJson.tempo_atual_video.."|Total: "..tostring(vetorJson.tempo_total)
			end
		end
	elseif vetorJson.acao == "avançar" then
		if vetorJson.subtipo then 
			if vetorJson.subtipo == "no livro" then
				relatorio = relatorio.."| Avançou a execução do vídeo ".. vetorJson.objeto_id .." dentro do livro aos "..auxFuncs.SecondsToClock(vetorJson.tempo_atual_video).." na página "..vetorJson.pagina_Livro.. " às ".. vetorJson.hora.."."
				
				historicoTxT.texto = historicoTxT.texto ..  "Página "..vetorJson.pagina_Livro.."|||Video|||Interno|avançar|Video "..vetorJson.objeto_id.."|Tempo: "..vetorJson.tempo_atual_video.."|Total: "..tostring(vetorJson.tempo_total)
			end
		end
	elseif vetorJson.acao == "retroceder" then
		if vetorJson.subtipo then 
			if vetorJson.subtipo == "nativo" then
				
			elseif vetorJson.subtipo == "no livro" then
				relatorio = relatorio.."| Retrocedeu a execução do vídeo ".. vetorJson.objeto_id .." aos "..auxFuncs.SecondsToClock(vetorJson.tempo_atual_video).." na página "..vetorJson.pagina_Livro.. " às ".. vetorJson.hora.."."
				
				historicoTxT.texto = historicoTxT.texto ..  "Página "..vetorJson.pagina_Livro.."|||Video|||Interno|retroceder|Video "..vetorJson.objeto_id.."|Tempo: "..vetorJson.tempo_atual_video.."|Total: "..tostring(vetorJson.tempo_total)
			end
		end
	elseif vetorJson.acao == "abrir detalhes" or vetorJson.acao == "fechar detalhes" then
		M.Historico_detalhesAux(atrib,historicoTxT.texto,vetorJson)
	end
	
	vetorJson.relatorio = relatorio
	relatorio = nil
end

function M.Historico_audio(atrib,historicoTxT,vetorJson)
	vetorJson.subtipo = atrib.subtipo or nil
	vetorJson.tempo_total = atrib.tempo_total or nil
	vetorJson.tempo_atual_audio = atrib.tempo_atual_audio or nil
	-- iniciar relatório
	local relatorio = vetorJson.data
	-- verificar se é rodapé
	if vetorJson.rodape then 
		relatorio = relatorio .. "| No rodapé " .. vetorJson.rodape 
		historicoTxT.texto = historicoTxT.texto .. "Rodapé " .. vetorJson.rodape 
	elseif vetorJson.card then
		relatorio = relatorio .. "| No Card " .. vetorJson.card 
		historicoTxT.texto = historicoTxT.texto .. "Card " .. vetorJson.card
	end
	if vetorJson.dicionario then
		relatorio = relatorio .. "| No Dicionario de '" .. tostring(vetorJson.dicionario).."'"
		historicoTxT.texto = historicoTxT.texto .. "Dicionario '" .. tostring(vetorJson.dicionario).."'"
	end
	
	if vetorJson.acao == "avançar" then
		relatorio = relatorio.."| Avançou a execução do áudio "..vetorJson.objeto_id.."da pagina"..vetorJson.pagina_Livro.." aos "..auxFuncs.SecondsToClock(vetorJson.tempo_atual_audio).." de "..auxFuncs.SecondsToClock(vetorJson.tempo_total).." de execução às ".. vetorJson.hora.."."
	
		historicoTxT.texto = historicoTxT.texto ..  "Página "..vetorJson.pagina_Livro.."|||Audio|||Avançar|Tempo:"..vetorJson.tempo_atual_audio.."|Total: "..vetorJson.tempo_total.."|Audio "..vetorJson.objeto_id
	
	elseif vetorJson.acao == "retroceder" then
		relatorio = relatorio.."| Clicou para retroceder o áudio "..vetorJson.objeto_id.."da pagina"..vetorJson.pagina_Livro.." aos "..auxFuncs.SecondsToClock(vetorJson.tempo_atual_audio).." de "..auxFuncs.SecondsToClock(vetorJson.tempo_total).." de execução às ".. vetorJson.hora.."."
	
		historicoTxT.texto = historicoTxT.texto ..  "Página "..vetorJson.pagina_Livro.."|||Audio|||Retroceder|Tempo:"..vetorJson.tempo_atual_audio.."|Total: "..vetorJson.tempo_total.."|Audio "..vetorJson.objeto_id
	
	elseif vetorJson.acao == "pausar" then
		relatorio = relatorio.."| Pausou o áudio "..vetorJson.objeto_id.."da pagina"..vetorJson.pagina_Livro.." aos "..auxFuncs.SecondsToClock(vetorJson.tempo_atual_audio).." de "..auxFuncs.SecondsToClock(vetorJson.tempo_total).." de execução às ".. vetorJson.hora.."."
		
		historicoTxT.texto = historicoTxT.texto ..  "Página "..vetorJson.pagina_Livro.."|||Audio|||Pausar|Tempo:"..vetorJson.tempo_atual_audio.."|Total: "..vetorJson.tempo_total.."|Audio "..vetorJson.objeto_id
	elseif vetorJson.acao == "executar" then
		relatorio = relatorio.."| Executou o áudio "..vetorJson.objeto_id.."da pagina"..vetorJson.pagina_Livro.." aos "..auxFuncs.SecondsToClock(vetorJson.tempo_atual_audio).." de "..auxFuncs.SecondsToClock(vetorJson.tempo_total).." de execução às ".. vetorJson.hora.."."
		
		historicoTxT.texto = historicoTxT.texto ..  "Página "..vetorJson.pagina_Livro.."|||Audio|||Executar|Tempo:"..vetorJson.tempo_atual_audio.."|Total: "..vetorJson.tempo_total.."|Audio "..vetorJson.objeto_id
	elseif vetorJson.acao == "despausar" then
		relatorio = relatorio.."| despausou o áudio "..vetorJson.objeto_id.."da pagina"..vetorJson.pagina_Livro.." aos "..auxFuncs.SecondsToClock(vetorJson.tempo_atual_audio).." de "..auxFuncs.SecondsToClock(vetorJson.tempo_total).." de execução às ".. vetorJson.hora.."."
		
		historicoTxT.texto = historicoTxT.texto ..  "Página "..vetorJson.pagina_Livro.."|||Audio|||Despausar|Tempo:"..vetorJson.tempo_atual_audio.."|Total: "..vetorJson.tempo_total.."|Audio "..vetorJson.objeto_id
	elseif vetorJson.acao == "cancelar" then
		relatorio = relatorio.."| Cancelou a execução do áudio "..vetorJson.objeto_id.."da pagina"..vetorJson.pagina_Livro.." aos "..auxFuncs.SecondsToClock(vetorJson.tempo_atual_audio).." de "..auxFuncs.SecondsToClock(vetorJson.tempo_total).." de execução às ".. vetorJson.hora..". Executou o mesmo por "..auxFuncs.SecondsToClock(vetorJson.tempo_total_repetindo).."."
		
		historicoTxT.texto = historicoTxT.texto ..  "Página "..vetorJson.pagina_Livro.."|||Audio|||Cancelar|Tempo:"..vetorJson.tempo_atual_audio.."|Total: "..vetorJson.tempo_total.."|Audio "..vetorJson.objeto_id
	elseif vetorJson.acao == "terminar" then
		relatorio = relatorio.."| terminou a execução do áudio "..vetorJson.objeto_id.."da pagina"..vetorJson.pagina_Livro.." aos "..auxFuncs.SecondsToClock(vetorJson.tempo_atual_audio).." de "..auxFuncs.SecondsToClock(vetorJson.tempo_total).." de execução às ".. vetorJson.hora..". Executou o mesmo por "..auxFuncs.SecondsToClock(vetorJson.tempo_total_repetindo).."."
		
		historicoTxT.texto = historicoTxT.texto ..  "Página "..vetorJson.pagina_Livro.."|||Audio|||Terminar|Tempo:"..vetorJson.tempo_atual_audio.."|Total: "..vetorJson.tempo_total.."|Audio "..vetorJson.objeto_id
	end
	
	vetorJson.relatorio = relatorio
	relatorio = nil
end

function M.Historico_tts(atrib,historicoTxT,vetorJson)
	local nomesArquivosParagrafos = atrib.nomesArquivosParagrafos or {}
	local TTSduracaoTotal = atrib.TTSduracaoTotal or nil
	local controladorSons = atrib.controladorSons or ""
	local contAnimacao = atrib.contAnimacao or nil
	vetorJson.subtipo = atrib.subtipo or nil
	vetorJson.tts_valores = atrib.tts_valores or nil
	vetorJson.valor_id = atrib.valor_id or nil
	vetorJson.tempo_total = atrib.tempo_total or nil
	vetorJson.velocidade_tts = atrib.velocidade_tts or nil
	vetorJson.tempo_atual_video = atrib.tempo_atual_video or nil
	
	-- iniciar relatório
	local relatorio = vetorJson.data
	-- verificar se é rodapé
	if vetorJson.rodape then 
		relatorio = relatorio .. "| No rodapé " .. vetorJson.rodape 
		historicoTxT.texto = historicoTxT.texto .. "Rodapé " .. vetorJson.rodape 
	elseif vetorJson.card then
		relatorio = relatorio .. "| No Card " .. vetorJson.card 
		historicoTxT.texto = historicoTxT.texto .. "Card " .. vetorJson.card
	end
	
	
	if vetorJson.acao == "executar" then
		-- subtipo
		-- tempo_atual_video
		-- tempo_total
		-- valor_id
		-- velocidade_tts
		if atrib.subtipo and atrib.subtipo == "dicionário" then
			relatorio = relatorio.."| Ativou o TTS do dicionário da página "..vetorJson.pagina_Livro.." às "..vetorJson.hora.." com velocidade  "..vetorJson.velocidade_tts.."."
			
			historicoTxT.texto = historicoTxT.texto ..  "Página "..vetorJson.pagina_Livro.."|||TTS|||Executar|Dicionário|velocidade: "..vetorJson.velocidade_tts
		elseif atrib.subtipo and atrib.subtipo == "animação" then
			
		elseif atrib.subtipo and atrib.subtipo == "video" then
			relatorio = relatorio.."| Executou o vídeo "..controladorSons.." no TTS na página "..vetorJson.pagina_Livro.." às "..vetorJson.hora..". O video tem duração de "..SecondsToClock(atrib.tempoTotal)..". Numero de elementos TTS da página: "..controladorSons.."/"..#nomesArquivosParagrafos.."."
		elseif atrib.subtipo and atrib.subtipo == "mensagens" then
			relatorio = relatorio.."| Ativou o TTS da anotação e mensagens da página "..vetorJson.pagina_Livro.." às "..vetorJson.hora.." com velocidade  "..vetorJson.velocidade_tts.."."
			
			historicoTxT.texto = historicoTxT.texto ..  "Página "..vetorJson.pagina_Livro.."|||TTS|||Executar|Anotação e Mensagens|velocidade: "..vetorJson.velocidade_tts
		else
			relatorio = relatorio.."| Executou o áudio "..controladorSons.." do TTS da página "..vetorJson.pagina_Livro.." às "..vetorJson.hora.." com velocidade  "..atrib.velocidade_tts..". O áudio tem duração de ".. auxFuncs.SecondsToClock(TTSduracaoTotal)..". Numero de elementos TTS da página: "..controladorSons.."/"..#nomesArquivosParagrafos.."."
		end
	elseif acao == "terminar" then
		if atrib.subtipo and atrib.subtipo == "animação" then
			relatorio = relatorio.."| Terminou a execução da animação "..contAnimacao.." da página "..vetorJson.pagina_Livro.."."
		elseif atrib.subtipo and atrib.subtipo == "video" then
			
		end
	elseif vetorJson.acao == "gerar" then
		
	elseif vetorJson.acao == "pausar" then
		
	elseif vetorJson.acao == "despausar" then
		
	elseif vetorJson.acao == "parar" then
		
	elseif vetorJson.acao == "retroceder" then
		
	elseif vetorJson.acao == "avançar" then
		
	end
	
	vetorJson.relatorio = relatorio
	relatorio = nil
end

function M.Historico_texto(atrib,historicoTxT,vetorJson)
	vetorJson.link = atrib.link or nil
	vetorJson.subtipo = atrib.subtipo or nil
	vetorJson.audio = atrib.audio or nil -- clicando palavra audio
	vetorJson.palavra = atrib.palavra or nil -- clicando palavra audio
	vetorJson.numero_palavra = atrib.numero_palavra or nil -- clicando palavra audio
	vetorJson.tamanho_novo = atrib.tamanho_novo or nil
	vetorJson.tamanho_anterior = atrib.tamanho_anterior or nil
	
	-- iniciar relatório
	local relatorio = vetorJson.data
	-- verificar se é rodapé
	if vetorJson.rodape then 
		relatorio = relatorio .. "| No rodapé " .. vetorJson.rodape 
		historicoTxT.texto = historicoTxT.texto .. "Rodapé " .. vetorJson.rodape 
	elseif vetorJson.card then
		relatorio = relatorio .. "| No Card " .. vetorJson.card 
		historicoTxT.texto = historicoTxT.texto .. "Card " .. vetorJson.card
	end
	
	if vetorJson.acao == "fechar link do texto" then
		if vetorJson.subtipo then
			relatorio = relatorio.."| Fechou o link aberto do texto contido em "..vetorJson.subtipo.." "..vetorJson.objeto_id.." às "..vetorJson.hora.." na página "..vetorJson.pagina_Livro..'. O link em questão é: "'..vetorJson.link..'".'
		
			historicoTxT.texto = historicoTxT.texto ..  "Página "..vetorJson.pagina_Livro.."|||Texto|||"..vetorJson.subtipo.."|Fechar link "..vetorJson.link
		else
			relatorio = relatorio.."| Fechou o link aberto do texto "..vetorJson.objeto_id.." às "..vetorJson.hora.." na página "..vetorJson.pagina_Livro..'. O link em questão é: "'..vetorJson.link..'".'
		
			historicoTxT.texto = historicoTxT.texto ..  "Página "..vetorJson.pagina_Livro.."|||Texto|||fechar link "..vetorJson.link
		end
	elseif vetorJson.acao == "abrir link do texto" then
		if vetorJson.subtipo then
			relatorio = relatorio.."| Abriu o link do texto contido em "..vetorJson.subtipo.." "..vetorJson.objeto_id.." às "..vetorJson.hora.." na página "..vetorJson.pagina_Livro..'. O link em questão é: "'..vetorJson.link..'".'
		
			historicoTxT.texto = historicoTxT.texto ..  "Página "..vetorJson.pagina_Livro.."|||Texto|||"..vetorJson.subtipo.."|Fechar link "..vetorJson.link
		else
			relatorio = relatorio.."| Abriu o link do texto "..vetorJson.objeto_id.." às "..vetorJson.hora.." na página "..vetorJson.pagina_Livro..'. O link em questão é: "'..vetorJson.link..'".'
		
			historicoTxT.texto = historicoTxT.texto ..  "Página "..vetorJson.pagina_Livro.."|||Texto|||abrir link "..vetorJson.link
		end
	elseif vetorJson.acao == "abrir link externo do texto" then
		if vetorJson.subtipo then
			relatorio = relatorio.."| Abriu o link do texto contido em "..vetorJson.subtipo.." "..vetorJson.objeto_id.." às "..vetorJson.hora.." na página "..vetorJson.pagina_Livro..' fora do livro. O link em questão é: "'..vetorJson.link..'".'
		
			historicoTxT.texto = historicoTxT.texto ..  "Página "..vetorJson.pagina_Livro.."|||Texto|||"..vetorJson.subtipo.."|abrir link externo "..vetorJson.link
		else
			relatorio = relatorio.."| Abriu o link do texto "..vetorJson.objeto_id.." às "..vetorJson.hora.." na página "..vetorJson.pagina_Livro..' fora do livro. O link em questão é: "'..vetorJson.link..'".'
		
			historicoTxT.texto = historicoTxT.texto ..  "Página "..vetorJson.pagina_Livro.."|||Texto|||abrir link externo "..vetorJson.link
		end
	elseif vetorJson.acao == "executar som do texto" then
		if vetorJson.subtipo then
			relatorio = relatorio.."| Executou um som presente no texto contido em "..vetorJson.subtipo.." "..vetorJson.objeto_id.." às "..vetorJson.hora.." na página "..vetorJson.pagina_Livro..'. A palavra clicada foi: "'..vetorJson.palavra..'" e está na posição '..vetorJson.numero_palavra..'.'
			
			historicoTxT.texto = historicoTxT.texto ..  "Página "..vetorJson.pagina_Livro.."|||Texto|||"..vetorJson.subtipo.."|executar som "..vetorJson.audio.."|Palavra "..vetorJson.palavra.."|posição "..vetorJson.numero_palavra
		else
			relatorio = relatorio.."| Executou um som presente no texto "..vetorJson.objeto_id.." às "..vetorJson.hora.." na página "..vetorJson.pagina_Livro..'. A palavra clicada foi: "'..vetorJson.palavra..'" e está na posição '..vetorJson.numero_palavra..'.'
			
			historicoTxT.texto = historicoTxT.texto ..  "Página "..vetorJson.pagina_Livro.."|||Texto|||executar som "..vetorJson.audio.."|Palavra "..vetorJson.palavra.."|posição "..vetorJson.numero_palavra
		end
	elseif vetorJson.acao == "aumentar" then
		if vetorJson.subtipo then
			relatorio = relatorio.."| Aumentou o tamanho da letra do texto contido em "..vetorJson.subtipo.." "..vetorJson.objeto_id.." da página "..vetorJson.pagina_Livro.." às "..vetorJson.hora.."."
			
			historicoTxT.texto = historicoTxT.texto ..  "Página "..vetorJson.pagina_Livro.."|||Texto|||"..vetorJson.subtipo.."|Aumentou tamanho do texto da página||De "..vetorJson.tamanho_anterior.."Para ".. vetorJson.tamanho_novo
		else
			relatorio = relatorio.."| Aumentou o tamanho da letra do texto "..vetorJson.objeto_id.." da página "..vetorJson.pagina_Livro.." às "..vetorJson.hora.."."
			
			historicoTxT.texto = historicoTxT.texto ..  "Página "..vetorJson.pagina_Livro.."|||Texto|||Aumentou tamanho do texto da página||De "..vetorJson.tamanho_anterior.."Para ".. vetorJson.tamanho_novo
		end
	elseif vetorJson.acao == "diminuir" then
		if vetorJson.subtipo then
			relatorio = relatorio.."| Diminuiu o tamanho da letra do texto contido em "..vetorJson.subtipo.." "..vetorJson.objeto_id.." da página "..vetorJson.pagina_Livro.." às "..vetorJson.hora.."."
			
			historicoTxT.texto = historicoTxT.texto ..  "Página "..vetorJson.pagina_Livro.."|||Texto|||"..vetorJson.subtipo.."|Diminuiu tamanho do texto da página"
		else
			relatorio = relatorio.."| Diminuiu o tamanho da letra do texto "..vetorJson.objeto_id.." da página "..vetorJson.pagina_Livro.." às "..vetorJson.hora.."."
			
			historicoTxT.texto = historicoTxT.texto ..  "Página "..vetorJson.pagina_Livro.."|||Texto|||Diminuiu tamanho do texto da página||De "..vetorJson.tamanho_anterior.."Para ".. vetorJson.tamanho_novo
		end
	end
	
	if vetorJson.historicoDicionario then
		if vetorJson.palavraDicionario then
			vetorJson.relatorio = vetorJson.relatorio.. 'No Verbete: "'..vetorJson.palavraDicionario..'", do elemento '.. objeto_historico_id.." da página."
		elseif vetorJson.palavraDicHistorico then
			vetorJson.relatorio = vetorJson.relatorio.. 'No Verbete: "'..vetorJson.palavraDicHistorico..'".'
		end
		historicoTxT.texto = historicoTxT.texto ..  "Dicionario|||"..historicoTxT.texto
	end
	
	vetorJson.relatorio = relatorio
	relatorio = nil
end

function M.Historico_imagem(atrib,historicoTxT,vetorJson)
	vetorJson.link = atrib.link or nil -- link
	vetorJson.tempo_aberto = atrib.tempo_aberto or nil -- zoom
	
	-- iniciar relatório
	local relatorio = vetorJson.data
	-- verificar se é rodapé
	if vetorJson.rodape then 
		relatorio = relatorio .. "| No rodapé " .. vetorJson.rodape 
		historicoTxT.texto = historicoTxT.texto .. "Rodapé " .. vetorJson.rodape 
	elseif vetorJson.card then
		relatorio = relatorio .. "| No Card " .. vetorJson.card 
		historicoTxT.texto = historicoTxT.texto .. "Card " .. vetorJson.card
	end
	
	if vetorJson.acao == "ativar zoom" then
		relatorio = relatorio.."| Ativou o zoom da imagem nº "..vetorJson.objeto_id .." da página ".. vetorJson.pagina_Livro .." às ".. vetorJson.hora .. "."
		
		historicoTxT.texto = historicoTxT.texto ..  "Página "..vetorJson.pagina_Livro.."|||Imagem|||Zoom ativado|Imagem "..vetorJson.objeto_id
	elseif vetorJson.acao == "desativar zoom" then
		relatorio = relatorio.."| Desativou o zoom da imagem nº "..vetorJson.objeto_id .." da página ".. vetorJson.pagina_Livro .." às ".. vetorJson.hora .. " depois de analizar a imagem por "..auxFuncs.SecondsToClock(vetorJson.tempo_aberto).."."
		
		historicoTxT.texto = historicoTxT.texto ..  "Página "..vetorJson.pagina_Livro.."|||Imagem|||Zoom removido|Imagem "..vetorJson.objeto_id.."|Tempo "..vetorJson.tempo_aberto
	elseif vetorJson.acao == "abrir link da imagem" then
		if atrib.embeded then
			relatorio = relatorio.."| Abriu o link da imagem n° "..vetorJson.objeto_id .. ", dentro do livro, às "..vetorJson.hora.." na página "..vetorJson.pagina_Livro .. ". O link aberto foi: "..vetorJson.link
			
			historicoTxT.texto = historicoTxT.texto ..  "Página "..vetorJson.pagina_Livro.."|||Imagem|||Link embeded aberto: "..vetorJson.link
		else
			relatorio = relatorio.."| Abriu o link da imagem n° "..vetorJson.objeto_id .. " às "..vetorJson.hora.." na página "..vetorJson.pagina_Livro .. ". O link aberto foi: "..vetorJson.link
			
			historicoTxT.texto = historicoTxT.texto ..  "Página "..vetorJson.pagina_Livro.."|||Imagem|||Link aberto: "..vetorJson.link
		end
	elseif vetorJson.acao == "fechar link da imagem" then
		relatorio = relatorio.."| Fechou o link Embeded da imagem n° "..vetorJson.objeto_id .. " às "..vetorJson.hora.." na página "..vetorJson.pagina_Livro .."após vizualizá-lo por ".. auxFuncs.SecondsToClock(vetorJson.tempo_aberto) .. ". O link aberto foi: "..vetorJson.link
		
		historicoTxT.texto = historicoTxT.texto ..  "Página "..vetorJson.pagina_Livro.."|||Imagem|||Link embeded fechado: "..vetorJson.link.."|Tempo "..vetorJson.tempo_aberto
	elseif vetorJson.acao == "abrir detalhes" or vetorJson.acao == "fechar detalhes" then
		M.Historico_detalhesAux(atrib,historicoTxT.texto,vetorJson)
	end
	
	vetorJson.relatorio = relatorio
	relatorio = nil
end

function M.Historico_dicionario(atrib,historicoTxT,vetorJson)
	vetorJson.palavra = atrib.palavra or nil
	
	-- iniciar relatório
	local relatorio = vetorJson.data
	-- verificar se é rodapé
	if vetorJson.rodape then 
		relatorio = relatorio .. "| No rodapé " .. vetorJson.rodape 
		historicoTxT.texto = historicoTxT.texto .. "Rodapé " .. vetorJson.rodape 
	elseif vetorJson.card then
		relatorio = relatorio .. "| No Card " .. vetorJson.card 
		historicoTxT.texto = historicoTxT.texto .. "Card " .. vetorJson.card
	end
	
	if vetorJson.acao == "abrir dicionário" then
		relatorio = relatorio.."| Abriu o dicionário da página "..vetorJson.pagina_Livro.." às "..vetorJson.hora.."."
		
		historicoTxT.texto = historicoTxT.texto ..  "Página "..vetorJson.pagina_Livro.."|||Dicionário|||Abriu dicionário"
	elseif vetorJson.acao == "fechar dicionário" then
		relatorio = relatorio.."| Fechou o dicionário da página "..vetorJson.pagina_Livro.." às "..vetorJson.hora.."."
		
		historicoTxT.texto = historicoTxT.texto ..  "Página "..vetorJson.pagina_Livro.."|||Dicionário|||Fechou dicionário"
	elseif vetorJson.acao == "abrir palavra" then
		relatorio = relatorio.."| Abriu o verbete "..vetorJson.objeto_id..": "..vetorJson.palavra.." da página "..vetorJson.pagina_Livro.." às "..vetorJson.hora.."."
		
		historicoTxT.texto = historicoTxT.texto ..  "Página "..vetorJson.pagina_Livro.."|||Dicionário|||Abriu o verbete|Palavra "..vetorJson.palavra
	elseif vetorJson.acao == "fechar palavra" then
		relatorio = relatorio.."| Fechou o verbete "..vetorJson.objeto_id..": "..vetorJson.palavra.." da página "..vetorJson.pagina_Livro.." às "..vetorJson.hora.."."
		
		historicoTxT.texto = historicoTxT.texto ..  "Página "..vetorJson.pagina_Livro.."|||Dicionário|||Fechou o verbete|Palavra "..vetorJson.palavra
	end
	
	vetorJson.relatorio = relatorio
	relatorio = nil
end

function M.Historico_detalhesAux(atrib,historicoTxT,vetorJson)
	
	local relatorio = vetorJson.data
	-- verificar se é rodapé
	if vetorJson.rodape then 
		relatorio = relatorio .. "| No rodapé " .. vetorJson.rodape 
		historicoTxT.texto = historicoTxT.texto .. "Rodapé " .. vetorJson.rodape 
	elseif vetorJson.card then
		relatorio = relatorio .. "| No Card " .. vetorJson.card 
		historicoTxT.texto = historicoTxT.texto .. "Card " .. vetorJson.card
	end

	if vetorJson.acao == "abrir detalhes" then
		local artigo = "do"
		if vetorJson.tipoInteracao == "imagem" or vetorJson.tipoInteracao == "animacao" then
			artigo = "da"
		end
		
		relatorio = relatorio.."| Abriu a descrição "..artigo.." "..vetorJson.tipoInteracao.." "..vetorJson.objeto_id.." da página "..vetorJson.pagina_Livro.." às "..vetorJson.hora.."."
		
		historicoTxT.texto = historicoTxT.texto ..  "Página "..vetorJson.pagina_Livro.."|||Audio|||Abriu detalhes audio|Número: "..vetorJson.objeto_id
	elseif vetorJson.acao == "fechar detalhes" then
		local artigo = "do"
		if vetorJson.tipoInteracao == "imagem" or vetorJson.tipoInteracao == "animacao" then
			artigo = "da"
		end
				
		relatorio = relatorio.."| Fechou a descrição "..artigo.." "..vetorJson.tipoInteracao.." "..vetorJson.objeto_id.." da página "..vetorJson.pagina_Livro.." às "..vetorJson.hora..". A vizualização foi de ".. auxFuncs.SecondsToClock(vetorJson.tempo_aberto).."."
		
		historicoTxT.texto = historicoTxT.texto ..  "Página "..vetorJson.pagina_Livro.."|||Audio|||Fechou detalhes audio|Número: "..vetorJson.objeto_id.."|Tempo "..vetorJson.tempo_aberto
	end
	
	vetorJson.relatorio = relatorio
	relatorio = nil
end

function M.Historico_botao(atrib,historicoTxT,vetorJson)
	vetorJson.subtipo = atrib.subtipo or nil
	vetorJson.automatico = atrib.automatico or nil -- audio
	vetorJson.tempo_aberto = atrib.tempo_aberto or nil -- audio
	
	local relatorio = vetorJson.data
	-- verificar se é rodapé
	if vetorJson.rodape then 
		relatorio = relatorio .. "| No rodapé " .. vetorJson.rodape 
		historicoTxT.texto = historicoTxT.texto .. "Rodapé " .. vetorJson.rodape 
	elseif vetorJson.card then
		relatorio = relatorio .. "| No Card " .. vetorJson.card 
		historicoTxT.texto = historicoTxT.texto .. "Card " .. vetorJson.card
	end
	
	if vetorJson.subtipo == "de audio" then
		if vetorJson.acao == "executar" and vetorJson.automatico then
			relatorio = relatorio.."| Executou o áudio do botão "..vetorJson.objeto_id.." automaticamente na página "..atrib.pagina.. " às ".. vetorJson.hora.."."
			
			historicoTxT.texto = historicoTxT.texto ..  "Página "..atrib.pagina.."|||Botão|||som|executar automatico|Botao "..vetorJson.objeto_id
		elseif vetorJson.acao == "executar" then
			relatorio = relatorio.."| Executou o áudio do botão "..vetorJson.objeto_id.." da página "..atrib.pagina.. " às ".. vetorJson.hora.."."
			
			historicoTxT.texto = historicoTxT.texto ..  "Página "..atrib.pagina.."|||Botão|||som|executar|Botao "..vetorJson.objeto_id
		elseif vetorJson.acao == "terminar" and vetorJson.tempo_aberto then
			relatorio = relatorio.."| Terminou de ouvir o áudio do botão "..vetorJson.objeto_id.." da página "..atrib.pagina.. " às ".. vetorJson.hora..". O tempo que permaneceu aberto foi: "..auxFuncs.SecondsToClock(vetorJson.tempo_aberto)
			
			historicoTxT.texto = historicoTxT.texto ..  "Página "..atrib.pagina.."|||Botão|||som|terminar|Botao "..vetorJson.objeto_id.."|Tempo "..vetorJson.tempo_aberto
		elseif vetorJson.acao == "cancelar" and vetorJson.tempo_aberto then
			relatorio = relatorio.."| Cancelou o áudio do botão "..vetorJson.objeto_id.." da página "..atrib.pagina.. " às ".. vetorJson.hora..". O tempo que permaneceu aberto foi: "..auxFuncs.SecondsToClock(vetorJson.tempo_aberto)
			
			historicoTxT.texto = historicoTxT.texto ..  "Página "..atrib.pagina.."|||Botão|||som|cancelar|Botao "..vetorJson.objeto_id.."|Tempo "..vetorJson.tempo_aberto
		elseif vetorJson.acao == "terminar" then
			relatorio = relatorio.."| Terminou de ouvir o áudio do botão "..vetorJson.objeto_id.." da página "..atrib.pagina.. " às ".. vetorJson.hora.."."
			
			historicoTxT.texto = historicoTxT.texto ..  "Página "..atrib.pagina.."|||Botão|||som|terminar|Botao "..vetorJson.objeto_id
		end
	end
	
	vetorJson.relatorio = relatorio
	relatorio = nil
end

function M.Historico_anotacao(atrib,historicoTxT,vetorJson)
	vetorJson.subtipo = atrib.subtipo or nil
	
	local relatorio = vetorJson.data
	-- verificar se é rodapé
	if vetorJson.rodape then 
		relatorio = relatorio .. "| No rodapé " .. vetorJson.rodape 
		historicoTxT.texto = historicoTxT.texto .. "Rodapé " .. vetorJson.rodape 
	end
	
	if vetorJson.acao == "excluir anotação" then
		relatorio = relatorio.."| Excluiu a anotação pessoal criada na página "..vetorJson.pagina_Livro.. " às ".. vetorJson.hora.."."
		
		historicoTxT.texto = historicoTxT.texto ..  "Página "..vetorJson.pagina_Livro.."|||Anotação|||Foi excluida uma anotação "
	
	elseif vetorJson.acao == "criar anotação" then
		relatorio = relatorio.."| Criou uma anotação pessoal na página "..vetorJson.pagina_Livro.. " às ".. vetorJson.hora.."."
		
		historicoTxT.texto = historicoTxT.texto ..  "Página "..vetorJson.pagina_Livro.."|||Anotação|||Foi criada uma anotação "
	end
	
	vetorJson.relatorio = relatorio
	relatorio = nil
end

function M.Historico_comentario(atrib,historicoTxT,vetorJson)
	vetorJson.subtipo = atrib.subtipo or nil
	vetorJson.conteudo = atrib.conteudo or nil
	vetorJson.id_Comentario = atrib.id_Comentario or nil
	
	local relatorio = vetorJson.data
	-- verificar se é rodapé
	if vetorJson.rodape then 
		relatorio = relatorio .. "| No rodapé " .. vetorJson.rodape 
		historicoTxT.texto = historicoTxT.texto .. "Rodapé " .. vetorJson.rodape 
	end
	
	if vetorJson.acao == "excluir comentário" then
		relatorio = relatorio.."| Excluiu uma mensagem própria anteriormente criada na página "..vetorJson.pagina_Livro.. " às ".. vetorJson.hora..'. O id da mensagem desativada é: "'..vetorJson.id_Comentario..'".'
		
		historicoTxT.texto = historicoTxT.texto .. "Página "..vetorJson.pagina_Livro.."|||Comentario|||Foi excluído um comentário "
	
	elseif vetorJson.acao == "criar comentário" then
		relatorio = relatorio.."| Criou uma mensagem na página "..vetorJson.pagina_Livro.. " às ".. vetorJson.hora..'.\nConteúdo da mensagem: "'..vetorJson.conteudo..'"'
		
		historicoTxT.texto = historicoTxT.texto .. "Página "..vetorJson.pagina_Livro.."|||Comentario|||Foi criado um comentário "
	
	elseif vetorJson.acao == "curtir comentário" then
		relatorio = relatorio.."| Curtiu uma mensagem feita na página "..vetorJson.pagina_Livro.. " às ".. vetorJson.hora..'. Conteúdo da mensagem: "'..vetorJson.conteudo..'".'
		
		historicoTxT.texto = historicoTxT.texto ..  "Página "..vetorJson.pagina_Livro.."|||Comentario|||curtir|||conteudo: "..vetorJson.conteudo.."|||id: "..vetorJson.id_Comentario
		
	elseif vetorJson.acao == "descurtir comentário" then
		relatorio = relatorio.."| Descurtiu uma mensagem feita na página "..vetorJson.pagina_Livro.. " às ".. vetorJson.hora..'. Conteúdo da mensagem: "'..vetorJson.conteudo..'".'
		
		historicoTxT.texto = historicoTxT.texto ..  "Página "..vetorJson.pagina_Livro.."|||Comentario|||descurtir|||conteudo: "..vetorJson.conteudo.."|||id: "..vetorJson.id_Comentario
	end
	
	vetorJson.relatorio = relatorio
	relatorio = nil
end

function M.Historico_animacao(atrib,historicoTxT,vetorJson)
	-- iniciar relatório
	local relatorio = vetorJson.data
	-- verificar se é rodapé
	if vetorJson.rodape then 
		relatorio = relatorio .. "| No rodapé " .. vetorJson.rodape 
		historicoTxT.texto = historicoTxT.texto .. "Rodapé " .. vetorJson.rodape 
	elseif vetorJson.card then
		relatorio = relatorio .. "| No Card " .. vetorJson.card 
		historicoTxT.texto = historicoTxT.texto .. "Card " .. vetorJson.card
	end
	
	
	if vetorJson.acao == "executar" then
		relatorio = relatorio.."| Executou a animação "..vetorJson.objeto_id.." da pagina"..vetorJson.pagina_Livro.." às ".. vetorJson.hora.."."
	
		historicoTxT.texto = historicoTxT.texto .. "Página "..vetorJson.pagina_Livro.."|||Animacao|||Executar|Animacao "..vetorJson.objeto_id
	
	elseif vetorJson.acao == "terminar" then
		relatorio = relatorio.."| Terminou a animação "..vetorJson.objeto_id.." da pagina"..vetorJson.pagina_Livro.." às ".. vetorJson.hora.."."
	
		historicoTxT.texto = historicoTxT.texto .. "Página "..vetorJson.pagina_Livro.."|||Animacao|||Terminar|Animacao "..vetorJson.objeto_id
	elseif vetorJson.acao == "pausar" then
		relatorio = relatorio.."| Pausou a animação "..vetorJson.objeto_id.."da pagina"..vetorJson.pagina_Livro.." às ".. vetorJson.hora.."."
		
		historicoTxT.texto = historicoTxT.texto .. "Página "..vetorJson.pagina_Livro.."|||Animacao|||Pausar|Animacao "..vetorJson.objeto_id

	elseif vetorJson.acao == "despausar" then
		relatorio = relatorio.."| despausou a animação "..vetorJson.objeto_id.."da pagina"..vetorJson.pagina_Livro.." às ".. vetorJson.hora.."."
		
		historicoTxT.texto = historicoTxT.texto .. "Página "..vetorJson.pagina_Livro.."|||Animacao|||Despausar|Animacao "..vetorJson.objeto_id
	elseif vetorJson.acao == "cancelar" then
		relatorio = relatorio.."| Cancelou a execução da animação "..vetorJson.objeto_id.."da pagina"..vetorJson.pagina_Livro.." às ".. vetorJson.hora.."."
		
		historicoTxT.texto = historicoTxT.texto ..  "Página "..vetorJson.pagina_Livro.."|||Audio|||Cancelar|Animacao "..vetorJson.objeto_id

	end
	
	vetorJson.relatorio = relatorio
	relatorio = nil
end

function M.Historico_card(atrib,historicoTxT,vetorJson)
	-- iniciar relatório
	local relatorio = vetorJson.data
	-- verificar se é rodapé
	
	if vetorJson.acao == "abrir" then
		relatorio = relatorio.."| Abriu o deck da pagina"..vetorJson.pagina_Livro.." às ".. vetorJson.hora.."."
	
		historicoTxT.texto = historicoTxT.texto .. "Página "..vetorJson.pagina_Livro.."|||Deck|||Abrir"
	
	elseif vetorJson.acao == "fechar" then
		relatorio = relatorio.."| Fechou o deck da pagina"..vetorJson.pagina_Livro.." às ".. vetorJson.hora.."."
	
		historicoTxT.texto = historicoTxT.texto .. "Página "..vetorJson.pagina_Livro.."|||Deck|||Fechar"

	end
	
	vetorJson.relatorio = relatorio
	relatorio = nil
end

function M.Historico_rodape(atrib,historicoTxT,vetorJson)
	-- iniciar relatório
	local relatorio = vetorJson.data
	vetorJson.numero = atrib.numero or nil
	-- verificar se é rodapé
	
	if vetorJson.acao == "abrir" then
		if vetorJson.numero then
			relatorio = relatorio.."| Abriu o rodapé "..vetorJson.numero.." da pagina"..vetorJson.pagina_Livro.." às ".. vetorJson.hora.."."
			historicoTxT.texto = historicoTxT.texto .. "Página "..vetorJson.pagina_Livro.."|||Rodape|||Abrir|numero "..vetorJson.numero
		else
			relatorio = relatorio.."| Abriu a janela de rodapés da pagina"..vetorJson.pagina_Livro.." às ".. vetorJson.hora.."."
			historicoTxT.texto = historicoTxT.texto .. "Página "..vetorJson.pagina_Livro.."|||Rodape|||Abrir"
		end
	elseif vetorJson.acao == "fechar" then
		if vetorJson.numero then
			relatorio = relatorio.."| Fechou o rodapé "..vetorJson.numero.." da pagina"..vetorJson.pagina_Livro.." às ".. vetorJson.hora.."."
			historicoTxT.texto = historicoTxT.texto .. "Página "..vetorJson.pagina_Livro.."|||Rodape|||Fechar|numero "..vetorJson.numero
		else
			relatorio = relatorio.."| Fechou a janela de rodapés da pagina"..vetorJson.pagina_Livro.." às ".. vetorJson.hora.."."
			historicoTxT.texto = historicoTxT.texto .. "Página "..vetorJson.pagina_Livro.."|||Rodape|||Fechar"
		end
	end
	
	vetorJson.relatorio = relatorio
	relatorio = nil
end

function M.Historico_relatorio(atrib,historicoTxT,vetorJson)
	-- iniciar relatório
	local relatorio = vetorJson.data
	-- verificar se é rodapé
	
	if vetorJson.acao == "abrir" then
		relatorio = relatorio.."| Abriu a janela de relatórios da pagina"..vetorJson.pagina_Livro.." às ".. vetorJson.hora.."."
		historicoTxT.texto = historicoTxT.texto .. "Página "..vetorJson.pagina_Livro.."|||Relatorio|||Abrir"
	elseif vetorJson.acao == "fechar" then
		relatorio = relatorio.."| Fechou a janela de relatórios da pagina"..vetorJson.pagina_Livro.." às ".. vetorJson.hora.."."
		historicoTxT.texto = historicoTxT.texto .. "Página "..vetorJson.pagina_Livro.."|||Relatorio|||Fechar"
	elseif vetorJson.acao == "abrir visualização" then
		relatorio = relatorio.."| Abriu a vizualização do relatório da pagina"..vetorJson.pagina_Livro.." às ".. vetorJson.hora.."."
		historicoTxT.texto = historicoTxT.texto .. "Página "..vetorJson.pagina_Livro.."|||Relatorio|||Abrir|vizualizacao"
	elseif vetorJson.acao == "fechar visualização" then
		relatorio = relatorio.."| Fechou a vizualização do relatório da pagina"..vetorJson.pagina_Livro.." às ".. vetorJson.hora.."."
		historicoTxT.texto = historicoTxT.texto .. "Página "..vetorJson.pagina_Livro.."|||Relatorio|||Fechar|vizualizacao"
	end
	
	vetorJson.relatorio = relatorio
	relatorio = nil
end

function M.Historico_impressao(atrib,historicoTxT,vetorJson)
	-- iniciar relatório
	local relatorio = vetorJson.data
	vetorJson.tipo = atrib.tipo or nil
	vetorJson.subtipo = atrib.subtipo or nil
	vetorJson.intervalo = atrib.intervalo or nil
	-- verificar se é rodapé
	
	if vetorJson.acao == "abrir" then
		relatorio = relatorio.."| Abriu a janela de Envio de PDF na pagina"..vetorJson.pagina_Livro.." às ".. vetorJson.hora.."."
		historicoTxT.texto = historicoTxT.texto .. "Página "..vetorJson.pagina_Livro.."|||Impressao|||Abrir"
	elseif vetorJson.acao == "fechar" then
		relatorio = relatorio.."| Fechou a janela de Envio de PDF na pagina"..vetorJson.pagina_Livro.." às ".. vetorJson.hora.."."
		historicoTxT.texto = historicoTxT.texto .. "Página "..vetorJson.pagina_Livro.."|||Impressao|||Fechar"
	elseif vetorJson.acao == "aba cards" then
		relatorio = relatorio.."| Mudou para a aba cards às ".. vetorJson.hora.."."
		historicoTxT.texto = historicoTxT.texto .. "Página "..vetorJson.pagina_Livro.."|||Impressao|||mudar aba|cards"
	elseif vetorJson.acao == "aba livro" then
		relatorio = relatorio.."| Mudou para a aba livro às ".. vetorJson.hora.."."
		historicoTxT.texto = historicoTxT.texto .. "Página "..vetorJson.pagina_Livro.."|||Impressao|||mudar aba|livro"
	elseif vetorJson.acao == "aba dicionario" then
		relatorio = relatorio.."| Mudou para a aba dicionário às ".. vetorJson.hora.."."
		historicoTxT.texto = historicoTxT.texto .. "Página "..vetorJson.pagina_Livro.."|||Impressao|||mudar aba|dicionario"
	elseif vetorJson.acao == "confirmar" then
		if vetorJson.subtipo == "atual" then
			if vetorJson.tipo == "cards" then
				relatorio = relatorio.."| Mandou criar o pdf dos cards da página atual às ".. vetorJson.hora.."."
				historicoTxT.texto = historicoTxT.texto .. "Página "..vetorJson.pagina_Livro.."|||Impressao|||Criar PDF|cards|atual"
			elseif vetorJson.tipo == "livro" then
				relatorio = relatorio.."| Mandou criar o pdf da página atual às ".. vetorJson.hora.."."
				historicoTxT.texto = historicoTxT.texto .. "Página "..vetorJson.pagina_Livro.."|||Impressao|||Criar PDF|livro|atual"
			end
		elseif vetorJson.subtipo == "intervalo" then
			if vetorJson.tipo == "cards" then
				relatorio = relatorio.."| Mandou criar o pdf dos cards contidos no intervalo de páginas "..vetorJson.intervalo.." às ".. vetorJson.hora.."."
				historicoTxT.texto = historicoTxT.texto .. "Página "..vetorJson.pagina_Livro.."|||Impressao|||Criar PDF|cards|intervalo="..vetorJson.intervalo
			elseif vetorJson.tipo == "livro" then
				relatorio = relatorio.."| Mandou criar o pdf do intervalo de páginas "..vetorJson.intervalo.." às ".. vetorJson.hora.."."
				historicoTxT.texto = historicoTxT.texto .. "Página "..vetorJson.pagina_Livro.."|||Impressao|||Criar PDF|livro|intervalo="..vetorJson.intervalo
			end
		elseif vetorJson.subtipo == "todas" then
			if vetorJson.tipo == "cards" then
				relatorio = relatorio.."| Mandou criar o pdf de todos os cards do livro às ".. vetorJson.hora.."."
				historicoTxT.texto = historicoTxT.texto .. "Página "..vetorJson.pagina_Livro.."|||Impressao|||Criar PDF|cards|tudo"
			elseif vetorJson.tipo == "livro" then
				relatorio = relatorio.."| Mandou criar o pdf de todo o livro às ".. vetorJson.hora.."."
				historicoTxT.texto = historicoTxT.texto .. "Página "..vetorJson.pagina_Livro.."|||Impressao|||Criar PDF|livro|tudo"
			end
		end
	end
	
	vetorJson.relatorio = relatorio
	relatorio = nil
end

function M.Historico_clearance(atrib,historicoTxT,vetorJson)
	-- iniciar relatório
	local relatorio = vetorJson.data
	vetorJson.objeto = atrib.objeto or nil
	-- verificar se é rodapé
	
	if vetorJson.acao == "desbloquear" then
		if vetorJson.objeto == "pagina" then
			relatorio = relatorio.."| Desbloqueou a página"..vetorJson.pagina_Livro.." às ".. vetorJson.hora.."."
			historicoTxT.texto = historicoTxT.texto .. "Página "..vetorJson.pagina_Livro.."|||Desbloquear|||Pagina"
		elseif vetorJson.objeto == "arquivo" then
			relatorio = relatorio..'| Desbloqueou o arquivo "'..vetorJson.objeto..'" da página'..vetorJson.pagina_Livro.." às ".. vetorJson.hora.."."
			historicoTxT.texto = historicoTxT.texto .. "Página "..vetorJson.pagina_Livro..'|||Desbloquear|||Arquivo: "'..vetorJson.objeto..'"'
		end
	end
	
	vetorJson.relatorio = relatorio
	relatorio = nil
end

function M.Historico_generico(atrib,historicoTxT,vetorJson)
	local relatorio = vetorJson.data
	vetorJson.tempo_aberto = atrib.tempo_aberto or nil
	vetorJson.tempo_aberto_pagina = atrib.tempo_aberto_pagina or nil
	vetorJson.pagina_anterior = atrib.pagina_anterior or nil
	
	if vetorJson.acao == "abrir livro" then
		relatorio = relatorio.."| Abriu o livro na página "..vetorJson.pagina_Livro.." às ".. vetorJson.hora.."."
		historicoTxT.texto = historicoTxT.texto .. "Página "..vetorJson.pagina_Livro.."|||Generica|||abrir livro"
	elseif vetorJson.acao == "fechar livro" then
		relatorio = relatorio.."| Fechou o livro na página"..vetorJson.pagina_Livro.." às ".. vetorJson.hora..". Pemaneceu nessa página por "..vetorJson.tempo_aberto_pagina..". Ficou com o livro aberto por ".. vetorJson.tempo_aberto
		historicoTxT.texto = historicoTxT.texto .. "Página "..vetorJson.pagina_Livro.."|||Generica|||fechar livro"
	elseif vetorJson.acao == "suspender livro" then
		relatorio = relatorio.."| Suspendeu a execução do livro na página"..vetorJson.pagina_Livro.." às ".. vetorJson.hora..". Pemaneceu nessa página por "..vetorJson.tempo_aberto_pagina..". Ficou com o livro aberto por ".. vetorJson.tempo_aberto
		historicoTxT.texto = historicoTxT.texto .. "Página "..vetorJson.pagina_Livro.."|||Generica|||suspender livro"
	elseif vetorJson.acao == "passar pagina" then
		relatorio = relatorio.."| Passou para a página"..vetorJson.pagina_Livro.." às ".. vetorJson.hora..", após permanecer na página "..vetorJson.pagina_anterior.." por "..vetorJson.tempo_aberto_pagina.." antes de mudar para a página atual."
		
		historicoTxT.texto = historicoTxT.texto .. "Página "..vetorJson.pagina_Livro.."|||Generica|||passar página"
	end
	
	vetorJson.relatorio = relatorio
	relatorio = nil
end

function M.Criar_e_salvar_vetor_historico(atrib)
	local vetorJson = {}
	local historicoTxT = {}
	historicoTxT.texto = ""
	local date = os.date( "*t" )
	vetorJson.data = date.day.."/"..date.month.."/"..date.year
	vetorJson.hora = date.hour..":"..date.min..":"..date.sec
	local pagina = nil
	
	if atrib.tela.contagemDaPaginaHistorico then
		pagina = auxFuncs.pegarNumeroPaginaRomanosHistorico(atrib.tela.contagemDaPaginaHistorico)
	end
	-- variaveis gerais comuns a todos --
	vetorJson.pagina_Livro = pagina or 0
	vetorJson.objeto_id = atrib.objeto_id
	vetorJson.tipoInteracao = atrib.tipoInteracao
	vetorJson.acao = atrib.acao
	vetorJson.historicoDicionario = atrib.tela.dicionario or nil
	vetorJson.palavraDicionario = atrib.tela.palavraDicionario or nil
	vetorJson.palavraDicHistorico = atrib.tela.palavraDicHistorico or nil
	vetorJson.rodape = atrib.rodape or nil
	vetorJson.card = atrib.card or nil
	vetorJson.dicionario = atrib.dicionario or nil
	
	if atrib.subPagina then
		vetorJson.subPagina = atrib.subPagina
	end
	-- especificas

	if vetorJson.tipoInteracao == "generica" then----------------------3
		M.Historico_generico(atrib,historicoTxT,vetorJson)
	elseif vetorJson.tipoInteracao == "questao" then-------------------2
		
	elseif vetorJson.tipoInteracao == "imagem" then
		M.Historico_imagem(atrib,historicoTxT,vetorJson)
	elseif vetorJson.tipoInteracao == "texto" then
		M.Historico_texto(atrib,historicoTxT,vetorJson)
	elseif vetorJson.tipoInteracao == "anotacao" then
		M.Historico_anotacao(atrib,historicoTxT,vetorJson)
	elseif vetorJson.tipoInteracao == "comentário" then
		M.Historico_comentario(atrib,historicoTxT,vetorJson)
	elseif vetorJson.tipoInteracao == "animação" then
		M.Historico_animacao(atrib,historicoTxT,vetorJson)
	elseif vetorJson.tipoInteracao == "audio" then
		M.Historico_audio(atrib,historicoTxT,vetorJson)
	elseif vetorJson.tipoInteracao == "botao" then---------------------1
		
	elseif vetorJson.tipoInteracao == "video" then
		M.Historico_video(atrib,historicoTxT,vetorJson)
	elseif vetorJson.tipoInteracao == "impressao" then
		M.Historico_impressao(atrib,historicoTxT,vetorJson)
	elseif vetorJson.tipoInteracao == "dicionário" then
		M.Historico_dicionario(atrib,historicoTxT,vetorJson)
	elseif vetorJson.tipoInteracao == "TTS" then
		M.Historico_tts(atrib,historicoTxT,vetorJson)
	elseif vetorJson.tipoInteracao == "deck" then
		M.Historico_card(atrib,historicoTxT,vetorJson)
	elseif vetorJson.tipoInteracao == "rodape" then
		M.Historico_rodape(atrib,historicoTxT,vetorJson)
	elseif vetorJson.tipoInteracao == "relatorio" then
		M.Historico_relatorio(atrib,historicoTxT,vetorJson)
	elseif vetorJson.tipoInteracao == "clearance" then
		M.Historico_clearance(atrib,historicoTxT,vetorJson)
	end
	
	M.escreverNoHistorico(atrib,historicoTxT.texto,vetorJson)
end

return M