local M = {}
local colocarFormatacaoTexto = require("colocarFormatacaoTexto")
local auxFuncs = require("ferramentasAuxiliares")
local conversor = require("conversores")
local validarUTF8 = require("utf8Validator")
local widget = require("widget")
local json = require("json")
local lfs = require "lfs"
local leituraTXT = require("leituraArquivosTxT")
local MenuRapido = require("MenuBotaoDireito")
local elemTela = require("elementosDaTela")
local W = display.viewableContentWidth ;
local H = display.viewableContentHeight;

function M.filtrarTextosDePagina(arquivoDoc)
	local function retirarControladores(aux)
		aux = string.gsub(aux,"[\\]+n","\n")
		aux = string.gsub(aux,"[\\]+","")
		aux = string.gsub(aux,"#t=%d+#","")
		aux = string.gsub(aux,"#/t=%d+#","")
		aux = string.gsub(aux,"#l%d+#","")
		aux = string.gsub(aux,"#/l%d+#","")
		aux = string.gsub(aux,"#s#","")
		aux = string.gsub(aux,"#/s#","")
		aux = string.gsub(aux,"#n#","")
		aux = string.gsub(aux,"#/n#","")
		aux = string.gsub(aux,"#i#","")
		aux = string.gsub(aux,"#/i#","")
		aux = string.gsub(aux,"#c=%d+,%d+,%d+#","")
		aux = string.gsub(aux,"#/c#","")
		aux = string.gsub(aux,"#audio=[^#]+#","")
		aux = string.gsub(aux,"#/audio#","")
		aux = string.gsub(aux,"#imagem=[^#]+#","")
		aux = string.gsub(aux,"#/imagem#","")
		aux = string.gsub(aux,"#video=[^#]+#","")
		aux = string.gsub(aux,"#/video#","")
		aux = string.gsub(aux,"#animacao=[^#]+#","")
		aux = string.gsub(aux,"#/animacao#","")
		--aux = string.gsub(aux,"#dic=[^#]+#","")
		--aux = string.gsub(aux,"#/dic=[^#]+#","")
		aux = string.gsub(aux,"#font=[^#]+#","")
		aux = string.gsub(aux,"#/font#","")
		aux = string.gsub(aux,"|t%d+%[","")
		return aux
	end
	local function procurarConteudo(vetorTodas,padrao)
		local vetorConteudos = {}
		for j=1,#vetorTodas do
			if not vetorTodas[j] then vetorTodas[j] = "" end
			local match = vetorTodas[j]:match("([^=]+)=")
			if not match then match = "" end
			if string.find( match, "texto" ) ~= nil then
				lixo,str = vetorTodas[j]:match("([^=]+)=+%s*([^\13]+)")
				if string.len(str) > 0 then
					vetorConteudos.texto = str
					vetorConteudos.textoComControladores = str
					vetorConteudos.texto, vetorConteudos.rodape = retirarControladores(vetorConteudos.texto)
				end
			end
			if string.find( match, "conteudo" ) ~= nil  then
				lixo,str = vetorTodas[j]:match("([^=]+)=+%s*([^\13]+)")
				if string.len(str) > 0 then
					local aux = str
					vetorConteudos.conteudo = aux
					vetorConteudos.conteudoComControladores = aux
					vetorConteudos.conteudo, vetorConteudos.rodape = retirarControladores(vetorConteudos.conteudo)
				end
			end
			if string.find( match, "enunciado" ) ~= nil  then
				lixo,str = vetorTodas[j]:match("([^=]+)=+%s*([^\13]+)")
				str = string.gsub(str,"\\n","\n")
				if string.len(str) > 0 then
					vetorConteudos.enunciado = str
					if string.gsub(str," ","") == "nil" then
						vetorConteudos.enunciado = ""
					end
				else
					table.insert(listaDeErros, "Arquivo: "..atributos.arquivo.. " -> Item - 'enunciado'".." está vazio")
					
					vetorConteudos.enunciado = ""
				end
			end
			if string.find( match, 'alternativas' ) ~= nil and not string.find( vetorTodas[j]:match("([^=]+)="), 'alternativas sorteadas' ) then
				vetorConteudos.alternativas = {}
				local arquivos = {}
				local xxy = 1
				lixo,str = vetorTodas[j]:match("([^=]+)=+%s*([^\13]+)")
				for past in string.gmatch(str, '([^|]+)') do
					vetorConteudos.alternativas[xxy] = past
					xxy = xxy + 1
				end
				if xxy-1 ~= vetorConteudos.numeroAlternativas then
				end
				local i = 1
				while i <= #vetorConteudos.alternativas do
					if string.len(vetorConteudos.alternativas[i]) < 1 then
						vetorConteudos.alternativas = {}
						i = #vetorConteudos.alternativas+1
					end
					i = i+1
				end
			end
			if string.find( match, 'justificativas' ) ~= nil then
				local arquivos = {}
				vetorConteudos.justificativas = {}
				vetorConteudos.justificativasComControladores = {}
				local xxy = 1
				lixo,str = vetorTodas[j]:match("([^=]+)=+%s*([^\13]+)")
				for past in string.gmatch(str, '([^|]+)') do
					vetorConteudos.justificativas[xxy] = past
					vetorConteudos.justificativasComControladores[xxy] = past
					vetorConteudos.justificativas[xxy], vetorConteudos.rodape = retirarControladores(vetorConteudos.justificativas[xxy])
					xxy = xxy + 1
				end
				if xxy-1 ~= vetorConteudos.numeroAlternativas then
				end
				local i = 1
				while i <= #vetorConteudos.justificativas do
					if string.len(vetorConteudos.justificativas[i]) < 1 then
						vetorConteudos.justificativas = {}
						i = #vetorConteudos.justificativas+1
					end
					i = i+1
				end
			end
			if string.find( string.lower(match), 'variáveis' ) ~= nil then
				local xxy = 1
				vetorConteudos.vars = {}
				vetorConteudos.varsComControladores = {}
				
				lixo,str = vetorTodas[j]:match("([^=]+)=+%s*([^\13]+)")
				str = string.gsub(str,"[ ]+","")
				for past in string.gmatch(str, '([^#]+)') do
					vetorConteudos.vars[xxy] = past
					vetorConteudos.varsComControladores = past
					vetorConteudos.vars[xxy], vetorConteudos.rodape = retirarControladores(vetorConteudos.vars[xxy])
					xxy = xxy + 1
				end
				local i = 1
				while i <= #vetorConteudos.vars do
					if string.len(vetorConteudos.vars[i]) < 1 then
						vetorConteudos.vars = {}
						i = #vetorConteudos.vars+1
					end
					i = i+1
				end
			end
		end
		return vetorConteudos
	end

	local textosPaginas = {}
	

	local function lerTextoArquivo(arquivo) -- vetor ou variavel
		local path = system.pathForFile( arquivo, system.ResourceDirectory )
			
		local file2, errorString = io.open( path, "r" )
		local xx = 1
		local vetor = {}
		
		if not file2 then
			print( "File error: " .. errorString )
		else
			local contents = file2:read( "*a" )
			local filtrado = string.gsub(contents,".",{ ["\13"] = "",["\10"] = "\13\10"})
			local is_valid, error_position = validarUTF8.validate(filtrado)
			if not is_valid then 
				--print('non-utf8 sequence detected at position ' .. tostring(error_position))
				filtrado = conversor.converterANSIparaUTFsemBoom(filtrado)
			end
			-- Output lines
			for line in string.gmatch(filtrado,"([^\13\10]+)") do
				vetor[xx] = line
				xx = xx+1
			end
			io.close( file2 )
			file2 = nil
		end
		return vetor
		
	end
	local imagens = 0--1
	local textos = 0
	local exercicios = 0
	local videos = 0
	local botoes = 0
	local sons = 0
	local animacoes = 0
	local separadores = 0
	local espacos = 0
	local imagemTextos = 0
	local vetorTodas = {{}}
	local vetorTela = {}
	vetorTela.ordemElementos = {}
	local textoNormal = false
	
	local function lerArquivoTela()
		local vetor = {}
		local path = system.pathForFile(arquivoDoc, system.DocumentsDirectory )
		
		local file, errorString = io.open( path, "r" )
		local xx=0
		local ignorar = true
		local comecou = 0
		local primeiro = false
		
		if not file then
			print( "File error: " .. errorString )
		else
			local primeiraLinha = false
			
			local contents = file:read( "*a" )
				
			
			local filtrado = string.gsub(contents,".",{ ["\13"] = "",["\10"] = "\13\10"})
			local is_valid, error_position = validarUTF8.validate(filtrado)
			if not is_valid then 
				filtrado = conversor.converterANSIparaUTFsemBoom(filtrado)
			end
			
			if not string.find(filtrado," *%d%d* *%- *%a+ *\13*\10") then
				textoNormal = filtrado
			end
			local um = 1
			for line in string.gmatch(filtrado,"([^\13\10]+)") do
				
				if string.len( line ) > 4 then
					local aux = tonumber(line:match("([^-]+)-"))
					if aux ~= nil then
						primeiro = false
						xx = 0
					end
					if aux ~= nil and primeiro == false then
						if string.find( line, "imagem" ) ~= nil then
							table.insert(vetorTela.ordemElementos,"imagem")
						elseif string.find( line, "texto" ) ~= nil then
							table.insert(vetorTela.ordemElementos,"texto")
						elseif string.find( line, "exercicio" ) ~= nil or string.find( line, "questao" ) ~= nil then
							table.insert(vetorTela.ordemElementos,"exercicio")
						elseif string.find( line, "video" ) ~= nil then
							table.insert(vetorTela.ordemElementos,"video")
						elseif string.find( line, "som" ) ~= nil then
							table.insert(vetorTela.ordemElementos,"som")
						elseif string.find( line, "botao" ) ~= nil then
							table.insert(vetorTela.ordemElementos,"botao")
						elseif string.find( line, "animacao" ) ~= nil then
							table.insert(vetorTela.ordemElementos,"animacao")
						elseif string.find( line, "espaco" ) ~= nil then
							table.insert(vetorTela.ordemElementos,"espaco")
						elseif string.find( line, "separador" ) ~= nil then
							table.insert(vetorTela.ordemElementos,"separador")
						elseif string.find( line, "imagemTexto" ) ~= nil then
							table.insert(vetorTela.ordemElementos,"imagemTexto")
						end
						primeiro = true
						
						if primeiraLinha == false then
							comecou = 1
							primeiraLinha = true
						else
							comecou = #vetorTodas+1
						end
						vetorTodas[comecou] = {}
						vetorTodas[comecou][0] = line

					elseif primeiro == true and string.find(line,"=") then
						linhaReduzida = line:match("=([^=]+)")
						local linhaFinal = ""
						if string.find( line, "texto" ) ~= nil or string.find( line, "arquivo" ) ~= nil then
							linhaFinal = linhaReduzida
						else
							local yy = 0
							for past in string.gmatch(linhaReduzida, '([A-Za-z0-9]+)') do
								linhaFinal = past
								yy = yy+1
							end
							local linhaFinalCor = {}
							local cor = false
							local c = 1
							if yy > 1 then
								for past in string.gmatch(linhaReduzida, '([0-9]+)') do
									linhaFinalCor[c] = past
									c = c+1
									cor = true
								end
							end
						end
						
						vetorTodas[comecou][xx] = line
					end
					xx = xx+1
				end
			end
			
			io.close( file )
		end
	end
	
	lerArquivoTela()
	if vetorTela ~= nil and vetorTela.ordemElementos ~= nil then
		for ord=1,#vetorTela.ordemElementos do
			local vetorConteudos = procurarConteudo(vetorTodas[ord])
			vetorConteudos.texto = vetorConteudos.texto or ""
			vetorConteudos.conteudo = vetorConteudos.conteudo or ""
			if not vetorTela[ord] then
				vetorTela[ord] = {}
			end
			if vetorTela.ordemElementos[ord] == "texto" then
				vetorTela[ord].tipo = vetorTela.ordemElementos[ord] .. " " .. textos
				vetorTela[ord].texto = vetorConteudos.texto
				textos = textos + 1
				--IDelemento = IDelemento + 1
			elseif vetorTela.ordemElementos[ord] == "imagem" then
				vetorTela[ord].tipo = vetorTela.ordemElementos[ord] .. " " .. imagens
				vetorTela[ord].texto = vetorConteudos.conteudo
				imagens = imagens + 1
				--IDelemento = IDelemento + 1
			elseif vetorTela.ordemElementos[ord] == "video" then
				vetorTela[ord].tipo = vetorTela.ordemElementos[ord] .. " " .. videos
				vetorTela[ord].texto = vetorConteudos.conteudo
				videos = videos + 1
				--IDelemento = IDelemento + 1
			elseif vetorTela.ordemElementos[ord] == "animacao" then
				vetorTela[ord].tipo = vetorTela.ordemElementos[ord] .. " " .. animacoes
				vetorTela[ord].texto = vetorConteudos.conteudo
				animacoes = animacoes + 1
				--IDelemento = IDelemento + 1
			elseif vetorTela.ordemElementos[ord] == "som" then
				vetorTela[ord].tipo = vetorTela.ordemElementos[ord] .. " " .. sons
				vetorTela[ord].texto = vetorConteudos.conteudo
				sons = sons + 1
				--IDelemento = IDelemento + 1
			elseif vetorTela.ordemElementos[ord] == "exercicio" then
				vetorTela[ord].tipo = vetorTela.ordemElementos[ord] .. " " .. exercicios
				vetorTela[ord].texto = ""
				if vetorConteudos.enunciado then
					vetorTela[ord].texto = vetorConteudos.enunciado
				end
				if vetorConteudos.alternativas then
					for alt=1,#vetorConteudos.alternativas do
						if vetorConteudos.alternativas[alt] and type(vetorConteudos.alternativas[alt]) == "string" then
							vetorTela[ord].texto = vetorTela[ord].texto .. "\n" .. vetorConteudos.alternativas[alt]
						end
					end
				end
				if vetorConteudos.justificativas then
					for alt=1,#vetorConteudos.justificativas do
						vetorTela[ord].texto = vetorTela[ord].texto .. "\n" .. vetorConteudos.justificativas[alt]
					end
				end
				exercicios = exercicios + 1
				--IDelemento = IDelemento + 1
			elseif vetorTela.ordemElementos[ord] == "botao" then
				vetorTela[ord].tipo = vetorTela.ordemElementos[ord] .. " " .. botoes
				vetorTela[ord].texto = vetorConteudos.conteudo .. "\n" .. vetorConteudos.texto
				botoes = botoes + 1
			end
		end
	end
	
	local textosPagina = ""
	for txts=1,#vetorTela do
		
		if vetorTela[txts].texto then
			textosPagina = textosPagina .. vetorTela[txts].texto .. " "
		end
	end
	vetorTela.ordemElementos = {}
	textosPagina = string.gsub(textosPagina,".",{ ["\13"] = " ",["\10"] = "\13\10"})
	if textoNormal then textosPagina = textoNormal end
	
	return textosPagina
end

