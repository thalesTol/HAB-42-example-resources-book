local M = {}
local colocarFormatacaoTexto = require "colocarFormatacaoTexto"
--local pdfImageConverter = require("plugin.pdfImageConverter")
--local zip = require( "plugin.zip" )
local auxFuncs = require("ferramentasAuxiliares")
local W = display.viewableContentWidth ;
local H = display.viewableContentHeight;
local validarUTF8 = require("utf8Validator")
local conversor = require("conversores")
local widget = require("widget")
local lfs = require "lfs";
local leituraTXT = require("leituraArquivosTxT")
local historicoLib = require("historico")
local MenuRapido = require("MenuBotaoDireito")
local json = require("json")
local pdfImageConverter = require("plugin.pdfImageConverter")

--  FUNÇÕES AUXILIARES MANIPULAR ELEMENTOS
--  COLOCAR TTS
	-- TTS RODAPE --
	-- TTS COMENTARIOS --
--  COLOCAR RODAPÉ
--  COLOCAR DICIONÁRIO
--  COLOCAR ANOTAÇÃO E COMENTÁRIO
--  COLOCAR BOTÃO IMPRIMIR
--  COLOCAR BOTÃO SALVAR RELATÓRIO
--  COLOCAR DESCRIÇÃO EM TEXTO
--  COLOCAR CONFIGS VOZ (TTS)
--	COLOCAR IMAGEM
--	COLOCAR SOM
--	COLOCAR HTML View
--	COLOCAR BOTAO
--	COLOCAR IMAG E TEXT
--	COLOCAR ESPAÇO
--	COLOCAR SEPARADOR
--	COLOCAR FUNDO
--	COLOCAR TEXTO
--	COLOCAR VIDEO
--	COLOCAR ANIMACAO
--  COLOCAR EXERCICIOS
--	COLOCAR DECK
--	COLOCAR PLANO DE FUNDO

----------------------------------------------------------
--  FUNÇÕES AUXILIARES MANIPULAR ELEMENTOS ---------------
----------------------------------------------------------
function M.clearNativeScreenElements(Var2)
	if Var2 and Var2.videos then
		print("WARNING: TEM VAR")
		for v=1,#Var2.videos do
			if Var2.videos[v].video then
				Var2.videos[v].video:removeSelf()
				Var2.videos[v].video = nil
			end
		end
	end
end
function M.restoreNativeScreenElements()
	if Var2 and Var2.videos then
		for v=1,#Var2.videos do
			if Var2.videos[v].video and Var2.videos[v].video.xOriginal then
				--Var.videos[v].video.y = Var.videos[v].video.yOriginal
				--Var.videos[v].video.isVisible = true
				--Var.videos[v].video.alpha = 1	sddwWiller14325
			end
		end
	end
end

----------------------------------------------------------
--  COLOCAR TTS ------------------------------------------
----------------------------------------------------------
function M.rodarVideoTTS(arquivo,grupoVideoTTS,onComplete)
	local function videoListener(e)
		local tempoTotal = grupoVideoTTS.videoTTS.totalTime
		
		if e.errorCode then
			native.showAlert( "Error!", e.errorMessage, { "OK" } )
			
		elseif e.phase == "ready" then
			
		elseif e.phase == "ended" then
			local evento = {}
			evento.completed = true
			grupoVideoTTS = nil
			onComplete(evento)
		end
	end
	grupoVideoTTS = display.newGroup()
	--[[local telaPreta = display.newRect(0,0,W,H)
	telaPreta.anchorX = 0.5; telaPreta.anchorY = 0.5
	telaPreta.anchorX = 0.5; telaPreta.anchorY = 0.5
	telaPreta.x = W/2; telaPreta.y = H/2
	telaPreta.x = W/2; telaPreta.y = H/2
	telaPreta:setFillColor(0,0,0)
	telaPreta.alpha=1
	telaPreta:addEventListener("tap",function() return true end)
	telaPreta:addEventListener("touch",function() return true end)]]
	grupoVideoTTS.videoTTS = native.newVideo(display.contentCenterX,display.contentCenterY,720,480)
	grupoVideoTTS.videoTTS.anchorX=.5
	grupoVideoTTS.videoTTS.anchorY=.5
	--grupoVideoTTS:insert(telaPreta)
	grupoVideoTTS:insert(grupoVideoTTS.videoTTS)
	grupoVideoTTS.videoTTS:load(arquivo,system.ResourceDirectory )
	grupoVideoTTS.videoTTS:addEventListener( "video", videoListener )
	grupoVideoTTS.videoTTS:play()
end
function M.rodarAudiosTTS(atrib,vetorBotoes,arquivosCriados,Var)
	media.stopSound()
	audio.stop()

	local function onComplete(event)
		if vetorBotoes then
			vetorBotoes:clearTTSelements(vetorBotoes)
		end
		auxFuncs.restoreNativeScreenElements(Var)
		if ( event.completed ) then
			vetorBotoes.contSons = vetorBotoes.contSons +1
		else
			return true
		end
		if vetorBotoes.contSons <= #arquivosCriados.lista then
			media.stopSound()
			if arquivosCriados.video[vetorBotoes.contSons] then
				auxFuncs.clearNativeScreenElements(Var)
				vetorBotoes:clearTTSelements(vetorBotoes)
				vetorBotoes.video = {}
				M.rodarVideoTTS(arquivosCriados.video,vetorBotoes.video,onComplete)
			elseif arquivosCriados.botao and arquivosCriados.botao[vetorBotoes.contSons] then

			elseif arquivosCriados.animacao and arquivosCriados.animacao[vetorBotoes.contSons] then
				auxFuncs.clearNativeScreenElements(Var)
				vetorBotoes:clearTTSelements()
				--funcGlobal.criarAnimacaoTTS()
			else
				local som
				if arquivosCriados.audio[vetorBotoes.contSons] then
					som = audio.loadStream(arquivosCriados.lista[vetorBotoes.contSons],system.ResourcesDirectory)
				else
					som = audio.loadStream(arquivosCriados.lista[vetorBotoes.contSons],system.DocumentsDirectory)
				end
				if not som then
					local evento = {}
					evento.completed = true
					onComplete(evento)
				else
					local TTSduracaoTotal = audio.getDuration(som)
					timer.performWithDelay(16,
					function()
						local audioRodando = audio.play(som,{onComplete=onComplete});
					end,1)
				end
			end
		elseif vetorBotoes.contSons > #arquivosCriados.lista then
			print("Acabou a página TTS, repetir o último após um BEEP")
			vetorBotoes.contSons = vetorBotoes.contSons -2
			local som = audio.loadSound("fimLivro.mp3")
			print("atrib.funcionalidade = ",atrib.funcionalidade)
			if atrib.funcionalidade and atrib.funcionalidade == "dicionario" then
				som = audio.loadSound("fimDic.mp3")
			end
			if atrib.funcionalidade and atrib.funcionalidade == "mensagens" then
				audio.stop()
			else
				local audioRodando = audio.play(som,{onComplete=onComplete});
			end
			--rodarProximaPaginaTTS(telas)
			return true
		end
	end

	-- rodar primeiro som --
	if arquivosCriados.video[vetorBotoes.contSons] then
		auxFuncs.clearNativeScreenElements(Var)
		vetorBotoes:clearTTSelements(vetorBotoes)
		vetorBotoes.video = {}
		M.rodarVideoTTS(arquivosCriados.video,vetorBotoes.video,onComplete)
	elseif arquivosCriados.botao and arquivosCriados.botao[vetorBotoes.contSons] then

	elseif arquivosCriados.animacao and arquivosCriados.animacao[vetorBotoes.contSons] then
		auxFuncs.clearNativeScreenElements(Var)
		vetorBotoes:clearTTSelements(vetorBotoes)
		--funcGlobal.criarAnimacaoTTS()
	else
		local som = nil
		if arquivosCriados.audio[vetorBotoes.contSons] then
			som = audio.loadStream(arquivosCriados.lista[vetorBotoes.contSons],system.ResourcesDirectory)
		else
			som = audio.loadStream(arquivosCriados.lista[vetorBotoes.contSons],system.DocumentsDirectory)
		end
		if not som then
			local evento = {}
			evento.completed = true
			onComplete(evento)
		else
			local TTSduracaoTotal = audio.getDuration(som)
			timer.performWithDelay(16,
			function()
				local audioRodando = audio.play(som,{onComplete=onComplete});
			end,1)
		end
	end
end
function M.DownloadTTSandCreateTXT(arquivosCriados,atributos,numero)
	print("numero="..numero)
	if numero <= #arquivosCriados.nomesArquivosParagrafos then

		if arquivosCriados.tableParagrafosFinais.audio[numero] then
			arquivosCriados.nomesArquivosParagrafos.audio[numero] = arquivosCriados.tableParagrafosFinais.audio[numero]
			numero = numero + 1
		elseif arquivosCriados.tableParagrafosFinais.video[numero] then
			arquivosCriados.nomesArquivosParagrafos.video[numero] = arquivosCriados.tableParagrafosFinais.video[numero]
			numero = numero + 1
		elseif arquivosCriados.tableParagrafosFinais.animacao[numero] then
			arquivosCriados.nomesArquivosParagrafos.animacao[numero] = arquivosCriados.tableParagrafosFinais.animacao[numero]
			numero = numero + 1
		elseif arquivosCriados.tableParagrafosFinais.botao[numero] then
			auxFuncs.copyFile( arquivosCriados.tableParagrafosFinais.botao[numero], system.ResourcesDirectory, arquivosCriados.nomesArquivosParagrafos[numero], system.pathForFile(nil,system.DocumentsDirectory), true )
			arquivosCriados.nomesArquivosParagrafos.botao[numero] = arquivosCriados.tableParagrafosFinais.botao[numero]
			numero = numero + 1
		end
		if numero <= #arquivosCriados.nomesArquivosParagrafos then
			local params = {}
			params.response = {
				filename = arquivosCriados.nomesArquivosParagrafos[numero],
				baseDirectory = atributos.diretorioBase
			}
			params.progress = "download"
			local frase = arquivosCriados.tableParagrafosFinais[numero]:urlEncode()
			atributos.params = params
			M.requisitarTTSOnline(atributos,arquivosCriados)
		else
			if grupoAguarde then
				grupoAguarde:removeSelf()
				grupoAguarde = nil
			end
			local textoArquivos = ""
			for n=1,#arquivosCriados.nomesArquivosParagrafos do
				local textoAux = arquivosCriados.nomesArquivosParagrafos[n]
				if arquivosCriados.tableParagrafosFinais.verbete[n] then
					textoAux = textoAux .. "|||" .. arquivosCriados.tableParagrafosFinais.verbete[n]
					--arquivosCriados.verbete[n] = arquivosCriados.tableParagrafosFinais.verbete[n]
				end
				if arquivosCriados.tableParagrafosFinais.video[n] then
					textoAux = textoAux .. "|||" .. "video"
					--arquivosCriados.video[n] = arquivosCriados.tableParagrafosFinais.video[n]
				elseif arquivosCriados.tableParagrafosFinais.audio[n] then
					textoAux = textoAux .. "|||" .. "audio"
					--arquivosCriados.audio[n] = arquivosCriados.tableParagrafosFinais.audio[n]
				end
				textoArquivos = textoArquivos .. textoAux .. "\n"
			end
			auxFuncs.criarTxTDoc(atributos.nome.."_"..atributos.pasta.."_"..atributos.pagina..".txt",textoArquivos)
			arquivosCriados:receberLista(arquivosCriados.nomesArquivosParagrafos,arquivosCriados.tableParagrafosFinais)
		end
	else
		if grupoAguarde then
			grupoAguarde:removeSelf()
			grupoAguarde = nil
		end
		local textoArquivos = ""
		for n=1,#arquivosCriados.nomesArquivosParagrafos do
			local textoAux = arquivosCriados.nomesArquivosParagrafos[n]
			if arquivosCriados.tableParagrafosFinais.verbete[n] then
				textoAux = textoAux .. "|||" .. arquivosCriados.tableParagrafosFinais.verbete[n]
				--arquivosCriados.verbete[n] = arquivosCriados.tableParagrafosFinais.verbete[n]
			end
			if arquivosCriados.tableParagrafosFinais.video[n] then
				textoAux = textoAux .. "|||" .. "video"
				--arquivosCriados.video[n] = arquivosCriados.tableParagrafosFinais.video[n]
			elseif arquivosCriados.tableParagrafosFinais.audio[n] then
				textoAux = textoAux .. "|||" .. "audio"
				--arquivosCriados.audio[n] = arquivosCriados.tableParagrafosFinais.audio[n]
			end
			textoArquivos = textoArquivos .. textoAux .. "\n"
		end
		auxFuncs.criarTxTDoc(atributos.nome.."_"..atributos.pasta.."_"..atributos.pagina..".txt",textoArquivos)
		arquivosCriados:receberLista(arquivosCriados.nomesArquivosParagrafos,arquivosCriados.tableParagrafosFinais)
	end
end
function M.requisitarTTSOnline(atributos,arquivosCriados)
	print("chegouAqui")
	if arquivosCriados.tableParagrafosFinais[atributos.controladorParagrafos] == "" then
		atributos.controladorParagrafos = atributos.controladorParagrafos + 1
		M.requisitarTTSOnline(atributos,arquivosCriados)
		arquivosCriados.temAudio = "não"
	else
		arquivosCriados.temAudio = "sim"
		local tableParagrafosFinais = arquivosCriados.tableParagrafosFinais
		local nomesArquivosParagrafos = arquivosCriados.nomesArquivosParagrafos
		local request
		local function networkListenerAux(event)
			print("chegouAqui3")
			if ( event.isError ) then
				arquivosCriados.baixarAudio = "Erro: "..tostring(event.response)
				network.cancel( event.target )
				local destDir = system.DocumentsDirectory
				timer.performWithDelay(100,function()media.stopSound();audio.stop();local som = audio.loadSound(atributos.audioSemNet);audio.play(som);end,1)
				arquivosCriados:receberLista(nomesArquivosParagrafos)
			elseif ( event.phase == "began" ) then
				if ( event.bytesEstimated <= 0 ) then
					print( "Download starting, size unknown" )
				else
					print( "Download starting, estimated size: " .. event.bytesEstimated )
				end
			elseif ( event.phase == "progress" ) then
				if ( event.bytesEstimated <= 0 ) then
					print( "Download progress: " .. event.bytesTransferred )
				else
					print( "Download progress: " .. event.bytesTransferred .. " of estimated: " .. event.bytesEstimated )
				end
			elseif ( event.phase == "ended" ) then
				arquivosCriados.baixarAudio = "ended"
				atributos.controladorParagrafos = atributos.controladorParagrafos + 1
				M.DownloadTTSandCreateTXT(arquivosCriados,atributos,atributos.controladorParagrafos)
			end
		end
		if atributos.tipoTTS == "RSS" then
			print("chegouAqui2")
			local params = {}--atributos.params
			params.progress = "download"
			params.response = {}
			params.response.baseDirectory = system.DocumentsDirectory
			atributos.diretorioBase = system.DocumentsDirectory
			print("atributos.controladorParagrafos",atributos.controladorParagrafos)
			params.response.filename = nomesArquivosParagrafos[atributos.controladorParagrafos]
			local frase = tableParagrafosFinais[atributos.controladorParagrafos]:urlEncode()
			atributos.texto = frase
			local url = "https://api.voicerss.org/?key="..atributos.APIkey.."&hl="..atributos.idioma.."&c="..atributos.extencao.."&r=-1".."&f="..atributos.qualidade.."&src="..atributos.texto
			request = network.request( url, "GET",networkListenerAux,params )
		elseif atributos.tipoTTS == "AWS" then
			atributos.params.body= "Voz="..atributos.voz.."&Texto="..atributos.texto.."&Neural="..atributos.neural
			local URL2 = "https://omniscience42.com/EAudioBookDB/pollyTTS.php"
			request = network.request(URL2, "POST",networkListener,atributos.params)
		end
	end
end
function M.criarAudiosTTS(atributos)
	local arquivosCriados = {}
	arquivosCriados.lista = {}
	--arquivosCriados.verbete = {}
	--arquivosCriados.audio = {}
	--arquivosCriados.video = {}
	arquivosCriados.listaAtualizada = false
	function arquivosCriados:receberLista(lista,tableP)
		for i=1,#tableP do
			self.verbete = tableP.verbete
			self.audio = tableP.audio
			self.video = tableP.video
		end
		self.lista = lista
		self.listaAtualizada = true
	end

	local arquivoTxT = atributos.nome.."_"..atributos.pasta.."_"..atributos.pagina..".txt"
	local diretorio = system.DocumentsDirectory--atributos.diretorioBase
	local vetorTTSAux = atributos.vetor
	print("vetorTTSAux = ",vetorTTSAux,#vetorTTSAux)
	-- montar os textos para cada palavra
	local vetorTTS = {}
	vetorTTS.audios = {}
	vetorTTS.video = {}
	for i=1,#vetorTTSAux do
		--if not 
		vetorTTS[i] = vetorTTSAux[i].texto
		vetorTTS.audios[i] = vetorTTSAux[i].audios
		vetorTTS.video[i] = vetorTTSAux[i].video
	end
	-- primeiro, verificar se arquivos existem --
	if auxFuncs.fileExistsDiretorioBase(arquivoTxT,diretorio) and not string.find(arquivoTxT,"AnotMens") then
		arquivosCriados.offline = true
		local vetorTextoAux = auxFuncs.lerArquivoTXTCaminho(
			{
				caminho = system.pathForFile(arquivoTxT,diretorio),
				tipo = "vetor"
			}
		)
		arquivosCriados.lista = {}
		arquivosCriados.verbete = {}
		arquivosCriados.audio = {}
		arquivosCriados.video = {}
		for i=1,#vetorTextoAux do
			local cont = 1
			for result in string.gmatch(vetorTextoAux[i],"([^|]+)") do
				if cont == 1 then
					arquivosCriados.lista[i] = result
				elseif cont == 2 then
					arquivosCriados.verbete[i] = result
				elseif cont == 3 then
					if string.find(result,"audio") then
						arquivosCriados.audio[i] = true
					elseif string.find(result,"video") then
						arquivosCriados.video[i] = true
					end
				end
				cont = cont + 1
			end
		end
		arquivosCriados.listaAtualizada = true
	elseif auxFuncs.fileExistsDiretorioBase("Dicionario Palavras/Outros Arquivos/Audios Offline"..arquivoTxT,system.ResourceDirectory) then
		arquivosCriados.offline = true
		local vetorTextoAux = auxFuncs.lerArquivoTXTCaminho(
			{
				caminho = system.pathForFile("Dicionario Palavras/Outros Arquivos/Audios Offline"..arquivoTxT,system.ResourceDirectory),
				tipo = "vetor"
			}
		)
		arquivosCriados.lista = {}
		arquivosCriados.verbete = {}
		arquivosCriados.audio = {}
		arquivosCriados.video = {}
		for i=1,#vetorTextoAux do
			local cont = 1
			for result in string.gmatch(vetorTextoAux[i],"([^|]+)") do
				if cont == 1 then
					arquivosCriados.lista[i] = result
				elseif cont == 2 then
					arquivosCriados.verbete[i] = result
				elseif cont == 3 then
					if string.find(result,"audio") then
						arquivosCriados.audio[i] = true
					elseif string.find(result,"video") then
						arquivosCriados.video[i] = true
					end
				end
				cont = cont + 1
			end
		end
		arquivosCriados.listaAtualizada = true
	else
		
	-- segundo, criar arquivos txt e mp3 caso não existam --
		--Iniciando veriaveis Necessarias
		atributos.controladorParagrafos = 1
		local tableParagrafosFinais = {}
		tableParagrafosFinais.audio = {}
		tableParagrafosFinais.video = {}
		tableParagrafosFinais.animacao = {}
		tableParagrafosFinais.botao = {}
		tableParagrafosFinais.verbete = {}
		local nomesArquivosParagrafos = {}
		nomesArquivosParagrafos.audio = {}
		nomesArquivosParagrafos.animacao = {}
		nomesArquivosParagrafos.video = {}
		nomesArquivosParagrafos.botao = {}
		local paragrafoFinal = ""
		local nTTS = 1
		local ultimoParagrafoPequeno = {}
		local ultimaFraseSemUltimoParagrafoPequeno = ""
		local ParagrafoFinalTamanho = 100
		local ParagrafoTamanho = 75

		local function tirarQuebrasDeLinhaRestantes(texto)
			for words in texto:gmatch("[^%s]+") do
				texto = texto .. " " .. words
			end
			return texto
		end
		for i=1,#vetorTTS do
			vetorTTS[i] = conversor.substituirQuebrasDeLinha(vetorTTS[i])
			--tirar Quebras De Linha Restantes
			local textoAux = ""
			for words in vetorTTS[i]:gmatch("[^%s]+") do
				textoAux = textoAux .. " " .. words
			end
			----------------------------------
			vetorTTS[i] = textoAux
		end
		for i=1,#vetorTTS do
			vetorTTS[i] = string.gsub(vetorTTS[i],"\n","#$*$#")
		end
		if not vetorTTS.audio then vetorTTS.audio = {} end
		if not vetorTTS.video then vetorTTS.video = {} end
		if not vetorTTS.botao then vetorTTS.botao = {} end
		if not vetorTTS.animacao then vetorTTS.animacao = {} end
		print("vetorTTS",#vetorTTS)
		for i=1,#vetorTTS do
			local texto = vetorTTS[i]
			paragrafoFinal = ""
			for paragrafo in string.gmatch(texto,"[^#$*$#]+") do
				print("paragrafo",paragrafo)
				paragrafoFinal = paragrafoFinal .. paragrafo .. "\n"
				if string.len(paragrafoFinal) > ParagrafoFinalTamanho --[[and string.len(paragrafo) > ParagrafoTamanho]] then
					--print("Paragrafo "..nTTS.." = "..paragrafoFinal)
					local nomeArquivoAudio = atributos.nome..atributos.pagina.."somTTS "..nTTS.."Vec"..atributos.velocidadeTTS.."."..atributos.extencao
					table.insert(nomesArquivosParagrafos,nomeArquivoAudio)
					table.insert(tableParagrafosFinais,paragrafoFinal)
					tableParagrafosFinais.verbete[#tableParagrafosFinais] = i
					print("paragrafoFinal = ",paragrafoFinal)
					nTTS = nTTS+1

					paragrafoFinal = ""
					ultimaFraseSemUltimoParagrafoPequeno = ""
				end
			end
			if paragrafoFinal ~= "" then
				local nomeArquivoAudio = atributos.nome..atributos.pagina.."somTTS "..nTTS.."Vec"..atributos.velocidadeTTS.."."..atributos.extencao
				table.insert(nomesArquivosParagrafos,nomeArquivoAudio)
				table.insert(tableParagrafosFinais,paragrafoFinal)
				tableParagrafosFinais.verbete[#tableParagrafosFinais] = i
				print("paragrafoFinal = ",paragrafoFinal)
				paragrafoFinal = ""
				nTTS = nTTS+1
			end
			if vetorTTS.audio[i] then
				--table.insert(tableParagrafosFinais,paragrafoFinal)
				paragrafoFinal=nil
				--tableParagrafosFinais.verbete[#tableParagrafosFinais] = i
				table.insert(nomesArquivosParagrafos,vetorTTS.audio[i])
				table.insert(tableParagrafosFinais,"")
				tableParagrafosFinais.audio[#tableParagrafosFinais] = true
				nomesArquivosParagrafos.audio[nTTS] = vetorTTS.audio[i]
				nTTS = nTTS+1
			end
			if vetorTTS.audios[i] then
				for ii=1,#vetorTTS.audios[i] do

					local nomeArquivoAudio = atributos.nome..atributos.pagina.."somTTS "..nTTS.."Vec"..atributos.velocidadeTTS.."."..atributos.extencao
					table.insert(nomesArquivosParagrafos,nomeArquivoAudio)
					table.insert(tableParagrafosFinais,"Pronúncia "..ii..":!")
					tableParagrafosFinais.verbete[#tableParagrafosFinais] = i
					nTTS = nTTS+1

					table.insert(tableParagrafosFinais,"")
					tableParagrafosFinais.verbete[#tableParagrafosFinais] = i
					table.insert(nomesArquivosParagrafos,atributos.pastaArquivos.."/"..vetorTTS.audios[i][ii])
					tableParagrafosFinais.audio[#tableParagrafosFinais] = true
					nTTS = nTTS+1
				end
			end
			if vetorTTS.video[i] and vetorTTS.video[i].conteudo then

				local nomeArquivoAudio = atributos.nome..atributos.pagina.."somTTS "..nTTS.."Vec"..atributos.velocidadeTTS.."."..atributos.extencao
				table.insert(nomesArquivosParagrafos,nomeArquivoAudio)
				table.insert(tableParagrafosFinais,"Vídeo:!")
				tableParagrafosFinais.verbete[#tableParagrafosFinais] = i
				nTTS = nTTS+1
				print(atributos.pastaArquivos,vetorTTS.video,vetorTTS.video[i],vetorTTS.video[i].conteudo)
				table.insert(nomesArquivosParagrafos,atributos.pastaArquivos.."/"..vetorTTS.video[i].conteudo)
				table.insert(tableParagrafosFinais,"")
				tableParagrafosFinais.verbete[#tableParagrafosFinais] = i
				tableParagrafosFinais.video[#tableParagrafosFinais] = true
				nTTS = nTTS+1
			elseif vetorTTS.animacao[i] then
				if paragrafoFinal then
					--table.insert(tableParagrafosFinais,paragrafoFinal)
					--tableParagrafosFinais.verbete[#tableParagrafosFinais] = i
					paragrafoFinal=nil
				end
				table.insert(nomesArquivosParagrafos,vetorTTS.animacao[i].som)
				tableParagrafosFinais.animacao[#tableParagrafosFinais] = vetorTTS.animacao[i]
				nomesArquivosParagrafos.animacao[nTTS] = vetorTTS.animacao[i]
				nTTS = nTTS+1
			elseif vetorTTS.botao[i] then
				if paragrafoFinal then
					--table.insert(tableParagrafosFinais,paragrafoFinal)
					--tableParagrafosFinais.verbete[#tableParagrafosFinais] = i
					paragrafoFinal=nil
				end
				table.insert(nomesArquivosParagrafos,vetorTTS.botao[i])
				tableParagrafosFinais.botao[#tableParagrafosFinais] = vetorTTS.botao[i]
				nomesArquivosParagrafos.botao[nTTS] = vetorTTS.botao[i]
				nTTS = nTTS+1
			end
		end

		if tableParagrafosFinais and tableParagrafosFinais[1] and not string.find(tableParagrafosFinais[1],"%a+") then
			if string.find(atributos.idioma,"en") then
				tableParagrafosFinais[1] = "Empty Page!"
			elseif string.find(atributos.idioma,"br") then
				tableParagrafosFinais[1] = "Página sem áudio!"
			end
		elseif tableParagrafosFinais and not tableParagrafosFinais[1] then
			tableParagrafosFinais[1] = "Nenhuma anotação ou mensagem na página!"
		end
		media.playSound("som gerando audio.MP3")
		atributos.params = {}
		atributos.params.progress = "download"
		atributos.params.response = {
			filename = nomesArquivosParagrafos[1],
			baseDirectory = atributos.diretorioBase
		}
		local frase = tableParagrafosFinais[1]:urlEncode()
		atributos.texto = frase
		arquivosCriados.tableParagrafosFinais = tableParagrafosFinais
		arquivosCriados.nomesArquivosParagrafos = nomesArquivosParagrafos
		M.requisitarTTSOnline(atributos,arquivosCriados)


	end

	-- terceiro, devolver lista de arquivos criados no segundo passo ou encontrados no primeiro passo
	return arquivosCriados
end
local function pegarTTSApartirDeScript(atributos)
	local VetorTTS = {}
	VetorTTS.audio = {}
	VetorTTS.video = {}
	VetorTTS.animacao = {}
	VetorTTS.botao = {}
	VetorTTS.texto = {}
	
	local vetorTodas = {}
	
	local vetorTela = {}
	vetorTela.ordemElementos = {}
	
	
	local imagens = 0
	local textos = 0
	local exercicios = 0
	local videos = 0
	local botoes = 0
	local sons = 0
	local animacoes = 0
	local separadores = 0
	local espacos = 0
	local imagemTextos = 0
	
	local filtrado = string.gsub(atributos.scriptTela,".",{ ["\13"] = "",["\10"] = "\13\10"})
	local is_valid, error_position = validarUTF8.validate(filtrado)
	if not is_valid then 
		filtrado = conversor.converterANSIparaUTFsemBoom(filtrado)
	end
	local um = 1
	local comecou = 0
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
				elseif string.find( line, "imagem" ) ~= nil or string.find( line, "figura" ) ~= nil then
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
				if linhaReduzida then
					vetorTodas[comecou][xx] = line
				end
			end
			xx = xx+1
		end
	end
	if vetorTodas[1] ~= nil and vetorTodas[1][0] ~= nil then
		for i=1,#vetorTodas do
			if string.find( vetorTodas[i][0], "imagem" ) ~= nil then
				padrao = {
					conteudo = "Imagem se descrição",
					atributoALT = "Imagem se descrição"
				}	
				leituraTXT.criarImagensDeArquivoPadraoAux(vetorTodas[i],padrao,atributos,{})
				if vetorTodas[i].atributoALT and vetorTodas[i].atributoALT ~= nil then
					table.insert( VetorTTS, "\n\n" .. vetorTodas[i].atributoALT )
					
					VetorTTS[#VetorTTS] = conversor.converterTextoParaFala(VetorTTS[#VetorTTS],{},"RSS")
					VetorTTS.texto[#VetorTTS] = VetorTTS[#VetorTTS]
				end
				if vetorTodas[i].conteudo and vetorTodas[i].conteudo ~= nil then
					table.insert( VetorTTS, "\n\n" .. vetorTodas[i].conteudo )
					VetorTTS[#VetorTTS] = conversor.converterTextoParaFala(VetorTTS[#VetorTTS],{},"RSS")
					VetorTTS.texto[#VetorTTS] = VetorTTS[#VetorTTS]
				end
			elseif string.find( vetorTodas[i][0], "texto" ) ~= nil then
				padrao = {
					texto = "(Erro no texto)"
				}
				leituraTXT.criarTextosDeArquivoPadraoAux(vetorTodas[i],padrao,atributos,{})
				local aux = string.gsub(vetorTodas[i].texto,"#t=%d+#","")
				aux = string.gsub(aux,"#/t=%d+#","")
				aux = string.gsub(aux,"#l%d+#","")
				aux = string.gsub(aux,"#/l%d+#","")
				aux = string.gsub(aux,"#s#","")
				aux = string.gsub(aux,"#/s#","")
				aux = string.gsub(aux,"#n#","")
				aux = string.gsub(aux,"#/n#","")
				if vetorTodas[i].atributoALT and vetorTodas[i].atributoALT ~= nil then
					table.insert( VetorTTS,"\n\n" .. vetorTodas[i].atributoALT )
				else
					table.insert( VetorTTS,"\n\n" .. aux )
				end
				VetorTTS[#VetorTTS] = conversor.converterTextoParaFala(VetorTTS[#VetorTTS],{},"RSS")
				VetorTTS.texto[#VetorTTS] = VetorTTS[#VetorTTS]
			elseif string.find( vetorTodas[i][0], "som" ) ~= nil then
				padrao = {
					conteudo = ""
				}
				leituraTXT.criarSonsDeArquivoPadraoAux(vetorTodas[i],padrao,atributos,{})
				if vetorTodas[i].atributoALT then
					if string.len(vetorTodas[i].atributoALT) > 2 then
						table.insert( VetorTTS,"\n\n Detalhes do áudio:. "..vetorTodas[i].atributoALT)
					end
				end
				table.insert( VetorTTS,"\n\n".."Executando ô áudiô")
				VetorTTS.texto[#VetorTTS] = VetorTTS[#VetorTTS]
				VetorTTS.audio[#VetorTTS] = vetorTodas[i].arquivo
			elseif string.find( vetorTodas[i][0], "video" ) ~= nil then
				padrao = {
					conteudo = ""
				}
				leituraTXT.criarVideosDeArquivoPadraoAux(vetorTodas[i],padrao,atributos,{})
				
				if vetorTodas[i].atributoALT then
					if string.len(vetorTodas[i].atributoALT) > 2 then
						local aux2 = vetorTodas[i].atributoALT
						aux2 = conversor.converterTextoParaFala(aux2,{},"RSS")
						table.insert( VetorTTS,"\n\n Detalhes do vídeo:.".. aux2)
					end
				end
				table.insert( VetorTTS,"\n\n".."Executando o vídeo")
				VetorTTS.video[#VetorTTS] = vetorTodas[i].arquivo
				VetorTTS.texto[#VetorTTS] = VetorTTS[#VetorTTS]
			elseif string.find( vetorTodas[i][0], "animacao" ) ~= nil then
				padrao = {
					conteudo = ""
				}
				leituraTXT.criarAnimacoesDeArquivoPadraoAux(vetorTodas[i],padrao,atributos,{})
				if vetorTodas[i].atributoALT then
					if string.len(vetorTodas[i].atributoALT) > 2 then
						local aux = vetorTodas[i].atributoALT
						aux = conversor.converterTextoParaFala(VetorTTS[#VetorTTS],{},"RSS")
						table.insert( VetorTTS,"\n\n Detalhes da animação:." .. aux )
					end
				end
				if vetorTodas[i].som and vetorTodas[i].som ~= "som vazio.WAV" then
					table.insert( VetorTTS,"\n\n".."Executando a animação com som")
					local vetor = {pasta = vetorTodas[i].pasta,imagens = vetorTodas[i].imagens,tempoPorImagem = vetorTodas[i].tempoPorImagem,numeroImagens = vetorTodas[i].numeroImagens,som = vetorTodas[i].som,atributoALT = vetorTodas[i].atributoALT,automatico = vetorTodas[i].automatico,loop = vetorTodas[i].loop,posicao = vetorTodas[i].posicao,avancar = vetorTodas[i].avancar,limitador = vetorTodas[i].limitador, x = vetorTodas[i].x,y = vetorTodas[i].y, index = i}
					VetorTTS.animacao[#VetorTTS] = vetor
					VetorTTS.texto[#VetorTTS] = VetorTTS[#VetorTTS]
				end
			elseif string.find( vetorTodas[i][0], "botao" ) ~= nil then
				padrao = {
					texto = ""
				}
				leituraTXT.criarBotoesDeArquivoPadraoAux(vetorTodas[i],padrao,atributos,{})
				local aux = ""
				if vetorTodas[i].titulo and vetorTodas[i].titulo.texto then
					for k=1,#vetorTodas[i].titulo.texto do
						aux = aux .. ", " .. vetorTodas[i].titulo.texto[k]
						aux = conversor.converterTextoParaFala(VetorTTS[#VetorTTS],{},"RSS")
					end
					if #vetorTodas[i].titulo.texto == 1 and string.find(vetorTodas[i].acao[1],"irPara") then
						table.insert( VetorTTS,"\n\nBotão. " .. aux.. "leva para  a página ".. vetorTodas[i].numero )
						VetorTTS.texto[#VetorTTS] = VetorTTS[#VetorTTS]
					else
						table.insert( VetorTTS,"\n\nBotões. " .. aux )
						VetorTTS.texto[#VetorTTS] = VetorTTS[#VetorTTS]
					end
				end
				if type(vetorTodas[i].acao) == "table" then
					for b=1,#vetorTodas[i].acao do
						if vetorTodas[i].acao[b] == "som" and vetorTodas[i].som then
							table.insert( VetorTTS,"\n\n".."Executando ô áudiô:")
							VetorTTS.audio[#VetorTTS] = vetorTodas[i].som
							VetorTTS.texto[#VetorTTS] = VetorTTS[#VetorTTS]
						elseif vetorTodas[i].acao[b] == "video" and vetorTodas[i].video then
							table.insert( VetorTTS,"\n\n".."Executando o vídeo:")
							VetorTTS.video[#VetorTTS] = vetorTodas[i].video
							VetorTTS.texto[#VetorTTS] = VetorTTS[#VetorTTS]
						elseif vetorTodas[i].acao[b] == "texto" and vetorTodas[i].texto then
							table.insert( VetorTTS,"\n\n".."Conteúdo do texto:. " .. vetorTodas[i].texto)
							VetorTTS.texto[#VetorTTS] = VetorTTS[#VetorTTS]
						end
					end
				end
			elseif string.find( vetorTodas[i][0], "exercicio" ) ~= nil then
				local padrao = {
					enunciado = "Assinale a alternatica correta:.",
					alternativas = {"opção 1","opção 2"}
				}
				leituraTXT.criarExerciciosDeArquivoPadraoAux(vetorTodas[i],padrao,atributos,{})
				
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
					aux = conversor.converterTextoParaFala(aux,{},"RSS")
					aux2 = conversor.converterTextoParaFala(aux2,{},"RSS")
				end
				if vetorTodas[i].atributoALT and vetorTodas[i].atributoALT ~= nil then
					table.insert( VetorTTS,"\n\n" .. vetorTodas[i].atributoALT )
					VetorTTS.texto[#VetorTTS] = VetorTTS[#VetorTTS]
				else
					local questao = "Questão: "..vetorTodas[i].numero
					questao = conversor.converterTextoParaFala("Questaum:"..vetorTodas[i].numero,{},"RSS")
					table.insert( VetorTTS,"\n\n "..questao.. vetorTodas[i].numero.. ".. " .. aux .. ". Alternativas: " .. aux2 )
					VetorTTS.texto[#VetorTTS] = VetorTTS[#VetorTTS]
				end
			end
		end
	end
	
	return VetorTTS
end

function M.pegarTextosTTSDasPaginasDicionario(vetorPalavrasTxTs)
	--print("vetorPalavrasTxTs = ",vetorPalavrasTxTs,#vetorPalavrasTxTs)
	--local vetorTextos = {}
	--local vetorErros = {}
	local vetorDeVetoresTTS = {}
	vetorDeVetoresTTS.audio={}
	vetorDeVetoresTTS.video={}
	vetorDeVetoresTTS.animacao={}
	vetorDeVetoresTTS.botao={}
	
	for i=1,#vetorPalavrasTxTs do
		local scriptTela = auxFuncs.lerArquivoTXTCaminho({caminho = system.pathForFile("Dicionario Palavras/"..vetorPalavrasTxTs[i][2]),tipo = "texto"})
		local VetorTTS = pegarTTSApartirDeScript({scriptTela = scriptTela,pasta = "Dicionario Palavras"})
		VetorTTS[1] =  "Verbete: "..vetorPalavrasTxTs[i][1].."\n\n "
		for k=1,#VetorTTS do
			vetorDeVetoresTTS[#vetorDeVetoresTTS+1] = {}
			vetorDeVetoresTTS[#vetorDeVetoresTTS].texto = auxFuncs.filtrarCodigos(VetorTTS[k])
			vetorDeVetoresTTS[#vetorDeVetoresTTS].texto = auxFuncs.filtrarCodigos(vetorDeVetoresTTS[#vetorDeVetoresTTS].texto)
			vetorDeVetoresTTS.audio[#vetorDeVetoresTTS] = VetorTTS.audio[k]
			vetorDeVetoresTTS.video[#vetorDeVetoresTTS] = VetorTTS.video[k]
			vetorDeVetoresTTS.animacao[#vetorDeVetoresTTS] = VetorTTS.animacao[k]
			vetorDeVetoresTTS.botao[#vetorDeVetoresTTS] = VetorTTS.botao[k]
		end
	end
	
	--[[
	for i=1,#vetorPalavrasTxTs do
		vetorTextos[i] = {}
		print("Palavra Dic:",vetorPalavrasTxTs[i][1],vetorPalavrasTxTs[i][2],vetorPalavrasTxTs[i][3])
		local vetorDicPalavra = leituraTXT.criarDicionarioDeArquivoPadrao({pasta = "Dicionario Palavras",arquivo = vetorPalavrasTxTs[i][2]},vetorErros)
		local textoFinal = "Verbete: "..vetorPalavrasTxTs[i][1].."\n\n "
		
		if vetorDicPalavra.traducao then
			textoFinal = textoFinal.. "Tradução: "..vetorDicPalavra.traducao.."\n\n "
		end
		if vetorDicPalavra.categoriaG then
			textoFinal = textoFinal.. "\n ! \n "..vetorDicPalavra.categoriaG.."\n\n "
		end
		if vetorDicPalavra.significado then
			textoFinal = textoFinal.. "Significado: "..vetorDicPalavra.significado.."\n\n "
		end
		if vetorDicPalavra.atributoALTimagens then
			for ii=1,#vetorDicPalavra.atributoALTimagens do
				if #vetorDicPalavra.atributoALTimagens == 1 then
					textoFinal = textoFinal.. "Detalhes da Imagem:! "..vetorDicPalavra.atributoALTimagens[ii].."\n\n "
				else
					textoFinal = textoFinal.. "Detalhes da Imagem: "..ii..":!"..vetorDicPalavra.atributoALTimagens[ii].."\n\n "
				end
			end
		end
		if vetorDicPalavra.referenciasContextuais then
			textoFinal = textoFinal.. "Referências de Livros e obras: \n"
			for ii=1,#vetorDicPalavra.referenciasContextuais do
				textoFinal = textoFinal..vetorDicPalavra.referenciasContextuais[ii].."\n\n "
			end
		end
		if vetorDicPalavra.plural then
			textoFinal = textoFinal.. "Plural: "..vetorDicPalavra.plural.."\n\n "
		end
		if vetorDicPalavra.contextos then
			for ii=1,#vetorDicPalavra.contextos do
				if #vetorDicPalavra.contextos == 1 then
					textoFinal = textoFinal.. "Exemplo de Contexto:! "..vetorDicPalavra.contextos[ii].."\n\n "
				else
					textoFinal = textoFinal.. "Contexto: "..ii..":!"..vetorDicPalavra.contextos[ii].."\n\n "
				end
			end
		elseif vetorDicPalavra.contexto then
			textoFinal = textoFinal.. "Exemplo de contexto:! "..vetorDicPalavra.contexto.."\n\n "
		end
		--atributoALTpronuncia
		vetorTextos[i].texto = textoFinal
		if vetorDicPalavra.foneticasEpronuncias then
			vetorTextos[i].audios = {}
			for fnp=1,#vetorDicPalavra.foneticasEpronuncias do
				if vetorDicPalavra.foneticasEpronuncias[fnp][2] then
					table.insert(vetorTextos[i].audios,vetorDicPalavra.foneticasEpronuncias[fnp][2])
				end
			end
		end
		if vetorDicPalavra.video then
			if vetorDicPalavra.atributoALTvideo then
				--textoFinal = textoFinal.. "Detalhes do Video:! "..vetorDicPalavra.atributoALTvideo.."\n\n "
			end
			vetorTextos[i].video = vetorDicPalavra.video
		end

	end
	]]
	return vetorDeVetoresTTS--vetorTextos
end
function M.BotoesTTSAuxFuncs(event,atrib,tipo,vetorBotoes,arquivosCriados,Var)
	if tipo == "play" then				-- EXECUTAR --
		vetorBotoes.botaoplayTTS.isVisible = false
		vetorBotoes.botaoPause.isVisible = true
		if vetorBotoes.video then
			vetorBotoes.video:play()
		elseif vetorBotoes.animacao then
			auxFuncs.pausarDespausarAnimacaoTTS(vetorBotoes.animacao,"despausar")
		else
			audio.resume()
		end
	elseif tipo == "pause" then			-- PAUSAR --
		vetorBotoes.botaoplayTTS.isVisible = true
		vetorBotoes.botaoPause.isVisible = false
		if vetorBotoes.video then
			vetorBotoes.video:pause()
		elseif vetorBotoes.animacao then
			auxFuncs.pausarDespausarAnimacaoTTS(vetorBotoes.animacao,"pausar")
		else
			audio.pause()
		end
	elseif tipo == "parar" then			-- PARAR --
		audio.stop()
		media.stopSound()
		vetorBotoes:clearTTSelements(vetorBotoes)
		auxFuncs.pausarDespausarAnimacao(Var,"parar")
		vetorBotoes:removerGrupo()
		return true
	elseif tipo == "avancar" then		-- AVANÇAR --
		audio.stop()
		media.stopSound()
		auxFuncs.pausarDespausarAnimacao(Var,"parar")
		if arquivosCriados.verbete then
			local verbeteAtual = arquivosCriados.verbete[vetorBotoes.contSons]
			print(verbeteAtual)
			while ( arquivosCriados.verbete[vetorBotoes.contSons] and verbeteAtual == arquivosCriados.verbete[vetorBotoes.contSons])  do
				print("vetorBotoes.contSons",vetorBotoes.contSons,arquivosCriados.verbete[vetorBotoes.contSons])
				vetorBotoes.contSons = vetorBotoes.contSons + 1
			end
		else
			vetorBotoes.contSons = vetorBotoes.contSons + 1
		end
		vetorBotoes:clearTTSelements(vetorBotoes)
		M.rodarAudiosTTS(atrib,vetorBotoes,arquivosCriados,Var)
	elseif tipo == "voltar" then		-- RETROCEDER --
		audio.stop()
		media.stopSound()
		auxFuncs.pausarDespausarAnimacao(Var,"parar")
		if arquivosCriados.verbete then
			local verbeteAtual = arquivosCriados.verbete[vetorBotoes.contSons]

			while ( vetorBotoes.contSons > 0 and tonumber(verbeteAtual) > tonumber(arquivosCriados.verbete[vetorBotoes.contSons]-1) and tonumber(arquivosCriados.verbete[vetorBotoes.contSons]) > tonumber(verbeteAtual)-2 ) do
				vetorBotoes.contSons = vetorBotoes.contSons - 1
			end
			vetorBotoes.contSons = vetorBotoes.contSons + 1
		else
			vetorBotoes.contSons = vetorBotoes.contSons - 1
		end
		vetorBotoes:clearTTSelements(vetorBotoes)
		M.rodarAudiosTTS(atrib,vetorBotoes,arquivosCriados,Var)
	end
	return true
end
function M.criarBotoesTTS(Var,atrib,arquivosCriados)
	local vetorBotoes =  display.newGroup()
	vetorBotoes.grupoTTS = display.newGroup()
	function vetorBotoes:incluirNoGrupoTTS(objeto)
		self.grupoTTS:insert(objeto)
	end
	function vetorBotoes:clearTTSelements(vetorBotoes)
		if vetorBotoes.video and vetorBotoes.video.videoTTS then
			vetorBotoes.video.videoTTS:removeSelf()
			vetorBotoes.video.videoTTS = nil
		end
		if vetorBotoes.video then
			print(vetorBotoes.video)
			if vetorBotoes.video.totalTime then
				vetorBotoes.video:removeSelf()
			end
			vetorBotoes.video = nil
		end
		if vetorBotoes.animacao then
			if vetorBotoes.animacao.timer then
				for i=1,#vetorBotoes.animacao.timer do
					timer.cancel(vetorBotoes.animacao.timer[i])
					vetorBotoes.animacao.timer[i] = nil
				end
			end
			if vetorBotoes.animacao.timer2 then
				timer.cancel(vetorBotoes.animacao.timer2)
				vetorBotoes.animacao.timer2 = nil
			end
			if vetorBotoes.animacao.som then
				audio.stop(vetorBotoes.animacao.som)
				vetorBotoes.animacao.som = nil
			end
		end
		if vetorBotoes.animacao then
			vetorBotoes.animacao:removeSelf()
			vetorBotoes.animacao = nil
		end
	end
	function vetorBotoes:removerGrupo()
		vetorBotoes:clearTTSelements(vetorBotoes)
		auxFuncs.pausarDespausarAnimacaoTTS(Var,"despausar")
		vetorBotoes:removeSelf()
		vetorBotoes = nil
	end

	local altura = 100
	local largura = 100
	local arquivoUp = "tts Play.png"
	local arquivoDown = "tts PlayD.png"
	local arquivoUpParar = "tts parar.png"
	local arquivoDownParar = "tts parar down.png"
	local arquivoUpPause = "tts pause.png"
	local arquivoDownPause = "tts pause down.png"
	local arquivoUpForward = "tts forwardUp.png"
	local arquivoDownForward = "tts forwardDown.png"
	local arquivoUpBackward = "tts backwardUp.png"
	local arquivoDownBackward = "tts backwardDown.png"
	vetorBotoes.contSons = atrib.controladorSons or 1
	-- começar os áudios --
	local telaProtetiva = auxFuncs.TelaProtetiva()
	vetorBotoes:insert(telaProtetiva)

	vetorBotoes.botaoParar = widget.newButton(
    {
        height = altura,
        width = largura,
        defaultFile = arquivoUpParar,
		overFile = arquivoDownParar,
		onRelease = function(event)
						M.BotoesTTSAuxFuncs(event,atrib,"parar",vetorBotoes,arquivosCriados,Var)
					end,
		x = 0,
		y = 0
	})
	vetorBotoes.botaoParar:addEventListener("tap",function() return true; end)
	vetorBotoes.botaoParar.selecionado = false
	vetorBotoes.botaoParar.anchorX = 0
	vetorBotoes.botaoParar.anchorY = 0


	vetorBotoes:insert(vetorBotoes.botaoParar)

	vetorBotoes.botaoplayTTS = widget.newButton(
    {
        height = altura,
        width = largura,
        defaultFile = arquivoUp,
		overFile = arquivoDown,
        onRelease = function(event)
						M.BotoesTTSAuxFuncs(event,atrib,"play",vetorBotoes,arquivosCriados,Var)
					end,
		x = W,
		y = 0

    })
	vetorBotoes.botaoplayTTS.selecionado = false
	vetorBotoes.botaoplayTTS.tipo = "play"
	vetorBotoes.botaoplayTTS:addEventListener("tap",function() return true; end)

	vetorBotoes.botaoplayTTS.anchorX = 1
	vetorBotoes.botaoplayTTS.isVisible = false
	vetorBotoes.botaoplayTTS.anchorY = 0
	vetorBotoes:insert(vetorBotoes.botaoplayTTS)

	vetorBotoes.botaoPause = widget.newButton(
    {
        height = altura,
        width = largura,
        defaultFile = arquivoUpPause,
		overFile = arquivoDownPause,
        onRelease = function(event)
						M.BotoesTTSAuxFuncs(event,atrib,"pause",vetorBotoes,arquivosCriados,Var)
					end,
		x = W,
		y = 0

    })
	--botaoPause.xScale = -1
	vetorBotoes.botaoPause:addEventListener("tap",function() return true; end)
	vetorBotoes.botaoPause.tipo = "pause"
	vetorBotoes.botaoPause.anchorX = 1--botaoPause.anchorX = 0
	vetorBotoes.botaoPause.isVisible = true
	vetorBotoes.botaoPause.anchorY = 0
	vetorBotoes:insert(vetorBotoes.botaoPause)

	vetorBotoes.botaoForward = widget.newButton(
    {
        height = altura,
        width = largura,
        defaultFile = arquivoUpForward,
		overFile = arquivoDownForward,
        onRelease = function(event)
						M.BotoesTTSAuxFuncs(event,atrib,"avancar",vetorBotoes,arquivosCriados,Var)
					end,
		x = W,
		y = H

    })
	vetorBotoes.botaoForward.selecionado = false
	vetorBotoes.botaoForward.anchorX = 1
	vetorBotoes.botaoForward.anchorY = 1
	vetorBotoes:insert(vetorBotoes.botaoForward)
	vetorBotoes.botaoForward:addEventListener("tap",function() return true; end)

	vetorBotoes.botaoBackward = widget.newButton(
    {
        height = altura,
        width = largura,
        defaultFile = arquivoUpBackward,
		overFile = arquivoDownBackward,
        onRelease = function(event)
						M.BotoesTTSAuxFuncs(event,atrib,"voltar",vetorBotoes,arquivosCriados,Var)
					end,
		x = 0,
		y = H

    })
	vetorBotoes.botaoBackward.selecionado = false
	vetorBotoes.botaoBackward.anchorX = 0
	vetorBotoes.botaoBackward.anchorY = 1
	vetorBotoes.botaoBackward:addEventListener("tap",function() return true; end)
	vetorBotoes:insert(vetorBotoes.botaoBackward)

	auxFuncs.pausarDespausarAnimacao(Var,"pausar")
	M.rodarAudiosTTS(atrib,vetorBotoes,arquivosCriados,Var)

	return vetorBotoes
end
function M.criarBotaoTTSDicionario(atrib,Var)
	local grupo = display.newGroup()


	system.setTapDelay( 1 )
	local function despausarTudo()
		--if botaoPause.isVisible == true then
		--	audio.resume()
		--	media.playSound()
		--end
		auxFuncs.pausarDespausarAnimacao(Var,"despausar")
	end
	function grupo.executarTTSPalavras(event)
		if event.phase == "began" then
			event.target.selecionado1 = true
			media.pauseSound()
			audio.pause()
			auxFuncs.pausarDespausarAnimacao(Var,"pausar")
			local som = audio.loadSound(atrib.somBotao1)
			audio.play(som,{onComplete = despausarTudo})
			--funcGlobal.escreverNoHistorico(varGlobal.HistoricoTTSClicar1);
			timer.performWithDelay(1000,function() event.target.selecionado1 = false end,1)
		elseif event.phase == "moved" then
			--system.vibrate()
			audio.stop()
			local som = audio.loadSound(atrib.somBotao1)
			audio.play(som)
		elseif event.phase == "ended" and event.target and event.target.selecionado2 == false  then
			event.target.selecionado2 = true
			audio.stop()
			local som = audio.loadSound(atrib.somBotao1)
			audio.play(som)
			timer.performWithDelay(1000,function() event.target.selecionado2 = false end,1)
			if Var.mensagemTemp and Var.mensagemTemp.remover then
				Var.mensagemTemp.remover()
			end
			Var.mensagemTemp = auxFuncs.criarMensagemTemporaria(Var.linguagem_MensagemTemp,event.x,event.y,400,200,2000)
		elseif event.phase == "ended" and event.target.selecionado1 == true and event.target.selecionado2 == true  then
			--event.target.isVisible = false
			-- HISTÓRICO
			
			local subPagina = atrib.subPagina
			historicoLib.Criar_e_salvar_vetor_historico({
				tipoInteracao = "TTS",
				pagina_livro = atrib.pagina,
				objeto_id = nil,
				acao = "executar",
				subtipo = "dicionário",
				subPagina = subPagina,
				velocidade_tts = atrib.velocidade,
				tela = atrib.tela
			})
			
			auxFuncs.pausarDespausarAnimacao(Var,"parar")
			auxFuncs.clearNativeScreenElements(Var)
			-- Pegar a lista de arquivos de áudio
			local vetorTextos = M.pegarTextosTTSDasPaginasDicionario(grupo.vetorPalavrasTxTs)
			media.stopSound()
			audio.stop()
			local nomeArquivos = "Dicionario"
			local grupoAguarde = auxFuncs.TelaAguardeGerarAudio()
			
			
			local arquivosCriados = M.criarAudiosTTS({
				nome = nomeArquivos,
				vetor = vetorTextos,
				pagina = atrib.pagina,
				tapResponse = atrib.tapResponse,
				tipoTTS = atrib.tipo,--"RSS"
				velocidadeTTS = atrib.velocidade,
				extencao = atrib.extencao,
				idioma = atrib.idioma, -- "pt-br"
				APIkey = atrib.APIkey,
				qualidade = atrib.qualidade, -- "12khz_16bit_mono"
				voz = atrib.voz,
				neural = atrib.neural,
				audioSemNet = atrib.audioSemNet,
				diretorioBase = atrib.diretorioBase,
				pasta = atrib.pasta,
				pastaArquivos = atrib.pastaArquivos,
				funcionalidade = ""--atrib.funcionalidade
			},grupoAguarde)
			arquivosCriados.timerDeEsperaPorLista = timer.performWithDelay(100,
				function()
					if grupoAguarde and grupoAguarde.offline then
						if grupoAguarde then
							grupoAguarde:removeSelf()
							grupoAguarde = nil
						end
					end
					if arquivosCriados.temAudio then 
						if arquivosCriados.temAudio == "sim" then
							if grupoAguarde then
								grupoAguarde.texto.text = "baixando audios"
							end
						elseif arquivosCriados.temAudio == "não" then
							if grupoAguarde then
								grupoAguarde.texto.text = "não tem audio"
								timer.performWithDelay(2000,function() grupoAguarde:removeSelf();grupoAguarde=nil end,1)
							end
						end
					end
					if arquivosCriados.baixarAudio then
						if arquivosCriados.baixarAudio == "ended" then
							if grupoAguarde then
								grupoAguarde.texto.text = "terminando de baixar audios"
							end
						else
							if grupoAguarde then
								grupoAguarde.texto.text = arquivosCriados.baixarAudio
							end
						end
					end
					if arquivosCriados.listaAtualizada then
					-- Após pegar a lista de arquivos de áudio, mandar tocar os áudios
						if grupoAguarde then
							grupoAguarde:removeSelf()
							grupoAguarde = nil
						end
						timer.cancel(arquivosCriados.timerDeEsperaPorLista)
						arquivosCriados.timerDeEsperaPorLista = nil

						for i=1,#arquivosCriados.lista do
							--print("Arquivo "..i,arquivosCriados.lista[i])
							--print("verbete "..i,arquivosCriados.verbete[i])
							--print("audio "..i,arquivosCriados.audio[i])
							--print("video "..i,arquivosCriados.video[i])

						end
						-- Aqui pode rodar os audios encontrados

						--arquivosCriados.tableParagrafosFinais
							-- .verbete
							-- .video
							-- .audio
						-- primeiro criar Interface de controle
						local grupoBotoes = M.criarBotoesTTS(Var,atrib,arquivosCriados)
						--local imagemPlaying = display.newImage("TTS Dic playing.png")
						local imagemPlaying = M.colocarAnimacao({imagens = {"TTS Dic 1.png","TTS Dic 2.png","TTS Dic 2.png","TTS Dic 3.png","TTS Dic 3.png"},loop = "sim",automatico = "sim",comprimento = 300,altura = 300,x = 0,y = -150,tempoPorImagem = 200,tirarBotao = true})
						imagemPlaying.x = W/2;imagemPlaying.y = H/2
						grupoBotoes:insert(imagemPlaying)
					end
				end,
			-1)
		end
		return true
	end

	grupo.botaoTTS = widget.newButton{
		
		defaultFile = "ttsDic2.png",
		overFile = "ttsDic2D.png",
		onEvent = grupo.executarTTSPalavras
	}
	grupo.botaoTTS.selecionado1 = false
	grupo.botaoTTS.selecionado2 = false
	grupo.botaoTTS.anchorX=1;grupo.botaoTTS.anchorY=0
	grupo.botaoTTS.x=W;
	grupo.botaoTTS.y=0--100
	grupo.botaoTTS.width = grupo.botaoTTS.width--*.7
	grupo.botaoTTS.height = grupo.botaoTTS.height--*.7

	return grupo
end
-- TTS RODAPE --

local function pegarTextosTTSDasPaginasDoRodape(vetor)
	--vetor[i].scriptTela
	--vetor[i].pasta
	--vetor[i].arquivo
	print("Pegando TTS")
	local vetorDeVetoresTTS = {}
	vetorDeVetoresTTS.audio={}
	vetorDeVetoresTTS.video={}
	vetorDeVetoresTTS.animacao={}
	vetorDeVetoresTTS.botao={}
	for	i=1,#vetor do
		local VetorTTS = pegarTTSApartirDeScript({scriptTela = vetor[i].scriptTela,pasta = vetor[i].pasta})
		local textopalavras = auxFuncs.filtrarCodigos(vetor[i].palavras)
		VetorTTS[1] =  "Rodapé de: " ..textopalavras.. ", número: "..vetor[i].numero.."!\n"..VetorTTS[1]
		for k=1,#VetorTTS do
			vetorDeVetoresTTS[#vetorDeVetoresTTS+1] = {}
			vetorDeVetoresTTS[#vetorDeVetoresTTS].texto = VetorTTS[k]
			vetorDeVetoresTTS[#vetorDeVetoresTTS].texto =vetorDeVetoresTTS[#vetorDeVetoresTTS].texto
			vetorDeVetoresTTS.audio[#vetorDeVetoresTTS] = VetorTTS.audio[k]
			vetorDeVetoresTTS.video[#vetorDeVetoresTTS] = VetorTTS.video[k]
			vetorDeVetoresTTS.animacao[#vetorDeVetoresTTS] = VetorTTS.animacao[k]
			vetorDeVetoresTTS.botao[#vetorDeVetoresTTS] = VetorTTS.botao[k]
			
		end
		--table.insert(vetorDeVetoresTTS,vetorTTS)
	end
	return vetorDeVetoresTTS
end
function M.criarBotaoTTSRodape(atrib,Var)
	local grupo = display.newGroup()


	system.setTapDelay( 1 )
	local function despausarTudo()
		--if botaoPause.isVisible == true then
		--	audio.resume()
		--	media.playSound()
		--end
		auxFuncs.pausarDespausarAnimacao(Var,"despausar")
	end
	function grupo.executarTTSRodape(event)
		if event.phase == "began" then
			event.target.selecionado1 = true
			media.pauseSound()
			audio.pause()
			auxFuncs.pausarDespausarAnimacao(Var,"pausar")
			local som = audio.loadSound(atrib.somBotao1)
			audio.play(som,{onComplete = despausarTudo})
			--funcGlobal.escreverNoHistorico(varGlobal.HistoricoTTSClicar1);
			timer.performWithDelay(1000,function() event.target.selecionado1 = false end,1)
		elseif event.phase == "moved" then
			--system.vibrate()
			audio.stop()
			local som = audio.loadSound(atrib.somBotao1)
			audio.play(som)
		elseif event.phase == "ended" and event.target and event.target.selecionado2 == false  then
			event.target.selecionado2 = true
			audio.stop()
			local som = audio.loadSound(atrib.somBotao1)
			audio.play(som)
			timer.performWithDelay(1000,function() event.target.selecionado2 = false end,1)
		elseif event.phase == "ended" and event.target.selecionado1 == true and event.target.selecionado2 == true  then
			--event.target.isVisible = false
			-- HISTÓRICO
			
			local subPagina = atrib.subPagina
			if atrib.temHistorico and atrib.temLogin then
				historicoLib.Criar_e_salvar_vetor_historico({
					tipoInteracao = "TTS",
					pagina_livro = atrib.pagina,
					objeto_id = nil,
					acao = "executar",
					subtipo = "rodape",
					subPagina = subPagina,
					velocidade_tts = atrib.velocidade,
					tela = atrib.tela
				})
			end
			auxFuncs.pausarDespausarAnimacao(Var,"parar")
			auxFuncs.clearNativeScreenElements(Var)
			-- Pegar a lista de Textos para montagem dos áudios
			
			local vetorTextos = pegarTextosTTSDasPaginasDoRodape(atrib.vetor)
			media.stopSound()
			audio.stop()
			local nomeArquivos = "Rodape"
			local grupoAguarde = auxFuncs.TelaAguardeGerarAudio()
			-- pegar lista de arquivos de áudio
			local arquivosCriados = M.criarAudiosTTS({
				nome = nomeArquivos,
				vetor = vetorTextos,
				pagina = atrib.pagina,
				tapResponse = atrib.tapResponse,
				tapPaginaResponse = atrib.tapPaginaResponse,
				tipoTTS = atrib.tipo,--"RSS"
				velocidadeTTS = atrib.velocidade,
				extencao = atrib.extencao,
				idioma = atrib.idioma, -- "pt-br"
				APIkey = atrib.APIkey,
				qualidade = atrib.qualidade, -- "12khz_16bit_mono"
				voz = atrib.voz,
				neural = atrib.neural,
				audioSemNet = atrib.audioSemNet,
				diretorioBase = atrib.diretorioBase,
				pasta = atrib.pasta,
				pastaArquivos = atrib.pastaArquivos,
				funcionalidade = atrib.funcionalidade
			},grupoAguarde)
			-- esperar a lista de arquivos ser criada
			arquivosCriados.timerDeEsperaPorLista = timer.performWithDelay(100,
				function()
					if grupoAguarde.offline then
						if grupoAguarde then
							grupoAguarde:removeSelf()
							grupoAguarde = nil
						end
					end
					if arquivosCriados.temAudio then 
						if arquivosCriados.temAudio == "sim" then
							if grupoAguarde then
								grupoAguarde.texto.text = "baixando audios"
							end
						elseif arquivosCriados.temAudio == "não" then
							if grupoAguarde then
								grupoAguarde.texto.text = "não tem audio"
								timer.performWithDelay(2000,function() grupoAguarde:removeSelf();grupoAguarde=nil end,1)
							end
						end
					end
					if arquivosCriados.baixarAudio then
						if arquivosCriados.baixarAudio == "ended" then
							if grupoAguarde then
								grupoAguarde.texto.text = "terminando de baixar audios"
							end
						else
							if grupoAguarde then
								grupoAguarde.texto.text = arquivosCriados.baixarAudio
							end
						end
					end
					if arquivosCriados.listaAtualizada then
					-- Após pegar a lista de arquivos de áudio, mandar tocar os áudios
						if grupoAguarde then
							grupoAguarde:removeSelf()
							grupoAguarde = nil
						end
						timer.cancel(arquivosCriados.timerDeEsperaPorLista)
						arquivosCriados.timerDeEsperaPorLista = nil

						for i=1,#arquivosCriados.lista do
							--print("Arquivo "..i,arquivosCriados.lista[i])
							--print("verbete "..i,arquivosCriados.verbete[i])
							--print("audio "..i,arquivosCriados.audio[i])
							--print("video "..i,arquivosCriados.video[i])

						end
						-- Aqui pode rodar os audios encontrados

						--arquivosCriados.tableParagrafosFinais
							-- .verbete
							-- .video
							-- .audio
						-- primeiro criar Interface de controle
						local grupoBotoes = M.criarBotoesTTS(Var,atrib,arquivosCriados)
						--local imagemPlaying = display.newImage("TTS Dic playing.png")
						local imagemPlaying = M.colocarAnimacao({imagens = {"TTS rodape 1.png","TTS rodape 2.png","TTS rodape 2.png","TTS rodape 3.png","TTS rodape 3.png"},loop = "sim",automatico = "sim",comprimento = 300,altura = 300,x = 0,y = -150,tempoPorImagem = 200,tirarBotao = true})
						imagemPlaying.x = W/2;imagemPlaying.y = H/2
						grupoBotoes:insert(imagemPlaying)
					end
				end,
			-1)
		end
		return true
	end

	grupo.botaoTTS = widget.newButton{
		
		defaultFile = "ttsRodape.png",
		overFile = "ttsRodapeD.png",
		onEvent = grupo.executarTTSRodape
	}
	grupo.botaoTTS.selecionado1 = false
	grupo.botaoTTS.selecionado2 = false
	grupo.botaoTTS.anchorX=1;grupo.botaoTTS.anchorY=0
	grupo.botaoTTS.x=W;
	grupo.botaoTTS.y=0--100
	grupo.botaoTTS.width = grupo.botaoTTS.width--*.7
	grupo.botaoTTS.height = grupo.botaoTTS.height--*.7
	grupo:insert(grupo.botaoTTS)
	return grupo
end

-- TTS COMENTARIOS --
local function organizarTextosTTSDosComentarios(vAnot,vMens)
	local vetorFinal = {}
	table.insert(vetorFinal,{texto=vAnot})
	if #vMens == 0 or (#vMens == 1 and vMens[1] and vMens[1].conteudo and vMens[1].conteudo == "Não existem mensagens a se exibir nesta página.")  then
		table.insert(vetorFinal,{texto="Mensagens:\n Nenhuma mensagem nessa página."})
	else
		table.insert(vetorFinal,{texto="Mensagens:\n"})
	
		for i=1,#vMens do
			table.insert(vetorFinal,{texto="Mensagem "..i..":"..vMens[i].conteudo})
			if vMens[i].filhos and #vMens[i].filhos > 0 then
				if #vMens[i].filhos == 1 then
					table.insert(vetorFinal,{texto="Esta mensagem tem "..#vMens[i].filhos.." resposta."})
				else
					table.insert(vetorFinal,{texto="Esta mensagem tem "..#vMens[i].filhos.." respostas."})
				end
				for j=1,#vMens[i].filhos do
					table.insert(vetorFinal,{texto="Resposta "..j..":"..vMens[i].filhos[j].conteudo})
				end
			else
				--table.insert(vetorFinal,{texto="Esta mensagem não tem respostas."})
			end
		end
		table.insert(vetorFinal,{texto="fim das mensagens"})
	end
	for i=1,#vetorFinal do
		print("VETRO FINAL = ",vetorFinal[i].texto)
	end
	return vetorFinal
end
function M.criarBotaoTTSComentario(atrib,Var)
	local grupo = display.newGroup()


	system.setTapDelay( 1 )
	local function despausarTudo()
		--if botaoPause.isVisible == true then
		--	audio.resume()
		--	media.playSound()
		--end
		auxFuncs.pausarDespausarAnimacao(Var,"despausar")
	end
	function grupo.executarTTSComentarios(event)
		if event.phase == "began" then
			event.target.selecionado1 = true
			media.pauseSound()
			audio.pause()
			auxFuncs.pausarDespausarAnimacao(Var,"pausar")
			local som = audio.loadSound(atrib.somBotao1)
			audio.play(som,{onComplete = despausarTudo})
			--funcGlobal.escreverNoHistorico(varGlobal.HistoricoTTSClicar1);
			timer.performWithDelay(1000,function() event.target.selecionado1 = false end,1)
		elseif event.phase == "moved" then
			--system.vibrate()
			audio.stop()
			local som = audio.loadSound(atrib.somBotao1)
			audio.play(som)
		elseif event.phase == "ended" and event.target and event.target.selecionado2 == false  then
			event.target.selecionado2 = true
			audio.stop()
			local som = audio.loadSound(atrib.somBotao1)
			audio.play(som)
			timer.performWithDelay(1000,function() event.target.selecionado2 = false end,1)
		elseif event.phase == "ended" and event.target.selecionado1 == true and event.target.selecionado2 == true  then
			--event.target.isVisible = false
			-- HISTÓRICO
			
			local subPagina = atrib.subPagina
			historicoLib.Criar_e_salvar_vetor_historico({
				tipoInteracao = "TTS",
				pagina_livro = atrib.pagina,
				objeto_id = nil,
				acao = "executar",
				subtipo = "mensagens",
				subPagina = subPagina,
				velocidade_tts = atrib.velocidade,
				tela = atrib.tela
			})
			
			auxFuncs.pausarDespausarAnimacao(Var,"parar")
			auxFuncs.clearNativeScreenElements(Var)
			-- Pegar a lista de Textos para montagem dos áudios
			
			local vetorTextos = organizarTextosTTSDosComentarios(atrib.vetorAnot,atrib.vetorMens)
			media.stopSound()
			audio.stop()
			local nomeArquivos = "AnotMens"
			local grupoAguarde = auxFuncs.TelaAguardeGerarAudio()
			-- pegar lista de arquivos de áudio
			local arquivosCriados = M.criarAudiosTTS({
				nome = nomeArquivos,
				vetor = vetorTextos,
				pagina = atrib.pagina,
				tapResponse = atrib.tapResponse,
				tipoTTS = atrib.tipo,--"RSS"
				velocidadeTTS = atrib.velocidade,
				extencao = atrib.extencao,
				idioma = atrib.idioma, -- "pt-br"
				APIkey = atrib.APIkey,
				qualidade = atrib.qualidade, -- "12khz_16bit_mono"
				voz = atrib.voz,
				neural = atrib.neural,
				audioSemNet = atrib.audioSemNet,
				diretorioBase = atrib.diretorioBase,
				pasta = atrib.pasta,
				pastaArquivos = atrib.pastaArquivos,
				funcionalidade = atrib.funcionalidade
			},grupoAguarde)
			-- esperar a lista de arquivos ser criada
			arquivosCriados.timerDeEsperaPorLista = timer.performWithDelay(100,
				function()
					if grupoAguarde.offline then
						if grupoAguarde then
							grupoAguarde:removeSelf()
							grupoAguarde = nil
						end
					end
					if arquivosCriados.temAudio then 
						if arquivosCriados.temAudio == "sim" then
							if grupoAguarde then
								grupoAguarde.texto.text = "baixando audios"
							end
						elseif arquivosCriados.temAudio == "não" then
							if grupoAguarde then
								grupoAguarde.texto.text = "não tem audio"
								timer.performWithDelay(2000,function() grupoAguarde:removeSelf();grupoAguarde=nil end,1)
							end
						end
					end
					if arquivosCriados.baixarAudio then
						if arquivosCriados.baixarAudio == "ended" then
							if grupoAguarde then
								grupoAguarde.texto.text = "terminando de baixar audios"
							end
						else
							if grupoAguarde then
								grupoAguarde.texto.text = arquivosCriados.baixarAudio
							end
						end
					end
					if arquivosCriados.listaAtualizada then
					-- Após pegar a lista de arquivos de áudio, mandar tocar os áudios
						if grupoAguarde then
							grupoAguarde:removeSelf()
							grupoAguarde = nil
						end
						timer.cancel(arquivosCriados.timerDeEsperaPorLista)
						arquivosCriados.timerDeEsperaPorLista = nil

						for i=1,#arquivosCriados.lista do
							--print("Arquivo "..i,arquivosCriados.lista[i])
							--print("verbete "..i,arquivosCriados.verbete[i])
							--print("audio "..i,arquivosCriados.audio[i])
							--print("video "..i,arquivosCriados.video[i])

						end
						-- Aqui pode rodar os audios encontrados

						--arquivosCriados.tableParagrafosFinais
							-- .verbete
							-- .video
							-- .audio
						-- primeiro criar Interface de controle
						local grupoBotoes = M.criarBotoesTTS(Var,atrib,arquivosCriados)
						--local imagemPlaying = display.newImage("TTS Dic playing.png")
						local imagemPlaying = M.colocarAnimacao({imagens = {"TTS anotMens 1.png","TTS anotMens 3.png","TTS anotMens 3.png","TTS anotMens 2.png","TTS anotMens 2.png"},loop = "sim",automatico = "sim",comprimento = 300,altura = 300,x = 0,y = -150,tempoPorImagem = 200,tirarBotao = true})
						imagemPlaying.x = W/2;imagemPlaying.y = H/2
						grupoBotoes:insert(imagemPlaying)
					end
				end,
			-1)
		end
		return true
	end

	grupo.botaoTTS = widget.newButton{
		
		defaultFile = "ttsComment.png",
		overFile = "ttsCommentD.png",
		onEvent = grupo.executarTTSComentarios
	}
	grupo.botaoTTS.selecionado1 = false
	grupo.botaoTTS.selecionado2 = false
	grupo.botaoTTS.anchorX=1;grupo.botaoTTS.anchorY=0
	grupo.botaoTTS.x=W;
	grupo.botaoTTS.y=0--100
	grupo.botaoTTS.width = grupo.botaoTTS.width--*.7
	grupo.botaoTTS.height = grupo.botaoTTS.height--*.7
	grupo:insert(grupo.botaoTTS)
	vAnot=nil
	vMens=nil
	return grupo
end

----------------------------------------------------------
--  COLOCAR RODAPÉ ---------------------------------------
----------------------------------------------------------

function M.criarBotaoRodape(tela,Var,varGlobal)
	local grupoRodape = display.newGroup()
	local aguarde = {}
	local manipularTela = require("manipularTela")
	local pagina = varGlobal.PagH
	
	local function fecharTela()
		local somFechando = audio.loadSound("audioTTS_rodape fechar.MP3")
		audio.play(somFechando)
		aguarde:removeSelf()
		aguarde={}
		auxFuncs.restoreNativeScreenElements(Var)
		grupoRodape.removerTelaRodape()
		if grupoRodape.grupoRemover then
			grupoRodape.grupoRemover:removeSelf()
			grupoRodape.grupoRemover = nil
		end
		grupoRodape.botaoFechar:setEnabled(false)
		grupoRodape:insert(grupoRodape.botao)
		grupoRodape:insert(grupoRodape.botaoFechar)
		grupoRodape.botaoFechar.isVisible = false
		transition.to(grupoRodape.botao,{time=300,y = H,yScale=1,xScale=1,onComplete = function()	grupoRodape.botao:setEnabled(true) end})
		transition.to(grupoRodape.botaoFechar,{time=300,y = H-5,x = W/2 + grupoRodape.botao.width/2 - grupoRodape.botaoFechar.width/2 - 5,yScale=1.4,xScale=1.4,alpha = 0})
		grupoRodape.botao.aberto = false
	end
	
	local function mostrarConteudoRodape()
		--print("Mostrando conteúdo rodapé")
		-- ACRESCENTAR CONTEUDO DO RODAPÉ COM MÁSCARA DE MOVIMENTO IGUAL NOS DETALHES DE TEXTO
		grupoRodape.grupoRemover = display.newGroup()
		grupoRodape.grupoRemover.grupoOpcoes = display.newGroup()
		
		grupoRodape.grupoRemover.opcoes = {}
		
		historicoLib.Criar_e_salvar_vetor_historico({
			tipoInteracao = "rodape",
			pagina_livro = pagina,
			acao = "abrir",
			tela = tela
		})
		
		local function scrollListener( event )

			local phase = event.phase
			if ( phase == "began" ) then print( "Scroll view was touched" )
			elseif ( phase == "moved" ) then print( "Scroll view was moved" )
			elseif ( phase == "ended" ) then print( "Scroll view was released" )
			end

			-- In the event a scroll limit is reached...
			if ( event.limitReached ) then
				if ( event.direction == "up" ) then print( "Reached bottom limit" )
				elseif ( event.direction == "down" ) then print( "Reached top limit" )
				elseif ( event.direction == "left" ) then print( "Reached right limit" )
				elseif ( event.direction == "right" ) then print( "Reached left limit" )
				end
			end
			if orientacao == "landscapeRight" then
				local X,Y = grupoRodape.grupoRemover.scrollView:getContentPosition()
				if X < -grupoRodape.grupoRemover.texto.height - 50 then
					grupoRodape.grupoRemover.scrollView:scrollToPosition
					{
						x = -grupoRodape.grupoRemover.texto.height,
						time = 300
					}
				elseif X > -grupoRodape.grupoRemover.texto.height/2 + 50 then
					grupoRodape.grupoRemover.scrollView:scrollToPosition
					{
						x = -grupoRodape.grupoRemover.texto.height/2,
						time = 300
					}
				end
			end

			return true
		end
		
		local backScrollView = display.newRect(34,200,W-68,H-200-100)
		backScrollView.anchorX = 0
		backScrollView.anchorY = 0
		backScrollView.strokeWidth = 4
		backScrollView:setStrokeColor(40/255,189/255,226/255)
		grupoRodape.grupoRemover:insert(backScrollView)
		
		grupoRodape.grupoRemover.scrollView = widget.newScrollView {
			left = 34,
			top = 200,
			width = W-68,
			height = H-200-100,
			hideBackground = true,
			backgroundColor = { 0 },
			--isBounceEnabled = false,
			horizontalScrollDisabled = true,
			verticalScrollDisabled = false,
			listener = scrollListener
		}
		--tela.vetorRodapes
		grupoRodape.grupoRemover:insert(grupoRodape.grupoRemover.scrollView)
		grupoRodape.grupoRemover.scrollView:insert( grupoRodape.grupoRemover.grupoOpcoes )
		
		local textoAUsar = ""
		local linhaAtual = 0
		local colunaAtual = 0
		local listaScriptTelasTTS = {}
		for i=1,#grupoRodape.arquivos do
			local numero = grupoRodape.arquivosNumeros[i]
			local palavras = grupoRodape.arquivosPalavras[i]
			local texto = display.newText(grupoRodape.grupoRemover," "..numero.." ",0,0,"Fontes/segoeui.ttf",70)
			texto:setFillColor(0,0,0)
			texto.anchorY=0.5
			texto.anchorX=0.5
			
			grupoRodape.grupoRemover.fecharTelaRodape = function(event)
				if grupoRodape.grupoRemover.botaoVoltar then grupoRodape.grupoRemover.botaoVoltar:setEnabled(false) end
					historicoLib.Criar_e_salvar_vetor_historico({
						tipoInteracao = "rodape",
						pagina_livro = pagina,
						numero = numero,
						palavras = palavras,
						acao = "fechar",
						tela = tela
					})
					transition.to(grupoRodape.grupoRemover.Tela,{time=500,x=W})
					transition.to(grupoRodape.grupoRemover.grupoOpcoes,{time=300,x=0,onComplete = function()
					if grupoRodape.grupoRemover.botaoVoltar then grupoRodape.grupoRemover.botaoVoltar:removeSelf(); grupoRodape.grupoRemover.botaoVoltar = nil end
					if grupoRodape.grupoRemover.Tela then grupoRodape.grupoRemover.Tela:removeSelf(); grupoRodape.grupoRemover.Tela = nil end
				end})
				return true
			end
			grupoRodape.grupoRemover.criarTelaRodape = function(event)
				if event.target.clicado == false  then
					audio.stop()
					media.stopSound()
					print(varGlobal.ttsRodape1CliquePagina)
					local somNumero = audio.loadSound(event.target.numero..".mp3")
					local function onComplete(evt)
						if evt.completed then
							local som = audio.loadSound(varGlobal.ttsRodape1CliquePagina)
							audio.play(som)
						end
					end
					local timerRequerimento = timer.performWithDelay(16,function() if somNumero then audio.play(somNumero,{onComplete = onComplete}) end end,1)
					event.target.clicado = true
					timer.performWithDelay(1000,function() event.target.clicado = false end,1)
					return true
				elseif event.target.clicado == true then
					event.target.clicado = false
					transition.to(grupoRodape.grupoRemover.grupoOpcoes,{time=500,x=-W})
					local pathFile = system.pathForFile(tela.pastaArquivosAtual.."/Rodape/"..event.target.arquivo)
					if not pathFile then
						scriptTela = "1 - texto\n texto=Não foi anexado um texto válido para esse rodapé."
					else
						scriptTela = auxFuncs.lerArquivoTXTCaminho({caminho = system.pathForFile(tela.pastaArquivosAtual.."/Rodape/"..event.target.arquivo),tipo = "texto"})
					end
					-- acrescentar uma tela
					--local fundo = elemTela.colocarSeparador({espessura = H,largura = W,cor = {255,255,255}})
					--fundo.strokeWidth = 5
					--fundo:setStrokeColor(46/255,171/255,200/255)
					--fundo:scale(.9,1)
					local function refazerTela(atribut)
						atribut.PaginaCriada.removerTela()
						grupoRodape.grupoRemover.Tela:removeSelf()
						print("refez a tela")
						print("pasta rodape 2:",tela.pastaArquivosAtual.."/Rodape")
						grupoRodape.grupoRemover.Tela = manipularTela.criarUmaTela(
							{
								pasta = tela.pastaArquivosAtual.."/Rodape",
								arquivo = event.target.arquivo,
								scriptDaPagina = scriptTela,
								vetorRefazer = atribut.tela,
								--dicionario = true
							},
							refazerTela
						)
						grupoRodape.grupoRemover.Tela.x = 0
						grupoRodape.grupoRemover.Tela.y = 0
						grupoRodape.grupoRemover.Tela.height = grupoRodape.grupoRemover.Tela.height*0.9
						grupoRodape.grupoRemover.Tela.width = grupoRodape.grupoRemover.Tela.width*0.9
						grupoRodape.grupoRemover.scrollView:insert( grupoRodape.grupoRemover.Tela)
						
					end
					historicoLib.Criar_e_salvar_vetor_historico({
						tipoInteracao = "rodape",
						pagina_livro = pagina,
						numero = event.target.i,
						acao = "abrir",
						tela = tela
					})
					print("pasta rodape 1:",listaScriptTelasTTS[event.target.i].pasta)
					grupoRodape.grupoRemover.Tela = manipularTela.criarUmaTela(
						{
							pasta = listaScriptTelasTTS[event.target.i].pasta,
							arquivo = listaScriptTelasTTS[event.target.i].arquivo,
							scriptDaPagina = listaScriptTelasTTS[event.target.i].scriptTela,
							--dicionario = true
						},
						refazerTela
					)
					grupoRodape.grupoRemover.Tela.x = W
					grupoRodape.grupoRemover.Tela.y = 0
					grupoRodape.grupoRemover.Tela.height = grupoRodape.grupoRemover.Tela.height*0.9
					grupoRodape.grupoRemover.Tela.width = grupoRodape.grupoRemover.Tela.width*0.9
					grupoRodape.grupoRemover.scrollView:insert( grupoRodape.grupoRemover.Tela)
					
					grupoRodape.grupoRemover.botaoVoltar = widget.newButton {
						onRelease = grupoRodape.grupoRemover.fecharTelaRodape,
						emboss = false,
						-- Properties for a rounded rectangle button
						defaultFile = "backButton.png",
						overFile = "backButtonD.png",
						height = 70,
						width = 140
					}
					grupoRodape.grupoRemover.botaoVoltar.i = event.target.i
					grupoRodape.grupoRemover.botaoVoltar.anchorX=0
					grupoRodape.grupoRemover.botaoVoltar.anchorY=0
					
					grupoRodape.grupoRemover.botaoVoltar.x = W+10
					grupoRodape.grupoRemover.botaoVoltar.y=10
					grupoRodape.grupoRemover.grupoOpcoes:insert( grupoRodape.grupoRemover.botaoVoltar )
					
					transition.to(grupoRodape.grupoRemover.Tela,{time=500,x=0})
					
					--transition.to(grupoRodape.grupoRemover.botaoVoltar,{time=500,x=W+10})
				end
			end
			local pathFile = system.pathForFile("Rodape/"..grupoRodape.arquivos[i])
			local scriptTela = nil
			if not pathFile then 
				print("PATH FILE","Rodape/"..grupoRodape.arquivos[i])
				scriptTela = "1 - texto\n texto=Não foi anexado um texto válido para esse rodapé."
			else
				scriptTela = auxFuncs.lerArquivoTXTCaminho({caminho = system.pathForFile("Rodape/"..grupoRodape.arquivos[i]),tipo = "texto"})
			end
			
			table.insert(listaScriptTelasTTS,{scriptTela = scriptTela,pasta="Rodape",arquivo=grupoRodape.arquivos[i],numero = grupoRodape.arquivosNumeros[i],palavras = grupoRodape.arquivosPalavras[i]})
			
			grupoRodape.grupoRemover.opcoes[i] = widget.newButton{
				shape = "roundedRect",
				fillColor = {default = {46/255,171/255,200/255},over = {40/255,189/255,226/255,0.5}},
				radius = 20,
				width = 90,
				height = 90,
				strokeWidth = 1,
				strokeColor = { default={ 0, 0, 0 }, over={ 1, 1, 1 } },
				onRelease = grupoRodape.grupoRemover.criarTelaRodape
			}
			grupoRodape.grupoRemover.opcoes[i].clicado = false
			grupoRodape.grupoRemover.opcoes[i].anchorY=0
			grupoRodape.grupoRemover.opcoes[i].anchorX=0
			grupoRodape.grupoRemover.opcoes[i].y = 10 + linhaAtual*100
			grupoRodape.grupoRemover.opcoes[i].x = 10 + colunaAtual*108
			grupoRodape.grupoRemover.opcoes[i].arquivo = grupoRodape.arquivos[i]
			grupoRodape.grupoRemover.opcoes[i].i = i
			grupoRodape.grupoRemover.opcoes[i].numero = numero
			texto.x = grupoRodape.grupoRemover.opcoes[i].x + grupoRodape.grupoRemover.opcoes[i].width/2
			texto.y = grupoRodape.grupoRemover.opcoes[i].y + grupoRodape.grupoRemover.opcoes[i].height/2
			grupoRodape.grupoRemover.grupoOpcoes:insert( grupoRodape.grupoRemover.opcoes[i] )
			grupoRodape.grupoRemover.grupoOpcoes:insert( texto )
			colunaAtual = colunaAtual + 1
			if (i+1)%7 == 0 then
				linhaAtual = linhaAtual + 1
				colunaAtual = 0
			end
			
			
			
		end
		local vertices = { 	-50,50, 0,-30, 50,50, 20,50, 20,120, -20,120, -20,50 }
		
		
		
		local seta = display.newPolygon(grupoRodape.grupoRemover.grupoOpcoes,W/2, grupoRodape.grupoRemover.opcoes[#grupoRodape.grupoRemover.opcoes].y + grupoRodape.grupoRemover.opcoes[#grupoRodape.grupoRemover.opcoes].height + 30, vertices )
		seta.anchorY=0
		seta.anchorX=1
		seta:scale(.8,.7)
		seta.fill = { 46/255,171/255,200/255 }
		seta.strokeWidth = 5
		seta:setStrokeColor( 0, 0, 0 )
		local optionsText = {
			parent = grupoRodape.grupoRemover.grupoOpcoes,
			text = "Clique em um dos números para ver o conteúdo multimídia do mesmo.",
			align = "center",
			x = W/2-30,
			y = 10,
			width = 600,
			font = "Fontes/segoeuib.ttf",
			size = 40
		}
		local textoIntruncoes = display.newText(optionsText)
		textoIntruncoes.y = grupoRodape.grupoRemover.opcoes[#grupoRodape.grupoRemover.opcoes].y + grupoRodape.grupoRemover.opcoes[#grupoRodape.grupoRemover.opcoes].height/2 + 30 +seta.height
		textoIntruncoes.anchorX=0.5
		textoIntruncoes.anchorY=0
		textoIntruncoes:setFillColor(0,0,0)
		
		local retangulo = display.newRoundedRect(0,0,0,0,20)
		retangulo.width = 610;retangulo.height = textoIntruncoes.height+40
		retangulo.x = textoIntruncoes.x;retangulo.y = textoIntruncoes.y - 40
		retangulo.anchorY=0
		retangulo:setFillColor(1,1,1,0)
		retangulo.strokeWidth = 5
		retangulo:setStrokeColor(0,0,0,1)
		grupoRodape.grupoRemover.grupoOpcoes:insert(retangulo)
		grupoRodape.grupoRemover.grupoOpcoes:insert(seta)


		Var.botaoTTSRodape = M.criarBotaoTTSRodape(
			{
				tela = tela,
				pagina = tela.rodapeTTS.paginaHistorico,
				tipo = tela.rodapeTTS.tipo,
				APIkey = tela.rodapeTTS.apiKey,
				idioma = tela.rodapeTTS.idioma,
				voz = tela.rodapeTTS.voz,
				velocidade = tela.rodapeTTS.velocidade,
				neural = tela.rodapeTTS.neural, 
				qualidade = tela.rodapeTTS.qualidade,
				extencao = tela.rodapeTTS.extencao, 
				diretorioBase = tela.rodapeTTS.diretorio,
				tapResponse = tela.rodapeTTS.respostaTapAudio,
				tapPaginaResponse = tela.rodapeTTS.respostaTapAudioPagina,
				audioSemNet = tela.rodapeTTS.botaoSemInternet,
				pastaArquivos = tela.rodapeTTS.pastaArquivos,
				pasta = tela.rodapeTTS.pasta,
				somBotao1 = tela.rodapeTTS.somBotao1,
				temHistorico = tela.rodapeTTS.temHistorico,
				temLogin = tela.rodapeTTS.temLogin,
				subPagina = tela.rodapeTTS.subPagina,
				funcionalidade = "rodape",
				vetor = listaScriptTelasTTS
			}
			,Var
		)
		--print("Var.botaoTTSRodape = ",Var.botaoTTSRodape)

	end
	function grupoRodape.abrirRodape(event)
		if event.target.clicado == false  then
			audio.stop()
			media.stopSound()
			
			local som = audio.loadStream(varGlobal.ttsRodapeMenuRapido1Clique)
			local timerRequerimento = timer.performWithDelay(16,function() audio.play(som) end,1)
			event.target.clicado = true
			timer.performWithDelay(1000,function() event.target.clicado = false end,1)
			return true
		end
		if event.target.clicado == true  then
			audio.stop()
			event.target.clicado = false
			local somAbrindo = audio.loadSound("audioTTS_rodape abrir.MP3")
			audio.play(somAbrindo)
			auxFuncs.clearNativeScreenElements(Var)
			grupoRodape.botao:setEnabled(false)
			grupoRodape.botaoFechar:setEnabled(true)
			local grupoAberto = display.newGroup()
			aguarde = {}
			aguarde = auxFuncs.TelaProtetiva()

			grupoAberto:insert(aguarde)
			grupoAberto:insert(grupoRodape.botao)
			grupoAberto:insert(grupoRodape.botaoFechar)
			grupoRodape.botao.aberto = true
			grupoRodape.botaoFechar.isVisible = true
			transition.to(grupoRodape.botao,{time=300,y = 200,yScale=1.4,xScale=1.4,onComplete = mostrarConteudoRodape})
			transition.to(grupoRodape.botaoFechar,{time=300,y = 200 - (5*1.4),x=W/2 + (grupoRodape.botao.width*1.4)/2 - (grupoRodape.botaoFechar.width*1.4)/2 - 5,yScale=1.4,xScale=1.4,alpha = 1})
			return true
		end
	end
	function grupoRodape.removerTelaRodape()
		print("Var.botaoTTSRodape = ",Var.botaoTTSRodape)
		
		historicoLib.Criar_e_salvar_vetor_historico({
			tipoInteracao = "rodape",
			pagina_livro = pagina,
			acao = "fechar",
			tela = tela
		})
		
		if Var.botaoTTSRodape then
			Var.botaoTTSRodape:removeSelf()
			Var.botaoTTSRodape = nil
		end
		if grupoRodape.grupoRemover then
			grupoRodape.grupoRemover:removeSelf()
			grupoRodape.grupoRemover = nil
		end
		
		return true;
	end
	local txtArquivos = auxFuncs.lerTextoDoc("rodape.txt")
	if not txtArquivos then
		txtArquivos = ""
	else
		txtArquivos = string.gsub(txtArquivos,".",{ ["\13"] = "",["\10"] = "\13\10"})
	end
	local is_valid, error_position = validarUTF8.validate(txtArquivos)
	if not is_valid then 
		--print('non-utf8 sequence detected at position ' .. tostring(error_position))
		txtArquivos = conversor.converterANSIparaUTFsemBoom(txtArquivos)
	end
	-- Output lines
	grupoRodape.arquivos = {}
	grupoRodape.arquivosNumeros = {}
	grupoRodape.arquivosPalavras = {}
	for line in string.gmatch(txtArquivos,"([^\13\10]+)") do
		local arquivo,numero,palavras = string.match(line,"(.+)|||(.+)|||(.+)")
		table.insert(grupoRodape.arquivos,arquivo)
		table.insert(grupoRodape.arquivosNumeros,numero)
		table.insert(grupoRodape.arquivosPalavras,palavras)
	end
	
	grupoRodape.botao = widget.newButton{
		shape = "roundedRect",
		fillColor = { default={ 243/255,129/255,33/255 }, over={ 1,1,1 } },
		label = "rodapé",
		width = W-250,
		height = 40,
		strokeWidth = 3,
		strokeColor = { default={ 0, 0, 0 }, over={ 0, 0, 0 } },
		fontSize = 40,
		font = "Fontes/paolaAccent.ttf",
		labelColor = { default={ 0, 0, 0 }, over={ 1, 1, 1, 1 } },
		onRelease = grupoRodape.abrirRodape
	}
	grupoRodape.botao:addEventListener("tap",function() return true end)
	grupoRodape.botao.clicado = false
	grupoRodape.botao.aberto = false
	grupoRodape.botao.anchorX=0.5
	grupoRodape.botao.anchorY=1
	grupoRodape.botao.x = W/2
	grupoRodape.botao.y = H
	grupoRodape:insert(grupoRodape.botao)
	
	--botao fechar invisivel
	grupoRodape.botaoFechar = widget.newButton {
		onRelease = fecharTela,
		emboss = false,
		-- Properties for a rounded rectangle button
		defaultFile = "closeMenuButton2.png",
		overFile = "closeMenuButton2D.png",
		height = 35,
		width = 35
	}
	grupoRodape.botaoFechar.anchorX=0.5
	grupoRodape.botaoFechar.anchorY=1
	grupoRodape.botaoFechar.alpha = 0
	grupoRodape.botaoFechar.isVisible = false
	grupoRodape.botaoFechar:setEnabled(false)
	
	grupoRodape.botaoFechar.x = grupoRodape.botao.x + grupoRodape.botao.width/2 - grupoRodape.botaoFechar.width/2 - 5
	grupoRodape.botaoFechar.y=grupoRodape.botao.y - 5
	grupoRodape:insert(grupoRodape.botaoFechar)
	
	return grupoRodape
end
----------------------------------------------------------
--  COLOCAR DICIONÁRIO --
----------------------------------------------------------

function M.montarScriptDicionario(atrib,vetorDicPalavra)
	local tamanho_fonte = " tamanho = 20\n"
	local cor_fonte = " cor = 0,0,0\n"
	local alinhamento = " alinhamento = justificado\n"
	local fonteAriblk = " fonte = ariblk.ttf\n"
	local recuo = " x = 10\n"
	local scriptPagina = "0-texto\n texto="..atrib.palavra.."\n"
	scriptPagina = scriptPagina..	cor_fonte
	scriptPagina = scriptPagina..	" alinhamento = esquerda\n"
	scriptPagina = scriptPagina..	fonteAriblk
	scriptPagina = scriptPagina.."0-espaco\n"
	if vetorDicPalavra.silabas then
		scriptPagina = scriptPagina.."2-texto\n"
		scriptPagina = scriptPagina..	"texto ="..vetorDicPalavra.silabas.."\n"
		scriptPagina = scriptPagina..	" tamanho = 25\n"
		scriptPagina = scriptPagina..	" cor = 100,100,100\n"
		scriptPagina = scriptPagina..	" alinhamento = esquerda\n"
		scriptPagina = scriptPagina..	fonteAriblk
		scriptPagina = scriptPagina.."0-espaco\n"
	end
	if vetorDicPalavra.categoriaG then
		scriptPagina = scriptPagina.."3-texto\n"
		scriptPagina = scriptPagina..	"texto ="..vetorDicPalavra.categoriaG.."\n"
		scriptPagina = scriptPagina..	tamanho_fonte
		scriptPagina = scriptPagina..	cor_fonte
		scriptPagina = scriptPagina..	alinhamento
		scriptPagina = scriptPagina..	fonteAriblk
		scriptPagina = scriptPagina.."0-espaco\n"
	end
	if vetorDicPalavra.plural then
		scriptPagina = scriptPagina.."2-texto\n"
		scriptPagina = scriptPagina..	"texto = Plural: "..vetorDicPalavra.plural.."\n"
		scriptPagina = scriptPagina..	" tamanho = 20\n"
		scriptPagina = scriptPagina..	cor_fonte
		scriptPagina = scriptPagina..	alinhamento
		scriptPagina = scriptPagina.."0-espaco\n"
	end
	if vetorDicPalavra.traducao then
		scriptPagina = scriptPagina.."1-texto\n"
		scriptPagina = scriptPagina..	" texto = Tradução: \n"
		scriptPagina = scriptPagina..	tamanho_fonte
		scriptPagina = scriptPagina..	cor_fonte
		scriptPagina = scriptPagina..	alinhamento
		scriptPagina = scriptPagina..	fonteAriblk
		scriptPagina = scriptPagina.."1-texto\n"
		scriptPagina = scriptPagina..	" texto ="..vetorDicPalavra.traducao.."\n"
		scriptPagina = scriptPagina..	tamanho_fonte
		scriptPagina = scriptPagina..	cor_fonte
		scriptPagina = scriptPagina..	alinhamento
		scriptPagina = scriptPagina..	recuo
		scriptPagina = scriptPagina.."0-espaco\n"
	end
	if vetorDicPalavra.significado then
		scriptPagina = scriptPagina.."2-texto\n"
		scriptPagina = scriptPagina..	"texto = Significado: \n"
		scriptPagina = scriptPagina..	tamanho_fonte
		scriptPagina = scriptPagina..	cor_fonte
		scriptPagina = scriptPagina..	alinhamento
		scriptPagina = scriptPagina..	fonteAriblk
		scriptPagina = scriptPagina.."2-texto\n"
		scriptPagina = scriptPagina..	"texto ="..vetorDicPalavra.significado.."\n"
		scriptPagina = scriptPagina..	tamanho_fonte
		scriptPagina = scriptPagina..	cor_fonte
		scriptPagina = scriptPagina..	alinhamento
		scriptPagina = scriptPagina..	recuo
		scriptPagina = scriptPagina.."0-espaco\n"
	end



	if vetorDicPalavra.origem then
		scriptPagina = scriptPagina.."2-texto\n"
		scriptPagina = scriptPagina..	"texto = Etimologia (origem da palavra): \n"
		scriptPagina = scriptPagina..	tamanho_fonte
		scriptPagina = scriptPagina..	cor_fonte
		scriptPagina = scriptPagina..	alinhamento
		scriptPagina = scriptPagina..	fonteAriblk
		scriptPagina = scriptPagina.."2-texto\n"
		scriptPagina = scriptPagina..	"texto ="..vetorDicPalavra.origem.."\n"
		scriptPagina = scriptPagina..	tamanho_fonte
		scriptPagina = scriptPagina..	cor_fonte
		scriptPagina = scriptPagina..	alinhamento
		scriptPagina = scriptPagina..	recuo
		scriptPagina = scriptPagina.."0-espaco\n"
	end
	if vetorDicPalavra.foneticasEpronuncias then
			scriptPagina = scriptPagina.."4-texto\n"
			scriptPagina = scriptPagina..	"texto = Fonética:\n"
			scriptPagina = scriptPagina..	tamanho_fonte
			scriptPagina = scriptPagina..	cor_fonte
			scriptPagina = scriptPagina..	alinhamento
			scriptPagina = scriptPagina..	fonteAriblk
			for fnp=1,#vetorDicPalavra.foneticasEpronuncias do
				if vetorDicPalavra.foneticasEpronuncias[fnp][1] then
					scriptPagina = scriptPagina.."0-espaco\n"
					scriptPagina = scriptPagina.."4-texto\n"
					scriptPagina = scriptPagina..	"texto = "..vetorDicPalavra.foneticasEpronuncias[fnp][1].."\n"
					scriptPagina = scriptPagina..	tamanho_fonte
					scriptPagina = scriptPagina..	cor_fonte
					scriptPagina = scriptPagina..	recuo
					scriptPagina = scriptPagina..	alinhamento
				end
				if vetorDicPalavra.foneticasEpronuncias[fnp][2] then
					scriptPagina = scriptPagina.."0-espaco\n"
					scriptPagina = scriptPagina.."5-botao\n"
					scriptPagina = scriptPagina.. " label = \n"
					scriptPagina = scriptPagina.. " acao = som\n"
					scriptPagina = scriptPagina.. " comprimento = 240\n"
					scriptPagina = scriptPagina.. " altura = 160\n"
					scriptPagina = scriptPagina.. " automatico = nao\n"
					scriptPagina = scriptPagina.. " cor = 191,77,78\n"
					scriptPagina = scriptPagina.. " fundoUp = audioButton.png\n"
					scriptPagina = scriptPagina.. " fundoDown = audioButtonD.png\n"
					scriptPagina = scriptPagina..	" som = "..vetorDicPalavra.foneticasEpronuncias[fnp][2].."\n"
				end
			end
			scriptPagina = scriptPagina.."0-espaco\n"
	end
	if vetorDicPalavra.imagens then

		scriptPagina = scriptPagina.."6-texto\n"
		if #vetorDicPalavra.imagens > 1 then
			scriptPagina = scriptPagina..	"texto = Imagens:\n"
		else
			scriptPagina = scriptPagina..	"texto = Imagem:\n"
		end
		scriptPagina = scriptPagina..	tamanho_fonte
		scriptPagina = scriptPagina..	cor_fonte
		scriptPagina = scriptPagina..	alinhamento
		scriptPagina = scriptPagina..	fonteAriblk
		for img=1,#vetorDicPalavra.imagens do
			scriptPagina = scriptPagina.."0-espaco\n"
			local textoTitulo = "texto = Figura "..img.."\n"
			if vetorDicPalavra.imagens[img].titulo then
				textoTitulo = "texto = Figura "..img..": "..vetorDicPalavra.imagens[img].titulo.."\n"
			end
			scriptPagina = scriptPagina.."6-texto\n"
			scriptPagina = scriptPagina..	textoTitulo
			scriptPagina = scriptPagina..	tamanho_fonte
			scriptPagina = scriptPagina..	cor_fonte
			scriptPagina = scriptPagina..	" alinhamento = meio\n"
			scriptPagina = scriptPagina.."6-imagem\n"
			scriptPagina = scriptPagina..	"arquivo = "..vetorDicPalavra.imagens[img].arquivo.."\n"
			if vetorDicPalavra.imagens[img].fonte then
				scriptPagina = scriptPagina.."6-texto\n"
				scriptPagina = scriptPagina..	"texto = Fonte: "..vetorDicPalavra.imagens[img].fonte.."\n"
				scriptPagina = scriptPagina..	tamanho_fonte
				scriptPagina = scriptPagina..	cor_fonte
				scriptPagina = scriptPagina..	" alinhamento = meio\n"
			end
			scriptPagina = scriptPagina.."0-espaco\n"
		end
	end
	if vetorDicPalavra.video then
			scriptPagina = scriptPagina.."7-texto\n"
			scriptPagina = scriptPagina..	"texto = Vídeo:\n"
			scriptPagina = scriptPagina..	tamanho_fonte
			scriptPagina = scriptPagina..	cor_fonte
			scriptPagina = scriptPagina..	alinhamento
			scriptPagina = scriptPagina..	fonteAriblk
			local textoTitulo = ""
			if vetorDicPalavra.video.titulo then
				textoTitulo = "texto = "..vetorDicPalavra.video.titulo.."\n"
			end
			if textoTitulo ~= "" then
				scriptPagina = scriptPagina.."6-texto\n"
				scriptPagina = scriptPagina..	textoTitulo
				scriptPagina = scriptPagina..	tamanho_fonte
				scriptPagina = scriptPagina..	cor_fonte
				scriptPagina = scriptPagina..	" alinhamento = meio\n"
			end
			scriptPagina = scriptPagina.."7-video\n"
			scriptPagina = scriptPagina..	"arquivo = "..vetorDicPalavra.video.arquivo.."\n"
			if vetorDicPalavra.video.fonte then
				scriptPagina = scriptPagina.."6-texto\n"
				scriptPagina = scriptPagina..	"texto = Fonte: "..vetorDicPalavra.video.fonte.."\n"
				scriptPagina = scriptPagina..	tamanho_fonte
				scriptPagina = scriptPagina..	cor_fonte
				scriptPagina = scriptPagina..	" alinhamento = meio\n"
			end
			scriptPagina = scriptPagina.."0-espaco\n"
	end
	if vetorDicPalavra.contextos then
		for ii=1,#vetorDicPalavra.contextos do
			local texto = "Contexto: "..ii..":"
			if #vetorDicPalavra.contextos == 1 then
				texto = "Exemplo de Contexto:"
			end
			scriptPagina = scriptPagina.."8-texto\n"
			scriptPagina = scriptPagina..	"texto = "..texto.." \n"
			scriptPagina = scriptPagina..	tamanho_fonte
			scriptPagina = scriptPagina..	cor_fonte
			scriptPagina = scriptPagina..	alinhamento
			scriptPagina = scriptPagina..	fonteAriblk
			scriptPagina = scriptPagina.."8-texto\n"
			scriptPagina = scriptPagina..	"texto ="..vetorDicPalavra.contextos[ii].."\n"
			scriptPagina = scriptPagina..	tamanho_fonte
			scriptPagina = scriptPagina..	cor_fonte
			scriptPagina = scriptPagina..	alinhamento
			scriptPagina = scriptPagina..	recuo
			scriptPagina = scriptPagina.."0-espaco\n"
		end
	elseif atrib.contexto then
		scriptPagina = scriptPagina.."8-texto\n"
			scriptPagina = scriptPagina..	"texto = Contexto: \n"
			scriptPagina = scriptPagina..	tamanho_fonte
			scriptPagina = scriptPagina..	cor_fonte
			scriptPagina = scriptPagina..	alinhamento
			scriptPagina = scriptPagina..	fonteAriblk
			scriptPagina = scriptPagina.."8-texto\n"
			scriptPagina = scriptPagina..	"texto ="..atrib.contexto.."\n"
			scriptPagina = scriptPagina..	tamanho_fonte
			scriptPagina = scriptPagina..	cor_fonte
			scriptPagina = scriptPagina..	alinhamento
			scriptPagina = scriptPagina..	recuo
			scriptPagina = scriptPagina.."0-espaco\n"
	end

	if vetorDicPalavra.referencias then
		scriptPagina = scriptPagina.."8-texto\n"
		scriptPagina = scriptPagina..	"texto = #n#Referências:#/n# \n"
		scriptPagina = scriptPagina..	tamanho_fonte
		scriptPagina = scriptPagina..	cor_fonte
		scriptPagina = scriptPagina..	alinhamento
		scriptPagina = scriptPagina..	fonteAriblk
		scriptPagina = scriptPagina.."0-espaco\n"
		for ii=1,#vetorDicPalavra.referencias do
			scriptPagina = scriptPagina.."8-texto\n"
			scriptPagina = scriptPagina..	"texto = "..ii.." - "..vetorDicPalavra.referencias[ii].."\n"
			scriptPagina = scriptPagina..	recuo
			scriptPagina = scriptPagina..	tamanho_fonte
			scriptPagina = scriptPagina..	cor_fonte
			scriptPagina = scriptPagina..	" alinhamento = esquerda\n"
			scriptPagina = scriptPagina.."0-espaco\n"
		end
	end
	if vetorDicPalavra.complementos then
		scriptPagina = scriptPagina.."8-texto\n"
		scriptPagina = scriptPagina..	"texto = Complementos... \n"
		scriptPagina = scriptPagina..	tamanho_fonte
		scriptPagina = scriptPagina..	cor_fonte
		scriptPagina = scriptPagina..	alinhamento
		scriptPagina = scriptPagina..	fonteAriblk
		scriptPagina = scriptPagina.."0-espaco\n"
		for ii=1,#vetorDicPalavra.complementos do
			scriptPagina = scriptPagina.."8-texto\n"
			scriptPagina = scriptPagina..	"texto ="..vetorDicPalavra.complementos[ii].."\n"
			scriptPagina = scriptPagina..	tamanho_fonte
			scriptPagina = scriptPagina..	cor_fonte
			scriptPagina = scriptPagina..	alinhamento
			scriptPagina = scriptPagina..	recuo
			scriptPagina = scriptPagina.."0-espaco\n"
		end

	end
	return scriptPagina
end

function M.criarTelaDoDicionario(atrib,VarTela)
	local scriptPagina = auxFuncs.lerTextoRes("Dicionario Palavras/"..atrib.dicionario)--leituraTXT.criarDicionarioDeArquivoPadrao({pasta = "Dicionario Palavras",arquivo = atrib.dicionario},{})
	if not scriptPagina or (scriptPagina and scriptPagina == "") then
		scriptPagina = "1 - texto\n texto = \\nNão foi anexada uma página válida para o dicionário."
	end
	if scriptPagina then
		local elemTela = require "elementosDaTela";
		local manipularTela = require("manipularTela")
		local widget = require("widget")
		local TTS = {}
		
		if not string.find(scriptPagina,"%d%s*%-%s*%a+%s*\n") then
			scriptPagina = "1 - texto\n texto = \\nNão foi anexada uma página válida para o dicionário."
		end

		local telaProtetiva = auxFuncs.TelaProtetiva()
		telaProtetiva.alpha = 1

		local fundo = elemTela.colocarSeparador({espessura = H,largura = W,cor = {255,255,255}})
		fundo.strokeWidth = 5
		fundo:setStrokeColor(46/255,171/255,200/255)
		fundo:scale(.9,1)
		local Tela = {}
		local function refazerTela(atribut)
			atribut.PaginaCriada.removerTela()
			Tela:removeSelf()
			
			Tela = manipularTela.criarUmaTela(
				{
					pasta = "Dicionario Palavras",
					arquivo = atrib.dicionario,
					scriptDaPagina = scriptPagina,
					vetorRefazer = atribut.tela,
					dicionario = true
				},
				refazerTela
			)
			Tela.y = -200
			Tela.x = Tela.x - W/2 + Tela.width/20
			Tela.y = Tela.y - H/2 + Tela.height/10
			Tela:scale(.9,.9)
			fundo.container:insert( Tela, false )
			Tela.yInicial = fundo.container.height/10
			Tela.limiteV = fundo.container.y+fundo.container.height
			Tela:addEventListener("touch",auxFuncs.moverComLimiteVertical)
		end
		
		Tela = manipularTela.criarUmaTela(
			{
				pasta = "Dicionario Palavras",
				arquivo = atrib.dicionario,
				scriptDaPagina = scriptPagina,
				dicionario = true
			},
			refazerTela
		)
		atrib.telas.palavraDicHistorico = atrib.palavra
		atrib.telas.historicoDicionario = true

		historicoLib.Criar_e_salvar_vetor_historico({
			tipoInteracao = "dicionário",
			pagina_livro = atrib.telas.pagina,
			palavra = atrib.palavra,
			acao = "abrir palavra",
			objeto_id = atrib.objeto_id,
			tela = atrib.telas
		})

		Tela.y = -200
		--Tela.y = Tela.height/10 - 200
		--Tela.x = Tela.width/20
		Tela.x = Tela.x - W/2 + Tela.width/20
		Tela.y = Tela.y - H/2 + Tela.height/10
		Tela:scale(.9,.9)

		fundo.anchorX=0
		fundo.anchorY=0
		fundo.x = Tela.width/20--fundo.x - W/2
		fundo.y = 60--fundo.y - H/2

		fundo.container = display.newContainer( W, H )
		fundo.height = fundo.container.height - 120
		fundo.container:translate( W/2, H/2 ) -- center the container
		--container:insert( fundo, false )
		fundo.container:insert( Tela, false )
		--container.y = Tela.height/10 - 200
		--container.x = Tela.width/20


		Tela.yInicial = fundo.container.height/10
		Tela.limiteV = fundo.container.y+fundo.container.height
		Tela:addEventListener("touch",auxFuncs.moverComLimiteVertical)

		fundo.container:scale(.9,.9)

		function fundo.fecharTela(event)
			historicoLib.Criar_e_salvar_vetor_historico({
				tipoInteracao = "dicionário",
				pagina_livro = atrib.telas.pagina,
				palavra = atrib.palavra,
				acao = "fechar palavra",
				objeto_id = atrib.objeto_id,
				tela = atrib.telas
			})

			Tela.removerTela()

			Tela:removeSelf()

			telaProtetiva:removeSelf()
			fundo.fechar:removeSelf()
			fundo.fechar = nil
			fundo.container:removeSelf()
			fundo.container = nil

			if atrib.voltar then
				fundo.voltar:removeSelf()
				fundo.voltar=nil
			end

			Tela = nil
			fundo:removeSelf()
			fundo = nil
			telaProtetiva = nil

			if atrib.onClose and event.target.tipo == "fechar"  then
				atrib.onClose()
			end

			return true
		end

		fundo.fechar = widget.newButton {
			onRelease = fundo.fecharTela,
			emboss = false,
			-- Properties for a rounded rectangle button
			defaultFile = "closeMenuButton.png",
			overFile = "closeMenuButtonD.png"
		}
		fundo.fechar.clicado = false
		fundo.fechar.tipo = "fechar"
		fundo.fechar.anchorX=1
		fundo.fechar.anchorY=0
		fundo.fechar.x = W - 50 + fundo.fechar.width/2
		fundo.fechar.y = 70
		
		if atrib.voltar then
			fundo.voltar = widget.newButton {
				onRelease = fundo.fecharTela,
				emboss = false,
				-- Properties for a rounded rectangle button
				defaultFile = "backButton.png",
				overFile = "backButtonD.png"
			}
			fundo.voltar.tipo = "voltar"
			fundo.voltar.clicado = false
			fundo.voltar.anchorX=0
			fundo.voltar.anchorY=0
			fundo.voltar.x = 50
			fundo.voltar.y = 70
		end
		
		

	end

end

function M.criarListaDePalavras(event,vetor,VarTela)
	local grupoPalavras = display.newGroup()
	local grupoTTS = display.newGroup()
	grupoTTS:insert(VarTela.TTSDicionario.botaoTTS)
	local contexto = event.target.contexto
	function grupoPalavras.fecharTela()
		local somFechar = audio.loadSound("audioTTS_dicionario fechar.MP3")
		audio.play(somFechar)
		auxFuncs.restoreNativeScreenElements(VarTela)
		VarTela.palavraDicHistorico = nil

		historicoLib.Criar_e_salvar_vetor_historico({
			tipoInteracao = "dicionário",
			pagina_livro = VarTela.pagina,
			acao = "fechar dicionário",
			tela = VarTela
		})
		grupoPalavras:removeSelf()
		grupoPalavras=nil
		VarTela.TTSDicionario.botaoTTS.isVisible = false
	end

	grupoPalavras.fechar = widget.newButton {
		onRelease = grupoPalavras.fecharTela,
		emboss = false,
		-- Properties for a rounded rectangle button
		defaultFile = "closeMenuButton.png",
		overFile = "closeMenuButtonD.png"
	}
	grupoPalavras.fechar.clicado = false
	grupoPalavras.fechar.anchorX=1
	grupoPalavras.fechar.anchorY=0
	grupoPalavras.fechar.x = W - 50 + grupoPalavras.fechar.width/2
	grupoPalavras.fechar.y = 100

	local function onRowTouch( event )
		local row = event.row
		if event.phase == "release" then
			M.criarTelaDoDicionario({voltar=true,dicionario = row.params.arquivo,palavra = row.params.palavra,onClose = grupoPalavras.fecharTela,contexto = row.params.contexto,telas = VarTela,objeto_id = row.index},VarTela)
		end
		return true
	end
	local function onRowRender( event )

		-- Get reference to the row group
		local row = event.row

		-- Cache the row "contentWidth" and "contentHeight" because the row bounds can change as children objects are added
		local rowHeight = row.contentHeight
		local rowWidth = row.contentWidth

		if row.index == 1 then
			local rowLine = display.newRect( row, 0,0,row.width,2 )
			rowLine.anchorX=0;rowLine.anchorY=0
			rowLine:setFillColor( 0 )
		end
		local rowTitle = display.newText( row, row.index.." - "..row.params.palavra, 0, 0, nil, 40 )
		rowTitle:setFillColor( 0 )

		-- Align the label left and vertically centered
		rowTitle.anchorX = 0
		rowTitle.x = 5
		rowTitle.y = rowHeight * 0.5
	end

	local bloqueioTela = auxFuncs.TelaProtetiva()
	grupoPalavras:insert(bloqueioTela)
	bloqueioTela.alpha = .8
	bloqueioTela.isHitTestable = true

	local fundo = display.newRoundedRect(0,0,W-100+4,H-200+4,4)
	fundo.strokeWidth = 4
	fundo:setStrokeColor(46/255,171/255,200/255)
	grupoPalavras:insert(fundo)

	local titulo = display.newText("VERBETES",60,105,"Fontes/ariblk.ttf",50)
	titulo:setFillColor(42/255,159/255,183/255)
	titulo.anchorX=0;titulo.anchorY=0
	grupoPalavras:insert(titulo)

	local tableView = widget.newTableView(
		{
			left = 50,
			top = 200,
			height = H-300,
			width = W-100,
			onRowRender = onRowRender,
			onRowTouch = onRowTouch,
			listener = scrollListener,
			rowTouchDelay =0
		}
	)
	fundo.x=tableView.x;fundo.y=tableView.y-50
	grupoPalavras:insert(tableView)

	-- Insert 40 rows
	for i = 1, #vetor do
		local isCategory = false
		local rowHeight = 80
		local rowColor = { default={1,1,1}, over={1,0.5,0,0.2} }
		local lineColor = { 0.5, 0.5, 0.5 }

		-- Make some rows categories
		if ( i%2 == 0 ) then
			--isCategory = true
			--rowHeight = 40
			rowColor = { default={0.7,0.5,0.5,0.5} }
			--lineColor = { 1, 0, 0 }
		end
		-- Insert a row into the tableView
		tableView:insertRow(
			{
				isCategory = isCategory,
				rowHeight = rowHeight,
				rowColor = rowColor,
				lineColor = lineColor,
				params = {palavra = vetor[i][1],arquivo = vetor[i][2],contexto = contextoPalavra}
			}
		)
	end

	historicoLib.Criar_e_salvar_vetor_historico({
		tipoInteracao = "dicionário",
		pagina_livro = VarTela.pagina,
		acao = "abrir dicionário",
		tela = VarTela
	})

	grupoPalavras:insert(grupoPalavras.fechar)

	return grupoPalavras
end

function M.criarDicionarioPagina(pagina,telas,pasta,VarTela,varGlobal)
	local Var = {}
	Var.dicionario = display.newGroup()
	local doc_dir = system.DocumentsDirectory
	local vetor_palavras_e_txts = telas[pagina].dicionario
	local vetorFinalPalavrasTxTs = {}

	local txtArquivos = auxFuncs.lerTextoDoc("dicionario.txt")
	if not txtArquivos then
		txtArquivos = ""
	else
		txtArquivos = string.gsub(txtArquivos,".",{ ["\13"] = "",["\10"] = "\13\10"})
	end
	local is_valid, error_position = validarUTF8.validate(txtArquivos)
	if not is_valid then 
		txtArquivos = conversor.converterANSIparaUTFsemBoom(txtArquivos)
	end
	-- Output lines
	for line in string.gmatch(txtArquivos,"([^\13\10]+)") do
		local arquivo,palavra = string.match(line,"(.+)|||(.+)")
		table.insert(vetorFinalPalavrasTxTs,{palavra,arquivo})
		palavra,arquivo = nil,nil
	end

	function Var.dicionario.abrirPalavras(event)
		if event.target.clicado == false  then
			audio.stop()
			media.stopSound()
			
			local som = audio.loadStream(varGlobal.ttsDicionarioMenuRapido1Clique)
			local timerRequerimento = timer.performWithDelay(16,function() audio.play(som) end,1)
			event.target.clicado = true
			timer.performWithDelay(1000,function() event.target.clicado = false end,1)
			return true
		end
		if event.target.clicado == true  then
			audio.stop()
			event.target.clicado = false
			local somAbrindo = audio.loadSound("audioTTS_dicionario abrir.MP3")
			audio.play(somAbrindo)
			auxFuncs.clearNativeScreenElements(VarTela)
			--print(telas[pagina].dicionarioContexto,#telas[pagina].dicionarioContexto)
			print("criando lista paalvras,",vetorFinalPalavrasTxTs)
			M.criarListaDePalavras(event,vetorFinalPalavrasTxTs,VarTela)
			VarTela.TTSDicionario.botaoTTS.isVisible = true
		end
	end
	Var.dicionario.botao = widget.newButton{
		defaultFile = "botaoDicionario.png",
		overFile = "botaoDicionarioD.png",
		onRelease = Var.dicionario.abrirPalavras,
		width = 80,
		height = 80
	}
	Var.dicionario.botao.clicado = false
	Var.dicionario.botao.contexto = telas[pagina].dicionarioContexto
	Var.dicionario.botao.anchorY=0.5;Var.dicionario.botao.anchorX=0.5
	Var.dicionario:insert(Var.dicionario.botao)
	Var.dicionario.vetorFinalPalavrasTxTs = vetorFinalPalavrasTxTs
	Var.dicionario.vetorPalavrasTxT = vetorPalavrasTxT
	
	Var.dicionario.botaoLRight = display.newImageRect(Var.dicionario,"botaoDicionarioR.png",80,80)
	Var.dicionario.botaoLRight.anchorY=0;Var.dicionario.botaoLRight.anchorX=0
	Var.dicionario.botaoLRight.y = 0--GRUPOGERAL.height+100--Var.proximoY+ 40
	Var.dicionario.botaoLRight.x = 0
	Var.dicionario.botaoLRight.isVisible = false
	
	Var.dicionario.botaoLLeft = display.newImageRect(Var.dicionario,"botaoDicionarioL.png",80,80)
	Var.dicionario.botaoLLeft.anchorY=0;Var.dicionario.botaoLLeft.anchorX=0
	Var.dicionario.botaoLLeft.y = 0--GRUPOGERAL.height+100--Var.proximoY+ 40
	Var.dicionario.botaoLLeft.x = 0
	Var.dicionario.botaoLLeft.isVisible = false
	if Var.dicionario.timerOrientacao then
		timer.cancel(Var.dicionario.timerOrientacao)
		Var.dicionario.timerOrientacao = nil
	end
	Var.dicionario.timerOrientacao = timer.performWithDelay(300,
		function(e) 
			if not Var.dicionario.botao then  
				timer.cancel(Var.dicionario.timerOrientacao)
				Var.dicionario.timerOrientacao = nil
			elseif Var.dicionario.botao then
				if system.orientation == "landscapeRight" then
					Var.dicionario.botao.isVisible = false
					Var.dicionario.botaoLLeft.isVisible = false
					Var.dicionario.botaoLRight.isVisible = true
				elseif system.orientation == "landscapeLeft" then
					Var.dicionario.botao.isVisible = false
					Var.dicionario.botaoLLeft.isVisible = true
					Var.dicionario.botaoLRight.isVisible = false
				else
					Var.dicionario.botao.isVisible = true
					Var.dicionario.botaoLLeft.isVisible = false
					Var.dicionario.botaoLRight.isVisible = false
				end
				Var.dicionario.botao.isHitTestable = true
			end 
		end,-1)

	return Var.dicionario
end
----------------------------------------------------------
--  COLOCAR ANOTAÇÃO E COMENTÁRIO --
----------------------------------------------------------
function M.criarAnotacoesComentarios(pagina,telas,Var,varGlobal)

	Var.anotComInterface = display.newGroup()
	
	Var.anotComInterface.Icone = display.newImageRect(Var.anotComInterface,"anotacao.png",80,80)
	Var.anotComInterface.Icone.anchorY=0;Var.anotComInterface.Icone.anchorX=0
	Var.anotComInterface.Icone.y = 0--GRUPOGERAL.height+100--Var.proximoY+ 40
	Var.anotComInterface.Icone.x = 0
	
	Var.anotComInterface.IconeLRight = display.newImageRect(Var.anotComInterface,"anotacaoR.png",80,80)
	Var.anotComInterface.IconeLRight.anchorY=0;Var.anotComInterface.IconeLRight.anchorX=0
	Var.anotComInterface.IconeLRight.y = 0--GRUPOGERAL.height+100--Var.proximoY+ 40
	Var.anotComInterface.IconeLRight.x = 0
	Var.anotComInterface.IconeLRight.isVisible = false
	
	Var.anotComInterface.IconeLLeft = display.newImageRect(Var.anotComInterface,"anotacaoL.png",80,80)
	Var.anotComInterface.IconeLLeft.anchorY=0;Var.anotComInterface.IconeLLeft.anchorX=0
	Var.anotComInterface.IconeLLeft.y = 0--GRUPOGERAL.height+100--Var.proximoY+ 40
	Var.anotComInterface.IconeLLeft.x = 0
	Var.anotComInterface.IconeLLeft.isVisible = false
	if Var.anotComInterface.timerOrientacao then
		timer.cancel(Var.anotComInterface.timerOrientacao)
		Var.anotComInterface.timerOrientacao = nil
	end
	Var.anotComInterface.timerOrientacao = timer.performWithDelay(300,
		function(e) 
			if not Var.anotComInterface.Icone then  
				timer.cancel(Var.anotComInterface.timerOrientacao)
				Var.anotComInterface.timerOrientacao = nil
			elseif Var.anotComInterface.Icone then
				if system.orientation == "landscapeRight" then
					Var.anotComInterface.Icone.isVisible = false
					Var.anotComInterface.IconeLLeft.isVisible = false
					Var.anotComInterface.IconeLRight.isVisible = true
				elseif system.orientation == "landscapeLeft" then
					Var.anotComInterface.Icone.isVisible = false
					Var.anotComInterface.IconeLLeft.isVisible = true
					Var.anotComInterface.IconeLRight.isVisible = false
				else
					Var.anotComInterface.Icone.isVisible = true
					Var.anotComInterface.IconeLLeft.isVisible = false
					Var.anotComInterface.IconeLRight.isVisible = false
				end
				Var.anotComInterface.Icone.isHitTestable = true
			end 
		end,-1)
	
	--===============================================================================--
	--===============================================================================--
	local alturaRetangulo = 0
	
	
	local function notificacaoMensagemAutor(vetorJson)
		--local telaProtetiva = TelaProtetiva()
	
		local mensagemRespondida = vetorJson.mensagemOutro or nil
		local mensagem = vetorJson.mensagem or nil
		local pagina = vetorJson.pagina or nil
		local apelidoRespondido = vetorJson.apelidoOutro or nil
		--local autor = vetorJson.apelido or nil
		local nomeLivro = vetorJson.nomeLivro or nil
		local idLivro = varGlobal.idLivro1 or nil
		
		
		
		local parameters = {}
		parameters.body = "livro_id=" .. idLivro
		local URL2 = "https://omniscience42.com/EAudioBookDB/lerDadosLeitoresLivro.php"
		print("IDLIVRO = ",idLivro)
		
		local function listenerIDLeitores(event)
			print("||"..tostring(event.response).."||")
			if ( event.isError ) then
				print("Network Error . Check Connection", "Connect to Internet")
				timer.performWithDelay(2000,function()network.request(URL2, "POST", listenerIDLeitores,parameters)end,1)
			else
				local json = require("json")
				--print(event.response)
				local resposta = json.decode(event.response)
				--auxFuncs.overwriteTable( resposta, "table.json" )
				if resposta and resposta.message == "falha" then
					audio.stop()
					local som = audio.loadSound("audioTTS_4_email2.mp3")
					audio.play(som)
				elseif resposta and resposta.message == "sucesso" then
					local vetorEmails = {}
					local vetorApelidos = {}
					print("message = ",resposta.message)
					print("\n")
					for i=1,resposta.nLeitores do
						resposta[i] = resposta[tostring(i)]
						print("EMAIL = ",resposta[i].email_usuario)
						print("APELIDO = ",resposta[i].apelido_usuario)
						print("\n")
						table.insert(vetorEmails,resposta[i].email_usuario)
						table.insert(vetorApelidos,resposta[i].apelido_usuario)
					end
					-- Se Sucesso Mandar os e-mails --
					local vetorJson2 = {}
					vetorJson2.tipoDeAcesso = "notificarMensagemAdmin"
					print("tipo de acesso = ",vetorJson2.tipoDeAcesso)
					
					vetorJson2.mensagemOutro = mensagemRespondida
					vetorJson2.mensagem = mensagem
					vetorJson2.pagina = pagina
					vetorJson2.apelidoOutro = apelidoRespondido
					vetorJson2.nomeLivro = nomeLivro
					vetorJson2.emails = vetorEmails
					vetorJson2.apelidos = vetorApelidos
					
					local headers = {}
					headers["Content-Type"] = "application/json"
					local parameters = {}
					parameters.headers = headers
					local data = json.encode(vetorJson2)
					parameters.body = data
					local URL = "https://omniscience42.com/EAudioBookDB/sendMail.php" --mongo.php"
					
					local function emailListener(event)
						print("|"..tostring(event.response).."|")
						if ( event.isError ) then
							print("Network Error . Check Connection", "Connect to Internet")
							timer.performWithDelay(2000,function() network.request(URL, "POST", emailListener,parameters)end,1)
						else
							print("ENVIADO")
						end
					end

					network.request(URL, "POST", emailListener,parameters)
						
					----------------------------------
				else
					print("Network Error . Check Connection", "Connect to Internet")
					timer.performWithDelay(2000,function()network.request(URL2, "POST", listenerIDLeitores,parameters)end,1)
				end
			end
		end
		
		
		network.request(URL2, "POST", listenerIDLeitores,parameters)
		
	end
	
	Var.anotComInterface.varCtrl = {}
	Var.anotComInterface.varCtrl.anotLida = false
	Var.anotComInterface.varCtrl.mensLida = false
	
	local function criarCampoAnotacao()
		local alturaRetangulo = 0
		local strokeWidth = 0
		
		-- criar Grupo de Máscara para mover
		 
		-- Create the widget
		Var.anotacao.scrollView = widget.newScrollView(
			{
				width = Var.anotacao.rectTop.width-50+strokeWidth*2,
				height = Var.anotComInterface.retanguloFundo.height-200,
				scrollWidth = Var.anotacao.rectTop.width-50+strokeWidth*2,
				scrollHeight = Var.anotComInterface.retanguloFundo.height,
				hideBackground = true,
				horizontalScrollDisabled  = true,
				listener = scrollListener
			}
		)
		Var.anotacao.scrollView.anchorY=0
		Var.anotacao.scrollView.anchorX=0
		Var.anotacao:insert(2,Var.anotacao.scrollView)
		Var.anotacao.scrollView.x = -40
		Var.anotacao.scrollView.y = Var.anotacao.rectTop.y + 2+100
		
		Var.anotacao.retanguloFundo = display.newRoundedRect(strokeWidth,0,Var.anotacao.rectTop.width-50,200,12)
		Var.anotacao.retanguloFundo.strokeWidth = strokeWidth
		Var.anotacao.retanguloFundo:setStrokeColor(0,0,0)
		Var.anotacao.retanguloFundo.anchorX=0;Var.anotacao.retanguloFundo.anchorY=0
		Var.anotacao.retanguloFundo:setFillColor(1,1,1)
		Var.anotacao.scrollView:insert(1,Var.anotacao.retanguloFundo)

		Var.anotacao.erro = nil
		Var.anotacao.vazio = nil
		Var.anotacao.conteudo = nil

		-- verificar se já existe um TXT -----------------------------------
		function Var.anotacao.anotacaoListener( event )
			print("WARNING: COMEÇOU")
			if Var.anotacao and Var.anotComInterface then
				if ( event.isError ) then
					Var.anotacao.conteudo = "Conexão com a internet falhou:"
					Var.anotacao.erro = true
				elseif Var.anotacao then
					local json = require("json")
					print(event.response)
					Var.anotacao.vetorAnotacao = json.decode(event.response)
					if Var.anotacao.vetorAnotacao["vazio"] == true then
						print("TAH VAZIO")
					elseif Var.anotacao.vetorAnotacao["vazio"] == false then
						auxFuncs.criarTxTDoc("anotacaoPagina"..pagina..".txt",Var.anotacao.vetorAnotacao["conteudo"]);
						Var.anotacao.conteudo = Var.anotacao.vetorAnotacao["conteudo"]
						Var.anotacao.idAnotacao = Var.anotacao.vetorAnotacao["idAnotacao"]
						Var.anotacao.vazio = Var.anotacao.vetorAnotacao["vazio"]
						
						Var.anotacao.texto.text = Var.anotacao.vetorAnotacao["conteudo"]
						Var.anotComInterface.Icone.fill.effect = nil
						Var.anotacao.rectTop.fill.effect = nil
						Var.anotacao.texto:setFillColor(0,0,0)
						alturaRetangulo = 0
						alturaRetangulo = Var.anotacao.texto.height + 10
						Var.anotacao.retanguloFundo.height = Var.anotacao.texto.height + 10
						if Var.anotacao.retanguloFundo.height < 200 then 
							Var.anotacao.retanguloFundo.height = 200
						end
						
						if Var.anotacao.retanguloFundo.height <= Var.anotComInterface.retanguloFundo.height-200 then
							Var.anotacao.scrollView:setScrollHeight( Var.anotComInterface.retanguloFundo.height-200 )
						else
							Var.anotacao.scrollView:setScrollHeight( Var.anotacao.retanguloFundo.height + 10 )
						end
						
					end
				end
				Var.anotComInterface.varCtrl.anotLida = true
				Var.anotComInterface.varCtrl.anotCont = Var.anotacao.conteudo
			end
		end
			
		local parameters = {}
		if varGlobal.idLivro1 then
			parameters.body = "consulta=1&idLivro=" .. varGlobal.idLivro1 .. "&pagina=" .. telas.paginaHistorico.."&idUsuario=" .. varGlobal.idAluno1
			--parameters.body = "consulta=1&codigoLivro=" .. varGlobal.codigoLivro1 .. "&pagina=" .. contagemDaPaginaHistorico().."&idUsuario=" .. varGlobal.idAluno1
			local URL2 = "https://omniscience42.com/EAudioBookDB/anotacoes.php"
			if auxFuncs.fileExistsDiretorioBase("anotacaoPagina"..pagina..".txt",system.DocumentsDirectory) then
				local aux = auxFuncs.lerTextoDoc("anotacaoPagina"..pagina..".txt")
				Var.anotacao.conteudo = aux
				Var.anotComInterface.varCtrl.anotLida = true
				Var.anotComInterface.varCtrl.anotCont = Var.anotacao.conteudo
			else
				network.request(URL2, "POST", Var.anotacao.anotacaoListener,parameters)
			end
		end
	
		if auxFuncs.fileExistsDiretorioBase("anotacaoPagina"..pagina..".txt",system.DocumentsDirectory) then
			local aux = auxFuncs.lerTextoDoc("anotacaoPagina"..pagina..".txt")
			Var.anotacao.conteudo = aux
			Var.anotComInterface.varCtrl.anotLida = true
			Var.anotComInterface.varCtrl.anotCont = Var.anotacao.conteudo
		end

		if not Var.anotacao.conteudo then
			Var.anotacao.conteudo = ""
			Var.anotacao.vazio = true
			if Var.anotacao.erro then
				Var.anotacao.conteudo = "Conexão com a internet falhou:"
			end
		end
		--------------------------------------------------------------------
		-- arrumando formatação texto encontrado -> grupoAnotacao
		local posTexto =  Var.anotacao.rectTop.y + Var.anotacao.rectTop.height + 50
		Var.anotacao.texto = {}
		Var.anotacao.grupoAnotacao= display.newGroup()


		Var.anotacao:insert(Var.anotacao.grupoAnotacao)
		Var.anotacao.texto = display.newText(Var.anotacao.conteudo,0,0,Var.anotacao.retanguloFundo.width-10,0,native.systemFont,35)
		Var.anotacao.scrollView:insert(Var.anotacao.texto)
		Var.anotacao.texto:setFillColor(0,0,0)
		Var.anotacao.texto.anchorY=0;Var.anotacao.texto.anchorX=0
		Var.anotacao.texto.y = 0
		Var.anotacao.texto.x = 5
		alturaRetangulo = Var.anotacao.texto.height + 10
		Var.anotacao.retanguloFundo.height = alturaRetangulo
		if alturaRetangulo < 200 then 
			Var.anotacao.retanguloFundo.height = 200
		end
		if Var.anotacao.retanguloFundo.height <= Var.anotComInterface.retanguloFundo.height-200 then
			Var.anotacao.scrollView:setScrollHeight( Var.anotComInterface.retanguloFundo.height-200 )
		else
			Var.anotacao.scrollView:setScrollHeight( Var.anotacao.retanguloFundo.height )
		end
		-- se existe erro então criar botão de tentar novamente --s
		if Var.anotacao.vazio or Var.anotacao.erro then
			Var.anotacao.texto:setFillColor(.2,.2,.2)
			Var.anotacao.texto.size = 30
			if Var.anotacao.erro then
			
			else
				-- se for vazio deixar cor cinza --
			end
		end
		local function janelaDeAnotacao()
			print("janela")
			
			local telaProtetiva = auxFuncs.TelaProtetiva()
			telaProtetiva.alpha = .8
			local function textListener( event )
 
				if ( event.phase == "began" ) then
					-- User begins editing "defaultBox"
		 
				elseif ( event.phase == "ended" or event.phase == "submitted" ) then
					-- Output resulting text from "defaultBox"
					print( event.target.text )
		 
				elseif ( event.phase == "editing" ) then
					print( event.newCharacters )
					print( event.oldText )
					print( event.startPosition )
					print( event.text )
				end
			end
			-- Create text box
			local defaultBox = native.newTextBox( W/2, 10 + 3*W/8, 9*W/10, 3*W/4 )
			defaultBox.placeHolder = "coloque sua anotação aqui."
			defaultBox.text = Var.anotacao.texto.text
			defaultBox.isEditable = true
			defaultBox.size = 25
			defaultBox:addEventListener( "userInput", textListener )
			defaultBox.hasBackground = false
			native.setKeyboardFocus( defaultBox )
			local fundoTextBox = display.newImageRect("campoEditar.png",9*W/10 ,3*W/4)
			fundoTextBox.anchorY=0.5
			fundoTextBox.anchorX=0.5
			fundoTextBox.x = defaultBox.x
			fundoTextBox.y = defaultBox.y
			local cancelar
			local salvar = widget.newButton(
			{
				top = defaultBox.y + defaultBox.height/2 + 20,
				left = defaultBox.x - defaultBox.width/2 ,
				shape = "roundedRect",
				label = "salvar",
				labelAlign = "center",
				labelColor = { default={ 0, 0, 0 }, over={ 1, 1, 1, 0.5 } },
				font = "Fontes/paolaAccent.ttf",
				fontSize = 40,
				onRelease = function(e)
								native.setKeyboardFocus( nil );
								auxFuncs.criarTxTDoc("anotacaoPagina"..pagina..".txt",defaultBox.text);
								Var.anotComInterface.varCtrl.anotLida = true
								Var.anotComInterface.varCtrl.anotCont = defaultBox.text
								if Var.botaoTTSAnotComentarios then
									Var.botaoTTSAnotComentarios:removeSelf()
									Var.botaoTTSAnotComentarios = nil
									Var.anotComInterface.varCtrl.criarBotaoTTSAux()
								end
								cancelar:removeSelf()
								defaultBox:removeSelf()
								fundoTextBox:removeSelf()
								e.target:removeSelf()
								telaProtetiva:removeSelf()
								Var.anotacao.texto.text = defaultBox.text
								Var.anotComInterface.Icone.fill.effect = nil
								Var.anotacao.rectTop.fill.effect = nil
								alturaRetangulo = Var.anotacao.texto.height + 10
								Var.anotacao.retanguloFundo.height = alturaRetangulo
								if alturaRetangulo < 200 then 
									Var.anotacao.retanguloFundo.height = 200
								end
								if alturaRetangulo <= Var.anotComInterface.retanguloFundo.height-200 then
									Var.anotacao.scrollView:setScrollHeight( Var.anotComInterface.retanguloFundo.height-200 )
								else
									Var.anotacao.scrollView:setScrollHeight( alturaRetangulo )
								end
								Var.anotacao.scrollView:scrollToPosition{y = 0}
								if telas.ativarLogin == "sim" then
									local subPagina = telas.subPagina
									historicoLib.Criar_e_salvar_vetor_historico({
										tipoInteracao = "anotacao",
										pagina_livro = telas.pagina,
										objeto_id = nil,
										acao = "criar anotação",
										subPagina = subPagina,
										tela = telas
									})
									
									local parameters = {}
									parameters.body = "Criar=1&idLivro=" .. varGlobal.idLivro1  .. "&idUsuario=" .. varGlobal.idAluno1 .. "&pagina=" .. telas.paginaHistorico .. "&conteudo=" .. defaultBox.text .. "&situacao=" .. "A"
									local URL2 = "https://omniscience42.com/EAudioBookDB/anotacoes.php"
									network.request(URL2, "POST", 
										function(event)
											if ( event.isError ) then
												native.showAlert("Falha no envio","Sua anotação não pôde ser enviada para a nuvem, verifique sua conexão com a internet e tente editar e salvar a anotação novamente para que seja salva na nuvem",{"OK"})
											else
												print("WARNING: IdAnotacao = ",event.response)
												Var.anotacao.idAnotacao = event.response
											end
										end,parameters)
								end
							end,
				width = 200,
				height = 50,
				fillColor = { default={ 0.18, 0.67, 0.785, 1 }, over={ 0.004, 0.368, 0.467, 1 } },
				strokeColor = { default={ 0, 0, 0 }, over={ 0, 0, 0,.7 } },
				strokeWidth = 2,
				cornerRadius = 2
			})
		
			cancelar = widget.newButton(
			{
				top = defaultBox.y + defaultBox.height/2 + 20,
				left = defaultBox.x + defaultBox.width/2 - 200,
				shape = "roundedRect",
				label = "cancelar",
				labelAlign = "center",
				labelColor = { default={ 0, 0, 0 }, over={ 1, 1, 1, 0.5 } },
				font = "Fontes/paolaAccent.ttf",
				fontSize = 40,
				onRelease = function(e)
								native.setKeyboardFocus( nil );
								salvar:removeSelf()
								defaultBox:removeSelf()
								fundoTextBox:removeSelf()
								e.target:removeSelf()
								telaProtetiva:removeSelf()
							end
				,
				width = 200,
				height = 50,
				fillColor = { default={ 0.9, 0.2, 0.1, 1 }, over={ 0.7, 0.02, 0.01, 1 } },
				strokeColor = { default={ 0, 0, 0 }, over={ 0, 0, 0,.7 } },
				strokeWidth = 2,
				cornerRadius = 2
			})
		end
	
		Var.anotacao.editar = widget.newButton(
		{
			shape = "roundedRect",
			label = "editar",
			labelAlign = "center",
			labelColor = { default={ 0, 0, 0 }, over={ 1, 1, 1, 0.5 } },
			font = "Fontes/paolaAccent.ttf",
			fontSize = 30,
			onRelease = janelaDeAnotacao,
			width = Var.anotComInterface.retanguloFundo.width/5,
			height = 40,
			fillColor = { default={ 0.18, 0.67, 0.785, 1 }, over={ 0.004, 0.368, 0.467, 1 } },
			strokeColor = { default={ 0, 0, 0 }, over={ 0, 0, 0,.7 } },
			strokeWidth = 0,
			cornerRadius = 2
		})-- FALTA ATUALIZAR QUANDO MUDAR ABA!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
		Var.anotacao.editar.anchorX = 1
		Var.anotacao.editar.anchorY = 1
		Var.anotacao.editar.y = Var.anotComInterface.retanguloFundo.y + Var.anotComInterface.retanguloFundo.height - 40
		Var.anotacao.editar.x = W/2 - 250
		Var.anotacao.grupoAnotacao:insert(Var.anotacao.editar)
	
		Var.anotacao.editar.lapis = display.newImageRect(Var.anotacao.grupoAnotacao,"editPencil.png",40,50)
		Var.anotacao.editar.lapis.rotation = 10
		Var.anotacao.editar.lapis.anchorX=1;Var.anotacao.editar.lapis.anchorY=1
		Var.anotacao.editar.lapis.x = Var.anotacao.editar.x + Var.anotacao.editar.lapis.width/2
		Var.anotacao.editar.lapis.y = Var.anotacao.editar.y -- 10

		local function onComplete(e)
			if e.index == 1 then
				os.remove(system.pathForFile("anotacaoPagina"..pagina..".txt",system.DocumentsDirectory))
				Var.anotComInterface.varCtrl.anotLida = true
				Var.anotComInterface.varCtrl.anotCont = ""
				if Var.botaoTTSAnotComentarios then
					Var.botaoTTSAnotComentarios:removeSelf()
					Var.botaoTTSAnotComentarios = nil
					Var.anotComInterface.varCtrl.criarBotaoTTSAux()
				end
				Var.anotacao.texto.text = ""
				Var.anotacao.retanguloFundo.height = 200
				if Var.anotacao.retanguloFundo.height <= Var.anotComInterface.retanguloFundo.height-200 then
					Var.anotacao.scrollView:setScrollHeight( Var.anotComInterface.retanguloFundo.height-200 )
				else
					Var.anotacao.scrollView:setScrollHeight( Var.anotacao.retanguloFundo.height )
				end
				Var.anotacao.scrollView:scrollToPosition{y = 0}
				alturaRetangulo = 0
				if Var.anotacao.idAnotacao then
					local parameters = {}
					parameters.body = "Excluir=1&anotacao_id="..Var.anotacao.idAnotacao
					local URL2 = "https://omniscience42.com/EAudioBookDB/anotacoes.php"
					network.request(URL2, "POST", 
						function(event)
							if ( event.isError ) then
								native.showAlert("Falha na conexão","Sua anotação não pôde ser excluída da nuvem, verifique sua conexão com a internet e tente excluir a anotação novamente",{"OK"})
							else
								local subPagina = telas.subPagina
								historicoLib.Criar_e_salvar_vetor_historico({
									tipoInteracao = "anotacao",
									pagina_livro = telas.pagina,
									objeto_id = nil,
									acao = "excluir anotação",
									subPagina = subPagina,
									tela = telas
								})
							end
						end,parameters)
				end
			end
		end
		Var.anotacao.apagar = widget.newButton(
		{
			shape = "roundedRect",
			label = "apagar",
			labelAlign = "center",
			labelColor = { default={ 0, 0, 0 }, over={ 1, 1, 1, 0.5 } },
			font = "Fontes/paolaAccent.ttf",
			fontSize = 30,
			onRelease = function(e)
							native.showAlert("Atenção!","Tem certeza de que deseja apagar esse comentário? Essa ação não pode ser desfeita!",{"OK","Cancelar"},onComplete)
						end,
			width = Var.anotComInterface.retanguloFundo.width/5,
			height = 40,
			fillColor = { default={ 0.9, 0.2, 0.1, 1 }, over={ 0.7, 0.02, 0.01, 1 } },
			strokeColor = { default={ 0, 0, 0 }, over={ 0, 0, 0,.7 } },
			strokeWidth = 0,
			cornerRadius = 2
		})
		Var.anotacao.apagar.anchorX = 0
		Var.anotacao.apagar.anchorY = 1
		Var.anotacao.apagar.y = Var.anotComInterface.retanguloFundo.y + Var.anotComInterface.retanguloFundo.height - 40
		Var.anotacao.apagar.x = W/2
		Var.anotacao.grupoAnotacao:insert(Var.anotacao.apagar)
	
		Var.anotacao.apagar.borracha = display.newImageRect(Var.anotacao.grupoAnotacao,"eraser.png",30,38)
		Var.anotacao.apagar.borracha.rotation = 10
		Var.anotacao.apagar.borracha.anchorX=0;Var.anotacao.apagar.borracha.anchorY=1
		Var.anotacao.apagar.borracha.x = Var.anotacao.apagar.x + Var.anotacao.apagar.width - Var.anotacao.apagar.borracha.width/2
		Var.anotacao.apagar.borracha.y = Var.anotacao.apagar.y - 5
		
	end

	local function criarCampoComentario(idContato)
		
		local strokeWidth = 2
		local dadosAutor = {}
		local switch = require("newSwitch")
		
		local distanciaScroll = 150
		local alturaScroll = 830
		
		-- pegando dados do autor:
		local function pegarDadosIDAux(idContato)
			local function pegarDadosID(event)
				if ( event.isError ) then
					print("Error??")
				elseif dadosAutor then
					local json = require("json")
					print("PEGOU!",event.response)
					dadosAutor = json.decode(event.response)
				end
			end
			local parameters = {}
			parameters.body = "usuario_id=" .. idContato
			local URL2 = "https://omniscience42.com/EAudioBookDB/lerDadosUsuario.php"
			network.request(URL2, "POST",pegarDadosID,parameters)
		end
		
		pegarDadosIDAux(idContato)
		
		
		Var.comentario.erro = nil
		Var.comentario.vazio = nil
		Var.comentario.conteudo = nil
		Var.comentario.gruposComentarios = display.newGroup()
		Var.comentario.remetente = idContato
		
		Var.comentario.vetorComentarios = {}
		Var.comentario.vetorComentarios.erro = nil
		Var.comentario.vetorComentarios.vazio = nil
		Var.comentario.vetorComentarios.comentarios = {}
		Var.comentario.vetorComentarios.conteudo = {}
		Var.comentario.vetorComentarios.usuarioID = {}
		Var.comentario.vetorComentarios.imagemPerfil = {}
		Var.comentario.vetorComentarios.usuarioNome = {}
		Var.comentario.vetorComentarios.curtidasComentario = {}
		Var.comentario.vetorComentarios.comentarioFilho = {}
		Var.comentario.vetorComentarios.comentarioPai = {}

		local alturaRetanguloComment = 0
		
		Var.comentario.vetorPrinc = {}
		Var.comentario.vetorSec = {}
		Var.comentario.respostaAberta = false
		local Secundario = nil
		local protetorTelaParaLoading = auxFuncs.TelaAguarde()
		protetorTelaParaLoading.alpha = .5
		local function criarBaloesDeComentarios(vetorComentarios,diminuirParaResposta,eventResp)
			local textoComentarios = {}
			local grupoComentario = {}
			local diminuir = 0
			-- olhar se está criando balões de resposta --
			if diminuirParaResposta then
				diminuir = diminuirParaResposta
			end
			
			if eventResp then
				Secundario = eventResp.target
				Secundario.altura = 0
			else
				Secundario = nil
			end
			----------------------------------------------
			for i=1,#vetorComentarios do
				print("vetorComentarios[i].usuarioID",vetorComentarios[i].IDUnico)--.usuarioID)
				local bordasY = 100
				
				
				grupoComentario[i] = display.newGroup()
				
				local posTexto =  0--Var.anotacao.rectTop.y + Var.anotacao.rectTop.height + 20
				--print("posTexto!!!",posTexto, Var.anotacao.rectTop.y)
				if Secundario then
					posTexto =  Secundario.y + Secundario.height - 20
					local sv=Var.comentario.scrollView:getView() Var.comentario.scrollView:setScrollHeight(sv.contentHeight+ Secundario.height+100)
			
				end
				if i > 1 then
					posTexto = textoComentarios[i-1].y - bordasY/2 + grupoComentario[i-1].height + 10
				end
				
				grupoComentario[i].numero = i
				grupoComentario[i].x = grupoComentario[i].x + diminuir
				textoComentarios[i] = display.newText(grupoComentario[i],vetorComentarios[i].conteudo,0,0,Var.anotComInterface.retanguloFundo.width-20 - diminuir - 10,0,native.systemFont,35)
				print(vetorComentarios[i].conteudo)
				textoComentarios[i]:setFillColor(0,0,0)
				textoComentarios[i].anchorY=0;textoComentarios[i].anchorX=0
				textoComentarios[i].y = posTexto
				textoComentarios[i].x = 0--Var.anotacao.rectTop.x + 20
				-- se existe erro então criar botão de tentar novamente --s
				if vetorComentarios.vazio or vetorComentarios.erro then
					textoComentarios[i]:setFillColor(.2,.2,.2)
					textoComentarios[i].size = 30
				else
					-- criar barra comentador -- inserir em: grupoComentario[i]
					
					local altura = textoComentarios[i].height + bordasY
					local x = 0--Var.anotacao.rectTop.x +20
					
					-- FUNDO DO COMENTÁRIO
					grupoComentario[i].retanguloFundoBranco = display.newRoundedRect(x,posTexto,Var.anotComInterface.retanguloFundo.width-20 - diminuir - 10,altura,6)
					grupoComentario[i].retanguloFundoBranco.anchorX=0
					grupoComentario[i].retanguloFundoBranco.anchorY=0
					grupoComentario[i]:insert(1,grupoComentario[i].retanguloFundoBranco)
					if Var.comentario.vetorComentarios[i].usuarioID == varGlobal.idAluno1 then
						grupoComentario[i].retanguloFundoBranco:setFillColor(1,0.9,0.7)
					end
					-- INTERFACE (Avatar,apelido e data)
					-- baixar e colocar o avatar --
					grupoComentario[i].avatarNome = vetorComentarios[i].Imagem
					grupoComentario[i].jaCurtiu = vetorComentarios[i].jaCurtiu
					print("WARNING: NOVO")
					local protetorTelaParaBaixar = auxFuncs.TelaAguarde()
					protetorTelaParaBaixar.alpha = 0
					protetorTelaParaBaixar.isHitTestable = true
					
					local function aposBaixarAvatar(event)
						if ( event.isError ) then
							print( "Network error - download failed: ", event.response )
							
							if protetorTelaParaBaixar then 
								protetorTelaParaBaixar:removeSelf(); 
								protetorTelaParaBaixar = nil 
							end
						elseif ( event.phase == "began" ) then
							print( "Progress Phase: began" )
						elseif ( event.phase == "ended" ) then
							if protetorTelaParaBaixar then 
								protetorTelaParaBaixar:removeSelf(); 
								protetorTelaParaBaixar = nil 
							end
							print( "Displaying response image file" )
							--timer.performWithDelay(10,
							--function()
							--if jaAbriu == false then
								if grupoComentario and grupoComentario[i] and Var.comentario and grupoComentario[i].avatarNome  then
									
									grupoComentario[i].idComentario = vetorComentarios[i].comentarioID
									grupoComentario[i].idPai = vetorComentarios[i].pai

									grupoComentario[i].avatar = display.newImageRect(grupoComentario[i].avatarNome,system.TemporaryDirectory,(bordasY/2)-2,(bordasY/2)-2)
									grupoComentario[i].avatar.x = x + 5
									grupoComentario[i].avatar.y = posTexto + 1
									grupoComentario[i].avatar.anchorX=0
									grupoComentario[i].avatar.anchorY=0
									if grupoComentario[i] and grupoComentario[i].avatar then
										grupoComentario[i]:insert(grupoComentario[i].avatar)
									end

									grupoComentario[i].avatar2 = display.newImageRect("avatar.png",(bordasY/2)-2,(bordasY/2)-2)
									grupoComentario[i].avatar2.x = x + 5
									grupoComentario[i].avatar2.y = posTexto + 1
									grupoComentario[i].avatar2.anchorX=0
									grupoComentario[i].avatar2.anchorY=0
									grupoComentario[i]:insert(grupoComentario[i].avatar2)

									-- colocar o apelido --
									local textoAvatar = vetorComentarios[i].apelido
									if textoAvatar then
										grupoComentario[i].avatarTexto = display.newText(textoAvatar,grupoComentario[i].avatar.x + grupoComentario[i].avatar.width + 5,grupoComentario[i].avatar.y + grupoComentario[i].avatar.height/2,"Fontes/segoeui.ttf",27)
										grupoComentario[i].avatarTexto.anchorX=0
										grupoComentario[i].avatarTexto.anchorY=0.5
										grupoComentario[i]:insert(grupoComentario[i].avatarTexto)
										grupoComentario[i].avatarTexto:setFillColor(.3,.3,.3)
									end
									local function abrirMenuRapido(eventP)
										if Var.comentario.telaProtetiva then
											Var.comentario.telaProtetiva:removeSelf()
											Var.comentario.telaProtetiva = nil
										end
										Var.comentario.telaProtetiva = display.newRect(0,0,W*2,H*2)
										Var.comentario.telaProtetiva.alpha=.2
										Var.comentario.telaProtetiva.isHitTestable = true
										Var.comentario.telaProtetiva.anchorX=0.5;Var.comentario.telaProtetiva.anchorY=0.5
										Var.comentario.telaProtetiva:addEventListener("tap",function(e)Var.comentario.MenuRapido:removeSelf();Var.comentario.telaProtetiva:removeSelf();Var.comentario.telaProtetiva = nil;return true; end)
										Var.comentario.telaProtetiva:addEventListener("touch",function() return true; end)
									
										local escolhas = {"copiar"}
										if vetorComentarios[i].usuarioID == varGlobal.idAluno1 then
											table.insert(escolhas,"excluir")
										end
										local function AoExcluirComentario(event)
											if ( event.isError ) then
												print( "Network error - download failed: ", event.response )
												native.showAlert("Conexão Instável","Não foi possível excluir o comentário devido a uma falha na conexão com a internet.",{"ok"})
											elseif ( event.phase == "began" ) then
												print( "Progress Phase: began" )
											elseif ( event.phase == "ended" ) then
												print(event.response)
												
												local subPagina = telas.subPagina
												historicoLib.Criar_e_salvar_vetor_historico({
													tipoInteracao = "comentário",
													pagina_livro = telas.pagina,
													objeto_id = grupoComentario[i].idComentario,
													acao = "excluir comentário",
													conteudo = textoComentarios[i].text,
													id_Comentario = grupoComentario[i].idComentario,
													subPagina = subPagina,
													tela = telas
												})
												
												Var.comentario.atualizarComentarios()
											end
										end
										local function rodarOpcao(e)
											Var.comentario.telaProtetiva:removeSelf()
											Var.comentario.telaProtetiva = nil
											Var.comentario.MenuRapido:removeSelf()
											Var.comentario.MenuRapido = nil
											if e.target.params.tipo == "copiar" then
												print("copiou")
												--local pasteboard = require( "plugin.pasteboard" )
												--pasteboard.copy( "string", tostring(textoComentarios[i].text) )
											elseif e.target.params.tipo == "excluir" then
												print("excluiu")
												local function onComplete(e)
													if e.index == 1 then
														print("cancelou exclusão")
													elseif e.index == 2 then
														parameters.body = "Excluir=1&codigoLivro=" .. varGlobal.codigoLivro1  .. "&idUsuario=" .. varGlobal.idAluno1 .. "&idComentario=" .. grupoComentario[i].idComentario
														local URL2 = "https://omniscience42.com/EAudioBookDB/mensagens.php"
														network.request(URL2, "POST", AoExcluirComentario,parameters)
													end
												end
												native.showAlert("Atenção!","Tem certeza que quer excluir a sua mensagem?\nEssa ação não pode ser desfeita.",{"cancelar","confirmar"},onComplete)
											end
										end
										local escolhasGerais = {}
										for i=1,#escolhas do
											table.insert(escolhasGerais,
											{
												listener = rodarOpcao,
												tamanho = 40,
												texto = escolhas[i],
												cor = {.9,.9,.9},
												params = {tipo = escolhas[i]},
												cor = {37/225,185/225,219/225},
											})
											if escolhas[i] == "copiar" then
												escolhasGerais[#escolhasGerais].iconeEsq =  {imagem = "copiar.png"}
											elseif escolhas[i] == "excluir" then
												escolhasGerais[#escolhasGerais].iconeEsq =  {imagem = "deletar.png"}
											end
										end
										Var.comentario.MenuRapido = MenuRapido.New(
											{
											escolhas = escolhasGerais,
											rowWidthGeneric = 200,
											rowHeightGeneric = 50,
											tamanhoTexto = 30,
											telaProtetiva = "nao"
											}
										)

										--Var.imagens[ims].MenuRapido.x = event.x
										--Var.imagens[ims].MenuRapido.y = event.y - GRUPOGERAL.y
										local posicaoScrollX, posicaoScrollY = Var.comentario.scrollView:getContentPosition()
										Var.comentario.MenuRapido.x = grupoComentario[i].botaoOpcoes.x
										Var.comentario.MenuRapido.y = grupoComentario[i].y + grupoComentario[i].botaoOpcoes.y + posicaoScrollY+ 200-diminuir
										--print(eventP.target.y,Var.anotComInterface.y)
										Var.comentario.MenuRapido.anchorY=0
										Var.comentario.MenuRapido.anchorX=1
										if Var.comentario.MenuRapido.x + Var.comentario.MenuRapido.width > W and system.orientation == "portrait" then
											Var.comentario.MenuRapido.x = eventP.x - Var.comentario.MenuRapido.width
										end
										if system.orientation == "landscapeLeft" then
											Var.comentario.MenuRapido.y = grupoComentario[i].botaoOpcoes.y + grupoComentario[i].botaoOpcoes.height/2
											Var.comentario.MenuRapido.x = grupoComentario[i].botaoOpcoes.x
										elseif system.orientation == "landscapeRight" then
											Var.comentario.MenuRapido.y = grupoComentario[i].botaoOpcoes.y + grupoComentario[i].botaoOpcoes.height/2
											Var.comentario.MenuRapido.x = grupoComentario[i].botaoOpcoes.x
										end
										
									end
									local botaoOpcaoX = grupoComentario[i].retanguloFundoBranco.x + grupoComentario[i].retanguloFundoBranco.width - 10
									--print("botaoOpcaoX",botaoOpcaoX)
									local botaoOpcaoY = grupoComentario[i].avatar.y + grupoComentario[i].avatar.height/2
									grupoComentario[i].botaoOpcoes = display.newImageRect("optionComment.png",50,40)
									grupoComentario[i].botaoOpcoes.anchorX=1
									grupoComentario[i].botaoOpcoes.x = botaoOpcaoX
									grupoComentario[i].botaoOpcoes.y = botaoOpcaoY
									grupoComentario[i]:insert(grupoComentario[i].botaoOpcoes)
									grupoComentario[i].botaoOpcoes:addEventListener("tap",abrirMenuRapido)
									
									local dataComentario = vetorComentarios[i].data
									if dataComentario then
										grupoComentario[i].comentarioData = display.newText(dataComentario,grupoComentario[i].botaoOpcoes.x - grupoComentario[i].botaoOpcoes.width - 10,botaoOpcaoY,"Fontes/segoeui.ttf",25)
										grupoComentario[i].comentarioData.anchorX=1
										grupoComentario[i].comentarioData.anchorY=0.5
										grupoComentario[i]:insert(grupoComentario[i].comentarioData)
										grupoComentario[i].comentarioData:setFillColor(.3,.3,.3)
									end
									if not Secundario then
										grupoComentario[i].opcoes = widget.newButton(
										{
											defaultFile = "responder.png",
											overFile = "responder.png",
											id = grupoComentario[i].idComentario,
											onRelease = Var.comentario.criarComentario
										})
										--grupoComentario[i].opcoes.alpha = .5
										grupoComentario[i].opcoes.params = {email = vetorComentarios[i].email,apelidoOutro = vetorComentarios[i].apelido,pagina = telas.paginaHistorico,apelido = varGlobal.apelidoLogin1,mensagemOutro = textoComentarios[i].text,nomeLivro = varGlobal.nomeLivro1}
										grupoComentario[i].opcoes.height = 40
										grupoComentario[i].opcoes.width = 55
										grupoComentario[i].opcoes.x = grupoComentario[i].retanguloFundoBranco.x + grupoComentario[i].retanguloFundoBranco.width - 5
										grupoComentario[i].opcoes.y = grupoComentario[i].retanguloFundoBranco.y + grupoComentario[i].retanguloFundoBranco.height - 2
										grupoComentario[i].opcoes.anchorX=1
										grupoComentario[i].opcoes.anchorY=1
										grupoComentario[i].opcoes.id = grupoComentario[i].idComentario
										grupoComentario[i]:insert(grupoComentario[i].opcoes)
									end
									
									print("SELO??",varGlobal.idProprietario1,vetorComentarios[i].usuarioID)
									local distanciaX =  grupoComentario[i].retanguloFundoBranco.x + grupoComentario[i].retanguloFundoBranco.width - 5
									local distanciaW = -30
									if grupoComentario[i].opcoes then
										distanciaX = grupoComentario[i].opcoes.x
										distanciaW = grupoComentario[i].opcoes.width
									end
									if varGlobal.idProprietario1 == vetorComentarios[i].usuarioID then
										
										grupoComentario[i].seloDoAutor = display.newImageRect("comentarioAutor.png",140-17.5,40-5)
										grupoComentario[i].seloDoAutor.x = distanciaX - distanciaW - 30
										grupoComentario[i].seloDoAutor.y = grupoComentario[i].retanguloFundoBranco.y + grupoComentario[i].retanguloFundoBranco.height - 2
										grupoComentario[i].seloDoAutor.anchorX=1
										grupoComentario[i].seloDoAutor.anchorY=1
										grupoComentario[i].seloDoAutor.alpha = .9
										grupoComentario[i]:insert(grupoComentario[i].seloDoAutor)
									end
									if not Secundario then
										local function MostrarEsconderRespostas(event)
											if vetorComentarios[i].filhos.aberto == false then
												if Secundario and Var.comentario.respostaAberta == true then
													for k=1,#Var.comentario.vetorPrinc do
														if Secundario.numero == k then
															grupoComentario[k].botaoRespostas:setLabel("Respostas ("..#vetorComentarios[k].filhos..") ↓")
															vetorComentarios[k].filhos.aberto = false
														end
														if Secundario.numero < k then
															Var.comentario.vetorPrinc[k].y = Var.comentario.vetorPrinc[k].y - Secundario.altura
														end
													end
													for k=1,#Var.comentario.vetorSec do
														Var.comentario.vetorSec[k]:removeSelf()
														Var.comentario.vetorSec[k] = nil
													end
													Var.comentario.vetorSec = {}
													Secundario = nil
												end
												vetorComentarios[i].filhos.numero = i
												criarBaloesDeComentarios(vetorComentarios[i].filhos,50,event)
												grupoComentario[i].botaoRespostas:setLabel("Respostas ("..#vetorComentarios[i].filhos..") ↑")
												vetorComentarios[i].filhos.aberto = true
												Var.comentario.respostaAberta = true
												local sv=Var.comentario.scrollView:getView() Var.comentario.scrollView:setScrollHeight(sv.contentHeight+50)
												
											elseif vetorComentarios[i].filhos.aberto == true then

												grupoComentario[i].botaoRespostas:setLabel("Respostas ("..#vetorComentarios[i].filhos..") ↓")
												vetorComentarios[i].filhos.aberto = false
												for i=1,#Var.comentario.vetorPrinc do
													if Secundario.numero < i then
														Var.comentario.vetorPrinc[i].y = Var.comentario.vetorPrinc[i].y - Secundario.altura
													end
												end
												for i=1,#Var.comentario.vetorSec do
													Var.comentario.vetorSec[i].avatarNome = nil
													Var.comentario.vetorSec[i]:removeSelf()
													Var.comentario.vetorSec[i] = nil
												end
												Var.comentario.vetorSec = {}
												Var.comentario.respostaAberta = false
												
												local sv=Var.comentario.scrollView:getView() Var.comentario.scrollView:setScrollHeight(sv.contentHeight+50)
												
											end
										end
										-- verificar se há filhos e colocar botão de filhos
										if vetorComentarios[i].filhos and #vetorComentarios[i].filhos > 0 then
											grupoComentario[i].botaoRespostas = widget.newButton(
											{
												--shape = "RoundedRect",
												--fillColor = { default={ 1, 0.2, 0.5, 0.7 }, over={ 1, 0.2, 0.5, 1 } },
												textOnly = true,
												labelColor = { default={ .45, .45, .45 }, over={ .8, .8, .8 } },
												font = "Fontes/arial.ttf",
												fontSize  = 27,
												label = "Respostas ("..#vetorComentarios[i].filhos..") ↓",--↓▼
												onRelease = MostrarEsconderRespostas,
											})
											grupoComentario[i].botaoRespostas.anchorX=0
											grupoComentario[i].botaoRespostas.anchorY=1
											grupoComentario[i].botaoRespostas.y = grupoComentario[i].retanguloFundoBranco.y + grupoComentario[i].retanguloFundoBranco.height - 2
											grupoComentario[i].botaoRespostas.x = x + 5
											grupoComentario[i].botaoRespostas.numero = i
											grupoComentario[i]:insert(grupoComentario[i].botaoRespostas)
										else
											grupoComentario[i].botaoRespostas = display.newText("Não há respostas",0,0,"Fontes/arial.ttf",27)
											grupoComentario[i].botaoRespostas:setFillColor(.45,.45,.45)
											grupoComentario[i].botaoRespostas.anchorX=0
											grupoComentario[i].botaoRespostas.anchorY=1
											grupoComentario[i].botaoRespostas.y = grupoComentario[i].retanguloFundoBranco.y + grupoComentario[i].retanguloFundoBranco.height - 2
											grupoComentario[i].botaoRespostas.x = x + 5
											grupoComentario[i]:insert(grupoComentario[i].botaoRespostas)
										end
									end
								end
							--jaAbriu = true
							--end
							--end,1)
						end
					end
					if grupoComentario[i].avatarNome then
						local params = {}
						params.progress = true
						--"https://www.coronasdkgames.com/libEA 2"
						auxFuncs.downloadArquivo(grupoComentario[i].avatarNome,"https://livrosdic.s3.us-east-2.amazonaws.com/perfil",aposBaixarAvatar)
					else
						if protetorTelaParaBaixar then 
							protetorTelaParaBaixar:removeSelf(); 
							protetorTelaParaBaixar = nil 
						end
					end
					
					-- Reorganizando localização do comentário
					textoComentarios[i].y = textoComentarios[i].y + bordasY/2
					
				end
				if Secundario then
					Secundario.altura = Secundario.altura + grupoComentario[i].height + 10
					table.insert(Var.comentario.vetorSec,grupoComentario[i])
				else
					table.insert(Var.comentario.vetorPrinc,grupoComentario[i])
				end
				----------------------------------------------------------s
				Var.comentario.scrollView:insert(grupoComentario[i])
				--Var.comentario.gruposComentarios:insert(grupoComentario[i])
				alturaRetanguloComment = Var.comentario.gruposComentarios.height + 25
				if not Secundario then
					
					sv=Var.comentario.scrollView:getView() 
					Var.comentario.scrollView:setScrollHeight(sv.contentHeight+50)
				end
			end
			if Secundario then
				for i=1,#Var.comentario.vetorPrinc do
					if Secundario.numero < i then
						Var.comentario.vetorPrinc[i].y = Var.comentario.vetorPrinc[i].y + Secundario.altura
					end
				end
				local sv=Var.comentario.scrollView:getView(); Var.comentario.scrollView:setScrollHeight(sv.contentHeight+50)
			end
			local espaco = display.newRect(grupoComentario[#grupoComentario].x,grupoComentario[#grupoComentario].y+grupoComentario[#grupoComentario].height,1,300)
			espaco.alpha=0
			Var.comentario.scrollView:insert(espaco)
			local sv=Var.comentario.scrollView:getView(); Var.comentario.scrollView:setScrollHeight(sv.contentHeight+50)
			Var.comentario.scrollView:scrollTo( "bottom", { time=0 } )
			if Var.comentario.vetorComentarios.vazio == true or sv.contentHeight < Var.comentario.scrollView.height then
				Var.comentario.scrollView:scrollTo( "top", { time=0 } )
			end
		end
		function Var.comentario.criarComentario(event)
			
			local acrescentar = ""
			if event and event.target.id then
				print("event.target.id",event.target.id)
				acrescentar = "&idComentario="..event.target.id
			end
			local telaProtetiva = auxFuncs.TelaProtetiva()
			telaProtetiva.alpha = .8
			local function textListener( event )
	 
				if ( event.phase == "began" ) then
					-- User begins editing "defaultBox"
			 
				elseif ( event.phase == "ended" or event.phase == "submitted" ) then
					-- Output resulting text from "pdefaultBox"
					print( event.target.text )
			 
				elseif ( event.phase == "editing" ) then
					print( event.newCharacters )
					print( event.oldText )
					print( event.startPosition )
					print( event.text )
				end
			end
			-- Create text box
			
			local defaultBox = native.newTextBox( W/2, 10 + 3*W/8, 9*W/10 - 60, 3*W/4 - 60 )
			defaultBox.placeHolder = "coloque sua mensagem aqui."
			defaultBox.text = ""
			defaultBox.isEditable = true
			defaultBox.size = 30
			defaultBox:addEventListener( "userInput", textListener )
			defaultBox.hasBackground = false
			native.setKeyboardFocus( defaultBox )
			local fundoTextBox = display.newImageRect("campoEditar.png",9*W/10 ,3*W/4)
			fundoTextBox.anchorY=0.5
			fundoTextBox.anchorX=0.5
			fundoTextBox.x = defaultBox.x
			fundoTextBox.y = defaultBox.y
			local cancelar
			
			local salvar = widget.newButton(
			{
				top = fundoTextBox.y + fundoTextBox.height/2 + 20,
				left = fundoTextBox.x - fundoTextBox.width/2 ,
				shape = "roundedRect",
				label = "enviar",
				labelAlign = "center",
				labelColor = { default={ 0, 0, 0 }, over={ 1, 1, 1, 0.5 } },
				font = "Fontes/paolaAccent.ttf",
				fontSize = 40,
				onRelease = function(e)
								native.setKeyboardFocus( nil );
								local permissao = ""
								if string.find(varGlobal.preferenciasGerais.permissaoComentarios,"sim") then
									permissao = "&permissao=V" -- Verificando -- Reprovado -- Aprovado
								elseif string.find(varGlobal.preferenciasGerais.permissaoComentarios,"nao") then
									permissao = "&permissao=A"
								end
								local parameters = {}
								parameters.body = "Criar=1&idLivro=" .. varGlobal.idLivro1  .. "&idUsuario=" .. varGlobal.idAluno1 .. "&pagina=" .. telas.paginaHistorico .. "&conteudo=" .. defaultBox.text .. "&situacao=" .. "A" .. acrescentar..permissao.."&remetente="..Var.comentario.remetente
								local URL2 = "https://omniscience42.com/EAudioBookDB/mensagens.php"
								network.request(URL2, "POST", 
									function(event)
										if ( event.isError ) then
											native.showAlert("Falha no envio","Sua mensagem não pôde ser enviada, verifique sua conexão com a internet e tente novamente",{"OK"})
										else
											--print("WARNING: 24",event.response)
											cancelar:removeSelf()
											defaultBox:removeSelf()
											fundoTextBox:removeSelf()
											e.target:removeSelf()
											telaProtetiva:removeSelf()
											
											if permissao == "&permissao=V" then
												native.showAlert("Mensagem Enviada","Sua mensagem foi enviada com sucesso, Aguarde o mwoderador ou autor verificar e permitir esse comentário",{"OK"})
											end
											
											local subPagina = telas.subPagina
											historicoLib.Criar_e_salvar_vetor_historico({
												tipoInteracao = "comentário",
												pagina_livro = telas.pagina,
												objeto_id = nil,
												acao = "criar comentário",
												subTipo = "privada",
												conteudo = defaultBox.text,
												subPagina = subPagina,
												tela = telas
											})
											
											Var.comentario.atualizarComentarios()
											-- enviar notificação para o dono do comentário
											print(dadosAutor)
											print("dadosAutor.email_usuario",dadosAutor.email_usuario)
											if dadosAutor then
												local vetorJson = {}
												vetorJson.tipoDeAcesso = "notificarMensagemPrivada"
												vetorJson.toMail = dadosAutor.email_usuario
												vetorJson.mensagem = defaultBox.text
												vetorJson.pagina = telas.pagina
												vetorJson.apelidoOutro = dadosAutor.apelido_usuario
												vetorJson.apelido = varGlobal.NomeLogin1
												vetorJson.email = dadosAutor.email_usuario
												vetorJson.emailOriginal = auxFuncs.lerTextoDoc("emailEfetuado.txt")
												vetorJson.nomeLivro = auxFuncs.lerTextoDoc("nomeLivro.txt")
												
												local headers = {}
												headers["Content-Type"] = "application/json"
												local parameters = {}
												parameters.headers = headers
												local data = json.encode(vetorJson)

												parameters.body = data
												local function notifRespostaListener(event)
													--print("|"..tostring(event.response).."|")
													if ( event.isError ) then
														  print("Network Error . Check Connection", "Connect to Internet")
													else
														if string.find(event.response,"Email nao enviado") then
														elseif string.find(event.response,"Email enviado") then
															print("1!!!",event.response)
														elseif string.find(event.response,"Email nao encontrado") then
															print("2!!!",event.response)
														else
															print("3!!!",event.response)
														end
													end
												end
												local URL = "https://omniscience42.com/EAudioBookDB/sendMail.php" --mongo.php"
												network.request(URL, "POST", notifRespostaListener,parameters)
											end
										end
									end,parameters)

							end,
				width = 200,
				height = 50,
				fillColor = { default={ 0.18, 0.67, 0.785, 1 }, over={ 0.004, 0.368, 0.467, 1 } },
				strokeColor = { default={ 0, 0, 0 }, over={ 0, 0, 0,.7 } },
				strokeWidth = 2,
				cornerRadius = 2
			})
			
			cancelar = widget.newButton(
			{
				top = fundoTextBox.y + fundoTextBox.height/2 + 20,
				left = fundoTextBox.x + fundoTextBox.width/2 - 200,
				shape = "roundedRect",
				label = "cancelar",
				labelAlign = "center",
				labelColor = { default={ 0, 0, 0 }, over={ 1, 1, 1, 0.5 } },
				font = "Fontes/paolaAccent.ttf",
				fontSize = 40,
				onRelease = function(e)
								native.setKeyboardFocus( nil );
								salvar:removeSelf()
								defaultBox:removeSelf()
								fundoTextBox:removeSelf()
								e.target:removeSelf()
								telaProtetiva:removeSelf()
							end
				,
				width = 200,
				height = 50,
				fillColor = { default={ 0.9, 0.2, 0.1, 1 }, over={ 0.7, 0.02, 0.01, 1 } },
				strokeColor = { default={ 0, 0, 0 }, over={ 0, 0, 0,.7 } },
				strokeWidth = 2,
				cornerRadius = 2
			})
		end
		function Var.comentario.comentarioListener( event )
			print("WARNING: COMEÇOU coment listener")
			local numeroT = 1
			local EstaVazio = true
			-- pegando vetor de comentários do banco de dados
			if ( event.isError ) then
				
				Var.comentario.vetorComentarios = {}
				Var.comentario.vetorComentarios[1] = {}
				Var.comentario.vetorComentarios[1].conteudo = "Conexão com a internet falhou:"
				if protetorTelaParaLoading then 
					protetorTelaParaLoading:removeSelf(); 
					protetorTelaParaLoading = nil 
				end
				if Var.comentario.telaLoadingAtualizar then
					Var.comentario.telaLoadingAtualizar:removeSelf(); 
					Var.comentario.telaLoadingAtualizar = nil 
				end
			elseif Var.comentario then
				if protetorTelaParaLoading then 
					protetorTelaParaLoading:removeSelf(); 
					protetorTelaParaLoading = nil 
				end
				if Var.comentario.telaLoadingAtualizar then
					Var.comentario.telaLoadingAtualizar:removeSelf(); 
					Var.comentario.telaLoadingAtualizar = nil 
				end
				local json = require("json")
				--print("WARNING: |||CCC!!!")
				--print(varGlobal.idProprietario1)
				--print(event.response)
				--print("WARNING: |||FFF!!!")
				Var.comentario.vetorComentarios = json.decode(event.response)
				if Var.comentario.vetorComentarios and Var.comentario.vetorComentarios.vazio == false then
					numeroT = Var.comentario.vetorComentarios.N
					EstaVazio = false
					Var.anotComInterface.Icone.fill.effect = nil
					Var.comentario.rectTop.fill.effect = nil
				elseif Var.comentario.vetorComentarios and Var.comentario.vetorComentarios.vazio == true then
					Var.comentario.vetorComentarios = {}
					Var.comentario.vetorComentarios[1] = {}
					Var.comentario.vetorComentarios[1].conteudo = "Não existem mensagens a se exibir nesta página."
				end
				local comentariosComPai = {}
				
				for i=1,numeroT do
					if EstaVazio == false then
						Var.comentario.vetorComentarios[i] = Var.comentario.vetorComentarios[tostring(i)]
						--se autor e id autor comentario são iguais faça:
						local function trocarElementoTable(t, old, new)
							local value = t[old]
							if new < old then
							   table.move(t, new, old - 1, new + 1)
							else    
							   table.move(t, old + 1, new, old) 
							end
							t[new] = value
						end
						 
						Var.comentario.vetorComentarios[i].filhos = {}
						Var.comentario.vetorComentarios[i].filhos.aberto = false
					end
					
				end
				
				-- separando os comentarios que têm comentário pai e retirando comentarios removidos.
				local function forAuxiliar0(i,limite)
					if Var.comentario.vetorComentarios[i].situacao == "D" then -- já estou filtrando no php, mas vou deixar arrumado caso seja necessário depois
						table.remove(Var.comentario.vetorComentarios,i)
						limite = limite-1
						i = i-1
					elseif Var.comentario.vetorComentarios[i].permissao and (Var.comentario.vetorComentarios[i].permissao == "V" or Var.comentario.vetorComentarios[i].permissao == "R") then
						table.remove(Var.comentario.vetorComentarios,i)
						limite = limite-1
						i = i-1
					else
						if Var.comentario.vetorComentarios[i].pai then
							table.insert(comentariosComPai,Var.comentario.vetorComentarios[i])
							table.remove(Var.comentario.vetorComentarios,i)
							limite = limite-1
							i = i-1
						end
					end
					Var.comentario.rodarLoopFor0(i+1,limite)
				end
				function Var.comentario.rodarLoopFor0(i,limite)
					if i<=limite then forAuxiliar0(i,limite); end
				end
				Var.comentario.rodarLoopFor0(1,numeroT)
				
				for i=1,#comentariosComPai do
					print("I = ",i)
					for k=1,#Var.comentario.vetorComentarios do
						print("K = ",k)
						print("CId = ",Var.comentario.vetorComentarios[k].comentarioID)
						print("Pai = ",comentariosComPai[i].pai)
						print("ID = ",comentariosComPai[i].usuarioID)
						if Var.comentario.vetorComentarios[k].comentarioID == comentariosComPai[i].pai then
							print("ACHOU")
							table.insert(Var.comentario.vetorComentarios[k].filhos,comentariosComPai[i])
						end
					end
				end
				
			end
			
			-- guardando o vetor para montagem posterior do TTS --
			Var.anotComInterface.varCtrl.mensLida = true
			Var.anotComInterface.varCtrl.mensCont = {}
			print("Cont Var.comentario.vetorComentarios = ",#Var.comentario.vetorComentarios)
			for cont=1,#Var.comentario.vetorComentarios do
				Var.anotComInterface.varCtrl.mensCont[cont] = {}
				--varCtrl.mensCont[cont] = Var.comentario.vetorComentarios[cont]
				Var.anotComInterface.varCtrl.mensCont[cont].conteudo = Var.comentario.vetorComentarios[cont].conteudo
				print("conteudo mens "..cont.." "..Var.anotComInterface.varCtrl.mensCont[cont].conteudo)
				if Var.comentario.vetorComentarios[cont].filhos then
					Var.anotComInterface.varCtrl.mensCont[cont].filhos = {}
					for cont2 = 1,#Var.comentario.vetorComentarios[cont].filhos do
						Var.anotComInterface.varCtrl.mensCont[cont].filhos[cont2] = {}
						Var.anotComInterface.varCtrl.mensCont[cont].filhos[cont2].conteudo = Var.comentario.vetorComentarios[cont].filhos[cont2].conteudo
						print("conteudo res "..cont2.." "..Var.anotComInterface.varCtrl.mensCont[cont].filhos[cont2].conteudo)
					end
				end
			end
			--------------------------------------------------------------------
			-- arrumando formatação texto encontrado -> grupoComentario
			if Var.comentario.gruposComentarios then
				Var.comentario.gruposComentarios:removeSelf()
				Var.comentario.gruposComentarios = nil
			end
			local alturaRetanguloComment = 0
			Var.comentario.gruposComentarios = display.newGroup()
			Var.comentario.scrollView = widget.newScrollView(
				{
					width = Var.anotComInterface.retanguloFundo.width-30,
					height = alturaScroll,
					scrollHeight = Var.anotComInterface.retanguloFundo.height,
					hideBackground = true,
					horizontalScrollDisabled  = true,
					listener = scrollListener
				}
			)
			Var.comentario.scrollView.anchorY=0
			Var.comentario.scrollView.anchorX=0
			Var.comentario:insert(2,Var.comentario.scrollView)
			Var.comentario.scrollView.x = -50
			Var.comentario.scrollView.y = Var.comentario.rectTop.y + 2+distanciaScroll
			--Var.comentario:insert(Var.comentario.scrollView)
			Var.comentario.gruposComentarios:insert(Var.comentario.scrollView)
			Var.comentario.vetorPrinc = {}
			Var.comentario.vetorSec = {}
			Var.comentario.respostaAberta = false
			local function voltarParaContatosFunc()
				Var.comentario.gruposComentarios:removeSelf()
				Var.comentario.tituloBarra:removeSelf()
				Var.comentario.gruposComentarios=nil
				Var.comentario.tituloBarra=nil
				Var.comentario.grupoContatos.isVisible = true
			end
			Var.comentario.voltarParaContatos = auxFuncs.createNewButton(
			{
				defaultFile = "backButton.png",
				overFile =  "backButtonD.png",
				onRelease = voltarParaContatosFunc
			})
			Var.comentario.gruposComentarios:insert(Var.comentario.voltarParaContatos)
			Var.comentario.voltarParaContatos.x = Var.comentario.rectTop.x - Var.comentario.rectTop.width/2 + Var.comentario.voltarParaContatos.width/2 + 5
			Var.comentario.voltarParaContatos.y = Var.comentario.rectTop.y + Var.comentario.rectTop.height + Var.comentario.voltarParaContatos.height/2 + 5
				
			criarBaloesDeComentarios(Var.comentario.vetorComentarios)
			Var.comentario.posOriginal = Var.comentario.y
			
			Var.comentario.textField = native.newTextField(0,0,Var.comentario.rectTop.width - 100,50)
			Var.comentario.textField.isVisible = false
			Var.comentario.textField.x = Var.anotComInterface.fundoBranco.x - Var.anotComInterface.fundoBranco.width/2 + Var.comentario.textField.width/2 + 20
			Var.comentario.textField.y = Var.anotComInterface.fundoBranco.y + Var.anotComInterface.fundoBranco.height - Var.comentario.textField.height/2 - 30
			Var.comentario.gruposComentarios:insert(Var.comentario.textField)
			Var.comentario.textField.hasBackground = false
				
			local function entrarComMensagem()
				native.setKeyboardFocus(Var.comentario.textField)
				Var.comentario.y = Var.comentario.posOriginal - H/2
				local sv=Var.comentario.scrollView:getView() Var.comentario.scrollView:setScrollHeight(sv.contentHeight+100)
				Var.comentario.scrollView:scrollTo( "bottom", { time=0 } )
				Var.comentario.protTelaMensagem = auxFuncs.TelaProtetiva()
				Var.comentario.protTelaMensagem.y = - 200
				Var.comentario.protTelaMensagem.isVisible=false
				timer.performWithDelay(10,function()Var.comentario.protTelaMensagem.isHitTestable = true end,1)
				Var.comentario.textField.isVisible=true
				Var.comentario.protTelaMensagem:addEventListener("tap",function() 
					Var.comentario.y = Var.comentario.posOriginal; 
					native.setKeyboardFocus(nil);
					Var.comentario.protTelaMensagem:removeSelf();
					Var.comentario.protTelaMensagem=nil 
					local sv=Var.comentario.scrollView:getView()
					Var.comentario.textField.isVisible = false
					if Var.comentario.vetorComentarios.vazio == true or sv.contentHeight < Var.comentario.scrollView.height then
						Var.comentario.scrollView:scrollTo( "top", { time=0 } )
					end
				end)
				--Var.comentario.scrollView:scrollTo( "top", { time=0 } )
			end
			Var.comentario.comentar = widget.newButton(
			{
				defaultFile = "comentar.png",
				overFile = "comentar.png",
				onRelease = entrarComMensagem,
				width = Var.anotComInterface.retanguloFundo.width/4,
			})
			Var.comentario.comentar.anchorX = 0
			Var.comentario.comentar.anchorY = 1
			Var.comentario.comentar.id = nil
			Var.comentario.comentar.y = Var.anotComInterface.retanguloFundo.y + Var.anotComInterface.retanguloFundo.height - 10
			Var.comentario.comentar.x = Var.anotComInterface.retanguloFundo.x - Var.anotComInterface.retanguloFundo.width/2 + 10
			Var.comentario.gruposComentarios:insert(Var.comentario.comentar)
			
			function Var.comentario.atualizarComentarios()
				if Var.comentario.gruposComentarios then
					Var.comentario.gruposComentarios:removeSelf()
					Var.comentario.gruposComentarios = nil
				end
				
				Var.comentario.gruposComentarios = display.newGroup()
				Var.comentario.scrollView = widget.newScrollView(
					{
						width = Var.anotComInterface.retanguloFundo.width-30,
						height = Var.anotComInterface.retanguloFundo.height-200,
						scrollHeight = Var.anotComInterface.retanguloFundo.height,
						hideBackground = true,
						horizontalScrollDisabled  = true,
						listener = scrollListener
					}
				)
				Var.comentario.scrollView.anchorY=0
				Var.comentario.scrollView.anchorX=0
				--Var.comentario:insert(2,Var.comentario.scrollView)
				Var.comentario.scrollView.x = -50
				Var.comentario.scrollView.y = Var.comentario.rectTop.y + 2+100
				Var.comentario.gruposComentarios:insert(Var.comentario.scrollView)
				
				Var.comentario.vetorComentarios = nil
				Var.comentario.vetorPrinc = {}
				Var.comentario.vetorSec = {}
				Var.comentario.respostaAberta = false
				alturaRetanguloComment = 0
				local sv=Var.comentario.scrollView:getView() Var.comentario.scrollView:setScrollHeight(sv.contentHeight)
				local remetente = 0
				if Var.comentario.remetente then remetente = Var.comentario.remetente end
				local parameters = {}
				Var.comentario.telaLoadingAtualizar = auxFuncs.TelaProtetiva()
				Var.comentario.telaLoadingAtualizar.alpha = 0
				Var.comentario.telaLoadingAtualizar.isHitTestable = true
				parameters.body = "consulta=1&codigoLivro=" .. varGlobal.codigoLivro1 .. "&pagina=" .. telas.paginaHistorico.."&idUsuario=" .. varGlobal.idAluno1.."&remetente="..remetente
				local URL2 = "https://omniscience42.com/EAudioBookDB/mensagens.php"
				network.request(URL2, "POST", Var.comentario.comentarioListener,parameters)
			end
			
			function Var.comentario.enviarMensagem(event)
				
				if Var.comentario.textField and Var.comentario.textField.text and Var.comentario.textField.text ~= "" then
					local acrescentar = ""
					if event and event.target.id then
						--print("event.target.id",event.target.id)
						--acrescentar = "&idComentario="..event.target.id
					end
					native.setKeyboardFocus( nil );
					Var.comentario.y = Var.comentario.posOriginal; 
					native.setKeyboardFocus(nil);
					if Var.comentario.protTelaMensagem then
						Var.comentario.protTelaMensagem:removeSelf();
						Var.comentario.protTelaMensagem=nil 
					end
					local permissao = ""
					if string.find(varGlobal.preferenciasGerais.permissaoComentarios,"sim") then
						permissao = "&permissao=V" -- Verificando -- Reprovado -- Aprovado
					elseif string.find(varGlobal.preferenciasGerais.permissaoComentarios,"nao") then
						permissao = "&permissao=A"
					end
					local parameters = {}
					parameters.body = "Criar=1&idLivro=" .. varGlobal.idLivro1  .. "&idUsuario=" .. varGlobal.idAluno1 .. "&pagina=" .. telas.paginaHistorico .. "&conteudo=" .. Var.comentario.textField.text ..acrescentar.. "&situacao=" .. "A" ..permissao.."&remetente="..Var.comentario.remetente
					local URL2 = "https://omniscience42.com/EAudioBookDB/mensagens.php"
					network.request(URL2, "POST", 
						function(event1)
							if ( event1.isError ) then
								native.showAlert("Falha no envio","Sua mensagem não pôde ser enviada, verifique sua conexão com a internet e tente novamente",{"OK"})
							else
								print("WARNING: 24",event1.response)
								
								if permissao == "&permissao=V" then
									native.showAlert("Mensagem Enviada","Sua mensagem foi enviada com sucesso, Aguarde o mwoderador ou autor verificar e permitir esse comentário",{"OK"})
								end
								
								local subPagina = telas.subPagina
								historicoLib.Criar_e_salvar_vetor_historico({
									tipoInteracao = "comentário",
									pagina_livro = telas.pagina,
									objeto_id = nil,
									acao = "criar comentário",
									subtipo = "privada",
									remetente = Var.comentario.remetente,
									conteudo = Var.comentario.textField.text,
									subPagina = subPagina,
									tela = telas
								})
								
								Var.comentario.atualizarComentarios()
								-- enviar notificação para o dono do comentário
								print(dadosAutor)
								if dadosAutor then
									local vetorJson = {}
									vetorJson.tipoDeAcesso = "notificarMensagemPrivada"
									vetorJson.toMail = dadosAutor.email_usuario
									vetorJson.mensagem = Var.comentario.enviar.text
									vetorJson.pagina = telas.pagina
									vetorJson.apelidoOutro = dadosAutor.apelido_usuario
									vetorJson.apelido = varGlobal.NomeLogin1
									vetorJson.email = dadosAutor.email_usuario
									vetorJson.emailOriginal = auxFuncs.lerTextoDoc("emailEfetuado.txt")
									vetorJson.nomeLivro = auxFuncs.lerTextoDoc("nomeLivro.txt")
									
									local headers = {}
									headers["Content-Type"] = "application/json"
									local parameters = {}
									parameters.headers = headers
									local data = json.encode(vetorJson)

									parameters.body = data
									local function notifRespostaListener(event2)
										--print("|"..tostring(event.response).."|")
										if ( event2.isError ) then
											  print("Network Error . Check Connection", "Connect to Internet")
										else
											if string.find(event2.response,"Email nao enviado") then
											elseif string.find(event2.response,"Email enviado") then
												print("1!!!",event2.response)
											elseif string.find(event2.response,"Email nao encontrado") then
												print("2!!!",event2.response)
											else
												print("3!!!",event2.response)
											end
										end
									end
									local URL = "https://omniscience42.com/EAudioBookDB/sendMail.php" --mongo.php"
									network.request(URL, "POST", notifRespostaListener,parameters)
								end
							end
						end,parameters)
				end
			end
						
			Var.comentario.enviar = widget.newButton(
			{
				defaultFile = "send.png",
				overFile = "sendD.png",
				width = 70,
				height = 70,
				onRelease = Var.comentario.enviarMensagem,
			})
			Var.comentario.enviar.anchorX = 0
			Var.comentario.enviar.anchorY = 1
			Var.comentario.enviar.y = Var.anotComInterface.retanguloFundo.y + Var.anotComInterface.retanguloFundo.height - 20
			Var.comentario.enviar.x = Var.comentario.comentar.x + Var.comentario.comentar.width + 10
			Var.comentario.gruposComentarios:insert(Var.comentario.enviar)
			
			
			alturaRetanguloComment = Var.comentario.gruposComentarios.height + 15
			
			Var.comentario:insert(Var.comentario.gruposComentarios)
			local sv=Var.comentario.scrollView:getView() Var.comentario.scrollView:setScrollHeight(sv.contentHeight)

			
		end
		local parameters = {}
		print("consulta=1&codigoLivro=" .. varGlobal.codigoLivro1 .. "&pagina=" .. telas.paginaHistorico.."&idUsuario=" .. varGlobal.idAluno1.."&remetente="..Var.comentario.remetente)
		parameters.body = "consulta=1&codigoLivro=" .. varGlobal.codigoLivro1 .. "&pagina=" .. telas.paginaHistorico.."&idUsuario=" .. varGlobal.idAluno1.."&remetente="..Var.comentario.remetente
		local URL2 = "https://omniscience42.com/EAudioBookDB/mensagens.php"
		network.request(URL2, "POST", Var.comentario.comentarioListener,parameters)
		--------------------------------------------------p
		
	
	end
	
	local function criarCampoComentarioPub()
		local strokeWidth = 2
		
		local distanciaScroll = 100
		local alturaScroll = 870
		Var.comentarioPub.erro = nil
		Var.comentarioPub.vazio = nil
		Var.comentarioPub.conteudo = nil
		
		Var.comentarioPub.vetorComentarios = {}
		Var.comentarioPub.vetorComentarios.erro = nil
		Var.comentarioPub.vetorComentarios.vazio = nil
		Var.comentarioPub.vetorComentarios.comentarios = {}
		Var.comentarioPub.vetorComentarios.conteudo = {}
		Var.comentarioPub.vetorComentarios.usuarioID = {}
		Var.comentarioPub.vetorComentarios.imagemPerfil = {}
		Var.comentarioPub.vetorComentarios.usuarioNome = {}
		Var.comentarioPub.vetorComentarios.curtidasComentario = {}
		Var.comentarioPub.vetorComentarios.comentarioFilho = {}
		Var.comentarioPub.vetorComentarios.comentarioPai = {}

		local alturaRetanguloComment = 0
		Var.comentarioPub.gruposComentarios = display.newGroup()

		Var.comentarioPub.vetorPrinc = {}
		Var.comentarioPub.vetorSec = {}
		Var.comentarioPub.respostaAberta = false
		local Secundario = nil
		
		local function criarBaloesDeComentarios(vetorComentarios,diminuirParaResposta,eventResp)
			local textoComentarios = {}
			local grupoComentario = {}
			local diminuir = 0
			-- olhar se está criando balões de resposta --
			if diminuirParaResposta then
				diminuir = diminuirParaResposta
			end
			
			if eventResp then
				Secundario = eventResp.target
				Secundario.altura = 0
			else
				Secundario = nil
			end
			----------------------------------------------
			for i=1,#vetorComentarios do
				print("vetorComentarios[i].usuarioID",vetorComentarios[i].IDUnico)--.usuarioID)
				local bordasY = 100
				
				
				grupoComentario[i] = display.newGroup()
				
				local posTexto =  20--Var.anotacao.rectTop.y + Var.anotacao.rectTop.height + 20
				--print("posTexto!!!",posTexto, Var.anotacao.rectTop.y)
				if Secundario then
					posTexto =  Secundario.y + Secundario.height - 20
					local sv=Var.comentarioPub.scrollView:getView() Var.comentarioPub.scrollView:setScrollHeight(sv.contentHeight+ Secundario.height)
			
				end
				if i > 1 then
					posTexto = textoComentarios[i-1].y - bordasY/2 + grupoComentario[i-1].height + 10
				end
				
				grupoComentario[i].numero = i
				grupoComentario[i].x = grupoComentario[i].x + diminuir
				textoComentarios[i] = display.newText(grupoComentario[i],vetorComentarios[i].conteudo,0,0,Var.anotComInterface.retanguloFundo.width-20 - diminuir - 10,0,native.systemFont,35)
				print(vetorComentarios[i].conteudo)
				textoComentarios[i]:setFillColor(0,0,0)
				textoComentarios[i].anchorY=0;textoComentarios[i].anchorX=0
				textoComentarios[i].y = posTexto
				textoComentarios[i].x = 0--Var.anotacao.rectTop.x + 20
				-- se existe erro então criar botão de tentar novamente --s
				if vetorComentarios.vazio or vetorComentarios.erro then
					textoComentarios[i]:setFillColor(.2,.2,.2)
					textoComentarios[i].size = 30
				else
					-- criar barra comentador -- inserir em: grupoComentario[i]
					
					local altura = textoComentarios[i].height + bordasY
					local x = 0--Var.anotacao.rectTop.x +20
					
					-- FUNDO DO COMENTÁRIO
					grupoComentario[i].retanguloFundoBranco = display.newRoundedRect(x,posTexto,Var.anotComInterface.retanguloFundo.width-20 - diminuir - 10,altura,6)
					grupoComentario[i].retanguloFundoBranco.anchorX=0
					grupoComentario[i].retanguloFundoBranco.anchorY=0
					grupoComentario[i]:insert(1,grupoComentario[i].retanguloFundoBranco)
					
					-- INTERFACE (Avatar,apelido e data)
					-- baixar e colocar o avatar --
					grupoComentario[i].avatarNome = vetorComentarios[i].Imagem
					grupoComentario[i].jaCurtiu = vetorComentarios[i].jaCurtiu
					print("WARNING: NOVO")
					local function aposBaixarAvatar(event)
						if ( event.isError ) then
							print( "Network error - download failed: ", event.response )
						elseif ( event.phase == "began" ) then
							print( "Progress Phase: began" )
						elseif ( event.phase == "ended" ) then
							print( "Displaying response image file" )
							--timer.performWithDelay(10,
							--function()
							--if jaAbriu == false then
								if grupoComentario and grupoComentario[i] and Var.comentarioPub and grupoComentario[i].avatarNome  then
									
									grupoComentario[i].idComentario = vetorComentarios[i].comentarioID
									grupoComentario[i].idPai = vetorComentarios[i].pai
									
									grupoComentario[i].avatar = display.newImageRect(grupoComentario[i].avatarNome,system.TemporaryDirectory,(bordasY/2)-2,(bordasY/2)-2)
									grupoComentario[i].avatar.x = x + 5
									grupoComentario[i].avatar.y = posTexto + 1
									grupoComentario[i].avatar.anchorX=0
									grupoComentario[i].avatar.anchorY=0
									if grupoComentario[i].avatar  then
										grupoComentario[i]:insert(grupoComentario[i].avatar)
									end

									grupoComentario[i].avatar2 = display.newImageRect("avatar.png",(bordasY/2)-2,(bordasY/2)-2)
									grupoComentario[i].avatar2.x = x + 5
									grupoComentario[i].avatar2.y = posTexto + 1
									grupoComentario[i].avatar2.anchorX=0
									grupoComentario[i].avatar2.anchorY=0
									grupoComentario[i]:insert(grupoComentario[i].avatar2)

									-- colocar o apelido --
									local textoAvatar = vetorComentarios[i].apelido
									if textoAvatar then
										grupoComentario[i].avatarTexto = display.newText(textoAvatar,grupoComentario[i].avatar.x + grupoComentario[i].avatar.width + 5,grupoComentario[i].avatar.y + grupoComentario[i].avatar.height/2,"Fontes/segoeui.ttf",27)
										grupoComentario[i].avatarTexto.anchorX=0
										grupoComentario[i].avatarTexto.anchorY=0.5
										grupoComentario[i]:insert(grupoComentario[i].avatarTexto)
										grupoComentario[i].avatarTexto:setFillColor(.3,.3,.3)
									end
									local function abrirMenuRapido(eventP)
										if Var.comentarioPub.telaProtetiva then
											Var.comentarioPub.telaProtetiva:removeSelf()
											Var.comentarioPub.telaProtetiva = nil
										end
										Var.comentarioPub.telaProtetiva = display.newRect(0,0,W*2,H*2)
										Var.comentarioPub.telaProtetiva.alpha=.2
										Var.comentarioPub.telaProtetiva.isHitTestable = true
										Var.comentarioPub.telaProtetiva.anchorX=0.5;Var.comentarioPub.telaProtetiva.anchorY=0.5
										Var.comentarioPub.telaProtetiva:addEventListener("tap",function(e)Var.comentarioPub.MenuRapido:removeSelf();Var.comentarioPub.telaProtetiva:removeSelf();Var.comentarioPub.telaProtetiva = nil;return true; end)
										Var.comentarioPub.telaProtetiva:addEventListener("touch",function() return true; end)
									
										local escolhas = {"copiar"}
										if vetorComentarios[i].usuarioID == varGlobal.idAluno1 then
											table.insert(escolhas,"excluir")
										end
										local function AoExcluirComentario(event)
											if ( event.isError ) then
												print( "Network error - download failed: ", event.response )
												native.showAlert("Conexão Instável","Não foi possível excluir o comentário devido a uma falha na conexão com a internet.",{"ok"})
											elseif ( event.phase == "began" ) then
												print( "Progress Phase: began" )
											elseif ( event.phase == "ended" ) then
												print(event.response)
												
												local subPagina = telas.subPagina
												historicoLib.Criar_e_salvar_vetor_historico({
													tipoInteracao = "comentário",
													pagina_livro = telas.pagina,
													objeto_id = grupoComentario[i].idComentario,
													acao = "excluir comentário",
													conteudo = textoComentarios[i].text,
													id_Comentario = grupoComentario[i].idComentario,
													subPagina = subPagina,
													tela = telas
												})
												
												Var.comentarioPub.atualizarComentarios()
											end
										end
										local function rodarOpcao(e)
											Var.comentarioPub.telaProtetiva:removeSelf()
											Var.comentarioPub.telaProtetiva = nil
											Var.comentarioPub.MenuRapido:removeSelf()
											Var.comentarioPub.MenuRapido = nil
											if e.target.params.tipo == "copiar" then
												print("copiou")
												--local pasteboard = require( "plugin.pasteboard" )
												--pasteboard.copy( "string", tostring(textoComentarios[i].text) )
											elseif e.target.params.tipo == "excluir" then
												print("excluiu")
												local function onComplete(e)
													if e.index == 1 then
														print("cancelou exclusão")
													elseif e.index == 2 then
														parameters.body = "Excluir=1&codigoLivro=" .. varGlobal.codigoLivro1  .. "&idUsuario=" .. varGlobal.idAluno1 .. "&idComentario=" .. grupoComentario[i].idComentario
														local URL2 = "https://omniscience42.com/EAudioBookDB/comentarios.php"
														network.request(URL2, "POST", AoExcluirComentario,parameters)
													end
												end
												native.showAlert("Atenção!","Tem certeza que quer excluir a sua mensagem?\nEssa ação não pode ser desfeita.",{"cancelar","confirmar"},onComplete)
											end
										end
										local escolhasGerais = {}
										for i=1,#escolhas do
											table.insert(escolhasGerais,
											{
												listener = rodarOpcao,
												tamanho = 40,
												texto = escolhas[i],
												cor = {.9,.9,.9},
												params = {tipo = escolhas[i]},
												cor = {37/225,185/225,219/225},
											})
											if escolhas[i] == "copiar" then
												escolhasGerais[#escolhasGerais].iconeEsq =  {imagem = "copiar.png"}
											elseif escolhas[i] == "excluir" then
												escolhasGerais[#escolhasGerais].iconeEsq =  {imagem = "deletar.png"}
											end
										end
										Var.comentarioPub.MenuRapido = MenuRapido.New(
											{
											escolhas = escolhasGerais,
											rowWidthGeneric = 200,
											rowHeightGeneric = 50,
											tamanhoTexto = 30,
											telaProtetiva = "nao"
											}
										)

										--Var.imagens[ims].MenuRapido.x = event.x
										--Var.imagens[ims].MenuRapido.y = event.y - GRUPOGERAL.y
										local posicaoScrollX, posicaoScrollY = Var.comentarioPub.scrollView:getContentPosition()
										Var.comentarioPub.MenuRapido.x = grupoComentario[i].botaoOpcoes.x
										Var.comentarioPub.MenuRapido.y = grupoComentario[i].y + grupoComentario[i].botaoOpcoes.y + posicaoScrollY+ 200-diminuir
										--print(eventP.target.y,Var.anotComInterface.y)
										Var.comentarioPub.MenuRapido.anchorY=0
										Var.comentarioPub.MenuRapido.anchorX=1
										if Var.comentarioPub.MenuRapido.x + Var.comentarioPub.MenuRapido.width > W and system.orientation == "portrait" then
											Var.comentarioPub.MenuRapido.x = eventP.x - Var.comentarioPub.MenuRapido.width
										end
										if system.orientation == "landscapeLeft" then
											Var.comentarioPub.MenuRapido.y = grupoComentario[i].botaoOpcoes.y + grupoComentario[i].botaoOpcoes.height/2
											Var.comentarioPub.MenuRapido.x = grupoComentario[i].botaoOpcoes.x
										elseif system.orientation == "landscapeRight" then
											Var.comentarioPub.MenuRapido.y = grupoComentario[i].botaoOpcoes.y + grupoComentario[i].botaoOpcoes.height/2
											Var.comentarioPub.MenuRapido.x = grupoComentario[i].botaoOpcoes.x
										end
										
									end
									local botaoOpcaoX = grupoComentario[i].retanguloFundoBranco.x + grupoComentario[i].retanguloFundoBranco.width - 10
									--print("botaoOpcaoX",botaoOpcaoX)
									local botaoOpcaoY = grupoComentario[i].avatar.y + grupoComentario[i].avatar.height/2
									grupoComentario[i].botaoOpcoes = display.newImageRect("optionComment.png",50,40)
									grupoComentario[i].botaoOpcoes.anchorX=1
									grupoComentario[i].botaoOpcoes.x = botaoOpcaoX
									grupoComentario[i].botaoOpcoes.y = botaoOpcaoY
									grupoComentario[i]:insert(grupoComentario[i].botaoOpcoes)
									grupoComentario[i].botaoOpcoes:addEventListener("tap",abrirMenuRapido)
									
									local dataComentario = vetorComentarios[i].data
									if dataComentario then
										grupoComentario[i].comentarioData = display.newText(dataComentario,grupoComentario[i].botaoOpcoes.x - grupoComentario[i].botaoOpcoes.width - 10,botaoOpcaoY,"Fontes/segoeui.ttf",25)
										grupoComentario[i].comentarioData.anchorX=1
										grupoComentario[i].comentarioData.anchorY=0.5
										grupoComentario[i]:insert(grupoComentario[i].comentarioData)
										grupoComentario[i].comentarioData:setFillColor(.3,.3,.3)
									end
									if not Secundario then
										grupoComentario[i].opcoes = widget.newButton(
										{
											defaultFile = "responder.png",
											overFile = "responder.png",
											id = grupoComentario[i].idComentario,
											onRelease = Var.comentarioPub.criarComentario
										})
										--grupoComentario[i].opcoes.alpha = .5
										grupoComentario[i].opcoes.params = {email = vetorComentarios[i].email,apelidoOutro = vetorComentarios[i].apelido,pagina = telas.paginaHistorico,apelido = varGlobal.apelidoLogin1,mensagemOutro = textoComentarios[i].text,nomeLivro = varGlobal.nomeLivro1}
										grupoComentario[i].opcoes.height = 40
										grupoComentario[i].opcoes.width = 55
										grupoComentario[i].opcoes.x = grupoComentario[i].retanguloFundoBranco.x + grupoComentario[i].retanguloFundoBranco.width - 5
										grupoComentario[i].opcoes.y = grupoComentario[i].retanguloFundoBranco.y + grupoComentario[i].retanguloFundoBranco.height - 2
										grupoComentario[i].opcoes.anchorX=1
										grupoComentario[i].opcoes.anchorY=1
										grupoComentario[i].opcoes.id = grupoComentario[i].idComentario
										grupoComentario[i]:insert(grupoComentario[i].opcoes)
									end
									
									local curtidas = vetorComentarios[i].curtidas
									if curtidas then
										local distanciaX =  grupoComentario[i].retanguloFundoBranco.x + grupoComentario[i].retanguloFundoBranco.width - 5
										local distanciaW = -30
										if grupoComentario[i].opcoes then
											distanciaX = grupoComentario[i].opcoes.x
											distanciaW = grupoComentario[i].opcoes.width
										end
										grupoComentario[i].nCurtidas = display.newText(curtidas,distanciaX - distanciaW - 30, grupoComentario[i].retanguloFundoBranco.y + grupoComentario[i].retanguloFundoBranco.height - 2,"Fontes/segoeui.ttf",30)
										grupoComentario[i].nCurtidas.anchorX=1
										grupoComentario[i].nCurtidas.anchorY=1
										grupoComentario[i]:insert(grupoComentario[i].nCurtidas)
										grupoComentario[i].nCurtidas:setFillColor(0,0,0)
									end
									local function curtirDescurtirComentario(e)
										e.target:setEnabled( false )
										local function AoCurtirDescurtir(event)
											if ( event.isError ) then
												print( "Network error - download failed: ", event.response )
												if grupoComentario[i].nCurtidas and grupoComentario[i].nCurtidas.text and grupoComentario[i].curtidas then
													if grupoComentario[i].curtidas.alpha == .2 then
														grupoComentario[i].curtidas.alpha = 1
													elseif grupoComentario[i].curtidas.alpha == 1 then
														grupoComentario[i].curtidas.alpha = .2
													end
												end
											elseif ( event.phase == "began" ) then
												print( "Progress Phase: began" )
											elseif ( event.phase == "ended" ) then
												if grupoComentario[i].nCurtidas and grupoComentario[i].nCurtidas.text and grupoComentario[i].curtidas then
													if grupoComentario[i].curtidas.alpha == 1 then
														grupoComentario[i].curtidas.alpha = 1
														grupoComentario[i].nCurtidas.text = tonumber(grupoComentario[i].nCurtidas.text) + 1
														vetorComentarios[i].curtidas = vetorComentarios[i].curtidas + 1
														grupoComentario[i].jaCurtiu = "S"
														vetorComentarios[i].jaCurtiu = "S"
														
														local subPagina = telas.subPagina
														historicoLib.Criar_e_salvar_vetor_historico({
															tipoInteracao = "comentário",
															pagina_livro = telas.pagina,
															objeto_id = grupoComentario[i].idComentario,
															acao = "curtir comentário",
															conteudo = textoComentarios[i].text,
															id_Comentario = grupoComentario[i].idComentario,
															subPagina = subPagina,
															tela = telas
														})
														
														Var.comentarioPub.atualizarComentarios()
													else
														grupoComentario[i].curtidas.alpha = .2
														grupoComentario[i].nCurtidas.text = tonumber(grupoComentario[i].nCurtidas.text) - 1
														vetorComentarios[i].curtidas = vetorComentarios[i].curtidas - 1
														grupoComentario[i].jaCurtiu = "N"
														vetorComentarios[i].jaCurtiu = "N"
														
														local subPagina = telas.subPagina
														historicoLib.Criar_e_salvar_vetor_historico({
															tipoInteracao = "comentário",
															pagina_livro = telas.pagina,
															objeto_id = grupoComentario[i].idComentario,
															acao = "descurtir comentário",
															id_Comentario = grupoComentario[i].idComentario,
															conteudo = textoComentarios[i].text,
															subPagina = subPagina,
															tela = telas
														})
														
														Var.comentarioPub.atualizarComentarios()
													end
												end
											end
											timer.performWithDelay(700,function()e.target:setEnabled( true )end,1)
										end
										local parameters = {}
										if grupoComentario[i].curtidas.alpha == .2 then
											parameters.body = "Curtir=1&codigoLivro=" .. varGlobal.codigoLivro1  .. "&idUsuario=" .. varGlobal.idAluno1 .. "&idComentario=" .. grupoComentario[i].idComentario .. "&nCurtidas=" .. tonumber(grupoComentario[i].nCurtidas.text) + 1
											grupoComentario[i].curtidas.alpha = 1
										else
											parameters.body = "Descurtir=1&codigoLivro=" .. varGlobal.codigoLivro1  .. "&idUsuario=" .. varGlobal.idAluno1 .. "&idComentario=" .. grupoComentario[i].idComentario .. "&nCurtidas=" .. tonumber(grupoComentario[i].nCurtidas.text) - 1
											grupoComentario[i].curtidas.alpha = .2
										end
										local URL2 = "https://omniscience42.com/EAudioBookDB/comentarios.php"
										network.request(URL2, "POST", AoCurtirDescurtir,parameters)
									end
									grupoComentario[i].curtidas = widget.newButton(
									{
										defaultFile = "like.png",
										overFile = "like.png",
										onRelease = curtirDescurtirComentario,
									})
									grupoComentario[i].curtidas.height = 44
									grupoComentario[i].curtidas.width = 44
									grupoComentario[i].curtidas.x = grupoComentario[i].nCurtidas.x - grupoComentario[i].nCurtidas.width - 10
									grupoComentario[i].curtidas.y = grupoComentario[i].retanguloFundoBranco.y + grupoComentario[i].retanguloFundoBranco.height - 2
									grupoComentario[i].curtidas.anchorX=1
									grupoComentario[i].curtidas.anchorY=1
									grupoComentario[i].curtidas.alpha = .2
									grupoComentario[i]:insert(grupoComentario[i].curtidas)
									if grupoComentario[i].jaCurtiu == "S" then
										grupoComentario[i].curtidas.alpha = 1
									end
									--print("warning: |||".. varGlobal.idProprietario1, vetorComentarios[i].usuarioID .."|||")
									print("SELO??",varGlobal.idProprietario1,vetorComentarios[i].usuarioID)
									if varGlobal.idProprietario1 == vetorComentarios[i].usuarioID then
										grupoComentario[i].seloDoAutor = display.newImageRect("comentarioAutor.png",140-17.5,40-5)
										grupoComentario[i].seloDoAutor.x = grupoComentario[i].curtidas.x - grupoComentario[i].curtidas.width - 5
										grupoComentario[i].seloDoAutor.y = grupoComentario[i].curtidas.y
										grupoComentario[i].seloDoAutor.anchorX=1
										grupoComentario[i].seloDoAutor.anchorY=1
										grupoComentario[i].seloDoAutor.alpha = .9
										grupoComentario[i]:insert(grupoComentario[i].seloDoAutor)
									end
									if not Secundario then
										local function MostrarEsconderRespostas(event)
											if vetorComentarios[i].filhos.aberto == false then
												if Secundario and Var.comentarioPub.respostaAberta == true then
													for k=1,#Var.comentarioPub.vetorPrinc do
														if Secundario.numero == k then
															grupoComentario[k].botaoRespostas:setLabel("Respostas ("..#vetorComentarios[k].filhos..") ↓")
															vetorComentarios[k].filhos.aberto = false
														end
														if Secundario.numero < k then
															Var.comentarioPub.vetorPrinc[k].y = Var.comentarioPub.vetorPrinc[k].y - Secundario.altura
														end
													end
													for k=1,#Var.comentarioPub.vetorSec do
														Var.comentarioPub.vetorSec[k]:removeSelf()
														Var.comentarioPub.vetorSec[k] = nil
													end
													Var.comentarioPub.vetorSec = {}
													Secundario = nil
												end
												vetorComentarios[i].filhos.numero = i
												criarBaloesDeComentarios(vetorComentarios[i].filhos,50,event)
												grupoComentario[i].botaoRespostas:setLabel("Respostas ("..#vetorComentarios[i].filhos..") ↑")
												vetorComentarios[i].filhos.aberto = true
												Var.comentarioPub.respostaAberta = true
												local sv=Var.comentarioPub.scrollView:getView() Var.comentarioPub.scrollView:setScrollHeight(sv.contentHeight)
												
											elseif vetorComentarios[i].filhos.aberto == true then

												grupoComentario[i].botaoRespostas:setLabel("Respostas ("..#vetorComentarios[i].filhos..") ↓")
												vetorComentarios[i].filhos.aberto = false
												for i=1,#Var.comentarioPub.vetorPrinc do
													if Secundario.numero < i then
														Var.comentarioPub.vetorPrinc[i].y = Var.comentarioPub.vetorPrinc[i].y - Secundario.altura
													end
												end
												for i=1,#Var.comentarioPub.vetorSec do
													Var.comentarioPub.vetorSec[i].avatarNome = nil
													Var.comentarioPub.vetorSec[i]:removeSelf()
													Var.comentarioPub.vetorSec[i] = nil
												end
												Var.comentarioPub.vetorSec = {}
												Var.comentarioPub.respostaAberta = false
												
												local sv=Var.comentarioPub.scrollView:getView() Var.comentarioPub.scrollView:setScrollHeight(sv.contentHeight)
												
											end
										end
										-- verificar se há filhos e colocar botão de filhos
										if vetorComentarios[i].filhos and #vetorComentarios[i].filhos > 0 then
											grupoComentario[i].botaoRespostas = widget.newButton(
											{
												--shape = "RoundedRect",
												--fillColor = { default={ 1, 0.2, 0.5, 0.7 }, over={ 1, 0.2, 0.5, 1 } },
												textOnly = true,
												labelColor = { default={ .45, .45, .45 }, over={ .8, .8, .8 } },
												font = "Fontes/arial.ttf",
												fontSize  = 27,
												label = "Respostas ("..#vetorComentarios[i].filhos..") ↓",--↓▼
												onRelease = MostrarEsconderRespostas,
											})
											grupoComentario[i].botaoRespostas.anchorX=0
											grupoComentario[i].botaoRespostas.anchorY=1
											grupoComentario[i].botaoRespostas.y = grupoComentario[i].retanguloFundoBranco.y + grupoComentario[i].retanguloFundoBranco.height - 2
											grupoComentario[i].botaoRespostas.x = x + 5
											grupoComentario[i].botaoRespostas.numero = i
											grupoComentario[i]:insert(grupoComentario[i].botaoRespostas)
										else
											grupoComentario[i].botaoRespostas = display.newText("Não há respostas",0,0,"Fontes/arial.ttf",27)
											grupoComentario[i].botaoRespostas:setFillColor(.45,.45,.45)
											grupoComentario[i].botaoRespostas.anchorX=0
											grupoComentario[i].botaoRespostas.anchorY=1
											grupoComentario[i].botaoRespostas.y = grupoComentario[i].retanguloFundoBranco.y + grupoComentario[i].retanguloFundoBranco.height - 2
											grupoComentario[i].botaoRespostas.x = x + 5
											grupoComentario[i]:insert(grupoComentario[i].botaoRespostas)
										end
									end
								end
							--jaAbriu = true
							--end
							--end,1)
						end
					end
					if grupoComentario[i].avatarNome then
						local params = {}
						params.progress = true
						--"https://www.coronasdkgames.com/libEA 2"
						auxFuncs.downloadArquivo(grupoComentario[i].avatarNome,"https://livrosdic.s3.us-east-2.amazonaws.com/perfil",aposBaixarAvatar)
					end
					
					-- Reorganizando localização do comentário
					textoComentarios[i].y = textoComentarios[i].y + bordasY/2
					
				end
				if Secundario then
					Secundario.altura = Secundario.altura + grupoComentario[i].height + 10
					table.insert(Var.comentarioPub.vetorSec,grupoComentario[i])
				else
					table.insert(Var.comentarioPub.vetorPrinc,grupoComentario[i])
				end
				----------------------------------------------------------s
				Var.comentarioPub.scrollView:insert(grupoComentario[i])
				--Var.comentarioPub.gruposComentarios:insert(grupoComentario[i])
				alturaRetanguloComment = Var.comentarioPub.gruposComentarios.height + 25
				if not Secundario then
					sv=Var.comentarioPub.scrollView:getView() Var.comentarioPub.scrollView:setScrollHeight(sv.contentHeight)
				end
			end
			if Secundario then
				for i=1,#Var.comentarioPub.vetorPrinc do
					if Secundario.numero < i then
						Var.comentarioPub.vetorPrinc[i].y = Var.comentarioPub.vetorPrinc[i].y + Secundario.altura
					end
				end
				local sv=Var.comentarioPub.scrollView:getView() Var.comentarioPub.scrollView:setScrollHeight(sv.contentHeight)
				
			end
		end
		function Var.comentarioPub.criarComentario(event)
			
			local acrescentar = ""
			if event and event.target.id then
				print("event.target.id",event.target.id)
				acrescentar = "&idComentario="..event.target.id
			end
			local telaProtetiva = auxFuncs.TelaProtetiva()
			telaProtetiva.alpha = .8
			local function textListener( event )
	 
				if ( event.phase == "began" ) then
					-- User begins editing "defaultBox"
			 
				elseif ( event.phase == "ended" or event.phase == "submitted" ) then
					-- Output resulting text from "pdefaultBox"
					print( event.target.text )
			 
				elseif ( event.phase == "editing" ) then
					print( event.newCharacters )
					print( event.oldText )
					print( event.startPosition )
					print( event.text )
				end
			end
			-- Create text box
			
			local defaultBox = native.newTextBox( W/2, 10 + 3*W/8, 9*W/10 - 60, 3*W/4 - 60 )
			defaultBox.placeHolder = "coloque sua mensagem aqui."
			defaultBox.text = ""
			defaultBox.isEditable = true
			defaultBox.size = 30
			defaultBox:addEventListener( "userInput", textListener )
			defaultBox.hasBackground = false
			native.setKeyboardFocus( defaultBox )
			local fundoTextBox = display.newImageRect("campoEditar.png",9*W/10 ,3*W/4)
			fundoTextBox.anchorY=0.5
			fundoTextBox.anchorX=0.5
			fundoTextBox.x = defaultBox.x
			fundoTextBox.y = defaultBox.y
			local cancelar
			local notificacao = nil
			if event.target.params then
				notificacao = event.target.params
			end
			
			local salvar = widget.newButton(
			{
				top = fundoTextBox.y + fundoTextBox.height/2 + 20,
				left = fundoTextBox.x - fundoTextBox.width/2 ,
				shape = "roundedRect",
				label = "enviar",
				labelAlign = "center",
				labelColor = { default={ 0, 0, 0 }, over={ 1, 1, 1, 0.5 } },
				font = "Fontes/paolaAccent.ttf",
				fontSize = 40,
				onRelease = function(e)
								native.setKeyboardFocus( nil );
								local permissao = ""
								if string.find(varGlobal.preferenciasGerais.permissaoComentarios,"sim") then
									permissao = "&permissao=V" -- Verificando -- Reprovado -- Aprovado
								elseif string.find(varGlobal.preferenciasGerais.permissaoComentarios,"nao") then
									permissao = "&permissao=A"
								end
								local parameters = {}
								parameters.body = "Criar=1&idLivro=" .. varGlobal.idLivro1  .. "&idUsuario=" .. varGlobal.idAluno1 .. "&pagina=" .. telas.paginaHistorico .. "&conteudo=" .. defaultBox.text .. "&situacao=" .. "A" .. acrescentar..permissao
								local URL2 = "https://omniscience42.com/EAudioBookDB/comentarios.php"
								network.request(URL2, "POST", 
									function(event2)
										if ( event2.isError ) then
											native.showAlert("Falha no envio","Sua mensagem não pôde ser enviada, verifique sua conexão com a internet e tente novamente",{"OK"})
										else
											--print("WARNING: 24",event2.response)
											cancelar:removeSelf()
											defaultBox:removeSelf()
											fundoTextBox:removeSelf()
											e.target:removeSelf()
											telaProtetiva:removeSelf()
											
											if permissao == "&permissao=V" then
												native.showAlert("Mensagem Enviada","Sua mensagem foi enviada com sucesso, Aguarde o mwoderador ou autor verificar e permitir esse comentário",{"OK"})
											end
											
											local subPagina = telas.subPagina
											historicoLib.Criar_e_salvar_vetor_historico({
												tipoInteracao = "comentário",
												pagina_livro = telas.pagina,
												objeto_id = nil,
												acao = "criar comentário",
												conteudo = defaultBox.text,
												subPagina = subPagina,
												tela = telas
											})
											
											Var.comentarioPub.atualizarComentarios()
											-- enviar notificação para o dono do comentário
											if notificacao then
												print("WARNING: notificacao:")
												print(defaultBox.text)
												print(notificacao.mensagemOutro)
												print(notificacao.pagina)
												print(notificacao.apelidoOutro)
												print(notificacao.apelido)
												print(notificacao.email)
												print(notificacao.nomeLivro)
												
												print("WARNING: end notificacao")
												
												local vetorJson = {}
												vetorJson.tipoDeAcesso = "notificarMensagemResposta"
												vetorJson.toMail = notificacao.email
												
												
												vetorJson.mensagemOutro = notificacao.mensagemOutro
												vetorJson.mensagem = defaultBox.text
												vetorJson.pagina = notificacao.pagina
												vetorJson.apelidoOutro = notificacao.apelidoOutro
												vetorJson.apelido = notificacao.apelido
												vetorJson.emailOriginal = varGlobal.EmailLogin1
												vetorJson.email = notificacao.email
												vetorJson.nomeLivro = notificacao.nomeLivro
												
											
												local headers = {}
												headers["Content-Type"] = "application/json"
												local parameters = {}
												parameters.headers = headers
												local data = json.encode(vetorJson)

												parameters.body = data
												local function notifRespostaListener(event)
													--print("|"..tostring(event.response).."|")
													if ( event.isError ) then
														  print("Network Error . Check Connection", "Connect to Internet")
													else
														if string.find(event.response,"Email nao enviado") then
														elseif string.find(event.response,"Email enviado") then
															--print(event.response)
														elseif string.find(event.response,"Email nao encontrado") then
															--print(event.response)
														else
															--print(event.response)
														end
													end
												end
												local URL = "https://omniscience42.com/EAudioBookDB/sendMail.php" --mongo.php"
												network.request(URL, "POST", notifRespostaListener,parameters)
												
												-- NOTIFICAR TODOS SE FOR AUTOR --
												notificacaoMensagemAutor(vetorJson)
												----------------------------------
											end
											
										end
									end,parameters)

							end,
				width = 200,
				height = 50,
				fillColor = { default={ 0.18, 0.67, 0.785, 1 }, over={ 0.004, 0.368, 0.467, 1 } },
				strokeColor = { default={ 0, 0, 0 }, over={ 0, 0, 0,.7 } },
				strokeWidth = 2,
				cornerRadius = 2
			})
			
			cancelar = widget.newButton(
			{
				top = fundoTextBox.y + fundoTextBox.height/2 + 20,
				left = fundoTextBox.x + fundoTextBox.width/2 - 200,
				shape = "roundedRect",
				label = "cancelar",
				labelAlign = "center",
				labelColor = { default={ 0, 0, 0 }, over={ 1, 1, 1, 0.5 } },
				font = "Fontes/paolaAccent.ttf",
				fontSize = 40,
				onRelease = function(e)
								native.setKeyboardFocus( nil );
								salvar:removeSelf()
								defaultBox:removeSelf()
								fundoTextBox:removeSelf()
								e.target:removeSelf()
								telaProtetiva:removeSelf()
							end
				,
				width = 200,
				height = 50,
				fillColor = { default={ 0.9, 0.2, 0.1, 1 }, over={ 0.7, 0.02, 0.01, 1 } },
				strokeColor = { default={ 0, 0, 0 }, over={ 0, 0, 0,.7 } },
				strokeWidth = 2,
				cornerRadius = 2
			})
		end
		function Var.comentarioPub.comentarioListener( event )
			print("WARNING: COMEÇOU coment listener")
			local numeroT = 1
			local EstaVazio = true
			-- pegando vetor de comentários do banco de dados
			if ( event.isError ) then
				
				Var.comentarioPub.vetorComentarios = {}
				Var.comentarioPub.vetorComentarios[1] = {}
				Var.comentarioPub.vetorComentarios[1].conteudo = "Conexão com a internet falhou:"
			elseif Var.comentarioPub then
				local json = require("json")
				--print("WARNING: |||CCC!!!")
				--print(varGlobal.idProprietario1)
				--print(event.response)
				--print("WARNING: |||FFF!!!")
				Var.comentarioPub.vetorComentarios = json.decode(event.response)
				
				if Var.comentarioPub.vetorComentarios and Var.comentarioPub.vetorComentarios.vazio == false then
					numeroT = Var.comentarioPub.vetorComentarios.N
					EstaVazio = false
					Var.anotComInterface.Icone.fill.effect = nil
				elseif Var.comentarioPub.vetorComentarios and Var.comentarioPub.vetorComentarios.vazio == true then
					Var.comentarioPub.vetorComentarios = {}
					Var.comentarioPub.vetorComentarios[1] = {}
					Var.comentarioPub.vetorComentarios[1].conteudo = "Não existem mensagens a se exibir nesta página."
				end
				local comentariosComPai = {}
				
				for i=1,numeroT do
					if EstaVazio == false then
						Var.comentarioPub.vetorComentarios[i] = Var.comentarioPub.vetorComentarios[tostring(i)]
						--se autor e id autor comentario são iguais faça:
						local function trocarElementoTable(t, old, new)
							local value = t[old]
							if new < old then
							   table.move(t, new, old - 1, new + 1)
							else    
							   table.move(t, old + 1, new, old) 
							end
							t[new] = value
						end
						 
						Var.comentarioPub.vetorComentarios[i].filhos = {}
						Var.comentarioPub.vetorComentarios[i].filhos.aberto = false
					end
					
				end
				for i=1,numeroT do
					if Var.comentarioPub.vetorComentarios[i].usuarioID == varGlobal.idProprietario1 then
						table.insert(Var.comentarioPub.vetorComentarios, 1, table.remove(Var.comentarioPub.vetorComentarios,i))
						--trocarElementoTable(Var.comentarioPub.vetorComentarios, i, 1)
					end
				end
				
				-- separando os comentarios que têm comentário pai e retirando comentarios removidos.
				local function forAuxiliar0(i,limite)
					if Var.comentarioPub.vetorComentarios[i].situacao == "D" then -- já estou filtrando no php, mas vou deixar arrumado caso seja necessário depois
						table.remove(Var.comentarioPub.vetorComentarios,i)
						limite = limite-1
						i = i-1
					elseif Var.comentarioPub.vetorComentarios[i].permissao and (Var.comentarioPub.vetorComentarios[i].permissao == "V" or Var.comentarioPub.vetorComentarios[i].permissao == "R") then
						table.remove(Var.comentarioPub.vetorComentarios,i)
						limite = limite-1
						i = i-1
					else
						if Var.comentarioPub.vetorComentarios[i].pai then
							table.insert(comentariosComPai,Var.comentarioPub.vetorComentarios[i])
							table.remove(Var.comentarioPub.vetorComentarios,i)
							limite = limite-1
							i = i-1
						end
					end
					Var.comentarioPub.rodarLoopFor0(i+1,limite)
				end
				function Var.comentarioPub.rodarLoopFor0(i,limite)
					if i<=limite then forAuxiliar0(i,limite); end
				end
				Var.comentarioPub.rodarLoopFor0(1,numeroT)
				
				for i=1,#comentariosComPai do
					print("I = ",i)
					for k=1,#Var.comentarioPub.vetorComentarios do
						print("K = ",k)
						print("CId = ",Var.comentarioPub.vetorComentarios[k].comentarioID)
						print("Pai = ",comentariosComPai[i].pai)
						print("ID = ",comentariosComPai[i].usuarioID)
						if Var.comentarioPub.vetorComentarios[k].comentarioID == comentariosComPai[i].pai then
							print("ACHOU")
							table.insert(Var.comentarioPub.vetorComentarios[k].filhos,comentariosComPai[i])
						end
					end
				end
				
			end
			
			-- guardando o vetor para montagem posterior do TTS --
			Var.anotComInterface.varCtrl.mensLida = true
			Var.anotComInterface.varCtrl.mensCont = {}
			print("Cont Var.comentarioPub.vetorComentarios = ",#Var.comentarioPub.vetorComentarios)
			for cont=1,#Var.comentarioPub.vetorComentarios do
				Var.anotComInterface.varCtrl.mensCont[cont] = {}
				--varCtrl.mensCont[cont] = Var.comentarioPub.vetorComentarios[cont]
				Var.anotComInterface.varCtrl.mensCont[cont].conteudo = Var.comentarioPub.vetorComentarios[cont].conteudo
				print("conteudo mens "..cont.." "..Var.anotComInterface.varCtrl.mensCont[cont].conteudo)
				if Var.comentarioPub.vetorComentarios[cont].filhos then
					Var.anotComInterface.varCtrl.mensCont[cont].filhos = {}
					for cont2 = 1,#Var.comentarioPub.vetorComentarios[cont].filhos do
						Var.anotComInterface.varCtrl.mensCont[cont].filhos[cont2] = {}
						Var.anotComInterface.varCtrl.mensCont[cont].filhos[cont2].conteudo = Var.comentarioPub.vetorComentarios[cont].filhos[cont2].conteudo
						print("conteudo res "..cont2.." "..Var.anotComInterface.varCtrl.mensCont[cont].filhos[cont2].conteudo)
					end
				end
			end
			--------------------------------------------------------------------
			-- arrumando formatação texto encontrado -> grupoComentario
			if Var.comentarioPub.gruposComentarios then
				Var.comentarioPub.gruposComentarios:removeSelf()
				Var.comentarioPub.gruposComentarios = nil
			end
			local alturaRetanguloComment = 0
			Var.comentarioPub.gruposComentarios = display.newGroup()
			Var.comentarioPub.scrollView = widget.newScrollView(
				{
					width = Var.anotComInterface.retanguloFundo.width-30,
					height = alturaScroll,--Var.anotComInterface.retanguloFundo.height-200,
					scrollHeight = Var.anotComInterface.retanguloFundo.height,
					hideBackground = true,
					horizontalScrollDisabled  = true,
					listener = scrollListener
				}
			)
			Var.comentarioPub.scrollView.anchorY=0
			Var.comentarioPub.scrollView.anchorX=0
			Var.comentarioPub:insert(2,Var.comentarioPub.scrollView)
			Var.comentarioPub.scrollView.x = -50
			Var.comentarioPub.scrollView.y = Var.comentarioPub.rectTop.y + distanciaScroll
			Var.comentarioPub.gruposComentarios:insert(Var.comentarioPub.scrollView)
			Var.comentarioPub.vetorPrinc = {}
			Var.comentarioPub.vetorSec = {}
			Var.comentarioPub.respostaAberta = false
			
			if Var.comentarioPub.rectTop.x then -- verificar se cancelou antes da leitura
				
				criarBaloesDeComentarios(Var.comentarioPub.vetorComentarios)
				Var.comentarioPub.posOriginal = Var.comentarioPub.y
				
				local function entrarComMensagem()
					native.setKeyboardFocus( Var.comentarioPub.textField );
					Var.comentarioPub.y = Var.comentarioPub.posOriginal - H/2
					local sv=Var.comentarioPub.scrollView:getView() Var.comentarioPub.scrollView:setScrollHeight(sv.contentHeight+100)
					Var.comentarioPub.scrollView:scrollTo( "bottom", { time=0 } )
					Var.comentarioPub.protTelaMensagem = auxFuncs.TelaProtetiva()
					Var.comentarioPub.protTelaMensagem.y = - 200
					Var.comentarioPub.protTelaMensagem.isVisible=false
					timer.performWithDelay(10,function()Var.comentarioPub.protTelaMensagem.isHitTestable = true end,1)
					Var.comentarioPub.textField.isVisible=true
					Var.comentarioPub.protTelaMensagem:addEventListener("tap",function() 
						Var.comentarioPub.y = Var.comentarioPub.posOriginal; 
						native.setKeyboardFocus(nil);
						Var.comentarioPub.protTelaMensagem:removeSelf();
						Var.comentarioPub.protTelaMensagem=nil 
						local sv=Var.comentarioPub.scrollView:getView()
						Var.comentarioPub.textField.isVisible = false
						if Var.comentarioPub.vetorComentarios.vazio == true or sv.contentHeight < Var.comentarioPub.scrollView.height then
							Var.comentarioPub.scrollView:scrollTo( "top", { time=0 } )
						end
					end)
					--Var.comentario.scrollView:scrollTo( "top", { time=0 } )
				end
				
				Var.comentarioPub.comentar = widget.newButton(
				{
					defaultFile = "comentar.png",
					overFile = "comentar.png",
					onRelease = entrarComMensagem,
					width = Var.anotComInterface.fundoBranco.width-100,
					height = 75
				})
				Var.comentarioPub.comentar.anchorX = 0
				Var.comentarioPub.comentar.anchorY = 1
				Var.comentarioPub.comentar.id = nil
				Var.comentarioPub.comentar.y = Var.anotComInterface.retanguloFundo.y + Var.anotComInterface.retanguloFundo.height - 10
				Var.comentarioPub.comentar.x = Var.anotComInterface.retanguloFundo.x - Var.anotComInterface.retanguloFundo.width/2 + 10
				Var.comentarioPub.gruposComentarios:insert(Var.comentarioPub.comentar)
				
				Var.comentarioPub.textField = native.newTextField(0,0,Var.comentarioPub.rectTop.width - 100,50)
				Var.comentarioPub.textField.isVisible = false
				Var.comentarioPub.textField.x = Var.anotComInterface.fundoBranco.x - Var.anotComInterface.fundoBranco.width/2 + Var.comentarioPub.textField.width/2 + 20
				Var.comentarioPub.textField.y = Var.anotComInterface.fundoBranco.y + Var.anotComInterface.fundoBranco.height - Var.comentarioPub.textField.height/2 - 30
				Var.comentarioPub.gruposComentarios:insert(Var.comentarioPub.textField)
				Var.comentarioPub.textField.hasBackground = false
				
				function Var.comentarioPub.atualizarComentarios()
					if Var.comentarioPub.gruposComentarios then
						Var.comentarioPub.gruposComentarios:removeSelf()
						Var.comentarioPub.gruposComentarios = nil
					end
					
					Var.comentarioPub.gruposComentarios = display.newGroup()
					Var.comentarioPub.scrollView = widget.newScrollView(
						{
							width = Var.anotComInterface.retanguloFundo.width-30,
							height = Var.anotComInterface.retanguloFundo.height-200,
							scrollHeight = Var.anotComInterface.retanguloFundo.height,
							hideBackground = true,
							horizontalScrollDisabled  = true,
							listener = scrollListener
						}
					)
					Var.comentarioPub.scrollView.anchorY=0
					Var.comentarioPub.scrollView.anchorX=0
					Var.comentarioPub:insert(2,Var.comentarioPub.scrollView)
					Var.comentarioPub.scrollView.x = -50
					Var.comentarioPub.scrollView.y = Var.comentarioPub.rectTop.y + 2+100
					Var.comentarioPub.gruposComentarios:insert(Var.comentarioPub.scrollView)
					
					Var.comentarioPub.vetorComentarios = nil
					Var.comentarioPub.vetorPrinc = {}
					Var.comentarioPub.vetorSec = {}
					Var.comentarioPub.respostaAberta = false
					alturaRetanguloComment = 0
					local sv=Var.comentarioPub.scrollView:getView() Var.comentarioPub.scrollView:setScrollHeight(sv.contentHeight)
				
					local parameters = {}
					parameters.body = "consulta=1&codigoLivro=" .. varGlobal.codigoLivro1 .. "&pagina=" .. telas.paginaHistorico.."&idUsuario=" .. varGlobal.idAluno1
					local URL2 = "https://omniscience42.com/EAudioBookDB/comentarios.php"
					network.request(URL2, "POST", Var.comentarioPub.comentarioListener,parameters)
				end
				
				function Var.comentarioPub.enviarMensagem()
					if Var.comentarioPub.textField and Var.comentarioPub.textField.text and Var.comentarioPub.textField.text ~= "" then
						native.setKeyboardFocus( nil );
						if Var.comentarioPub.protTelaMensagem then
							Var.comentarioPub.protTelaMensagem:removeSelf();
							Var.comentarioPub.protTelaMensagem=nil 
						end
						Var.comentarioPub.y = Var.comentarioPub.posOriginal;
						local permissao = ""
						local acrescentar = ""--idcomentario pai
						if string.find(varGlobal.preferenciasGerais.permissaoComentarios,"sim") then
							permissao = "&permissao=V" -- Verificando -- Reprovado -- Aprovado
						elseif string.find(varGlobal.preferenciasGerais.permissaoComentarios,"nao") then
							permissao = "&permissao=A"
						end
						local parameters = {}
						
						parameters.body = "Criar=1&idLivro=" .. varGlobal.idLivro1  .. "&idUsuario=" .. varGlobal.idAluno1 .. "&pagina=" .. telas.paginaHistorico .. "&conteudo=" .. Var.comentarioPub.textField.text .. "&situacao=" .. "A" .. acrescentar..permissao
						print(parameters.body)
						local URL2 = "https://omniscience42.com/EAudioBookDB/comentarios.php"
						network.request(URL2, "POST", 
							function(event)
								
								if ( event.isError ) then
									native.showAlert("Falha no envio","Sua mensagem não pôde ser enviada, verifique sua conexão com a internet e tente novamente",{"OK"})
								else
									print("WARNING: 24",event.response)
									Var.comentarioPub.textField.text = ""
									if permissao == "&permissao=V" then
										native.showAlert("Mensagem Enviada","Sua mensagem foi enviada com sucesso, Aguarde o mwoderador ou autor verificar e permitir esse comentário",{"OK"})
									end
									
									local subPagina = telas.subPagina
									historicoLib.Criar_e_salvar_vetor_historico({
										tipoInteracao = "comentário",
										pagina_livro = telas.pagina,
										objeto_id = nil,
										acao = "criar comentário",
										conteudo = Var.comentarioPub.textField.text,
										subPagina = subPagina,
										tela = telas
									})
									
									Var.comentarioPub.atualizarComentarios()
									
									--notificacaoMensagemAutor()??
								end
							end,parameters)
					end
				end
				
				Var.comentarioPub.enviar = widget.newButton(
				{
					defaultFile = "send.png",
					overFile = "sendD.png",
					width = 70,
					height = 70,
					onRelease = Var.comentarioPub.enviarMensagem,
				})
				Var.comentarioPub.enviar.anchorX = 0
				Var.comentarioPub.enviar.anchorY = 1
				Var.comentarioPub.enviar.y = Var.comentarioPub.comentar.y
				Var.comentarioPub.enviar.x = Var.comentarioPub.comentar.x + Var.comentarioPub.comentar.width + 5
				Var.comentarioPub.gruposComentarios:insert(Var.comentarioPub.enviar)
				
				
				alturaRetanguloComment = Var.comentarioPub.gruposComentarios.height + 15
				
				Var.comentarioPub:insert(Var.comentarioPub.gruposComentarios)
				local sv=Var.comentarioPub.scrollView:getView() Var.comentarioPub.scrollView:setScrollHeight(sv.contentHeight)
				
				print("WARNING: FIM")
			end
			
		end
		local parameters = {}
		parameters.body = "consulta=1&codigoLivro=" .. varGlobal.codigoLivro1 .. "&pagina=" .. telas.paginaHistorico.."&idUsuario=" .. varGlobal.idAluno1
		print("parameters.body",parameters.body)
		local URL2 = "https://omniscience42.com/EAudioBookDB/comentarios.php"
		network.request(URL2, "POST", Var.comentarioPub.comentarioListener,parameters)
		--------------------------------------------------p
		
	
	end
	
	
	-- Timer Para Verificar se os comentarios e anotaçõesz foram lidos
	-- Após verificar, criar botão TTS com os textos encontrados
	Var.anotComInterface.varCtrl.criarBotaoTTSAux2 = function()
		if (Var.anotComInterface and Var.anotComInterface.varCtrl and Var.anotComInterface.varCtrl.mensLida) or ( not Var.comentarioPub and Var.anotComInterface.varCtrl) then
			print("ACHOU TTS MENSANOT!!!!")
			if not Var.comentarioPub then
				Var.anotComInterface.varCtrl.mensCont = {conteudo = "O fórum da página não pôde ser acessado."}
			end
			
			Var.botaoTTSAnotComentarios2 = M.criarBotaoTTSComentario(
				{
					tela = telas,
					pagina = telas.anotMensTTS.paginaHistorico,
					tipo = telas.anotMensTTS.tipo,
					APIkey = telas.anotMensTTS.apiKey,
					idioma = telas.anotMensTTS.idioma,
					voz = telas.anotMensTTS.voz,
					velocidade = telas.anotMensTTS.velocidade,
					neural = telas.anotMensTTS.neural, 
					qualidade = telas.anotMensTTS.qualidade,
					extencao = telas.anotMensTTS.extencao, 
					diretorioBase = telas.anotMensTTS.diretorio,
					tapResponse = telas.anotMensTTS.respostaTapAudio,
					audioSemNet = telas.anotMensTTS.botaoSemInternet,
					pastaArquivos = telas.anotMensTTS.pastaArquivos,
					pasta = telas.anotMensTTS.pasta,
					somBotao1 = telas.anotMensTTS.somBotao1,
					temHistorico = telas.anotMensTTS.temHistorico,
					subPagina = telas.anotMensTTS.subPagina,
					funcionalidade = "mensagens",
					vetorMens = Var.anotComInterface.varCtrl.mensCont,
					vetorAnot = ""
					}
				,Var
			)
			print("CRIOU TTS MENSANOT!!!!")
			if Var.anotComInterface.timerTTS2 then
				timer.cancel(Var.anotComInterface.timerTTS2)
				Var.anotComInterface.timerTTS2 = nil
			end
		end
	end
	Var.anotComInterface.varCtrl.criarBotaoTTSAux = function()
		if (Var.anotComInterface and Var.anotComInterface.varCtrl and Var.anotComInterface.varCtrl.mensLida and Var.anotComInterface.varCtrl.anotLida) or ( not Var.comentario and Var.anotComInterface.varCtrl and Var.anotComInterface.varCtrl.anotLida) then
			print("ACHOU TTS MENSANOT!!!!")
			if not Var.comentario then
				Var.anotComInterface.varCtrl.mensCont = {conteudo = "O fórum da página não pôde ser acessado."}
			end
			if Var.anotComInterface.varCtrl.anotCont == "" or #Var.anotComInterface.varCtrl.anotCont<=1 then
				Var.anotComInterface.varCtrl.anotCont = "Anotação:\nNenhuma anotação foi criada!"
			else
				Var.anotComInterface.varCtrl.anotCont = "Anotação:\n"..Var.anotComInterface.varCtrl.anotCont
			end
			
			Var.botaoTTSAnotComentarios = M.criarBotaoTTSComentario(
				{
					tela = telas,
					pagina = telas.anotMensTTS.paginaHistorico,
					tipo = telas.anotMensTTS.tipo,
					APIkey = telas.anotMensTTS.apiKey,
					idioma = telas.anotMensTTS.idioma,
					voz = telas.anotMensTTS.voz,
					velocidade = telas.anotMensTTS.velocidade,
					neural = telas.anotMensTTS.neural, 
					qualidade = telas.anotMensTTS.qualidade,
					extencao = telas.anotMensTTS.extencao, 
					diretorioBase = telas.anotMensTTS.diretorio,
					tapResponse = telas.anotMensTTS.respostaTapAudio,
					audioSemNet = telas.anotMensTTS.botaoSemInternet,
					pastaArquivos = telas.anotMensTTS.pastaArquivos,
					pasta = telas.anotMensTTS.pasta,
					somBotao1 = telas.anotMensTTS.somBotao1,
					temHistorico = telas.anotMensTTS.temHistorico,
					subPagina = telas.anotMensTTS.subPagina,
					funcionalidade = "mensagens",
					vetorMens = Var.anotComInterface.varCtrl.mensCont,
					vetorAnot = Var.anotComInterface.varCtrl.anotCont
				}
				,Var
			)
			print("CRIOU TTS MENSANOT!!!!")
			if Var.anotComInterface.timerTTS then
				timer.cancel(Var.anotComInterface.timerTTS)
				Var.anotComInterface.timerTTS = nil
			end
		end
	end
	
	Var.anotComInterface.criarInterfaceBasicaForum = function(tipo)
		local PosY = Var.anotComInterface.y
		local PosX = Var.anotComInterface.x
		local strokeWidth = 1
		if tipo and tipo == "publico" then
			Var.anotComInterface.timerTTS2 = timer.performWithDelay(100,Var.anotComInterface.varCtrl.criarBotaoTTSAux2,-1)
		else
			Var.anotComInterface.timerTTS = timer.performWithDelay(100,Var.anotComInterface.varCtrl.criarBotaoTTSAux,-1)
		end
		Var.anotComInterface.telaProtetiva = auxFuncs.TelaProtetiva()
		Var.anotComInterface.telaProtetiva.alpha = .8
		Var.anotComInterface.telaProtetiva.x = Var.anotComInterface.telaProtetiva.x - PosX
		Var.anotComInterface.telaProtetiva.y = Var.anotComInterface.telaProtetiva.y - PosY
		Var.anotComInterface:insert(Var.anotComInterface.telaProtetiva)
		--Var.anotComInterface.fundoBranco = display.newRect(50,100,W-90,H-200)
		Var.anotComInterface.fundoBranco = M.colocarSeparador({espessura = H-200,largura = W-125,cor = {255,255,255},y=105})
		Var.anotComInterface.fundoBranco.strokeWidth = 5
		Var.anotComInterface.fundoBranco:setStrokeColor(46/255,171/255,200/255)
		Var.anotComInterface.fundoBranco.x = Var.anotComInterface.fundoBranco.x - PosX
		Var.anotComInterface.fundoBranco.y = Var.anotComInterface.fundoBranco.y - PosY
		local function FecharBarra(e)
			local somFechando = audio.loadSound("audioTTS_anotacaoEForum fechar.MP3")
			audio.play(somFechando)
			if Var.botaoTTSAnotComentarios then
				Var.botaoTTSAnotComentarios:removeSelf()
				Var.botaoTTSAnotComentarios = nil
			end
			if Var.botaoTTSAnotComentarios2 then
				Var.botaoTTSAnotComentarios2:removeSelf()
				Var.botaoTTSAnotComentarios2 = nil
			end
			if Var.anotComInterface.telaProtetiva then
				if Var.anotComInterface.timerTTS then
					timer.cancel(Var.anotComInterface.timerTTS)
					Var.anotComInterface.timerTTS=nil
				end
				Var.anotComInterface.telaProtetiva:removeSelf()
				Var.anotComInterface.telaProtetiva=nil
				Var.anotComInterface.fundoBranco:removeSelf()
				Var.anotComInterface.fundoBranco=nil
				Var.anotComInterface.fechar:removeSelf()
				Var.anotComInterface.fechar=nil
				if Var.anotacao and Var.anotacao.rectTop then
					Var.anotacao.rectTop:removeSelf()
					Var.anotacao.rectTop=nil
				end
				if Var.comentario and Var.comentario.rectTop then
					
					Var.comentario.rectTop:removeSelf()
					Var.comentario.rectTop=nil
					Var.comentario:removeSelf()
					Var.comentario=nil
				end
				if Var.anotacao and Var.anotacao.rectTopEsconder1 then
					Var.anotacao.rectTopEsconder1:removeSelf()
				end

				if Var.anotacao then
					Var.anotacao.rectTop=nil
				end
				if Var.anotacao then
					Var.anotacao.rectTopEsconder1=nil
				end
				
				
				if Var.anotacao then
					Var.anotacao:removeSelf()
				end
				Var.anotacao=nil
				if Var.anotComInterface.retanguloFundo then
					Var.anotComInterface.retanguloFundo:removeSelf()
					Var.anotComInterface.retanguloFundo=nil
				end
				if Var.comentarioPub then
					Var.comentarioPub:removeSelf()
					Var.comentarioPub = nil
				end
			end
			
			return true
		end
		Var.anotComInterface.fechar = widget.newButton {
			onRelease = FecharBarra,
			emboss = false,
			-- Properties for a rounded rectangle button
			defaultFile = "closeMenuButton2.png",
			overFile = "closeMenuButton2D.png",
			width = 58,
			height = 58
		}
		Var.anotComInterface.fechar.clicado = false
		Var.anotComInterface.fechar.tipo = "fechar"
		Var.anotComInterface.fechar.anchorX=1
		Var.anotComInterface.fechar.anchorY=0
		Var.anotComInterface.fechar.x = W - 62
		Var.anotComInterface.fechar.y = 105
		--Var.anotComInterface.fundoBranco.anchorY=0; Var.anotComInterface.fundoBranco.anchorX=0
		Var.anotComInterface:insert(Var.anotComInterface.fundoBranco)

		Var.anotComInterface.retanguloFundo = display.newRoundedRect(Var.anotComInterface.fundoBranco.x,Var.anotComInterface.fundoBranco.y,Var.anotComInterface.fundoBranco.width-8,Var.anotComInterface.fundoBranco.height-8,6)
		Var.anotComInterface.retanguloFundo.anchorY=0
		Var.anotComInterface.retanguloFundo.strokeWidth = 2
		Var.anotComInterface.retanguloFundo:setStrokeColor(0,0,0)
		Var.anotComInterface.retanguloFundo:setFillColor(.9,.9,.9)
		Var.anotComInterface:insert(Var.anotComInterface.retanguloFundo)
	end
	
	local function abrirBarra(e)
		
		
		
		if e.target.clicado == false  then
			audio.stop()
			media.stopSound()
			
			local som = audio.loadStream(varGlobal.ttsForumMenuRapido1Clique)
			local timerRequerimento = timer.performWithDelay(16,function() audio.play(som) end,1)
			e.target.clicado = true
			timer.performWithDelay(1000,function() e.target.clicado = false end,1)
			return true
		end
		if e.target.clicado == true  then
			audio.stop()
			e.target.clicado = false
			local somAbrindo = audio.loadSound("audioTTS_anotacaoEForum.MP3")
			audio.play(somAbrindo)
			local function forum()
				
				local PosY = Var.anotComInterface.y
				local PosX = Var.anotComInterface.x
				Var.anotComInterface.criarInterfaceBasicaForum()
				Var.comentarioPub = display.newGroup()
				Var.anotComInterface:insert(Var.comentarioPub)
				
				Var.comentarioPub.rectTop = display.newRect(0,0,Var.anotComInterface.fundoBranco.width-8,Var.anotComInterface.fechar.height)
				Var.comentarioPub.rectTop.anchorY=0
				Var.comentarioPub.rectTop.x = Var.anotComInterface.fundoBranco.x
				Var.comentarioPub.rectTop.y = Var.anotComInterface.fundoBranco.y
				Var.comentarioPub.rectTop:setFillColor(46/255,171/255,200/255)
				Var.comentarioPub.rectTop.strokeWidth=1
				Var.comentarioPub.rectTop:setStrokeColor(0,0,0)
				Var.comentarioPub:insert(Var.comentarioPub.rectTop)
				
				Var.comentarioPub.tituloBarra = display.newText("mensagens públicas",0,0,0,0,"Fontes/paolaAccent.ttf",48)
				Var.comentarioPub.tituloBarra.anchorY=0.5
				Var.comentarioPub.tituloBarra.x = Var.comentarioPub.rectTop.x-20
				Var.comentarioPub.tituloBarra.y = Var.comentarioPub.rectTop.y + Var.comentarioPub.rectTop.height/2
				Var.comentarioPub.tituloBarra:setFillColor(0,0,0)
				Var.comentarioPub:insert(Var.comentarioPub.tituloBarra)
				
				if telas.ativarLogin == "sim" then
					criarCampoComentarioPub()
				end
			end
			local function anotacoes()
				
				local PosY = Var.anotComInterface.y
				local PosX = Var.anotComInterface.x
				Var.anotComInterface.criarInterfaceBasicaForum()
				Var.anotacao = display.newGroup()
				Var.comentarioPub = display.newGroup()
				Var.anotComInterface:insert(Var.comentarioPub)
				Var.anotComInterface:insert(Var.anotacao)
				
				Var.anotacao.rectTop = display.newRect(0,0,Var.anotComInterface.fundoBranco.width-8,Var.anotComInterface.fechar.height)
				Var.anotacao.rectTop.anchorY=0
				Var.anotacao.rectTop.x = Var.anotComInterface.fundoBranco.x
				Var.anotacao.rectTop.y = Var.anotComInterface.fundoBranco.y
				Var.anotacao.rectTop:setFillColor(46/255,171/255,200/255)
				Var.anotacao.rectTop.strokeWidth=1
				Var.anotacao.rectTop:setStrokeColor(0,0,0)
				Var.anotacao:insert(Var.anotacao.rectTop)
				
				Var.anotacao.tituloBarra = display.newText("Anotações Pessoais",0,0,0,0,"Fontes/paolaAccent.ttf",50)
				Var.anotacao.tituloBarra.anchorY=0.5
				Var.anotacao.tituloBarra.x = Var.anotacao.rectTop.x - 10
				Var.anotacao.tituloBarra.y = Var.anotacao.rectTop.y + Var.anotacao.rectTop.height/2
				Var.anotacao.tituloBarra:setFillColor(0,0,0)
				Var.anotacao:insert(Var.anotacao.tituloBarra)
					
				criarCampoAnotacao()
			end
			local function Mensagens(idContato)
				
				--===============================================================================--
				-- INTERFACE GERAL --
				--===============================================================================--
				local PosY = Var.anotComInterface.y
				local PosX = Var.anotComInterface.x
				
				Var.comentario.tituloBarra = display.newText("Mensagens Privadas",0,0,0,0,"Fontes/paolaAccent.ttf",48)
				Var.comentario.tituloBarra.anchorY=0.5
				Var.comentario.tituloBarra.x = Var.comentario.rectTop.x - 20
				Var.comentario.tituloBarra.y = Var.comentario.rectTop.y + Var.comentario.rectTop.height/2
				Var.comentario.tituloBarra:setFillColor(0,0,0)
				Var.comentario:insert(Var.comentario.tituloBarra)

				criarCampoComentario(idContato)
			end
			local function MenuContatosMensagens()
				local group = display.newGroup()
				
				Var.comentario = display.newGroup()
				
				Var.anotComInterface.criarInterfaceBasicaForum()
				
				Var.anotComInterface:insert(Var.comentario)
				
				Var.comentario.rectTop = display.newRect(0,0,Var.anotComInterface.fundoBranco.width-8,Var.anotComInterface.fechar.height)
				Var.comentario.rectTop.anchorY=0
				Var.comentario.rectTop.x = Var.anotComInterface.fundoBranco.x
				Var.comentario.rectTop.y = Var.anotComInterface.fundoBranco.y
				Var.comentario.rectTop:setFillColor(46/255,171/255,200/255)
				Var.comentario.rectTop.strokeWidth=1
				Var.comentario.rectTop:setStrokeColor(0,0,0)
				Var.comentario:insert(Var.comentario.rectTop)
				
				Var.comentario.grupoContatos = display.newGroup() 
				Var.comentario:insert(Var.comentario.grupoContatos)
				
				Var.comentario.tituloContatos = display.newText("Contatos",0,0,0,0,"Fontes/paolaAccent.ttf",48)
				Var.comentario.tituloContatos.anchorY=0.5
				Var.comentario.tituloContatos.x = Var.comentario.rectTop.x
				Var.comentario.tituloContatos.y = Var.comentario.rectTop.y + Var.comentario.rectTop.height/2
				Var.comentario.tituloContatos:setFillColor(0,0,0)
				Var.comentario.grupoContatos:insert(Var.comentario.tituloContatos)
				
				Var.comentario.onRowTouch = function( event )
					local row = event.target
					if event.phase == "release" then
						Var.comentario.grupoContatos.isVisible = false
						Mensagens(row.params.contato.usuario_id)
					end
				end
				Var.comentario.onRowRender = function( event )

					-- Get reference to the row group
					local row = event.row

					-- Cache the row "contentWidth" and "contentHeight" because the row bounds can change as children objects are added
					local rowHeight = row.contentHeight
					local rowWidth = row.contentWidth
					local contact = row.params.contato
					
					local rect = display.newRect(row,0,0,rowWidth,rowHeight)
					if row.index%2 == 0 then
						rect:setFillColor(.9,.9,.9)
					else
						rect:setFillColor(1,1,1)
					end
					rect.anchorX=0
					rect.anchorY=0
					
					if varGlobal.idProprietario1 == contact.usuario_id then
						local seloDoAutor = display.newImageRect("comentarioAutor.png",140,40)
						seloDoAutor.x = rowWidth - 5
						seloDoAutor.y = rowHeight/2
						seloDoAutor.anchorX=1
						seloDoAutor.anchorY=.5
						seloDoAutor.alpha = .9
						row:insert(seloDoAutor)
					end

					local rowTitle = display.newText( row,contact.apelido_usuario, 0, 0, nil, 40 )
					rowTitle:setFillColor( 0 )
					local avatar
					if auxFuncs.fileExistsTemp(contact.arq_img_usuario) then
						avatar = display.newImageRect(contact.arq_img_usuario,system.TemporaryDirectory,4*rowHeight/5,4*rowHeight/5)
					else
						avatar = display.newImageRect("avatar.png",4*rowHeight/5,4*rowHeight/5)
					end
					avatar.x=5
					avatar.y=rowHeight/2
					avatar.anchorX=0
					row:insert(avatar)

					rowTitle.anchorX = 0
					rowTitle.x = avatar.x+avatar.width+5
					rowTitle.y = rowHeight * 0.5
				end
				
				Var.comentario.createAllRows = function(vetor)
					for i = 1,vetor.nLeitores do
						local params = {}
						params.progress = true
						--"https://www.coronasdkgames.com/libEA 2"
						local function aposBaixar(event)
							print("baixando?",event.response)
							if ( event.isError ) then
								print( "Network error - download failed: ", event.response )
							elseif ( event.phase == "began" ) then
								print( "Progress Phase: began" )
							elseif ( event.phase == "ended" ) then
								print( "Displaying response image file" )
								Var.comentario.tableContacts:insertRow(
									{
										rowHeight = 100,
										rowColor = rowColor,
										lineColor = lineColor,
										params = {contato = vetor[tostring(i)]}
									}
								)
							end
						end
						auxFuncs.downloadArquivo(vetor[tostring(i)].arq_img_usuario,"https://livrosdic.s3.us-east-2.amazonaws.com/perfil",aposBaixar)
					end
				end
				Var.comentario.tableContacts = widget.newTableView(
					{
						height = Var.anotComInterface.fundoBranco.height - Var.comentario.rectTop.height - 10,
						width = Var.anotComInterface.fundoBranco.width - 10,
						onRowRender = Var.comentario.onRowRender,
						onRowTouch = Var.comentario.onRowTouch,
						--listener = scrollListener,
						rowTouchDelay =0
					}
				)
				Var.comentario.tableContacts.anchorY=0
				Var.comentario.tableContacts.x = Var.anotComInterface.fundoBranco.x - Var.anotComInterface.fundoBranco.width/2 + Var.comentario.tableContacts.width/2+5
				Var.comentario.tableContacts.y = Var.anotComInterface.fundoBranco.y + Var.comentario.rectTop.height
				Var.comentario.grupoContatos:insert(Var.comentario.tableContacts)
				
				Var.comentario.addContact = auxFuncs.createNewButton({
					defaultFile = "addContact.png",
					overFile = "addContactD.png",
					height = 100,
					width=100,
					onRelease = function()
						native.showAlert("Atenção","Você não possui privilégios suficientes para adicionar novos contatos!",{"ok"})
					end
				})
				Var.comentario.addContact.x = Var.anotComInterface.fundoBranco.x + Var.anotComInterface.fundoBranco.width/2 - Var.comentario.addContact.width/2 - 10
				Var.comentario.addContact.y = Var.anotComInterface.fundoBranco.y + Var.anotComInterface.fundoBranco.height - Var.comentario.addContact.height/2 - 10
				Var.comentario.grupoContatos:insert(Var.comentario.addContact)
				
				Var.comentario.addGroup = auxFuncs.createNewButton({
					defaultFile = "addGroup.png",
					overFile = "addGroupD.png",
					height = 100,
					width=100,
					onRelease = function()
						native.showAlert("Atenção","Você não possui privilégios suficientes para adicionar novos contatos!",{"ok"})
					end
				})
				Var.comentario.addGroup.x = Var.anotComInterface.fundoBranco.x + Var.anotComInterface.fundoBranco.width/2 - Var.comentario.addGroup.width/2 - 10 - 100 - 10
				Var.comentario.addGroup.y = Var.anotComInterface.fundoBranco.y + Var.anotComInterface.fundoBranco.height - Var.comentario.addGroup.height/2 - 10
				Var.comentario.grupoContatos:insert(Var.comentario.addGroup)
				function Var.comentario.comentarioListener( event )
					print("WARNING: COMEÇOU coment listener")
					local numeroT = 1
					local EstaVazio = true
					-- pegando vetor de comentários do banco de dados
					if ( event.isError ) then
						
					else
						local json = require("json")
						local vetor = json.decode(event.response)
						if vetor.message and vetor.message == "sucesso" then
							local numero = tonumber(vetor.nleitores)
							Var.comentario.createAllRows(vetor)
						end
					end
				end
				local parameters = {}
				parameters.body = "livro_id=" .. varGlobal.idLivro1 .. "&autor_id="..varGlobal.idProprietario1
				local URL2 = "https://omniscience42.com/EAudioBookDB/lerDadosLeitoresContatoLivro.php"
				network.request(URL2, "POST", Var.comentario.comentarioListener,parameters)
			end
			
			local function criarBalaoOpcoes()
				local group = display.newGroup()
				
				local function aoSelecionarOpcao( event )
					if ( event.target.tipo == "publicas" ) then
						group:removeSelf()
						group = nil
						forum()
					elseif ( event.target.tipo == "privadas" ) then
						group:removeSelf()
						group = nil
						
						MenuContatosMensagens()
					elseif ( event.target.tipo == "anotacao" ) then
						group:removeSelf()
						group = nil
						anotacoes()
					end
				end
				
				group.telaProtetiva = auxFuncs.TelaProtetiva()
				group.telaProtetiva:setFillColor(0,0,0)
				group.telaProtetiva.alpha = 0.7
				group:insert(group.telaProtetiva)

				group.fundo = auxFuncs.displayShape({width=600,height=330,x=W/2,y=H/2,radius=10,shape="roundedRect"})
				group.fundo.strokeWidth=4
				group.fundo:setStrokeColor(46/255,171/255,200/255,.7)
				group:insert(group.fundo)
				
				local options = {align="center",text = "FÓRUM",x=W/2,y=H/2-110,font="Fontes/ariblk.ttf",size=80}
				group.titulo = display.newText(options)
				group.titulo:setFillColor(0,0,0)
				group:insert(group.titulo)
				
				group.botaoPublicas = auxFuncs.createNewButton(
					{
						shape = "roundedRect",
						label = "MENSAGENS\nPÚBLICAS",
						font = "Fontes/ariblk.ttf",
						labelColor = {default = {1,1,1,1},over = {0,0,0,0.5}},
						fillColor = {default = {46/255,171/255,200/255,1},over = {46/255,171/255,200/255,0.5}},
						size = 30,
						width = 230,
						height = 100,
						strokeWidth = 1,
						onRelease = aoSelecionarOpcao
					}
				)
				group.botaoPublicas.btn.tipo = "publicas"
				group.botaoPublicas.x = W/2 - 150
				group.botaoPublicas.y = H/2
				group:insert(group.botaoPublicas)
				group.botaoPrivadas = auxFuncs.createNewButton(
					{
						shape = "roundedRect",
						label = "MENSAGENS\nPRIVADAS",
						font = "Fontes/ariblk.ttf",
						labelColor = {default = {1,1,1,1},over = {0,0,0,0.5}},
						size = 30,
						width = 230,
						height = 100,
						strokeWidth = 1,
						onRelease = aoSelecionarOpcao
					}
				)
				group.botaoPrivadas.btn.tipo = "privadas"
				group.botaoPrivadas.x = W/2 + 150
				group.botaoPrivadas.y = H/2
				group:insert(group.botaoPrivadas)
				
				group.botaoAnotacoes = auxFuncs.createNewButton(
					{
						shape = "roundedRect",
						label = "ANOTAÇÕES PESSOAIS",
						font = "Fontes/ariblk.ttf",
						labelColor = {default = {0,0,0,1},over = {1,1,1,0.8}},
						fillColor = {default={.9,.9,.9,1},over={0,0,0,.5}},
						size = 30,
						width = 420,
						height = 70,
						strokeWidth = 1,
						onRelease = aoSelecionarOpcao
					}
				)
				group.botaoAnotacoes.btn.tipo = "anotacao"
				group.botaoAnotacoes.x = W/2
				group.botaoAnotacoes.y = H/2 + 110
				group:insert(group.botaoAnotacoes)
			end
			criarBalaoOpcoes()
			--native.showAlert("FÓRUM DE MENSAGENS","",{"PRIVADAS","PÚBLICAS"},aoSelecionarOpcao)
		end
		
	end
	
	Var.anotComInterface.Icone:addEventListener("tap",abrirBarra)
	Var.anotComInterface.Icone.clicado = false
end

----------------------------------------------------------
--  COLOCAR BOTÃO IMPRIMIR --
----------------------------------------------------------
function M.formatarCardParaImpressaoAux(vetorCards,i,pagina,vetorImagensCards,telas)
	local grupoCard = display.newGroup()
	local destino = system.TemporaryDirectory
	local nomeArquivo = "Pagina ".. pagina .. " Card "..vetorCards[i].numeroCard..".png"
	local nomeDoLivro = "HiperBook"
	if auxFuncs.fileExistsDoc("nomeLivro.txt") then
		nomeDoLivro = auxFuncs.lerTextoDoc("nomeLivro.txt")
	end
	grupoCard.titulo = colocarFormatacaoTexto.criarTextodePalavras({
		texto = vetorCards[i].titulo,
		margem = 70,
		alinhamento = "meio",
		cor = {0,0,0},
		x = nil,
		Y = 0,
		fonte = "segoeui.ttf",
		tamanho = 50,
		xNegativo = nil,
		temHistorico = false
	})
	grupoCard.titulo.y = 0
	grupoCard.separadorTitulo = M.colocarSeparador({espessura = 10,largura = W-80,cor = {0,0,0},raio = 5,x=W/2,Y=0})
	grupoCard.separadorTitulo.y=grupoCard.titulo.y + grupoCard.titulo.height + 20
	local posY = grupoCard.separadorTitulo.y + grupoCard.separadorTitulo.height + 20
	local posX = W/2
	grupoCard.elemento = nil
	local scale = 0.8
	if vetorCards[i].tipo == "texto" then
		grupoCard.elemento = colocarFormatacaoTexto.criarTextodePalavras({
			texto = vetorCards[i].texto,
			margem = 70,
			alinhamento = "justificado",
			cor = {0,0,0},
			x = nil,
			Y = posY,
			fonte = "segoeui.ttf",
			tamanho = 35,
			xNegativo = nil,
			temHistorico = false
		})
		scale=1
	elseif vetorCards[i].tipo == "imagem" then
		print("|"..tostring(vetorCards[i].arquivo).."|")
		local imagem = system.pathForFile("Paginas/Outros Arquivos/imagemErro.jpg")
		if vetorCards[i].arquivo then imagem = vetorCards[i].arquivo end
		grupoCard.elemento = M.colocarImagem({
			arquivo = imagem,
			y = posY
		})
		grupoCard.elemento.x = W/2 - (grupoCard.elemento.width/2)*scale
		grupoCard.elemento.xScale = scale
		grupoCard.elemento.yScale = scale
	elseif vetorCards[i].tipo == "video" then
		local video = system.pathForFile("Paginas/Outros Arquivos/video vazio.m4v")
		if vetorCards[i].arquivo then video = vetorCards[i].arquivo end
		grupoCard.elemento = M.colocarVideo({
			arquivo = video,
			x = 0
		},telas)
		grupoCard.elemento.y = posY
		scale = 0.5
		grupoCard.elemento.x = W/2
		grupoCard.elemento.xScale = scale
		grupoCard.elemento.yScale = scale
	elseif vetorCards[i].tipo == "som" then
		local som = system.pathForFile("Paginas/Outros Arquivos/som vazio.WAV")
		if vetorCards[i].arquivo then som = vetorCards[i].arquivo end
		grupoCard.elemento = M.colocarSom({
			arquivo = som,
			x = 0
		},telas)
		grupoCard.elemento.y = posY
		grupoCard.elemento.x = W/2 - (grupoCard.elemento.width/2)*scale
		grupoCard.elemento.xScale = scale
		grupoCard.elemento.yScale = scale
	elseif vetorCards[i].tipo == "animacao" then
		local pasta = system.pathForFile("Paginas/Outros Arquivos/Anim Padrao.lib")
		if vetorCards[i].pasta then pasta = vetorCards[i].pasta end
		grupoCard.elemento = M.colocarAnimacao({
			pasta = pasta,
			x = 0
		},telas)
		grupoCard.elemento.y = posY
		grupoCard.elemento.x = W/2
		grupoCard.elemento.xScale = scale
		grupoCard.elemento.yScale = scale
	elseif vetorCards[i].tipo == "exercicio" then
		grupoCard.elemento = M.criarExercicio({
			pasta = vetorCards[i].pasta,
			enunciado = vetorCards[i].enunciado,
			alternativas = vetorCards[i].alternativas,
			corretas = vetorCards[i].corretas,
			alinhamento = "justificado",
			x = 0,
			y = 0,
			tamanhoFonte = 55,
			tamanhoFonteAlternativas = 40,
			margem = 40,
			tipo = "CARD",
			mensagemCorreta = vetorCards[i].mensagemCorreta,
			mensagemErrada = vetorCards[i].mensagemErrada,
			funcaoCard = function() end
		},telas)
		grupoCard.elemento.y = posY
	end
	grupoCard:insert(grupoCard.titulo)
	grupoCard:insert(grupoCard.separadorTitulo)
	if grupoCard.elemento then
		grupoCard:insert(grupoCard.elemento)
	end
	
	local posFundoFinal = grupoCard.separadorTitulo.y + grupoCard.separadorTitulo.height
	if grupoCard.elemento then
		posFundoFinal = grupoCard.elemento.y + grupoCard.elemento.height*scale
	end
	
	local vetorTextosCards = vetorCards.vetorDeTextosDosCards
	vetorCards[i].textoExtra = nil
	if vetorCards.vetorDeTextosDosCards then
		for cad=1,#vetorCards.vetorDeTextosDosCards do
			if tonumber(vetorCards.vetorDeTextosDosCards[cad].numeroCard) == i then
				vetorCards[i].textoExtra = vetorCards.vetorDeTextosDosCards[cad].texto
			end
		end
	end
	
	if vetorCards[i].textoExtra then
		grupoCard.textoExtra = colocarFormatacaoTexto.criarTextodePalavras({
			texto = "#font=paolaAccent.ttf#Observações Pessoais...#/font#\n"..vetorCards[i].textoExtra,
			margem = 70,
			alinhamento = "justificado",
			cor = {0,0,0},
			x = nil,
			Y = grupoCard.y + grupoCard.height + 10,
			fonte = "segoeui.ttf",
			tamanho = 35,
			xNegativo = nil,
			temHistorico = false
		})
		grupoCard:insert(grupoCard.textoExtra)
		grupoCard.textoExtra.anchorY=0
		posFundoFinal = grupoCard.textoExtra.y + grupoCard.textoExtra.height + 10
	end
	vetorCards[i].textoExtra = nil

	--grupoCard:insert(1,grupoCard.fundo)
	
	grupoCard.quadradoNumero = display.newRoundedRect(0,0,100,100,10)
	grupoCard.quadradoNumero.strokeWidth = 4
	grupoCard.quadradoNumero:setStrokeColor(0,0,0)
	grupoCard.quadradoNumero.anchorX = 1
	grupoCard.quadradoNumero.anchorY = 0
	grupoCard.quadradoNumero.x = W - 45
	grupoCard.quadradoNumero.y = grupoCard.y + grupoCard.height
	if grupoCard.quadradoNumero.y < 500 then grupoCard.quadradoNumero.y = 500 end
	grupoCard:insert(grupoCard.quadradoNumero)
	
	
	grupoCard.espacoExtra = M.colocarSeparador({espessura = 5,largura = W-80,cor = {255,255,255},x=W/2,Y=0})
	grupoCard.espacoExtra.y=grupoCard.quadradoNumero.y + grupoCard.quadradoNumero.height
	grupoCard:insert(grupoCard.espacoExtra)
	
	grupoCard.nomelivro = display.newText("Livro: "..nomeDoLivro,0,0,"segoeui.ttf",30)
	
	local larguraNomeLivro = grupoCard.nomelivro.width
	while larguraNomeLivro > 4*W/7 do
		grupoCard.nomelivro:removeSelf()
		nomeDoLivro = string.sub(nomeDoLivro,1,#nomeDoLivro-1)
		grupoCard.nomelivro = display.newText("Livro: "..nomeDoLivro.."...",0,0,"segoeui.ttf",30)
		larguraNomeLivro = grupoCard.nomelivro.width
	end
	grupoCard.nomelivro:setFillColor(0,0,0)
	grupoCard.nomelivro.anchorX=0
	grupoCard.nomelivro.anchorY=1
	grupoCard.nomelivro.x = 45
	grupoCard.nomelivro.y = grupoCard.quadradoNumero.y + grupoCard.quadradoNumero.height
	grupoCard:insert(grupoCard.nomelivro)
	
	grupoCard.paglivro = display.newText("pag "..vetorCards[i].pagina,0,0,"segoeui.ttf",25)
	grupoCard.paglivro:setFillColor(0,0,0)
	grupoCard.paglivro.anchorX=0
	grupoCard.paglivro.anchorY=1
	grupoCard.paglivro.x = grupoCard.nomelivro.x + grupoCard.nomelivro.width + 15
	grupoCard.paglivro.y = grupoCard.nomelivro.y
	grupoCard:insert(grupoCard.paglivro)
	
	
	display.save( grupoCard, { filename=nomeArquivo, baseDir=destino, captureOffscreenArea=true, backgroundColor={1,1,1} } )
	
	
	
	table.insert(vetorImagensCards,nomeArquivo)
	
	--------------------------------------------------
	-- se for exercicio, adicionar cada alternativa --
	if grupoCard.textoExtra then
		grupoCard.textoExtra:removeSelf()
		grupoCard.textoExtra = nil
	end
	if vetorCards[i].tipo == "exercicio" then
		if vetorCards[i].pasta then
			local numeroAlternativas = #vetorCards[i].alternativas
			
			local manipularTela = require("manipularTela")
			local titulox = grupoCard.titulo.x
			local tituloy = grupoCard.titulo.y
			for j=1,numeroAlternativas do
				if auxFuncs.fileExists(vetorCards[i].pasta.."/"..j..".txt") then
					grupoCard.elemento:removeSelf()
					grupoCard.elemento = nil
					grupoCard.titulo:removeSelf()
					grupoCard.titulo = nil
					
					grupoCard.titulo = colocarFormatacaoTexto.criarTextodePalavras({
						texto = "Resposta Alternativa "..j,
						margem = 70,
						alinhamento = "meio",
						cor = {0,0,0},
						x = nil,
						Y = 0,
						fonte = "segoeui.ttf",
						tamanho = 50,
						xNegativo = nil,
						temHistorico = false
					})
					grupoCard.titulo.y = tituloy
					grupoCard:insert(grupoCard.titulo)
					
					local scriptPagina = auxFuncs.lerArquivoTXTCaminho({caminho = system.pathForFile(vetorCards[i].pasta.."/"..j..".txt"),tipo = "texto"})
					local pastaAtual = string.gsub(telas.pastaArquivosAtual,"/Outros Arquivos","")
					grupoCard.elemento = manipularTela.criarUmaTela(
						{
							pasta = pastaAtual,
							arquivo = j..".txt",
							scriptDaPagina = scriptPagina,
							exercicio = vetorCards[i].pasta,
							correta = " ",
							card = true,
						},function()end)
					grupoCard.elemento:scale(.9,.9)
					grupoCard.elemento.x = grupoCard.elemento.x + grupoCard.elemento.width/20
					grupoCard.elemento.y = grupoCard.elemento.y
					grupoCard:insert(grupoCard.elemento)
					
					nomeArquivo = "Pagina ".. pagina .. " Card "..vetorCards[i].numeroCard.." Alternativa "..j..".png"
					
					grupoCard.quadradoNumero.x = W - 45
					grupoCard.quadradoNumero.y = grupoCard.elemento.y + grupoCard.elemento.height
					grupoCard.nomelivro.y = grupoCard.quadradoNumero.y + grupoCard.quadradoNumero.height
					grupoCard.paglivro.x = grupoCard.nomelivro.x + grupoCard.nomelivro.width + 15
					grupoCard.paglivro.y = grupoCard.nomelivro.y
					
					display.save( grupoCard, { filename=nomeArquivo, baseDir=destino, captureOffscreenArea=true, backgroundColor={1,1,1} } )
					
					table.insert(vetorImagensCards,nomeArquivo)
				end
			end
		end
	end
	--------------------------------------------------
	--------------------------------------------------
	
	grupoCard:removeSelf()
	grupoCard = nil
end
function M.gerarVetorECardsDePagina(vetorCardsLivro,vetorImagensCards,paginaAtual,telas)
	local destino = system.TemporaryDirectory
	-- iniciar um loop para cada card da pagina
	print(vetorCardsLivro,paginaAtual,vetorCardsLivro[paginaAtual])
	if vetorCardsLivro[paginaAtual] then
		print("verificar vetor cards: ","Deck_pag"..paginaAtual..".json")
		M.checarCardsOnlinePagina(paginaAtual,telas)
		if auxFuncs.fileExistsDoc("Deck_pag"..paginaAtual..".json") then
			print("verificar vetor cards2: ","Deck_pag"..paginaAtual..".json")
			vetorCardsLivro[paginaAtual].vetorDeTextosDosCards = auxFuncs.loadTable("Deck_pag"..paginaAtual..".json")
		end
		for card=1,#vetorCardsLivro[paginaAtual] do
			-- criar os cards no formato de card e salvar um print de cada um
			M.formatarCardParaImpressaoAux(vetorCardsLivro[paginaAtual],card,paginaAtual,vetorImagensCards,telas)
		end
	end
end
function M.EnviarImagensDasPaginasEmPDF(vetorImagensCards,telaAguarde)
	local destino = system.TemporaryDirectory
	
	local nomeDoLivro = "HiperBook"
	if auxFuncs.fileExistsDoc("nomeLivro.txt") then
		nomeDoLivro = auxFuncs.lerTextoDoc("nomeLivro.txt")
	end
	nomeDoLivro = string.gsub(nomeDoLivro,"([^%w ]+)","_")
	
	pdfImageConverter.toPdf(system.pathForFile(vetorImagensCards[1], destino), system.pathForFile(string.gsub(vetorImagensCards[1],"png","pdf"), destino))

	for i=2,#vetorImagensCards do
		--testarNoAndroid(Var2.atachmentZip[i],i*50)
		print(vetorImagensCards[i])
		local arq1 = string.gsub(vetorImagensCards[i-1],"png","pdf")
		local arq2 = string.gsub(vetorImagensCards[i],"png","pdf")
		local nome2 = string.gsub(vetorImagensCards[i],"%.png","")
		local pdf1 = system.pathForFile(arq1,destino)
		local pdf2 = system.pathForFile(arq2,destino)
		pdfImageConverter.toPdf(system.pathForFile(vetorImagensCards[i], destino), pdf2)
		os.rename(pdf2,system.pathForFile(nome2 .."_old.pdf",destino))
		print(pdf2)
		pdfImageConverter.combinePdf(pdf1, system.pathForFile(nome2 .."_old.pdf",destino),pdf2)
	end
	print(string.gsub(vetorImagensCards[#vetorImagensCards],"png","pdf"))
	local arqFinal = string.gsub(vetorImagensCards[#vetorImagensCards],"png","pdf")
	os.rename(system.pathForFile(arqFinal,destino),system.pathForFile("Cards do Livro _".. nomeDoLivro ..".pdf",destino))
	print(system.pathForFile(arqFinal,destino))
	print(system.pathForFile("Cards do Livro _".. nomeDoLivro ..".pdf",destino))
	print("Cards do Livro _".. nomeDoLivro ..".pdf")
	-- enviar o pdf após acabar
	
	local arquivo = string.gsub(vetorImagensCards[#vetorImagensCards],"png","pdf")--"livro.pdf"--
	local destino = system.TemporaryDirectory
	-- tirar todos os caracteres que não sejam alphanumericos(%w) ou espaços
	
	telaAguarde.timer = timer.performWithDelay(100,
		function(e) 
			if telaAguarde and telaAguarde.timer and auxFuncs.fileExistsTemp("Cards do Livro _".. nomeDoLivro ..".pdf") then
				timer.cancel(telaAguarde.timer)
				telaAguarde.timer = nil
				telaAguarde:removeSelf()
				telaAguarde = nil
			end
		end,
	-1)
	local options =
	{
		to = "",
		subject = "Cards do Livro: "..nomeDoLivro,
		body = "PDF dos cards contidos no livro: " .. nomeDoLivro .. " para impressão.",
		attachment = { baseDir=system.TemporaryDirectory, filename="Cards do Livro _".. nomeDoLivro ..".pdf", type="document/pdf" },
		listener = function(event) 
			if telaAguarde then
				if telaAguarde.timer then
					timer.cancel(telaAguarde.timer)
					telaAguarde.timer = nil
				end
				telaAguarde:removeSelf()
				telaAguarde = nil
			end
		end
	}
	native.showPopup( "mail", options )
end
function M.criarBotaoImpressao(pagina,telas,Var,varGlobal,GRUPOGERAL)
	local grupoImpressao = display.newGroup()
	local manipularTela = require("manipularTela")
	
	local function RemoverPaginaAnterior(Var2)
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
	local function pegarNumeroRealPagina(paginaSistema)
		local pagina
		print(paginaSistema)
		if type(paginaSistema) == "number" then
			pagina = paginaSistema + varGlobal.contagemInicialPaginas -varGlobal.numeroTotal.PaginasPre-varGlobal.numeroTotal.Indices -1
		else
			--paginaPaginas_Pagina49_PagExerc1Alt3_3
			local aux1 = string.match(paginaSistema,"_Pagina%d+")
			local aux1_2 = string.match(aux1,"%d+")
			local paginaSistema = tonumber(aux1_2) + varGlobal.contagemInicialPaginas -varGlobal.numeroTotal.PaginasPre-varGlobal.numeroTotal.Indices -1
		
			local aux2 = string.match(paginaSistema,"_PagExerc%d+")
			local aux2_1 = string.match(aux2,"%d+")
			local exerc_atual = tonumber(aux2_1)
		
			local aux3 = string.match(paginaSistema,"Alt%d+")
			local aux3_1 = string.match(aux3,"%d+")
			local alt_atual = tonumber(aux3_1)
		
			pagina = tostring(paginaSistema)..", exercício "..exerc_atual..", alternativa "..alt_atual
		
		end
		return pagina
	end
	local function criarImagensDasPaginas(vetorTelas)
		local Var2 = {}
		
		Var2.atachment = {}
		Var2.atachmentZip = {}
		local numeroTotalVetor = #vetorTelas.PaginasAux
		local cont2 = 1
		Var2.grupoTravarTela = display.newGroup()
		local telaPreta = display.newRect(0,0,W,H)
		telaPreta.anchorX = 0.5; telaPreta.anchorY = 0.5
		telaPreta.anchorX = 0.5; telaPreta.anchorY = 0.5
		telaPreta.x = W/2; telaPreta.y = H/2
		telaPreta.x = W/2; telaPreta.y = H/2
		telaPreta:setFillColor(1,1,1)
		telaPreta.alpha=0.9
		telaPreta:addEventListener("tap",function() return true end)
		telaPreta:addEventListener("touch",function() return true end)
		local optionAguarde = {
			text = "aguarde",
			x = W/2,
			y = H/2,
			font = "Fontes/segoeuib.ttf",
			align = "center",
			fontSize = 50
		}
		local textoTravarTela = display.newText(optionAguarde)
		textoTravarTela:setFillColor(0,0,0)
		Var2.grupoTravarTela:insert(telaPreta)
		Var2.grupoTravarTela:insert(textoTravarTela)
		
		local function loopPaginas()
		--while cont2<=numeroTotalVetor do
			vetorTelas.vetorRodapes = telas.vetorRodapes
			vetorTelas.vetorDic = telas.vetorDic
			
			local GRUPOGERAL2 = display.newGroup()
			GRUPOGERAL2.ultimaPaginaSalva = nil
			local i = vetorTelas.PaginasAux[cont2]
			vetorTelas.contagemDaPaginaHistorico = pegarNumeroRealPagina(i)
			
			if vetorTelas[i] then
				vetorTelas[i].cont = {}
				vetorTelas[i].cont.imagemTextos = 1
				vetorTelas[i].cont.imagens = 1
				vetorTelas[i].cont.textos = 1
				vetorTelas[i].cont.animacoes = 1
				vetorTelas[i].cont.exercicios = 1
				vetorTelas[i].cont.botoes = 1
				vetorTelas[i].cont.espacos = 1
				vetorTelas[i].cont.separadores = 1
				vetorTelas[i].cont.videos = 1
				vetorTelas[i].cont.sons = 1
			end
			Var2.proximoY = 100
			-- criar a página e salvar a imagem dela
			
			if vetorTelas[i] ~= nil and vetorTelas[i].ordemElementos ~= nil then
				for ord=1, #vetorTelas[i].ordemElementos do
					vetorTelas.elementoAtual = ord
					
					if vetorTelas[i] ~= nil then
						if(vetorTelas[i].ordemElementos[ord] == "imagem") then
							if not Var2.imagens then Var2.imagens = {} end
							local ims = vetorTelas[i].cont.imagens
							if vetorTelas[i].imagens[ims].arquivo then
								Var2.imagens[ims] = ead.colocarImagem(vetorTelas[i].imagens[ims],vetorTelas)
								Var2.imagens[ims].conteudo = vetorTelas[i].imagens[ims].conteudo
								Var2.imagens[ims].atributoALT = vetorTelas[i].imagens[ims].atributoALT
								Var2.imagens[ims].y = Var2.imagens[ims].y + Var2.proximoY
								Var2.imagens[ims].contImagem = ims
								Var2.proximoY = Var2.imagens[ims].y + Var2.imagens[ims].height
								GRUPOGERAL2:insert(Var2.imagens[ims]) 
							end  
				  
							vetorTelas[i].cont.imagens =  vetorTelas[i].cont.imagens + 1
						end
						--verifica se tem espaço
						if(vetorTelas[i].ordemElementos[ord] == "espaco") then
							if not Var2.espacos then Var2.espacos = {} end
							local esp = vetorTelas[i].cont.espacos
			
							Var2.espacos[esp] = M.colocarEspaco(vetorTelas[i].espacos[esp])
							vetorTelas[i].cont.espacos =  vetorTelas[i].cont.espacos + 1
							Var2.espacos[esp].y = Var2.espacos[esp].y + Var2.proximoY
							Var2.proximoY = Var2.espacos[esp].y + Var2.espacos[esp].height
						end
						--verifica se tem separador
						if(vetorTelas[i].ordemElementos[ord] == "separador") then
							if not Var2.separadores then Var2.separadores = {} end
							local sep = vetorTelas[i].cont.separadores
			
							Var2.separadores[sep] = M.colocarSeparador(vetorTelas[i].separadores[sep])
							vetorTelas[i].cont.separadores =  vetorTelas[i].cont.separadores + 1
							Var2.separadores[sep].y = Var2.separadores[sep].y + Var2.proximoY
							Var2.proximoY = Var2.separadores[sep].y + Var2.separadores[sep].height
							GRUPOGERAL2:insert(Var2.separadores[sep])
						end
						--verifica se tem som
						if(vetorTelas[i].ordemElementos[ord] == "som") then
							if not Var2.sons then Var2.sons = {} end
							local son = vetorTelas[i].cont.sons
			
							Var2.sons[son] = M.colocarSom(vetorTelas[i].sons[son],vetorTelas)
							vetorTelas[i].cont.sons =  vetorTelas[i].cont.sons + 1
							Var2.sons[son].y = Var2.sons[son].y + Var2.proximoY
							Var2.proximoY = Var2.sons[son].y + Var2.sons[son].height
							GRUPOGERAL2:insert(Var2.sons[son])
						end
						--verifica se tem video
						if(vetorTelas[i].ordemElementos[ord] == "video") then
							if not Var2.videos then Var2.videos = {} end
							local vids = vetorTelas[i].cont.videos
			
							Var2.videos[vids] = M.colocarVideo(vetorTelas[i].videos[vids],vetorTelas)
							Var2.videos[vids].contVideo = vetorTelas[i].cont.videos
							vetorTelas[i].cont.videos =  vetorTelas[i].cont.videos + 1
							Var2.videos[vids].y = Var2.videos[vids].y + Var2.proximoY
							Var2.proximoY = Var2.videos[vids].y + Var2.videos[vids].videoH
							GRUPOGERAL2:insert(Var2.videos[vids])
						end

						if(vetorTelas[i].ordemElementos[ord] == "exercicio") then
							if not Var2.eXercicios then Var2.eXercicios = {} end
							local exes = vetorTelas[i].cont.exercicios
			
							Var2.eXercicios[exes] = {}
							Var2.eXercicios[exes][1] = {}
							Var2.eXercicios[exes][1],Var2.eXercicios[exes][2],Var2.eXercicios[exes][3],Var2.eXercicios[exes][4],Var2.eXercicios[exes][5],Var2.eXercicios[exes][6] = ead.criarExercicio(vetorTelas[i].exercicios[exes],vetorTelas)
							if vetorTelas[i].exercicios[exes].corretas and #vetorTelas[i].exercicios[exes].corretas > 1 then
									Var2.eXercicios[exes][5].tipo = "multiplas"
								else
									Var2.eXercicios[exes][5].tipo = "simples"
							end
							Var2.eXercicios[exes][5].exe = exes
							Var2.eXercicios[exes][5].contExerc = vetorTelas[i].cont.exercicios
							vetorTelas[i].cont.exercicios =  vetorTelas[i].cont.exercicios + 1
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
		
						if(vetorTelas[i].ordemElementos[ord] == "indiceManual") then
							local function funcRetorno() end
							vetorTelas[i].indiceManual.impressao = true
							Var2.indiceManual = ead.colocarIndicePreMontado(vetorTelas[i].indiceManual,vetorTelas,funcRetorno)
							while Var2.indiceManual.numChildren > 0 do
								Var2.indiceManual[1].y = Var2.indiceManual[1].y + Var2.indiceManual.y
								Var2.indiceManual[1].x = Var2.indiceManual[1].x + Var2.indiceManual.x
								Var2.indiceManual[1].anchorX=Var2.indiceManual.anchorX
								Var2.indiceManual[1].anchorY=Var2.indiceManual.anchorY
								
								GRUPOGERAL2:insert(Var2.indiceManual[1])
							end
						end
		
						if(vetorTelas[i].ordemElementos[ord] == "texto") then
							if not Var2.textos then Var2.textos = {} end
							local txt = vetorTelas[i].cont.textos
							vetorTelas[i].textos[txt].contTexto = txt
							Var2.textos[txt] = M.colocarTexto(vetorTelas[i].textos[txt],vetorTelas)
							vetorTelas[i].cont.textos = vetorTelas[i].cont.textos + 1
							Var2.textos[txt].txt = vetorTelas[i].textos[txt].texto
							Var2.textos[txt].iii = txt
							Var2.textos[txt].y = Var2.textos[txt].y + Var2.proximoY
							Var2.proximoY = Var2.textos[txt].y + Var2.textos[txt].height
							GRUPOGERAL2:insert(Var2.textos[txt])      
						end
						--Verifica se tem animacao
						if(vetorTelas[i].ordemElementos[ord] == "animacao") then
							if not Var2.animacoes then Var2.animacoes = {} end
							local ani = vetorTelas[i].cont.animacoes
			
							Var2.animacoes[ani] = M.colocarAnimacao(vetorTelas[i].animacoes[ani],vetorTelas)
							vetorTelas[i].cont.animacoes = vetorTelas[i].cont.animacoes + 1
							Var2.animacoes[ani].y = Var2.animacoes[ani].y + Var2.proximoY
							Var2.proximoY = Var2.animacoes[ani].y + Var2.animacoes[ani].height
							GRUPOGERAL2:insert(Var2.animacoes[ani])
						end 
						--verifica se tem botao
						if(vetorTelas[i].ordemElementos[ord] == "botao") then
			
							if not Var2.botoes then Var2.botoes = {} end
							local bot = vetorTelas[i].cont.botoes
			
							Var2.botoes[bot] = M.colocarBotao(vetorTelas[i].botoes[bot],vetorTelas)
							vetorTelas[i].cont.botoes =  vetorTelas[i].cont.botoes + 1
							Var2.botoes[bot].y = Var2.botoes[bot].y + Var2.proximoY
							Var2.botoes[bot].YY = Var2.botoes[bot].YY + Var2.proximoY
							Var2.proximoY = Var2.botoes[bot].y + Var2.botoes[bot].height
							GRUPOGERAL2:insert(Var2.botoes[bot])
						end	
		
						if(vetorTelas[i].ordemElementos[ord] == "imagemTexto") then
							if not Var2.imagemTextos then Var2.imagemTextos = {} end
							local imtx = vetorTelas[i].cont.imagemTextos
			
							Var2.imagemTextos[imtx] = M.colocarImagemTexto(vetorTelas[i].imagemTextos[imtx],vetorTelas)
							vetorTelas[i].cont.imagemTextos =  vetorTelas[i].cont.imagemTextos + 1
							Var2.imagemTextos[imtx].y = Var2.imagemTextos[imtx].y + Var2.proximoY
							Var2.proximoY = Var2.imagemTextos[imtx].y + Var2.imagemTextos[imtx].height

							if Var2.imagemTextos[imtx] then
								GRUPOGERAL2:insert(Var2.imagemTextos[imtx])
							end	
						end
						if GRUPOGERAL2.height > 1300 then
							local paginaLivro = pegarNumeroRealPagina(i)
							local destino = system.TemporaryDirectory
							Var2.separouPaginas = true
							
							if not GRUPOGERAL2.numeroTelaTemp then GRUPOGERAL2.numeroTelaTemp = 1 end
							GRUPOGERAL2.grupoTemp = display.newGroup()
							local YInicial = 0
							if(vetorTelas[i].ordemElementos[ord] == "indiceManual") then
								local xx = 1
								while GRUPOGERAL2.numChildren > 0 do
									
									GRUPOGERAL2.grupoTemp:insert(GRUPOGERAL2[1])
									
									if GRUPOGERAL2.grupoTemp.height > 1300 then
										xx = xx + 1
										local textoNumeroPagina = display.newText(optionAguarde)
										textoNumeroPagina.anchorY=0
										textoNumeroPagina:setFillColor(0,0,0)
										local auxPaginaLivro = tostring(paginaLivro)
										if string.find(auxPaginaLivro,"%-") then
											textoNumeroPagina.text = auxFuncs.ToRomanNumerals(string.gsub(auxPaginaLivro,"%-",""))
										else
											textoNumeroPagina.text = auxPaginaLivro
										end
										textoNumeroPagina.text = textoNumeroPagina.text .. "_"..GRUPOGERAL2.numeroTelaTemp
										
										local rect = display.newRect(0,0,0,0)
										rect:setFillColor(1,1,1)
										rect.anchorX=0
										rect.anchorY=0	
										
										--textoNumeroPagina.y = GRUPOGERAL2.grupoTemp.height + YInicial
										--YInicial = YInicial + GRUPOGERAL2.grupoTemp.height
										
										
										GRUPOGERAL2.grupoTemp.x = rect.x
										GRUPOGERAL2.grupoTemp.y = rect.y
										rect.height = GRUPOGERAL2.grupoTemp.height
										rect.width = W--GRUPOGERAL2.grupoTemp.width
										rect.y = GRUPOGERAL2.grupoTemp[1].y
										GRUPOGERAL2.grupoTemp:insert(1,rect)
										
										textoNumeroPagina.y = rect.y + rect.height + 200
										rect.height = rect.height + 200
										rect.y = rect.y +125
										GRUPOGERAL2.grupoTemp:insert(textoNumeroPagina)
										
										--textoNumeroPagina.y
										
										display.save( GRUPOGERAL2.grupoTemp, { filename="TelaPagina".. paginaLivro .."_"..GRUPOGERAL2.numeroTelaTemp..".png", baseDir=destino, captureOffscreenArea=true, backgroundColor=varGlobal.preferenciasGerais.cor } )
										table.insert(Var2.atachment,{ baseDir=destino, filename="TelaPagina".. paginaLivro .."_"..GRUPOGERAL2.numeroTelaTemp..".png", type="image/png" })
										table.insert(Var2.atachmentZip,"TelaPagina".. paginaLivro .."_"..GRUPOGERAL2.numeroTelaTemp..".png")
										if Var.Impressao.grupoPDFPNG.tipo == "PDF" then
											pdfImageConverter.toPdf(system.pathForFile("TelaPagina".. paginaLivro .."_"..GRUPOGERAL2.numeroTelaTemp..".png", destino), system.pathForFile("TelaPagina".. paginaLivro .."_"..GRUPOGERAL2.numeroTelaTemp..".pdf", destino))
										end
										GRUPOGERAL2.ultimaPaginaSalva = "TelaPagina".. paginaLivro .."_"..GRUPOGERAL2.numeroTelaTemp..".png"
										--testarNoAndroid("TelaPagina".. paginaLivro .."_"..GRUPOGERAL2.numeroTelaTemp..".png",xx*50)
										GRUPOGERAL2.grupoTemp:removeSelf()
										GRUPOGERAL2.grupoTemp = nil
										--rect:removeSelf()
										--rect = nil
										GRUPOGERAL2.numeroTelaTemp = GRUPOGERAL2.numeroTelaTemp + 1
										GRUPOGERAL2.grupoTemp = display.newGroup()
										
									
									end
								end
								local textoNumeroPagina = display.newText(optionAguarde)
								textoNumeroPagina.anchorY=0
								textoNumeroPagina:setFillColor(0,0,0)
								local auxPaginaLivro = tostring(paginaLivro)
								local total = varGlobal.numeroTotal.PaginasPre+varGlobal.numeroTotal.Indices-1
								if string.find(auxPaginaLivro,"%-") then
									local paginaAux = (-1)*total + (-1)*tonumber(auxPaginaLivro) - 1
									textoNumeroPagina.text = auxFuncs.ToRomanNumerals(string.gsub(paginaAux,"%-",""))
								else
									textoNumeroPagina.text = auxPaginaLivro
								end
								textoNumeroPagina.text = textoNumeroPagina.text .. "_"..GRUPOGERAL2.numeroTelaTemp
								
								local rect = display.newRect(0,0,0,0)
								rect:setFillColor(1,1,1)
								rect.anchorX=0
								rect.anchorY=0	
								
								--textoNumeroPagina.y = GRUPOGERAL2.grupoTemp.height + YInicial
								--YInicial = YInicial + GRUPOGERAL2.grupoTemp.height
								
								
								GRUPOGERAL2.grupoTemp.x = rect.x
								GRUPOGERAL2.grupoTemp.y = rect.y
								rect.height = GRUPOGERAL2.grupoTemp.height
								rect.width = W--GRUPOGERAL2.grupoTemp.width
								rect.y = GRUPOGERAL2.grupoTemp[1].y
								GRUPOGERAL2.grupoTemp:insert(1,rect)
								
								textoNumeroPagina.y = rect.y + rect.height + 200
								rect.height = rect.height + 200
								rect.y = rect.y +125
								GRUPOGERAL2.grupoTemp:insert(textoNumeroPagina)
								
								--textoNumeroPagina.y
								
								display.save( GRUPOGERAL2.grupoTemp, { filename="TelaPagina".. paginaLivro .."_"..GRUPOGERAL2.numeroTelaTemp..".png", baseDir=destino, captureOffscreenArea=true, backgroundColor=varGlobal.preferenciasGerais.cor } )
								table.insert(Var2.atachment,{ baseDir=destino, filename="TelaPagina".. paginaLivro .."_"..GRUPOGERAL2.numeroTelaTemp..".png", type="image/png" })
								table.insert(Var2.atachmentZip,"TelaPagina".. paginaLivro .."_"..GRUPOGERAL2.numeroTelaTemp..".png")
								if Var.Impressao.grupoPDFPNG.tipo == "PDF" then
									pdfImageConverter.toPdf(system.pathForFile("TelaPagina".. paginaLivro .."_"..GRUPOGERAL2.numeroTelaTemp..".png", destino), system.pathForFile("TelaPagina".. paginaLivro .."_"..GRUPOGERAL2.numeroTelaTemp..".pdf", destino))
								end
								GRUPOGERAL2.ultimaPaginaSalva = "TelaPagina".. paginaLivro .."_"..GRUPOGERAL2.numeroTelaTemp..".png"
								--testarNoAndroid("TelaPagina".. paginaLivro .."_"..GRUPOGERAL2.numeroTelaTemp..".png",xx*50)
								GRUPOGERAL2.grupoTemp:removeSelf()
								GRUPOGERAL2.grupoTemp = nil
								--rect:removeSelf()
								--rect = nil
								GRUPOGERAL2.numeroTelaTemp = GRUPOGERAL2.numeroTelaTemp + 1
								GRUPOGERAL2.grupoTemp = display.newGroup()
							else
								
								local textoNumeroPagina = display.newText(optionAguarde)
								textoNumeroPagina:setFillColor(0,0,0)
								local auxPaginaLivro = tostring(paginaLivro)
								local total = varGlobal.numeroTotal.PaginasPre+varGlobal.numeroTotal.Indices-1
								if string.find(auxPaginaLivro,"%-") then
									local paginaAux = (-1)*total + (-1)*tonumber(auxPaginaLivro) - 1
									textoNumeroPagina.text = auxFuncs.ToRomanNumerals(string.gsub(paginaAux,"%-",""))
								else
									textoNumeroPagina.text = auxPaginaLivro
								end
							
								local rect = display.newRect(0,0,0,0)
								rect:setFillColor(1,1,1)
								rect.anchorX=0
								rect.anchorY=0
			
								while GRUPOGERAL2.numChildren > 0 do
									GRUPOGERAL2.grupoTemp:insert(GRUPOGERAL2[1])
								end
								textoNumeroPagina.text = textoNumeroPagina.text .. "_"..GRUPOGERAL2.numeroTelaTemp
								textoNumeroPagina.y = GRUPOGERAL2.grupoTemp.height+50 + 100
								GRUPOGERAL2.grupoTemp:insert(textoNumeroPagina)
								GRUPOGERAL2.grupoTemp.x = rect.x
								GRUPOGERAL2.grupoTemp.y = rect.y
								rect.height = GRUPOGERAL2.grupoTemp.height
								rect.width = W--GRUPOGERAL2.grupoTemp.width
								GRUPOGERAL2.grupoTemp:insert(1,rect)
							
								display.save( GRUPOGERAL2.grupoTemp, { filename="TelaPagina".. paginaLivro .."_"..GRUPOGERAL2.numeroTelaTemp..".png", baseDir=destino, captureOffscreenArea=true, backgroundColor=varGlobal.preferenciasGerais.cor } )
								table.insert(Var2.atachment,{ baseDir=destino, filename="TelaPagina".. paginaLivro .."_"..GRUPOGERAL2.numeroTelaTemp..".png", type="image/png" })
								table.insert(Var2.atachmentZip,"TelaPagina".. paginaLivro .."_"..GRUPOGERAL2.numeroTelaTemp..".png")

								GRUPOGERAL2.ultimaPaginaSalva = "TelaPagina".. paginaLivro .."_"..GRUPOGERAL2.numeroTelaTemp..".png"
							
							
								GRUPOGERAL2.grupoTemp:removeSelf()
								GRUPOGERAL2.grupoTemp = nil
								rect:removeSelf()
								rect = nil
								GRUPOGERAL2.numeroTelaTemp = GRUPOGERAL2.numeroTelaTemp + 1
								Var2.proximoY = 0
							end	
						
						end
					end
					
					
				end	
				
				-- criando ultima pagina dividida sem ser índice
				if GRUPOGERAL2.height and GRUPOGERAL2.height > 0 and Var2.separouPaginas == true then
					--Var2.separouPaginas = true
					local paginaLivro = pegarNumeroRealPagina(i)
					local destino = system.TemporaryDirectory
					local textoNumeroPagina = display.newText(optionAguarde)
					local auxPaginaLivro = tostring(paginaLivro)
					local total = varGlobal.numeroTotal.PaginasPre+varGlobal.numeroTotal.Indices-1
					print("IMPRIMINDO PAGINA LIVRO",textoNumeroPagina.text)
					if string.find(auxPaginaLivro,"%-") then
						local paginaAux = (-1)*total + (-1)*tonumber(auxPaginaLivro) - 1
						textoNumeroPagina.text = auxFuncs.ToRomanNumerals(string.gsub(paginaAux,"%-",""))
					else
						textoNumeroPagina.text = auxPaginaLivro
					end
					textoNumeroPagina:setFillColor(0,0,0)
				
					local rect = display.newRect(0,0,0,0)
					rect:setFillColor(1,1,1)
					rect.anchorX=0
					rect.anchorY=0
				
					if not GRUPOGERAL2.numeroTelaTemp then GRUPOGERAL2.numeroTelaTemp = 1 end
					GRUPOGERAL2.grupoTemp = display.newGroup()
				
				
					while GRUPOGERAL2.numChildren > 0 do
						GRUPOGERAL2.grupoTemp:insert(GRUPOGERAL2[1])
					end
					textoNumeroPagina.text = textoNumeroPagina.text .. "_"..GRUPOGERAL2.numeroTelaTemp
					textoNumeroPagina.y = GRUPOGERAL2.grupoTemp.height+50+100
					GRUPOGERAL2.grupoTemp:insert(textoNumeroPagina)
					GRUPOGERAL2.grupoTemp.x = rect.x
					GRUPOGERAL2.grupoTemp.y = rect.y
					rect.height = GRUPOGERAL2.grupoTemp.height
					rect.width = W--GRUPOGERAL2.grupoTemp.width
					GRUPOGERAL2.grupoTemp:insert(1,rect)
				
					display.save( GRUPOGERAL2.grupoTemp, { filename="TelaPagina".. paginaLivro .."_"..GRUPOGERAL2.numeroTelaTemp..".png", baseDir=destino, captureOffscreenArea=true, backgroundColor=varGlobal.preferenciasGerais.cor } )
					table.insert(Var2.atachment,{ baseDir=destino, filename="TelaPagina".. paginaLivro .."_"..GRUPOGERAL2.numeroTelaTemp..".png", type="image/png" })
					table.insert(Var2.atachmentZip,"TelaPagina".. paginaLivro .."_"..GRUPOGERAL2.numeroTelaTemp..".png")
					
					GRUPOGERAL2.ultimaPaginaSalva = "TelaPagina".. paginaLivro .."_"..GRUPOGERAL2.numeroTelaTemp..".png"
					
					GRUPOGERAL2.grupoTemp:removeSelf()
					GRUPOGERAL2.grupoTemp = nil
					rect:removeSelf()
					rect = nil
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
			--!!!--funcGlobal.criarAnotacoesComentarios(pagina,vetorTelas)
			--!!!--Var2.Impressao = funcGlobal.criarBotaoImpressao(pagina,vetorTelas)
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
				varGlobal.WindowsDireita.height,varGlobal.WindowsEsquerda.height = varGlobal.limiteTela,varGlobal.limiteTela
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
			
			GRUPOGERAL2:insert(1,Var2.retanguloMovimento)
			
			local paginaLivro = pegarNumeroRealPagina(i)
			local destino = system.TemporaryDirectory
			local textoNumeroPagina = display.newText(optionAguarde)
			textoNumeroPagina.y = GRUPOGERAL2.height-10
			textoNumeroPagina:setFillColor(0,0,0)
			GRUPOGERAL2:insert(textoNumeroPagina)
			local auxPaginaLivro = tostring(paginaLivro)
			if string.find(auxPaginaLivro,"%-") then
				local total = varGlobal.numeroTotal.PaginasPre+varGlobal.numeroTotal.Indices-1
				local numeroImpressao = auxPaginaLivro
				textoNumeroPagina.text = auxFuncs.ToRomanNumerals(string.gsub(numeroImpressao,"%-",""))
			else
				textoNumeroPagina.text = auxPaginaLivro
			end
			print("IMPRIMINDO PAGINA LIVRO",textoNumeroPagina.text,auxPaginaLivro)
			textoTravarTela.text = "aguarde:\nSalvando Páginas\n"..cont2.." de ".. numeroTotalVetor
			
			
			if Var2.separouPaginas == true then
				Var2.separouPaginas = false
			else
				GRUPOGERAL2.ultimaPaginaSalva = "TelaPagina".. paginaLivro ..".png"
				display.save( GRUPOGERAL2, { filename="TelaPagina".. paginaLivro ..".png", baseDir=destino, captureOffscreenArea=true, backgroundColor=varGlobal.preferenciasGerais.cor } )
				table.insert(Var2.atachment,{ baseDir=destino, filename="TelaPagina".. paginaLivro ..".png", type="image/png" })
				table.insert(Var2.atachmentZip,"TelaPagina".. paginaLivro ..".png")
			end
			
			local numeroTelasDivididas = math.ceil(GRUPOGERAL2.height/1300)
			
			
			RemoverPaginaAnterior(Var2)
			GRUPOGERAL2:removeSelf()
			Var2.telaMovedora = nil
			Var2.retanguloMovimento = nil
			
			
			Var2.timerEsperarArquivo = timer.performWithDelay(30,function()
				local arquivo = GRUPOGERAL2.ultimaPaginaSalva
				print("arquivo",arquivo)
				
				if auxFuncs.fileExistsTemp(arquivo) then
					timer.cancel(Var2.timerEsperarArquivo)
					Var2.timerEsperarArquivo = nil
					cont2 = cont2 + 1
					
					if cont2-1 == numeroTotalVetor then
						if Var.Impressao.grupoPDFPNG.tipo == "PDF" then
							
							pdfImageConverter.toPdf(system.pathForFile(Var2.atachmentZip[1], destino), system.pathForFile(string.gsub(Var2.atachmentZip[1],"png","pdf"), destino))

							for i=2,#Var2.atachmentZip do
								--testarNoAndroid(Var2.atachmentZip[i],i*50)
								print(Var2.atachmentZip[i])
								local arq1 = string.gsub(Var2.atachmentZip[i-1],"png","pdf")
								local arq2 = string.gsub(Var2.atachmentZip[i],"png","pdf")
								local nome2 = string.gsub(Var2.atachmentZip[i],"%.png","")
								local pdf1 = system.pathForFile(arq1,destino)
								local pdf2 = system.pathForFile(arq2,destino)
								pdfImageConverter.toPdf(system.pathForFile(Var2.atachmentZip[i], destino), pdf2)
								os.rename(pdf2,system.pathForFile(nome2 .."_old.pdf",destino))
								print(pdf2)
								pdfImageConverter.combinePdf(pdf1, system.pathForFile(nome2 .."_old.pdf",destino),pdf2)
							end
							local arqFinal = string.gsub(Var2.atachmentZip[#Var2.atachmentZip],"png","pdf")
							--os.rename(system.pathForFile(arqFinal),string.gsub(system.pathForFile(arqFinal),arqFinal,"livro.pdf"))
					
							-- enviar o pdf após acabar
							
							local arquivo = string.gsub(Var2.atachmentZip[#Var2.atachmentZip],"png","pdf")--"livro.pdf"--
							local destino = system.TemporaryDirectory
							local options =
							{
							   to = "",
							   subject = "PDF das páginas do livro",
							   body = "PDF da páginas para leitura",
							   attachment = { baseDir=destino, filename=arquivo, type="document/pdf" }
							}
							native.showPopup( "mail", options 
							)
							timer.performWithDelay(1000,function()
								Var2.grupoTravarTela:removeSelf()
								Var2.grupoTravarTela = nil
							end,1)
						end
					else
						loopPaginas()
					end
				end
			end,-1)
			
			
		end
		loopPaginas()
		
		--[[local result, reason = os.rename(
			system.pathForFile("TelaPagina".. pegarNumeroRealPagina(vetorTelas.PaginasAux[numeroTotalVetor]) ..".pdf",destDir),
			system.pathForFile("PDF Livro.pdf", destDir )
		)
		if result then
			print( "File renamed" )
			testarNoAndroid("File renamed",100)
		else
			testarNoAndroid(reason,100)
			print( "File not renamed", reason )  --> File not renamed    orange.txt: No such file or directory
		end]]
		
	end
	local function criarVetorDasPaginas(vetorPaginas)
		local vetor = {}
		
		local cont = 1
		while cont<=#vetorPaginas do
			local pagina = vetorPaginas[cont]
			print("cont",cont)
			print("vetorPaginas[cont]",vetorPaginas[cont])
			if pagina >= 1 and pagina <= telas.numeroTotal.PaginasPre then
				local nomeArquivo = auxFuncs.tirarAExtencao(telas.arquivos[pagina])
				vetor[pagina] = {}
				vetor[pagina] = ead.criarTeladeArquivo({pasta = "PaginasPre",arquivo = telas.arquivos[pagina]},telas,{},pagina,nomeArquivo)
				vetor.PastaPaginas = "PaginasPre/Outros Arquivos"
			elseif pagina >= telas.numeroTotal.PaginasPre+1 and pagina <=  telas.numeroTotal.PaginasPre+telas.numeroTotal.Indices then
				vetor[pagina] = leituraTXT.criarIndicesDeArquivoConfig({pasta = "Indices",arquivo = "config indices.txt",pagina = pagina,TTSTipo = varGlobal.TTSTipo,paginaAtual = pagina},telas,listaDeErros,{{}})
				vetor.PastaPaginas = "Indices/Outros Arquivos"
			else
				if #telas.arquivos > 0 then
					local nomeArquivo = auxFuncs.tirarAExtencao(telas.arquivos[pagina])
					vetor[pagina] = ead.criarTeladeArquivo({pasta = "Paginas",arquivo = telas.arquivos[pagina]},telas,{},pagina,nomeArquivo)
				end
			end
			cont = cont + 1
		end
		vetor.PaginasAux = vetorPaginas
		vetor.nIndices = telas.numeroTotal.Indices
		vetor.nPaginasPre = telas.numeroTotal.PaginasPre
		criarImagensDasPaginas(vetor)
	end
	
	local function criarEEnviarCardsDasPaginasEmPdf(vetorPaginas)
		local vetorImagensCards = {}
		
		local vetorCardsLivro = auxFuncs.loadTable("cardDeck.json","res")
		
		for i=1,#vetorCardsLivro.paginasComCards do
			local pagina = tostring(vetorCardsLivro.paginasComCards[i].pag)
			local totalCardsPagina = vetorCardsLivro.paginasComCards[i].n
			for card=1,totalCardsPagina do
				table.insert(vetorCardsLivro[pagina],vetorCardsLivro[pagina][tostring(card)])
			end
		end
		
		local vetor = {}
		local cont = 1
		local telaAguarde = auxFuncs.TelaAguarde()
		timer.performWithDelay(30,function()
			while cont<=#vetorPaginas do
				print("vetorPaginas[cont]",vetorPaginas[cont])
				local paginaAtual = vetorPaginas[cont]
				print("vetorCardsLivro,paginaAtual = ",vetorCardsLivro,paginaAtual)
				if vetorCardsLivro[paginaAtual] then
					print("criando arquivo")
					M.gerarVetorECardsDePagina(vetorCardsLivro,vetorImagensCards,paginaAtual,telas)
				end
				cont = cont + 1
			end
			print("vetorImagensCards",vetorImagensCards[1],vetorImagensCards[#vetorImagensCards],#vetorImagensCards)
			M.EnviarImagensDasPaginasEmPDF(vetorImagensCards,telaAguarde)
		end,1)
	end
	
	local function abrirEmailComImagem()
		display.save( GRUPOGERAL, { filename="TelaPagina".. varGlobal.PagH ..".png", baseDir=system.TemporaryDirectory, captureOffscreenArea=true, backgroundColor=varGlobal.preferenciasGerais.cor } )
		
		local options =
		{
		   to = "",
		   subject = "Conteúdo da "..varGlobal.PagH,
		   body = "Imagem da " .. varGlobal.PagH .. " para impressão.",
		   attachment = { baseDir=system.TemporaryDirectory, filename="TelaPagina".. varGlobal.PagH ..".png", type="image/png" }
		}
		native.showPopup( "mail", options )
	end
	local function abrirEmailComPDF()
		if Var.Impressao.grupoPDFPNG.tipo == "PDF" then
	
			display.save( GRUPOGERAL, { filename="TelaPagina".. varGlobal.PagH ..".png", baseDir=system.TemporaryDirectory, captureOffscreenArea=true, backgroundColor=varGlobal.preferenciasGerais.cor } )
			local function enviarPDF()
				if auxFuncs.fileExistsTemp("TelaPagina".. varGlobal.PagH ..".png") then
					pdfImageConverter.toPdf(system.pathForFile("TelaPagina".. varGlobal.PagH ..".png", system.TemporaryDirectory), system.pathForFile("TelaPagina".. varGlobal.PagH ..".pdf", system.TemporaryDirectory))

					local options =
					{
					   to = "",
					   subject = "Conteúdo da "..varGlobal.PagH,
					   body = "PDF da " .. varGlobal.PagH .. " para impressão.",
					   attachment = { baseDir=system.TemporaryDirectory, filename="TelaPagina".. varGlobal.PagH ..".pdf", type="document/pdf" }
					}
					native.showPopup( "mail", options )
					if Var.Impressao.grupoPDFPNG.timer then
						timer.cancel(Var.Impressao.grupoPDFPNG.timer)
						Var.Impressao.grupoPDFPNG.timer = nil
					end
				end
			end
			Var.Impressao.grupoPDFPNG.timer = timer.performWithDelay(100,enviarPDF,-1)

		elseif Var.Impressao.grupoPDFPNG.tipo == "CARDS" then
			print("imprimindo card atual")
			local telaAguarde = auxFuncs.TelaAguarde()
			
			local vetorCards = auxFuncs.loadTable("cardDeck.json","res")
			for i=1,#vetorCards.paginasComCards do
				local pagina = tostring(vetorCards.paginasComCards[i].pag)
				local totalCardsPagina = vetorCards.paginasComCards[i].n
				for card=1,totalCardsPagina do
					table.insert(vetorCards[pagina],vetorCards[pagina][tostring(card)])
				end
			end
			local vetorImagensCards = {}
			local destino = system.TemporaryDirectory
			-- iniciar um loop para cada card 
			
			timer.performWithDelay(10,function()
				
				if vetorCards[varGlobal.PagH] then
					
					M.gerarVetorECardsDePagina(vetorCards,vetorImagensCards,varGlobal.PagH,telas)
					
					pdfImageConverter.toPdf(system.pathForFile(vetorImagensCards[1], destino), system.pathForFile(string.gsub(vetorImagensCards[1],"png","pdf"), destino))

					for i=2,#vetorImagensCards do
						--testarNoAndroid(Var2.atachmentZip[i],i*50)
						print(vetorImagensCards[i])
						local arq1 = string.gsub(vetorImagensCards[i-1],"png","pdf")
						local arq2 = string.gsub(vetorImagensCards[i],"png","pdf")
						local nome2 = string.gsub(vetorImagensCards[i],"%.png","")
						local pdf1 = system.pathForFile(arq1,destino)
						local pdf2 = system.pathForFile(arq2,destino)
						pdfImageConverter.toPdf(system.pathForFile(vetorImagensCards[i], destino), pdf2)
						os.rename(pdf2,system.pathForFile(nome2 .."_old.pdf",destino))
						print(pdf2)
						pdfImageConverter.combinePdf(pdf1, system.pathForFile(nome2 .."_old.pdf",destino),pdf2)
					end
					print(string.gsub(vetorImagensCards[#vetorImagensCards],"png","pdf"))
					local arqFinal = string.gsub(vetorImagensCards[#vetorImagensCards],"png","pdf")
					os.rename(system.pathForFile(arqFinal,destino),system.pathForFile("Cards da Pagina".. varGlobal.PagH ..".pdf",destino))
			
					-- enviar o pdf após acabar
					
					local arquivo = string.gsub(vetorImagensCards[#vetorImagensCards],"png","pdf")--"livro.pdf"--
					local destino = system.TemporaryDirectory
					
					telaAguarde.timer = timer.performWithDelay(100,
						function(e) 
							if telaAguarde and telaAguarde.timer and auxFuncs.fileExistsTemp("Cards da Pagina".. varGlobal.PagH ..".pdf") then
								timer.cancel(telaAguarde.timer)
								telaAguarde.timer = nil
								telaAguarde:removeSelf()
								telaAguarde = nil
							end
						end,
					-1)
					local options =
					{
						to = "",
						subject = "Cards da  página "..varGlobal.PagH,
						body = "PDF dos cards contidos na página " .. varGlobal.PagH .. " para impressão.",
						attachment = { baseDir=system.TemporaryDirectory, filename="Cards da Pagina".. varGlobal.PagH ..".pdf", type="document/pdf" },
						listener = function(event) 
							if telaAguarde then
								if telaAguarde.timer then
									timer.cancel(telaAguarde.timer)
									telaAguarde.timer = nil
								end
								telaAguarde:removeSelf()
								telaAguarde = nil
							end
						end
					}
					native.showPopup( "mail", options )
					
					
				else
					print("Tentando imprimir página:",varGlobal.PagH)
					telaAguarde:removeSelf()
					telaAguarde = nil
					native.showAlert("Atenção!","A página atual não contém cards",{"OK"})
				end
			end,1)

		end
	end
	local function mostrarPaginaDicinario(arquivo)
		local grupoPagina = display.newGroup()
		local scriptPagina = auxFuncs.lerTextoRes("Dicionario Palavras/"..arquivo)
		local fundo = M.colocarSeparador({espessura = H,largura = W,cor = {255,255,255}})
		fundo.strokeWidth = 5
		fundo:setStrokeColor(46/255,171/255,200/255)
		fundo:scale(.9,1)
		local Tela = manipularTela.criarUmaTela(
			{
				pasta = "Dicionario Palavras",
				arquivo = arquivo,
				scriptDaPagina = scriptPagina,
				dicionario = true
			},
			function() end
		)
		Tela.y = -200
		Tela.x = Tela.x - W/2 + Tela.width/20
		Tela.y = Tela.y - H/2 + Tela.height/10
		Tela:scale(.9,.9)
		fundo.anchorX=0
		fundo.anchorY=0
		fundo.x = Tela.width/20
		fundo.y = 60
		fundo.container = display.newContainer( W, H ) 
		fundo.height = fundo.container.height - 120
		fundo.container:translate( W/2, H/2 )
		fundo.container:insert( Tela, false )
		Tela.yInicial = fundo.container.height/10
		Tela.limiteV = fundo.container.y+fundo.container.height
		Tela:addEventListener("touch",auxFuncs.moverComLimiteVertical)
		fundo.container:scale(.9,.9)
		function fundo.fecharTela()
			grupoPagina:removeSelf()
			grupoPagina=nil
		end
		fundo.fechar = widget.newButton {
			onRelease = fundo.fecharTela,
			emboss = false,
			-- Properties for a rounded rectangle button
			defaultFile = "closeMenuButton.png",
			overFile = "closeMenuButtonD.png"
		}
		fundo.fechar.clicado = false
		fundo.fechar.tipo = "fechar"
		fundo.fechar.anchorX=1
		fundo.fechar.anchorY=0
		fundo.fechar.x = W - 50 + fundo.fechar.width/2
		fundo.fechar.y = 70
		
		grupoPagina:insert(fundo)
		grupoPagina:insert(fundo.container)
		grupoPagina:insert(fundo.fechar)
	end
	local function imprimirPalavrasDicionario(palavras)
		local manipularTela = require("manipularTela")
		for i=1,#palavras do
			local scriptPagina = auxFuncs.lerTextoRes("Dicionario Palavras/"..palavras[i])--leituraTXT.criarDicionarioDeArquivoPadrao({pasta = "Dicionario Palavras",arquivo = atrib.dicionario},{})
			if not scriptPagina or (scriptPagina and scriptPagina == "") then
				scriptPagina = "1 - texto\n texto = \\nNão foi anexada uma página válida para o dicionário."
			end
			local Tela = manipularTela.criarUmaTela(
				{
					pasta = "Dicionario Palavras",
					arquivo = palavras[i],
					scriptDaPagina = scriptPagina,
					dicionario = true
				},
				function() end
			)
			
			local diretTempAux = system.pathForFile(nil,system.TemporaryDirectory)
			diretTemp = diretTempAux .. "/" .. "palavra"..i..".jpg"
			print("path = "..diretTemp)
			display.save( Tela, { filename="palavra"..i..".jpg", baseDir=system.TemporaryDirectory, captureOffscreenArea=true, backgroundColor={1,1,1} } )
			pdfImageConverter.toPdf(diretTemp, diretTempAux .. "/" .. "palavra"..i..".pdf", system.TemporaryDirectory)
			if i>1 then
				local pdf1 = diretTempAux .. "/" .. "palavra".. i-1 ..".pdf"
				local pdf2 = diretTempAux .. "/" .. "palavra"..i..".pdf"
				local nome2 = "palavra"..i
				os.rename(pdf2,diretTempAux.."/"..nome2 .."_old.pdf")
				pdfImageConverter.combinePdf(pdf1, diretTempAux.."/"..nome2 .."_old.pdf",pdf2)
			end
			Tela:removeSelf()
			Tela = nil
		end
		if auxFuncs.fileExistsTemp("palavra"..#palavras..".pdf") then
			os.rename(system.pathForFile("palavra"..#palavras..".pdf",system.TemporaryDirectory),system.pathForFile("Dicionario.pdf",system.TemporaryDirectory))
			
			local options =
			{
				to = "",
				subject = "PDF de Palavras do Dicionário ",
				body = "PDF criado das palavras selecionadas para impressão para impressão.",
				attachment = { baseDir=system.TemporaryDirectory, filename="Dicionario.pdf", type="document/pdf" },
				listener = function(event) 
					
				end
			}
			native.showPopup( "mail", options )
		end
	end
	local function abrirMenuRapido(event)
		if grupoImpressao.botao then 
			grupoImpressao.botao:setEnabled(false)
		end
		local escolhas = {
			"Enviar Imagem..",
			"Enviar PDF..",
			"|             X             |"
		}
	
		local function aoFecharMenuRapido()
			if Var.Impressao.MenuRapido then
				Var.Impressao.MenuRapido:removeSelf()
				Var.Impressao.MenuRapido = nil
			end
			if grupoImpressao.botao then
				grupoImpressao.botao:setEnabled(true)
			end
		end
		local function rodarOpcao(e)
			if e.target.params.tipo ~= "|             X             |" then
				Var.Impressao.grupoPDFPNG = display.newGroup()
				Var.Impressao.grupoPDFPNG.y = -300
				Var.Impressao.telaPreta = display.newRect(Var.Impressao.grupoPDFPNG,W/2,H/2+300,W,H)
				Var.Impressao.telaPreta.alpha = .3
				Var.Impressao.telaPreta:setFillColor(0,0,0)
				Var.Impressao.telaPreta:addEventListener("touch",function() return true end)
				Var.Impressao.telaPreta:addEventListener("tap",function() Var.Impressao.grupoPDFPNG:removeSelf();Var.Impressao.grupoPDFPNG=nil; return true end)
				Var.Impressao.fundoPDFPNG = display.newRoundedRect(Var.Impressao.grupoPDFPNG,W/2,H/2,620,420,8)
				Var.Impressao.fundoPDFPNG:setFillColor(42/255,195/255,232/255)
				Var.Impressao.fundoPDFPNG:addEventListener("touch",function() return true end)
				Var.Impressao.fundoPDFPNG:addEventListener("tap",function() return true end)
				Var.Impressao.fundoPDFPNG.alpha = 0
				Var.Impressao.fundoPDFPNG.isHitTestable = true
				
			end
			local textoTitulo = varGlobal.menuImprimirTitulo.." PDF"
			if e.target.params.tipo == "Enviar Imagem.." then
				--abrirEmailComImagem()
				Var.Impressao.fundoPNG = display.newImage(Var.Impressao.grupoPDFPNG,"menu enviar PNG.png")
				Var.Impressao.fundoPNG.x = W/2
				Var.Impressao.fundoPNG.y = H/2
				textoTitulo = varGlobal.menuImprimirTitulo.." PNG"
				Var.Impressao.grupoPDFPNG.tipo = "PNG"
			elseif e.target.params.tipo == "Enviar PDF.." then
				Var.Impressao.fundoPDF = display.newImage(Var.Impressao.grupoPDFPNG,"menu enviar PDF.png")
				Var.Impressao.fundoPDF.x = W/2
				Var.Impressao.fundoPDF.y = H/2 
				textoTitulo = varGlobal.menuImprimirTitulo.." PDF"			
				Var.Impressao.grupoPDFPNG.tipo = "PDF"
			elseif e.target.params.tipo == "|             X             |" then
				print("cancelou menu rapido")
			end
			
			if e.target.params.tipo == "Enviar Imagem.." or e.target.params.tipo == "Enviar PDF.." then
				Var.Impressao.textoFundoTitulo = display.newText(Var.Impressao.grupoPDFPNG,textoTitulo,W/2,470,"Fontes/ariblk.ttf",50)
				Var.Impressao.textoFundoTitulo:setFillColor(1,1,1)
			
				local options = {
					width = 100,
					height = 101,
					numFrames = 2,
					sheetContentWidth = 200,
					sheetContentHeight = 101
				}
				local radioButtonSheet = graphics.newImageSheet( "check.png", options )
			
				local opcaoInicial = {"atual","todas","intervalo"}
				Var.Impressao.grupoPDFPNG.escolha = "atual"
				opcaoInicial["atual"] = true
				opcaoInicial["todas"] = false
				opcaoInicial["intervalo"] = false
				Var.Impressao.opcoesIntervalo = {}
				local function onSwitchPress(e)
					
					if Var.Impressao.opcoesIntervalo.textoRadio3Dica then
						Var.Impressao.opcoesIntervalo.textoRadio3Dica.isVisible = false
						Var.Impressao.opcoesIntervalo.textoRadio3Campo.isVisible = false
					end
					local switch = e.target
					Var.Impressao.grupoPDFPNG.escolha = switch.id
					print("switch id = ",switch.id)
					if switch.id == "atual" then
						Var.Impressao.textoRadio1:setFillColor(1,1,1)
						Var.Impressao.textoRadio2:setFillColor(0.7,0.7,0.7)
						Var.Impressao.textoRadio3:setFillColor(0.7,0.7,0.7)
						Var.Impressao.grupoPDFPNG.escolha = "atual"
					elseif switch.id == "todas" then
						Var.Impressao.textoRadio1:setFillColor(0.7,0.7,0.7)
						Var.Impressao.textoRadio2:setFillColor(1,1,1)
						Var.Impressao.textoRadio3:setFillColor(0.7,0.7,0.7)
						Var.Impressao.grupoPDFPNG.escolha = "todas"
					elseif switch.id == "intervalo" then
						Var.Impressao.textoRadio1:setFillColor(0.7,0.7,0.7)
						Var.Impressao.textoRadio2:setFillColor(0.7,0.7,0.7)
						Var.Impressao.textoRadio3:setFillColor(1,1,1)
						Var.Impressao.opcoesIntervalo.textoRadio3Dica.isVisible = true
						Var.Impressao.opcoesIntervalo.textoRadio3Campo.isVisible = true
						Var.Impressao.grupoPDFPNG.escolha = "intervalo"
					end
					
				end
				Var.Impressao.radioButton1 = widget.newSwitch(
					{
						x = 120,
						y = 510,
						style = "radio",
						id = "atual",
						width = 50,
						height = 50,
						initialSwitchState = opcaoInicial["atual"],
						onPress = onSwitchPress,
						sheet = radioButtonSheet,
						frameOff = 1,
						frameOn = 2
					}
				)
				Var.Impressao.radioButton1.anchorX=0;Var.Impressao.radioButton1.anchorY=0
				--GrupoAli.radioButton1.x = 0;GrupoAli.radioButton1.y = 0
				Var.Impressao.grupoPDFPNG:insert( Var.Impressao.radioButton1 )
			 	Var.Impressao.textoRadio1 = display.newText(varGlobal.menuImprimirTexto1,0,0,"Fontes/ariblk.ttf",30)
				Var.Impressao.textoRadio1:setFillColor(1,1,1)
				Var.Impressao.textoRadio1.anchorX = 0
				Var.Impressao.textoRadio1.anchorY = 0
				Var.Impressao.textoRadio1.x = Var.Impressao.radioButton1.x + Var.Impressao.radioButton1.width + 20
				Var.Impressao.textoRadio1.y = Var.Impressao.radioButton1.y
				Var.Impressao.grupoPDFPNG:insert( Var.Impressao.textoRadio1 )
				Var.Impressao.radioButton2 = widget.newSwitch(
					{
						x = 120,
						y = 580,
						style = "radio",
						id = "todas",
						width = 50,
						height = 50,
						initialSwitchState = opcaoInicial["todas"],
						onPress = onSwitchPress,
						sheet = radioButtonSheet,
						frameOff = 1,
						frameOn = 2
					}
				)
				Var.Impressao.radioButton2.anchorX=0;Var.Impressao.radioButton2.anchorY=0
				Var.Impressao.grupoPDFPNG:insert( Var.Impressao.radioButton2 )
				Var.Impressao.textoRadio2 = display.newText(varGlobal.menuImprimirTexto2,0,0,"Fontes/ariblk.ttf",30)
				Var.Impressao.textoRadio2:setFillColor(0.7,0.7,0.7)
				Var.Impressao.textoRadio2.anchorX = 0
				Var.Impressao.textoRadio2.anchorY = 0
				Var.Impressao.textoRadio2.x = Var.Impressao.radioButton2.x + Var.Impressao.radioButton2.width + 20
				Var.Impressao.textoRadio2.y = Var.Impressao.radioButton2.y
				Var.Impressao.grupoPDFPNG:insert( Var.Impressao.textoRadio2 )
				Var.Impressao.radioButton3 = widget.newSwitch(
					{
						x = 120,
						y = 650,
						style = "radio",
						id = "intervalo",
						width = 50,
						height = 50,
						initialSwitchState = opcaoInicial["intervalo"],
						onPress = onSwitchPress,
						sheet = radioButtonSheet,
						frameOff = 1,
						frameOn = 2
					}
				)
				Var.Impressao.radioButton3.anchorX=0;Var.Impressao.radioButton3.anchorY=0
				Var.Impressao.grupoPDFPNG:insert( Var.Impressao.radioButton3 )
				Var.Impressao.textoRadio3 = display.newText(varGlobal.menuImprimirTexto3,0,0,"Fontes/ariblk.ttf",30)
				Var.Impressao.textoRadio3:setFillColor(0.7,0.7,0.7)
				Var.Impressao.textoRadio3.anchorX = 0
				Var.Impressao.textoRadio3.anchorY = 0
				Var.Impressao.textoRadio3.x = Var.Impressao.radioButton3.x + Var.Impressao.radioButton3.width + 20
				Var.Impressao.textoRadio3.y = Var.Impressao.radioButton3.y
				Var.Impressao.grupoPDFPNG:insert( Var.Impressao.textoRadio3 )
				local function textListener( event )
					if ( event.phase == "began" ) then
						-- User begins editing "defaultField"
 
					elseif ( event.phase == "ended" or event.phase == "submitted" ) then
						-- Output resulting text from "defaultField"
						print( event.target.text )
 
					elseif ( event.phase == "editing" ) then
						event.text = string.gsub(event.text,"([^%-,%divxl])","")
						event.text = string.gsub(event.text,",%-",",")
						event.text = string.gsub(event.text,"%-,","%-")
						event.text = string.gsub(event.text,"%-%-","%-")
						event.text = string.gsub(event.text,",,",",")
						event.text = string.gsub(event.text,"%d%a","")
						event.target.text = string.gsub(event.text,"%a%d","")
						print( event.newCharacters )
						print( event.oldText )
						print( event.startPosition )
						print( event.text )
					end
				end
				Var.Impressao.opcoesIntervalo.textoRadio3Dica = display.newText(Var.Impressao.grupoPDFPNG,"Ex.: 1-5\n      1,2,3,4,5",Var.Impressao.textoRadio3.x,Var.Impressao.textoRadio3.y + 50,"Fontes/segoeui.ttf",30)
				Var.Impressao.opcoesIntervalo.textoRadio3Dica:setFillColor(1,1,1)
				Var.Impressao.opcoesIntervalo.textoRadio3Dica.anchorX=0
				Var.Impressao.opcoesIntervalo.textoRadio3Dica.anchorY=0
				Var.Impressao.opcoesIntervalo.textoRadio3Campo = native.newTextField(0,0,300,40)
				Var.Impressao.opcoesIntervalo.textoRadio3Campo.x = Var.Impressao.opcoesIntervalo.textoRadio3Dica.x + Var.Impressao.opcoesIntervalo.textoRadio3Campo.width/2
				Var.Impressao.opcoesIntervalo.textoRadio3Campo.y = Var.Impressao.opcoesIntervalo.textoRadio3Dica.y + Var.Impressao.opcoesIntervalo.textoRadio3Dica.height + Var.Impressao.opcoesIntervalo.textoRadio3Campo.height/2
				Var.Impressao.opcoesIntervalo.textoRadio3Dica.isVisible = false
				Var.Impressao.opcoesIntervalo.textoRadio3Campo.isVisible = false
				Var.Impressao.opcoesIntervalo.textoRadio3Campo:addEventListener( "userInput", textListener )
				Var.Impressao.grupoPDFPNG:insert(Var.Impressao.opcoesIntervalo.textoRadio3Campo)
				
				local botaoCancelar = widget.newButton{
				  top = H/2 + 200 + 5,
				  left = W/2 - 300,
				  defaultFile = 'botaoCancelarImprimir.png',
				  overFile    = 'botaoCancelarImprimirD.png',
				  onRelease     = function( event )
						if Var.Impressao.grupoPDFPNG then
							Var.Impressao.grupoPDFPNG:removeSelf()
							Var.Impressao.grupoPDFPNG = nil
						end
				  end
				}
				
				Var.Impressao.grupoPDFPNG:insert(botaoCancelar)
				botaoCancelar.texto = display.newText(Var.Impressao.grupoPDFPNG,"CANCELAR",0,0,"Fontes/ariblk.ttf",40)
				botaoCancelar.texto:setFillColor(1,1,1)
				botaoCancelar.texto.x = botaoCancelar.x
				botaoCancelar.texto.y = botaoCancelar.y
				
				local function confirmarSelecaoImprimir(event)
					native.setKeyboardFocus( nil )
					print("TIPO = "..Var.Impressao.grupoPDFPNG.tipo)
					if Var.Impressao.grupoPDFPNG.tipo == "PDF" then
						
						if Var.Impressao.grupoPDFPNG.escolha == "atual" then
							abrirEmailComPDF()
						elseif Var.Impressao.grupoPDFPNG.escolha == "intervalo" then
							local vetorPaginasTexto = Var.Impressao.opcoesIntervalo.textoRadio3Campo.text
							local vetorAux = {}
							local count = 1
							for pagina in string.gmatch(vetorPaginasTexto,"([^%-,]+)") do
								local aux = pagina
								
								if string.find(string.lower(pagina),"i") or string.find(pagina,"v") or string.find(pagina,"x") or string.find(pagina,"l") then
									aux = string.gsub(string.lower(pagina),"%s%p","")
									aux = auxFuncs.ToNumber(aux)
									aux = (-1)*tonumber(aux)
								end
								
								local paginaReal = aux - varGlobal.contagemInicialPaginas + telas.numeroTotal.PaginasPre+telas.numeroTotal.Indices +1
								table.insert(vetorAux,paginaReal) 
								--testarNoAndroid(paginaReal,100 + 50*(count))
								count = count + 1 
							end
							criarVetorDasPaginas(vetorAux)
						elseif Var.Impressao.grupoPDFPNG.escolha == "todas" then
							local vetorPaginas = {}
							local todas = telas.numeroTotal.PaginasPre+telas.numeroTotal.Indices+telas.numeroTotal.Paginas
							for i=1,todas do
								table.insert(vetorPaginas,i)
							end
							criarVetorDasPaginas(vetorPaginas)
						end
					--[[elseif Var.Impressao.grupoPDFPNG.tipo == "PNG" then
						if Var.Impressao.grupoPDFPNG.escolha == "atual" then
							abrirEmailComImagem()
						elseif Var.Impressao.grupoPDFPNG.escolha == "intervalo" then
							local vetorPaginasTexto = Var.Impressao.opcoesIntervalo.textoRadio3Campo.text
							local vetorAux = {}
							local count = 1
							for pagina in string.gmatch(vetorPaginasTexto,"([^%-,]+)") do
								local aux = pagina
								
								if string.find(string.lower(pagina),"i") or string.find(pagina,"v") or string.find(pagina,"x") or string.find(pagina,"l") then
									aux = string.gsub(string.lower(pagina),"%s%p","")
									aux = auxFuncs.ToNumber(aux)
									aux = (-1)*tonumber(aux)
								end
								
								local paginaReal = aux - varGlobal.contagemInicialPaginas + telas.numeroTotal.PaginasPre+telas.numeroTotal.Indices +1
								table.insert(vetorAux,paginaReal) 
								--testarNoAndroid(paginaReal,100 + 50*(count))
								count = count + 1 
							end
							criarVetorDasPaginas(vetorAux)
						elseif Var.Impressao.grupoPDFPNG.escolha == "todas" then
							local vetorPaginas = {}
							local todas = telas.numeroTotal.PaginasPre+telas.numeroTotal.Indices+telas.numeroTotal.Paginas
							for i=1,todas do
								table.insert(vetorPaginas,i)
							end
							if 
							criarVetorDasPaginas(vetorPaginas)
						end]]
					end
				end
				local botaoConfirmar = widget.newButton{
				  top = H/2 + 200 + 5,
				  left = W/2 + 5,
				  defaultFile = 'botaoConfirmarImprimir.png',
				  overFile    = 'botaoConfirmarImprimirD.png',
				  onRelease     = confirmarSelecaoImprimir
				}
				Var.Impressao.grupoPDFPNG:insert(botaoConfirmar)
				botaoConfirmar.texto = display.newText(Var.Impressao.grupoPDFPNG,"CONFIRMAR",0,0,"Fontes/ariblk.ttf",40)
				botaoConfirmar.texto:setFillColor(1,1,1)
				botaoConfirmar.texto.x = botaoConfirmar.x
				botaoConfirmar.texto.y = botaoConfirmar.y
			end
			
			aoFecharMenuRapido()
		end
		local escolhasGerais = {}
		for i=1,#escolhas do

			table.insert(escolhasGerais,
			{
				listener = rodarOpcao,
				tamanho = 45,
				texto = escolhas[i],
				cor = {.9,.9,.9},
				params = {tipo = escolhas[i]},
				cor = {37/225,185/225,219/225},
			})
			if i == 1 then
				escolhasGerais[#escolhasGerais].iconeEsq =  {imagem = "iconePNG.png",alt = 45,larg = 45}
			elseif i == 2 then
				escolhasGerais[#escolhasGerais].iconeEsq =  {imagem = "iconePDF.png",alt = 45,larg = 45}
			else
				escolhasGerais[#escolhasGerais].fonte = "Fontes/paolaAccent.ttf"
			end
		end
		Var.Impressao.MenuRapido = MenuRapido.New(
			{
			escolhas = escolhasGerais,
			rowWidthGeneric = 240,
			rowHeightGeneric = 55,
			tamanhoTexto = 45,
			closeListener = aoFecharMenuRapido,
			telaProtetiva = "nao"
			}
		)
		GRUPOGERAL:insert(Var.Impressao.MenuRapido)
		--Var.imagens[ims].MenuRapido.x = event.x
		--Var.imagens[ims].MenuRapido.y = event.y - GRUPOGERAL.y
		Var.Impressao.MenuRapido.x = event.x
		Var.Impressao.MenuRapido.y = event.target.y + event.target.height/2 - Var.Impressao.MenuRapido.height
		Var.Impressao.MenuRapido.anchorY=1
		Var.Impressao.MenuRapido.anchorX=event.target.anchorX
		if Var.Impressao.MenuRapido.x + Var.Impressao.MenuRapido.width > W and system.orientation == "portrait" then
			Var.Impressao.MenuRapido.x = event.x - Var.Impressao.MenuRapido.width
		end
		--[[if Var.imagens[ims].MenuRapido.y + Var.imagens[ims].MenuRapido.height > H and system.orientation == "portrait" then
			Var.imagens[ims].MenuRapido.y = event.y - Var.imagens[ims].MenuRapido.height - GRUPOGERAL.y
		end]]
		if system.orientation == "landscapeLeft" then
			Var.Impressao.MenuRapido.y = event.target.y + event.target.height/2
			Var.Impressao.MenuRapido.x = event.target.x
		elseif system.orientation == "landscapeRight" then
			Var.Impressao.MenuRapido.y = event.target.y + event.target.height/2
			Var.Impressao.MenuRapido.x = event.target.x
		end
	
	end
	
	local function criarInterfaceDeImprimirPaginas(e)
		if e.target.clicado == false  then
			audio.stop()
			media.stopSound()
			
			local som = audio.loadStream(varGlobal.ttsImprimirMenuRapido1Clique)
			local timerRequerimento = timer.performWithDelay(16,function() audio.play(som) end,1)
			e.target.clicado = true
			timer.performWithDelay(1000,function() e.target.clicado = false end,1)
			return true
		end
		if e.target.clicado == true  then
			audio.stop()
			e.target.clicado = false
			historicoLib.Criar_e_salvar_vetor_historico({
				tipoInteracao = "impressao",
				pagina_livro = varGlobal.PagH,
				acao = "abrir",
				tela = telas
			})
			
			local textoTitulo = varGlobal.menuImprimirTitulo.." PDF"
			Var.Impressao.grupoPDFPNG = display.newGroup()
			Var.Impressao.protecaoTela = auxFuncs.TelaProtetiva()
			Var.Impressao.grupoPDFPNG:insert(Var.Impressao.protecaoTela)
			Var.Impressao.alphaNaoSelecionado = 0.3
			Var.Impressao.AbaLivroRect = widget.newButton(
			{
				shape = "roundedRect",
				label = "Livro",
				labelAlign = "center",
				labelColor = { default={ 1,1,1,1 }, over={ 1,1,1, 0.5 } },
				font = "Fontes/paolaAccent.ttf",
				fontSize = 50,
				onRelease = function(e)
								if Var.Impressao.tableViewDic then
									Var.Impressao.tableViewSelectedText:removeSelf()
									Var.Impressao.tableViewSelectedText = nil
									Var.Impressao.tableViewDic:removeSelf()
									Var.Impressao.tableViewDic = nil
								end
								Var.Impressao.AbaDeckRect.alpha = Var.Impressao.alphaNaoSelecionado
								Var.Impressao.AbaDicRect.alpha = Var.Impressao.alphaNaoSelecionado
								--button._view._label._labelColor.default = { 1, 0, 0, 0.5 }
								Var.Impressao.AbaDeckRect._view._label:setFillColor( 1, 1, 1, 0.5 )
								Var.Impressao.AbaDicRect._view._label:setFillColor( 1, 1, 1, 0.5 )
								Var.Impressao.AbaLivroRect.alpha = 1.0
								historicoLib.Criar_e_salvar_vetor_historico({
									tipoInteracao = "impressao",
									pagina_livro = varGlobal.PagH,
									acao = "aba livro",
									tela = telas
								})
								Var.Impressao.fundo:setFillColor(191/255,17/255,17/255)
								
								Var.Impressao.grupoPDFPNG.tipo = "PDF"
								Var.Impressao.textoFundoTitulo:setFillColor(1,1,1)
								Var.Impressao.textoRadio1:setFillColor(1,1,1)
								Var.Impressao.textoRadio2:setFillColor(1,1,1)
								Var.Impressao.textoRadio3:setFillColor(1,1,1)
								Var.Impressao.textoRadio1.text = varGlobal.menuImprimirTexto1
								Var.Impressao.textoRadio2.text = varGlobal.menuImprimirTexto2
								Var.Impressao.textoRadio3.isVisible = true
								Var.Impressao.radioButton3.isVisible = true
								if Var.Impressao.opcoesIntervalo then
									Var.Impressao.opcoesIntervalo.textoRadio3Campo.isVisible = false
									Var.Impressao.opcoesIntervalo.textoRadio3Dica.isVisible = false
								end
								Var.Impressao.radioButton1:setState( { isOn=true, isAnimated=true } )
								Var.Impressao.grupoPDFPNG.escolha = "atual"
							end
				,
				width = 170,
				height = 70,
				fillColor = { default={ 191/255,17/255,17/255, 1 }, over={ 0.7, 0.02, 0.01, .5 } },
				strokeColor = { default={ 0, 0, 0 }, over={ 0, 0, 0,.7 } },
				strokeWidth = 3,
				cornerRadius = 10
			})
			
			--Var.Impressao.AbaLivroRect.alpha = .6
			Var.Impressao.AbaDeckRect = widget.newButton(
			{
				shape = "roundedRect",
				label = "CARDS",
				labelAlign = "center",
				labelColor = { default={ 0,0,0,1 }, over={ 1,1,1, 0.5 } },
				font = "Fontes/paolaAccent.ttf",
				fontSize = 50,
				onRelease = function(e)
								if Var.Impressao.tableViewDic then
									Var.Impressao.tableViewSelectedText:removeSelf()
									Var.Impressao.tableViewSelectedText = nil
									Var.Impressao.tableViewDic:removeSelf()
									Var.Impressao.tableViewDic = nil
								end
								Var.Impressao.AbaLivroRect.alpha = Var.Impressao.alphaNaoSelecionado + 0.1
								Var.Impressao.AbaDicRect.alpha = Var.Impressao.alphaNaoSelecionado + 0.1
								Var.Impressao.AbaLivroRect._view._label:setFillColor( 0, 0, 0, 0.5 )
								Var.Impressao.AbaDicRect._view._label:setFillColor( 0, 0, 0, 0.5 )
								Var.Impressao.AbaDeckRect.alpha = 1.0
								historicoLib.Criar_e_salvar_vetor_historico({
									tipoInteracao = "impressao",
									pagina_livro = varGlobal.PagH,
									acao = "aba cards",
									tela = telas
								})
								Var.Impressao.fundo:setFillColor(1,1,1)
								--Var.Impressao.AbaLivroRect.alpha = 1
								--Var.Impressao.AbaDeckRect.alpha = .6
								Var.Impressao.grupoPDFPNG.tipo = "CARDS"
								Var.Impressao.textoFundoTitulo:setFillColor(0,0,0)
								Var.Impressao.textoRadio1:setFillColor(0,0,0)
								Var.Impressao.textoRadio2:setFillColor(0,0,0)
								Var.Impressao.textoRadio3:setFillColor(0,0,0)
								Var.Impressao.textoRadio1.text = varGlobal.menuImprimirTexto1
								Var.Impressao.textoRadio2.text = varGlobal.menuImprimirTexto2
								Var.Impressao.textoRadio3.isVisible = true
								Var.Impressao.radioButton3.isVisible = true
								if Var.Impressao.opcoesIntervalo then
									Var.Impressao.opcoesIntervalo.textoRadio3Campo.isVisible = false
									Var.Impressao.opcoesIntervalo.textoRadio3Dica.isVisible = false
								end
								Var.Impressao.radioButton1:setState( { isOn=true, isAnimated=true } )
								Var.Impressao.grupoPDFPNG.escolha = "atual"
							end
				,
				width = 170,
				height = 70,
				fillColor = { default={ 1,1,1, 1 }, over={ 1,1,1, .5 } },
				strokeColor = { default={ 0, 0, 0 }, over={ 0, 0, 0,.7 } },
				strokeWidth = 3,
				cornerRadius = 10
			})
			Var.Impressao.AbaDeckRect.alpha = 0.25
			
			Var.Impressao.AbaDicRect = widget.newButton(
			{
				shape = "roundedRect",
				label = "Dicionário",
				labelAlign = "center",
				labelColor = { default={ 1,1,1,1 }, over={ 1,1,1, 0.5 } },
				font = "Fontes/paolaAccent.ttf",
				fontSize = 36,
				onRelease = function(e)
								Var.Impressao.AbaDeckRect.alpha = Var.Impressao.alphaNaoSelecionado
								Var.Impressao.AbaLivroRect.alpha = Var.Impressao.alphaNaoSelecionado
								Var.Impressao.AbaDeckRect._view._label:setFillColor( 1, 1, 1, 0.5 )
								Var.Impressao.AbaLivroRect._view._label:setFillColor( 1, 1, 1, 0.5 )
								Var.Impressao.AbaDicRect.alpha = 1.0
								historicoLib.Criar_e_salvar_vetor_historico({
									tipoInteracao = "impressao",
									pagina_livro = varGlobal.PagH,
									acao = "aba dicionario",
									tela = telas
								})
								Var.Impressao.fundo:setFillColor(38/255,117/255,139/255)
								--Var.Impressao.AbaLivroRect.alpha = 1
								--Var.Impressao.AbaDeckRect.alpha = .6
								Var.Impressao.grupoPDFPNG.tipo = "dicionario"
								Var.Impressao.textoFundoTitulo:setFillColor(1,1,1)
								Var.Impressao.textoRadio1:setFillColor(1,1,1)
								Var.Impressao.textoRadio2:setFillColor(1,1,1)
								Var.Impressao.textoRadio3:setFillColor(1,1,1)
								Var.Impressao.textoRadio1.text = varGlobal.menuImprimirTextoDic1
								Var.Impressao.textoRadio2.text = varGlobal.menuImprimirTextoDic2
								Var.Impressao.textoRadio3.isVisible = false
								Var.Impressao.radioButton3.isVisible = false
								if Var.Impressao.opcoesIntervalo then
									Var.Impressao.opcoesIntervalo.textoRadio3Campo.isVisible = false
									Var.Impressao.opcoesIntervalo.textoRadio3Dica.isVisible = false
								end
								Var.Impressao.radioButton1:setState( { isOn=true, isAnimated=true } )
								Var.Impressao.grupoPDFPNG.escolha = "atual"
								if not Var.Impressao.tableViewDic or not Var.Impressao.tableViewDic.x then
									function Var.Impressao.gerarLinha( event )
										local phase = event.phase
										local row = event.row
										local groupContentHeight = row.contentHeight
										
										local palavra = row.params.vetorPalavraArquivo[1]
										local arquivo = row.params.vetorPalavraArquivo[2]
									 
										local rowHeight = row.contentHeight
										local rowWidth = row.contentWidth
										
										if not palavra then
											local linhaSuperior = display.newRect(row,250,0,500,1)
											linhaSuperior:setFillColor(0,0,0)
											row.rowTitle = display.newText( row, "Nenhuma há palavra a ser selecionada",0,0, 500, rowHeight,"Fontes/segoeui.ttf", 40 )
											row.rowTitle.x = 10
											row.rowTitle.anchorX = 0
											row.rowTitle.y = groupContentHeight * 0.5
											row.rowTitle:setFillColor(0,0,0)
										else
											row.background = display.newRect(row,2,2,rowWidth-4,rowHeight-4)
											row.background.anchorX=0;row.background.anchorY=0
											row.background.strokeWidth = 3
											if Var.Impressao.vetorPalavrasSelecionadas[row.id][2] then
												row.background:setFillColor(1/255,152/255,162/255)
												row.background:setStrokeColor(.825,0,0)
												row.background.alpha = .5
											else
												row.background:setFillColor(1,1,1)
												row.background:setStrokeColor(1,1,1)
												row.background.alpha = 1
											end 
											local linhaSuperior = display.newRect(row,250,0,500,1)
											linhaSuperior:setFillColor(0,0,0)
											
											row.rowTitle = display.newText( row, palavra,0,0,0, rowHeight,"Fontes/segoeui.ttf", 30 )
											row.rowTitle.x = 10
											row.rowTitle.anchorX = 0
											row.rowTitle.y = groupContentHeight * 0.5 + 5
											row.rowTitle:setFillColor(0,0,0)
											
											local function AbrirFrase()
												mostrarPaginaDicinario(arquivo)
												return true
											end
											row.botaoFrase = widget.newButton {
												defaultFile = "menuRapidoDic.png",
												overFile = "menuRapidoDicD.png",
												strokeColor = {default = {0,0,0},over = {0,0,0,0.5}},
												font = "Fontes/segoeui.ttf",
												fontSize = 40,
												strokeWidth = 1,
												radius = 5,
												width = 42,
												height = 42,
												onRelease = AbrirFrase
											}
											row.botaoFrase.y = 5 + row.botaoFrase.height/2
											row.botaoFrase.x = row.width - row.botaoFrase.width/2 - 10
											row:insert(row.botaoFrase)
										end
										local linhaInferior = display.newRect(row,250,groupContentHeight,500,1)
										linhaInferior:setFillColor(0,0,0)
									end
									
									local function selecionarPalavra(event )
										local phase = event.phase
										local row = event.row
										--if phase == "ended" then
											if Var.Impressao.vetorPalavrasSelecionadas[row.id][2] then
												-- retirar cor de selecionada
												Var.Impressao.vetorPalavrasSelecionadas[row.id][2] = false
												Var.Impressao.vetorPalavrasSelecionadas.numero = Var.Impressao.vetorPalavrasSelecionadas.numero -1
											else
												-- colocar cor de selecionada
												Var.Impressao.vetorPalavrasSelecionadas[row.id][2] = true
												Var.Impressao.vetorPalavrasSelecionadas.numero = Var.Impressao.vetorPalavrasSelecionadas.numero + 1
											end
											local nSelecionadas = Var.Impressao.vetorPalavrasSelecionadas.numero
											local total = #Var.Impressao.vetorPalavrasSelecionadas
											Var.Impressao.tableViewSelectedText.text = "Selecionadas: "..nSelecionadas.." de "..total
											Var.Impressao.tableViewDic:reloadData()
										--end
									end
									local tablePalavrasArquivos = auxFuncs.loadTable("dicImpressao.json","res")
									if not Var.Impressao.vetorPalavrasSelecionadas then
										Var.Impressao.vetorPalavrasSelecionadas = {}
										Var.Impressao.vetorPalavrasSelecionadas.numero = 0
										for i=1,#tablePalavrasArquivos do
											table.insert(Var.Impressao.vetorPalavrasSelecionadas,{i,false})
										end
									end
									local rowColor = {1,1,1}
									Var.Impressao.tableViewDic = widget.newTableView(
										{
											height = 200,
											width = 500,
											onRowRender = Var.Impressao.gerarLinha,
											onRowTouch = selecionarPalavra,
											listener = scrollListener,
											rowTouchDelay = 100
										}
									)
									for i=1,#tablePalavrasArquivos do
										
										Var.Impressao.tableViewDic:insertRow{
											rowHeight = 60,
											id = i,
											rowColor = {default = {1,1,1},over={.9,.9,.9}},
											params = {vetorPalavraArquivo = tablePalavrasArquivos[i]}
										}
									end
									Var.Impressao.tableViewDic.x = W/2 - 30
									Var.Impressao.tableViewDic.y = Var.Impressao.textoRadio2.y + Var.Impressao.textoRadio2.height/2 + Var.Impressao.tableViewDic.height/2 + 40
									Var.Impressao.tableViewDic.isVisible = false
									Var.Impressao.grupoPDFPNG:insert(Var.Impressao.tableViewDic)
									local nSelecionadas = Var.Impressao.vetorPalavrasSelecionadas.numero
									local total = #Var.Impressao.vetorPalavrasSelecionadas
									Var.Impressao.tableViewSelectedText = display.newText("Selecionadas: "..nSelecionadas.." de "..total,0,0,"Fontes/seguibl.ttf",30)
									Var.Impressao.tableViewSelectedText.x = Var.Impressao.tableViewDic.x - Var.Impressao.tableViewDic.width/2 + 5
									Var.Impressao.tableViewSelectedText.y = Var.Impressao.tableViewDic.y + Var.Impressao.tableViewDic.height/2 + 5
									Var.Impressao.tableViewSelectedText.isVisible = false
									Var.Impressao.tableViewSelectedText.anchorX = 0
									Var.Impressao.tableViewSelectedText.anchorY = 0
									Var.Impressao.grupoPDFPNG:insert(Var.Impressao.tableViewSelectedText)
								end
							end
				,
				width = 170,
				height = 70,
				fillColor = { default={ 38/255,117/255,139/255,1, 1 }, over={ 38/255,117/255,139/255,1, .5 } },
				strokeColor = { default={ 0, 0, 0 }, over={ 0, 0, 0,.7 } },
				strokeWidth = 3,
				cornerRadius = 10
			})
			Var.Impressao.AbaDicRect.alpha = 0.25
			
			Var.Impressao.fundo = display.newRoundedRect(Var.Impressao.grupoPDFPNG,0,0,620,700,10)
			--Var.Impressao.fundo = display.newImage(Var.Impressao.grupoPDFPNG,"menu enviar.png")
			Var.Impressao.fundo.x = W/2
			Var.Impressao.fundo.y = H/2
			Var.Impressao.fundo.strokeWidth = 2
			Var.Impressao.fundo:setStrokeColor(0,0,0)
			Var.Impressao.grupoPDFPNG:insert(Var.Impressao.AbaLivroRect)
			Var.Impressao.grupoPDFPNG:insert(Var.Impressao.AbaDeckRect)
			Var.Impressao.grupoPDFPNG:insert(Var.Impressao.AbaDicRect)
			Var.Impressao.AbaLivroRect.x = Var.Impressao.fundo.x - Var.Impressao.fundo.width/2 + Var.Impressao.AbaLivroRect.width/2 + 5
			Var.Impressao.AbaDeckRect.x = Var.Impressao.AbaLivroRect.x + Var.Impressao.AbaLivroRect.width/2 + Var.Impressao.AbaDeckRect.width/2
			Var.Impressao.AbaDicRect.x = Var.Impressao.AbaDeckRect.x + Var.Impressao.AbaDeckRect.width/2 + Var.Impressao.AbaDicRect.width/2
			Var.Impressao.AbaLivroRect.y = Var.Impressao.fundo.y - Var.Impressao.fundo.height/2 + Var.Impressao.AbaLivroRect.height/2 + 5
			Var.Impressao.AbaDeckRect.y = Var.Impressao.AbaLivroRect.y
			Var.Impressao.AbaDicRect.y = Var.Impressao.AbaLivroRect.y
			local larguraMenu = Var.Impressao.fundo.width
			local alturaMenu = Var.Impressao.fundo.height
			
			local somAbrir = audio.loadSound("audioTTS_envioPDF abrir.MP3")
			audio.play(somAbrir)
			textoTitulo = varGlobal.menuImprimirTitulo.." PDF"
			Var.Impressao.fundo:setFillColor(191/255,17/255,17/255)
			
			textoTitulo = varGlobal.menuImprimirTitulo.." PDF"			
			Var.Impressao.grupoPDFPNG.tipo = "PDF"
			
			
			if e.target.tipo == "Enviar Imagem.." or e.target.tipo == "Enviar PDF.." then
				Var.Impressao.textoFundoTitulo = display.newText(Var.Impressao.grupoPDFPNG,textoTitulo,0,470,"Fontes/ariblk.ttf",50)
				Var.Impressao.textoFundoTitulo.x = W/2-larguraMenu/2+Var.Impressao.textoFundoTitulo.width/2 + 15
				Var.Impressao.textoFundoTitulo:setFillColor(1,1,1)
			
				local options = {
					width = 100,
					height = 101,
					numFrames = 2,
					sheetContentWidth = 200,
					sheetContentHeight = 101
				}
				local radioButtonSheet = graphics.newImageSheet( "check.png", options )
				
				local texto1 = varGlobal.menuImprimirTexto1
				local texto2 = varGlobal.menuImprimirTexto2
				local texto3 = varGlobal.menuImprimirTexto3
				
				local opcaoInicial = {"atual","todas","intervalo"}
				Var.Impressao.grupoPDFPNG.escolha = "atual"
				opcaoInicial["atual"] = true
				opcaoInicial["todas"] = false
				opcaoInicial["intervalo"] = false
				Var.Impressao.opcoesIntervalo = {}
				local function onSwitchPress(e)
					
					if Var.Impressao.opcoesIntervalo.textoRadio3Dica then
						Var.Impressao.opcoesIntervalo.textoRadio3Dica.isVisible = false
						Var.Impressao.opcoesIntervalo.textoRadio3Campo.isVisible = false
					end
					
					local switch = e.target
					Var.Impressao.grupoPDFPNG.escolha = switch.id
					print("switch id = ",switch.id)
					if Var.Impressao.tableViewDic then
						Var.Impressao.tableViewDic.isVisible = false
						Var.Impressao.tableViewSelectedText.isVisible = false
					end
					if switch.id == "atual" then
						Var.Impressao.textoRadio1:setFillColor(1,1,1)
						if Var.Impressao.grupoPDFPNG.tipo == "CARDS" then
							Var.Impressao.textoRadio1:setFillColor(0,0,0)
						end
						if Var.Impressao.grupoPDFPNG.tipo == "dicionario" then
							Var.Impressao.textoRadio1:setFillColor(1,1,1)
						end
						Var.Impressao.textoRadio2:setFillColor(0.7,0.7,0.7)
						Var.Impressao.textoRadio3:setFillColor(0.7,0.7,0.7)
						Var.Impressao.grupoPDFPNG.escolha = "atual"
					elseif switch.id == "todas" then
						Var.Impressao.textoRadio1:setFillColor(0.7,0.7,0.7)
						Var.Impressao.textoRadio2:setFillColor(1,1,1)
						if Var.Impressao.grupoPDFPNG.tipo == "CARDS" then
							Var.Impressao.textoRadio2:setFillColor(0,0,0)
						end
						if Var.Impressao.grupoPDFPNG.tipo == "dicionario" then
							Var.Impressao.textoRadio2:setFillColor(1,1,1)
						end
						Var.Impressao.textoRadio3:setFillColor(0.7,0.7,0.7)
						Var.Impressao.grupoPDFPNG.escolha = "todas"
						if Var.Impressao.tableViewDic then
							Var.Impressao.tableViewDic.isVisible = true
							Var.Impressao.tableViewSelectedText.isVisible = true
						end
					elseif switch.id == "intervalo" then
						Var.Impressao.textoRadio1:setFillColor(0.7,0.7,0.7)
						Var.Impressao.textoRadio2:setFillColor(0.7,0.7,0.7)
						Var.Impressao.textoRadio3:setFillColor(1,1,1)
						if Var.Impressao.grupoPDFPNG.tipo == "CARDS" then
							Var.Impressao.textoRadio3:setFillColor(0,0,0)
						end
						if Var.Impressao.grupoPDFPNG.tipo == "dicionario" then
							Var.Impressao.textoRadio3:setFillColor(1,1,1)
						end
						Var.Impressao.opcoesIntervalo.textoRadio3Dica.isVisible = true
						if Var.Impressao.grupoPDFPNG.tipo == "CARDS" then
							Var.Impressao.opcoesIntervalo.textoRadio3Dica:setFillColor(0,0,0)
						end
						if Var.Impressao.grupoPDFPNG.tipo == "dicionario" then
							Var.Impressao.opcoesIntervalo.textoRadio3Dica:setFillColor(1,1,1)
						end
						Var.Impressao.opcoesIntervalo.textoRadio3Campo.isVisible = true
						Var.Impressao.grupoPDFPNG.escolha = "intervalo"
					end
					
				end
				Var.Impressao.radioButton1 = widget.newSwitch(
					{
						x = 120,
						y = 510,
						style = "radio",
						id = "atual",
						width = 50,
						height = 50,
						initialSwitchState = opcaoInicial["atual"],
						onPress = onSwitchPress,
						sheet = radioButtonSheet,
						frameOff = 1,
						frameOn = 2
					}
				)
				Var.Impressao.radioButton1.anchorX=0;Var.Impressao.radioButton1.anchorY=0
				--GrupoAli.radioButton1.x = 0;GrupoAli.radioButton1.y = 0
				Var.Impressao.grupoPDFPNG:insert( Var.Impressao.radioButton1 )
				Var.Impressao.textoRadio1 = display.newText(texto1,0,0,"Fontes/ariblk.ttf",30)
				Var.Impressao.textoRadio1:setFillColor(1,1,1)
				Var.Impressao.textoRadio1.anchorX = 0
				Var.Impressao.textoRadio1.anchorY = 0
				Var.Impressao.textoRadio1.x = Var.Impressao.radioButton1.x + Var.Impressao.radioButton1.width + 20
				Var.Impressao.textoRadio1.y = Var.Impressao.radioButton1.y
				Var.Impressao.grupoPDFPNG:insert( Var.Impressao.textoRadio1 )
				Var.Impressao.radioButton2 = widget.newSwitch(
					{
						x = 120,
						y = 580,
						style = "radio",
						id = "todas",
						width = 50,
						height = 50,
						initialSwitchState = opcaoInicial["todas"],
						onPress = onSwitchPress,
						sheet = radioButtonSheet,
						frameOff = 1,
						frameOn = 2
					}
				)
				Var.Impressao.radioButton2.anchorX=0;Var.Impressao.radioButton2.anchorY=0
				Var.Impressao.grupoPDFPNG:insert( Var.Impressao.radioButton2 )
				Var.Impressao.textoRadio2 = display.newText(texto2,0,0,"Fontes/ariblk.ttf",30)
				Var.Impressao.textoRadio2:setFillColor(0.7,0.7,0.7)
				Var.Impressao.textoRadio2.anchorX = 0
				Var.Impressao.textoRadio2.anchorY = 0
				Var.Impressao.textoRadio2.x = Var.Impressao.radioButton2.x + Var.Impressao.radioButton2.width + 20
				Var.Impressao.textoRadio2.y = Var.Impressao.radioButton2.y
				Var.Impressao.grupoPDFPNG:insert( Var.Impressao.textoRadio2 )
				Var.Impressao.radioButton3 = widget.newSwitch(
					{
						x = 120,
						y = 650,
						style = "radio",
						id = "intervalo",
						width = 50,
						height = 50,
						initialSwitchState = opcaoInicial["intervalo"],
						onPress = onSwitchPress,
						sheet = radioButtonSheet,
						frameOff = 1,
						frameOn = 2
					}
				)
				Var.Impressao.radioButton3.anchorX=0;Var.Impressao.radioButton3.anchorY=0
				Var.Impressao.grupoPDFPNG:insert( Var.Impressao.radioButton3 )
				Var.Impressao.textoRadio3 = display.newText(texto3,0,0,"Fontes/ariblk.ttf",30)
				Var.Impressao.textoRadio3:setFillColor(0.7,0.7,0.7)
				Var.Impressao.textoRadio3.anchorX = 0
				Var.Impressao.textoRadio3.anchorY = 0
				Var.Impressao.textoRadio3.x = Var.Impressao.radioButton3.x + Var.Impressao.radioButton3.width + 20
				Var.Impressao.textoRadio3.y = Var.Impressao.radioButton3.y
				Var.Impressao.grupoPDFPNG:insert( Var.Impressao.textoRadio3 )
				local function textListener( event )
					if ( event.phase == "began" ) then
						-- User begins editing "defaultField"
						transition.to(Var.Impressao.opcoesIntervalo.textoRadio3Campo,{time=0,y = H/2,xScale = 2,yScale = 2})
						Var.Impressao.opcoesIntervalo.ZoomSair.isVisible=true
						Var.Impressao.opcoesIntervalo.ZoomSair.isHitTestable=true
					elseif ( event.phase == "ended" or event.phase == "submitted" ) then
						-- Output resulting text from "defaultField"
						print( event.target.text )
						transition.to(Var.Impressao.opcoesIntervalo.textoRadio3Campo,{time=0,y = Var.Impressao.opcoesIntervalo.textoRadio3Dica.y + Var.Impressao.opcoesIntervalo.textoRadio3Dica.height + Var.Impressao.opcoesIntervalo.textoRadio3Campo.height/2,xScale = 1,yScale = 1})
						Var.Impressao.opcoesIntervalo.ZoomSair.isVisible = false
						Var.Impressao.opcoesIntervalo.ZoomSair.isHitTestable=false
					elseif ( event.phase == "editing" ) then
						transition.to(Var.Impressao.opcoesIntervalo.textoRadio3Campo,{time=0,y = H/2,xScale = 2,yScale = 2})
						Var.Impressao.opcoesIntervalo.ZoomSair.isVisible=true
						Var.Impressao.opcoesIntervalo.ZoomSair.isHitTestable=true
						event.text = string.gsub(event.text,"([^%-,%divxl])","")
						event.text = string.gsub(event.text,",%-",",")
						event.text = string.gsub(event.text,"%-,","%-")
						event.text = string.gsub(event.text,"%-%-","%-")
						event.text = string.gsub(event.text,",,",",")
						event.text = string.gsub(event.text,"%d%a","")
						event.target.text = string.gsub(event.text,"%a%d","")
						print( event.newCharacters )
						print( event.oldText )
						print( event.startPosition )
						print( event.text )
					end
				end
				if Var.Impressao.opcoesIntervalo.ZoomSair then
					Var.Impressao.opcoesIntervalo.ZoomSair:removeSelf()
					Var.Impressao.opcoesIntervalo.ZoomSair = nil
				end
				Var.Impressao.opcoesIntervalo.ZoomSair = auxFuncs.TelaProtetiva()
				Var.Impressao.opcoesIntervalo.ZoomSair.alpha = .3
				Var.Impressao.opcoesIntervalo.ZoomSair.isHitTestable=false
				Var.Impressao.grupoPDFPNG:insert(Var.Impressao.opcoesIntervalo.ZoomSair)
				Var.Impressao.opcoesIntervalo.ZoomSair:addEventListener("tap",function() transition.to(Var.Impressao.opcoesIntervalo.textoRadio3Campo,{time=0,y = Var.Impressao.opcoesIntervalo.textoRadio3Dica.y + Var.Impressao.opcoesIntervalo.textoRadio3Dica.height + Var.Impressao.opcoesIntervalo.textoRadio3Campo.height/2,xScale = 1,yScale = 1});Var.Impressao.opcoesIntervalo.ZoomSair.isVisible = false;Var.Impressao.opcoesIntervalo.ZoomSair.isHitTestable=false;native.setKeyboardFocus(nil) end)
				
				Var.Impressao.opcoesIntervalo.textoRadio3Dica = display.newText(Var.Impressao.grupoPDFPNG,"Ex.: 1-5\n      1,2,3,4,5",Var.Impressao.textoRadio3.x,Var.Impressao.textoRadio3.y + 50,"Fontes/segoeui.ttf",30)
				Var.Impressao.opcoesIntervalo.textoRadio3Dica:setFillColor(1,1,1)
				Var.Impressao.opcoesIntervalo.textoRadio3Dica.anchorX=0
				Var.Impressao.opcoesIntervalo.textoRadio3Dica.anchorY=0
				Var.Impressao.opcoesIntervalo.textoRadio3Campo = native.newTextField(0,0,300,40)
				Var.Impressao.opcoesIntervalo.textoRadio3Campo.isFontSizeScaled = true
				Var.Impressao.opcoesIntervalo.textoRadio3Campo.x = Var.Impressao.opcoesIntervalo.textoRadio3Dica.x + Var.Impressao.opcoesIntervalo.textoRadio3Campo.width/2
				Var.Impressao.opcoesIntervalo.textoRadio3Campo.y = Var.Impressao.opcoesIntervalo.textoRadio3Dica.y + Var.Impressao.opcoesIntervalo.textoRadio3Dica.height + Var.Impressao.opcoesIntervalo.textoRadio3Campo.height/2
				Var.Impressao.opcoesIntervalo.textoRadio3Dica.isVisible = false
				Var.Impressao.opcoesIntervalo.textoRadio3Campo.isVisible = false
				Var.Impressao.opcoesIntervalo.textoRadio3Campo:addEventListener( "userInput", textListener )
				Var.Impressao.grupoPDFPNG:insert(Var.Impressao.opcoesIntervalo.textoRadio3Campo)
				
				local botaoCancelar = widget.newButton{
				  defaultFile = 'closeMenuButton2.png',
				  overFile    = 'closeMenuButton2D.png',
				  width = 50,
				  height = 55,
				  onRelease = function( event )
						historicoLib.Criar_e_salvar_vetor_historico({
							tipoInteracao = "impressao",
							pagina_livro = varGlobal.PagH,
							acao = "fechar",
							tela = telas
						})
						local somFechar = audio.loadSound("audioTTS_envioPDF fechar.MP3")
						audio.play(somFechar)
						timer.performWithDelay(10,function()
							if Var and Var.Impressao and Var.Impressao.grupoPDFPNG then
								Var.Impressao.grupoPDFPNG:removeSelf()
								Var.Impressao.grupoPDFPNG = nil
							end
						end,1)
						return true
				  end
				}
				botaoCancelar.x = W/2 +larguraMenu/2- botaoCancelar.width/2 - 10
				botaoCancelar.y = H/2 - alturaMenu/2 + botaoCancelar.height/2 + 10
				Var.Impressao.grupoPDFPNG:insert(botaoCancelar)
				
				local function confirmarSelecaoImprimir(event)
					native.setKeyboardFocus( nil )
					local tipoHistorico = "livro"
					if Var.Impressao.grupoPDFPNG.tipo == "PDF" then
						tipoHistorico = "livro"
					elseif Var.Impressao.grupoPDFPNG.tipo == "CARDS" then
						tipoHistorico = "cards"
					elseif Var.Impressao.grupoPDFPNG.tipo == "dicionario" then
						tipoHistorico = "dicionario"
					end 
					if Var.Impressao.grupoPDFPNG.tipo == "dicionario" then
						local tablePalavrasArquivos = auxFuncs.loadTable("dicImpressao.json","res")
						local palavras = {}
						if Var.Impressao.grupoPDFPNG.escolha == "atual" then
							for i=1,#tablePalavrasArquivos do
								table.insert(palavras,tablePalavrasArquivos[i][2])
							end
							imprimirPalavrasDicionario(palavras)
						elseif Var.Impressao.grupoPDFPNG.escolha == "todas" then
							local tablePalavrasArquivos = auxFuncs.loadTable("dicImpressao.json","res")
							if Var.Impressao.vetorPalavrasSelecionadas and Var.Impressao.vetorPalavrasSelecionadas.numero > 0 then
								for i=1,#tablePalavrasArquivos do
									if Var.Impressao.vetorPalavrasSelecionadas[i][2] == true then
										table.insert(palavras,tablePalavrasArquivos[i][2])
									end
								end
								imprimirPalavrasDicionario(palavras)
							elseif Var.Impressao.vetorPalavrasSelecionadas and Var.Impressao.vetorPalavrasSelecionadas.numero == 0 then
								native.showAlert("Atenção","Você deve selecionar pelo menos uma palavra antes de prosseguir!",{"OK"})
							end
						end
					else
						if Var.Impressao.grupoPDFPNG.escolha == "atual" then
							historicoLib.Criar_e_salvar_vetor_historico({
								tipoInteracao = "impressao",
								pagina_livro = varGlobal.PagH,
								acao = "confirmar",
								tipo = tipoHistorico,
								subtipo = "atual",
								tela = telas
							})
							abrirEmailComPDF()
						elseif Var.Impressao.grupoPDFPNG.escolha == "intervalo" then
							local vetorPaginasTexto = Var.Impressao.opcoesIntervalo.textoRadio3Campo.text
							local count = 1
							local numbers = {}
							local total = varGlobal.contagemInicialPaginas + telas.numeroTotal.PaginasPre+telas.numeroTotal.Indices - 1
							for number1, number2 in string.gmatch(vetorPaginasTexto, "(%w+)%-?([^,]*)") do
								print("number1,number2",number1,number2)
								if string.find(string.lower(number1),"i") or string.find(number1,"v") or string.find(number1,"x") or string.find(number1,"l") then
									number1 = string.gsub(string.lower(number1),"%s*%p*","")
									number1 = auxFuncs.ToNumber(number1)
									number1 = (-1)*total + tonumber(number1)--(-1)*tonumber(number1)
								end
								number1 = tonumber(number1)
								
								if number2 and number2 ~= "" and number2 ~= " " then
									if string.find(string.lower(number2),"i") or string.find(number2,"v") or string.find(number2,"x") or string.find(number2,"l") then
										number2 = string.gsub(string.lower(number2),"%s*%p*","")
										number2 = auxFuncs.ToNumber(number2)
										number2 = (-1)*total + tonumber(number2)
									end
									number2 = tonumber(number2)
									for i = number1, number2 do
										local paginaReal = i - varGlobal.contagemInicialPaginas + telas.numeroTotal.PaginasPre+telas.numeroTotal.Indices +1
										table.insert(numbers, i)
									end
								else
									local paginaReal = number1 - varGlobal.contagemInicialPaginas + telas.numeroTotal.PaginasPre+telas.numeroTotal.Indices +1
									table.insert(numbers, number1)
								end

							end
							local numbersFinal = {}
							for pag=1,#numbers do
								table.insert(numbersFinal,numbers[pag] - varGlobal.contagemInicialPaginas + telas.numeroTotal.PaginasPre+telas.numeroTotal.Indices +1)
							end
							
							local stringIntervalos = numbersFinal[1]
							for n=2,#numbersFinal do stringIntervalos = stringIntervalos .. ", " .. numbers[n] end
							historicoLib.Criar_e_salvar_vetor_historico({
								tipoInteracao = "impressao",
								pagina_livro = varGlobal.PagH,
								acao = "confirmar",
								tipo = tipoHistorico,
								subtipo = "intervalo",
								intervalo = Var.Impressao.opcoesIntervalo.textoRadio3Campo.text,
								tela = telas
							})
							numbers = nil
							if Var.Impressao.grupoPDFPNG.tipo == "PDF" then
								criarVetorDasPaginas(numbersFinal)
							elseif Var.Impressao.grupoPDFPNG.tipo == "CARDS" then
								local numbers = {}
								for n=1,#numbersFinal do
									table.insert(numbers,tostring(pegarNumeroRealPagina(numbersFinal[n])))
								end
								criarEEnviarCardsDasPaginasEmPdf(numbers)
							end
						elseif Var.Impressao.grupoPDFPNG.escolha == "todas" then
							local vetorPaginas = {}
							historicoLib.Criar_e_salvar_vetor_historico({
								tipoInteracao = "impressao",
								pagina_livro = varGlobal.PagH,
								acao = "confirmar",
								tipo = tipoHistorico,
								subtipo = "todas",
								tela = telas
							})
							local todas = telas.numeroTotal.PaginasPre+telas.numeroTotal.Indices+telas.numeroTotal.Paginas
							for i=1,todas do
								table.insert(vetorPaginas,i)
							end
							if Var.Impressao.grupoPDFPNG.tipo == "PDF" then
								criarVetorDasPaginas(vetorPaginas)
							elseif Var.Impressao.grupoPDFPNG.tipo == "CARDS" then
								local numbers = {}
								for n=1,#vetorPaginas do
									table.insert(numbers,tostring(pegarNumeroRealPagina(vetorPaginas[n])))
								end
								criarEEnviarCardsDasPaginasEmPdf(numbers)
							end
						end
					end
				end
				local botaoConfirmar = widget.newButton{
				  top = H/2 + 250 + 5,
				  defaultFile = 'botaoConfirmarImprimir.png',
				  overFile    = 'botaoConfirmarImprimirD.png',
				  onRelease     = confirmarSelecaoImprimir
				}
				botaoConfirmar.x = W/2
				Var.Impressao.grupoPDFPNG:insert(botaoConfirmar)
				botaoConfirmar.texto = display.newText(Var.Impressao.grupoPDFPNG,"CONFIRMAR",0,0,"Fontes/ariblk.ttf",40)
				botaoConfirmar.texto:setFillColor(1,1,1)
				botaoConfirmar.texto.x = botaoConfirmar.x
				botaoConfirmar.texto.y = botaoConfirmar.y
				
			end
		end
	end
	grupoImpressao.botao = widget.newButton {
		defaultFile = "iconePDF.png",
		overFile = "iconePDFD.png",
		width = 80,
		height = 80,
		onRelease = criarInterfaceDeImprimirPaginas
	}
	grupoImpressao.botao.clicado = false
	grupoImpressao.botao.tipo = "Enviar PDF.."
	
	grupoImpressao.botao.anchorX = 0--Var.anotComInterface.Icone.anchorX
	grupoImpressao.botao.anchorY = 0--Var.anotComInterface.Icone.anchorY
	--Var.anotComInterface.Icone.y = Y+ 100--GRUPOGERAL.height+100--Var.proximoY+ 40
	--Var.anotComInterface.Icone.x = (W-12*W/13)/2
	grupoImpressao.botao.y = 0
	grupoImpressao.botao.x = 0
	grupoImpressao:insert(grupoImpressao.botao)
	
	grupoImpressao.botaoLRight = display.newImageRect(grupoImpressao,"iconePDFR.png",80,80)
	grupoImpressao.botaoLRight.anchorY=0;grupoImpressao.botaoLRight.anchorX=0
	grupoImpressao.botaoLRight.y = 0--GRUPOGERAL.height+100--Var.proximoY+ 40
	grupoImpressao.botaoLRight.x = 0
	grupoImpressao.botaoLRight.isVisible = false
	
	grupoImpressao.botaoLLeft = display.newImageRect(grupoImpressao,"iconePDFL.png",80,80)
	grupoImpressao.botaoLLeft.anchorY=0;grupoImpressao.botaoLLeft.anchorX=0
	grupoImpressao.botaoLLeft.y = 0--GRUPOGERAL.height+100--Var.proximoY+ 40
	grupoImpressao.botaoLLeft.x = 0
	grupoImpressao.botaoLLeft.isVisible = false
	if grupoImpressao.timerOrientacao then
		timer.cancel(grupoImpressao.timerOrientacao)
		grupoImpressao.timerOrientacao = nil
	end
	grupoImpressao.timerOrientacao = timer.performWithDelay(300,
		function(e) 
			if not grupoImpressao.botao then  
				timer.cancel(grupoImpressao.timerOrientacao)
				grupoImpressao.timerOrientacao = nil
			elseif grupoImpressao.botao then
				if system.orientation == "landscapeRight" then
					grupoImpressao.botao.isVisible = false
					grupoImpressao.botaoLLeft.isVisible = false
					grupoImpressao.botaoLRight.isVisible = true
				elseif system.orientation == "landscapeLeft" then
					grupoImpressao.botao.isVisible = false
					grupoImpressao.botaoLLeft.isVisible = true
					grupoImpressao.botaoLRight.isVisible = false
				else
					grupoImpressao.botao.isVisible = true
					grupoImpressao.botaoLLeft.isVisible = false
					grupoImpressao.botaoLRight.isVisible = false
				end
				grupoImpressao.botao.isHitTestable = true
			end 
		end,-1)
	

	return grupoImpressao
end

----------------------------------------------------------
--  COLOCAR BOTÃO SALVAR RELATÓRIO --
----------------------------------------------------------
function M.criarBotaoRelatorio(pagina,telas,Var,varGlobal)
	local grupoRelatorio = display.newGroup()
	
	-- arrumando campos de data
	local data = os.date( "*t" )
	local vetorMeses = {}
	vetorMeses[1] = 31
	local AnO = tonumber(data.year)
	anoBissexto = false
	vetorMeses[3] = 31
	vetorMeses[4] = 30
	vetorMeses[5] = 31
	vetorMeses[6] = 30
	vetorMeses[7] = 31
	vetorMeses[8] = 31
	vetorMeses[9] = 30
	vetorMeses[10] = 31
	vetorMeses[11] = 30
	vetorMeses[12] = 31
	local function DataListener(e)
		local tipo = e.target.t
		local target = e.target
		local aux = tonumber(e.text)
		local dataAtual = os.date( "*t" )
		if e.phase == "editing" then
			if target.text ~= nil and target.text ~= "" then
				if tipo =="d" then
					if aux > 31 then
						target.text = "31"
					elseif aux < 1 then
						target.text = "0"
					end
				elseif tipo =="m" then
					if aux > 12 then
						target.text = "12"
					elseif aux < 1 then
						target.text = "0"
					end
				elseif tipo =="a" then
					if aux > data.year then
						target.text = tostring(data.year)
					end
				end
			end
		elseif e.phase == "ended" then
			if tipo == 'm' or tipo =="d" then
				if string.len(e.target.text) == 1 then e.target.text = "0"..e.target.text end
				if string.len(e.target.text) > 2 then e.target.text = "01" end
			elseif tipo =="a" then
				if string.len(e.target.text) > 4 then e.target.text = "2020" end
				if tonumber(e.target.text) and tonumber(e.target.text) < 2020 then e.target.text = "2020" end
			end
		end
	end
	local function aposGerar(resultado,tipoBotao)
		if resultado == "sucesso" then
			print("WARNING: SUCESSO!!!")
			if tipoBotao == "vizualizar" then
				historicoLib.Criar_e_salvar_vetor_historico({
					tipoInteracao = "relatorio",
					pagina_livro = pagina,
					acao = "fechar visualização",
					tela = telas
				})
			
				local telaPreta = display.newRect(0,0,W,H)
				telaPreta.anchorX = 0.5; telaPreta.anchorY = 0.5
				telaPreta.anchorX = 0.5; telaPreta.anchorY = 0.5
				telaPreta.x = W/2; telaPreta.y = H/2
				telaPreta.x = W/2; telaPreta.y = H/2
				telaPreta:setFillColor(1,1,1)
				telaPreta.alpha=0.9
				telaPreta:addEventListener("tap",function() return true end)
				telaPreta:addEventListener("touch",function() return true end)
				local webView = native.newWebView( display.contentCenterX, display.contentCenterY,700, 1000)
				webView:request( "relatorio.htm", system.DocumentsDirectory )
				local botaoFechar = display.newImageRect("closeMenuButton.png",160,160)
				botaoFechar.x = W/2 + webView.width/2
				botaoFechar.y = webView.y -webView.height/2-5
				local function fecharSite()
					webView:removeSelf()
					botaoFechar:removeSelf()
					telaPreta:removeSelf()
					return true
				end
				botaoFechar:addEventListener("tap",fecharSite)
			elseif tipoBotao == "salvar" then
				local options =
				{
				   to = "",
				   subject = "Relatório do livro",
				   body = "Arquivo contendo o relatório em formato pdf.",
				   attachment = { baseDir=system.DocumentsDirectory, filename="relatorio.pdf", type="document/pdf" }
				}
				native.showPopup( "mail", options )
			end
		else
			native.showAlert("Falha de conexão","Verifique sua conexão com a internet e tente novamente.",{"OK"})
		end
	end
	local function botaoVizualizar(X,Y,WIDTH,HEIGHT,tipo)
		local grupo = display.newGroup()
		grupo.anchorY=0
		grupo.anchorX=0
		local relatorio = require("relatorio")
		local function vizualizarHTMLGerado()
			historicoLib.Criar_e_salvar_vetor_historico({
				tipoInteracao = "relatorio",
				pagina_livro = pagina,
				acao = "abrir visualização",
				tela = telas
			})
			
			local periodoInicial = nil
			local periodoFinal = nil
			if Var.Relatorio.pickerWheel1.chosenDay and Var.Relatorio.pickerWheel1.chosenMonth and Var.Relatorio.pickerWheel1.chosenYear  then
				local Ano = tonumber(Var.Relatorio.pickerWheel1.chosenYear)
				local Mes = tonumber(Var.Relatorio.pickerWheel1.chosenMonth)
				local Dia = tonumber(Var.Relatorio.pickerWheel1.chosenDay)
				if Ano and Ano > 2019 and Mes and Mes > 0 and Dia and Dia > 0 then
					periodoInicial = Var.Relatorio.pickerWheel1.chosenYear.."-"..Var.Relatorio.pickerWheel1.chosenMonth.."-"..Var.Relatorio.pickerWheel1.chosenDay.." 00:00:00.0"
				end
			end
			if Var.Relatorio.pickerWheel2.chosenDay and Var.Relatorio.pickerWheel2.chosenMonth and Var.Relatorio.pickerWheel2.chosenYear  then
				local Ano = tonumber(Var.Relatorio.pickerWheel2.chosenYear)
				local Mes = tonumber(Var.Relatorio.pickerWheel2.chosenMonth)
				local Dia = tonumber(Var.Relatorio.pickerWheel2.chosenDay)
				if Ano and Ano > 2019 and Mes and Mes > 0 and Dia and Dia > 0 then
					periodoFinal = Var.Relatorio.pickerWheel2.chosenYear.."-"..Var.Relatorio.pickerWheel2.chosenMonth.."-"..Var.Relatorio.pickerWheel2.chosenDay.." 23:59:59.9"
				end
			end
			if tipo == "1" then
				relatorio.gerarRelatorio({
					livroID = varGlobal.idLivro1,
					usuarioID = varGlobal.idAluno1,
					periodoInicial = periodoInicial,
					periodoFinal = periodoFinal,
					formatar1 = "data",
					formatar2 = nil,
					onComplete = aposGerar,
					tipoBotao = "vizualizar"
				})
			elseif tipo == "2" then
				relatorio.gerarRelatorio({
					livroID = varGlobal.idLivro1,
					usuarioID = varGlobal.idAluno1,
					periodoInicial = periodoInicial,
					periodoFinal = periodoFinal,
					formatar1 = "data",
					formatar2 = "tipoInteracao",
					onComplete = aposGerar,
					tipoBotao = "vizualizar"
				})
			elseif tipo == "3" then
				relatorio.gerarRelatorio({
					livroID = varGlobal.idLivro1,
					usuarioID = varGlobal.idAluno1,
					periodoInicial = periodoInicial,
					periodoFinal = periodoFinal,
					formatar1 = "tipoInteracao",
					formatar2 = "data",
					onComplete = aposGerar,
					tipoBotao = "vizualizar"
				})
			end
		end
		grupo.botao = widget.newButton {
			shape = "rect",
			label = "   Vizualizar",
			width = WIDTH,
			height = HEIGHT,
			fillColor = { default={ 1, 1, 1, .9 }, over={ 0, 0, 0, .5 } },
			labelColor = { default={ 0, 0, 0 }, over={ 1, 1, 1, 1 } },
			strokeColor = { default={ 0, 0, 0 }, over={ 0, 0, 0 } },
			strokeWidth = 2,
			font = "Fontes/segoeui.ttf",
			fontSize = HEIGHT-HEIGHT/10,
			onRelease = vizualizarHTMLGerado
		}
		grupo.botao.anchorX = 0
		grupo.botao.anchorY = 0
		grupo.botao.y = Y
		grupo.botao.x = X
		grupo:insert(grupo.botao) 
		grupo.icone = display.newImageRect("botaozoom.png",HEIGHT-HEIGHT/8,HEIGHT-HEIGHT/8)
		grupo.icone.anchorX = 0
		grupo.icone.anchorY = 0
		grupo.icone.y = Y + HEIGHT/8
		grupo.icone.x = X + HEIGHT/8
		grupo:insert(grupo.icone) 
		
		return grupo
	end
	
	local function botaoSalvar(X,Y,WIDTH,HEIGHT,tipo)
		local relatorio = require("relatorio")
		local function salvarPDFGerado()
			local periodoInicial = nil
			local periodoFinal = nil
			if Var.Relatorio.campoDia.text and Var.Relatorio.campoMes.text and Var.Relatorio.campoAno.text  then
				local Ano = tonumber(Var.Relatorio.campoAno.text)
				local Mes = tonumber(Var.Relatorio.campoMes.text)
				local Dia = tonumber(Var.Relatorio.campoDia.text)
				if Ano and Ano > 2019 and Mes and Mes > 0 and Dia and Dia > 0 then
					periodoInicial = Var.Relatorio.campoAno.text.."-"..Var.Relatorio.campoMes.text.."-"..Var.Relatorio.campoDia.text.." 00:00:00.0"
				end
			end
			if Var.Relatorio.campoDiaF.text and Var.Relatorio.campoMesF.text and Var.Relatorio.campoAnoF.text then
				local Ano = tonumber(Var.Relatorio.campoAnoF.text)
				local Mes = tonumber(Var.Relatorio.campoMesF.text)
				local Dia = tonumber(Var.Relatorio.campoDiaF.text)
				if Ano and Ano > 2019 and Mes and Mes > 0 and Dia and Dia > 0 then
					periodoFinal = Var.Relatorio.campoAnoF.text.."-"..Var.Relatorio.campoMesF.text.."-"..Var.Relatorio.campoDiaF.text.." 23:59:59.9"
				end
			end
			if tipo == "1" then
				relatorio.gerarRelatorio({
					livroID = varGlobal.idLivro1,
					usuarioID = varGlobal.idAluno1,
					periodoInicial = periodoInicial,
					periodoFinal = periodoFinal,
					formatar1 = "data",
					formatar2 = nil,
					onComplete = aposGerar,
					tipoBotao = "salvar"
				})
			elseif tipo == "2" then
				relatorio.gerarRelatorio({
					livroID = varGlobal.idLivro1,
					usuarioID = varGlobal.idAluno1,
					periodoInicial = periodoInicial,
					periodoFinal = periodoFinal,
					formatar1 = "data",
					formatar2 = "tipoInteracao",
					onComplete = aposGerar,
					tipoBotao = "salvar"
				})
			elseif tipo == "3" then
				relatorio.gerarRelatorio({
					livroID = varGlobal.idLivro1,
					usuarioID = varGlobal.idAluno1,
					periodoInicial = periodoInicial,
					periodoFinal = periodoFinal,
					formatar1 = "tipoInteracao",
					formatar2 = "data",
					onComplete = aposGerar,
					tipoBotao = "salvar"
				})
			end
		end
		local botao = widget.newButton {
			shape = "rect",
			label = "Salvar",
			width = WIDTH,
			height = HEIGHT,
			fillColor = { default={ 1, 1, 1, .9 }, over={ 0, 0, 0, .3 } },
			labelColor = { default={ 0, 0, 0 }, over={ 1, 1, 1, 1 } },
			strokeColor = { default={ 0, 0, 0 }, over={ 0, 0, 0 } },
			strokeWidth = 2,
			font = "Fontes/segoeui.ttf",
			fontSize = HEIGHT-HEIGHT/10,
			onRelease = salvarPDFGerado
		}
		botao.anchorX = 0
		botao.anchorY = 0
		botao.y = Y
		botao.x = X
		
		return botao
	end
	
	local function abrirMenu(e)
		if e.target.clicado == false  then
			audio.stop()
			media.stopSound()
			
			local som = audio.loadStream(varGlobal.ttsRelatorioMenuRapido1Clique)
			local timerRequerimento = timer.performWithDelay(16,function() audio.play(som) end,1)
			e.target.clicado = true
			timer.performWithDelay(1000,function() e.target.clicado = false end,1)
			return true
		end
		if e.target.clicado == true  then
			audio.stop()
			e.target.clicado = false
			historicoLib.Criar_e_salvar_vetor_historico({
				tipoInteracao = "relatorio",
				pagina_livro = pagina,
				acao = "abrir",
				tela = telas
			})
		
			local somAbrir = audio.loadSound("audioTTS_relatorio abrir.MP3")
			audio.play(somAbrir)
			Var.Relatorio.grupo = display.newGroup()
			
			Var.Relatorio.telaPreta = display.newRect(Var.Relatorio.grupo,W/2,H/2,W,H)
			Var.Relatorio.telaPreta.alpha = .3
			Var.Relatorio.telaPreta:setFillColor(0,0,0)
			Var.Relatorio.telaPreta:addEventListener("touch",function() return true end)
			Var.Relatorio.telaPreta:addEventListener("tap",function() Var.Relatorio.grupo:removeSelf();Var.Relatorio.grupo=nil; return true end)
			
			Var.Relatorio.fundoRelatorio = display.newImage(Var.Relatorio.grupo,"menuPagina3.png")
			Var.Relatorio.fundoRelatorio:setFillColor(1,1,1)
			Var.Relatorio.fundoRelatorio.x = 0
			Var.Relatorio.fundoRelatorio.y = 0
			Var.Relatorio.fundoRelatorio.anchorY=0
			Var.Relatorio.fundoRelatorio.anchorX=0
			Var.Relatorio.fundoRelatorio:addEventListener("touch",function() return true end)
			Var.Relatorio.fundoRelatorio:addEventListener("tap",function() return true end)
			Var.Relatorio.grupo:insert(Var.Relatorio.fundoRelatorio)
			Var.Relatorio.fecharMenu = widget.newButton {
				onRelease = function( event )
					local somFechar = audio.loadSound("audioTTS_relatorio fechar.MP3")
					audio.play(somFechar)
					historicoLib.Criar_e_salvar_vetor_historico({
						tipoInteracao = "relatorio",
						pagina_livro = pagina,
						acao = "fechar",
						tela = telas
					})
					-- timer para o toque não propagar
					timer.performWithDelay(10,function()
						if Var.Relatorio and Var.Relatorio.grupo then
							Var.Relatorio.grupo:removeSelf()
							Var.Relatorio.grupo = nil
						end
					end,1)
					return true
				end,
				emboss = false,
				-- Properties for a rounded rectangle button
				defaultFile = "closeMenuButton.png",
				overFile = "closeMenuButtonD.png"
			}
			Var.Relatorio.fecharMenu.clicado = false
			Var.Relatorio.fecharMenu.anchorX=1
			Var.Relatorio.fecharMenu.anchorY=0
			Var.Relatorio.fecharMenu.x = W - 80 + Var.Relatorio.fecharMenu.width/2 - 2
			Var.Relatorio.fecharMenu.y = 135
			Var.Relatorio.grupo:insert(Var.Relatorio.fecharMenu)
			
			Var.Relatorio.Titulo = display.newText(Var.Relatorio.grupo,"Relatório",0,0,"Fontes/seguibl.ttf",60)
			Var.Relatorio.Titulo.anchorY=0
			Var.Relatorio.Titulo.y = 135
			Var.Relatorio.Titulo.x = W/2
			Var.Relatorio.Titulo:setFillColor(0,0,0)
			
			---------------------------------------------------------
			-- PERÍODO --
			---------------------------------------------------------
			
			Var.Relatorio.PeriodoTitulo1 = display.newText(Var.Relatorio.grupo,"Data Inicial",0,0,"Fontes/paolaAccent.ttf",45)
			Var.Relatorio.PeriodoTitulo1.anchorX=0
			Var.Relatorio.PeriodoTitulo1.anchorY=0
			Var.Relatorio.PeriodoTitulo1.y = 270
			Var.Relatorio.PeriodoTitulo1.x = 110
			Var.Relatorio.PeriodoTitulo1:setFillColor(0,0,0)
			
			Var.Relatorio.PeriodoTitulo2 = display.newText(Var.Relatorio.grupo,"Data Final",0,0,"Fontes/paolaAccent.ttf",45)
			Var.Relatorio.PeriodoTitulo2.anchorX=0
			Var.Relatorio.PeriodoTitulo2.anchorY=0
			Var.Relatorio.PeriodoTitulo2.y = 270
			Var.Relatorio.PeriodoTitulo2.x = 385
			Var.Relatorio.PeriodoTitulo2:setFillColor(0,0,0)
 
		-- Set up the picker wheel columns
		
		 
		-- Create the widget
		local widgetData = require("seletorDeDatas")
		--[[
		local left = atrib.left or 100 
		local top = atrib.top or 320
		local fontSize = atrib.fontSize or 28
		local width = atrib.width or 400
		local height = atrib.height or 400
		local align = atrib.align or "center"
		local rowHeight = atrib.rowHeight or 30
		local borderSize = atrib.borderSize or 4
		local borderRGBColor = atrib.borderRGBAColor or {0,0,0,1}
		local background = atrib.background or "pickerwheel.png"
		local backgroundWidth = atrib.backgroundWidth or width
		local backgroundHeight = atrib.backgroundHeight or height]]
		
		
		Var.Relatorio.pickerWheel1 = widgetData.newPicker(
		{
			fontSize = 33,
			width = 240,
			height = 200,
			align = "center",
			rowHeight = 34
		})		
		Var.Relatorio.pickerWheel1.x = 110
		Var.Relatorio.pickerWheel1.y = 324
		
		
		Var.Relatorio.pickerWheel2 = widgetData.newPicker(
		{
			fontSize = 33,
			width = 240,
			height = 200,
			align = "center",
			rowHeight = 34
		}) 
		Var.Relatorio.pickerWheel2.x = W-105-Var.Relatorio.pickerWheel1.width
		Var.Relatorio.pickerWheel2.y = 324
		
		
		Var.Relatorio.fundoPickerWheels = display.newRoundedRect(Var.Relatorio.grupo,W/2,318,550,Var.Relatorio.pickerWheel2.height+2,20)
		Var.Relatorio.fundoPickerWheels.anchorX=0.5;Var.Relatorio.fundoPickerWheels.anchorY=0
		Var.Relatorio.fundoPickerWheels:setFillColor(0,180/255,201/255)
		Var.Relatorio.grupo:insert(Var.Relatorio.pickerWheel1)
		Var.Relatorio.grupo:insert(Var.Relatorio.pickerWheel2)
		 
		-- Get the table of current values for all columns
		-- This can be performed on a button tap, timer execution, or other event
		--local values = Var.Relatorio.pickerWheel1:getValues()



			Var.Relatorio.campoDiaFundo = display.newImageRect(Var.Relatorio.grupo,"fundo data.png",53,50)
		Var.Relatorio.campoDiaFundo.isVisible=false
			Var.Relatorio.campoMesFundo = display.newImageRect(Var.Relatorio.grupo,"fundo data.png",53,50)
		Var.Relatorio.campoMesFundo.isVisible=false
			Var.Relatorio.campoAnoFundo = display.newImageRect(Var.Relatorio.grupo,"fundo data.png",100,50)
		Var.Relatorio.campoAnoFundo.isVisible=false
			Var.Relatorio.campoDiaFundo.anchorX=0;Var.Relatorio.campoMesFundo.anchorX=0;Var.Relatorio.campoAnoFundo.anchorX=0
			Var.Relatorio.campoDiaFundo.anchorY=0;Var.Relatorio.campoMesFundo.anchorY=0;Var.Relatorio.campoAnoFundo.anchorY=0
	 
			
			
			local function verificarData1()
				if Var.Relatorio.campoAno then
					--RR.campoData1.text.."/"..RR.campoData2.text.."/" ..RR.campoData3.text
					
					anoBissexto = false
					local anoCampo = tonumber(Var.Relatorio.campoAno.text)
					local anoAtual = tonumber(data.year)
					local mesCampo = tonumber(Var.Relatorio.campoMes.text)
					local mesAtual = tonumber(data.month)
					local diaCampo = tonumber(Var.Relatorio.campoDia.text)
					local diaAtual = tonumber(data.day)
					local div400 = 1
					local div100 = 0
					local div4 = 1
					if anoCampo then
						div400 = anoCampo%400
						div100 = anoCampo%100
						div4 = anoCampo%4
					end
					if anoCampo ~= nil and div4 == 0 then
						if div100 == 0 and div400 == 0 then
							anoBissexto = true
						elseif div100 ~= 0 then
							anoBissexto = true
						end
					end
					if anoBissexto == true then
						vetorMeses[2] = 29
					else
						vetorMeses[2] = 28
					end
					if mesCampo then
						if mesCampo > 12 then
							mesCampo = 12
						end
					end
					if mesCampo~= nil and mesCampo > 0 and diaCampo~= nil and diaCampo > vetorMeses[mesCampo] then
						Var.Relatorio.campoDia.text = tostring(vetorMeses[mesCampo])
						if string.len(Var.Relatorio.campoDia.text) == 1 then Var.Relatorio.campoDia.text = "0"..Var.Relatorio.campoDia.text end
					end
					if anoCampo == anoAtual then
						if mesCampo ~= nil then
							if mesCampo >= mesAtual then
								if mesCampo > mesAtual then
									Var.Relatorio.campoMes.text = tostring(mesAtual)
									if string.len(Var.Relatorio.campoMes.text) == 1 then Var.Relatorio.campoMes.text = "0"..Var.Relatorio.campoMes.text end
								end
								if diaCampo ~= nil and diaCampo > diaAtual then
									Var.Relatorio.campoDia.text = tostring(diaAtual)
									if string.len(Var.Relatorio.campoDia.text) == 1 then Var.Relatorio.campoDia.text = "0"..Var.Relatorio.campoDia.text end
								end
							end
						end
					end
					Var.Relatorio.dataLimite[1] = {diaCampo,mesCampo,anoCampo}
				elseif Var.Relatorio.campoDataTimer1 then
					timer.cancel(Var.Relatorio.campoDataTimer1)
					Var.Relatorio.campoDataTimer1 = nil
				end
			end
			local function verificarData2()
				if Var.Relatorio.campoAnoF then
					--RR.campoData1.text.."/"..RR.campoData2.text.."/" ..RR.campoData3.text
					
					anoBissexto = false
					local anoCampo = tonumber(Var.Relatorio.campoAnoF.text)
					local anoAtual = tonumber(data.year)
					local mesCampo = tonumber(Var.Relatorio.campoMesF.text)
					local mesAtual = tonumber(data.month)
					local diaCampo = tonumber(Var.Relatorio.campoDiaF.text)
					local diaAtual = tonumber(data.day)
					local div400 = 1
					local div100 = 0
					local div4 = 1
					if anoCampo then
						div400 = anoCampo%400
						div100 = anoCampo%100
						div4 = anoCampo%4
					end
					if anoCampo ~= nil and div4 == 0 then
						if div100 == 0 and div400 == 0 then
							anoBissexto = true
						elseif div100 ~= 0 then
							anoBissexto = true
						end
					end
					if anoBissexto == true then
						vetorMeses[2] = 29
					else
						vetorMeses[2] = 28
					end
					if mesCampo then
						if mesCampo > 12 then
							mesCampo = 12
						end
					end
					if mesCampo~= nil and mesCampo > 0 and diaCampo~= nil and diaCampo > vetorMeses[mesCampo] then
						Var.Relatorio.campoDiaF.text = tostring(vetorMeses[mesCampo])
						if string.len(Var.Relatorio.campoDiaF.text) == 1 then Var.Relatorio.campoDiaF.text = "0"..Var.Relatorio.campoDiaF.text end
					end
					if anoCampo == anoAtual then
						if mesCampo ~= nil then
							if mesCampo >= mesAtual then
								if mesCampo > mesAtual then
									Var.Relatorio.campoMesF.text = tostring(mesAtual)
									if string.len(Var.Relatorio.campoMesF.text) == 1 then Var.Relatorio.campoMesF.text = "0"..Var.Relatorio.campoMesF.text end
								end
								if diaCampo ~= nil and diaCampo > diaAtual then
									Var.Relatorio.campoDiaF.text = tostring(diaAtual)
									if string.len(Var.Relatorio.campoDiaF.text) == 1 then Var.Relatorio.campoDiaF.text = "0"..Var.Relatorio.campoDiaF.text end
								end
							end
						end
					end
				elseif Var.Relatorio.campoDataTimer2 then
					timer.cancel(Var.Relatorio.campoDataTimer2)
					Var.Relatorio.campoDataTimer2 = nil
				end
			end
			local function verificarData3()
				if Var.Relatorio.campoAnoF then
					--RR.campoData1.text.."/"..RR.campoData2.text.."/" ..RR.campoData3.text
					
					anoBissexto = false
					local anoCampo = tonumber(Var.Relatorio.campoAnoF.text)
					local anoInicial = tonumber(Var.Relatorio.campoAno.text)
					local mesCampo = tonumber(Var.Relatorio.campoMesF.text)
					local mesInicial = tonumber(Var.Relatorio.campoMes.text)
					local diaCampo = tonumber(Var.Relatorio.campoDiaF.text)
					local diaInicial = tonumber(Var.Relatorio.campoDia.text)
					if anoCampo and string.len(anoCampo) >= 4 then
						if anoCampo and anoInicial and anoCampo < anoInicial then
							anoCampo = anoAtual
							Var.Relatorio.campoAnoF.text = anoInicial
						end
					
						if anoCampo and anoInicial and anoCampo == anoInicial then
							if mesCampo and anoInicial and mesCampo < mesInicial then
								mesCampo = mesInicial
								Var.Relatorio.campoMesF.text = mesInicial
							end
							if mesCampo and mesInicial and mesCampo == mesInicial then
								if diaCampo and diaInicial and diaCampo < diaInicial then
									Var.Relatorio.campoDiaF.text = tostring(diaInicial)
								end
							end
						end
					end
				elseif Var.Relatorio.campoDataTimer3 then
					timer.cancel(Var.Relatorio.campoDataTimer3)
					Var.Relatorio.campoDataTimer3 = nil
				end
			end
			

			
			---------------------------------------------------------
			-- FORMATAÇÃO --
			---------------------------------------------------------


			Var.Relatorio.FormatarTitulo = display.newText(Var.Relatorio.grupo," Formatação:",0,0,"Fontes/paolaAccent.ttf",50)
			Var.Relatorio.FormatarTitulo.anchorX=0
			Var.Relatorio.FormatarTitulo.anchorY=0
			Var.Relatorio.FormatarTitulo.y = 570
			Var.Relatorio.FormatarTitulo.x = 80
			Var.Relatorio.FormatarTitulo:setFillColor(0,0,0)
			
			Var.Relatorio.FormatarTitulo2 = display.newText(Var.Relatorio.grupo,"__________________________",0,0,"Fontes/segoeuib.ttf",50)
			Var.Relatorio.FormatarTitulo2.anchorY=0
			Var.Relatorio.FormatarTitulo2.alpha=0
			Var.Relatorio.FormatarTitulo2.y,Var.Relatorio.FormatarTitulo2.x = Var.Relatorio.FormatarTitulo.y+10,W/2
			Var.Relatorio.FormatarTitulo2:setFillColor(0,0,0)
			
			Var.Relatorio.FormatarTexto1 = display.newText(Var.Relatorio.grupo,"1 - por datas:",0,0,"Fontes/paolaAccent.ttf",40)
			Var.Relatorio.FormatarTexto1.anchorX=0
			Var.Relatorio.FormatarTexto1.anchorY=0
			Var.Relatorio.FormatarTexto1.y = Var.Relatorio.FormatarTitulo2.y+Var.Relatorio.FormatarTitulo2.height + 15
			Var.Relatorio.FormatarTexto1.x = 90
			Var.Relatorio.FormatarTexto1:setFillColor(0,0,0)
			
			Var.Relatorio.FormatarTexto2 = display.newText(Var.Relatorio.grupo,"2 - por data e tipos:",0,0,"Fontes/paolaAccent.ttf",40)
			Var.Relatorio.FormatarTexto2.anchorX=0
			Var.Relatorio.FormatarTexto2.anchorY=0
			Var.Relatorio.FormatarTexto2.y = Var.Relatorio.FormatarTexto1.y+Var.Relatorio.FormatarTexto1.height + 70
			Var.Relatorio.FormatarTexto2.x = 90
			Var.Relatorio.FormatarTexto2:setFillColor(0,0,0)
			
			Var.Relatorio.FormatarTexto3 = display.newText(Var.Relatorio.grupo,"3 - por tipo e datas:",0,0,"Fontes/paolaAccent.ttf",40)
			Var.Relatorio.FormatarTexto3.anchorX=0
			Var.Relatorio.FormatarTexto3.anchorY=0
			Var.Relatorio.FormatarTexto3.y = Var.Relatorio.FormatarTexto2.y+Var.Relatorio.FormatarTexto2.height + 70
			Var.Relatorio.FormatarTexto3.x = 90
			Var.Relatorio.FormatarTexto3:setFillColor(0,0,0)
			
			Var.Relatorio.FormatarTexto4 = display.newText(Var.Relatorio.grupo,"4 - outro tipo:",0,0,"Fontes/paolaAccent.ttf",40)
			Var.Relatorio.FormatarTexto4.anchorX=0
			Var.Relatorio.FormatarTexto4.anchorY=0
			Var.Relatorio.FormatarTexto4.y = Var.Relatorio.FormatarTexto3.y+Var.Relatorio.FormatarTexto3.height + 70
			Var.Relatorio.FormatarTexto4.x = 90
			Var.Relatorio.FormatarTexto4:setFillColor(0,0,0)
			
			Var.Relatorio.FormatarBotaoVer1 = botaoVizualizar(90,Var.Relatorio.FormatarTexto1.y + 50,250,49,"1")
			Var.Relatorio.FormatarBotaoVer2 = botaoVizualizar(90,Var.Relatorio.FormatarTexto2.y + 50,250,49,"2")
			Var.Relatorio.FormatarBotaoVer3 = botaoVizualizar(90,Var.Relatorio.FormatarTexto3.y + 50,250,49,"3")
			Var.Relatorio.grupo:insert(Var.Relatorio.FormatarBotaoVer1)
			Var.Relatorio.grupo:insert(Var.Relatorio.FormatarBotaoVer2)
			Var.Relatorio.grupo:insert(Var.Relatorio.FormatarBotaoVer3)
		
			Var.Relatorio.FormatarBotaoSalvar1 = botaoSalvar(80 + 250 + 20,Var.Relatorio.FormatarTexto1.y + 50,160,49,"1")
			Var.Relatorio.FormatarBotaoSalvar2 = botaoSalvar(80 + 250 + 20,Var.Relatorio.FormatarTexto2.y + 50,160,49,"2")
			Var.Relatorio.FormatarBotaoSalvar3 = botaoSalvar(80 + 250 + 20,Var.Relatorio.FormatarTexto3.y + 50,160,49,"3")
			Var.Relatorio.grupo:insert(Var.Relatorio.FormatarBotaoSalvar1)
			Var.Relatorio.grupo:insert(Var.Relatorio.FormatarBotaoSalvar2)
			Var.Relatorio.grupo:insert(Var.Relatorio.FormatarBotaoSalvar3)
			
			Var.Relatorio.abrirSolicitacao = function()
				historicoLib.Criar_e_salvar_vetor_historico({
					tipoInteracao = "relatorio",
					pagina_livro = pagina,
					acao = "abrir solicitacao",
					tela = telas
				})
			
				local grupoS = display.newGroup()
				
				grupoS.protetorTela = auxFuncs.TelaProtetiva()
				grupoS.protetorTela:setFillColor(0,0,0)
				grupoS.protetorTela.alpha=.5
				grupoS:insert(grupoS.protetorTela)
				
				grupoS.fundo = display.newRect(W/2,H/2,W-60,500)
				grupoS.fundo.strokeWidth = 4
				grupoS.fundo:setStrokeColor(.5,.5,.5)
				grupoS.fundo:setStrokeVertexColor( 1, 1, 0, 0 )
				grupoS:insert(grupoS.fundo)
				
				
				
				grupoS.fecharMenu = widget.newButton {
					onRelease = function( event )
						historicoLib.Criar_e_salvar_vetor_historico({
							tipoInteracao = "relatorio",
							pagina_livro = pagina,
							acao = "fechar solicitacao",
							tela = telas
						})
						-- timer para o toque não propagar
						timer.performWithDelay(10,function()
							if grupoS then
								grupoS:removeSelf()
								grupoS = nil
							end
						end,1)
						return true
					end,
					emboss = false,
					-- Properties for a rounded rectangle button
					defaultFile = "closeMenuButton2.png",
					overFile = "closeMenuButton2D.png"
				}
				grupoS.fecharMenu.clicado = false
				grupoS.fecharMenu.x = grupoS.fundo.x - grupoS.fecharMenu.width/2 + grupoS.fundo.width/2-2
				grupoS.fecharMenu.y =  grupoS.fundo.y + grupoS.fecharMenu.height/2 - grupoS.fundo.height/2+2
				
				
				grupoS.rectTop = display.newRect(0,0,grupoS.fundo.width-8,grupoS.fecharMenu.height-2)
				grupoS.rectTop.x = W/2
				grupoS.rectTop.y = grupoS.fecharMenu.y-1
				grupoS.rectTop:setFillColor(46/255,171/255,200/255)
				grupoS.rectTop.strokeWidth=1
				grupoS.rectTop:setStrokeColor(0,0,0)
				grupoS:insert(grupoS.rectTop)
				grupoS.fecharMenu.height = grupoS.fecharMenu.height-2
				grupoS.fecharMenu.y = grupoS.fecharMenu.y - 1
				grupoS:insert(grupoS.fecharMenu)
				
				grupoS.titulo = display.newText("Solicitação",0,0,0,0,"Fontes/ariblk.ttf",60)
				grupoS.titulo:setFillColor(0,0,0)
				grupoS.titulo.x = grupoS.rectTop.x - grupoS.rectTop.width/2 + grupoS.titulo.width/2 + 10
				grupoS.titulo.y = grupoS.fecharMenu.y-1
				grupoS:insert(grupoS.titulo)
				
				grupoS.campoTexto = native.newTextBox(0,0,grupoS.fundo.width - 30,grupoS.fundo.height - grupoS.rectTop.height - 90)
				grupoS.campoTexto.x = W/2; grupoS.campoTexto.y = grupoS.rectTop.y + grupoS.rectTop.height/2 + grupoS.campoTexto.height/2 + 10
				grupoS.campoTexto.size = 35
				grupoS.campoTexto.placeholder = "Entre com sua solicitação aqui."
				grupoS:insert(grupoS.campoTexto)
				
				grupoS.enviarSolicitacao = function()
					if grupoS then
						grupoS:removeSelf()
						grupoS = nil
					end
					native.showAlert("Solicitação enviada!","Sua solicitação foi enviada com sucesso!\nEm breve enviaremos uma resposta no e-mail cadastrado em nosso sistema.",{"OK"})
				end
				
				grupoS.botaoEnviar  = auxFuncs.createNewButton({
					fillColor = {default = {46/255,171/255,200/255,1},over = {0,0,0,0.5}},
					labelColor = {default = {0,0,0,1},over = {1,1,1,1}},
					strokeWidth = 2,
					strokeColor = {default = {0,0,0,0.5},over = {0,0,0,0.5}},
					shape = "roundedRect",
					radius = 10,
					label = "Enviar",
					font = "Fontes/paolaAccent.ttf",
					height = 60,
					width = 180,
					size = 40,
					onRelease = grupoS.enviarSolicitacao
				})
				grupoS.botaoEnviar.x = W/2 + grupoS.botaoEnviar.width/2 + 100
				grupoS.botaoEnviar.y = grupoS.campoTexto.y + grupoS.campoTexto.height/2 + grupoS.botaoEnviar.height/2 + 5
				grupoS:insert(grupoS.botaoEnviar)
				
			end
			
			Var.Relatorio.botaoSolicitar  = auxFuncs.createNewButton({
				fillColor = {default = {0,0,0,1},over = {0,0,0,0.5}},
				labelColor = {default = {1,1,1,1},over = {1,1,1,1}},
				shape = "rect",
				label = "solicitar",
				font = "Fontes/paolaAccent.ttf",
				height = Var.Relatorio.FormatarTexto4.height,
				width = 250,
				size = 40,
				onRelease = Var.Relatorio.abrirSolicitacao
			})
			Var.Relatorio.botaoSolicitar.x = 90 + 125 + 10
			Var.Relatorio.botaoSolicitar.y = Var.Relatorio.FormatarTexto4.y+Var.Relatorio.FormatarTexto4.height + 30
			Var.Relatorio.grupo:insert(Var.Relatorio.botaoSolicitar)
		end
	end
	
	grupoRelatorio.botao = widget.newButton {
		defaultFile = "iconeRelatorio.png",
		overFile = "iconeRelatorioD.png",
		width = 80,
		height = 80,
		onRelease = abrirMenu
	}
	grupoRelatorio.botao.clicado = false
	grupoRelatorio.botao.anchorX = 0
	grupoRelatorio.botao.anchorY = 0
	grupoRelatorio.botao.y = 0
	grupoRelatorio.botao.x = 0
	grupoRelatorio:insert(grupoRelatorio.botao)
	
	grupoRelatorio.botaoLRight = display.newImageRect(grupoRelatorio,"iconeRelatorioR.png",80,80)
	grupoRelatorio.botaoLRight.anchorY=0;grupoRelatorio.botaoLRight.anchorX=0
	grupoRelatorio.botaoLRight.y = 0--GRUPOGERAL.height+100--Var.proximoY+ 40
	grupoRelatorio.botaoLRight.x = 0
	grupoRelatorio.botaoLRight.isVisible = false
	
	grupoRelatorio.botaoLLeft = display.newImageRect(grupoRelatorio,"iconeRelatorioL.png",80,80)
	grupoRelatorio.botaoLLeft.anchorY=0;grupoRelatorio.botaoLLeft.anchorX=0
	grupoRelatorio.botaoLLeft.y = 0--GRUPOGERAL.height+100--Var.proximoY+ 40
	grupoRelatorio.botaoLLeft.x = 0
	grupoRelatorio.botaoLLeft.isVisible = false
	if grupoRelatorio.timerOrientacao then
		timer.cancel(grupoRelatorio.timerOrientacao)
		grupoRelatorio.timerOrientacao = nil
	end
	grupoRelatorio.timerOrientacao = timer.performWithDelay(300,
		function(e) 
			if not grupoRelatorio.botao then  
				timer.cancel(grupoRelatorio.timerOrientacao)
				grupoRelatorio.timerOrientacao = nil
			elseif grupoRelatorio.botao then
				if system.orientation == "landscapeRight" then
					grupoRelatorio.botao.isVisible = false
					grupoRelatorio.botaoLLeft.isVisible = false
					grupoRelatorio.botaoLRight.isVisible = true
				elseif system.orientation == "landscapeLeft" then
					grupoRelatorio.botao.isVisible = false
					grupoRelatorio.botaoLLeft.isVisible = true
					grupoRelatorio.botaoLRight.isVisible = false
				else
					grupoRelatorio.botao.isVisible = true
					grupoRelatorio.botaoLLeft.isVisible = false
					grupoRelatorio.botaoLRight.isVisible = false
				end
				grupoRelatorio.botao.isHitTestable = true
			end 
		end,-1)
	
	return grupoRelatorio
end
----------------------------------------------------------
--  COLOCAR DESCRIÇÃO EM TEXTO
----------------------------------------------------------
function M.criarDescricao(atributos,jaClicou,contador)
	print("CRIAR TEXTO 1")
	local url = nil
	if atributos.url then
		url = atributos.url
	end
	local colocarFormatacaoTexto = require "colocarFormatacaoTexto"
	if atributos.conteudo and atributos.conteudo ~= "" then
		print("CRIAR TEXTO 2")
		local ox, oy = math.abs(display.screenOriginX), math.abs(display.screenOriginY)
		local grupoRemover = display.newGroup()
		local grupoTexto = display.newGroup()
		grupoRemover:insert(grupoTexto)
		local fundoPreto = display.newRect(W/2,H/2,H,H)
		grupoRemover:insert(fundoPreto)

		fundoPreto:addEventListener("touch",function() return true end)
		fundoPreto:setFillColor(0,0,0)
		fundoPreto.alpha = 0.3
		--grupoTexto:insert(fundoPreto)

		--local fundoBranco = display.newRect(W/2,H/2,600,1100)
		--fundoBranco:setFillColor(1,1,1)
		--grupoTexto:insert(fundoBranco)
		--fundoBranco:addEventListener("touch",function() return true end)
		--fundoBranco:addEventListener("tap",function() return true end)
		local alinhamento = "justificado"
		if atributos.alinhamento then
			alinhamento = atributos.alinhamento
		end

		local tamanho =30
		local larguraTexto = 720
		local margem = 80
		local orientacao = system.orientation
		if system.orientation == "landscapeRight" or system.orientation == "landscapeLeft" then
			tamanho = 45
			larguraTexto = 1180
			margem = 100
		end
		local textoAColocar = string.gsub(atributos.conteudo,"\\n","\n")

		local function mudarTamanhoFonte(atrib)
			if atrib.acao == "aumentar" then
				print("aumentar")
				atributos.modificar = atributos.modificar + 5
				grupoRemover.removerTudo()
				local subPagina = atributos.tela.subPagina
				historicoLib.Criar_e_salvar_vetor_historico({
					tipoInteracao = "texto",
					pagina_livro = atributos.tela.pagina,
					objeto_id = contador,
					acao = "aumentar",
					subtipo = atributos.subtipo,
					subPagina = subPagina,
					tela = atributos.tela
				})
				funcGlobal.criarDescricao(atributos,false,contador)
			elseif atrib.acao == "diminuir" then
				print("diminuir")
				atributos.modificar = atributos.modificar - 5
				grupoRemover.removerTudo()
				local subPagina = atributos.tela.subPagina
				historicoLib.Criar_e_salvar_vetor_historico({
					tipoInteracao = "texto",
					pagina_livro = atributos.tela.pagina,
					objeto_id = contador,
					acao = "diminuir",
					subtipo = atributos.subtipo,
					subPagina = subPagina,
					tela = atributos.tela
				})
				funcGlobal.criarDescricao(atributos,false,contador)
			end
			return true
		end
		local subtipo = nil
		if atributos.subtipo then
			subtipo = atributos.subtipo
		end
		local texto = colocarFormatacaoTexto.criarTextodePalavras(
			{	
				tela = atributos.tela,texto = textoAColocar,
				x = 0,Y = 0,
				fonte = "Fontes/segoeui.ttf",
				tamanho = tamanho + atributos.modificar,
				cor = {0,0,0},largura = larguraTexto,
				url = url, 
				alinhamento = alinhamento,
				margem = margem,
				xNegativo = 0, 
				modificou = 0, 
				embeded = nil, 
				endereco = atributos.enderecoArquivos,
				contTexto = contador,
				whenOpenedURL = nil,
				whenClosedURL = nil,
				mudarTamanhoFonte = mudarTamanhoFonte,
				EhIndice = false,
				dic = atributos.dicPalavras,
				subtipo = tipo,
				temHistorico = atributos.tela.temHistorico
			}
		)
		grupoTexto:insert(texto)

		texto.y = 0--fundoBranco.y - fundoBranco.height/2 + 50--+ texto.height/2
		texto.x = -60
		if system.orientation == "landscapeRight" then
			texto.rotation = 90
			texto.x = 600
			texto.y = -80
		elseif system.orientation == "landscapeLeft" then
			texto.rotation = -90
			texto.x = 0
			texto.y = H-80
		end
		grupoTexto:insert(texto)

		local horizontalLock = true
		local verticalLock = false
		if orientacao ~= "portrait" and orientacao ~= "portraitUpsideDown" then
			horizontalLock = false
			verticalLock = true
		end
		local backScrollView = display.newRect(55,62,W-60-50,H-32-120)
		backScrollView.anchorX = 0
		backScrollView.anchorY = 0
		backScrollView.strokeWidth = 4
		backScrollView:setStrokeColor(.3,.3,.3)
		grupoRemover:insert(backScrollView)
		local scrollView
		local function scrollListener( event )

			local phase = event.phase
			if ( phase == "began" ) then print( "Scroll view was touched" )
			elseif ( phase == "moved" ) then print( "Scroll view was moved" )
			elseif ( phase == "ended" ) then print( "Scroll view was released" )
			end

			-- In the event a scroll limit is reached...
			if ( event.limitReached ) then
				if ( event.direction == "up" ) then print( "Reached bottom limit" )
				elseif ( event.direction == "down" ) then print( "Reached top limit" )
				elseif ( event.direction == "left" ) then print( "Reached right limit" )
				elseif ( event.direction == "right" ) then print( "Reached left limit" )
				end
			end
			if orientacao == "landscapeRight" then
				local X,Y = scrollView:getContentPosition()
				if X < -texto.height - 50 then
					scrollView:scrollToPosition
					{
						x = -texto.height,
						time = 300
					}
				elseif X > -texto.height/2 + 50 then
					scrollView:scrollToPosition
					{
						x = -texto.height/2,
						time = 300
					}
				end
			end

			return true
		end


		scrollView = widget.newScrollView {
			left = 55,
			top = 62,
			width = W-60-50,
			height = H-32-120,
			hideBackground = true,
			backgroundColor = { 240/255 },
			--isBounceEnabled = false,
			horizontalScrollDisabled = horizontalLock,
			verticalScrollDisabled = verticalLock,
			listener = scrollListener
		}
		scrollView:insert( texto )
		grupoRemover:insert(scrollView)
		--scrollView.hideBackground = true



		local function removerTudo(e)
			--[[if scrollView then
				if scrollView.timer then
					timer.cancel(scrollView.timer)
					scrollView.timer = nil
				end
				scrollView:removeSelf();
			end
			if backScrollView then
				backScrollView:removeSelf();
			end
			if texto and texto.botaoAumentar then
				texto.botaoAumentar:removeSelf()
				texto.botaoAumentar = nil
			end
			]]
			if scrollView.timer then
				timer.cancel(scrollView.timer)
				scrollView.timer = nil
			end
			auxFuncs.restoreNativeScreenElements()
			if grupoRemover then
				grupoRemover:removeSelf()
				grupoRemover = nil
			end
			timer.performWithDelay(1,function()

				local subPagina = atributos.tela.subPagina
				historicoLib.Criar_e_salvar_vetor_historico({
					tipoInteracao = atributos.tipoInteracao,
					pagina_livro = atributos.tela.pagina,
					objeto_id = contador,
					acao = "fechar detalhes",
					tempo_aberto = grupoTexto.tempoAbertoDetalhesNumero,
					subPagina = subPagina,
					tela = atributos.tela
				})

				if grupoTexto.tempoAbertoDetalhes then
					timer.cancel(grupoTexto.tempoAbertoDetalhes)
				end
				grupoTexto.tempoAbertoDetalhesNumero = 0
				auxFuncs.restoreNativeScreenElements()
			end,1)
			return true;
		end

		local backButtonTelaAluno = widget.newButton {
			shape = "roundedRect",
			fillColor = { default={ 0.18, 0.67, 0.785, 1 }, over={ 0.004, 0.368, 0.467, 1 } },
			width = 250,
			height = 70,
			label = "voltar",
			fontSize = 50,
			strokeWidth = 5,
			labelColor = { default={ 0, 0, 0, 1 }, over={ 1, 1, 1, 1 } },
			--onRelease = removerTudo
		}
		backButtonTelaAluno:addEventListener("touch",function() return true end)
		backButtonTelaAluno:addEventListener("tap",removerTudo)
		grupoRemover:insert(backButtonTelaAluno)
		backButtonTelaAluno.anchorX=.5
		backButtonTelaAluno.x = W/2 - 60
		backButtonTelaAluno.y = texto.y + texto.height + 50
		if system.orientation == "landscapeRight" then
			scrollView:scrollToPosition
			{
				x = -texto.height,
				time = 100
			}
			texto.x = 600 + texto.height
			backButtonTelaAluno.rotation = 90
			backButtonTelaAluno.x = texto.x - texto.height - backButtonTelaAluno.height
			backButtonTelaAluno.y = H/2 - backButtonTelaAluno.height
		elseif system.orientation == "landscapeLeft" then
			backButtonTelaAluno.rotation = -90
			backButtonTelaAluno.x = texto.x + texto.height + backButtonTelaAluno.height
			backButtonTelaAluno.y = H/2 - backButtonTelaAluno.height
		end
		local timerOrientacao

		if scrollView.timer then
			timer.cancel(scrollView.timer)
			scrollView.timer = nil
		end
		local function mudarOrientacaoTexto(e)
			if orientacao ~= system.orientation then
				removerTudo();
				funcGlobal.criarDescricao(atributos,true,contador)

				if scrollView.timer then
					timer.cancel(scrollView.timer)
					scrollView.timer = nil
				end

			end
		end
		scrollView.timer = timer.performWithDelay(1000,mudarOrientacaoTexto,-1)


		local widget = require( "widget" )

		-- ScrollView listener

		scrollView:insert( backButtonTelaAluno )

		scrollView:addEventListener("touch",function() return true end)
		scrollView:addEventListener("tap",function() return true end)
		fundoPreto:addEventListener("tap",removerTudo)


		local function InterfaceAumentarLetra(evento)
			if texto.botaoAumentar then
				texto.botaoAumentar:removeSelf()
				texto.botaoAumentar = nil
			else
				local function mudarFonte(e)
					local condicao1 = e.x
					local condicao2 = (e.target.x)
					if condicao1 >= condicao2 then
						print("aumentar")
						atributos.modificar = atributos.modificar + 5
						removerTudo()
						funcGlobal.criarDescricao(atributos,false,contador)
					elseif condicao1 < condicao2 then
						print("diminuir")
						atributos.modificar = atributos.modificar - 5
						removerTudo()
						funcGlobal.criarDescricao(atributos,false,contador)
					end
					if texto.botaoAumentar then
						texto.botaoAumentar:removeSelf()
						texto.botaoAumentar = nil
					end
					return true
				end
				texto.botaoAumentar = botaoDeAumentarfunc(evento)
				texto.botaoAumentar.x = W/2
				texto.botaoAumentar:addEventListener("tap",mudarFonte)
				texto.botaoAumentar:addEventListener("touch",function()return true end)
			end
		end

		--texto:addEventListener("tap",InterfaceAumentarLetra)
		if jaClicou == true then

			local subPagina = atributos.tela.subPagina
			historicoLib.Criar_e_salvar_vetor_historico({
				tipoInteracao = atributos.tipoInteracao,
				pagina_livro = atributos.tela.pagina,
				objeto_id = contador,
				acao = "abrir detalhes",
				subPagina = subPagina,
				tela = atributos.tela
			})

			if grupoTexto.tempoAbertoDetalhes then
				timer.cancel(grupoTexto.tempoAbertoDetalhes)
			end
			grupoTexto.tempoAbertoDetalhesNumero = 0
			grupoTexto.tempoAbertoDetalhes = timer.performWithDelay(100,function() grupoTexto.tempoAbertoDetalhesNumero = grupoTexto.tempoAbertoDetalhesNumero + 100 end,-1)

		end
		timer.performWithDelay(100,function()auxFuncs.clearNativeScreenElements()end,1)
	end
end
----------------------------------------------------------
--  COLOCAR CONFIGS VOZ (TTS)
----------------------------------------------------------
function M.colocarBotaoConfig(atributos,telas)
	local grupoBotao = display.newGroup()
	local botaoConfigRect = display.newImageRect(grupoBotao,varGlobal.menuConfigBotaoImagem,196,70)
	botaoConfigRect.anchorX = .5;botaoConfigRect.anchorY = 0
	botaoConfigRect.x = W/2;botaoConfigRect.y = atributos.y
	botaoConfigRect.clicado = false
	local cancelar = false
	local timerRequerimento
	local requerimentoDownload
	local function abrirMenuConfig(e)

		local function networkListener000(event)

			if ( event.isError ) then
				print( "Network error: ", event.response )
			elseif ( event.phase == "began" ) then
				if ( event.bytesEstimated <= 0 ) then
					print( "Download starting, size unknown" )
				else
					print( "Download starting, estimated size: " .. event.bytesEstimated )
				end

			elseif ( event.phase == "progress" ) then
				if ( event.bytesEstimated <= 0 ) then
					print( "Download progress: " .. event.bytesTransferred )
				else
					print( "Download progress: " .. event.bytesTransferred .. " of estimated: " .. event.bytesEstimated )
				end

			elseif ( event.phase == "ended" ) then
				print( "Download complete, total bytes transferred: " .. event.bytesTransferred )

				audio.stop()
				if cancelar == false then

					local som = audio.loadStream("audioConfig.MP3",system.DocumentsDirectory)
					timerRequerimento = timer.performWithDelay(16,function() audio.play(som) end,1)
				end
				--timer.performWithDelay(16,function() media.playSound( arquivo , system.DocumentsDirectory);end,1)
			end
		end

		if e.target.clicado == false  then
			audio.stop()
			media.stopSound()
			
			local som = audio.loadStream(varGlobal.menuConfigBotaoPedidoEntrar)
			timerRequerimento = timer.performWithDelay(16,function() audio.play(som) end,1)
			e.target.clicado = true
			timer.performWithDelay(1000,function() e.target.clicado = false end,1)
			return true
		end
		if e.target.clicado == true then
			if requerimentoDownload then
				network.cancel( requerimentoDownload )
				print("cancelei o download!")
			end
			if timerRequerimento then
				timer.cancel(timerRequerimento)
				print("cancelei o timer do audio!")
			end
			cancelar = true
			print(cancelar,"cancelou")
			audio.stop()
			media.stopSound()
			print("Abrindo menu rapido!")
			local cancelarMenuConfig = false
			local timerRequerimentoMenuConfig
			local requerimentoDownloadMenuConfig
			local function AudiosMenuConfig(event)
				if event.y > 229 and event.y < 299 and event.x < 454 then -- som config de voz
					audio.stop()
					media.stopSound()
					local som = audio.loadStream(varGlobal.menuConfigVelocIntro)
					audio.play(som)
				elseif event.y >= 1132 or event.x < 80 or event.x > event.target.width - 80 or event.y < 150 then -- botao sair

					if event.target.clicado == false  then
						audio.stop()
						media.stopSound()
						timer.performWithDelay(1000,function() event.target.clicado = false end,1)
						local som = audio.loadStream(varGlobal.menuConfigPedidoSairSom)
						timerRequerimento = timer.performWithDelay(16,function() audio.play(som) end,1)
					end
					if event.target.clicado == true then
						grupoBotao.GMenu.fecharMenu:setEnabled(false)
						local som = audio.loadStream(varGlobal.menuConfigSairSom)
						local function onComplete()
							grupoBotao.GMenu:removeSelf()
						end
						event.target:removeEventListener("tap",fecharMenuConfig)
						timerRequerimento = timer.performWithDelay(16,function() audio.play(som,{onComplete = onComplete}) end,1)
						audio.stop()
						media.stopSound()

					end
					event.target.clicado = true
				end
				return true
			end



			grupoBotao.GMenu = display.newGroup()
			local diferencaH = H - 1280
			grupoBotao.GMenu.MenuConfig = display.newImageRect(varGlobal.menuConfigImagem,W,H)
			grupoBotao.GMenu.MenuConfig.x,grupoBotao.GMenu.MenuConfig.y = W/2,H/2
			grupoBotao.GMenu.MenuConfig.isHitTestable = true
			grupoBotao.GMenu.MenuConfig.clicado = false
			grupoBotao.GMenu.MenuConfig:addEventListener("tap",AudiosMenuConfig)
			grupoBotao.GMenu.MenuConfig:addEventListener("touch",function()return true end)



			--------------------------------------------------------------------------
			-- botão aumentar velocidade audio ---------------------------------------
			local function onStepperPress( event )
				if ( "increment" == event.phase ) then
					if varGlobal.VelocidadeTTS < 7 then
						varGlobal.VelocidadeTTS = varGlobal.VelocidadeTTS + 1
						grupoBotao.GMenu.quantidadeAtual.text = "+"..varGlobal.VelocidadeTTS
						audio.stop()
						media.stopSound()
						local som = audio.loadStream("aumentaAudio"..varGlobal.accLinguagem..varGlobal.VelocidadeTTS..".MP3")
						audio.play(som)
					else
						print("já alcançou a velocidade máxima")
					end
				elseif ( "decrement" == event.phase ) then
					if varGlobal.VelocidadeTTS > -1 then
						varGlobal.VelocidadeTTS = varGlobal.VelocidadeTTS -1
						if varGlobal.VelocidadeTTS == -1 then
							grupoBotao.GMenu.quantidadeAtual.text = varGlobal.VelocidadeTTS
						else
							grupoBotao.GMenu.quantidadeAtual.text = "+"..varGlobal.VelocidadeTTS
						end
						audio.stop()
						media.stopSound()
						if varGlobal.VelocidadeTTS ~= -1 then
							local som = audio.loadStream("diminuiAudio"..varGlobal.accLinguagem..varGlobal.VelocidadeTTS..".MP3")
							audio.play(som)
						else
							local som = audio.loadStream("diminuiAudio"..varGlobal.accLinguagem.."_1.MP3")
							audio.play(som)
						end
					else
						print("já alcançou a velocidade mínima")
					end
				end
				return true
			end

			local options = {
				width = 110,
				height = 50,
				numFrames = 5,
				sheetContentWidth = 550,
				sheetContentHeight = 50
			}
			local stepperSheet = graphics.newImageSheet( "stepper widget.png", options )
			local frameDefault = 1
			if varGlobal.VelocidadeTTS == -1 then
				frameDefault = 2
			elseif varGlobal.VelocidadeTTS == 7 then
				frameDefault = 3
			end
			-- Create the widget
			grupoBotao.GMenu.newStepper = widget.newStepper(
				{
					width = 220,--110,
					height = 100,--50,
					sheet = stepperSheet,
					defaultFrame = frameDefault,
					noMinusFrame = 2,
					noPlusFrame = 3,
					minusActiveFrame = 4,
					plusActiveFrame = 5,
					minimumValue = -1,
					maximumValue = 7,
					onPress = onStepperPress
				}
			)
			grupoBotao.GMenu.newStepper.anchorX=0
			grupoBotao.GMenu.newStepper.anchorY=0
			grupoBotao.GMenu.newStepper.x = 455
			grupoBotao.GMenu.newStepper.y = 222
			grupoBotao.GMenu.newStepper:scale(1.6,1.6)
			local textoQntinicial = "+"..varGlobal.VelocidadeTTS
			if varGlobal.VelocidadeTTS == -1 then
				textoQntinicial = varGlobal.VelocidadeTTS
			end
			grupoBotao.GMenu.quantidadeAtual = display.newText(textoQntinicial,0,0,"Fontes/arial.ttf",50)
			grupoBotao.GMenu.quantidadeAtual:setFillColor(1,1,1)
			grupoBotao.GMenu.quantidadeAtual.anchorX = 0
			grupoBotao.GMenu.quantidadeAtual.anchorY = 0.5
			grupoBotao.GMenu.quantidadeAtual.x = grupoBotao.GMenu.newStepper.x - grupoBotao.GMenu.quantidadeAtual.width
			grupoBotao.GMenu.quantidadeAtual.y = grupoBotao.GMenu.newStepper.y + grupoBotao.GMenu.newStepper.height*1.6/2
			--------------------------------------------------------------------------
			-- botão localizar -------------------------------------------------------
			print("CRIOU BOTÃO LOCALIZAR 2")
			grupoBotao.GMenu.localizar = widget.newButton(
				{
					shape = "roundedRect",
					strokeWidth = 1,
					strokeColor = {default = {110/255,161/255,164/255},over = {110/255,161/255,164/255,0.5}},
					fillColor = {default = {110/255,161/255,164/255,0},over = {110/255,161/255,164/255,0}},
					label = "localizar",
					font = "Fontes/paolaAccent.ttf",
					labelColor = {default = {0,0,0},over = {1,1,1}}
				}
			)
			grupoBotao.GMenu.localizar.x = grupoBotao.GMenu.newStepper.x
			grupoBotao.GMenu.localizar.y = grupoBotao.GMenu.newStepper.y + grupoBotao.GMenu.newStepper.height + 10
			grupoBotao.GMenu:insert(grupoBotao.GMenu.localizar)
			--------------------------------------------------------------------------
			--------------------------------------------------------------------------
			-- botão de deslogar --
			local function DeslogarESair(e)
				if e.target.clicado == false  then
					audio.stop()
					media.stopSound()
					local som = audio.loadStream(varGlobal.menuConfigBotaoDeslogarClicar)
					timerRequerimento = timer.performWithDelay(16,function() audio.play(som) end,1)
					e.target.clicado = true
					timer.performWithDelay(1000,function() e.target.clicado = false end,1)
					return true
				end
				if e.target.clicado == true  then
					audio.stop()
					media.stopSound()
					e.target:setEnabled( false )
					local protetor = display.newRect(W/2,H/2,W,H)
					protetor.alpha = 0
					protetor.isHitTestable = true
					protetor:addEventListener("tap",function()end)
					protetor:addEventListener("touch",function()end)
					local function DeslogarESairAux(event)
						if event.isError then
							audio.stop()
							local som = audio.loadStream(varGlobal.menuConfigBotaoDeslogarFalha)
							timerRequerimento = timer.performWithDelay(16,function() audio.play(som) end,1)
						else
							print(event.response)
							auxFuncs.LimparTemporaryDirectory()
							auxFuncs.LimparDocumentsDirectory()
							local function onComplete()
								os.exit()
							end
							local som = audio.loadStream(varGlobal.menuConfigBotaoDeslogar)
							timerRequerimento = timer.performWithDelay(16,function() audio.play(som,{onComplete=onComplete}) end,1)
						end
					end
					local parameters = {}
					parameters.body = "deslogar&livro_id=" .. varGlobal.idLivro1 .. "&usuario_id=" .. varGlobal.idAluno1
					local URL = "https://omniscience42.com/EAudioBookDB/verificarPermissaoAcessoLivro.php"
					network.request(URL, "POST", DeslogarESairAux,parameters)
				end


			end
			grupoBotao.GMenu.botaoDeslogar = widget.newButton {
				label = varGlobal.menuConfigBotaoDeslogarTexto,
				onRelease = DeslogarESair,
				emboss = false,
				-- Properties for a rounded rectangle button
				shape = "roundedRect",
				width = 250,
				height = 50,
				font = "segoeui.ttf",
				fontSize = 30,
				cornerRadius = 2,
				fillColor = { default={0.85,0.85,0.85,.9}, over={0.35,0.35,0.35,.9} },
				strokeColor = { default={0,0,0,1}, over={.5,0.5,.5,1} },
				labelColor = { default={0,0,0,1}, over={.7,0.7,.7,1} },
				strokeWidth = 2
			}
			grupoBotao.GMenu.botaoDeslogar.clicado = false
			grupoBotao.GMenu.botaoDeslogar.anchorX=0
			grupoBotao.GMenu.botaoDeslogar.anchorY=1
			grupoBotao.GMenu.botaoDeslogar.x = 390
			grupoBotao.GMenu.botaoDeslogar.y = 1130

			-- botão de fechar menu --
			local function fecharMenuConfig(event)
				if event.target.clicado == false  then
					audio.stop()
					media.stopSound()
					timer.performWithDelay(1000,function() event.target.clicado = false end,1)
					local som = audio.loadStream(varGlobal.menuConfigPedidoSairSom)
					timerRequerimento = timer.performWithDelay(16,function() audio.play(som) end,1)
				end
				if event.target.clicado == true then
					grupoBotao.GMenu.fecharMenu:setEnabled(false)
					local som = audio.loadStream(varGlobal.menuConfigSairSom)
					local function onComplete()
						grupoBotao.GMenu:removeSelf()
					end
					event.target:removeEventListener("tap",fecharMenuConfig)
					timerRequerimento = timer.performWithDelay(16,function() audio.play(som,{onComplete = onComplete}) end,1)
					audio.stop()
					media.stopSound()
				end
				event.target.clicado = true
				return true
			end
			grupoBotao.GMenu.fecharMenu = widget.newButton {
				onRelease = fecharMenuConfig,
				emboss = false,
				-- Properties for a rounded rectangle button
				defaultFile = "closeMenuButton.png",
				overFile = "closeMenuButtonD.png"
			}
			grupoBotao.GMenu.fecharMenu.clicado = false
			grupoBotao.GMenu.fecharMenu.anchorX=1
			grupoBotao.GMenu.fecharMenu.anchorY=0
			grupoBotao.GMenu.fecharMenu.x = W - 80 + grupoBotao.GMenu.fecharMenu.width/2 - 2
			grupoBotao.GMenu.fecharMenu.y = 135--1130 + grupoBotao.GMenu.fecharMenu.height/2 - 5
			--------------------------------------------------------------------------
			--------------------------------------------------------------------------
			grupoBotao.GMenu:insert(grupoBotao.GMenu.MenuConfig)
			grupoBotao.GMenu:insert(grupoBotao.GMenu.newStepper)
			grupoBotao.GMenu:insert(grupoBotao.GMenu.quantidadeAtual)
			grupoBotao.GMenu:insert(grupoBotao.GMenu.botaoDeslogar)
			grupoBotao.GMenu:insert(grupoBotao.GMenu.fecharMenu)

			return true
		end
		e.target.clicado = true
		return true
	end
	botaoConfigRect:addEventListener("tap",abrirMenuConfig)

	return grupoBotao
end

----------------------------------------------------------
--	COLOCAR IMAGEM										--
--	Funcao responsavel por colocar uma imagem			--
--  na tela, podendo ser tela inteira					--
--  ou dimensionada										--
--  ATRIBUTOS: arquivo,comprimento,altura,x,y,*posicao	--
--  *Posicao: (base, centro, topo), zoom (sim ou nao)--
----------------------------------------------------------
--[[
local subPagina = atrib.subPagina
historicoLib.Criar_e_salvar_vetor_historico({
	tipoInteracao = "TTS",
	pagina_livro = atrib.pagina,
	objeto_id = nil,
	acao = "executar",
	subtipo = "dicionário",
	subPagina = subPagina,
	velocidade_tts = atrib.velocidade,
	tela = atrib.tela
})
]]
function M.ZoomImagem(event,Var,vetorTelas,ims,GRUPOGERAL)
	if Var.video then
		Var.video.x = 1000
	end
	if Var.videos then
		for k=1,#Var.videos do
			Var.videos[k].x = 1000
		end
	end
	Var.imagens[ims].grupoZoom = display.newGroup()
	--print(e.target.zoom)
	local imagemoutra = vetorTelas.imagens[ims].arquivo
	Var.imagens[ims].grupoZoom.telaPreta = display.newRect(0,0,W*2,H*2)
	Var.imagens[ims].grupoZoom.telaPreta.anchorX = 0.5; Var.imagens[ims].grupoZoom.telaPreta.anchorY = 0.5
	Var.imagens[ims].grupoZoom.telaPreta.x = W/2; Var.imagens[ims].grupoZoom.telaPreta.y = H/2
	Var.imagens[ims].grupoZoom.telaPreta:setFillColor(1,1,1)
	Var.imagens[ims].grupoZoom.telaPreta.alpha=.8
	Var.imagens[ims].grupoZoom.imgFunc = display.newImage(imagemoutra,W/2,H/2)
	Var.imagens[ims].grupoZoom.imgFunc.anchorX = .5; Var.imagens[ims].grupoZoom.imgFunc.anchorY= .5
	Var.imagens[ims].grupoZoom.imgFunc.x=W/2;Var.imagens[ims].grupoZoom.imgFunc.y=H/2
	Var.imagens[ims].grupoZoom:insert(Var.imagens[ims].grupoZoom.telaPreta)
	Var.imagens[ims].grupoZoom:insert(Var.imagens[ims].grupoZoom.imgFunc)
	--Var.imagens[ims]:removeEventListener("tap",ZoomImagem)
	local texto = display.newText("Zoom Ativado",1,1,native.systemFont,50)
	texto.anchorX = 1; texto.anchorY = 1
	texto.x = W; texto.y = H
	texto:setFillColor(0,1,0)
	Var.imagens[ims].grupoZoom:insert(texto)
	local function rodarTelaZoom()
		if Var.imagens[ims] then
			girarTelaOrientacao(Var.imagens[ims].grupoZoom)
		end
	end

	function Var.imagens.mudarOrientation()
		if Var.imagens[ims] and Var.imagens[ims].grupoZoom then
			if system.orientation == "landscapeRight" then

				transition.to(Var.imagens[ims].grupoZoom.imgFunc,{time = 0,rotation = 90,x=W/2,y=H/2})
				transition.to(texto,{time = 0,rotation = 90,x=0,y=H})

			elseif system.orientation == "landscapeLeft" then

				transition.to(Var.imagens[ims].grupoZoom.imgFunc,{time = 0,rotation = -90,x=W/2,y=H/2})
				transition.to(texto,{time = 0,rotation = -90,x=W,y=0})
			else

				Var.imagens[ims].grupoZoom.imgFunc.rotation = 0

				texto.x = W; texto.y = H
				texto.rotation = 0
			end
		end
	end
	Var.imagens.mudarOrientation(Var.imagens[ims].grupoZoom)
	-- ZOOM IMAGEM ORIENTAÇÃO
	Runtime:addEventListener("orientation",Var.imagens.mudarOrientation)
	--varGlobal.GRUPOTTS:insert(1,Var.imagens[ims].grupoZoom)
	local function removerImgFunc()
		if Var.video then
			Var.video.x = 0
		end
		if Var.videos then
			for k=1,#Var.videos do
				Var.videos[k].x = 0
			end
		end
		if Var.imagens[ims].grupoZoom then
			Var.imagens[ims].grupoZoom:removeEventListener("tap",removerImgFunc)
			Var.imagens[ims].grupoZoom:removeSelf()
			Var.imagens[ims].grupoZoom = nil
		end
		Runtime:removeEventListener("orientation",rodarTelaZoom)
		Runtime:removeEventListener("orientation",Var.imagens.mudarOrientation)
		--Var.imagens[ims]:addEventListener("tap",ZoomImagem)
		toqueHabilitado = true
		print("\n\nremoveu Zoom\n\n")
		print(vetorTelas.pagina)
		local subPagina = vetorTelas.subPagina
		historicoLib.Criar_e_salvar_vetor_historico({
			tipoInteracao = "imagem",
			pagina_livro = vetorTelas.pagina,
			objeto_id = ims,
			acao = "desativar zoom",
			tempo_aberto = Var.imagens[ims].tempoAbertoZoomNumero,
			subPagina = subPagina,
			tela = vetorTelas
		})

		if Var.imagens[ims].tempoAbertoZoom then
			timer.cancel(Var.imagens[ims].tempoAbertoZoom)
		end
		Var.imagens[ims].tempoAbertoZoomNumero = 0
		auxFuncs.restoreNativeScreenElements(Var)
		return true
	end
	print("\n\ncriou Zoom\n\n")
	Var.imagens[ims].grupoZoom.imgFunc.prevX=Var.imagens[ims].grupoZoom.imgFunc.x
	Var.imagens[ims].grupoZoom.imgFunc.prevY=Var.imagens[ims].grupoZoom.imgFunc.y
	Var.imagens[ims].grupoZoom.imgFunc.anchorChildren = true

	Var.imagens[ims].grupoZoom:addEventListener("touch",function() return true; end)
	Var.imagens[ims].grupoZoom:addEventListener("tap",removerImgFunc)
	
	--imgFunc:addEventListener("touch",ZOOMZOOMZOOM)

	local subPagina = vetorTelas.subPagina
	historicoLib.Criar_e_salvar_vetor_historico({
		tipoInteracao = "imagem",
		pagina_livro = vetorTelas.pagina,
		objeto_id = ims,
		acao = "ativar zoom",
		tempo_aberto = Var.imagens[ims].tempoAbertoZoom,
		subPagina = subPagina,
		tela = vetorTelas
	})

	Var.imagens[ims].grupoZoom:addEventListener("touch",ZOOMZOOMZOOM2)
	if Var.imagens[ims].tempoAbertoZoom then
		timer.cancel(Var.imagens[ims].tempoAbertoZoom)
	end
	Var.imagens[ims].tempoAbertoZoomNumero = 0
	Var.imagens[ims].tempoAbertoZoom = timer.performWithDelay(100,
		function(event) 
			if not Var.imagens[ims] or not Var.imagens[ims].tempoAbertoZoomNumero then
				if event.source then timer.cancel(event.source); event.source = nil end
			else
				Var.imagens[ims].tempoAbertoZoomNumero = Var.imagens[ims].tempoAbertoZoomNumero + 100 
			end
		end,-1)
	auxFuncs.clearNativeScreenElements(Var)
	--GRUPOGERAL2.grupoZoom = Var.imagens[ims].grupoZoom
	return true
end
function M.colocarImagem(atributos,telas)
	if auxFuncs.naoVazio(atributos) then
		if not atributos.y then atributos.y = 0 end
		--local image = display.newImage(atributos.arquivo,system.ResourceDirectory)
		--if tostring(imagem) == "nil" then
		--	if atributos.arquivo then
		--		native.showAlert( "Não conseguiu ler a Imagem: "..atributos.arquivo, { "OK" })
		--	else
		--		native.showAlert( "Não conseguiu ler uma Imagem", { "OK" })
		--	end
		--else
			--image:removeSelf()
			if(atributos.arquivo) then
				print ("COLOQUEI UMA IMAGEM")
				local imagem = display.newImage(atributos.arquivo,system.ResourceDirectory)-- MODIFICAÇÂO PARA MONTADOR --
				if not imagem then
					imagem = display.newImage("imagemErro.jpg",system.ResourceDirectory)
				end
				imagem.anchorX,imagem.anchorY = 0,0
				--POSICAO CENTRO
				if(atributos.posicao=='centro') then
					imagem.anchorX=.5;
					imagem.anchorY=.5;
					imagem.y = H/2
					imagem.x = W/2
				--POSICAO TOPO
				elseif(atributos.posicao=='topo') then
					imagem.anchorX=.5;
					imagem.anchorY=0;
					imagem.x = W/2
					imagem.y = 0
				--POSICAO BASE
				elseif(atributos.posicao=='base') then
					imagem.anchorX=.5;
					imagem.anchorY=1;
					imagem.x = W/2
					imagem.y = H
				else
					imagem.anchorX=0;
					imagem.anchorY=0


				end
				local margem = atributos.margem or 0
				margem = margem*2
				if atributos.altura and atributos.comprimento then

					imagem.y = display.contentCenterY - (atributos.altura/2)
					imagem.x = display.contentCenterX - (atributos.comprimento/2)
				elseif atributos.altura then

					imagem.y = display.contentCenterY - (atributos.altura/2)
					imagem.x = display.contentCenterX - (imagem.width/2)
				elseif atributos.comprimento then

					imagem.x = display.contentCenterX - (atributos.comprimento/2)
					imagem.y = display.contentCenterY - (imagem.height/2)
				else
					--imagem.width,imagem.height = W,H
					local auxiliarW = imagem.width
					local auxiliarH = imagem.height
					local aux2 = (W-margem)/imagem.width
					imagem.width = aux2*imagem.width
					imagem.height = aux2*imagem.height

				end
				
				if atributos.comprimento or atributos.altura then
					local AuxComprimento = nil
					if (atributos.comprimento) then
						AuxComprimento = imagem.width
						imagem.width=atributos.comprimento;
					end
					if (atributos.comprimento) and not atributos.altura then
						local aux = AuxComprimento/atributos.comprimento
						imagem.height=imagem.height*aux;
					end
					if (atributos.altura) then
						imagem.height=atributos.altura
					end
					if imagem.width > W-margem then
						local auxiliarW = imagem.width
						local auxiliarH = imagem.height
						local aux2 = (W-margem)/imagem.width
						imagem.width = aux2*imagem.width
						imagem.height = aux2*imagem.height
					end
				end
				if not atributos.escala then atributos.escala = 1 end
				imagem:scale(atributos.escala,atributos.escala)
				
				if(atributos.url) then
					local function onClickLink(event)
						system.openURL(atributos.url)
					end
					--imagem:addEventListener('tap', onClickLink)
					imagem.url = atributos.url
				end
				if(atributos.urlembeded) then
					local function onClickLink(event)
						system.openURL(atributos.url)
					end
					--imagem:addEventListener('tap', onClickLink)
					imagem.urlembeded = atributos.urlembeded
				end
				


				if(atributos.alinhamento=='esquerda') then
					imagem.anchorX=0;
					imagem.x = 0
					if atributos.margem then
						imagem.x = atributos.margem
					end
				--POSICAO TOPO
				elseif(atributos.alinhamento=='direita') then
					imagem.anchorX=1;
					imagem.x = W
					if atributos.margem then
						imagem.x = W - atributos.margem
					end
				--POSICAO BASE
				elseif(atributos.alinhamento=='meio') then
					imagem.anchorX=.5;
					imagem.x = W/2
				end


				if (atributos.x) then
					imagem.anchorX=0;
					imagem.x=atributos.x
				end
				if (atributos.y) then
					meioY = display.contentCenterY
					imagem.anchorY=0;
					imagem.y= atributos.y;
				end

				imagem.pOsicao = imagem.y + imagem.height
				imagem.posicao1 = atributos.posicao
				if(atributos.posicao=='base') then
					if telas then
							if telas.texto then
								local texto = M.colocarTexto(telas.texto,telas)
								imagem.anchorY = 0

								if telas.texto.y then
									imagem.y = texto.y+ texto.height + telas.texto.y
								else
									imagem.y = texto.y+ texto.height + H
								end
								texto:removeSelf()
								texto = nil
							end
							if telas.textos then
								for txt=1,#telas.textos do
									local textos = M.colocarTexto(telas.textos[txt],telas)
									imagem.anchorY = 0
									imagem.y = textos.y + textos.height
									textos:removeSelf()
									textos = nil
								end
							end
					end
				end
				if atributos.zoom then
					imagem.zoom = atributos.zoom
				else
					imagem.zoom = "sim"
				end
				if atributos.index then imagem.index = atributos.index end
				return imagem;
			end


		--end


	end
end

--------------------------------------------------
--	COLOCAR SOM									--
--	Funcao responsavel por tocar som, 			--
--  aceita arquivos wav e mp3					--
--  ATRIBUTOS: arquivo ,temImagem, imagemReiniciar,	largura, altura					--
-- imagemPause, imagemPauseHeight, imagemPauseWidth
--------------------------------------------------

function M.colocarSomNew(atributos,telas)
	if auxFuncs.naoVazio(atributos) and atributos.arquivo then
		--verificar se o áudio é válido	 ------
		local slider =  require("slider")
		local grupoSom = display.newGroup()
		grupoSom.som = audio.loadStream(atributos.arquivo)
		
		-- verificar e guardar todas as variáveis --
		local Y = atributos.y or  0
		local X = atributos.x or  W/2
		local arquivo = atributos.arquivo
		local automatico = atributos.automatico or  "nao"
		local avancar = atributos.avancar or  "nao"
		local index = atributos.index
		local url = atributos.url or nil
		local pagina = atributos.pagina
		local objetoIDHistorico = 1
		if telas[paginaAtual] and telas[paginaAtual].cont then
			objetoIDHistorico = telas[paginaAtual].cont.sons
		end
		local vetorExtencoesAudio = auxFuncs.vetorExtencoesAudio
		-- adicionando variáveis de tempo --
		grupoSom.TempoExecutadoValor = 0
		grupoSom.TempoExecutadoValorMax = 0
		grupoSom.TempoRepetindoValor = 0
		----------------------------------
		
		-- se o áudio for válido, prosseguir ------
		if grupoSom.som then
			local lowerArquivo = string.lower(arquivo)
			-- verificar extenção e definir imagem --
			grupoSom.Mp3 = string.find( string.lower(atributos.arquivo), "%.mp3" )
			grupoSom.Wav = string.find( string.lower(atributos.arquivo), "%.wav" )

			grupoSom.imagemSom = display.newImage("audioPlayer.png",W/2,0)
			grupoSom.imagemSom.anchorY=0
			grupoSom.imagemSom.anchorX=0
			grupoSom.imagemSom.x = W/2 - grupoSom.imagemSom.width/2
			grupoSom.imagemSom.width = 600
			grupoSom.imagemSom.height = 172
			-----------------------------------------
			grupoSom.duracaoAudio = audio.getDuration( grupoSom.som )
			
			local function avancarPagina(event)
				if avancar and grupoSom.duracaoAudio >0.5 then
					if event.completed then
						if pagina then
							criarCursoAux(telas, pagina+1)
						end
					end
				end
			end
			
			grupoSom.slider = {}
			
			if index then grupoSom.index = index end
			return grupoSom
		end
	end
end
function M.colocarSom(atributos,telas)
	audio.stop()

	if auxFuncs.naoVazio(atributos) then

		if not atributos.y then atributos.y = 0 end
		if(atributos.arquivo) then
			local grupoSom = display.newGroup()
			
			grupoSom.som = audio.loadStream(atributos.arquivo)
			local duracaoAudio = 0
			if grupoSom.som then
				duracaoAudio = audio.getDuration( grupoSom.som )
			end
			local function onComplete(event)
				if atributos.avancar == "sim" then
					if duracaoAudio >0.5 then
						if event.completed then
							criarCursoAux(telas, paginaAtual+1)
							paginaAtual=paginaAtual+1
						end
					end
				end
			end
			local tempoParaPassar = 2000
			if duracaoAudio/20 > duracaoAudio then tempoParaPassar = duracaoAudio/20 end
			if tempoParaPassar > 7000 then tempoParaPassar = 7000 end
			-- adicionado variável de tempo --
			grupoSom.TempoExecutadoValor = 0
			grupoSom.TempoExecutadoValorMax = 0
			grupoSom.TempoRepetindoValor = 0
			----------------------------------

			--local som2 = audio.play( som,{ onComplete=onComplete })
			if not atributos.automatico then
				audio.stop()
			else
				if atributos.automatico ~= "sim" then
					audio.stop()
				end
			end
			local somAtual = 1
			if telas[paginaAtual] and telas[paginaAtual].cont then
				somAtual = telas[paginaAtual].cont.sons
			end
			local horizontalSlider

			local Mp3 = string.find( string.lower(atributos.arquivo), "%.mp3" )
			local Wav = string.find( string.lower(atributos.arquivo), ".wav" )
			local Wma = string.find( string.lower(atributos.arquivo), ".wma" )

			local cor = {0,0,0}
			if Mp3 ~= nil then
				cor = {0,.7,0}
			elseif Wav ~= nil then
				cor = {5,15,180}
			elseif Wma ~= nil then
				cor = {0.7,0.7,0.7}
			else
				cor = {0,0,0}
			end
			grupoSom.imagemSom = display.newImage("audioPlayer.png",W/2,0)
			grupoSom.imagemSom.anchorY=0
			grupoSom.imagemSom.anchorX=0
			grupoSom.imagemSom.x = W/2 - grupoSom.imagemSom.width/2
			grupoSom.extencaoAtual = string.match(atributos.arquivo,"%.(.+)")
			grupoSom.texto = display.newText({
				text     = grupoSom.extencaoAtual,
				x        = grupoSom.imagemSom.x+5,
				y        = grupoSom.imagemSom.y + grupoSom.imagemSom.height,
				font     = "Fontes/segoeui.ttf",
				fontSize = 40,
				align    = 'center'
			})

			grupoSom.texto.anchorX=0;grupoSom.texto.anchorY = 1
			grupoSom.texto:setFillColor(cor[1],cor[2],cor[3])
			
			if atributos.x then
				grupoSom.imagemSom.x = atributos.x
			end 
			if atributos.y then
				grupoSom.imagemSom.y = atributos.y
			end

			local arquivoATirar = ""
			if string.find(atributos.arquivo,"PaginasPre") then
				arquivoATirar = "PaginasPre/Outros Arquivos/"
			else
				arquivoATirar = "Paginas/Outros Arquivos/"
			end
			

			grupoSom.imagemAtivo = display.newImage("somAtivo.png",grupoSom.imagemSom.x+grupoSom.imagemSom.width-10,grupoSom.imagemSom.y + grupoSom.imagemSom.height-5)
			grupoSom.imagemAtivo.width = grupoSom.imagemSom.width/6.5
			grupoSom.imagemAtivo.height = grupoSom.imagemSom.width/12
			grupoSom.imagemAtivo.alpha = 0
			grupoSom.imagemAtivo:setFillColor(0,192/255,0) 
			grupoSom.imagemAtivo.anchorX,grupoSom.imagemAtivo.anchorY = 1,1
			
			local pAuSaDo = false
			local RoDaNdO = false
			grupoSom.temporizador = 0
			-- SLIDEEEEEEER ------------------------------------------------------
			local widget = require( "widget" )


			local function sliderListener(event)
				if grupoSom.musica then
					local resultado = (event.value/100) * duracaoAudio
					if event.phase == "moved" then
						if grupoSom.delay then
							timer.cancel(grupoSom.delay)
							grupoSom.delay = nil
						end
						if grupoSom.timerAvancar then
							timer.cancel(grupoSom.timerAvancar)
							grupoSom.timerAvancar = nil
						end
						if grupoSom.timerUp then
							timer.cancel(grupoSom.timerUp)
							grupoSom.timerUp = nil
						end
						if grupoSom.musica then
							if pAuSaDo == false then
								--[[local date = os.date( "*t" )
								local data = date.day.."/"..date.month.."/"..date.year
								local hora = date.hour..":"..date.min..":"..date.sec
								local pH = funcGlobal.pegarNumeroPaginaRomanosHistorico(varGlobal.PagH)
								local vetorJson = {
									tipoInteracao = "audio",
									pagina_livro = varGlobal.PagH,
									objeto_id = somAtual,
									acao = "pausar",
									tempo_atual_audio = grupoSom.temporizador,
									tempo_total = duracaoAudio,
									relatorio = data.."| Pausou o áudio "..somAtual.."da pagina"..pH.." aos "..SecondsToClock(grupoSom.temporizador).." de execução às ".. hora.."."
								}
								if GRUPOGERAL.subPagina then
									vetorJson.subPagina = GRUPOGERAL.subPagina
								end
								funcGlobal.escreverNoHistorico(varGlobal.HistoricoPausouSom1..grupoSom.temporizador.."|Total: "..duracaoAudio..varGlobal.HistoricoPausouSom2.."|Audio "..somAtual,vetorJson)--atributos.arquivo)]]
								if grupoSom.TempoExecutado then
									timer.pause(grupoSom.TempoExecutado)
								end
								if grupoSom.TempoRepetindo then
									timer.pause(grupoSom.TempoRepetindo)
								end
							end
							pAuSaDo = true
							audio.pause(grupoSom.musica)
						end
						grupoSom.temporizador = resultado
						audio.seek(grupoSom.temporizador,grupoSom.musica)
					end
					if event.phase == "ended" then
						local aux = grupoSom.temporizador
						grupoSom.temporizador = resultado
						if grupoSom.TempoExecutado then
							if aux > resultado then -- se retrocedeu
								grupoSom.TempoExecutadoValor = grupoSom.TempoExecutadoValor - (aux - resultado)
							end
						end
					end

				end
			end

			local options = {
				frames = {
					{ x=0, y=0, width=40, height=64 },
					{ x=40, y=0, width=36, height=64 },
					{ x=80, y=0, width=36, height=64 },
					{ x=124, y=0, width=36, height=64 },
					{ x=168, y=0, width=64, height=64 }
				},
				sheetContentHeight = 64,
				sheetContentWidth = 232
			}
			local sliderSheet = graphics.newImageSheet( "slider2.png", options )

			-- Create the widget

			horizontalSlider = widget.newSlider(
				{
					sheet = sliderSheet,
					leftFrame = 1,
					middleFrame   = 2,
					rightFrame  = 3,
					fillFrame  = 4,
					frameWidth = 30,
					frameHeight = 45,
					handleFrame = 5,
					handleHeight = 45,
					handleWidth = 50,
					orientation = "horizontal",
					width = 310,
					value = 0,
					x = grupoSom.imagemSom.x+230,
					y = grupoSom.imagemSom.y+30,
					listener = sliderListener
				}
			)
			horizontalSlider.anchorY = 0
			horizontalSlider.anchorX = 0

			local function timeCount(numSec)
				local nSeconds = numSec
				if nSeconds == 0 then
					return "00:00:00";
				else
					local	nHours = string.format("%02.f", math.floor(nSeconds/3600));
					local	nMins = string.format("%02.f", math.floor(nSeconds/60 - (nHours*60)));
					local	nSecs = string.format("%02.f", math.floor(nSeconds - nHours*3600 - nMins *60));
					return (nHours..":"..nMins..":"..nSecs)
				end
			end

			grupoSom.tempTotal = display.newText(timeCount(duracaoAudio/1000),grupoSom.imagemSom.x + 495,grupoSom.imagemSom.y + 20,"timesSemi.otf",25)
			grupoSom.tempTotal:setFillColor(0,0,0)
			grupoSom.tempTotal.anchorX = 0
			grupoSom.tempTotal.anchorY = 0

			grupoSom.tempo = display.newText("00:00:00",grupoSom.imagemSom.x + 385,grupoSom.tempTotal.y,"timesSemi.otf",25)
			grupoSom.tempo:setFillColor(1,1,1)
			grupoSom.tempo.anchorX = 0
			grupoSom.tempo.anchorY = 0


			----------------------------------------------------------------------------

			local function voltarAudio()
				if grupoSom.delay then
					timer.cancel(grupoSom.delay)
					grupoSom.delay = nil
				end
				if grupoSom.timerAvancar then
					timer.cancel(grupoSom.timerAvancar)
					grupoSom.timerAvancar = nil
				end
				if grupoSom.timerUp then
					timer.cancel(grupoSom.timerUp)
					grupoSom.timerUp = nil
				end
				if grupoSom.musica then
					if pAuSaDo == false then
						--[[local subPagina = atributos.subPagina
						local subTipo = nil
						if atributos.dicionario then subtipo = "dicionário" end
						historicoLib.Criar_e_salvar_vetor_historico({
							tipoInteracao = "audio",
							pagina_livro = atributos.pagina,
							objeto_id = somAtual,
							subtipo = subtipo,
							subPagina = subPagina,
							acao = "pausar",
							tempo_atual_audio = grupoSom.temporizador,
							tempo_total = duracaoAudio,
							tempo_total_executado = grupoSom.TempoExecutadoValorMax,
							tempo_total_repetindo = grupoSom.TempoRepetindoValor,
							tela = telas
						})]]
					end
					pAuSaDo = true
					audio.pause(grupoSom.musica)
				end
				if grupoSom.Runtime then
					timer.cancel(grupoSom.Runtime)
					grupoSom.Runtime = nil
				end
				if not grupoSom.timerVoltar then
					local subPagina = atributos.subPagina
					local subTipo = nil
					if atributos.dicionario then subtipo = "dicionário" end
					historicoLib.Criar_e_salvar_vetor_historico({
						tipoInteracao = "audio",
						pagina_livro = telas.pagina,
						objeto_id = somAtual,
						subtipo = subtipo,
						subPagina = subPagina,
						acao = "retroceder",
						tempo_atual_audio = grupoSom.temporizador,
						tempo_total = duracaoAudio,
						tela = telas
					})
					if grupoSom.TempoExecutado then
						timer.pause(grupoSom.TempoExecutado)
					end
					if grupoSom.TempoRepetindo then
						timer.pause(grupoSom.TempoRepetindo)
					end
					grupoSom.timerVoltar = timer.performWithDelay(1000,function()
						if grupoSom.temporizador <= tempoParaPassar then
							grupoSom.temporizador = 0
							grupoSom.TempoExecutadoValor = 0
							audio.stop()
							grupoSom.musica = audio.play(grupoSom.som,{ onComplete=function() audio.stop();audio.seek(0,grupoSom.musica);grupoSom.temporizador = 0; end })
							grupoSom.timerUp = timer.performWithDelay(1000,function() grupoSom.temporizador = grupoSom.temporizador + 1000;horizontalSlider:setValue((grupoSom.temporizador/duracaoAudio)*100) end,-1)
							timer.cancel(grupoSom.timerVoltar)
							grupoSom.timerVoltar = nil
						else
							grupoSom.temporizador = grupoSom.temporizador - tempoParaPassar;
							grupoSom.TempoExecutadoValor = grupoSom.TempoExecutadoValor - tempoParaPassar
							horizontalSlider:setValue((grupoSom.temporizador/duracaoAudio)*100)
						end
					end,-1)
				end
			end
			grupoSom.clicouInterromper = false
			local function pararAudio()
				if grupoSom.delay then
					timer.cancel(grupoSom.delay)
					grupoSom.delay = nil
				end
				if grupoSom.timerVoltar then
					timer.cancel(grupoSom.timerVoltar)
					grupoSom.timerVoltar = nil
				end
				if grupoSom.timerAvancar then
					timer.cancel(grupoSom.timerAvancar)
					grupoSom.timerAvancar = nil
				end
				if grupoSom.timerUp then
					timer.cancel(grupoSom.timerUp)
					grupoSom.timerUp = nil
				end
				if grupoSom.Runtime then
					timer.cancel(grupoSom.Runtime)
					grupoSom.Runtime = nil
				end
				if grupoSom.musica then
					audio.seek(0,grupoSom.musica)
					audio.stop(grupoSom.musica)
					audio.dispose(grupoSom.musica)
					grupoSom.musica = nil
				end
				RoDaNdO = false
				local tempoAtualHistorico = 0
				if grupoSom.temporizador > 0 then
					grupoSom.clicouInterromper = true

					tempoAtualHistorico = grupoSom.temporizador
				end
				grupoSom.temporizador = 0
				horizontalSlider:setValue((grupoSom.temporizador/duracaoAudio)*100)
				grupoSom.imagemAtivo.alpha = 0
			end
			local function rodarAudio()


			if RoDaNdO == false or pAuSaDo == true then
				local tempo = grupoSom.temporizador
				if chegouNoFim == true then
					horizontalSlider:setValue((grupoSom.temporizador/duracaoAudio)*100)
				end
				chegouNoFim = false
				if grupoSom.Runtime then
					timer.cancel(grupoSom.Runtime)
					grupoSom.Runtime = nil
				end
				grupoSom.Runtime = timer.performWithDelay(100,
				function()
					if grupoSom.som then
						print(grupoSom.som)
						duracaoAudio = audio.getDuration( grupoSom.som )
					else
						duracaoAudio = 0
					end
					if grupoSom.temporizador >= duracaoAudio then
						grupoSom.temporizador = duracaoAudio;
					else
						grupoSom.tempo.text = timeCount(grupoSom.temporizador/1000);
					end
				end,-1)
				if grupoSom.delay then
					timer.cancel(grupoSom.delay)
					grupoSom.delay = nil
				end
				if grupoSom.timerVoltar then
					timer.cancel(grupoSom.timerVoltar)
					grupoSom.timerVoltar = nil
				end
				if grupoSom.timerAvancar then
					timer.cancel(grupoSom.timerAvancar)
					grupoSom.timerAvancar = nil
				end

				if grupoSom.musica and pAuSaDo == true then
					pAuSaDo = false
					audio.seek(grupoSom.temporizador)
					local subPagina = atributos.subPagina
					local subTipo = nil
					if atributos.dicionario then subtipo = "dicionário" end
					historicoLib.Criar_e_salvar_vetor_historico({
						tipoInteracao = "audio",
						pagina_livro = telas.pagina,
						objeto_id = somAtual,
						acao = "despausar",
						subtipo = subtipo,
						subPagina = subPagina,
						tempo_atual_audio = grupoSom.temporizador,
						tempo_total = duracaoAudio,
						tela = telas
					})
					
					grupoSom.delay = timer.performWithDelay(500,function()audio.resume(grupoSom.musica);end,1)
					grupoSom.imagemAtivo.alpha = 1
				else
					pAuSaDo = false
					RoDaNdO = true
					audio.stop()
					media.stopSound()
					local tempoAntesDeCancelar = grupoSom.temporizador
					grupoSom.delay = timer.performWithDelay(10,function()
						grupoSom.musica = audio.play(grupoSom.som,{ onComplete=
						function(event)
							--if event.completed == true then
								if event.completed == false then
									if grupoSom.clicouInterromper ~= true then
										local subPagina = atributos.subPagina
										local subTipo = nil
										if atributos.dicionario then subtipo = "dicionário" end
										historicoLib.Criar_e_salvar_vetor_historico({
											tipoInteracao = "audio",
											pagina_livro = telas.pagina,
											objeto_id = somAtual,
											subtipo = subtipo,
											subPagina = subPagina,
											acao = "cancelar",
											tempo_atual_audio = grupoSom.temporizador,
											tempo_total = duracaoAudio,
											tempo_total_executado = grupoSom.TempoExecutadoValorMax,
											tempo_total_repetindo = grupoSom.TempoRepetindoValor,
											tela = telas
										})
										if grupoSom.TempoExecutado then
											grupoSom.TempoExecutadoValor = 0
											grupoSom.TempoExecutadoValorMax = 0
											timer.cancel(grupoSom.TempoExecutado)
											grupoSom.TempoExecutado = nil
										end
										if grupoSom.TempoRepetindo then
											grupoSom.TempoRepetindoValor = 0
											timer.cancel(grupoSom.TempoRepetindo)
											grupoSom.TempoRepetindo = nil
										end
									end
									grupoSom.clicouInterromper = false
								else
									local subPagina = atributos.subPagina
									local subTipo = nil
									if atributos.dicionario then subtipo = "dicionário" end
									historicoLib.Criar_e_salvar_vetor_historico({
										tipoInteracao = "audio",
										pagina_livro = telas.pagina,
										objeto_id = somAtual,
										subtipo = subtipo,
										subPagina = subPagina,
										acao = "terminar",
										tempo_atual_audio = duracaoAudio,
										tempo_total = duracaoAudio,
										tempo_total_executado = grupoSom.TempoExecutadoValorMax,
										tempo_total_repetindo = grupoSom.TempoRepetindoValor,
										tela = telas
									})
									horizontalSlider:setValue(100)
									if grupoSom.TempoExecutado then
										grupoSom.TempoExecutadoValor = 0
										grupoSom.TempoExecutadoValorMax = 0
										timer.cancel(grupoSom.TempoExecutado)
										grupoSom.TempoExecutado = nil
									end
									if grupoSom.TempoRepetindo then
										grupoSom.TempoRepetindoValor = 0
										timer.cancel(grupoSom.TempoRepetindo)
										grupoSom.TempoRepetindo = nil
									end
									print("avancar!!!",atributos.avancar)
									if atributos.avancar == "sim" then
										if duracaoAudio >0.5 then
											if event.completed then
												print("tttttt",telas.pagina,telas.numeroTotal.Todas)
												if telas.pagina < telas.numeroTotal.Todas then 
													criarCursoAux(telas, telas.pagina+1)
												end
											end
										end
									end
								end
								if grupoSom.musica then
									audio.stop(grupoSom.musica);
								end
								if grupoSom.timerUp then
									timer.cancel(grupoSom.timerUp)
									grupoSom.timerUp = nil
								end
								if grupoSom.imagemAtivo then
									grupoSom.imagemAtivo.alpha = 0
								end
								if grupoSom.delay then
									timer.cancel(grupoSom.delay)
									grupoSom.delay = nil
								end
								if grupoSom.timerVoltar then
									timer.cancel(grupoSom.timerVoltar)
									grupoSom.timerVoltar = nil
								end
								if grupoSom.timerAvancar then
									timer.cancel(grupoSom.timerAvancar)
									grupoSom.timerAvancar = nil
								end
								if grupoSom.musica then
									grupoSom.musica = nil
								end
								if grupoSom.temporizador then
									grupoSom.temporizador = 0
								end
								if grupoSom.temporizador and horizontalSlider and duracaoAudio then
									chegouNoFim = true
									--horizontalSlider:setValue((grupoSom.temporizador/duracaoAudio)*100)
								end
								RoDaNdO = false

							--end
						end })
					end,1)
					local subPagina = atributos.subPagina
					local subTipo = nil
					if atributos.dicionario then subtipo = "dicionário" end
					historicoLib.Criar_e_salvar_vetor_historico({
						tipoInteracao = "audio",
						pagina_livro = telas.pagina,
						objeto_id = somAtual,
						subtipo = subtipo,
						subPagina = subPagina,
						acao = "executar",
						tempo_atual_audio = grupoSom.temporizador,
						tempo_total = duracaoAudio,
						tempo_total_executado = grupoSom.TempoExecutadoValorMax,
						tempo_total_repetindo = grupoSom.TempoRepetindoValor,
						tela = telas
					})
					grupoSom.imagemAtivo.alpha = 1
					if grupoSom.TempoExecutado then
						timer.cancel(grupoSom.TempoExecutado)
						grupoSom.TempoExecutado = nil
					end
					if grupoSom.TempoRepetindo then
						timer.cancel(grupoSom.TempoRepetindo)
						grupoSom.TempoRepetindo = nil
					end
					grupoSom.TempoExecutado = timer.performWithDelay(100,
						function()
							grupoSom.TempoExecutadoValor = grupoSom.TempoExecutadoValor + 100;
							if grupoSom.TempoExecutadoValor > grupoSom.TempoExecutadoValorMax then
								grupoSom.TempoExecutadoValorMax = grupoSom.TempoExecutadoValor
							end
						end,-1)
					grupoSom.TempoRepetindo = timer.performWithDelay(100,function() grupoSom.TempoRepetindoValor = grupoSom.TempoRepetindoValor + 100 end,-1)
				end
				grupoSom.timerUp = timer.performWithDelay(1000,
				function()
					grupoSom.temporizador = grupoSom.temporizador + 1000;
					horizontalSlider:setValue((grupoSom.temporizador/duracaoAudio)*100)
				end,-1)
				end
			end
			local function pausarAudio()

				if grupoSom.delay then
					timer.cancel(grupoSom.delay)
					grupoSom.delay = nil
				end
				if grupoSom.timerVoltar then
					timer.cancel(grupoSom.timerVoltar)
					grupoSom.timerVoltar = nil
				end
				if grupoSom.timerAvancar then
					timer.cancel(grupoSom.timerAvancar)
					grupoSom.timerAvancar = nil
				end
				if grupoSom.timerUp then
					timer.cancel(grupoSom.timerUp)
					grupoSom.timerUp = nil
				end
				if grupoSom.musica then
					if pAuSaDo == false then
						local subPagina = atributos.subPagina
						local subTipo = nil
						if atributos.dicionario then subtipo = "dicionário" end
						historicoLib.Criar_e_salvar_vetor_historico({
							tipoInteracao = "audio",
							pagina_livro = telas.pagina,
							objeto_id = somAtual,
							subtipo = subtipo,
							subPagina = subPagina,
							acao = "pausar",
							tempo_atual_audio = grupoSom.temporizador,
							tempo_total = duracaoAudio,
							tempo_total_executado = grupoSom.TempoExecutadoValorMax,
							tempo_total_repetindo = grupoSom.TempoRepetindoValor,
							tela = telas
						})
						if grupoSom.TempoExecutado then
							timer.pause(grupoSom.TempoExecutado)
						end
						if grupoSom.TempoRepetindo then
							timer.pause(grupoSom.TempoRepetindo)
						end
					end
					pAuSaDo = true
					audio.pause(grupoSom.musica)
				end
				if grupoSom.Runtime then
					timer.cancel(grupoSom.Runtime)
					grupoSom.Runtime = nil
				end
				horizontalSlider:setValue((grupoSom.temporizador/duracaoAudio)*100)
			end
			local function avancarAudio()
				if grupoSom.delay then
					timer.cancel(grupoSom.delay)
					grupoSom.delay = nil
				end
				if grupoSom.timerVoltar then
					timer.cancel(grupoSom.timerVoltar)
					grupoSom.timerVoltar = nil
				end
				if grupoSom.timerUp then
					timer.cancel(grupoSom.timerUp)
					grupoSom.timerUp = nil
				end
				if grupoSom.musica then

					if pAuSaDo == false then
						--[[local subPagina = atributos.subPagina
						local subTipo = nil
						if atributos.dicionario then subtipo = "dicionário" end
						historicoLib.Criar_e_salvar_vetor_historico({
							tipoInteracao = "audio",
							pagina_livro = telas.pagina,
							objeto_id = somAtual,
							subtipo = subtipo,
							subPagina = subPagina,
							acao = "pausar",
							tempo_atual_audio = grupoSom.temporizador,
							tempo_total = duracaoAudio,
							tempo_total_executado = grupoSom.TempoExecutadoValorMax,
							tempo_total_repetindo = grupoSom.TempoRepetindoValor,
							tela = telas
						})]]
						if grupoSom.TempoExecutado then
							timer.pause(grupoSom.TempoExecutado)
						end
						if grupoSom.TempoRepetindo then
							timer.pause(grupoSom.TempoRepetindo)
						end
					end
					pAuSaDo = true
					audio.pause(grupoSom.musica)
				end
				if grupoSom.Runtime then
					timer.cancel(grupoSom.Runtime)
					grupoSom.Runtime = nil
				end
				if not grupoSom.timerAvancar then
					local subPagina = atributos.subPagina
					local subTipo = nil
					if atributos.dicionario then subtipo = "dicionário" end
					historicoLib.Criar_e_salvar_vetor_historico({
						tipoInteracao = "audio",
						pagina_livro = telas.pagina,
						objeto_id = somAtual,
						subtipo = subtipo,
						subPagina = subPagina,
						acao = "avançar",
						tempo_atual_audio = grupoSom.temporizador,
						tempo_total = duracaoAudio,
						tela = telas
					})
					if grupoSom.TempoExecutado then
						timer.pause(grupoSom.TempoExecutado)
					end
					if grupoSom.TempoRepetindo then
						timer.pause(grupoSom.TempoRepetindo)
					end
					grupoSom.timerAvancar = timer.performWithDelay(1000,function()
						if grupoSom.temporizador >= duracaoAudio - tempoParaPassar then
							grupoSom.temporizador = duracaoAudio
							timer.cancel(grupoSom.timerAvancar)
							grupoSom.timerAvancar = nil
						else
							grupoSom.temporizador = grupoSom.temporizador + tempoParaPassar;
							horizontalSlider:setValue((grupoSom.temporizador/duracaoAudio)*100)
						end
					end,-1)
				end
			end
			
			if atributos.automatico and atributos.automatico == "sim" then
				audio.stop()
				rodarAudio()
			end
			
			local barra = {}
			barra.x = grupoSom.imagemSom.x
			barra.y = grupoSom.imagemSom.y
			local voltar = widget.newButton({defaultFile = "audioVoltar.png",overFile = "audioVoltarD.png",width = 60,height = 50, x = barra.x + 90 + 60 -10,y = barra.y + 60,onRelease = voltarAudio})
			local parar = widget.newButton({defaultFile = "audioParar.png",overFile = "audioPararD.png",width = 60,height = 50, x = voltar.x + 79,y = barra.y + 60,onRelease = pararAudio})
			local rodar = widget.newButton({defaultFile = "audioRodar.png",overFile = "audioRodarD.png",width = 60,height = 50, x = parar.x + 79,y = barra.y + 60,onRelease = rodarAudio})
			local pausar = widget.newButton({defaultFile = "audioPausar.png",overFile = "audioPausarD.png",width = 60,height = 50, x = rodar.x + 79,y = barra.y + 60,onRelease = pausarAudio})
			local avancar=widget.newButton({defaultFile="audioAvancar.png",overFile = "audioAvancarD.png", width = 60,height = 50, x = pausar.x + 79,y = barra.y + 60,onRelease = avancarAudio})
			voltar.anchorY,parar.anchorY,rodar.anchorY,pausar.anchorY,avancar.anchorY = 0,0,0,0,0


			grupoSom:insert(grupoSom.texto)
			grupoSom:insert(grupoSom.imagemSom)
			grupoSom:insert(horizontalSlider)
			grupoSom:insert(voltar)
			grupoSom:insert(parar)
			grupoSom:insert(rodar)
			grupoSom:insert(pausar)
			grupoSom:insert(avancar)
			grupoSom:insert(grupoSom.tempTotal)
			grupoSom:insert(grupoSom.tempo)
			grupoSom:insert(grupoSom.imagemAtivo)

			local function mudarSlider(e)
				if system.orientation == "landscapeLeft" then
					horizontalSlider.isVisible = false
				elseif system.orientation == "landscapeRight" then
					horizontalSlider.isVisible = false
				else
					horizontalSlider.isVisible = true
				end
			end
			grupoSom.RuntimeSlider = timer.performWithDelay(100,mudarSlider,-1)
			if atributos.index then grupoSom.index = atributos.index end

			-- BOTÃO DE DETALHES
			if not atributos.modificar then
				atributos.modificar = 0
			end
			local function handleButtonEvent(event)
				print("EVENTO")
				atributos.tipoInteracao = "audio"
				atributos.tela = telas
				timer.performWithDelay(15,function()M.criarDescricao(atributos,true,somAtual); end,1)
			end

			local options = {
				width = 50,
				height = 50,
				defaultFile = "detalhes.png",
				overFile = "detalhesDown.png",
				onRelease = handleButtonEvent
			}
			local botaoDetalhes = widget.newButton(options)
			botaoDetalhes.x = botaoDetalhes.x + grupoSom.width - botaoDetalhes.width/2 + 30
			botaoDetalhes.y = botaoDetalhes.y + grupoSom.height - botaoDetalhes.height - 5
			grupoSom:insert(botaoDetalhes)
			if not atributos.conteudo then
				botaoDetalhes.isVisible = false
			end
			return grupoSom
		end
	end

end

------------------------------------------------------------------
--	COLOCAR HTML View											--
--	Funcao responsavel por abrir arquivo de html e mostra-lo, 	--
--  aceita arquivos htm, html									--
--  ATRIBUTOS: arquivo, x, y, largura, altura					--
------------------------------------------------------------------
function M.colocarHTML(atributos)
	if auxFuncs.naoVazio(atributos) then
		if not atributos.y then atributos.y = 0 end
		if(atributos.arquivo) then
			local posx = display.contentCenterX
			local posy = display.contentCenterY+45
			local larg = W-100
			local alt = H-250
			if atributos.x then
				posx = atributos.x
			end
			if atributos.y then
				posy = atributos.y
			end
			if atributos.largura then
				larg = atributos.largura
				if atributos.largura > W-100 then
					atributos.largura = W-100
				end
			end
			if atributos.altura then
				alt = atributos.altura
				if atributos.altura > H-20 then
					atributos.altura = H-20
				end
			end
			local webView = native.newWebView( posx, posy, larg, alt )
			webView:request( atributos.arquivo, system.DocumentsDirectory )
			if (webView.y+webView.height/2) > H then
				webView.y = H/2+45
			end
			if (webView.x+webView.width/2) > W then
				webView.y = W/2
			end
			if atributos.index then webView.index = atributos.index end
			return webView
		end
	end
end

------------------------------------------------------------------------------------
--	COLOCAR BOTAO
--	Funcao responsavel por criar um botao
--  de acordo com as opcoes desejadas e acoes pre-definidas
--  ATRIBUTOS: fundo,titulo(texto,tamanho,cor),altura,comprimento,x,y,*posicao,*acao
--  *tipo: texto, botao
--  *Acoes: iniciaCurso, iniciaPagina, irPara
-------------------------------------------------------------------------------------
-- colocarBotao({fundoUp = "",fundoDown = "",acao = "",altura = 0,comprimento = 0,x = 0,y = 0, posicao = "",tipo = "",titulo = {texto = "",tamanho = 30,cor={0,0,0}}},telas)
function M.colocarBotao(atributos,telas)
	-- DEFINE ATRIBUTOS DEFAULT
	if atributos == nil then
		atributos = {}
		atributos.titulo = {}
	end
	if not atributos.y then atributos.y = 0 end
	if not atributos.modificar then
		atributos.modificar = 0
	end
	local fundoUpEraNil = false
	if atributos.fundoUp == nil then
		atributos.fundoUp = "fundo-azul.png"
		fundoUpEraNil = true
	end
	if atributos.fundoDown == nil then
		if fundoUpEraNil == true then
			atributos.fundoDown = "fundo-azul-pressionado.png"
		else
			atributos.fundoDown = atributos.fundoUp
		end
	end

	-- ACAO DO BOTAO --=============================================================
	local contBotao = 1
	if telas[telas.pagina] and telas[telas.pagina].cont then
		contBotao = telas[telas.pagina].cont.botoes
	end

	local pAuSaDo = false
	local function handleButtonEvent( event )
		local botao = event.target
		if ( "began" == event.phase ) then

		elseif("moved" == event.phase or "cancelled" == event.phase) then

		elseif ( "ended" == event.phase ) then
			--== AÇÃO SELECIONAR MATERIAL ==--
			if botao.evento == "selecionar material" then
				if atributos.selecionarMaterial then
					atributos.selecionarMaterial()
				end
			--== AÇÃO IR PARA ==--
			elseif botao.evento == "irPara" then
				if botao.tempoAberto then
					timer.cancel(botao.tempoAberto)
					botao.tempoAberto = nil
				end
				if atributos.exercicioVoltar then
					--[[local date = os.date( "*t" )
					local data = date.day.."/"..date.month.."/"..date.year
					local hora = date.hour..":"..date.min..":"..date.sec
					local pH = funcGlobal.pegarNumeroPaginaRomanosHistorico(varGlobal.PagH)
					local vetorJson = {
						tipoInteracao = "botao",
						pagina_livro = atributos.numero,
						objeto_id = contBotao,
						acao = "executar",
						subtipo = "de link",
						relatorio = data.."| Clicou botão "..contBotao.." da pagina "..pH.." para ir para a página "..atributos.numero.." às "..hora.."."
					}
					if GRUPOGERAL.subPagina then
						vetorJson.subPagina = GRUPOGERAL.subPagina
					end
					funcGlobal.escreverNoHistorico(varGlobal.HistoricoVoltarParaQuestao,vetorJson)]]
					
				else
					--[[local date = os.date( "*t" )
					local data = date.day.."/"..date.month.."/"..date.year
					local hora = date.hour..":"..date.min..":"..date.sec
					local pH = funcGlobal.pegarNumeroPaginaRomanosHistorico(varGlobal.PagH)
					local vetorJson = {
						tipoInteracao = "botao",
						pagina_livro = atributos.numero,
						objeto_id = contBotao,
						acao = "executar",
						subtipo = "de link",
						relatorio = data.."| Clicou botão "..contBotao.." da pagina"..pH.." para ir para a página "..atributos.numero.." às "..hora.."."
					}
					if GRUPOGERAL.subPagina then
						vetorJson.subPagina = GRUPOGERAL.subPagina
					end
					funcGlobal.escreverNoHistorico(varGlobal.HistoricoBotaoPagina..atributos.numero,vetorJson)]]
				end
				if atributos.Telas then

					--verificaAcaoBotao(botao,atributos.Telas)
				else
					--verificaAcaoBotao(botao,telas)
				end
				if event.phase == "ended" then
					local fundoPreto = display.newRect(W/2,H/2,H,H)
					fundoPreto:addEventListener("touch",function() return true end)
					fundoPreto:setFillColor(0,0,0)
					fundoPreto.alpha = 0
					fundoPreto.isHitTestable = true
					timer.performWithDelay(100,function()fundoPreto:removeSelf() end,1)
				end

			--== AÇÃO TOCAR AUDIO ==--
			elseif botao.evento == "som" then
				if atributos.som then
					local som = audio.loadSound(atributos.som)
					pAuSaDo = false
					if event.target.som then
						audio.stop()
						event.target.som = nil
					end
					local function onComplete( event )
					   print( "audio session ended" )
						if event.completed == false then

							local subPagina = telas.subPagina
							historicoLib.Criar_e_salvar_vetor_historico({
								tipoInteracao = "botao",
								pagina_livro = telas.pagina,
								objeto_id = contBotao,
								acao = "terminar",
								subtipo = "de audio",
								tempo_aberto = botao.tempoAbertoNumero,
								subPagina = subPagina,
								tela = telas
							})

							if botao.tempoAberto then
								timer.cancel(botao.tempoAberto)
								botao.tempoAberto = nil
							end
							botao.tempoAbertoNumero = 0
						else

							local subPagina = telas.subPagina
							historicoLib.Criar_e_salvar_vetor_historico({
								tipoInteracao = "botao",
								pagina_livro = telas.pagina,
								objeto_id = contBotao,
								acao = "terminar",
								subtipo = "de audio",
								tempo_aberto = botao.tempoAbertoNumero,
								subPagina = subPagina,
								tela = telas
							})

							if botao.tempoAberto then
								timer.cancel(botao.tempoAberto)
								botao.tempoAberto = nil
							end
							botao.tempoAbertoNumero = 0
						end

						if atributos.avancar and atributos.avancar == "sim" then
							if event.completed then
								criarCursoAux(telas, telas.pagina+1)
								telas.pagina=telas.pagina+1
							end
						end
					end
					event.target.som = audio.play(som, {onComplete = onComplete})

				end

				local subPagina = telas.subPagina
				historicoLib.Criar_e_salvar_vetor_historico({
					tipoInteracao = "botao",
					pagina_livro = telas.pagina,
					objeto_id = contBotao,
					acao = "executar",
					subtipo = "de audio",
					subPagina = subPagina,
					tela = telas
				})

				if botao.tempoAberto then
					timer.cancel(botao.tempoAberto)
					botao.tempoAberto = nil
				end
				botao.tempoAbertoNumero = 0
				botao.tempoAberto = timer.performWithDelay(100,function() botao.tempoAbertoNumero = botao.tempoAbertoNumero + 100 end,-1)
			elseif botao.evento == "video" then
				if atributos.video then
					local videoID = atributos.video
					if string.find(atributos.video,"be/") then
						for lixo,past in string.gmatch(atributos.video, '(be/)(.+)') do
							videoID = past
						end
					elseif string.find(atributos.video,"be.com/watch%?v=") then
						for lixo,past in string.gmatch(atributos.video, '(be.com/watch%?v=)(.+)') do
							videoID = past
						end
					end
					if varGlobal.tipoSistema == "PC" then
					--if system.pathForFile(nil) ~= nil then
						local webView = native.newWebView( display.contentCenterX, display.contentCenterY, 320, 480 )
						webView.isVisible = false
						webView:request( atributos.video,system.ResourceDirectory )
						local date = os.date( "*t" )
						local data = date.day.."/"..date.month.."/"..date.year
						local hora = date.hour..":"..date.min..":"..date.sec
						local pH = funcGlobal.pegarNumeroPaginaRomanosHistorico(varGlobal.PagH)
						--[[local vetorJson = {
							tipoInteracao = "botao",
							pagina_livro = varGlobal.PagH,
							objeto_id = contBotao,
							acao = "executar",
							subtipo = "de video",
							relatorio = data.."| Executou o vídeo do botão "..contBotao.." da página "..pH.. " às ".. hora.."."
						}
						if GRUPOGERAL.subPagina then
							vetorJson.subPagina = GRUPOGERAL.subPagina
						end
						funcGlobal.escreverNoHistorico(varGlobal.HistoricoBotaoVideo..contBotao,vetorJson)]]
					else
						if videoID ~= atributos.video then
							timer.performWithDelay(30,function()


								local fundoPreto = display.newRect(W/2,H/2,H,H)

								fundoPreto:addEventListener("touch",function() return true end)
								fundoPreto:setFillColor(0,0,0)
								fundoPreto.alpha = 0.5

								local path = system.pathForFile( "story.html", system.TemporaryDirectory )
								-- io.open opens a file at path. returns nil if no file found
								local fh, errStr = io.open( path, "w" )
								if fh then
									print( "Created file" )
									fh:write("<!doctype html>\n<html>\n<head>\n<meta charset=\"utf-8\">")
									fh:write("<meta name=\"viewport\" content=\"width=320; initial-scale=1.0; maximum-scale=1.0; user-scalable=0;\"/>\n")
									fh:write("<style type=\"text/css\">\n html { -webkit-text-size-adjust: none; font-family: HelveticaNeue-Light, Helvetica, Droid-Sans, Arial, san-serif; font-size: 1.0em; } h1 {font-size:1.25em;} p {font-size:0.9em; } </style>")
									fh:write("</head>\n<body>\n")

									--fh:write("<h1>" .. story.title .. "</h1>\n")


									print(atributos.youtube)
									print(videoID)
									--print(videoID)
									local height = 200
									fh:write([[<iframe width="100%" height="]] .. height .. [[" src="https://www.youtube.com/embed/]] .. videoID .. [[?html5=1&autoplay=1" frameborder="0" ></iframe>]])

									fh:write( "\n</body>\n</html>\n" )
									io.close( fh )
								else
									print( "Create file failed!" )
								end

								local video = native.newWebView(0, 71, 600, 400)
								video.x = W/2
								video.y = H/2
								video.anchorY  = .5
								video:request("story.html", system.TemporaryDirectory)
								local function removerTudo()
									video:removeSelf()
									timer.performWithDelay(30,function()fundoPreto:removeSelf()end,1);
									return true
								end
								fundoPreto:addEventListener("touch",function() return true; end)
								fundoPreto:addEventListener("tap",removerTudo)
							end,1);
						else
							audio.stop()
							local onComplete = function( event )
							   print( "video session ended" )
								if event.completed then
									--[[local date = os.date( "*t" )
									local data = date.day.."/"..date.month.."/"..date.year
									local hora = date.hour..":"..date.min..":"..date.sec
									local pH = funcGlobal.pegarNumeroPaginaRomanosHistorico(varGlobal.PagH)
									local vetorJson = {
										tipoInteracao = "botao",
										pagina_livro = varGlobal.PagH,
										objeto_id = contBotao,
										acao = "terminar",
										subtipo = "de video",
										tempo_aberto = botao.tempoAbertoNumero,
										relatorio = data.."| Terminou de assistir o vídeo do botão "..contBotao.." da página "..pH.. " às ".. hora.."."
									}
									if GRUPOGERAL.subPagina then
										vetorJson.subPagina = GRUPOGERAL.subPagina
									end
									funcGlobal.escreverNoHistorico(varGlobal.HistoricoBotaoVideoFechou..contBotao,vetorJson)--atributos.video)]]
									if botao.tempoAberto then
										timer.cancel(botao.tempoAberto)
										botao.tempoAberto = nil
									end
									botao.tempoAbertoNumero = 0
								else
									--[[local date = os.date( "*t" )
									local data = date.day.."/"..date.month.."/"..date.year
									local hora = date.hour..":"..date.min..":"..date.sec
									local pH = funcGlobal.pegarNumeroPaginaRomanosHistorico(varGlobal.PagH)
									local vetorJson = {
										tipoInteracao = "botao",
										pagina_livro = varGlobal.PagH,
										objeto_id = contBotao,
										acao = "cancelar",
										subtipo = "de video",
										tempo_aberto = botao.tempoAbertoNumero,
										relatorio = data.."| Cancelou o vídeo do botão "..contBotao.." da página "..pH.. " às ".. hora.."."
									}
									if GRUPOGERAL.subPagina then
										vetorJson.subPagina = GRUPOGERAL.subPagina
									end
									funcGlobal.escreverNoHistorico(varGlobal.HistoricoBotaoVideoCancelou..contBotao,vetorJson)--atributos.video)]]
									if botao.tempoAberto then
										timer.cancel(botao.tempoAberto)
										botao.tempoAberto = nil
									end
									botao.tempoAbertoNumero = 0
								end
							end
							--print(atributos.video)

							media.playVideo( atributos.video, true, onComplete )
							--[[local date = os.date( "*t" )
							local data = date.day.."/"..date.month.."/"..date.year
							local hora = date.hour..":"..date.min..":"..date.sec
							local pH = funcGlobal.pegarNumeroPaginaRomanosHistorico(varGlobal.PagH)
							local vetorJson = {
								tipoInteracao = "botao",
								pagina_livro = varGlobal.PagH,
								objeto_id = contBotao,
								acao = "executar",
								subtipo = "de video",
								relatorio = data.."| Executou o vídeo do botão "..contBotao.." da página "..pH.. " às ".. hora.."."
							}
							if GRUPOGERAL.subPagina then
								vetorJson.subPagina = GRUPOGERAL.subPagina
							end
							funcGlobal.escreverNoHistorico(varGlobal.HistoricoBotaoVideo..contBotao,vetorJson)--atributos.video)]]
							if botao.tempoAberto then
								timer.cancel(botao.tempoAberto)
								botao.tempoAberto = nil
							end
							botao.tempoAbertoNumero = 0
							botao.tempoAberto = timer.performWithDelay(100,function() botao.tempoAbertoNumero = botao.tempoAbertoNumero + 100 end,-1)
						end
					end
				end
			elseif botao.evento == "texto" then

				local function criarTexto(jaClicou)

					local url = nil
					if atributos.url then
						url = atributos.url
					end
					local colocarFormatacaoTexto = require "colocarFormatacaoTexto"
					if atributos.texto then
						local ox, oy = math.abs(display.screenOriginX), math.abs(display.screenOriginY)

						local grupoTexto = display.newGroup()
						local fundoPreto = display.newRect(W/2,H/2,H,H)

						fundoPreto:addEventListener("touch",function() return true end)
						fundoPreto:setFillColor(0,0,0)
						fundoPreto.alpha = 0.5
						--grupoTexto:insert(fundoPreto)

						--local fundoBranco = display.newRect(W/2,H/2,600,1100)
						--fundoBranco:setFillColor(1,1,1)
						--grupoTexto:insert(fundoBranco)
						--fundoBranco:addEventListener("touch",function() return true end)
						--fundoBranco:addEventListener("tap",function() return true end)
						local alinhamento = "justificado"
						if atributos.alinhamento then
							alinhamento = atributos.alinhamento
						end

						local tamanho =30
						local largura = 720
						local margem = 80
						local orientacao = system.orientation
						if system.orientation == "landscapeRight" or system.orientation == "landscapeLeft" then
							tamanho = 45
							largura = 1180
							margem = 100
						end
						local textoAColocar = string.gsub(atributos.texto,"\\n","\n")
						local texto = colocarFormatacaoTexto.criarTextodePalavras({texto = textoAColocar,x = 0,Y = 0,fonte = "Fontes/segoeui.ttf",tamanho = tamanho + atributos.modificar,cor = {0,0,0},largura = largura,url = url, alinhamento = alinhamento,margem = margem,xNegativo = 0, modificou = 0, endereco = atributos.enderecoArquivos, tipoTTS = atributos.tipoTTS,temHistorico = telas.temHistorico})
						texto.y = 0--fundoBranco.y - fundoBranco.height/2 + 50--+ texto.height/2
						texto.x = -60
						if system.orientation == "landscapeRight" then
							texto.rotation = 90
							texto.x = 600
							texto.y = -80
						elseif system.orientation == "landscapeLeft" then
							texto.rotation = -90
							texto.x = 0
							texto.y = H-80
						end
						grupoTexto:insert(texto)

						local horizontalLock = true
						local verticalLock = false
						if orientacao ~= "portrait" and orientacao ~= "portraitUpsideDown" then
							horizontalLock = false
							verticalLock = true
						end
						local scrollView
						local function scrollListener( event )

							local phase = event.phase
							if ( phase == "began" ) then print( "Scroll view was touched" )
							elseif ( phase == "moved" ) then print( "Scroll view was moved" )
							elseif ( phase == "ended" ) then print( "Scroll view was released" )
							end

							-- In the event a scroll limit is reached...
							if ( event.limitReached ) then
								if ( event.direction == "up" ) then print( "Reached bottom limit" )
								elseif ( event.direction == "down" ) then print( "Reached top limit" )
								elseif ( event.direction == "left" ) then print( "Reached right limit" )
								elseif ( event.direction == "right" ) then print( "Reached left limit" )
								end
							end
							if orientacao == "landscapeRight" then
								local X,Y = scrollView:getContentPosition()
								if X < -texto.height - 50 then
									scrollView:scrollToPosition
									{
										x = -texto.height,
										time = 300
									}
								elseif X > -texto.height/2 + 50 then
									scrollView:scrollToPosition
									{
										x = -texto.height/2,
										time = 300
									}
								end
							end

							return true
						end
						scrollView = widget.newScrollView {
							left = 55-ox,
							top = 62,
							width = W+ox+ox-60-50,
							height = H-32-120,
							hideBackground = false,
							backgroundColor = { 240/255 },
							--isBounceEnabled = false,
							horizontalScrollDisabled = horizontalLock,
							verticalScrollDisabled = verticalLock,
							listener = scrollListener
						}
						scrollView:insert( texto )


						local function removerTudo()
							if scrollView.timer then
								timer.cancel(scrollView.timer)
								scrollView.timer = nil
							end
							scrollView:removeSelf();
							if texto.botaoAumentar then
								texto.botaoAumentar:removeSelf()
								texto.botaoAumentar = nil
							end

							timer.performWithDelay(1,function()
								fundoPreto:removeSelf();
								--[[local date = os.date( "*t" )
								local data = date.day.."/"..date.month.."/"..date.year
								local hora = date.hour..":"..date.min..":"..date.sec
								local pH = funcGlobal.pegarNumeroPaginaRomanosHistorico(varGlobal.PagH)
								local vetorJson = {
									tipoInteracao = "botao",
									pagina_livro = varGlobal.PagH,
									objeto_id = contBotao,
									acao = "fechar",
									subtipo = "de texto",
									tempo_aberto = botao.tempoAbertoNumero,
									relatorio = data.."| Fechou o texto do botão "..contBotao.." da página "..pH.. " às ".. hora.."."
								};
								if GRUPOGERAL.subPagina then
									vetorJson.subPagina = GRUPOGERAL.subPagina;
								end
								funcGlobal.escreverNoHistorico(varGlobal.HistoricoBotaoTextoFechou..contBotao,vetorJson);]]
								if botao.tempoAberto then
									timer.cancel(botao.tempoAberto)
									botao.tempoAberto = nil
								end
								botao.tempoAbertoNumero = 0
								auxFuncs.restoreNativeScreenElements()
							end,1);
							return true
						end

						local backButtonTelaAluno = widget.newButton {
							shape = "roundedRect",
							fillColor = { default={ 0.18, 0.67, 0.785, 1 }, over={ 0.004, 0.368, 0.467, 1 } },
							width = 250,
							height = 70,
							label = "voltar",
							fontSize = 50,
							strokeWidth = 5,
							labelColor = { default={ 0, 0, 0, 1 }, over={ 1, 1, 1, 1 } },
							onRelease = removerTudo
						}

						backButtonTelaAluno.anchorX=.5
						backButtonTelaAluno.x = W/2 - 60
						backButtonTelaAluno.y = texto.y + texto.height + 50
						if system.orientation == "landscapeRight" then
							scrollView:scrollToPosition
							{
								x = -texto.height,
								time = 100
							}
							texto.x = 600 + texto.height
							backButtonTelaAluno.rotation = 90
							backButtonTelaAluno.x = texto.x - texto.height - backButtonTelaAluno.height
							backButtonTelaAluno.y = H/2 - backButtonTelaAluno.height
						elseif system.orientation == "landscapeLeft" then
							backButtonTelaAluno.rotation = -90
							backButtonTelaAluno.x = texto.x + texto.height + backButtonTelaAluno.height
							backButtonTelaAluno.y = H/2 - backButtonTelaAluno.height
						end
						local timerOrientacao

						if scrollView.timer then
							timer.cancel(scrollView.timer)
							scrollView.timer = nil
						end
						local function mudarOrientacaoTexto(e)
							if orientacao ~= system.orientation then
								removerTudo();
								criarTexto(true)
							end
						end
						scrollView.timer = timer.performWithDelay(1000,mudarOrientacaoTexto,-1)


						local widget = require( "widget" )

						-- ScrollView listener

						scrollView:insert( backButtonTelaAluno )

						scrollView:addEventListener("touch",function() return true end)
						scrollView:addEventListener("tap",function() return true end)
						fundoPreto:addEventListener("tap",removerTudo)


						local function InterfaceAumentarLetra(evento)
							if texto.botaoAumentar then
								texto.botaoAumentar:removeSelf()
								texto.botaoAumentar = nil
							else
								local function mudarFonte(e)
									local condicao1 = e.x
									local condicao2 = (e.target.x)
									if condicao1 >= condicao2 then
										print("aumentar")
										atributos.modificar = atributos.modificar + 5
										removerTudo()
										criarTexto()
									elseif condicao1 < condicao2 then
										print("diminuir")
										atributos.modificar = atributos.modificar - 5
										removerTudo()
										criarTexto()
									end
									if texto.botaoAumentar then
										texto.botaoAumentar:removeSelf()
										texto.botaoAumentar = nil
									end
									return true
								end
								texto.botaoAumentar = botaoDeAumentarfunc(evento)
								texto.botaoAumentar.x = W/2
								texto.botaoAumentar:addEventListener("tap",mudarFonte)
								texto.botaoAumentar:addEventListener("touch",function()return true end)
							end
						end

						texto:addEventListener("tap",InterfaceAumentarLetra)
						if jaClicou == true then
							--[[local date = os.date( "*t" )
							local data = date.day.."/"..date.month.."/"..date.year
							local hora = date.hour..":"..date.min..":"..date.sec
							local pH = auxFuncs.pegarNumeroPaginaRomanosHistorico(atributos.numero)
							local vetorJson = {
								tipoInteracao = "botao",
								pagina_livro = atributos.numero,
								objeto_id = contBotao,
								acao = "abrir",
								subtipo = "de texto",
								relatorio = data.."| Clicou no botão "..contBotao.." de texto na página "..pH.. " às ".. hora.."."
							};
							if atributos.subPagina then
								vetorJson.subPagina = atributos.subPagina;
							end
							historicoLib.escreverNoHistorico(varGlobal.HistoricoBotaoTexto..contBotao,vetorJson)]]
							auxFuncs.clearNativeScreenElements()
						end
						if botao.tempoAberto then
							timer.cancel(botao.tempoAberto)
							botao.tempoAberto = nil
						end
						botao.tempoAbertoNumero = 0
						botao.tempoAberto = timer.performWithDelay(100,function() botao.tempoAbertoNumero = botao.tempoAbertoNumero + 100 end,-1)
					end
				end
				criarTexto(true)
			elseif botao.evento == "imagem" then
				local function ZoomImagem(e)
					--toqueHabilitado = false
					grupoZoom = display.newGroup()
					--print(e.target.zoom)
					local imagemoutra = "imagemErro.jpg"
					if atributos.imagem then
						imagemoutra = atributos.imagem
					end
					local telaPreta = display.newRect(0,0,W,H)
					telaPreta.anchorX = 0.5; telaPreta.anchorY = 0.5
					telaPreta.x = W/2; telaPreta.y = H/2
					telaPreta:setFillColor(1,1,1)
					telaPreta.alpha=0.7

					grupoZoom.imgFunc = display.newImage(imagemoutra,W/2,H/2)
					grupoZoom.imgFunc.anchorX = .5; grupoZoom.imgFunc.anchorY= .5

					grupoZoom.imgFunc.x=W/2;grupoZoom.imgFunc.y=H/2

					grupoZoom:insert(telaPreta)
					grupoZoom:insert(grupoZoom.imgFunc)
					grupoZoom.imgFunc:removeEventListener("tap",ZoomImagem)
					local texto = display.newText("IMAGEM",1,1,native.systemFont,50)
					texto.anchorX = 1; texto.anchorY = 1
					texto.x = W; texto.y = H
					texto:setFillColor(0,1,0)
					if system.orientation == "landscapeRight" then
						telaPreta.xScale = aspectRatio;telaPreta.yScale = aspectRatio;
						telaPreta.x = telaPreta.x + 100
						grupoZoom.xScale = aspectRatio;grupoZoom.yScale = aspectRatio;
						grupoZoom.rotation = 90
						grupoZoom.x = 0 + grupoZoom.height/2
						grupoZoom.y = 0
						texto.y = W/2 + 110
						texto.x = W - 90
						grupoZoom.imgFunc.x=W/2 ;grupoZoom.imgFunc.y=H/2- grupoZoom.imgFunc.height/2
					elseif system.orientation == "landscapeLeft" then
						telaPreta.xScale = aspectRatio;telaPreta.yScale = aspectRatio;
						grupoZoom.xScale = aspectRatio;grupoZoom.yScale = aspectRatio;
						grupoZoom.rotation = -90
						grupoZoom.x = 0
						grupoZoom.y = 0 + grupoZoom.width
						texto.y = W/2 + 110
						texto.x = W + 90
						grupoZoom.imgFunc.x=W/2+ grupoZoom.imgFunc.width/2;grupoZoom.imgFunc.y=H/2- grupoZoom.imgFunc.height/2
					else
						telaPreta.xScale = 1;telaPreta.yScale = 1;
						telaPreta.x = W/2; telaPreta.y = H/2;
						texto.x = W; texto.y = H
						grupoZoom.xScale = 1;grupoZoom.yScale = 1;
						grupoZoom.rotation = 0
						grupoZoom.x = 0
						grupoZoom.y = 0
						texto.x = W; texto.y = H
					end

					grupoZoom:insert(texto)
					local function rodarTelaZoom()
						if grupoZoom.imgFunc then
							girarTelaOrientacao(grupoZoom)
						end
					end

					function grupoZoom.imgFunc.mudarOrientation()
						if grupoZoom and telaPreta and grupoZoom.imgFunc then
							if system.orientation == "landscapeRight" then
								telaPreta.xScale = aspectRatio;telaPreta.yScale = aspectRatio;
								telaPreta.x = telaPreta.x + 100
								grupoZoom.xScale = aspectRatio;grupoZoom.yScale = aspectRatio;
								grupoZoom.rotation = 90
								grupoZoom.x = 0 + grupoZoom.height/2
								grupoZoom.y = 0
								texto.y = W/2 +250
								texto.x = W + 100
								grupoZoom.imgFunc.x=H/2- (grupoZoom.imgFunc.width/2);grupoZoom.imgFunc.y=W/2
							elseif system.orientation == "landscapeLeft" then
								telaPreta.xScale = aspectRatio;telaPreta.yScale = aspectRatio;
								grupoZoom.xScale = aspectRatio;grupoZoom.yScale = aspectRatio;
								grupoZoom.rotation = -90
								grupoZoom.x = 0
								grupoZoom.y = 0 + grupoZoom.width
								texto.y = W/2 + 110
								texto.x = W
								grupoZoom.imgFunc.y=W/2 ;grupoZoom.imgFunc.x=H/2 - (grupoZoom.imgFunc.width*aspectRatio/2)
							else
								telaPreta.xScale = 1;telaPreta.yScale = 1;
								telaPreta.x = W/2; telaPreta.y = H/2;
								texto.x = W; texto.y = H
								grupoZoom.xScale = 1;grupoZoom.yScale = 1;
								grupoZoom.rotation = 0
								grupoZoom.x = 0
								grupoZoom.y = 0
								texto.x = W; texto.y = H
							end
						end
					end
					Runtime:addEventListener("orientation",grupoZoom.imgFunc.mudarOrientation)
					local function removerImgFunc()
						Runtime:removeEventListener("orientation",grupoZoom.imgFunc.mudarOrientation)
						grupoZoom:removeEventListener("tap",removerImgFunc)
						grupoZoom:removeSelf()
						print("\n\nremoveu Zoom\n\n")
						--[[local date = os.date( "*t" )
						local data = date.day.."/"..date.month.."/"..date.year
						local hora = date.hour..":"..date.min..":"..date.sec
						local pH = funcGlobal.pegarNumeroPaginaRomanosHistorico(varGlobal.PagH)
						local vetorJson = {
							tipoInteracao = "botao",
							pagina_livro = varGlobal.PagH,
							objeto_id = contBotao,
							acao = "fechar",
							subtipo = "de imagem",
							relatorio = data.."| Clicou no botão "..contBotao.." de imagem na página "..pH.. " às ".. hora.."."

						};
						if GRUPOGERAL.subPagina then
							vetorJson.subPagina = GRUPOGERAL.subPagina;
						end
						funcGlobal.escreverNoHistorico(varGlobal.HistoricoBotaoImagemFechou..contBotao,vetorJson)--imagemoutra)]]
						return true
					end
					print("\n\ncriou Zoom\n\n")
					grupoZoom:addEventListener("touch",function() return true; end)
					timer.performWithDelay(100,function()grupoZoom:addEventListener("tap",removerImgFunc)end,1)


					grupoZoom.imgFunc.prevX=grupoZoom.imgFunc.x
					grupoZoom.imgFunc.prevY=grupoZoom.imgFunc.y
					grupoZoom.imgFunc.anchorChildren = true
					--zoomLib.loadIMageZoom(imgFunc)
					--funcGlobal.escreverNoHistorico(varGlobal.HistoricoZoomEfetuado..imagemoutra)
					if system.orientation ~= "portrait" then
						grupoZoom.imgFunc:addEventListener("touch",ZOOMZOOMZOOM)
					else
						grupoZoom:addEventListener("touch",ZOOMZOOMZOOM2)
					end
					--[[local date = os.date( "*t" )
					local data = date.day.."/"..date.month.."/"..date.year
					local hora = date.hour..":"..date.min..":"..date.sec
					local pH = funcGlobal.pegarNumeroPaginaRomanosHistorico(varGlobal.PagH)
					local vetorJson = {
						tipoInteracao = "botao",
						pagina_livro = varGlobal.PagH,
						objeto_id = contBotao,
						acao = "abrir",
						subtipo = "de imagem",
						relatorio = data.."| Fechou a imagem do botão "..contBotao.." da página "..pH.. " às ".. hora.."."
					};
					if GRUPOGERAL.subPagina then
						vetorJson.subPagina = GRUPOGERAL.subPagina;
					end
					funcGlobal.escreverNoHistorico(varGlobal.HistoricoBotaoImagem..contBotao,vetorJson)--imagemoutra)]]
					return true
				end
				ZoomImagem(e)

			end
			return true
	    end
		return true
	end
	--==============================================================================

	local TamanhoDaFonte = nil
	if atributos.titulo then
		if atributos.titulo.tamanho then
			TamanhoDaFonte = atributos.titulo.tamanho
		else
			TamanhoDaFonte = 40
		end
	end
	local TamaNhoBotao
	if W > H then
		TamaNhoBotao = W
	else
		TamaNhoBotao = H
	end

	local options = {
        width = TamaNhoBotao/3,
        height = TamaNhoBotao/9,
        defaultFile = atributos.fundoUp,
		overFile = atributos.fundoDown,
        label = "",
		fontSize = TamanhoDaFonte,
        onEvent = handleButtonEvent
    }
	if(atributos.x) then
		options.x = atributos.x;
	else
		options.x = W/2
	end
	if(atributos.y) then
		options.y = atributos.y;
	end

	if atributos.altura then
		options.height =atributos.altura;
	end
	if atributos.comprimento then
		options.width =atributos.comprimento;
	end
	if atributos.cor then
		options.fillColor = {default={ atributos.cor[1],atributos.cor[2],atributos.cor[3]},over = { atributos.cor[1],atributos.cor[2],atributos.cor[3],0.5}}
	end
	if atributos.titulo and atributos.titulo.cor then
		local auxRed = atributos.titulo.cor[1]
		local auxGreen = atributos.titulo.cor[2]
		local auxBlue = atributos.titulo.cor[3]
		local auxRv = 255 - auxRed
		local auxGv = 255 - auxGreen
		local auxBv = 255 - auxBlue
		options.labelColor = { default={ auxRed/255, auxGreen/255, auxBlue/255 }, over={ auxRv, auxGv, auxBv, 0.5 } }
	else
		options.labelColor = { default={ 1, 1, 1 }, over={ 0, 0, 0, 0.5 } }
	end



	local EventoDoBotao = {}
	if atributos.acao and #atributos.acao > 0 then
		for i=1,#atributos.acao do
			if string.find(string.lower(atributos.acao[i]),"irpara") or string.find(string.lower(atributos.acao[i]),"ir para") then
				table.insert(EventoDoBotao,"irPara")
			elseif string.find(string.lower(atributos.acao[i]),"som") then
				table.insert(EventoDoBotao,"som")
			elseif string.find(string.lower(atributos.acao[i]),"texto") then
				table.insert(EventoDoBotao,"texto")
			elseif string.find(string.lower(atributos.acao[i]),"video") then
				table.insert(EventoDoBotao,"video")
			elseif string.find(string.lower(atributos.acao[i]),"imagem") then
				table.insert(EventoDoBotao,"imagem")
			elseif string.find(string.lower(atributos.acao[i]),"selecionar material") then
				table.insert(EventoDoBotao,"selecionar material")
			end
		end
	end

	if #EventoDoBotao > 1 then
		if options.width and options.width > W/3 then
			options.width = W/3
		end
	end

	local botao = {}
	local grupoBotao = display.newGroup()
	print(atributos.tipo)
	for i=1,#EventoDoBotao do
		botao[i] = widget.newButton(options)
		grupoBotao:insert(botao[i])
		botao[i].evento = EventoDoBotao[i]
		if botao[i].evento == "irPara" then
			botao[i].numero = 1
			if atributos.numero then
				botao[i].numero = telas.contagemDaPaginaHistorico
			end
		else
			botao[i]:setLabel(botao[i].evento)
		end
		if botao[i].evento == "som" then
			if atributos.som then
				local som = audio.loadSound(atributos.som)
				audio.stop()

				local subPagina = telas.subPagina
				historicoLib.Criar_e_salvar_vetor_historico({
					tipoInteracao = "botao",
					pagina_livro = telas.pagina,
					objeto_id = contBotao,
					acao = "executar",
					subtipo = "de audio",
					automatico = true,
					subPagina = subPagina,
					tela = telas
				})

				local function onComplete( event )
					print( "audio session ended" )
					if event.completed then
						--atributos.som)

						local subPagina = telas.subPagina
						historicoLib.Criar_e_salvar_vetor_historico({
							tipoInteracao = "botao",
							pagina_livro = telas.pagina,
							objeto_id = contBotao,
							acao = "terminar",
							subtipo = "de audio",
							subPagina = subPagina,
							tela = telas
						})
					else
						--funcGlobal.escreverNoHistorico(varGlobal.HistoricoBotaoSomCancelou..contBotao)--atributos.som)
					end
					if atributos.avancar and atributos.avancar == "sim" then
						if event.completed then
							criarCursoAux(telas, paginaAtual+1)
							paginaAtual=paginaAtual+1
						end
					end
				end

				botao[i].pausarSom = function(e)
					if pAuSaDo == false and botao[i].som then
						audio.pause(botao[i].som)
						pAuSaDo = true
						--[[local date = os.date( "*t" )
						local data = date.day.."/"..date.month.."/"..date.year
						local hora = date.hour..":"..date.min..":"..date.sec
						local pH = funcGlobal.pegarNumeroPaginaRomanosHistorico(varGlobal.PagH)
						local vetorJson = {
							tipoInteracao = "botao",
							pagina_livro = varGlobal.PagH,
							objeto_id = contBotao,
							acao = "pausar",
							subtipo = "de audio",
							relatorio = data.."| Pausou o áudio do botão "..contBotao.." da página "..pH.. " às ".. hora.."."
						};
						if GRUPOGERAL.subPagina then
							vetorJson.subPagina = GRUPOGERAL.subPagina;
						end
						funcGlobal.escreverNoHistorico(varGlobal.HistoricoBotaoSomPausou..contBotao,vetorJson)--atributos.som)]]
					elseif botao[i].som then
						pAuSaDo = false
						audio.resume(botao[i].som)
						--[[local date = os.date( "*t" )
						local data = date.day.."/"..date.month.."/"..date.year
						local hora = date.hour..":"..date.min..":"..date.sec
						local pH = funcGlobal.pegarNumeroPaginaRomanosHistorico(varGlobal.PagH)
						local vetorJson = {
							tipoInteracao = "botao",
							pagina_livro = varGlobal.PagH,
							objeto_id = contBotao,
							acao = "despausar",
							subtipo = "de audio",
							relatorio = data.."| Despausou o áudio do botão "..contBotao.." da página "..pH.. " às ".. hora.."."
						};
						if GRUPOGERAL.subPagina then
							vetorJson.subPagina = GRUPOGERAL.subPagina;
						end
						funcGlobal.escreverNoHistorico(varGlobal.HistoricoBotaoSomDespausou..contBotao,vetorJson)--atributos.som)]]
					end
				end

				if atributos.automatico and atributos.automatico == "sim" then
					botao[i].som = audio.play(som, {onComplete = onComplete})
				end
			end
			if atributos.pause then
				--[[local optionsPause = options
				optionsPause.x = botao[i].x + botao[i].width + 5
				optionsPause.y = optionsPause.y -1
				optionsPause.shape = "roundedRect"
				optionsPause.fillColor = { default={ 0.18, 0.67, 0.785, 1 }, over={ 0.004, 0.368, 0.467, 1 } }
				optionsPause.width = botao[i].width/2
				optionsPause.height = botao[i].height
				optionsPause.label = "pause"
				optionsPause.fontSize = botao[i].height-10
				optionsPause.strokeWidth = 5
				optionsPause.labelColor = { default={ 0, 0, 0, 1 }, over={ 1, 1, 1, 1 } }
				optionsPause.onEvent = nil
				optionsPause.onRelease = botao[i].pausarSom
				local botaoPause = widget.newButton(optionsPause)
				botaoPause.anchorY = 0

				grupoBotao:insert(botaoPause)]]

				local optionsPause = options
				optionsPause.x = botao[i].x + botao[i].width + 5
				optionsPause.y = optionsPause.y -1
				local aux = string.sub(options.defaultFile,#options.defaultFile-3,#options.defaultFile)
				print("aux",aux)
				local aux2 = string.sub(options.defaultFile,1,#options.defaultFile-4)
				aux2 = aux2.."pause"..aux
				optionsPause.defaultFile = aux2
				local aux = string.sub(options.overFile,#options.overFile-3,#options.overFile)
				local aux2 = string.sub(options.overFile,1,#options.overFile-4)
				aux2 = aux2.."pause"..aux
				optionsPause.overFile = aux2
				print(aux2)
				optionsPause.onEvent = nil
				optionsPause.onRelease = botao[i].pausarSom
				local botaoPause = widget.newButton(optionsPause)
				botaoPause.anchorY = 0

				grupoBotao:insert(botaoPause)
			end
		end
		botao[i].anchorY = 0
		botao[i].clicado = false
		if atributos.titulo and #EventoDoBotao == 1 then
			botao[i]:setLabel( atributos.titulo.texto[i] )
			local texto = display.newText(atributos.titulo.texto[i],0,0,0,0,native.systemFontBold,options.fontSize)
			while texto.width > botao[i].width -10 do
				texto.size = texto.size-1
			end
			while texto.height > botao[i].height -1 do
				texto.size = texto.size-1
			end
			local novoTamanho = texto.size
			botao[i]._view._label.size = novoTamanho
			texto:removeSelf()
		end
		botao[i].setDefaultFile =atributos.fundoUp
		botao[i].setOverFile =atributos.fundoDown
		if atributos.titulo then
			botao[i].fontSize = TamanhoDaFonte
		end
	end
	local distanciaHorizontal = 10
	local distanciaVertical = 10
	if  #EventoDoBotao > 1 then
		if #EventoDoBotao == 2 then
			botao[1].x = W/3 - distanciaHorizontal/2
			botao[2].x = 2*W/3 + distanciaHorizontal/2
		elseif #EventoDoBotao == 3 then
			botao[1].x = W/3 - distanciaHorizontal/2
			botao[2].x = 2*W/3 + distanciaHorizontal/2
			botao[3].y = botao[2].y + botao[2].height + distanciaVertical
		elseif #EventoDoBotao == 4 then
			botao[1].x = W/3 -distanciaHorizontal/2
			botao[2].x = 2*W/3 + distanciaHorizontal/2
			botao[3].x = W/3 -distanciaHorizontal/2
			botao[4].x = 2*W/3 + distanciaHorizontal/2
			botao[3].y = botao[2].y + botao[2].height + distanciaVertical
			botao[4].y = botao[2].y + botao[2].height + distanciaVertical
		end
	end
	if options.y == nil then
		grupoBotao.YY = 0
	else
		grupoBotao.YY = options.y
	end
	if atributos.index then grupoBotao.index = atributos.index end
	return grupoBotao
end

----------------------------------------------------------------------
--	COLOCAR IMAG E TEXT												--
--	Funcao responsavel por colocar uma imagem e texto				--
--  na tela															--
--  ATRIBUTOS: arquivo,comprimento,altura,x,y,*posicao				--
--  *Posicao: (base, centro, topo), zoom (sim ou nao),urlImagem 	--
--  ATRIBUTOS: texto, url, tamanho, eNegrito,*posicao,*fonte,cor    --
--  distância (texto da imagem)
--  *Posicao: topo, centro, base	  								--
--  *Fonte: arial, times, calibri   								--
--  alinhamento: esquerda, direita, meio, justificado				--
----------------------------------------------------------------------

function M.colocarImagemTexto(atributos,telas)
	local temImagem = false
	local grImText = display.newGroup()
	if auxFuncs.naoVazio(atributos) then
		if not atributos.y then atributos.y = 0 end
		if(atributos.arquivo) then
			temImagem = true
			grImText.imagem = display.newImage(atributos.arquivo,system.ResourceDirectory)
			grImText:insert(grImText.imagem)
			grImText.imagem.anchorX,grImText.imagem.anchorY = 0,0

			local XX = 0
			local YY = 0
			if atributos.x then
				XX=atributos.x
			end
			if atributos.y then
				YY=atributos.y
			end



			if(string.find(atributos.posicao,'esquerda')) then
				grImText.imagem.anchorX=0;
				grImText.imagem.anchorY=0;
				grImText.imagem.x = XX
				grImText.imagem.y = YY
			--POSICAO BASE
			elseif(string.find(atributos.posicao,'direita')) then
				grImText.imagem.anchorX=0;
				grImText.imagem.anchorY=0;
				grImText.imagem.x = W - grImText.imagem.width
				grImText.imagem.y = YY
			else
				grImText.imagem.anchorX=0;
				grImText.imagem.anchorY=0
				grImText.imagem.x = XX
				grImText.imagem.y = YY
			end
			if atributos.altura and atributos.comprimento then

				local auxiliarW = grImText.imagem.width
				local auxiliarH = grImText.imagem.height
				local aux2 = W/grImText.imagem.width
				grImText.imagem.width = (aux2*grImText.imagem.width)/2
				grImText.imagem.height = (aux2*grImText.imagem.height)/2
				--print("portrait")
				end
			if(atributos.urlImagem) then
				local function onClickLink(event)
					system.openURL(atributos.urlImagem)
				end
				grImText.imagem:addEventListener('tap', onClickLink)
			end
			if (atributos.comprimento) then
				grImText.imagem.width=atributos.comprimento;
			end
			if (atributos.altura) then
				grImText.imagem.height=atributos.altura
			end
			if atributos.zoom then
				grImText.imagem.zoom = atributos.zoom
			else
				grImText.imagem.zoom = "sim"
			end

		end
		---------------------------------------------------------
		-- TEXTO DA IMAGEM --------------------------------------
		---------------------------------------------------------
		local XXX
		local YYY
		if temImagem == true then
			atributos.xO = atributos.x
			--atributos.x = (atributos.x + imagem.width)/2 + 5
			--atributos.y = imagem.y
		end
		local function mudarTamanhoGrupo(texto,grupoTamanho)
			local aux = texto.y + texto.height + 40
			if aux > grupoTamanho then
				grupoTamanho = aux
			end

			return grupoTamanho
		end
		local textoASerUsado = atributos.texto--conversor.converterANSIparaUTFsemBoom(atributos.texto)

		if JaConveRTEU == false then
			--atributos.texto = conversor.converterANSIparaUTFsemBoom(atributos.texto)
			--JaConveRTEU = true
		end
		if auxFuncs.naoVazio(atributos) then
			grImText.tamanho = 0
			local options =
			{
				text = "",
				x = (W/2)+20,
				y = H/2,
				width = W-20,
				height = 0,
				font = native.systemFont,
				fontSize = 20,
				align = "center"
			}

			--FONTES
			if(atributos.fonte =='Fontes/arial') then
				options.font = 'arial.ttf'
			elseif(atributos.fonte=='times') then
				options.font = 'Fontes/times.ttf'
			elseif atributos.fonte then
				if string.find(atributos.fonte, ".ttf") ~= nil then
					options.font = atributos.fonte
				end
			end

			if(atributos.tamanho) then
				options.fontSize = atributos.tamanho*1.5;
			end

			if atributos.eNegrito then
				if atributos.eNegrito=='sim' then
					if atributos.fonte then
						if(atributos.fonte =='arial') then
							options.font = 'Fontes/arialbd.ttf'
						elseif(atributos.fonte=='times') then
							options.font = 'Fontes/timesbd.ttf'
						end

					else
						options.font = native.systemFontBold;
					end
				elseif string.find(atributos.eNegrito, ".ttf") ~= nil then
					options.font = atributos.eNegrito
				end
			end


			if(atributos.texto) then
				local r,g,b
				if not atributos.cor then
					r,g,b = 0,0,0
				else
					r = atributos.cor[1]/255; g = atributos.cor[2]/255; b = atributos.cor[3]/255
				end
				if not atributos.x then
					atributos.x = 0
				end
				local xNegativo = 0
				if atributos.x and atributos.x < 0 then
					xNegativo = atributos.x
					grImText.imagem.x = grImText.imagem.x + xNegativo
				end
				if not atributos.y then
					atributos.y = 0
				end
				if not atributos.tamanho then
					atributos.tamanho = 30
				end
				if not atributos.alinhamento then
					atributos.alinhamento = "meio"
				end
				if not atributos.urlEmbeded then
					atributos.urlEmbeded = "nao"
				end
				if not atributos.distancia then
					atributos.distancia = 0
				end
				--atributos.margem = 60

				local largurax = 720
				local XX = atributos.x
				--atributos.margem = 60
				if atributos.margem then
					if atributos.posicao == "esquerda" then
						grImText.imagem.x = grImText.imagem.x + atributos.margem
					elseif atributos.posicao == "direita" then
						grImText.imagem.x = largurax - atributos.margem - grImText.imagem.width + xNegativo
					end
				else
					atributos.margem = 0
				end

				local imagemWidth = grImText.imagem.width + atributos.distancia
				largurax = largurax - 5


				grImText.texto = colocarFormatacaoTexto.criarTextodePalavras({texto = textoASerUsado,x = atributos.x,Y = grImText.imagem.y,fonte = options.font,tamanho = options.fontSize,cor = {r,g,b},largura = largurax,url = atributos.urlTexto, alinhamento = atributos.alinhamento,posicao = atributos.posicao,imagemW = imagemWidth ,imagemH = grImText.imagem.height,margem = atributos.margem, xNegativo = xNegativo, embeded = atributos.urlEmbeded, endereco = atributos.enderecoArquivos, tipoTTS = atributos.tipoTTS,temHistorico = telas.temHistorico})
				grImText:insert(grImText.texto)
				print("findThales")
				print(imagemWidth)
				print(grImText.texto.width/2)
				print(atributos.margem)
				print(W/2 - grImText.texto.width/2 - atributos.margem)
				print(atributos.alinhamento)
				print(atributos.posicao)
				if imagemWidth < W/2 - grImText.texto.width/2 - atributos.margem and atributos.alinhamento == "meio" then
					if atributos.posicao == "esquerda" then
						grImText.imagem.x = W/2 - grImText.texto.width/2 - imagemWidth
					elseif atributos.posicao == "direita" then
						grImText.imagem.x = W/2 + grImText.texto.width/2 + imagemWidth
					end

				end


				grImText.tamanho = mudarTamanhoGrupo(grImText.texto,grImText.tamanho)
			end
			local function fecharSite()
				webView:removeSelf()
				botaoFechar:removeSelf()
				return true
			end
			if(atributos.urlEmbeded) then
				local function onClickEnter(event)
					webView = native.newWebView( display.contentCenterX, display.contentCenterY, 700, 900 )
					webView:request( atributos.urlEmbeded )
					grImText.tamanho = mudarTamanhoGrupo(webView,grImText.tamanho)
					grImText:insert(webView)
					botaoFechar = display.newRoundedRect(W/2 + 270,H/2 + 720,50,50,5)
					botaoFechar:setFillColor(.7,.7,.7);botaoFechar.strokeWidth = 5; botaoFechar:setStrokeColor(0.4,0.4,0.4)
					botaoFechar.texto = display.newText("X",botaoFechar.x,botaoFechar.y,native.systemFont,40)
					botaoFechar:addEventListener("tap",fecharSite)
					grImText:insert(botaoFechar)
					grImText:insert(botaoFechar.texto)
					grImText.tamanho = mudarTamanhoGrupo(botaoFechar,grImText.tamanho)
				end
				grImText.texto:addEventListener('tap', onClickEnter)
			end

		end

	end
	if grImText.imagem then
		grImText.yy = grImText.imagem.y
	else
		grImText.yy = atributos.y
	end
	grImText.tipo = "imgText"
	if atributos.index then grImText.index = atributos.index end
	return grImText
end

----------------------------------------------------------------------
--	COLOCAR ESPAÇO 													--
-- função responsável por adicionar um espaço em  branco			--
-- ATRIBUTOS: numero (de espaços de 10 pixels)						--
----------------------------------------------------------------------
function M.colocarEspaco(atributos)
	local YY = 0
	local XX = W/2
	local espaccos = 10
	if not atributos.y then atributos.y = 0 end
	if atributos and type(atributos) == "table" then
		if atributos.y then
			YY = atributos.y
		end
		if atributos.distancia then
			espaccos = atributos.distancia
		else
			espaccos = 10
		end
	end

	local vetor = display.newRect(0,0,0,0)
	vetor.anchorX = 0; vetor.anchorY = 0
	vetor.width = 10; vetor.height = espaccos
	vetor.isVisible = false
	vetor.x = XX
	vetor.y = YY

	if atributos.index then vetor.index = atributos.index end
	return vetor
end

----------------------------------------------------------------------
--	COLOCAR SEPARADOR 												--
-- função responsável por adicionar um Separador retangular			--
-- ATRIBUTOS: espessura, cor, largura								--
----------------------------------------------------------------------
function M.colocarSeparador(atributos)
	local YY = 0
	local XX = W/2
	local espessura = 5
	local cor = {0,0,0}
	local largura = W
	
	if not atributos.y then atributos.y = 0 end
	if atributos and type(atributos) == "table" then
		if atributos.y then
			YY = atributos.y
		end
		if atributos.espessura then
			espessura = atributos.espessura
		end
		if atributos.largura and type(tonumber(atributos.largura)) == "number" then
			largura = tonumber(atributos.largura)
		end
		if atributos.margem and largura == W then 
			largura = largura - atributos.margem*2
		end
		if atributos.cor and type(atributos.cor) == "table" then
			if atributos.cor[1] and type(tonumber(atributos.cor[1])) == "number" then
				cor[1] = tonumber(atributos.cor[1])/255
			end
			if atributos.cor[2] and type(tonumber(atributos.cor[2])) == "number" then
				cor[2] = tonumber(atributos.cor[2])/255
			end
			if atributos.cor[3] and type(tonumber(atributos.cor[3])) == "number" then
				cor[3] = tonumber(atributos.cor[3])/255
			end
		end
	end

	local separadorx = display.newRect(XX,YY,largura,espessura)
	separadorx.anchorY = 0;separadorx.anchorX = 0.5
	separadorx:setFillColor(cor[1],cor[2],cor[3])

	if atributos.index then separadorx.index = atributos.index end
	return separadorx
end

----------------------------------------------------------------------
--	COLOCAR FUNDO													--
-- função responsável por adicionar um fundo estático na página		--
-- ATRIBUTOS: arquivo, cor											--
----------------------------------------------------------------------
function M.colocarFundo(atributos)
	local fundo = display.newGroup()
	if atributos and type(atributos) == "table" then
		local altura = atributos.altura or H
		local largura = atributos.largura or W
		local cor = atributos.cor or {168,16,16}
		local arquivo = atributos.arquivo or nil
		
		if cor and type(cor) == "table" then
			if cor[1] and type(tonumber(cor[1])) == "number" and cor[1] > 1 then
				cor[1] = tonumber(atributos.cor[1])/255
			end
			if cor[2] and type(tonumber(cor[2])) == "number" and cor[2] > 1 then
				cor[2] = tonumber(atributos.cor[2])/255
			end
			if cor[3] and type(tonumber(cor[3])) == "number" and cor[3] > 1 then
				cor[3] = tonumber(atributos.cor[3])/255
			end
		end
		
		if arquivo then
			fundo.img = display.newImageRect(arquivo,largura,altura)
			if fundo.img then
				fundo.img.anchorY = 0.5;fundo.img.anchorX = 0.5
				fundo.img.x,fundo.img.y = W/2,H/2
				fundo:insert(fundo.img)
			end
			
		end
		fundo.rect = display.newRect(W/2,H/2,largura,altura)
		fundo.rect:setFillColor(cor[1],cor[2],cor[3])
		fundo.rect.anchorY = 0.5;fundo.rect.anchorX = 0.5
		fundo:insert(fundo.rect)
	end

	if atributos and atributos.index then fundo.index = atributos.index end
	return fundo
end


----------------------------------------------------------------------
--	COLOCAR TEXTO 													--
--	Funcao responsavel por criar um texto 							--
--  de acordo com as opcoes desejadas e acoes pre-definidas			--
--  ATRIBUTOS: texto, url, tamanho, eNegrito,*posicao,*fonte,cor    --
--  *Posicao: topo, centro, base	  								--
--  *Fonte: arial, times, calibri   								--
--  alinhamento: esquerda, direita, meio, justificado				--
----------------------------------------------------------------------
function M.mudarFonte(atrib,telas,GRUPOGERAL,Var,criarCursoAux, paginaAtual,PagH)
	aumentouOSom = true

	local tempo
	GRUPOGERAL.mudancaTamanho = 0
	local function rodarPaginaAumentada(atrib,telas)

		if atrib.acao == "aumentar" then
			local pH = auxFuncs.pegarNumeroPaginaRomanosHistorico(PagH)
			
			local subPagina = GRUPOGERAL.subPagina
			historicoLib.Criar_e_salvar_vetor_historico({
				tipoInteracao = "texto",
				pagina_livro = pH,
				objeto_id = atrib.contador,
				acao = "aumentar",
				tamanho_anterior = telas[paginaAtual].textos[atrib.contador].tamanho,
				tamanho_novo = telas[paginaAtual].textos[atrib.contador].tamanho + 5,
				subPagina = subPagina,
				tela = telas
			})
		elseif atrib.acao == "diminuir" then
			local pH = auxFuncs.pegarNumeroPaginaRomanosHistorico(PagH)
			local subPagina = GRUPOGERAL.subPagina
			historicoLib.Criar_e_salvar_vetor_historico({
				tipoInteracao = "texto",
				pagina_livro = pH,
				objeto_id = atrib.contador,
				acao = "diminuir",
				tamanho_anterior = telas[paginaAtual].textos[atrib.contador].tamanho,
				tamanho_novo = telas[paginaAtual].textos[atrib.contador].tamanho + 5,
				subPagina = subPagina,
				tela = telas
			})
		end
		local function funcaoMudarTamanhoGenerica(e,txt,tipo)
			local auxtamanho
			local auxsubtamanho
			local mudancaTamanho

			local textoY = telas[paginaAtual].textos[txt].y

			if atrib.acao == "aumentar" then
				if telas[paginaAtual].textos and telas[paginaAtual].textos[txt].tamanho then
					auxtamanho = telas[paginaAtual].textos[txt].tamanho
					auxsubtamanho = telas[paginaAtual].textos[txt].subtituloTamanho
					telas[paginaAtual].textos[txt].tamanho = auxtamanho + 5
					if telas[paginaAtual].textos[txt].modificou then
						telas[paginaAtual].textos[txt].modificou = telas[paginaAtual].textos[txt].modificou + 5
					else
						telas[paginaAtual].textos[txt].modificou = 5
					end
					if telas[paginaAtual].textos[txt].subtitulo then
						telas[paginaAtual].textos[txt].subtituloTamanho = auxsubtamanho + 5
					end
					local textoTeste = M.colocarTexto(telas[paginaAtual].textos[txt],telas)
					mudancaTamanho = textoTeste.height - Var.textos[txt].height
					textoTeste:removeSelf()
				end
			elseif atrib.acao == "diminuir" then
				if telas[paginaAtual].textos and telas[paginaAtual].textos[txt].tamanho then
					auxtamanho = telas[paginaAtual].textos[txt].tamanho
					auxsubtamanho = telas[paginaAtual].textos[txt].subtituloTamanho
					telas[paginaAtual].textos[txt].tamanho = auxtamanho - 5
					if telas[paginaAtual].textos[txt].modificou then
						telas[paginaAtual].textos[txt].modificou = telas[paginaAtual].textos[txt].modificou - 5
					else
						telas[paginaAtual].textos[txt].modificou = -5
					end
					if telas[paginaAtual].textos[txt].subtitulo then
						telas[paginaAtual].textos[txt].subtituloTamanho = auxsubtamanho - 5
					end
					local textoTeste = M.colocarTexto(telas[paginaAtual].textos[txt],telas)
					mudancaTamanho = textoTeste.height - Var.textos[txt].height
					textoTeste:removeSelf()
				end
			end
			if telas[paginaAtual].textos then
				for i=1,#telas[paginaAtual].textos do
					if telas[paginaAtual].textos[i].index > telas[paginaAtual].textos[txt].index then
						Var.textos[i].y = Var.textos[i].y + mudancaTamanho
					end
				end
			end
			if telas[paginaAtual].imagens then
				for i=1,#telas[paginaAtual].imagens do
					if telas[paginaAtual].imagens[i].index > telas[paginaAtual].textos[txt].index then
						Var.imagens[i].y = Var.imagens[i].y + mudancaTamanho
					end
				end
			end
			if telas[paginaAtual].exercicios then
				for i=1,#telas[paginaAtual].exercicios do
					if telas[paginaAtual].exercicios[i].index > telas[paginaAtual].textos[txt].index then
						Var.exercicios[i].y = Var.exercicios[i].y + mudancaTamanho
					end
				end
			end	
			if telas[paginaAtual].videos then
				for i=1,#telas[paginaAtual].videos do
					if telas[paginaAtual].videos[i].index > telas[paginaAtual].textos[txt].index then
						Var.videos[i].y = Var.videos[i].y + mudancaTamanho
					end
				end
			end
			if telas[paginaAtual].animacoes then
				for i=1,#telas[paginaAtual].animacoes do
					if telas[paginaAtual].animacoes[i].index > telas[paginaAtual].textos[txt].index then
						Var.animacoes[i].y = Var.animacoes[i].y + mudancaTamanho
					end
				end
			end
			if telas[paginaAtual].botoes then
				for i=1,#telas[paginaAtual].botoes do
					if telas[paginaAtual].botoes[i].index > telas[paginaAtual].textos[txt].index then
						Var.botoes[i].y = Var.botoes[i].y + mudancaTamanho
					end
				end
			end
			if telas[paginaAtual].imagemTextos then
				for i=1,#telas[paginaAtual].imagemTextos do
					if telas[paginaAtual].imagemTextos[i].index > telas[paginaAtual].textos[txt].index then
						Var.imagemTextos[i].y = Var.imagemTextos[i].y + mudancaTamanho
					end
				end
			end
			if telas[paginaAtual].sons then
				for i=1,#telas[paginaAtual].sons do
					if telas[paginaAtual].sons[i].index > telas[paginaAtual].textos[txt].index then
						Var.sons[i].y = Var.sons[i].y + mudancaTamanho
					end
				end
			end
			if telas[paginaAtual].espacos then
				for i=1,#telas[paginaAtual].espacos do
					if telas[paginaAtual].espacos[i].index > telas[paginaAtual].textos[txt].index then
						Var.espacos[i].y = Var.espacos[i].y + mudancaTamanho
					end
				end
			end
			if telas[paginaAtual].separadores then
				for i=1,#telas[paginaAtual].separadores do
					if telas[paginaAtual].separadores[i].index > telas[paginaAtual].textos[txt].index then
						Var.separadores[i].y = Var.separadores[i].y + mudancaTamanho
					end
				end
			end
	
		end
		if telas[paginaAtual].textos then
			for i=1,#telas[paginaAtual].textos do
				funcaoMudarTamanhoGenerica(atrib.event,i,"texto")
			end
		end
		tempo = nil
		criarCursoAux(telas, paginaAtual)
		--e.target:removeSelf()
		--toqueHabilitado = true
		--grupoTravarTela:removeSelf()
	end

	tempo = timer.performWithDelay(100,function()rodarPaginaAumentada(atrib,telas); end,1)
	return true
end


function M.colocarTexto(atributos,tela)

	local modificou = 0

	if atributos.modificou then
		modificou = atributos.modificou*1.5
	end
	local function mudarTamanhoGrupo(texto,grupoTamanho)
		local aux = texto.y + texto.height + 40
		if aux > grupoTamanho then
			grupoTamanho = aux
		end

		return grupoTamanho
	end
	local textoASerUsado = atributos.texto

	if not atributos.y then atributos.y = 0 end

	local function lerArquivo(fileName)
		local path = system.pathForFile( fileName, system.ResourceDirectory )
		local contents
		-- Open the file handle
		local file, errorString = io.open( path, "r" )

		if not file then
			-- Error occurred; output the cause
			print( "File error: " .. errorString )
		else
			-- Read data from file
			contents = file:read( "*a" )
			-- Output the file contents
			--print( "Contents of " .. path .. "\n" .. contents )
			-- Close the file handle
			io.close( file )
		end
		return contents
	end
	if atributos.arquivo then
		atributos.texto = lerArquivo(atributos.arquivo)
	end
	if auxFuncs.naoVazio(atributos) then
		grupoTexto = display.newGroup()
		if atributos.y then
			grupoTexto.y = atributos.y
		end
		grupoTexto.tamanho = 0
		local options =
		{
		    text = "",
		    x = (W/2)+20,
		    y = 0,
		    width = W-20,
		    height = 0,
		    font = "Fontes/arial.ttf",
		    fontSize = 20,
		    align = "center"
		}

		local options2 =
		{
		    text = "",
		    x = (W/2)+20,
		    y = 0,
		    width = W-20,
		    height = 0,
		    font = "Fontes/arial.ttf",
		    fontSize = 20,
		    align = "center"
		}
		--ALINHAMENTO ESQUERDA
		if(atributos.alinhamento=='esquerda') then
			options.align = "left"
		--ALINHAMENTO DIREITA
		elseif(atributos.alinhamento=='direita') then
			options.align = "right"
		--ALINHAMENTO MEIO
		elseif(atributos.alinhamento=='meio') then
			options.align = "center"
		end
		if(atributos.alinhamentoSub=='esquerda') then
			options2.align = "left"
		--ALINHAMENTO DIREITA
		elseif(atributos.alinhamentoSub=='direita') then
			options2.align = "right"
			options2.width = W/2 + W/10
		--ALINHAMENTO MEIO
		elseif(atributos.alinhamentoSub=='meio') then
			options2.align = "center"
		end
		--FONTES
		if(atributos.fonte =='Fontes/arial') then
			options.font = 'arial.ttf'
		elseif(atributos.fonte=='times') then
			options.font = 'Fontes/times.ttf'
		elseif atributos.fonte then
			if string.find(atributos.fonte, "%.ttf") ~= nil or string.find(atributos.fonte, "%.otf") ~= nil then
				options.font = atributos.fonte
			end
		end
		if(atributos.x) then
			options.x = atributos.x
		end
		if(atributos.texto) then
			options.text = conversor.converterANSIparaUTFsemBoom(atributos.texto)
			--options.text = atributos.texto;

		end
		
		if(atributos.tamanho) then
			options.fontSize = atributos.tamanho*1.5;
		end
		if atributos.eNegrito then
			if atributos.eNegrito=='sim' then
				if atributos.fonte then
					if(atributos.fonte =='arial') then
						options.font = 'Fontes/arialbd.ttf'
					elseif(atributos.fonte=='times') then
						options.font = 'Fontes/timesbd.ttf'
					end

				else
					options.font = "Fontes/arialbd.ttf";
				end
			elseif string.find(atributos.eNegrito, "%.ttf") ~= nil or string.find(atributos.eNegrito, "%.otf") ~= nil then
				options.font = atributos.eNegrito
			end
		end
		local fillColorx = { 0, 0.2, 0.13 }
		if atributos.fundo and atributos.fundo == "preto" then
			fillColorx = {1,1,1};
		end
		if(atributos.cor) then
			r = atributos.cor[1]/255; g = atributos.cor[2]/255; b = atributos.cor[3]/255
			fillColorx = {r,g,b};
		end
		local texto
		grupoTexto.texto = display.newText( options )
		grupoTexto.texto.anchorY = 0
		grupoTexto.texto:setFillColor(fillColorx[1],fillColorx[2],fillColorx[3])
		if(atributos.alinhamento=='direita') then
			grupoTexto.texto.x = grupoTexto.texto.x - 10
		end
		
		grupoTexto.tamanho = mudarTamanhoGrupo(grupoTexto.texto,grupoTexto.tamanho)
		if(atributos.y) then
			grupoTexto.texto.anchorY = 0
		end
		grupoTexto:insert(grupoTexto.texto)
		
		local contTexto = atributos.contTexto
		if(atributos.texto) then
			local r,g,b
			if not atributos.cor then
				r,g,b = 0,0,0
			else
				r = atributos.cor[1]/255; g = atributos.cor[2]/255; b = atributos.cor[3]/255
			end
			if not atributos.x then
				atributos.x = 0
			end
			local xNegativo = 0
			if atributos.x and atributos.x < 0 then
				xNegativo = atributos.x
			end
			if not atributos.y then
				atributos.y = 0
			end
			if not atributos.tamanho then
				atributos.tamanho = 30
			end
			if not atributos.alinhamento then
				atributos.alinhamento = "meio"
			end
			if not atributos.urlEmbeded then
				atributos.urlEmbeded = "nao"
			elseif type(atributos.urlEmbeded) == "string" and string.find(atributos.urlEmbeded,"sim") then
				atributos.urlEmbeded = "sim"
			end
			local colocarFormatacaoTexto = require "colocarFormatacaoTexto"

			local largurax = W-5

			if not atributos.margem then
				atributos.margem = 0
			end
			
			if not atributos.espacamento then
				atributos.espacamento = 0
			end

			grupoTexto.texto:removeSelf()
			
			local function mudarTamanhoFonte(atrib)
				atrib.contElemento = atributos.contElemento
				if grupoTexto.mudarTamanhoFontePagina then
					grupoTexto.mudarTamanhoFontePagina(atrib,tela)
				else
					grupoTexto.mudarTamanhoFonte(atrib,tela)
				end
			end
			if not tela then
				tela = {}
			end
			grupoTexto.texto = colocarFormatacaoTexto.criarTextodePalavras({tela = tela,texto = textoASerUsado,x = atributos.x,Y = 0,fonte = options.font,tamanho = options.fontSize,cor = {r,g,b},largura = largurax,url = atributos.url, alinhamento = atributos.alinhamento,margem = atributos.margem,xNegativo = xNegativo, modificou = modificou, embeded = atributos.urlEmbeded,historicoTexto = tela.paginaHistorico, endereco = atributos.enderecoArquivos, contTexto = contTexto,whenOpenedURL = tela.clearNativeScreenElements,whenClosedURL = tela.restoreNativeScreenElements,mudarTamanhoFonte = mudarTamanhoFonte,EhIndice = false,dic = atributos.dicPalavras,temHistorico = tela.temHistorico,card = atributos.card,espacamento = atributos.espacamento})
			
			if atributos.sombra then
				local corS = {0,0,0,.5}
				if atributos.corSombra then
					local corSombra = atributos.corSombra
					if type(corSombra) == "table" then
						if corSombra[1] and type(tonumber(corSombra[1])) == "number" and corSombra[1] > 1 then
							corS[1] = tonumber(corSombra[1])/255
						end
						if corSombra[2] and type(tonumber(corSombra[2])) == "number" and corSombra[2] > 1 then
							corS[2] = tonumber(atributos.corSombra[2])/255
						end
						if corSombra[3] and type(tonumber(corSombra[3])) == "number" and corSombra[3] > 1 then
							corS[3] = tonumber(atributos.corSombra[3])/255
						end
						if corSombra[4] and type(tonumber(corSombra[4])) == "number" and corSombra[4] >= 0 and corSombra[4] <= 1 then
							corS[4] = tonumber(atributos.corSombra[4])
						end
					end
				end
				
				grupoTexto.textoS = colocarFormatacaoTexto.criarTextodePalavras({tela = tela,texto = textoASerUsado,x = atributos.x,Y = 0,fonte = options.font,tamanho = options.fontSize,cor = corS,largura = largurax, alinhamento = atributos.alinhamento,margem = atributos.margem,xNegativo = xNegativo, modificou = modificou,EhIndice = false,temHistorico = false,espacamento = atributos.espacamento,sombra = true,corSombra = corS})
				
				grupoTexto.textoS.x = grupoTexto.texto.x + atributos.sombra[1]
				grupoTexto.textoS.y = grupoTexto.texto.y + atributos.sombra[2]
				grupoTexto.textoS.alpha = corS[4]
				grupoTexto:insert(grupoTexto.textoS)
			end
			
			grupoTexto:insert(grupoTexto.texto)

			grupoTexto.tamanho = mudarTamanhoGrupo(grupoTexto.texto,grupoTexto.tamanho)

		end
		
		--grupoTexto.texto = texto
		grupoTexto.yy = atributos.y
		
		if atributos.index then grupoTexto.index = atributos.index end
		return grupoTexto
	end
end


--------------------------------------------------
--	COLOCAR VIDEO 								--
--	Funcao responsavel por tocar um Video 		--
--  de acordo com arquivo: (mp4,mov, m4v) 		--
--	ATRIBUTOS: arquivo 	,tipo, largura, altura	--
--	velocidade, url							--
--  *¨tipo = local,player,incorporado			--
--------------------------------------------------
function M.colocarVideo(atributos,telas)
	if auxFuncs.naoVazio(atributos) then
		local contVideo = 1
		if telas[paginaAtual] and telas[paginaAtual].cont then
			contVideo = telas[paginaAtual].cont.videos
		end
		if not atributos.y then atributos.y = 0 end
		local grupoVideo = display.newGroup()
		if(atributos.arquivo or atributos.url) then

			if atributos.tipo == "local" or atributos.tipo == "incorporado" then
				local largura
				local altura
				local velocidade = 10
				local function videoListener(e)
					if e.errorCode then
						native.showAlert("Erro!", e.errorMessage, {"OK"})
					end
					if e.phase == "ended" then
						if tempoLoading then
							timer.cancel(tempoLoading)
						end
						if tempoLoading then
							tempoLoading:removeSelf()
						end
						if loading then
							loading:removeSelf()
						end
						vide0:removeSelf()
						botaOPausar.isVisible = false
						botaOPausar.isHitTestable = false
						botaORodar.isVisible = true
					end
				end
				local function pausarRodarVideo(e)
					if e.target.tipo == "pause" then
						vide0:pause()
						botaORodar.isVisible = true
						botaORodar.isHitTestable = true
						botaOPausar.isVisible = false
						botaOPausar.isHitTestable = false
					elseif e.target.tipo == "play" then
						vide0:play()
						botaORodar.isVisible = false
						botaORodar.isHitTestable = false
						botaOPausar.isVisible = true
						botaOPausar.isHitTestable = true
					elseif e.target.tipo == "forward" then
						local tempolimite = vide0.currentTime +velocidade
						if vide0.totalTime <= tempolimite then
							vide0:seek(vide0.totalTime)
						else
							local praFrente = vide0.currentTime + velocidade
							vide0:seek(praFrente)
						end
					elseif e.target.tipo == "backward" then
						if vide0.currentTime <= velocidade then
							vide0:seek(0)
						else
							local praTras = vide0.currentTime - velocidade
							vide0:seek(praTras)
						end
					end
					return true
				end
				local function passarVideo(e)
					if e.phase == "moved" or e.phase == "stationary" or e.phase == "began" then
						local praFrente = vide0.currentTime + 5
							vide0:seek(praFrente)
					end
				end
				if atributos.largura then
					largura = atributos.largura
				else
					largura = 720
				end
				if atributos.altura then
					altura = atributos.altura
				else
					altura = 720
				end
				if atributos.velocidade then
					velocidade = atributos.velocidade
				else
					velocidade = 5
				end
				vide0 = native.newVideo(W/2,H/2,largura,altura)
				if atributos.tipo == "local" then
					vide0:load(atributos.arquivo,system.ResourceDirectory)
					grupoVideo.tipo = "local"
				elseif atributos.tipo == "incorporado" then
					vide0:load(atributos.url,media.RemoteSource)
					grupoVideo.tipo = "incorporado"
					vide0:play()
				end
				--vide0:addEventListener("video",videoListener)
				--vide0:play()
				vide0.situacao = "executando"
				botaORodar = display.newImageRect("play.png",70,70)
				botaORodar.anchorY = 0
				botaORodar.x,botaORodar.y = display.contentCenterX,display.contentCenterY + (altura/2) + 100
				botaORodar.isVisible = true
				botaORodar.tipo = "play"
				botaOPausar = display.newImageRect("pause.png",70,70)
				botaOPausar.x,botaOPausar.y = W/2,H/2 + (altura/2) + 100
				botaOPausar.tipo = "pause"
				botaOPausar.isVisible = false
				botaOPausar.isHitTestable = false
				botaOForward = display.newImageRect("forward.png",70,70)
				botaOForward.x,botaOForward.y = W/2+120,H/2 + (altura/2) + 100
				botaOForward.tipo = "forward"
				botaOBackward = display.newImageRect("backward.png",70,70)
				botaOBackward.x,botaOBackward.y = W/2-120,H/2 + (altura/2) + 100
				botaOBackward.tipo = "backward"
				botaORodar:addEventListener("tap",pausarRodarVideo)
				botaOPausar:addEventListener("tap",pausarRodarVideo)
				botaOForward:addEventListener("tap",pausarRodarVideo)
				botaOForward:addEventListener("touch",passarVideo)
				botaOBackward:addEventListener("tap",pausarRodarVideo)
				grupoVideo:insert(vide0)
				grupoVideo:insert(botaORodar)
				grupoVideo:insert(botaOPausar)
				grupoVideo:insert(botaOForward)
				grupoVideo:insert(botaOBackward)
				if loading then
					grupoVideo:insert(loading)
				end
				grupoVideo.timer = tempoLoading
				if atributos.index then grupoVideo.index = atributos.index end
				return grupoVideo

			elseif atributos.youtube then
				local grupoVideo = display.newGroup()
				local X = W/2
				local Y = 0

				if atributos.y then
					Y = atributos.y
				end
				if atributos.x then
					X = atributos.x
				end

				local videoID = atributos.youtube --story.link:sub(33, 43)
				if string.find(atributos.youtube,"be/") then
					for lixo,past in string.gmatch(atributos.youtube, '(be/)(.+)') do
						videoID = past
					end
				elseif string.find(atributos.youtube,"be.com/watch%?v=") then
					for lixo,past in string.gmatch(atributos.youtube, '(be.com/watch%?v=)(.+)') do
						videoID = past
					end
				end
				local path = system.pathForFile( "story".. contVideo ..".html", system.TemporaryDirectory )
				-- io.open opens a file at path. returns nil if no file found
				local fh, errStr = io.open( path, "w" )
				if fh then
					print( "Created file" )
					fh:write("<!doctype html>\n<html>\n<head>\n<meta charset=\"utf-8\">")
					fh:write("<meta name=\"viewport\" content=\"width=320, initial-scale=1.0, maximum-scale=1.0, user-scalable=0\"/>\n")
					fh:write("<style type=\"text/css\">\n html { -webkit-text-size-adjust: none; font-family: HelveticaNeue-Light, Helvetica, Droid-Sans, Arial, san-serif; font-size: 1.0em; } h1 {font-size:1.25em;} p {font-size:0.9em; } </style>\n")
					--fh:write([[<script type="text/javascript">function f() {location.href='##';}</script>]])
					fh:write("</head>\n<body>\n")

					fh:write([[
						<div id="player"></div>

						<script>
						  // Load the IFrame Player API code asynchronously.
						  //Holds a reference to the YouTube player
						  var tag = document.createElement('script');
						  tag.src = "https://www.youtube.com/iframe_api";
						  var firstScriptTag = document.getElementsByTagName('script')[0];
						  firstScriptTag.parentNode.insertBefore(tag, firstScriptTag);

						  // Replace the 'ytplayer' element with an <iframe> and
						  // YouTube player after the API code downloads.
						  var player;
						  function newContent() {
							  document.open();
							  document.write("<h1>Out with the old, in with the new!</h1>");
							  document.close();
							}
						  function onYouTubeIframeAPIReady() {
							  //creates the player object --> ik_player_iframe
							  player = new YT.Player('player', {
								  height: '200',
								  width: '100%',
								  videoId: ']]..videoID..[[',
								  events: {
									'onReady': onPlayerReady,
									'onStateChange': onPlayerStateChange
								  }
							  });
							  console.log('Video API is loaded');
						  }
						  function onPlayerReady(event) {
							console.log('Video is ready to play');
						  }
						  var done = false;
						  function onPlayerStateChange(event) {
							console.log('Video state changed');
							console.log(event.data);
							console.log(YT.PlayerState.PLAYING);
							//newContent();
							var duracao = player.getDuration()
							location.href='#' + event.data + '#' + duracao + '#';
						  }

						</script>]])

					fh:write( "\n</body>\n</html>\n" )
					io.close( fh )
				else
					print( "Create file failed!" )
				end
				grupoVideo.YoutubeVideoState = "-1"
				grupoVideo.YoutubeVideoDuration = "0"
				local function webListener( event )

					if event.url then
						print( "You are visiting: " .. event.url )
						function grupoVideo.listenerWebViewChanges()

							local aux,dur = string.match(event.url,"#(.+)#(.+)#")
							if aux then
								if grupoVideo.YoutubeVideoState and aux ~= grupoVideo.YoutubeVideoState then
									grupoVideo.YoutubeVideoState = aux
									grupoVideo.YoutubeVideoDuration = dur
									--[[
									-1 (não iniciado)
									0 (encerrado)
									1 (em reprodução)
									2 (em pausa)
									3 (armazenando em buffer)
									5 (vídeo indicado).
									]]
									local enviarHistorico = false
									local estado = "não iniciado"
									if aux == "-1" then
										estado = "não iniciado"
									elseif aux == "0" then
										estado = "terminou"
										enviarHistorico = true
									elseif aux == "1" then
										estado = "executou"
										enviarHistorico = true
									elseif aux == "2" then
										estado = "pausou"
										enviarHistorico = true
									elseif aux == "3" then
										estado = "armazenando em buffer"
									end
									if enviarHistorico then

										local subPagina = telas.subPagina
										historicoLib.Criar_e_salvar_vetor_historico({
											tipoInteracao = "video",
											subtipo = "youtube",
											pagina_livro = telas.pagina,
											objeto_id = contVideo,
											acao = estado,
											tempo_total = dur,
											subPagina = subPagina,
											tela = telas
										})
									end
								end
							end--if aux then
						end--function grupoVideo.listenerWebViewChanges
						grupoVideo.runtimeYouTube = timer.performWithDelay(1000,grupoVideo.listenerWebViewChanges,-1)
					end

					if event.type then
						print( "The event.type is " .. event.type ) -- print the type of request
					end

					if event.errorCode then
						native.showAlert( "Error!", event.errorMessage, { "OK" } )
					end
				end

				function grupoVideo.esconderVideo()
					if system.orientation ~= "portrait" then
						if grupoVideo.video then
							grupoVideo.video:removeSelf()
							grupoVideo.video = nil
						end
					end
				end

				grupoVideo.botaoPlay = display.newImageRect(grupoVideo,"playNot.png",600, 400)
				grupoVideo.botaoPlay.x= X;grupoVideo.botaoPlay.y= Y + 30
				grupoVideo.botaoPlay.anchorY  = 0
				local function onClickLink(event)
					local subPagina = telas.subPagina
					historicoLib.Criar_e_salvar_vetor_historico({
						tipoInteracao = "video",
						subtipo = "youtube",
						link = "sim",
						pagina_livro = telas.pagina,
						objeto_id = contVideo,
						acao = "executar",
						subPagina = subPagina,
						tela = telas
					})

					system.openURL("https://www.youtube.com/embed/"..videoID)
				end
				local function abrirYoutubeOuLink()
					if system.orientation ~= "portrait" then
						onClickLink()
					else
						grupoVideo.video = native.newWebView(0, 71, 600, 400)
						grupoVideo.video.x = X
						grupoVideo.video.y = Y
						grupoVideo.video.anchorY  = 0
						--<iframe width="403" height="238" src="https://www.youtube.com/embed/AVcKdr6ODpM" frameborder="0" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>
						grupoVideo.video:request("story"..contVideo..".html", system.TemporaryDirectory)
						grupoVideo.video:addEventListener( "urlRequest", webListener )

						--webView:addEventListener( "urlRequest", webListener )
						grupoVideo:insert(grupoVideo.video)
						--grupoVideo.videoY = Y
						local function mudarmudar()
							grupoVideo.video.xScale = 1
							grupoVideo.video.yScale = 1
							grupoVideo.video.rotation = 0
						end

						--Runtime:addEventListener("orientation",mudarmudar)
					end
				end

				grupoVideo.botaoPlay:addEventListener('tap', abrirYoutubeOuLink)
				Runtime:addEventListener("orientation",grupoVideo.esconderVideo)

				if atributos.index then grupoVideo.index = atributos.index end
				grupoVideo.videoH = grupoVideo.botaoPlay.height + 40
				return grupoVideo
			else

				local grupoVideo = display.newGroup()
				grupoVideo.pausado = false
				local Y = 0
				grupoVideo. y = Y
				if atributos.y then
					Y = atributos.y
				end
				local horizontalSlider
				local botaoPlay = display.newImageRect("play.png",480,320)
				botaoPlay.anchorY=0
				botaoPlay.y = 0
				botaoPlay.x = display.contentCenterX; botaoPlay.y = display.contentCenterY
				if travarOrientacaoLado == true then
					botaoPlay.x = display.contentCenterX; botaoPlay.y = display.contentCenterX-50
				end
				botaoPlay.y = 0
				if atributos.x then
					botaoPlay.x = atributos.x
				end

				-- adicionado variável de tempo --
				grupoVideo.TempoExecutadoValor = 0
				grupoVideo.TempoExecutadoValorMax = 0
				grupoVideo.TempoRepetindoValor = 0
				----------------------------------

				local function rodarVideoNovamente()
					--toqueHabilitado=false
					local function oncomplete(event)
						toqueHabilitado=true
						if event.completed then
							local subPagina = telas.subPagina
							historicoLib.Criar_e_salvar_vetor_historico({
								tipoInteracao = "video",
								subtipo = "nativo",
								pagina_livro = telas.pagina,
								objeto_id = contVideo,
								acao = "terminar",
								subPagina = subPagina,
								tela = telas
							})
						else
							local subPagina = telas.subPagina
							historicoLib.Criar_e_salvar_vetor_historico({
								tipoInteracao = "video",
								subtipo = "nativo",
								pagina_livro = telas.pagina,
								objeto_id = contVideo,
								acao = "cancelar",
								subPagina = subPagina,
								tela = telas
							})
						end
					end
					local videooow
					if varGlobal and varGlobal.tipoSistema == "PC" then
					--if system.pathForFile() then
						local webView = native.newWebView( botaoPlay.x, botaoPlay.y,480, 320 )
						webView.anchorY = 0
						webView.isVisible = false
						webView:request( atributos.arquivo,system.ResourceDirectory )
						grupoVideo:insert(webView)

						local subPagina = telas.subPagina
						historicoLib.Criar_e_salvar_vetor_historico({
							tipoInteracao = "video",
							subtipo = "nativo",
							pagina_livro = telas.pagina,
							objeto_id = contVideo,
							acao = "executar",
							tempo_total = grupoVideo.tempoTotalVideo * 1000,
							subPagina = subPagina,
							tela = telas
						})
					else
						videooow = media.playVideo( atributos.arquivo,system.ResourceDirectory,true,oncomplete)

						local subPagina = telas.subPagina
						historicoLib.Criar_e_salvar_vetor_historico({
							tipoInteracao = "video",
							subtipo = "nativo",
							pagina_livro = telas.pagina,
							objeto_id = contVideo,
							acao = "executar",
							tempo_total = grupoVideo.tempoTotalVideo * 1000,
							subPagina = subPagina,
							tela = telas
						})
						if grupoVideo.video then
							grupoVideo.video:pause()
						end
						if videooow then
							grupoVideo:insert(videooow)
						end
					end
					return true
				end
				botaoPlay:addEventListener("tap",rodarVideoNovamente)
				grupoVideo.tempoTotalVideo = 1
				-- criando video --
				local tempoAtual = 0
				local function videoListener(e)
					if e.phase == "ready" then
						grupoVideo.tempoTotalVideo = e.target.totalTime
						local function verificarVideo()
							if e.target.currentTime ~= nil then
								grupoVideo.SeeK = e.target.currentTime
								tempoAtual = e.target.currentTime
							end

							local percent = grupoVideo.SeeK /100
							if grupoVideo.timer then
								horizontalSlider:setValue(percent*100)
							end
						end
						grupoVideo.timer = timer.performWithDelay(1000,verificarVideo,-1)
					end
					if e.phase == "ended" then

						local subPagina = telas.subPagina
						historicoLib.Criar_e_salvar_vetor_historico({
							tipoInteracao = "video",
							subtipo = "no livro",
							pagina_livro = telas.pagina,
							objeto_id = contVideo,
							acao = "terminar",
							tempo_total = grupoVideo.tempoTotalVideo * 1000,
							tempo_total_executado = grupoVideo.TempoExecutadoValorMax,
							tempo_total_repetindo = grupoVideo.TempoRepetindoValor,
							subPagina = subPagina,
							tela = telas
						})

						if grupoVideo.TempoExecutado then
							grupoVideo.TempoExecutadoValor = 0
							grupoVideo.TempoExecutadoValorMax = 0
							timer.cancel(grupoVideo.TempoExecutado)
							grupoVideo.TempoExecutado = nil
						end
						if grupoVideo.TempoRepetindo then
							grupoVideo.TempoRepetindoValor = 0
							timer.cancel(grupoVideo.TempoRepetindo)
							grupoVideo.TempoRepetindo = nil
						end
					end
				end
				--grupoVideo.video = native.newVideo( display.contentCenterX , display.contentCenterY, botaoPlay.width- 10, botaoPlay.height )
				--grupoVideo.video.x = display.contentCenterX;grupoVideo.video.y = display.contentCenterY
				--grupoVideo.video.anchorY=0
				--grupoVideo.video.y = 0
				--if atributos.x then
				--	grupoVideo.video.x = atributos.x
				--end
				if not grupoVideo.SeeK then grupoVideo.SeeK = 1; end
				--grupoVideo.video:load(atributos.arquivo,system.ResourcesDirectory)
				--grupoVideo.video:addEventListener( "video", videoListener )
				--grupoVideo.video:seek( grupoVideo.SeeK )
				--grupoVideo.video:play()
				--grupoVideo.video:pause()
				-- barra botoes play video --
				local barra = display.newImageRect("barraBotoesPlayVideo.png",botaoPlay.width,100)
				barra.anchorY=0
				barra.x = botaoPlay.x; barra.y = botaoPlay.y + botaoPlay.height
				-- SLIDER de VELOCIDADE ----------------------------



				local widget = require( "widget" )
				local function sliderListener(event)
					local resultado = (event.value/100) * grupoVideo.tempoTotalVideo
					if event.phase == "began" then
						local resultado = (event.value/100) * grupoVideo.tempoTotalVideo
						grupoVideo.tempoAnterior = resultado
					elseif event.phase == "moved" then
						if grupoVideo.pausado == false and grupoVideo.executou == true then
							grupoVideo.pausado = true

							local subPagina = telas.subPagina
							historicoLib.Criar_e_salvar_vetor_historico({
								tipoInteracao = "video",
								subtipo = "no livro",
								pagina_livro = telas.pagina,
								objeto_id = contVideo,
								acao = "pausar",
								slider_mudou = true,
								tempo_atual_video = grupoVideo.SeeK * 1000,
								tempo_total = grupoVideo.tempoTotalVideo * 1000,
								subPagina = subPagina,
								tela = telas
							})

							grupoVideo.video:pause()

							if grupoVideo.TempoExecutado then
								timer.pause(grupoVideo.TempoExecutado)
							end
							if grupoVideo.TempoRepetindo then
								timer.pause(grupoVideo.TempoRepetindo)
							end
						end
					end
					if event.phase == "ended" then
						if grupoVideo.video then
							grupoVideo.video:seek( resultado )
						end
						grupoVideo.SeeK = resultado
						if grupoVideo.TempoExecutado then
							if aux > resultado then -- se retrocedeu
								grupoVideo.TempoExecutadoValor = grupoVideo.TempoExecutadoValor - (aux - resultado)
							end
						end
						if grupoVideo.tempoAnterior then 
							local subPagina = telas.subPagina
							if grupoVideo.SeeK > grupoVideo.tempoAnterior then
								historicoLib.Criar_e_salvar_vetor_historico({
									tipoInteracao = "video",
									pagina_livro = telas.pagina,
									objeto_id = contVideo,
									acao = "avançar",
									subtipo = "no livro",
									tempo_atual_video = grupoVideo.SeeK * 1000,
									tempo_total = grupoVideo.tempoTotalVideo * 1000,
									subPagina = subPagina,
									tela = telas
								})
							elseif grupoVideo.SeeK < grupoVideo.tempoAnterior then
								
								historicoLib.Criar_e_salvar_vetor_historico({
									tipoInteracao = "video",
									pagina_livro = telas.pagina,
									objeto_id = contVideo,
									acao = "retroceder",
									subtipo = "no livro",
									tempo_atual_video = grupoVideo.SeeK * 1000,
									tempo_total = grupoVideo.tempoTotalVideo * 1000,
									subPagina = subPagina,
									tela = telas
								})
							end
						end
					end
				end


				local options = {
					frames = {
						{ x=0, y=0, width=40, height=64 },
						{ x=40, y=0, width=36, height=64 },
						{ x=80, y=0, width=36, height=64 },
						{ x=124, y=0, width=36, height=64 },
						{ x=168, y=0, width=64, height=64 }
					},
					sheetContentHeight = 64,
					sheetContentWidth = 232
				}
				local sliderSheet = graphics.newImageSheet( "slider.png", options )

				-- Create the widget
				tempoInicial = 0
				if grupoVideo.SeeK then
					--tempoInicial = grupoVideo.SeeK * grupoVideo.tempoTotalVideo/100
				end
				horizontalSlider = widget.newSlider(
					{
						sheet = sliderSheet,
						leftFrame = 1,
						middleFrame   = 2,
						rightFrame  = 3,
						fillFrame  = 4,
						frameWidth = 36,
						frameHeight = 64,
						handleFrame = 5,
						handleHeight = 64,
						handleWidth = 64,
						orientation = "horizontal",
						width = 509,
						value = tempoInicial,
						x = botaoPlay.x-1,
						y = botaoPlay.y + botaoPlay.height,
						listener = sliderListener
					}
				)
				horizontalSlider.anchorY = 0
				local function voltarVideo()
					if grupoVideo.timerVoltar then
						timer.cancel(grupoVideo.timerVoltar)
						grupoVideo.timerVoltar = nil
					end
					if grupoVideo.timerAvancar then
						timer.cancel(grupoVideo.timerAvancar)
						grupoVideo.timerAvancar = nil
					end

					local subPagina = telas.subPagina
					historicoLib.Criar_e_salvar_vetor_historico({
						tipoInteracao = "video",
						subtipo = "no livro",
						pagina_livro = telas.pagina,
						objeto_id = contVideo,
						acao = "retroceder",
						tempo_atual_video = grupoVideo.SeeK * 1000,
						tempo_total = grupoVideo.tempoTotalVideo * 1000,
						subPagina = subPagina,
						tela = telas
					})

					if grupoVideo.TempoExecutado then
						timer.pause(grupoVideo.TempoExecutado)
					end
					if grupoVideo.TempoRepetindo then
						timer.pause(grupoVideo.TempoRepetindo)
					end
					grupoVideo.timerVoltar = timer.performWithDelay(1000,
					function()
						if grupoVideo.SeeK < 4 then
							grupoVideo.SeeK = 0
							grupoVideo.TempoExecutadoValor = 0
							timer.cancel(grupoVideo.timerVoltar)
						else
							grupoVideo.SeeK = grupoVideo.SeeK - 4
							grupoVideo.TempoExecutadoValor = grupoVideo.TempoExecutadoValor - 4
							grupoVideo.video:seek(grupoVideo.SeeK)
						end
					end,-1)
				end
				local function pararVideo()
					if grupoVideo.timerVoltar then
						timer.cancel(grupoVideo.timerVoltar)
						grupoVideo.timerVoltar = nil
					end
					if grupoVideo.timerAvancar then
						timer.cancel(grupoVideo.timerAvancar)
						grupoVideo.timerAvancar = nil
					end
					if grupoVideo.SeeK and grupoVideo.SeeK > 0 then

						local subPagina = telas.subPagina
						historicoLib.Criar_e_salvar_vetor_historico({
							tipoInteracao = "video",
							subtipo = "no livro",
							pagina_livro = telas.pagina,
							objeto_id = contVideo,
							acao = "cancelar",
							tempo_atual_video = grupoVideo.SeeK * 1000,
							tempo_total = grupoVideo.tempoTotalVideo * 1000,
							tempo_total_executado = grupoVideo.TempoExecutadoValorMax,
							tempo_total_repetindo = grupoVideo.TempoRepetindoValor,
							subPagina = subPagina,
							tela = telas
						})

						if grupoVideo.TempoExecutado then
							grupoVideo.TempoExecutadoValor = 0
							grupoVideo.TempoExecutadoValorMax = 0
							timer.cancel(grupoVideo.TempoExecutado)
							grupoVideo.TempoExecutado = nil
						end
						if grupoVideo.TempoRepetindo then
							grupoVideo.TempoRepetindoValor = 0
							timer.cancel(grupoVideo.TempoRepetindo)
							grupoVideo.TempoRepetindo = nil
						end
					end
					grupoVideo.SeeK = 0
					if grupoVideo.video then
						grupoVideo.video:seek(grupoVideo.SeeK)
						grupoVideo.video:play()
						grupoVideo.video:pause()
						horizontalSlider:setValue(grupoVideo.SeeK)
					end
				end
				grupoVideo.executou = false
				local function rodarVideo()
					if grupoVideo.timerVoltar then
						timer.cancel(grupoVideo.timerVoltar)
						grupoVideo.timerVoltar = nil
					end
					if grupoVideo.timerAvancar then
						timer.cancel(grupoVideo.timerAvancar)
						grupoVideo.timerAvancar = nil
					end

					if grupoVideo.pausado == false and grupoVideo.executou == false then

						local subPagina = telas.subPagina
						historicoLib.Criar_e_salvar_vetor_historico({
							tipoInteracao = "video",
							subtipo = "no livro",
							pagina_livro = telas.pagina,
							objeto_id = contVideo,
							acao = "executar",
							tempo_atual_video = grupoVideo.SeeK * 1000,
							tempo_total = grupoVideo.tempoTotalVideo * 1000,
							subPagina = subPagina,
							tela = telas
						})

						if grupoVideo.TempoExecutado then
							timer.cancel(grupoVideo.TempoExecutado)
							grupoVideo.TempoExecutado = nil
						end
						if grupoVideo.TempoRepetindo then
							timer.cancel(grupoVideo.TempoRepetindo)
							grupoVideo.TempoRepetindo = nil
						end
						grupoVideo.TempoExecutado = timer.performWithDelay(100,
							function()
								grupoVideo.TempoExecutadoValor = grupoVideo.TempoExecutadoValor + 100;
								if grupoVideo.TempoExecutadoValor > grupoVideo.TempoExecutadoValorMax then
									grupoVideo.TempoExecutadoValorMax = grupoVideo.TempoExecutadoValor
								end
							end,-1)
						grupoVideo.TempoRepetindo = timer.performWithDelay(100,function() grupoVideo.TempoRepetindoValor = grupoVideo.TempoRepetindoValor + 100; end,-1)
					else

						local subPagina = telas.subPagina
						historicoLib.Criar_e_salvar_vetor_historico({
							tipoInteracao = "video",
							subtipo = "no livro",
							pagina_livro = telas.pagina,
							objeto_id = contVideo,
							acao = "despausar",
							tempo_atual_video = grupoVideo.SeeK * 1000,
							tempo_total = grupoVideo.tempoTotalVideo * 1000,
							subPagina = subPagina,
							tela = telas
						})

						if not grupoVideo.video then
							grupoVideo.video = native.newVideo( display.contentCenterX , display.contentCenterY, botaoPlay.width- 10, botaoPlay.height )
							grupoVideo.video.x = display.contentCenterX;grupoVideo.video.y = display.contentCenterY
							grupoVideo.video.anchorY=0
							grupoVideo.video.y = 0
							if atributos.x then
								grupoVideo.video.x = atributos.x
							end
							grupoVideo.video:load(atributos.arquivo,system.ResourcesDirectory)
							grupoVideo.video:addEventListener( "video", videoListener )
							grupoVideo.video:seek( grupoVideo.SeeK )
							grupoVideo.video:play()

							grupoVideo:insert(grupoVideo.video)
						end
						if grupoVideo.TempoExecutado then
							timer.resume(grupoVideo.TempoExecutado)
						end
						if grupoVideo.TempoRepetindo then
							timer.resume(grupoVideo.TempoRepetindo)
						end
					end
					if not grupoVideo.video then
						grupoVideo.video = native.newVideo( display.contentCenterX , display.contentCenterY, botaoPlay.width- 10, botaoPlay.height )
						grupoVideo.video.x = display.contentCenterX;grupoVideo.video.y = display.contentCenterY
						grupoVideo.video.anchorY=0
						grupoVideo.video.y = 0
						if atributos.x then
							grupoVideo.video.x = atributos.x
						end
						grupoVideo.video:load(atributos.arquivo,system.ResourcesDirectory)
						grupoVideo.video:addEventListener( "video", videoListener )
						grupoVideo.video:seek( grupoVideo.SeeK )
						grupoVideo.video:play()

						grupoVideo:insert(grupoVideo.video)
					end

					grupoVideo.video:play()
					grupoVideo.pausado = false
					grupoVideo.executou = true
				end

				local function pausarVideo()
					if grupoVideo.timerVoltar then
						timer.cancel(grupoVideo.timerVoltar)
						grupoVideo.timerVoltar = nil
					end
					if grupoVideo.timerAvancar then
						timer.cancel(grupoVideo.timerAvancar)
						grupoVideo.timerAvancar = nil
					end
					if grupoVideo.executou == true then
						grupoVideo.pausado = true

						local subPagina = telas.subPagina
						historicoLib.Criar_e_salvar_vetor_historico({
							tipoInteracao = "video",
							subtipo = "no livro",
							pagina_livro = telas.pagina,
							objeto_id = contVideo,
							acao = "pausar",
							tempo_atual_video = grupoVideo.SeeK * 1000,
							tempo_total = grupoVideo.tempoTotalVideo * 1000,
							subPagina = subPagina,
							tela = telas
						})

						grupoVideo.video:pause()

						if grupoVideo.TempoExecutado then
							timer.pause(grupoVideo.TempoExecutado)
						end
						if grupoVideo.TempoRepetindo then
							timer.pause(grupoVideo.TempoRepetindo)
						end
					end

				end
				local function avancarVideo()
					if grupoVideo.timerVoltar then
						timer.cancel(grupoVideo.timerVoltar)
						grupoVideo.timerVoltar = nil
					end
					if grupoVideo.timerAvancar then
						timer.cancel(grupoVideo.timerAvancar)
						grupoVideo.timerAvancar = nil
					end

					local subPagina = telas.subPagina
					historicoLib.Criar_e_salvar_vetor_historico({
						tipoInteracao = "video",
						subtipo = "no livro",
						pagina_livro = telas.pagina,
						objeto_id = contVideo,
						acao = "avançar",
						tempo_atual_video = grupoVideo.SeeK * 1000,
						tempo_total = grupoVideo.tempoTotalVideo * 1000,
						subPagina = subPagina,
						tela = telas
					})

					if grupoVideo.TempoExecutado then
						timer.pause(grupoVideo.TempoExecutado)
					end
					if grupoVideo.TempoRepetindo then
						timer.pause(grupoVideo.TempoRepetindo)
					end
					grupoVideo.timerAvancar = timer.performWithDelay(1000,
					function()
						if grupoVideo.SeeK > grupoVideo.tempoTotalVideo-5 then
							grupoVideo.SeeK = grupoVideo.tempoTotalVideo
							timer.cancel(grupoVideo.timerAvancar)
						else
							grupoVideo.SeeK = grupoVideo.SeeK + 5
							grupoVideo.video:seek(grupoVideo.SeeK)
						end
					end,-1)
				end


				local LBarra = barra.width/2
				local voltar = widget.newButton({defaultFile = "videoback.png",overFile = "videobackD.png",width = 50,height = 50, x = barra.x + 79 - LBarra,y = barra.y + 37,onRelease = voltarVideo})
				local parar = widget.newButton({defaultFile = "videostop.png",overFile = "videostopD.png",width = 50,height = 50, x = barra.x + 2*79 - LBarra,y = barra.y + 37,onRelease = pararVideo})
				local rodar = widget.newButton({defaultFile = "videoplay.png",overFile = "videoplayD.png",width = 50,height = 50, x = barra.x + 3*79 - LBarra,y = barra.y + 37,onRelease = rodarVideo})
				local pausar = widget.newButton({defaultFile = "videopause.png",overFile = "videopauseD.png",width = 50,height = 50, x = barra.x + 4*79 - LBarra,y = barra.y + 37,onRelease = pausarVideo})
				local avancar = widget.newButton({defaultFile = "videoforward.png",overFile = "videoforwardD.png",width = 50,height = 50, x = barra.x + 5*79 - LBarra,y = barra.y + 37,onRelease = avancarVideo})
				voltar.anchorY,parar.anchorY,rodar.anchorY,pausar.anchorY,avancar.anchorY = 0,0,0,0,0

				grupoVideo:insert(botaoPlay)
				--grupoVideo:insert(grupoVideo.video)
				grupoVideo:insert(barra)
				grupoVideo:insert(horizontalSlider)
				grupoVideo:insert(voltar)
				grupoVideo:insert(parar)
				grupoVideo:insert(rodar)
				grupoVideo:insert(pausar)
				grupoVideo:insert(avancar)
				grupoVideo.videoY = botaoPlay.y

				function grupoVideo.esconderVideo()
					if system.orientation ~= "portrait" then
						if grupoVideo.timerVoltar then
							timer.cancel(grupoVideo.timerVoltar)
							grupoVideo.timerVoltar = nil
						end
						if grupoVideo.timerAvancar then
							timer.cancel(grupoVideo.timerAvancar)
							grupoVideo.timerAvancar = nil
						end
						if grupoVideo.video then
							grupoVideo.video:removeSelf()
							grupoVideo.video = nil
						end
						horizontalSlider.isVisible = false
						voltar.isVisible = false
						parar.isVisible = false
						rodar.isVisible = false
						pausar.isVisible = false
						avancar.isVisible = false
						grupoVideo.pausado = true

						local subPagina = telas.subPagina
						historicoLib.Criar_e_salvar_vetor_historico({
							tipoInteracao = "video",
							subtipo = "no livro",
							pagina_livro = telas.pagina,
							objeto_id = contVideo,
							acao = "pausar",
							orientacao_mudou = true,
							tempo_atual_video = grupoVideo.SeeK * 1000,
							tempo_total = grupoVideo.tempoTotalVideo * 1000,
							subPagina = subPagina,
							tela = telas
						})

						if grupoVideo.TempoExecutado then
							timer.pause(grupoVideo.TempoExecutado)
						end
						if grupoVideo.TempoRepetindo then
							timer.pause(grupoVideo.TempoRepetindo)
						end
					else
						horizontalSlider.isVisible = true
						voltar.isVisible = true
						parar.isVisible = true
						rodar.isVisible = true
						pausar.isVisible = true
						avancar.isVisible = true
					end
				end

				Runtime:addEventListener("orientation",grupoVideo.esconderVideo)

				grupoVideo.videoH = botaoPlay.height + barra.height

				if atributos.index then grupoVideo.index = atributos.index end


				-- BOTÃO DE DETALHES
				if not atributos.modificar then
					atributos.modificar = 0
				end
				local function handleButtonEvent1(event)
					print("EVENTO")
					atributos.tipoInteracao = "video"
					timer.performWithDelay(15,function()funcGlobal.criarDescricao(atributos,true,contVideo); end,1)
				end

				local options = {
					width = 50,
					height = 50,
					defaultFile = "detalhes.png",
					overFile = "detalhesDown.png",
					onRelease = handleButtonEvent1
				}
				local botaoDetalhes = widget.newButton(options)
				botaoDetalhes.x = botaoDetalhes.x + grupoVideo.width + botaoDetalhes.width/2 + 20
				botaoDetalhes.y = botaoDetalhes.y + grupoVideo.height - botaoDetalhes.height - 10
				grupoVideo:insert(botaoDetalhes)
				if not atributos.conteudo then
					botaoDetalhes.isVisible = false
				end
				return grupoVideo
			end
		else
			local botaoPlay = display.newImageRect("Arquivos/playErro.png",300,150)
			botaoPlay.anchorY = 0
			botaoPlay.alpha = .5
			botaoPlay.x = W/2; botaoPlay.y = H/2
			if atributos.y then
				botaoPlay.y = atributos.y
			end
			if atributos.x then
				botaoPlay.x = atributos.x
			end
			if atributos.index then botaoPlay.index = atributos.index end
			return botaoPlay
		end
	end
end

--------------------------------------------------
--  COLOCAR ANIMACAO 							--
--	Funcao responsavel por gerar uma animacao 	--
--  de acordo com as imagens, tempo (ms) e som. --
--  ATRIBUTOS: imagens,tempoPorImagem,som 		--
--------------------------------------------------
function M.colocarAnimacao(atributos,telas,varGlobal,funcGlobal)

	local grupoAnimacao = display.newGroup() 
	if not atributos.y then atributos.y = 0 end
	
	local contAnimacao = 1
	if telas and telas[paginaAtual] and telas[paginaAtual].cont then
		contAnimacao = telas[paginaAtual].cont.animacoes
	end
	
	
	local AtrSom = atributos.som
	if atributos.pasta and atributos.som then
		AtrSom = atributos.pasta.."/"..atributos.som
	end
	local somValido = false
	local tempoTotalAudio = 0
	if atributos.som ~= "som vazio.WAV" and  media.newEventSound( AtrSom, system.ResourceDirectory ) then
		somValido = true
		local som = audio.loadStream(AtrSom,system.ResourceDirectory)
		if som then
			tempoTotalAudio = audio.getDuration(som)
		end
		som = nil
	end
	
	local automatico = "nao"
	local loop = "nao"
	local altura = 0
	local largura = 0
	local X = W/2
	local Y = H/2
	local imagens = {}
	local padrao = "Paginas/Outros Arquivos/Anim Padrao.lib/"
	local tempoPorImagem = 300
	local duracaoAnimacao = atributos.tempoPorImagem
	
	if atributos.automatico then
		automatico = atributos.automatico
	end
	if atributos.loop then
		loop = atributos.loop
	end
	if atributos.tempoPorImagem then
		tempoPorImagem = atributos.tempoPorImagem
	end
	if atributos.imagens then
		for i=1,#atributos.imagens do
			imagens[i] = atributos.imagens[i]
		end
	else
		imagens = {padrao.."imagemErro1.png",padrao.."imagemErro2.png",padrao.."imagemErro3.png",padrao.."imagemErro4.png",padrao.."imagemErro5.png"}
	end
	
	if tempoTotalAudio > tempoPorImagem * #imagens then tempoPorImagem = tempoTotalAudio/#imagens end
	local larguraPadrao = 258
	local alturaPadrao = 258
	
	if atributos.pasta and atributos.imagens then
		for i=1,#imagens do
			imagens[i] = atributos.pasta .. "/" ..imagens[i]
		end
		
		local calcTamanho = display.newImage(imagens[1])
		larguraPadrao = calcTamanho.width
		alturaPadrao = calcTamanho.height
		calcTamanho:removeSelf()
		
	end
	local imagemPlay = imagens[1]
	
	local auxiliarW = larguraPadrao
	local auxiliarH = alturaPadrao
	local aux2 = W/larguraPadrao
	largura = aux2*larguraPadrao
	altura = aux2*alturaPadrao
	
	if atributos.altura then
		altura = atributos.altura
	end
	if atributos.comprimento then
		largura = atributos.comprimento
	end
	if atributos.y then
		Y = atributos.y
	end
	if atributos.x then
		X = atributos.x
	end
	local alphaTTS = 1
	if atributos.souTTS then alphaTTS = 0 end
	
	grupoAnimacao.botaoPlay = display.newImageRect(imagemPlay,largura,altura)
	grupoAnimacao.botaoPlay.x = X;grupoAnimacao.botaoPlay.y = Y;
	grupoAnimacao.botaoPlay.anchorY = 0;grupoAnimacao.botaoPlay.anchorX = .5
	grupoAnimacao:insert(grupoAnimacao.botaoPlay)
	local imagemPlay = display.newImage("anima.png")
	--imagemPlay.alpha = .5
	imagemPlay.x = X;imagemPlay.y = grupoAnimacao.botaoPlay.y + grupoAnimacao.botaoPlay.height + 10;
	imagemPlay.anchorY = 0;imagemPlay.anchorX = .5
	imagemPlay.alpha = alphaTTS
	grupoAnimacao:insert(imagemPlay)
	
	grupoAnimacao.botaoPause = display.newImageRect("anima pause.png",40,imagemPlay.height)
	grupoAnimacao.botaoPause.x = imagemPlay.x - imagemPlay.width/2 - 25
	grupoAnimacao.botaoPause.y = grupoAnimacao.botaoPlay.y + grupoAnimacao.botaoPlay.height + 10;
	grupoAnimacao.botaoPause.anchorY = 0;grupoAnimacao.botaoPause.anchorX = 1
	grupoAnimacao.botaoPause.alpha = alphaTTS
	
	grupoAnimacao.botaoResume = display.newImageRect("anima resume.png",40,imagemPlay.height)
	grupoAnimacao.botaoResume.x = imagemPlay.x - imagemPlay.width/2 - 25
	grupoAnimacao.botaoResume.y = grupoAnimacao.botaoPlay.y + grupoAnimacao.botaoPlay.height + 10;
	grupoAnimacao.botaoResume.anchorY = 0;grupoAnimacao.botaoResume.anchorX = 1
	grupoAnimacao.botaoResume.alpha = alphaTTS
	
	grupoAnimacao:insert(grupoAnimacao.botaoResume)
	grupoAnimacao:insert(grupoAnimacao.botaoPause)
	grupoAnimacao.botaoResume:addEventListener("tap",
		function()
			if grupoAnimacao.paused then
				grupoAnimacao.paused = false
				if grupoAnimacao.timer then
					for i=1,#grupoAnimacao.timer do
						if grupoAnimacao.timer[i] then
							timer.resume(grupoAnimacao.timer[i])
						end
					end
					local subPagina = telas.subPagina
					local subtipo = atributos.dicionario
					historicoLib.Criar_e_salvar_vetor_historico({
						tipoInteracao = "animação",
						subtipo = subtipo,
						acao = "despausar",
						pagina_livro = telas.pagina,
						objeto_id = contAnimacao,
						subPagina = subPagina,
						tela = telas
					})
				end
				if grupoAnimacao.timer2 then
					timer.resume(grupoAnimacao.timer2)
				end
				if grupoAnimacao.timer then
					grupoAnimacao.paused = false
					grupoAnimacao.botaoPause.isVisible = true
					grupoAnimacao.botaoPause.isHitTestable = true
					if grupoAnimacao.som then
						audio.resume(grupoAnimacao.som)
					end
				end
			end
			return true
		end
	)
	grupoAnimacao.botaoPause:addEventListener("tap",
		function()
			if not grupoAnimacao.paused then
				if grupoAnimacao.timer then
					for i=1,#grupoAnimacao.timer do
						if grupoAnimacao.timer[i] then
							timer.pause(grupoAnimacao.timer[i])
						end
					end
					local subPagina = telas.subPagina
					local subtipo = atributos.dicionario
					historicoLib.Criar_e_salvar_vetor_historico({
						tipoInteracao = "animação",
						subtipo = subtipo,
						acao = "pausar",
						pagina_livro = telas.pagina,
						objeto_id = contAnimacao,
						subPagina = subPagina,
						tela = telas
					})
				end
				if grupoAnimacao.timer2 then
					timer.pause(grupoAnimacao.timer2)
				end
				if grupoAnimacao.timer then
					grupoAnimacao.paused = true
					grupoAnimacao.botaoPause.isVisible = false
					grupoAnimacao.botaoPause.isHitTestable = false
					if grupoAnimacao.som then
						audio.pause(grupoAnimacao.som)
					end
				end
			end
			return true
		end
	)
	
	if automatico == "sim" then
		--imagemPlay.isVisible = false
	end
	grupoAnimacao.imagens = {}
	for i=1,#imagens do
		grupoAnimacao.imagens[i] = display.newImageRect(imagens[i],largura,altura)
		grupoAnimacao.imagens[i].x = X
		grupoAnimacao.imagens[i].y = Y
		grupoAnimacao.imagens[i].anchorY = 0;grupoAnimacao.imagens[i].anchorX = .5
		grupoAnimacao.imagens[i].isVisible = false
		grupoAnimacao:insert(grupoAnimacao.imagens[i])
	end

	grupoAnimacao.timer = {}
	local function rodarAnimacao(evento)
		grupoAnimacao.paused = false
		grupoAnimacao.botaoPause.isVisible = true
		grupoAnimacao.botaoPause.isHitTestable = true
		if evento then
			local subPagina = telas.subPagina
			local subtipo = atributos.dicionario
			historicoLib.Criar_e_salvar_vetor_historico({
				tipoInteracao = "animação",
				subtipo = subtipo,
				acao = "executar",
				pagina_livro = telas.pagina,
				objeto_id = contAnimacao,
				subPagina = subPagina,
				tela = telas
			})
		end
		if loop == "sim" then
			--imagemPlay.isVisible = false
		else
			--funcGlobal.escreverNoHistorico(varGlobal.HistoricoRodarAnimacao.."|Animacao "..contAnimacao)
		end
		local i = 1
		if grupoAnimacao.timer2 then
			for k=1,#imagens do
				if grupoAnimacao.imagens[k] then
					grupoAnimacao.imagens[k].isVisible = false;
				end
			end
			if grupoAnimacao.botaoPlay then
				grupoAnimacao.botaoPlay.isVisible = true;
			end
			if loop == "sim" then
				--rodarAnimacao();
			else
				imagemPlay.isVisible = true;
				if varGlobal.grupoAnimacaoTTS and varGlobal.grupoAnimacaoTTS.animacaoTTS then
					funcGlobal.passarTTSAnimParaFrente()
				end
			end
		end
		if grupoAnimacao.timer then
			for k=1,#grupoAnimacao.timer do
				timer.cancel(grupoAnimacao.timer[k])
				grupoAnimacao.timer[k] = nil
			end
			for k=1,#imagens do
				if grupoAnimacao.imagens[k] then
					grupoAnimacao.imagens[k].isVisible = false;
				end
			end
			if grupoAnimacao.botaoPlay then
				grupoAnimacao.botaoPlay.isVisible = true;
			end
			imagemPlay.isVisible = true;
		end
		grupoAnimacao.clicouBotao = false
		if grupoAnimacao.som and atributos.som ~= "som vazio.WAV" then
			audio.stop(grupoAnimacao.som)
			grupoAnimacao.clicouBotao = true
		end
		local function rodarAnimacaoAux()
			grupoAnimacao.imagens[i].isVisible = true
			--imagemPlay.isVisible = false
			
			if i == 1 then
				grupoAnimacao.imagens[#imagens].isVisible = false;
				
				if somValido == true then
					local function onComplete(e)
						if e.completed ~= true and grupoAnimacao.clicouBotao == false then
							if grupoAnimacao.timer2 then
								timer.cancel(grupoAnimacao.timer2)
								grupoAnimacao.timer2 = nil
							end
							if grupoAnimacao.timer then
								for i=1,#grupoAnimacao.timer do
									timer.cancel(grupoAnimacao.timer[i])
									grupoAnimacao.timer[i] = nil
								end
								for i=1,#imagens do
									grupoAnimacao.imagens[i].isVisible = false;
								end
								if grupoAnimacao.botaoPlay then
									grupoAnimacao.botaoPlay.isVisible = true;
								end
								imagemPlay.isVisible = true;
							end
						end
						if e.completed == true then
							local subPagina = telas.subPagina
							local subtipo = atributos.dicionario
							historicoLib.Criar_e_salvar_vetor_historico({
								tipoInteracao = "animação",
								subtipo = subtipo,
								acao = "terminar",
								pagina_livro = telas.pagina,
								objeto_id = contAnimacao,
								subPagina = subPagina,
								tela = telas
							})
							if atributos.limitador and atributos.limitador == "som" then
								if atributos.avancar and atributos.avancar == "sim" then
									paginaAtual=paginaAtual+1
									criarCursoAux(telas,paginaAtual)
									
								end
							end
							-- JSON
						end
					end
					local som = audio.loadStream(AtrSom,system.ResourceDirectory)
					grupoAnimacao.som = audio.play(som,{onComplete = onComplete})
				end
				grupoAnimacao.botaoPlay.isVisible = false
			elseif i == #imagens then
				grupoAnimacao.timer2 = nil
				grupoAnimacao.timer2 = timer.performWithDelay(tempoPorImagem,
					function()
						for i=1,#imagens do
							--grupoAnimacao.imagens[i].isVisible = false;
						end
						if grupoAnimacao.botaoPlay then
							grupoAnimacao.botaoPlay.isVisible = true;
						end
						if loop == "sim" then
							rodarAnimacao();
						else
							imagemPlay.isVisible = true;
							if varGlobal and varGlobal.grupoAnimacaoTTS and varGlobal.grupoAnimacaoTTS.animacaoTTS then
								
								local subPagina = telas.subPagina
								local subtipo = atributos.dicionario
								historicoLib.Criar_e_salvar_vetor_historico({
									tipoInteracao = "TTS",
									subtipo = "animação",
									acao = "terminar",
									pagina_livro = telas.pagina,
									objeto_id = contAnimacao,
									subPagina = subPagina,
									tela = telas
								})
								
								funcGlobal.passarTTSHiperParaFrente()
							else
								local subPagina = telas.subPagina
								local subtipo = atributos.dicionario
								historicoLib.Criar_e_salvar_vetor_historico({
									tipoInteracao = "animação",
									subtipo = subtipo,
									acao = "terminar",
									pagina_livro = telas.pagina,
									objeto_id = contAnimacao,
									subPagina = subPagina,
									card = atributos.card,
									tela = telas
								})
							end
						end
						if atributos.avancar and atributos.avancar == "sim" then
							criarCursoAux(telas, telas.pagina+1)
						end
					end,1) 
			end
			i = i+1
		end
		grupoAnimacao.timer[i] = nil
		grupoAnimacao.timer[i] = timer.performWithDelay(tempoPorImagem,rodarAnimacaoAux,#imagens)
	end

	imagemPlay:addEventListener("tap",rodarAnimacao)
	--grupoAnimacao.botaoPlay:addEventListener("tap",rodarAnimacao)
	if automatico == "sim" then
		rodarAnimacao()
	end
	grupoAnimacao.xx = grupoAnimacao.botaoPlay.x
	grupoAnimacao.YY = grupoAnimacao.botaoPlay.y
	grupoAnimacao.hh = grupoAnimacao.botaoPlay.height
	if atributos.index then grupoAnimacao.index = atributos.index end
	
	-- BOTÃO DE DETALHES
	if not atributos.modificar then
		atributos.modificar = 0
	end
	local function handleButtonEvent(event)
		print("EVENTO")
		atributos.tipoInteracao = "animação"
		timer.performWithDelay(15,function()funcGlobal.criarDescricao(atributos,true,contAnimacao); end,1)
	end
	
	local options = {
		width = imagemPlay.height,
		height = imagemPlay.height,
		defaultFile = "detalhes.png",
		overFile = "detalhesDown.png",
		onRelease = handleButtonEvent	
	}
	
	local botaoDetalhes = {}
	if atributos.conteudo then
		botaoDetalhes = widget.newButton(options)
		botaoDetalhes.anchorY = 0;botaoDetalhes.anchorX = .5
		botaoDetalhes.x = imagemPlay.x + botaoDetalhes.width/2 + imagemPlay.width/2 + 10
		botaoDetalhes.y = imagemPlay.y --botaoDetalhes.y + grupoAnimacao.height - botaoDetalhes.height
		grupoAnimacao:insert(botaoDetalhes)
	end
	
	return grupoAnimacao
end

-------------------------------------------------------------------------
--  COLOCAR EXERCICIOS												   --
-- atributos: enunciado,tamanhoFonte, corFonte, alternativas, corretas,--
-- justificativas, posicaoTexto("centro","topo")					   --
-- para montador: numeroalternativas								   --
-------------------------------------------------------------------------
function M.criarExercicio(atributos,telas)
	
	if auxFuncs.naoVazio(atributos) then
		if atributos.tipo and atributos.tipo == "CARD" then
			local manipularTela = require("manipularTela")
		
			local margem = atributos.margem or 60
			local posX = atributos.x or W/2
			local posY = atributos.y or H/2
			local alternativas = atributos.alternativas or {"opção 1","opção 2","opção 3"}
			local corretas = atributos.corretas or {1}
			local alinhamento = atributos.alinhamento or "justificado"
			local fonte = "Fontes/segoeui.ttf"
			if atributos.fonte then fonte = "Fontes/"..atributos.fonte end
			local enunciado = atributos.enunciado or "Marque a alternativa correta:"
			local tamanhoEnunciado = atributos.tamanhoFonte or 70
			local tamanhoAlternativas = atributos.tamanhoFonteAlternativas or 40
			if atributos.tamanhoFonteAlternativas then
				tamanhoFonteAlternativas = atributos.tamanhoFonteAlternativas
			else
				tamanhoFonteAlternativas = tamanhoEnunciado-(tamanhoEnunciado/3)
			end
			local corFonte = atributos.corFonte or {0,0,0}
			local pasta = nil or atributos.pasta --telas.pastaArquivosAtual.."/"..
			print("WARNING: pasta do exercicio do card:",pasta)
			local numeroAlternativas = atributos.numeroAlternativas or 3
			local mensagemCorreta = atributos.mensagemCorreta or "Você acertou!"
			local mensagemErrada = atributos.mensagemErrada or "Você errou..."
			local numero = atributos.numero or nil
			
			local GG = display.newGroup()
			GG.Interno = display.newGroup()
			GG:insert(GG.Interno)
			GG.x = posX
			GG.y = posY
			
			GG.grupoBotaoExercicio = display.newGroup()
			GG.Interno:insert(GG.grupoBotaoExercicio)
			GG.grupoBotaoExercicio.x = margem
			------------------------------------
			-- grupo botão exercício cascata --
				local botaoExercicio = display.newImageRect("exercicioDropDown.png",315 + (315*1/3),40 + (40*1/3))
				botaoExercicio.anchorY = 0;botaoExercicio.anchorX = 0
				botaoExercicio.x = 0
				botaoExercicio.y = 0
				GG.grupoBotaoExercicio:insert(botaoExercicio)
				if anumero then
					GG.grupoBotaoExercicio.numero = numero
				else
					GG.grupoBotaoExercicio.numero = ""
				end

				local numeroExercicio = display.newText(GG.grupoBotaoExercicio.numero,botaoExercicio.x+250,botaoExercicio.y-2,"Fontes/ariblk.ttf",40)
				numeroExercicio:setFillColor(0,0,0)
				numeroExercicio.anchorX=0;numeroExercicio.anchorY=0;
				GG.grupoBotaoExercicio:insert(numeroExercicio)
			------------------------------------
			------------------------------------
			
			GG.enunciado = colocarFormatacaoTexto.criarTextodePalavras({texto = enunciado,x = 0,Y = 0,fonte = fonte,tamanho = tamanhoEnunciado,cor = corFonte, alinhamento = alinhamento,margem = margem,xNegativo = nil,largura = nil, endereco = pasta,temHistorico = nil})

			GG.enunciado.y = GG.grupoBotaoExercicio.y + GG.grupoBotaoExercicio.height
			GG.enunciado.anchorY = 0
			GG.Interno:insert(GG.enunciado)
			local function alertaAcertou() native.showAlert("Parabéns!", mensagemCorreta,{"OK"}) end
			local function alertaErrou() native.showAlert("Que pena!", mensagemErrada,{"OK"}) end
			-- criação do botão de verificar alternativa
			GG.verificarAlternativaSelecionada = function(e)
				if GG.Interno.selecionada then
					if pasta and auxFuncs.fileExists(pasta.."/"..GG.Interno.selecionada..".txt") then
						local scriptPagina = auxFuncs.lerArquivoTXTCaminho({caminho = system.pathForFile(pasta.."/"..GG.Interno.selecionada..".txt"),tipo = "texto"})
						local pastaAntiga = string.gsub(telas.pastaArquivosAtual,"/Outros Arquivos","")
						
						local correta = mensagemErrada
						if GG.Interno.selecionada == corretas[1] then
							correta = mensagemCorreta
						end
						local YY = 0
						local count = 2
						GG.Interno.refazerTela = function(atribut)
							atribut.PaginaCriada.removerTela()
							GG.Interno.TelaQuestao:removeSelf()
							print("refez a tela")
							GG.Interno.TelaQuestao = manipularTela.criarUmaTela(
								{
									pasta = pastaAntiga,
									arquivo = GG.Interno.selecionada..".txt",
									scriptDaPagina = scriptPagina,
									vetorRefazer = atribut.tela,
									--dicionario = true
								},
								GG.Interno.refazerTela
							)
							GG.Interno.TelaQuestao:scale(.9,.9)
							GG.Interno.TelaQuestao.y = GG.Interno.TelaQuestao.y
							GG.Interno.TelaQuestao.x = GG.Interno.TelaQuestao.x + GG.Interno.TelaQuestao.width/20
							print("NOVA POSICAO",GG.Interno.TelaQuestao.y)
							GG:insert(GG.Interno.TelaQuestao)
							atributos.funcaoCard(GG.Interno.TelaQuestao.height)
						end
						GG.Interno.TelaQuestao = manipularTela.criarUmaTela(
							{
								pasta = pastaAntiga,
								arquivo = GG.Interno.selecionada..".txt",
								scriptDaPagina = scriptPagina,
								exercicio = pasta,
								correta = correta,
								card = true,
							},GG.Interno.refazerTela)
						GG.Interno.TelaQuestao:scale(.9,.9)
						GG.Interno.TelaQuestao.x = GG.Interno.TelaQuestao.x + GG.Interno.TelaQuestao.width/20
						GG.Interno.TelaQuestao.y = GG.Interno.TelaQuestao.y
						YY = GG.Interno.TelaQuestao.y - 200
						GG:insert(GG.Interno.TelaQuestao)
						GG.Interno.isVisible = false
						
						atributos.funcaoCard(GG.Interno.TelaQuestao.height)
						-- criar botão voltar fixo --
						
						-----------------------------
					elseif not pasta or (pasta and not auxFuncs.fileExists(pasta.."/"..GG.Interno.selecionada..".txt")) then
						if GG.Interno.selecionada == corretas[1] then
							alertaAcertou()
						else
							alertaErrou()
						end
					end
				else
					native.showAlert("Atenção", "Você deve selecionar alguma alternativa antes de poder verificar a questão.",{"OK"})
				end
			end
			GG.textoVerifica = widget.newButton(
				{
					label = "verificar",
					onRelease   =  GG.verificarAlternativaSelecionada,
					emboss = false,
					shape = "roundedRect",
					width = 250 + (250*1/3),
					height = 40 + (40*1/3),
					cornerRadius = 2,
					fontSize = 45,
					fillColor = { default={0,.8,0,1}, over={0,0.3,0,1} },
					labelColor = { default={0,0,0,1}, over={0,0,0,0.7} },
					strokeColor = { default={0,0,0,1}, over={0,0,0,0.7} },
					strokeWidth = 4
				}
			)
			--GG.textoVerifica = display.newImage("verificar.png",314 + (314*1/3),40 + (40*1/3))
			GG.textoVerifica.y = GG.enunciado.y + GG.enunciado.height + 10
			GG.textoVerifica.anchorY = 0
			GG.textoVerifica.x = W/2
			GG.Interno:insert(GG.textoVerifica)
			
			
			
			-- função de seleção da alternativa
			GG.Interno.selecionarAlternativa = function(e)
				
				for k=1,#alternativas do
					if k ~= e.target.numero then
						GG.Interno.numeroAlternativas[k].alpha = 1
						GG.Interno.alternativas[k].alpha = 1
					end
				end
				if GG.Interno.selecionada == e.target.numero then
					GG.Interno.selecionada = nil
					GG.Interno.numeroAlternativas[e.target.numero].alpha = 1
					GG.Interno.alternativas[e.target.numero].alpha = 1
				else
					GG.Interno.selecionada = e.target.numero
					GG.Interno.numeroAlternativas[e.target.numero].alpha = .5
					GG.Interno.alternativas[e.target.numero].alpha = .5
				end
				
			end
			
			-- criação das alternativas
			local Yalternativa = GG.enunciado.y + GG.enunciado.height + 20
			GG.Interno.alternativas = {}
			GG.Interno.selecionada = nil
			GG.Interno.numeroAlternativas = {}
			for i=1,#alternativas do
				GG.Interno.numeroAlternativas[i] = colocarFormatacaoTexto.criarTextodePalavras({texto = i..")",x = 0,Y = 0,fonte = fonte,tamanho = tamanhoAlternativas,cor = corFonte, alinhamento = alinhamento,margem = margem,xNegativo = nil,largura = nil, endereco = pasta,temHistorico = nil})
				GG.Interno.numeroAlternativas[i].y = Yalternativa
				GG.Interno.numeroAlternativas[i].anchorY = 0
				GG.Interno.numeroAlternativas[i].numero = i
				GG.Interno:insert(GG.Interno.numeroAlternativas[i])
				
				GG.Interno.alternativas[i] = colocarFormatacaoTexto.criarTextodePalavras({texto = alternativas[i],x = 40,Y = 0,fonte = fonte,tamanho = tamanhoAlternativas,cor = corFonte, alinhamento = alinhamento,margem = margem,xNegativo = nil,largura = nil, endereco = pasta,temHistorico = nil})
				GG.Interno.alternativas[i].y = Yalternativa
				GG.Interno.alternativas[i].numero = i
				GG.Interno.alternativas[i].anchorY = 0
				
				GG.Interno:insert(GG.Interno.alternativas[i])
				
				GG.Interno.numeroAlternativas[i]:addEventListener("tap",GG.Interno.selecionarAlternativa)
				GG.Interno.alternativas[i]:addEventListener("tap",GG.Interno.selecionarAlternativa)
				
				Yalternativa = Yalternativa + GG.Interno.alternativas[i].height + 10
			end
			-- posicionamento final do botão de verificar alternativa
			GG.textoVerifica.y = Yalternativa + 20
			
			return GG
		else
			if not atributos.y then atributos.y = 0 end
			local function mudarTamanhoGrupo(texto,grupoTamanho)
				local aux = texto.y + texto.height + 40
				if aux > grupoTamanho then
					grupoTamanho = aux
				end

				return grupoTamanho
			end


			local imagesAux
			local posicaoTexto
			local textoAlternativas = {}
			local textoEnuciado
			local tamanhoFonte
			local tamanhoFonteAlternativas
			-- verificar pasta --
			local lfs = require "lfs";
			local Pasta = nil
			local grupoTempo = display.newGroup()

			local MensagemCorreta = "CORRETA!!\nPARABÉNS!!"
			local MensagemErrada = "Opção Incorreta!"

			if atributos.mensagemErrada then
				MensagemErrada = atributos.mensagemErrada
			end
			if atributos.mensagemCorreta then
				MensagemCorreta = atributos.mensagemCorreta
			end

			local vetorTxTs = {}
			if atributos.pasta and not string.find(atributos.pasta,"nil") then

				Pasta = atributos.pasta
			end
			if Pasta ~= nil then
				local vetorTxTs = funcGlobal.lerArquivoTXT2({caminho = system.pathForFile(Pasta.."/dllTelas.txt",system.ResourceDirectory),tipo = "vetor"})
				local aux = {}
				for i=1,#vetorTxTs do
					if string.len(vetorTxTs[i])>4 then
						table.insert(aux,vetorTxTs[i])
						print(vetorTxTs[i])
					end
				end
				vetorTxTs = aux

			end
			---------------------
			local red; local green; local blue
			if atributos.posicao == "centro" then
				posicaoTexto = H/2
			else
				posicaoTexto = 50
			end
			--Posicao inciais dq questao
			
			if atributos.tamanhoFonte then
				tamanhoFonte = atributos.tamanhoFonte
			else
				tamanhoFonte = 60
			end
			if atributos.corFonte then
				red = (atributos.corFonte[1]/255)
				green = (atributos.corFonte[2]/255)
				blue = (atributos.corFonte[3]/255)
			else
				if PlanoDeFundoLibEA == "branco" then
					red,green,blue = 0,0,0
				else
					red,green,blue = 1,1,1
				end
			end
			if atributos.tamanhoFonteAlternativas then
				tamanhoFonteAlternativas = atributos.tamanhoFonteAlternativas
			else
				tamanhoFonteAlternativas = tamanhoFonte-(tamanhoFonte/3)
			end

			local xNegativo = 0
			if atributos.x and atributos.x < 0 then
				xNegativo = atributos.x
			end
			local margem = 0
			if atributos.margem then
				margem = atributos.margem
			end
			if not atributos.x then
				atributos.x = 0
			end

			local largura = 720

			if not atributos.y then
				atributos.y = 0
			end

			local options =
			{
				text = "Marque a(s) alternativa(s) correta(s):",
				x = 20,
				y = posicaoTexto,
				width = 700,
				font = native.systemFont,
				fontSize = tamanhoFonte
			}

			local optionsAlternativas =
			{
				text = "Marque a(s) alternativa(s) correta(s):",
				x = 20,
				y = 100,
				width = 700,
				font = native.systemFont,
				fontSize = tamanhoFonteAlternativas
			}

			if(atributos.alinhamento=='esquerda') then
				options.align = "esquerda"
				optionsAlternativas.align = "esquerda"
			--ALINHAMENTO DIREITA
			elseif(atributos.alinhamento=='direita') then
				options.align = "direita"
				optionsAlternativas.align = "direita"
			--ALINHAMENTO MEIO
			elseif(atributos.alinhamento=='meio') then
				options.align = "meio"
				optionsAlternativas.align = "meio"
			elseif (atributos.alinhamento=='justificado') then
				options.align = "justificado"
				optionsAlternativas.align = "justificado"
			end
			if atributos.fonte then
				if string.find(atributos.fonte, ".ttf") ~= nil then
					options.font = atributos.fonte
					optionsAlternativas.font = atributos.fonte
				end
			end

			if atributos.x then
				options.x = atributos.x + atributos.margem
			end
			if atributos.y then
				options.y = atributos.y

			end

			local grupoBotaoExercicio = display.newGroup()

			local botaoExercicio = display.newImageRect("exercicioDropDown.png",315 + (315*1/3),40 + (40*1/3))
			botaoExercicio.anchorX = 0;botaoExercicio.anchorY = 0
			botaoExercicio.x = options.x
			botaoExercicio.y = options.y
			grupoBotaoExercicio:insert(botaoExercicio)
			if atributos.numero then
				grupoBotaoExercicio.numero = atributos.numero
			else
				grupoBotaoExercicio.numero = ""
			end

			local numeroExercicio = display.newText(grupoBotaoExercicio.numero,botaoExercicio.x+250,botaoExercicio.y-2,"Fontes/ariblk.ttf",40)
			numeroExercicio:setFillColor(0,0,0)
			numeroExercicio.anchorX=0;numeroExercicio.anchorY=0;
			grupoBotaoExercicio:insert(numeroExercicio)


			local colocarFormatacaoTexto = require "colocarFormatacaoTexto"

			if atributos.enunciado then
				options.text = atributos.enunciado
			end

			if string.sub(options.text,1,1) == " " then
				options.text = string.sub(options.text,2)
				options.text = string.gsub(options.text,"\\n","\n")
			end
			local textoEnunciado = colocarFormatacaoTexto.criarTextodePalavras({texto = options.text,x = atributos.x,Y = atributos.y + botaoExercicio.height,fonte = options.font,tamanho = options.fontSize,cor = {red,green,blue}, alinhamento = atributos.alinhamento,margem = margem,xNegativo = xNegativo,largura = largura, endereco = atributos.enderecoArquivos,temHistorico = telas.temHistorico})

			if(atributos.y) then
				textoEnunciado.anchorY = 0
			end

			--textoEnunciado = display.newText(options)
			--textoEnunciado.anchorX = 0; textoEnunciado.anchorY = 0
			--textoEnunciado.y = textoEnunciado.y + botaoExercicio.height
			--textoEnunciado:setFillColor(red,green,blue)


			local textoVerifica = display.newImage("verificar.png",314 + (314*1/3),40 + (40*1/3))
			--textoVerifica:setFillColor(.7,0,0)
			textoVerifica.anchorY = 0
			textoVerifica.x = W/2
			local alternativaMarcada = "nao"
			local somatoriaCertas = 0
			local textoAlertaQuestoesCorretas = MensagemErrada
			local alert
			local numeroDeMarcadas = 0
			local function onComplete( event )
				if ( event.action == "clicked" ) then
					local i = event.index
					if ( i == 1 ) then
						-- Do nothing; dialog will simply dismiss
					elseif ( i == 2 ) then
						-- Open URL if "Learn More" (second button) was clicked
						if atributos.justificativas then
							local texto = ""
							for k=1,#atributos.justificativas do
								local textoAux = texto
								texto = textoAux .. "\n" .. k .. ") " .. atributos.justificativas[k]
							end
							native.showAlert( "Explicações", texto, {"OK"} )
						else
							native.showAlert( "Explicações", 'Não há necessidade de explicações para esta questão', {"OK"} )
						end
					end
				end
			end
			local contExercicios = 1
			if telas[paginaAtual] and telas[paginaAtual].cont then
				contExercicios = telas[paginaAtual].cont.exercicios
			end
			local function criarPaginaAlternativaMarcada(i,textoAlertaQuestoesCorretas)
				print(i,textoAlertaQuestoesCorretas)
				--if textoAlternativas[i].temArquivo ~= false then
					print(atributos.atributos.pasta,atributos.pasta,textoAlternativas[i].temArquivo..".txt")
					local arquivoPaginaExercicio = atributos.atributos.pasta.."_Pagina"..paginaAtual.."_PagExerc"..contExercicios.."Alt"..i.."_"..textoAlternativas[i].temArquivo..".txt"
					local nomePaginaExercicio = atributos.atributos.pasta.."_Pagina"..paginaAtual.."_PagExerc"..contExercicios.."Alt"..i.."_"..textoAlternativas[i].temArquivo
					local arquivoTxtDaTela
					if grupoTempo.texto.text ~= "00:00" then
						arquivoTxtDaTela = criarTeladeArquivo({pasta = atributos.atributos.pasta,arquivo = textoAlternativas[i].temArquivo..".txt",exercicio = atributos.pasta,correta = textoAlertaQuestoesCorretas,tempoResposta = "\nVocê gastou: "..grupoTempo.texto.text .. " de tempo para escolher essa alternativa",Telas = atributos.Telas},atributos.Telas,{},nomePaginaExercicio,nil)
					else
						arquivoTxtDaTela = criarTeladeArquivo({pasta = atributos.atributos.pasta,arquivo = textoAlternativas[i].temArquivo..".txt",exercicio = atributos.pasta,correta = textoAlertaQuestoesCorretas,Telas = atributos.Telas},atributos.Telas,{},nomePaginaExercicio,nil)
					end

					local vetor = {};vetor[nomePaginaExercicio] = arquivoTxtDaTela
					--vetor[NumeroPaginaCriada] = true
					vetor.numeroTotal = atributos.Telas.numeroTotal
					vetor.arquivos = atributos.Telas.arquivos
					vetor.arquivos[nomePaginaExercicio] = textoAlternativas[i].temArquivo..".txt"

					local textoExerc = lerTextoRes(atributos.pasta.."/"..textoAlternativas[i].temArquivo..".txt")
					print(atributos.pasta.."/"..textoAlternativas[i].temArquivo..".txt")
					auxFuncs.overwriteTable(arquivoTxtDaTela,nomePaginaExercicio..".json")
					if tipoSistema == "PC" then
						tablesave(  VetorDeVetorTTS,system.pathForFile("VetorTTS.json",system.DocumentsDirectory) )
					end
					VetorDeVetorTTS[nomePaginaExercicio].numero = #VetorDeVetorTTS[nomePaginaExercicio]
					--auxFuncs.overwriteTable(VetorDeVetorTTS,"VetorTTS.json")
					criarTxTDoc(arquivoPaginaExercicio,textoExerc)

					criarCursoAux(vetor, nomePaginaExercicio)
					paginaAtual = nomePaginaExercicio
				--end
			end
			local tipoquestao = "simples"
			if atributos.corretas and #atributos.corretas > 2 then
				tipoquestao = "multiplas"
			end
			local function verificarAlternativas()
				if alternativaMarcada == "nao" then
					alert = native.showAlert( "Atenção!", "Marque uma alternativa antes de verificar!", { "OK" }, onComplete )
				elseif alternativaMarcada == "sim" then
					if atributos.corretas then
						if #atributos.corretas == 1 then
							for i=1,#atributos.alternativas do
								--atributos.numero = 1
								if Var.eXercicios and Var.eXercicios ~= {} then
									local xx = 1
									for i=1,#Var.eXercicios do
										if Var.eXercicios.index == atributos.index then
											atributos.numero = xx
										end
										xx = xx+1
									end
								end
								local date = os.date( "*t" )
								if textoAlternativas[i].marcada == "sim" and i == atributos.corretas[1] then
									textoAlertaQuestoesCorretas = MensagemCorreta
									--[[local date = os.date( "*t" )
									local data = date.day.."/"..date.month.."/"..date.year
									local hora = date.hour..":"..date.min..":"..date.sec
									local numero = "1"
									if grupoBotaoExercicio.numero then numero = grupoBotaoExercicio.numero.." " end
									local pH = funcGlobal.pegarNumeroPaginaRomanosHistorico(varGlobal.PagH)
									local vetorJson = {
										tipoInteracao = "questao",
										pagina_livro = varGlobal.PagH,
										objeto_id = grupoBotaoExercicio.numero,
										acao = "verificar",
										resultado = "acerto",
										tipo = tipoquestao,
										alternativa = i,
										conteudo_alternativas = atributos.alternativas,
										conteudo_enunciado = options.text,
										relatorio = data .. "| Verificou se a alternativa "..i.." que marcou na questão "..numero.."da página "..pH.." estava correta. Foi constatado que a alternativa estava correta."
									};
									GRUPOGERAL.subPagina = grupoBotaoExercicio.numero .. "|" .. i
									funcGlobal.escreverNoHistorico(varGlobal.HistoricoVerificarQuestao.. grupoBotaoExercicio.numero .."|alternativa "..i.."|".."correta",vetorJson)]]
									if Pasta ~= nil then
										criarPaginaAlternativaMarcada(i,textoAlertaQuestoesCorretas)
									else
										alert = native.showAlert( textoAlertaQuestoesCorretas, 'Clique em "Saber Mais.." para ver as explicações das alternativas. Senão pressione "OK".', { "OK", "Saber Mais.." }, onComplete )
									end


									textoAlertaQuestoesCorretas = MensagemErrada
									somatoriaCertas = 0
									i = #atributos.alternativas
									return true
								elseif textoAlternativas[i].marcada == "sim" and i ~= atributos.corretas[1] then
									--[[local date = os.date( "*t" )
									local data = date.day.."/"..date.month.."/"..date.year
									local hora = date.hour..":"..date.min..":"..date.sec
									local numero = "1"
									if grupoBotaoExercicio.numero then numero = grupoBotaoExercicio.numero.." " end
									local pH = funcGlobal.pegarNumeroPaginaRomanosHistorico(varGlobal.PagH)
									local vetorJson = {
										tipoInteracao = "questao",
										pagina_livro = varGlobal.PagH,
										objeto_id = grupoBotaoExercicio.numero,
										acao = "verificar",
										resultado = "erro",
										tipo = tipoquestao,
										alternativa = i,
										conteudo_alternativas = atributos.alternativas,
										conteudo_enunciado = options.text,
										relatorio = data .. "| Verificou se a alternativa "..i.." que marcou na questão "..numero.."da página "..pH.." estava correta. Foi constatado que a alternativa estava errada."
									};
									GRUPOGERAL.subPagina = grupoBotaoExercicio.numero .. "|" .. i
									funcGlobal.escreverNoHistorico(varGlobal.HistoricoVerificarQuestao.. grupoBotaoExercicio.numero .."|alternativa "..i.."|".."incorreta",vetorJson)]]
									if Pasta ~= nil then
										criarPaginaAlternativaMarcada(i,textoAlertaQuestoesCorretas)
									else
										alert = native.showAlert( textoAlertaQuestoesCorretas, 'Clique em "Saber Mais.." para ver as explicações das alternativas. Senão pressione "OK".', { "OK", "Saber Mais.." }, onComplete )
									end
									somatoriaCertas = 0


									return true
								elseif i == #atributos.alternativas then
									--[[local date = os.date( "*t" )
									local data = date.day.."/"..date.month.."/"..date.year
									local hora = date.hour..":"..date.min..":"..date.sec
									local numero = "1"
									if grupoBotaoExercicio.numero then numero = grupoBotaoExercicio.numero.." " end
									local pH = funcGlobal.pegarNumeroPaginaRomanosHistorico(varGlobal.PagH)
									local vetorJson = {
										tipoInteracao = "questao",
										pagina_livro = varGlobal.PagH,
										objeto_id = grupoBotaoExercicio.numero,
										acao = "verificar",
										resultado = "erro",
										tipo = tipoquestao,
										alternativa = i,
										conteudo_alternativas = atributos.alternativas,
										conteudo_enunciado = options.text,
										relatorio = data .. "| Verificou se a alternativa "..i.." que marcou na questão "..numero.."da página "..pH.." estava correta. Foi constatado que a alternativa estava errada."
									};
									GRUPOGERAL.subPagina = grupoBotaoExercicio.numero .. "|" .. i
									funcGlobal.escreverNoHistorico(varGlobal.HistoricoVerificarQuestao.. grupoBotaoExercicio.numero .."|alternativa "..i.."|".."incorreta",vetorJson)]]
									if Pasta ~= nil then
										criarPaginaAlternativaMarcada(i,textoAlertaQuestoesCorretas)
									else
										alert = native.showAlert( textoAlertaQuestoesCorretas, 'Clique em "Saber Mais.." para ver as explicações das alternativas. Senão pressione "OK".', { "OK", "Saber Mais.." }, onComplete )
									end

									somatoriaCertas = 0
									return true
								end
							end
						elseif #atributos.corretas > 1 then
							for i=1,#atributos.alternativas do
								if textoAlternativas[i].marcada == "sim" then
									for j=1,#atributos.corretas do
										if i == atributos.corretas[j] then
											local somaAux = somatoriaCertas
											somatoriaCertas = somaAux + 1
										end
									end
								end
							end
							if somatoriaCertas == #atributos.corretas then

								textoAlertaQuestoesCorretas = MensagemCorreta

								if Pasta ~= nil then
									criarPaginaAlternativaMarcada(i,textoAlertaQuestoesCorretas)
								else
									alert = native.showAlert( textoAlertaQuestoesCorretas, 'Clique em "Saber Mais.." para ver as explicações das alternativas. Senão pressione "OK".', { "OK", "Saber Mais.." }, onComplete )
								end
								textoAlertaQuestoesCorretas = MensagemErrada
								somatoriaCertas = 0
							else
								if somatoriaCertas == 1 then

									if Pasta ~= nil then
										criarPaginaAlternativaMarcada(i,textoAlertaQuestoesCorretas)
									else
										alert = native.showAlert( textoAlertaQuestoesCorretas, 'Clique em "Saber Mais.." para ver as explicações das alternativas. Senão pressione "OK".', { "OK", "Saber Mais.." }, onComplete )
									end
									textoAlertaQuestoesCorretas = "Questão Incorreta!"
									somatoriaCertas = 0
								elseif somatoriaCertas > 1 or somatoriaCertas == 0 then

									if Pasta ~= nil then
										criarPaginaAlternativaMarcada(i,textoAlertaQuestoesCorretas)
									else
										alert = native.showAlert( textoAlertaQuestoesCorretas, 'Clique em "Saber Mais.." para ver as explicações das alternativas. Senão pressione "OK".', { "OK", "Saber Mais.." }, onComplete )
									end
									textoAlertaQuestoesCorretas = MensagemErrada
									somatoriaCertas = 0
								end
							end
						end
					end
				end
			end
			textoVerifica:addEventListener("tap",verificarAlternativas)
			if atributos.alternativas then
				for i=1,#atributos.alternativas do
					if string.sub(atributos.alternativas[i],1,1) == " " then
						atributos.alternativas[i] = string.sub(atributos.alternativas[i],2)
					end
					textoAlternativas[i] = colocarFormatacaoTexto.criarTextodePalavras({texto = i..") - "..atributos.alternativas[i],x = atributos.x,Y = atributos.y,fonte = optionsAlternativas.font,tamanho = optionsAlternativas.fontSize,cor = {red,green,blue}, alinhamento = atributos.alinhamento,margem = margem,xNegativo = xNegativo,largura = largura, endereco = atributos.enderecoArquivos,temHistorico = telas.temHistorico})
					textoAlternativas[i].y = textoAlternativas[i].y + botaoExercicio.height + textoEnunciado.height+ 50

					--textoAlternativas[i] = display.newText(optionsAlternativas)
					--textoAlternativas[i].text = i.." ( ) "..atributos.alternativas[i]
					textoAlternativas[i].marcada = "nao"
					--textoAlternativas[i].anchorX = 0; textoAlternativas[i].anchorY = 0
					--textoAlternativas[i]:setFillColor(red,green,blue)
					--textoAlternativas[i].y = atributos.y + botaoExercicio.height + textoEnunciado.height+ 50
					textoAlternativas[i].temArquivo = false
					if Pasta ~= nil and fileExistsX(Pasta.."/"..i..".txt") then

						textoAlternativas[i].temArquivo = i
					elseif Pasta ~= nil then
						local path = string.gsub(system.pathForFile(Pasta.."/dllTelas.txt"),"/dllTelas.txt","")
						criarArquivoTXT({caminho = path,arquivo = i..".txt",variavel = "1 - separador"})
						textoAlternativas[i].temArquivo = i
					end
					if i ~= 1 then
						textoAlternativas[i].y = textoAlternativas[i-1].y + textoAlternativas[i-1].height + 20
					end
					if i == #atributos.alternativas then
						textoVerifica.y = atributos.y + textoAlternativas[i].y + textoAlternativas[i].height+10

						imagesAux = display.newRect(textoAlternativas[i].x,textoAlternativas[1].y,650,textoVerifica.y-textoAlternativas[1].y)
						imagesAux.anchorX = 0; imagesAux.anchorY = 0
						imagesAux:setFillColor(1,0,0); imagesAux.alpha = 0
						imagesAux.isHitTestable = false
					end
					textoAlternativas[i].i = i
					textoAlternativas[i].textoOriginal = atributos.alternativas[i]
					if atributos.corretas then
						for j=1,#atributos.corretas do
							if textoAlternativas[i] == atributos.corretas[j] then
								textoAlternativas[i].correta = true
							else
								textoAlternativas[i].correta = false
							end
						end
					end
					local function marcarQuestao(e)
						if e.target.marcada then

							if e.target.marcada == "sim" then
								e.target.marcada = "nao"
								--e.target.text = e.target.i.." ( ) ".. e.target.textoOriginal
								e.target.alpha = 1
								e.target.marcada = "nao"
								alternativaMarcada = "nao"
								for i=1,#atributos.alternativas do
									if textoAlternativas[i].marcada == "sim" then
										alternativaMarcada = "sim"
									end
								end
								local numeroAux = numeroDeMarcadas
								numeroDeMarcadas = numeroAux - 1
								--[[local date = os.date( "*t" )
								local data = date.day.."/"..date.month.."/"..date.year
								local hora = date.hour..":"..date.min..":"..date.sec
								local numero = "1"
								if grupoBotaoExercicio.numero then numero = grupoBotaoExercicio.numero.." " end
								local pH = funcGlobal.pegarNumeroPaginaRomanosHistorico(varGlobal.PagH)
								local vetorJson = {
									tipoInteracao = "questao",
									pagina_livro = varGlobal.PagH,
									objeto_id = grupoBotaoExercicio.numero,
									acao = "desmarcar alternativa",
									alternativa = e.target.indexHist,
									tipo = tipoquestao,
									conteudo_alternativas = atributos.alternativas,
									conteudo_enunciado = options.text,
									relatorio = data .. "| Desmarcou a alternativa "..i.." na questão "..numero.."da página "..pH.."."
								};
								GRUPOGERAL.subPagina = grupoBotaoExercicio.numero .. "|" .. i
								funcGlobal.escreverNoHistorico(varGlobal.HistoricoDesmarcarQuestao.. grupoBotaoExercicio.numero .."|alternativa "..i,vetorJson)]]
							elseif e.target.marcada == "nao" then
								--print("marcou",textoAlternativas[i].i)
								e.target.marcada = "sim"
								--e.target.text = e.target.i.." (X) ".. e.target.textoOriginal
								e.target.alpha = .5
								e.target.marcada = "sim"
								alternativaMarcada = "sim"
								local numeroAux = numeroDeMarcadas
								numeroDeMarcadas = numeroAux + 1
								--[[local date = os.date( "*t" )
								local data = date.day.."/"..date.month.."/"..date.year
								local hora = date.hour..":"..date.min..":"..date.sec
								local numero = "1"
								if grupoBotaoExercicio.numero then numero = grupoBotaoExercicio.numero.." " end
								local pH = funcGlobal.pegarNumeroPaginaRomanosHistorico(varGlobal.PagH)
								local vetorJson = {
									tipoInteracao = "questao",
									pagina_livro = varGlobal.PagH,
									objeto_id = grupoBotaoExercicio.numero,
									acao = "escolher alternativa",
									tipo = tipoquestao,
									alternativa = e.target.indexHist,
									conteudo_alternativas = atributos.alternativas,
									conteudo_enunciado = options.text,
									relatorio = data .. "| Marcou a alternativa "..i.." na questão "..numero.."da página "..pH.."."
								};
								GRUPOGERAL.subPagina = grupoBotaoExercicio.numero .. "|" .. i
								funcGlobal.escreverNoHistorico(varGlobal.HistoricoMarcarQuestao.. grupoBotaoExercicio.numero .."|alternativa "..i,vetorJson)]]
							end

						else
							e.target.marcada = "sim"
							--e.target.text = e.target.i.." (X) "..atributos.alternativas[i]
							e.target.alpha = .5
							alternativaMarcada = "sim"
							local numeroAux = numeroDeMarcadas
							numeroDeMarcadas = numeroAux + 1
							--[[local date = os.date( "*t" )
							local data = date.day.."/"..date.month.."/"..date.year
							local hora = date.hour..":"..date.min..":"..date.sec
							local pH = funcGlobal.pegarNumeroPaginaRomanosHistorico(varGlobal.PagH)
							local vetorJson = {
								tipoInteracao = "questao",
								pagina_livro = varGlobal.PagH,
								objeto_id = grupoBotaoExercicio.numero,
								acao = "escolher alternativa",
								tipo = tipoquestao,
								alternativa = e.target.indexHist,
								conteudo_alternativas = atributos.alternativas,
								conteudo_enunciado = options.text,
								relatorio = data .. "| Marcou a alternativa "..i.." na questão "..numero.."da página "..pH.."."
							};
							GRUPOGERAL.subPagina = grupoBotaoExercicio.numero .. "|" .. i
							funcGlobal.escreverNoHistorico(varGlobal.HistoricoMarcarQuestao.. grupoBotaoExercicio.numero .."|alternativa "..i,vetorJson)]]
						end
						if #atributos.corretas == 1 then
							for i=1,#textoAlternativas do
								if textoAlternativas[i].i ~= e.target.i then
									--print("desmarcou",textoAlternativas[i].i)
									--textoAlternativas[i].text = i.." ( ) ".. textoAlternativas[i].textoOriginal
									textoAlternativas[i].alpha = 1
									textoAlternativas[i].marcada = "nao"
									local numeroAux = numeroDeMarcadas
									numeroDeMarcadas = numeroAux - 1
								end
							end
						end
						return true
					end
					textoAlternativas[i].indexHist = i
					textoAlternativas[i]:addEventListener("tap",marcarQuestao)
					textoAlternativas[i]:addEventListener("tap",function() return true; end)
				end
				imagesAux:addEventListener("tap",function() return true; end)
				--imagesAux:addEventListener("touch",function() return true; end)
			end
			local grupo = display.newGroup()


			grupoTempo.botaoTempo = display.newImageRect("tempoAtivado.png",120 + (120*1/3),botaoExercicio.height+2)
			grupoTempo.botaoTempo.anchorX = 0;grupoTempo.botaoTempo.anchorY = 0
			grupoTempo.botaoTempo.x = botaoExercicio.x + botaoExercicio.width
			grupoTempo.botaoTempo.y = botaoExercicio.y-1
			grupoTempo.botaoTempo.isVisible = true
			grupoTempo.botaoTempo.fill.effect = "filter.desaturate"
			grupoTempo.botaoTempo.fill.effect.intensity = 0
			grupoTempo.botaoTempo.ativado = true
			grupoTempo:insert(grupoTempo.botaoTempo)

			-- grupoTempo.botaoTempo2 = display.newImageRect("tempo2.png",150 + (150*1/3),botaoExercicio.height+2)
			-- grupoTempo.botaoTempo2.anchorX = 0;grupoTempo.botaoTempo2.anchorY = 0
			-- grupoTempo.botaoTempo2.x = botaoExercicio.x + botaoExercicio.width + 10
			-- grupoTempo.botaoTempo2.y = botaoExercicio.y-1
			-- grupoTempo.botaoTempo2.isVisible = true
			-- grupoTempo.botaoTempo2.fill.effect = "filter.desaturate"
			-- grupoTempo.botaoTempo2.fill.effect.intensity = 0
			-- grupoTempo.botaoTempo2.ativado = true
			-- grupoTempo:insert(grupoTempo.botaoTempo2)


			local function SecondsToClock(seconds)
			  local seconds = tonumber(seconds)

			  if seconds <= 0 then
				return "00:00";
			  else
				hours = string.format("%02.f", math.floor(seconds/3600));
				mins = string.format("%02.f", math.floor(seconds/60 - (hours*60)));
				secs = string.format("%02.f", math.floor(seconds - hours*3600 - mins *60));
				return --[[hours..":"..]]mins..":"..secs
			  end
			end

			--atributos.tempo = "sim"
			--if atributos.tempo then
			local tempo = SecondsToClock(0)
			grupoTempo.texto = display.newText(tempo,0,0,"Fontes/ariblk.ttf",32)
			grupoTempo.texto.anchorX=0;grupoTempo.texto.anchorY=0
			grupoTempo.texto.x = grupoTempo.botaoTempo.x + 11
			grupoTempo.texto.y = grupoTempo.botaoTempo.y + 4 + grupoBotaoExercicio.y
			grupoTempo.texto.isVisible = true
			grupoTempo:insert(grupoTempo.texto)
			--end

			if atributos.tempo and string.find(atributos.tempo,"sim") then
				grupoTempo.tempo = "sim"
			end

			--[[local function desativarAtivarTempo()
				if grupoTempo.botaoTempo.ativado == true then -- desativar
					--grupoTempo.botaoTempo.fill.effect.intensity = 1
					grupoTempo.botaoTempo2.isVisible = true
					grupoTempo.botaoTempo.ativado = false
				else -- ativar
					-- grupoTempo.botaoTempo.fill.effect.intensity = 0
					grupoTempo.botaoTempo2.isVisible = false
					grupoTempo.botaoTempo.ativado = true
				end
			end
			grupoTempo.botaoTempo:addEventListener("tap",desativarAtivarTempo)]]

			for i=1,#textoAlternativas do
				grupo:insert(textoAlternativas[i])
			end
			grupo:insert(textoEnunciado)
			grupo:insert(textoVerifica)
			if imagesAux then
				grupo:insert(imagesAux)
			end
			local tamanhoTudo = (textoVerifica.y+textoVerifica.height)-textoEnunciado.y
			textoAlternativas.altura = tamanhoTudo
			if atributos.index then botaoExercicio.index = atributos.index; grupoBotaoExercicio.index = atributos.index end
			local LIXO =  display.newGroup()
			for i=1,#textoAlternativas do
				textoAlternativas[i].isVisible = false
			end
			LIXO:insert(textoEnunciado)
			textoEnunciado.isVisible = false
			LIXO:insert(textoVerifica)
			textoVerifica.isVisible = false

			--LIXO:insert(botaoExercicio)
			botaoExercicio.HH = LIXO.height + botaoExercicio.height
			grupoBotaoExercicio.HH = LIXO.height + botaoExercicio.height
			print("LIXO = ",botaoExercicio.HH)
			--LIXO.isVisible = false
			grupoTempo.isVisible = false
			return textoAlternativas, textoEnunciado, textoVerifica, imagesAux, grupoBotaoExercicio,grupoTempo
		end
	end
end
--------------------------------------------------
--	COLOCAR DECK								--
--------------------------------------------------
function M.checarCardsOnlinePagina(pagina,telas)
	if telas.idLivro1 then
		local json = require("json")
		local parameters = {}
		parameters.body = "consulta=1&idLivro=" .. telas.idLivro1  .. "&idUsuario=" .. telas.idAluno1 .. "&pagina=" .. pagina
		local URL2 = "https://omniscience42.com/EAudioBookDB/deck.php"
		network.request(URL2, "POST", 
			function(event)
				if ( event.isError ) then
					native.showAlert("Atenção","Não foi possível baixar os dados dos cards da nuvem. Verifique sua conexão com a internet",{"OK"})
				else
					local data = json.decode(event.response)
					if data and data.N then
						local vetorCards = {}
						for i=1,data.N  do table.insert(vetorCards,data[tostring(i)]) end
						auxFuncs.saveTable( vetorCards, "Deck_pag"..pagina..".json" )
					end
				end
			end,parameters)
		parameters.body = "consulta=1&idLivro=" .. telas.idLivro1  .. "&idUsuario=" .. telas.idProprietario1 .. "&pagina=" .. pagina
		local URL2 = "https://omniscience42.com/EAudioBookDB/deck.php"
		network.request(URL2, "POST", 
			function(event)
				if ( event.isError ) then
					native.showAlert("Atenção","Não foi possível baixar os dados dos cards da nuvem. Verifique sua conexão com a internet",{"OK"})
				else
					local data = json.decode(event.response)
					if data and data.N then
						local vetorCards = {}
						for i=1,data.N  do table.insert(vetorCards,data[tostring(i)]) end
						auxFuncs.saveTable( vetorCards, "Deck_pag"..pagina.."Autor.json" )
					end
				end
			end,parameters)
	end
end
function M.criarBotaoDecks(decks,pagina,telas,varGlobal,Var)
	local Deck = display.newGroup()
	local vetorDeTextosDosCards = {}
	local vetorDeTextosDosCardsAutor = {}
	if auxFuncs.fileExistsDoc("Deck_pag"..pagina..".json") then
		vetorDeTextosDosCards = auxFuncs.loadTable("Deck_pag"..pagina..".json")
	end
	if auxFuncs.fileExistsDoc("Deck_pag"..pagina.."Autor.json") then
		vetorDeTextosDosCardsAutor = auxFuncs.loadTable("Deck_pag"..pagina.."Autor.json")
	end
	
	function Deck.fecharJanelaCards(event)
		historicoLib.Criar_e_salvar_vetor_historico({
			tipoInteracao = "deck",
			pagina_livro = pagina,
			acao = "fechar",
			tela = telas
		})
		if Deck.grupoJCards then
			audio.stop()
			Deck.grupoJCards:removeSelf()
			Deck.grupoJCards = nil
		end
		local somFechando = audio.loadSound(varGlobal.ttsDeckFechar)
		audio.play(somFechando)
		return true
	end
	
	local function abrirJanelaDeCards(e)
		if e.target.clicado == false  then
			audio.stop()
			media.stopSound()
			
			local som = audio.loadStream(varGlobal.ttsDeckMenuRapido1Clique)
			local timerRequerimento = timer.performWithDelay(16,function() audio.play(som) end,1)
			e.target.clicado = true
			timer.performWithDelay(1000,function() e.target.clicado = false end,1)
			if Var.mensagemTemp and Var.mensagemTemp.remover then
				Var.mensagemTemp.remover()
			end
			Var.mensagemTemp = auxFuncs.criarMensagemTemporaria(varGlobal.linguagem_MensagemTemp,e.x,e.y,400,200,2000)
			return true
		end
		if e.target.clicado == true  then
			if Var.mensagemTemp and Var.mensagemTemp.remover then
				Var.mensagemTemp.remover()
			end
			audio.stop()
			e.target.clicado = false
			local somAbrindo = audio.loadSound(varGlobal.ttsDeckAbrir)
			audio.play(somAbrindo)
			Deck.grupoJCards = display.newGroup()
			local cardDeck = display.newGroup()
			Deck.protecaoJanelaDeCards = auxFuncs.TelaProtetiva()
			Deck.grupoJCards:insert(Deck.protecaoJanelaDeCards)
			
			historicoLib.Criar_e_salvar_vetor_historico({
				tipoInteracao = "deck",
				pagina_livro = pagina,
				acao = "abrir",
				tela = telas
			})
			
			local fundo = M.colocarSeparador({espessura = H,largura = W-60,cor = {255,255,255}})
			fundo.strokeWidth = 5
			fundo:setStrokeColor(46/255,171/255,200/255)
			fundo.height = H - 150
			fundo.x,fundo.y = W/2,100
			Deck.grupoJCards:insert(fundo)
			
			
			
			local fechar = widget.newButton {
				onRelease = Deck.fecharJanelaCards,
				emboss = false,
				-- Properties for a rounded rectangle button
				defaultFile = "closeMenuButton2.png",
				overFile = "closeMenuButton2D.png"
			}
			fechar.clicado = false
			fechar.tipo = "fechar"
			fechar.x = W - 30 - fechar.width/2
			fechar.y = 100 + fechar.height/2
			Deck.grupoJCards:insert(fechar)
			
			cardDeck.cards = {}
			cardDeck.numero = 1
			cardDeck.total = #decks
			for i=1,#decks do
				cardDeck.cards[i] = display.newGroup()
				Deck.grupoJCards:insert(cardDeck.cards[i])
				
				cardDeck.cards[i].titulo = colocarFormatacaoTexto.criarTextodePalavras({
					texto = decks[i].titulo,
					margem = 70,
					alinhamento = "meio",
					cor = {0,0,0},
					x = nil,
					Y = 0,
					fonte = "Fontes/segoeui.ttf",
					tamanho = 40,
					xNegativo = nil,
					temHistorico = false
				})
				cardDeck.cards[i].titulo.y = 0
				cardDeck.cards[i].separadorTitulo = M.colocarSeparador({espessura = 10,largura = W-80,cor = {0,0,0},raio = 5,x=W/2,Y=0})
				cardDeck.cards[i].separadorTitulo.y=cardDeck.cards[i].titulo.y + cardDeck.cards[i].titulo.height + 20
				local posY = cardDeck.cards[i].separadorTitulo.y + cardDeck.cards[i].separadorTitulo.height + 20
				local posX = W/2
				cardDeck.cards[i].elemento = nil
				
				cardDeck.scrollView = {}
				cardDeck.trocarTamanhoScroll = function(newHeight)
					cardDeck.scrollView:setScrollHeight( newHeight )
				end
				if decks[i].texto then
					cardDeck.cards[i].texto = colocarFormatacaoTexto.criarTextodePalavras({
						texto = decks[i].texto,
						margem = 35,
						alinhamento = "justificado",
						cor = {0,0,0},
						x = nil,
						Y = posY,
						fonte = "Fontes/segoeui.ttf",
						tamanho = 30,
						xNegativo = nil,
						temHistorico = false,
						card = i
					})
				end
				
				if decks[i].tipo == "imagem" then
					print("|"..tostring(decks[i].arquivo).."|")
					local imagem = telas.pastaArquivosAtual.."/Outros Arquivos/imagemErro.jpg"
					if decks[i].arquivo then imagem = decks[i].arquivo end
					cardDeck.cards[i].elemento = M.colocarImagem({
						arquivo = imagem,
						y = posY,
						margem = 40,
						card = i
					})
					cardDeck.cards[i].elemento.x = W/2 - cardDeck.cards[i].elemento.width/2
				elseif decks[i].tipo == "video" then
					local video = telas.pastaArquivosAtual.."/Outros Arquivos/video vazio.m4v"
					if decks[i].arquivo then video = decks[i].arquivo end
					cardDeck.cards[i].elemento = M.colocarVideo({
						arquivo = video,
						x = 0,
						margem = 40,
						card = i
					},telas)
					cardDeck.cards[i].elemento.y = posY
					cardDeck.cards[i].elemento.x = W/2
					cardDeck.cards[i].elemento.xScale = .8
					cardDeck.cards[i].elemento.yScale = .8
				elseif decks[i].tipo == "som" or decks[i].tipo == "audio" then
					local som = telas.pastaArquivosAtual.."/Outros Arquivos/som vazio.WAV"
					if decks[i].arquivo then som = decks[i].arquivo end
					cardDeck.cards[i].elemento = M.colocarSom({
						arquivo = som,
						x = 0,
						margem = 40,
						card = i
					},telas)
					cardDeck.cards[i].elemento.y = posY
					cardDeck.cards[i].elemento.x = W/2 - (cardDeck.cards[i].elemento.width/2)*.8
					cardDeck.cards[i].elemento.xScale = .8
					cardDeck.cards[i].elemento.yScale = .8
				elseif decks[i].tipo == "animacao" then
					local pasta = telas.pastaArquivosAtual.."/Outros Arquivos/Anim Padrao.lib"
					if decks[i].pasta then pasta = decks[i].pasta end
					cardDeck.cards[i].elemento = M.colocarAnimacao({
						pasta = pasta,
						x = 0,
						margem = 40,
						card = i,
						som = decks[i].som,
						tempoPorImagem = decks[i].tempoPorImagem,
						imagens = decks[i].imagens
					},telas)
					cardDeck.cards[i].elemento.y = posY
					cardDeck.cards[i].elemento.x = W/2 -- (cardDeck.cards[i].elemento.width/2)*.8
					cardDeck.cards[i].elemento.xScale = .8
					cardDeck.cards[i].elemento.yScale = .8
				elseif decks[i].tipo == "exercicio" or decks[i].tipo == "questao" then
					cardDeck.cards[i].elemento = M.criarExercicio({
						pasta = decks[i].pasta,
						enunciado = decks[i].enunciado,
						alternativas = decks[i].alternativas,
						corretas = decks[i].corretas,
						alinhamento = "justificado",
						x = 0,
						y = 0,
						tamanhoFonte = 55,
						tamanhoFonteAlternativas = 40,
						margem = 40,
						tipo = "CARD",
						mensagemCorreta = decks[i].mensagemCorreta,
						mensagemErrada = decks[i].mensagemErrada,
						funcaoCard = cardDeck.trocarTamanhoScroll,
						card = i
					},telas)
					cardDeck.cards[i].elemento.y = posY

				end
				if cardDeck.cards[i].elemento then 
					posY = posY + cardDeck.cards[i].elemento.height
				end
				
				cardDeck.cards[i].isVisible = false
				
				
				cardDeck.cards[i].grupoCardContainer = display.newGroup()
				
				cardDeck.cards[i].fundo = display.newRect(0,0,W-70,10)
				cardDeck.cards[i].fundo.anchorY=0
				cardDeck.cards[i].fundo.x = W/2
				local posFundoFinal = cardDeck.cards[i].separadorTitulo.y + cardDeck.cards[i].separadorTitulo.height
				
				if cardDeck.cards[i].texto and cardDeck.cards[i].elemento then
					cardDeck.cards[i].elemento.y = cardDeck.cards[i].elemento.y + cardDeck.cards[i].texto.height + 10
					posFundoFinal = posY + cardDeck.cards[i].texto.height + 10
				elseif cardDeck.cards[i].texto then
					posFundoFinal = posY + cardDeck.cards[i].texto.height + 10
				else
					posFundoFinal = posY
				end
				
				if vetorDeTextosDosCardsAutor and vetorDeTextosDosCardsAutor[i] and vetorDeTextosDosCardsAutor[i].texto then
					cardDeck.cards[i].textoAutor = colocarFormatacaoTexto.criarTextodePalavras({
						texto = "\n #font=ariblk.ttf#COMPLEMENTOS - ATUALIZAÇÕES#/font# \n"..vetorDeTextosDosCardsAutor[i].texto,
						margem = 35,
						alinhamento = "justificado",
						cor = {0,0,0},
						x = nil,
						Y = posFundoFinal + 10,
						fonte = "Fontes/segoeuib.ttf",
						tamanho = 29,
						xNegativo = nil,
						temHistorico = false,
						card = i
					})
					posFundoFinal = posFundoFinal + cardDeck.cards[i].textoAutor.height + 10
				end
				
				cardDeck.cards[i].fundo.height = posFundoFinal + 50
				
				cardDeck.cards[i].grupoCardContainer:insert(cardDeck.cards[i].fundo)
				cardDeck.cards[i].grupoCardContainer:insert(cardDeck.cards[i].titulo)
				cardDeck.cards[i].grupoCardContainer:insert(cardDeck.cards[i].separadorTitulo)
				if cardDeck.cards[i].texto then
					cardDeck.cards[i].grupoCardContainer:insert(cardDeck.cards[i].texto)
				end
				if cardDeck.cards[i].elemento then
					cardDeck.cards[i].grupoCardContainer:insert(cardDeck.cards[i].elemento)
				end
				if cardDeck.cards[i].textoAutor then
					cardDeck.cards[i].grupoCardContainer:insert(cardDeck.cards[i].textoAutor)
				end
				
				
				
				cardDeck.cards[i].grupoCardContainer.x = -35
				
				local function scrollListener( event )
					local phase = event.phase
					if ( phase == "began" ) then --print( "Scroll view was touched" )
					elseif ( phase == "moved" ) then --print( "Scroll view was moved" )
					elseif ( phase == "ended" ) then --print( "Scroll view was released" )
					end
					-- In the event a scroll limit is reached...
					if ( event.limitReached ) then
						if ( event.direction == "up" ) then --print( "Reached bottom limit" )
						elseif ( event.direction == "down" ) then --print( "Reached top limit" )
						elseif ( event.direction == "left" ) then --print( "Reached right limit" )
						elseif ( event.direction == "right" ) then --print( "Reached left limit" )
						end
					end
				 
					return true
				end
				cardDeck.scrollView = widget.newScrollView(
					{
						top = fechar.y+fechar.height/2,
						left = 35,
						width = W-70,
						height = 750,
						scrollWidth = W-70,
						scrollHeight = cardDeck.cards[i].grupoCardContainer.height,
						horizontalScrollDisabled = true,
						listener = scrollListener
					}
				)
				 
				-- Create a image and insert it into the scroll view
				cardDeck.scrollView:insert( cardDeck.cards[i].grupoCardContainer )
				cardDeck.cards[i]:insert(cardDeck.scrollView)
			end
			cardDeck.cards[cardDeck.numero].isVisible = true
			
			
			
			local function mudarCard(e)
				audio.stop()
				local botao = e.target
				local soma = 0
				cardDeck.TextBox.text = ""
				cardDeck.TextBox.oldText = ""
				if botao.tipo == "voltar" then
					cardDeck.botaoAvancar.isVisible = true
					if cardDeck.numero > 1 then 
						cardDeck.numero = cardDeck.numero - 1 
						cardDeck.cards[cardDeck.numero+1].isVisible = false
						cardDeck.cards[cardDeck.numero].isVisible = true
						cardDeck.numeroCard.text = "Card ".. cardDeck.numero .. "/" .. cardDeck.total
					end
					if cardDeck.numero == 1 then cardDeck.botaoVoltar.isVisible = false end
				elseif botao.tipo == "avancar" then
					cardDeck.botaoVoltar.isVisible = true
					if cardDeck.numero < cardDeck.total then 
						cardDeck.numero = cardDeck.numero + 1 
						cardDeck.cards[cardDeck.numero-1].isVisible = false
						cardDeck.cards[cardDeck.numero].isVisible = true
						cardDeck.numeroCard.text = "Card ".. cardDeck.numero .. "/" .. cardDeck.total
					end
					if cardDeck.numero == cardDeck.total then cardDeck.botaoAvancar.isVisible = false end
				end
				if vetorDeTextosDosCards[cardDeck.numero] and vetorDeTextosDosCards[cardDeck.numero].texto then
					print("criou algo antes",cardDeck.numero,vetorDeTextosDosCards[cardDeck.numero].texto)
					cardDeck.TextBox.text = vetorDeTextosDosCards[cardDeck.numero].texto
					cardDeck.TextBox.oldText = vetorDeTextosDosCards[cardDeck.numero].texto
				end
			end
			
			cardDeck.botaoVoltar = widget.newButton {
				defaultFile = "backButton.png",
				overFile = "backButtonD.png",
				width = 160,
				height = 80,
				onRelease = mudarCard
			}
			cardDeck.botaoVoltar.tipo = "voltar"
			cardDeck.botaoVoltar.isVisible = false
			cardDeck.botaoVoltar.x = fundo.x - fundo.width/2 + cardDeck.botaoVoltar.width/2 + 5
			cardDeck.botaoVoltar.y = fundo.y + fundo.height - cardDeck.botaoVoltar.height/2 - 5
			Deck.grupoJCards:insert(cardDeck.botaoVoltar)
			
			cardDeck.botaoAvancar = widget.newButton {
				defaultFile = "forwardButton.png",
				overFile = "forwardButtonD.png",
				width = 160,
				height = 80,
				onRelease = mudarCard
			}
			cardDeck.botaoAvancar.tipo = "avancar"
			cardDeck.botaoAvancar.x = fundo.x + fundo.width/2 - cardDeck.botaoAvancar.width/2 - 5
			cardDeck.botaoAvancar.y = fundo.y + fundo.height - cardDeck.botaoAvancar.height/2 - 5
			Deck.grupoJCards:insert(cardDeck.botaoAvancar)
			
			cardDeck.numeroCard = display.newText("Card ".. 1 .. "/" .. #decks,W/2,0,0,0,"Fontes/paolaAccent.ttf",60)
			cardDeck.numeroCard.y = cardDeck.botaoAvancar.y
			cardDeck.numeroCard:setFillColor(46/255,171/255,200/255)
			Deck.grupoJCards:insert(cardDeck.numeroCard)
			
			cardDeck.separadorNumeroCard = M.colocarSeparador({espessura = 5,largura = W-60,cor = {46/255,171/255,200/255}})
			cardDeck.separadorNumeroCard:setFillColor(46/255,171/255,200/255)
			cardDeck.separadorNumeroCard.x = W/2
			cardDeck.separadorNumeroCard.y = cardDeck.botaoAvancar.y - cardDeck.botaoAvancar.height/2 - cardDeck.separadorNumeroCard.height
			Deck.grupoJCards:insert(cardDeck.separadorNumeroCard)
			
			local function boxListener( event )
					if ( event.phase == "began" ) then
						transition.to(cardDeck.TextBox,{time=0,y = H/2 - cardDeck.TextBox.height/2})
						transition.to(cardDeck.TextBoxFundo,{time=0,y = H/2 - cardDeck.TextBox.height/2})
						cardDeck.ZoomSair.isVisible=true
						cardDeck.ZoomSair.isHitTestable=true
					elseif ( event.phase == "ended" or event.phase == "submitted" ) then
						transition.to(cardDeck.TextBox,{time=0,y = cardDeck.separadorNumeroCard.y - cardDeck.separadorNumeroCard.height - cardDeck.TextBox.height/2 - 5})
						transition.to(cardDeck.TextBoxFundo,{time=0,y = cardDeck.separadorNumeroCard.y - cardDeck.separadorNumeroCard.height - cardDeck.TextBox.height/2 - 5})
						cardDeck.ZoomSair.isVisible = false
						cardDeck.ZoomSair.isHitTestable=false
					elseif ( event.phase == "editing" ) then
						transition.to(cardDeck.TextBox,{time=0,y = H/2 - cardDeck.TextBox.height/2})
						transition.to(cardDeck.TextBoxFundo,{time=0,y = H/2 - cardDeck.TextBox.height/2})
						cardDeck.ZoomSair.isVisible=true
						cardDeck.ZoomSair.isHitTestable=true

					end
				end
			
			cardDeck.TextBox = native.newTextBox(cardDeck.separadorNumeroCard.x - 40,0,570,200)
			cardDeck.TextBox.y = cardDeck.separadorNumeroCard.y - cardDeck.separadorNumeroCard.height - cardDeck.TextBox.height/2 - 5
			cardDeck.TextBox.hasBackground = false
			cardDeck.TextBox:setReturnKey("default")
			cardDeck.TextBox.isEditable = true
			cardDeck.TextBox.size = 30
			cardDeck.TextBox:addEventListener( "userInput", boxListener )
			Deck.grupoJCards:insert(cardDeck.TextBox)
			cardDeck.TextBox.isVisible = true
			cardDeck.TextBox.placeholder = "...observações pessoais"
			if not vetorDeTextosDosCards[cardDeck.numero] then
				vetorDeTextosDosCards[cardDeck.numero] = {}
			end
			if not vetorDeTextosDosCards[cardDeck.numero].texto then vetorDeTextosDosCards[cardDeck.numero].texto = "" end
			cardDeck.TextBox.text = vetorDeTextosDosCards[cardDeck.numero].texto
			cardDeck.TextBox.oldText = vetorDeTextosDosCards[cardDeck.numero].texto
			
			cardDeck.ZoomSair = auxFuncs.TelaProtetiva()
			cardDeck.ZoomSair.alpha = .3
			cardDeck.ZoomSair.isHitTestable=false
			Deck.grupoJCards:insert(cardDeck.ZoomSair)
			cardDeck.ZoomSair:addEventListener("tap",
				function() 
					transition.to(cardDeck.TextBox,{time=0,y = cardDeck.separadorNumeroCard.y - cardDeck.separadorNumeroCard.height - cardDeck.TextBox.height/2 - 5})
					transition.to(cardDeck.TextBoxFundo,{time=0,y = cardDeck.separadorNumeroCard.y - cardDeck.separadorNumeroCard.height - cardDeck.TextBox.height/2 - 5})
					cardDeck.ZoomSair.isVisible = false
					cardDeck.ZoomSair.isHitTestable=false
					native.setKeyboardFocus(nil)
				end)
			
			
			
			cardDeck.TextBoxFundo = display.newRoundedRect(0,0,650-2,200-2,10)
			cardDeck.TextBoxFundo.strokeWidth = 6
			cardDeck.TextBoxFundo:setFillColor(1,1,1)
			cardDeck.TextBoxFundo:setStrokeColor(46/510,171/510,200/510)
			cardDeck.TextBoxFundo.x = cardDeck.TextBox.x + 40+1
			cardDeck.TextBoxFundo.y = cardDeck.TextBox.y
			Deck.grupoJCards:insert(cardDeck.TextBoxFundo)
			local function salvarTextBox(e)
				local vetorParaBancoDeDados = {
					pagina = pagina,
					texto = cardDeck.TextBox.text,
					numeroCard = cardDeck.numero
				}
				
				local subPagina = telas.subPagina
				historicoLib.Criar_e_salvar_vetor_historico({
					tipoInteracao = "cards",
					pagina_livro = pagina,
					objeto_id = cardDeck.numero,
					acao = "salvar texto",
					conteudo = cardDeck.TextBox.text,
					subPagina = subPagina,
					tela = telas
				})
				
				local parameters = {}
				parameters.body = "Criar=1&idLivro=" .. telas.idLivro1  .. "&idUsuario=" .. telas.idAluno1 .. "&pagina=" .. pagina .. "&conteudo=" .. cardDeck.TextBox.text .. "&situacao=" .. "A" .. "&card_number=" .. cardDeck.numero
				local URL2 = "https://omniscience42.com/EAudioBookDB/deck.php"
				network.request(URL2, "POST", 
					function(event)
						if ( event.isError ) then
							native.showAlert("Falha no envio","Seu card não pôde ser enviado para a nuvem, verifique sua conexão com a internet e tente salvar o card novamente para que seja salvo na nuvem.",{"OK"})
						else
							print("WARNING: IdAnotacao = ",event.response)
							cardDeck.idCardText = event.response
						end
					end,parameters)

				vetorDeTextosDosCards[cardDeck.numero] = vetorParaBancoDeDados
				
				auxFuncs.saveTable( vetorDeTextosDosCards, "Deck_pag"..pagina..".json" )
			end
			cardDeck.botaoOK = widget.newButton {
				shape= "roundedRect",
				fillColor = {default = {46/255,171/255,200/255},over = {46/510,171/510,200/510}},
				strokeColor = {default = {0,0,0},over = {0,0,0,0.5}},
				labelColor = {default = {0,0,0},over = {0,0,0,0.5}},
				labelAlign = "center",
				label = "OK",
				font = "Fontes/paolaAccent.ttf",
				fontSize = 50,
				strokeWidth = 2,
				radius = 10,
				width = 70,
				height = 70,
				onRelease = salvarTextBox
			}
			cardDeck.botaoOK.x = cardDeck.TextBoxFundo.x + cardDeck.TextBoxFundo.width/2 - cardDeck.botaoOK.height/2 - 2
			cardDeck.botaoOK.y = cardDeck.TextBoxFundo.y + cardDeck.TextBoxFundo.height/2 - cardDeck.botaoOK.height/2 - 2
			Deck.grupoJCards:insert(cardDeck.botaoOK)
		end
	end
	
	Deck.botao = widget.newButton {
		defaultFile = "flash card.png",
		overFile = "flash cardD.png",
		width = 80,
		height = 80,
		onRelease = abrirJanelaDeCards
	}
	Deck.botao.tipo = "Enviar PDF.."
	Deck.botao.clicado = false
	Deck.botao.anchorX = 0--Var.anotComInterface.Icone.anchorX
	Deck.botao.anchorY = 0--Var.anotComInterface.Icone.anchorY
	--Var.anotComInterface.Icone.y = Y+ 100--GRUPOGERAL.height+100--Var.proximoY+ 40
	--Var.anotComInterface.Icone.x = (W-12*W/13)/2
	Deck.botao.y = 0
	Deck.botao.x = 0
	Deck:insert(Deck.botao)
	
	
	
	return Deck
end
--------------------------------------------------
--	COLOCAR PLANO DE FUNDO						--
--	Funcao responsavel por colocar um plano de 	--
--  fundo em todas as telas.					--
--  ATRIBUTOS: cor, arquivo 					--
--------------------------------------------------
function M.colocarPlanoDeFundo(atributos)
	if auxFuncs.naoVazio(atributos) then
		if (atributos.cor) then
			if type(atributos.cor) == "string" then
				if(atributos.cor=='branco') then
					display.setDefault( "background", 1, 1, 1 )
					PlanoDeFundoLibEA = "branco"
				end
				if(atributos.cor=='preto') then
					display.setDefault( "background", 0, 0, 0 )
					PlanoDeFundoLibEA = "preto"
				end
				if(atributos.cor=='azul') then
					display.setDefault( "background", 0, 0, 1 )
					PlanoDeFundoLibEA = "azul"
				end
				if(atributos.cor=='vermelho') then
					display.setDefault( "background", 1, 0, 0 )
					PlanoDeFundoLibEA = "vermelho"
				end
				if(atributos.cor=='verde') then
					display.setDefault( "background", 0, 1, 0 )
					PlanoDeFundoLibEA = "verde"
				end
			elseif type(atributos.cor) == "table" then
				display.setDefault( "background", atributos.cor[1]/255, atributos.cor[2]/255, atributos.cor[3]/255 )
				PlanoDeFundoLibEA = "custom"
			end
		end

		if(atributos.arquivo) then
			kimagemFundok = display.newImage(atributos.arquivo)
			kimagemFundok.anchorX=0;
			kimagemFundok.anchorY=0;
			kimagemFundok.width=W;
			kimagemFundok.height=H;
			PlanoDeFundoLibEA = "branco"
			GRUPOPLANODEFUNDO:insert(kimagemFundok)
			local function girarTelaOrientacaoPlanoDeFundo()
				if system.orientation == "landscapeLeft" then
					GRUPOPLANODEFUNDO.rotation = 270
					GRUPOPLANODEFUNDO.xScale = aspectRatio
					GRUPOPLANODEFUNDO.yScale = aspectRatio
					GRUPOPLANODEFUNDO.y = H-100
					GRUPOPLANODEFUNDO.x = 0
					GRUPOPLANODEFUNDO.tipo = "landscapeLeft"
				elseif system.orientation == "landscapeRight" then
					if system.getInfo( "platform" ) == "win32" then--win32
						GRUPOPLANODEFUNDO.rotation = 0
						GRUPOPLANODEFUNDO.y = 0
						GRUPOPLANODEFUNDO.x = 0
						GRUPOPLANODEFUNDO.tipo = "landscapeRight"
					else
						GRUPOPLANODEFUNDO.rotation = 90
						GRUPOPLANODEFUNDO.xScale = aspectRatio
						GRUPOPLANODEFUNDO.yScale = aspectRatio
						GRUPOPLANODEFUNDO.y = 100
						GRUPOPLANODEFUNDO.x = W
						GRUPOPLANODEFUNDO.tipo = "landscapeRight"
					end
				elseif system.orientation == "portrait" then
					GRUPOPLANODEFUNDO.rotation = 0
					GRUPOPLANODEFUNDO.xScale = 1
					GRUPOPLANODEFUNDO.yScale = 1
					GRUPOPLANODEFUNDO.x = 0
					GRUPOPLANODEFUNDO.y = 0
					GRUPOPLANODEFUNDO.tipo = "portrait"
				end
			end
			if travarOrientacaoLado == true then
				system.orientation = "landscapeRight"-- deletar!!!!!!!!!!!!!!!!!!!!!!!!!
				girarTelaOrientacaoPlanoDeFundo()-- deletar!!!!!!!!!!!!!!!!!!!!!!!!!
			else
				Runtime:addEventListener("orientation",girarTelaOrientacaoPlanoDeFundo)-- arrumar!!!!!!!!!!!!!!!!!!!!!!!!!
			end
		elseif (kimagemFundok) then
			kimagemFundok:removeSelf()
		end
	end
end

return M