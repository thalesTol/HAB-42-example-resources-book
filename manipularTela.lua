local M = {}
local W = display.viewableContentWidth ;
local H = display.viewableContentHeight;
--RemoverTela(Var2)
--criarVetorDasPaginas(vetorPaginas)
--criarImagensDasPaginas(vetorTelas)

local elemTela = require "elementosDaTela"
local leitArqTxt = require "leituraArquivosTxT"
local auxFuncs = require "ferramentasAuxiliares"
local validarUTF8 = require("utf8Validator")
local conversor = require("conversores")
local MenuRapido = require("MenuBotaoDireito")
local historicoLib = require("historico")

--M.criarVetorTeladeArquivo({pasta = "PaginasPre",arquivo = telas.arquivos[pagina]},telas,{},pagina,nomeArquivo)
function M.mudarTamanhoFonte(atrib,grupoTela)
	local tela = atrib.tela
	aumentouOSom = true
	local grupoTravarTela = display.newGroup()
	local telaPreta = auxFuncs.TelaProtetiva()
	local texto = display.newText("aguarde",W/2,H/2,"Fontes/segoeuib.ttf",50)
	texto:setFillColor(0,0,0)
	grupoTravarTela:insert(telaPreta)
	grupoTravarTela:insert(texto)
	
	local function rodarPaginaAumentada(atrib,tela)

		if atrib.acao == "aumentar" then
			
			local subPagina = tela.subPagina
			historicoLib.Criar_e_salvar_vetor_historico({
				tipoInteracao = "texto",
				pagina_livro = tela.pagina,
				objeto_id = atrib.contador,
				acao = "aumentar",
				tamanho_anterior = tela.textos[atrib.contador].tamanho,
				tamanho_novo = tela.textos[atrib.contador].tamanho + 5,
				subPagina = subPagina,
				tela = tela
			})
		elseif atrib.acao == "diminuir" then
			
			local subPagina = tela.subPagina
			historicoLib.Criar_e_salvar_vetor_historico({
				tipoInteracao = "texto",
				pagina_livro = tela.pagina,
				objeto_id = atrib.contador,
				acao = "diminuir",
				tamanho_anterior = tela.textos[atrib.contador].tamanho,
				tamanho_novo = tela.textos[atrib.contador].tamanho + 5,
				subPagina = subPagina,
				tela = tela
			})
		end
		local function funcaoMudarTamanhoGenerica(e,txt,tipo)
			local auxtamanho
			local auxsubtamanho
			local mudancaTamanho
			local textoY
			--local txt = atrib.contador
			if tipo == "imageText" then
				textoY = tela.imagemTextos[txt].y
			else
				textoY = tela.textos[txt].y
			end

			if atrib.acao == "aumentar" then
				if tipo == "imageText" then
					if tela.imagemTextos and tela.imagemTextos[txt].tamanho then
						auxtamanho = tela.imagemTextos[txt].tamanho
						tela.imagemTextos[txt].tamanho = auxtamanho + 5
						if tela.imagemTextos[txt].modificou then
							tela.imagemTextos[txt].modificou = tela.imagemTextos[txt].modificou + 5
						else
							tela.imagemTextos[txt].modificou = 5
						end
						local textoTeste = ead.colocarImagemTexto(tela.imagemTextos[txt])
						mudancaTamanho = textoTeste.height - atrib.event.target.height
						textoTeste:removeSelf()
					end
					--mudancaTamanho = e.target.HMaior - e.target.HAtual
				else
					if tela.textos and tela.textos[txt].tamanho then
						auxtamanho = tela.textos[txt].tamanho
						tela.textos[txt].tamanho = auxtamanho + 5
						if tela.textos[txt].modificou then
							tela.textos[txt].modificou = tela.textos[txt].modificou + 5
						else
							tela.textos[txt].modificou = 5
						end
						local textoTeste = elemTela.colocarTexto(tela.textos[txt],tela)
						mudancaTamanho = textoTeste.height - atrib.event.target.height
						textoTeste:removeSelf()
						textoTeste=nil
					end
					--mudancaTamanho = e.target.HMaior - e.target.HAtual
				end
			elseif atrib.acao == "diminuir" then
				if tipo == "imageText" then
					if tela.imagemTextos and tela.imagemTextos[txt].tamanho then
						auxtamanho = tela.imagemTextos[txt].tamanho
						tela.imagemTextos[txt].tamanho = auxtamanho - 5
						if tela.imagemTextos[txt].modificou then
							tela.imagemTextos[txt].modificou = tela.imagemTextos[txt].modificou - 5
						else
							tela.imagemTextos[txt].modificou = -5
						end
						local textoTeste = ead.colocarImagemTexto(tela.imagemTextos[txt])
						mudancaTamanho = textoTeste.height - atrib.event.target.height
						textoTeste:removeSelf()
					end
					--mudancaTamanho = e.target.HMenor - e.target.HAtual
				else
					if tela.textos and tela.textos[txt].tamanho then
						auxtamanho = tela.textos[txt].tamanho
						tela.textos[txt].tamanho = auxtamanho - 5
						if tela.textos[txt].modificou then
							tela.textos[txt].modificou = tela.textos[txt].modificou - 5
						else
							tela.textos[txt].modificou = -5
						end
						local textoTeste = elemTela.colocarTexto(tela.textos[txt],tela)
						mudancaTamanho = textoTeste.height - atrib.event.target.height
						textoTeste:removeSelf()
					end
					--mudancaTamanho = e.target.HMenor - e.target.HAtual
				end
			end
			grupoTela.mudancaTamanho = grupoTela.mudancaTamanho + mudancaTamanho
			if tela.textos then
				for i=1,#tela.textos do
					if tela.textos[i].y > textoY then
						tela.textos[i].y = tela.textos[i].y + mudancaTamanho
					end
				end
			end
			if tela.imagens then
				for i=1,#tela.imagens do
					if tela.imagens[i].y ~= nil and tela.imagens[i].y > textoY then
						tela.imagens[i].y = tela.imagens[i].y + mudancaTamanho
					end
				end
			end
			if tela.exercicios then
				for i=1,#tela.exercicios do
					if tela.exercicios[i].y > textoY then
						tela.exercicios[i].y = tela.exercicios[i].y + mudancaTamanho
					end
				end
			end
		
			if tela.videos then
				for i=1,#tela.videos do
					if tela.videos[i].y > textoY then
						tela.videos[i].y = tela.videos[i].y + mudancaTamanho
					end
				end
			end
			if tela.animacoes then
				for i=1,#tela.animacoes do
					if tela.animacoes[i].y > textoY then
						tela.animacoes[i].y = tela.animacoes[i].y + mudancaTamanho
					end
				end
			end
			if tela.botoes then
				for i=1,#tela.botoes do
					if tela.botoes[i].y > textoY then
						tela.botoes[i].y = tela.botoes[i].y + mudancaTamanho
					end
				end
			end
			if tela.imagemTextos then
				for i=1,#tela.imagemTextos do
					if tela.imagemTextos[i].y > textoY then
						tela.imagemTextos[i].y = tela.imagemTextos[i].y + mudancaTamanho
					end
				end
			end
			if tela.sons then
				for i=1,#tela.sons do
					if tela.sons[i].y > textoY then
						tela.sons[i].y = tela.sons[i].y + mudancaTamanho
					end
				end
			end
			if tela.espacos then
				for i=1,#tela.espacos do
					if tela.espacos[i].y > textoY then
						tela.espacos[i].y = tela.espacos[i].y + mudancaTamanho
					end
				end
			end
			if tela.separadores then
				for i=1,#tela.separadores do
					if tela.separadores[i].y > textoY then
						tela.separadores[i].y = tela.separadores[i].y + mudancaTamanho
					end
				end
			end
			grupoTravarTela:removeSelf()
			grupoTravarTela = nil
		end
		if tela.textos then
			--for i=1,#telas[paginaAtual].textos do
				--funcaoMudarTamanhoGenerica(atrib.event,i,"texto")
				funcaoMudarTamanhoGenerica(atrib.event,atrib.contador,"texto")
			--end
		elseif tela.imagemTextos then
			--for i=1,#telas[paginaAtual].imagemTextos do
				--funcaoMudarTamanhoGenerica(atrib.event,i,"imageText")
				funcaoMudarTamanhoGenerica(atrib.event,atrib.contador,"imageText")
			--end
		end
		tempo = nil
		--criarCursoAux(telas, paginaAtual)
		if grupoTela.refazer then
			grupoTela.refazer(tela)
		end
	end

	tempo = timer.performWithDelay(100,function()rodarPaginaAumentada(atrib,tela); end,1)
	return true
end