function M.filtrarPalavrasDeTextos(texto)
	local vetor = {}
	local testarRepetido = {}
	texto = string.gsub(texto,".",{ ["\13\10"] = " "})
	texto = string.gsub(texto,"\n"," ")
	for word in string.gmatch(texto,"([^%s]+)") do
		
		word = conversor.stringLowerAcento(word)
		word = string.gsub(word,"[%p%d]+","") -- depois tirar e arrumar os filtros para alphanumericos, elementos quimicos, acordes, etc
		if string.sub(word,#word,#word) == ")" and string.sub(word,1,1) ~= "(" then
			word = string.sub(word,1,#word-1)
		
		elseif string.sub(word,#word,#word) ~= ")" and string.sub(word,1,1) == "(" then
			word = string.sub(word,2,#word)
		elseif string.sub(word,#word,#word) == ")" and string.sub(word,1,1) == "(" then
			-- nothing
		elseif string.match(string.sub(word,#word,#word),"%p") then
			word = string.sub(word,1,#word-1)
		end
		if string.find(word,"%d+%p+%d*%p*%d*%p*%d*%p*%d*%p*%d*%p*") then
			local index1,index2 = string.find(word,"%d+%p+d*%p*%d*%p*%d*%p*%d*%p*%d*%p*")
			word = string.sub(word,index2+1,#word)
		end
		
		local lastChar = string.sub(word,#word,#word) 
		if lastChar == "%." or lastChar == "," or lastChar == ":" or lastChar == ";" or lastChar == "%?" or lastChar == "%!" then
			word = string.sub(word,1,#word-1)
		end
		if not testarRepetido[word] and string.find(word,"%a") and #word > 1 then
			table.insert(vetor,word)
			testarRepetido[word] = true
		end
	end
	--vetor = auxFuncs.Alphanumsort(vetor)
	return vetor
end

-- url = "https://omniscience42.com/EAudioBookDB/upload.php"
--contentType = "text/plain" another option is "image/jpeg" or "application/json"
function M.uploadFiles(atrib)
	local function uploadListener( event )
		   if ( event.isError ) then
			  print( "Network Error." )
		 
			  -- This is likely a time out or server being down. In other words,
			  -- It was unable to communicate with the web server. Now if the
			  -- connection to the web server worked, but the request is bad, this
			  -- will be false and you need to look at event.status and event.response
			  -- to see why the web server failed to do what you want.
			  if atrib.aposFalhar then
				atrib.aposFalhar()
			  end
		   else
			  if ( event.phase == "began" ) then
				 print( "Upload started" )
			  elseif ( event.phase == "progress" ) then
				 print( "Uploading... bytes transferred ", event.bytesTransferred )
			  elseif ( event.phase == "ended" ) then
				 print( "Upload ended..." )
				 print( "Status:", event.status )
				 print( "Response:", event.response )
				 if atrib.aposEnviar then
					atrib.aposEnviar()
				 end
			  end
		   end
		end
		print("atrib.pasta",atrib.pasta)
		local url = "https://coronasdkgames.com/Onisciencia 42/Livros/"..atrib.pasta.."/upload.php"
		print("url = "..url)
		--local url = "https://omniscience42.com/EAudioBookDB/uploadHistorico.php"
		local method = "PUT"
		 
		local params = {
		   timeout = 60,
		   progress = true,
		   bodyType = "binary"
		}
		local filename = atrib.arquivo
		local baseDirectory = system.DocumentsDirectory
		local contentType = "text/plain"  --another option is "image/jpeg"

		local headers = {}
		headers.filename = filename
		params.headers = headers
		 
		network.upload( url , method, uploadListener, params, filename, baseDirectory, contentType )
end

function M.verificarPastaOuCriar(pasta)
	local function listener( event )
		if ( event.isError ) then
			print("error!!!!",event.isError)
		else
			if string.find(tostring(event.response),"Pasta encontrada") then -- achou
				-- atualizar o arquivo de upload
				print("achou a pasta",event.response)
				local function cadastroListener( event )
					if ( event.isError ) then
						print("error!!!!",event.isError)
					else
						print("pasta criada",event.response)
					end
				end
				-- criar pasta com upload.php
				local parameters = {}
				parameters.body = "Copy_upload&codigoLivro="..pasta
				local URL2 = "https://coronasdkgames.com/Onisciencia 42/ManejarPastaLivros.php"
				network.request(URL2, "POST", cadastroListener,parameters)
			else
				print("não achou a pasta")
				local function cadastroListener( event )
					if ( event.isError ) then
						print("error!!!!",event.isError)
					else
						print("pasta criada",event.response)
					end
				end
				-- criar pasta com upload.php
				local parameters = {}
				parameters.body = "Register&codigoLivro="..pasta
				local URL2 = "https://coronasdkgames.com/Onisciencia 42/ManejarPastaLivros.php"
				network.request(URL2, "POST", cadastroListener,parameters)
			end
		end
	end
	local parameters = {}
	parameters.body = "Existe=true"
	local URL2 = "https://coronasdkgames.com/Onisciencia 42/Livros/"..pasta.."/upload.php"
	network.request(URL2, "POST", listener,parameters)
end

function M.verificarArquivoPastaEBaixarSeNaoBaixou(atrib)
	-- primeiro verificar se já baixou
	local pasta = atrib.pasta
	local arquivo = atrib.arquivo
	if auxFuncs.fileExistsDoc(arquivo) then
		atrib.onComplete(atrib.arquivo,"sucesso")
	else
		M.downloadFiles({pasta = pasta, arquivo = arquivo,onComplete = atrib.onComplete})
	end
end

function M.downloadFiles(atrib)
	local function networkListener( event )
		if ( event.isError ) then
			print( "Network error - download failed: " )
			
			atrib.onComplete(atrib.arquivo,tostring(event.response))
		elseif ( event.phase == "began" ) then
			print( "Progress Phase: began" )
		elseif ( event.phase == "ended" ) then
			print( "Progress Phase: ended. File: ",event.response.filename )
			if event.response.filename == nil then
				atrib.onComplete(atrib.arquivo,"Não foi criado um arquivo anteriormente.")
			else
				atrib.onComplete(atrib.arquivo,"sucesso")
			end
		end
	end
	print("Novo Arquivo = ",atrib.novoArquivo)
	
	local params = {}
	params.progress = true
	local arquivo = atrib.arquivo
	local url = "https://coronasdkgames.com/Onisciencia 42/Livros/"..atrib.pasta.."/"..arquivo
	if atrib.novoArquivo then arquivo = atrib.novoArquivo end
	network.download(
		url,
		"GET",
		networkListener,
		params,
		arquivo,
		--atrib.arquivo,
		system.DocumentsDirectory
	)
end

function M.checarMostrarTxTAudioImageVideo(atrib)
	local pasta = atrib.pasta
	local arquivo = atrib.arquivo
	local tipo = atrib.tipo
	
	local grupo = display.newGroup()
	
	function grupo.AposVerificarEBaixar(arqui,resposta)
		if resposta == "sucesso" then
			native.showAlert("Arquivo encontrado","criando botão de novo upload e vizualizar arquivo",{"OK"})
		else
			native.showAlert("Arquivo não encontrado","motivo: "..resposta,{"OK"})
		end
	end
	
	if tipo then
		print(pasta)
		print(tipo)
		M.verificarPastaOuCriar(pasta)
		if tipo == "texto" then
			M.verificarArquivoPastaEBaixarSeNaoBaixou({pasta = pasta,arquivo = arquivo,onComplete = grupo.AposVerificarEBaixar})
		elseif tipo == "imagem" then
			M.verificarArquivoPastaEBaixarSeNaoBaixou({pasta = pasta,arquivo = arquivo,onComplete = grupo.AposVerificarEBaixar})
		elseif tipo == "audio" then
			M.verificarArquivoPastaEBaixarSeNaoBaixou({pasta = pasta,arquivo = arquivo,onComplete = grupo.AposVerificarEBaixar})
		elseif tipo == "video" then
			M.verificarArquivoPastaEBaixarSeNaoBaixou({pasta = pasta,arquivo = arquivo,onComplete = grupo.AposVerificarEBaixar})
		end
	end
	
	return grupo
end

function M.abrirEdicaoCC(event)
	local botao = event.target
	local tipo = botao.tipo
	
	-- UM CLIQUE
	if botao.clicado == false  then
		print("um clique")
		audio.stop()
		media.stopSound()
		local som = audio.loadStream("TTS_cliqueDuasVezes.mp3")
		timerRequerimento = timer.performWithDelay(16,function() audio.play(som) end,1)
		botao.clicado = true
		timer.performWithDelay(1000,function() botao.clicado = false end,1)
		return true
	end
	-- DOIS CLIQUES
	if botao.clicado == true then
		audio.stop()
		media.stopSound()
		print("dois cliques")
		botao.G = display.newGroup()
		local vetorPalavrasA = {}
		local vetorPalavrasP = {}
		local pastaPrincipal = event.target.pasta
		botao.G.editarPalavra = function(event2)
			
			
			
			if event2.phase == "release" then
				local GEdicao = display.newGroup()
				local row = event2.row
				local palavraEscolhida = row.params.results
			
				GEdicao.MenuConfig = display.newImageRect("menuPagina.png",W+60,H-100)
				GEdicao.MenuConfig.x,GEdicao.MenuConfig.y = W/2,H/2
				GEdicao.MenuConfig.isHitTestable = true
				GEdicao.MenuConfig.clicado = false
				GEdicao.MenuConfig:addEventListener("tap",function()return true end)
				GEdicao.MenuConfig:addEventListener("touch",function()return true end)
				GEdicao:insert(GEdicao.MenuConfig)
				
				GEdicao.voltarMenuConfig = function(evento)
					if evento.target.clicado == false  then
						audio.stop()
						media.stopSound()
						timer.performWithDelay(1000,function() evento.target.clicado = false end,1)
						local som = audio.loadStream("TTS_cliqueDuasVezes.mp3")
						audio.play(som)
						evento.target.clicado = true
					end
					if evento.target.clicado == true then
						evento.target.clicado = false
						audio.stop()
						media.stopSound()
						
						GEdicao:removeSelf()
						GEdicao = nil
					end
					return true
				end
				
				GEdicao.voltar = widget.newButton {
					onRelease = GEdicao.voltarMenuConfig,
					emboss = false,
					width = 70,
					height = 70,
					-- Properties for a rounded rectangle button
					defaultFile = "arrow.png",
					overFile = "arrowD.png"
				}
				GEdicao.voltar.clicado = false
				GEdicao.voltar.rotation = 180
				GEdicao.voltar.anchorX=0.5
				GEdicao.voltar.anchorY=0
				GEdicao.voltar.x = 95
				GEdicao.voltar.y = 240
				GEdicao:insert(GEdicao.voltar)
				
				GEdicao.fecharMenuConfig = function(evento)
					if evento.target.clicado == false  then
						
						audio.stop()
						media.stopSound()
						timer.performWithDelay(1000,function() evento.target.clicado = false end,1)
						local som = audio.loadStream("TTS_cliqueDuasVezes.mp3")
						audio.play(som)
						evento.target.clicado = true
					end
					if evento.target.clicado == true then
						evento.target.clicado = false
						audio.stop()
						media.stopSound()
						
						GEdicao.fechar:setEnabled(false)
						botao.G.fechar:setEnabled(false)
						local som = audio.loadStream("TTS_fechando.mp3")
						local function onComplete()
							GEdicao:removeSelf()
							GEdicao = nil
							botao.G:removeSelf()
						end
						botao.G.fechar:removeEventListener("tap",botao.G.fecharMenuConfig)
						evento.target:removeEventListener("tap",GEdicao.fecharMenuConfig)
						timerRequerimento = timer.performWithDelay(16,function() audio.play(som,{onComplete = onComplete}) end,1)
						audio.stop()
						media.stopSound()
						
						
						
					end
					return true
				end
				
				GEdicao.fechar = widget.newButton {
					onRelease = GEdicao.fecharMenuConfig,
					emboss = false,
					-- Properties for a rounded rectangle button
					defaultFile = "closeMenuButton2.png",
					overFile = "closeMenuButton2D.png"
				}
				GEdicao.fechar.clicado = false
				GEdicao.fechar.anchorX=1
				GEdicao.fechar.anchorY=0
				GEdicao.fechar.x = W - 55
				GEdicao.fechar.y = 173
				GEdicao:insert(GEdicao.fechar)
				
				-- Create the widget
				
				 
				-- Create a image and insert it into the scroll view
				local background = display.newRect(w/2,700, 450, 600 )
				background.anchorX=0.5
				background.anchorY=0.5
				background:setFillColor(1,1,1)
				GEdicao:insert(background)
				
				GEdicao.botaoUpImg = auxFuncs.createNewButton({
					width = 200,
					height = 50,
					shape = "roundedRect",
					radius = 5,
					label = "Image",
					size = 38,
					font = "Fontes/neuropol.ttf",
					strokeWidth = 2,
					fillColor = {default = {1,1,1,1},over = {1,1,1,.7}},
					strokeColor = {default = {0,0,0,1},over = {0,0,0,.7}},
					labelColor = {default = {0,0,0,1},over = {0,0,0,.7}},
					onRelease = function(event3)
						local tipo = event3.target.tipo
						local arquivo = palavraEscolhida.."_"..tipo..".txt"
						local pastaPalavra = pastaPrincipal.."/"..palavraEscolhida
						if auxFuncs.fileExistsDoc(arquivo) then
							local content = auxFuncs.lerTextoDoc(arquivo)
							M.checarMostrarTxTAudioImageVideo({pasta = pastaPalavra,tipo = tipo,arquivo = content})
						else
							-- verificar txt nuvem e pegar conteudo
							local tentativas = 1
							local function onCompleteDownload(arqui,response)
								if response then
									if response == "Não foi criado um arquivo anteriormente." then
										print("Aqui 1")
										auxFuncs.criarTxTDoc(arquivo,"")
										M.uploadFiles({
											arquivo = arquivo,
											pasta = pastaPalavra
										})
									elseif response == "sucesso" then
										print("Aqui 2")
										local arquivoBaixado = auxFuncs.lerTextoDoc(arquivo)
										print("|"..arquivoBaixado.."|")
									elseif tentativas <=3 then
										-- tentar de novo
										print("Aqui 3")
										tentativas = tentativas+1
										M.downloadFiles({pasta=pastaPalavra,arquivo=arquivo,onComplete=onCompleteDownload})
									else
										native.showAlert("Atenção!","Verifique sua conexão com a internet e tente novamente!",{"OK"})
									end
								end
							end
							print("Aqui 0")
							M.downloadFiles({pasta=pastaPalavra,arquivo=arquivo,onComplete=onCompleteDownload})
							-- senão tiver conteudo ou n tiver arquivo
							
						end
					end
				})
				GEdicao.botaoUpImg.btn.tipo = "imagem"
				GEdicao.botaoUpImg.x = 240
				GEdicao.botaoUpImg.y = 350
				GEdicao:insert(GEdicao.botaoUpImg)
				
				GEdicao.botaoUpVideo = auxFuncs.createNewButton({
					width = 200,
					height = 50,
					shape = "roundedRect",
					radius = 5,
					label = "Video",
					size = 38,
					font = "Fontes/neuropol.ttf",
					strokeWidth = 2,
					fillColor = {default = {1,1,1,1},over = {1,1,1,.7}},
					strokeColor = {default = {0,0,0,1},over = {0,0,0,.7}},
					labelColor = {default = {0,0,0,1},over = {0,0,0,.7}},
					onRelease = function(event3)
						M.checarMostrarTxTAudioImageVideo({pasta = pastaPrincipal.."/"..palavraEscolhida,tipo = "video",arquivo = palavraEscolhida..".mp4"}) 
					end
				})
				GEdicao.botaoUpVideo.btn.tipo = "video"
				GEdicao.botaoUpVideo.x = GEdicao.botaoUpImg.x + GEdicao.botaoUpImg.width/2 + GEdicao.botaoUpVideo.width/2 + 20
				GEdicao.botaoUpVideo.y = GEdicao.botaoUpImg.y
				GEdicao:insert(GEdicao.botaoUpVideo)
				
				GEdicao.botaoUpTxt = auxFuncs.createNewButton({
					width = 200,
					height = 50,
					shape = "roundedRect",
					radius = 5,
					label = "Texto",
					size = 38,
					font = "Fontes/neuropol.ttf",
					strokeWidth = 2,
					fillColor = {default = {1,1,1,1},over = {1,1,1,.7}},
					strokeColor = {default = {0,0,0,1},over = {0,0,0,.7}},
					labelColor = {default = {0,0,0,1},over = {0,0,0,.7}},
					onRelease = function(event3)
						M.checarMostrarTxTAudioImageVideo({pasta = pastaPrincipal.."/"..palavraEscolhida,tipo = "texto",arquivo = palavraEscolhida..".txt"}) 
					end
				})
				GEdicao.botaoUpTxt.btn.tipo = "texto"
				GEdicao.botaoUpTxt.x = GEdicao.botaoUpImg.x
				GEdicao.botaoUpTxt.y = 270
				GEdicao:insert(GEdicao.botaoUpTxt)
				
				GEdicao.botaoUpAud = auxFuncs.createNewButton({
					width = 200,
					height = 50,
					shape = "roundedRect",
					radius = 5,
					label = "Audio",
					size = 38,
					font = "Fontes/neuropol.ttf",
					strokeWidth = 2,
					fillColor = {default = {1,1,1,1},over = {1,1,1,.7}},
					strokeColor = {default = {0,0,0,1},over = {0,0,0,.7}},
					labelColor = {default = {0,0,0,1},over = {0,0,0,.7}},
					onRelease = function(event3)
						M.checarMostrarTxTAudioImageVideo({pasta = pastaPrincipal.."/"..palavraEscolhida,tipo = "audio",arquivo = palavraEscolhida..".mp3"}) 
					end
				})
				GEdicao.botaoUpAud.btn.tipo = "audio"
				GEdicao.botaoUpAud.x = GEdicao.botaoUpTxt.x + GEdicao.botaoUpTxt.width/2 + GEdicao.botaoUpAud.width/2 + 20
				GEdicao.botaoUpAud.y = GEdicao.botaoUpTxt.y
				GEdicao:insert(GEdicao.botaoUpAud)
			end
		end
		botao.G.gerarLinha = function( event )
			local phase = event.phase
			local row = event.row
			local groupContentHeight = row.contentHeight
			
			local result = row.params.results
			local tipo1 = row.params.tipo1
			local tipo2 = row.params.tipo2
		 
			local rowHeight = row.contentHeight
			local rowWidth = row.contentWidth
			local linhaSuperior = display.newRect(row,rowWidth/2,0,rowWidth,2)
			linhaSuperior:setFillColor(0,0,0)

			local palavra = result
			if not palavra then palavra = "" end
			
			row.editar = native.newTextField(5,0,5*rowWidth/9, rowHeight )
			row:insert(row.editar)
			row.editar.text = palavra
			row.editar.x = 5
			row.editar.anchorX = 0
			row.editar.y = groupContentHeight * 0.5
			row.editar.isVisible = false
			row.rowTitle = display.newText( row, palavra,0,0,3*rowWidth/5,0,"Fontes/segoeui.ttf", 30 )
			row.rowTitle.x = 10
			row.rowTitle.anchorX = 0
			row.rowTitle.y = groupContentHeight * 0.5
			row.rowTitle:setFillColor(0,0,0)
			
			local bWidth = 40
			local alpha = .2
			
			row.titleHeight = row.rowTitle.height 
			local function  marcarPalavra(e)
				local btn = e.target
				if e.target.tipo == "deletar" then
					
					row.botaoConceito.alpha = alpha
					row.botaoConceito.ativado = false
					row.botaoConhecimento.alpha = alpha
					row.botaoConhecimento.ativado = false
					row.botaoAulaK.alpha = alpha
					row.botaoAulaK.ativado = false
					row.botaoAulaC.alpha = alpha
					row.botaoAulaC.ativado = false
					
					vetorPalavras[row.index][2] = false
					vetorPalavras[row.index][3] = false
					vetorPalavras[row.index][4] = false
					vetorPalavras[row.index][5] = false
				elseif e.target.ativado then
					e.target.alpha = alpha
					e.target.ativado = false
					vetorPalavras[row.index][btn.indexR] = false
				elseif not e.target.ativado then
					e.target.alpha = 1
					e.target.ativado = true
					vetorPalavras[row.index][btn.indexR] = true
				end
			end
			row.botaoDeletar = widget.newButton {
				shape= "roundedRect",
				fillColor = {default = {192/255,0/255,0/255},over = {168/510,10/510,10/510}},
				labelColor = {default = {0,0,0},over = {0,0,0,0.5}},
				labelAlign = "center",
				label = "X",
				font = "Fontes/arial.ttf",
				fontSize = 30,
				width = 25,
				height = rowHeight-2,
				onRelease = marcarPalavra
			}
			row.botaoDeletar.tipo = "deletar"
			row.botaoDeletar.y = 2+row.botaoDeletar.height/2
			row.botaoDeletar.x = row.width - row.botaoDeletar.width/2
			row.botaoDeletar.isVisible = false
			row:insert(row.botaoDeletar)
			if tipo1 == "conceitos" then
				if tipo2 == "P" then
					row.Tipo = display.newText(row,"p",0,0,"Fontes/paolaAccent.ttf",40)
					row.Tipo.anchorX=1
					row.Tipo.x = row.botaoDeletar.x - row.botaoDeletar.width/2 - 10
					row.Tipo.y = rowHeight/2
					row.Tipo:setFillColor(0,0,0)
				else
					row.Tipo = display.newImageRect(row,"criarConceito.png",40,40)
					row.Tipo.x = row.botaoDeletar.x - row.botaoDeletar.width/2 - 10 - 20
					row.Tipo.y = rowHeight/2
				end
			elseif tipo1 == "conhecimentos" then
				if tipo2 == "P" then
					row.Tipo = display.newText(row,"p",0,0,"Fontes/paolaAccent.ttf",40)
					row.Tipo.anchorX=1
					row.Tipo.x = row.botaoDeletar.x - row.botaoDeletar.width/2 - 10
					row.Tipo.y = rowHeight/2
					row.Tipo:setFillColor(0,0,0)
				else
					row.Tipo = display.newImageRect(row,"criarConhecimento.png",40,40)
					row.Tipo.x = row.botaoDeletar.x - row.botaoDeletar.width/2 - 10 - 20
					row.Tipo.y = rowHeight/2
				end
			end

			local linhaInferior = display.newRect(row,rowWidth/2,groupContentHeight,rowWidth,2)
			linhaInferior:setFillColor(0,0,0)
		end
		
		
		botao.G.telaProtetiva = auxFuncs.TelaProtetiva()
		botao.G.telaProtetiva.alpha = .5
		botao.G:insert(botao.G.telaProtetiva)
		botao.G.MenuConfig = display.newImageRect("menuPagina.png",W+60,H-100)
		botao.G.MenuConfig.x,botao.G.MenuConfig.y = W/2,H/2
		botao.G.MenuConfig.isHitTestable = true
		botao.G.MenuConfig.clicado = false
		botao.G.MenuConfig:addEventListener("tap",function()return true end)
		botao.G.MenuConfig:addEventListener("touch",function()return true end)
		botao.G:insert(botao.G.MenuConfig)
		
		local titulo = string.upper(tipo)
		
		botao.G.titulo = display.newText(botao.G,titulo,70,185,0,0,"Fontes/paolaAccent.ttf",60)
		botao.G.titulo.anchorY=0
		botao.G.titulo.anchorX=0
		botao.G.titulo:setFillColor(168/255,10/255,10/255)
		
		-- criar table
		botao.G.tableViewResults = widget.newTableView(
			{
				height = 600,
				width = 600,
				onRowRender = botao.G.gerarLinha,
				onRowTouch = botao.G.editarPalavra,
				listener = scrollListener,
				rowTouchDelay =0
			}
		)
		botao.G.tableViewResults.x = W/2
		botao.G.tableViewResults.y = 400 + botao.G.tableViewResults.height/2
		botao.G:insert(botao.G.tableViewResults)
		
		
		botao.G.createAllRows = function()
			for i=1,#vetorPalavrasA do
				
				local lixo = display.newText( vetorPalavrasA[i],0,0,3*botao.G.tableViewResults.width/5,0,"Fontes/segoeui.ttf", 30 )
				local height = lixo.height
				lixo:removeSelf()
				lixo = nil
				print("Nova altura da linha criar A"..i.." = ",height + 15)
				botao.G.tableViewResults:insertRow{rowHeight = height + 15,params = {results = vetorPalavrasA[i],tipo1 = tipo,tipo2 = "A"}}
			end
			for i=1,#vetorPalavrasP do
				
				local lixo = display.newText( vetorPalavrasP[i],0,0,3*botao.G.tableViewResults.width/5,0,"Fontes/segoeui.ttf", 30 )
				local height = lixo.height
				lixo:removeSelf()
				lixo = nil
				print("Nova altura da linha criar P"..i.." = ",height + 15)
				botao.G.tableViewResults:insertRow{rowHeight = height + 15,params = {results = vetorPalavrasP[i],tipo1 = tipo,tipo2 = "P"}}
			end
		end
		
		local function onCompleteDownload(arquivo)
			local function onCompleteDownload2(arquivo2)
				print("onCompleteDownload2",arquivo2)
				if auxFuncs.fileExistsDoc(arquivo2) then
					print("ExisteP")
					vetorPalavrasP = auxFuncs.loadTable(arquivo2)
					print("nova table P = ",vetorPalavrasA,#vetorPalavrasA)
				end
				botao.G.createAllRows()
			end
			if auxFuncs.fileExistsDoc(arquivo) then
				print("ExisteA")
				vetorPalavrasA = auxFuncs.loadTable(arquivo)
				print("nova table A = ",vetorPalavrasA,#vetorPalavrasA)
			end
			if botao.tipo == "conceitos" then
				M.downloadFiles({
					arquivo = botao.vetorNomes[3],
					pasta = botao.pasta,
					onComplete = onCompleteDownload2
				})
			elseif botao.tipo == "conhecimentos" then
				M.downloadFiles({
					arquivo = botao.vetorNomes[4],
					pasta = botao.pasta,
					onComplete = onCompleteDownload2
				})
			end
			
		end
		
		if botao.tipo == "conceitos" then
			M.downloadFiles({
				arquivo = botao.vetorNomes[1],
				pasta = botao.pasta,
				onComplete = onCompleteDownload
			})
		elseif botao.tipo == "conhecimentos" then
			M.downloadFiles({
				arquivo = botao.vetorNomes[2],
				pasta = botao.pasta,
				onComplete = onCompleteDownload
			})
		end
		
		-- criar botão de fechar
		botao.G.fecharMenuConfig = function(evento)
			if evento.target.clicado == false  then
				
				audio.stop()
				media.stopSound()
				timer.performWithDelay(1000,function() evento.target.clicado = false end,1)
				local som = audio.loadStream("TTS_cliqueDuasVezes.mp3")
				audio.play(som)
				evento.target.clicado = true
			end
			if evento.target.clicado == true then
				evento.target.clicado = false
				audio.stop()
				media.stopSound()
				
				
				botao.G.fechar:setEnabled(false)
				local som = audio.loadStream("TTS_fechando.mp3")
				local function onComplete()
					botao.G:removeSelf()
				end
				evento.target:removeEventListener("tap",botao.G.fecharMenuConfig)
				timerRequerimento = timer.performWithDelay(16,function() audio.play(som,{onComplete = onComplete}) end,1)
				audio.stop()
				media.stopSound()
				
				
				
			end
			return true
		end
		
		botao.G.fechar = widget.newButton {
			onRelease = botao.G.fecharMenuConfig,
			emboss = false,
			-- Properties for a rounded rectangle button
			defaultFile = "closeMenuButton2.png",
			overFile = "closeMenuButton2D.png"
		}
		botao.G.fechar.clicado = false
		botao.G.fechar.anchorX=1
		botao.G.fechar.anchorY=0
		botao.G.fechar.x = W - 55
		botao.G.fechar.y = 173
		botao.G:insert(botao.G.fechar)
		
		botao.clicado = false
	end
end

function M.htmlScript(dados,numero)
	local palavra = dados.palavra
	local caminho = "palavras/"..palavra
	local tipo = dados.tipo
	local listaArquivos = {}
	local numeroMaior = 0
	if dados.lista and dados.lista[3] then
		listaArquivos.textos = dados.textos
		numeroMaior = #listaArquivos.textos
		listaArquivos.imagens = dados.imagens
		if #listaArquivos.imagens > numeroMaior then numeroMaior = #listaArquivos.imagens end
		listaArquivos.audios = dados.audios
		if #listaArquivos.audios > numeroMaior then numeroMaior = #listaArquivos.audios end
		listaArquivos.videos = dados.videos
		if #listaArquivos.videos > numeroMaior then numeroMaior = #listaArquivos.videos end
	end
	local texto = ""
	local fontTitle = "arial"
	local fontText = "arial"
	local html = ""
	local function addTitleLine(text)
		return '\n<h2 align= "left" style= "color:red; font-family:'..fontTitle..'">' .. text .. "</h2>\n<br>"
	end
	local function addTextLine(text)
		return '\n<h2 align= "left" style= "color:black; font-family:'..fontText..'">' .. text .. "</h2>"
	end
	local function addLink(link)
		return '\n <a href="'..link..'">'..'</a>'
	end
	local function addTextLineRed(text)
		return '\n <h2 align= "left" style= "color:red; font-family:'..fontText..'">' .. text .. "</h2>"
	end
	local function addImage(image)
		return '\n <br><img src="'..caminho.."/"..image..'">'
	end
	local function addImageWithLink(image,link)
		return ' <br><a href="'..link..'"> <img src= natali.jpg border="none" /></a>'
	end
	local function addAudio(audio)
		return ' <br><audio src="'..audio..'" controls></audio>'
	end
	local function addVideo(video)
		return ' <br><video src="'..video..'" controls></video>'
	end
	local function addYouTube(videoY)
		videoY = string.gsub(videoY,"\10","")
		videoY = string.gsub(videoY,"\13","")
		videoY = string.gsub(videoY,"/watch%?v=","/embed/")
		videoY = string.gsub(videoY,"https://youtu.be/","https://www.youtube.com/embed/")
		return '\n<br><iframe width="640" height="360" src="'..videoY..'" frameborder="0" allowfullscreen></iframe>'
	end
	
	texto = texto .. '\n<h1 align= "left" style= "color:red; font-family:'..fontTitle..'">'.. numero .. " - " .. palavra .. '</h1>\n'
	texto = texto .. addTitleLine("("..tipo..")") .. "\n<br>\n"
	
	if not dados.lista or not dados.lista[3] then
		addTextLine("Assunto sem conteúdo!\nO conteudísta ainda esta criando um material para este assunto,\npor favor aguarde novas atualizações da instituição!")
	else
		print("palavra = ",palavra)
		for i=1,numeroMaior do
			print("listaArquivos.textos",listaArquivos.textos,#listaArquivos.textos)
			if listaArquivos.textos[i] then
				texto = texto .. addTextLine(listaArquivos.textos[i])
			end
			if listaArquivos.imagens[i] then
				texto = texto .. addImage(listaArquivos.imagens[i])
			end
			if listaArquivos.audios[i] then
				texto = texto .. addAudio(listaArquivos.audios[i])
			end
			if listaArquivos.videos[i] then
				if not string.find(listaArquivos.videos[i][1],".mp4") or  not string.find(listaArquivos.videos[i][1],".MP4") then
					texto = texto .. addYouTube(listaArquivos.videos[i][1])
				else
					texto = texto .. addVideo(listaArquivos.videos[i][1])
				end
				if listaArquivos.videos[i][2] then
					texto = texto .. addTextLine(listaArquivos.videos[i][2])
				end
			end
		end
	end
	return texto.."\n\n"
end

function M.GerarTelaeHTML(atrib)
	
	local palavras = {}
	for i=1,#atrib.palavras do
		-- 1- palavra, 2- tipo, 3- selecionada
		if atrib.palavras[i][3] == true then
			table.insert(palavras,atrib.palavras[i])
		end
	end
	local pastaPrincipal = atrib.pastaPrincipal
	local count = 1
	print(pastaPalavra)
	if palavras[count] and palavras[count][1] and palavras[count][2] then
		local pastaPalavra = pastaPrincipal.."/palavras/"..palavras[count][1].." "..palavras[count][2]
		local lista = pastaPalavra
		
		-- 1 - primeiro listar arquivos das palavras e ir guardando em um vetor
		local contador = 1
		local tentativas = 1
		local function listener( event )

			if ( event.isError ) then
				  --local alert = native.showAlert( "Network Error . Check Connection", "Connect to Internet", { "Try again" }  )
				  print("Network Error . Check Connection", "Connect to Internet")
			else
				local dados = json.decode(event.response)
				print("event.response",event.response)
				auxFuncs.saveTable(dados,"listaArquivosPalavras.json")
				if dados and #dados and #dados>0 then

					-- 2 - após gerar o vetor de arquivos, deve-se montar o php e salva-lo na nuvem
					local HTML = "<html>\n" .. '<head><meta charset="UTF-8"></head>\n'
					local HTML2 = "<html>\n" .. '</html><head><meta charset="UTF-8"></head>\n'
					local iConhecimento = 1
					local atual = ""
					for i=1,#dados do
						-- material de Conhecimentos\nTalvez precise de um tutor ou um curso para efetivação do conhecimento
						if dados[i].tipo == "conceito" and atual ~= "conceito" then
							atual = "conceito"
							HTML = HTML..'\n<h1 align= "center" style= "color:red; font-family:'.."arial"..'">Material de Conceitos</h1>\n<br>\n'
						elseif dados[i].tipo == "conhecimento" and atual ~= "conhecimento" then
							iConhecimento = i
							atual = "conhecimento"
							HTML2 = HTML2..'\n<br>\n<h1 align= "center" style= "color:red; font-family:'.."arial"..'">Material de Conhecimentos</h1>\n<h1 align= "left" style= "color:darkred; font-family:'.."arial"..'">Talvez precise de um tutor ou um curso para efetivação do conhecimento.</h1>\n<br>\n'
						end
						
						if atual == "conceito" then
							HTML = HTML .. M.htmlScript(dados[i],i)
						elseif atual == "conhecimento" then
							HTML2 = HTML2 .. M.htmlScript(dados[i],i-iConhecimento+1)
						end
					end
					HTML = HTML .. "\n</html>"
					HTML2 = HTML2 .. "\n</html>"
					
					local arquivoHtml = "material"..atrib.idAluno..atrib.codigoLivro.."Conceito.html"
					local arquivoHtml2 = "material"..atrib.idAluno..atrib.codigoLivro.."Conhecimento.html"
					local linkHtml = "https://coronasdkgames.com/Onisciencia%2042/Livros/Hyper_Audio_Book%20Demo/"..string.gsub(arquivoHtml," ","%%20")
					local linkHtml2 = "https://coronasdkgames.com/Onisciencia%2042/Livros/Hyper_Audio_Book%20Demo/"..string.gsub(arquivoHtml2," ","%%20")
					auxFuncs.criarTxTDoc(arquivoHtml,HTML)
					auxFuncs.criarTxTDoc(arquivoHtml2,HTML2)
					local Func = {}
					local tentativas = 1
					function Func.aposNaoCriarLink2()
						tentativas = tentativas+1
						if tentativas <=3 then
							M.uploadFiles({
								arquivo = arquivoHtml2,
								pasta = pastaPrincipal,
								aposEnviar = Func.aposCriarLink2,
								aposFalhar = Func.aposNaoCriarLink2
							})
						else
							native.showAlert("Atenção!","não foi possível enviar o link neste momento!\nVerifique sua conexão com a internet e tente novamente!")
						end
					end
					function Func.aposNaoCriarLink()
						tentativas = tentativas+1
						if tentativas <=3 then
							M.uploadFiles({
								arquivo = arquivoHtml,
								pasta = pastaPrincipal,
								aposEnviar = Func.aposCriarLink,
								aposFalhar = Func.aposNaoCriarLink
							})
						else
							native.showAlert("Atenção!","não foi possível enviar o link neste momento!\nVerifique sua conexão com a internet e tente novamente!")
						end
					end
					function Func.aposCriarLink2()
						tentativas = 1
						-- 4 - Por fim, enviar um email com o link
						local options =
						{
						   to = "",
						   subject = "Link para estudo!",
						   body = "Links:\nConceitos: "..linkHtml.."\nConhecimentos: "..linkHtml2
						}
						native.showPopup( "mail", options )
						print("Links:\nConceitos: "..linkHtml.."\nConhecimentos: "..linkHtml2)
					end
					function Func.aposCriarLink()
						if HTML2 ~= "<html>\n" .. '</html><head><meta charset="UTF-8"></head>\n\n</html>' then
							tentativas = 1
							M.uploadFiles({
								arquivo = arquivoHtml2,
								pasta = pastaPrincipal,
								aposEnviar = Func.aposCriarLink2,
								aposFalhar = Func.aposNaoCriarLink2
							})
						else
							tentativas = 1
							-- 4 - Por fim, enviar um email com o link
							local options =
							{
							   to = "",
							   subject = "Link para estudo!",
							   body = "Link: Conceitos: "..linkHtml
							}
							native.showPopup( "mail", options )
							print("Link: Conceitos: "..linkHtml)
						end
					end
					-- 3 - Finalmente fazer upload!
					M.uploadFiles({
						arquivo = arquivoHtml,
						pasta = pastaPrincipal,
						aposEnviar = Func.aposCriarLink,
						aposFalhar = Func.aposNaoCriarLink
					})
					
					--"https://coronasdkgames.com/Onisciencia%2042/Livros/Hyper_Audio_Book%20Demo/".."material"..atrib.idAluno..atrib.codigoLivro..".html"
				elseif tentativas <= 3 then
					tentativas = tentativas+1
					print("tentativa número: "..tentativas)
					--local URL = "https://coronasdkgames.com/Onisciencia 42/ManejarPastaLivros.php"
					--network.request(URL, "POST", listener,parameters)
				else
					native.showAlert("Atenção!"," O material só pode ser gerado se você tiver uma conexão estável com a intenet.\n Caso não consiga prosseguir, contate o suporte!")
				end
			end
		end
		local json = require("json")
		local headers = {}
		headers["Content-Type"] = "application/json"
		local parameters = {}
		parameters.headers = headers
		local dados = {}
		dados.palavras = palavras
		dados.pasta = pastaPrincipal.."/palavras/"
		dados.numero = #palavras
		dados.idAluno = atrib.idAluno
		dados.codigoLivroHtml = string.gsub(atrib.codigoLivro," ","%%20")
		dados.codigoLivro = atrib.codigoLivro
		dados = json.encode(dados)
		parameters.body = dados
		local URL = "https://coronasdkgames.com/Onisciencia 42/ManejarListaPalavras.php"
		network.request(URL, "POST", listener,parameters)
	else
		native.showAlert("Atenção","Selecione alguma palavra para poder prosseguir!",{"OK"})
	end
end

function M.abrirEscolhaCCAluno(event)
	local botao = event.target
	local pagina = event.target.pagina
	local alunoID = event.target.alunoID
	local paginaHTMLPalavras = {}
	-- UM CLIQUE
	if botao.clicado == false  then
		print("um clique")
		audio.stop()
		media.stopSound()
		local som = audio.loadStream("TTS_cliqueDuasVezes.mp3")
		timerRequerimento = timer.performWithDelay(16,function() audio.play(som) end,1)
		botao.clicado = true
		timer.performWithDelay(1000,function() botao.clicado = false end,1)
		return true
	end
	-- DOIS CLIQUES
	if botao.clicado == true then
		audio.stop()
		media.stopSound()
		
		botao.G = display.newGroup()
		botao.G.palavrasSelecionadas = {}
		local vetorPalavrasConceito = {}
		local vetorPalavrasConhecimento = {}
		local pastaPrincipal = event.target.pasta
		botao.G.selecionarPalavra = function(event2)
			local row = event2.target
			local rowLineVector = botao.G.palavrasSelecionadas[row.index]
			if event2.phase == "release" then
				print("row",row.index)
				if rowLineVector and rowLineVector[3] == false then
					botao.G.palavrasSelecionadas[row.index][3] = true
					row.rect.alpha = 1
				elseif rowLineVector and rowLineVector[3] == true then
					botao.G.palavrasSelecionadas[row.index][3] = false
					row.rect.alpha = 0
				end
			end
		end
		
		botao.G.gerarLinha = function( event )
			local phase = event.phase
			local row = event.row
			local groupContentHeight = row.contentHeight
			local groupContentWidth = row.contentWidth
			
			local result = row.params.results
			local tipo = row.params.tipo
		 
			local rowHeight = row.contentHeight
			local rowWidth = row.contentWidth
			local linhaSuperior = display.newRect(row,rowWidth/2,0,rowWidth,2)
			linhaSuperior:setFillColor(0,0,0)

			local palavra = result
			if not palavra then palavra = "" end
			
			row.rect = display.newRect(row,0,0,groupContentWidth-1,groupContentHeight-2)
			row.rect.anchorX = 0
			row.rect.anchorY = 0
			row.rect:setFillColor(0.7,0.7,0.7)
			row.rect.alpha = 0
			row.rect.strokeWidth = 2
			row.rect:setStrokeColor(0.7,0,0)
			
			row.editar = native.newTextField(5,0,5*rowWidth/9, rowHeight )
			row:insert(row.editar)
			row.editar.text = palavra
			row.editar.x = 5
			row.editar.anchorX = 0
			row.editar.y = groupContentHeight * 0.5
			row.editar.isVisible = false
			row.rowTitle = display.newText( row, palavra,0,0,3*rowWidth/5,0,"Fontes/segoeui.ttf", 30 )
			row.rowTitle.x = 10
			row.rowTitle.anchorX = 0
			row.rowTitle.y = groupContentHeight * 0.5
			row.rowTitle:setFillColor(0,0,0)
			
			local bWidth = 40
			local alpha = .2
			if botao.G.palavrasSelecionadas[row.index] and botao.G.palavrasSelecionadas[row.index][3] then
				row.rect.alpha = 1
			end
			
			row.titleHeight = row.rowTitle.height 
			local function  marcarPalavra(e)
				local btn = e.target
				if e.target.tipo == "deletar" then
					
					row.botaoConceito.alpha = alpha
					row.botaoConceito.ativado = false
					row.botaoConhecimento.alpha = alpha
					row.botaoConhecimento.ativado = false
					row.botaoAulaK.alpha = alpha
					row.botaoAulaK.ativado = false
					row.botaoAulaC.alpha = alpha
					row.botaoAulaC.ativado = false
					
					vetorPalavras[row.index][2] = false
					vetorPalavras[row.index][3] = false
					vetorPalavras[row.index][4] = false
					vetorPalavras[row.index][5] = false
				elseif e.target.ativado then
					e.target.alpha = alpha
					e.target.ativado = false
					vetorPalavras[row.index][btn.indexR] = false
				elseif not e.target.ativado then
					e.target.alpha = 1
					e.target.ativado = true
					vetorPalavras[row.index][btn.indexR] = true
				end
			end
			row.botaoDeletar = widget.newButton {
				shape= "roundedRect",
				fillColor = {default = {192/255,0/255,0/255},over = {168/510,10/510,10/510}},
				labelColor = {default = {0,0,0},over = {0,0,0,0.5}},
				labelAlign = "center",
				label = "X",
				font = "Fontes/arial.ttf",
				fontSize = 30,
				width = 25,
				height = rowHeight-2,
				onRelease = marcarPalavra
			}
			row.botaoDeletar.tipo = "deletar"
			row.botaoDeletar.y = 2+row.botaoDeletar.height/2
			row.botaoDeletar.x = row.width - row.botaoDeletar.width/2
			row.botaoDeletar.isVisible = false
			row:insert(row.botaoDeletar)
			if tipo == "conceito" then
				row.Tipo = display.newImageRect(row,"criarConceito.png",50,50)
				row.Tipo.x = row.botaoDeletar.x - row.botaoDeletar.width/2 - 10 - 20
				row.Tipo.y = rowHeight/2
			elseif tipo == "conhecimento" then
				row.Tipo = display.newImageRect(row,"criarConhecimento.png",50,50)
				row.Tipo.x = row.botaoDeletar.x - row.botaoDeletar.width/2 - 10 - 20
				row.Tipo.y = rowHeight/2
			end

			local linhaInferior = display.newRect(row,rowWidth/2,groupContentHeight,rowWidth,2)
			linhaInferior:setFillColor(0,0,0)
		end
		
		
		botao.G.telaProtetiva = auxFuncs.TelaProtetiva()
		botao.G.telaProtetiva.alpha = .5
		botao.G:insert(botao.G.telaProtetiva)
		botao.G.MenuConfig = display.newImageRect("menuPagina.png",W+60,H-100)
		botao.G.MenuConfig.x,botao.G.MenuConfig.y = W/2,H/2
		botao.G.MenuConfig.isHitTestable = true
		botao.G.MenuConfig.clicado = false
		botao.G.MenuConfig:addEventListener("tap",function()return true end)
		botao.G.MenuConfig:addEventListener("touch",function()return true end)
		botao.G:insert(botao.G.MenuConfig)

		local options = {align="center",text="Decisão Democrática\nPersonalizada",x=70,y=185,font="Fontes/paolaAccent.ttf",fontSize=50}
		botao.G.titulo = display.newText(options)
		botao.G.titulo.anchorY=0
		botao.G.titulo.anchorX=0
		botao.G.titulo:setFillColor(168/255,10/255,10/255)
		botao.G:insert(botao.G.titulo)
		
		botao.G.titulo2 = display.newText(botao.G,"O que desejo saber?",70,345,0,0,"Fontes/paolaAccent.ttf",45)
		botao.G.titulo2.anchorY=0
		botao.G.titulo2.anchorX=0
		botao.G.titulo2:setFillColor(192/255,0,0)
		
		-- criar table
		botao.G.tableViewResults = widget.newTableView(
			{
				height = 500,
				width = 600,
				onRowRender = botao.G.gerarLinha,
				onRowTouch = botao.G.selecionarPalavra,
				listener = scrollListener,
				rowTouchDelay =0
			}
		)
		botao.G.tableViewResults.x = W/2
		botao.G.tableViewResults.y = 400 + botao.G.tableViewResults.height/2
		botao.G:insert(botao.G.tableViewResults)
		
		
		
		botao.G.legendaTable = display.newText(botao.G,"Conceitos: ? | Conhecimentos: ?",60,botao.G.tableViewResults.y+botao.G.tableViewResults.height/2 + 10,0,0,"Fontes/ariblk.ttf",30)--vetorPalavrasConceito--vetorPalavrasConhecimento
		botao.G.legendaTable.anchorX=0;botao.G.legendaTable.anchorY=0
		botao.G.legendaTable:setFillColor(0/255,0/255,0/255)
		
		-- criar Botão gerar
		botao.G.botaoGerarHTML = auxFuncs.createNewButton({
			width = 270,
			height = 80,
			shape = "roundedRect",
			radius = 5,
			label = "Gerar e Enviar",
			size = 38,
			labelColor = {default = {1,1,1,1},over = {1,1,1,.7}},
			onRelease = function() 
				auxFuncs.saveTable(botao.G.palavrasSelecionadas,"palavrasSelecionadasAluno.json")

				M.GerarTelaeHTML({palavras = botao.G.palavrasSelecionadas,pastaPrincipal = pastaPrincipal,idAluno=alunoID,codigoLivro=pastaPrincipal}) 
			end
		})
		botao.G.botaoGerarHTML.x = W/2
		botao.G.botaoGerarHTML.y = botao.G.legendaTable.y + botao.G.legendaTable.height + botao.G.botaoGerarHTML.height/2 + 15
		botao.G:insert(botao.G.botaoGerarHTML)
		
		botao.G.createAllRows = function()
			for i=1,#vetorPalavrasConceito do
				
				local lixo = display.newText( vetorPalavrasConceito[i],0,0,3*botao.G.tableViewResults.width/5,0,"Fontes/segoeui.ttf", 30 )
				local height = lixo.height
				lixo:removeSelf()
				lixo = nil
				botao.G.tableViewResults:insertRow{rowHeight = height + 15,params = {results = vetorPalavrasConceito[i],tipo = "conceito"}}
				table.insert(botao.G.palavrasSelecionadas,{vetorPalavrasConceito[i],"conceito",false})
			end
			for i=1,#vetorPalavrasConhecimento do
				
				local lixo = display.newText( vetorPalavrasConhecimento[i],0,0,3*botao.G.tableViewResults.width/5,0,"Fontes/segoeui.ttf", 30 )
				local height = lixo.height
				lixo:removeSelf()
				lixo = nil
				botao.G.tableViewResults:insertRow{rowHeight = height + 15,params = {results = vetorPalavrasConhecimento[i],tipo = "conhecimento"}}
				table.insert(botao.G.palavrasSelecionadas,{vetorPalavrasConhecimento[i],"conhecimento",false})
			end
			auxFuncs.saveTable(botao.G.palavrasSelecionadas,"palavrasSelecionadasAluno.json")
		end
		
		local function onCompleteDownload(arquivo)
			local function onCompleteDownload2(arquivo2)
				print("onCompleteDownload2",arquivo2)
				if auxFuncs.fileExistsDoc(arquivo2) then
					print("ExisteP")
					vetorPalavrasConhecimento = auxFuncs.loadTable(arquivo2)
					print("nova table Conh = ",vetorPalavrasConhecimento,#vetorPalavrasConhecimento)
				end
				botao.G.legendaTable.text =  "Conceitos: "..#vetorPalavrasConceito.." | Conhecimentos: "..#vetorPalavrasConhecimento
				botao.G.createAllRows()
			end
			if auxFuncs.fileExistsDoc(arquivo) then
				print("ExisteA")
				vetorPalavrasConceito = auxFuncs.loadTable(arquivo)
				print("nova table Conc = ",vetorPalavrasConceito,#vetorPalavrasConceito)
			end
			M.downloadFiles({
				arquivo = "MP_"..botao.vetorNomes[2].."_".. botao.nomeArquivoSelecaoMA ..".json",
				pasta = botao.pasta,
				onComplete = onCompleteDownload2
			})
		end
		print(botao.pasta,"MP_"..botao.vetorNomes[1].."_".. botao.nomeArquivoSelecaoMA ..".json")
		M.downloadFiles({
			arquivo = "MP_"..botao.vetorNomes[1].."_".. botao.nomeArquivoSelecaoMA ..".json",
			pasta = botao.pasta,
			onComplete = onCompleteDownload
		})
		
		-- criar botão de fechar
		botao.G.fecharMenuConfig = function(evento)
			if evento.target.clicado == false  then
				
				audio.stop()
				media.stopSound()
				timer.performWithDelay(1000,function() evento.target.clicado = false end,1)
				local som = audio.loadStream("TTS_cliqueDuasVezes.mp3")
				audio.play(som)
				evento.target.clicado = true
			end
			if evento.target.clicado == true then
				evento.target.clicado = false
				audio.stop()
				media.stopSound()
				
				
				botao.G.fechar:setEnabled(false)
				local som = audio.loadStream("TTS_fechando.mp3")
				local function onComplete()
					botao.G:removeSelf()
				end
				evento.target:removeEventListener("tap",botao.G.fecharMenuConfig)
				timerRequerimento = timer.performWithDelay(16,function() audio.play(som,{onComplete = onComplete}) end,1)
				audio.stop()
				media.stopSound()
				
				
				
			end
			return true
		end
		
		botao.G.fechar = widget.newButton {
			onRelease = botao.G.fecharMenuConfig,
			emboss = false,
			-- Properties for a rounded rectangle button
			defaultFile = "closeMenuButton2.png",
			overFile = "closeMenuButton2D.png"
		}
		botao.G.fechar.clicado = false
		botao.G.fechar.anchorX=1
		botao.G.fechar.anchorY=0
		botao.G.fechar.x = W - 55
		botao.G.fechar.y = 173
		botao.G:insert(botao.G.fechar)
		
		botao.clicado = false
	end
end

function M.selecionarMaterial(varGlobal,Var)

	print("selecionando material")
	if varGlobal.idAluno1 then
		if Var.GMenuBotao then Var.GMenuBotao:removeSelf();Var.GMenuBotao = nil end
		Var.GMenuBotao = display.newGroup()
		Var.GMenuBotao.MenuConfig = display.newImageRect("menuPagina2.png",W+60,H-100)
		Var.GMenuBotao.MenuConfig.alpha = 0.99
		Var.GMenuBotao.MenuConfig.x,Var.GMenuBotao.MenuConfig.y = W/2,H/2
		Var.GMenuBotao.MenuConfig.isHitTestable = true
		Var.GMenuBotao.MenuConfig.clicado = false
		Var.GMenuBotao:insert(Var.GMenuBotao.MenuConfig)
		
		Var.GMenuBotao.MenuConfig.retanguloCentral = display.newRect(60,200,W-120,H-400)
		Var.GMenuBotao.MenuConfig.retanguloCentral.anchorX = 0; Var.GMenuBotao.MenuConfig.retanguloCentral.anchorY = 0
		Var.GMenuBotao.MenuConfig.retanguloCentral.alpha = 0
		Var.GMenuBotao.MenuConfig.retanguloCentral.isHitTestable = true
		Var.GMenuBotao.MenuConfig.retanguloCentral:addEventListener("tap",function()return true end)
		Var.GMenuBotao.MenuConfig.retanguloCentral:addEventListener("touch",function()return true end)
		Var.GMenuBotao:insert(Var.GMenuBotao.MenuConfig.retanguloCentral)
		
		Var.GMenuBotao.materiaisSalvos = {}
		if not Var.GMenuBotao.paginasSelecionadas then Var.GMenuBotao.paginasSelecionadas = {} end
		
		Var.GMenuBotao.titulo1 = colocarFormatacaoTexto.criarTextodePalavras({
			texto = "Selecione o Curso",--"|c=192,0,0[S]elecione o |c=192,0,0[C]urso#/c#",
			fonte = "Fontes/ariblk.ttf",
			cor = {0,0,0},
			alinhamento = "meio",
			margem = 0,
			tamanho = 45
		})
		Var.GMenuBotao.titulo1.x = 0
		Var.GMenuBotao.titulo1.y = 250
		Var.GMenuBotao.titulo1.anchorX=0.5
		Var.GMenuBotao:insert(Var.GMenuBotao.titulo1)
		
		Var.GMenuBotao.livroSelecionado = ""
		Var.GMenuBotao.tableLivrosLinhaSelecionada = nil
		Var.GMenuBotao.tableLivrosY = 0
		Var.GMenuBotao.createAllRows = function(tableView,vetor)
			if vetor and #vetor > 0 then
				for i=1,#vetor do
					local lixo = {}
					if vetor.tipo and vetor.tipo == "livros" then 
						lixo = display.newText( tostring(vetor[i][4]),5,0,tableView.width-10,0,"Fontes/segoeui.ttf", 30 )
					else
						lixo = display.newText( tostring(vetor[i]),5,0,tableView.width-10,0,"Fontes/segoeui.ttf", 30 )
					end
					local height = lixo.height
					lixo:removeSelf()
					lixo = nil
					tableView:insertRow{rowHeight = height + 15,params = {result = vetor[i]}}
				end
			elseif vetor then
				local lixo = display.newText( "Nenhum curso ou livro para ser selecionado",5,0,tableView.width-10,0,"Fontes/segoeui.ttf", 30 )
				local height = lixo.height
				lixo:removeSelf()
				lixo = nil
				tableView:insertRow{rowHeight = height + 15,params = {result = "Nenhum curso ou livro para ser selecionado"}}
			end
		end
		
		Var.GMenuBotao.selecionarLivro = function(event)
			local phase = event.phase
			if phase == "release" then
				local row = event.row
				local groupContentHeight = row.contentHeight
				local groupContentWidth = row.contentWidth
				local result = row.params.result
				local codigoLivro = result[3]
				Var.GMenuBotao.livroSelecionado = codigoLivro
				local function listener( event )

					if ( event.isError ) then
						  --local alert = native.showAlert( "Network Error . Check Connection", "Connect to Internet", { "Try again" }  )
						  print("Network Error . Check Connection", "Connect to Internet")
					else
						local arquivos = json.decode(event.response)
						
						if arquivos and #arquivos and #arquivos>0 then
							local txtFiles = {}
							Var.GMenuBotao.materiaisSalvos = {}
							for i=1,#arquivos do
								if string.sub(arquivos[i],#arquivos[i]-3,#arquivos[i]) == ".txt" then
									table.insert(txtFiles,arquivos[i])
									table.insert(Var.GMenuBotao.paginasSelecionadas,{arquivos[i],false})
								elseif string.sub(arquivos[i],#arquivos[i]-4,#arquivos[i]) == ".json" and string.sub(arquivos[i],1,4) == "MPS_" then
									table.insert(Var.GMenuBotao.materiaisSalvos,arquivos[i])
								end
							end
							if #txtFiles == 0 then txtFiles = {"Não há material para selecionar"} end
							txtFiles = auxFuncs.Alphanumsort(txtFiles)
							if Var.GMenuBotao.tablePags then
								Var.GMenuBotao.tablePags:deleteAllRows()
								Var.GMenuBotao.createAllRows(Var.GMenuBotao.tablePags,txtFiles)
							end
							if Var.GMenuBotao.tableLivros then
								Var.GMenuBotao.tableLivrosY = Var.GMenuBotao.tableLivros:getContentPosition()
								Var.GMenuBotao.tableLivrosLinhaSelecionada = row.index
								Var.GMenuBotao.tableLivros:deleteAllRows()
								Var.GMenuBotao.createAllRows(Var.GMenuBotao.tableLivros,Var.GMenuBotao.tableLivros.livros)
								Var.GMenuBotao.tableLivros:scrollToY({ y=Var.GMenuBotao.tableLivrosY, time=0 })
							end
							-- atualizar tabela de materias salvos
							Var.GMenuBotao.checarMateriaisSalvoseAtualizarTable()
						end
					end
				end
				if codigoLivro then
				local parameters = {}
					parameters.body = "listarArquivos&codigoLivro="..codigoLivro
					local URL = "https://coronasdkgames.com/Onisciencia 42/ManejarPastaLivros.php"
					network.request(URL, "POST", listener,parameters)
				end
			end
		end
		
		Var.GMenuBotao.gerarLinhasLivros = function(event)
			local phase = event.phase
			local row = event.row
			local groupContentHeight = row.contentHeight
			local groupContentWidth = row.contentWidth
			local result = row.params.result
			local NomeLivro = result[4]
			if not NomeLivro then NomeLivro = tostring(result) end
			
			row.rect = display.newRect(row,0,0,groupContentWidth-1,groupContentHeight-2)
			row.rect.anchorX = 0
			row.rect.anchorY = 0
			row.rect:setFillColor(0.7,0.7,0.7)
			row.rect.alpha = 0
			row.rect.strokeWidth = 2
			row.rect:setStrokeColor(0.7,0,0)
			
			row.rowTitle = display.newText( row, NomeLivro,5,0,groupContentWidth-10,0,"Fontes/times.ttf", 30 )
			row.rowTitle.x = 10
			row.rowTitle.anchorX = 0
			row.rowTitle.y = groupContentHeight * 0.5
			row.rowTitle:setFillColor(0,0,0)
			
			if Var.GMenuBotao.tableLivrosLinhaSelecionada and Var.GMenuBotao.tableLivrosLinhaSelecionada == row.index then
				row.rect.alpha = 1
			end
		end
		
		
		Var.GMenuBotao.tableLivros = widget.newTableView(
			{
				height = 150,
				width = 500,
				onRowRender = Var.GMenuBotao.gerarLinhasLivros,
				onRowTouch = Var.GMenuBotao.selecionarLivro,
				listener = scrollListener,
				rowTouchDelay =0
			}
		)
		Var.GMenuBotao.tableLivros.anchorY = 0
		Var.GMenuBotao.tableLivros.x = W/2
		Var.GMenuBotao.tableLivros.y = Var.GMenuBotao.titulo1.y + Var.GMenuBotao.titulo1.height + 5
		Var.GMenuBotao:insert(Var.GMenuBotao.tableLivros)
		
		local posicaoYTituloSalvos
		if varGlobal.personalizar.aluno then
			--== ALUNO ==--
			
			-- procurar livros do aluno
			local function pegarLivros()
				local parameters = {}
				parameters.body = "usuario_id=" .. varGlobal.idAluno1
				local URL = "https://omniscience42.com/EAudioBookDB/pegarLivros.php"
				local tentativa = false
				local function pegarLivrosListener(event)
				   if ( event.isError ) then
					  print( "Network error! Conexão instável, atualize a página para receber a mensagem de bloqueio novamente.")
					  textoMensagemExtra.text = "Conexão instável, atualize a página para receber a mensagem de bloqueio novamente."
				   else
					  print("Mensagem de bloqueio recebida:",event.response)
					  local data = json.decode(event.response)
					  if data then
						if data.message and data.message == "Success" then
							print("Mensagem:",data.message,data["len"])
							Var.GMenuBotao.tableLivros.livros = {}
							for i=1,data.len do
								local livro = data[tostring(i)]
								if livro and livro[4] and livro[4] == "Hyper_Audio_Book" then -- mudar isso!!!!!
									table.insert(Var.GMenuBotao.tableLivros.livros,data[tostring(i)])
								end
							end
							Var.GMenuBotao.createAllRows(Var.GMenuBotao.tableLivros,Var.GMenuBotao.tableLivros.livros)
						elseif data.message and data.message == "Usuário não é autor de nenhum curso ou livro" then
							if not tentativa then
								tentativa = true
								local URL = "http://omniscience42.com/EAudioBookDB/pegarLivrosAutor.php"
								network.request(URL, "POST", pegarLivrosListener,parameters)
							else
								Var.GMenuBotao.createAllRows(Var.GMenuBotao.tableLivros,{})
							end
						elseif data.message then
							native.showAlert("Atenção",data.message,{"ok"})
						else
							native.showAlert("Atenção","Verifique sua conexão com a internet e depois tente novamente!",{"ok"})
						end
					  end
				   end
				end 
				network.request(URL, "POST", pegarLivrosListener,parameters)
			end
			pegarLivros()
			
			Var.GMenuBotao.titulo3 = colocarFormatacaoTexto.criarTextodePalavras({
				texto = "Selecione o Material",--"|c=192,0,0[S]elecione o |c=192,0,0[C]urso#/c#",
				fonte = "Fontes/ariblk.ttf",
				cor = {0,0,0},
				alinhamento = "meio",
				margem = 0,
				tamanho = 35
			})
			Var.GMenuBotao.titulo3.x = 0
			Var.GMenuBotao.titulo3.y = 500
			Var.GMenuBotao.titulo3.anchorX=0.5
			Var.GMenuBotao:insert(Var.GMenuBotao.titulo3)
			
			Var.GMenuBotao.materialSelecionado = {}
			Var.GMenuBotao.tableSalvosLinhaSelecionada = nil
			Var.GMenuBotao.selecionarSalvo = function(event)
				local row = event.target
				local phase = event.phase
				if phase == "release" then
					-- primeiro baixar o arquivo .json
					-- depois atualizar a table Var.GMenuBotao.paginasSelecionadas pelo
					-- arquivo baixado e lido.
					local function aposBaixarTable(arquivo,resposta)
						--native.showAlert("Atenção","|"..tostring(resposta).."|")
						if resposta == "sucesso" then
							local novasPagSelecionadas = auxFuncs.loadTable(row.params.result)
							Var.GMenuBotao.paginasSelecionadas = novasPagSelecionadas
							Var.GMenuBotao.materialSelecionado = string.sub(row.params.result,5,#row.params.result-5)
							
							Var.GMenuBotao.tableSalvosLinhaSelecionada = row.index
							Var.GMenuBotao.tableSalvos:deleteAllRows()
							Var.GMenuBotao.createAllRowsSalvos(Var.GMenuBotao.tableSalvos,Var.GMenuBotao.materiaisSalvos)
						end
					end
					M.downloadFiles({pasta = Var.GMenuBotao.livroSelecionado, arquivo = row.params.result,onComplete = aposBaixarTable})
				end
			end
			
			Var.GMenuBotao.gerarLinhasMatSalvos = function(event)
				local phase = event.phase
				local row = event.row
				local groupContentHeight = row.contentHeight
				local groupContentWidth = row.contentWidth

				local rowHeight = row.contentHeight
				local rowWidth = row.contentWidth
				local linhaSuperior = display.newRect(row,rowWidth/2,0,rowWidth,2)
				linhaSuperior:setFillColor(0,0,0)
				local arquivo = string.sub(row.params.result,5,#row.params.result-5)
				
				row.rect = display.newRect(row,0,0,groupContentWidth-1,groupContentHeight-2)
				row.rect.anchorX = 0
				row.rect.anchorY = 0
				row.rect:setFillColor(0.7,0.7,0.7)
				row.rect.alpha = 0
				row.rect.strokeWidth = 2
				row.rect:setStrokeColor(0.7,0,0)
				
				if Var.GMenuBotao.tableSalvosLinhaSelecionada and Var.GMenuBotao.tableSalvosLinhaSelecionada == row.index then
					row.rect.alpha = 1
				end
				row.rowTitle = display.newText( row, arquivo,5,0,groupContentWidth-10,0,"Fontes/times.ttf", 30 )
				row.rowTitle.x = 10
				row.rowTitle.anchorX = 0
				row.rowTitle.y = groupContentHeight * 0.5
				row.rowTitle:setFillColor(0,0,0)

			end
			
			Var.GMenuBotao.tableSalvos = widget.newTableView(
				{
					height = 100,
					width = 500,
					onRowRender = Var.GMenuBotao.gerarLinhasMatSalvos,
					onRowTouch = Var.GMenuBotao.selecionarSalvo,
					listener = scrollListener,
					rowTouchDelay =0
				}
			)
			Var.GMenuBotao.tableSalvos.anchorY = 0
			Var.GMenuBotao.tableSalvos.x = W/2
			Var.GMenuBotao.tableSalvos.y = Var.GMenuBotao.titulo3.y + Var.GMenuBotao.titulo3.height + 5
			Var.GMenuBotao:insert(Var.GMenuBotao.tableSalvos)
			
			Var.GMenuBotao.createAllRowsSalvos = function(tableViewSalvos,vetor)
				if vetor and #vetor > 0 then
					for i=1,#vetor do
						local lixo = display.newText( tostring(vetor[i]),5,0,tableViewSalvos.width-10,0,"Fontes/segoeui.ttf", 30 )
						local height = lixo.height
						lixo:removeSelf()
						lixo = nil
						tableViewSalvos:insertRow{rowHeight = height + 15,params = {result = vetor[i]}}
					end
				elseif vetor then
					local lixo = display.newText( "    Nenhum material para ser selecionado!    ",5,0,tableViewSalvos.width-10,0,"Fontes/segoeui.ttf", 30 )
					local height = lixo.height
					lixo:removeSelf()
					lixo = nil
					tableViewSalvos:insertRow{rowHeight = height + 15,params = {result = "    Nenhum material para ser selecionado!    "}}
				end
			end
			
			Var.GMenuBotao.checarMateriaisSalvoseAtualizarTable = function(novaSelecao)
				Var.GMenuBotao.tableSalvos:deleteAllRows()
				local vetor = {}
				local jaTem = false
				if Var.GMenuBotao.materiaisSalvos and #Var.GMenuBotao.materiaisSalvos > 0 and string.sub(Var.GMenuBotao.materiaisSalvos[1],1,4) ~= "MPS_" then
					Var.GMenuBotao.materiaisSalvos = {}
				end
				if novaSelecao then
					local novoNome = "MPS_"..novaSelecao..".json"
					for i=1,#Var.GMenuBotao.materiaisSalvos do
						
						if Var.GMenuBotao.materiaisSalvos[i] == novoNome then
							jaTem = true
						elseif i == #Var.GMenuBotao.materiaisSalvos and not jaTem and Var.GMenuBotao.materiaisSalvos[i] ~= novoNome then
							table.insert(Var.GMenuBotao.materiaisSalvos,novoNome)
						end
					end
					if #Var.GMenuBotao.materiaisSalvos == 0 then
						table.insert(Var.GMenuBotao.materiaisSalvos,novoNome)
					end
				end
				Var.GMenuBotao.createAllRowsSalvos(Var.GMenuBotao.tableSalvos,Var.GMenuBotao.materiaisSalvos)
			end
			

			local textoBotaoConfirmar = "Confirmar\nSeleção"
			local mensagemDeSelecao1 = "Escolha um livro e um material para poder prosseguir."
			local mensagemDeSelecao2 = "O material foi selecionado com sucesso!\n\nPode prosseguir com a escolha dos tokens no menu abaixo!"
			local mensagemDeSelecao3 = "Selecione algum material antes de prosseguir!"
			
			Var.GMenuBotao.botaoConfirmar = auxFuncs.createNewButton({
				width = 350,
				height = 140,
				shape = "roundedRect",
				radius = 5,
				font = "Fontes/arialb.ttf",
				label = textoBotaoConfirmar,
				size = 39,
				labelColor = {default = {1,1,1,1},over = {1,1,1,.7}},
				onRelease = function() 
					if Var.GMenuBotao.materialSelecionado ~= {} then
						local selecao = {}
						for i=1,#Var.GMenuBotao.paginasSelecionadas do
							if Var.GMenuBotao.paginasSelecionadas[i][2] == true then
								table.insert(selecao,Var.GMenuBotao.paginasSelecionadas[i][1])
							end
						end
						if #selecao == 0 then
							native.showAlert("Atenção!",mensagemDeSelecao3,{"OK"})
						else
							local novaSelecao = Var.GMenuBotao.materialSelecionado
							auxFuncs.saveTable(Var.GMenuBotao.paginasSelecionadas,"palavrasSelecionadasMA.json")
							auxFuncs.criarTxTDoc("MA_NomeSelecao.txt",novaSelecao)
							auxFuncs.criarTxTDoc("MA_NomeLivro.txt",Var.GMenuBotao.livroSelecionado)
							auxFuncs.saveTable(Var.GMenuBotao.paginasSelecionadas,"MAS_"..novaSelecao..".json")
							M.downloadFiles({
								arquivo = "MP_listaPalavras_"..Var.GMenuBotao.materialSelecionado..".json",
								pasta = Var.GMenuBotao.livroSelecionado,
								onComplete = function() 
									Var.GMenuBotao:removeSelf()
									Var.GMenuBotao = nil
									
									-- SUCESSO ABRIR ESCOLHA!!!!
									local vetorSelecoes = {}
									Var.nomeArquivoSelecaoMA = nil
									Var.nomeLivroSelecaoMA = nil
									if auxFuncs.fileExistsDoc("MA_NomeSelecao.txt") then
										Var.nomeArquivoSelecaoMA = auxFuncs.lerTextoDoc("MA_NomeSelecao.txt")
										Var.nomeLivroSelecaoMA = auxFuncs.lerTextoDoc("MA_NomeLivro.txt")
										vetorSelecoes = auxFuncs.loadTable("MP_listaPalavras_"..Var.nomeArquivoSelecaoMA..".json")
										if auxFuncs.fileExistsDoc("MA_listaPalavras_"..Var.nomeArquivoSelecaoMA..".json") then -- verificar se o aluno já fez alguma seleção anteriormente
											vetorSelecoes = auxFuncs.loadTable("MA_listaPalavras_"..Var.nomeArquivoSelecaoMA..".json")
										end
									end
									
									if Var.nomeArquivoSelecaoMA then
										local event = {}
										local vetorNomes = {"Aconceitos","Aconhecimentos","Pconceitos","Pconhecimentos"}
										event.target = {}
										event.target.vetorPalavras = vetorSelecoes
										event.target.pasta = Var.nomeLivroSelecaoMA
										event.target.nomeArquivoSelecaoMA = Var.nomeArquivoSelecaoMA
										event.target.clicado = true
										event.target.alunoID = varGlobal.idAluno1
										--event.target.pagina = atrib.tela.paginaHistorico
										event.target.vetorNomes = vetorNomes
										
										M.abrirEscolhaCCAluno(event)
									else
										native.showAlert("Sucesso!",mensagemDeSelecao2,{"OK"})
									end
								end
							})
						end
					elseif Var.GMenuBotao.materialSelecionado ~= {} then
						native.showAlert("Atenção!",mensagemDeSelecao1,{"OK"})
					else
						-- ler material salvo
					end
				end
			})
			Var.GMenuBotao.botaoConfirmar.anchorY=1
			Var.GMenuBotao.botaoConfirmar.x = W/2
			Var.GMenuBotao.botaoConfirmar.y = H - Var.GMenuBotao.botaoConfirmar.height/2 - 200
			Var.GMenuBotao:insert(Var.GMenuBotao.botaoConfirmar)
		end
		
		if varGlobal.personalizar.professor then
			--== PROFESSOR ==--
		
			-- procurar livros do proprietário
			local function pegarLivros()
				local parameters = {}
				parameters.body = "usuario_id=" .. varGlobal.idAluno1
				local URL = "https://omniscience42.com/EAudioBookDB/pegarLivrosAutor.php"
				local tentativa = false
				local function pegarLivrosListener(event)
				   if ( event.isError ) then
					  print( "Network error! Conexão instável, atualize a página para receber a mensagem de bloqueio novamente.")
					  textoMensagemExtra.text = "Conexão instável, atualize a página para receber a mensagem de bloqueio novamente."
				   else
					  print("Mensagem de bloqueio recebida:",event.response)
					  local data = json.decode(event.response)
					  if data then
						if data.message and data.message == "Success" then
							print("Mensagem:",data.message,data["len"])
							Var.GMenuBotao.tableLivros.livros = {}
							for i=1,data.len do
								table.insert(Var.GMenuBotao.tableLivros.livros,data[tostring(i)])
							end
							Var.GMenuBotao.createAllRows(Var.GMenuBotao.tableLivros,Var.GMenuBotao.tableLivros.livros)
						elseif data.message and data.message == "Usuário não é autor de nenhum curso ou livro" then
							if not tentativa then
								tentativa = true
								local URL = "http://omniscience42.com/EAudioBookDB/pegarLivrosAutor.php"
								network.request(URL, "POST", pegarLivrosListener,parameters)
							else
								Var.GMenuBotao.createAllRows(Var.GMenuBotao.tableLivros,{})
							end
						elseif data.message then
							native.showAlert("Atenção",data.message,{"ok"})
						else
							native.showAlert("Atenção","Verifique sua conexão com a internet e depois tente novamente!",{"ok"})
						end
					  end
				   end
				end 
				network.request(URL, "POST", pegarLivrosListener,parameters)
			end
			pegarLivros()
			Var.GMenuBotao.tableSalvosLinhaSelecionada = nil
			-- selecionar páginas
			Var.GMenuBotao.titulo2 = colocarFormatacaoTexto.criarTextodePalavras({
				texto = "Selecione o Material",--"|c=192,0,0[S]elecione o |c=192,0,0[C]urso#/c#",
				fonte = "Fontes/ariblk.ttf",
				cor = {0,0,0},
				alinhamento = "meio",
				margem = 0,
				tamanho = 35
			})
			Var.GMenuBotao.titulo2.x = 0
			Var.GMenuBotao.titulo2.y = 500
			Var.GMenuBotao.titulo2.anchorX=0.5
			Var.GMenuBotao:insert(Var.GMenuBotao.titulo2)
			
			Var.GMenuBotao.paginasSelecionadas = {}
			Var.GMenuBotao.selecionarPags = function(event)
				local row = event.target
				local phase = event.phase
				if phase == "release" then
					local rowLineVector = Var.GMenuBotao.paginasSelecionadas[row.index]
					if event.phase == "release" then
						print("row",row.index)
						if rowLineVector and rowLineVector[2] == false then
							Var.GMenuBotao.paginasSelecionadas[row.index][2] = true
							row.rect.alpha = 1
						elseif rowLineVector and rowLineVector[2] == true then
							Var.GMenuBotao.paginasSelecionadas[row.index][2] = false
							row.rect.alpha = 0
						end
					end
				end
			end
			Var.GMenuBotao.gerarLinhasPags = function(event)
				local phase = event.phase
				local row = event.row
				local groupContentHeight = row.contentHeight
				local groupContentWidth = row.contentWidth
				local result = row.params.result
				local arquivo = result
				
				local rowHeight = row.contentHeight
				local rowWidth = row.contentWidth
				local linhaSuperior = display.newRect(row,rowWidth/2,0,rowWidth,2)
				linhaSuperior:setFillColor(0,0,0)
				
				row.rect = display.newRect(row,0,0,groupContentWidth-1,groupContentHeight-2)
				row.rect.anchorX = 0
				row.rect.anchorY = 0
				row.rect:setFillColor(0.7,0.7,0.7)
				row.rect.alpha = 0
				row.rect.strokeWidth = 2
				row.rect:setStrokeColor(0.7,0,0)
				
				row.rowTitle = display.newText( row, arquivo,5,0,groupContentWidth-10,0,"Fontes/times.ttf", 30 )
				row.rowTitle.x = 10
				row.rowTitle.anchorX = 0
				row.rowTitle.y = groupContentHeight * 0.5
				row.rowTitle:setFillColor(0,0,0)
				
				local rowLineVector = Var.GMenuBotao.paginasSelecionadas[row.index]
				if rowLineVector and rowLineVector[2] == false then
					row.rect.alpha = 0
				elseif rowLineVector and rowLineVector[2] == true then
					row.rect.alpha = 1
				end
			end
			
		
			Var.GMenuBotao.tablePags = widget.newTableView(
				{
					height = 150,
					width = 500,
					onRowRender = Var.GMenuBotao.gerarLinhasPags,
					onRowTouch = Var.GMenuBotao.selecionarPags,
					listener = scrollListener,
					rowTouchDelay =0
				}
			)
			Var.GMenuBotao.tablePags.anchorY = 0
			Var.GMenuBotao.tablePags.x = W/2
			Var.GMenuBotao.tablePags.y = Var.GMenuBotao.titulo2.y + Var.GMenuBotao.titulo2.height + 5
			Var.GMenuBotao:insert(Var.GMenuBotao.tablePags)
			
			Var.GMenuBotao.titulo3 = colocarFormatacaoTexto.criarTextodePalavras({
				texto = "Seleções Salvas",--"|c=192,0,0[S]elecione o |c=192,0,0[C]urso#/c#",
				fonte = "Fontes/ariblk.ttf",
				cor = {0,0,0},
				alinhamento = "meio",
				margem = 0,
				tamanho = 35
			})
			Var.GMenuBotao.titulo3.x = 0
			Var.GMenuBotao.titulo3.y = 710
			Var.GMenuBotao.titulo3.anchorX=0.5
			Var.GMenuBotao:insert(Var.GMenuBotao.titulo3)
			
			Var.GMenuBotao.materialSelecionado = {}
			Var.GMenuBotao.selecionarSalvo = function(event)
				local row = event.target
				local phase = event.phase
				if phase == "release" then
					-- primeiro baixar o arquivo .json
					-- depois atualizar a table Var.GMenuBotao.paginasSelecionadas pelo
					-- arquivo baixado e lido.
					local function aposBaixarTable()
						local novasPagSelecionadas = auxFuncs.loadTable(row.params.result)
						Var.GMenuBotao.paginasSelecionadas = novasPagSelecionadas
						Var.GMenuBotao.paginasSalvasSelecionada = novasPagSelecionadas
						-- atualizar table de paginas com as seleções salvas
						Var.GMenuBotao.tableSalvosLinhaSelecionada = row.index
						Var.GMenuBotao.tableSalvos:reloadData()
						Var.GMenuBotao.tablePags:deleteAllRows()
						local txtFiles = {}
						if novasPagSelecionadas then
							Var.GMenuBotao.materialSalvoSelecionado = {}
							for i=1,#novasPagSelecionadas do
								table.insert(txtFiles,novasPagSelecionadas[i][1])
							end
							txtFiles = auxFuncs.Alphanumsort(txtFiles)
							Var.GMenuBotao.createAllRows(Var.GMenuBotao.tablePags,txtFiles)
							
							Var.GMenuBotao.campoDeNome.text = string.sub(row.params.result,5,#row.params.result-5)
							
						end
					end
					M.downloadFiles({pasta = Var.GMenuBotao.livroSelecionado, arquivo = row.params.result,onComplete = aposBaixarTable})
				end
			end
			Var.GMenuBotao.gerarLinhasMatSalvos = function(event)
				local phase = event.phase
				local row = event.row
				local groupContentHeight = row.contentHeight
				local groupContentWidth = row.contentWidth

				local rowHeight = row.contentHeight
				local rowWidth = row.contentWidth
				local linhaSuperior = display.newRect(row,rowWidth/2,0,rowWidth,2)
				linhaSuperior:setFillColor(0,0,0)
				local arquivo = string.sub(row.params.result,5,#row.params.result-5)
				
				row.rect = display.newRect(row,0,0,groupContentWidth-1,groupContentHeight-2)
				row.rect.anchorX = 0
				row.rect.anchorY = 0
				row.rect:setFillColor(0.7,0.7,0.7)
				row.rect.alpha = 0
				row.rect.strokeWidth = 2
				row.rect:setStrokeColor(0.7,0,0)
				
				if Var.GMenuBotao.tableSalvosLinhaSelecionada and Var.GMenuBotao.tableSalvosLinhaSelecionada == row.index then
					row.rect.alpha = 1
				end
				
				row.rowTitle = display.newText( row, arquivo,5,0,groupContentWidth-10,0,"Fontes/times.ttf", 30 )
				row.rowTitle.x = 10
				row.rowTitle.anchorX = 0
				row.rowTitle.y = groupContentHeight * 0.5
				row.rowTitle:setFillColor(0,0,0)

			end
			
			Var.GMenuBotao.tableSalvos = widget.newTableView(
				{
					height = 100,
					width = 500,
					onRowRender = Var.GMenuBotao.gerarLinhasMatSalvos,
					onRowTouch = Var.GMenuBotao.selecionarSalvo,
					listener = scrollListener,
					rowTouchDelay =0
				}
			)
			Var.GMenuBotao.tableSalvos.anchorY = 0
			Var.GMenuBotao.tableSalvos.x = W/2
			Var.GMenuBotao.tableSalvos.y = Var.GMenuBotao.titulo3.y + Var.GMenuBotao.titulo3.height + 5
			
			Var.GMenuBotao:insert(Var.GMenuBotao.tableSalvos)
			
			Var.GMenuBotao.createAllRowsSalvos = function(tableViewSalvos,vetor)
				if vetor and #vetor > 0 then
					for i=1,#vetor do
						local lixo = display.newText( tostring(vetor[i]),5,0,tableViewSalvos.width-10,0,"Fontes/segoeui.ttf", 30 )
						local height = lixo.height
						lixo:removeSelf()
						lixo = nil
						tableViewSalvos:insertRow{rowHeight = height + 15,params = {result = vetor[i]}}
					end
				elseif vetor then
					local lixo = display.newText( "    Nenhuma seleção foi salva anteriormente!    ",5,0,tableViewSalvos.width-10,0,"Fontes/segoeui.ttf", 30 )
					local height = lixo.height
					lixo:removeSelf()
					lixo = nil
					tableViewSalvos:insertRow{rowHeight = height + 15,params = {result = "    Nenhuma seleção foi salva anteriormente!    "}}
				end
			end
			Var.GMenuBotao.checarMateriaisSalvoseAtualizarTable = function(novaSelecao)
				Var.GMenuBotao.tableSalvos:deleteAllRows()
				local vetor = {}
				local jaTem = false
				if Var.GMenuBotao.materiaisSalvos and #Var.GMenuBotao.materiaisSalvos > 0 and string.sub(Var.GMenuBotao.materiaisSalvos[1],1,4) ~= "MPS_" then
					Var.GMenuBotao.materiaisSalvos = {}
				end
				if novaSelecao then
					local novoNome = "MPS_"..novaSelecao..".json"
					for i=1,#Var.GMenuBotao.materiaisSalvos do
						
						if Var.GMenuBotao.materiaisSalvos[i] == novoNome then
							jaTem = true
						elseif i == #Var.GMenuBotao.materiaisSalvos and not jaTem and Var.GMenuBotao.materiaisSalvos[i] ~= novoNome then
							table.insert(Var.GMenuBotao.materiaisSalvos,novoNome)
						end
					end
					if #Var.GMenuBotao.materiaisSalvos == 0 then
						table.insert(Var.GMenuBotao.materiaisSalvos,novoNome)
					end
				end
				Var.GMenuBotao.createAllRowsSalvos(Var.GMenuBotao.tableSalvos,Var.GMenuBotao.materiaisSalvos)
			end
			-- criar Botão confirmar
			local textoBotaoConfirmar = "Enviar ao Módulo\nDe\nSeleção de Tokens"
			local mensagemDeSelecao1 = "Preencha o campo de nova seleção com um nome à sua escolha antes de prosseguir, ou escolha uma seleção já salva anteriormente para poder editá-la."
			local mensagemDeSelecao2 = "O material foi selecionado com sucesso!\n\nPode prosseguir com a classificação e edição dos tokens no menu inferior!"
			local mensagemDeSelecao3 = "Selecione algum material antes de prosseguir! ou escolha uma seleção já salva anteriormente para poder editá-la."

			Var.GMenuBotao.botaoConfirmar = auxFuncs.createNewButton({
				width = 350,
				height = 140,
				shape = "roundedRect",
				radius = 5,
				font = "Fontes/arialb.ttf",
				label = textoBotaoConfirmar,
				size = 36,
				labelColor = {default = {1,1,1,1},over = {1,1,1,.7}},
				onRelease = function() 
					if Var.GMenuBotao.materialSelecionado ~= {} and Var.GMenuBotao.campoDeNome.text and Var.GMenuBotao.campoDeNome.text ~= "" then
						local selecao = {}
						for i=1,#Var.GMenuBotao.paginasSelecionadas do
							if Var.GMenuBotao.paginasSelecionadas[i][2] == true then
								table.insert(selecao,Var.GMenuBotao.paginasSelecionadas[i][1])
							end
						end
						if #selecao == 0 then
							native.showAlert("Atenção!",mensagemDeSelecao3,{"OK"})
						else
							local novaSelecao = Var.GMenuBotao.campoDeNome.text
							auxFuncs.saveTable(Var.GMenuBotao.paginasSelecionadas,"palavrasSelecionadasMP.json")
							auxFuncs.criarTxTDoc("MP_NomeSelecao.txt",novaSelecao)
							auxFuncs.criarTxTDoc("MP_NomeLivro.txt",Var.GMenuBotao.livroSelecionado)
							
							auxFuncs.saveTable(Var.GMenuBotao.paginasSelecionadas,"MPS_"..novaSelecao..".json")
							local tentativa = 1
							if Var.GMenuBotao.paginasSalvasSelecionada then
								-- baixar configs anteriores e verificar se existe
								--senão fazer upload
								local function aposBaixarSalvo(arqu,resp)
									if resp == "Não foi criado um arquivo anteriormente." then
										M.uploadFiles({
											arquivo = "MPS_"..novaSelecao..".json",
											pasta = Var.GMenuBotao.livroSelecionado
										})
										Var.GMenuBotao.paginasSelecionadas.livro = Var.GMenuBotao.livroSelecionado
										local function onComplete()
											varGlobal.personalizar.professor.textoPalavras = M.filtrarTextosDePagina("Paginas Mescladas.txt")
											native.showAlert("Sucesso!",mensagemDeSelecao2,{"OK"})
											Var.GMenuBotao.checarMateriaisSalvoseAtualizarTable(novaSelecao)
											Var.GMenuBotao:removeSelf()
											Var.GMenuBotao = nil
										end
										M.verificarMesclarAulas({arquivos = selecao,pasta = "Livros/"..Var.GMenuBotao.livroSelecionado,onComplete = onComplete})
									elseif resp ~= "sucesso" then
										if tentativa < 3 then
											tentativa = tentativa + 1
											M.downloadFiles({pasta = Var.GMenuBotao.livroSelecionado, arquivo = "MP_listaPalavras_"..novaSelecao..".json",onComplete = aposBaixarSalvo})
										end
									else
										local function onComplete()
											varGlobal.personalizar.professor.textoPalavras = M.filtrarTextosDePagina("Paginas Mescladas.txt")
											native.showAlert("Sucesso!",mensagemDeSelecao2,{"OK"})
											Var.GMenuBotao.checarMateriaisSalvoseAtualizarTable(novaSelecao)
											Var.GMenuBotao:removeSelf()
											Var.GMenuBotao = nil
										end
										M.verificarMesclarAulas({arquivos = selecao,pasta = "Livros/"..Var.GMenuBotao.livroSelecionado,onComplete = onComplete})
									end
									
								end
								M.downloadFiles({pasta = Var.GMenuBotao.livroSelecionado, arquivo = "MP_listaPalavras_"..novaSelecao..".json",onComplete = aposBaixarSalvo})
							else
								M.uploadFiles({
									arquivo = "MPS_"..novaSelecao..".json",
									pasta = Var.GMenuBotao.livroSelecionado
								})
								Var.GMenuBotao.paginasSelecionadas.livro = Var.GMenuBotao.livroSelecionado
								local function onComplete()
									varGlobal.personalizar.professor.textoPalavras = M.filtrarTextosDePagina("Paginas Mescladas.txt")
									native.showAlert("Sucesso!",mensagemDeSelecao2,{"OK"})
									Var.GMenuBotao.checarMateriaisSalvoseAtualizarTable(novaSelecao)
									Var.GMenuBotao:removeSelf()
									Var.GMenuBotao = nil
								end
								M.verificarMesclarAulas({arquivos = selecao,pasta = "Livros/"..Var.GMenuBotao.livroSelecionado,onComplete = onComplete})
							end
							
							
						end
					elseif Var.GMenuBotao.materialSelecionado ~= {} then
						native.showAlert("Atenção!",mensagemDeSelecao1,{"OK"})
					else
						-- ler material salvo
					end
				end
			})
			Var.GMenuBotao.botaoConfirmar.anchorY=1
			Var.GMenuBotao.botaoConfirmar.x = W/2
			Var.GMenuBotao.botaoConfirmar.y = H - Var.GMenuBotao.botaoConfirmar.height/2 - 200
			Var.GMenuBotao:insert(Var.GMenuBotao.botaoConfirmar)
			-- criar campo de texto
			Var.GMenuBotao.titulo4 = colocarFormatacaoTexto.criarTextodePalavras({
				texto = "Nova Seleção:",--"|c=192,0,0[S]elecione o |c=192,0,0[C]urso#/c#",
				fonte = "Fontes/ariblk.ttf",
				cor = {0,0,0},
				alinhamento = "meio",
				margem = 0,
				tamanho = 30
			})
			Var.GMenuBotao.titulo4.x = 105 + Var.GMenuBotao.titulo4.width/2 - W/2
			Var.GMenuBotao.titulo4.y = 870
			Var.GMenuBotao.titulo4.anchorX=0
			Var.GMenuBotao:insert(Var.GMenuBotao.titulo4)
			
			Var.GMenuBotao.campoDeNome = native.newTextField(0,0,270,50)
			Var.GMenuBotao.campoDeNome.anchorY=0
			Var.GMenuBotao.campoDeNome.x = W/2 + Var.GMenuBotao.campoDeNome.width/2
			Var.GMenuBotao.campoDeNome.y = 870
			Var.GMenuBotao:insert(Var.GMenuBotao.campoDeNome)
			--Var.GMenuBotao.paginasSalvasSelecionadas
			local function cancelarSelecaoAoDigitar(event)
				if event.phase == "editing" then
					if Var.GMenuBotao.tableSalvosLinhaSelecionada then
						Var.GMenuBotao.tableSalvosLinhaSelecionada = nil
						Var.GMenuBotao.paginasSalvasSelecionada = nil
						Var.GMenuBotao.tableSalvos:reloadData()
					end
				end
			end
			Var.GMenuBotao.campoDeNome:addEventListener("userInput",cancelarSelecaoAoDigitar)
		end
		
		Var.GMenuBotao.fecharMenuConfig = function(evento)
				if evento.target.clicado == false  then
					audio.stop()
					media.stopSound()
					timer.performWithDelay(1000,function() evento.target.clicado = false end,1)
					local som = audio.loadStream("TTS_cliqueDuasVezes.mp3")
					audio.play(som)
					evento.target.clicado = true
				end
				if evento.target.clicado == true then
					evento.target.clicado = false
					audio.stop()
					media.stopSound()
					
					Var.GMenuBotao.fechar:setEnabled(false)
					local som = audio.loadStream("TTS_fechando.mp3")
					local function onComplete()
						if Var.GMenuBotao then
							Var.GMenuBotao:removeSelf()
							Var.GMenuBotao = nil
						end
					end
					evento.target:removeEventListener("tap",Var.GMenuBotao.fecharMenuConfig)
					timerRequerimento = timer.performWithDelay(16,function() audio.play(som,{onComplete = onComplete}) end,1)
					audio.stop()
					media.stopSound()
				end
				return true
			end
		
		Var.GMenuBotao.fechar = widget.newButton{
			onRelease = Var.GMenuBotao.fecharMenuConfig,
			emboss = false,
			-- Properties for a rounded rectangle button
			defaultFile = "closeMenuButton2.png",
			overFile = "closeMenuButton2D.png"
		}
		Var.GMenuBotao.fechar.clicado = false
		Var.GMenuBotao.fechar.anchorX=1
		Var.GMenuBotao.fechar.anchorY=0
		Var.GMenuBotao.fechar.x = W - 55
		Var.GMenuBotao.fechar.y = 173
		Var.GMenuBotao:insert(Var.GMenuBotao.fechar)
	end
end

function M.verificarMesclarAulas(vetor)
	for i=1,#vetor do
		print("paginas = ",vetor[i])
	end
	local function listener( event )

		if ( event.isError ) then
			  --local alert = native.showAlert( "Network Error . Check Connection", "Connect to Internet", { "Try again" }  )
			  print("Network Error . Check Connection", "Connect to Internet")
		else
			--local resposta = json.decode(event.response)
			--print(resposta)
			auxFuncs.criarTxTDoc("Paginas Mescladas.txt",event.response)
			vetor.onComplete()
		end
	end
	local json = require("json")
	local headers = {}
	headers["Content-Type"] = "application/json"
	local parametersCards = {}
	parametersCards.headers = headers
	local dados = json.encode(vetor)
	parametersCards.body = dados
	local URL = "https://coronasdkgames.com/Onisciencia 42/MergeFiles.php"
	network.request(URL, "POST", listener,parametersCards)
end

function M.abrirVizualizacaoCC(event)
	local botao = event.target
	local tipo = botao.tipo
	local vetorPalavras = botao.vetorPalavras
	
	-- UM CLIQUE
	if botao.clicado == false  then
		print("um clique")
		audio.stop()
		media.stopSound()
		local som = audio.loadStream("TTS_cliqueDuasVezes.mp3")
		timerRequerimento = timer.performWithDelay(16,function() audio.play(som) end,1)
		botao.clicado = true
		timer.performWithDelay(1000,function() botao.clicado = false end,1)
		return true
	end
	-- DOIS CLIQUES
	if botao.clicado == true then
		audio.stop()
		media.stopSound()
		print("dois cliques")
		botao.G = display.newGroup()
		local vetorPalavrasA = {}
		local vetorPalavrasP = {}
		botao.G.gerarLinha = function( event )
			local phase = event.phase
			local row = event.row
			local groupContentHeight = row.contentHeight
			
			local result = row.params.results
		 
			local rowHeight = row.contentHeight
			local rowWidth = row.contentWidth
			local linhaSuperior = display.newRect(row,rowWidth/2,0,rowWidth,2)
			linhaSuperior:setFillColor(0,0,0)

			local palavra = result
			if not palavra then palavra = "" end
			
			row.editar = native.newTextField(5,0,5*rowWidth/9, rowHeight )
			row:insert(row.editar)
			row.editar.text = palavra
			row.editar.x = 5
			row.editar.anchorX = 0
			row.editar.y = groupContentHeight * 0.5
			row.editar.isVisible = false
			row.rowTitle = display.newText( row, palavra,0,0,3*rowWidth/5,0,"Fontes/segoeui.ttf", 30 )
			row.rowTitle.x = 10
			row.rowTitle.anchorX = 0
			row.rowTitle.y = groupContentHeight * 0.5
			row.rowTitle:setFillColor(0,0,0)
			local tipo = row.params.tipo
			
			local bWidth = 40
			local alpha = .2
			
			row.titleHeight = row.rowTitle.height 
			local function  marcarPalavra(e)
				local btn = e.target
				if e.target.tipo == "deletar" then
					
					row.botaoConceito.alpha = alpha
					row.botaoConceito.ativado = false
					row.botaoConhecimento.alpha = alpha
					row.botaoConhecimento.ativado = false
					row.botaoAulaK.alpha = alpha
					row.botaoAulaK.ativado = false
					row.botaoAulaC.alpha = alpha
					row.botaoAulaC.ativado = false
					
					vetorPalavras[row.index][2] = false
					vetorPalavras[row.index][3] = false
					vetorPalavras[row.index][4] = false
					vetorPalavras[row.index][5] = false
				elseif e.target.ativado then
					e.target.alpha = alpha
					e.target.ativado = false
					vetorPalavras[row.index][btn.indexR] = false
				elseif not e.target.ativado then
					e.target.alpha = 1
					e.target.ativado = true
					vetorPalavras[row.index][btn.indexR] = true
				end
			end

			if tipo == "P" then
				row.Tipo = display.newText(row,"p",0,0,"Fontes/paolaAccent.ttf",40)
				row.Tipo.anchorX=1
				row.Tipo.x = rowWidth - 5
				row.Tipo.y = rowHeight/2
				row.Tipo:setFillColor(0,0,0)
			end
			
			--[[row.botaoDeletar = widget.newButton {
				shape= "roundedRect",
				fillColor = {default = {192/255,0/255,0/255},over = {168/510,10/510,10/510}},
				labelColor = {default = {0,0,0},over = {0,0,0,0.5}},
				labelAlign = "center",
				label = "X",
				font = "Fontes/arial.ttf",
				fontSize = 30,
				width = 25,
				height = rowHeight-2,
				onRelease = marcarPalavra
			}
			row.botaoDeletar.tipo = "deletar"
			row.botaoDeletar.y = 2+row.botaoDeletar.height/2
			row.botaoDeletar.x = row.width - row.botaoDeletar.width/2
			row:insert(row.botaoDeletar)]]


			local linhaInferior = display.newRect(row,rowWidth/2,groupContentHeight,rowWidth,2)
			linhaInferior:setFillColor(0,0,0)
		end
		
		
		botao.G.telaProtetiva = auxFuncs.TelaProtetiva()
		botao.G.telaProtetiva.alpha = .5
		botao.G:insert(botao.G.telaProtetiva)
		botao.G.MenuConfig = display.newImageRect("menuPagina.png",W+60,H-100)
		botao.G.MenuConfig.x,botao.G.MenuConfig.y = W/2,H/2
		botao.G.MenuConfig.isHitTestable = true
		botao.G.MenuConfig.clicado = false
		botao.G.MenuConfig:addEventListener("tap",function()return true end)
		botao.G.MenuConfig:addEventListener("touch",function()return true end)
		botao.G:insert(botao.G.MenuConfig)
		
		local titulo = string.upper(tipo)
		
		botao.G.titulo = display.newText(botao.G,titulo,70,185,0,0,"Fontes/paolaAccent.ttf",60)
		botao.G.titulo.anchorY=0
		botao.G.titulo.anchorX=0
		botao.G.titulo:setFillColor(168/255,10/255,10/255)
		
		
		-- criar table
		botao.G.tableViewResults = widget.newTableView(
			{
				height = 600,
				width = 600,
				onRowRender = botao.G.gerarLinha,
				onRowTouch = botao.G.editarPalavra,
				listener = scrollListener,
				rowTouchDelay =0
			}
		)
		botao.G.tableViewResults.x = W/2
		botao.G.tableViewResults.y = 400 + botao.G.tableViewResults.height/2
		botao.G:insert(botao.G.tableViewResults)
		
		
		botao.G.createAllRows = function()
			for i=1,#vetorPalavrasA do
				
				local lixo = display.newText( vetorPalavrasA[i],0,0,3*botao.G.tableViewResults.width/5,0,"Fontes/segoeui.ttf", 30 )
				local height = lixo.height
				lixo:removeSelf()
				lixo = nil
				print("Nova linha "..i.." = ",height + 15,vetorPalavrasA[i])
				botao.G.tableViewResults:insertRow{rowHeight = height + 15,params = {results = vetorPalavrasA[i],tipo = "A"}}
			end
			for i=1,#vetorPalavrasP do
				local lixo = display.newText( vetorPalavrasP[i],0,0,3*botao.G.tableViewResults.width/5,0,"Fontes/segoeui.ttf", 30 )
				local height = lixo.height
				lixo:removeSelf()
				lixo = nil
				print("Nova linha P"..i.." = ",height + 15,vetorPalavrasP[i])
				botao.G.tableViewResults:insertRow{rowHeight = height + 15,params = {results = vetorPalavrasP[i],tipo = "P"}}
			end
		end
		local function onCompleteDownload2(arquivo)
			if auxFuncs.fileExistsDoc(arquivo) then
				vetorPalavrasP = auxFuncs.loadTable(arquivo)
			end
			botao.G.createAllRows()
		end
		local function onCompleteDownload(arquivo)
			if auxFuncs.fileExistsDoc(arquivo) then
				vetorPalavrasA = auxFuncs.loadTable(arquivo)
			end
			if botao.tipo == "conceitos" then
				M.downloadFiles({
					arquivo = botao.vetorNomes[3].."_"..botao.nomeSelecaoMP..".json",
					pasta = botao.pasta,
					onComplete = onCompleteDownload2
				})
			elseif botao.tipo == "conhecimentos" then
				M.downloadFiles({
					arquivo = botao.vetorNomes[4].."_"..botao.nomeSelecaoMP..".json",
					pasta = botao.pasta,
					onComplete = onCompleteDownload2
				})
			end
		end
		
		if botao.tipo == "conceitos" then
			M.downloadFiles({
				arquivo = botao.vetorNomes[1].."_"..botao.nomeSelecaoMP..".json",
				pasta = botao.pasta,
				onComplete = onCompleteDownload
			})
		elseif botao.tipo == "conhecimentos" then
			M.downloadFiles({
				arquivo = botao.vetorNomes[2].."_"..botao.nomeSelecaoMP..".json",
				pasta = botao.pasta,
				onComplete = onCompleteDownload
			})
		end
		
		-- criar botão de fechar
		botao.G.fecharMenuConfig = function(evento)
			if evento.target.clicado == false  then
				
				audio.stop()
				media.stopSound()
				timer.performWithDelay(1000,function() evento.target.clicado = false end,1)
				local som = audio.loadStream("TTS_cliqueDuasVezes.mp3")
				audio.play(som)
				evento.target.clicado = true
			end
			if evento.target.clicado == true then
				evento.target.clicado = false
				audio.stop()
				media.stopSound()
				
				
				botao.G.fechar:setEnabled(false)
				local som = audio.loadStream("TTS_fechando.mp3")
				local function onComplete()
					botao.G:removeSelf()
				end
				evento.target:removeEventListener("tap",botao.G.fecharMenuConfig)
				timerRequerimento = timer.performWithDelay(16,function() audio.play(som,{onComplete = onComplete}) end,1)
				audio.stop()
				media.stopSound()
				
				
				
			end
			return true
		end
		
		botao.G.fechar = widget.newButton {
			onRelease = botao.G.fecharMenuConfig,
			emboss = false,
			-- Properties for a rounded rectangle button
			defaultFile = "closeMenuButton2.png",
			overFile = "closeMenuButton2D.png"
		}
		botao.G.fechar.clicado = false
		botao.G.fechar.anchorX=1
		botao.G.fechar.anchorY=0
		botao.G.fechar.x = W - 55
		botao.G.fechar.y = 173
		botao.G:insert(botao.G.fechar)
		
		botao.clicado = false
	end
end

function M.abrirMenuDeSelecaoDePalavras(event)
	local botao = event.target
	local tipo = botao.tipo
	local vetorPalavras = botao.vetorPalavras
	
	-- UM CLIQUE
	if botao.clicado == false  then
		print("um clique")
		audio.stop()
		media.stopSound()
		local som = audio.loadStream("TTS_cliqueDuasVezes.mp3")
		timerRequerimento = timer.performWithDelay(16,function() audio.play(som) end,1)
		botao.clicado = true
		timer.performWithDelay(1000,function() botao.clicado = false end,1)
		return true
	end
	-- DOIS CLIQUES
	if botao.clicado == true then
		audio.stop()
		media.stopSound()
		print("dois cliques")
		botao.G = display.newGroup()
		print("Abriu botão",tipo)
		botao.G.telaProtetiva = auxFuncs.TelaProtetiva()
		botao.G.telaProtetiva.alpha = .5
		botao.G:insert(botao.G.telaProtetiva)
		botao.G.MenuConfig = display.newImageRect("menuPagina.png",W+60,H+60)
		botao.G.MenuConfig.x,botao.G.MenuConfig.y = W/2,H/2
		botao.G.MenuConfig.isHitTestable = true
		botao.G.MenuConfig.clicado = false
		botao.G.MenuConfig:addEventListener("tap",function()return true end)
		botao.G.MenuConfig:addEventListener("touch",function()return true end)
		botao.G:insert(botao.G.MenuConfig)
		
		local options = {align = "center",text = "Módulo de Seleção\nDos Tokens",x=70,y=115,font="Fontes/paolaAccent.ttf",fontSize=50}
		--[[botao.G.titulo = colocarFormatacaoTexto.criarTextodePalavras({
			texto = "Módulo de Seleção\nDos Tokens",--"|c=192,0,0[S]elecione o |c=192,0,0[C]urso#/c#",
			fonte = "Fontes/ariblk.ttf",
			cor = {0,0,0},
			alinhamento = "meio",
			margem = 0,
			tamanho = 45
		})]]
		botao.G.titulo = display.newText(options)
		botao.G.titulo.anchorY=0
		botao.G.titulo.anchorX=0
		botao.G.titulo:setFillColor(168/255,10/255,10/255)
		botao.G:insert(botao.G.titulo)
		-- criar table de palavras
		
		botao.G.editarPalavra = function( event )
			local phase = event.phase
			local row = event.row
			local groupContentHeight = row.contentHeight
			local rowHeight = row.contentHeight
			local rowWidth = row.contentWidth
			if phase == "release" then
				botao.G.selecionada = row.index
				row.fundo = auxFuncs.TelaProtetiva()
				row.fundo.alpha = .3
				row.rowTitle.isVisible = false
				row.editar.isVisible = true
				native.setKeyboardFocus( row.editar )
				function row.sairDaEdicao(e)
					if e.phase == "ended" then
						if row.fundo then
							row.editar.isVisible = false
							row.rowTitle.isVisible = true
							if row.editar.text ~= "" then
								row.rowTitle.text = row.editar.text
								vetorPalavras[event.target.index][1] = row.rowTitle.text
								row.params.results = row.rowTitle.text
							else
								row.editar.text = row.rowTitle.text
							end

							row.fundo:removeSelf()
							row.fundo = nil
							if row.titleHeight+ 15 < row.rowTitle.height+ 15 then
								botao.G.tableViewResults:deleteAllRows()
								botao.G.createAllRows()
							end
							
							return true
						end
					end
				end
				row.fundo:addEventListener("touch",row.sairDaEdicao)
				row.fundo:addEventListener("tap",function() return true end)
			end
		end
		botao.G.gerarLinha = function( event )
			local phase = event.phase
			local row = event.row
			local groupContentHeight = row.contentHeight
			
			local result = row.params.results
		 
			local rowHeight = row.contentHeight
			local rowWidth = row.contentWidth
			local linhaSuperior = display.newRect(row,rowWidth/2,0,rowWidth,2)
			linhaSuperior:setFillColor(0,0,0)

			local palavra = result[1]
			local conceito = result[2]
			local conhecimento = result[3]
			local Pconceito = result[4]
			local Pconhecimento = result[5]
			if not palavra then palavra = "" end
			
			row.editar = native.newTextField(5,0,5*rowWidth/9, rowHeight )
			row:insert(row.editar)
			row.editar.text = palavra
			row.editar.x = 5
			row.editar.anchorX = 0
			row.editar.y = groupContentHeight * 0.5
			row.editar.isVisible = false
			
			row.number = display.newText(row,row.index,2,rowHeight/2,0,0,"ariblk.ttf",25)
			row.number.anchorX=0
			row.number:setFillColor(192/255,0,0)
			
			row.rowTitle = display.newText( row, palavra,0,0,3*rowWidth/5,0,"Fontes/segoeui.ttf", 30 )
			row.rowTitle.x = 10 + row.number.x + row.number.width
			row.rowTitle.anchorX = 0
			row.rowTitle.y = groupContentHeight * 0.5
			row.rowTitle:setFillColor(0,0,0)
			
			local bWidth = 40
			local alpha = .2
			
			row.titleHeight = row.rowTitle.height 
			local function  marcarPalavra(e)
				local btn = e.target
				if e.target.tipo == "deletar" then
					
					row.botaoConceito.alpha = alpha
					row.botaoConceito.ativado = false
					row.botaoConhecimento.alpha = alpha
					row.botaoConhecimento.ativado = false
					row.botaoAulaK.alpha = alpha
					row.botaoAulaK.ativado = false
					row.botaoAulaC.alpha = alpha
					row.botaoAulaC.ativado = false
					
					vetorPalavras[row.index][2] = false
					vetorPalavras[row.index][3] = false
					vetorPalavras[row.index][4] = false
					vetorPalavras[row.index][5] = false
				elseif e.target.ativado then
					e.target.alpha = alpha
					e.target.ativado = false
					vetorPalavras[row.index][btn.indexR] = false
				elseif not e.target.ativado then
					e.target.alpha = 1
					e.target.ativado = true
					vetorPalavras[row.index][btn.indexR] = true
				end
			end
			row.botaoDeletar = widget.newButton {
				shape= "roundedRect",
				fillColor = {default = {0,0/255,0/255,0.7},over = {168/510,10/510,10/510}},
				labelColor = {default = {1,1,1},over = {0,0,0,0.5}},
				labelAlign = "center",
				label = "C",
				font = "Fontes/ariblk.ttf",
				fontSize = 30,
				width = 26,
				height = rowHeight-10,
				onRelease = marcarPalavra
			}
			row.botaoDeletar.tipo = "deletar"
			row.botaoDeletar.y = 4+row.botaoDeletar.height/2
			row.botaoDeletar.x = row.width - row.botaoDeletar.width/2
			row:insert(row.botaoDeletar)
			
			row.botaoConhecimento = widget.newButton {
				--shape= "roundedRect",
				defaultFile = "criarConhecimento.png",
				--fillColor = {default = {168/255,0.05,0.05},over = {46/510,171/510,200/510}},
				strokeColor = {default = {0,0,0},over = {0,0,0,0.5}},
				labelColor = {default = {46/255,171/255,200/255},over = {0,0,0,0.5}},
				labelAlign = "center",
				--label = "?",
				font = "Fontes/ariblk.ttf",
				fontSize = 40,
				strokeWidth = 1,
				radius = 5,
				width = bWidth,
				height = 40,
				onRelease = marcarPalavra
			}
			row.botaoConhecimento.ativado = false
			row.botaoConhecimento.alpha = alpha
			row.botaoConhecimento.isHitTestable = true
			row.botaoConhecimento.tipo = "conhecimento"
			row.botaoConhecimento.indexR = 3
			row.botaoConhecimento.y = row.botaoConhecimento.height/2
			row.botaoConhecimento.x = row.botaoDeletar.x - row.botaoDeletar.width/2 - row.botaoConhecimento.width/2 - 30
			row:insert(row.botaoConhecimento)
			
			row.botaoConceito = widget.newButton {
				--shape= "roundedRect",
				defaultFile = "criarConceito.png",
				--fillColor = {default = {163/255,73/255,164/255},over = {46/510,171/510,200/510}},
				strokeColor = {default = {0,0,0},over = {0,0,0,0.5}},
				labelColor = {default = {46/255,171/255,200/255},over = {0,0,0,0.5}},
				labelAlign = "center",
				--label = "!",
				font = "Fontes/ariblk.ttf",
				fontSize = 40,
				strokeWidth = 1,
				radius = 5,
				width = bWidth,
				height = 40,
				onRelease = marcarPalavra
			}
			row.botaoConceito.ativado = false
			row.botaoConceito.alpha = alpha
			row.botaoConceito.isHitTestable = true
			row.botaoConceito.tipo = "conceito"
			row.botaoConceito.indexR = 2
			row.botaoConceito.y = row.botaoConceito.height/2
			row.botaoConceito.x = row.botaoConhecimento.x - row.botaoConhecimento.width/2 - row.botaoConceito.width/2 - 20
			row:insert(row.botaoConceito)
			
			row.botaoAulaK = widget.newButton {
				shape= "roundedRect",
				fillColor = {default = {180/255,180/255,0/255},over = {46/510,171/510,200/510}},
				strokeColor = {default = {0,0,0},over = {0,0,0,0.5}},
				labelColor = {default = {0/255,0/255,0/255},over = {0,0,0,0.5}},
				labelAlign = "center",
				label = "P?",
				font = "Fontes/arial.ttf",
				fontSize = 30,
				strokeWidth = 1,
				radius = 5,
				width = bWidth-5,
				height = 40,
				onRelease = marcarPalavra
			}
			row.botaoAulaK.ativado = false
			row.botaoAulaK.alpha = alpha
			row.botaoAulaK.isHitTestable = true
			row.botaoAulaK.tipo = "ProfK"
			row.botaoAulaK.indexR = 5
			row.botaoAulaK.y = row.botaoAulaK.height/2 + 3
			row.botaoAulaK.x = row.botaoConceito.x - row.botaoConceito.width/2 - row.botaoAulaK.width/2 - 20
			row:insert(row.botaoAulaK)
			
			row.botaoAulaC = widget.newButton {
				shape= "roundedRect",
				fillColor = {default = {180/255,180/255,0/255},over = {46/510,171/510,200/510}},
				strokeColor = {default = {0,0,0},over = {0,0,0,0.5}},
				labelColor = {default = {0/255,0/255,0/255},over = {0,0,0,0.5}},
				labelAlign = "center",
				label = "P!",
				font = "Fontes/arial.ttf",
				fontSize = 30,
				strokeWidth = 1,
				radius = 5,
				width = bWidth-5,
				height = 40,
				onRelease = marcarPalavra
			}
			row.botaoAulaC.ativado = false
			row.botaoAulaC.alpha = alpha
			row.botaoAulaC.isHitTestable = true
			row.botaoAulaC.tipo = "ProfC"
			row.botaoAulaC.indexR = 4
			row.botaoAulaC.y = row.botaoAulaC.height/2 + 3
			row.botaoAulaC.x = row.botaoAulaK.x - row.botaoAulaK.width/2 - row.botaoAulaC.width/2 - 15
			row:insert(row.botaoAulaC)
			
			
			if conceito then row.botaoConceito.ativado = true;row.botaoConceito.alpha = 1 end
			if conhecimento then row.botaoConhecimento.ativado = true;row.botaoConhecimento.alpha = 1 end
			if Pconceito then row.botaoAulaC.ativado = true;row.botaoAulaC.alpha = 1 end
			if Pconhecimento then row.botaoAulaK.ativado = true;row.botaoAulaK.alpha = 1 end

			local linhaInferior = display.newRect(row,rowWidth/2,groupContentHeight,rowWidth,2)
			linhaInferior:setFillColor(0,0,0)
		end
		
		botao.G.legendas = display.newText("P = Professor\n!  = Conceito  | ? = Conhecimento",60,280,0,0,"Fontes/ariblk.ttf",32)
		botao.G.legendas.anchorX = 0
		botao.G.legendas:setFillColor(0,0,0)
		botao.G:insert(botao.G.legendas)
		
		botao.G.legendas2 = display.newText("| A = Aluno",320,280 - 24,0,0,"Fontes/ariblk.ttf",32)
		botao.G.legendas2.anchorX = 0
		botao.G.legendas2:setFillColor(192/255,10/255,10/255)
		botao.G:insert(botao.G.legendas2)
		
		botao.G.descricaoTablePal = display.newText("CLASSIFICAR",65,370,0,0,"Fontes/ariblk.ttf",35)
		botao.G.descricaoTablePal.anchorX = 0
		botao.G:insert(botao.G.descricaoTablePal)
		
		botao.G.descricaoTableProf = display.newText("P",425,355,0,0,"Fontes/ariblk.ttf",40)
		botao.G.descricaoTableProf.anchorX = 0
		botao.G.descricaoTableProf:setFillColor(0,0,0)
		botao.G:insert(botao.G.descricaoTableProf)
		botao.G.descricaoTableProfC = display.newText("| !",385,380,0,0,"Fontes/ariblk.ttf",30)
		botao.G.descricaoTableProfC.anchorX = 0
		botao.G.descricaoTableProfC:setFillColor(0,0,0)
		botao.G:insert(botao.G.descricaoTableProfC)
		botao.G.descricaoTableProfK = display.newText("? |",455,380,0,0,"Fontes/ariblk.ttf",30)
		botao.G.descricaoTableProfK.anchorX = 0
		botao.G.descricaoTableProfK:setFillColor(0,0,0)
		botao.G:insert(botao.G.descricaoTableProfK)
		
		botao.G.descricaoTableAluno = display.newText("A",540,355,0,0,"Fontes/ariblk.ttf",40)
		botao.G.descricaoTableAluno.anchorX = 0
		botao.G.descricaoTableAluno:setFillColor(192/255,10/255,10/255)
		botao.G:insert(botao.G.descricaoTableAluno)
		botao.G.descricaoTableConc = display.newText("| !",505,380,0,0,"Fontes/ariblk.ttf",30)
		botao.G.descricaoTableConc.anchorX = 0
		botao.G.descricaoTableConc:setFillColor(192/255,10/255,10/255)
		botao.G:insert(botao.G.descricaoTableConc)
		botao.G.descricaoTableConc = display.newText("? |",575,380,0,0,"Fontes/ariblk.ttf",30)
		botao.G.descricaoTableConc.anchorX = 0
		botao.G.descricaoTableConc:setFillColor(192/255,10/255,10/255)
		botao.G:insert(botao.G.descricaoTableConc)
		
		botao.G.tableViewResults = widget.newTableView(
			{
				height = 600,
				width = 600,
				onRowRender = botao.G.gerarLinha,
				onRowTouch = botao.G.editarPalavra,
				listener = scrollListener,
				rowTouchDelay =0
			}
		)
		botao.G.tableViewResults.x = W/2
		botao.G.tableViewResults.y = 400 + botao.G.tableViewResults.height/2
		botao.G:insert(botao.G.tableViewResults)
		-- gerar rows
		botao.G.createAllRows = function(vetorPalavras)
			for i=1,#vetorPalavras do
				local lixo = display.newText( vetorPalavras[i][1],0,0,3*botao.G.tableViewResults.width/5,0,"Fontes/segoeui.ttf", 30 )
				local height = lixo.height
				lixo:removeSelf()
				lixo = nil
				print("Nova linha"..i.." = ",height + 15,vetorPalavras[i])
				botao.G.tableViewResults:insertRow{rowHeight = height + 15,params = {results = vetorPalavras[i]}}
			end
		end
		botao.G.createAllRows(vetorPalavras)
		
		
		-- criar botão adicionar linha
		botao.G.adicionarLinha = function(event2)
			if ( event2.phase == "submitted" ) then
				if event2.target.text ~= "" then
					local tableY = botao.G.tableViewResults:getContentPosition()
					local selecionada = 0
					if botao.G.selecionada then
						selecionada = botao.G.selecionada
					else
						tableY = 0
					end
					selecionada = tonumber(selecionada) or 0
					table.insert(vetorPalavras,selecionada+1,{event2.target.text,false,false,false,false})
					botao.G.tableViewResults:deleteAllRows()
					botao.G.createAllRows(vetorPalavras)
					botao.G.tableViewResults:scrollToY( { y=tableY + 40, time=0 } )
					
					native.showAlert("Sucesso!","Novo token adicionado:\nLinha nº"..selecionada+1,{"OK"})
					botao.G.selecionada = nil
					botao.G.selecionada = ""
				else
					native.showAlert("Atenção","o campo de texto está vazio",{"OK"})
				end
			end
		end
		botao.G.editarLegenda = display.newText("Adicionar outra palavra:",0,0,"paolaAccent.ttf",30)
		botao.G.editarLegenda:setFillColor(0,0,0)
		botao.G.editarLegenda.anchorX = 0
		botao.G.editarLegenda.y = 1035; botao.G.editarLegenda.x = 60
		botao.G:insert(botao.G.editarLegenda)
		
		botao.G.editar = native.newTextField(60,1090,350, 45 )
		botao.G:insert(botao.G.editar)
		botao.G.editar.text = ""
		botao.G.editar.anchorX = 0
		botao.G.editar.isVisible = true
		botao.G.editar:addEventListener("userInput",botao.G.adicionarLinha)
		
		-- criar botão de separar e enviar
		botao.G.criarArquivosTxTDeConceitosEConhecimentos = function(event)
			local pagina = botao.pagina
		
			auxFuncs.saveTable(vetorPalavras,botao.arquivoCC)
			M.uploadFiles({
				arquivo = botao.arquivoCC,
				pasta = botao.pasta
			})
			-- separar em conceitos e conhecimentos
			local conceitos = {}
			local conhecimentos = {}
			local PConceitos = {}
			local PConhecimentos = {}
			
			for i=1,#vetorPalavras do
				if vetorPalavras[i][2] then
					table.insert(conceitos,vetorPalavras[i][1])
				end
				if vetorPalavras[i][3] then
					table.insert(conhecimentos,vetorPalavras[i][1])
				end
				if vetorPalavras[i][4] then
					table.insert(PConceitos,vetorPalavras[i][1])
				end
				if vetorPalavras[i][5] then
					table.insert(PConhecimentos,vetorPalavras[i][1])
				end
			end
			-- criar arquivos dos mesmos
			auxFuncs.saveTable(conceitos,botao.vetorNomes[1].."_"..botao.nomeSelecaoMP..".json")
			auxFuncs.saveTable(conhecimentos,botao.vetorNomes[2].."_"..botao.nomeSelecaoMP..".json")
			auxFuncs.saveTable(PConceitos,botao.vetorNomes[3].."_"..botao.nomeSelecaoMP..".json")
			auxFuncs.saveTable(PConhecimentos,botao.vetorNomes[4].."_"..botao.nomeSelecaoMP..".json")
			-- fazer upload dos mesmos
			local checagemDeEnvio = {}
			for i=1,#botao.vetorNomes do
				local function aposEnviarFalhar()
					if i == #botao.vetorNomes then
						native.showAlert("Atenção!","Os tokens foram salvos localmente, mas não é possível realizar o envio dos tokens neste momento!\n\nPor favor verifique sua conexão com a internet e depois tente realizar o envio novamente! Se o problema persistir, contate o suporte!",{"OK"})
					end
				end
				local function aposEnviarSucesso()
					table.insert(checagemDeEnvio,true)
					if i == #botao.vetorNomes and #botao.vetorNomes == #checagemDeEnvio then
						native.showAlert("Sucesso!","Os tokens foram salvos e enviados com sucesso!",{"OK"})
					end
				end
				M.uploadFiles({
					arquivo = botao.vetorNomes[i].."_"..botao.nomeSelecaoMP..".json",
					pasta = botao.pasta,
					aposEnviar = aposEnviarSucesso,
					aposFalhar = aposEnviarFalhar
				})
			end
		end
		
		botao.G.botaoSepararCC = auxFuncs.createNewButton({
			width = 230,
			height = 60,
			shape = "roundedRect",
			radius = 5,
			label = "SALVAR TOKENS",
			font = "Fontes/ariblk.ttf",
			size = 24,
			strokeWidth = 2,
			strokeColor = {default = {0,0,0,1},over = {0,0,0,.7}},
			labelColor = {default = {1,1,1,1},over = {1,1,1,.7}},
			onRelease = botao.G.criarArquivosTxTDeConceitosEConhecimentos
		})
		
		botao.G.botaoSepararCC.anchorX=1
		botao.G.botaoSepararCC.x = W - botao.G.botaoSepararCC.width/2 - 65
		botao.G.botaoSepararCC.anchorY=1
		botao.G.botaoSepararCC.y = H - botao.G.botaoSepararCC.height/2 - 180
		botao.G:insert(botao.G.botaoSepararCC)
		
		botao.G.editarLegenda = display.newText("P/Aluno-Conteudista",0,0,"calibri.ttf",26)
		botao.G.editarLegenda:setFillColor(0,0,0)
		botao.G.editarLegenda.anchorX = 1
		botao.G.editarLegenda.y = 1120; botao.G.editarLegenda.x = W-65
		botao.G:insert(botao.G.editarLegenda)
		
		
		
		-- criar botão de fechar
		botao.G.fecharMenuConfig = function(evento)
			if evento.target.clicado == false  then
				
				audio.stop()
				media.stopSound()
				timer.performWithDelay(1000,function() evento.target.clicado = false end,1)
				local som = audio.loadStream("TTS_cliqueDuasVezes.mp3")
				audio.play(som)
				evento.target.clicado = true
			end
			if evento.target.clicado == true then
				evento.target.clicado = false
				audio.stop()
				media.stopSound()
				botao.G.fechar:setEnabled(false)
				local som = audio.loadStream("TTS_fechando.mp3")
				local function onComplete()
					botao.G:removeSelf()
				end
				evento.target:removeEventListener("tap",botao.G.fecharMenuConfig)
				timerRequerimento = timer.performWithDelay(16,function() audio.play(som,{onComplete = onComplete}) end,1)
				audio.stop()
				media.stopSound()
			end
			return true
		end
		
		botao.G.fechar = widget.newButton {
			onRelease = botao.G.fecharMenuConfig,
			emboss = false,
			-- Properties for a rounded rectangle button
			defaultFile = "closeMenuButton2.png",
			overFile = "closeMenuButton2D.png"
		}
		botao.G.fechar.clicado = false
		botao.G.fechar.anchorX=1
		botao.G.fechar.anchorY=0
		botao.G.fechar.x = W - 55
		botao.G.fechar.y = 107
		botao.G:insert(botao.G.fechar)
		botao.clicado = false
		
		function botao.changeOrientation()
			if system.orientation ~= "portrait" then
				botao.G.x = 285
				botao.G.y = -285
				botao.G.telaProtetiva.width = H
				botao.G.telaProtetiva.height = W
				botao.G.MenuConfig.width = H + 60
				botao.G.MenuConfig.height = 800
				botao.G.tableViewResults:removeSelf()
				botao.G.tableViewResults = nil
				botao.G.tableViewResults = widget.newTableView(
					{
						height = 300,
						width = 1000,
						onRowRender = botao.G.gerarLinha,
						onRowTouch = botao.G.editarPalavra,
						listener = scrollListener,
						rowTouchDelay =0
					}
				)
				botao.G.tableViewResults.x = W/2
				botao.G.tableViewResults.y = botao.G.tableViewResults.height/2 + 500
				botao.G:insert(botao.G.tableViewResults)
				botao.G.createAllRows()
			else
				botao.G.x = 0
				botao.G.y = 0
				botao.G.MenuConfig.width = W + 60
				botao.G.MenuConfig.height = H + 60
				botao.G.tableViewResults:removeSelf()
				botao.G.tableViewResults = nil
				botao.G.tableViewResults = widget.newTableView(
					{
						height = 600,
						width = 600,
						onRowRender = botao.G.gerarLinha,
						onRowTouch = botao.G.editarPalavra,
						listener = scrollListener,
						rowTouchDelay =0
					}
				)
				botao.G.tableViewResults.x = W/2
				botao.G.tableViewResults.y = 400 + botao.G.tableViewResults.height/2
				botao.G:insert(botao.G.tableViewResults)
				botao.G.createAllRows()
			end
		end
		--Runtime:addEventListener("orientation",botao.changeOrientation)
		return true
	end
end

function M.criarMenuPersonalizacaoProfessor(atrib,Var)
	local G = display.newGroup()
	local retangulo = atrib.retangulo or {x=0,y=0,width=300,height=70}
	local varGlobal = atrib.varGlobal
	local vetorNomes = {"MP_Aconceitos","MP_Aconhecimentos","MP_Pconceitos","MP_Pconhecimentos"}
	
	-- pegando arquivo de upload de arquivos
	local params = {}
	params.progress = true
	-- colocando na nuvem -----------------------------------------------------------------
	-- 1 - Primeiro verificar se existe uma pasta do livro, verificando o arquivo 
	-- upload.php que tem que existir na pasta.
	-- 2 - se não exitir, mandar criar uma pasta usando o url: 
	-- "https://coronasdkgames.com/libEA 2/CadastrarHistorico.php"
	-- 3 - caso exista, usar usar o url "https://coronasdkgames.com/libEA 2/upload.php"
	-- para mandar e baixar os arquivos de imagem, video etc.
	---------------------------------------------------------------------------------------
	-- VERIFICANDO
	M.verificarPastaOuCriar(varGlobal.codigoLivro1)

	atrib.contentType = "application/json"
	atrib.url = "https://omniscience42.com/EAudioBookDB/upload.php"
	--M.uploadFiles(atrib)
	---------------------------------------------------------------------------------------
	G.botaoEditarCC = auxFuncs.createNewButton({
		width = retangulo.height-20,
		height = retangulo.height-30,
		defaultFile = "professor.png",
		onRelease = function(event)
			G.botaoEditarCC.pegarPalavras(event)
		end
	})
	G.botaoEditarCC.btn.clicado = false
	G.botaoEditarCC.btn.pagina = atrib.tela.paginaHistorico
	G.botaoEditarCC.x = (-1*retangulo.width/2) + G.botaoEditarCC.width/2 + 5
	G:insert(G.botaoEditarCC)
	if auxFuncs.fileExistsDoc("MP_NomeSelecao.txt") then
		Var.nomeArquivoSelecaoMP = auxFuncs.lerTextoDoc("MP_NomeSelecao.txt")
	end
	if auxFuncs.fileExistsDoc("MP_NomeLivro.txt") then
		Var.nomeLivroSelecaoMP = auxFuncs.lerTextoDoc("MP_NomeLivro.txt")
	else
		Var.nomeArquivoSelecaoMP = nil
	end
	G.botaoEditarCC.pegarPalavras = function(event)
		local textoPalavras = atrib.textoPalavras
		Var.nomeArquivoSelecaoMP = nil
		Var.nomeLivroSelecaoMP = nil
		if auxFuncs.fileExistsDoc("Paginas Mescladas.txt") then
			Var.nomeArquivoSelecaoMP = auxFuncs.lerTextoDoc("MP_NomeSelecao.txt")
			Var.nomeLivroSelecaoMP = auxFuncs.lerTextoDoc("MP_NomeLivro.txt")
			textoPalavras = M.filtrarTextosDePagina("Paginas Mescladas.txt")
		end
		if Var.nomeArquivoSelecaoMP then
			local vetorPalavras = {}
			if textoPalavras then
				print("textoPalavras = ",textoPalavras)
				local vetorPalavrasAux = M.filtrarPalavrasDeTextos(textoPalavras)
				for i=1,#vetorPalavrasAux do
					table.insert(vetorPalavras,{vetorPalavrasAux[i],false,false,false,false})
				end
			end
			atrib.arquivo = "MP_listaPalavras_"..Var.nomeArquivoSelecaoMP..".json"
			if auxFuncs.fileExistsDoc(atrib.arquivo) then
				vetorPalavras = auxFuncs.loadTable(atrib.arquivo)
			else
				auxFuncs.saveTable(vetorPalavras,atrib.arquivo)
			end
			G.botaoEditarCC.btn.vetorPalavras = vetorPalavras
			G.botaoEditarCC.btn.arquivoCC = atrib.arquivo
			G.botaoEditarCC.btn.pasta = Var.nomeLivroSelecaoMP
			G.botaoEditarCC.btn.nomeSelecaoMP = Var.nomeArquivoSelecaoMP
			G.botaoEditarCC.btn.vetorNomes = vetorNomes
			if Var.GMenuBotao then Var.GMenuBotao:removeSelf();Var.GMenuBotao = nil end
			M.abrirMenuDeSelecaoDePalavras(event)
		else
			native.showAlert("Atenção!","Selecione um material antes de prosseguir para a classificação dos Tokens!",{"OK"})
		end
	end
	
	G.botaoVerificarConhecimentos = auxFuncs.createNewButton({
		width = retangulo.height-30,
		height = retangulo.height-30,
		defaultFile = "criarConhecimento.png",
		onRelease = function(event)
			if Var.nomeArquivoSelecaoMP then
				if Var.GMenuBotao then Var.GMenuBotao:removeSelf();Var.GMenuBotao = nil; end
				local arquivo = "MP_listaPalavras_"..Var.nomeArquivoSelecaoMP..".json"
				G.botaoVerificarConhecimentos.btn.arquivoCC = arquivo
				G.botaoVerificarConhecimentos.btn.pasta = Var.nomeLivroSelecaoMP
				G.botaoVerificarConhecimentos.btn.nomeSelecaoMP = Var.nomeArquivoSelecaoMP
				G.botaoVerificarConhecimentos.btn.vetorNomes = vetorNomes
				M.abrirVizualizacaoCC(event)
			else
				native.showAlert("Atenção!","Selecione um material antes de verificar os conhecimentos!",{"OK"})
			end
		end
	})
	G.botaoVerificarConhecimentos.btn.clicado = false
	G.botaoVerificarConhecimentos.x = G.botaoEditarCC.x + G.botaoEditarCC.width/2 + G.botaoVerificarConhecimentos.width/2 + 10
	G.botaoVerificarConhecimentos.btn.tipo = "conhecimentos"
	
	G:insert(G.botaoVerificarConhecimentos)
	
	G.botaoVerificarConceito = auxFuncs.createNewButton({
		width = retangulo.height-30,
		height = retangulo.height-30,
		defaultFile = "criarConceito.png",
		onRelease = function(event) 
			if Var.nomeArquivoSelecaoMP then
				if Var.GMenuBotao then Var.GMenuBotao:removeSelf();Var.GMenuBotao = nil; end
				local arquivo = "MP_listaPalavras_"..Var.nomeArquivoSelecaoMP..".json"
				G.botaoVerificarConceito.btn.arquivoCC = arquivo
				G.botaoVerificarConceito.btn.pasta = Var.nomeLivroSelecaoMP
				G.botaoVerificarConceito.btn.nomeSelecaoMP = Var.nomeArquivoSelecaoMP
				G.botaoVerificarConceito.btn.vetorNomes = vetorNomes
				M.abrirVizualizacaoCC(event)
			else
				native.showAlert("Atenção!","Selecione um material antes de verificar os conceitos!",{"OK"})
			end
		end
	})
	G.botaoVerificarConceito.btn.clicado = false
	G.botaoVerificarConceito.x = G.botaoVerificarConhecimentos.x + G.botaoVerificarConhecimentos.width/2 + G.botaoVerificarConceito.width/2 + 10
	G.botaoVerificarConceito.btn.tipo = "conceitos"
	G:insert(G.botaoVerificarConceito)
	
	return G
end

function M.criarMenuPersonalizacaoConteudista(atrib)
	local G = display.newGroup()
	local varGlobal = atrib.varGlobal
	local retangulo = atrib.retangulo or {x=0,y=0,width=300,height=70}
	local varGlobal = atrib.varGlobal
	local vetorNomes = {"AconceitosPag"..atrib.tela.paginaHistorico..".json","AconhecimentosPag"..atrib.tela.paginaHistorico..".json","PconceitosPag"..atrib.tela.paginaHistorico..".json","PconhecimentosPag"..atrib.tela.paginaHistorico..".json"}
	atrib.arquivo = "listaPalavrasParaProfessorPag"..atrib.tela.paginaHistorico..".json"
	
	G.botaoVerificarConhecimentos = auxFuncs.createNewButton({
		width = retangulo.height-30,
		height = retangulo.height-30,
		defaultFile = "criarConhecimento.png",
		onRelease = M.abrirEdicaoCC
	})
	G.botaoVerificarConhecimentos.btn.clicado = false
	G.botaoVerificarConhecimentos.btn.vetorPalavras = {}--vetorPalavras
	G.botaoVerificarConhecimentos.btn.pasta = varGlobal.codigoLivro1
	G.botaoVerificarConhecimentos.btn.tipo = "conhecimentos"
	G.botaoVerificarConhecimentos.btn.pagina = atrib.tela.paginaHistorico
	G.botaoVerificarConhecimentos.btn.vetorNomes = vetorNomes
	G.botaoVerificarConhecimentos.x = (-1*retangulo.width/2) + G.botaoVerificarConhecimentos.width/2 + 5
	G:insert(G.botaoVerificarConhecimentos)
	
	G.botaoVerificarConceito = auxFuncs.createNewButton({
		width = retangulo.height-30,
		height = retangulo.height-30,
		defaultFile = "criarConceito.png",
		onRelease = M.abrirEdicaoCC
	})
	G.botaoVerificarConceito.btn.clicado = false
	G.botaoVerificarConceito.x = G.botaoVerificarConhecimentos.x + G.botaoVerificarConhecimentos.width/2 + G.botaoVerificarConceito.width/2 + 10
	G.botaoVerificarConceito.btn.tipo = "conceitos"
	G.botaoVerificarConceito.btn.pasta = varGlobal.codigoLivro1
	G.botaoVerificarConceito.btn.vetorNomes = vetorNomes
	G.botaoVerificarConceito.btn.pagina = atrib.tela.paginaHistorico
	G:insert(G.botaoVerificarConceito)
	
	return G
end

function M.criarMenuPersonalizacaoAluno(atrib,Var)
	local G = display.newGroup()
	local varGlobal = atrib.varGlobal
	local retangulo = atrib.retangulo or {x=0,y=0,width=300,height=70}
	local varGlobal = atrib.varGlobal
	local vetorNomes = {"Aconceitos","Aconhecimentos","Pconceitos","Pconhecimentos"}

		
	if auxFuncs.fileExistsDoc("MA_NomeSelecao.txt") then
		Var.nomeArquivoSelecaoMA = auxFuncs.lerTextoDoc("MP_NomeSelecao.txt")
	end
	if auxFuncs.fileExistsDoc("MA_NomeLivro.txt") then
		Var.nomeLivroSelecaoMA = auxFuncs.lerTextoDoc("MP_NomeLivro.txt")
	else
		Var.nomeArquivoSelecaoMA = nil
	end
	
	G.botaoSelecionarCC = auxFuncs.createNewButton({
		width = retangulo.height-30,
		height = retangulo.height-30,
		defaultFile = "CC icon.png",
		onRelease = function(event)
			local vetorSelecoes = {}
			Var.nomeArquivoSelecaoMA = nil
			Var.nomeLivroSelecaoMA = nil
			if auxFuncs.fileExistsDoc("MA_NomeSelecao.txt") then
				Var.nomeArquivoSelecaoMA = auxFuncs.lerTextoDoc("MA_NomeSelecao.txt")
				Var.nomeLivroSelecaoMA = auxFuncs.lerTextoDoc("MA_NomeLivro.txt")
				vetorSelecoes = auxFuncs.loadTable("MP_listaPalavras_"..Var.nomeArquivoSelecaoMA..".json")
				if auxFuncs.fileExistsDoc("MA_listaPalavras_"..Var.nomeArquivoSelecaoMA..".json") then -- verificar se o aluno já fez alguma seleção anteriormente
					vetorSelecoes = auxFuncs.loadTable("MA_listaPalavras_"..Var.nomeArquivoSelecaoMA..".json")
				end
			end
			
			if Var.nomeArquivoSelecaoMA then
				event.target.vetorPalavras = vetorSelecoes
				event.target.pasta = Var.nomeLivroSelecaoMA
				event.target.nomeArquivoSelecaoMA = Var.nomeArquivoSelecaoMA
				M.abrirEscolhaCCAluno(event)
			else
				native.showAlert("Atenção!","Você deve selecionar um material antes de poder escolher os tokens!",{"OK"})
			end
		end
	})
	G.botaoSelecionarCC.btn.clicado = false
	G.botaoSelecionarCC.btn.tipo = "conhecimentos"
	G.botaoSelecionarCC.btn.alunoID = atrib.tela.idAluno1
	G.botaoSelecionarCC.btn.pagina = atrib.tela.paginaHistorico
	G.botaoSelecionarCC.btn.vetorNomes = vetorNomes
	G.botaoSelecionarCC.x = (-1*retangulo.width/2) + G.botaoSelecionarCC.width/2 + 5
	G:insert(G.botaoSelecionarCC)
	
	return G
end

return M