function M.criarVetorTeladeArquivo(atributos,Telas,listaDeErros,iii,nomeArquivo,VetorTTS,substituicoesOnline,paginaAtual,VetorDeVetorTTS)


	local function lerTextoArquivo(arquivo) -- vetor ou variavel
		local path = system.pathForFile( arquivo, system.ResourceDirectory )
		
		
		local xx = 1
		local vetor = {}
		
		if path then
			local file2, errorString = io.open( path, "r" )
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
		end
		return vetor
		
	end

	local imagensNaPasta = lerTextoArquivo(atributos.pasta.."/dllImagens.txt")
	
	local imagens = 0--1
	local textos = 0
	local exercicios = 0
	local videos = 0
	local botoes = 0
	local sons = 0
	local animacoes = 0
	local separadores = 0
	local fundo = 0
	local espacos = 0
	local imagemTextos = 0
	local decks = 0
	local vetorTodas = {{}}
	local VetorPadraoImagem = {}
	local VetorPadraoTexto = {}
	local VetorPadraoExercicio = {}
	local VetorPadraoVideo = {}
	local VetorPadraoSom = {}
	local VetorPadraoAnimacao = {}
	local VetorPadraoBotao = {}
	local VetorPadraoSeparador = {}
	local VetorPadraoEspaco = {}
	local VetorPadraoImagemTexto = {}
	local VetorPadraoDeck = {}
	VetorTTS.audio = {}
	VetorTTS.video = {}
	VetorTTS.animacao = {}
	VetorTTS.botao = {}
	VetorTTS.deck = {}
	
	
	local vetorTela = {}
	local vetorDecks = {}
	vetorDecks[0] = 1
	local vetorTextos = {}
	vetorTextos[0] = 1
	local vetorVideos = {}
	vetorVideos[0] = 1
	local vetorBotoes = {}
	vetorBotoes[0] = 1
	local vetorImagens = {}
	vetorImagens[0] = 1
	local vetorExercicios = {}
	vetorExercicios[0] = 1
	local vetorAnimacoes = {}
	vetorAnimacoes[0] = 1
	local vetorSons = {}
	vetorSons[0] = 1
	local vetorSeparadores = {}
	vetorSeparadores[0] = 1
	local vetorFundo = {}
	vetorFundo[0] = 1
	local vetorEspacos = {}
	vetorEspacos[0] = 1
	local vetorImagemTextos = {}
	vetorImagemTextos[0] = 1
	
	local YinicialVideo = 0
	
	vetorTela.ordemElementos = {}
	
	local function lerArquivoTela()
		
		local path = system.pathForFile( atributos.pasta.."/"..atributos.arquivo, system.ResourceDirectory )
		--print("!20! = ", path)
		if atributos.exercicio then
			path = system.pathForFile( atributos.exercicio.."/"..atributos.arquivo, system.ResourceDirectory )
			--print("!20.5! = ", path)
		end
		local file = nil
		local errorString = nil
		if path then
		-- Open the file handle
			file, errorString = io.open( path, "r" )
		end
		local xx=0
		local ignorar = true
		local comecou = 0
		local primeiro = false
		
		if not file and not atributos.scriptDic then
			-- Error occurred; output the cause
			print( "File error: " .. errorString )
			
		else
			local primeiraLinha = false
			local contents = ""
			if atributos.scriptDic then
				contents = atributos.scriptDic
			else
				contents = file:read( "*a" )
			end
			
			local filtrado = string.gsub(contents,".",{ ["\13"] = "",["\10"] = "\13\10"})
			local is_valid, error_position = validarUTF8.validate(filtrado)
			if not is_valid then 
				filtrado = conversor.converterANSIparaUTFsemBoom(filtrado)
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
						if string.find( line, "imagem com texto" ) ~= nil then
							imagemTextos = imagemTextos + 1
							table.insert(vetorTela.ordemElementos,"imagemTexto")
						elseif string.find( line, "imagem" ) ~= nil or string.find( line, "figura" )then
							line = "1-imagem"
							imagens = imagens + 1
							table.insert(vetorTela.ordemElementos,"imagem")
						elseif string.find( line, "texto" ) ~= nil then
							textos = textos + 1
							table.insert(vetorTela.ordemElementos,"texto")
						elseif string.find( line, "exercicio" ) ~= nil or string.find( line, "questao" ) ~= nil then
							line = "1-exercicio"
							exercicios = exercicios + 1
							table.insert(vetorTela.ordemElementos,"exercicio")
						elseif string.find( line, "video" ) ~= nil then
							videos = videos + 1
							table.insert(vetorTela.ordemElementos,"video")
						elseif string.find( line, "som" ) ~= nil then
							sons = sons + 1
							print("Tem Som: ",line)
							table.insert(vetorTela.ordemElementos,"som")
						elseif string.find( line, "botao" ) ~= nil then
							botoes = botoes + 1
							table.insert(vetorTela.ordemElementos,"botao")
						elseif string.find( line, "animacao" ) ~= nil then
							animacoes = animacoes + 1
							table.insert(vetorTela.ordemElementos,"animacao")
						elseif string.find( line, "separador" ) ~= nil then
							separadores = separadores + 1
							table.insert(vetorTela.ordemElementos,"separador")
						elseif string.find( line, "espaco" ) ~= nil then
							espacos = espacos + 1
							table.insert(vetorTela.ordemElementos,"espaco")
						elseif string.find( line, "card" ) ~= nil then
							decks = decks + 1
							table.insert(vetorTela.ordemElementos,"card")
						elseif string.find( line, "fundo" ) ~= nil then
							fundo = fundo + 1
							table.insert(vetorTela.ordemElementos,"fundo")
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
						local linhaReduzida = line:match("=([^=]+)")
						if linhaReduzida then -- mudança 12/11/2021 devido a palavra seguida de igual sem texto posterior
							vetorTodas[comecou][xx] = line
						end
					end
					xx = xx+1
				end
			end
			if file then
				io.close( file )
			end
		end
		VetorPadraoTextoImagem = vetorTodas
		Telas.Ordem = vetorTodas
		file = nil
		return true
	end
	
	local achouImagemTela = false
	
	if atributos.vetorTelaPronto and atributos.vetorTelaPronto ~= {} then
		vetorTodas = atributos.vetorTelaPronto
	end
	
	if atributos.exercicio then
		atributos.pasta2 = atributos.pasta
		atributos.pasta = atributos.exercicio
		print("PASTAS NOVAS EXERCICIO",atributos.pasta2,atributos.pasta)
				
		
		textos = textos + 1
		--textos = 1
		vetorTextos[1] = {texto = atributos.correta,y=100,x=nil,cor = {192,0,0},tamanho = 40,alinhamento = "meio"}
		table.insert(vetorTela.ordemElementos,"texto")
		
		textos = textos + 1
		--textos = 1
		vetorTextos[2] = {texto = atributos.tempoResposta,y=0,x=nil,cor = {0,0,0},tamanho = 30,alinhamento = "meio"}
		table.insert(vetorTela.ordemElementos,"texto")

		if (string.find(string.lower(vetorTextos[1].texto),"acertou") or string.find(string.lower(vetorTextos[1].texto),"correta") or string.find(string.lower(vetorTextos[1].texto),"correto") or string.find(string.lower(vetorTextos[1].texto),"parabéns")) and not (string.find(string.lower(vetorTextos[1].texto),"incorret") or string.find(string.lower(vetorTextos[1].texto),"não") or string.find(string.lower(vetorTextos[1].texto),"estude")) then
			vetorTextos[1].cor = {27,141,8}
		end
		
		local aux = string.gsub(vetorTextos[1].texto,"#t=%d+#","")
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
		
		if vetorTextos[1].atributoALT and vetorTextos[1].atributoALT ~= nil then
			table.insert( VetorTTS,"!\n\n\n!" .. vetorTextos[1].atributoALT )
		else
			table.insert( VetorTTS,"!\n\n\n!" .. aux )
		end
		
		--YinicialVideo = YinicialVideo + 200 + auxProx + 100
	end
	
	lerArquivoTela()
	
	--local YinicialVideo = 1000
	local espacoPixels = 10
	
	if nomeArquivo and auxFuncs.fileExists(atributos.pasta.."/TTS/"..nomeArquivo..".txt") == true then
		local caminhoAux = system.pathForFile(atributos.pasta.."/TTS/"..nomeArquivo..".txt",system.ResourceDirectory)
		--caminhoAux = string.gsub(caminhoAux,"/"..nomeArquivo,"")
		--print("WARNING: "..tostring(caminhoAux))
		local textoTTS2 = leitArqTxt.lerArquivoTXTCaminho({caminho = caminhoAux,arquivo = nomeArquivo, tipo = "texto"})
		
		
		local rodape = ""
		
		local is_valid, error_position = validarUTF8.validate(textoTTS2)
		if not is_valid then 
			--print('non-utf8 sequence detected at position ' .. tostring(error_position))
			textoTTS2 = conversor.converterANSIparaUTFsemBoom(textoTTS2)
		end
		--textoTTS = conversor.converterANSIparaUTFsemBoom(textoTTS)
		if atributos.TTSTipo and atributos.TTSTipo == "RSS" then
			textoTTS2 = conversor.converterTextoParaFala(textoTTS2,substituicoesOnline,atributos.TTSTipo)
		end
		if type(Telas) == "number" then
			table.insert(VetorTTS,textoTTS2.."\n")
		else
			table.insert(VetorTTS,textoTTS2.."\n")
		end
	end
	local contadorElementos = 0
	if vetorTodas[1] ~= nil and vetorTodas[1][0] ~= nil then
		local proximaPosicao = 0
		local numeroCard = 1
		for i=1,#vetorTodas do
			--os.execute("sleep " .. tonumber(10))
			
			--print(atributos.pasta,atributos.arquivo)
			--print(vetorTodas[i][0])
			--print(vetorTodas[i][0])
			
			if string.find( vetorTodas[i][0], "imagem com texto" ) ~= nil then
				local padrao = {}
				--thales2 imagem com texto
				contadorElementos = contadorElementos + 1
				
				if auxFuncs.fileExists(atributos.pasta.."/Config Padrao ImagemTexto.txt") == true then
					VetorPadraoImagemTexto = leitArqTxt.criarImagemTextosDeArquivoPadrao({pasta = atributos.pasta,arquivo = "Config Padrao ImagemTexto.txt",substituicoesOnline = substituicoesOnline},listaDeErros)
					padrao = VetorPadraoImagemTexto
				elseif atributos.pasta2 and auxFuncs.fileExists(atributos.pasta.."/Config Padrao ImagemTexto.txt") == true then
					VetorPadraoImagemTexto = leitArqTxt.criarImagemTextosDeArquivoPadrao({pasta = atributos.pasta2,arquivo = "Config Padrao ImagemTexto.txt",substituicoesOnline = substituicoesOnline},listaDeErros)
					padrao = VetorPadraoImagemTexto
				else
					padrao = {
						arquivo = atributos.pasta.."/Outros Arquivos/imagemErro.jpg",
						atributoALT = nil,
						altura = nil,
						comprimento = nil,
						posicao = "esquerda",
						zoom = "sim",
						urlImagem = nil,
						x = nil,
						y = nil,
						texto = "(Erro no texto)",
						urlTexto = {"sim"},
						urlEmbeded = nil,
						tamanho = 40,
						negrito = "nao",
						fonte = nil,
						margem = 0,
						distancia = 0,
						alinhamento = "meio",
						cor = {180,180,180}
					}
				end
				--padrao.atributoALT = "Imagem sem descrição"
						
				vetorTodas[i].arquivo = padrao.arquivo
				vetorTodas[i].atributoALT = padrao.atributoALT
				vetorTodas[i].altura = padrao.altura
				vetorTodas[i].comprimento = padrao.comprimento
				vetorTodas[i].posicao = padrao.posicao
				vetorTodas[i].zoom = padrao.zoom
				vetorTodas[i].x = padrao.x
				vetorTodas[i].y = padrao.y
				vetorTodas[i].urlImagem = padrao.url1
				vetorTodas[i].texto = padrao.texto
				vetorTodas[i].urlTexto = padrao.url
				vetorTodas[i].urlEmbeded = padrao.urlEmbeded
				vetorTodas[i].tamanho = padrao.tamanho
				vetorTodas[i].negrito = padrao.negrito
				vetorTodas[i].fonte = padrao.fonte
				vetorTodas[i].alinhamento = padrao.alinhamento
				vetorTodas[i].cor = padrao.cor
				vetorTodas[i].margem = padrao.margem
				vetorTodas[i].distancia = padrao.distancia
				
				leitArqTxt.criarImagemTextosDeArquivoPadraoAux(vetorTodas[i],padrao,atributos,listaDeErros)
				
				-- verificar se imagem está imagem com arquivo txt
				
				if achouImagemTela == false then
					local aux = string.sub(atributos.arquivo,1,#atributos.arquivo-4)
					local aux2 = string.gsub(vetorTodas[i].arquivo,atributos.pasta.."/Outros Arquivos/","")
					aux2 = string.gsub(vetorTodas[i].arquivo,atributos.pasta.."\\Outros Arquivos\\","")
					if imagensNaPasta ~= {} then
						for k=1,#imagensNaPasta do
							if (imagensNaPasta[k] == aux..".png" or imagensNaPasta[k] == aux..".PNG" or imagensNaPasta[k] == aux..".jpg" or imagensNaPasta[k] == aux..".JPG" or imagensNaPasta[k] == aux..".BMP" or imagensNaPasta[k] == aux..".bmp") and (aux2 == aux..".png" or aux2 == aux..".PNG" or aux2 == aux..".jpg" or aux2 == aux..".JPG" or aux2 == aux..".BMP" or aux2 == aux..".bmp") then
								local arquivoTeste = string.gsub(vetorTodas[i].arquivo,"Outros Arquivos/","")
								arquivoTeste = string.gsub(vetorTodas[i].arquivo,"Outros Arquivos\\","")
								vetorTodas[i].arquivo = arquivoTeste
								achouImagemTela = true
							end
						end
					end
				end
				---------------------------------------------------
				local aux = string.gsub(vetorTodas[i].texto,"#t=%d+#","")
				aux = string.gsub(aux,"#/t=%d+#","")
				aux = string.gsub(aux,"#l%d+#","")
				aux = string.gsub(aux,"#/l%d+#","")
				aux = string.gsub(aux,"#s#","")
				aux = string.gsub(aux,"#/s#","")
				aux = string.gsub(aux,"#n#","")
				aux = string.gsub(aux,"#/n#","")
				table.insert( VetorTTS, "\n\n" .. vetorTodas[i].atributoALT .. ".\n\n\n." .. aux)
				--VetorTTS[#VetorTTS] = conversor.converterANSIparaUTFsemBoom(VetorTTS[#VetorTTS])
				if atributos.TTSTipo and atributos.TTSTipo == "RSS" then
					VetorTTS[#VetorTTS] = conversor.converterTextoParaFala(VetorTTS[#VetorTTS],substituicoesOnline,atributos.TTSTipo)
				end
				if i == 1 then 
				
					--print("imagem "..i.." caiu no 'primeiro'")
					local imagex = display.newImage(vetorTodas[i].arquivo)
					local imagex2 = nil
					if imagex == nil then
						vetorTodas[i].arquivo = padrao.arquivo
						imagex2 = display.newImage(vetorTodas[i].arquivo)
					end
					if imagex == nil and imagex2 == nil then
					
					else
						if imagex ~= nil then
							imagex:removeSelf()
							imagex = nil
						end
						if imagex2 ~= nil then
							imagex2:removeSelf()
							imagex2 = nil
						end
						if vetorTodas[i].y == nil then
							vetorTodas[i].y = 0
						end
						
						if vetorTodas[i].y ~= nil then
							vetorTodas[i].y = vetorTodas[i].y + YinicialVideo
						else
							vetorTodas[i].y = YinicialVideo
						end
						
						vetorImagemTextos[#vetorImagemTextos+1] = {arquivo = vetorTodas[i].arquivo,atributoALT = vetorTodas[i].atributoALT,altura = vetorTodas[i].altura, comprimento = vetorTodas[i].comprimento, posicao = vetorTodas[i].posicao, zoom = vetorTodas[i].zoom, x = vetorTodas[i].x, y = vetorTodas[i].y,urlImagem = vetorTodas[i].urlImagem,texto = vetorTodas[i].texto,urlTexto = vetorTodas[i].urlTexto, tamanho = vetorTodas[i].tamanho,eNegrito = vetorTodas[i].negrito, fonte = vetorTodas[i].fonte,alinhamento = vetorTodas[i].alinhamento,cor = vetorTodas[i].cor,margem = vetorTodas[i].margem,distancia = vetorTodas[i].distancia, index = i,dicionario = vetorTodas[i].dicionario}

					end
				else
					local imagex = display.newImage(vetorTodas[i].arquivo)
					local imagex2 = nil
					if imagex == nil then
						vetorTodas[i].arquivo = padrao.arquivo
						imagex2 = display.newImage(vetorTodas[i].arquivo)
					end
					if imagex == nil and imagex2 == nil then
					
					else
						if imagex ~= nil then
							imagex:removeSelf()
							imagex = nil
						end
						if imagex2 ~= nil then
							imagex2:removeSelf()
							imagex2 = nil
						end
						
						vetorImagemTextos[#vetorImagemTextos+1] = {arquivo = vetorTodas[i].arquivo,atributoALT = vetorTodas[i].atributoALT,altura = vetorTodas[i].altura, comprimento = vetorTodas[i].comprimento, posicao = vetorTodas[i].posicao, zoom = vetorTodas[i].zoom, x = vetorTodas[i].x,urlImagem = vetorTodas[i].urlImagem,texto = vetorTodas[i].texto,urlTexto = vetorTodas[i].urlTexto, tamanho = vetorTodas[i].tamanho,eNegrito = vetorTodas[i].negrito, fonte = vetorTodas[i].fonte,alinhamento = vetorTodas[i].alinhamento,cor = vetorTodas[i].cor,margem = vetorTodas[i].margem,distancia = vetorTodas[i].distancia, y = vetorTodas[i].y, index = i,dicionario = vetorTodas[i].dicionario}
						
					end
				end
				
			elseif string.find( vetorTodas[i][0], "imagem" ) ~= nil then
				local padrao = {}
				--thales2 imagem
				contadorElementos = contadorElementos + 1
				local ImageSize = require "imagesize"
				
				if auxFuncs.fileExists(atributos.pasta.."/Config Padrao Imagem.txt") == true then
					VetorPadraoImagem = leitArqTxt.criarImagensDeArquivoPadrao({pasta = atributos.pasta,arquivo = "Config Padrao Imagem.txt",substituicoesOnline = substituicoesOnline},listaDeErros)
					padrao = VetorPadraoImagem
				elseif atributos.pasta2 and auxFuncs.fileExists(atributos.pasta2.."/Config Padrao Imagem.txt") == true then
					VetorPadraoImagem = leitArqTxt.criarImagensDeArquivoPadrao({pasta = atributos.pasta2,arquivo = "Config Padrao Imagem.txt",substituicoesOnline = substituicoesOnline},listaDeErros)
					padrao = VetorPadraoImagem
					
				else
					padrao = {
						arquivo = atributos.pasta.."/Outros Arquivos/imagemErro.jpg",
						atributoALT = nil,
						conteudo = nil,
						altura = nil,
						comprimento = nil,
						posicao = "topo",
						zoom = "sim",
						url = nil,
						urlembeded = nil,
						margem = 0,
						alinhamento = "meio",
						x = nil,
						y = nil,
						dicionario = nil,
						escala = 1
					}
				end
				--padrao.atributoALT = "Imagem sem descrição"
						
				vetorTodas[i].arquivo = padrao.arquivo
				vetorTodas[i].atributoALT = padrao.atributoALT
				vetorTodas[i].conteudo = padrao.conteudo
				vetorTodas[i].altura = padrao.altura
				vetorTodas[i].comprimento = padrao.comprimento
				vetorTodas[i].posicao = padrao.posicao
				vetorTodas[i].zoom = padrao.zoom
				vetorTodas[i].x = padrao.x
				vetorTodas[i].y = padrao.y
				vetorTodas[i].url = padrao.url
				vetorTodas[i].urlembeded = padrao.urlembeded
				vetorTodas[i].margem = padrao.margem
				vetorTodas[i].alinhamento = padrao.alinhamento
				vetorTodas[i].dicionario = padrao.dicionario
				vetorTodas[i].escala = padrao.escala
				
				leitArqTxt.criarImagensDeArquivoPadraoAux(vetorTodas[i],padrao,atributos,listaDeErros)
				print("ESCALA = ",vetorTodas[i].arquivo,vetorTodas[i].escala)
				-- verificar se imagem está imagem com arquivo txt
				
				if achouImagemTela == false then
					local lenPasta = string.len(atributos.pasta)
					local lenOA = string.len("/Outros Arquivos/")
					local lenTotal = lenPasta + lenOA + 1
					local auxNome = string.sub(atributos.arquivo,1,#atributos.arquivo-4)
					
					local auxImagem = string.sub(vetorTodas[i].arquivo,lenTotal,#vetorTodas[i].arquivo)
					local auxImgSemExt = string.sub(auxImagem,1,#atributos.arquivo-4)

					if string.sub(auxImagem,#auxImagem,#auxImagem) == " " then
						local reverso = string.reverse(auxImagem)
						reverso = string.gsub(reverso,"[ ]+","",1)
						auxImagem = string.reverse(reverso)
					end
					
					if imagensNaPasta ~= {} then
						for k=1,#imagensNaPasta do
							if imagensNaPasta[k] == auxImagem and auxImgSemExt == auxNome then

								local arquivoTeste = atributos.pasta.."/"..auxImagem
								
								vetorTodas[i].arquivo = arquivoTeste
								achouImagemTela = true
							end
						end
					end
				end
				---------------------------------------------------
				if vetorTodas[i].atributoALT then
					if string.len(vetorTodas[i].atributoALT) > 2 then
						table.insert( VetorTTS, "\n\n" .. vetorTodas[i].atributoALT )
						--VetorTTS[#VetorTTS] = conversor.converterANSIparaUTFsemBoom(VetorTTS[#VetorTTS])
						if atributos.TTSTipo and atributos.TTSTipo == "RSS" then
							VetorTTS[#VetorTTS] = conversor.converterTextoParaFala(VetorTTS[#VetorTTS],substituicoesOnline,atributos.TTSTipo)
						end
					end
				end
				if i == 1 then 
				
					if imagex ~= nil then
						imagex:removeSelf()
						imagex = nil
					end
					if imagex2 ~= nil then
						imagex2:removeSelf()
						imagex2 = nil
					end
					if vetorTodas[i].y == nil then
						vetorTodas[i].y = 0
					end
					
					if vetorTodas[i].y ~= nil then
						vetorTodas[i].y = vetorTodas[i].y + YinicialVideo
					else
						vetorTodas[i].y = YinicialVideo
					end
					
					vetorImagens[#vetorImagens+1] = {arquivo = vetorTodas[i].arquivo,atributoALT = vetorTodas[i].atributoALT,altura = vetorTodas[i].altura, comprimento = vetorTodas[i].comprimento, posicao = vetorTodas[i].posicao, zoom = vetorTodas[i].zoom, x = vetorTodas[i].x, y = vetorTodas[i].y,url = vetorTodas[i].url,urlembeded = vetorTodas[i].urlembeded,alinhamento = vetorTodas[i].alinhamento,margem = vetorTodas[i].margem, index = i,conteudo = vetorTodas[i].conteudo,dicionario = vetorTodas[i].dicionario,escala = vetorTodas[i].escala}
				else
					local imagex = display.newImage(vetorTodas[i].arquivo)
					local imagex2 = nil
					if imagex == nil then
						vetorTodas[i].arquivo = padrao.arquivo
						imagex2 = display.newImage(vetorTodas[i].arquivo)
					end
					if imagex == nil and imagex2 == nil then
					
					else
						if imagex ~= nil then
							imagex:removeSelf()
							imagex = nil
						end
						if imagex2 ~= nil then
							imagex2:removeSelf()
							imagex2 = nil
						end
						
						vetorImagens[#vetorImagens+1] = {arquivo = vetorTodas[i].arquivo,atributoALT = vetorTodas[i].atributoALT,altura = vetorTodas[i].altura, comprimento = vetorTodas[i].comprimento, x = vetorTodas[i].x, y = vetorTodas[i].y, zoom = vetorTodas[i].zoom,url = vetorTodas[i].url,urlembeded = vetorTodas[i].urlembeded,alinhamento = vetorTodas[i].alinhamento,margem = vetorTodas[i].margem, index = i,conteudo = vetorTodas[i].conteudo,dicionario = vetorTodas[i].dicionario,escala = vetorTodas[i].escala}
						
					end
				end
						
			elseif string.find( vetorTodas[i][0], "texto" ) ~= nil then
				--thales2 texto
				local padrao = {}
				contadorElementos = contadorElementos + 1
				print("CONFIG PADRAO TEXTO = ",atributos.pasta.."/Config Padrao Texto.txt")
				if auxFuncs.fileExists(atributos.pasta.."/Config Padrao Texto.txt") == true then
					VetorPadraoTexto = leitArqTxt.criarTextosDeArquivoPadrao({pasta = atributos.pasta,arquivo = "Config Padrao Texto.txt",substituicoesOnline = substituicoesOnline},listaDeErros)
					padrao = VetorPadraoTexto
				elseif atributos.pasta2 and auxFuncs.fileExists(atributos.pasta2.."/Config Padrao Texto.txt") == true then
					VetorPadraoTexto = leitArqTxt.criarTextosDeArquivoPadrao({pasta = atributos.pasta2,arquivo = "Config Padrao Texto.txt",substituicoesOnline = substituicoesOnline},listaDeErros)
					padrao = VetorPadraoTexto
					
				else
					padrao = {
						texto = "(Erro no texto)",
						url = {},
						urlEmbeded = nil,
						tamanho = 40,
						negrito = "nao",
						posicao = "topo",
						fonte = nil,
						margem = 0,
						atributoALT = nil,
						alinhamento = "meio",
						cor = {180,180,180},
						x = nil,
						y = nil,
						dicionario = nil,
						espacamento = 0,
						sombra = nil,
						corSombra = nil
					}
				end
				

				vetorTodas[i].texto = padrao.texto
				vetorTodas[i].url = padrao.url
				vetorTodas[i].urlEmbeded = padrao.urlEmbeded
				vetorTodas[i].tamanho = padrao.tamanho
				vetorTodas[i].negrito = padrao.negrito
				vetorTodas[i].posicao = padrao.posicao
				vetorTodas[i].fonte = padrao.fonte
				vetorTodas[i].alinhamento = padrao.alinhamento
				vetorTodas[i].cor = padrao.cor
				vetorTodas[i].margem = padrao.margem
				vetorTodas[i].atributoALT = padrao.atributoALT
				vetorTodas[i].x = padrao.x
				vetorTodas[i].y = padrao.y
				vetorTodas[i].dicionario = padrao.dicionario
				vetorTodas[i].card = atributos.card
				vetorTodas[i].espacamento = padrao.espacamento
				vetorTodas[i].sombra = padrao.sombra
				vetorTodas[i].corSombra = padrao.corSombra
				
				leitArqTxt.criarTextosDeArquivoPadraoAux(vetorTodas[i],padrao,atributos,listaDeErros)
				
				
				--thalesTTS
				local aux = vetorTodas[i].texto
				local vetorpalavras = {}
				for textoAUsar in aux:gmatch("([^ ]+)") do
					table.insert(vetorpalavras,textoAUsar)
				end
				local contadorPalavrasRodape = 1
				local textoAux = ""
				local textoRodape = ""
				for pp=1,#vetorpalavras do
					textoRodape = textoRodape .. "|"..pp.."|" .. vetorpalavras[pp]
					if string.match(vetorpalavras[pp],"%s+") then contadorPalavrasRodape = contadorPalavrasRodape - 1 end
					if string.find(vetorpalavras[pp],"(.+)#/r=.+#") then
						if Telas.vetorRodapes and Telas.vetorRodapes[tostring(Telas.contagemDaPaginaHistorico)] then
							local aux2 = string.match(vetorpalavras[pp],"#/r=(.+)#")
							--local aux = string.sub(textoAUsar,auxR+4,#textoAUsar-2)
							local nRodR = aux2
							local paginaReal = tostring(Telas.contagemDaPaginaHistorico)
							vetorpalavras[pp] = string.gsub(vetorpalavras[pp],"#/r=.+#","")
							local numRodape = 0
							for rod=1,#Telas.vetorRodapes[paginaReal] do
								print("numPalavra1",Telas.vetorRodapes[paginaReal][rod].numPalavra,tostring(contadorPalavrasRodape),Telas.vetorRodapes[paginaReal][rod].numElem,tostring(contadorElementos))
								print(textoRodape)
								if 	Telas.vetorRodapes[paginaReal][rod].numPalavra == tostring(contadorPalavrasRodape) and
									Telas.vetorRodapes[paginaReal][rod].numElem == tostring(contadorElementos) then
									
									numRodape = Telas.vetorRodapes[paginaReal][rod].numRodape
								end
							end
							local auxRodapeFiltrado = auxFuncs.filtrarCodigosSemRodape(vetorpalavras[pp])
							local auxRodape = string.sub(auxRodapeFiltrado,#auxRodapeFiltrado,#auxRodapeFiltrado)
							auxRodapeFiltrado = nil
							if auxRodape == '.' or auxRodape == ';' or auxRodape == ',' or auxRodape == '!' or auxRodape == '?' or auxRodape == ':' then
								vetorpalavras[pp] = string.sub(vetorpalavras[pp],1,#vetorpalavras[pp]-1).." ![rd"..numRodape.."]"..auxRodape
							else
								vetorpalavras[pp] = vetorpalavras[pp].."["..numRodape.."]"
							end
						end
					end
					contadorPalavrasRodape = contadorPalavrasRodape + 1
					textoAux = textoAux .. vetorpalavras[pp] .. " "
				end
				aux = auxFuncs.filtrarCodigos(textoAux)
				print("Texto Depois:",aux)
				
				if vetorTodas[i].atributoALT and vetorTodas[i].atributoALT ~= nil then
					table.insert( VetorTTS,"\n\n" .. vetorTodas[i].atributoALT )
				else
					table.insert( VetorTTS,"\n\n" .. aux )
				end
				--VetorTTS[#VetorTTS] = conversor.converterANSIparaUTFsemBoom(VetorTTS[#VetorTTS])
				if atributos.TTSTipo and atributos.TTSTipo == "RSS" then
					VetorTTS[#VetorTTS] = conversor.converterTextoParaFala(VetorTTS[#VetorTTS],substituicoesOnline,atributos.TTSTipo)
				end
				if i == 1 then 
					--print("texto "..i.." caiu no 'primeiro'")
					
					if vetorTodas[i].y ~= nil then
						vetorTodas[i].y = vetorTodas[i].y + YinicialVideo
					else
						vetorTodas[i].y = YinicialVideo
					end
					
					vetorTextos[#vetorTextos+1] = {texto = vetorTodas[i].texto,url = vetorTodas[i].url,urlEmbeded = vetorTodas[i].urlEmbeded, tamanho = vetorTodas[i].tamanho,eNegrito = vetorTodas[i].negrito, posicao = vetorTodas[i].posicao, fonte = vetorTodas[i].fonte,alinhamento = vetorTodas[i].alinhamento,cor = vetorTodas[i].cor,margem = vetorTodas[i].margem, x = vetorTodas[i].x, y = vetorTodas[i].y,atributoALT = vetorTodas[i].atributoALT, index = i,conteudo = vetorTodas[i].conteudo,dicionario = vetorTodas[i].dicionario,card = vetorTodas[i].card,espacamento = vetorTodas[i].espacamento,sombra = vetorTodas[i].sombra,corSombra = vetorTodas[i].corSombra}
				
				else
					
					vetorTextos[#vetorTextos+1] = {texto = vetorTodas[i].texto,url = vetorTodas[i].url,urlEmbeded = vetorTodas[i].urlEmbeded, tamanho = vetorTodas[i].tamanho,eNegrito = vetorTodas[i].negrito, fonte = vetorTodas[i].fonte,alinhamento = vetorTodas[i].alinhamento,cor = vetorTodas[i].cor,margem = vetorTodas[i].margem, x = vetorTodas[i].x, y = vetorTodas[i].y,atributoALT = vetorTodas[i].atributoALT, index = i,conteudo = vetorTodas[i].conteudo,dicionario = vetorTodas[i].dicionario,card = vetorTodas[i].card,espacamento = vetorTodas[i].espacamento,sombra = vetorTodas[i].sombra,corSombra = vetorTodas[i].corSombra}
					
				end
			elseif string.find( vetorTodas[i][0], "som" ) ~= nil then
				--thales2 som
				local padrao = {}
				contadorElementos = contadorElementos + 1
				if auxFuncs.fileExists(atributos.pasta.."/Config Padrao Som.txt") == true then
					VetorPadraoSom = leitArqTxt.criarSonsDeArquivoPadrao({pasta = atributos.pasta,arquivo = "Config Padrao Som.txt",TTSTipo = atributos.TTSTipo,substituicoesOnline = substituicoesOnline},listaDeErros)
					padrao = VetorPadraoSom
				elseif atributos.pasta2 and auxFuncs.fileExists(atributos.pasta2.."/Config Padrao Som.txt") == true then
					VetorPadraoSom = leitArqTxt.criarSonsDeArquivoPadrao({pasta = atributos.pasta2,arquivo = "Config Padrao Som.txt",TTSTipo = atributos.TTSTipo,substituicoesOnline = substituicoesOnline},listaDeErros)
					padrao = VetorPadraoSom
					
				else
					padrao = {
						arquivo = atributos.pasta.."/OutrosArquivos/som vazio.WAV",
						imagemReiniciar = nil,
						largura = nil,
						altura = nil,
						automatico = "nao",
						imagemPause = "pause 2.png",
						atributoALT = nil,
						conteudo = nil,
						avancar = "nao",
						imagemPauseHeight = nil,
						imagemPauseWidth = nil,
						url = nil,
						x = nil,
						y = nil,
						dicionario = nil
					}
				end
				
				vetorTodas[i].conteudo = padrao.conteudo
				vetorTodas[i].arquivo = padrao.arquivo
				vetorTodas[i].atributoALT = padrao.atributoALT
				vetorTodas[i].imagemReiniciar = padrao.imagemReiniciar
				vetorTodas[i].largura = padrao.largura
				vetorTodas[i].altura = padrao.altura
				vetorTodas[i].avancar = padrao.avancar
				vetorTodas[i].automatico = padrao.automatico
				vetorTodas[i].imagemPause = padrao.imagemPause
				vetorTodas[i].imagemPauseHeight = padrao.imagemPauseHeight
				vetorTodas[i].imagemPauseWidth = padrao.imagemPauseWidth
				vetorTodas[i].url = padrao.url
				vetorTodas[i].x = padrao.x
				vetorTodas[i].y = padrao.y
				vetorTodas[i].dicionario = padrao.dicionario
				
				leitArqTxt.criarSonsDeArquivoPadraoAux(vetorTodas[i],padrao,atributos,listaDeErros)
				print("vetorTodas[i].arquivo ==",vetorTodas[i].arquivo)
				if vetorTodas[i].atributoALT then
					if string.len(vetorTodas[i].atributoALT) > 2 then
						table.insert( VetorTTS,"\n\n Detalhes do áudio:. "..vetorTodas[i].atributoALT)
						
					end
				end
				table.insert( VetorTTS,"\n\n".."Executando ô áudiô")
				VetorTTS.audio[#VetorTTS] = vetorTodas[i].arquivo
				
				local temImagem = "sim"
				
				if i == 1 then 
					--print("texto "..i.." caiu no 'primeiro'")
					
					if vetorTodas[i].y ~= nil then
						vetorTodas[i].y = vetorTodas[i].y + YinicialVideo
					else
						vetorTodas[i].y = YinicialVideo
					end
					
					vetorSons[#vetorSons+1] = {arquivo = vetorTodas[i].arquivo,imagemReiniciar = vetorTodas[i].imagemReiniciar, largura = vetorTodas[i].largura,altura = vetorTodas[i].altura, imagemPause = vetorTodas[i].imagemPause, imagemPauseHeight = vetorTodas[i].imagemPauseHeight,imagemPauseWidth = vetorTodas[i].imagemPauseWidth, x = vetorTodas[i].x, y = vetorTodas[i].y,temImagem = temImagem,automatico = vetorTodas[i].automatico,avancar = vetorTodas[i].avancar,atributoALT = vetorTodas[i].atributoALT, index = i,conteudo = vetorTodas[i].conteudo, url = vetorTodas[i].url,dicionario = vetorTodas[i].dicionario}
					
				else
					
					vetorSons[#vetorSons+1] = {arquivo = vetorTodas[i].arquivo,imagemReiniciar = vetorTodas[i].imagemReiniciar, largura = vetorTodas[i].largura,altura = vetorTodas[i].altura, imagemPause = vetorTodas[i].imagemPause, imagemPauseHeight = vetorTodas[i].imagemPauseHeight,imagemPauseWidth = vetorTodas[i].imagemPauseWidth, x = vetorTodas[i].x, y = vetorTodas[i].y,temImagem = temImagem,automatico = vetorTodas[i].automatico,avancar = vetorTodas[i].avancar,atributoALT = vetorTodas[i].atributoALT, index = i,conteudo = vetorTodas[i].conteudo, url = vetorTodas[i].url,dicionario = vetorTodas[i].dicionario}

				end
			elseif string.find( vetorTodas[i][0], "botao" ) ~= nil then
				--thales2 botao
				local padrao = {}
				contadorElementos = contadorElementos + 1
				if auxFuncs.fileExists(atributos.pasta.."/Config Padrao Botao.txt") == true then
					VetorPadraoBotao = leitArqTxt.criarBotoesDeArquivoPadrao({pasta = atributos.pasta,arquivo = "Config Padrao Botao.txt",substituicoesOnline = substituicoesOnline},listaDeErros)
					padrao = VetorPadraoBotao
				elseif atributos.pasta2 and auxFuncs.fileExists(atributos.pasta2.."/Config Padrao Botao.txt") == true then
					VetorPadraoBotao = leitArqTxt.criarBotoesDeArquivoPadrao({pasta = atributos.pasta2,arquivo = "Config Padrao Botao.txt",substituicoesOnline = substituicoesOnline},listaDeErros)
					padrao = VetorPadraoBotao
				else
					padrao = 
					{
						fundoUp = "fundo-azul.png",
						fundoDown = "fundo-azul-pressionado.png",
						acao = {"irPara"},
						numero = 0,
						altura = nil,
						comprimento = nil,
						titulo = {
							texto = {"Ir para!"},
							tamanho = 40,
							cor = {180,180,180}
						},
						atributoALT = nil,
						conteudo = nil,
						tipo = "texto",
						posicao = "topo",
						som = nil,
						texto = nil,
						video = nil,
						imagem = nil,
						automatico = nil,
						avancar = "nao",
						pause = nil,
						x = nil,
						y = nil,
						url = nil,
						dicionario = nil
					}
				end
				
				vetorTodas[i].conteudo = padrao.conteudo
				vetorTodas[i].fundoUp = padrao.fundoUp
				vetorTodas[i].fundoDown = padrao.fundoDown
				vetorTodas[i].acao = padrao.acao
				vetorTodas[i].numero = padrao.numero
				vetorTodas[i].tamanho = padrao.tamanho
				vetorTodas[i].altura = padrao.altura
				vetorTodas[i].comprimento = padrao.comprimento
				vetorTodas[i].titulo = padrao.titulo
				vetorTodas[i].tipo = padrao.tipo
				vetorTodas[i].posicao = padrao.posicao
				vetorTodas[i].atributoALT = padrao.atributoALT
				vetorTodas[i].som = padrao.som
				vetorTodas[i].texto = padrao.texto
				vetorTodas[i].video = padrao.video
				vetorTodas[i].imagem = padrao.imagem
				vetorTodas[i].automatico = padrao.automatico
				vetorTodas[i].avancar = padrao.avancar
				vetorTodas[i].pause = padrao.pause
				vetorTodas[i].x = padrao.x
				vetorTodas[i].y = padrao.y
				vetorTodas[i].url = padrao.url
				vetorTodas[i].dicionario = padrao.dicionario
				
				leitArqTxt.criarBotoesDeArquivoPadraoAux(vetorTodas[i],padrao,atributos,listaDeErros)
				
				
				--thalesTTS
				--local aux = conversor.converterANSIparaUTFsemBoom(vetorTodas[i].titulo.texto)
				local aux = ""
				for k=1,#vetorTodas[i].titulo.texto do
					aux = aux .. ", " .. vetorTodas[i].titulo.texto[k]
					if atributos.TTSTipo and atributos.TTSTipo == "RSS" then
						aux = conversor.converterTextoParaFala(aux,substituicoesOnline,atributos.TTSTipo)
					end
				end
				if #vetorTodas[i].titulo.texto == 1 and string.find(vetorTodas[i].acao[1],"irPara") then
					table.insert( VetorTTS,"\n\nBotão. " .. aux.. "leva para  a página ".. vetorTodas[i].numero )
				else
					table.insert( VetorTTS,"\n\nBotões. " .. aux )
				end
				local aux = ""
				if vetorTodas[i].atributoALT and #vetorTodas[i].atributoALT > 1 then
					aux = vetorTodas[i].atributoALT
					if atributos.TTSTipo and atributos.TTSTipo == "RSS" then
						aux = conversor.converterTextoParaFala(aux,substituicoesOnline,atributos.TTSTipo)
					end
					table.insert( VetorTTS,"\n\n " .. aux.. "\n\n" )
				end
				if type(vetorTodas[i].acao) == "table" then
					for b=1,#vetorTodas[i].acao do
						if vetorTodas[i].acao[b] == "som" and vetorTodas[i].som then
							table.insert( VetorTTS,"\n\n".."Executando ô áudiô:")
							VetorTTS.audio[#VetorTTS] = vetorTodas[i].som
						elseif vetorTodas[i].acao[b] == "video" and vetorTodas[i].video then
							table.insert( VetorTTS,"\n\n".."Executando o vídeo:")
							VetorTTS.video[#VetorTTS] = vetorTodas[i].video
						elseif vetorTodas[i].acao[b] == "texto" and vetorTodas[i].texto then
							table.insert( VetorTTS,"\n\n".."Conteúdo do texto:. " .. vetorTodas[i].texto)
						end
					end
				end
				
				if i == 1 then 
					--print("texto "..i.." caiu no 'primeiro'")
					
					if vetorTodas[i].y ~= nil then
						vetorTodas[i].y = vetorTodas[i].y + YinicialVideo
					else
						vetorTodas[i].y = YinicialVideo
					end
					vetorBotoes[#vetorBotoes+1] = ({texto = vetorTodas[i].texto, url = vetorTodas[i].url,imagem = vetorTodas[i].imagem,video = vetorTodas[i].video,fundoUp = vetorTodas[i].fundoUp,fundoDown = vetorTodas[i].fundoDown,acao = vetorTodas[i].acao,altura = vetorTodas[i].altura,comprimento = vetorTodas[i].comprimento,x = vetorTodas[i].x,y = vetorTodas[i].y, posicao = vetorTodas[i].posicao,tipo = vetorTodas[i].tipo,titulo = vetorTodas[i].titulo,numero = vetorTodas[i].numero,som = vetorTodas[i].som,automatico = vetorTodas[i].automatico,avancar = vetorTodas[i].avancar,pause = vetorTodas[i].pause,atributoALT = vetorTodas[i].atributoALT,Telas = Telas, index = i,conteudo = vetorTodas[i].conteudo,dicionario = vetorTodas[i].dicionario})


				else
					
					vetorBotoes[#vetorBotoes+1] = ({texto = vetorTodas[i].texto, url = vetorTodas[i].url,imagem = vetorTodas[i].imagem,video = vetorTodas[i].video,fundoUp = vetorTodas[i].fundoUp,fundoDown = vetorTodas[i].fundoDown,acao = vetorTodas[i].acao,altura = vetorTodas[i].altura,comprimento = vetorTodas[i].comprimento,x = vetorTodas[i].x,y = vetorTodas[i].y, posicao = vetorTodas[i].posicao,tipo = vetorTodas[i].tipo,titulo = vetorTodas[i].titulo,numero = vetorTodas[i].numero,som = vetorTodas[i].som,automatico = vetorTodas[i].automatico,avancar = vetorTodas[i].avancar,pause = vetorTodas[i].pause,atributoALT = vetorTodas[i].atributoALT,Telas = Telas, index = i,conteudo = vetorTodas[i].conteudo,dicionario = vetorTodas[i].dicionario})
					
				end
			elseif string.find( vetorTodas[i][0], "animacao" ) ~= nil then
				--thales2 animacao
				local padrao = {}
				contadorElementos = contadorElementos + 1
				if auxFuncs.fileExists(atributos.pasta.."/Config Padrao Animacao.txt") == true then
					VetorPadraoAnimacao = leitArqTxt.criarAnimacoesDeArquivoPadrao({pasta = atributos.pasta,arquivo = "Config Padrao Animacao.txt",substituicoesOnline = substituicoesOnline},listaDeErros)
					padrao = VetorPadraoAnimacao
				elseif atributos.pasta2 and auxFuncs.fileExists(atributos.pasta2.."/Config Padrao Animacao.txt") == true then
					VetorPadraoAnimacao = leitArqTxt.criarAnimacoesDeArquivoPadrao({pasta = atributos.pasta2,arquivo = "Config Padrao Animacao.txt",substituicoesOnline = substituicoesOnline},listaDeErros)
					padrao = VetorPadraoAnimacao
					
				else

					padrao = 
					{
						pasta = "Anim Padrao.lib",
						imagens = {"imagemErro1.png","imagemErro2.png","imagemErro3.png","imagemErro4.png","imagemErro5.png"},
						atributoALT = nil,
						conteudo = nil,
						tempoPorImagem = 300,
						numeroImagens = 6,
						som = nil,
						automatico = "nao",
						posicao = nil,
						loop = "nao",
						avancar = nil,
						limitador = "imagem",
						x = nil,
						y = nil,
						url = nil,
						dicionario = nil,
						margem = 0
					}
				end
				
				vetorTodas[i].conteudo = padrao.conteudo
				vetorTodas[i].pasta = padrao.pasta
				vetorTodas[i].imagens = padrao.imagens
				vetorTodas[i].tempoPorImagem = padrao.tempoPorImagem
				vetorTodas[i].numeroImagens = padrao.numeroImagens
				vetorTodas[i].som = padrao.som
				vetorTodas[i].atributoALT = padrao.atributoALT
				vetorTodas[i].automatico = padrao.automatico
				vetorTodas[i].posicao = padrao.posicao
				vetorTodas[i].loop = padrao.loop
				vetorTodas[i].avancar = padrao.avancar
				vetorTodas[i].limitador = padrao.limitador
				vetorTodas[i].x = padrao.x
				vetorTodas[i].y = padrao.y
				vetorTodas[i].url = padrao.url
				vetorTodas[i].dicionario = padrao.dicionario
				vetorTodas[i].margem = padrao.margem
				
				
				leitArqTxt.criarAnimacoesDeArquivoPadraoAux(vetorTodas[i],padrao,atributos,listaDeErros)
				
				vetorTodas[i].pasta = atributos.pasta.."/Outros Arquivos/"..vetorTodas[i].pasta
				--thalesTTS
				
				
				
				if i == 1 then 
					--print("texto "..i.." caiu no 'primeiro'")
					
					if vetorTodas[i].y ~= nil then
						vetorTodas[i].y = vetorTodas[i].y + YinicialVideo
					else
						vetorTodas[i].y = YinicialVideo
					end
					vetorAnimacoes[#vetorAnimacoes+1] = ({pasta = vetorTodas[i].pasta, url = vetorTodas[i].url,imagens = vetorTodas[i].imagens,tempoPorImagem = vetorTodas[i].tempoPorImagem,numeroImagens = vetorTodas[i].numeroImagens,som = vetorTodas[i].som,atributoALT = vetorTodas[i].atributoALT,automatico = vetorTodas[i].automatico,loop = vetorTodas[i].loop,posicao = vetorTodas[i].posicao,avancar = vetorTodas[i].avancar,limitador = vetorTodas[i].limitador, x = vetorTodas[i].x,y = vetorTodas[i].y, index = i,conteudo = vetorTodas[i].conteudo,dicionario = vetorTodas[i].dicionario,margem = vetorTodas[i].margem})
				
				else
					
					vetorAnimacoes[#vetorAnimacoes+1] = ({pasta = vetorTodas[i].pasta, url = vetorTodas[i].url,imagens = vetorTodas[i].imagens,tempoPorImagem = vetorTodas[i].tempoPorImagem,numeroImagens = vetorTodas[i].numeroImagens,som = vetorTodas[i].som,atributoALT = vetorTodas[i].atributoALT,automatico = vetorTodas[i].automatico,loop = vetorTodas[i].loop,posicao = vetorTodas[i].posicao,avancar = vetorTodas[i].avancar,limitador = vetorTodas[i].limitador, x = vetorTodas[i].x,y = vetorTodas[i].y, index = i,conteudo = vetorTodas[i].conteudo,dicionario = vetorTodas[i].dicionario,margem = vetorTodas[i].margem})
					
				end
				
				if vetorTodas[i].atributoALT then
					if string.len(vetorTodas[i].atributoALT) > 2 then
						local aux = vetorTodas[i].atributoALT
						if atributos.TTSTipo and atributos.TTSTipo == "RSS" then
							aux = conversor.converterTextoParaFala(vetorTodas[i].atributoALT,substituicoesOnline,atributos.TTSTipo)
						end
						table.insert( VetorTTS,"\n\n Detalhes da animação:." .. aux )
						
					end
				end
				if vetorTodas[i].som then
					local vetor = {pasta = vetorTodas[i].pasta,imagens = vetorTodas[i].imagens,tempoPorImagem = vetorTodas[i].tempoPorImagem,numeroImagens = vetorTodas[i].numeroImagens,som = vetorTodas[i].som,atributoALT = vetorTodas[i].atributoALT,automatico = vetorTodas[i].automatico,loop = vetorTodas[i].loop,posicao = vetorTodas[i].posicao,avancar = vetorTodas[i].avancar,limitador = vetorTodas[i].limitador, x = vetorTodas[i].x,y = vetorTodas[i].y, index = i}
					vetor.y = H/2
					if vetorTodas[i].som and vetorTodas[i].som ~= "som vazio.WAV" then
						table.insert( VetorTTS,"\n\n".."Executando a animação com som")
						VetorTTS.animacao[#VetorTTS] = vetor
					end
				end
				
			elseif string.find( vetorTodas[i][0], "exercicio" ) ~= nil then
				--thales2 exercicio
				local padrao = {}
				contadorElementos = contadorElementos + 1
				if auxFuncs.fileExists(atributos.pasta.."/Config Padrao Exercicio.txt") == true then
					VetorPadraoExercicio = leitArqTxt.criarExerciciosDeArquivoPadrao({pasta = atributos.pasta,arquivo = "Config Padrao Exercicio.txt",substituicoesOnline = substituicoesOnline},listaDeErros)
					padrao = VetorPadraoExercicio
				elseif atributos.pasta2 and auxFuncs.fileExists(atributos.pasta2.."/Config Padrao Exercicio.txt") == true then
					VetorPadraoExercicio = leitArqTxt.criarExerciciosDeArquivoPadrao({pasta = atributos.pasta2,arquivo = "Config Padrao Exercicio.txt",substituicoesOnline = substituicoesOnline},listaDeErros)
					padrao = VetorPadraoExercicio
					
				else
					
					local padrao = {
						pasta = nil,
						enunciado = "Assinale a alternatica correta:.",
						tamanhoFonte = 70,
						alternativas = {"opção 1","opção 2"},
						tamanhoFonteAlternativas = 40,
						corretas = {1},
						justificativas = {"não possui padrão" , "idem"},
						posicao = "topo",
						corFonte = {180,180,180},
						x = nil,
						y = nil,
						numeroAlternativas = 2,
						mensagemCorreta = nil,
						mensagemErrada = nil,
						fonte = nil,
						alinhamento = "justificado",
						margem = nil,
						tempo = nil,
						numero = nil,
						conteudo = nil,
						url = nil,
						dicionario = nil
					}
				end
				
				vetorTodas[i].conteudo = padrao.conteudo
				vetorTodas[i].pasta = padrao.pasta					
				vetorTodas[i].enunciado = padrao.enunciado
				vetorTodas[i].tamanhoFonte = padrao.tamanhoFonte
				vetorTodas[i].alternativas = padrao.alternativas
				vetorTodas[i].tamanhoFonteAlternativas = padrao.tamanhoFonteAlternativas
				vetorTodas[i].corretas = padrao.corretas
				vetorTodas[i].justificativas = padrao.justificativas
				vetorTodas[i].posicao = padrao.posicao
				vetorTodas[i].corFonte = padrao.corFonte
				vetorTodas[i].numeroAlternativas = padrao.numeroAlternativas
				vetorTodas[i].x = padrao.x
				vetorTodas[i].y = padrao.y
				vetorTodas[i].mensagemCorreta = padrao.mensagemCorreta
				vetorTodas[i].mensagemErrada = padrao.mensagemErrada
				vetorTodas[i].fonte = padrao.fonte
				vetorTodas[i].alinhamento = padrao.alinhamento
				vetorTodas[i].margem = padrao.margem
				vetorTodas[i].tempo = padrao.tempo
				vetorTodas[i].numero = padrao.numero
				vetorTodas[i].url = padrao.url
				vetorTodas[i].dicionario = padrao.dicionario
				
				leitArqTxt.criarExerciciosDeArquivoPadraoAux(vetorTodas[i],padrao,atributos,listaDeErros)
				
				local auxStringAlternativas = ""
				for j=1,#vetorTodas[i].alternativas do
					auxStringAlternativas = auxStringAlternativas .. j ..".. ".. vetorTodas[i].alternativas [j].. ".. "

				end
				
				local aux = string.gsub(vetorTodas[i].enunciado,"#t=%d+#","")
				aux = string.gsub(aux,"#/t=%d+#","")
				aux = string.gsub(aux,"#l%d+#","")
				aux = string.gsub(aux,"#/l%d+#","")
				aux = string.gsub(aux,"#s#","")
				aux = string.gsub(aux,"#/s#","")
				aux = string.gsub(aux,"#n#","")
				aux = string.gsub(aux,"#/n#","")
				aux2 = string.gsub(auxStringAlternativas,"#t=%d+#","")
				aux2 = string.gsub(aux2,"#/t=%d+#","")
				aux2 = string.gsub(aux2,"#l%d+#","")
				aux2 = string.gsub(aux2,"#/l%d+#","")
				aux2 = string.gsub(aux2,"#s#","")
				aux2 = string.gsub(aux2,"#/s#","")
				aux2 = string.gsub(aux2,"#n#","")
				aux2 = string.gsub(aux2,"#/n#","")
				aux2 = string.gsub(aux2,"\\n",".")
				aux2 = string.gsub(aux2,"\n",".")
				
				if atributos.TTSTipo and atributos.TTSTipo == "RSS" then
					aux = conversor.converterTextoParaFala(aux,substituicoesOnline,atributos.TTSTipo)
					aux2 = conversor.converterTextoParaFala(aux2,substituicoesOnline,atributos.TTSTipo)
				end
				
				

				if vetorTodas[i].numero == nil then
					vetorTodas[i].numero = ""
				end
				if vetorTodas[i].atributoALT and vetorTodas[i].atributoALT ~= nil then
					table.insert( VetorTTS,"\n\n" .. vetorTodas[i].atributoALT )
				else
					local questao = "Questão: "..vetorTodas[i].numero
					if atributos.TTSTipo and atributos.TTSTipo == "RSS" then
						questao = conversor.converterTextoParaFala("Questaum:"..vetorTodas[i].numero,substituicoesOnline,atributos.TTSTipo)
					end
					table.insert( VetorTTS,"\n\n "..questao.. ".. " .. aux .. ". Alternativas: " .. aux2 )
					print(questao.. ".. " .. aux)
				end
				
				if i == 1 then 
					--print("exercicio "..i.." caiu no 'primeiro'")
					
					if vetorTodas[i].y ~= nil then
						vetorTodas[i].y = vetorTodas[i].y + YinicialVideo
					else
						vetorTodas[i].y = YinicialVideo
					end
					
					vetorExercicios[#vetorExercicios+1] = {tempo = vetorTodas[i].tempo,url = vetorTodas[i].url,fonte = vetorTodas[i].fonte,alinhamento = vetorTodas[i].alinhamento,margem = vetorTodas[i].margem,pasta = vetorTodas[i].pasta,enunciado = vetorTodas[i].enunciado,tamanhoFonte = vetorTodas[i].tamanhoFonte, alternativas = vetorTodas[i].alternativas,tamanhoFonteAlternativas = vetorTodas[i].tamanhoFonteAlternativas, corretas = vetorTodas[i].corretas, justificativas = vetorTodas[i].justificativas,posicao = vetorTodas[i].posicao,corFonte = vetorTodas[i].corFonte, x = vetorTodas[i].x, y = vetorTodas[i].y,atributos = atributos,Telas = Telas,mensagemCorreta = vetorTodas[i].mensagemCorreta,mensagemErrada = vetorTodas[i].mensagemErrada, index = i, aberto = false,numeroExercicio = vetorTodas[i].numero,numero = vetorTodas[i].numero,conteudo = vetorTodas[i].conteudo,dicionario = vetorTodas[i].dicionario}
					
				else
					
					vetorExercicios[#vetorExercicios+1] = {tempo = vetorTodas[i].tempo,url = vetorTodas[i].url,fonte = vetorTodas[i].fonte,alinhamento = vetorTodas[i].alinhamento,margem = vetorTodas[i].margem,pasta = vetorTodas[i].pasta,enunciado = vetorTodas[i].enunciado,tamanhoFonte = vetorTodas[i].tamanhoFonte, alternativas = vetorTodas[i].alternativas,tamanhoFonteAlternativas = vetorTodas[i].tamanhoFonteAlternativas, corretas = vetorTodas[i].corretas, justificativas = vetorTodas[i].justificativas,posicao = vetorTodas[i].posicao,corFonte = vetorTodas[i].corFonte, x = vetorTodas[i].x, y = vetorTodas[i].y,atributos = atributos,Telas = Telas,mensagemCorreta = vetorTodas[i].mensagemCorreta,mensagemErrada = vetorTodas[i].mensagemErrada, index = i, aberto = false,numeroExercicio = vetorTodas[i].numero,numero = vetorTodas[i].numero,conteudo = vetorTodas[i].conteudo,dicionario = vetorTodas[i].dicionario}
					
				end
				
			elseif string.find( vetorTodas[i][0], "video" ) ~= nil then
				--thales2 video
				local padrao = {}
				contadorElementos = contadorElementos + 1
				if auxFuncs.fileExists(atributos.pasta.."/Config Padrao Video.txt") == true then
					VetorPadraoVideo = leitArqTxt.criarVideosDeArquivoPadrao({pasta = atributos.pasta,arquivo = "Config Padrao Video.txt",substituicoesOnline = substituicoesOnline},listaDeErros)
					padrao = VetorPadraoVideo
				elseif atributos.pasta2 and auxFuncs.fileExists(atributos.pasta2.."/Config Padrao Video.txt") == true then
					VetorPadraoVideo = leitArqTxt.criarVideosDeArquivoPadrao({pasta = atributos.pasta2,arquivo = "Config Padrao Video.txt",substituicoesOnline = substituicoesOnline},listaDeErros)
					padrao = VetorPadraoVideo
					
				else
					padrao = {
						arquivo = atributos.pasta.."/Outros Arquivos/video.mp4",
						url = nil,
						atributoALT = nil,
						conteudo = nil,
						youtube = nil,
						x = nil,
						y = nil,
						url = nil,
						dicionario = nil
					}
				end
				
				--print(padrao.arquivo,padrao.url,padrao.x,padrao.y)
						
				vetorTodas[i].arquivo = padrao.arquivo
				vetorTodas[i].url = padrao.url
				vetorTodas[i].atributoALT = padrao.atributoALT
				vetorTodas[i].youtube = padrao.youtube
				vetorTodas[i].x = padrao.x
				vetorTodas[i].y = padrao.y
				vetorTodas[i].conteudo = padrao.conteudo
				vetorTodas[i].url = padrao.url
				vetorTodas[i].dicionario = padrao.dicionario
				
				leitArqTxt.criarVideosDeArquivoPadraoAux(vetorTodas[i],padrao,atributos,listaDeErros)
				--local YinicialVideo = 0
				if vetorTodas[i].atributoALT then
					if string.len(vetorTodas[i].atributoALT) > 2 then
						local aux2 = vetorTodas[i].atributoALT
						if vetorTodas[i].atributoALT then
							--aux2 = conversor.converterANSIparaUTFsemBoom(vetorTodas[i].atributoALT)
						end
						if atributos.TTSTipo and atributos.TTSTipo == "RSS" then
							aux2 = conversor.converterTextoParaFala(aux2,substituicoesOnline,atributos.TTSTipo)
						end
						table.insert( VetorTTS,"\n\n Detalhes do vídeo:.".. aux2)
					end
				end
				table.insert( VetorTTS,"\n\n".."Executando o vídeo")
				VetorTTS.video[#VetorTTS] = vetorTodas[i].arquivo
				
				
				--print(vetorTodas[i].arquivo,vetorTodas[i].url,vetorTodas[i].x,vetorTodas[i].y)
				if i == 1 then 
					--print("video "..i.." caiu no 'primeiro'")
					if vetorTodas[i].y ~= nil then
						vetorTodas[i].y = vetorTodas[i].y + YinicialVideo
					else
						vetorTodas[i].y = YinicialVideo
					end
					
					vetorVideos[#vetorVideos+1] = {atributoALT = vetorTodas[i].atributoALT,url = vetorTodas[i].url,arquivo = vetorTodas[i].arquivo,youtube = vetorTodas[i].youtube,url = vetorTodas[i].url, x = vetorTodas[i].x, y = vetorTodas[i].y, index = i,conteudo = vetorTodas[i].conteudo,dicionario = vetorTodas[i].dicionario}

				else
					vetorVideos[#vetorVideos+1] = {atributoALT = vetorTodas[i].atributoALT,url = vetorTodas[i].url,arquivo = vetorTodas[i].arquivo,youtube = vetorTodas[i].youtube,url = vetorTodas[i].url, x = vetorTodas[i].x, y = vetorTodas[i].y, index = i,conteudo = vetorTodas[i].conteudo,dicionario = vetorTodas[i].dicionario}
					
				end	
			elseif string.find( vetorTodas[i][0], "card" ) ~= nil then
				--thales2 deck
				local padrao = {}
				--contadorElementos = contadorElementos + 1
				if auxFuncs.fileExists(atributos.pasta.."/Config Padrao Deck.txt") == true then
					VetorPadraoDeck = leitArqTxt.criarDeckDeArquivoPadrao({pasta = atributos.pasta,arquivo = "Config Padrao Deck.txt",substituicoesOnline = substituicoesOnline},listaDeErros)
					padrao = VetorPadraoDeck
				elseif atributos.pasta2 and auxFuncs.fileExists(atributos.pasta2.."/Config Padrao Deck.txt") == true then
					VetorPadraoDeck = leitArqTxt.criarVideosDeArquivoPadrao({pasta = atributos.pasta2,arquivo = "Config Padrao Deck.txt",substituicoesOnline = substituicoesOnline},listaDeErros)
					padrao = VetorPadraoDeck
					
				else
					padrao = {
						tipo = "texto",
						texto = nil,
						arquivo = nil,
						url = nil,
						atributoALT = nil,
						conteudo = nil,
						youtube = nil,
						x = nil,
						y = nil,
						som = nil,
						conteudo = nil,
						escala = 1,
						urlEmbeded = nil,
						titulo = "Flash Card",
						enunciado = "Marque a alternativa correta:",
						alternativas = {"opção 1","opção 2","opção 3","opção 4"},
						corretas = {0},
						pasta = "Anim Padrao.lib",
						imagens = {}
					}
				end
						
				vetorTodas[i].arquivo = padrao.arquivo
				vetorTodas[i].escala = padrao.escala
				vetorTodas[i].pasta = padrao.pasta
				vetorTodas[i].texto = padrao.texto
				vetorTodas[i].tipo = padrao.tipo
				vetorTodas[i].url = padrao.url
				vetorTodas[i].atributoALT = padrao.atributoALT
				vetorTodas[i].youtube = padrao.youtube
				vetorTodas[i].x = padrao.x
				vetorTodas[i].y = padrao.y
				vetorTodas[i].url = padrao.url
				vetorTodas[i].urlEmbeded = padrao.urlEmbeded
				vetorTodas[i].titulo = padrao.titulo
				vetorTodas[i].enunciado = padrao.enunciado
				vetorTodas[i].alternativas = padrao.alternativas
				vetorTodas[i].corretas = padrao.corretas
				vetorTodas[i].numeroCard = numeroCard
				vetorTodas[i].conteudo = padrao.conteudo
				vetorTodas[i].som = padrao.som
				vetorTodas[i].imagens = padrao.imagens
				
				if vetorTodas[i].tipo and vetorTodas[i].tipo == "exercicio" then
					vetorTodas[i].pasta = nil
					vetorTodas[i].justificativas = {"não há justificativa"}
				end
				leitArqTxt.criarDeckDeArquivoPadraoAux(vetorTodas[i],padrao,atributos,listaDeErros)
				if vetorTodas[i].pasta then 
					vetorTodas[i].pasta = atributos.pasta.."/Outros Arquivos/"..vetorTodas[i].pasta 
				end
				local aux2 = "\n\nLeitura do Card "..vetorTodas[i].numeroCard..":. Título: \n"..vetorTodas[i].titulo
				if atributos.TTSTipo and atributos.TTSTipo == "RSS" then
					aux2 = conversor.converterTextoParaFala(aux2,substituicoesOnline,atributos.TTSTipo)
				end
				table.insert(VetorTTS,aux2)
				if vetorTodas[i].tipo and vetorTodas[i].tipo == "exercicio" and vetorTodas[i].pasta then
					vetorTodas[i].pasta = atributos.pasta.."/Outros Arquivos/"..vetorTodas[i].pasta
				end
				if vetorTodas[i].atributoALT then
					if string.len(vetorTodas[i].atributoALT) > 2 then
						local aux2 = "\n\n conteúdo do card:.".. vetorTodas[i].atributoALT
						if atributos.TTSTipo and atributos.TTSTipo == "RSS" then
							aux2 = conversor.converterTextoParaFala(aux2,substituicoesOnline,atributos.TTSTipo)
						end
						table.insert( VetorTTS,aux2)
					end
				elseif vetorTodas[i].tipo == "imagem" then
					local aux2 = "\n\n Imagem sem texto explicativo:."
					if atributos.TTSTipo and atributos.TTSTipo == "RSS" then
						aux2 = conversor.converterTextoParaFala(aux2,substituicoesOnline,atributos.TTSTipo)
					end
					table.insert( VetorTTS,aux2)
				end
				if vetorTodas[i].arquivo and vetorTodas[i].tipo then
					if vetorTodas[i].tipo == "video" or vetorTodas[i].tipo == "som" or vetorTodas[i].tipo == "animacao" then
						local tipo = vetorTodas[i].tipo
						local aux2 = "\n\n".."Executando "..tipo
						if atributos.TTSTipo and atributos.TTSTipo == "RSS" then
							aux2 = conversor.converterTextoParaFala(aux2,substituicoesOnline,atributos.TTSTipo)
						end
						table.insert( VetorTTS,aux2)
						if not VetorTTS[tipo] then VetorTTS[tipo] = {} end
						VetorTTS[tipo][#VetorTTS] = vetorTodas[i].arquivo
					end
				end
				if vetorTodas[i].conteudo then
					if string.len(vetorTodas[i].conteudo) > 2 then
						local aux2 = "\n\n Conteúdo de "..vetorTodas[i].tipo..":.".. vetorTodas[i].conteudo
						if atributos.TTSTipo and atributos.TTSTipo == "RSS" then
							aux2 = conversor.converterTextoParaFala(aux2,substituicoesOnline,atributos.TTSTipo)
						end
						table.insert( VetorTTS,aux2)
					else
						local aux2 = "\n\n "..vetorTodas[i].tipo.." sem conteúdo textual:."
						if atributos.TTSTipo and atributos.TTSTipo == "RSS" then
							aux2 = conversor.converterTextoParaFala(aux2,substituicoesOnline,atributos.TTSTipo)
						end
						table.insert( VetorTTS,aux2)
					end
				elseif vetorTodas[i].tipo == "video" or vetorTodas[i].tipo == "som" or vetorTodas[i].tipo == "animacao" then
					local aux2 = "\n\n "..vetorTodas[i].tipo.. " sem conteúdo textual:."
					if atributos.TTSTipo and atributos.TTSTipo == "RSS" then
						aux2 = conversor.converterTextoParaFala(aux2,substituicoesOnline,atributos.TTSTipo)
					end
					table.insert( VetorTTS,aux2)
				end
				if vetorTodas[i].tipo == "texto" and vetorTodas[i].texto and (not  vetorTodas[i].atributoALT or (vetorTodas[i].atributoALT and #vetorTodas[i].atributoALT<3)) then
					if string.len(vetorTodas[i].texto) > 2 then
						local aux2 = vetorTodas[i].texto
						if atributos.TTSTipo and atributos.TTSTipo == "RSS" then
							aux2 = conversor.converterTextoParaFala(aux2,substituicoesOnline,atributos.TTSTipo)
						end
						table.insert( VetorTTS,"\n\n :.".. aux2)
					end
				end
				
				if i == 1 then 
					if vetorTodas[i].y ~= nil then
						vetorTodas[i].y = vetorTodas[i].y + YinicialVideo
					else
						vetorTodas[i].y = YinicialVideo
					end
					
					vetorDecks[#vetorDecks+1] = {atributoALT = vetorTodas[i].atributoALT,url = vetorTodas[i].url,arquivo = vetorTodas[i].arquivo,youtube = vetorTodas[i].youtube,url = vetorTodas[i].url, x = vetorTodas[i].x, y = vetorTodas[i].y, index = i,conteudo = vetorTodas[i].conteudo,dicionario = vetorTodas[i].dicionario, titulo = vetorTodas[i].titulo,enunciado = vetorTodas[i].enunciado,corretas = vetorTodas[i].corretas,alternativas = vetorTodas[i].alternativas,numeroCard = vetorTodas[i].numeroCard,pasta = vetorTodas[i].pasta,imagens = vetorTodas[i].imagens,som =  vetorTodas[i].som}
				else
					vetorDecks[#vetorDecks+1] = {atributoALT = vetorTodas[i].atributoALT,url = vetorTodas[i].url,arquivo = vetorTodas[i].arquivo,youtube = vetorTodas[i].youtube,url = vetorTodas[i].url, x = vetorTodas[i].x, y = vetorTodas[i].y, index = i,conteudo = vetorTodas[i].conteudo,texto = vetorTodas[i].texto,tipo = vetorTodas[i].tipo,urlEmbeded = vetorTodas[i].urlEmbeded,titulo = vetorTodas[i].titulo,enunciado = vetorTodas[i].enunciado,corretas = vetorTodas[i].corretas,alternativas = vetorTodas[i].alternativas,numeroCard = vetorTodas[i].numeroCard,pasta = vetorTodas[i].pasta,imagens = vetorTodas[i].imagens,som =  vetorTodas[i].som}
				end	
				numeroCard = numeroCard + 1
			elseif string.find( vetorTodas[i][0], "espaco" ) ~= nil then
				--thales2 espaço
				local padrao = {}
				contadorElementos = contadorElementos + 1
				local padrao = {
						distancia = 10,
						x = nil,
						y = 0,
						url = nil,
						dicionario = nil
					}
				
				--print(padrao.arquivo,padrao.url,padrao.x,padrao.y)
						
				vetorTodas[i].distancia = padrao.distancia
				vetorTodas[i].dicionario = padrao.dicionario
				
				leitArqTxt.criarEspacoDeArquivoPadraoAux(vetorTodas[i],padrao,atributos,listaDeErros)
				
				if i == 1 then 
					--print("video "..i.." caiu no 'primeiro'")
					
					if vetorTodas[i].y ~= nil then
						vetorTodas[i].y = vetorTodas[i].y + YinicialVideo
					else
						vetorTodas[i].y = YinicialVideo
					end
					
					vetorEspacos[#vetorEspacos+1] = {distancia = vetorTodas[i].distancia, y = vetorTodas[i].y, index = i,dicionario = vetorTodas[i].dicionario}

				else
					
					vetorEspacos[#vetorEspacos+1] = {distancia = vetorTodas[i].distancia, y = vetorTodas[i].y, index = i,dicionario = vetorTodas[i].dicionario}

				end

			elseif string.find( vetorTodas[i][0], "separador" ) ~= nil then
				--thales2 separador
				local padrao = {}
				contadorElementos = contadorElementos + 1
				if auxFuncs.fileExists(atributos.pasta.."/Config Padrao Separador.txt") == true then
					VetorPadraoSeparador = leitArqTxt.criarSeparadoresDeArquivoPadrao({pasta = atributos.pasta,arquivo = "Config Padrao Separador.txt",substituicoesOnline = substituicoesOnline},listaDeErros)
					padrao = VetorPadraoSeparador
				elseif atributos.pasta2 and auxFuncs.fileExists(atributos.pasta2.."/Config Padrao Separador.txt") == true then
					VetorPadraoSeparador = leitArqTxt.criarSeparadoresDeArquivoPadrao({pasta = atributos.pasta2,arquivo = "Config Padrao Separador.txt",substituicoesOnline = substituicoesOnline},listaDeErros)
					padrao = VetorPadraoSeparador
					
				else
					padrao = {
						espessura = 5,
						cor = {0,0,0},
						largura = nil,
						conteudo = nil,
						x = nil,
						y = nil,
						dicionario = nil,
						margem = 0
					}
				end
						
				vetorTodas[i].espessura = padrao.espessura
				vetorTodas[i].cor = padrao.cor
				vetorTodas[i].largura = padrao.largura
				vetorTodas[i].x = padrao.x
				vetorTodas[i].y = padrao.y
				vetorTodas[i].conteudo = padrao.conteudo
				vetorTodas[i].margem = padrao.margem
				vetorTodas[i].dicionario = padrao.dicionario
				
				leitArqTxt.criarSeparadorDeArquivoPadraoAux(vetorTodas[i],padrao,atributos,listaDeErros)
				
				if i == 1 then 
					--print("video "..i.." caiu no 'primeiro'")
					
					if vetorTodas[i].y ~= nil then
						vetorTodas[i].y = vetorTodas[i].y + YinicialVideo
					else
						vetorTodas[i].y = YinicialVideo
					end
					
					vetorSeparadores[#vetorSeparadores+1] = {espessura = vetorTodas[i].espessura,url = vetorTodas[i].url,cor = vetorTodas[i].cor,largura = vetorTodas[i].largura, x = vetorTodas[i].x, y = vetorTodas[i].y, index = i,conteudo = vetorTodas[i].conteudo,dicionario = vetorTodas[i].dicionario,margem=vetorTodas[i].margem}
				
				else
					
					vetorSeparadores[#vetorSeparadores+1] = {espessura = vetorTodas[i].espessura,url = vetorTodas[i].url,cor = vetorTodas[i].cor,largura = vetorTodas[i].largura, x = vetorTodas[i].x, y = vetorTodas[i].y, index = i,conteudo = vetorTodas[i].conteudo,dicionario = vetorTodas[i].dicionario,margem=vetorTodas[i].margem}

				end
			elseif string.find( vetorTodas[i][0], "fundo" ) ~= nil then
				--thales2 fundo
				local padrao = {}
				contadorElementos = contadorElementos + 1
				if auxFuncs.fileExists(atributos.pasta.."/Config Padrao Fundo.txt") == true then
					local VetorPadraoFundo = leitArqTxt.criarFundoDeArquivoPadrao({pasta = atributos.pasta,arquivo = "Config Padrao Fundo.txt",substituicoesOnline = substituicoesOnline},listaDeErros)
					padrao = VetorPadraoFundo
				elseif atributos.pasta2 and auxFuncs.fileExists(atributos.pasta2.."/Config Padrao Fundo.txt") == true then
					local VetorPadraoFundo = leitArqTxt.criarFundoDeArquivoPadrao({pasta = atributos.pasta2,arquivo = "Config Padrao Fundo.txt",substituicoesOnline = substituicoesOnline},listaDeErros)
					padrao = VetorPadraoFundo
				else
					padrao = {
						cor = {192,0,0},
						arquivo = nil
					}
				end
				contadorElementos = contadorElementos + 1
						
				vetorTodas[i].cor = padrao.cor
				vetorTodas[i].arquivo = padrao.arquivo
				
				leitArqTxt.criarFundoDeArquivoPadraoAux(vetorTodas[i],padrao,atributos,listaDeErros)
				

				vetorFundo[#vetorFundo+1] = {cor = vetorTodas[i].cor, arquivo = vetorTodas[i].arquivo}

			end
			
			if not VetorDeVetorTTS then VetorDeVetorTTS = {} end
			if type(Telas) == "number" then
				VetorDeVetorTTS[Telas] = VetorTTS
				if nomeArquivo and auxFuncs.fileExists(atributos.pasta.."/TTS/"..nomeArquivo..".txt") then
					VetorDeVetorTTS[Telas].tipo = "TTS"
				end
				VetorDeVetorTTS[iii].numero = #VetorDeVetorTTS[paginaAtual]
			else
				VetorDeVetorTTS[iii] = VetorTTS
				if nomeArquivo and auxFuncs.fileExists(atributos.pasta.."/TTS/"..nomeArquivo..".txt") then
					VetorDeVetorTTS[iii].tipo = "TTS"
				end
				VetorDeVetorTTS[iii].numero = #VetorDeVetorTTS[paginaAtual]
			end
			vetorTela.vetorTTS = VetorDeVetorTTS
		end
		
		-- imagens --
		vetorTela.imagens = {}
		for i=1,imagens do
			vetorTela.imagens[i] = vetorImagens[i]
		end
		-- textos --
		vetorTela.textos = {}
		for i=1,textos do
			vetorTela.textos[i] = vetorTextos[i]
		end
		-- sons --
		vetorTela.sons = {}
		for i=1,sons do
			vetorTela.sons[i] = vetorSons[i]
		end
		-- botoes --
		vetorTela.botoes = {}
		for i=1,botoes do
			vetorTela.botoes[i] = vetorBotoes[i]
		end
		-- exercicios --
		vetorTela.exercicios = {}
		for i=1,exercicios do
			vetorTela.exercicios[i] = vetorExercicios[i]
		end
		-- videos --
		vetorTela.videos = {}
		for i=1,videos do
			vetorTela.videos[i] = vetorVideos[i]
		end
		-- animacoes --
		vetorTela.animacoes = {}
		for i=1,animacoes do
			vetorTela.animacoes[i] = vetorAnimacoes[i]
		end
		-- espacos --
		vetorTela.espacos = {}
		for i=1,espacos do
			vetorTela.espacos[i] = vetorEspacos[i]
		end
		-- separadores --
		vetorTela.separadores = {}
		for i=1,separadores do
			vetorTela.separadores[i] = vetorSeparadores[i]
		end
		-- fundo --
		vetorTela.fundo = {}
		for i=1,fundo do
			vetorTela.fundo[i] = vetorFundo[i]
		end
		-- imagens com textos --
		vetorTela.imagemTextos = {}
		for i=1,imagemTextos do
			vetorTela.imagemTextos[i] = vetorImagemTextos[i]
		end
		-- Decks --
		vetorTela.decks = {}
		for i=1,decks do
			vetorTela.decks[i] = vetorDecks[i]
		end
		
		
	end
	if not VetorDeVetorTTS then VetorDeVetorTTS = {} end
	if type(Telas) == "number" then
		VetorDeVetorTTS[Telas] = VetorTTS
		if nomeArquivo and auxFuncs.fileExists(atributos.pasta.."/TTS/"..nomeArquivo..".txt") then
			VetorDeVetorTTS[Telas].tipo = "TTS"
		end
		VetorDeVetorTTS[iii].numero = #VetorDeVetorTTS[paginaAtual]
	else
		VetorDeVetorTTS[iii] = VetorTTS
		if nomeArquivo and auxFuncs.fileExists(atributos.pasta.."/TTS/"..nomeArquivo..".txt") then
			VetorDeVetorTTS[iii].tipo = "TTS"
		end
		VetorDeVetorTTS[iii].numero = #VetorDeVetorTTS[paginaAtual]
	end
	vetorTela.vetorTTS = VetorDeVetorTTS
	VetorTTS = {}
	return vetorTela
	
end

function M.RemoverTela(Var2)
	if Var2.botaoVoltarAlternativa then
		Var2.botaoVoltarAlternativa:removeSelf()
		Var2.botaoVoltarAlternativa = nil
	end
	if Var2.grupoBloqueioPagina then
		Var2.grupoBloqueioPagina:removeSelf()
	end
	if Var2.retanguloMovimento then
		Var2.retanguloMovimento:removeSelf()
		Var2.retanguloMovimento = nil
	end
	if(Var2.botaoConfigTTS ~= nil) then
		Var2.botaoConfigTTS:removeSelf()
		Var2.botaoConfigTTS = nil
	end
	if(Var2.espacos ~= nil) then
		for esp=1, #Var2.espacos do
			Var2.espacos[esp] = nil
		end
		Var2.espacos = {}
	end
	if(Var2.separadores ~= nil) then
		for sep=1, #Var2.separadores do
			Var2.separadores[sep]:removeSelf()
			Var2.separadores[sep] = nil
		end
		Var2.separadores = {}
	end
	if(Var2.imagemTextos ~= nil) then
		for imtx=1, #Var2.imagemTextos do
			if Var2.imagemTextos[imtx].MenuRapido then
				Var2.imagemTextos[imtx].MenuRapido:removeSelf()
				Var2.imagemTextos[imtx].MenuRapido = nil
			end
			if Var2.imagemTextos[imtx].botaoDeAumentar then
				Var2.imagemTextos[imtx].botaoDeAumentar:removeSelf()
				Var2.imagemTextos[imtx].botaoDeAumentar = nil
				jacliquei = false
			end
			Var2.imagemTextos[imtx]:removeSelf()
			Var2.imagemTextos[imtx] = nil
		end
		Var2.imagemTextos = {}
	end
	if(Var2.sons ~= nil) then
		for son=1, #Var2.sons do
			if Var2.sons[son].Runtime then
				timer.cancel(Var2.sons[son].Runtime)
				Var2.sons[son].Runtime = nil
			end
			if Var2.sons[son].RuntimeSlider then
				timer.cancel(Var2.sons[son].RuntimeSlider)
				Var2.sons[son].RuntimeSlider = nil
			end
			if Var2.sons[son].delay then
				timer.cancel(Var2.sons[son].delay)
				Var2.sons[son].delay = nil
			end
			if Var2.sons[son].timerVoltar then
				timer.cancel(Var2.sons[son].timerVoltar)
				Var2.sons[son].timerVoltar = nil
			end
			if Var2.sons[son].timerAvancar then
				timer.cancel(Var2.sons[son].timerAvancar)
				Var2.sons[son].timerAvancar = nil
			end
			if Var2.sons[son].timerUp then
				timer.cancel(Var2.sons[son].timerUp)
				Var2.sons[son].timerUp = nil
			end
			if Var2.sons[son].Runtime then
				timer.cancel(Var2.sons[son].Runtime)
				Var2.sons[son].Runtime = nil
			end
			Var2.sons[son]:removeSelf()
			Var2.sons[son] = nil
		end
		Var2.sons = {}
	end
	if(Var2.imagens ~= nil) then
		for ims=1, #Var2.imagens do
			if Var2.imagens[ims].MenuRapido then
				Var2.imagens[ims].MenuRapido:removeSelf()
				Var2.imagens[ims].MenuRapido = nil
			end
			Var2.imagens[ims]:removeSelf()
		end
		Var2.imagens = {}
	end
	if(Var2.botoes ~= nil) then
		for bot=1, #Var2.botoes do
			Var2.botoes[bot]:removeSelf()
		end 
		Var2.botoes={}
	end
	if(Var2.textos ~= nil) then
		for txt=1, #Var2.textos do
			if Var2.textos[txt].botaoDeAumentar then
				Var2.textos[txt].botaoDeAumentar:removeSelf()
				Var2.textos[txt].botaoDeAumentar = nil
				jacliquei = false
			end
			Var2.textos[txt]:removeSelf()
		end
	
		Var2.textos = {}
	end
	if(Var2.eXercicios ~= nil) then
		for exes=1, #Var2.eXercicios do
			for exe=1, #Var2.eXercicios[exes][1] do
				Var2.eXercicios[exes][1][exe]:removeSelf()
				Var2.eXercicios[exes][1][exe] = nil
			end
			if Var2.eXercicios[exes].timer then
				timer.cancel(Var2.eXercicios[exes].timer)
				Var2.eXercicios[exes].timer = nil
			end
			Var2.eXercicios[exes][1] = {}
			Var2.eXercicios[exes][2]:removeSelf()
			Var2.eXercicios[exes][3]:removeSelf()
			Var2.eXercicios[exes][4]:removeSelf()
			Var2.eXercicios[exes][5]:removeSelf()
			Var2.eXercicios[exes][6]:removeSelf()
			Var2.eXercicios[exes] = {}
			Var2.eXercicios[exes] = nil	
		end
		Var2.eXercicios = {}	
	end
	if(Var2.videos ~= nil) then
		for vid=1, #Var2.videos do
			if Var2.videos[vid].tipo == "incorporado"--[[ or Var2.video.tipo == "local"]]then
				if Var2.videos[vid].timer then
					timer.cancel(Var2.videos[vid].timer)
					Var2.videos[vid].timer = nil
				end
				Var2.videos[vid]:removeSelf()
				Var2.videos[vid] = nil
			else
				if Var2.videos[vid].timer then
					timer.cancel(Var2.videos[vid].timer)
					Var2.videos[vid].timer = nil
				end
				if Var2.videos[vid].timerVoltar then
					timer.cancel(Var2.videos[vid].timerVoltar)
					Var2.videos[vid].timerVoltar = nil
				end
				if Var2.videos[vid].timerAvancar then
					timer.cancel(Var2.videos[vid].timerAvancar)
					Var2.videos[vid].timerAvancar = nil
				end
				if Var2.videos[vid].runtimeYouTube then
					timer.cancel(Var2.videos[vid].runtimeYouTube)
					Var2.videos[vid].runtimeYouTube = nil
				end
				if Var2.videos[vid].esconderVideo then
					Runtime:removeEventListener("orientation",Var2.videos[vid].esconderVideo)
				end
				if Var2.videos[vid].url then
				else
					Var2.videos[vid]:removeSelf()
					Var2.videos[vid] = nil
				end
			end
		end
		Var2.videos = {}
	end
	if(Var2.indiceManual ~= nil) then
		if Var2.indiceManual.botao then
			Var2.indiceManual.botao:removeSelf()
		end
		Var2.indiceManual:removeSelf()
		Var2.indiceManual=nil
	end
	if(Var2.animacoes ~= nil) then
	
		for ani=1, #Var2.animacoes do
			if Var2.animacoes[ani].timer then
				for i=1,#Var2.animacoes[ani].timer do
					timer.cancel(Var2.animacoes[ani].timer[i])
					Var2.animacoes[ani].timer[i] = nil
				end
			end
			if Var2.animacoes[ani].timer2 then
				timer.cancel(Var2.animacoes[ani].timer2)
				Var2.animacoes[ani].timer2 = nil
			end
			if Var2.animacoes[ani].som then
				audio.stop(Var2.animacoes[ani].som)
				Var2.animacoes[ani].som = nil
			end
			Var2.animacoes[ani]:removeSelf()
			Var2.animacoes[ani]=nil
		end
		Var2.animacoes={}
	end
	if Var2.anotComInterface then
		Var2.anotComInterface:removeSelf()
		Var2.anotComInterface=nil
		if Var2.comentario.telaProtetiva then
			Var2.comentario.telaProtetiva:removeSelf()
			Var2.comentario.telaProtetiva = nil
		end
		if Var2.comentario.MenuRapido then
			Var2.comentario.MenuRapido:removeSelf()
			Var2.comentario.MenuRapido = nil
		end
	end
	if Var2.Impressao then
		Var2.Impressao:removeSelf()
		Var2.Impressao=nil
	end
end

function M.criarImagensDasPaginas(vetorTelas) -- vetorTelas[1] = {pasta = "Dicionario Palavras",arquivo = "Verbete1.txt"}
	local Var2 = {}
	
	local GRUPOGERAL2 = display.newGroup()
	GRUPOGERAL2.mudancaTamanho = 0
	GRUPOGERAL2.ultimaPaginaSalva = nil
	local i = 1
	--print("vetorTelas",vetorTelas)
	if vetorTelas then
		--print("vetorTelas",vetorTelas.ordemElementos,#vetorTelas.ordemElementos)
		vetorTelas.cont = {}
		vetorTelas.cont.imagemTextos = 1
		vetorTelas.cont.imagens = 1
		vetorTelas.cont.textos = 1
		vetorTelas.cont.animacoes = 1
		vetorTelas.cont.exercicios = 1
		vetorTelas.cont.botoes = 1
		vetorTelas.cont.espacos = 1
		vetorTelas.cont.separadores = 1
		vetorTelas.cont.videos = 1
		vetorTelas.cont.sons = 1
	end
	Var2.proximoY = 100
	-- criar a página e salvar a imagem dela
	
	if vetorTelas ~= nil and vetorTelas.ordemElementos ~= nil then
		for ord=1, #vetorTelas.ordemElementos do
			--print("WARNING: COMEÇOU")
			--print(vetorTelas.ordemElementos[ord])
			if vetorTelas ~= nil then
				if(vetorTelas.ordemElementos[ord] == "imagem") then
					if not Var2.imagens then Var2.imagens = {} end
					local ims = vetorTelas.cont.imagens
					vetorTelas.imagens[ims].contElemento = ord
					if vetorTelas.imagens[ims].arquivo then
						vetorTelas.imagens[ims].enderecoArquivos = vetorTelas.endereco
						Var2.imagens[ims] = elemTela.colocarImagem(vetorTelas.imagens[ims])
						Var2.imagens[ims].conteudo = vetorTelas.imagens[ims].conteudo
						Var2.imagens[ims].atributoALT = vetorTelas.imagens[ims].atributoALT
						Var2.imagens[ims].y = Var2.imagens[ims].y + Var2.proximoY
						Var2.imagens[ims].contImagem = ims
						Var2.proximoY = Var2.imagens[ims].y + Var2.imagens[ims].height
						GRUPOGERAL2:insert(Var2.imagens[ims]) 
					end
					local function abrirMenuRapido(event)
						Var2.imagens[ims]:removeEventListener("tap",abrirMenuRapido)
						local escolhas = {}
						local Imagem = event.target
						Imagem.tempoAbertoNumero = 0
						if Imagem.zoom == "sim" then table.insert(escolhas,"visualizar") end
						if Imagem.url ~= nil and Imagem.url ~= {} then table.insert(escolhas,"abrir link" )end
						if Imagem.urlembeded ~= nil and Imagem.urlembeded ~= {} then table.insert(escolhas,"abrir link" )end
						if Imagem.conteudo ~= nil and Imagem.conteudo ~= "" then 
							table.insert(escolhas,"descrição" )
						end
						escolhas[#escolhas+1] = "|             X             |"
					
					
						local function aoFecharMenuRapido()
							if Var2.imagens[ims].MenuRapido then
								Var2.imagens[ims].MenuRapido:removeSelf()
								Var2.imagens[ims].MenuRapido = nil
							end
							Var2.imagens[ims]:addEventListener("tap",abrirMenuRapido)
						end
						local function rodarOpcao(e)
							if e.target.params.tipo == "visualizar" then
								print("abriu o zoom: "..Imagem.zoom)
								elemTela.ZoomImagem(event,Var2,vetorTelas,ims,GRUPOGERAL2)
							elseif e.target.params.tipo == "abrir link" then
								if Imagem.url and Imagem.url ~= {} then
									system.openURL(Imagem.url[1])
																		
									local subPagina = GRUPOGERAL2.subPagina
									historicoLib.Criar_e_salvar_vetor_historico({
										tipoInteracao = "imagem",
										pagina_livro = vetorTelas.pagina,
										objeto_id = ims,
										acao = "abrir link da imagem",
										link = Imagem.url[1],
										subPagina = subPagina,
										tela = vetorTelas
									})
									
									if Imagem.tempoAberto then
										timer.cancel(Imagem.tempoAberto)
										Imagem.tempoAberto = nil
									end
								
									Imagem.tempoAbertoNumero = 0
									Imagem.tempoAberto = timer.performWithDelay(100,function() Imagem.tempoAbertoNumero = Imagem.tempoAbertoNumero + 100 end,-1)
								elseif Imagem.urlembeded and Imagem.urlembeded ~= {}  then
									local botaoFechar
									local telaPreta
									local webView
								
									local function fecharSite()
										webView:removeSelf()
										botaoFechar:removeSelf()
										telaPreta:removeSelf()
										local date = os.date( "*t" )
										local data = date.day.."/"..date.month.."/"..date.year
										local hora = date.hour..":"..date.min..":"..date.sec
																				
										local subPagina = GRUPOGERAL2.subPagina
										historicoLib.Criar_e_salvar_vetor_historico({
											tipoInteracao = "imagem",
											pagina_livro = vetorTelas.pagina,
											objeto_id = ims,
											embeded = true,
											acao = "fechar link da imagem",
											link = Imagem.urlembeded[1],
											tempo_aberto = Imagem.tempoAbertoNumero,
											subPagina = subPagina,
											tela = vetorTelas
										})
										
										if Imagem.tempoAberto then
											timer.cancel(Imagem.tempoAberto)
											Imagem.tempoAberto = nil
										end
										Imagem.tempoAbertoNumero = 0
										elemTela.restoreNativeScreenElements(Var2)
										return true
									end
									local function gerarEmbeded()
										local W = W
										local H = H
										telaPreta = display.newRect(0,0,W,H)
										telaPreta.anchorX = 0.5; telaPreta.anchorY = 0.5
										telaPreta.anchorX = 0.5; telaPreta.anchorY = 0.5
										telaPreta.x = W/2; telaPreta.y = H/2
										telaPreta.x = W/2; telaPreta.y = H/2
										telaPreta:setFillColor(1,1,1)
										telaPreta.alpha=0.9
										telaPreta:addEventListener("tap",function() return true end)
										telaPreta:addEventListener("touch",function() return true end)
										webView = native.newWebView( display.contentCenterX, display.contentCenterY + 100, 700, 1000 )
										webView:request( Imagem.urlembeded[1] )
										botaoFechar = display.newRoundedRect(W/2 + 270,H/2 + 720,50,50,5)
										botaoFechar.y = webView.y -webView.height/2 - botaoFechar.height/2
										botaoFechar:setFillColor(.7,.7,.7);botaoFechar.strokeWidth = 5; botaoFechar:setStrokeColor(0.4,0.4,0.4)
										botaoFechar.texto = display.newText("X",botaoFechar.x,botaoFechar.y,native.systemFont,40)
										botaoFechar:addEventListener("tap",fecharSite)
									end
									gerarEmbeded()
																		
									local subPagina = GRUPOGERAL2.subPagina
									historicoLib.Criar_e_salvar_vetor_historico({
										tipoInteracao = "imagem",
										pagina_livro = vetorTelas.pagina,
										objeto_id = ims,
										embeded = true,
										acao = "abrir link da imagem",
										link = Imagem.urlembeded[1],
										subPagina = subPagina,
										tela = vetorTelas
									})
									
									elemTela.clearNativeScreenElements(Var2)
								end
							elseif e.target.params.tipo == "descrição" then
								local atributos = {}
								atributos.modificar = 0
								atributos.conteudo = Var.imagens[ims].conteudo
								atributos.tipoInteracao = "imagem"
								timer.performWithDelay(15,function()funcGlobal.criarDescricao(atributos,true,telas[i].cont.imagens-1); end,1)
							elseif e.target.params.tipo == "|             X             |" then
								print("cancelou zoom")
							end
							aoFecharMenuRapido()
						end
						local escolhasGerais = {}
						for i=1,#escolhas do

							table.insert(escolhasGerais,
							{
								listener = rodarOpcao,
								tamanho = 30,
								texto = escolhas[i],
								cor = {.9,.9,.9},
								params = {tipo = escolhas[i]},
								cor = {37/225,185/225,219/225},
							})
							if escolhas[i] == "visualizar" then
								escolhasGerais[#escolhasGerais].iconeEsq =  {imagem = "botaozoom.png",alt = 30,larg = 30}
							elseif escolhas[i] == "abrir link" then
								escolhasGerais[#escolhasGerais].iconeEsq =  {imagem = "botaourl.png"}
							elseif escolhas[i] == "descrição" then
								escolhasGerais[#escolhasGerais].iconeEsq =  {imagem = "detalhes.png",alt = 30,larg = 30}
							else
								escolhasGerais[#escolhasGerais].fonte = "Fontes/paolaAccent.ttf"
							end
						end
						Var2.imagens[ims].MenuRapido = MenuRapido.New(
							{
							escolhas = escolhasGerais,
							rowWidthGeneric = 200,
							rowHeightGeneric = 40,
							tamanhoTexto = 30,
							closeListener = aoFecharMenuRapido,
							telaProtetiva = "nao"
							}
						)
						GRUPOGERAL2:insert(Var2.imagens[ims].MenuRapido)
						--Var.imagens[ims].MenuRapido.x = event.x
						--Var.imagens[ims].MenuRapido.y = event.y - GRUPOGERAL.y
						Var2.imagens[ims].MenuRapido.x = event.target.x
						Var2.imagens[ims].MenuRapido.y = event.target.y + event.target.height/2
						Var2.imagens[ims].MenuRapido.anchorY=1
						if Var2.imagens[ims].MenuRapido.x + Var2.imagens[ims].MenuRapido.width > W and system.orientation == "portrait" then
							Var2.imagens[ims].MenuRapido.x = event.x - Var2.imagens[ims].MenuRapido.width
						end
						--[[if Var.imagens[ims].MenuRapido.y + Var.imagens[ims].MenuRapido.height > H and system.orientation == "portrait" then
							Var.imagens[ims].MenuRapido.y = event.y - Var.imagens[ims].MenuRapido.height - GRUPOGERAL.y
						end]]
						if system.orientation == "landscapeLeft" then
							Var2.imagens[ims].MenuRapido.y = event.target.y + event.target.height/2
							Var2.imagens[ims].MenuRapido.x = event.target.x
						elseif system.orientation == "landscapeRight" then
							Var2.imagens[ims].MenuRapido.y = event.target.y + event.target.height/2
							Var2.imagens[ims].MenuRapido.x = event.target.x
						end
					
					end
					
					if Var2.imagens[ims] then
						if Var2.imagens[ims].zoom == "sim"or (Var2.imagens[ims].url ~= nil and Var2.imagens[ims].url ~= {} and Var2.imagens[ims].url[1] ) or (Var2.imagens[ims].urlembeded ~= nil and Var2.imagens[ims].urlembeded ~= {} and Var2.imagens[ims].urlembeded[1] ) or Var2.imagens[ims].atributoALT ~= nil then
							
							Var2.imagens[ims]:addEventListener("tap",abrirMenuRapido)
						end
						GRUPOGERAL2:insert(Var2.imagens[ims])
					end
		  
					vetorTelas.cont.imagens =  vetorTelas.cont.imagens + 1
				end
				--verifica se tem espaço
				if(vetorTelas.ordemElementos[ord] == "espaco") then
					if not Var2.espacos then Var2.espacos = {} end
					local esp = vetorTelas.cont.espacos
					vetorTelas.espacos[esp].contElemento = ord
					Var2.espacos[esp] = elemTela.colocarEspaco(vetorTelas.espacos[esp])
					vetorTelas.cont.espacos =  vetorTelas.cont.espacos + 1
					Var2.espacos[esp].y = Var2.espacos[esp].y + Var2.proximoY
					Var2.proximoY = Var2.espacos[esp].y + Var2.espacos[esp].height
				end
				--verifica se tem separador
				if(vetorTelas.ordemElementos[ord] == "separador") then
					if not Var2.separadores then Var2.separadores = {} end
					local sep = vetorTelas.cont.separadores
					vetorTelas.separadores[sep].contElemento = ord
					Var2.separadores[sep] = elemTela.colocarSeparador(vetorTelas.separadores[sep])
					vetorTelas.cont.separadores =  vetorTelas.cont.separadores + 1
					Var2.separadores[sep].y = Var2.separadores[sep].y + Var2.proximoY
					Var2.proximoY = Var2.separadores[sep].y + Var2.separadores[sep].height
					GRUPOGERAL2:insert(Var2.separadores[sep])
				end
				--verifica se tem som
				if(vetorTelas.ordemElementos[ord] == "som") then
					if not Var2.sons then Var2.sons = {} end
					local son = vetorTelas.cont.sons
					vetorTelas.sons[son].contElemento = ord
					vetorTelas.sons[son].enderecoArquivos = vetorTelas.endereco
					Var2.sons[son] = elemTela.colocarSom(vetorTelas.sons[son],vetorTelas)
					vetorTelas.cont.sons =  vetorTelas.cont.sons + 1
					Var2.sons[son].y = Var2.sons[son].y + Var2.proximoY
					Var2.proximoY = Var2.sons[son].y + Var2.sons[son].height
					GRUPOGERAL2:insert(Var2.sons[son])
					
					
				end
				--verifica se tem video
				if(vetorTelas.ordemElementos[ord] == "video") then
					if not Var2.videos then Var2.videos = {} end
					local vids = vetorTelas.cont.videos
					vetorTelas.videos[vids].contElemento = ord
					vetorTelas.videos[vids].enderecoArquivos = vetorTelas.endereco
					Var2.videos[vids] = elemTela.colocarVideo(vetorTelas.videos[vids],vetorTelas)
					Var2.videos[vids].contVideo = vetorTelas.cont.videos
					vetorTelas.cont.videos =  vetorTelas.cont.videos + 1
					Var2.videos[vids].y = Var2.videos[vids].y + Var2.proximoY
					Var2.proximoY = Var2.videos[vids].y + Var2.videos[vids].videoH
					GRUPOGERAL2:insert(Var2.videos[vids])
				end

				if(vetorTelas.ordemElementos[ord] == "exercicio") then
					if not Var2.eXercicios then Var2.eXercicios = {} end
					local exes = vetorTelas.cont.exercicios
					vetorTelas.exercicios[exes].contElemento = ord
					vetorTelas.exercicios[exes].enderecoArquivos = vetorTelas.endereco
					Var2.eXercicios[exes] = {}
					Var2.eXercicios[exes][1] = {}
					Var2.eXercicios[exes][1],Var2.eXercicios[exes][2],Var2.eXercicios[exes][3],Var2.eXercicios[exes][4],Var2.eXercicios[exes][5],Var2.eXercicios[exes][6] = elemTela.criarExercicio(vetorTelas.exercicios[exes],vetorTelas)
					if vetorTelas.exercicios[exes].corretas and #vetorTelas.exercicios[exes].corretas > 1 then
							Var2.eXercicios[exes][5].tipo = "multiplas"
						else
							Var2.eXercicios[exes][5].tipo = "simples"
					end
					Var2.eXercicios[exes][5].exe = exes
					Var2.eXercicios[exes][5].contExerc = vetorTelas.cont.exercicios
					vetorTelas.cont.exercicios =  vetorTelas.cont.exercicios + 1
					GRUPOGERAL2:insert(Var2.eXercicios[exes][6])
					GRUPOGERAL2:insert(Var2.eXercicios[exes][5])
					GRUPOGERAL2:insert(Var2.eXercicios[exes][4])
					GRUPOGERAL2:insert(Var2.eXercicios[exes][2])
					GRUPOGERAL2:insert(Var2.eXercicios[exes][3])
	
					Var2.eXercicios[exes][2].y = Var2.eXercicios[exes][2].y + Var2.proximoY
					Var2.eXercicios[exes][3].y = Var2.eXercicios[exes][3].y + Var2.proximoY
					Var2.eXercicios[exes][4].y = Var2.eXercicios[exes][4].y + Var2.proximoY
					Var2.eXercicios[exes][5].y = Var2.eXercicios[exes][5].y + Var2.proximoY
					for exe=1,#Var2.eXercicios[exes][1] do
						Var2.eXercicios[exes][1][exe].y = Var2.eXercicios[exes][1][exe].y + Var2.proximoY
						GRUPOGERAL2:insert(Var2.eXercicios[exes][1][exe])
					end
					Var2.proximoY = Var2.eXercicios[exes][5].y + Var2.eXercicios[exes][5].height
				end

				if(vetorTelas.ordemElementos[ord] == "indiceManual") then
					local function funcRetorno() end
					Var2.indiceManual = elemTela.colocarIndicePreMontado(vetorTelas.indiceManual,vetorTelas,funcRetorno)
					while Var2.indiceManual.numChildren > 0 do
						Var2.indiceManual[1].y = Var2.indiceManual[1].y + Var2.indiceManual.y
						Var2.indiceManual[1].x = Var2.indiceManual[1].x + Var2.indiceManual.x
						Var2.indiceManual[1].anchorX=Var2.indiceManual.anchorX
						Var2.indiceManual[1].anchorY=Var2.indiceManual.anchorY
						
						GRUPOGERAL2:insert(Var2.indiceManual[1])
					end
				end

				if(vetorTelas.ordemElementos[ord] == "texto") then
					if not Var2.textos then Var2.textos = {} end
					local txt = vetorTelas.cont.textos
					vetorTelas.textos[txt].contTexto = txt
					vetorTelas.textos[txt].contElemento = ord
					vetorTelas.textos[txt].enderecoArquivos = vetorTelas.endereco
					Var2.textos[txt] = elemTela.colocarTexto(vetorTelas.textos[txt],vetorTelas)
					
					Var2.textos[txt].mudarTamanhoFonte = function(atrib)
						M.mudarTamanhoFonte(atrib,GRUPOGERAL2)
					end
					vetorTelas.cont.textos = vetorTelas.cont.textos + 1
					Var2.textos[txt].txt = vetorTelas.textos[txt].texto
					Var2.textos[txt].iii = txt
					Var2.textos[txt].y = Var2.proximoY
					Var2.proximoY = Var2.textos[txt].y + Var2.textos[txt].height
					GRUPOGERAL2:insert(Var2.textos[txt])
					GRUPOGERAL2.mudarTamanhoFonte = Var2.textos[txt].mudarTamanho
				end
				--Verifica se tem animacao
				if(vetorTelas.ordemElementos[ord] == "animacao") then
					if not Var2.animacoes then Var2.animacoes = {} end
					local ani = vetorTelas.cont.animacoes
					vetorTelas.animacoes[ani].contElemento = ord
					vetorTelas.animacoes[ani].enderecoArquivos = vetorTelas.endereco
					Var2.animacoes[ani] = elemTela.colocarAnimacao(vetorTelas.animacoes[ani],vetorTelas)
					vetorTelas.cont.animacoes = vetorTelas.cont.animacoes + 1
					Var2.animacoes[ani].y = Var2.animacoes[ani].y + Var2.proximoY
					Var2.proximoY = Var2.animacoes[ani].y + Var2.animacoes[ani].height
					GRUPOGERAL2:insert(Var2.animacoes[ani])
				end 
				--verifica se tem botao
				if(vetorTelas.ordemElementos[ord] == "botao") then
	
					if not Var2.botoes then Var2.botoes = {} end
					local bot = vetorTelas.cont.botoes
					vetorTelas.botoes[bot].contElemento = ord
					vetorTelas.botoes[bot].enderecoArquivos = vetorTelas.endereco
					Var2.botoes[bot] = elemTela.colocarBotao(vetorTelas.botoes[bot],vetorTelas)
					vetorTelas.cont.botoes =  vetorTelas.cont.botoes + 1
					Var2.botoes[bot].y = Var2.botoes[bot].y + Var2.proximoY
					Var2.botoes[bot].YY = Var2.botoes[bot].YY + Var2.proximoY
					Var2.proximoY = Var2.botoes[bot].y + Var2.botoes[bot].height
					GRUPOGERAL2:insert(Var2.botoes[bot])
				end	

				if(vetorTelas.ordemElementos[ord] == "imagemTexto") then
					if not Var2.imagemTextos then Var2.imagemTextos = {} end
					local imtx = vetorTelas.cont.imagemTextos
					vetorTelas.imagemTextos[imtx].contElemento = ord
					vetorTelas.imagemTextos[imtx].enderecoArquivos = vetorTelas.endereco
					Var2.imagemTextos[imtx] = elemTela.colocarImagemTexto(vetorTelas.imagemTextos[imtx],vetorTelas)
					vetorTelas.cont.imagemTextos =  vetorTelas.cont.imagemTextos + 1
					Var2.imagemTextos[imtx].y = Var2.imagemTextos[imtx].y + Var2.proximoY
					Var2.proximoY = Var2.imagemTextos[imtx].y + Var2.imagemTextos[imtx].height

					if Var2.imagemTextos[imtx] then
						GRUPOGERAL2:insert(Var2.imagemTextos[imtx])
					end	
				end
				
			end
			
		end	
		
	end

	if Var2.telaMovedora then Var2.telaMovedora:removeSelf(); Var2.telaMovedora = nil; end

	Var2.telaMovedora = display.newRect(0,0,0,0)
	Var2.telaMovedora.width = W;Var2.telaMovedora.height = GRUPOGERAL2.height
	Var2.telaMovedora.y = GRUPOGERAL2.y
	Var2.telaMovedora.x = GRUPOGERAL2.x;Var2.telaMovedora.y = 0
	Var2.telaMovedora.anchorX=0;Var2.telaMovedora.anchorY=0;
	Var2.telaMovedora:setFillColor(1,0,0)
	Var2.telaMovedora.alpha = 0; Var2.telaMovedora.isHitTestable = true
	GRUPOGERAL2:insert(Var2.telaMovedora)
	

	GRUPOGERAL2ORIGINX = GRUPOGERAL2.x
	GRUPOGERAL2ORIGINY =	GRUPOGERAL2.y

	-- Baixar e criar anotações --
	--!!!--leitArqTxt.criarAnotacoesComentarios(pagina,vetorTelas)
	--!!!--Var2.Impressao = leitArqTxt.criarBotaoImpressao(pagina,vetorTelas)
	--!!!--GRUPOGERAL2:insert(Var2.Impressao)
	--------------------------------
	-- VERIFICAR EXERCICIO ABERTO --
	--------------------------------
	
	if Var2.eXercicios and varGlobal.exercicioAberto and varGlobal.exercicioAberto.pagina and varGlobal.exercicioAberto.numero then
		for i=1,#varGlobal.exercicioAberto.pagina do
			for exes=1,#Var2.eXercicios do
				if varGlobal.exercicioAberto.pagina[i] == pagina and varGlobal.exercicioAberto.numero[i] == Var2.eXercicios[exes][5].contExerc then
					local vetor = {}
					vetor.target = {}
					vetor.target.tempo = Var2.eXercicios[exes][5].tempo
					vetor.target.numero = Var2.eXercicios[exes][5].numero
					vetor.target.contExerc =  Var2.eXercicios[exes][5].contExerc
					vetor.target.index = Var2.eXercicios[exes][5].index
					vetor.target.HH =  Var2.eXercicios[exes][5].HH
					vetor.naoHistorico = true
					Var2.eXercicios[exes].abriu = false
					Var2.eXercicios[exes].nSalvarAbrir = true
					Var2.eXercicios[exes][5].abrirFecharExercicio(vetor)
					timer.performWithDelay(1000,function()varGlobal.limiteTela = varGlobal.limiteTela + Var2.eXercicios[exes][5].HH*1 end,1)
					--timer.performWithDelay(2000,function() funcGlobal.abrirFecharExercicio(vetor)end,1)
				end
			end
		end
	else
		if varGlobal and varGlobal.WindowsDireita then
			varGlobal.WindowsDireita.height,varGlobal.WindowsEsquerda.height = varGlobal.limiteTela,varGlobal.limiteTela
		end
	end

	Var2.retanguloMovimento = display.newRect(0,0,0,0)
	Var2.retanguloMovimento.anchorX=0;Var2.retanguloMovimento.anchorY=0
	Var2.retanguloMovimento.alpha=0
	Var2.retanguloMovimento.isHitTestable=true
	Var2.retanguloMovimento.height = GRUPOGERAL2.height + 100
	Var2.retanguloMovimento.width = W
	if Var2.retanguloMovimento.height < 1280 then
		Var2.retanguloMovimento.height = 1280
	end
	local function removerTela()
		M.RemoverTela(Var2)
	end
	GRUPOGERAL2:insert(1,Var2.retanguloMovimento)
	GRUPOGERAL2.removerTela = removerTela
	
	return GRUPOGERAL2
end

function M.criarUmaTela(atributos,refazerTela)
	local TelaFormada = {}
	local vetorTela = {}
	local vetorErro = {}
	local VetorDeVetorTTS = {}
	local VetorTTS = {}
	local nPagina = 1
	local enderecoArquivos = atributos.pasta.."/Outros Arquivos"
	local nomeArquivo = auxFuncs.tirarAExtencao(atributos.arquivo)
	local substituicoesOnline = {}
	substituicoesOnline.original = {}
	substituicoesOnline.novo = {}
	local paginaAtual = 1
	local vetorPagina = {}
	local exercicio = atributos.exercicio or nil
	local correta = atributos.correta or "-----"
	local card = atributos.card or nil
	if not atributos.vetorRefazer then
		vetorPagina = M.criarVetorTeladeArquivo({pasta = atributos.pasta,arquivo = atributos.arquivo,TTSTipo="RSS",scriptDic = atributos.scriptDaPagina,exercicio = exercicio,correta = correta,card = card},vetorTela,vetorErro,nPagina,nomeArquivo,VetorTTS,substituicoesOnline,paginaAtual,VetorDeVetorTTS)
	else
		vetorPagina = atributos.vetorRefazer
	end
	vetorPagina.endereco = enderecoArquivos
	
	if atributos.dicionario then
		vetorPagina.dicionario = true
	end
	vetorPagina.card = card
	local PaginaCriada = M.criarImagensDasPaginas(vetorPagina)
	
	PaginaCriada.refazer = function(tela)
		refazerTela({tela = tela,PaginaCriada = PaginaCriada})
	end
	
	return PaginaCriada
end

return M