-------------------------------------------------------------------------
--ÍNDICE-----------------------------------------------------------------
-----Funções gerais iniciais usadas nos códigos--------------------------
-------------------------------------------------------------------------

-- Definir Pagina 1 e Cabeçalho
-- LER PREFERÊNCIAS GENÉRICAS DO AUTOR --
	-- PAGINAS BLOQUEADAS
-- UPLOAD HISTORICO --
-- VERIFICANDO HISTORICO E LOGIN --
-- LER SUBSTITUICOES ONLINE SE EXISTIR --
  --uploadHistorico(arquivo)
  --RegistrarHistorico(conteudo)
-- FUNCOES GENERICAS NECESSARIAS
	-- pausarDespausarAnimacao
	-- pausarDespausarAnimacaoTTS
	-- clearNativeScreenElements()
	-- restoreNativeScreenElements()
-- VERIFICANDO LINGUAGEM DO LIVRO --
-- FUNÇÃO AUXILIAR GIRA TELA
-- botaoDeAumentarfunc
-- ZOOMZOOMZOOM
-- ZOOMZOOMZOOM2
-- ZOOM ESPECIAL --
-- function string.urlEncode( str )
-- COntrolador do botão voltar
-- escreverNoHistorico(texto,vetorJson)
-- girarTelaOrientacaoAumentarIndice(botao)
-- MOVER TELA PADRÃO --
-- LER TXT E CRIAR TELA: ------------------------------------------------------
-- criarMargensWindows
-- PROTETOR TELA --
-- CRIAR CURSO AUX
	-- Pagina Salva e Pagina Voltar --
	-- começo das exclusões 
	-- criarCursoAux Início --
	-- começo das adições --
		-- VERIFICAR SE PÁGINA ESTÁ BLOQUEADA
		-- verificar se a página é uma alternativa
		-- ZOOM IMAGEM ORIENTAÇÃO
	-- criando página bloqueada --
	-- Baixar e criar anotações --
	-- Baixar e Criar cometários --
	-- !!criar menu personalizar
	-- TRACKING DE TEMPO PAGINA --
	-- zerar variáveis marcadas --
-- FUNCOES AUXILIARES
-- -> funcGlobal.requisitarTTSOnline
-- -> criarArquivoTXT
-- -> lerArquivoTXT(atributos) -> caminho e arquivo
-- -> lerArquivoTXT2(atributos) -> caminho

-- -> verificaAcaoBotao
-------------------------------------------------------------------------
-----Funções de leitura de txt-------------------------------------------
-------------------------------------------------------------------------
-- CRIAR INDICE APARTIR DE ARQUIVOS
-- -> criarIndicedeArquivo
-- -> criarIndicesDeArquivoConfig
--CRIAR SOM APARTIR DE ARQUIVO
--CRIAR VIDEO APARTIR DE ARQUIVO
--CRIAR IMAGEM APARTIR DE ARQUIVO
--CRIAR TEXTO APARTIR DE ARQUIVO
--CRIAR BOTÃO APARTIR DE ARQUIVO
--CRIAR EXERCICIO APARTIR DE ARQUIVO
--CRIAR ANIMAÇÃO APARTIR DE ARQUIVOS
--CRIAR ESPAÇO APARTIR DE ARQUIVOS
--CRIAR SEPARADOR APARTIR DE ARQUIVOS
--CRIAR IMAGEM E TEXTO APARTIR DE ARQUIVOS
-------------------------------------------------------------------------
-----Funções de montagem final de telas----------------------------------
-------------------------------------------------------------------------
--local GRUPOINTERFACE = display.newGroup()
--	COLOCAR INDICE	PRÉ FORMATADO
--  COLOCAR ANOTAÇÃO E COMENTÁRIO --
--  COLOCAR BOTÃO IMPRIMIR --
--  COLOCAR BOTÃO SALVAR RELATÓRIO --
--  COLOCAR DESCRIÇÃO EM TEXTO
--  COLOCAR CONFIGS VOZ (TTS)
--	COLOCAR IMAGEM
--	COLOCAR HTML View
--	COLOCAR BOTAO
--	COLOCAR IMAG E TEXT
--	COLOCAR SEPARADOR
--	COLOCAR VIDEO
--	COLOCAR ANIMACAO
--  COLOCAR EXERCICIOS
-- INDICE MENU BOTOES
--	COLOCAR PLANO DE FUNDO
-------------------------------------------------------------------------
-----Funções iniciais que executam a montagem final e interface----------
-------------------------------------------------------------------------
-- NUMERO DAS PAGINAS --
-- CRIAR PAGINACAO
-- CRIAR BOTAO FALAR PAGINA --
-- COLOCAR INTERFACE TTS
-- COLOCAR INTERFACE BOTAO (criarBotaoIndice)
-- MOVER A TELA E SLIDE DE TELA
-- CRIOU O ZOOM ESPECIAL --
-- CRIAR BARRA DE PÁGINAS
-- INICIAR TELAS E PAGINAÇÃO
-- EVENTOS DE SYSTEMA --
-- MICROFONE
-- grupoMenuGeralTTS:insert(verticalSlider)
-- ->local function onKeyEvent( event )
-- QUANDO MUDAR TAMANHO TELA WINDOWS

--[[local function verificarCPF(CPF)
	local vetorNumerosCPF = {}
	for num in string.gmatch(CPF,"%d")do
		table.insert(vetorNumerosCPF,tonumber(num))
	end
	if #vetorNumerosCPF == 11 then
		
		local vetorAusar = {}
		-- PRIMEIRO digito verificador --
		local pesos = {10,9,8,7,6,5,4,3,2}
		
		for i=1,#vetorNumerosCPF-2 do
			table.insert(vetorAusar,vetorNumerosCPF[i])
		end
		
		local somatoriaResultados = 0
		for i=1,#vetorAusar do
			local aux = vetorAusar[i] * pesos[i]
			somatoriaResultados = somatoriaResultados + aux
		end
		
		local restoDivisao = somatoriaResultados % 11
		local resultado = 11 - restoDivisao
		
		local PrimeirodigitoVerificador
		if resultado > 9 then
			PrimeirodigitoVerificador = 0
		else
			PrimeirodigitoVerificador = resultado
		end
		-- SEGUNDO digito verificador --
		table.insert(vetorAusar,PrimeirodigitoVerificador)
		local pesos2 = {11,10,9,8,7,6,5,4,3,2}
		
		local somatoriaResultados2 = 0
		for i=1,#vetorAusar do
			local aux = vetorAusar[i] * pesos2[i]
			somatoriaResultados2 = somatoriaResultados2 + aux
		end
		
		local restoDivisao2 = somatoriaResultados2 % 11
		local resultado2 = 11 - restoDivisao2
		
		local SegundodigitoVerificador
		if resultado2 > 9 then
			SegundodigitoVerificador = 0
		else
			SegundodigitoVerificador = resultado2
		end
		if vetorNumerosCPF[#vetorNumerosCPF-1] == PrimeirodigitoVerificador and vetorNumerosCPF[#vetorNumerosCPF] == SegundodigitoVerificador then
			return true
		else
			return false
		end
	else
		return false
	end
end
verificarCPF(CPF)]]

io.output():setvbuf("no")
display.setStatusBar(display.HiddenStatusBar)
-- =====================================================
require "ssk2.loadSSK"
_G.ssk.init( { measure = false } )

local M = {}
local json = require("json")
local historicoLib = require("historico")
local elemTela = require("elementosDaTela")
local conversor = require("conversores")
local leituraTXT = require("leituraArquivosTxT")
local MenuRapido = require("MenuBotaoDireito")
local validarUTF8 = require("utf8Validator")
local auxFuncs = require("ferramentasAuxiliares")
local manipularTela = require("manipularTela")
local Pcurses = require("personalizarCursos")

local varGlobal = {}
local funcGlobal = {}
varGlobal.numeroWin = 1280
varGlobal.paginaComMenu = true

varGlobal.tipoSistema = auxFuncs.checarPortatil()
varGlobal.tipoSistema2 = auxFuncs.checarSimulator()

--=================================================
-- Definir Pagina 1 e Cabeçalho -- desativado, precisa atualizar
--=================================================
varGlobal.cabecalhoLivro = nil
varGlobal.cabecalhoLivroPos = {}
varGlobal.numeroInicialLivro = nil
--[[
if varGlobal.tipoSistema == "PC" then
	local function alphanumsort(o)
	  local function padnum(d) local dec, n = string.match(d, "(%.?)0*(.+)")
		return #dec > 0 and ("%.12f"):format(d) or ("%s%03d%s"):format(dec, #n, n) end
	  table.sort(o, function(a,b)
		return string.lower(tostring(a):gsub("%.?%d+",padnum)..("%3d"):format(#b))
			 <  string.lower(tostring(b):gsub("%.?%d+",padnum)..("%3d"):format(#a)) end)
	  return o
	end
	local lfs = require "lfs"
	local res_path = system.pathForFile( nil, system.ResourceDirectory )
	--print("1 - ",res_path)
	local arquivosTxt = {}
	local arquivosImagens = {}
	for file in lfs.dir(res_path.."/Paginas/TTS") do
		--print("2 - ",res_path .. "/Paginas/TTS")
		if file and file ~= "." and file ~= ".." and file ~= "dllImagens.txt" and not string.find(file,".DS_Store") then
			--print("3 - ",file)
			table.insert(arquivosTxt,file)
		end
	end
	for file in lfs.dir(res_path.."/Paginas/") do
		--print("4 - ",res_path.."/Paginas/")
		if file and file ~= "." and file ~= ".."and not string.find(file,".DS_Store") and (string.find(string.lower(file),"%.jpg") or string.find(string.lower(file),"%.png")) then
			table.insert(arquivosImagens,file)
			--print("5 - ",file)
		end
	end
	alphanumsort(arquivosTxt)
	alphanumsort(arquivosImagens)
	if #arquivosTxt > 0 then
		--print("6 - ",#arquivosTxt)
		local cabecalhoAnterior = nil
		local numeroAnterior = nil
		
		
		local xx = 1
		
		local function forAuxiliar0(i,limite)
			--print("7 - ",i,limite)
			--print(res_path)
			local pathArquivo = tostring(res_path).."/Paginas/TTS/"..arquivosTxt[i]
			--print("8 - ",pathArquivo)
			local file2, errorString = io.open( pathArquivo, "r" )
			local conteudo = file2:read( "*a" )
			--print("\n\n9 - ",conteudo,"\n\n")

			io.close( file2 )
			file2 = nil

			--print("arquivosTxt["..i.."] = ",arquivosTxt[i])
			local conteudo = string.gsub(conteudo,".",{ ["\13"] = "",["\10"] = "\13\10"})
			for cabecalho,numero in string.gmatch(conteudo,"(.+)\13\10(%d+) \13\10",1) do
				--print("10 - ",numero,cabecalho)
				-- comparar cabeçalhos e guardar cabeçalho e numero final
				if cabecalho and cabecalhoAnterior and cabecalho == cabecalhoAnterior then
					if not varGlobal.cabecalhoLivro then
						varGlobal.cabecalhoLivro = cabecalhoAnterior
						local charInicial,charFinal = string.match(varGlobal.cabecalhoLivro,conteudo)
						varGlobal.cabecalhoLivroPos.charInicial = charInicial
						varGlobal.cabecalhoLivroPos.charFinal = charFinal
						--print("||cabecalhoFinal|| ="..cabecalho)
					end
				end
				if numero and numeroAnterior and tonumber(numero) > tonumber(numeroAnterior) then
					if not varGlobal.numeroInicialLivro then
						local aSomar = 0
						varGlobal.numeroInicialLivro = tonumber(numeroAnterior) - (xx-2)
						--print("||Numero pagina 1|| ="..varGlobal.numeroInicialLivro)
					end
				end
			
				-- criar cabeçalho anterior e umero se houver
				if not cabecalhoAnterior and cabecalho then
					cabecalhoAnterior = cabecalho
					--print("cabeçalho anterior armazenado||| "..cabecalho)
				end
				if not numeroAnterior and numero then
					numeroAnterior = numero
					--print("numero anterior armazenado||| "..numero)
				end
				--print("cabeçalho: "..cabecalho)
				--print("numero: "..numero)
				--print("xx = "..xx)
				--print("11 - ",numero,cabecalho,xx)
			end
			if varGlobal.cabecalhoLivro and varGlobal.numeroInicialLivro then
				--print("13 - ",varGlobal.cabecalhoLivro,varGlobal.numeroInicialLivro)
				return true
			else
				xx = xx+1
				--print("12 - ",xx)
				rodarLoopFor0(i+1,limite)
			end
		end
		function rodarLoopFor0(i,limite)
			if i<=limite then forAuxiliar0(i,limite); end
		end
		rodarLoopFor0(1,#arquivosTxt)

		local numerosPositivos = 0
		if varGlobal.numeroInicialLivro and varGlobal.numeroInicialLivro - (xx-2) > 0 then
			numerosPositivos = varGlobal.numeroInicialLivro+1
		else
			varGlobal.numeroInicialLivro = 0
		end
		
		if arquivosTxt[1] ~= "P".. 1 .."_Page ~"..varGlobal.numeroInicialLivro-1 and arquivosTxt[1] ~= "Page "..numerosPositivos then
			for i=1,#arquivosTxt do
				local extencaoImagemDoTexto
				if arquivosImagens[i] then
					extencaoImagemDoTexto = string.sub(arquivosImagens[i],#arquivosImagens[i]-3,#arquivosImagens[i])
				end
				
				if i < (xx-2)then
					--print("(Neg)os.rename: "..arquivosTxt[i].."| P"..i.."_Page ~"..varGlobal.numeroInicialLivro-i)
					--print("(Neg)os.rename: "..arquivosImagens[i].."| P"..i.."_Page ~"..varGlobal.numeroInicialLivro-i)
					os.rename(res_path.."/Paginas/TTS/"..arquivosTxt[i],res_path.."/Paginas/TTS/P"..i.."_Page ~"..(xx-2)-i..".txt")
					--os.rename(res_path.."/Paginas/"..arquivosTxt[i],res_path.."/Paginas/(".. i..")Page~"..numerosPositivos-i..".txt")
					if arquivosImagens[i] then
						os.rename(res_path.."/Paginas/"..arquivosImagens[i],res_path.."/Paginas/P"..i.."_Page ~"..(xx-2)-i..extencaoImagemDoTexto)
					end
				else
					os.rename(res_path.."/Paginas/TTS/"..arquivosTxt[i],res_path.."/Paginas/TTS/Page "..numerosPositivos-1 ..".txt")
					--os.rename(res_path.."/Paginas/"..arquivosTxt[i],res_path.."/Paginas/Page "..numerosPositivos..".txt")
					if arquivosImagens[i] then
						os.rename(res_path.."/Paginas/"..arquivosImagens[i],res_path.."/Paginas/Page "..numerosPositivos-1 ..extencaoImagemDoTexto)
					end
					--print("(Pos)os.rename: "..arquivosTxt[i].."| Page "..numerosPositivos-1)
					--print("(Pos)os.rename: "..arquivosImagens[i].."| Page "..numerosPositivos-1)
					numerosPositivos = numerosPositivos+1
				end
			end
		end
	end
end

]]
---------------------------------------------------
--=================================================
--=================================================

varGlobal.textoPadRaO = "Página sem áudio"
varGlobal.vaiPassarPraFrente = true

varGlobal.pixelsPassarPage = 150
if system.getInfo("platform") == "win32" then
	varGlobal.pixelsPassarPage = 75
end

--local W = display.actualContentWidth;
--local H = display.actualContentHeight;
local W = display.viewableContentWidth ;
local H = display.viewableContentHeight;

------------------------------------------------------------------
-- LER PREFERÊNCIAS GENÉRICAS DO AUTOR --------------------------------
------------------------------------------------------------------
function funcGlobal.lerPreferenciasAutor()

	local vetorTodas = auxFuncs.lerTextoResLinhasNaoVazias("Preferencias Autor.txt")
	
	--thales1
	local padrao = {
		permissaoComentarios = "nao",
		ativarHistorico = "sim",
		ativarLogin = "sim",
		primeiraNumeracao = 1,
		cor = "branco",
		linguagem = "portugues_br",
		VelocidadeTTS = 0,
		ajudaTTS = "sim",
		TTSDesativado = "nao"
	}
	vetorTodas.permissaoComentarios = padrao.permissaoComentarios
	vetorTodas.ativarHistorico = padrao.ativarHistorico
	vetorTodas.ativarLogin = padrao.alativarLogintura
	vetorTodas.primeiraNumeracao = padrao.primeiraNumeracao
	vetorTodas.linguagem = padrao.linguagem
	vetorTodas.VelocidadeTTS = padrao.VelocidadeTTS
	vetorTodas.ajudaTTS = padrao.ajudaTTS
	vetorTodas.TTSDesativado = padrao.TTSDesativado
	
	vetorTodas = auxFuncs.lerPreferenciasAutorAux(vetorTodas,padrao)
	
	return vetorTodas
end
M.lerPreferenciasAutor = funcGlobal.lerPreferenciasAutor

varGlobal.preferenciasGerais = funcGlobal.lerPreferenciasAutor()
-- PAGINAS BLOQUEADAS
varGlobal.paginasBloqueadas = auxFuncs.loadTable("paginas_bloqueadas.json")

-- UPLOAD HISTORICO --
varGlobal.Login1 = nil
varGlobal.NomeLogin1 = nil
varGlobal.EmailLogin1 = nil
varGlobal.idAluno1 = 0
varGlobal.idProprietario1 = 15
varGlobal.codigoLivro1 = nil
varGlobal.idLivro1 = nil
varGlobal.idModeradores = {}




-- VERIFICANDO HISTORICO E LOGIN --
varGlobal.temLogin = true
varGlobal.temHistorico = true

if varGlobal.preferenciasGerais.ativarLogin then
	varGlobal.auxTemLogin = varGlobal.preferenciasGerais.ativarLogin
	if string.find(varGlobal.auxTemLogin,"nao") then
		varGlobal.temLogin = false
	elseif string.find(varGlobal.auxTemLogin,"sim") then
		varGlobal.temLogin = true
	end
	varGlobal.auxTemLogin = nil
end
if varGlobal.preferenciasGerais.ativarHistorico then
	varGlobal.auxTemHistorico = varGlobal.preferenciasGerais.ativarHistorico
	if string.find(varGlobal.auxTemHistorico,"nao") then
		varGlobal.temHistorico = false
	elseif string.find(varGlobal.auxTemHistorico,"sim") then
		varGlobal.temHistorico = true
	end
	varGlobal.auxTemHistorico = nil
end
---------------------------------------
-- LER SUBSTITUICOES ONLINE SE EXISTIR --
varGlobal.substituicoesOnline = {}
varGlobal.substituicoesOnline.original = {}
varGlobal.substituicoesOnline.novo = {}
if auxFuncs.fileExistsDoc("substituicoes.txt") then
	local conteudo = auxFuncs.lerTextoDoc("substituicoes.txt")
	
	for string1, string2 in string.gmatch(conteudo,"([^|]+)||([^\n]+)\n") do
		string1 = string.gsub(string1,"%-","%%-") 
		string2 = string.gsub(string2,"%-","%%-")
		table.insert(varGlobal.substituicoesOnline.original,string1)
		table.insert(varGlobal.substituicoesOnline.novo,string2)
	end
end


if auxFuncs.fileExistsDoc("loginEfetuado.txt") then
	varGlobal.Login1 = auxFuncs.lerTextoDoc("loginEfetuado.txt")
end
if auxFuncs.fileExistsDoc("nomeEfetuado.txt") then
	varGlobal.NomeLogin1 = auxFuncs.lerTextoDoc("nomeEfetuado.txt")
end
if auxFuncs.fileExistsDoc("nomeEfetuado.txt") then
	varGlobal.NomeLogin1 = auxFuncs.lerTextoDoc("nomeEfetuado.txt")
end
if auxFuncs.fileExistsDoc("apelidoEfetuado.txt") then
	varGlobal.apelidoLogin1 = auxFuncs.lerTextoDoc("apelidoEfetuado.txt")
end
if auxFuncs.fileExistsDoc("idAlunoEfetuado.txt") then
	varGlobal.idAluno1 = auxFuncs.lerTextoDoc("idAlunoEfetuado.txt")
end
if auxFuncs.fileExistsDoc("idProprietario.txt") then
	print("||||||",varGlobal.idProprietario1)
	varGlobal.idProprietario1 = auxFuncs.lerTextoDoc("idProprietario.txt")
	print(varGlobal.idProprietario1)
end
if auxFuncs.fileExists("codigoLivro.txt") then
	varGlobal.codigoLivro1 = auxFuncs.lerTextoRes("codigoLivro.txt")
end
if auxFuncs.fileExistsDoc("idLivro.txt") then
	varGlobal.idLivro1 = auxFuncs.lerTextoDoc("idLivro.txt")
end
if auxFuncs.fileExistsDoc("nomeLivro.txt") then
	varGlobal.nomeLivro1 = auxFuncs.lerTextoDoc("nomeLivro.txt")
end
-- verificar rodape--
if auxFuncs.fileExists("rodape.json") then
	varGlobal.vetorRodapes = auxFuncs.loadTable("rodape.json","res")
end 
if auxFuncs.fileExists("dicionario.json") then
	varGlobal.vetorDic = auxFuncs.loadTable("dicionario.json","res")
end 

local function RegistrarHistorico(conteudo)
	local conteudoCompleto = "Aluno = "..varGlobal.idAluno1.."|||Livro = "..varGlobal.codigoLivro1.."\n"..conteudo
	local function cadastroListener1( event )
	
		if ( event.isError ) then
			  --local alert = native.showAlert( "Network Error . Check Connection", "Connect to Internet", { "Try again" }  )
			  print("Network Error . Check Connection", "Connect to Internet")
		else
			if string.find(tostring(event.response),"Registrado com sucesso .") or string.find(tostring(event.response),"Atualizado com sucesso .") then
				--local alert = native.showAlert( "Cadastrando no banco de dados", "Resultado: "..event.response, { "Ok" } )
				print("Cadastrando no banco de dados", "Resultado: "..event.response)
				os.remove(system.pathForFile("historico.txt",system.DocumentsDirectory))
			else
				--local alert = native.showAlert( "Erro ao Cadastrar", event.response, { "Try again" }  )
				print("Erro ao Cadastrar", event.response)
			end
		end
	end
	
	local vetorJsonAux = auxFuncs.loadTable("historico.json")
	if not vetorJsonAux then vetorJsonAux = {} end
	
	vetorJsonAux.usuario_id = varGlobal.idAluno1
	vetorJsonAux.livro_id = varGlobal.idLivro1
	vetorJsonAux.identificador = system.getInfo( "deviceID" )
	vetorJsonAux.dispositivo = system.getInfo( "model" )
	local date = os.date( "*t" )
	vetorJsonAux.data_horario = os.date("!%Y-%m-%dT%TZ")--date.year.."-"..date.month.."-"..date.day.." "..date.hour..":"..date.min..":"..date.sec..".0"
	
	local function cadastroListener2( event )
	
		if ( event.isError ) then
			  --local alert = native.showAlert( "Network Error . Check Connection", "Connect to Internet", { "Try again" }  )
			  print("Network Error . Check Connection", "Connect to Internet")
		else
			print("WARNING: Começo MONGODB\n", event.response,"\n","WARNING: FIM MONGODB")
			local resposta = json.decode(event.response)
			if string.find(tostring(event.response),"sucesso") then
				os.remove(system.pathForFile("historico.json",system.DocumentsDirectory))
			end
		end
	end
	local headers = {}
	headers["Content-Type"] = "application/json"
	local parameters2 = {}
	parameters2.headers = headers

	local data = json.encode(vetorJsonAux)
	parameters2.body = data
	
	local parameters1 = {}
	parameters1.body = "Register=1&idAluno=" .. varGlobal.idAluno1 .. "&idProprietario=" .. varGlobal.idProprietario1 .. "&codigoLivro=" .. varGlobal.codigoLivro1 .. "&conteudo=".. conteudoCompleto
	
	local URL2 = "https://omniscience42.com/EAudioBookDB/CadastrarHistorico.php"
	network.request(URL2, "POST", cadastroListener1,parameters1) -- baixando base de dados completa
	local URL2 = "https://omniscience42.com/EAudioBookDB/mongo.php"
	network.request(URL2, "POST", cadastroListener2,parameters2) -- baixando base de dados completa
end

-- FUNCOES GENERICAS NECESSARIAS
local Var = {}
local function pausarDespausarAnimacao(tipo)
	if Var and Var.animacoes and Var.animacoes ~= {} then
		for i=1,#Var.animacoes do
			if Var.animacoes[i].som then
				if tipo == "pausar" then
					if  Var.animacoes[i].timer then
						for j=1,# Var.animacoes[i].timer do
							timer.pause( Var.animacoes[i].timer[j])
						end
					end
					if  Var.animacoes[i].timer2 then
						timer.pause( Var.animacoes[i].timer2)
					end
				elseif tipo == "parar" then
					if  Var.animacoes[i].timer then
						for j=1,# Var.animacoes[i].timer do
							timer.cancel( Var.animacoes[i].timer[j])
						end
					end
					if  Var.animacoes[i].timer2 then
						timer.cancel( Var.animacoes[i].timer2)
					end
					if  Var.animacoes[i].som then
						audio.stop( Var.animacoes[i].som)
					end
				else
					if  Var.animacoes[i].timer then
						for j=1,# Var.animacoes[i].timer do
							timer.resume( Var.animacoes[i].timer[j])
						end
					end
					if  Var.animacoes[i].timer2 then
						timer.resume( Var.animacoes[i].timer2)
					end
					if  Var.animacoes[i].som then
						audio.resume( Var.animacoes[i].som)
					end
				end
			end
		end
	end
end
local function pausarDespausarAnimacaoTTS(tipo,animacao)
	if animacao.som then
		if tipo == "pausar" then
			if  animacao.timer then
				for j=1,# animacao.timer do
					timer.pause( animacao.timer[j])
				end
			end
			if  animacao.timer2 then
				timer.pause( animacao.timer2)
			end
		elseif tipo == "parar" then
			if  animacao.timer then
				for j=1,# animacao.timer do
					timer.cancel( animacao.timer[j])
				end
			end
			if  animacao.timer2 then
				timer.cancel( animacao.timer2)
			end
			if  animacao.som then
				audio.stop( animacao.som)
			end
		else
			if  animacao.timer then
				for j=1,# animacao.timer do
					timer.resume( animacao.timer[j])
				end
			end
			if  animacao.timer2 then
				timer.resume( animacao.timer2)
			end
			if  animacao.som then
				audio.resume( animacao.som)
			end
		end
	end
end
local function clearNativeScreenElements()
	if Var and Var.videos then 
		print("WARNING: TEM VAR")
		for v=1,#Var.videos do
			if Var.videos[v].video then
				Var.videos[v].video:removeSelf()
				Var.videos[v].video = nil
			end
		end
	end
end
local function restoreNativeScreenElements()
	if Var and Var.videos then
		for v=1,#Var.videos do
			if Var.videos[v].video and Var.videos[v].video.xOriginal then
				--Var.videos[v].video.y = Var.videos[v].video.yOriginal
				--Var.videos[v].video.isVisible = true
				--Var.videos[v].video.alpha = 1	sddwWiller14325
			end
		end
	end
end


-- definindo pagina inicial --
varGlobal.contagemInicialPaginas = varGlobal.preferenciasGerais.primeiraNumeracao
varGlobal.numeroTotal = {}

if varGlobal.numeroInicialLivro and type(varGlobal.numeroInicialLivro) == "number" then
	varGlobal.contagemInicialPaginas = varGlobal.numeroInicialLivro
end

if varGlobal.preferenciasGerais.primeiraNumeracao then
	local numero = tonumber(varGlobal.preferenciasGerais.primeiraNumeracao)
	if type(numero) == "number" then
		varGlobal.contagemInicialPaginas = numero
	end
	numero = nil
end
-- mudar arquivo de pagina numero 1 se encontrar --

if varGlobal.numeroInicialLivro then
	if varGlobal.preferenciasGerais.primeiraNumeracao then
		local conteudoTotal = tonumber(auxFuncs.lerTextoRes("Preferencias Autor.txt"))
		local conteudo = varGlobal.preferenciasGerais.primeiraNumeracao
		print(conteudo)
		if type(conteudo) ~= "number" then
			varGlobal.contagemInicialPaginas = varGlobal.numeroInicialLivro
			
			local novoTextoAux = string.gsub(conteudoTotal,"4 - Pagina Numero 1 =.+","")
			local novoTexto = novoTextoAux.."\n Pagina Numero 1 = "..tostring(varGlobal.contagemInicialPaginas)
			
			auxFuncs.criarTxTRes("Preferencias Autor.txt",novoTexto)
		end
		conteudo = nil
	end
end

-----------------------------
-- VERIFICANDO LINGUAGEM DO LIVRO --

if varGlobal.preferenciasGerais.linguagem == "portugues_br" then
	varGlobal.TTSVozIdioma = "pt-br"
	varGlobal.accLinguagem = ""
	varGlobal.botaoPauseAudioTTS = "pause.MP3"
	varGlobal.botaoStopAudioTTS = "som botao parar.MP3"
	varGlobal.botaoResumeAudioTTS = "som botao play.MP3"
	varGlobal.botaoForwardAudioTTS = "som botao de avancar.MP3"
	varGlobal.botaoRewindAudioTTS = "som botao de retroceder.MP3"
	varGlobal.botaoFirstTouchAudioTTS = "som botao gerar audios.MP3"
	varGlobal.botaoGenerateAudioTTS = "som gerando audio.MP3"
	varGlobal.botaoSemInternetTTS = "semInternet.MP3"
	varGlobal.botaoSemAudioTTS = "paginaSemAudio.MP3"
	
	varGlobal.botaoIndiceAudio = "indice.MP3"
	varGlobal.botaoInicioAudioTTS = "inicio.MP3"
	varGlobal.botaoIndiceImagemUp = "botaoIndiceUp.MP3"
	varGlobal.botaoIndiceImagemDown = "botaoIndiceDown.MP3"
	varGlobal.botaoInicioImagemUp = "botaoRecomecarUp.MP3"
	varGlobal.botaoInicioImagemDown = "botaoRecomecarDown.MP3"
	-- Menu de configurações
	varGlobal.menuConfigBotaoPedidoEntrar = "menuConfig.MP3"
	varGlobal.menuConfigBotaoImagem = "menuConfigBotao.png"
	varGlobal.menuConfigImagem = "menuConfig.png"
	varGlobal.menuConfigPedidoSairSom = "menuConfigPedidoFechar.MP3"
	varGlobal.menuConfigSairSom = "menuConfigFechar.MP3"
	varGlobal.menuConfigVelocIntro = "menuConfigVelocIntro.MP3"
	varGlobal.menuConfigVelocAcc = "menuConfigVelocAcc.MP3"
	varGlobal.menuConfigVelocDec = "menuConfigVelocDec.MP3"
	varGlobal.menuConfigVelocUpperLimit = "menuConfigVelocUpperLimit.MP3"
	varGlobal.menuConfigVelocLowerLimit = "menuConfigVelocLowerLimit.MP3"
	
	varGlobal.menuConfigBotaoDeslogarClicar = "menuConfigDeslogarClicar.MP3"
	varGlobal.menuConfigBotaoDeslogar = "menuConfigDeslogar.MP3"
	varGlobal.menuConfigBotaoDeslogarTexto = "SAIR DO LIVRO"
	varGlobal.menuConfigBotaoDeslogarFalha = "audioTTS necessariaConexaoDesconectarConta.mp3"
	
	-- textos imprimir
	varGlobal.menuImprimirTitulo = "Criar e Enviar "
	varGlobal.menuImprimirTexto1 = "Página atual"
	varGlobal.menuImprimirTexto2 = "Todas as páginas"
	varGlobal.menuImprimirTexto3 = "Intervalo de páginas:"
	
	varGlobal.menuImprimirTextoDic1 = "Todas as palavras"
	varGlobal.menuImprimirTextoDic2 = "Selecionar palavras:"
	varGlobal.ttsImprimirMenuRapido1Clique = "audioTTS_ImprimirMenuRapido1Clique.mp3"
	
	-- audios TTS dicionário
	varGlobal.ttsDicionario1Clique = "dicionarioTTSBotao1Toque.mp3"
	varGlobal.ttsDicionarioVazio = "audioTTS_DicionarioVazio.mp3"
	varGlobal.ttsDicionarioMenuRapido1Clique = "audioTTS_DicionarioMenuRapido1Clique.mp3"
	
	-- audios TTS rodapé
	varGlobal.ttsRodape1Clique = "rodapeTTSBotao1Toque.mp3"
	varGlobal.ttsRodapeVazio = "audioTTS_RodapeVazio.mp3"
	varGlobal.ttsRodapeMenuRapido1Clique = "audioTTS_RodapeMenuRapido1Clique.mp3"
	varGlobal.ttsRodape1CliquePagina = "audioTTS_notaRodape_1clique.mp3"
	
	-- audios Deck
	varGlobal.ttsDeck1Clique = "deckTTSBotao1Toque.mp3"
	varGlobal.ttsDeckVazio = "audioTTS_DeckVazio.mp3"
	varGlobal.ttsDeckAbrir = "audioTTS_DeckAbrindo.mp3"
	varGlobal.ttsDeckFechar = "audioTTS_DeckFechar.mp3"
	varGlobal.ttsDeckMenuRapido1Clique = "audioTTS_DeckMenuRapido1Clique.mp3"
	
	-- audios relatorio
	varGlobal.ttsRelatorioMenuRapido1Clique = "audioTTS_RelatorioMenuRapido1Clique.mp3"
	
	-- audios forum
	varGlobal.ttsForumMenuRapido1Clique = "audioTTS_ForumMenuRapido1Clique.mp3"
	
	-- Mensagem Temporaria
	varGlobal.linguagem_MensagemTemp = "mensagem clique.png"
	
elseif varGlobal.preferenciasGerais.linguagem == "ingles_us" then
	varGlobal.TTSVozIdioma = "en-us"
	varGlobal.accLinguagem = "Ingles"
	varGlobal.botaoPauseAudioTTS = "pause ingles.MP3"
	varGlobal.botaoStopAudioTTS = "som botao parar ingles.MP3"
	varGlobal.botaoResumeAudioTTS = "som botao play ingles.MP3"
	varGlobal.botaoForwardAudioTTS = "som botao de avancar ingles.MP3"
	varGlobal.botaoRewindAudioTTS = "som botao de retroceder ingles.MP3"
	varGlobal.botaoFirstTouchAudioTTS = "som botao gerar audios ingles.MP3"
	varGlobal.botaoGenerateAudioTTS = "som gerando audio ingles.MP3"
	varGlobal.botaoSemInternetTTS = "semInternet ingles.MP3"
	varGlobal.botaoSemAudioTTS = "paginaSemAudio ingles.MP3"
	
	varGlobal.botaoIndiceAudio = "indice ingles.MP3"
	varGlobal.botaoInicioAudioTTS = "inicio ingles.MP3"
	varGlobal.botaoIndiceImagemUp = "botaoIndiceUp ingles.MP3"
	varGlobal.botaoIndiceImagemDown = "botaoIndiceDown ingles.MP3"
	varGlobal.botaoInicioImagemUp = "botaoRecomecarUp ingles.MP3"
	varGlobal.botaoInicioImagemDown = "botaoRecomecarDown ingles.MP3"
	-- Menu de configurações
	varGlobal.menuConfigBotaoPedidoEntrar = "menuConfigIngles.MP3"
	varGlobal.menuConfigBotaoImagem = "menuConfigBotao.png"
	varGlobal.menuConfigImagem = "menuConfigIngles.png"
	varGlobal.menuConfigPedidoSairSom = "menuConfigPedidoFecharIngles.MP3"
	varGlobal.menuConfigSairSom = "menuConfigFecharIngles.MP3"
	varGlobal.menuConfigVelocIntro = "menuConfigVelocIntroIngles.MP3"
	varGlobal.menuConfigVelocUpperLimit = "menuConfigVelocUpperLimitIngles.MP3"
	varGlobal.menuConfigVelocLowerLimit = "menuConfigVelocLowerLimitIngles.MP3"
	
	varGlobal.menuConfigBotaoDeslogarClicar = "menuConfigDeslogarClicarIngles.MP3"
	varGlobal.menuConfigBotaoDeslogar = "menuConfigDeslogarIngles.MP3"
	varGlobal.menuConfigBotaoDeslogarTexto = "CLOSE THE BOOK"
	varGlobal.menuConfigBotaoDeslogarFalha = "audioTTS necessariaConexaoDesconectarConta ingles.mp3"
	
	-- textos imprimir
	varGlobal.menuImprimirTitulo = "Create and send "
	varGlobal.menuImprimirTexto1 = "Current Page"
	varGlobal.menuImprimirTexto2 = "All Pages"
	varGlobal.menuImprimirTexto3 = "Select range of pages:"
	
	varGlobal.menuImprimirTextoDic1 = "All words"
	varGlobal.menuImprimirTextoDic2 = "Select words:"
	varGlobal.ttsImprimirMenuRapido1Clique = "audioTTS_ImprimirMenuRapido1CliqueIngles.mp3"
	
	-- audios TTS dicionário
	varGlobal.ttsDicionario1Clique = "dicionarioTTSBotao1ToqueIngles.mp3"
	varGlobal.ttsDicionarioVazio = "audioTTS_DicionarioVazioIngles.mp3"
	varGlobal.ttsDicionarioMenuRapido1Clique = "audioTTS_DicionarioMenuRapido1CliqueIngles.mp3"
	
	-- audios TTS rodapé
	varGlobal.ttsRodape1Clique = "rodapeTTSBotao1ToqueIngles.mp3"
	varGlobal.ttsRodapeVazio = "audioTTS_RodapeVazioIngles.mp3"
	varGlobal.ttsRodapeMenuRapido1Clique = "audioTTS_RodapeMenuRapido1CliqueIngles.mp3"
	varGlobal.ttsRodape1CliquePagina = "audioTTS_notaRodape_1cliqueIngles.mp3"
	
	-- audios TTS deck
	varGlobal.ttsDeck1Clique = "deckTTSBotao1ToqueIngles.mp3"
	varGlobal.ttsDeckVazio = "audioTTS_DeckVazioIngles.mp3"
	varGlobal.ttsDeckAbrir = "audioTTS_DeckAbrindoIngles.mp3"
	varGlobal.ttsDeckFechar = "audioTTS_DeckFecharIngles.mp3"
	varGlobal.ttsDeckMenuRapido1Clique = "audioTTS_DeckMenuRapido1CliqueIngles.mp3"
	
	-- audios relatorio
	varGlobal.ttsRelatorioMenuRapido1Clique = "audioTTS_RelatorioMenuRapido1CliqueIngles.mp3"
	
	-- audios forum
	varGlobal.ttsForumMenuRapido1Clique = "audioTTS_ForumMenuRapido1CliqueIngles.mp3"
	
	-- Mensagem Temporaria
	varGlobal.linguagem_MensagemTemp = "mensagem cliqueIngles.png"
end
varGlobal.ExtencaoSendoUsada = "WAV"
varGlobal.VelocidadeTTS = varGlobal.preferenciasGerais.VelocidadeTTS


APIkey = {"d54c836b16aa40178bca74642d957cbf","70cb20352e164941bc83fb1ea7033122"}
APIkey.thithou1 = 	"d54c836b16aa40178bca74642d957cbf" -- thithous@hotmail.com
--APIkey.thithou1 = 	"70cb20352e164941bc83fb1ea7033122" -- thithou1@hotmail.com
----APIkey.thithou1 = 	"07aa9b6dabdc4c1abe01c94cb560441e" -- thithous@yahoo.com.br
----APIkey.thithou1 = 	"07aa9b6dabdc4c1abe01c94cb560441e" -- lucianovieiralimaster
--APIkey.thithou1 = "13bcb1e44e264c9c8d5c48ed949e732a" -- rhodantoday@gmail.com
--APIkey.thithou1 = "488e27efe1934464a54642560addb859" -- thaleschief2@gmail.com
--APIkey.thithou1 = "0084746c28b4438fb98aa8dc126764f7" -- thaleschief@gmail.com
--APIkey.thithou1 = "0da5843e87434c0a987feb77d30d6d14" -- gibisraros2015@gmail.com
--APIkey.thithou1 = "e257f3e0e78646f59fa99aba6b9b53d8" -- thaleschief3@gmail.com
--APIkey.thithou1 = "72b0ce7ca9b04bec88b44c55196ade91" -- thaleschief4@gmail.com
--APIkey.thithou1 = "df1814991f5741019412507df6f3a0a8" -- luciano.vieira.lima@terra.com.br

--https://api.voicerss.org/?key=488e27efe1934464a54642560addb859&hl=pt-br&c=MP3&r=-1&f=12khz_16bit_mono&src=Antes de finalizar o cadastro, verifique se os dados estão corretos. Se estiverem, toque no botão finalizar no centro inferior da tela.
--erro total bytes transferred: 76
	
local function verificarWindows2()
	local path = system.pathForFile(nil,system.ResourceDirectory)

	--auxFuncs.testarNoAndroid(tostring(path),0)
	if varGlobal.tipoSistema ~= "PC" then
	--if path == nil then
		return false
	else
		return true
	end
end	

local verificarWindows = verificarWindows2()
local lfs = require ( "lfs" )
local conversor = require("conversores")
local botaoPause
local botaoBackward
local botaoForward
local botaoReiniciar
local botaoplayTTS
varGlobal.TTSTipo = varGlobal.preferenciasGerais.tipoTTS -- RSS or AWS
varGlobal.TTSVoz = varGlobal.preferenciasGerais.vozTTS
varGlobal.TTSduracaoTotal = 0
varGlobal.TTSNeural = varGlobal.preferenciasGerais.TTSNeural
varGlobal.extensao = "MP3"
local tableParagrafosFinais = {}
local nomesArquivosParagrafos = {}
local controladorParagrafos = 1
local controladorSons = 1
local barraclicada = false
varGlobal.VetorBotoesBarra = {}

--local vibrator = require('plugin.vibrator')
--IMPORTS
display.setStatusBar( display.HiddenStatusBar )
local widget = require "widget";

indicePaginas = {}
varGlobal.limiteTela = 0

larguraTela = W
alturaTela = H

local paginaAtual = 1
local toqueHabilitado = true
local TemUmaImagem = {}
TemUmaImagem[1] = 0
PlanoDeFundoLibEA = "preto"
local GRUPOPLANODEFUNDO = display.newGroup()
--local Interfacexx = display.newGroup()

local GRUPOGERAL = display.newGroup()
GRUPOGERAL.novaOrientacao = "portrait"
GRUPOGERAL.tipoG = "Geral"


local grupoBotaoAumentar = display.newGroup()

local GRUPOSOM = display.newGroup()
GRUPOSOM.tipo = "som"
local jacliquei = false
--VetorDeVetorTTS[paginaAtual][i]
local VetorDeVetorTTS = {}
local VetorTTS = {}
local VetorIndiceTTS = {{}}
VetorIndiceTTS[1] = {}
VetorIndiceTTS[2] = {}
VetorIndiceTTS[3] = {}
VetorIndiceTTS[4] = {}
VetorIndiceTTS[5] = {}
VetorIndiceTTS[6] = {}
VetorIndiceTTS[7] = {}
VetorIndiceTTS[8] = {}
VetorIndiceTTS[9] = {}
local textoTTS = ""
local TTSVOZRodando = nil
local clicouBOTAOtts = false
local clicouAvancar = false
local clicouVoltar = false
local timerClicouAvancar
local timerClicouVoltar
local atributoALTPadraoVideo = "!Vi deo:! sem descrição. "
local botaoPassarPaginaTrue = false
local TelasMenuGeral = {}
--!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
local travarOrientacaoLado = false
local telasAnteriores = 0
local verificarNumeroPaginasPre = auxFuncs.lerTextoResNumeroLinhas("PaginasPre/dllTelas.txt")
local verificarNumeroIndices = auxFuncs.lerTextoResNumeroLinhas("Indices/dllIndices.txt")
local totalPaginasAnteriores = verificarNumeroPaginasPre + verificarNumeroIndices + 1
--!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!


-- Add touch listener to background image
varGlobal.aspectRatio = 1.3
if system.getInfo("platform") == win32 then
	varGlobal.aspectRatio = display.pixelHeight / display.pixelWidth
end
print("OPAOPAOPAOPA",display.pixelHeight / display.pixelWidth)
varGlobal.aumentoProp = varGlobal.aspectRatio
--------------------------------------------------------------------------
--	CRIAR CURSO															--
--	Funcao responsavel por criar o Curso personalizado					--
--  de acordo com as telas fornecidas e a pagina que 					-- 
--  apresentara a tela na ordem do valor da pagina						--
--  ATRIBUTOS: telas[imagem,imagens,botao,som,video,animacao],pagina 	--
--------------------------------------------------------------------------
varGlobal.mudouAgoraOrientacao = false
-- FUNÇÃO AUXILIAR GIRA TELA --
function girarTelaOrientacao(grupo)
	
	if GRUPOGERAL.timer then
		--timer.cancel(GRUPOGERAL.timer)
		--GRUPOGERAL.timer = nil
	end
	
	local function girarTelaAposDelay()
		
		if GRUPOGERAL.novaOrientacao ~= GRUPOGERAL.velhaOrientacao then
			if grupo == GRUPOGERAL then
				GRUPOGERALORIGINX = grupo.x
				GRUPOGERALORIGINY = grupo.y
				--GRUPOGERAL.YPagina[paginaAtual] = GRUPOGERALORIGINY
			end
			local ajusteWindows = 0
			if system.getInfo("platform") == "win32" then
				ajusteWindows = 10
			end
			if system.orientation == "landscapeLeft" then
				local extra = 0
				
				if grupo.width then
					grupo.rotation = -90
					grupo.xScale = varGlobal.aumentoProp
					grupo.yScale = varGlobal.aumentoProp
					grupo.y = H/2 + grupo.width/2*varGlobal.aumentoProp--grupo.width*varGlobal.aumentoProp  --+ W/2.758620689655172--464--H/2 + ((grupo.width-ajusteWindows)/2)*varGlobal.aumentoProp

					grupo.x = 0
					
				end
				if grupo == GRUPOGERAL then	
					if GRUPOGERAL.YPagina[paginaAtual] then
						transition.to(GRUPOGERAL,{x = GRUPOGERAL.YPagina[paginaAtual]*varGlobal.aspectRatio,time = 0})
					end
					if not varGlobal.mudouAgoraOrientacao then
						if GRUPOGERAL.orientacaoAtual ~= system.orientation then
							local date = os.date( "*t" )
							local data = date.day.."/"..date.month.."/"..date.year
							local hora = date.hour..":"..date.min..":"..date.sec
							local pH = funcGlobal.pegarNumeroPaginaRomanosHistorico(varGlobal.PagH)
							local vetorJson = {
								tipoInteracao = "genérica",
								pagina_livro = varGlobal.PagH,
								objeto_id = nil,
								tipo_orientacao = "landscapeLeft",
								acao = "mudar orientação da tela",
								relatorio = data.."| Modificou a orientação da tela para a horizontal esquerda às "..hora.. ", na página ".. pH
							}
							if GRUPOGERAL.subPagina then
								vetorJson.subPagina = GRUPOGERAL.subPagina
							end
							funcGlobal.escreverNoHistorico(varGlobal.MudouOrientacaoLandscape,vetorJson)
							GRUPOGERAL.orientacaoAtual = system.orientation
						end
						varGlobal.mudouAgoraOrientacao = true
						timer.performWithDelay(1000,function() varGlobal.mudouAgoraOrientacao = false end,1)
					end
				end
				print("\n\LEFT - girarTelaAposDelay\n\n")
				grupo.tipo = "landscapeLeft"
				print("\n\nLEFT\n\n")
				
			elseif system.orientation == "landscapeRight" then
				if system.getInfo( "platform" ) == "win32" then--win32
					if grupo.width then
						grupo.rotation = 0
						grupo.y = 0 -- (grupo.width/2) 
						grupo.x = 0
					end
					grupo.tipo = "landscapeRight"
					print("\n\nRIGHT\n\nopa1")
				else
					print("WARNING:","THALES")
					print(GRUPOGERAL.x,GRUPOGERAL.y)
					print(GRUPOGERAL.width,grupo.y,grupo.x)
					print("\n\RIGHT - girarTelaAposDelay\n\n")
					if grupo.width then
						grupo.rotation = 90
						grupo.xScale = varGlobal.aumentoProp
						grupo.yScale = varGlobal.aumentoProp
						grupo.y = H/2 - grupo.width/2*varGlobal.aumentoProp-- 0 --W/12.8--100--H/2 - ((grupo.width-ajusteWindows)/2)*varGlobal.aumentoProp
						grupo.x = W
					end
					if grupo == GRUPOGERAL then	
						if GRUPOGERAL.YPagina[paginaAtual] then
							transition.to(GRUPOGERAL,{x = W-GRUPOGERAL.YPagina[paginaAtual]*varGlobal.aspectRatio,time = 0})	
						end
						if not varGlobal.mudouAgoraOrientacao then
							if GRUPOGERAL.orientacaoAtual ~= system.orientation then
								local date = os.date( "*t" )
								local data = date.day.."/"..date.month.."/"..date.year
								local hora = date.hour..":"..date.min..":"..date.sec
								local pH = funcGlobal.pegarNumeroPaginaRomanosHistorico(varGlobal.PagH)
								local vetorJson = {
									tipoInteracao = "genérica",
									pagina_livro = varGlobal.PagH,
									objeto_id = nil,
									tipo_orientacao = "landscapeRight",
									acao = "mudar orientação da tela",
									relatorio = data.."| Modificou a orientação da tela para a horizontal direita às "..hora.. ", na página ".. pH
								}
								if GRUPOGERAL.subPagina then
									vetorJson.subPagina = GRUPOGERAL.subPagina
								end
								funcGlobal.escreverNoHistorico(varGlobal.MudouOrientacaoLandscape,vetorJson)
								GRUPOGERAL.orientacaoAtual = system.orientation
							end
							varGlobal.mudouAgoraOrientacao = true
							timer.performWithDelay(1000,function() varGlobal.mudouAgoraOrientacao = false end,1)
						end
					end	
					
					print(GRUPOGERAL.x,GRUPOGERAL.y)
					print(GRUPOGERAL.width,grupo.y,grupo.x)
					grupo.tipo = "landscapeRight"
				end
				
			elseif system.orientation == "portrait" then
				if GRUPOGERAL.limiteAumentado == true then
					--varGlobal.limiteTela = varGlobal.limiteTela/varGlobal.aumentoProp
				end
				if grupo.width then
					grupo.rotation = 0
					grupo.xScale = 1
					grupo.yScale = 1
					grupo.x = 0
					grupo.y = 0
				end
				local function onComplete()
					if GRUPOGERAL.y > 0 then
						GRUPOGERAL.y = 0
					elseif GRUPOGERAL.y < -(varGlobal.limiteTela - H)then
						
						GRUPOGERAL.y = -(varGlobal.limiteTela - H)
					end
				end
				if grupo == GRUPOGERAL then	
					if GRUPOGERAL.YPagina[paginaAtual] then
						transition.to(GRUPOGERAL,{y = GRUPOGERAL.YPagina[paginaAtual],time = 0,onComplete = onComplete})
					end
					if not varGlobal.mudouAgoraOrientacao then
						if GRUPOGERAL.orientacaoAtual ~= system.orientation then
							local date = os.date( "*t" )
							local data = date.day.."/"..date.month.."/"..date.year
							local hora = date.hour..":"..date.min..":"..date.sec
							local pH = funcGlobal.pegarNumeroPaginaRomanosHistorico(varGlobal.PagH)
							local vetorJson = {
								tipoInteracao = "genérica",
								pagina_livro = varGlobal.PagH,
								objeto_id = nil,
								tipo_orientacao = "portrait",
								acao = "mudar orientação da tela",
								relatorio = data.."| Modificou a orientação da tela para a vertical às "..hora.. ", na página ".. pH
							}
							if GRUPOGERAL.subPagina then
								vetorJson.subPagina = GRUPOGERAL.subPagina
							end
							funcGlobal.escreverNoHistorico(varGlobal.MudouOrientacaoPortrait,vetorJson)
							GRUPOGERAL.orientacaoAtual = system.orientation
						end
						varGlobal.mudouAgoraOrientacao = true
						timer.performWithDelay(1000,function() varGlobal.mudouAgoraOrientacao = false end,1)
					end
				end
				if varGlobal.limiteTela < 1280 then
					transition.to(GRUPOGERAL,{y = 0,time=0})
				end
				grupo.tipo = "portrait"
			end
		end
	end
	if GRUPOGERAL.girarImediato == true then
		girarTelaAposDelay()
		GRUPOGERAL.girarImediato = false
	elseif grupo == GRUPOGERAL then
		GRUPOGERAL.timer = timer.performWithDelay(1000,function()girarTelaAposDelay()end,1)
	end
	
end

-- FUNÇÃO AUXILIAR DE AUMENTAR TEXTOS --
local function botaoDeAumentarfunc(evento)
	local botaoDeAumentar = display.newImageRect("fontChange.png",200,100)
	botaoDeAumentar.x = 0; botaoDeAumentar.y = 0
	botaoDeAumentar.anchorY = 0

	--grupoTexto:insert(botaoDeAumentar)
	if botaoDeAumentar.y + botaoDeAumentar.height < 0 then
		--botaoDeAumentar.y = 80
	end
	if botaoDeAumentar.x + botaoDeAumentar.width > W then
		--botaoDeAumentar.x = evento.x-80
	end
	return botaoDeAumentar
end
-- FUNÇÃO AUXILIAR Zoom Imagens
		system.activate( "multitouch" )
function calculateDelta( previousTouches, event )

	local id, touch = next( previousTouches )
	if ( event.id == id ) then
		id, touch = next( previousTouches, id )
		assert( id ~= event.id )
	end

	local dx = touch.x - event.x
	local dy = touch.y - event.y
	return dx, dy
end

-- create a table listener object for the bkgd image
function ZOOMZOOMZOOM( event )
    local result = true

    local phase = event.phase
	
	if event.target.imgFunc then
		event.target = event.target.imgFunc
	end

    local previousTouches = event.target.previousTouches
	
	

    local numTotalTouches = 1
    if ( previousTouches ) then
            -- add in total from previousTouches, subtract one if event is already in the array
            numTotalTouches = numTotalTouches + event.target.numPreviousTouches
            if previousTouches[event.id] then
                    numTotalTouches = numTotalTouches - 1
            end
    end
	
    if "began" == phase then
			toqueY = event.y
			targetY = event.target.y
			toqueX = event.x
			targetX = event.target.x
			if system.orientation == "landscapeLeft" or system.orientation == "landscapeRight" then
				-- toqueY = event.x
				-- targetY = event.target.x
				-- toqueX = event.y
				-- targetX = event.target.y
			end
			if event.target.yScale < 0.5 then
				event.target.yScale = 0.5
				event.target.xScale = 0.5
			end
            -- Very first "began" event
            if ( not event.target.isFocus ) then
                    -- Subsequent touch events will target button even if they are outside the stageBounds of button
                    display.getCurrentStage():setFocus( event.target )
                    event.target.isFocus = true

                    previousTouches = {}
                    event.target.previousTouches = previousTouches
                    event.target.numPreviousTouches = 0
            elseif ( not event.target.distance ) then
                    local dx,dy

                    if previousTouches and ( numTotalTouches ) >= 2 then
                            dx,dy = calculateDelta( previousTouches, event )
                    end

                    -- initialize to distance between two touches
                    if ( dx and dy ) then
                            local d = math.sqrt( dx*dx + dy*dy )
                            if ( d > 0 ) then
                                    event.target.distance = d
                                    event.target.xScaleOriginal = event.target.xScale
                                    event.target.yScaleOriginal = event.target.yScale
                                    --print( "distance = " .. event.target.distance )
                            end
                    end
            end

            if not previousTouches[event.id] then
                    event.target.numPreviousTouches = event.target.numPreviousTouches + 1
            end
            previousTouches[event.id] = event

    elseif event.target.isFocus then
            if "moved" == phase then
					
                    if ( event.target.distance ) then
                            local dx,dy
                            if previousTouches and ( numTotalTouches ) >= 2 then
                                    dx,dy = calculateDelta( previousTouches, event )
                            end
							local ZOOMMAX = 5
							local ZOOMMIN = .5
                            if ( dx and dy ) then
                                    local newDistance = math.sqrt( dx*dx + dy*dy )
                                    local scale = newDistance / event.target.distance
                                    --print( "newDistance(" ..newDistance .. ") / distance(" .. event.target.distance .. ") = scale("..  scale ..")" )
                                    if ( scale > 0 ) then
                                            --event.target.xScale = event.target.xScaleOriginal * scale
                                            --event.target.yScale = event.target.yScaleOriginal * scale
											
											local xScale = event.target.xScaleOriginal * scale
											local yScale = event.target.yScaleOriginal * scale

											--// set upper bound
											xScale = math.min(ZOOMMAX, xScale)
											yScale = math.min(ZOOMMAX, yScale)

											--// set lower bound
											event.target.xScale = math.max(ZOOMMIN, xScale)
											event.target.yScale = math.max(ZOOMMIN, yScale)
                                    end
							else
									event.target.y = (event.y - toqueY + targetY) / dy
									event.target.x = event.x - toqueX + targetX
                            end
                    end

                    if not previousTouches[event.id] then
                            event.target.numPreviousTouches = event.target.numPreviousTouches + 1
                    end
                    previousTouches[event.id] = event
					
					local target = event.target
					local escala = target.xScale
					
					
					--target.x = event.x - toqueX + targetX
					--target.y = event.y - toqueY + targetY

					if target.yScale < 0.5 then
						target.yScale = 0.5
						target.xScale = 0.5
					end
					local e = event
					if system.orientation == "landscapeLeft" then
						if toqueY then
							e.target.y = (event.x - toqueX)/varGlobal.aspectRatio + targetY
							
							e.target.x = -(event.y - toqueY)/varGlobal.aspectRatio + targetX
						end
					elseif system.orientation == "landscapeRight" then
						if toqueY then
							e.target.y = -(event.x - toqueX)/varGlobal.aspectRatio + targetY
							
							e.target.x = (event.y - toqueY)/varGlobal.aspectRatio + targetX
						end
					else
						if toqueY then
							e.target.y = e.y - toqueY + targetY
							target.x = event.x - toqueX + targetX
						end
					end
            elseif "ended" == phase or "cancelled" == phase then
					if event.target.yScale < 0.5 then
						event.target.yScale = 0.5
						event.target.xScale = 0.5
					end
                    if previousTouches[event.id] then
                            event.target.numPreviousTouches = event.target.numPreviousTouches - 1
                            previousTouches[event.id] = nil
                    end

                    if ( #previousTouches > 0 ) then
                            -- must be at least 2 touches remaining to pinch/zoom
                            event.target.distance = nil
                    else
                            -- previousTouches is empty so no more fingers are touching the screen
                            -- Allow touch events to be sent normally to the objects they "hit"
                            display.getCurrentStage():setFocus( nil )

                            event.target.isFocus = false
                            event.target.distance = nil
                            event.target.xScaleOriginal = nil
                            event.target.yScaleOriginal = nil

                            -- reset array
                            event.target.previousTouches = nil
                            event.target.numPreviousTouches = nil
                    end
            end
    end

    return result
end

function calculateDelta2( previousTouches, event )
	local id,touch = next( previousTouches )
	if event.id == id then
		id,touch = next( previousTouches, id )
		assert( id ~= event.id )
	end

	local dx = touch.x - event.x
	local dy = touch.y - event.y

	midX=math.abs((touch.x + event.x)/2)
	midY=math.abs((touch.y + event.y)/2)
	
	offX=event.target.x-midX
	offY=event.target.y-midY
	
	return dx, dy,midX,midY,offX,offY
end

system.activate( "multitouch" )

function ZOOMZOOMZOOM2( event )
	local scale
	local result = true
	local girado = "portrait"
	if event.target.imgFunc then
		event.target = event.target.imgFunc
		if system.orientation == "landscapeLeft" then
			girado = "Right"
		elseif system.orientation == "landscapeRight" then
			girado = "Left"
		end
	end
	
	local phase = event.phase
	local previousTouches = event.target.previousTouches

	local numTotalTouches = 1
	if ( previousTouches ) then
		-- add in total from previousTouches, subtract one if event is already in the array
		numTotalTouches = numTotalTouches + event.target.numPreviousTouches
		if previousTouches[event.id] then
			numTotalTouches = numTotalTouches - 1
		end
	end

	if "began" == phase then
		-- Very first "began" event
		event.target.xScaleOriginal=event.target.xScale
		if ( not event.target.isFocus ) then
			isMulti=false
			-- Subsequent touch events will target button even if they are outside the contentBounds of button
			display.getCurrentStage():setFocus( event.target )
			event.target.isFocus = true
			previousTouches = {}
			event.target.previousTouches = previousTouches
			event.target.numPreviousTouches = 0
			----ADDED BY CON TO ORIGINAL PINCHZOOM CODE
			startX=event.x
			startY=event.y
			
			--------------------------------
			
		elseif ( not event.target.distance ) then
			local dx,dy
			isMulti=true
			if previousTouches and ( numTotalTouches ) >= 2 then
				
				dx,dy,midX,midY,offX,offY = calculateDelta2( previousTouches, event )
			end
			-- initialize to distance between two touches
			if ( dx and dy ) then
				local d = math.sqrt( dx*dx + dy*dy )
				if ( d > 0 ) then
					
					event.target.distance = d
					offCX=(event.target.width*event.target.xScale/2)-event.target.x
					offCY=(event.target.height*event.target.yScale/2)-event.target.y
					local newAnchorY=(midY+offCY)/(event.target.height*event.target.yScale)
					local newAnchorX=(midX+offCX)/(event.target.width*event.target.xScale)
					
					event.target.anchorX=newAnchorX
					event.target.anchorY=newAnchorY							
					event.target.x=event.target.x-offX
					event.target.y=event.target.y-offY

				end
			end
		end
		
		if not previousTouches[event.id] then
			event.target.numPreviousTouches = event.target.numPreviousTouches + 1
		end
		previousTouches[event.id] = event

	elseif event.target.isFocus then
		if "moved" == phase then
			if ( event.target.distance ) then
				local dx,dy
				if previousTouches and ( numTotalTouches ) >= 2 then
					dx,dy = calculateDelta2( previousTouches, event )
				end
	
				if ( dx and dy ) then
					local newDistance = math.sqrt( dx*dx + dy*dy )
					modScale = newDistance / event.target.distance
					if ( modScale > 0 ) then
						----MODIFIED BY CON
						local newScale=event.target.xScaleOriginal * modScale
						-- uncomment below to set max and min scales
						maxScale,minScale=4,0.5
						if (newScale>maxScale) then 
							newScale=maxScale 
						end
						if (newScale<minScale) then 
							newScale=minScale 
						end

						event.target.xScale = newScale
						event.target.yScale = newScale
						-----------------------------
					end
				end
			----ADDED BY CON TO ORIGINAL PINCHZOOM CODE

			else
					local deltaX = event.target.prevX+event.x - startX
					local deltaY = event.target.prevY+event.y - startY
					if system.orientation == "landscapeLeft" then
						--deltaY = event.target.prevX+(event.x - startX)/varGlobal.aspectRatio
						--deltaX = -event.target.prevY-(event.y - startY)/varGlobal.aspectRatio
					elseif system.orientation == "landscapeRight" then
						--deltaX = event.target.prevX + (startX - event.x)/varGlobal.aspectRatio
						--deltaX = event.target.prevY+(event.y - startY)/varGlobal.aspectRatio
					end
					event.target.x = deltaX
					event.target.y = deltaY	
					--limits on image movement													
					local limit=1280
					if system.getInfo("platform") == "win32" then
						limit = varGlobal.numeroWin
					end
					local bounds = event.target.contentBounds 
					if (bounds.xMin>512+limit) then event.target.x=event.target.x-100 end
					if (bounds.yMin>376+limit) then event.target.y=event.target.y-100 end							
					if (bounds.xMax<512-limit) then event.target.x=event.target.x+100 end
					if (bounds.yMax<376-limit) then event.target.y=event.target.y+100 end
			---------------------------------
			end

			if not previousTouches[event.id] then
				event.target.numPreviousTouches = event.target.numPreviousTouches + 1
			end
			previousTouches[event.id] = event
			if system.orientation == "landscapeLeft" then
				if startY then

					--event.target.y = (event.x - startX)/varGlobal.aspectRatio + event.target.prevY
					
					--event.target.x = -(event.y - startY)/varGlobal.aspectRatio + event.target.prevX
				end
			elseif system.orientation == "landscapeRight" then
				if startY then
					--event.target.y = -(event.x - startX)/varGlobal.aspectRatio + event.target.prevY
					
					--event.target.x = (event.y - startY)/varGlobal.aspectRatio + event.target.prevX
				end
			else
				if startY then
					--e.target.y = e.y - startY + event.target.prevY
					--target.x = event.x - startX + event.target.prevX
				end
			end
		elseif "ended" == phase or "cancelled" == phase then									
			
			if previousTouches[event.id] then
				event.target.numPreviousTouches = event.target.numPreviousTouches - 1
				previousTouches[event.id] = nil
			end
			if (event.target.anchorX~=0.5) then
				axOff=event.target.anchorX-0.5
				ayOff=event.target.anchorY-0.5
				event.target.anchorX=0.5
				event.target.anchorY=0.5

				event.target.x=event.target.x-(axOff*(event.target.width*event.target.xScale))
				event.target.y=event.target.y-(ayOff*(event.target.height*event.target.yScale))

			end
			if ( #previousTouches > 0 ) then
				-- must be at least 2 touches remaining to pinch/zoom
				event.target.distance = nil

			else
				-- previousTouches is empty so no more fingers are touching the screen
				-- Allow touch events to be sent normally to the objects they "hit"
				display.getCurrentStage():setFocus( nil )
				event.target.isFocus = false
				event.target.distance = nil
				-- reset array
				event.target.previousTouches = nil
				event.target.numPreviousTouches = nil
				
				----ADDED BY CON TO ORIGINAL PINCHZOOM CODE
				-- Detecting a touch event or move event that's less than 12 pixels as a selection within the image
				local function submitTouch(x,y)
					--use this for a single touch event
				end
				if (math.abs(startX-event.x)<12) and (math.abs(startY-event.y)<12) and (not isMulti) then submitTouch(event.x,event.y) end
				event.target.prevX = event.target.x
				event.target.prevY = event.target.y

				----------------------------
			end

		end
	end
end

--===========================================================================
-- ZOOM ESPECIAL --=================================================
--===========================================================================
-- which environment are we running on?
local isDevice = (system.getInfo("environment") == "device")


-- returns the distance between points a and b
function lengthOf( a, b )
    local width, height = b.x-a.x, b.y-a.y
    return (width*width + height*height)^0.5
end

-- returns the degrees between (0,0) and pt
-- note: 0 degrees is 'east'
function angleOfPoint( pt )
    local x, y = pt.x, pt.y
    local radian = math.atan2(y,x)
    local angle = radian*180/math.pi
    if angle < 0 then angle = 360 + angle end
    return angle
end

-- returns the degrees between two points
-- note: 0 degrees is 'east'
function angleBetweenPoints( a, b )
    local x, y = b.x - a.x, b.y - a.y
    return angleOfPoint( { x=x, y=y } )
end

-- returns the smallest angle between the two angles
-- ie: the difference between the two angles via the shortest distance
function smallestAngleDiff( target, source )
    local a = target - source

    if (a > 180) then
        a = a - 360
    elseif (a < -180) then
        a = a + 360
    end

    return a
end

-- rotates a point around the (0,0) point by degrees
-- returns new point object
function rotatePoint( point, degrees )
    local x, y = point.x, point.y

    local theta = math.rad( degrees )

    local pt = {
        x = x * math.cos(theta) - y * math.sin(theta),
        y = x * math.sin(theta) + y * math.cos(theta)
    }

    return pt
end

-- rotates point around the centre by degrees
-- rounds the returned coordinates using math.round() if round == true
-- returns new coordinates object
function rotateAboutPoint( point, centre, degrees, round )
    local pt = { x=point.x - centre.x, y=point.y - centre.y }
    pt = rotatePoint( pt, degrees )
    pt.x, pt.y = pt.x + centre.x, pt.y + centre.y
    if (round) then
        pt.x = math.round(pt.x)
        pt.y = math.round(pt.y)
    end
    return pt
end



-- calculates the average centre of a list of points
local function calcAvgCentre( points )
    local x, y = 0, 0

    for i=1, #points do
        local pt = points[i]
        x = x + pt.x
        y = y + pt.y
    end

    return { x = x / #points, y = y / #points }
end

-- calculate each tracking dot's distance and angle from the midpoint
local function updateTracking( centre, points )
    for i=1, #points do
        local point = points[i]

        point.prevAngle = point.angle
        point.prevDistance = point.distance

        point.angle = angleBetweenPoints( centre, point )
        point.distance = lengthOf( centre, point )
    end
end

-- calculates rotation amount based on the average change in tracking point rotation
local function calcAverageRotation( points )
    local total = 0

    for i=1, #points do
        local point = points[i]
        total = total + smallestAngleDiff( point.angle, point.prevAngle )
    end

    return total / #points
end

-- calculates scaling amount based on the average change in tracking point distances
local function calcAverageScaling( points )
    local total = 0

    for i=1, #points do
        local point = points[i]
        total = total + point.distance / point.prevDistance
    end

    return total / #points
end



-- creates an object to be moved
function newTrackDot(e)
    -- create a user interface object
    local circle = display.newCircle( e.x, e.y, 50 )

    -- make it less imposing
    circle.alpha = .5

    -- keep reference to the rectangle
    local rect = e.target

    -- standard multi-touch event listener
    function circle:touch(e)
        -- get the object which received the touch event
        local target = circle

        -- store the parent object in the event
        e.parent = rect

        -- handle each phase of the touch event life cycle...
        if (e.phase == "began") then
            -- tell corona that following touches come to this display object
            display.getCurrentStage():setFocus(target, e.id)
            -- remember that this object has the focus
            target.hasFocus = true
            -- indicate the event was handled
            return true
        elseif (target.hasFocus) then
            -- this object is handling touches
            if (e.phase == "moved") then
                -- move the display object with the touch (or whatever)
                target.x, target.y = e.x, e.y
            else -- "ended" and "cancelled" phases
                -- stop being responsible for touches
                display.getCurrentStage():setFocus(target, nil)
                -- remember this object no longer has the focus
                target.hasFocus = false
            end

            -- send the event parameter to the rect object
            rect:touch(e)

            -- indicate that we handled the touch and not to propagate it
            return true
        end

        -- if the target is not responsible for this touch event return false
        return false
    end

    -- listen for touches starting on the touch layer
    circle:addEventListener("touch")

    -- listen for a tap when running in the simulator
    function circle:tap(e)
        if (e.numTaps == 2) then
            -- set the parent
            e.parent = rect

            -- call touch to remove the tracking dot
            rect:touch(e)
        end
        return true
    end

    -- only attach tap listener in the simulator
    if (not isDevice) then
        circle:addEventListener("tap")
    end

    -- pass the began phase to the tracking dot
    circle:touch(e)

    -- return the object for use
    return circle
end



-- spawning tracking dots

-- create display group to listen for new touches
local group = display.newGroup()


-- keep a list of the tracking dots
GRUPOGERAL.dots = {}
local grupoRects = display.newGroup()
-- advanced multi-touch event listener
function touch(self, e)
    -- get the object which received the touch event
    local target = e.target

    -- get reference to self object
    local rect = self
	
    -- handle began phase of the touch event life cycle...
    if (e.phase == "began") then
        print( e.phase, e.x, e.y )

        -- create a tracking dot
        local dot = newTrackDot(e)
		grupoRects:insert(dot)
        -- add the new dot to the list
        rect.dots[ #rect.dots+1 ] = dot
		
        -- pre-store the average centre position of all touch points
        rect.prevCentre = calcAvgCentre( rect.dots )

        -- pre-store the tracking dot scale and rotation values
        updateTracking( rect.prevCentre, rect.dots )

        -- we handled the began phase
        return true
    elseif (e.parent == rect) then
        if (e.phase == "moved") then
            print( e.phase, e.x, e.y )

            -- declare working variables
            local centre, scale, rotate = {}, 1, 0

            -- calculate the average centre position of all touch points
            centre = calcAvgCentre( rect.dots )

            -- refresh tracking dot scale and rotation values
            updateTracking( rect.prevCentre, rect.dots )

            -- if there is more than one tracking dot, calculate the rotation and scaling
            if (#rect.dots > 1) then
                -- calculate the average rotation of the tracking dots
                rotate = calcAverageRotation( rect.dots )

                -- calculate the average scaling of the tracking dots
                scale = calcAverageScaling( rect.dots )

                -- apply rotation to rect
                --rect.rotation = rect.rotation + rotate

                -- apply scaling to rect
                rect.xScale, rect.yScale = rect.xScale * scale, rect.yScale * scale
				
				
            end
			
            -- declare working point for the rect location
            local pt = {}
			local xOriginal = target.x
			local yOriginal = target.y
            -- translation relative to centre point move
            pt.x = rect.x + (centre.x - rect.prevCentre.x)
            pt.y = rect.y + (centre.y - rect.prevCentre.y)

            -- scale around the average centre of the pinch
            -- (centre of the tracking dots, not the rect centre)
            pt.x = centre.x + ((pt.x - centre.x) * scale)
            pt.y = centre.y + ((pt.y - centre.y) * scale)

            -- rotate the rect centre around the pinch centre
            -- (same rotation as the rect is rotated!)
            pt = rotateAboutPoint( pt, centre, rotate, false )

            -- apply pinch translation, scaling and rotation to the rect centre
			if #rect.dots == 1  and system.orientation == "portrait"then
				if self.xScale <= 1 then
					rect.y = pt.y
					if rect.y > 0 then
						rect.y = 0
					end
					local numero = 1280
					if system.getInfo("platform") == "win32" then
						numero = varGlobal.numeroWin
					end
					if rect.y < -varGlobal.limiteTela +numero then
						rect.y = -varGlobal.limiteTela +numero
					end
				else
					rect.x, rect.y = pt.x, pt.y
				end
				
			elseif #rect.dots == 1  and system.orientation ~= "portrait"then
				if self.xScale <= varGlobal.aumentoProp then
					rect.x = pt.x
					if system.orientation == "landscapeLeft" then
						if self.x > 0 then
							self.x = 0
						end
						if self.x < W-varGlobal.limiteTela*varGlobal.aumentoProp then
							self.x = W-varGlobal.limiteTela*varGlobal.aumentoProp
						end
					elseif system.orientation == "landscapeRight" then
						if self.x < 720 then
							self.x = 720
						end
						if self.x > varGlobal.limiteTela*varGlobal.aumentoProp then
							self.x = varGlobal.limiteTela*varGlobal.aumentoProp
						end
					end
				else
					rect.x, rect.y = pt.x, pt.y
				end
				
			else
				--caso seja mais de um dedo
				rect.x, rect.y = pt.x, pt.y
			end
			--[[
							if GRUPOGERAL.tipo == "landscapeLeft" then
								if toqueY then
									e.target.x = e.x - toqueY + targetY
									if e.target.x > 0 then
										e.target.x = 0
									end
									if e.target.x < W-varGlobal.limiteTela*1.5 then
										e.target.x = W-varGlobal.limiteTela*1.5
									end
								end
							elseif GRUPOGERAL.tipo == "landscapeRight" then
								if toqueY then
									e.target.x = e.x - toqueY + targetY
									if e.target.x < 720 then
										e.target.x = 720
									end
									if e.target.x > varGlobal.limiteTela*1.5 then
										e.target.x = varGlobal.limiteTela*1.5
									end
								end
							else
								if toqueY then
									e.target.y = e.y - toqueY + targetY
									if e.target.y > 0 then
										e.target.y = 0
									end
									if e.target.y < -varGlobal.limiteTela +1280 then
										e.target.y = -varGlobal.limiteTela +1280
									end
								end
							end]]
            -- store the centre of all touch points
            rect.prevCentre = centre
			
			if system.orientation == "portrait"then
				if self.xScale < 1 then
					self.xScale = 1
					self.yScale = 1
					self.x = 0
					self.y = 0
					for i=1,#rect.dots do
						table.remove( rect.dots, i )
					end
					rect.dots = {}
					while grupoRects.numChildren > 0 do
						local child = grupoRects[1]
						if child then child:removeSelf() end
						print("middleGroup.numChildren" , grupoRects.numChildren )
					end
				end
			else
				if self.xScale < varGlobal.aumentoProp then
					self.xScale = varGlobal.aumentoProp
					self.yScale = varGlobal.aumentoProp
					if system.orientation == "landscapeRight" then
						--self.y = self.YPagina
						transition.to(self,{time = 0,x=0+varGlobal.limiteTela,y=0})
					else
						--self.x = 0
						transition.to(self,{time = 0,x=0,y=0+self.width*varGlobal.aumentoProp})
					end
					
					for i=1,#rect.dots do
						table.remove( rect.dots, i )
					end
					rect.dots = {}
					while grupoRects.numChildren > 0 do
						local child = grupoRects[1]
						if child then child:removeSelf() end
						print("middleGroup.numChildren" , grupoRects.numChildren )
					end
				end
			end
        else -- "ended" and "cancelled" phases
            print( e.phase, e.x, e.y )

            -- remove the tracking dot from the list
            if (isDevice or e.numTaps == 2) then
                -- get index of dot to be removed
                local index = table.indexOf( rect.dots, e.target )

                -- remove dot from list
                table.remove( rect.dots, index )

                -- remove tracking dot from the screen
                e.target:removeSelf()

                -- store the new centre of all touch points
                rect.prevCentre = calcAvgCentre( rect.dots )

                -- refresh tracking dot scale and rotation values
                updateTracking( rect.prevCentre, rect.dots )
            end
			if system.orientation == "portrait" then
				self.YPagina[paginaAtual] = self.y
			elseif system.orientation == "landscapeLeft" then
				self.YPagina[paginaAtual] = (-1)*math.abs(self.x/varGlobal.aumentoProp)
			elseif system.orientation == "landscapeRight" then
				self.YPagina[paginaAtual] = (-1)*math.abs(self.x/varGlobal.aumentoProp - W/varGlobal.aumentoProp)
			end
			if system.orientation == "portrait" then
				self.YPagina[paginaAtual] = self.y
			elseif system.orientation == "landscapeLeft" then
				self.YPagina[paginaAtual] = (-1)*math.abs(self.x/varGlobal.aumentoProp)
			elseif system.orientation == "landscapeRight" then
				self.YPagina[paginaAtual] = (-1)*math.abs(self.x/varGlobal.aumentoProp - W/varGlobal.aumentoProp)
			end
        end
        return true
    end

    -- if the target is not responsible for this touch event return false
    return false
end

--GRUPOGERAL.touch = touch
--GRUPOGERAL:addEventListener("touch")


--===========================================================================
--===========================================================================

--[[function ZOOMZOOMZOOM( event )

	local result = true
	local phase = event.phase
	local previousTouches = event.target.previousTouches
	local numTotalTouches = 1

	if previousTouches then
		-- Add in total from "previousTouches", subtracting 1 if event is already in the array
		numTotalTouches = numTotalTouches + event.target.numPreviousTouches
		if previousTouches[event.id] then
			numTotalTouches = numTotalTouches - 1
		end
	end

	if ( "began" == phase ) then

		toqueY = event.y
		targetY = event.target.y
		toqueX = event.x
		targetX = event.target.x

		if system.orientation == "landscapeLeft" or system.orientation == "landscapeRight" then
			toqueY = event.x
			targetY = event.target.x
			toqueX = event.y
			targetX = event.target.y
		end
		if event.target.yScale < 0.5 then
			event.target.yScale = 0.5
			event.target.xScale = 0.5
		end
		-- Set touch focus on first "began" event
		if not event.target.isFocus then
			display.currentStage:setFocus( event.target )
			event.target.isFocus = true
			-- Reset "previousTouches"
			previousTouches = {}
			event.target.previousTouches = previousTouches
			event.target.numPreviousTouches = 0
		elseif not event.target.distance then
			local dx, dy
			if previousTouches and ( numTotalTouches ) >= 2 then
				dx, dy = calculateDelta( previousTouches, event )
			end
			-- Initialize the distance between two touches
			if ( dx and dy ) then
				local d = math.sqrt( dx*dx + dy*dy )
				if ( d > 0 ) then
					event.target.distance = d
					event.target.xScaleOriginal = event.target.xScale
					event.target.yScaleOriginal = event.target.yScale
					--print( "Distance: " .. self.distance )
				end
			end
		end

		if not previousTouches[event.id] then
			event.target.numPreviousTouches = event.target.numPreviousTouches + 1
		end
		previousTouches[event.id] = event
				
		-- If image is already in touch focus, handle other phases
		elseif event.target.isFocus then

			-- Handle touch moved phase
			if ( "moved" == phase ) then
				
				if event.target.distance and event.target.yScale >= 0.5  then
					local dx, dy
					-- Must be at least 2 touches remaining to pinch/zoom
					if ( previousTouches and numTotalTouches >= 2 ) then
						dx, dy = calculateDelta( previousTouches, event )
					end

					if ( dx and dy ) then
						local newDistance = math.sqrt( dx*dx + dy*dy )
						local scale = newDistance / event.target.distance
						--print( "newDistance(" ..newDistance .. ") / distance(" .. self.distance .. ") = scale("..  scale ..")" )
						if ( scale > 0 ) then
							event.target.xScale = event.target.xScaleOriginal * scale
							event.target.yScale = event.target.yScaleOriginal * scale
						end
						
					end
					-- if event.target.tipoG and event.target.tipoG == "Geral" then
							
						-- local acrescimo = 50
						
						-- --limitando o eixo Y --------
						-- if event.target.height*event.target.yScale <= H then
							-- event.target.y = H/2 - ((varGlobal.limiteTela*event.target.yScale)/2)
						-- elseif event.target.y > 0 then 
							-- event.target.y = 0
						-- elseif event.target.y + event.target.height*event.target.yScale  <= H then
							-- event.target.y = H - event.target.height*event.target.yScale
						-- else
							-- if event.target.y > 0 then 
								-- event.target.y = 0
							-- else
								-- event.target.y = event.y - toqueY + targetY
							-- end
						-- end
						-- --limitando o eixo X --------
						-- if event.target.width*event.target.xScale <= W then
							-- event.target.x = W/2 - ((event.target.width*event.target.xScale)/2) + acrescimo
						-- elseif event.target.x > 0 then 
							-- event.target.x = 0
						-- elseif event.target.x + event.target.width*event.target.xScale  <= W then
							-- event.target.x = W - event.target.width*event.target.xScale + acrescimo*2
						-- else
							-- if event.target.x > 0 then 
								-- event.target.x = 0
							-- else
								--event.target.x = event.x - toqueX + targetX
							-- end
						-- end
					--else
						event.target.y = (event.y - toqueY + targetY) / dy
						event.target.x = event.x - toqueX + targetX
					--end
				else
					if system.orientation == "portrait" then
						-- if event.target.tipoG and event.target.tipoG == "Geral" then
							
							-- local acrescimo = 50
							
							----limitando o eixo Y --------
							-- if event.target.height*event.target.yScale <= H then
								-- event.target.y = H/2 - ((varGlobal.limiteTela*event.target.yScale)/2)
							-- elseif event.target.y > 0 then 
								-- event.target.y = 0
							-- elseif event.target.y + event.target.height*event.target.yScale  <= H then
								-- event.target.y = H - event.target.height*event.target.yScale
							-- else
								-- if event.target.y > 0 then 
									-- event.target.y = 0
								-- else
									-- event.target.y = event.y - toqueY + targetY
								-- end
							-- end
							----limitando o eixo X --------
							-- if event.target.width*event.target.xScale <= W then
								-- event.target.x = W/2 - ((event.target.width*event.target.xScale)/2) + acrescimo
							-- elseif event.target.x > 0 then 
								-- event.target.x = 0
							-- elseif event.target.x + event.target.width*event.target.xScale  <= W then
								-- event.target.x = W - event.target.width*event.target.xScale + acrescimo*2
							-- else
								-- if event.target.x > 0 then 
									-- event.target.x = 0
								-- else
									-- event.target.x = event.x - toqueX + targetX
								-- end
							-- end
						-- else
							event.target.y = event.y - toqueY + targetY
							event.target.x = event.x - toqueX + targetX
						--end
					elseif system.orientation == "landscapeLeft" then
						event.target.x = -event.y + (toqueX + targetY)
						event.target.y = event.x - (toqueY - targetX)
					elseif system.orientation == "landscapeRight" then

						event.target.x = event.y - (toqueX - targetY)
						event.target.y = -event.x + (toqueY + targetX)
					end
				end

				if not previousTouches[event.id] then
					event.target.numPreviousTouches = event.target.numPreviousTouches + 1
				end
				previousTouches[event.id] = event
				--event.target.y = event.y - toqueY + targetY
				--event.target.x = event.x - toqueX + targetX
			-- Handle touch ended and/or cancelled phases
			elseif ( "ended" == phase or "cancelled" == phase ) then

				local acrescimo = 50 
				if previousTouches[event.id] then
					event.target.numPreviousTouches = event.target.numPreviousTouches - 1
					previousTouches[event.id] = nil
				end

				if ( #previousTouches > 0 ) then
					event.target.distance = nil
				else
					if event.target.tipoG and event.target.tipoG == "Geral" then
						if varGlobal.limiteTela*event.target.yScale <= H then
							event.target.y = H/2 - ((varGlobal.limiteTela*event.target.yScale)/2)
						elseif event.target.y > 0 then 
							event.target.y = 0
						elseif event.target.y + varGlobal.limiteTela*event.target.yScale  <= H then
							event.target.y = H - varGlobal.limiteTela*event.target.yScale
						end
						if event.target.width*event.target.xScale <= W then
							event.target.x = W/2 - ((event.target.width*event.target.xScale)/2) + acrescimo
						elseif event.target.x > 0 then 
							event.target.x = 0
						elseif event.target.x + event.target.width*event.target.xScale  <= W then
							event.target.x = W - event.target.width*event.target.xScale + acrescimo*2
						end
					end
					-- Since "previousTouches" is empty, no more fingers are touching the screen
					-- Thus, reset touch focus (remove from image)
					display.currentStage:setFocus( nil )
					event.target.isFocus = false
					event.target.distance = nil
					event.target.xScaleOriginal = nil
					event.target.yScaleOriginal = nil
					-- Reset array
					event.target.previousTouches = nil
					event.target.numPreviousTouches = nil
				end
			end
		end
	return result
end]]
	--	--	--	--	 FIM 	--	--	--	--

	
local vetorVoltar = {}
local function networkListener00( event ) -- listener do numero da pagina (TTS)
	print("resposta:")
	print(event.response)
	print("--------")		
	local arquivo = "textoVozGeral pagina("..paginaAtual..").MP3"
	if system.getInfo("platform") == "win32" then
		arquivo = "textoVozGeral pagina("..paginaAtual..").MP3"
	end
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
		print("textoVozGeral pagina("..paginaAtual..").MP3")
		
		audio.pause()
		local som = audio.loadSound(arquivo,system.DocumentsDirectory)
		--local channel, source = audio.play(som)
		--al.Source(source, al.PITCH, 2)
		local function onComplete()
			audio.resume()
		end
		timer.performWithDelay(16,function() audio.play(som,{onComplete = onComplete}) end,1)
		
		--timer.performWithDelay(16,function() media.playSound( arquivo , system.DocumentsDirectory);end,1)
	end
end
	
-- COntrolador do botão voltar --	

local function createFilePagina(pagina)
	auxFuncs.criarTxTDocWSemMais("paginaSalva.txt",pagina)
end
local function createFilePaginaVoltar(pagina)
	auxFuncs.criarTxTDocWSemMais("paginaVoltar.txt",pagina)
end
-- função de atualizar histórico --
local yy = 1
local function copyFileHistorico( srcName, srcPath, dstName, dstPath, overwrite )
		
	local results = false
	local function doesFileExist( fname, path )

		local results = false
	 
		-- Path for the file
		local filePath = path .. "/"..fname
		--auxFuncs.testarNoAndroid(filePath.."!",60*yy)
		
		if ( filePath ) then
			local file, errorString = io.open( filePath, "r" )
			--auxFuncs.testarNoAndroid(tostring(errorString).."!",(60*yy)+30)
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
		yy = yy+1
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
-- segunda opcao para salvar tables com o simbolo \n --
local function exportstring( s )
	return string.format("%q", s)
end
local function tablesave(  tbl,filename )
	local charS,charE = "   ","\n"
	local file,err = io.open( filename, "wb" )
	if err then return err end

	-- initiate variables for save procedure
	local tables,lookup = { tbl },{ [tbl] = 1 }
	file:write( "return {"..charE )

	for idx,t in ipairs( tables ) do
	 file:write( "-- Table: {"..idx.."}"..charE )
	 file:write( "{"..charE )
	 local thandled = {}

	 for i,v in ipairs( t ) do
		thandled[i] = true
		local stype = type( v )
		-- only handle value
		if stype == "table" then
		   if not lookup[v] then
			  table.insert( tables, v )
			  lookup[v] = #tables
		   end
		   file:write( charS.."{"..lookup[v].."},"..charE )
		elseif stype == "string" then
		   file:write(  charS..exportstring( v )..","..charE )
		elseif stype == "number" then
		   file:write(  charS..tostring( v )..","..charE )
		end
	 end

	 for i,v in pairs( t ) do
		-- escape handled values
		if (not thandled[i]) then
		
		   local str = ""
		   local stype = type( i )
		   -- handle index
		   if stype == "table" then
			  if not lookup[i] then
				 table.insert( tables,i )
				 lookup[i] = #tables
			  end
			  str = charS.."[{"..lookup[i].."}]="
		   elseif stype == "string" then
			  str = charS.."["..exportstring( i ).."]="
		   elseif stype == "number" then
			  str = charS.."["..tostring( i ).."]="
		   end
		
		   if str ~= "" then
			  stype = type( v )
			  -- handle value
			  if stype == "table" then
				 if not lookup[v] then
					table.insert( tables,v )
					lookup[v] = #tables
				 end
				 file:write( str.."{"..lookup[v].."},"..charE )
			  elseif stype == "string" then
				 file:write( str..exportstring( v )..","..charE )
			  elseif stype == "number" then
				 file:write( str..tostring( v )..","..charE )
			  end
		   end
		end
	 end
	 file:write( "},"..charE )
	end
	file:write( "}" )
	file:close()
end

	--// The Load Function
local function tableload( sfile )
	local ftables,err = loadfile( sfile )
	--print("ftables =>",ftables)
	--print("err =>",err)
	if err then return _,err end
	local tables = ftables()
	for idx = 1,#tables do
		--print("#tables =>",#tables)
		--print("idx =>",idx)
		local tolinki = {}
		for i,v in pairs( tables[idx] ) do
			if type( v ) == "table" then
			   tables[idx][i] = tables[v[1]]
			   --print("tables[idx][i] =>",tables[idx][i])
			end
			if type( i ) == "table" and tables[i[1]] then
				--print("insert =>",tables[i[1]])
			   table.insert( tolinki,{ i,tables[i[1]] } )
			end
		end
		-- link indices
		for _,v in ipairs( tolinki ) do
			tables[idx][v[2]],tables[idx][v[1]] =  tables[idx][v[1]],nil
		end
	end
	return tables[1]
end

-------------------

--[[function funcGlobal.escreverNoHistorico(texto,vetorJson)
	if varGlobal.temHistorico == true then
		local date = os.date( "*t" )
		local dataHistorico = date.day.."|"..date.month.."|"..date.year.."|"..date.hour..":"..date.min..":"..date.sec.."|||"
		
		local path = system.pathForFile( "historico.txt", system.DocumentsDirectory )
		local file, errorString = io.open( path, "a" )
		file:write(dataHistorico..texto.."\n")
		io.close( file )
		file = nil
		local tipoSistemaMac = system.getInfo("platform")
		
		--local vetorJson = {data = dataHistorico,acao = texto}
		
		if vetorJson then
			local vetorJsonAux = auxFuncs.loadTable("historico.json")
			if not vetorJsonAux then vetorJsonAux = {} end
			--vetorJson.sessao_id = dataHistorico
			vetorJson.data = date.year.."-"..date.month.."-"..date.day.." "..date.hour..":"..date.min..":"..date.sec..".0"
			
			table.insert(vetorJsonAux,vetorJson)
			if not vetorJsonAux.numeroEntradas then
				vetorJsonAux.numeroEntradas = 1
			else
				vetorJsonAux.numeroEntradas = tonumber(vetorJsonAux.numeroEntradas) + 1
			end

			auxFuncs.overwriteTable( vetorJsonAux, "historico.json")
		end
		
		if auxFuncs.fileExistsDoc("historico offline.txt") then
			if varGlobal.tipoSistema == "android" then
				copyFileHistorico( "historico offline.txt", string.gsub(system.pathForFile("historico offline.txt",system.DocumentsDirectory),"historico offline.txt",""), "historico offline.txt", "/sdcard", true )
			elseif varGlobal.tipoSistema == "PC" then
				if tipoSistemaMac == "macos" then
					copyFileHistorico( "historico offline.txt", string.gsub(system.pathForFile("historico offline.txt",system.DocumentsDirectory),"historico offline.txt",""), "historico offline.txt", ssk.files.desktop.getDesktopRoot(), true )
				else
					copyFileHistorico( "historico offline.txt", string.gsub(system.pathForFile("historico offline.txt",system.DocumentsDirectory),"historico offline.txt",""), "historico offline.txt", "C:/!E-book Hipermidia!", true )
				end
			end
		end
	end
	
	
end]]
function funcGlobal.pegarNumeroPaginaRomanosHistorico(pagina)
	local auxPaginaLivro = tostring(pagina)
	if string.find(auxPaginaLivro,"%-") then
		auxPaginaLivro = auxFuncs.ToRomanNumerals(string.gsub(auxPaginaLivro,"%-",""))
	else
		auxPaginaLivro = auxPaginaLivro
	end
	return auxPaginaLivro
end
function funcGlobal.escreverNoHistorico(texto,vetorJson)
	if varGlobal.temHistorico == true then
		local date = os.date( "*t" )
		local dataHistorico = date.day.."|"..date.month.."|"..date.year.."|"..date.hour..":"..date.min..":"..date.sec.."|||"
		
		local path = system.pathForFile( "historico.txt", system.DocumentsDirectory )
		local file, errorString = io.open( path, "a" )
		file:write(dataHistorico..texto.."\n")
		io.close( file )
		file = nil
		local tipoSistemaMac = system.getInfo("platform")
		
		--local vetorJson = {data = dataHistorico,acao = texto}
		
		if vetorJson then
			local vetorJsonAux = auxFuncs.loadTable("historico.json")
			
			if not vetorJsonAux then vetorJsonAux = {} end
			--vetorJson.sessao_id = dataHistorico
			vetorJson.data = os.date("!%Y-%m-%dT%TZ")--date.year.."-"..date.month.."-"..date.day.." "..date.hour..":"..date.min..":"..date.sec..".0"
			
			table.insert(vetorJsonAux,vetorJson)
			

			auxFuncs.overwriteTable( vetorJsonAux, "historico.json")
		end
		
		if auxFuncs.fileExistsDoc("historico offline.txt") then
			if varGlobal.tipoSistema == "android" then
				copyFileHistorico( "historico offline.txt", string.gsub(system.pathForFile("historico offline.txt",system.DocumentsDirectory),"historico offline.txt",""), "historico offline.txt", "/sdcard", true )
			elseif varGlobal.tipoSistema == "PC" then
				if tipoSistemaMac == "macos" then
					copyFileHistorico( "historico offline.txt", string.gsub(system.pathForFile("historico offline.txt",system.DocumentsDirectory),"historico offline.txt",""), "historico offline.txt", ssk.files.desktop.getDesktopRoot(), true )
				else
					copyFileHistorico( "historico offline.txt", string.gsub(system.pathForFile("historico offline.txt",system.DocumentsDirectory),"historico offline.txt",""), "historico offline.txt", "C:/!E-book Hipermidia!", true )
				end
			end
		end
	end
	
	
end
function string.urlEncode( str )
 
    if ( str ) then
        str = string.gsub( str, "\n", "\r\n" )
        str = string.gsub( str, "([^%w ])",
            function( c )
                return string.format( "%%%02X", string.byte(c) )
            end
        )
        str = string.gsub( str, " ", "+" )
    end
    return str
end
-- FIM --
--local qualidadeSom = "8khz_8bit_mono"
--local qualidadeSom = "11khz_8bit_mono"
--local qualidadeSom = "11khz_16bit_mono"
--local qualidadeSom = "12khz_8bit_mono"
local qualidadeSom = "12khz_16bit_mono"

local somFlip = audio.loadSound("page-flip-10.wav",system.ResourceDirectory)
local grupoAguarde = {}
local aumentouOSom = false
local function girarTelaOrientacaoAumentarIndice(botao)
	if system.orientation == "landscapeRight" then
		if system.getInfo( "platform" ) == "win32" then --win32
			botao.rotation = 0
			botao.y = W - botao.width*varGlobal.aumentoProp
			botao.x = botao.height*varGlobal.aumentoProp - botao.acrescimo*varGlobal.aumentoProp - 100*varGlobal.aumentoProp - 5--botao.height*varGlobal.aumentoProp
			botao.xScale = varGlobal.aumentoProp
			botao.yScale = varGlobal.aumentoProp
			botao.tipo = "portrait"
			
			print("\n\nPORTRAIT\n\n")
		else
			botao.rotation = 90
			aux = botao.y
			botao.y = H/2
			botao.x = W - botao.height*varGlobal.aumentoProp/2 - botao.acrescimo*varGlobal.aumentoProp - 100*varGlobal.aumentoProp - 5 + 80*varGlobal.aumentoProp
			botao.xScale = varGlobal.aumentoProp
			botao.yScale = varGlobal.aumentoProp
			botao.tipo = "landscapeRight"
			print("\n\nLEFT\n\n")
		end
	elseif system.orientation == "landscapeLeft" then
		botao.rotation = 270
		botao.y = H/2
		botao.x = 0 + botao.height*varGlobal.aumentoProp/2 + botao.acrescimo*varGlobal.aumentoProp + 100*varGlobal.aumentoProp + 5 - 80*varGlobal.aumentoProp
		botao.xScale = varGlobal.aumentoProp
		botao.yScale = varGlobal.aumentoProp
		botao.tipo = "landscapeLeft"
		print("\n\nRIGHT\n\n")
	elseif system.orientation == "portrait" then
		botao.rotation = 0
		botao.x = W/2
		botao.y = botao.acrescimo + botao.height/2  + 100 + 5 - 80--botao.height/2
		botao.xScale = 1
		botao.yScale = 1
		botao.tipo = "portrait"
		
		print("\n\nPORTRAIT\n\n")
	end
	botao:addEventListener("tap",function() return true; end)
end

-- MOVER TELA PADRÃO --
function MoverATela(e,telas)
	varGlobal.VetorBotoesBarra.numeroSprite.isVisible = false
	varGlobal.VetorBotoesBarra.retangulo.isVisible = false
	--print("\nlimite = "..varGlobal.limiteTela.."\n")
	--print("WARNING: MOVERTELA")
	--print(e.target.x,e.target.y)
	--print(e.target.width,e.target.height)
	if e.phase == "began" then
		if GRUPOGERAL.tipo == "landscapeLeft" or GRUPOGERAL.tipo == "landscapeRight" then
			toqueY = e.x
			targetY = e.target.x
		else
			toqueY = e.y
			targetY = e.target.y
			
		end
		--display.getCurrentStage():setFocus( e.target, e.id )
		toqueXX = e.x
		targetXX = e.target.x
		toqueYY = e.y
		targetYY = e.target.y
	end
	
	e.primeiroToque = ""
	if e.phase == "moved" then
		--toqueHabilitado = false
		if GRUPOGERAL.tipo == "landscapeLeft" then
			if toqueY then
				e.target.x = e.x - toqueY + targetY
				if e.target.x > 0 then
					e.target.x = 0
				end
				if e.target.x < W-varGlobal.limiteTela*varGlobal.aumentoProp then
					e.target.x = W-varGlobal.limiteTela*varGlobal.aumentoProp
				end
				if varGlobal.limiteTela < 720 then
					e.target.x = 0
				end
			end
			
		elseif GRUPOGERAL.tipo == "landscapeRight" then
			if toqueY then
				e.target.x = e.x - toqueY + targetY
				if e.target.x < 720 then
					e.target.x = 720
				end
				if e.target.x > varGlobal.limiteTela*varGlobal.aumentoProp then
					e.target.x = varGlobal.limiteTela*varGlobal.aumentoProp
				end
				if varGlobal.limiteTela < 720 then
					e.target.x = 720
				end
			end
		else
			if toqueY then
				--print("1",e.target.y)
				--print(toqueY)
				--print(targetY)
				--print("4",varGlobal.limiteTela)
				e.target.y = e.y - toqueY + targetY
				if e.target.y > 0 then
					e.target.y = 0
				end
				local numero = 1280
				
				if system.getInfo("platform") == "win32" then
					numero = varGlobal.numeroWin
				end
				if e.target.y < -varGlobal.limiteTela +numero  then
					e.target.y = -varGlobal.limiteTela +numero
				end
				--print("WARNING:varGlobal.limiteTela",varGlobal.limiteTela)
				if varGlobal.limiteTela < 1280 then
					e.target.y = 0
				end
			end
		end
		
		if toqueXX and type(paginaAtual) == "number" then
			--- botao direito passar pagina
			if system.orientation == "portrait" then
				if e.x < toqueXX - varGlobal.pixelsPassarPage then
					varGlobal.botaoDireito.isVisible = true
				else
					varGlobal.botaoDireito.isVisible = false
				end
			elseif system.orientation == "landscapeLeft" then
				if e.y > toqueYY +varGlobal.pixelsPassarPage then
					varGlobal.botaoDireito.isVisible = true
				else
					varGlobal.botaoDireito.isVisible = false
				end
			elseif system.orientation == "landscapeRight" then
				if e.y < toqueYY -varGlobal.pixelsPassarPage then
					varGlobal.botaoDireito.isVisible = true
				else
					varGlobal.botaoDireito.isVisible = false
				end
			end
			--- botao esquerdo passar pagina
			if system.orientation == "portrait" then
				if e.x > toqueXX +varGlobal.pixelsPassarPage then
					varGlobal.botaoEsquerdo.isVisible = true
				else
					varGlobal.botaoEsquerdo.isVisible = false
				end
			elseif system.orientation == "landscapeLeft" then
				if e.y < toqueYY -varGlobal.pixelsPassarPage then
					varGlobal.botaoEsquerdo.isVisible = true
				else
					varGlobal.botaoEsquerdo.isVisible = false
				end
			elseif system.orientation == "landscapeRight" then
				if e.y > toqueYY +varGlobal.pixelsPassarPage then
					varGlobal.botaoEsquerdo.isVisible = true
				else
					varGlobal.botaoEsquerdo.isVisible = false
				end
			end
		end
	end
	if e.phase == "ended" then
		if varGlobal.limiteTela < 1280 and system.orientation == "portrait" then
			e.target.y = 0
		end
		if system.orientation == "portrait" then
			GRUPOGERAL.YPagina[paginaAtual] = GRUPOGERAL.y
		elseif system.orientation == "landscapeLeft" then
			GRUPOGERAL.YPagina[paginaAtual] = (-1)*math.abs(GRUPOGERAL.x/varGlobal.aumentoProp)
		elseif system.orientation == "landscapeRight" then
			GRUPOGERAL.YPagina[paginaAtual] = (-1)*math.abs(GRUPOGERAL.x/varGlobal.aumentoProp - W/varGlobal.aumentoProp)
		end
		--toqueHabilitado = true
		if system.orientation == "portrait" then
			GRUPOGERAL.YPagina[paginaAtual] = GRUPOGERAL.y
		elseif system.orientation == "landscapeLeft" then
			GRUPOGERAL.YPagina[paginaAtual] = (-1)*math.abs(GRUPOGERAL.x/varGlobal.aumentoProp)
		elseif system.orientation == "landscapeRight" then
			GRUPOGERAL.YPagina[paginaAtual] = (-1)*math.abs(GRUPOGERAL.x/varGlobal.aumentoProp - W/varGlobal.aumentoProp)
		end
		if varGlobal.botaoDireito.isVisible == true then
			varGlobal.botaoDireito.isVisible = false
			local passarPagina = false
			if system.orientation == "portrait" then
				if e.x <toqueXX -varGlobal.pixelsPassarPage and not(e.y < (toqueYY -varGlobal.pixelsPassarPage)) and not(e.y > (toqueYY +varGlobal.pixelsPassarPage)) then
					passarPagina = true
				end
			elseif system.orientation == "landscapeLeft" then
				if e.y > toqueYY +varGlobal.pixelsPassarPage and not(e.x < (toqueXX -varGlobal.pixelsPassarPage)) and not(e.x > (toqueXX +varGlobal.pixelsPassarPage))then
					passarPagina = true
				end
			elseif system.orientation == "landscapeRight" then
				if e.y < toqueYY -varGlobal.pixelsPassarPage and not(e.x < (toqueXX -varGlobal.pixelsPassarPage)) and not(e.x > (toqueXX +varGlobal.pixelsPassarPage)) then
					passarPagina = true
				end
			end
			if passarPagina == true then
				if(paginaAtual<varGlobal.numeroTotal.Todas and toqueHabilitado == true) then
					if TemUmaImagem[1] then
						TemUmaImagem[2] = 0
						TemUmaImagem[3] = 0
						TemUmaImagem[4] = 0
						TemUmaImagem[5] = 0
						TemUmaImagem[1] = 0
					end
					paginaAtual=paginaAtual+1
					print("foi para: "..paginaAtual.." de "..varGlobal.numeroTotal.Todas)
					media.stopSound()
					GRUPOGERAL.subPagina = nil
					criarCursoAux(varGlobal.botaoDireito.telas, paginaAtual)
					if GRUPOGERAL.grupoZoom then
						GRUPOGERAL.grupoZoom:removeSelf()
					end

					--girarTelaOrientacao(GRUPOGERAL)
				end
			end
		elseif varGlobal.botaoEsquerdo.isVisible == true then
			local passarPagina = false
			varGlobal.botaoEsquerdo.isVisible = false
			if system.orientation == "portrait" then
				if e.x > toqueXX +varGlobal.pixelsPassarPage and not(e.y < (toqueYY -varGlobal.pixelsPassarPage)) and not(e.y > (toqueYY +varGlobal.pixelsPassarPage)) then
					passarPagina = true
				end
			elseif system.orientation == "landscapeLeft" then
				if e.y < toqueYY -varGlobal.pixelsPassarPage and not(e.x < (toqueXX -varGlobal.pixelsPassarPage)) and not(e.x > (toqueXX +varGlobal.pixelsPassarPage))then
					passarPagina = true
				end
			elseif system.orientation == "landscapeRight" then
				if e.y > toqueYY +varGlobal.pixelsPassarPage and not(e.x < (toqueXX -varGlobal.pixelsPassarPage)) and not(e.x > (toqueXX +varGlobal.pixelsPassarPage)) then
					passarPagina = true
				end
			end
			if passarPagina == true then
				if(paginaAtual<=varGlobal.numeroTotal.Todas and paginaAtual>1 and toqueHabilitado == true) then
					clicouInicio = false
					if TemUmaImagem[1] then
						TemUmaImagem[2] = 0
						TemUmaImagem[3] = 0
						TemUmaImagem[4] = 0
						TemUmaImagem[5] = 0
						TemUmaImagem[1] = 0
					end
					paginaAtual=paginaAtual-1
					print("voltou para: "..paginaAtual.." de "..varGlobal.numeroTotal.Todas)
					media.stopSound()
					GRUPOGERAL.subPagina = nil
					criarCursoAux(varGlobal.botaoEsquerdo.telas, paginaAtual)
					if GRUPOGERAL.grupoZoom then
						GRUPOGERAL.grupoZoom:removeSelf()
					end

					--girarTelaOrientacao(GRUPOGERAL)
				end
			end
		end
		e.target.Ytoque = e.target.y
		--toqueHabilitado = true
		--display.getCurrentStage():setFocus( e.target, nil )
	end
	return true
end


-------------------------------------------------------------------------------
-- LER TXT E CRIAR TELA: ------------------------------------------------------
-------------------------------------------------------------------------------
-- criarMargensWindows ----
varGlobal.grupoMargens = display.newGroup()
varGlobal.WindowsDireita = display.newRect(W,0,1,H)
varGlobal.WindowsDireita.anchorX = 0; varGlobal.WindowsDireita.anchorY = 0
varGlobal.WindowsDireita:setFillColor(0,0,0)
varGlobal.WindowsEsquerda = display.newRect(0,0,1,H)
varGlobal.WindowsEsquerda.anchorX = 1; varGlobal.WindowsEsquerda.anchorY = 0
varGlobal.WindowsEsquerda:setFillColor(0,0,0)
varGlobal.grupoMargens:insert(varGlobal.WindowsDireita)
varGlobal.grupoMargens:insert(varGlobal.WindowsEsquerda)
GRUPOGERAL:insert(varGlobal.grupoMargens)
---------------------------
function criarTeladeArquivo(atributos,Telas,listaDeErros,iii,nomeArquivo)
	local vetorTTS = vetorTTS
	local pagina = paginaAtual
	local VetorDeVetorTTS = VetorDeVetorTTS
	local vetorTela = manipularTela.criarVetorTeladeArquivo(atributos,Telas,listaDeErros,iii,nomeArquivo,VetorTTS,varGlobal.substituicoesOnline,pagina,VetorDeVetorTTS)
	VetorTTS = {}
	
	return vetorTela
	
end
M.criarTeladeArquivo = criarTeladeArquivo

-- PROTETOR TELA --
local function TelaProtetiva()
	local telaPreta = display.newRect(0,0,W,H)
	telaPreta.anchorX = 0.5; telaPreta.anchorY = 0.5
	telaPreta.anchorX = 0.5; telaPreta.anchorY = 0.5
	telaPreta.x = W/2; telaPreta.y = H/2
	telaPreta.x = W/2; telaPreta.y = H/2
	telaPreta:setFillColor(1,1,1)
	telaPreta.alpha=0.9
	telaPreta:addEventListener("tap",function() return true end)
	telaPreta:addEventListener("touch",function() return true end)
	
	return telaPreta
end



-------------------------------------------------------------------------------
-- CRIAR CURSO AUX --
GRUPOGERAL.YPagina = {}
local PaGiNa = {}
PaGiNa.animacao = {}
varGlobal.tempoAbertoPagina = nil
varGlobal.tempoAbertoPaginaNumero = 0
if varGlobal.tempoAbertoLivro then
	timer.cancel(varGlobal.tempoAbertoLivro)
end
varGlobal.tempoAbertoLivroNumero = 0
varGlobal.tempoAbertoLivro = timer.performWithDelay(100,function() varGlobal.tempoAbertoLivroNumero = varGlobal.tempoAbertoLivroNumero + 100 end,-1)
local function contagemDaPaginaHistorico()
	local pagina
	if type(paginaAtual) == "number" then
		pagina = paginaAtual + varGlobal.contagemInicialPaginas -varGlobal.numeroTotal.PaginasPre-varGlobal.numeroTotal.Indices -1
	else
		--paginaPaginas_Pagina49_PagExerc1Alt3_3
		local aux1 = string.match(paginaAtual,"_Pagina%d+")
		local aux1_2 = string.match(aux1,"%d+")
		local pagina_atual = tonumber(aux1_2) + varGlobal.contagemInicialPaginas -varGlobal.numeroTotal.PaginasPre-varGlobal.numeroTotal.Indices -1
		
		local aux2 = string.match(paginaAtual,"_PagExerc%d+")
		local aux2_1 = string.match(aux2,"%d+")
		local exerc_atual = tonumber(aux2_1)
		
		local aux3 = string.match(paginaAtual,"Alt%d+")
		local aux3_1 = string.match(aux3,"%d+")
		local alt_atual = tonumber(aux3_1)
		
		pagina = tostring(pagina_atual)..", exercício "..exerc_atual..", alternativa "..alt_atual
		
	end
	return pagina
end

criouZoomDeTela = false

local function tirarAExtencao(str)
	local inverso = string.reverse(str)
	local inversoReduzidoNome = string.sub( inverso, 5 )
	local nome = string.reverse(inversoReduzidoNome)
	return nome
end
local function LimparTemporaryDirectory()
	local lfs = require "lfs";
	 
	local doc_dir = system.TemporaryDirectory;
	local doc_path = system.pathForFile(nil, doc_dir);
	local resultOK, errorMsg;
	 
	for file in lfs.dir(doc_path) do
		local theFile = system.pathForFile(file, doc_dir);
	 
		if (lfs.attributes(theFile, "mode") ~= "directory") then
			resultOK, errorMsg = os.remove(theFile);
		 
			if (resultOK) then
				print(file.." removed");
			else
				print("Error removing file: "..file..":"..errorMsg);
			end
		end
	end
end
local function LimparDocumentsDirectory()
	local lfs = require "lfs";
	 
	local doc_dir = system.DocumentsDirectory;
	local doc_path = system.pathForFile(nil, doc_dir);
	local resultOK, errorMsg;
	 
	for file in lfs.dir(doc_path) do
		local theFile = system.pathForFile(file, doc_dir);
	 
		if (lfs.attributes(theFile, "mode") ~= "directory") then
			resultOK, errorMsg = os.remove(theFile);
		 
			if (resultOK) then
				print(file.." removed");
			else
				print("Error removing file: "..file..":"..errorMsg);
			end
		end
	end
end

-- começo das exclusões --
function Var.RemoverPaginaAnterior()
	if Var.mensagemTemp then
		if Var.mensagemTemp.remover then
			Var.mensagemTemp.remover()
		end
	end
	if Var.fundo then
		Var.fundo:removeSelf()
		Var.fundo = nil
	end
	if Var.deck then
		Var.deck:removeSelf()
		Var.deck = nil
	end
	if Var.retanguloMenu then
		Var.retanguloMenu:removeSelf()
		Var.retanguloMenu = nil
	end
	if Var.botaoVoltarAlternativa then
		Var.botaoVoltarAlternativa:removeSelf()
		Var.botaoVoltarAlternativa = nil
	end
	if Var.grupoBloqueioPagina then
		Var.grupoBloqueioPagina:removeSelf()
	end
	if varGlobal.grupoVideoTTS then
		varGlobal.grupoVideoTTS:removeSelf()
	end
	if varGlobal.grupoBotaoTTS then
		varGlobal.grupoBotaoTTS:removeSelf()
	end
	if Var.botaoTTSAnotComentarios then
		Var.botaoTTSAnotComentarios:removeSelf()
		Var.botaoTTSAnotComentarios=nil
	end
	if varGlobal.grupoAnimacaoTTS then
		if varGlobal.grupoAnimacaoTTS.timer then
			for i=1,#varGlobal.grupoAnimacaoTTS.timer do
				timer.cancel(varGlobal.grupoAnimacaoTTS.timer[i])
				varGlobal.grupoAnimacaoTTS.timer[i] = nil
			end
		end
		if varGlobal.grupoAnimacaoTTS.timer2 then
			timer.cancel(varGlobal.grupoAnimacaoTTS.timer2)
			varGlobal.grupoAnimacaoTTS.timer2 = nil
		end
		if varGlobal.grupoAnimacaoTTS.som then
			audio.stop(varGlobal.grupoAnimacaoTTS.som)
			varGlobal.grupoAnimacaoTTS.som = nil
		end
		varGlobal.grupoAnimacaoTTS:removeSelf()
		varGlobal.grupoAnimacaoTTS=nil
	end
	if Var.retanguloMovimento then
		Var.retanguloMovimento:removeSelf()
		Var.retanguloMovimento = nil
	end
	if(Var.botaoConfigTTS ~= nil) then
		--Var.botaoConfigTTS:removeSelf()
		--Var.botaoConfigTTS = nil
	end
	if(Var.espacos ~= nil) then
		for esp=1, #Var.espacos do
			Var.espacos[esp] = nil
		end
		Var.espacos = {}
	end
	if(Var.separadores ~= nil) then
		for sep=1, #Var.separadores do
			Var.separadores[sep]:removeSelf()
			Var.separadores[sep] = nil
		end
		Var.separadores = {}
	end
	if(Var.imagemTextos ~= nil) then
		for imtx=1, #Var.imagemTextos do
			if Var.imagemTextos[imtx].MenuRapido then
				Var.imagemTextos[imtx].MenuRapido:removeSelf()
				Var.imagemTextos[imtx].MenuRapido = nil
			end
			if Var.imagemTextos[imtx].botaoDeAumentar then
				Var.imagemTextos[imtx].botaoDeAumentar:removeSelf()
				Var.imagemTextos[imtx].botaoDeAumentar = nil
				jacliquei = false
			end
			Var.imagemTextos[imtx]:removeSelf()
			Var.imagemTextos[imtx] = nil
		end
		Var.imagemTextos = {}
	end
	if(Var.sons ~= nil) then
		for son=1, #Var.sons do
			if Var.sons[son].Runtime then
				timer.cancel(Var.sons[son].Runtime)
				Var.sons[son].Runtime = nil
			end
			if Var.sons[son].RuntimeSlider then
				timer.cancel(Var.sons[son].RuntimeSlider)
				Var.sons[son].RuntimeSlider = nil
			end
			if Var.sons[son].delay then
				timer.cancel(Var.sons[son].delay)
				Var.sons[son].delay = nil
			end
			if Var.sons[son].timerVoltar then
				timer.cancel(Var.sons[son].timerVoltar)
				Var.sons[son].timerVoltar = nil
			end
			if Var.sons[son].timerAvancar then
				timer.cancel(Var.sons[son].timerAvancar)
				Var.sons[son].timerAvancar = nil
			end
			if Var.sons[son].timerUp then
				timer.cancel(Var.sons[son].timerUp)
				Var.sons[son].timerUp = nil
			end
			if Var.sons[son].Runtime then
				timer.cancel(Var.sons[son].Runtime)
				Var.sons[son].Runtime = nil
			end
			Var.sons[son]:removeSelf()
			Var.sons[son] = nil
		end
		Var.sons = {}
	end
	if(html ~= nil) then
		html:removeSelf()
		html=nil
	end
    if(Var.imagens ~= nil) then
        for ims=1, #Var.imagens do
			if Var.imagens[ims].MenuRapido then
				Var.imagens[ims].MenuRapido:removeSelf()
				Var.imagens[ims].MenuRapido = nil
			end
            Var.imagens[ims]:removeSelf()
        end
        Var.imagens = {}
    end
	if(Var.botoes ~= nil) then
		for bot=1, #Var.botoes do
            Var.botoes[bot]:removeSelf()
        end 
        Var.botoes={}
    end
	if(Var.textos ~= nil) then
        for txt=1, #Var.textos do
			if Var.textos[txt].botaoDeAumentar then
				Var.textos[txt].botaoDeAumentar:removeSelf()
				Var.textos[txt].botaoDeAumentar = nil
				jacliquei = false
			end
            Var.textos[txt]:removeSelf()
        end
		
        Var.textos = {}
    end
	if(Var.eXercicios ~= nil) then
		for exes=1, #Var.eXercicios do
			for exe=1, #Var.eXercicios[exes][1] do
				Var.eXercicios[exes][1][exe]:removeSelf()
				Var.eXercicios[exes][1][exe] = nil
			end
			if Var.eXercicios[exes].timer then
				timer.cancel(Var.eXercicios[exes].timer)
				Var.eXercicios[exes].timer = nil
			end
			Var.eXercicios[exes][1] = {}
			Var.eXercicios[exes][2]:removeSelf()
			Var.eXercicios[exes][3]:removeSelf()
			Var.eXercicios[exes][4]:removeSelf()
			Var.eXercicios[exes][5]:removeSelf()
			Var.eXercicios[exes][6]:removeSelf()
			Var.eXercicios[exes] = {}
			Var.eXercicios[exes] = nil	
		end
		Var.eXercicios = {}	
	end
	if(Var.videos ~= nil) then
		for vid=1, #Var.videos do
			if Var.videos[vid].tipo == "incorporado"--[[ or Var.video.tipo == "local"]]then
				if Var.videos[vid].timer then
					timer.cancel(Var.videos[vid].timer)
					Var.videos[vid].timer = nil
				end
				Var.videos[vid]:removeSelf()
				Var.videos[vid] = nil
			else
				if Var.videos[vid].timer then
					timer.cancel(Var.videos[vid].timer)
					Var.videos[vid].timer = nil
				end
				if Var.videos[vid].timerVoltar then
					timer.cancel(Var.videos[vid].timerVoltar)
					Var.videos[vid].timerVoltar = nil
				end
				if Var.videos[vid].timerAvancar then
					timer.cancel(Var.videos[vid].timerAvancar)
					Var.videos[vid].timerAvancar = nil
				end
				if Var.videos[vid].runtimeYouTube then
					timer.cancel(Var.videos[vid].runtimeYouTube)
					Var.videos[vid].runtimeYouTube = nil
				end
				if Var.videos[vid].esconderVideo then
					Runtime:removeEventListener("orientation",Var.videos[vid].esconderVideo)
				end
				if Var.videos[vid].url then
				else
					Var.videos[vid]:removeSelf()
					Var.videos[vid] = nil
				end
			end
		end
		Var.videos = {}
	end
	if(Var.indiceManual ~= nil) then
		if Var.indiceManual.botao then
			Var.indiceManual.botao:removeSelf()
		end
        Var.indiceManual:removeSelf()
        Var.indiceManual=nil
    end
	if(Var.animacoes ~= nil) then
		
		for ani=1, #Var.animacoes do
			if Var.animacoes[ani].timer then
				for i=1,#Var.animacoes[ani].timer do
					timer.cancel(Var.animacoes[ani].timer[i])
					Var.animacoes[ani].timer[i] = nil
				end
			end
			if Var.animacoes[ani].timer2 then
				timer.cancel(Var.animacoes[ani].timer2)
				Var.animacoes[ani].timer2 = nil
			end
			if Var.animacoes[ani].som then
				audio.stop(Var.animacoes[ani].som)
				Var.animacoes[ani].som = nil
			end
			Var.animacoes[ani]:removeSelf()
			Var.animacoes[ani]=nil
		end
		Var.animacoes={}
	end
	if(Var.rodape ~= nil) then
		
		--for rod=1, #Var.rodape do
		--	Var.rodape[rod]:removeSelf()
		--	Var.rodape[rod]=nil
		--end
		Var.rodape:removeSelf()
		Var.rodape=nil
	end
	if Var.anotComInterface then
		if Var.anotComInterface then
			if Var.anotComInterface.timerTTS then
				timer.cancel(Var.anotComInterface.timerTTS)
				Var.anotComInterface.timerTTS = nil
			end
		end
		Var.anotComInterface:removeSelf()
		Var.anotComInterface=nil
		
		if Var.comentario and Var.comentario.telaProtetiva then
			Var.comentario.telaProtetiva:removeSelf()
			Var.comentario.telaProtetiva = nil
		end
		if Var.comentario and Var.comentario.MenuRapido then
			Var.comentario.MenuRapido:removeSelf()
			Var.comentario.MenuRapido = nil
		end
	end
	if Var.Impressao then
		Var.Impressao:removeSelf()
		Var.Impressao=nil
	end
	if Var.Relatorio then
		Var.Relatorio:removeSelf()
		Var.Relatorio=nil
	end
	if Var.Dicionario then
		Var.Dicionario:removeSelf()
		Var.Dicionario=nil
	end
	if Var.TTSDicionario then
		Var.TTSDicionario:removeSelf()
		Var.TTSDicionario=nil
	end
	LimparTemporaryDirectory()
end
-- criarCursoAux Início --
varGlobal.exercicioAberto = auxFuncs.loadTable("exerciciosAbertos.json")


function criarCursoAux(telas, pagina)
	telas.idLivro = varGlobal.idLivro1
	varGlobal.limiteTela = 0
	os.remove(system.pathForFile("rodape.txt",system.DocumentsDirectory))
	os.remove(system.pathForFile("dicionario.txt",system.DocumentsDirectory))
	audio.setVolume( 1 )
	paginaAtual = pagina
	
	local Func = {}
	
	local paginaHistorico = auxFuncs.contagemDaPaginaHistorico(
		{
			pagina_livro = pagina,
			contagemInicialPaginas = varGlobal.contagemInicialPaginas,
			PaginasPre= varGlobal.numeroTotal.PaginasPre,
			Indices = varGlobal.numeroTotal.Indices,
			paginasAntesZero = telas.numeroTotal.paginasAntesZero
		}
	)
	telas.contagemDaPaginaHistorico = paginaHistorico
	telas.nPaginasPre = varGlobal.numeroTotal.PaginasPre
	telas.nIndices = varGlobal.numeroTotal.Indices
	telas.nContagemInicialPaginas = varGlobal.contagemInicialPaginas
	telas.vetorRodapes = varGlobal.vetorRodapes
	telas.nPaginasAntesDoZero = telas.numeroTotal.paginasAntesZero
	telas.vetorDic = varGlobal.vetorDic

	-- FALAR PÁGINA ATUAL --
	function Func.forAuxiliar(i,limite,palavra)
		local char = string.sub(palavra,i,i)
		print(Func.paginaReal,char)
		local som = audio.loadSound(char..".mp3")
		local duracaoAudio = audio.getDuration( som  )
		local MAXIMA = duracaoAudio-900
		local function onComplete(e)
			Func.rodarLoopFor(i+1,limite,palavra)
		end
		local options =
		{
			duration = MAXIMA,
			onComplete = onComplete
		}
		audio.seek( 110, som )
		
		audio.play(som,options)
	end
	function Func.forAuxiliar2(i,limite,palavra)
		local char = string.sub(palavra,i,i)
		print(Func.paginaReal,char)
		local som = audio.loadSound(char..".mp3")
		local duracaoAudio = audio.getDuration( som  )
		local MAXIMA = duracaoAudio-900
		local function onComplete(e)
			Func.rodarLoopFor2(i+1,limite,palavra)
		end
		local options =
		{
			duration = MAXIMA,
			onComplete = onComplete
		}
		audio.seek( 110, som )
		
		audio.play(som,options)
	end
	function Func.rodarLoopFor2(i,limite,palavra)
		if i<=limite then
			Func.forAuxiliar2(i,limite,palavra)
		end
	end
	function Func.rodarLoopFor(i,limite,palavra)
		if i<=limite then
			print(i,limite,palavra)
			Func.forAuxiliar(i,limite,palavra)
		else
			if type(paginaAtual) == "string" then
				local vetor = {}
				print(paginaAtual)
				vetor[1],vetor[2],vetor[3] = string.match(paginaAtual,"_Pagina(%d+).*(%d+).*(%d+)")
				local somAlternativa = audio.loadSound('audioTTS_alternativa.mp3')
				local function rodarSom(e)
					if e.completed == true then
						Func.rodarLoopFor2(1,string.len(vetor[3]),vetor[3])
					end
				end
				audio.play(somAlternativa,{onComplete = rodarSom})
			end
		end
	end
	local function onCompleteSomPagina(e)
		if e.completed == true then
			
			if type(pagina) == "number" then
				Func.paginaReal = pagina + varGlobal.contagemInicialPaginas -telas.numeroTotal.PaginasPre-telas.numeroTotal.Indices -1
				print(Func.paginaReal)
				Func.paginaReal = auxFuncs.verificarNumeroPaginaRomanosHistorico(Func.paginaReal,telas.numeroTotal.paginasAntesZero)
				
				Func.rodarLoopFor(1,string.len(Func.paginaReal),Func.paginaReal)
			else
				if not string.find(paginaHistorico,"xer") then
					Func.rodarLoopFor(1,string.len(paginaHistorico[1]),paginaHistorico[1])
				end
			end
		end
	end
	local function aoCompleterFLIP(e)
		if e.completed == true and varGlobal.preferenciasGerais.ajudaTTS and varGlobal.preferenciasGerais.ajudaTTS == "sim" then
			local somPagina = audio.loadSound("audioTTS_pagina.mp3")
			audio.play(somPagina,{onComplete = onCompleteSomPagina})
		end
	end
	timer.performWithDelay(16,function() audio.play(somFlip,{onComplete = aoCompleterFLIP}) end,1)
	-- FALAR PÁGINA ATUAL FIM --
	
	
	GRUPOGERAL.orientacaoAtual = system.orientation
	varGlobal.NumeroExerciciosControlador = 1
	Var.proximoY = 100
	GRUPOGERAL.girarImediato = false
	print("pagina",pagina)
	print("telas.numeroTotal.PaginasPre",telas.numeroTotal.PaginasPre)
	if telas then
		print(telas.numeroTotal.PaginasPre,telas.numeroTotal.Indices)
	end
	--if pagina
	print("WARNING: PÁGINA -> ",pagina)
	varGlobal.enderecoArquivos = "Paginas/Outros Arquivos"
	local enderecoArquivos = "Paginas/Outros Arquivos"
	if not telas[pagina] then -- tem que ver porque está perdendo o vetor anterior para depois podermos guardar as informações modificadas
		if string.find(pagina,"PagExerc") then -- é exercício
			if telas.arquivos[pagina] then
				if string.find(pagina,"PaginasPre_PagExerc") then
					print("PaginasPre",telas.arquivos[pagina],pagina)
					varGlobal.enderecoArquivos = "PaginasPre/Outros Arquivos"
					enderecoArquivos = "PaginasPre/Outros Arquivos"
				elseif string.find(pagina,"Paginas_PagExerc") then
					print("Paginas",telas.arquivos[pagina],pagina)
					varGlobal.enderecoArquivos = "Paginas/Outros Arquivos"
					enderecoArquivos = "Paginas/Outros Arquivos"
				end
				--auxFuncs.overwriteTable(VetorDeVetorTTS,"VetorTTS.json")
				if varGlobal.tipoSistema == "PC" then
					tablesave(VetorDeVetorTTS,system.pathForFile("VetorTTS.json",system.DocumentsDirectory))
				end
			else
				local aux = tableload(system.pathForFile("VetorTTS.json",system.DocumentsDirectory))
				if aux then
					VetorDeVetorTTS = aux
				end
				if telas[pagina].vetorTTS then
					print("tem isso aqui")
					VetorDeVetorTTS = telas[pagina].vetorTTS
				end
			end
		elseif pagina >= 1 and pagina <= telas.numeroTotal.PaginasPre then
			local nomeArquivo = tirarAExtencao(telas.arquivos[pagina])
			telas[pagina] = {}
			telas[pagina] = ead.criarTeladeArquivo({pasta = "PaginasPre",arquivo = telas.arquivos[pagina],TTSTipo = varGlobal.TTSTipo},telas,{},pagina,nomeArquivo)
			varGlobal.enderecoArquivos = "PaginasPre/Outros Arquivos"
			enderecoArquivos = "PaginasPre/Outros Arquivos"
			--auxFuncs.overwriteTable(VetorDeVetorTTS,"VetorTTS.json")
			if varGlobal.tipoSistema == "PC" then
				tablesave(VetorDeVetorTTS,system.pathForFile("VetorTTS.json",system.DocumentsDirectory))
			end
		elseif pagina >= telas.numeroTotal.PaginasPre+1 and pagina <=  telas.numeroTotal.PaginasPre+telas.numeroTotal.Indices then
			telas[pagina] = funcGlobal.criarIndicesDeArquivoConfig({pasta = "Indices",arquivo = "config indices.txt",pagina = pagina,TTSTipo = varGlobal.TTSTipo,paginaAtual = paginaAtual},telas,listaDeErros,VetorDeVetorTTS)
			varGlobal.enderecoArquivos = "Indices/Outros Arquivos"
			enderecoArquivos = "Indices/Outros Arquivos"
			--auxFuncs.overwriteTable(VetorDeVetorTTS,"VetorTTS.json")
			if varGlobal.tipoSistema == "PC" then
				tablesave(VetorDeVetorTTS,system.pathForFile("VetorTTS.json",system.DocumentsDirectory))
			end
		else
			if #telas.arquivos > 0 and telas.arquivos[pagina] then
				print(pagina)
				local nomeArquivo = tirarAExtencao(telas.arquivos[pagina])
				telas[pagina] = ead.criarTeladeArquivo({pasta = "Paginas",arquivo = telas.arquivos[pagina],TTSTipo = varGlobal.TTSTipo},telas,{},pagina,nomeArquivo)
				auxFuncs.overwriteTable(VetorDeVetorTTS,"VetorTTS2.json")
				if varGlobal.tipoSistema == "PC" then
					tablesave(VetorDeVetorTTS,system.pathForFile("VetorTTS.json",system.DocumentsDirectory))
				end
			end
		end
	elseif auxFuncs.fileExistsDoc("VetorTTS.json") then
		--VetorDeVetorTTS = auxFuncs.loadTable("VetorTTS.json")
		--print("WARNING: VETOOOOR!")
		if varGlobal.tipoSistema == "PC" then
			--print("WARNING: tentando ler")
			--print(VetorDeVetorTTS)
			local aux = tableload(system.pathForFile("VetorTTS.json",system.DocumentsDirectory))
			if aux then
				VetorDeVetorTTS = aux
			end
			if telas[pagina].vetorTTS then
				--print("tem isso aqui")
				VetorDeVetorTTS = telas[pagina].vetorTTS
			end
			if varGlobal.enderecoArquivos then
				enderecoArquivos = varGlobal.enderecoArquivos
			end
			--print(VetorDeVetorTTS[paginaAtual].numero)
			--print(VetorDeVetorTTS[paginaAtual][3])
			--print(VetorDeVetorTTS[paginaAtual]["3"])
			--print("VetorDeVetorTTS = ",VetorDeVetorTTS)
		end
	end
	if enderecoArquivos and telas[pagina] then
		telas.pastaArquivosAtual = enderecoArquivos
		telas[pagina].pastaArquivosAtual = enderecoArquivos
	elseif telas[pagina] then
		telas.pastaArquivosAtual = "Paginas/Outros Arquivos"
		telas[pagina].pastaArquivosAtual = "Paginas/Outros Arquivos"
	end
	if string.find(pagina,"PagExerc") then
		varGlobal.paginaComMenu = false
	else
		varGlobal.paginaComMenu = true
	end

	if grupoAguarde.telaPreta then
		grupoAguarde.telaPreta:removeSelf()
		grupoAguarde.texto:removeSelf()
		grupoAguarde.telaPreta = nil
		grupoAguarde.texto = nil
	end
	
	
	
	-- Pagina Salva e Pagina Voltar --
	--if pagina < 99999 then
		
	if type(pagina) == "string" and varGlobal.tipoSistema2 == "simulator" then
		-- não salvar a página
	else
		createFilePagina(pagina)
	end
	
	
	if telas.paginasParaVoltar then
		vetorVoltar = telas.paginasParaVoltar
		telas.paginasParaVoltar = nil
	else
		--if pagina < 99999 then
	
			table.insert(vetorVoltar,pagina)
		--end
	end
	local textoAux = ""
	for i=1,#vetorVoltar do 
		textoAux = textoAux..vetorVoltar[i].."\n"
	end

	if aumentouOSom == false then
		audio.stop()
		media.stopSound()
		--if pagina < 99999 then
			createFilePaginaVoltar(textoAux)
		--end
	end
	

	VetorTTS = {}
	TelasMenuGeral = telas
	textoTTS = varGlobal.textoPadRaO
	clicouBOTAOtts = false
	if timerClicouVoltar then
		timer.cancel(timerClicouVoltar)
		timerClicouVoltar = nil
	end
	if timerClicouAvancar then
		timer.cancel(timerClicouAvancar)
		timerClicouAvancar = nil
	end
	clicouAvancar = false
	clicouVoltar = false
	
	if aumentouOSom == false then
		varGlobal.VetorBotoesBarra.numeroSprite.isVisible = false
		varGlobal.VetorBotoesBarra.retangulo.isVisible = false
		if botaoPause then
			botaoPause.isVisible = false
			botaoBackward.isVisible = false
			botaoForward.isVisible = false
			botaoReiniciar.isVisible = false
			botaoplayTTS.isVisible = false
		end
		tableParagrafosFinais = {}
		nomesArquivosParagrafos = {}
		controladorParagrafos = 1
		controladorSons = 1
	end
	
	aumentouOSom = false
	
	local removeuOZoom = GRUPOGERAL:removeEventListener("touch",ZOOMZOOMZOOM)
	Runtime:removeEventListener("orientation",function() girarTelaOrientacao() end)
    local i = pagina;	
	
	indicePaginas = {}
	varGlobal.limiteTela = 0
	print("TELA: "..i)

	
	--thales0
	if GRUPOGERAL.grupoZoom then
		GRUPOGERAL.grupoZoom:removeSelf()
	end
	
	---------------------------------------------------------------------
	-- HISTÓRICO --------------------------------------------------------
	varGlobal.PagH = 0
	
	local function contagemDaPaginaHistoricoLocal()
		local pagina = vetorVoltar[#vetorVoltar] + varGlobal.contagemInicialPaginas -varGlobal.numeroTotal.PaginasPre-varGlobal.numeroTotal.Indices -1
		return pagina
	end

	varGlobal.PagH = paginaHistorico

	varGlobal.HistoricoSuspendeuLivro = "Página "..varGlobal.PagH.."|||Ação Genérica Livro|||Suspendeu o livro|"
	varGlobal.HistoricoImagemAbriuLink = "Página "..varGlobal.PagH.."|||Imagem|||Link aberto: "
	varGlobal.HistoricoImagemFechouLink = "Página "..varGlobal.PagH.."|||Imagem|||Link fechado: "
	varGlobal.HistoricoZoomEfetuado = "Página "..varGlobal.PagH.."|||Imagem|||Zoom efetuado|Arquivo: "
	varGlobal.HistoricoZoomRemovido = "Página "..varGlobal.PagH.."|||Imagem|||Zoom removido|Arquivo: "
	varGlobal.HistoricoPassarPagina = "Página "..varGlobal.PagH.."|||Ação Genérica Livro|||Acessou a página"
	varGlobal.HistoricoRodouSom = "Página "..varGlobal.PagH.."|||Audio|||Executou audio|Arquivo: "
	varGlobal.HistoricoDetalhesSom = "Página "..varGlobal.PagH.."|||Audio|||Abriu detalhes audio|Número: "
	varGlobal.HistoricoDetalhesSomFechar = "Página "..varGlobal.PagH.."|||Audio|||Fechou detalhes audio|Número: "
	varGlobal.HistoricoInterrompeuSom1 = "Página "..varGlobal.PagH.."|||Audio|||Interrompeu audio|Tempo:"
	varGlobal.HistoricoInterrompeuSom2 = "|Arquivo: "
	varGlobal.HistoricoDespausouSom1 = "Página "..varGlobal.PagH.."|||Audio|||Despausou audio|Tempo:"
	varGlobal.HistoricoDespausouSom2 = "|Arquivo: "
	varGlobal.HistoricoAcabouSom = "Página "..varGlobal.PagH.."|||Audio|||Terminou audio|Arquivo: "
	varGlobal.HistoricoPausouSom1 = "Página "..varGlobal.PagH.."|||Audio|||Pausou audio|Tempo:"
	varGlobal.HistoricoPausouSom2 = "|Arquivo: "
	varGlobal.HistoricoAvancouSom1 = "Página "..varGlobal.PagH.."|||Audio|||Avançou audio|Tempo:"
	varGlobal.HistoricoAvancouSom2 = "|Arquivo: "
	varGlobal.HistoricoVoltouSom1 = "Página "..varGlobal.PagH.."|||Audio|||Retrocedeu audio|Tempo:"
	varGlobal.HistoricoVoltouSom2 = "|Arquivo: "
	varGlobal.HistoricoBotaoPagina = "Página "..varGlobal.PagH.."|||Botão|||Ir para|Clicou no botão, ir para a página: "
	varGlobal.HistoricoBotaoSom = "Página "..varGlobal.PagH.."|||Botão|||som|Clicou no botão, tocar som|Botao "
	varGlobal.HistoricoBotaoSomFechou = "Página "..varGlobal.PagH.."|||Botão|||som|Terminou o som|Botao "
	varGlobal.HistoricoBotaoSomCancelou = "Página "..varGlobal.PagH.."|||Botão|||som|Cancelou o som|Botao "
	varGlobal.HistoricoBotaoSomPausou = "Página "..varGlobal.PagH.."|||Botão|||som|Pausou o som|Botao "
	varGlobal.HistoricoBotaoSomDespausou = "Página "..varGlobal.PagH.."|||Botão|||som|Despausou o som|Botao "
	varGlobal.HistoricoBotaoSomAutomatico = "Página "..varGlobal.PagH.."|||Botão|||som|Começou som automático da página|Botao "
	varGlobal.HistoricoBotaoVideo = "Página "..varGlobal.PagH.."|||Botão|||video|Clicou no botão, Executar video|Botao "
	varGlobal.HistoricoBotaoVideoFechou = "Página "..varGlobal.PagH.."|||Botão|||video|Terminou o video|Botao "
	varGlobal.HistoricoBotaoVideoCancelou = "Página "..varGlobal.PagH.."|||Botão|||video|Cancelou o video|Botao "
	varGlobal.HistoricoBotaoTexto = "Página "..varGlobal.PagH.."|||Botão|||texto|Clicou no botão, Abrir Texto|Botao "
	varGlobal.HistoricoBotaoTextoFechou = "Página "..varGlobal.PagH.."|||Botão|||texto|Encerrou o texto|Botao "
	varGlobal.HistoricoBotaoImagem = "Página "..varGlobal.PagH.."|||Botão|||imagem|Clicou no botão, Abrir Imagem|Botao "
	varGlobal.HistoricoBotaoImagemFechou = "Página "..varGlobal.PagH.."|||Botão|||imagem|Encerrou a imagem|Botao "
	varGlobal.HistoricoRodarAnimacao = "Página "..varGlobal.PagH.."|||Animação|||Executou animação "
	varGlobal.HistoricoTerminarAnimacao = "Página "..varGlobal.PagH.."|||Animação|||Terminou animação "
	varGlobal.HistoricoAbrirQuestao = "Página "..varGlobal.PagH.."|||Questão|||Abriu a questão "
	varGlobal.HistoricoFecharQuestao = "Página "..varGlobal.PagH.."|||Questão|||Fechou a questão "
	varGlobal.HistoricoVerificarQuestao = "Página "..varGlobal.PagH.."|||Questão|||Verificou a questão "
	varGlobal.HistoricoDesmarcarQuestao = "Página "..varGlobal.PagH.."|||Questão|||Desmarcou a questão "
	varGlobal.HistoricoMarcarQuestao = "Página "..varGlobal.PagH.."|||Questão|||Escolheu a questão " 
	varGlobal.HistoricoCriarAnotacao = "Página "..varGlobal.PagH.."|||Anotação|||Foi criada uma anotação "
	varGlobal.HistoricoExcluirAnotacao = "Página "..varGlobal.PagH.."|||Anotação|||Foi excluida uma anotação "
	varGlobal.HistoricoCriarComentario = "Página "..varGlobal.PagH.."|||Comentario|||Foi criado um comentário "
	varGlobal.HistoricoExcluirComentario = "Página "..varGlobal.PagH.."|||Comentario|||Foi excluído um comentário "
	varGlobal.HistoricoVoltarParaQuestao = "Página "..varGlobal.PagH.."|||Questão|||Clicou no botão voltar"
	varGlobal.HistoricoVideoNativoAbrir = "Página "..varGlobal.PagH.."|||Video|||Abriu o video|Player Nativo|Arquivo: "
	varGlobal.HistoricoVideoNativoCancelar = "Página "..varGlobal.PagH.."|||Video|||Interrompeu o video|Player Nativo|Arquivo: "
	varGlobal.HistoricoVideoNativoTerminar = "Página "..varGlobal.PagH.."|||Video|||Terminou o video|Player Nativo|Arquivo: "
	varGlobal.HistoricoVideoNormalDetalhes = "Página "..varGlobal.PagH.."|||Video|||Abriu detalhes video|Número: "
	varGlobal.HistoricoVideoNormalDetalhesFechar = "Página "..varGlobal.PagH.."|||Video|||Fechou detalhes video|Número: "
	varGlobal.HistoricoVideoNormalTerminar = "Página "..varGlobal.PagH.."|||Video|||Terminou o video|Player Interno|Arquivo: "
	varGlobal.HistoricoVideoNormalExecutar = "Página "..varGlobal.PagH.."|||Video|||Executou o video|Player Interno|Arquivo: "
	varGlobal.HistoricoVideoNormalCancelar = "Página "..varGlobal.PagH.."|||Video|||Interrompeu o video|Player Interno|Arquivo: "
	varGlobal.HistoricoVideoNormalPausar = "Página "..varGlobal.PagH.."|||Video|||Pausou o video|Player Interno|Arquivo: "
	varGlobal.HistoricoVideoNormalDespausar = "Página "..varGlobal.PagH.."|||Video|||Despausou o video|Player Interno|Arquivo: "
	varGlobal.HistoricoVideoNormalAvancar = "Página "..varGlobal.PagH.."|||Video|||Avançou o video|Player Interno|Arquivo: "
	varGlobal.HistoricoVideoNormalVoltar = "Página "..varGlobal.PagH.."|||Video|||Retrocedeu o video|Player Interno|Arquivo: "
	varGlobal.HistoricoVideoYoutubeRodar = "Página "..varGlobal.PagH.."|||Video|||Abriu Link do Youtube|Player Browser|Video "
	varGlobal.HistoricoVideoYoutube = "Página "..varGlobal.PagH.."|||Video|||Video Youtube |"
	varGlobal.HistoricoTextoAumentar = "Página "..varGlobal.PagH.."|||Texto|||Aumentou tamanho do texto da página"
	varGlobal.HistoricoTextoDiminuir = "Página "..varGlobal.PagH.."|||Texto|||Diminuiu tamanho do texto da página"
	varGlobal.HistoricoTextoAbriuLink = "Página "..varGlobal.PagH.."|||Texto|||Link aberto: "
	varGlobal.HistoricoTextoFechouLink = "Página "..varGlobal.PagH.."|||Texto|||Link fechado: "
	varGlobal.HistoricoTTSClicar1 = "Página "..varGlobal.PagH.."|||TTS|||Clicou uma vez no botão TTS"
	varGlobal.HistoricoTTSClicar2 = "Página "..varGlobal.PagH.."|||TTS|||Clicou duas vezes no botão TTS"
	varGlobal.HistoricoTTSPausar = "Página "..varGlobal.PagH.."|||TTS|||Pausou o áudio TTS"
	varGlobal.HistoricoTTSDespausar = "Página "..varGlobal.PagH.."|||TTS|||Despausou o áudio TTS"
	varGlobal.HistoricoTTSReiniciar = "Página "..varGlobal.PagH.."|||TTS|||Cancelou o áudio TTS da página"
	varGlobal.HistoricoTTSVoltar = "Página "..varGlobal.PagH.."|||TTS|||Retrocedeu o áudio TTS"
	varGlobal.HistoricoTTSAvancar = "Página "..varGlobal.PagH.."|||TTS|||Avançou o áudio TTS"
	varGlobal.HistoricoTTSExecutar = "Página "..varGlobal.PagH.."|||TTS|||Executou o áudio TTS"
	varGlobal.HistoricoTerminarAnimacaoTTS = "Página "..varGlobal.PagH.."|||TTS|||Terminou a animação "
	varGlobal.HistoricoPausarAnimacao = "Página "..varGlobal.PagH.."|||TTS|||Pausou a animação "
	varGlobal.HistoricoDespausarAnimacao = "Página "..varGlobal.PagH.."|||TTS|||Despausou a animação "
	varGlobal.MudouOrientacaoPortrait = "Página "..varGlobal.PagH.."|||Ação Genérica Livro|||Mudou para orientação Vertical"
	varGlobal.MudouOrientacaoLandscape = "Página "..varGlobal.PagH.."|||Ação Genérica Livro|||Mudou para orientação horizontal"
	

	local pagina_anterior = vetorVoltar[#vetorVoltar - 1]
	if type(pagina_anterior) == "number" then
		pagina_anterior = pagina_anterior + varGlobal.contagemInicialPaginas -varGlobal.numeroTotal.PaginasPre-varGlobal.numeroTotal.Indices -1
	end
	local paginaHistoricoAnterior = auxFuncs.contagemDaPaginaHistorico(
		{
			pagina_livro = vetorVoltar[#vetorVoltar - 1],
			contagemInicialPaginas = varGlobal.contagemInicialPaginas,
			PaginasPre= varGlobal.numeroTotal.PaginasPre,
			Indices = varGlobal.numeroTotal.Indices,
			paginasAntesZero = telas.numeroTotal.paginasAntesZero
		}
	)
	
	if #vetorVoltar>1 then
		if vetorVoltar[#vetorVoltar - 1] ~= pagina then

			local subPagina = GRUPOGERAL.subPagina
			historicoLib.Criar_e_salvar_vetor_historico({
				tipoInteracao = "generica",
				pagina_anterior = paginaHistoricoAnterior,
				pagina_livro = paginaHistorico,
				objeto_id = nil,
				tipo_orientacao = nil,
				acao = "passar pagina",
				subPagina = subPagina,
				tempo_aberto_pagina = auxFuncs.SecondsToClock(tonumber(varGlobal.tempoAbertoPaginaNumero))..".",
				tela = telas
			})
		end
	else

		local subPagina = GRUPOGERAL.subPagina
		historicoLib.Criar_e_salvar_vetor_historico({
			tipoInteracao = "generica",
			pagina_anterior = paginaHistoricoAnterior,
			pagina_livro = paginaHistorico,
			objeto_id = nil,
			tipo_orientacao = nil,
			acao = "passar pagina",
			subPagina = subPagina,
			tempo_aberto_pagina = auxFuncs.SecondsToClock(tonumber(varGlobal.tempoAbertoPaginaNumero))..".",
			tela = telas
		})
	end

	---------------------------------------------------------------------
	-- Remoção da página anterior ---------------------------------------
	Var.RemoverPaginaAnterior() -- !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
	---------------------------------------------------------------------
	Var.linguagem_MensagemTemp = varGlobal.linguagem_MensagemTemp
	Var.contagemDaPaginaHistorico = telas.contagemDaPaginaHistorico
	function funcGlobal.modificarLimiteTela(objeto)
		if objeto.tipo and objeto.tipo == "imgText" then
			--print(objeto.tipo)
			local aux = objeto.yy + objeto.height + 40
			if aux > varGlobal.limiteTela then
				varGlobal.limiteTela = aux
			end
			varGlobal.limiteTela = GRUPOGERAL.height
			if varGlobal.limiteTela <= 1280 then varGlobal.limiteTela = 1280 end
		elseif objeto.tamanho then
			--print(objeto.tamanho)
			local aux = objeto.tamanho
			if aux > varGlobal.limiteTela then
				varGlobal.limiteTela = aux
			end
			varGlobal.limiteTela = GRUPOGERAL.height
			if varGlobal.limiteTela <= 1280 then varGlobal.limiteTela = 1280 end
		else
			local Y = objeto.y
			if objeto.YY then
				Y = objeto.YY
			end
			--print(Y)
			local aux = Y + objeto.height + 40
			--print(aux)
			if aux > varGlobal.limiteTela then
				varGlobal.limiteTela = aux
			end
			varGlobal.limiteTela = varGlobal.limiteTela
			if varGlobal.limiteTela <= 1280 then varGlobal.limiteTela = 1280 end
		end
	end
	telas.temHistorico = varGlobal.temHistorico
	
	-- começo das adições --
	if telas[i] then
		telas[i].temHistorico = varGlobal.temHistorico
		telas[i].cont = {}
		telas[i].cont.imagemTextos = 1
		telas[i].cont.imagens = 1
		telas[i].cont.textos = 1
		telas[i].cont.animacoes = 1
		telas[i].cont.exercicios = 1
		telas[i].cont.botoes = 1
		telas[i].cont.espacos = 1
		telas[i].cont.separadores = 1
		telas[i].cont.videos = 1
		telas[i].cont.sons = 1
		telas[i].cont.rodape = 1
		telas[i].cont.fundo = 1
	end
	-- VERIFICAR SE PÁGINA ESTÁ BLOQUEADA
	local paginaBloqueada = false
	if varGlobal.paginasBloqueadas and varGlobal.paginasBloqueadas ~= {} and varGlobal.paginasBloqueadas[1] then
		for i=1,#varGlobal.paginasBloqueadas do
			if tostring(varGlobal.paginasBloqueadas[i][1]) == tostring(varGlobal.PagH) then
				paginaBloqueada = varGlobal.paginasBloqueadas[i]
				if auxFuncs.fileExistsDoc("senhaDesbloqueio.txt") then
					local senha = auxFuncs.lerTextoDoc("senhaDesbloqueio.txt")
					if tostring(varGlobal.paginasBloqueadas[i][2]) == tostring(senha) then
						paginaBloqueada = false
					end
				end
			end
		end
	end
	-- verificar se a página é uma alternativa
	if type(pagina) == "string" then
		-- criar botao voltar
		print("WARNING: ??",vetorVoltar[#vetorVoltar])
		local vetorBotoes = {}
		vetorBotoes.fundoUp = "fechar.png"
		vetorBotoes.fundoDown = "fecharD.png"
		vetorBotoes.acao = {"irPara"}
		if type(vetorVoltar[#vetorVoltar - 1]) == "string" then
			vetorVoltar[#vetorVoltar] = nil
		end
		vetorBotoes.numero = vetorVoltar[#vetorVoltar - 1] + varGlobal.contagemInicialPaginas -varGlobal.numeroTotal.PaginasPre-varGlobal.numeroTotal.Indices -1
		vetorBotoes.tamanho = 30
		vetorBotoes.altura = nil
		vetorBotoes.comprimento = nil
		vetorBotoes.titulo = {}
		vetorBotoes.titulo.texto = {" "}
		vetorBotoes.tipo = nil
		vetorBotoes.posicao = nil
		vetorBotoes.atributoALT = "Botão voltar"
		vetorBotoes.som = nil
		vetorBotoes.texto = nil
		vetorBotoes.video = nil
		vetorBotoes.imagem = nil
		vetorBotoes.x = W/2
		vetorBotoes.y = 140
		vetorBotoes.exercicioVoltar = true
		
		Var.botaoVoltarAlternativa = ead.colocarBotao(vetorBotoes,telas)
		Var.botaoVoltarAlternativa:scale(.6,.6)
	end
	-- FORMAR  A PÁGINA
	telas.pagina = pagina
	telas.vetorRodapes = varGlobal.vetorRodapes
	telas.vetorDic = varGlobal.vetorDic
	telas.paginaHistorico = paginaHistorico
	
	function telas.clearNativeScreenElements()
		auxFuncs.clearNativeScreenElements(Var)
	end
	function telas.restoreNativeScreenElements()
		auxFuncs.restoreNativeScreenElements(Var)
	end
	if not paginaBloqueada then
		if not telas[i] then telas[i] = {} end
		telas[i].pagina = pagina
		telas[i].contagemDaPaginaHistorico = telas.contagemDaPaginaHistorico
		--print("telas[i].pagina",telas[i].pagina)
		telas[i].dicionario = {}
		telas[i].dicionarioContexto = {}
		if not telas[i].YElementos then telas[i].YElementos = {} end
		if telas[i] ~= nil and telas[i].ordemElementos ~= nil then
			-- verificar rodape --
			telas.rodapeAux = nil
			for ord=1, #telas[i].ordemElementos do
				if telas[i] ~= nil then 
					if(telas[i].ordemElementos[ord] == "rodape") then
						telas.rodapeAux = telas[i].rodape[1]
						print("pegou aqui")
					end
				end
			end
			
			----------------------
			for ord=1, #telas[i].ordemElementos do
				telas.elementoAtual = ord
				if telas[i] ~= nil then
					telas[i].rodapeAux = telas.rodapeAux
					telas[i].YElementos[ord] = Var.proximoY
					print("Y do Elemento "..ord,telas[i].YElementos[ord])
					if(telas[i].ordemElementos[ord] == "fundo") then
						if not Var.fundo then Var.fundo = {} end
						local tamanhoH = display.actualContentHeight
						local tamanhoW = display.actualContentWidth
						local fd = telas[i].cont.fundo
						telas[i].fundo[fd].altura = tamanhoH
						telas[i].fundo[fd].largura = tamanhoW
						Var.fundo = elemTela.colocarFundo(telas[i].fundo[fd],telas)
						telas[i].cont.fundo = telas[i].cont.fundo + 1
						GRUPOPLANODEFUNDO:insert(Var.fundo)
					end
					if(telas[i].ordemElementos[ord] == "imagem") then
						if not Var.imagens then Var.imagens = {} end
						local ims = telas[i].cont.imagens
						
						if telas[i].imagens[ims].arquivo then
							print("IMAGEM EXISTE")
							--image:removeSelf()
							image = nil
							--Var.imagens[ims] = ead.colocarImagem(telas[i].imagens[ims],telas)
							Var.imagens[ims] = elemTela.colocarImagem(telas[i].imagens[ims],telas)
							Var.imagens[ims].conteudo = telas[i].imagens[ims].conteudo
							Var.imagens[ims].atributoALT = telas[i].imagens[ims].atributoALT
							Var.imagens[ims].y = Var.imagens[ims].y + Var.proximoY
							Var.imagens[ims].contImagem = ims
							Var.proximoY = Var.imagens[ims].y + (Var.imagens[ims].height*telas[i].imagens[ims].escala)
							--telas[i].YElementos[ord] = Var.imagens[ims].y
							local function ZoomImagem(e)
								if Var.video then
									Var.video.x = 1000
								end
								if Var.videos then
									for k=1,#Var.videos do
										Var.videos[k].x = 1000
									end
								end
								toqueHabilitado = false
								Var.imagens[ims].grupoZoom = display.newGroup()
								--print(e.target.zoom)
								local imagemoutra = telas[i].imagens[ims].arquivo
								Var.imagens[ims].grupoZoom.telaPreta = display.newRect(0,0,W*2,H*2)
								Var.imagens[ims].grupoZoom.telaPreta.anchorX = 0.5; Var.imagens[ims].grupoZoom.telaPreta.anchorY = 0.5
								Var.imagens[ims].grupoZoom.telaPreta.x = W/2; Var.imagens[ims].grupoZoom.telaPreta.y = H/2
								Var.imagens[ims].grupoZoom.telaPreta:setFillColor(1,1,1)
								Var.imagens[ims].grupoZoom.telaPreta.alpha=1
								Var.imagens[ims].grupoZoom.imgFunc = display.newImage(imagemoutra,W/2,H/2)
								Var.imagens[ims].grupoZoom.imgFunc.anchorX = .5; Var.imagens[ims].grupoZoom.imgFunc.anchorY= .5
								Var.imagens[ims].grupoZoom.imgFunc.x=W/2;Var.imagens[ims].grupoZoom.imgFunc.y=H/2
								Var.imagens[ims].grupoZoom:insert(Var.imagens[ims].grupoZoom.telaPreta)
								Var.imagens[ims].grupoZoom:insert(Var.imagens[ims].grupoZoom.imgFunc)
								Var.imagens[ims]:removeEventListener("tap",ZoomImagem)
								local texto = display.newText("Zoom Ativado",1,1,native.systemFont,50)
								texto.anchorX = 1; texto.anchorY = 1
								texto.x = W; texto.y = H
								texto:setFillColor(0,1,0)
								if system.orientation ~= "portrait" then
									--telaPreta.xScale = varGlobal.aspectRatio
									--telaPreta.yScale = varGlobal.aspectRatio
									--telaPreta.x = telaPreta.x + 165
									--Var.imagens[ims].grupoZoom.imgFunc.x = Var.imagens[ims].grupoZoom.imgFunc.x + 170
									--texto.y = W/2 + 110
									--texto.x = W + 220
								end
								Var.imagens[ims].grupoZoom:insert(texto)
								local function rodarTelaZoom()
									if Var.imagens[ims] then
										girarTelaOrientacao(Var.imagens[ims].grupoZoom)
									end
								end
							
								function Var.imagens.mudarOrientation()
									if Var.imagens[ims] and Var.imagens[ims].grupoZoom then
										if system.orientation == "landscapeRight" then 
											--telaPreta.xScale = varGlobal.aspectRatio;telaPreta.yScale = varGlobal.aspectRatio;
											--telaPreta.x = telaPreta.x + 100
											--Var.imagens[ims].grupoZoom.telaPreta.x = H/2
											--Var.imagens[ims].grupoZoom.telaPreta.y = W/2
											--Var.imagens[ims].grupoZoom.telaPreta.width = H
											--Var.imagens[ims].grupoZoom.telaPreta.height = W
											--Var.imagens[ims].grupoZoom.xScale = varGlobal.aspectRatio;Var.imagens[ims].grupoZoom.yScale = varGlobal.aspectRatio;
											transition.to(Var.imagens[ims].grupoZoom.imgFunc,{time = 0,rotation = 90,x=W/2,y=H/2})
											transition.to(texto,{time = 0,rotation = 90,x=0,y=H})
											--Var.imagens[ims].grupoZoom.rotation = 90
											--Var.imagens[ims].grupoZoom.x = 0 + Var.imagens[ims].grupoZoom.height/2
											--Var.imagens[ims].grupoZoom.y = 0
											--texto.y = W/2 +250
											--texto.x = W + 100
											--texto.rotation = 90
											--Var.imagens[ims].grupoZoom.imgFunc.x=H/2- (Var.imagens[ims].grupoZoom.imgFunc.width/2);Var.imagens[ims].grupoZoom.imgFunc.y=W/2
										elseif system.orientation == "landscapeLeft" then 
											--telaPreta.xScale = varGlobal.aspectRatio;telaPreta.yScale = varGlobal.aspectRatio;
											--Var.imagens[ims].grupoZoom.xScale = varGlobal.aspectRatio;Var.imagens[ims].grupoZoom.yScale = varGlobal.aspectRatio;
											--Var.imagens[ims].grupoZoom.rotation = -90
											--Var.imagens[ims].grupoZoom.x = 0
											--Var.imagens[ims].grupoZoom.y = 0 + Var.imagens[ims].grupoZoom.width
											--texto.y = W/2 + 110
											--texto.x = W
											--Var.imagens[ims].grupoZoom.imgFunc.y=W/2 ;Var.imagens[ims].grupoZoom.imgFunc.x=H/2 - (Var.imagens[ims].grupoZoom.imgFunc.width*varGlobal.aspectRatio/2)
											transition.to(Var.imagens[ims].grupoZoom.imgFunc,{time = 0,rotation = -90,x=W/2,y=H/2})
											transition.to(texto,{time = 0,rotation = -90,x=W,y=0})
										else 
											--telaPreta.xScale = 1;telaPreta.yScale = 1; 
											--telaPreta.x = W/2; telaPreta.y = H/2; 
											--texto.x = W; texto.y = H
											--Var.imagens[ims].grupoZoom.xScale = 1;Var.imagens[ims].grupoZoom.yScale = 1;
											Var.imagens[ims].grupoZoom.imgFunc.rotation = 0
											--Var.imagens[ims].grupoZoom.x = 0
											--Var.imagens[ims].grupoZoom.y = 0
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
									Var.imagens[ims].grupoZoom:removeEventListener("tap",removerImgFunc)
									Var.imagens[ims].grupoZoom:removeSelf()
									Runtime:removeEventListener("orientation",rodarTelaZoom)
									Runtime:removeEventListener("orientation",Var.imagens.mudarOrientation)
									--Var.imagens[ims]:addEventListener("tap",ZoomImagem)
									toqueHabilitado = true
									print("\n\nremoveu Zoom\n\n")
									local date = os.date( "*t" )
									local data = date.day.."/"..date.month.."/"..date.year
									local hora = date.hour..":"..date.min..":"..date.sec
									local pH = funcGlobal.pegarNumeroPaginaRomanosHistorico(varGlobal.PagH)
									local vetorJson = {
										tipoInteracao = "imagem",
										pagina_livro = varGlobal.PagH,
										objeto_id = Var.imagens[ims].contImagem,
										acao = "desativar zoom",
										tempo_aberto = varGlobal.tempoAbertoZoomNumero,
										relatorio = data.."| Desativou o zoom da imagem nº "..Var.imagens[ims].contImagem .." da página ".. pH .." às ".. hora .. " depois de analizar a imagem por "..auxFuncs.SecondsToClock(varGlobal.tempoAbertoZoomNumero).."."
									}
									if GRUPOGERAL.subPagina then
										vetorJson.subPagina = GRUPOGERAL.subPagina
									end
									funcGlobal.escreverNoHistorico(varGlobal.HistoricoZoomRemovido.."|Imagem "..telas[i].cont.imagens - 1,vetorJson)
									if varGlobal.tempoAbertoZoom then
										timer.cancel(varGlobal.tempoAbertoZoom)
									end
									varGlobal.tempoAbertoZoomNumero = 0
									restoreNativeScreenElements()
									return true
								end
								print("\n\ncriou Zoom\n\n")
								Var.imagens[ims].grupoZoom.imgFunc.prevX=Var.imagens[ims].grupoZoom.imgFunc.x
								Var.imagens[ims].grupoZoom.imgFunc.prevY=Var.imagens[ims].grupoZoom.imgFunc.y
								Var.imagens[ims].grupoZoom.imgFunc.anchorChildren = true
							
								Var.imagens[ims].grupoZoom:addEventListener("touch",function() return true; end)
								Var.imagens[ims].grupoZoom:addEventListener("tap",removerImgFunc)
								
								--imgFunc:addEventListener("touch",ZOOMZOOMZOOM)
								local date = os.date( "*t" )
								local data = date.day.."/"..date.month.."/"..date.year
								local hora = date.hour..":"..date.min..":"..date.sec
								local pH = funcGlobal.pegarNumeroPaginaRomanosHistorico(varGlobal.PagH)
								local vetorJson = {
									tipoInteracao = "imagem",
									pagina_livro = varGlobal.PagH,
									objeto_id = Var.imagens[ims].contImagem,
									acao = "ativar zoom",
									relatorio = data.."| Ativou o zoom da imagem nº "..Var.imagens[ims].contImagem .." da página ".. pH .." às ".. hora .. "."
								}
								if GRUPOGERAL.subPagina then
									vetorJson.subPagina = GRUPOGERAL.subPagina
								end
								funcGlobal.escreverNoHistorico(varGlobal.HistoricoZoomEfetuado.."|Imagem "..telas[i].cont.imagens - 1,vetorJson)
								Var.imagens[ims].grupoZoom:addEventListener("touch",ZOOMZOOMZOOM2)
								if varGlobal.tempoAbertoZoom then
									timer.cancel(varGlobal.tempoAbertoZoom)
								end
								varGlobal.tempoAbertoZoomNumero = 0
								varGlobal.tempoAbertoZoom = timer.performWithDelay(100,function() varGlobal.tempoAbertoZoomNumero = varGlobal.tempoAbertoZoomNumero + 100 end,-1)
								clearNativeScreenElements()
								GRUPOGERAL.grupoZoom = Var.imagens[ims].grupoZoom
								return true
							end
						
							local function abrirMenuRapido(event)
								Var.imagens[ims]:removeEventListener("tap",abrirMenuRapido)
								Var.imagens[ims].telaPreta = TelaProtetiva()
								Var.imagens[ims].telaPreta.alpha = .7
								--GRUPOGERAL:insert(Var.imagens[ims].telaPreta)
								
								local escolhas = {}
								escolhas[1] = ""
								local Imagem = event.target
								Imagem.tempoAbertoNumero = 0
								auxFuncs.overwriteTable( Imagem.url,"url.json")
								auxFuncs.overwriteTable( Imagem.urlembeded,"urlEmbeded.json")
								if Imagem.zoom == "sim" then table.insert(escolhas,"Dar Zoom") end
								if Imagem.url ~= nil and Imagem.url ~= {} then table.insert(escolhas,"abrir link" )end
								if Imagem.urlembeded ~= nil and Imagem.urlembeded ~= {} then table.insert(escolhas,"abrir link" )end
								if Imagem.conteudo ~= nil and Imagem.conteudo ~= "" then 
									table.insert(escolhas,"descrição" )
								end
								
							
							
								local function aoFecharMenuRapido()
									if Var.imagens[ims].MenuRapido then
										Var.imagens[ims].MenuRapido:removeSelf()
										Var.imagens[ims].MenuRapido = nil
									end
									if Var.imagens[ims].telaPreta then
										Var.imagens[ims].telaPreta:removeSelf()
										Var.imagens[ims].telaPreta = nil
									end
									if Var.imagens[ims].botaoFecharG then
										Var.imagens[ims].botaoFecharG:removeSelf()
										Var.imagens[ims].botaoFecharG = nil
									end
									Var.imagens[ims]:addEventListener("tap",abrirMenuRapido)
								end
								Var.imagens[ims].telaPreta:addEventListener("tap",function()aoFecharMenuRapido()end)
								
								local function rodarOpcao(e)
									if e.target.params.tipo == "Dar Zoom" then
										print("abriu o zoom: "..Imagem.zoom)
										elemTela.ZoomImagem(e,Var,telas[i],ims,GRUPOGERAL)
										
										--ZoomImagem(event)
									elseif e.target.params.tipo == "abrir link" then
										if Imagem.url and Imagem.url ~= {} then
											system.openURL(Imagem.url[1])
											local date = os.date( "*t" )
											local data = date.day.."/"..date.month.."/"..date.year
											local hora = date.hour..":"..date.min..":"..date.sec
											local pH = funcGlobal.pegarNumeroPaginaRomanosHistorico(varGlobal.PagH)
											local vetorJson = {
												tipoInteracao = "imagem",
												pagina_livro = varGlobal.PagH,
												objeto_id = Var.imagens[ims].contImagem,
												acao = "abrir link da imagem",
												link = Imagem.url[1],
												relatorio = data.."| Abriu o link da imagem n° "..Var.imagens[ims].contImagem .. " às "..hora.." na página "..pH .. ". O link aberto foi: "..Imagem.url[1]
											}
											if GRUPOGERAL.subPagina then
												vetorJson.subPagina = GRUPOGERAL.subPagina
											end
											funcGlobal.escreverNoHistorico(varGlobal.HistoricoImagemAbriuLink..Imagem.url[1].."|Imagem "..telas[i].cont.imagens - 1,vetorJson)
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
												local pH = funcGlobal.pegarNumeroPaginaRomanosHistorico(varGlobal.PagH)
												local vetorJson = {
													tipoInteracao = "imagem",
													pagina_livro = varGlobal.PagH,
													objeto_id = Var.imagens[ims].contImagem,
													acao = "fechar link da imagem",
													link = Imagem.urlembeded[1],
													tempo_aberto = Imagem.tempoAbertoNumero,
													relatorio = data.."| Fechou o link Embeded da imagem n° "..Var.imagens[ims].contImagem .. " às "..hora.." na página "..pH .."após vizualizá-lo por ".. Imagem.tempoAbertoNumero .. ". O link aberto foi: "..Imagem.urlembeded[1]
												}
												if GRUPOGERAL.subPagina then
													vetorJson.subPagina = GRUPOGERAL.subPagina
												end
												funcGlobal.escreverNoHistorico(varGlobal.HistoricoImagemFechouLink..Imagem.urlembeded[1].."|Imagem "..telas[i].cont.imagens - 1,vetorJson)
												if Imagem.tempoAberto then
													timer.cancel(Imagem.tempoAberto)
													Imagem.tempoAberto = nil
												end
												Imagem.tempoAbertoNumero = 0
												restoreNativeScreenElements()
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
											local date = os.date( "*t" )
											local data = date.day.."/"..date.month.."/"..date.year
											local hora = date.hour..":"..date.min..":"..date.sec
											local pH = funcGlobal.pegarNumeroPaginaRomanosHistorico(varGlobal.PagH)
											local vetorJson = {
												tipoInteracao = "imagem",
												pagina_livro = varGlobal.PagH,
												objeto_id = Var.imagens[ims].contImagem,
												acao = "abrir link da imagem",
												link = Imagem.urlembeded[1],
												relatorio = data.."| Abriu o link Embeded da imagem n° "..Var.imagens[ims].contImagem .. " às "..hora.." na página "..pH..". O link aberto foi: "..Imagem.urlembeded[1]
											}
											if GRUPOGERAL.subPagina then
												vetorJson.subPagina = GRUPOGERAL.subPagina
											end
											funcGlobal.escreverNoHistorico(varGlobal.HistoricoImagemAbriuLink..Imagem.urlembeded[1].."|Imagem "..telas[i].cont.imagens - 1,vetorJson)
											clearNativeScreenElements()
										end
									elseif e.target.params.tipo == "descrição" then
										local atributos = {}
										atributos.modificar = 0
										atributos.conteudo = Var.imagens[ims].conteudo
										atributos.tipoInteracao = "imagem"
										timer.performWithDelay(15,function()funcGlobal.criarDescricao(atributos,true,telas[i].cont.imagens-1); end,1)
									elseif e.target.params.tipo == "fechar menu" then
										print("cancelou zoom")
									end
									aoFecharMenuRapido()
								end
								local escolhasGerais = {}
								for i=1,#escolhas do

									table.insert(escolhasGerais,
									{
										listener = rodarOpcao,
										tamanho = 50,
										texto = escolhas[i],
										cor = {.9,.9,.9},
										params = {tipo = escolhas[i]},
										cor = {37/225,185/225,219/225},
									})
									if escolhas[i] == "Dar Zoom" then
										escolhasGerais[#escolhasGerais].iconeEsq =  {imagem = "botaozoom.png",alt = 70,larg = 70}
									elseif escolhas[i] == "abrir link" then
										escolhasGerais[#escolhasGerais].iconeEsq =  {imagem = "botaourl.png"}
									elseif escolhas[i] == "descrição" then
										escolhasGerais[#escolhasGerais].iconeEsq =  {imagem = "detalhes.png",alt = 70,larg = 70}
									elseif escolhas[i] == "" then
										escolhasGerais[#escolhasGerais].iconeDir =  {imagem = "closeMenuButton2.png",alt = 50,larg = 50}
									else
										escolhasGerais[#escolhasGerais].fonte = "Fontes/paolaAccent.ttf"
									end
								end
								Var.imagens[ims].MenuRapido = MenuRapido.New(
									{
									escolhas = escolhasGerais,
									rowWidthGeneric = 250,
									rowHeightGeneric = 70,
									tamanhoTexto = 50,
									closeListener = aoFecharMenuRapido,
									telaProtetiva = "nao"
									}
								)
								--GRUPOGERAL:insert(Var.imagens[ims].MenuRapido)
								--Var.imagens[ims].MenuRapido.x = event.x
								--Var.imagens[ims].MenuRapido.y = event.y - GRUPOGERAL.y
								Var.imagens[ims].MenuRapido.x = event.x
								Var.imagens[ims].MenuRapido.y = event.y
								Var.imagens[ims].MenuRapido.anchorY=1
								if Var.imagens[ims].MenuRapido.y + Var.imagens[ims].MenuRapido.height > H then
									Var.imagens[ims].MenuRapido.y = Var.imagens[ims].MenuRapido.y - Var.imagens[ims].MenuRapido.height
								end
								if Var.imagens[ims].MenuRapido.x + Var.imagens[ims].MenuRapido.width > W and system.orientation == "portrait" then
									Var.imagens[ims].MenuRapido.x = event.x - Var.imagens[ims].MenuRapido.width
								end
								--[[if Var.imagens[ims].MenuRapido.y + Var.imagens[ims].MenuRapido.height > H and system.orientation == "portrait" then
									Var.imagens[ims].MenuRapido.y = event.y - Var.imagens[ims].MenuRapido.height - GRUPOGERAL.y
								end]]
								if system.orientation == "landscapeLeft" then
									Var.imagens[ims].MenuRapido.y = event.target.y + event.target.height/2
									Var.imagens[ims].MenuRapido.x = event.target.x
								elseif system.orientation == "landscapeRight" then
									Var.imagens[ims].MenuRapido.y = event.target.y + event.target.height/2
									Var.imagens[ims].MenuRapido.x = event.target.x
								end
							
							end
							print("escolhas = ",Var.imagens[ims].atributoALT)
							if Var.imagens[ims] then
								if Var.imagens[ims].zoom == "sim"or (Var.imagens[ims].url ~= nil and Var.imagens[ims].url ~= {} and Var.imagens[ims].url[1] ) or (Var.imagens[ims].urlembeded ~= nil and Var.imagens[ims].urlembeded ~= {} and Var.imagens[ims].urlembeded[1] ) or Var.imagens[ims].atributoALT ~= nil then
									print("THALES1",Var.imagens[ims],Var.imagens[ims].url)
									Var.imagens[ims]:addEventListener("tap",abrirMenuRapido)
								end
								GRUPOGERAL:insert(Var.imagens[ims])
								funcGlobal.modificarLimiteTela(Var.imagens[ims])
								--funcGlobal.modificarLimiteTela(Var.imagens[ims])
							end
						end      
						telas[i].cont.imagens =  telas[i].cont.imagens + 1
					end
					-- verifica se tem html viewer
					--[[if(telas[i].html) then
						html = ead.colocarHTML(telas[i].html)
						GRUPOGERAL:insert(html)
						funcGlobal.modificarLimiteTela(html)
					end]]
					--verifica se tem espaço
					if(telas[i].ordemElementos[ord] == "espaco") then
						if not Var.espacos then Var.espacos = {} end
						local esp = telas[i].cont.espacos
					
						Var.espacos[esp] = elemTela.colocarEspaco(telas[i].espacos[esp])
						telas[i].cont.espacos =  telas[i].cont.espacos + 1
						Var.espacos[esp].y = Var.espacos[esp].y + Var.proximoY
						--telas[i].YElementos[ord] = Var.espacos[esp].y
						Var.proximoY = Var.espacos[esp].y + Var.espacos[esp].height
						funcGlobal.modificarLimiteTela(Var.espacos[esp])
					end
					--verifica se tem separador
					if(telas[i].ordemElementos[ord] == "separador") then
						print("TEM SEPARADOR")
						if not Var.separadores then Var.separadores = {} end
						local sep = telas[i].cont.separadores
					
						Var.separadores[sep] = elemTela.colocarSeparador(telas[i].separadores[sep])
						telas[i].cont.separadores =  telas[i].cont.separadores + 1
						print("WARNING:Sep:",Var.separadores[sep].y)
						Var.separadores[sep].y = Var.separadores[sep].y + Var.proximoY
						--telas[i].YElementos[ord] = Var.separadores[sep].y
						Var.proximoY = Var.separadores[sep].y + Var.separadores[sep].height
						GRUPOGERAL:insert(Var.separadores[sep])
						funcGlobal.modificarLimiteTela(Var.separadores[sep])
					end
					--verifica se tem som
					if(telas[i].ordemElementos[ord] == "som") then
						if not Var.sons then Var.sons = {} end
						local son = telas[i].cont.sons
						Var.sons[son] = elemTela.colocarSom(telas[i].sons[son],telas)
						telas[i].cont.sons =  telas[i].cont.sons + 1
						Var.sons[son].y = Var.sons[son].y + Var.proximoY
						--telas[i].YElementos[ord] = Var.sons[son].y
						Var.proximoY = Var.sons[son].y + Var.sons[son].height
						GRUPOGERAL:insert(Var.sons[son])
						local aux = {}
						aux.y = Var.sons[son].y
						aux.height = Var.sons[son].height
						funcGlobal.modificarLimiteTela(aux)
					end
					--verifica se tem video
					if(telas[i].ordemElementos[ord] == "video") then
						if not Var.videos then Var.videos = {} end
						local vids = telas[i].cont.videos
						Var.videos[vids] = ead.colocarVideo(telas[i].videos[vids],telas)
						Var.videos[vids].contVideo = telas[i].cont.videos
						telas[i].cont.videos =  telas[i].cont.videos + 1
						Var.videos[vids].y = Var.videos[vids].y + Var.proximoY
						--telas[i].YElementos[ord] = Var.videos[vids].y
						Var.proximoY = Var.videos[vids].y + Var.videos[vids].videoH
						GRUPOGERAL:insert(Var.videos[vids])
						local videoLimite = {}
						videoLimite.y = Var.videos[vids].y
						videoLimite.height = Var.videos[vids].videoH
						funcGlobal.modificarLimiteTela(videoLimite)
					end

					if(telas[i].ordemElementos[ord] == "exercicio") then
						if not Var.eXercicios then Var.eXercicios = {} end
						local exes = telas[i].cont.exercicios

						Var.eXercicios[exes] = {}
						Var.eXercicios[exes][1] = {}
						Var.eXercicios[exes][1],Var.eXercicios[exes][2],Var.eXercicios[exes][3],Var.eXercicios[exes][4],Var.eXercicios[exes][5],Var.eXercicios[exes][6] = ead.criarExercicio(telas[i].exercicios[exes],telas)
						if telas[i].exercicios[exes].corretas and #telas[i].exercicios[exes].corretas > 1 then
								Var.eXercicios[exes][5].tipo = "multiplas"
							else
								Var.eXercicios[exes][5].tipo = "simples"
						end
						
						Var.eXercicios[exes][5].exe = exes
						Var.eXercicios[exes][5].contExerc = telas[i].cont.exercicios
						telas[i].cont.exercicios =  telas[i].cont.exercicios + 1
						GRUPOGERAL:insert(Var.eXercicios[exes][6])
						GRUPOGERAL:insert(Var.eXercicios[exes][5])
						GRUPOGERAL:insert(Var.eXercicios[exes][4])
						GRUPOGERAL:insert(Var.eXercicios[exes][2])
						GRUPOGERAL:insert(Var.eXercicios[exes][3])
					
						Var.eXercicios[exes][2].y = Var.eXercicios[exes][2].y + Var.proximoY
						Var.eXercicios[exes][3].y = Var.eXercicios[exes][3].y + Var.proximoY
						Var.eXercicios[exes][4].y = Var.eXercicios[exes][4].y + Var.proximoY
						Var.eXercicios[exes][5].y = Var.eXercicios[exes][5].y + Var.proximoY
						for exe=1,#Var.eXercicios[exes][1] do
							Var.eXercicios[exes][1][exe].y = Var.eXercicios[exes][1][exe].y + Var.proximoY
							GRUPOGERAL:insert(Var.eXercicios[exes][1][exe])
						end
						--telas[i].YElementos[ord] = Var.eXercicios[exes][2].y
						Var.proximoY = Var.eXercicios[exes][5].y + Var.eXercicios[exes][5].height
						print("EXERCICIO:",i,Var.proximoY,Var.eXercicios[exes][5].y)
						funcGlobal.modificarLimiteTela(Var.eXercicios[exes][3])

						Var.eXercicios[exes][5].abrirFecharExercicio = function(e)
							if not varGlobal.exercicioAberto then varGlobal.exercicioAberto = {} end
							if not varGlobal.exercicioAberto.pagina then varGlobal.exercicioAberto.pagina = {} end
							if not varGlobal.exercicioAberto.numero then varGlobal.exercicioAberto.numero = {} end
							if not varGlobal.exercicioAberto.exe then varGlobal.exercicioAberto.exe = {} end
							local multiplicador = 1
							local tempoInicio = system.getTimer()
							if Var.eXercicios[exes].abriu == true then
								for i=1,#varGlobal.exercicioAberto.pagina do
									if varGlobal.exercicioAberto.pagina[i] == pagina and varGlobal.exercicioAberto.numero[i] == e.target.contExerc then
										table.remove(varGlobal.exercicioAberto.pagina,i)
										table.remove(varGlobal.exercicioAberto.numero,i)
										table.remove(varGlobal.exercicioAberto.exe,i)
										auxFuncs.overwriteTable( varGlobal.exercicioAberto, "exerciciosAbertos.json" )
										Var.eXercicios[exes].nSalvarAbrir = true
									end
								end
								multiplicador = -1
								for i=1,#Var.eXercicios[exes][1] do
									Var.eXercicios[exes][1][i].isVisible = false
								end
								Var.eXercicios[exes][2].isVisible,Var.eXercicios[exes][3].isVisible,Var.eXercicios[exes][4].isVisible = false,false,false
								Var.eXercicios[exes].abriu = false
								if e.target.tempo == "ativado" then
									Var.eXercicios[exes][6].isVisible = false
									if Var.eXercicios[exes].timer then
										timer.cancel(Var.eXercicios[exes].timer)
										Var.eXercicios[exes].timer = nil
									end
								end
								local date = os.date( "*t" )
								local data = date.day.."/"..date.month.."/"..date.year
								local hora = date.hour..":"..date.min..":"..date.sec
								local numeroQ = ""
								if telas[i].exercicios[exes].numero then
									numeroQ = telas[i].exercicios[exes].numero.." "
								end
								local pH = funcGlobal.pegarNumeroPaginaRomanosHistorico(varGlobal.PagH)
								local vetorJson = {
									tipoInteracao = "questao",
									pagina_livro = varGlobal.PagH,
									objeto_id = telas[i].cont.exercicios - 1,
									acao = "fechar",
									tempo_aberto = nil,
									resultado = nil,
									tipo = Var.eXercicios[exes][5].tipo,
									conteudo_alternativas = telas[i].exercicios[exes].alternativas,
									conteudo_enunciado = telas[i].exercicios[exes].enunciado,
									relatorio = data .. "| Fechou a questão "..numeroQ.."da página "..pH.." às "..hora.."."
								}
								if GRUPOGERAL.subPagina then
									vetorJson.subPagina = GRUPOGERAL.subPagina
								end
								funcGlobal.escreverNoHistorico(varGlobal.HistoricoFecharQuestao..e.target.numero,vetorJson)
							else
								local exercicioEstaAberto = "false"
								if not varGlobal.exercicioAberto.pagina then
									exercicioEstaAberto = "false"
								else
									for i=1,#varGlobal.exercicioAberto.pagina do
										if varGlobal.exercicioAberto.pagina[i] == pagina and varGlobal.exercicioAberto.numero[i] == e.target.contExerc then
											exercicioEstaAberto = true
										end
									end
								end
								if exercicioEstaAberto == "false" then
									table.insert(varGlobal.exercicioAberto.pagina,pagina)
									table.insert(varGlobal.exercicioAberto.numero,e.target.contExerc)
									table.insert(varGlobal.exercicioAberto.exe,e.target.exe)
									auxFuncs.overwriteTable( varGlobal.exercicioAberto, "exerciciosAbertos.json" )
									Var.eXercicios[exes].nSalvarAbrir = false
								end
								for i=1,#Var.eXercicios[exes][1] do
									Var.eXercicios[exes][1][i].isVisible = true
								end
								Var.eXercicios[exes][2].isVisible,Var.eXercicios[exes][3].isVisible,Var.eXercicios[exes][4].isVisible = true,true,true
								Var.eXercicios[exes].abriu = true
							
								if e.target.tempo == "ativado" then
									local function mudarSegundos()
										Var.eXercicios[exes][6].texto.text = auxFuncs.SecondsToClock((system.getTimer() - tempoInicio)/1000)
									end
									Var.eXercicios[exes].timer = timer.performWithDelay(100,mudarSegundos,-1)
									Var.eXercicios[exes][6].isVisible = true
									Var.eXercicios[exes][6].y = Var.eXercicios[exes][5].y
								end
								local alternativas = ""
								if telas[i].exercicios[exes].alternativas then
								
									for k=1,#telas[i].exercicios[exes].alternativas do
										print(i,#telas[i].exercicios[exes].alternativas,alternativas)
										print(telas[i].exercicios[exes].alternativas[k])
										alternativas = alternativas.."|".. k .. " " .. telas[i].exercicios[exes].alternativas[k]
									end
								end
								if not e.naoHistorico then
									local date = os.date( "*t" )
									local data = date.day.."/"..date.month.."/"..date.year
									local hora = date.hour..":"..date.min..":"..date.sec
									local numeroQ = ""
									if telas[i].exercicios[exes].numero then
										numeroQ = telas[i].exercicios[exes].numero.." "
									end
									local pH = funcGlobal.pegarNumeroPaginaRomanosHistorico(varGlobal.PagH)
									local vetorJson = {
										tipoInteracao = "questao",
										pagina_livro = varGlobal.PagH,
										objeto_id = telas[i].cont.exercicios - 1,
										acao = "abrir",
										resultado = nil,
										tipo = Var.eXercicios[exes][5].tipo,
										conteudo_alternativas = telas[i].exercicios[exes].alternativas,
										conteudo_enunciado = telas[i].exercicios[exes].enunciado,
										relatorio = data .. "| Abriu a questão "..numeroQ.."da página "..pH.." às "..hora.."."
									}
									if GRUPOGERAL.subPagina then
										vetorJson.subPagina = GRUPOGERAL.subPagina
									end
									funcGlobal.escreverNoHistorico(varGlobal.HistoricoAbrirQuestao..e.target.numero.."|De Enunciado: "..tostring(telas[i].exercicios[exes].enunciado).."|De alternativas "..alternativas,vetorJson)
								end
							end
							if Var.imagens then for i=1,#Var.imagens do if Var.imagens[i].index > e.target.index then Var.imagens[i].y = Var.imagens[i].y + e.target.HH*multiplicador end end end
						
							if Var.textos then for i=1,#Var.textos do if Var.textos[i].index > e.target.index then Var.textos[i].y = Var.textos[i].y + e.target.HH*multiplicador end end end
							if Var.separadores then for i=1,#Var.separadores do if Var.separadores[i].index > e.target.index then Var.separadores[i].y = Var.separadores[i].y + e.target.HH*multiplicador end end end
							if Var.espacos then for i=1,#Var.espacos do if Var.espacos[i].index > e.target.index then Var.espacos[i].y = Var.espacos[i].y + e.target.HH*multiplicador end end end
							if Var.animacoes then for i=1,#Var.animacoes do if Var.animacoes[i].index > e.target.index then Var.animacoes[i].y = Var.animacoes[i].y + e.target.HH*multiplicador end end end
							if Var.imagemTextos then for i=1,#Var.imagemTextos do if Var.imagemTextos[i].index > e.target.index then Var.imagemTextos[i].y = Var.imagemTextos[i].y + e.target.HH*multiplicador end end end
							if Var.eXercicios then 
								for i=1,#Var.eXercicios do 
									print(Var.eXercicios,Var.eXercicios[i],Var.eXercicios[i][5].index,e.target.index)
									if Var.eXercicios[i][5].index > e.target.index then 
										Var.eXercicios[i][6].y = Var.eXercicios[i][6].y + e.target.HH*multiplicador 
										Var.eXercicios[i][5].y = Var.eXercicios[i][5].y + e.target.HH*multiplicador 
										Var.eXercicios[i][4].y = Var.eXercicios[i][4].y + e.target.HH*multiplicador 
										Var.eXercicios[i][3].y = Var.eXercicios[i][3].y + e.target.HH*multiplicador
										Var.eXercicios[i][2].y = Var.eXercicios[i][2].y + e.target.HH*multiplicador
										for k=1,#Var.eXercicios[i][1] do
											Var.eXercicios[i][1][k].y = Var.eXercicios[i][1][k].y + e.target.HH*multiplicador
										end
									end 
								end 
							end
							if Var.sons then for i=1,#Var.sons do if Var.sons[i].index > e.target.index then Var.sons[i].y = Var.sons[i].y + e.target.HH*multiplicador end end end
							if Var.videos then for i=1,#Var.videos do if Var.videos[i].index > e.target.index then Var.videos[i].y = Var.videos[i].y + e.target.HH*multiplicador end end end
							if htmls then for i=1,#htmls do if htmls[i].index > e.target.index then htmls[i].y = htmls[i].y + e.target.HH*multiplicador end end end
							if Var.botoes then for i=1,#Var.botoes do if Var.botoes[i].index > e.target.index then Var.botoes[i].y = Var.botoes[i].y + e.target.HH*multiplicador end end end
							
							varGlobal.limiteTela = varGlobal.limiteTela + e.target.HH*multiplicador
							local numero = 1280
							if system.getInfo("platform") == "win32" then
								numero = varGlobal.numeroWin
							end
							if system.orientation == "portrait" then
								local diferenca = (H+250) - varGlobal.limiteTela
								if diferenca >= 0 then diferenca = 0 end
								if GRUPOGERAL.y < diferenca then
									GRUPOGERAL.y = diferenca
								end
								if varGlobal.limiteTela <= H+250 then
									GRUPOGERAL.y = 0
								end 
							end
							varGlobal.WindowsDireita.height,varGlobal.WindowsEsquerda.height = varGlobal.limiteTela,varGlobal.limiteTela
							if Var.retanguloMovimento then 
								Var.retanguloMovimento.height = varGlobal.limiteTela
							end
						end
						if Var.eXercicios[exes][6].tempo and Var.eXercicios[exes][6].tempo == "sim" then
							local function abrirAviso(event)
								local function onComplete(e)
									if e.index == 2 then
										event.target.tempo = "ativado"
										abrirFecharExercicio(event)
									elseif e.index == 1 then
										event.target.tempo = "desativado"
										abrirFecharExercicio(event)
									elseif e.action == "cancelled" then
										--funcGlobal.escreverNoHistorico("Cancelou o exercício "..event.target.numero.."| página: "..contagemDaPaginaHistorico())
									end
								end
								--[[if Var.eXercicios[exes].abriu == true then
									abrirFecharExercicio(event)
								else
									local aviso = native.showAlert("selecione o tipo de questão:","",{"Didática","Tempo"},onComplete)
								end]]
								Var.eXercicios[exes][5].abrirFecharExercicio(event)
							end
							Var.eXercicios[exes][5]:addEventListener("tap",abrirAviso)
						else
							Var.eXercicios[exes][5]:addEventListener("tap",Var.eXercicios[exes][5].abrirFecharExercicio)
						end
					end
				
					if(telas[i].ordemElementos[ord] == "texto") then
						if not Var.textos then Var.textos = {} end
						local txt = telas[i].cont.textos
						telas[i].textos[txt].contTexto = txt
						telas[i].textos[txt].enderecoArquivos = telas[pagina].pastaArquivosAtual
						
						Var.textos[txt] = elemTela.colocarTexto(telas[i].textos[txt],telas)
						
						Var.textos[txt].mudarTamanhoFontePagina = function (atrib,telas)	
							elemTela.mudarFonte(atrib,telas,GRUPOGERAL,Var,criarCursoAux,paginaAtual,varGlobal.PagH)
						end

						telas[i].cont.textos = telas[i].cont.textos + 1
						Var.textos[txt].txt = telas[i].textos[txt].texto
						Var.textos[txt].iii = txt
						
						Var.textos[txt].y = Var.textos[txt].y + Var.proximoY
						--telas[i].YElementos[ord] = Var.textos[txt].y
						Var.proximoY = Var.textos[txt].y + Var.textos[txt].height 

						GRUPOGERAL:insert(Var.textos[txt])
						local vetor = {}
						vetor.height = Var.textos[txt].height
						vetor.y = Var.textos[txt].y
						funcGlobal.modificarLimiteTela(vetor)
					end
					--Verifica se tem animacao
					if(telas[i].ordemElementos[ord] == "animacao") then
						if not Var.animacoes then Var.animacoes = {} end
						local ani = telas[i].cont.animacoes

						Var.animacoes[ani] = elemTela.colocarAnimacao(telas[i].animacoes[ani],telas,varGlobal,funcGlobal)

						telas[i].cont.animacoes = telas[i].cont.animacoes + 1
						Var.animacoes[ani].y = Var.animacoes[ani].y + Var.proximoY
						--telas[i].YElementos[ord] = Var.animacoes[ani].y
						Var.proximoY = Var.animacoes[ani].y + Var.animacoes[ani].height
						GRUPOGERAL:insert(Var.animacoes[ani])
						funcGlobal.modificarLimiteTela(Var.animacoes[ani])	
					end 
					--verifica se tem botao
					if(telas[i].ordemElementos[ord] == "botao") then
					
						if not Var.botoes then Var.botoes = {} end
						local bot = telas[i].cont.botoes

						Var.botoes[bot] = ead.colocarBotao(telas[i].botoes[bot],telas)

						telas[i].cont.botoes =  telas[i].cont.botoes + 1
						Var.botoes[bot].y = Var.botoes[bot].y + Var.proximoY
						Var.botoes[bot].YY = Var.botoes[bot].YY + Var.proximoY
						--telas[i].YElementos[ord] = Var.botoes[bot].y
						Var.proximoY = Var.botoes[bot].y + Var.botoes[bot].height
						GRUPOGERAL:insert(Var.botoes[bot])
						local botaoLimite = {}
						botaoLimite.height = Var.botoes[bot].height
						botaoLimite.y = Var.botoes[bot].YY
						funcGlobal.modificarLimiteTela(botaoLimite)
					end	
				
					if(telas[i].ordemElementos[ord] == "imagemTexto") then
						if not Var.imagemTextos then Var.imagemTextos = {} end
						local imtx = telas[i].cont.imagemTextos
					
						Var.imagemTextos[imtx] = ead.colocarImagemTexto(telas[i].imagemTextos[imtx],telas)
						telas[i].cont.imagemTextos =  telas[i].cont.imagemTextos + 1
						Var.imagemTextos[imtx].y = Var.imagemTextos[imtx].y + Var.proximoY
						--telas[i].YElementos[ord] = Var.imagemTextos[imtx].y
						Var.proximoY = Var.imagemTextos[imtx].y + Var.imagemTextos[imtx].height
						local function ZoomImagem(e)
							
							toqueHabilitado = false
							Var.imagemTextos[imtx].imagem.grupoZoom = display.newGroup()
							--print(e.target.zoom)
							local imagemoutra = telas[i].imagemTextos[imtx].arquivo
							local telaPreta = display.newRect(0,0,W,H)
							telaPreta.anchorX = 0.5; telaPreta.anchorY = 0.5
							telaPreta.x = W/2; telaPreta.y = H/2
							telaPreta:setFillColor(1,1,1)
							telaPreta.alpha=0.7
							Var.imagemTextos[imtx].imagem.grupoZoom.imgFunc = display.newImage(imagemoutra,W/2,H/2)
							Var.imagemTextos[imtx].imagem.grupoZoom.imgFunc.anchorX = .5; Var.imagemTextos[imtx].imagem.grupoZoom.imgFunc.anchorY= .5
							Var.imagemTextos[imtx].imagem.grupoZoom.imgFunc.x=W/2;Var.imagemTextos[imtx].imagem.grupoZoom.imgFunc.y=H/2
							Var.imagemTextos[imtx].imagem.grupoZoom:insert(telaPreta)
							Var.imagemTextos[imtx].imagem.grupoZoom:insert(Var.imagemTextos[imtx].imagem.grupoZoom.imgFunc)
							Var.imagemTextos[imtx].imagem:removeEventListener("tap",ZoomImagem)
							local texto = display.newText("Zoom Ativado",1,1,native.systemFont,50)
							texto.anchorX = 1; texto.anchorY = 1
							texto.x = W; texto.y = H
							texto:setFillColor(0,1,0)
							if system.orientation ~= "portrait" then
								telaPreta.xScale = varGlobal.aspectRatio
								telaPreta.yScale = varGlobal.aspectRatio
								telaPreta.x = telaPreta.x + 165
								Var.imagemTextos[imtx].imagem.grupoZoom.imgFunc.x = Var.imagemTextos[imtx].imagem.grupoZoom.imgFunc.x + 170
								texto.y = W/2 + 110
								texto.x = W + 220
							end
							Var.imagemTextos[imtx].imagem.grupoZoom:insert(texto)
							local function rodarTelaZoom()
								if Var.imagemTextos[imtx].imagem then
									girarTelaOrientacao(Var.imagemTextos[imtx].imagem.grupoZoom)
								end
							end
						
							function Var.imagemTextos.mudarOrientation()
								if Var.imagemTextos[imtx] and Var.imagemTextos[imtx].grupoZoom then
									if system.orientation == "landscapeRight" then 
										telaPreta.xScale = varGlobal.aspectRatio;telaPreta.yScale = varGlobal.aspectRatio;
										telaPreta.x = telaPreta.x + 100
										Var.imagemTextos[imtx].grupoZoom.xScale = varGlobal.aspectRatio;Var.imagemTextos[imtx].grupoZoom.yScale = varGlobal.aspectRatio;
										Var.imagemTextos[imtx].grupoZoom.rotation = 90
										Var.imagemTextos[imtx].grupoZoom.x = 0 + Var.imagemTextos[imtx].grupoZoom.height/2
										Var.imagemTextos[imtx].grupoZoom.y = 0
										texto.y = W/2 +250
										texto.x = W + 100
										Var.imagemTextos[imtx].imagem.grupoZoom.imgFunc.x=H/2- (Var.imagemTextos[imtx].imagem.grupoZoom.imgFunc.width/2);Var.imagemTextos[imtx].imagem.grupoZoom.imgFunc.y=W/2
									elseif system.orientation == "landscapeLeft" then 
										telaPreta.xScale = varGlobal.aspectRatio;telaPreta.yScale = varGlobal.aspectRatio;
										Var.imagemTextos[imtx].grupoZoom.xScale = varGlobal.aspectRatio;Var.imagemTextos[imtx].grupoZoom.yScale = varGlobal.aspectRatio;
										Var.imagemTextos[imtx].grupoZoom.rotation = -90
										Var.imagemTextos[imtx].grupoZoom.x = 0
										Var.imagemTextos[imtx].grupoZoom.y = 0 + Var.imagemTextos[imtx].grupoZoom.width
										texto.y = W/2 + 110
										texto.x = W
										Var.imagemTextos[imtx].imagem.grupoZoom.imgFunc.y=W/2 ;Var.imagemTextos[imtx].imagem.grupoZoom.imgFunc.x=H/2 - (Var.imagemTextos[imtx].imagem.grupoZoom.imgFunc.width*varGlobal.aspectRatio/2)
									else 
										telaPreta.xScale = 1;telaPreta.yScale = 1; 
										telaPreta.x = W/2; telaPreta.y = H/2; 
										texto.x = W; texto.y = H
										Var.imagemTextos[imtx].grupoZoom.xScale = 1;Var.imagemTextos[imtx].grupoZoom.yScale = 1;
										Var.imagemTextos[imtx].grupoZoom.rotation = 0
										Var.imagemTextos[imtx].grupoZoom.x = 0
										Var.imagemTextos[imtx].grupoZoom.y = 0
										texto.x = W; texto.y = H
									end	
								end
							end
							Var.imagemTextos.mudarOrientation(Var.imagemTextos[imtx].imagem.grupoZoom)
							Runtime:addEventListener("orientation",Var.imagemTextos.mudarOrientation)
							local function removerImgFunc()
								Var.imagemTextos[imtx].imagem.grupoZoom:removeEventListener("tap",removerImgFunc)
								Var.imagemTextos[imtx].imagem.grupoZoom:removeSelf()
								Runtime:removeEventListener("orientation",rodarTelaZoom)
								Runtime:removeEventListener("orientation",Var.imagemTextos.mudarOrientation)
								Var.imagemTextos[imtx].imagem:addEventListener("tap",ZoomImagem)
								Runtime:removeEventListener("orientation",onOrientationChange )
								toqueHabilitado = true
								print("\n\nremoveu Zoom\n\n")
								funcGlobal.escreverNoHistorico(varGlobal.HistoricoZoomRemovido..telas[i].cont.imagemTextos - 1)
								return true
							end
							print("\n\ncriou Zoom\n\n")
						
							Var.imagemTextos[imtx].imagem.grupoZoom.imgFunc.prevX=Var.imagemTextos[imtx].imagem.grupoZoom.imgFunc.x
							Var.imagemTextos[imtx].imagem.grupoZoom.imgFunc.prevY=Var.imagemTextos[imtx].imagem.grupoZoom.imgFunc.y
							Var.imagemTextos[imtx].imagem.grupoZoom.imgFunc.anchorChildren = true
							--zoomLib.loadIMageZoom(imgFunc)
							funcGlobal.escreverNoHistorico(varGlobal.HistoricoZoomEfetuado..telas[i].cont.imagemTextos - 1)
							if system.orientation ~= "portrait" then
								Var.imagemTextos[imtx].imagem.grupoZoom.imgFunc:addEventListener("touch",ZOOMZOOMZOOM)
							else
								Var.imagemTextos[imtx].imagem.grupoZoom:addEventListener("touch",ZOOMZOOMZOOM2)
							end
						
							Var.imagemTextos[imtx].imagem.grupoZoom:addEventListener("touch",function() return true; end)
							Var.imagemTextos[imtx].imagem.grupoZoom:addEventListener("tap",removerImgFunc)
							--imgFunc:addEventListener("touch",ZOOMZOOMZOOM)

							GRUPOGERAL.grupoZoom = Var.imagemTextos[imtx].imagem.grupoZoom
							Var.imagemTextos[imtx].imagem.grupoZoom.imgFunc.orientacao = system.orientation
							local function onOrientationChange()
								if system.orientation ~= Var.imagemTextos[imtx].imagem.grupoZoom.imgFunc.orientacao then
									removerImgFunc()
								
								end
							end
							Runtime:addEventListener("orientation",onOrientationChange )
							return true
						end
						if Var.imagemTextos[imtx] then
							if Var.imagemTextos[imtx].imagem.zoom == "sim" then
								Var.imagemTextos[imtx].imagem:addEventListener("tap",ZoomImagem)
							end
							local function aumentaDiminuiFonte2(evento)
								if jacliquei == true then
									 if Var.imagemTextos[imtx].botaoDeAumentar then
										Var.imagemTextos[imtx].botaoDeAumentar:removeSelf()
										Var.imagemTextos[imtx].botaoDeAumentar = nil
										jacliquei = false
									end
								else
									Var.imagemTextos[imtx].botaoDeAumentar = botaoDeAumentarfunc(evento)
									Var.imagemTextos[imtx].botaoDeAumentar.tamanho = Var.imagemTextos[imtx].tamanho
									--textos[txt].botaoDeAumentar.y = telas[pagina].textos[txt].y  + textos[txt].height/2
									jacliquei = true
								
									grupoBotaoAumentar:insert(Var.imagemTextos[imtx].botaoDeAumentar)
									if system.orientation == "portrait" then
										grupoBotaoAumentar.x = W/2
									end
									--GRUPOINTERFACE:insert(textos[txt].botaoDeAumentar)
									Var.imagemTextos[imtx].botaoDeAumentar.txt = imtx
									Var.imagemTextos[imtx].botaoDeAumentar.tipo = "imageText"
									Var.imagemTextos[imtx].botaoDeAumentar.HMaior = Var.imagemTextos[imtx].texto.HMaior
									Var.imagemTextos[imtx].botaoDeAumentar.HMenor = Var.imagemTextos[imtx].texto.HMenor
									Var.imagemTextos[imtx].botaoDeAumentar.alturaMaior = Var.imagemTextos[imtx].texto.alturaMaior
									Var.imagemTextos[imtx].botaoDeAumentar.alturaMenor = Var.imagemTextos[imtx].texto.alturaMenor
									Var.imagemTextos[imtx].botaoDeAumentar.alturaAtual = Var.imagemTextos[imtx].texto.alturaAtual
									Var.imagemTextos[imtx].botaoDeAumentar.HAtual = Var.imagemTextos[imtx].texto.HAtual
									--Var.imagemTextos[imtx].botaoDeAumentar:addEventListener("tap",mudarFonte)
									--Var.imagemTextos[imtx].botaoDeAumentar:addEventListener("touch",function()return true end)
									Var.imagemTextos[imtx].botaoDeAumentar:addEventListener("orientation",
									function() 
										Var.imagemTextos[imtx].botaoDeAumentar:removeSelf()
										Var.imagemTextos[imtx].botaoDeAumentar = nil
										jacliquei = false
									end)
								end
							end

							Var.imagemTextos[imtx].texto:addEventListener("tap",aumentaDiminuiFonte2)
						
							GRUPOGERAL:insert(Var.imagemTextos[imtx])
							funcGlobal.modificarLimiteTela(Var.imagemTextos[imtx])
						
						end	
					end
					
					if(telas[i].ordemElementos[ord] == "indiceManual") then
						local cancelar = false
						local timerRequerimento
						local requerimentoDownload
						local function funcRetorno(e)
							local function networkListener000(event)
								if ( event.isError ) then
									print( "Network error: ", event.response )
								elseif ( event.phase == "began" ) then
								elseif ( event.phase == "progress" ) then
								elseif ( event.phase == "ended" ) then
									audio.stop()
									if cancelar == false then
										local som = audio.loadStream(e.target.arquivo,system.DocumentsDirectory)
										timerRequerimento = timer.performWithDelay(16,function() audio.play(som) end,1)
									end
								end
							end
							if e.target.clicado == false  then
								local YYAnterior = Var.indiceManual.textoFinalIndice[#Var.indiceManual.textoFinalIndice].y
								audio.stop()
								media.stopSound()
								local params = {}
								-- Tell network.request() that we want the "began" and "progress" events:
								params.progress = "download"
								params.response = {
									filename = e.target.arquivo,
									baseDirectory = system.DocumentsDirectory
								}
								local frase = auxFuncs.filtrarCodigos(e.target.text)
								frase = frase:urlEncode()

								local url = "https://api.voicerss.org/?key="..APIkey.thithou1.."&hl="..varGlobal.TTSVozIdioma.."&c=MP3&r=-1".."&f=".."12khz_16bit_mono".."&src="..frase
								--print(url)
								--requerimentoDownload = network.request( url, "GET", networkListener000,  params )
								requerimentoDownload = funcGlobal.requisitarTTSOnline({tipo = varGlobal.TTSTipo,voz = varGlobal.TTSVoz,params = params,qualidade = "12khz_16bit_mono",idioma = varGlobal.TTSVozIdioma,texto = frase,extensao = varGlobal.extensao,funcao = networkListener000})
								e.target.clicado = true
								timer.performWithDelay(1000,function() e.target.clicado = false end,1)
								
								local vetorTamanhosAux = {}
								if e.target.subtituloTamanhos and #e.target.subtituloTamanhos > 0 then
									vetorTamanhosAux = e.target.subtituloTamanhos
								elseif e.target.subtitulo2Tamanhos and #e.target.subtitulo2Tamanhos > 0 then
									vetorTamanhosAux = e.target.subtitulo2Tamanhos
								elseif e.target.subtitulo3Tamanhos and #e.target.subtitulo3Tamanhos > 0 then
									vetorTamanhosAux = e.target.subtitulo3Tamanhos
								end
								if e.target.tipo ~= "subtitulo3" and #vetorTamanhosAux > 0 then
									
									if e.target.aberto == false then
										local contAbertos = 1
										local ultimoy = 0
										for i=e.target.indice+1,#Var.indiceManual.textoFinalIndice do
											local tamanhoAumentar = 0
											local listaTamanhos = {}
											if e.target.tipo == "titulo" then
												tamanhoAumentar = e.target.subtituloTamanhosTotal
												listaTamanhos = e.target.subtituloTamanhos
											elseif e.target.tipo == "subtitulo" then
												tamanhoAumentar = e.target.subtitulo2TamanhosTotal
												listaTamanhos = e.target.subtitulo2Tamanhos
											elseif e.target.tipo == "subtitulo2" then
												tamanhoAumentar = e.target.subtitulo3TamanhosTotal
												listaTamanhos = e.target.subtitulo3Tamanhos
											end
											
											local ehDaLista = false
											for j=1,#listaTamanhos do
												if i == listaTamanhos[j][1] then
													ehDaLista = true
													
												end
											end
											if ehDaLista then
												print("ehDaLista =>",i,ehDaLista)
												if contAbertos == 1 then
													print("Subs1: ",Var.indiceManual.textoFinalIndice[i].text)
													Var.indiceManual.textoFinalIndice[i].y = e.target.y + e.target.height + 20
													if Var.indiceManual.textoFinalIndice[i].symbol then
														Var.indiceManual.textoFinalIndice[i].symbol.y = e.target.y + 200 + e.target.height+ 20
														Var.indiceManual.textoFinalIndice[i].symbol.alpha = 1
													end
													ultimoy = Var.indiceManual.textoFinalIndice[i].y
													
												else
													print("Subs2: ",Var.indiceManual.textoFinalIndice[i].text)
													Var.indiceManual.textoFinalIndice[i].y = ultimoy + listaTamanhos[contAbertos-1][2] + 20--Var.indiceManual.textoFinalIndice[i].y + listaTamanhos[j][2] + 20
													if Var.indiceManual.textoFinalIndice[i].symbol then
														
														Var.indiceManual.textoFinalIndice[i].symbol.y = ultimoy + 200 + listaTamanhos[contAbertos-1][2] + 20--Var.indiceManual.textoFinalIndice[i].symbol.y + listaTamanhos[j][2]+ 20
														Var.indiceManual.textoFinalIndice[i].symbol.alpha = 1
													end
													ultimoy = Var.indiceManual.textoFinalIndice[i].y
												
												end
												contAbertos = contAbertos + 1
												Var.indiceManual.textoFinalIndice[i].alpha = 1
												
											else
												print("Subs3: ",Var.indiceManual.textoFinalIndice[i].text)
												Var.indiceManual.textoFinalIndice[i].y = Var.indiceManual.textoFinalIndice[i].y + tamanhoAumentar + 20*#listaTamanhos
												if Var.indiceManual.textoFinalIndice[i].symbol then
													print("NãoehDaLista =>",i,ehDaLista)
													Var.indiceManual.textoFinalIndice[i].symbol.y = Var.indiceManual.textoFinalIndice[i].symbol.y + tamanhoAumentar + 20*#listaTamanhos
													--Var.indiceManual.textoFinalIndice[i].symbol.alpha = 1
												end
												
											end
											
										end
										
										e.target.symbol.squareMinus.alpha = 1
										e.target.symbol.squarePlus.alpha = 0
										e.target.aberto = true
										local YY = Var.indiceManual.textoFinalIndice[#Var.indiceManual.textoFinalIndice].y
										
										funcGlobal.modificarLimiteTela(GRUPOGERAL)
									elseif e.target.aberto == true then
										local contAbertos = 1
										local ultimoy = 0
										local achouTituloAnterior = false
										for i=e.target.indice+1,#Var.indiceManual.textoFinalIndice do
											
											local tamanhoAumentar = 0
											local listaTamanhos = {}
											if e.target.tipo == "titulo" then
												tamanhoAumentar = e.target.subtituloTamanhosTotal
												listaTamanhos = e.target.subtituloTamanhos
											elseif e.target.tipo == "subtitulo" then
												tamanhoAumentar = e.target.subtitulo2TamanhosTotal
												listaTamanhos = e.target.subtitulo2Tamanhos
											elseif e.target.tipo == "subtitulo2" then
												tamanhoAumentar = e.target.subtitulo3TamanhosTotal
												listaTamanhos = e.target.subtitulo3Tamanhos
											end
											
											local ehDaLista = false
											
											for j=1,#listaTamanhos do
												print("listaTamanhos[j][1]",listaTamanhos[j][1],i)
												if i >= listaTamanhos[j][1] then
													ehDaLista = true
												end
											end
											
											-- verificar se já mudou para outra opção anterior --
											if e.target.tipo == "titulo" then
												print("sou titulo")
												if Var.indiceManual.textoFinalIndice[i].tipo == "titulo" then
													print("Sou da lista",Var.indiceManual.textoFinalIndice[i].text)
													ehDaLista = false
												else
													print("Sou da lista",Var.indiceManual.textoFinalIndice[i].text)
													if Var.indiceManual.textoFinalIndice[i].aberto then
														print("estou aberto")
													end
													if Var.indiceManual.textoFinalIndice[i].aberto and Var.indiceManual.textoFinalIndice[i].subtitulo2Tamanhos then
														print("estou aberto e tenho sub 2",Var.indiceManual.textoFinalIndice[i].subtitulo2TamanhosTotal)
														tamanhoAumentar = tamanhoAumentar + Var.indiceManual.textoFinalIndice[i].subtitulo2TamanhosTotal
														for list=1,#Var.indiceManual.textoFinalIndice[i].subtitulo2Tamanhos do
															table.insert(listaTamanhos,Var.indiceManual.textoFinalIndice[i].subtitulo2Tamanhos[list])
														end
													end
													if Var.indiceManual.textoFinalIndice[i].aberto and Var.indiceManual.textoFinalIndice[i].subtitulo3Tamanhos then
														print("estou aberto e tenho sub 3",Var.indiceManual.textoFinalIndice[i].subtitulo3TamanhosTotal)
														tamanhoAumentar = tamanhoAumentar + Var.indiceManual.textoFinalIndice[i].subtitulo3TamanhosTotal
														for list=1,#Var.indiceManual.textoFinalIndice[i].subtitulo3Tamanhos do
															table.insert(listaTamanhos,Var.indiceManual.textoFinalIndice[i].subtitulo3Tamanhos[list])
														end
													end
												end
											elseif e.target.tipo == "subtitulo" then
												print("sou subtitulo")
												if Var.indiceManual.textoFinalIndice[i].tipo == "titulo" or  Var.indiceManual.textoFinalIndice[i].tipo == "subtitulo" then
													ehDaLista = false
												else
													if Var.indiceManual.textoFinalIndice[i].aberto and Var.indiceManual.textoFinalIndice[i].subtitulo2Tamanhos then
														tamanhoAumentar = Var.indiceManual.textoFinalIndice[i].subtitulo3TamanhosTotal
														listaTamanhos = Var.indiceManual.textoFinalIndice[i].subtitulo3Tamanhos
													end
												end
											elseif e.target.tipo == "subtitulo2" then
												if Var.indiceManual.textoFinalIndice[i].tipo == "titulo" or Var.indiceManual.textoFinalIndice[i].tipo == "subtitulo" or  Var.indiceManual.textoFinalIndice[i].tipo == "subtitulo2" then
													ehDaLista = false
												end
											end
											-----------------------------------------------------
											
											if ehDaLista then
												print("ehDaLista",Var.indiceManual.textoFinalIndice[i].text)
												-- verificar se tem outras opções abertas e reduzí-las -------
												if Var.indiceManual.textoFinalIndice[i].aberto and Var.indiceManual.textoFinalIndice[i].symbol then
													print("aberto",Var.indiceManual.textoFinalIndice[i].aberto)
													Var.indiceManual.textoFinalIndice[i].aberto = false
													Var.indiceManual.textoFinalIndice[i].symbol.squareMinus.alpha = 0
													Var.indiceManual.textoFinalIndice[i].symbol.squarePlus.alpha = 1
												end
												---------------------------------------------------------------
												if contAbertos == 1 then
													Var.indiceManual.textoFinalIndice[i].y = e.target.y
													if Var.indiceManual.textoFinalIndice[i].symbol then
														Var.indiceManual.textoFinalIndice[i].symbol.y = e.target.y
														Var.indiceManual.textoFinalIndice[i].symbol.alpha = 0
													end
												else
													Var.indiceManual.textoFinalIndice[i].y = e.target.y
													if Var.indiceManual.textoFinalIndice[i].symbol then
														
														Var.indiceManual.textoFinalIndice[i].symbol.y = e.target.y
														Var.indiceManual.textoFinalIndice[i].symbol.alpha = 0
													end
												end
												contAbertos = contAbertos + 1
												Var.indiceManual.textoFinalIndice[i].alpha = 0
											else
												print("NÃO SOU DA LISTA",tamanhoAumentar,#listaTamanhos)
												Var.indiceManual.textoFinalIndice[i].y = Var.indiceManual.textoFinalIndice[i].y - tamanhoAumentar - 20*#listaTamanhos
												if Var.indiceManual.textoFinalIndice[i].symbol then
													Var.indiceManual.textoFinalIndice[i].symbol.y = Var.indiceManual.textoFinalIndice[i].symbol.y - tamanhoAumentar - 20*#listaTamanhos
												end
											end
										end
										local YY = Var.indiceManual.textoFinalIndice[#Var.indiceManual.textoFinalIndice].y
										
										funcGlobal.modificarLimiteTela(GRUPOGERAL)
										e.target.symbol.squareMinus.alpha = 0
										e.target.symbol.squarePlus.alpha = 1
										e.target.aberto = false
									end
									funcGlobal.modificarLimiteTela(GRUPOGERAL)	
									
								end	
													
								return true
							end
							if e.target.clicado == true and not e.target.indiceRemissivo then
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
								GRUPOGERAL.x = GRUPOGERALORIGINX
								GRUPOGERAL.y = GRUPOGERALORIGINY
								print(e.target)
								local numeroMaximo = varGlobal.numeroTotal.Todas
								print("numeroMaximo = ",numeroMaximo,e.target.i,e.target.numeroReal)
								if e.target.i > numeroMaximo then
									native.showAlert("Atenção!","A página "..e.target.numeroReal..", de índice "..e.target.i..", não existe!",{"OK"})
								else
									paginaAtual = e.target.i 
									GRUPOGERAL.irParaElemento = e.target.elemento
									print("e.target.localizar",e.target.localizar)
									telas.localizar = e.target.localizar
									criarCursoAux(telas, paginaAtual)
								end
								return true
							end
							e.target.clicado = true
							return true
						end
						Var.indiceManual = ead.colocarIndicePreMontado(telas[i].indiceManual,telas,funcRetorno)
						GRUPOGERAL:insert(Var.indiceManual)
					
						local function girarTela(e)
							if Var.indiceManual and Var.indiceManual.botao then
								girarTelaOrientacaoAumentarIndice(Var.indiceManual.botao)
							else
								Runtime:removeEventListener("orientation",girarTela)
							end
						end
						Runtime:addEventListener("orientation",girarTela)
						funcGlobal.modificarLimiteTela(Var.indiceManual)
						
					end
					
				end	
			end
			-- Verificar se o indice mandou para a página --
			-- e atualizar o YPagina -----------------------
			if GRUPOGERAL.irParaElemento then 
				local ord = tonumber(GRUPOGERAL.irParaElemento)
				print("local para ir = "..tostring(telas[i].YElementos[ord]),GRUPOGERAL.irParaElemento)
				--telas[i].YPagina = telas[i].YElementos[ord]
				--GRUPOGERAL.y = -1*telas[i].YElementos[ord]
				if telas[i].YElementos[ord] then
					transition.to(GRUPOGERAL,{time = 200,y=(-1*telas[i].YElementos[ord])+200})
				end
				GRUPOGERAL.irParaElemento = nil
			end 
			------------------------------------------------
			if Var.telaMovedora then Var.telaMovedora:removeSelf(); Var.telaMovedora = nil; end
			Var.telaMovedora = display.newRect(0,0,0,0)
			Var.telaMovedora.width = W;Var.telaMovedora.height = GRUPOGERAL.height
			Var.telaMovedora.y = GRUPOGERAL.y
			Var.telaMovedora.x = GRUPOGERAL.x;Var.telaMovedora.y = 0
			Var.telaMovedora.anchorX=0;Var.telaMovedora.anchorY=0;
			Var.telaMovedora:setFillColor(1,0,0)
			Var.telaMovedora.alpha = 0; Var.telaMovedora.isHitTestable = true
			if varGlobal.limiteTela < 1280 then
				--Var.telaMovedora.height = 1270
			end
			if system.orientation == "landscapeLeft" or system.orientation == "landscapeRight" then
				Var.telaMovedora.x = 0
			end
			GRUPOGERAL:insert(Var.telaMovedora)
	
	
			GRUPOGERAL.girarFundoOrientacao = function()
				girarTelaOrientacao(Var.fundo)
			end
			if travarOrientacaoLado == true then
				system.orientation = "landscapeRight";-- deletar!!!!!!!!!!!!!!!!!!!!!!!!!
				--girarTelaOrientacao(GRUPOGERAL)-- deletar!!!!!!!!!!!!!!!!!!!!!!!!!
				--girarTelaOrientacao(GRUPOSOM)-- deletar!!!!!!!!!!!!!!!!!!!!!!!!!
			else
				Runtime:addEventListener("orientation",function() girarTelaOrientacao(GRUPOGERAL) end)-- arrumar!!!!!!!!!!!!!!!!!!!!!!!!!
				if Var.fundo then
					Runtime:addEventListener("orientation",GRUPOGERAL.girarFundoOrientacao)
				else
					Runtime:removeEventListener("orientation",GRUPOGERAL.girarFundoOrientacao)
				end
				Runtime:addEventListener("orientation",function() girarTelaOrientacao(GRUPOGERAL) end)
				Runtime:addEventListener("orientation",function() girarTelaOrientacao(GRUPOSOM) end)-- arrumar!!!!!!!!!!!!!!!!!!!!!!!!!
			end
			GRUPOGERALORIGINX = GRUPOGERAL.x
			GRUPOGERALORIGINY =	GRUPOGERAL.y
			--varGlobal.limiteTela = varGlobal.limiteTela + 100
			--GRUPOGERAL.anchorX=0;GRUPOGERAL.anchorY=0.5
			--GRUPOGERAL:addEventListener("touch",ZOOMZOOMZOOM)
			
			-- Baixar e criar anotações --
			telas.ativarLogin = varGlobal.preferenciasGerais.ativarLogin
			
			--funcGlobal.criarAnotacoesComentarios(pagina,telas)
			
			Var.retanguloMenu = display.newRoundedRect(0,0,W-250,100,10)
			Var.retanguloMenu.anchorX=0.5
			Var.retanguloMenu.anchorY=1
			Var.retanguloMenu.alpha = .9
			Var.retanguloMenu:setFillColor(40/255,189/255,226/255)
			Var.retanguloMenu.fill.effect = "filter.blurGaussian"
			Var.retanguloMenu.fill.effect.horizontal.blurSize = 20
			Var.retanguloMenu.fill.effect.horizontal.sigma = 140
			Var.retanguloMenu.fill.effect.vertical.blurSize = 20
			Var.retanguloMenu.fill.effect.vertical.sigma = 140
			Var.retanguloMenu.x = W/2
			Var.retanguloMenu.y = H - 50
			Var.retanguloMenu:addEventListener("touch",function() return true end)
			Var.retanguloMenu:addEventListener("tap",function() return true end)
			Var.retanguloMenu.yScale = .8
			
			local pasta = string.gsub(varGlobal.enderecoArquivos,"/Outros Arquivos","")
			------------------------------------------------------------
			-- criando variaveis para o TTS da anotação e comentários --
			------------------------------------------------------------
			local function criarMenuInferiorPadrao()
			
				telas.anotMensTTS = {}
				
				telas.anotMensTTS.paginaHistorico = paginaHistorico
				telas.anotMensTTS.tipo = varGlobal.TTSTipo
				telas.anotMensTTS.apiKey = APIkey.thithou1
				telas.anotMensTTS.idioma = varGlobal.TTSVozIdioma
				telas.anotMensTTS.voz = varGlobal.TTSVoz
				telas.anotMensTTS.velocidade = varGlobal.VelocidadeTTS
				telas.anotMensTTS.neural = varGlobal.TTSNeural
				telas.anotMensTTS.qualidade = "12khz_16bit_mono"
				telas.anotMensTTS.extencao = varGlobal.extensao
				telas.anotMensTTS.diretorio = system.DocumentsDirectory
				telas.anotMensTTS.respostaTapAudio = "audioTTS_AnotacaoEMensagensTTS.mp3"
				telas.anotMensTTS.botaoSemInternet = varGlobal.botaoSemInternetTTS
				telas.anotMensTTS.pastaArquivos = nil
				telas.anotMensTTS.pasta = pasta
				telas.anotMensTTS.somBotao1 = "audioTTS_AnotacaoEMensagensTTS.mp3"
				telas.anotMensTTS.temHistorico = varGlobal.temHistorico
				telas.anotMensTTS.subPagina = nil
				
				------------------------------------------------------------
				------------------------------------------------------------
				------------------------------------------------------------
				-- criando variaveis para o TTS do rodapé --
				------------------------------------------------------------
				telas.rodapeTTS = {}
				
				telas.rodapeTTS.paginaHistorico = paginaHistorico
				telas.rodapeTTS.tipo = varGlobal.TTSTipo
				telas.rodapeTTS.apiKey = APIkey.thithou1
				telas.rodapeTTS.idioma = varGlobal.TTSVozIdioma
				telas.rodapeTTS.voz = varGlobal.TTSVoz
				telas.rodapeTTS.velocidade = varGlobal.VelocidadeTTS
				telas.rodapeTTS.neural = varGlobal.TTSNeural
				telas.rodapeTTS.qualidade = "12khz_16bit_mono"
				telas.rodapeTTS.extencao = varGlobal.extensao
				telas.rodapeTTS.diretorio = system.DocumentsDirectory
				telas.rodapeTTS.respostaTapAudio = varGlobal.ttsRodape1Clique
				telas.rodapeTTS.respostaTapAudioPagina = varGlobal.ttsRodape1CliquePagina
				telas.rodapeTTS.botaoSemInternet = varGlobal.botaoSemInternetTTS
				telas.rodapeTTS.pastaArquivos = nil
				telas.rodapeTTS.pasta = pasta
				telas.rodapeTTS.somBotao1 = varGlobal.ttsRodape1Clique
				telas.rodapeTTS.temHistorico = varGlobal.temHistorico
				telas.rodapeTTS.temLogin = varGlobal.temLogin
				telas.rodapeTTS.subPagina = nil
				
				------------------------------------------------------------
				------------------------------------------------------------
				
				elemTela.criarAnotacoesComentarios(pagina,telas,Var,varGlobal)
				
				Var.anotComInterface.y = H- Var.anotComInterface.Icone.height - 5
				Var.anotComInterface.x = Var.retanguloMenu.x - Var.anotComInterface.width/2 - Var.retanguloMenu.width/2 + Var.anotComInterface.width/2
				
				
				Var.Impressao = elemTela.criarBotaoImpressao(pagina,telas,Var,varGlobal,GRUPOGERAL)
				--funcGlobal.criarBotaoImpressao(pagina,telas)
				Var.Impressao.y = Var.retanguloMenu.y - Var.Impressao.botao.height*0.8 - 10
				Var.anotComInterface.y = Var.retanguloMenu.y - Var.Impressao.botao.height*0.8 - 10
				Var.anotComInterface.Icone.yScale = .8
				Var.Impressao.x = Var.anotComInterface.x + Var.anotComInterface.Icone.width + 20
				Var.Impressao.botao.yScale = .8
				
				Var.Relatorio = elemTela.criarBotaoRelatorio(pagina,telas,Var,varGlobal)
				--Var.Relatorio = funcGlobal.criarBotaoRelatorio(pagina,telas)
				Var.Relatorio.y = Var.Impressao.y
				Var.Relatorio.x = Var.Impressao.x + Var.Impressao.botao.x + Var.Impressao.botao.width + 10
				Var.Relatorio.botao.yScale = .8
				--GRUPOGERAL:insert(Var.Impressao)
				--GRUPOGERAL:insert(Var.Relatorio)
				
				
				if auxFuncs.fileExistsDiretorioBase("dicionario.txt",system.DocumentsDirectory) then
					Var.temHistorico = varGlobal.temHistorico
					Var.pagina = pagina
					Var.Dicionario = elemTela.criarDicionarioPagina(pagina,telas,pasta,Var,varGlobal)
					Var.Dicionario.y = Var.Impressao.y - 5 -- Var.Impressao.botao.height/2
					Var.Dicionario.x = Var.Relatorio.x + Var.Relatorio.botao.width + 10
					Var.Dicionario.botao.yScale = .8
					--GRUPOGERAL:insert(Var.Dicionario)
				else
					Var.Dicionario = display.newGroup()
					Var.Dicionario.botao = display.newImageRect("botaoDicionario.png",80,80)
					Var.Dicionario.botao.anchorY=0;Var.Dicionario.botao.anchorX=0
					Var.Dicionario:insert(Var.Dicionario.botao)
					Var.Dicionario.botao.fill.effect = "filter.desaturate"
					Var.Dicionario.botao.fill.effect.intensity = 1
					Var.Dicionario.y = Var.Impressao.y + 2 -- Var.Impressao.botao.height/2
					Var.Dicionario.x = Var.Relatorio.x + Var.Relatorio.botao.width + 10
					Var.Dicionario.botao.yScale = .8
					Var.Dicionario.botao.clicavel = true
					Var.Dicionario.botao:addEventListener("touch",function(e)
						if not audio.isChannelPlaying(1) then
							Var.Dicionario.botao.clicavel = true
						end
						if e.phase == "began" and Var.Dicionario.botao.clicavel then
							local som = audio.loadSound(varGlobal.ttsDicionarioVazio)
							local activeChannels = {}
							local noChannels = true
							if audio.isChannelPlaying(1) then audio.stop(1) end
							for c=1,31 do
								local channel = audio.isChannelPlaying(c)
								if channel then noChannels = false end
								table.insert(activeChannels,c)
							end
							audio.pause()
							Var.Dicionario.botao.clicavel = false
							local function onComplete()
								if not noChannels then
									for c=1,#activeChannels do
										audio.resume(activeChannels[c])
										Var.Dicionario.botao.clicavel = true
									end
								end
							end
							local options = {channel = 1,onComplete = onComplete}
							audio.play(som,options)
						end
						return true
					end)
				end
				
				if not Var.TTSDicionario and Var.Dicionario then
					Var.TTSDicionario = {}
					Var.TTSDicionario = elemTela.criarBotaoTTSDicionario({tela = telas,pagina = paginaHistorico,tipo = varGlobal.TTSTipo,APIkey = APIkey.thithou1,idioma = varGlobal.TTSVozIdioma,voz = varGlobal.TTSVoz,velocidade = varGlobal.VelocidadeTTS,neural = varGlobal.TTSNeural, qualidade = "12khz_16bit_mono",extencao = varGlobal.extensao, diretorioBase = system.DocumentsDirectory,tapResponse = varGlobal.ttsDicionario1Clique,audioSemNet = varGlobal.botaoSemInternetTTS,pastaArquivos = "Dicionario Palavras/Outros Arquivos",pasta = pasta,somBotao1 = varGlobal.ttsDicionario1Clique,temHistorico = varGlobal.temHistorico,subPagina = GRUPOGERAL.subPagina,funcionalidade = "dicionario"},Var)
					Var.TTSDicionario.botaoTTS.isVisible = false
				end
				if Var.Dicionario and Var.Dicionario.vetorFinalPalavrasTxTs then
					Var.TTSDicionario.vetorPalavrasTxTs = Var.Dicionario.vetorFinalPalavrasTxTs--vetorOriginalPalavrasTxT
				end
				telas.idLivro1 = varGlobal.idLivro1
				telas.idAluno1 = varGlobal.idAluno1
				telas.idProprietario1 = varGlobal.idProprietario1
				if telas[i].decks and telas[i].decks[1] then
					print(telas.pagina)
					elemTela.checarCardsOnlinePagina(varGlobal.PagH,telas)
					print("WARNING: tem decks na página")
					Var.deck = elemTela.criarBotaoDecks(telas[i].decks,paginaHistorico,telas,varGlobal,Var)
					Var.deck.y = Var.retanguloMenu.y - Var.deck.botao.height*0.8 - 10
					if Var.Dicionario then
						Var.deck.x = Var.Dicionario.x + Var.Dicionario.botao.width + 10
					else
						Var.deck.x = Var.Relatorio.x + Var.Relatorio.botao.width + 10
					end
					Var.deck.botao.yScale = .8
					Var.deck.botao.xScale = .9
				else
					Var.deck = display.newGroup()
					Var.deck.botao = display.newImageRect("flash card.png",80,80)
					Var.deck.botao.anchorY = 0;Var.deck.botao.anchorX=0
					Var.deck.botao.y = 0
					Var.deck.botao.x = 0
					Var.deck:insert(Var.deck.botao)
					Var.deck.botao:setFillColor(.7,.7,.7)
					Var.deck.y = Var.retanguloMenu.y - Var.deck.botao.height*0.8 - 10
					Var.deck.x = Var.Dicionario.x + Var.Dicionario.botao.width + 10
					Var.deck.botao.yScale = .8
					Var.deck.botao.xScale = .9
					Var.deck.botao.clicavel = true
					Var.deck.botao:addEventListener("touch",function(e)
						if not audio.isChannelPlaying(1) then
							Var.deck.botao.clicavel = true
						end
						if e.phase == "began" and Var.deck.botao.clicavel then
							local som = audio.loadSound(varGlobal.ttsDeckVazio)
							local activeChannels = {}
							local noChannels = true
							if audio.isChannelPlaying(1) then audio.stop(1) end
							for c=1,31 do
								local channel = audio.isChannelPlaying(c)
								if channel then noChannels = false end
								table.insert(activeChannels,c)
							end
							audio.pause()
							Var.deck.botao.clicavel = false
							local function onComplete()
								if not noChannels then
									for c=1,#activeChannels do
										audio.resume(activeChannels[c])
										Var.deck.botao.clicavel = true
									end
								end
							end
							local options = {channel = 1,onComplete = onComplete}
							audio.play(som,options)
						end
						return true
					end)
				end
				-- colocando o rodapé --
				if auxFuncs.fileExistsDiretorioBase("rodape.txt",system.DocumentsDirectory) then
					Var.rodape = elemTela.criarBotaoRodape(telas,Var,varGlobal)
				else
					Var.rodape = display.newGroup()
					Var.rodape.botao = display.newRoundedRect(Var.rodape,0,0,W-250,40,10)
					Var.rodape.botao:setFillColor(0.5,0.5,0.5)
					Var.rodape.botao.strokeWidth = 3
					Var.rodape.botao:setStrokeColor(0,0,0)
					Var.rodape.botao.anchorX=0.5
					Var.rodape.botao.anchorY=1
					Var.rodape.botao.clicavel = true
					Var.rodape.botao.x = W/2
					Var.rodape.botao.y = H
					Var.rodape.label = display.newText(Var.rodape,"rodapé",Var.rodape.botao.x,Var.rodape.botao.y - Var.rodape.botao.height/2,"Fontes/paolaAccent.ttf",40)
					Var.rodape.botao:addEventListener("touch",function(e)
						if not audio.isChannelPlaying(1) then
							Var.rodape.botao.clicavel = true
						end
						if e.phase == "began" and Var.rodape.botao.clicavel then
							local som = audio.loadSound(varGlobal.ttsRodapeVazio)
							local activeChannels = {}
							local noChannels = true
							if audio.isChannelPlaying(1) then audio.stop(1) end
							for c=1,31 do
								local channel = audio.isChannelPlaying(c)
								if channel then noChannels = false end
								table.insert(activeChannels,c)
							end
							audio.pause()
							Var.rodape.botao.clicavel = false
							local function onComplete()
								if not noChannels then
									for c=1,#activeChannels do
										audio.resume(activeChannels[c])
										Var.rodape.botao.clicavel = true
									end
								end
							end
							local options = {channel = 1,onComplete = onComplete}
							audio.play(som,options)
						end
						return true
					end)
				end
			end	
			telas.idLivro1 = varGlobal.idLivro1
			telas.idAluno1 = varGlobal.idAluno1
			
			local vetorPalavras = auxFuncs.loadTable("todasAsPalavrasPorPagina.json","res")
			local textoPalavrasDaPagina = vetorPalavras[tonumber(paginaHistorico)]
			
			if auxFuncs.fileExistsDoc("Paginas mescladas.txt") then
				textoPalavrasDaPagina = Pcurses.filtrarTextosDePagina("Paginas Mescladas.txt")
			end
			-- !!criar menu personalizar
			
			--varGlobal.personalizar = {}
			--varGlobal.personalizar.professor = {id=telas.idAluno1,nome=tostring(varGlobal.NomeLogin1),cursos={"HAB Curso 1"},textoPalavras = textoPalavrasDaPagina}
			--varGlobal.personalizar.conteudista = {id=telas.idAluno1,nome=tostring(varGlobal.NomeLogin1),cursos={"HAB Curso 1"},textoPalavras = textoPalavrasDaPagina}
			--varGlobal.personalizar.aluno = {id=telas.idAluno1,nome=tostring(varGlobal.NomeLogin1),cursos={"HAB Curso 1"},textoPalavras = textoPalavrasDaPagina}
			if varGlobal.personalizar then
				if Var.botoes then
					for bot=1,#Var.botoes do
						if telas[i].botoes[bot].acao and #telas[i].botoes[bot].acao > 0  and telas[i].botoes[bot].acao[1] == "selecionar material" then
							Var.botoes[bot].selecionarMaterial = function()
								Pcurses.selecionarMaterial(varGlobal,Var)
							end
						end
					end
				end
				if varGlobal.personalizar.professor then
					--telas.pagina
					--telas.paginaHistorico
					Var.menuProfessor = Pcurses.criarMenuPersonalizacaoProfessor(
						{
							retangulo = Var.retanguloMenu,
							vetor = varGlobal.personalizar.professor,
							tela = telas,
							varGlobal = varGlobal
						},
						Var
					)
					Var.menuProfessor.x = Var.retanguloMenu.x
					Var.menuProfessor.y = Var.retanguloMenu.y - Var.menuProfessor.height/2 - 5
				elseif varGlobal.personalizar.conteudista then
					Var.menuConteudista = Pcurses.criarMenuPersonalizacaoConteudista(
						{
							retangulo = Var.retanguloMenu,
							vetor = varGlobal.personalizar.conteudista,
							tela = telas,
							varGlobal = varGlobal
						},
						Var
					)
					Var.menuConteudista.x = Var.retanguloMenu.x
					Var.menuConteudista.y = Var.retanguloMenu.y - Var.menuConteudista.height/2 - 5
				elseif varGlobal.personalizar.aluno then
					Var.menuAluno = Pcurses.criarMenuPersonalizacaoAluno(
						{
							retangulo = Var.retanguloMenu,
							vetor = varGlobal.personalizar.aluno,
							tela = telas,
							varGlobal = varGlobal
						},
						Var
					)
					Var.menuAluno.x = Var.retanguloMenu.x
					Var.menuAluno.y = Var.retanguloMenu.y - Var.menuAluno.height/2 - 5
				end
			else
				criarMenuInferiorPadrao()
			end
			
			varGlobal.limiteTela = varGlobal.limiteTela + 300
			if varGlobal.preferenciasGerais.ativarLogin == "nao" then
				funcGlobal.modificarLimiteTela(GRUPOGERAL)
			end
			if Var.anotComInterface then
				local grupoComentarioAberto = display.newGroup()
				grupoComentarioAberto:insert(Var.anotComInterface)
			end
		end
	else
		--------------------------------------
		-- criando página bloqueada ----------
		--------------------------------------

		Var.grupoBloqueioPagina = display.newGroup()
		
		local retanguloBloqueioPagina = display.newRoundedRect(Var.grupoBloqueioPagina,W/2,0,600,300,20)
		retanguloBloqueioPagina:setFillColor(46/255,171/255,200/255)
		retanguloBloqueioPagina.anchorY=0
		local contato = ""
		local linkcontato = nil
		if varGlobal.preferenciasGerais.contatoBloqueio then
			contato = "\ncontatar com:"
		end
		if varGlobal.preferenciasGerais.linkContato then
			linkcontato = varGlobal.preferenciasGerais.linkContato
		end
		local options = {
			text = "Me desculpe!\nEsta página está bloqueada!"..contato,
			font = "Fontes/segoeui.ttf",
			fontSize = 40,
			y = retanguloBloqueioPagina.y,
			x = W/2,
			align = "center",
			width = 580,
		}
		if contato == "" then
			options.text = "Me desculpe!\nEsta página está bloqueada!\n\n Entre com a senha para desbloquear:"
		end
		local textoBloqueioPagina = display.newText(options)
		textoBloqueioPagina:setFillColor(0,0,0)
		textoBloqueioPagina.anchorY=0
		Var.grupoBloqueioPagina:insert(textoBloqueioPagina)
		
		if contato ~= "" then
			local options2 = {
				text = varGlobal.preferenciasGerais.contatoBloqueio,
				y = textoBloqueioPagina.y + textoBloqueioPagina.height + 20,
				x = W/2,
				font = "segoeui.ttf",
				align = "center",
				width = 580,
				fontSize = 40
			}
			textoBloqueioPagina.contato = display.newText(options2)
			textoBloqueioPagina.contato.anchorY=0
			textoBloqueioPagina.contato:setFillColor(1,1,1)
			Var.grupoBloqueioPagina:insert(textoBloqueioPagina.contato)
		end
		
		local heightSenha = 0
		if paginaBloqueada[2] then
			local Y = textoBloqueioPagina.y + textoBloqueioPagina.height
			if textoBloqueioPagina.contato then Y = textoBloqueioPagina.contato.height + textoBloqueioPagina.contato.y end
			local options2 = {
				text = "Entre com a senha para desbloquear:",
				y = Y + 20,
				x = W/2,
				font = "segoeui.ttf",
				align = "center",
				width = 580,
				fontSize = 40
			}
			local textoBloqueioSenha = display.newText(options2)
			textoBloqueioSenha.anchorY=0
			textoBloqueioSenha:setFillColor(1,1,1)
			Var.grupoBloqueioPagina:insert(textoBloqueioSenha)
			local YAux = textoBloqueioSenha.height + textoBloqueioSenha.y
			local campoSenhaFundo = display.newRect(Var.grupoBloqueioPagina,W/2, YAux + 40 + 20, 2*W/3, 80)
			local campoSenha = native.newTextField(W/2, campoSenhaFundo.y, 2*W/3, 80)
			Var.grupoBloqueioPagina:insert(campoSenhaFundo)
			Var.grupoBloqueioPagina:insert(campoSenha)
			heightSenha = campoSenhaFundo.height + textoBloqueioSenha.height + 20 + 20
			local function textListenerSenha( event )
				if ( event.phase == "began" ) then
					Var.grupoBloqueioPagina.telaProtetiva = auxFuncs.TelaProtetiva()
					Var.grupoBloqueioPagina:insert(Var.grupoBloqueioPagina.telaProtetiva)
					Var.grupoBloqueioPagina:insert(campoSenhaFundo)
					Var.grupoBloqueioPagina:insert(campoSenha)
					textoBloqueioSenha.y = -200
					textoBloqueioSenha:setFillColor(0,0,0)
					campoSenhaFundo.y = textoBloqueioSenha.y + textoBloqueioSenha.height + campoSenhaFundo.height/2
					campoSenha.y = campoSenhaFundo.y
					Var.grupoBloqueioPagina.telaProtetiva:addEventListener("tap",function() native.setKeyboardFocus(nil) end)
					Var.grupoBloqueioPagina.telaProtetiva:addEventListener("touch",function() native.setKeyboardFocus(nil) end)
				elseif event.phase == "ended" then
					if Var.grupoBloqueioPagina.telaProtetiva then
						Var.grupoBloqueioPagina.telaProtetiva:removeSelf()
						Var.grupoBloqueioPagina.telaProtetiva = nil
					end
					textoBloqueioSenha:setFillColor(1,1,1)
					textoBloqueioSenha.y = Y + 20
					campoSenhaFundo.y = YAux + 40 + 20
					campoSenha.y = campoSenhaFundo.y
				elseif event.phase == "submitted" then
					if paginaBloqueada[2] and paginaBloqueada[2] == tostring(campoSenha.text) then
						local subPagina = telas.subPagina
						local subtipo = telas.dicionario
						historicoLib.Criar_e_salvar_vetor_historico({
							tipoInteracao = "clearance",
							acao = "desbloquear",
							pagina_livro = telas.pagina,
							objeto = "pagina",
							subPagina = subPagina,
							subTipo = subtipo,
							tela = telas
						})
						auxFuncs.criarTxTDoc("senhaDesbloqueio.txt",tostring(campoSenha.text))
						criarCursoAux(telas,telas.pagina)
					else
						if Var.grupoBloqueioPagina.telaProtetiva then
							Var.grupoBloqueioPagina.telaProtetiva:removeSelf()
							Var.grupoBloqueioPagina.telaProtetiva = nil
						end
						textoBloqueioSenha:setFillColor(1,1,1)
						textoBloqueioSenha.y = Y + 20
						campoSenhaFundo.y = YAux + 40 + 20
						campoSenha.y = campoSenhaFundo.y
						native.setKeyboardFocus(nil)
						native.showAlert("Atenção","A senha colocada está incorreta!",{"OK"})
					end
				end
			end
			campoSenha.isSecure = true
			campoSenha:addEventListener( "userInput", textListenerSenha )
			campoSenha.placeholder = "senha"
		end
		if not textoBloqueioPagina.contato then textoBloqueioPagina.contato = {}; textoBloqueioPagina.contato.height = 0 end
		retanguloBloqueioPagina.height = textoBloqueioPagina.height+ textoBloqueioPagina.contato.height + 40 + 20 + heightSenha
		textoBloqueioPagina.y = retanguloBloqueioPagina.y + 20
		if linkcontato then
			textoBloqueioPagina.contato:setFillColor(0,0,1)
			textoBloqueioPagina.contato:addEventListener("tap",function()system.openURL(linkcontato);end)
		end
		Var.grupoBloqueioPagina.y = 200 + Var.grupoBloqueioPagina.height/2
		
		
		local options = {
			text = "",
			font = "Fontes/segoeui.ttf",
			fontSize = 40,
			y = retanguloBloqueioPagina.y + retanguloBloqueioPagina.height + 50,
			x = W/2,
			align = "center",
			width = 580,
		}
		local textoMensagemExtra = display.newText(options)
		textoMensagemExtra:setFillColor(0,0,0)
		textoMensagemExtra.anchorY=0
		Var.grupoBloqueioPagina:insert(textoMensagemExtra)
		GRUPOGERAL:insert(Var.grupoBloqueioPagina)
		
		local mensagemDeBloqueio = ""
		
		local parameters = {}
		parameters.body = "livro_id=" .. varGlobal.idLivro1 .. "&usuario_id=" .. varGlobal.idAluno1
		local URL = "https://omniscience42.com/EAudioBookDB/verificarPermissaoAcessoLivro.php"
		local function lerMensagemBloqueioSeTiver(event)
		   if ( event.isError ) then
			  print( "Network error! Conexão instável, atualize a página para receber a mensagem de bloqueio novamente.")
			  textoMensagemExtra.text = "Conexão instável, atualize a página para receber a mensagem de bloqueio novamente."
		   else
			  print("Mensagem de bloqueio recebida:",event.response)
			  local data2 = json.decode(event.response)
			  if data2 then
				if data2.mensagemBloqueio then
					print("Mensagem de bloqueio:",data2.mensagemBloqueio)
					textoMensagemExtra.text = data2.mensagemBloqueio
					
				else
					print("Não foi possível ler uma mensagem de bloqueio")
				end
			  end
		   end
		end 
		network.request(URL, "POST", lerMensagemBloqueioSeTiver,parameters)
		
		
		if Var.telaMovedora then Var.telaMovedora:removeSelf(); Var.telaMovedora = nil; end
		Var.telaMovedora = display.newRect(0,0,0,0)
		Var.telaMovedora.width = W;Var.telaMovedora.height = GRUPOGERAL.height
		Var.telaMovedora.y = GRUPOGERAL.y
		Var.telaMovedora.x = GRUPOGERAL.x;Var.telaMovedora.y = 0
		Var.telaMovedora.anchorX=0;Var.telaMovedora.anchorY=0;
		Var.telaMovedora:setFillColor(1,0,0)
		Var.telaMovedora.alpha = 0; Var.telaMovedora.isHitTestable = true
		if varGlobal.limiteTela < 1280 then
			--Var.telaMovedora.height = 1270
		end
		if system.orientation == "landscapeLeft" or system.orientation == "landscapeRight" then
			Var.telaMovedora.x = 0
		end
		GRUPOGERAL:insert(Var.telaMovedora)



		if travarOrientacaoLado == true then
			system.orientation = "landscapeRight";-- deletar!!!!!!!!!!!!!!!!!!!!!!!!!
			--girarTelaOrientacao(GRUPOGERAL)-- deletar!!!!!!!!!!!!!!!!!!!!!!!!!
			--girarTelaOrientacao(GRUPOSOM)-- deletar!!!!!!!!!!!!!!!!!!!!!!!!!
		else
			Runtime:addEventListener("orientation",function() girarTelaOrientacao(GRUPOGERAL) end)-- arrumar!!!!!!!!!!!!!!!!!!!!!!!!!
			Runtime:addEventListener("orientation",function() girarTelaOrientacao(GRUPOSOM) end)-- arrumar!!!!!!!!!!!!!!!!!!!!!!!!!
		end
		GRUPOGERALORIGINX = GRUPOGERAL.x
		GRUPOGERALORIGINY =	GRUPOGERAL.y
		--varGlobal.limiteTela = varGlobal.limiteTela + 100
		--GRUPOGERAL.anchorX=0;GRUPOGERAL.anchorY=0.5
		--GRUPOGERAL:addEventListener("touch",ZOOMZOOMZOOM)
	
		-- Baixar e criar anotações --
			-- Baixar e criar anotações --
			telas.ativarLogin = varGlobal.preferenciasGerais.ativarLogin
			
			--funcGlobal.criarAnotacoesComentarios(pagina,telas)
			
			Var.retanguloMenu = display.newRoundedRect(0,0,W-250,100,10)
			Var.retanguloMenu.anchorX=0.5
			Var.retanguloMenu.anchorY=1
			Var.retanguloMenu.alpha = .9
			Var.retanguloMenu:setFillColor(40/255,189/255,226/255)
			Var.retanguloMenu.fill.effect = "filter.blurGaussian"
			Var.retanguloMenu.fill.effect.horizontal.blurSize = 20
			Var.retanguloMenu.fill.effect.horizontal.sigma = 140
			Var.retanguloMenu.fill.effect.vertical.blurSize = 20
			Var.retanguloMenu.fill.effect.vertical.sigma = 140
			Var.retanguloMenu.x = W/2
			Var.retanguloMenu.y = H - 50
			Var.retanguloMenu.yScale = .8
			Var.retanguloMenu:addEventListener("touch",function() return true end)
			Var.retanguloMenu:addEventListener("tap",function() return true end)
			
			local function criarMenuInferiorPadrao()
			
				elemTela.criarAnotacoesComentarios(pagina,telas,Var,varGlobal)
				Var.anotComInterface.isVisible = false
				Var.anotComInterface.y = H- Var.anotComInterface.Icone.height - 5
				Var.anotComInterface.x = Var.retanguloMenu.x - Var.anotComInterface.width/2 - Var.retanguloMenu.width/2 + Var.anotComInterface.width/2
				local pasta = string.gsub(varGlobal.enderecoArquivos,"/Outros Arquivos","")
				Var.anotComInterface.Icone.yScale =  Var.anotComInterface.height * .8
				
				Var.Impressao = elemTela.criarBotaoImpressao(pagina,telas,Var,varGlobal,GRUPOGERAL)
				--funcGlobal.criarBotaoImpressao(pagina,telas)
				Var.Impressao.y = Var.retanguloMenu.y - Var.Impressao.botao.height*0.8 - 10
				Var.anotComInterface.y = Var.retanguloMenu.y - Var.Impressao.botao.height*0.8 - 10
				Var.anotComInterface.Icone.yScale = .8
				Var.Impressao.x = Var.anotComInterface.x + Var.anotComInterface.Icone.width + 20
				Var.Impressao.botao.yScale = .8
				
				Var.Relatorio = elemTela.criarBotaoRelatorio(pagina,telas,Var,varGlobal)
				--Var.Relatorio = funcGlobal.criarBotaoRelatorio(pagina,telas)
				Var.Relatorio.y = Var.Impressao.y
				Var.Relatorio.x = Var.Impressao.x + Var.Impressao.botao.x + Var.Impressao.botao.width + 10
				Var.Relatorio.botao.yScale = .8
				
				
				--GRUPOGERAL:insert(Var.Impressao)
				--GRUPOGERAL:insert(Var.Relatorio)
				if telas[pagina].dicionario and #telas[pagina].dicionario and #telas[pagina].dicionario >=1 then
					Var.temHistorico = varGlobal.temHistorico
					Var.pagina = pagina
					Var.Dicionario = elemTela.criarDicionarioPagina(pagina,telas,pasta,Var)
					Var.Dicionario.isVisible = false
					Var.Dicionario.y = Var.Impressao.y -- Var.Impressao.botao.height/2
					Var.Dicionario.x = Var.Relatorio.x + Var.Relatorio.botao.width + 10
					Var.Dicionario.botao.yScale = .8
					Var.Dicionario.botao.botaoLRight.yScale = .8
					Var.Dicionario.botao.botaoLLeft.yScale = .8
					--GRUPOGERAL:insert(Var.Dicionario)
				end
				if not Var.TTSDicionario and Var.Dicionario then
					Var.TTSDicionario = {}
					
					Var.TTSDicionario = elemTela.criarBotaoTTSDicionario({pagina = paginaHistorico,tipo = varGlobal.TTSTipo,APIkey = APIkey.thithou1,idioma = varGlobal.TTSVozIdioma,voz = varGlobal.TTSVoz,velocidade = varGlobal.VelocidadeTTS,neural = varGlobal.TTSNeural, qualidade = "12khz_16bit_mono",extencao = varGlobal.extensao, diretorioBase = system.DocumentsDirectory,tapResponse = "audioTTSBotaoDicionario.mp3",audioSemNet = varGlobal.botaoSemInternetTTS,pastaArquivos = "Dicionario Palavras/Outros Arquivos",pasta = pasta,somBotao1 = varGlobal.ttsDicionario1Clique,temHistorico = varGlobal.temHistorico},Var)
					Var.TTSDicionario.isVisible = false
					--Var.TTSDicionario.isVisible = false
				end
				if Var.Dicionario and Var.Dicionario.vetorFinalPalavrasTxTs then
					Var.TTSDicionario.vetorPalavrasTxTs = Var.Dicionario.vetorFinalPalavrasTxTs--vetorOriginalPalavrasTxT
				end
				
				if varGlobal.preferenciasGerais.ativarLogin == "nao" then
					funcGlobal.modificarLimiteTela(GRUPOGERAL)
				end
				local grupoComentarioAberto = display.newGroup()
				grupoComentarioAberto:insert(Var.anotComInterface)
			end
			criarMenuInferiorPadrao()
			
			varGlobal.limiteTela = varGlobal.limiteTela + 300
	end
	local function gravarCoordenada(e)
		GRUPOGERAL.Ytoque = e.y
		--print("clicou",e.y)
	end
	GRUPOGERAL:addEventListener("tap",gravarCoordenada)
	
	-- calcular posição na pagina para quando aumentar o texto --
	
	local Ytoque = 0
	if GRUPOGERAL.Ytoque then
		Ytoque = GRUPOGERAL.Ytoque
	end
	
	GRUPOGERAL.auxGGeral = 0
	if GRUPOGERAL.tamanhoAnterior then
		GRUPOGERAL.auxGGeral = varGlobal.limiteTela - GRUPOGERAL.tamanhoAnterior
		--print("tamanhoAnterior",GRUPOGERAL.tamanhoAnterior)
	end
	--print("auxGGeral",auxGGeral)
	
	if GRUPOGERAL.YPagina[pagina] then
		if #vetorVoltar-1 > 0 then
			if pagina ~= GRUPOGERAL.ultimaPagina and GRUPOGERAL.YPagina and GRUPOGERAL.YPagina[pagina] then
				if system.orientation == "portrait" then
					transition.to(GRUPOGERAL,{y = GRUPOGERAL.YPagina[pagina],time = 0})
				elseif system.orientation == "landscapeLeft" then
					transition.to(GRUPOGERAL,{x = GRUPOGERAL.YPagina[pagina]*varGlobal.aumentoProp,time = 0})
				elseif system.orientation == "landscapeRight" then
					transition.to(GRUPOGERAL,{x = W-GRUPOGERAL.YPagina[pagina]*varGlobal.aumentoProp,time = 0})
				end
			end
		end
	else
		GRUPOGERAL.y = 0
		GRUPOGERAL.YPagina[pagina] = 0
	end
	
	if GRUPOGERAL.ultimaPagina == pagina then
		if system.orientation == "portrait" then
			if GRUPOGERAL.auxGGeral >= 0 then
				transition.to(GRUPOGERAL,{y = GRUPOGERAL.y - Ytoque,time = 0})
				--GRUPOGERAL.y = GRUPOGERAL.y - Ytoque - auxGGeral + H/2
				-- print("auxGGeral",auxGGeral)
				-- print(GRUPOGERAL.y,"NOVO")
				-- print(varGlobal.limiteTela)
				if GRUPOGERAL.y > 0 then
					--GRUPOGERAL.y = 0
				elseif GRUPOGERAL.y < -(varGlobal.limiteTela - H) then
					
					--GRUPOGERAL.y = -(varGlobal.limiteTela - H)
				end
			else
				--GRUPOGERAL.y = GRUPOGERAL.y --+  Ytoque
				if GRUPOGERAL.y > 0 then
					GRUPOGERAL.y = 0
				elseif GRUPOGERAL.y < -(varGlobal.limiteTela - H)then
					
					GRUPOGERAL.y = -(varGlobal.limiteTela - H)
				end
			end
		end
	end
	print("DEPOIS")
	print("GRUPOGERAL.y",GRUPOGERAL.y)
	print("tamanhoNovo",varGlobal.limiteTela)

	GRUPOGERAL.ultimaPagina = pagina
	GRUPOGERAL.tamanhoAnterior = varGlobal.limiteTela
	-------------------------------------------------------------
	-- criar imagem de um grupo --
	--display.save( GRUPOGERAL, { filename="entireGroup.png", baseDir=system.DocumentsDirectory, captureOffscreenArea=true, backgroundColor={1,1,1,0} } )
	------------------------------
	GRUPOGERAL.limiteAumentado = false
	
	
	
	if telas[pagina] and telas[pagina].imagem and not (telas[pagina].texto or telas[pagina].textos or telas[pagina].imagens or telas[pagina].imagemTexto or telas[pagina].imagemTextos or telas[pagina].exercicio or telas[pagina].exercicios or telas[pagina].separador or telas[pagina].separadores or telas[pagina].botao or telas[pagina].botoes or telas[pagina].animacao or telas[pagina].animacoes or telas[pagina].video or telas[pagina].videos or telas[pagina].som or telas[pagina].sons) then
		GRUPOGERAL.dots = {}
		GRUPOGERAL.touch = touch
		GRUPOGERAL.telas = telas
		GRUPOGERAL:addEventListener("touch")
		criouZoomDeTela = true
	else
		if criouZoomDeTela == true then
			GRUPOGERAL:removeEventListener("touch")
		end
		if grupoRects then
			while grupoRects.numChildren > 0 do
				local child = grupoRects[1]
				if child then child:removeSelf(); child = nil end
				print("middleGroup.numChildren" , grupoRects.numChildren )
			end
		end
		
		GRUPOGERAL:addEventListener("touch",MoverATela)
		criouZoomDeTela = false
		
		
	end
	if system.orientation ~= "portrait" then
		GRUPOGERAL.girarImediato = true
	else
		GRUPOGERAL.girarImediato = false
	end
	--------------------------------
	-- VERIFICAR EXERCICIO ABERTO --
	--------------------------------
	if Var.eXercicios and varGlobal.exercicioAberto and varGlobal.exercicioAberto.pagina and varGlobal.exercicioAberto.numero then
		for i=1,#varGlobal.exercicioAberto.pagina do
			for exes=1,#Var.eXercicios do
				if varGlobal.exercicioAberto.pagina[i] == pagina and varGlobal.exercicioAberto.numero[i] == Var.eXercicios[exes][5].contExerc then
					local vetor = {}
					vetor.target = {}
					vetor.target.tempo = Var.eXercicios[exes][5].tempo
					vetor.target.numero = Var.eXercicios[exes][5].numero
					vetor.target.contExerc =  Var.eXercicios[exes][5].contExerc
					vetor.target.index = Var.eXercicios[exes][5].index
					vetor.target.HH =  Var.eXercicios[exes][5].HH
					vetor.naoHistorico = true
					Var.eXercicios[exes].abriu = false
					Var.eXercicios[exes].nSalvarAbrir = true
					Var.eXercicios[exes][5].abrirFecharExercicio(vetor)
					timer.performWithDelay(1000,
						function()
							if Var.eXercicios and Var.eXercicios[exes] then
								varGlobal.limiteTela = varGlobal.limiteTela + Var.eXercicios[exes][5].HH*1 
							end
						end
					,1)
					--timer.performWithDelay(2000,function() funcGlobal.abrirFecharExercicio(vetor)end,1)
				end
			end
		end
	else
		varGlobal.WindowsDireita.height,varGlobal.WindowsEsquerda.height = varGlobal.limiteTela,varGlobal.limiteTela
	end
	
	
	
	if system.orientation ~= "portrait" then
		girarTelaOrientacao(GRUPOGERAL)
	end
	
	-- TRACKING DE TEMPO PAGINA --
	if vetorVoltar[#vetorVoltar - 1] and vetorVoltar[#vetorVoltar - 1] ~= pagina then
		if varGlobal.tempoAbertoPagina then
			timer.cancel(varGlobal.tempoAbertoPagina)
		end
	
		varGlobal.tempoAbertoPaginaNumero = 0
		varGlobal.tempoAbertoPagina = timer.performWithDelay(100,function() varGlobal.tempoAbertoPaginaNumero = varGlobal.tempoAbertoPaginaNumero + 100 end,-1)
	elseif not vetorVoltar[#vetorVoltar - 1] then
		if varGlobal.tempoAbertoPagina then
			timer.cancel(varGlobal.tempoAbertoPagina)
		end
	
		varGlobal.tempoAbertoPaginaNumero = 0
		varGlobal.tempoAbertoPagina = timer.performWithDelay(100,function() varGlobal.tempoAbertoPaginaNumero = varGlobal.tempoAbertoPaginaNumero + 100 end,-1)
	end
	varGlobal.tempoAbertoDetalhesNumero = 0
	varGlobal.tempoAbertoZoomNumero = 0
	------------------------------
	
	-- adicionando botaoDireito e esquerdo com a variavel telas
	varGlobal.botaoDireito.telas = telas
	varGlobal.botaoEsquerdo.telas = telas
	
	Var.retanguloMovimento = display.newRect(0,0,0,0)
	Var.retanguloMovimento.anchorX=0;Var.retanguloMovimento.anchorY=0
	Var.retanguloMovimento.alpha=0
	Var.retanguloMovimento.isHitTestable=true
	Var.retanguloMovimento.height = varGlobal.limiteTela
	Var.retanguloMovimento.width = W
	if Var.retanguloMovimento.height < H then Var.retanguloMovimento.height = H end
	GRUPOGERAL:insert(1,Var.retanguloMovimento)
	local posicaoBarra = telas.pagina
	if tonumber(telas.pagina) then
		if telas.pagina < telas.numeroTotal.Todas then
			posicaoBarra = posicaoBarra - 1
		end
		varGlobal.VetorBotoesBarra.meuSlider.updatePosition(posicaoBarra)
	end
	-- zerar variáveis marcadas --
	if telas.localizar then 
		telas.localizar = nil
	end
	------------------------------
end
M.criarCursoAux = criarCursoAux

--------------------------------------------------
--	FUNCOES AUXILIARES							--
--------------------------------------------------
function funcGlobal.requisitarTTSOnline(atrib)
	local request
	if atrib.tipo == "RSS" then
		local url = "https://api.voicerss.org/?key="..APIkey.thithou1.."&hl="..atrib.idioma.."&c="..atrib.extensao.."&r=-1".."&f="..atrib.qualidade.."&src="..atrib.texto
		request = network.request( url, "GET", atrib.funcao,  atrib.params ) 
		
	elseif atrib.tipo == "AWS" then
		atrib.params.body= "Voz="..atrib.voz.."&Texto="..atrib.texto.."&Neural="..varGlobal.TTSNeural
		local URL2 = "https://omniscience42.com/EAudioBookDB/pollyTTS.php"
		request = network.request(URL2, "POST", atrib.funcao ,atrib.params)
	end
	return request
end

function funcGlobal.downloadArquivo(arquivo,link,funcao)
	 
	local params = {}
	params.progress = false
	 
	network.download(
		--link.."/avatares/"..arquivo,
		link.."/"..arquivo,
		"GET",
		funcao,
		params,
		arquivo,
		system.TemporaryDirectory
	)
	-- "https://www.coronasdkgames.com/libEA 2"
end
M.downloadArquivo = funcGlobal.downloadArquivo

local function criarArquivoTXT(atributos) -- vetor ou variavel
	local caminho2 = atributos.caminho .. "/"..atributos.arquivo
	local file2,errorString = io.open( caminho2, "w" )
	if not file2 then
			print( "File error: " .. errorString )
	else
		if atributos.vetor then
			for i=1,#atributos.vetor do
				file2:write(atributos.vetor[i])
				if i ~= #atributos.vetor then
					file2:write("\n")
				end
			end
		elseif atributos.variavel then
			file2:write(atributos.variavel)
		end
		io.close( file2 )
	end
	file2 = nil
end

local function lerArquivoTXT(atributos) -- vetor ou variavel

	local caminho2 = atributos.caminho .. "/"..atributos.arquivo
		
	local file2, errorString = io.open( caminho2, "r" )
	local vetor = {}
	local texto = ""
	local xx = 0
	if atributos.tipo == "vetor" then
		if not file2 then
			print( "File error: " .. errorString )
		else
			-- Output lines
			local contents = file2:read( "*a" )
			local filtrado = string.gsub(contents,".",{ ["\13"] = "",["\10"] = "\13\10"})
			for line in string.gmatch(filtrado,"([^\13\10]+)") do
				if string.len(line)>1 then
					for past in string.gmatch(line, '([A-Za-z0-9?!@#$=%&"[-]:;/.,\\_+-*ÂÃÁ ÀÉÊÍÎÕÔÓÚÜ%âãáàéêíîõôóúü%(%)]+)') do
						line = past
					end
					table.insert(vetor,line)
					xx = xx+1
				end
			end
			for i=1,#vetor do
				if i~= #vetor then
					if varGlobal.tipoSistema == "android" then
						--vetor[i] = vetor[i]:sub(1, #vetor[i] - 1)
					end
				end
			end
			io.close( file2 )
			file2 = nil
		end
		return vetor
	elseif atributos.tipo == "texto" then

		if not file2 then
			print( "File error: " .. errorString )
		else
			texto = file2:read( "*a" )

			io.close( file2 )
			file2 = nil
			return texto
		end
	else 
		if file2 then
			io.close( file2 )
			file2 = nil
		end
		return "defina um tipo (texto ou vetor)"
	end
	
end
M.lerArquivoTXT = lerArquivoTXT
function funcGlobal.lerArquivoTXT2(atributos) -- vetor ou variavel

	local caminho2 = atributos.caminho
	print(caminho2)
	local file2, errorString = io.open( caminho2, "r" )
	local vetor = {}
	local texto = ""
	local xx = 0
	if atributos.tipo == "vetor" then
		if not file2 then
			print( "File error: " .. errorString )
		else
			-- Output lines
			local contents = file2:read( "*a" )
			local filtrado = string.gsub(contents,".",{ ["\13"] = "",["\10"] = "\13\10"})
			for line in string.gmatch(filtrado,"([^\13\10]+)") do
				if string.len(line)>1 then
					for past in string.gmatch(line, '([A-Za-z0-9?!@#$=%&"[-]:;/.,\\_+-*ÂÃÁ ÀÉÊÍÎÕÔÓÚÜâãáàéêíîõôóúü%(%)]+)') do
						line = past 
						
					end
					table.insert(vetor,line)
					xx = xx+1
				end
			end
			for i=1,#vetor do
				if i~= #vetor then
					if varGlobal.tipoSistema == "android" then
						--vetor[i] = vetor[i]:sub(1, #vetor[i] - 1)
					end
				end
			end
			io.close( file2 )
			file2 = nil
		end
		return vetor
	elseif atributos.tipo == "texto" then

		if not file2 then
			print( "File error: " .. errorString )
		else
			texto = file2:read( "*a" )

			io.close( file2 )
			file2 = nil
			return texto
		end
	else 
		if file2 then
			io.close( file2 )
			file2 = nil
		end
		return "defina um tipo (texto ou vetor)"
	end
	
end
M.lerArquivoTXT2 = lerArquivoTXT2


local function alphanumsort(o)
  local function padnum(d) local dec, n = string.match(d, "(%.?)0*(.+)")
    return #dec > 0 and ("%.12f"):format(d) or ("%s%03d%s"):format(dec, #n, n) end
  table.sort(o, function(a,b)
    return string.lower(tostring(a):gsub("%.?%d+",padnum)..("%3d"):format(#b))
         <  string.lower(tostring(b):gsub("%.?%d+",padnum)..("%3d"):format(#a)) end)
  return o
end


local function naoVazio(s)
  return s ~= nil or s ~= ''
end

local function juntarListas(l1,l2)
    for i=1,#l2 do
        l1[#l1+1] = l2[i]
    end
    return l1
end

local function verificaAcaoBotao( acao ,telas,paginaIndice)
	
	if type(acao) == "table" then
		GRUPOGERAL.subPagina = nil
		paginaAtual = acao.numero
		criarCursoAux(telas, paginaAtual)
	else
		GRUPOGERAL.subPagina = nil
		if (acao=="iniciaPagina" and toqueHabilitado == true) then
			criarCursoAux(telas, paginaAtual)
			respostasfalsasAtivadas = false
		end
		if (acao=="iniciaCurso" and toqueHabilitado == true) then
			criarCursoAux(telas, 1)
			paginaAtual=1
		end
		print("verificando Ação do Botão")
		if (acao=="indice") then
			--[[for i =1,#telas do
				print("telas:" .. i)
				if telas[i].indiceImagem or telas[i].indiceTexto then
					print("telas com indice:" .. i)
					criarCursoAux(telas, i)
					paginaAtual=i
					return true
				end
			end]]
			GRUPOGERAL.x = GRUPOGERALORIGINX
			GRUPOGERAL.y = GRUPOGERALORIGINY
			if paginaIndice then
				
				paginaAtual=paginaIndice
				criarCursoAux(telas, paginaIndice)
			else
				paginaAtual=1
				criarCursoAux(telas, 1)
			end
			
		end 
	end
end

------------------------------------------------------------------
--	CRIAR INDICE APARTIR DE ARQUIVOS - auxiliar do indice Manual--
------------------------------------------------------------------
funcGlobal.criarIndicedeArquivo = leituraTXT.criarIndicedeArquivo
funcGlobal.criarIndicesDeArquivoConfig = leituraTXT.criarIndicesDeArquivoConfig


------------------------------------------------------------------
--CRIAR SOM APARTIR DE ARQUIVO --------------------------------
------------------------------------------------------------------
funcGlobal.criarSonsDeArquivoPadraoAux = leituraTXT.criarSonsDeArquivoPadraoAux
funcGlobal.criarSonsDeArquivoPadrao = leituraTXT.criarSonsDeArquivoPadrao

------------------------------------------------------------------
--CRIAR VIDEO APARTIR DE ARQUIVO --------------------------------
------------------------------------------------------------------
funcGlobal.criarVideosDeArquivoPadraoAux = leituraTXT.criarVideosDeArquivoPadraoAux
funcGlobal.criarVideosDeArquivoPadrao = leituraTXT.criarVideosDeArquivoPadrao

------------------------------------------------------------------
--CRIAR IMAGEM APARTIR DE ARQUIVO --------------------------------
------------------------------------------------------------------
funcGlobal.criarImagensDeArquivoPadraoAux = leituraTXT.criarImagensDeArquivoPadraoAux
funcGlobal.criarImagensDeArquivoPadrao = leituraTXT.criarImagensDeArquivoPadrao

------------------------------------------------------------------
--CRIAR TEXTO APARTIR DE ARQUIVO --------------------------------
------------------------------------------------------------------
funcGlobal.criarTextosDeArquivoPadraoAux = leituraTXT.criarTextosDeArquivoPadraoAux
funcGlobal.criarTextosDeArquivoPadrao = leituraTXT.criarTextosDeArquivoPadrao

------------------------------------------------------------------
--CRIAR BOTÃO APARTIR DE ARQUIVO ---------------------------------
------------------------------------------------------------------
funcGlobal.criarBotoesDeArquivoPadraoAux = leituraTXT.criarBotoesDeArquivoPadraoAux
funcGlobal.criarBotoesDeArquivoPadrao = leituraTXT.criarBotoesDeArquivoPadrao

------------------------------------------------------------------
--CRIAR EXERCICIO APARTIR DE ARQUIVO -----------------------------
------------------------------------------------------------------
funcGlobal.criarExerciciosDeArquivoPadraoAux = leituraTXT.criarExerciciosDeArquivoPadraoAux
funcGlobal.criarExerciciosDeArquivoPadrao = leituraTXT.criarExerciciosDeArquivoPadrao

------------------------------------------------------------------
--CRIAR ANIMAÇÃO APARTIR DE ARQUIVOS 							--
------------------------------------------------------------------
funcGlobal.criarAnimacoesDeArquivoConfig = leituraTXT.criarAnimacoesDeArquivoConfig
funcGlobal.criarAnimacoesDeArquivoPadraoAux = leituraTXT.criarAnimacoesDeArquivoPadraoAux
funcGlobal.criarAnimacoesDeArquivoPadrao = leituraTXT.criarAnimacoesDeArquivoPadrao

------------------------------------------------------------------
--CRIAR ESPAÇO APARTIR DE ARQUIVOS -------------------------------
------------------------------------------------------------------
funcGlobal.criarEspacoDeArquivoPadraoAux = leituraTXT.criarEspacoDeArquivoPadraoAux

------------------------------------------------------------------
--CRIAR SEPARADOR APARTIR DE ARQUIVOS ----------------------------
------------------------------------------------------------------
funcGlobal.criarSeparadorDeArquivoPadraoAux = leituraTXT.criarSeparadorDeArquivoPadraoAux
funcGlobal.criarSeparadoresDeArquivoPadrao = leituraTXT.criarSeparadoresDeArquivoPadrao

------------------------------------------------------------------
--CRIAR IMAGEM E TEXTO APARTIR DE ARQUIVOS -----------------------
------------------------------------------------------------------
funcGlobal.criarImagemTextosDeArquivoPadraoAux = leituraTXT.criarImagemTextosDeArquivoPadraoAux
funcGlobal.criarImagemTextosDeArquivoPadrao = leituraTXT.criarImagemTextosDeArquivoPadrao

local GRUPOINTERFACE = display.newGroup()
------------------------------------------------------------------
--	COLOCAR INDICE	PRÉ FORMATADO								--
--	Funcao responsavel por colocar um indice					--
--  na tela com link interno para outras paginas 				--
--  do curso.				 									--
--  ATRIBUTOS: titulo,alinhamento,tamanhoTitulo, cor, eNegrito	--
--	titulo = "MÁQUINA ELÉTRICA DE INDUÇÃO",
--  vetorTitulos = 
--		{	titulo = {texto,pagina},
--			subtitulo = {texto,pagina},
--			titulo = {texto,pagina}			}
--	tamanhoTexto, alinhamentoTexto, corTexto					--
------------------------------------------------------------------
local function colocarIndicePreMontado(atributos,telas,funcRetorno)

	if naoVazio(atributos) then
		GRUPOGERALORIGINX = GRUPOGERAL.x
		GRUPOGERALORIGINY = GRUPOGERAL.y

		local grupoIndice = display.newGroup()
		local optionsIndice = 
		{
		    text = "",
		    x = 0,
		    y = 100  + 80,
		    width = W-20,
		    height = 0,
		    font = "Fontes/ariblk.ttf",
		    fontSize = 40,
		    align = "center",
			alinhamento= "meio"
		}
		local options = 
		{
		    text = "",
		    x = 0,
		    y = 200,
		    width = W-20,
		    height = 0,
		    font = "Fontes/ariblk.ttf",
		    fontSize = 40,
		    align = "center"
		}
		--ALINHAMENTO ESQUERDA
		if(atributos.alinhamento=='esquerda') then
			optionsIndice.alinhamento = "esquerda"
		--ALINHAMENTO DIREITA
		elseif(atributos.alinhamento=='direita') then
			optionsIndice.alinhamento = "direita"
		--ALINHAMENTO MEIO
		elseif(atributos.alinhamento=='centro') or atributos.alinhamentoTexto=='meio'then
			optionsIndice.alinhamento = "meio"
		elseif(atributos.alinhamento=='justificado') then
			optionsIndice.alinhamento = "justificado"
		end
		--ALINHAMENTO ESQUERDA
		if(atributos.alinhamentoTexto=='esquerda') then
			options.align = "esquerda"
		--ALINHAMENTO DIREITA
		elseif(atributos.alinhamentoTexto=='direita') then
			options.align = "direita"
		--ALINHAMENTO MEIO
		elseif(atributos.alinhamentoTexto=='centro') or atributos.alinhamentoTexto=='meio' then
			options.align = "meio"
		elseif(atributos.alinhamentoTexto=='justificado') then
			options.align = "justificado"
		end
		if(atributos.titulo) then
			optionsIndice.text = atributos.titulo;
		end
		if(atributos.tamanhoTexto) then
			options.fontSize = atributos.tamanhoTexto;
		end
		if(atributos.tamanhoTitulo) then
			optionsIndice.fontSize = atributos.tamanhoTitulo;
		end
		if(atributos.eNegrito and atributos.eNegrito=='sim') then
			optionsIndice.font = "Fontes/ariblk.ttf"
		end
		local margem = 0
		if atributos.margem then
			margem = atributos.margem
		end
		local xNegativo = 0
		if atributos.x then
			if atributos.x < 0 then
				xNegativo = atributos.x
			end
		else
			atributos.x = 0
		end
		local largura = 720
		local red,green,blue
		if atributos.cor then
			red = (atributos.cor[1]/255)
			green = (atributos.cor[2]/255)
			blue = (atributos.cor[3]/255)
		else
			if PlanoDeFundoLibEA == "branco" then
				red,green,blue = 0,0,0
			else
				red,green,blue = 1,1,1
			end
		end
		local red2,green2,blue2
		if atributos.corTexto then
			red2 = (atributos.corTexto[1]/255)
			green2 = (atributos.corTexto[2]/255)
			blue2 = (atributos.corTexto[3]/255)
		else
			if PlanoDeFundoLibEA == "branco" then
				red2,green2,blue2 = 0,0,0
			else
				red2,green2,blue2 = 1,1,1
			end
		end
		
		if atributos.fonte then
			if string.find(atributos.fonte, ".ttf") ~= nil then
				optionsIndice.font = atributos.fonte
				options.font = atributos.fonte
			end
		end

		if atributos.y then
			optionsIndice.y = 100 + atributos.y + 80
		end
		
		--titulodoIndice = display.newText( optionsIndice ) 
		local colocarFormatacaoTexto = require "colocarFormatacaoTexto"
		
		--optionsIndice.text = conversor.converterANSIparaUTFsemBoom(optionsIndice.text)
		optionsIndice.text = string.gsub(optionsIndice.text,"\\n","\n")
		local titulodoIndice = colocarFormatacaoTexto.criarTextodePalavras({texto = optionsIndice.text,x = atributos.x,Y = optionsIndice.y,fonte = optionsIndice.font,tamanho = optionsIndice.fontSize,cor = {red,green,blue}, alinhamento = optionsIndice.alinhamento,margem = margem,xNegativo = xNegativo,largura = largura, endereco = varGlobal.enderecoArquivos,EhIndice = true,temHistorico = varGlobal.temHistorico})
		grupoIndice:insert(titulodoIndice)
		
		if optionsIndice.align == "right" then
			--local textinho = titulodoIndice.text
			--titulodoIndice.text = textinho .. " "
		end

		if(telas) then
			--print "Existe .telas"
			--print ("#telas = " .. #telas)	
		end
		
		local grupoTitulo = {}
		grupoTitulo.titulo = 0
		grupoTitulo.tituloMarcacao = 0
		grupoTitulo.subtituloTamanhos = {}
		grupoTitulo.subtitulo = 0
		grupoTitulo.subtituloMarcacao = 0
		grupoTitulo.subtitulo2Tamanhos = {}
		grupoTitulo.subtitulo2 = 0
		grupoTitulo.subtitulo2Marcacao = 0
		grupoTitulo.subtitulo3Tamanhos = {}
		
		local function displaySymbolSquare(atrib)
			local symbol = display.newGroup()
			
			symbol.squarePlus = display.newImageRect("plusSymbol.png",atrib.width,atrib.height)
			--symbol.squarePlus:setFillColor(atrib.color[1]/255,atrib.color[2]/255,atrib.color[3]/255)
			symbol.squarePlus.anchorY=0;symbol.squarePlus.anchorX=0
			symbol.squareMinus = display.newImageRect("minusSymbol.png",atrib.width,atrib.height)
			--symbol.squareMinus:setFillColor(0.5,atrib.color[2]/255,atrib.color[3]/255)
			symbol.squareMinus.anchorY=0;symbol.squareMinus.anchorX=0
			symbol.squareMinus.alpha = 0			
			
			symbol:insert(symbol.squarePlus)
			symbol:insert(symbol.squareMinus)
			return symbol
		end
		grupoIndice.textoFinalIndice = {}
		for i=1,#atributos.vetorTitulos do -- só para controle
			
			if i == 1 then 
				if atributos.vetorTitulos.indiceRemissivo then
					local texto = " "
					options.font = native.systemFontBold
					options.x = atributos.x
					options.width= W-20
					grupoTitulo.titulo = grupoTitulo.titulo + 1
					if grupoTitulo.tituloMarcacao > 0 then
						grupoTitulo.tituloMarcacaoAnt = grupoTitulo.tituloMarcacao
					end
					grupoTitulo.tituloMarcacao = i
					grupoTitulo.subtitulo = 0
					grupoTitulo.subtitulo2 = 0
					grupoTitulo.subtituloTamanhos = {}
					grupoTitulo.subtitulo2Tamanhos = {}
					grupoTitulo.subtitulo3Tamanhos = {}
				elseif atributos.vetorTitulos[i][1] == "titulo" then
					options.text = atributos.vetorTitulos[i][2]
					options.font = native.systemFontBold
					options.x = atributos.x
					options.width= W-20
					
					grupoTitulo.titulo = grupoTitulo.titulo + 1
					if grupoTitulo.tituloMarcacao > 0 then
						grupoTitulo.tituloMarcacaoAnt = grupoTitulo.tituloMarcacao
					end
					grupoTitulo.tituloMarcacao = i
					grupoTitulo.subtitulo = 0
					grupoTitulo.subtitulo2 = 0
					grupoTitulo.subtituloTamanhos = {}
					grupoTitulo.subtitulo2Tamanhos = {}
					grupoTitulo.subtitulo3Tamanhos = {}
				elseif atributos.vetorTitulos[i][1] == "subtitulo" then
					options.text = atributos.vetorTitulos[i][2]
					options.font = native.systemFont
					options.x = atributos.x + 50
					options.width = W-70
					grupoTitulo.subtitulo = grupoTitulo.subtitulo + 1
					grupoTitulo.subtituloMarcacao = i
					grupoTitulo.subtitulo2 = 0
					grupoTitulo.subtitulo2Tamanhos = {}
					grupoTitulo.subtitulo3Tamanhos = {}
				elseif atributos.vetorTitulos[i][1] == "subtitulo2" then
					options.text = atributos.vetorTitulos[i][2]
					options.font = native.systemFont
					options.x = atributos.x + 50 + 50
					options.width = W-120
					grupoTitulo.subtitulo2 = grupoTitulo.subtitulo2 + 1
					grupoTitulo.subtitulo2Marcacao = i
					grupoTitulo.subtitulo3Tamanhos = {}
				elseif atributos.vetorTitulos[i][1] == "subtitulo3" then
					options.text = atributos.vetorTitulos[i][2]
					options.font = native.systemFont
					options.x = atributos.x + 50 + 50 + 50
					options.width = W-170
				end
			else
				if atributos.vetorTitulos.indiceRemissivo then
					local texto = ""
					for v=1,#atributos.vetorTitulos[i] do
						texto = texto .. atributos.vetorTitulos[i][v]
						if v ~= #atributos.vetorTitulos[i] then texto = texto .. ", " end
						
					end

					options.text = texto
					options.font = "Fontes/ariblk.ttf"
					options.x = atributos.x
					options.width= W-40
					grupoTitulo.titulo = grupoTitulo.titulo + 1
					if grupoTitulo.tituloMarcacao > 0 then
						grupoTitulo.tituloMarcacaoAnt = grupoTitulo.tituloMarcacao
					end
					grupoTitulo.tituloMarcacao = i
					grupoTitulo.subtituloMarcacao=0
					grupoTitulo.subtitulo2Marcacao=0
					grupoTitulo.subtitulo = 0
					grupoTitulo.subtitulo2 = 0
					grupoTitulo.subtituloTamanhos = {}
					grupoTitulo.subtitulo2Tamanhos = {}
					grupoTitulo.subtitulo3Tamanhos = {}
				elseif atributos.vetorTitulos[i][1] == "titulo" then
					options.text = atributos.vetorTitulos[i][2]
					options.font = "Fontes/ariblk.ttf"
					options.x = atributos.x
					options.width= W-40
					
					grupoTitulo.titulo = grupoTitulo.titulo + 1
					if grupoTitulo.tituloMarcacao > 0 then
						grupoTitulo.tituloMarcacaoAnt = grupoTitulo.tituloMarcacao
					end
					grupoTitulo.tituloMarcacao = i
					grupoTitulo.subtituloMarcacao=0
					grupoTitulo.subtitulo2Marcacao=0
					grupoTitulo.subtitulo = 0
					grupoTitulo.subtitulo2 = 0
					grupoTitulo.subtituloTamanhos = {}
					grupoTitulo.subtitulo2Tamanhos = {}
					grupoTitulo.subtitulo3Tamanhos = {}
				elseif atributos.vetorTitulos[i][1] == "subtitulo" then
					options.text = atributos.vetorTitulos[i][2]
					options.font = "Fontes/ariblk.ttf"
					options.x = atributos.x + 50
					options.width = W-140
					
					grupoTitulo.subtitulo = grupoTitulo.subtitulo + 1
					grupoTitulo.subtituloMarcacao = i
					grupoTitulo.subtitulo2Marcacao=0
					grupoTitulo.subtitulo2 = 0
					grupoTitulo.subtitulo2Tamanhos = {}
					grupoTitulo.subtitulo3Tamanhos = {}
				elseif atributos.vetorTitulos[i][1] == "subtitulo2" then
					options.text = atributos.vetorTitulos[i][2]
					options.font = "Fontes/ariblk.ttf"
					options.x = atributos.x + 50 + 50
					options.width = W-240
					
					grupoTitulo.subtitulo2 = grupoTitulo.subtitulo2 + 1
					grupoTitulo.subtitulo2Marcacao = i
					grupoTitulo.subtitulo3Tamanhos = {}
				elseif atributos.vetorTitulos[i][1] == "subtitulo3" then
					options.text = atributos.vetorTitulos[i][2]
					options.font = "Fontes/ariblk.ttf"
					options.x = atributos.x + 50 + 50+ 50
					options.width = W-290
				end
			end
			
			options.text = string.gsub(options.text,"\\n","\n")
			local function externalFunc(event)
				print("Rodou external func")
				local numero = tonumber(string.match(event.target.text,"%d+"))
				
				if numero then
					-- aqui colocar para ir para a página
					local numero = numero - varGlobal.contagemInicialPaginas + totalPaginasAnteriores
					local numeroMaximo = varGlobal.numeroTotal.Todas
					if numero > numeroMaximo then
						native.showAlert("Atenção!","A página "..tonumber(string.match(event.target.text,"%d+")).." de índice "..numero.." não existe!",{"OK"})
					else
						print("GRUPOGERAL.irParaElemento2",event.target.elemento)
						GRUPOGERAL.irParaElemento = event.target.elemento
						telas.localizar = grupoIndice.textoFinalIndice[i].localizar
						criarCursoAux(telas,numero)
					end
				else
					local numeroMaximo = varGlobal.numeroTotal.Todas
					local e = {}
					print("GRUPOGERAL.irParaElemento1",event.target.elemento)
					GRUPOGERAL.irParaElemento = grupoIndice.textoFinalIndice[i].elemento
					e.target = grupoIndice.textoFinalIndice[i]
					funcRetorno(e)
				end
			end
			grupoIndice.textoFinalIndice[i] = colocarFormatacaoTexto.criarTextodePalavras({texto = options.text,x = options.x,Y = options.y,fonte = options.font,tamanho = options.fontSize,cor = {red2,green2,blue2}, alinhamento = options.align,margem = margem,xNegativo = xNegativo,largura = largura, endereco = varGlobal.enderecoArquivos,tipoTTS = varGlobal.TTSTipo,temHistorico = varGlobal.temHistorico,indiceRemissivo = atributos.vetorTitulos.indiceRemissivo,funcaoExterna = externalFunc})
			grupoIndice.textoFinalIndice[i].localizar = atributos.vetorTitulos[i].localizar
			grupoIndice.textoFinalIndice[i].indiceRemissivo = atributos.vetorTitulos.indiceRemissivo
			grupoIndice.textoFinalIndice[i].text = options.text
			grupoIndice.textoFinalIndice[i].grupoTitulo = grupoTitulo.titulo
			grupoIndice.textoFinalIndice[i].grupoSubtitulo = grupoTitulo.subtitulo
			grupoIndice.textoFinalIndice[i].grupoSubtitulo2 = grupoTitulo.subtitulo2
			grupoIndice.textoFinalIndice[i].aberto = false
			grupoIndice.textoFinalIndice[i].elemento = atributos.vetorTitulos[i][4]
			if i == 1 then
				grupoIndice.textoFinalIndice[i].y = 0 + titulodoIndice.height - 50

			else
				grupoIndice.textoFinalIndice[i].y = grupoIndice.textoFinalIndice[i-1].y+grupoIndice.textoFinalIndice[i-1].height + 30
			end

			if options.align == "right" then
				local textinho = grupoIndice.textoFinalIndice[i].text
				grupoIndice.textoFinalIndice[i].text = textinho .. " "
			end
			if not atributos.vetorTitulos.indiceRemissivo then
				local paginaReal = auxFuncs.contagemDaPaginaRetroativa(
					{
						paginaReal = atributos.vetorTitulos[i][3],
						contagemInicialPaginas = telas.nContagemInicialPaginas,
						PaginasPre= telas.nPaginasPre,
						Indices = telas.nIndices,
						paginasAntesZero = telas.nPaginasAntesDoZero
					}
				)
				
				grupoIndice.textoFinalIndice[i].i = paginaReal--atributos.vetorTitulos[i][3] - varGlobal.contagemInicialPaginas + totalPaginasAnteriores
				grupoIndice.textoFinalIndice[i].numeroReal = atributos.vetorTitulos[i][3]
				grupoIndice.textoFinalIndice[i]:addEventListener("tap", funcRetorno)
			end
			grupoIndice:insert(grupoIndice.textoFinalIndice[i])
			grupoIndice.textoFinalIndice[i].clicado = false
			grupoIndice.textoFinalIndice[i].indice = i
			grupoIndice.textoFinalIndice[i].arquivo = "somTextoIndice P"..paginaAtual.." numero ".. i .. ".MP3"
			if PlanoDeFundoLibEA == "preto" then
				--grupoIndice.textoFinalIndice[i]:setFillColor(1,1,1);
			end
			
			local auxiliar = grupoIndice.textoFinalIndice[i].y + grupoIndice.textoFinalIndice[i].height
			--if auxiliar > 1280 then
			--	varGlobal.limiteTela = auxiliar
			--end
			
			-- somar o tamanho dos subtitulos
			if atributos.vetorTitulos.indiceRemissivo then
				grupoIndice.textoFinalIndice[i].tipo = "titulo"
			else
				if atributos.vetorTitulos[i][1] == "titulo" then
					grupoIndice.textoFinalIndice[i].tipo = "titulo"
				elseif atributos.vetorTitulos[i][1] == "subtitulo" then
					table.insert(grupoTitulo.subtituloTamanhos,{i,grupoIndice.textoFinalIndice[i].height})
					grupoIndice.textoFinalIndice[i].tipo = "subtitulo"
				elseif atributos.vetorTitulos[i][1] == "subtitulo2" then
					table.insert(grupoTitulo.subtitulo2Tamanhos,{i,grupoIndice.textoFinalIndice[i].height})
					grupoIndice.textoFinalIndice[i].tipo = "subtitulo2"
				elseif atributos.vetorTitulos[i][1] == "subtitulo3" then
					table.insert(grupoTitulo.subtitulo3Tamanhos,{i,grupoIndice.textoFinalIndice[i].height})
					grupoIndice.textoFinalIndice[i].tipo = "subtitulo3"
				end
			end
			
			if grupoTitulo.tituloMarcacao ~= 0 and grupoTitulo.tituloMarcacao ~= i  then
				grupoIndice.textoFinalIndice[grupoTitulo.tituloMarcacao].subtituloTamanhos = grupoTitulo.subtituloTamanhos
				if not grupoIndice.textoFinalIndice[grupoTitulo.tituloMarcacao].subtituloTamanhosTotal then
					grupoIndice.textoFinalIndice[grupoTitulo.tituloMarcacao].subtituloTamanhosTotal=0
				end
				if atributos.vetorTitulos[i][1] == "subtitulo" then
					grupoIndice.textoFinalIndice[grupoTitulo.tituloMarcacao].subtituloTamanhosTotal = grupoIndice.textoFinalIndice[grupoTitulo.tituloMarcacao].subtituloTamanhosTotal + grupoIndice.textoFinalIndice[i].height
				end
			end
			if grupoTitulo.subtituloMarcacao ~= 0 and grupoTitulo.subtituloMarcacao ~= i then
				grupoIndice.textoFinalIndice[grupoTitulo.subtituloMarcacao].subtitulo2Tamanhos = grupoTitulo.subtitulo2Tamanhos
				if not grupoIndice.textoFinalIndice[grupoTitulo.subtituloMarcacao].subtitulo2TamanhosTotal then
					grupoIndice.textoFinalIndice[grupoTitulo.subtituloMarcacao].subtitulo2TamanhosTotal=0
				end
				if atributos.vetorTitulos[i][1] == "subtitulo2" then
					grupoIndice.textoFinalIndice[grupoTitulo.subtituloMarcacao].subtitulo2TamanhosTotal = grupoIndice.textoFinalIndice[grupoTitulo.subtituloMarcacao].subtitulo2TamanhosTotal + grupoIndice.textoFinalIndice[i].height
				end
			end
			if grupoTitulo.subtitulo2Marcacao ~= 0 and grupoTitulo.subtitulo2Marcacao ~= i then
				grupoIndice.textoFinalIndice[grupoTitulo.subtitulo2Marcacao].subtitulo3Tamanhos = grupoTitulo.subtitulo3Tamanhos
				if not grupoIndice.textoFinalIndice[grupoTitulo.subtitulo2Marcacao].subtitulo3TamanhosTotal then
					grupoIndice.textoFinalIndice[grupoTitulo.subtitulo2Marcacao].subtitulo3TamanhosTotal = 0
				end
				if atributos.vetorTitulos[i][1] == "subtitulo3" then
					grupoIndice.textoFinalIndice[grupoTitulo.subtitulo2Marcacao].subtitulo3TamanhosTotal = grupoIndice.textoFinalIndice[grupoTitulo.subtitulo2Marcacao].subtitulo3TamanhosTotal + grupoIndice.textoFinalIndice[i].height
				end
			end
			if grupoIndice.textoFinalIndice[i].tipo ~= "titulo" and grupoTitulo.tituloMarcacao ~= 0 then
			
				-- recolher o indice para o superior
				grupoIndice.textoFinalIndice[i].y = grupoIndice.textoFinalIndice[grupoTitulo.tituloMarcacao].y
				grupoIndice.textoFinalIndice[i].alpha = 0
				--grupoIndice.textoFinalIndice[i].originalHeight = grupoIndice.textoFinalIndice[i].height
				--grupoIndice.textoFinalIndice[i].height = grupoIndice.textoFinalIndice[grupoTitulo.tituloMarcacao].height
			elseif grupoIndice.textoFinalIndice[i].tipo == "titulo" and grupoTitulo.tituloMarcacaoAnt then
				grupoIndice.textoFinalIndice[i].y = grupoIndice.textoFinalIndice[grupoTitulo.tituloMarcacaoAnt].y + grupoIndice.textoFinalIndice[grupoTitulo.tituloMarcacaoAnt].height + 30
			end
			
			
		end
		if not atributos.impressao then
			for i=1,#grupoIndice.textoFinalIndice do
				-- acrescentar simbolo se for o caso --
				if grupoIndice.textoFinalIndice[i].subtituloTamanhos and  #grupoIndice.textoFinalIndice[i].subtituloTamanhos>0 and grupoIndice.textoFinalIndice[i].tipo == "titulo" then
					grupoIndice.textoFinalIndice[i].symbol = displaySymbolSquare({width=30,height=30,color=atributos.corTexto})
					grupoIndice.textoFinalIndice[i].symbol.y = grupoIndice.textoFinalIndice[i].y+options.y
					grupoIndice.textoFinalIndice[i].symbol.x = atributos.x + 50 - 5 - grupoIndice.textoFinalIndice[i].symbol.width
					grupoIndice:insert(grupoIndice.textoFinalIndice[i].symbol)
				elseif  grupoIndice.textoFinalIndice[i].subtitulo2Tamanhos and  #grupoIndice.textoFinalIndice[i].subtitulo2Tamanhos>0 and grupoIndice.textoFinalIndice[i].tipo == "subtitulo"  then
					grupoIndice.textoFinalIndice[i].symbol = displaySymbolSquare({width=30,height=30,color=atributos.corTexto})
					grupoIndice.textoFinalIndice[i].symbol.alpha=0
					grupoIndice.textoFinalIndice[i].symbol.y = grupoIndice.textoFinalIndice[i].y+options.y
					grupoIndice.textoFinalIndice[i].symbol.x = atributos.x + 50 + 50 - 5 - grupoIndice.textoFinalIndice[i].symbol.width
					grupoIndice:insert(grupoIndice.textoFinalIndice[i].symbol)
				end
			end
		end
		local aux = grupoIndice.y + grupoIndice.height*1.35 + 40

		if aux > varGlobal.limiteTela then
			varGlobal.limiteTela = aux
		end

		grupoIndice.yOriginal = grupoIndice.y
		
		if grupoIndice.textoFinalIndice[1] then
			grupoIndice.botao = display.newImage("fontChange.png")
			grupoIndice.botao.posicaoYOriginal = 400
			grupoIndice.botao.width = 150
			grupoIndice.botao.height = 75
			grupoIndice.botao.x = W/2
			grupoIndice.botao.y = titulodoIndice.y + titulodoIndice.height + 5 + 100 + grupoIndice.botao.height/2 - 70--grupoIndice.botao.height/2
			grupoIndice.botao.acrescimo = titulodoIndice.y + titulodoIndice.height
			grupoIndice.botao.anchorY = .5
			grupoIndice.botao.anchorX = .5
			grupoIndice.botao.alpha = .7
			grupoIndice.botao.isVisible = false
			grupoIndice.botao.isHitTestable = false
		
			local function aumentarTexto(e)
				if system.orientation == "portrait" then
					if e.x >= (e.target.x) then
						print("aumentou")
						print(atributos.fontSize)
						local Y = GRUPOGERAL.y
						local Height = GRUPOGERAL.height
						telas[paginaAtual].indiceManual.tamanhoTexto = telas[paginaAtual].indiceManual.tamanhoTexto+5
						ead.criarCursoAux(telas,paginaAtual)
						local difHeight = GRUPOGERAL.height - Height
						GRUPOGERAL.y = Y + difHeight
						return true
					elseif e.x < (e.target.x) then
						print("diminuiu")
						local Y = GRUPOGERAL.y
						local Height = GRUPOGERAL.height
						telas[paginaAtual].indiceManual.tamanhoTexto = telas[paginaAtual].indiceManual.tamanhoTexto-5
						ead.criarCursoAux(telas,paginaAtual)
						local difHeight = GRUPOGERAL.height - Height
						GRUPOGERAL.y = Y + difHeight
						return true
					end
				elseif system.orientation == "landscapeRight" then
					if e.y >= (e.target.y) then
						print("e.y",e.y)
						print("e.target.y",e.target.y)
						print("aumentou")
						print(atributos.fontSize)
						local X = GRUPOGERAL.x
						local Height = GRUPOGERAL.height
						telas[paginaAtual].indiceManual.tamanhoTexto = telas[paginaAtual].indiceManual.tamanhoTexto+5
						ead.criarCursoAux(telas,paginaAtual)
						local difHeight = GRUPOGERAL.height - Height
						GRUPOGERAL.x = X + difHeight
						return true
					elseif e.y < (e.target.y) then
						print("e.y",e.y)
						print("e.target.y",e.target.y)
						print("diminuiu")
						local X = GRUPOGERAL.x
						local Height = GRUPOGERAL.height
						telas[paginaAtual].indiceManual.tamanhoTexto = telas[paginaAtual].indiceManual.tamanhoTexto-5
						ead.criarCursoAux(telas,paginaAtual)
						local difHeight = GRUPOGERAL.height - Height
						GRUPOGERAL.x = X + difHeight
						return true
					end
				elseif system.orientation == "landscapeLeft" then
					if e.y <= (e.target.y) then
						print("e.y",e.y)
						print("e.target.y",e.target.y)
						print("aumentou")
						print(atributos.fontSize)
						local X = GRUPOGERAL.x
						local Height = GRUPOGERAL.height
						telas[paginaAtual].indiceManual.tamanhoTexto = telas[paginaAtual].indiceManual.tamanhoTexto+5
						ead.criarCursoAux(telas,paginaAtual)
						local difHeight = GRUPOGERAL.height - Height
						GRUPOGERAL.x = X - difHeight
						return true
					elseif e.y > (e.target.y) then
						print("e.y",e.y)
						print("e.target.y",e.target.y)
						print("diminuiu")
						local X = GRUPOGERAL.x
						local Height = GRUPOGERAL.height
						telas[paginaAtual].indiceManual.tamanhoTexto = telas[paginaAtual].indiceManual.tamanhoTexto-5
						ead.criarCursoAux(telas,paginaAtual)
						local difHeight = GRUPOGERAL.height - Height
						GRUPOGERAL.x = X - difHeight
						return true
					end
				end
			end
			grupoIndice.botao:addEventListener("tap",aumentarTexto)
			girarTelaOrientacaoAumentarIndice(grupoIndice.botao)
		end
		
		-- separando os tamanhos dos grupos
		local numeroTotalTitulos = grupoIndice.textoFinalIndice[#grupoIndice.textoFinalIndice].grupoTitulo
		print("numeroTotalTitulos",numeroTotalTitulos)
		for i=1,#grupoIndice.textoFinalIndice do
			if grupoIndice.textoFinalIndice[i].tipo and grupoIndice.textoFinalIndice[i].tipo == "titulo" then
				print("tit ",grupoIndice.textoFinalIndice[i].grupoTitulo)
				print(grupoIndice.textoFinalIndice[i].subtituloTamanhosTotal)
			elseif grupoIndice.textoFinalIndice[i].tipo and grupoIndice.textoFinalIndice[i].tipo == "subtitulo" then
				print("sub ",grupoIndice.textoFinalIndice[i].grupoSubtitulo)
				print(grupoIndice.textoFinalIndice[i].subtitulo2TamanhosTotal)
			elseif grupoIndice.textoFinalIndice[i].tipo and grupoIndice.textoFinalIndice[i].tipo == "subtitulo2" then
				print("sub2 ",grupoIndice.textoFinalIndice[i].grupoSubtitulo2)
				print(grupoIndice.textoFinalIndice[i].subtitulo3TamanhosTotal)
			elseif grupoIndice.textoFinalIndice[i].tipo and grupoIndice.textoFinalIndice[i].tipo == "subtitulo3" then
				print("sub3 ",grupoIndice.textoFinalIndice[i].grupoSubtitulo3)
			end
		end
		
		return grupoIndice
	end
	
end
M.colocarIndicePreMontado = colocarIndicePreMontado		

----------------------------------------------------------
--  COLOCAR ANOTAÇÃO E COMENTÁRIO --
----------------------------------------------------------
function funcGlobal.criarAnotacoesComentarios(pagina,telas)
	Var.anotacao = display.newGroup()
	Var.comentario = display.newGroup()
	Var.anotComInterface = display.newGroup()
	Var.anotComInterface:insert(Var.anotacao)
	Var.anotComInterface:insert(Var.comentario)
	print("Var.proximoY",Var.proximoY)
	local Y = Var.proximoY + 100
	if Y <= 200 then
		print("GRUPOGERAL.height + 100",GRUPOGERAL.height + 100)
		Y = GRUPOGERAL.height + 100
	end
	--===============================================================================--
	-- INTERFACE GERAL --
	--===============================================================================--
	Var.anotComInterface.Icone = display.newImageRect(Var.anotComInterface,"anotacaoD.png",80,80)
	Var.anotComInterface.Icone.anchorY=0;Var.anotComInterface.Icone.anchorX=0
	Var.anotComInterface.Icone.y = Y+ 195--GRUPOGERAL.height+100--Var.proximoY+ 40
	Var.anotComInterface.Icone.x = (W-12*W/13)/2
	
	Var.anotComInterface.IconeFrente = display.newImageRect(Var.anotComInterface,"anotacao.png",80,80)
	Var.anotComInterface.IconeFrente.anchorY=0;Var.anotComInterface.IconeFrente.anchorX=0
	Var.anotComInterface.IconeFrente.y = Y+ 195--Var.proximoY+ 40
	Var.anotComInterface.IconeFrente.x = (W-12*W/13)/2
	
	Var.anotComInterface.IconeVoltar = display.newImageRect(Var.anotComInterface,"anotacaoBack.png",80,80)
	Var.anotComInterface.IconeVoltar.anchorY=0;Var.anotComInterface.IconeVoltar.anchorX=0
	Var.anotComInterface.IconeVoltar.y = Y+ 195--GRUPOGERAL.height+100--Var.proximoY+ 40
	Var.anotComInterface.IconeVoltar.x = (W-12*W/13)/2
	
	Var.anotacao.Barra = display.newImageRect(Var.anotComInterface,"comentariosMini1.png",(12*W/13 - 60)/2,60)
	Var.anotacao.Barra.anchorY=0;Var.anotacao.Barra.anchorX=0
	Var.anotacao.Barra.y = Y+ 195--GRUPOGERAL.height+100--Var.proximoY+ 40
	Var.anotacao.Barra.x = Var.anotComInterface.IconeVoltar.x - 20 + Var.anotComInterface.IconeVoltar.width
	if varGlobal.preferenciasGerais.ativarLogin == "sim" then
		Var.comentario.Barra = display.newImageRect(Var.anotComInterface,"comentariosMini2.png",(12*W/13 - 60)/2,60)
		Var.comentario.Barra.anchorY=0;Var.comentario.Barra.anchorX=0
		Var.comentario.Barra.y = Y+ 195--GRUPOGERAL.height+100--Var.proximoY+ 40
		Var.comentario.Barra.x = Var.anotacao.Barra.x + Var.anotacao.Barra.width
		Var.comentario.Barra.fill.effect = "filter.desaturate"
		Var.comentario.Barra.fill.effect.intensity = 0.9
	end
	
	Var.anotacao.BarraEsconder1 = display.newRect(Var.anotComInterface,0,0,Var.anotacao.Barra.width - 15,45)
	Var.anotacao.BarraEsconder1.anchorY=0;Var.anotacao.BarraEsconder1.anchorX=0
	Var.anotacao.BarraEsconder1.y = Var.anotacao.Barra.y + 8
	Var.anotacao.BarraEsconder1.x = Var.anotacao.Barra.x + 15
	Var.anotacao.BarraEsconder1:setFillColor(0,0,0)
	Var.anotacao.BarraEsconder1.alpha = .5
	
	--[[
	Var.comentario.BarraEsconder2 = display.newRect(Var.anotComInterface,0,0,(12*W/13)/2 - 30,52)
	Var.comentario.BarraEsconder2.anchorY=0;Var.comentario.BarraEsconder2.anchorX=0
	Var.comentario.BarraEsconder2.y = Var.comentario.Barra.y + 4
	Var.comentario.BarraEsconder2.x = Var.comentario.Barra.x + 1
	]]
	if varGlobal.preferenciasGerais.ativarLogin == "sim" then
		Var.comentario.BarraEsconder2 = display.newRect(Var.anotComInterface,0,0,Var.comentario.Barra.width,45)
		Var.comentario.BarraEsconder2.anchorY=0;Var.comentario.BarraEsconder2.anchorX=0
		Var.comentario.BarraEsconder2.y = Var.comentario.Barra.y + 8
		Var.comentario.BarraEsconder2.x = Var.comentario.Barra.x
		Var.comentario.BarraEsconder2:setFillColor(0,0,0)
		Var.comentario.BarraEsconder2.alpha = .5
	end
	GRUPOGERAL:insert(Var.anotComInterface)
	
	local BarraTextoTopo = display.newText(Var.anotComInterface,"anotação",0,0,"Fontes/paolaAccent.ttf",45)
	BarraTextoTopo:setFillColor(0,0,0)
	BarraTextoTopo.anchorX=0;BarraTextoTopo.anchorY=0
	BarraTextoTopo.x = Var.anotacao.Barra.x + 10 + 5 + 10
	BarraTextoTopo.y = Var.anotacao.Barra.y + 5
	local BarraTextoTopo2
	if varGlobal.preferenciasGerais.ativarLogin == "sim" then
		BarraTextoTopo2 = display.newText(Var.anotComInterface,"mensagens",0,0,"Fontes/paolaAccent.ttf",45)
		BarraTextoTopo2:setFillColor(0,0,0)
		BarraTextoTopo2.anchorX=1;BarraTextoTopo2.anchorY=0
		BarraTextoTopo2.x = Var.comentario.Barra.x - 10 + Var.comentario.Barra.width
		BarraTextoTopo2.y = Var.comentario.Barra.y + 5
	end
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
	
	local function criarCampoAnotacao()
		Var.anotacao.retanguloFundo = display.newRoundedRect(Var.anotacao.Barra.x - 55,Var.anotacao.Barra.y + 2,Var.anotacao.Barra.width*2 + 60 -6,200,6)
		Var.anotacao.retanguloFundo.strokeWidth = 2
		Var.anotacao.retanguloFundo:setStrokeColor(0,0,0)
		Var.anotacao.retanguloFundo.anchorX=0;Var.anotacao.retanguloFundo.anchorY=0
		Var.anotacao.retanguloFundo:setFillColor(.9,.9,.9)
		Var.anotacao:insert(1,Var.anotacao.retanguloFundo)

		Var.anotacao.erro = nil
		Var.anotacao.vazio = nil
		Var.anotacao.conteudo = nil

		-- verificar se já existe um TXT -----------------------------------
		function Var.anotacao.anotacaoListener( event )
			print("WARNING: COMEÇOU")
			if ( event.isError ) then
				Var.anotacao.conteudo = "Conexão com a internet falhou:"
				Var.anotacao.erro = true
			else
				local json = require("json")
				print(event.response)
				Var.anotacao.vetorAnotacao = json.decode(event.response)
				if Var.anotacao.vetorAnotacao["vazio"] == true then
					print("TAH VAZIO")
				elseif Var.anotacao.vetorAnotacao["vazio"] == false then
					auxFuncs.criarTxTDocWSemMais("anotacaoPagina"..varGlobal.PagH..".txt",Var.anotacao.vetorAnotacao["conteudo"]);
					Var.anotacao.conteudo = Var.anotacao.vetorAnotacao["conteudo"]
					Var.anotacao.idAnotacao = Var.anotacao.vetorAnotacao["idAnotacao"]
					Var.anotacao.vazio = Var.anotacao.vetorAnotacao["vazio"]
					
					Var.anotacao.texto.text = Var.anotacao.vetorAnotacao["conteudo"]
					Var.anotComInterface.Icone.fill.effect = nil
					Var.anotacao.Barra.fill.effect = nil
					Var.anotacao.texto:setFillColor(0,0,0)
					alturaRetangulo = 0
					alturaRetangulo = alturaRetangulo + Var.anotacao.grupoAnotacao.height + 10
					if alturaRetangulo > 200 -70 then Var.anotacao.retanguloFundo.height = alturaRetangulo + 70 end
					varGlobal.limiteTela = 1280
					local aux = {}
					aux.y = Var.anotacao.Barra.y
					aux.height = Var.anotacao.Barra.height
					funcGlobal.modificarLimiteTela(aux)
					funcGlobal.modificarLimiteTela(Var.anotComInterface)
				end
			end
			
		end
			local parameters = {}
			if varGlobal.idLivro1 then
				parameters.body = "consulta=1&idLivro=" .. varGlobal.idLivro1 .. "&pagina=" .. varGlobal.PagH.."&idUsuario=" .. varGlobal.idAluno1
				--parameters.body = "consulta=1&codigoLivro=" .. varGlobal.codigoLivro1 .. "&pagina=" .. contagemDaPaginaHistorico().."&idUsuario=" .. varGlobal.idAluno1
				local URL2 = "https://omniscience42.com/EAudioBookDB/anotacoes.php"
				network.request(URL2, "POST", Var.anotacao.anotacaoListener,parameters)
			end
		
			if auxFuncs.fileExistsDoc("anotacaoPagina"..varGlobal.PagH..".txt") then
				local aux = auxFuncs.lerTextoDoc("anotacaoPagina"..varGlobal.PagH..".txt")
				Var.anotacao.conteudo = aux
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
			local posTexto =  Var.anotacao.Barra.y + Var.anotacao.Barra.height + 20
			Var.anotacao.texto = {}
			Var.anotacao.grupoAnotacao= display.newGroup()
		
	
			Var.anotacao:insert(Var.anotacao.grupoAnotacao)
			Var.anotacao.texto = display.newText(Var.anotacao.grupoAnotacao,Var.anotacao.conteudo,0,0,8*W/9,0,native.systemFont,25)
			Var.anotacao.texto:setFillColor(0,0,0)
			Var.anotacao.texto.anchorY=0;Var.anotacao.texto.anchorX=0
			Var.anotacao.texto.y = posTexto
			Var.anotacao.texto.x = Var.anotacao.Barra.x + 5 - 40
			-- se existe erro então criar botão de tentar novamente --s
			if Var.anotacao.vazio or Var.anotacao.erro then
				Var.anotacao.texto:setFillColor(.2,.2,.2)
				Var.anotacao.texto.size = 30
				if Var.anotacao.erro then
				
				else
					-- se for vazio deixar cor cinza --
					Var.anotComInterface.Icone.fill.effect = "filter.desaturate"
					Var.anotComInterface.Icone.fill.effect.intensity = 0.9
					Var.anotacao.Barra.fill.effect = "filter.desaturate"
					Var.anotacao.Barra.fill.effect.intensity = 0.9
				end
			end
			local function janelaDeAnotacao()
				print("janela")
				local telaProtetiva = TelaProtetiva()
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
									auxFuncs.criarTxTDocWSemMais("anotacaoPagina"..varGlobal.PagH..".txt",defaultBox.text);
									cancelar:removeSelf()
									defaultBox:removeSelf()
									fundoTextBox:removeSelf()
									e.target:removeSelf()
									telaProtetiva:removeSelf()
									Var.anotacao.texto.text = defaultBox.text
									Var.anotacao.apagar.y = Var.anotacao.texto.y + Var.anotacao.texto.height + 40
									Var.anotacao.editar.y = Var.anotacao.texto.y + Var.anotacao.texto.height + 40
									Var.anotacao.editar.lapis.y = Var.anotacao.editar.y - 10
									Var.anotacao.apagar.borracha.y = Var.anotacao.apagar.y - 5
									Var.anotComInterface.Icone.fill.effect = nil
									Var.anotacao.Barra.fill.effect = nil
									alturaRetangulo = Var.anotacao.grupoAnotacao.height + 10
									if alturaRetangulo > 200 -70 then Var.anotacao.retanguloFundo.height = alturaRetangulo + 70 end
								
									local aux = {}
									aux.y = Var.anotacao.Barra.y
									aux.height = Var.anotacao.height + 100
									funcGlobal.modificarLimiteTela(aux)
									funcGlobal.modificarLimiteTela(Var.anotComInterface)
									local date = os.date( "*t" )
									local data = date.day.."/"..date.month.."/"..date.year
									local hora = date.hour..":"..date.min..":"..date.sec
									local pH = funcGlobal.pegarNumeroPaginaRomanosHistorico(varGlobal.PagH)
									local vetorJson = {
										tipoInteracao = "anotacao",
										pagina_livro = varGlobal.PagH,
										objeto_id = nil,
										acao = "criar anotações",
										relatorio = data.."| Criou uma anotação pessoal na página "..pH.." às "..hora.."."
									}
									if GRUPOGERAL.subPagina then
										vetorJson.subPagina = GRUPOGERAL.subPagina
									end
									funcGlobal.escreverNoHistorico(varGlobal.HistoricoCriarAnotacao,vetorJson)
									local parameters = {}
									parameters.body = "Criar=1&idLivro=" .. varGlobal.idLivro1  .. "&idUsuario=" .. varGlobal.idAluno1 .. "&pagina=" .. varGlobal.PagH .. "&conteudo=" .. defaultBox.text .. "&situacao=" .. "A"
									local URL2 = "https://omniscience42.com/EAudioBookDB/anotacoes.php"
									network.request(URL2, "POST", 
										function(event)
											if ( event.isError ) then
												native.showAlert("Falha no envio","Sua anotação não pôde ser enviada para a nuvem, verifique sua conexão com a internet e tente editar e salvar a anotação novamente",{"OK"})
											else
												print("WARNING: IdAnotacao = ",event.response)
												Var.anotacao.idAnotacao = event.response
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
				width = Var.anotacao.retanguloFundo.width/5,
				height = 40,
				fillColor = { default={ 0.18, 0.67, 0.785, 1 }, over={ 0.004, 0.368, 0.467, 1 } },
				strokeColor = { default={ 0, 0, 0 }, over={ 0, 0, 0,.7 } },
				strokeWidth = 0,
				cornerRadius = 2
			})
			Var.anotacao.editar.anchorX = 0
			Var.anotacao.editar.anchorY = 0
			Var.anotacao.editar.y = Var.anotacao.texto.y + Var.anotacao.texto.height + 40
			Var.anotacao.editar.x = Var.anotacao.retanguloFundo.x + 20
			Var.anotacao.grupoAnotacao:insert(Var.anotacao.editar)
		
			Var.anotacao.editar.lapis = display.newImageRect(Var.anotacao.grupoAnotacao,"editPencil.png",40,50)
			Var.anotacao.editar.lapis.rotation = 10
			Var.anotacao.editar.lapis.anchorX=0;Var.anotacao.editar.lapis.anchorY=0
			Var.anotacao.editar.lapis.x = Var.anotacao.editar.x + Var.anotacao.editar.width - 15
			Var.anotacao.editar.lapis.y = Var.anotacao.editar.y - 10
	
			local function onComplete(e)
				if e.index == 1 then
					Var.anotComInterface.Icone.fill.effect = "filter.desaturate"
					Var.anotComInterface.Icone.fill.effect.intensity = 0.9
					Var.anotacao.Barra.fill.effect = "filter.desaturate"
					Var.anotacao.Barra.fill.effect.intensity = 0.9
					os.remove(system.pathForFile("anotacaoPagina"..varGlobal.PagH..".txt",system.DocumentsDirectory))
					Var.anotComInterface.Icone.fill.effect = "filter.desaturate"
					Var.anotComInterface.Icone.fill.effect.intensity = 0.9
					Var.anotacao.Barra.fill.effect = "filter.desaturate"
					Var.anotacao.Barra.fill.effect.intensity = 0.9
					Var.anotacao.texto.text = ""
					Var.anotacao.apagar.y = Var.anotacao.texto.y + Var.anotacao.texto.height + 40
					Var.anotacao.editar.y = Var.anotacao.texto.y + Var.anotacao.texto.height + 40
					Var.anotacao.editar.lapis.y = Var.anotacao.editar.y - 10
					Var.anotacao.apagar.borracha.y = Var.anotacao.apagar.y - 5
					Var.anotacao.retanguloFundo.height = 200
					alturaRetangulo = 0
				
					local aux = {}
					aux.y = Var.anotacao.Barra.y
					aux.height = Var.anotacao.height + 100
					funcGlobal.modificarLimiteTela(aux)
					funcGlobal.modificarLimiteTela(Var.anotComInterface)
					local date = os.date( "*t" )
					local data = date.day.."/"..date.month.."/"..date.year
					local hora = date.hour..":"..date.min..":"..date.sec
					local pH = funcGlobal.pegarNumeroPaginaRomanosHistorico(varGlobal.PagH)
					local vetorJson = {
						tipoInteracao = "anotacao",
						pagina_livro = varGlobal.PagH,
						objeto_id = nil,
						acao = "excluir anotações",
						relatorio = data.."| Excluiu a anotação pessoal criada na página "..pH.." às "..hora.."."
					}
					if GRUPOGERAL.subPagina then
						vetorJson.subPagina = GRUPOGERAL.subPagina
					end
					funcGlobal.escreverNoHistorico(varGlobal.HistoricoExcluirAnotacao,vetorJson)
					if Var.anotacao.idAnotacao then
						local parameters = {}
						parameters.body = "Excluir=1&anotacao_id="..Var.anotacao.idAnotacao
						local URL2 = "https://omniscience42.com/EAudioBookDB/anotacoes.php"
						network.request(URL2, "POST", 
							function(event)
								if ( event.isError ) then
									native.showAlert("Falha no envio","Sua anotação não pôde ser enviada para a nuvem, verifique sua conexão com a internet e tente editar e salvar a anotação novamente",{"OK"})
								else
									print("WARNING: 2",event.response)
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
				width = Var.anotacao.retanguloFundo.width/5,
				height = 40,
				fillColor = { default={ 0.9, 0.2, 0.1, 1 }, over={ 0.7, 0.02, 0.01, 1 } },
				strokeColor = { default={ 0, 0, 0 }, over={ 0, 0, 0,.7 } },
				strokeWidth = 0,
				cornerRadius = 2
			})
			Var.anotacao.apagar.anchorX = 1
			Var.anotacao.apagar.anchorY = 0
			Var.anotacao.apagar.y = Var.anotacao.texto.y + Var.anotacao.texto.height + 40
			Var.anotacao.apagar.x = Var.anotacao.retanguloFundo.x + Var.anotacao.retanguloFundo.width - 20
			Var.anotacao.grupoAnotacao:insert(Var.anotacao.apagar)
		
			Var.anotacao.apagar.borracha = display.newImageRect(Var.anotacao.grupoAnotacao,"eraser.png",30,38)
			Var.anotacao.apagar.borracha.rotation = 10
			Var.anotacao.apagar.borracha.anchorX=0;Var.anotacao.apagar.borracha.anchorY=0
			Var.anotacao.apagar.borracha.x = Var.anotacao.apagar.x - 5 -- Var.anotacao.apagar.width - 30
			Var.anotacao.apagar.borracha.y = Var.anotacao.apagar.y - 5
		
	end
	-- criar anotação
	criarCampoAnotacao()
	--Var.anotacao.grupoAnotacao.isVisible = false
	
	local function criarCampoComentario()
		Var.comentario.retanguloFundo = display.newRoundedRect(Var.anotacao.Barra.x - 55,Var.anotacao.Barra.y + 2,Var.anotacao.Barra.width+Var.comentario.Barra.width + 60 -6,200,6)
		Var.comentario.retanguloFundo.strokeWidth = 2
		Var.comentario.retanguloFundo:setStrokeColor(0,0,0)
		Var.comentario.retanguloFundo.anchorX=0;Var.comentario.retanguloFundo.anchorY=0
		Var.comentario.retanguloFundo:setFillColor(.9,.9,.9)
		Var.comentario:insert(1,Var.comentario.retanguloFundo)

		Var.comentario.erro = nil
		Var.comentario.vazio = nil
		Var.comentario.conteudo = nil
		
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
		Var.comentario.gruposComentarios = display.newGroup()
		Var.comentario.vetorPrinc = {}
		Var.comentario.vetorSec = {}
		Var.comentario.respostaAberta = false
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
				
				local posTexto =  Var.anotacao.Barra.y + Var.anotacao.Barra.height + 20
				if Secundario then
					posTexto =  Secundario.y + Secundario.height - 20
				end
				if i > 1 then
					posTexto = textoComentarios[i-1].y - bordasY/2 + grupoComentario[i-1].height + 10
				end
				
				grupoComentario[i].numero = i
				grupoComentario[i].x = grupoComentario[i].x + diminuir
				textoComentarios[i] = display.newText(grupoComentario[i],vetorComentarios[i].conteudo,0,0,Var.comentario.retanguloFundo.width-20 - diminuir - 10,0,native.systemFont,35)
				print(vetorComentarios[i].conteudo)
				textoComentarios[i]:setFillColor(0,0,0)
				textoComentarios[i].anchorY=0;textoComentarios[i].anchorX=0
				textoComentarios[i].y = posTexto
				textoComentarios[i].x = Var.anotacao.Barra.x + 10 - 40
				-- se existe erro então criar botão de tentar novamente --s
				if vetorComentarios.vazio or vetorComentarios.erro then
					textoComentarios[i]:setFillColor(.2,.2,.2)
					textoComentarios[i].size = 30
				else
					-- criar barra comentador -- inserir em: grupoComentario[i]
					
					local altura = textoComentarios[i].height + bordasY
					local x = Var.anotacao.Barra.x - 40
					
					-- FUNDO DO COMENTÁRIO
					grupoComentario[i].retanguloFundoBranco = display.newRoundedRect(x,posTexto,Var.comentario.retanguloFundo.width-20 - diminuir - 10,altura,6)
					grupoComentario[i].retanguloFundoBranco.anchorX=0
					grupoComentario[i].retanguloFundoBranco.anchorY=0
					grupoComentario[i]:insert(1,grupoComentario[i].retanguloFundoBranco)
					
					-- INTERFACE (Avatar,apelido e data)
					-- baixar e colocar o avatar --
					grupoComentario[i].avatarNome = vetorComentarios[i].Imagem
					grupoComentario[i].jaCurtiu = vetorComentarios[i].jaCurtiu
					print("WARNING: NOVO")
					print(grupoComentario[i].jaCurtiu)
					print(vetorComentarios[i].conteudo)
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
								if grupoComentario and grupoComentario[i] then
									grupoComentario[i].idComentario = vetorComentarios[i].comentarioID
									grupoComentario[i].idPai = vetorComentarios[i].pai

									grupoComentario[i].avatar = display.newImageRect(grupoComentario[i].avatarNome,system.TemporaryDirectory,(bordasY/2)-2,(bordasY/2)-2)
									grupoComentario[i].avatar.x = x + 5
									grupoComentario[i].avatar.y = posTexto + 1
									grupoComentario[i].avatar.anchorX=0
									grupoComentario[i].avatar.anchorY=0
									if grupoComentario[i].avatar then
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
										grupoBotaoAumentar:insert(Var.comentario.telaProtetiva)
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
												local date = os.date( "*t" )
												local data = date.day.."/"..date.month.."/"..date.year
												local hora = date.hour..":"..date.min..":"..date.sec
												local pH = funcGlobal.pegarNumeroPaginaRomanosHistorico(varGlobal.PagH)
												local vetorJson = {
													tipoInteracao = "comentário",
													pagina_livro = varGlobal.PagH,
													objeto_id = nil,
													acao = "excluir comentário",
													conteudo = grupoComentario[i].text,
													id_Comentario = grupoComentario[i].idComentario,
													relatorio = data .. "| Excluiu uma mensagem própria anteriormente criada na página ".. pH .." às "..hora..'. O id da mensagem desativada é: "'..grupoComentario[i].idComentario..'".'
												}
												if GRUPOGERAL.subPagina then
													vetorJson.subPagina = GRUPOGERAL.subPagina
												end
												funcGlobal.escreverNoHistorico(varGlobal.HistoricoExcluirComentario .. grupoComentario[i].idComentario,vetorJson)
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
												--pasteboard.copy( "string", tostring(grupoComentario[i].text) )
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
										Var.comentario.MenuRapido = MenuRapido.New(
											{
											escolhas = escolhasGerais,
											rowWidthGeneric = 200,
											rowHeightGeneric = 50,
											tamanhoTexto = 30,
											telaProtetiva = "nao"
											}
										)
										grupoBotaoAumentar:insert(Var.comentario.MenuRapido)
										--Var.imagens[ims].MenuRapido.x = event.x
										--Var.imagens[ims].MenuRapido.y = event.y - GRUPOGERAL.y
										Var.comentario.MenuRapido.x = grupoComentario[i].botaoOpcoes.x
										Var.comentario.MenuRapido.y = grupoComentario[i].botaoOpcoes.y + grupoComentario[i].botaoOpcoes.height/2 + grupoComentario[i].y + GRUPOGERAL.y
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
										grupoComentario[i].opcoes.params = {email = vetorComentarios[i].email,apelidoOutro = vetorComentarios[i].apelido,pagina = varGlobal.PagH,apelido = varGlobal.apelidoLogin1,mensagemOutro = textoComentarios[i].text,nomeLivro = varGlobal.nomeLivro1}
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
														local date = os.date( "*t" )
														local data = date.day.."/"..date.month.."/"..date.year
														local hora = date.hour..":"..date.min..":"..date.sec
														local pH = funcGlobal.pegarNumeroPaginaRomanosHistorico(varGlobal.PagH)
														local vetorJson = {
															tipoInteracao = "comentário",
															pagina_livro = varGlobal.PagH,
															objeto_id = nil,
															acao = "Curtir comentário",
															id_Comentario = grupoComentario[i].idComentario,
															relatorio = data.."| Curtiu uma mensagem feito na página "..pH.. " às "..hora..'. Conteúdo da mensagem: "'..grupoComentario[i].text..'".'
														}
														if GRUPOGERAL.subPagina then
															vetorJson.subPagina = GRUPOGERAL.subPagina
														end
														funcGlobal.escreverNoHistorico(varGlobal.HistoricoCurtirComentario .. grupoComentario[i].idComentario,vetorJson)
														Var.comentario.atualizarComentarios()
													else
														grupoComentario[i].curtidas.alpha = .2
														grupoComentario[i].nCurtidas.text = tonumber(grupoComentario[i].nCurtidas.text) - 1
														vetorComentarios[i].curtidas = vetorComentarios[i].curtidas - 1
														grupoComentario[i].jaCurtiu = "N"
														vetorComentarios[i].jaCurtiu = "N"
														local date = os.date( "*t" )
														local data = date.day.."/"..date.month.."/"..date.year
														local hora = date.hour..":"..date.min..":"..date.sec
														local pH = funcGlobal.pegarNumeroPaginaRomanosHistorico(varGlobal.PagH)
														local vetorJson = {
															tipoInteracao = "comentário",
															pagina_livro = varGlobal.PagH,
															objeto_id = nil,
															acao = "Descurtir comentário",
															id_Comentario = grupoComentario[i].idComentario,
															relatorio = data.."| Descurtiu uma mensagem feito na página "..pH.. " às "..hora..'. Conteúdo da mensagem: "'..grupoComentario[i].text..'".'
														}
														if GRUPOGERAL.subPagina then
															vetorJson.subPagina = GRUPOGERAL.subPagina
														end
														funcGlobal.escreverNoHistorico(varGlobal.HistoricoDescurtirComentario .. grupoComentario[i].idComentario,vetorJson)
														Var.comentario.atualizarComentarios()
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
									if Var.comentario.BarraEsconder2.selecionada == true then
										Var.comentario.gruposComentarios.alpha = 1
									end
									--print("warning: |||".. varGlobal.idProprietario1, vetorComentarios[i].usuarioID .."|||")
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
													Var.comentario.comentar.y = Var.comentario.comentar.y - Secundario.altura
													Var.comentario.atualizar.y = Var.comentario.atualizar.y - Secundario.altura
													Var.comentario.retanguloFundo.height = Var.comentario.retanguloFundo.height - Secundario.altura
													for k=1,#Var.comentario.vetorSec do
														Var.comentario.vetorSec[k]:removeSelf()
													end
													Var.comentario.vetorSec = {}
													local aux = {}
													varGlobal.limiteTela = 1280
													aux.y = Var.comentario.Barra.y
													aux.height = Var.comentario.height
													funcGlobal.modificarLimiteTela(aux)
													funcGlobal.modificarLimiteTela(Var.anotComInterface)
													Secundario = nil
												end
												vetorComentarios[i].filhos.numero = i
												criarBaloesDeComentarios(vetorComentarios[i].filhos,50,event)
												grupoComentario[i].botaoRespostas:setLabel("Respostas ("..#vetorComentarios[i].filhos..") ↑")
												vetorComentarios[i].filhos.aberto = true
												Var.comentario.respostaAberta = true
											elseif vetorComentarios[i].filhos.aberto == true then
												grupoComentario[i].botaoRespostas:setLabel("Respostas ("..#vetorComentarios[i].filhos..") ↓")
												vetorComentarios[i].filhos.aberto = false
												for i=1,#Var.comentario.vetorPrinc do
													if Secundario.numero < i then
														Var.comentario.vetorPrinc[i].y = Var.comentario.vetorPrinc[i].y - Secundario.altura
													end
												end
												Var.comentario.comentar.y = Var.comentario.comentar.y - Secundario.altura
												Var.comentario.atualizar.y = Var.comentario.atualizar.y - Secundario.altura
												Var.comentario.retanguloFundo.height = Var.comentario.retanguloFundo.height - Secundario.altura
												for i=1,#Var.comentario.vetorSec do
													Var.comentario.vetorSec[i]:removeSelf()
												end
												Var.comentario.vetorSec = {}
												local aux = {}
												varGlobal.limiteTela = 1280
												aux.y = Var.comentario.Barra.y
												aux.height = Var.comentario.height
												funcGlobal.modificarLimiteTela(aux)
												funcGlobal.modificarLimiteTela(Var.anotComInterface)
												Var.comentario.respostaAberta = false
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
						funcGlobal.downloadArquivo(grupoComentario[i].avatarNome,"https://livrosdic.s3.us-east-2.amazonaws.com/perfil",aposBaixarAvatar)
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
				Var.comentario.gruposComentarios:insert(grupoComentario[i])
				alturaRetanguloComment = Var.comentario.gruposComentarios.height + 25
				
				if alturaRetanguloComment > 200 -70 then Var.comentario.retanguloFundo.height = alturaRetanguloComment + 70 end
			end
			if Secundario then
				for i=1,#Var.comentario.vetorPrinc do
					if Secundario.numero < i then
						Var.comentario.vetorPrinc[i].y = Var.comentario.vetorPrinc[i].y + Secundario.altura
					end
				end
				Var.comentario.comentar.y = Var.comentario.comentar.y + Secundario.altura
				Var.comentario.atualizar.y = Var.comentario.atualizar.y + Secundario.altura
				local auxRectY = Var.comentario.comentar.y + Var.comentario.comentar.height
				local auxRectY2 = Var.comentario.retanguloFundo.y + Var.comentario.retanguloFundo.height
				local auxRectResult = auxRectY - auxRectY2
				if auxRectResult > 0 then
					Var.comentario.retanguloFundo.height = Var.comentario.retanguloFundo.height + auxRectResult
				else
					Var.comentario.retanguloFundo.height = Var.comentario.retanguloFundo.height + Secundario.altura
				end
				local aux = {}
				varGlobal.limiteTela = 1280
				aux.y = Var.comentario.Barra.y
				aux.height = Var.comentario.height
				funcGlobal.modificarLimiteTela(aux)
				funcGlobal.modificarLimiteTela(Var.anotComInterface)
			end
		end
		function Var.comentario.criarComentario(event)
			
			local acrescentar = ""
			if event and event.target.id then
				print("event.target.id",event.target.id)
				acrescentar = "&idComentario="..event.target.id
			end
			local telaProtetiva = TelaProtetiva()
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
			defaultBox.text = Var.anotacao.texto.text
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
								parameters.body = "Criar=1&idLivro=" .. varGlobal.idLivro1  .. "&idUsuario=" .. varGlobal.idAluno1 .. "&pagina=" .. varGlobal.PagH .. "&conteudo=" .. defaultBox.text .. "&situacao=" .. "A" .. acrescentar..permissao
								local URL2 = "https://omniscience42.com/EAudioBookDB/comentarios.php"
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
											local date = os.date( "*t" )
											local data = date.day.."/"..date.month.."/"..date.year
											local hora = date.hour..":"..date.min..":"..date.sec
											local pH = funcGlobal.pegarNumeroPaginaRomanosHistorico(varGlobal.PagH)
											local vetorJson = {
												tipoInteracao = "comentário",
												pagina_livro = varGlobal.PagH,
												objeto_id = nil,
												acao = "criar comentário",
												conteudo = defaultBox.text,
												relatorio = data.."| Criou uma mensagem na página "..pH.." às "..hora..'.\nConteúdo da mensagem: "'..defaultBox.text..'"'
											}
											if GRUPOGERAL.subPagina then
												vetorJson.subPagina = GRUPOGERAL.subPagina
											end
											funcGlobal.escreverNoHistorico(varGlobal.HistoricoCriarComentario,vetorJson)
											Var.comentario.atualizarComentarios()
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
		function Var.comentario.comentarioListener( event )
			print("WARNING: COMEÇOU coment listener")
			local numeroT = 1
			local EstaVazio = true
			if ( event.isError ) then
				
				Var.comentario.vetorComentarios = {}
				Var.comentario.vetorComentarios[1] = {}
				Var.comentario.vetorComentarios[1].conteudo = "Conexão com a internet falhou:"
			else
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
					Var.comentario.Barra.fill.effect = nil
				elseif Var.comentario.vetorComentarios and Var.comentario.vetorComentarios.vazio == true then
					Var.comentario.vetorComentarios = {}
					Var.comentario.vetorComentarios[1] = {}
					Var.comentario.vetorComentarios[1].conteudo = "Não existem mensagens a se exibir nesta página."
					Var.comentario.Barra.fill.effect = "filter.desaturate"
					Var.comentario.Barra.fill.effect.intensity = 0.9
					if Var.anotacao.texto.text == "" then
						Var.anotComInterface.Icone.fill.effect = "filter.desaturate"
						Var.anotComInterface.Icone.fill.effect.intensity = 0.9
					end
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
				for i=1,numeroT do
					if Var.comentario.vetorComentarios[i].usuarioID == varGlobal.idProprietario1 then
						table.insert(Var.comentario.vetorComentarios, 1, table.remove(Var.comentario.vetorComentarios,i))
						--trocarElementoTable(Var.comentario.vetorComentarios, i, 1)
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
			--------------------------------------------------------------------
			-- arrumando formatação texto encontrado -> grupoComentario
			if Var.comentario.gruposComentarios then
				Var.comentario.gruposComentarios:removeSelf()
				Var.comentario.gruposComentarios = nil
			end
			local alturaRetanguloComment = 0
			Var.comentario.gruposComentarios = display.newGroup()
			Var.comentario.vetorPrinc = {}
			Var.comentario.vetorSec = {}
			Var.comentario.respostaAberta = false
			
			if BarraTextoTopo.x then -- verificar se cancelou antes da leitura
				
				criarBaloesDeComentarios(Var.comentario.vetorComentarios)
				
				Var.comentario.comentar = widget.newButton(
				{
					defaultFile = "comentar.png",
					overFile = "comentar.png",
					onRelease = Var.comentario.criarComentario,
					width = Var.comentario.retanguloFundo.width/4,
				})
				Var.comentario.comentar.anchorX = 0
				Var.comentario.comentar.anchorY = 0
				Var.comentario.comentar.id = nil
				Var.comentario.comentar.y = Var.comentario.retanguloFundo.y + Var.comentario.retanguloFundo.height
				Var.comentario.comentar.x = Var.comentario.retanguloFundo.x + 20
				Var.comentario.gruposComentarios:insert(Var.comentario.comentar)
				
				function Var.comentario.atualizarComentarios()
					if Var.comentario.gruposComentarios then
						Var.comentario.gruposComentarios:removeSelf()
						Var.comentario.gruposComentarios = nil
					end
					
					Var.comentario.gruposComentarios = display.newGroup()
					Var.comentario.vetorComentarios = nil
					Var.comentario.vetorPrinc = {}
					Var.comentario.vetorSec = {}
					Var.comentario.respostaAberta = false
					Var.comentario.retanguloFundo.height = 200
					alturaRetanguloComment = 0
					local parameters = {}
					parameters.body = "consulta=1&codigoLivro=" .. varGlobal.codigoLivro1 .. "&pagina=" .. varGlobal.PagH.."&idUsuario=" .. varGlobal.idAluno1
					local URL2 = "https://omniscience42.com/EAudioBookDB/comentarios.php"
					network.request(URL2, "POST", Var.comentario.comentarioListener,parameters)
				end
				Var.comentario.atualizar = widget.newButton(
				{
					defaultFile = "atualizar.png",
					overFile = "atualizarD.png",
					width = 60,
					height = 60,
					onRelease = Var.comentario.atualizarComentarios,
				})
				Var.comentario.atualizar.anchorX = 1
				Var.comentario.atualizar.anchorY = 0
				Var.comentario.atualizar.y = Var.comentario.retanguloFundo.y + Var.comentario.retanguloFundo.height
				Var.comentario.atualizar.x = Var.comentario.retanguloFundo.x + Var.comentario.retanguloFundo.width - 35
				Var.comentario.gruposComentarios:insert(Var.comentario.atualizar)
				
				
				alturaRetanguloComment = Var.comentario.gruposComentarios.height + 15
				
				Var.comentario:insert(Var.comentario.gruposComentarios)
				if alturaRetanguloComment > 200 -70 then Var.comentario.retanguloFundo.height = alturaRetanguloComment + 70 end
				
				if Var.comentario.BarraEsconder2.selecionada == true then
					local aux = {}
					varGlobal.limiteTela = 1280
					aux.y = Var.comentario.Barra.y
					aux.height = Var.comentario.height
					funcGlobal.modificarLimiteTela(aux)
					funcGlobal.modificarLimiteTela(Var.anotComInterface)
				else
					Var.comentario.gruposComentarios.alpha = 0
					local aux = {}
					varGlobal.limiteTela = 1280
					aux.y = Var.anotacao.Barra.y
					aux.height = Var.anotacao.height
					funcGlobal.modificarLimiteTela(aux)
					funcGlobal.modificarLimiteTela(Var.anotComInterface)
				end
				
				
				print("WARNING: FIM")
			end
			
		end
		local parameters = {}
		print("WARNING: PAGH = > ",varGlobal.PagH)
		parameters.body = "consulta=1&codigoLivro=" .. varGlobal.codigoLivro1 .. "&pagina=" .. varGlobal.PagH.."&idUsuario=" .. varGlobal.idAluno1
		local URL2 = "https://omniscience42.com/EAudioBookDB/comentarios.php"
		network.request(URL2, "POST", Var.comentario.comentarioListener,parameters)
		--------------------------------------------------p
		
	
	end
	-- criar anotação
	if varGlobal.preferenciasGerais.ativarLogin == "sim" then
		criarCampoComentario()
	end
	-- calcular altura da anotação para limitar movimento da tela --
	alturaRetangulo = alturaRetangulo + Var.anotacao.grupoAnotacao.height + 10
	----------------------------------------------------------s
	if alturaRetangulo > 200 -70 then Var.anotacao.retanguloFundo.height = alturaRetangulo + 70 end
		varGlobal.limiteTela = 1280
	local aux = {}
	aux.y = Var.anotacao.Barra.y
	aux.height = Var.anotacao.Barra.height
	funcGlobal.modificarLimiteTela(aux)
	funcGlobal.modificarLimiteTela(Var.anotComInterface)
	-- função de abrir e fechar anotação --
	Var.anotacao.abriu = false
	Var.anotacao.grupoAnotacao.alpha = 0
	Var.anotacao.retanguloFundo.alpha = 0
	Var.anotacao.Barra.alpha = 0
	if varGlobal.preferenciasGerais.ativarLogin == "sim" then
		Var.comentario.gruposComentarios.alpha = 0
		Var.comentario.retanguloFundo.alpha = 0
		Var.comentario.Barra.alpha = 0
		Var.comentario.Barra.tipo = "comentarios"
		Var.comentario.BarraEsconder2.isVisible = false
		Var.comentario.BarraEsconder2.selecionada = false
		BarraTextoTopo2.alpha = 0
	end
	Var.anotacao.Barra.tipo = "anotacao"
	
	
	BarraTextoTopo.alpha = 0
	
	Var.anotacao.BarraEsconder1.isVisible = false
	
	Var.anotacao.BarraEsconder1.selecionada = true
	
	
	Var.anotComInterface.IconeVoltar.alpha = 0
	
	local function abrirBarra()
		Var.anotComInterface.Icone.alpha = 0
		Var.anotComInterface.IconeFrente.alpha = 0
		Var.anotComInterface.IconeVoltar.alpha = 1
		Var.anotacao.Barra.alpha = 1
		
		if varGlobal.preferenciasGerais.ativarLogin == "sim" then
		Var.comentario.Barra.alpha = 1
		BarraTextoTopo2.alpha = 1
		end
		
		BarraTextoTopo.alpha = 1
		
		Var.anotacao.abriu = true
		local aux = {}
		varGlobal.limiteTela = 1280
		if varGlobal.preferenciasGerais.ativarLogin == "sim" and Var.comentario.BarraEsconder2.selecionada == true then
			Var.comentario.gruposComentarios.alpha = 1
			Var.comentario.retanguloFundo.alpha = 1
			
			Var.anotacao.BarraEsconder1.isVisible = true
			Var.comentario.BarraEsconder2.isVisible = false
			
			aux.y = Var.comentario.Barra.y
			aux.height = Var.comentario.height
		elseif Var.anotacao.BarraEsconder1.selecionada == true then
			Var.anotacao.grupoAnotacao.alpha = 1
			Var.anotacao.retanguloFundo.alpha = 1

			Var.anotacao.BarraEsconder1.isVisible = false
			if varGlobal.preferenciasGerais.ativarLogin == "sim" then
			Var.comentario.BarraEsconder2.isVisible = true
			end
			
			aux.y = Var.anotacao.Barra.y
			aux.height = Var.anotacao.height
		end
		funcGlobal.modificarLimiteTela(aux)
		funcGlobal.modificarLimiteTela(Var.anotComInterface)
		
	end
	local function FecharBarra(e)
		print("minimizar")
		Var.anotComInterface.Icone.alpha = 1
		Var.anotComInterface.IconeVoltar.alpha = 0
		Var.anotComInterface.IconeFrente.alpha = 1
		Var.anotacao.grupoAnotacao.alpha = 0
		Var.anotacao.retanguloFundo.alpha = 0
		if varGlobal.preferenciasGerais.ativarLogin == "sim" then
		Var.comentario.gruposComentarios.alpha = 0
		Var.comentario.retanguloFundo.alpha = 0
		Var.comentario.Barra.alpha = 0
		Var.comentario.BarraEsconder2.isVisible = false
		BarraTextoTopo2.alpha = 0
		end
		Var.anotacao.Barra.alpha = 0
		
		BarraTextoTopo.alpha = 0
		Var.anotacao.BarraEsconder1.isVisible = false
		
		
		Var.anotacao.abriu = false
		varGlobal.limiteTela = 1280
		local aux = {}
		aux.y = Var.anotacao.Barra.y
		aux.height = Var.anotacao.Barra.height
		funcGlobal.modificarLimiteTela(aux)
		funcGlobal.modificarLimiteTela(Var.anotComInterface)
		return true
	end
	local function mudarBarra(e)
		if e.target.tipo == "anotacao" then -- anotação
			if Var.anotacao.BarraEsconder1.selecionada == false then
				Var.anotacao.BarraEsconder1.isVisible = false
				Var.comentario.BarraEsconder2.isVisible = true
				Var.anotacao.grupoAnotacao.alpha = 1
				Var.anotacao.retanguloFundo.alpha = 1
				Var.comentario.gruposComentarios.alpha = 0
				Var.comentario.retanguloFundo.alpha = 0
				varGlobal.limiteTela = 1280
				local aux = {}
				aux.y = Var.anotacao.Barra.y
				aux.height = Var.anotacao.height
				funcGlobal.modificarLimiteTela(aux)
				funcGlobal.modificarLimiteTela(Var.anotComInterface)
			end
			Var.anotacao.BarraEsconder1.selecionada = true
			Var.comentario.BarraEsconder2.selecionada = false
		elseif e.target.tipo == "comentarios" then
			if Var.comentario.BarraEsconder2.selecionada == false then
				Var.comentario.BarraEsconder2.isVisible = false
				Var.anotacao.BarraEsconder1.isVisible = true
				Var.anotacao.grupoAnotacao.alpha = 0
				Var.anotacao.retanguloFundo.alpha = 0
				Var.comentario.gruposComentarios.alpha = 1
				Var.comentario.retanguloFundo.alpha = 1
				varGlobal.limiteTela = 1280
				local aux = {}
				aux.y = Var.comentario.Barra.y
				aux.height = Var.comentario.height
				funcGlobal.modificarLimiteTela(aux)
				funcGlobal.modificarLimiteTela(Var.anotComInterface)
			end
			Var.comentario.BarraEsconder2.selecionada = true
			Var.anotacao.BarraEsconder1.selecionada = false
		end
	end
	Var.anotComInterface.Icone:addEventListener("tap",abrirBarra)
	Var.anotComInterface.IconeVoltar:addEventListener("tap",FecharBarra)
	if varGlobal.preferenciasGerais.ativarLogin == "sim" then
	Var.anotacao.Barra:addEventListener("tap",mudarBarra)
	Var.comentario.Barra:addEventListener("tap",mudarBarra)
	end
end

----------------------------------------------------------
--  COLOCAR BOTÃO IMPRIMIR --
----------------------------------------------------------
local pdfImageConverter = require("plugin.pdfImageConverter")
--local zip = require( "plugin.zip" )
function funcGlobal.criarBotaoImpressao(pagina,telas)
	local grupoImpressao = display.newGroup()
	
	
	
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
			local GRUPOGERAL2 = display.newGroup()
			GRUPOGERAL2.ultimaPaginaSalva = nil
			local i = vetorTelas.PaginasAux[cont2]
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
					print("WARNING: COMEÇOU")
					print(vetorTelas[i].ordemElementos[ord])
					if vetorTelas[i] ~= nil then
						if(vetorTelas[i].ordemElementos[ord] == "imagem") then
							if not Var2.imagens then Var2.imagens = {} end
							local ims = vetorTelas[i].cont.imagens
							if vetorTelas[i].imagens[ims].arquivo then
								Var2.imagens[ims] = ead.colocarImagem(vetorTelas[i].imagens[ims],telas)
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
			
							Var2.espacos[esp] = elemTela.colocarEspaco(vetorTelas[i].espacos[esp])
							vetorTelas[i].cont.espacos =  vetorTelas[i].cont.espacos + 1
							Var2.espacos[esp].y = Var2.espacos[esp].y + Var2.proximoY
							Var2.proximoY = Var2.espacos[esp].y + Var2.espacos[esp].height
						end
						--verifica se tem separador
						if(vetorTelas[i].ordemElementos[ord] == "separador") then
							if not Var2.separadores then Var2.separadores = {} end
							local sep = vetorTelas[i].cont.separadores
			
							Var2.separadores[sep] = elemTela.colocarSeparador(vetorTelas[i].separadores[sep])
							vetorTelas[i].cont.separadores =  vetorTelas[i].cont.separadores + 1
							Var2.separadores[sep].y = Var2.separadores[sep].y + Var2.proximoY
							Var2.proximoY = Var2.separadores[sep].y + Var2.separadores[sep].height
							GRUPOGERAL2:insert(Var2.separadores[sep])
						end
						--verifica se tem som
						if(vetorTelas[i].ordemElementos[ord] == "som") then
							if not Var2.sons then Var2.sons = {} end
							local son = vetorTelas[i].cont.sons
			
							Var2.sons[son] = elemTela.colocarSom(vetorTelas[i].sons[son],vetorTelas)
							vetorTelas[i].cont.sons =  vetorTelas[i].cont.sons + 1
							Var2.sons[son].y = Var2.sons[son].y + Var2.proximoY
							Var2.proximoY = Var2.sons[son].y + Var2.sons[son].height
							GRUPOGERAL2:insert(Var2.sons[son])
						end
						--verifica se tem video
						if(vetorTelas[i].ordemElementos[ord] == "video") then
							if not Var2.videos then Var2.videos = {} end
							local vids = vetorTelas[i].cont.videos
			
							Var2.videos[vids] = ead.colocarVideo(vetorTelas[i].videos[vids],vetorTelas)
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
							Var2.textos[txt] = elemTela.colocarTexto(vetorTelas[i].textos[txt],vetorTelas)
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
			
							Var2.animacoes[ani] = elemTela.colocarAnimacao(vetorTelas[i].animacoes[ani],vetorTelas,varGlobal,funcGlobal)
							vetorTelas[i].cont.animacoes = vetorTelas[i].cont.animacoes + 1
							Var2.animacoes[ani].y = Var2.animacoes[ani].y + Var2.proximoY
							Var2.proximoY = Var2.animacoes[ani].y + Var2.animacoes[ani].height
							GRUPOGERAL2:insert(Var2.animacoes[ani])
						end 
						--verifica se tem botao
						if(vetorTelas[i].ordemElementos[ord] == "botao") then
			
							if not Var2.botoes then Var2.botoes = {} end
							local bot = vetorTelas[i].cont.botoes
			
							Var2.botoes[bot] = ead.colocarBotao(vetorTelas[i].botoes[bot],vetorTelas)
							vetorTelas[i].cont.botoes =  vetorTelas[i].cont.botoes + 1
							Var2.botoes[bot].y = Var2.botoes[bot].y + Var2.proximoY
							Var2.botoes[bot].YY = Var2.botoes[bot].YY + Var2.proximoY
							Var2.proximoY = Var2.botoes[bot].y + Var2.botoes[bot].height
							GRUPOGERAL2:insert(Var2.botoes[bot])
						end	
		
						if(vetorTelas[i].ordemElementos[ord] == "imagemTexto") then
							if not Var2.imagemTextos then Var2.imagemTextos = {} end
							local imtx = vetorTelas[i].cont.imagemTextos
			
							Var2.imagemTextos[imtx] = ead.colocarImagemTexto(vetorTelas[i].imagemTextos[imtx],vetorTelas)
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
										--auxFuncs.testarNoAndroid("TelaPagina".. paginaLivro .."_"..GRUPOGERAL2.numeroTelaTemp..".png",xx*50)
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
								--auxFuncs.testarNoAndroid("TelaPagina".. paginaLivro .."_"..GRUPOGERAL2.numeroTelaTemp..".png",xx*50)
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
								if string.find(auxPaginaLivro,"%-") then
									textoNumeroPagina.text = auxFuncs.ToRomanNumerals(string.gsub(auxPaginaLivro,"%-",""))
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
					if string.find(auxPaginaLivro,"%-") then
						textoNumeroPagina.text = auxFuncs.ToRomanNumerals(string.gsub(auxPaginaLivro,"%-",""))
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
				textoNumeroPagina.text = auxFuncs.ToRomanNumerals(string.gsub(auxPaginaLivro,"%-",""))
			else
				textoNumeroPagina.text = auxPaginaLivro
			end
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
								--auxFuncs.testarNoAndroid(Var2.atachmentZip[i],i*50)
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

						elseif Var.Impressao.grupoPDFPNG.tipo == "PNG" then
							local destino = system.TemporaryDirectory
							local function zipListener( event )
 
								if ( event.isError ) then
									print( "Error!" )
								else
									print ( event["type"] )  --> compress
									--print ( event.response[1] )  --> space.jpg
									--print ( event.response[2] )  --> space1.jpg
									--print ( event.response[3] )  --> space2.jpg
									-- enviar o imagem após acabar
							
									local options =
									{
									   to = "",
									   subject = "Imagens das páginas do livro",
									   body = "Imagens das páginas para leitura",
									   attachment = { baseDir=destino, filename="Telas.zip", type="zip/zip" }--Var2.atachment
									}
									native.showPopup( "mail", options )
									timer.performWithDelay(1000,function()
										Var2.grupoTravarTela:removeSelf()
										Var2.grupoTravarTela = nil
									end,1)
								end
							end
							local zipOptions = { 
								zipFile = "Telas.zip",
								zipBaseDir = destino,
								srcBaseDir = destino,
								srcFiles = Var2.atachmentZip,
								listener = zipListener
							}
							timer.performWithDelay(1000,function()
								zip.compress( zipOptions )
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
			auxFuncs.testarNoAndroid("File renamed",100)
		else
			auxFuncs.testarNoAndroid(reason,100)
			print( "File not renamed", reason )  --> File not renamed    orange.txt: No such file or directory
		end]]
		
	end
	local function criarVetorDasPaginas(vetorPaginas)
		local vetor = {}
		local cont = 1
		while cont<=#vetorPaginas do
			local pagina = vetorPaginas[cont]
			if pagina >= 1 and pagina <= telas.numeroTotal.PaginasPre then
				local nomeArquivo = tirarAExtencao(telas.arquivos[pagina])
				vetor[pagina] = {}
				vetor[pagina] = ead.criarTeladeArquivo({pasta = "PaginasPre",arquivo = telas.arquivos[pagina]},telas,{},pagina,nomeArquivo)
				vetor.PastaPaginas = "PaginasPre/Outros Arquivos"
			elseif pagina >= telas.numeroTotal.PaginasPre+1 and pagina <=  telas.numeroTotal.PaginasPre+telas.numeroTotal.Indices then
				vetor[pagina] = funcGlobal.criarIndicesDeArquivoConfig({pasta = "Indices",arquivo = "config indices.txt",pagina = pagina,TTSTipo = varGlobal.TTSTipo,paginaAtual = paginaAtual},telas,listaDeErros,VetorDeVetorTTS)
				vetor.PastaPaginas = "Indices/Outros Arquivos"
			else
				if #telas.arquivos > 0 then
					local nomeArquivo = tirarAExtencao(telas.arquivos[pagina])
					vetor[pagina] = ead.criarTeladeArquivo({pasta = "Paginas",arquivo = telas.arquivos[pagina]},telas,{},pagina,nomeArquivo)
				end
			end
			cont = cont + 1
		end
		vetor.PaginasAux = vetorPaginas
		criarImagensDasPaginas(vetor)
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
		display.save( GRUPOGERAL, { filename="TelaPagina".. varGlobal.PagH ..".png", baseDir=system.TemporaryDirectory, captureOffscreenArea=true, backgroundColor=varGlobal.preferenciasGerais.cor } )
		
		pdfImageConverter.toPdf(system.pathForFile("TelaPagina".. varGlobal.PagH ..".png", system.TemporaryDirectory), system.pathForFile("TelaPagina".. varGlobal.PagH ..".pdf", system.TemporaryDirectory))

		local options =
		{
		   to = "",
		   subject = "Conteúdo da "..varGlobal.PagH,
		   body = "PDF da " .. varGlobal.PagH .. " para impressão.",
		   attachment = { baseDir=system.TemporaryDirectory, filename="TelaPagina".. varGlobal.PagH ..".pdf", type="document/pdf" }
		}
		native.showPopup( "mail", options )
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
				local opcoesIntervalo = {}
				local function onSwitchPress(e)
					
					if opcoesIntervalo.textoRadio3Dica then
						opcoesIntervalo.textoRadio3Dica.isVisible = false
						opcoesIntervalo.textoRadio3Campo.isVisible = false
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
						opcoesIntervalo.textoRadio3Dica.isVisible = true
						opcoesIntervalo.textoRadio3Campo.isVisible = true
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
				opcoesIntervalo.textoRadio3Dica = display.newText(Var.Impressao.grupoPDFPNG,"Ex.: 1-5\n      1,2,3,4,5",Var.Impressao.textoRadio3.x,Var.Impressao.textoRadio3.y + 50,"Fontes/segoeui.ttf",30)
				opcoesIntervalo.textoRadio3Dica:setFillColor(1,1,1)
				opcoesIntervalo.textoRadio3Dica.anchorX=0
				opcoesIntervalo.textoRadio3Dica.anchorY=0
				opcoesIntervalo.textoRadio3Campo = native.newTextField(0,0,300,40)
				opcoesIntervalo.textoRadio3Campo.x = opcoesIntervalo.textoRadio3Dica.x + opcoesIntervalo.textoRadio3Campo.width/2
				opcoesIntervalo.textoRadio3Campo.y = opcoesIntervalo.textoRadio3Dica.y + opcoesIntervalo.textoRadio3Dica.height + opcoesIntervalo.textoRadio3Campo.height/2
				opcoesIntervalo.textoRadio3Dica.isVisible = false
				opcoesIntervalo.textoRadio3Campo.isVisible = false
				opcoesIntervalo.textoRadio3Campo:addEventListener( "userInput", textListener )
				Var.Impressao.grupoPDFPNG:insert(opcoesIntervalo.textoRadio3Campo)
				
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
					if Var.Impressao.grupoPDFPNG.tipo == "PDF" then
						if Var.Impressao.grupoPDFPNG.escolha == "atual" then
							abrirEmailComPDF()
						elseif Var.Impressao.grupoPDFPNG.escolha == "intervalo" then
							local vetorPaginasTexto = opcoesIntervalo.textoRadio3Campo.text
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
								--auxFuncs.testarNoAndroid(paginaReal,100 + 50*(count))
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
					elseif Var.Impressao.grupoPDFPNG.tipo == "PNG" then
						if Var.Impressao.grupoPDFPNG.escolha == "atual" then
							abrirEmailComImagem()
						elseif Var.Impressao.grupoPDFPNG.escolha == "intervalo" then
							local vetorPaginasTexto = opcoesIntervalo.textoRadio3Campo.text
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
								--auxFuncs.testarNoAndroid(paginaReal,100 + 50*(count))
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
		local textoTitulo = varGlobal.menuImprimirTitulo.." PDF"
		Var.Impressao.grupoPDFPNG = display.newGroup()
		Var.Impressao.protecaoTela = auxFuncs.TelaProtetiva()
		Var.Impressao.grupoPDFPNG:insert(Var.Impressao.protecaoTela)

		Var.Impressao.fundo = display.newImage(Var.Impressao.grupoPDFPNG,"menu enviar.png")
		Var.Impressao.fundo.x = W/2
		Var.Impressao.fundo.y = H/2
		local larguraMenu = Var.Impressao.fundo.width
		local alturaMenu = Var.Impressao.fundo.height
		if e.target.tipo == "Enviar Imagem.." then
			local somAbrir = audio.loadSound("audioTTS_envioPNG abrir.MP3")
			audio.play(somAbrir)
			--abrirEmailComImagem()
			Var.Impressao.fundo:setFillColor(51/255,98/255,129/255)
			textoTitulo = varGlobal.menuImprimirTitulo.." PNG"
			Var.Impressao.grupoPDFPNG.tipo = "PNG"
		elseif e.target.tipo == "Enviar PDF.." then
			local somAbrir = audio.loadSound("audioTTS_envioPDF abrir.MP3")
			audio.play(somAbrir)
			Var.Impressao.fundo:setFillColor(191/255,17/255,17/255)
			textoTitulo = varGlobal.menuImprimirTitulo.." PDF"			
			Var.Impressao.grupoPDFPNG.tipo = "PDF"
		end
		
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
		
			local opcaoInicial = {"atual","todas","intervalo"}
			Var.Impressao.grupoPDFPNG.escolha = "atual"
			opcaoInicial["atual"] = true
			opcaoInicial["todas"] = false
			opcaoInicial["intervalo"] = false
			local opcoesIntervalo = {}
			local function onSwitchPress(e)
				
				if opcoesIntervalo.textoRadio3Dica then
					opcoesIntervalo.textoRadio3Dica.isVisible = false
					opcoesIntervalo.textoRadio3Campo.isVisible = false
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
					opcoesIntervalo.textoRadio3Dica.isVisible = true
					opcoesIntervalo.textoRadio3Campo.isVisible = true
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
			opcoesIntervalo.textoRadio3Dica = display.newText(Var.Impressao.grupoPDFPNG,"Ex.: 1-5\n      1,2,3,4,5",Var.Impressao.textoRadio3.x,Var.Impressao.textoRadio3.y + 50,"Fontes/segoeui.ttf",30)
			opcoesIntervalo.textoRadio3Dica:setFillColor(1,1,1)
			opcoesIntervalo.textoRadio3Dica.anchorX=0
			opcoesIntervalo.textoRadio3Dica.anchorY=0
			opcoesIntervalo.textoRadio3Campo = native.newTextField(0,0,300,40)
			opcoesIntervalo.textoRadio3Campo.x = opcoesIntervalo.textoRadio3Dica.x + opcoesIntervalo.textoRadio3Campo.width/2
			opcoesIntervalo.textoRadio3Campo.y = opcoesIntervalo.textoRadio3Dica.y + opcoesIntervalo.textoRadio3Dica.height + opcoesIntervalo.textoRadio3Campo.height/2
			opcoesIntervalo.textoRadio3Dica.isVisible = false
			opcoesIntervalo.textoRadio3Campo.isVisible = false
			opcoesIntervalo.textoRadio3Campo:addEventListener( "userInput", textListener )
			Var.Impressao.grupoPDFPNG:insert(opcoesIntervalo.textoRadio3Campo)
			
			local botaoCancelar = widget.newButton{
			  defaultFile = 'closeMenuButton2.png',
			  overFile    = 'closeMenuButton2D.png',
			  width = 50,
			  height = 55,
			  onRelease     = function( event )
					if e.target.tipo == "Enviar Imagem.." then
						local somFechar = audio.loadSound("audioTTS_envioPNG fechar.MP3")
						audio.play(somFechar)
					elseif e.target.tipo == "Enviar PDF.." then
						local somFechar = audio.loadSound("audioTTS_envioPDF fechar.MP3")
						audio.play(somFechar)
					end
					if Var.Impressao.grupoPDFPNG then
						Var.Impressao.grupoPDFPNG:removeSelf()
						Var.Impressao.grupoPDFPNG = nil
					end
			  end
			}
			botaoCancelar.x = W/2 +larguraMenu/2- botaoCancelar.width/2 - 10
			botaoCancelar.y = H/2 - alturaMenu/2 + botaoCancelar.height/2 + 10
			Var.Impressao.grupoPDFPNG:insert(botaoCancelar)
			
			local function confirmarSelecaoImprimir(event)
				native.setKeyboardFocus( nil )
				if Var.Impressao.grupoPDFPNG.tipo == "PDF" then
					if Var.Impressao.grupoPDFPNG.escolha == "atual" then
						abrirEmailComPDF()
					elseif Var.Impressao.grupoPDFPNG.escolha == "intervalo" then
						local vetorPaginasTexto = opcoesIntervalo.textoRadio3Campo.text
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
							--auxFuncs.testarNoAndroid(paginaReal,100 + 50*(count))
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
				elseif Var.Impressao.grupoPDFPNG.tipo == "PNG" then
					if Var.Impressao.grupoPDFPNG.escolha == "atual" then
						abrirEmailComImagem()
					elseif Var.Impressao.grupoPDFPNG.escolha == "intervalo" then
						local vetorPaginasTexto = opcoesIntervalo.textoRadio3Campo.text
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
							--auxFuncs.testarNoAndroid(paginaReal,100 + 50*(count))
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
				end
			end
			local botaoConfirmar = widget.newButton{
			  top = H/2 + 200 + 5,
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
	grupoImpressao.botao = widget.newButton {
		defaultFile = "EnviarImagem.png",
		overFile = "EnviarImagemD.png",
		width = 80,
		height = 80,
		onRelease = criarInterfaceDeImprimirPaginas
	}
	grupoImpressao.botao.tipo = "Enviar Imagem.."
	
	grupoImpressao.botao.anchorX = 0--Var.anotComInterface.Icone.anchorX
	grupoImpressao.botao.anchorY = 0--Var.anotComInterface.Icone.anchorY
	--Var.anotComInterface.Icone.y = Y+ 100--GRUPOGERAL.height+100--Var.proximoY+ 40
	--Var.anotComInterface.Icone.x = (W-12*W/13)/2
	grupoImpressao.botao.y = 0
	grupoImpressao.botao.x = 0
	grupoImpressao:insert(grupoImpressao.botao)
	
	grupoImpressao.botaoPDF = widget.newButton {
		defaultFile = "iconePDF.png",
		overFile = "iconePDFD.png",
		width = 80,
		height = 80,
		onRelease = criarInterfaceDeImprimirPaginas
	}
	grupoImpressao.botaoPDF.tipo = "Enviar PDF.."
	grupoImpressao.botaoPDF.anchorX = 0--Var.anotComInterface.Icone.anchorX
	grupoImpressao.botaoPDF.anchorY = 0--Var.anotComInterface.Icone.anchorY
	--Var.anotComInterface.Icone.y = Y+ 100--GRUPOGERAL.height+100--Var.proximoY+ 40
	--Var.anotComInterface.Icone.x = (W-12*W/13)/2
	grupoImpressao.botaoPDF.y = 0
	grupoImpressao.botaoPDF.x = grupoImpressao.botao.x + grupoImpressao.botao.width + 10
	grupoImpressao:insert(grupoImpressao.botaoPDF)
	
	grupoImpressao.botaoLRight = display.newImageRect(grupoImpressao,"EnviarImagemR.png",80,80)
	grupoImpressao.botaoLRight.anchorY=0;grupoImpressao.botaoLRight.anchorX=0
	grupoImpressao.botaoLRight.y = 0--GRUPOGERAL.height+100--Var.proximoY+ 40
	grupoImpressao.botaoLRight.x = 0
	grupoImpressao.botaoLRight.isVisible = false
	
	grupoImpressao.botaoLLeft = display.newImageRect(grupoImpressao,"EnviarImagemL.png",80,80)
	grupoImpressao.botaoLLeft.anchorY=0;grupoImpressao.botaoLLeft.anchorX=0
	grupoImpressao.botaoLLeft.y = 0--GRUPOGERAL.height+100--Var.proximoY+ 40
	grupoImpressao.botaoLLeft.x = 0
	grupoImpressao.botaoLLeft.isVisible = false
	
	grupoImpressao.botaoPDFLRight = display.newImageRect(grupoImpressao,"iconePDFR.png",80,80)
	grupoImpressao.botaoPDFLRight.anchorY=0;grupoImpressao.botaoPDFLRight.anchorX=0
	grupoImpressao.botaoPDFLRight.y = 0--GRUPOGERAL.height+100--Var.proximoY+ 40
	grupoImpressao.botaoPDFLRight.x = grupoImpressao.botao.x + grupoImpressao.botao.width + 10
	grupoImpressao.botaoPDFLRight.isVisible = false
	
	grupoImpressao.botaoPDFLLeft = display.newImageRect(grupoImpressao,"iconePDFL.png",80,80)
	grupoImpressao.botaoPDFLLeft.anchorY=0;grupoImpressao.botaoPDFLLeft.anchorX=0
	grupoImpressao.botaoPDFLLeft.y = 0--GRUPOGERAL.height+100--Var.proximoY+ 40
	grupoImpressao.botaoPDFLLeft.x = grupoImpressao.botao.x + grupoImpressao.botao.width + 10
	grupoImpressao.botaoPDFLLeft.isVisible = false
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
					grupoImpressao.botaoPDF.isVisible = false
					grupoImpressao.botaoPDFLLeft.isVisible = false
					grupoImpressao.botaoPDFLRight.isVisible = true
				elseif system.orientation == "landscapeLeft" then
					grupoImpressao.botao.isVisible = false
					grupoImpressao.botaoLLeft.isVisible = true
					grupoImpressao.botaoLRight.isVisible = false
					grupoImpressao.botaoPDF.isVisible = false
					grupoImpressao.botaoPDFLLeft.isVisible = true
					grupoImpressao.botaoPDFLRight.isVisible = false
				else
					grupoImpressao.botao.isVisible = true
					grupoImpressao.botaoLLeft.isVisible = false
					grupoImpressao.botaoLRight.isVisible = false
					grupoImpressao.botaoPDF.isVisible = true
					grupoImpressao.botaoPDFLLeft.isVisible = false
					grupoImpressao.botaoPDFLRight.isVisible = false
				end
				grupoImpressao.botao.isHitTestable = true
				grupoImpressao.botaoPDF.isHitTestable = true
			end 
		end,-1)
	
	return grupoImpressao
end

----------------------------------------------------------
--  COLOCAR BOTÃO SALVAR RELATÓRIO --
----------------------------------------------------------
function funcGlobal.criarBotaoRelatorio(pagina,telas)
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
	
	local function abrirMenu()
		local somAbrir = audio.loadSound("audioTTS_relatorio abrir.MP3")
		audio.play(somAbrir)
		Var.Relatorio.grupo = display.newGroup()
		
		Var.Relatorio.telaPreta = display.newRect(Var.Relatorio.grupo,W/2,H/2,W,H)
		Var.Relatorio.telaPreta.alpha = .3
		Var.Relatorio.telaPreta:setFillColor(0,0,0)
		Var.Relatorio.telaPreta:addEventListener("touch",function() return true end)
		Var.Relatorio.telaPreta:addEventListener("tap",function() Var.Relatorio.grupo:removeSelf();Var.Relatorio.grupo=nil; return true end)
		
		Var.Relatorio.fundoRelatorio = display.newImage(Var.Relatorio.grupo,"menuPagina.png")
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
				Var.Relatorio.grupo:removeSelf()
				Var.Relatorio.grupo = nil
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
		Var.Relatorio.PeriodoTitulo0 = display.newText(Var.Relatorio.grupo,"___________________________",0,0,"Fontes/segoeuib.ttf",50)
		Var.Relatorio.PeriodoTitulo0.anchorY=0
		Var.Relatorio.PeriodoTitulo0.y,Var.Relatorio.PeriodoTitulo0.x = 190,W/2
		Var.Relatorio.PeriodoTitulo0:setFillColor(0,0,0)
		
		Var.Relatorio.PeriodoTitulo1 = display.newText(Var.Relatorio.grupo," Período:",0,0,"Fontes/segoeuib.ttf",50)
		Var.Relatorio.PeriodoTitulo1.anchorX=0
		Var.Relatorio.PeriodoTitulo1.anchorY=0
		Var.Relatorio.PeriodoTitulo1.y = 243
		Var.Relatorio.PeriodoTitulo1.x = 80
		Var.Relatorio.PeriodoTitulo1:setFillColor(0,0,0)
		
		Var.Relatorio.PeriodoTitulo2 = display.newText(Var.Relatorio.grupo,"___________________________",0,0,"Fontes/segoeuib.ttf",50)
		Var.Relatorio.PeriodoTitulo2.anchorY=0
		Var.Relatorio.PeriodoTitulo2.y,Var.Relatorio.PeriodoTitulo2.x = 255,W/2
		Var.Relatorio.PeriodoTitulo2:setFillColor(0,0,0)
		
		Var.Relatorio.dataInicioTexto = display.newText(Var.Relatorio.grupo,"Data inicial:  dia / mês / ano",0,0,"Fontes/segoeui.ttf",40)
		Var.Relatorio.dataInicioTexto.anchorX=0
		Var.Relatorio.dataInicioTexto.anchorY=0
		Var.Relatorio.dataInicioTexto.y = Var.Relatorio.PeriodoTitulo2.y + Var.Relatorio.PeriodoTitulo2.height + 10
		Var.Relatorio.dataInicioTexto.x = 80
		Var.Relatorio.dataInicioTexto:setFillColor(0,0,0)

		Var.Relatorio.campoDiaFundo = display.newImageRect(Var.Relatorio.grupo,"fundo data.png",53,50)
		Var.Relatorio.campoMesFundo = display.newImageRect(Var.Relatorio.grupo,"fundo data.png",53,50)
		Var.Relatorio.campoAnoFundo = display.newImageRect(Var.Relatorio.grupo,"fundo data.png",100,50)
		Var.Relatorio.campoDiaFundo.anchorX=0;Var.Relatorio.campoMesFundo.anchorX=0;Var.Relatorio.campoAnoFundo.anchorX=0
 		Var.Relatorio.campoDiaFundo.anchorY=0;Var.Relatorio.campoMesFundo.anchorY=0;Var.Relatorio.campoAnoFundo.anchorY=0
 
		-- Create text field
		Var.Relatorio.campoDia = native.newTextField( 305, Var.Relatorio.dataInicioTexto.y + 50, 50, 50 )
		Var.Relatorio.campoDia:addEventListener( "userInput", DataListener )
		Var.Relatorio.campoDia.font = native.newFont( "Fontes/arialbd.ttf", 40 )
		Var.Relatorio.campoMes = native.newTextField(Var.Relatorio.campoDia.x + 95, Var.Relatorio.campoDia.y, 50, 50 )
		Var.Relatorio.campoMes:addEventListener( "userInput", DataListener )
		Var.Relatorio.campoMes.font = native.newFont( "Fontes/arialbd.ttf", 40 )
		Var.Relatorio.campoAno = native.newTextField(Var.Relatorio.campoMes.x + 95, Var.Relatorio.campoDia.y, 100, 50 )
		Var.Relatorio.campoAno:addEventListener( "userInput", DataListener )
		Var.Relatorio.campoAno.font = native.newFont( "Fontes/arialbd.ttf", 40 )
		Var.Relatorio.grupo:insert(Var.Relatorio.campoDia);Var.Relatorio.grupo:insert(Var.Relatorio.campoMes);Var.Relatorio.grupo:insert(Var.Relatorio.campoAno)
		Var.Relatorio.campoDia:setReturnKey( "next" );Var.Relatorio.campoMes:setReturnKey( "next" );Var.Relatorio.campoAno:setReturnKey( "next" )
		
		Var.Relatorio.campoDia:setTextColor(1,1,1);Var.Relatorio.campoMes:setTextColor(1,1,1);Var.Relatorio.campoAno:setTextColor(1,1,1)
		Var.Relatorio.campoDia.anchorX=0;Var.Relatorio.campoMes.anchorX=0;Var.Relatorio.campoAno.anchorX=0
		Var.Relatorio.campoDia.anchorY=0;Var.Relatorio.campoMes.anchorY=0;Var.Relatorio.campoAno.anchorY=0
		Var.Relatorio.campoDia.isEditable,Var.Relatorio.campoMes.isEditable,Var.Relatorio.campoAno.isEditable = true,true,true
		Var.Relatorio.campoDia.hasBackground,Var.Relatorio.campoMes.hasBackground,Var.Relatorio.campoAno.hasBackground = false,false,false
		Var.Relatorio.campoDia.size,Var.Relatorio.campoMes.size,Var.Relatorio.campoAno.size = 40,40,40
		Var.Relatorio.campoDia.inputType,Var.Relatorio.campoMes.inputType,Var.Relatorio.campoAno.inputType = "number","number","number"
		Var.Relatorio.campoDia.t = "d";Var.Relatorio.campoMes.t = "m";Var.Relatorio.campoAno.t = "a";
		Var.Relatorio.campoDia.placeholder,Var.Relatorio.campoMes.placeholder,Var.Relatorio.campoAno.placeholder = "00","00","0000"
		Var.Relatorio.campoDiaFundo.x,Var.Relatorio.campoMesFundo.x,Var.Relatorio.campoAnoFundo.x = Var.Relatorio.campoDia.x,Var.Relatorio.campoMes.x,Var.Relatorio.campoAno.x
		Var.Relatorio.campoDiaFundo.y,Var.Relatorio.campoMesFundo.y,Var.Relatorio.campoAnoFundo.y = Var.Relatorio.campoDia.y,Var.Relatorio.campoMes.y,Var.Relatorio.campoAno.y
		
		Var.Relatorio.dataFinalTexto = display.newText(Var.Relatorio.grupo,"Data final:    dia / mês / ano",0,0,"Fontes/segoeui.ttf",40)
		Var.Relatorio.dataFinalTexto.anchorX=0
		Var.Relatorio.dataFinalTexto.anchorY=0
		Var.Relatorio.dataFinalTexto.y = Var.Relatorio.dataInicioTexto.y+90
		Var.Relatorio.dataFinalTexto.x = 80
		Var.Relatorio.dataFinalTexto:setFillColor(0,0,0)
		
		-- Create text field
		Var.Relatorio.campoDiaFFundo = display.newImageRect(Var.Relatorio.grupo,"fundo data.png",53,50)
		Var.Relatorio.campoMesFFundo = display.newImageRect(Var.Relatorio.grupo,"fundo data.png",53,50)
		Var.Relatorio.campoAnoFFundo = display.newImageRect(Var.Relatorio.grupo,"fundo data.png",100,50)
		Var.Relatorio.campoDiaFFundo.anchorX=0;Var.Relatorio.campoMesFFundo.anchorX=0;Var.Relatorio.campoAnoFFundo.anchorX=0
 		Var.Relatorio.campoDiaFFundo.anchorY=0;Var.Relatorio.campoMesFFundo.anchorY=0;Var.Relatorio.campoAnoFFundo.anchorY=0
 
		
		Var.Relatorio.campoDiaF = native.newTextField( 305, Var.Relatorio.dataFinalTexto.y + 50, 50, 50 )
		Var.Relatorio.campoDiaF:addEventListener( "userInput", DataListener )
		Var.Relatorio.campoDiaF.font = native.newFont( "Fontes/arialbd.ttf", 40 )
		Var.Relatorio.campoMesF = native.newTextField(Var.Relatorio.campoDiaF.x + 95, Var.Relatorio.campoDiaF.y, 50, 50 )
		Var.Relatorio.campoMesF:addEventListener( "userInput", DataListener )
		Var.Relatorio.campoMesF.font = native.newFont( "Fontes/arialbd.ttf", 40 )
		Var.Relatorio.campoAnoF = native.newTextField(Var.Relatorio.campoMesF.x + 95, Var.Relatorio.campoDiaF.y, 100, 50 )
		Var.Relatorio.campoAnoF:addEventListener( "userInput", DataListener )
		Var.Relatorio.campoAnoF.font = native.newFont( "Fontes/arialbd.ttf", 40 )
		Var.Relatorio.grupo:insert(Var.Relatorio.campoDiaF);Var.Relatorio.grupo:insert(Var.Relatorio.campoMesF);Var.Relatorio.grupo:insert(Var.Relatorio.campoAnoF)
		Var.Relatorio.campoDiaF:setReturnKey( "next" );Var.Relatorio.campoMesF:setReturnKey( "next" );Var.Relatorio.campoAnoF:setReturnKey( "done" )
		
		Var.Relatorio.campoDiaF:setTextColor(1,1,1);Var.Relatorio.campoMesF:setTextColor(1,1,1);Var.Relatorio.campoAnoF:setTextColor(1,1,1)
		Var.Relatorio.campoDiaF.anchorX=0;Var.Relatorio.campoMesF.anchorX=0;Var.Relatorio.campoAnoF.anchorX=0
		Var.Relatorio.campoDiaF.anchorY=0;Var.Relatorio.campoMesF.anchorY=0;Var.Relatorio.campoAnoF.anchorY=0
		Var.Relatorio.campoDiaF.isEditable,Var.Relatorio.campoMesF.isEditable,Var.Relatorio.campoAnoF.isEditable = true,true,true
		Var.Relatorio.campoDiaF.hasBackground,Var.Relatorio.campoMesF.hasBackground,Var.Relatorio.campoAnoF.hasBackground = false,false,false
		Var.Relatorio.campoDiaF.size,Var.Relatorio.campoMesF.size,Var.Relatorio.campoAnoF.size = 40,40,40
		Var.Relatorio.campoDiaF.inputType,Var.Relatorio.campoMesF.inputType,Var.Relatorio.campoAnoF.inputType = "number","number","number"
		Var.Relatorio.campoDiaF.t = "d";Var.Relatorio.campoMesF.t = "m";Var.Relatorio.campoAnoF.t = "a";
		Var.Relatorio.campoDiaF.placeholder,Var.Relatorio.campoMesF.placeholder,Var.Relatorio.campoAnoF.placeholder = "00","00","0000"
		Var.Relatorio.campoDiaFFundo.x,Var.Relatorio.campoMesFFundo.x,Var.Relatorio.campoAnoFFundo.x = Var.Relatorio.campoDiaF.x,Var.Relatorio.campoMesF.x,Var.Relatorio.campoAnoF.x
		Var.Relatorio.campoDiaFFundo.y,Var.Relatorio.campoMesFFundo.y,Var.Relatorio.campoAnoFFundo.y = Var.Relatorio.campoDiaF.y,Var.Relatorio.campoMesF.y,Var.Relatorio.campoAnoF.y
		
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
		
		Var.Relatorio.campoDataTimer1 = timer.performWithDelay(50,verificarData1,-1)
		Var.Relatorio.campoDataTimer2 = timer.performWithDelay(50,verificarData2,-1)
		Var.Relatorio.campoDataTimer3 = timer.performWithDelay(50,verificarData3,-1)
		
		---------------------------------------------------------
		-- FORMATAÇÃO --
		---------------------------------------------------------
		Var.Relatorio.FormatarTitulo0 = display.newText(Var.Relatorio.grupo,"___________________________",0,0,"Fontes/segoeuib.ttf",50)
		Var.Relatorio.FormatarTitulo0.anchorY=0
		Var.Relatorio.FormatarTitulo0.y,Var.Relatorio.FormatarTitulo0.x = Var.Relatorio.campoAnoFFundo.y+Var.Relatorio.campoAnoFFundo.height+20-55,W/2
		Var.Relatorio.FormatarTitulo0:setFillColor(0,0,0)

		Var.Relatorio.FormatarTitulo = display.newText(Var.Relatorio.grupo," Formatação:",0,0,"Fontes/segoeuib.ttf",50)
		Var.Relatorio.FormatarTitulo.anchorX=0
		Var.Relatorio.FormatarTitulo.anchorY=0
		Var.Relatorio.FormatarTitulo.y = Var.Relatorio.campoAnoFFundo.y+Var.Relatorio.campoAnoFFundo.height+18
		Var.Relatorio.FormatarTitulo.x = 80
		Var.Relatorio.FormatarTitulo:setFillColor(0,0,0)
		
		Var.Relatorio.FormatarTitulo2 = display.newText(Var.Relatorio.grupo,"___________________________",0,0,"Fontes/segoeuib.ttf",50)
		Var.Relatorio.FormatarTitulo2.anchorY=0
		Var.Relatorio.FormatarTitulo2.y,Var.Relatorio.FormatarTitulo2.x = Var.Relatorio.FormatarTitulo.y+10,W/2
		Var.Relatorio.FormatarTitulo2:setFillColor(0,0,0)
		
		Var.Relatorio.FormatarTexto1 = display.newText(Var.Relatorio.grupo,"por datas:",0,0,"Fontes/segoeui.ttf",40)
		Var.Relatorio.FormatarTexto1.anchorX=0
		Var.Relatorio.FormatarTexto1.anchorY=0
		Var.Relatorio.FormatarTexto1.y = Var.Relatorio.FormatarTitulo2.y+Var.Relatorio.FormatarTitulo2.height + 15
		Var.Relatorio.FormatarTexto1.x = 80
		Var.Relatorio.FormatarTexto1:setFillColor(0,0,0)
		
		Var.Relatorio.FormatarTexto2 = display.newText(Var.Relatorio.grupo,"por data e tipos:",0,0,"Fontes/segoeui.ttf",40)
		Var.Relatorio.FormatarTexto2.anchorX=0
		Var.Relatorio.FormatarTexto2.anchorY=0
		Var.Relatorio.FormatarTexto2.y = Var.Relatorio.FormatarTexto1.y+Var.Relatorio.FormatarTexto1.height + 10 + 50
		Var.Relatorio.FormatarTexto2.x = 80
		Var.Relatorio.FormatarTexto2:setFillColor(0,0,0)
		
		Var.Relatorio.FormatarTexto3 = display.newText(Var.Relatorio.grupo,"por tipo e datas:",0,0,"Fontes/segoeui.ttf",40)
		Var.Relatorio.FormatarTexto3.anchorX=0
		Var.Relatorio.FormatarTexto3.anchorY=0
		Var.Relatorio.FormatarTexto3.y = Var.Relatorio.FormatarTexto2.y+Var.Relatorio.FormatarTexto2.height + 10 + 50
		Var.Relatorio.FormatarTexto3.x = 80
		Var.Relatorio.FormatarTexto3:setFillColor(0,0,0)
		
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
	end
	
	grupoRelatorio.botao = widget.newButton {
		defaultFile = "iconeRelatorio.png",
		overFile = "iconeRelatorioD.png",
		width = 80,
		height = 80,
		onRelease = abrirMenu
	}
	
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
function funcGlobal.criarDescricao(atributos,jaClicou,contador)
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
		local texto = {}
		local function mudarTamanhoFonte(atrib)
			if atrib.acao == "aumentar" then
				print("aumentar")
				atributos.modificar = atributos.modificar + 5
				grupoRemover.removerTudo()
				funcGlobal.criarDescricao(atributos,false,contador)
			elseif atrib.acao == "diminuir" then
				print("diminuir")
				atributos.modificar = atributos.modificar - 5
				grupoRemover.removerTudo()
				funcGlobal.criarDescricao(atributos,false,contador)
			end
			return true
		end
		
		texto = colocarFormatacaoTexto.criarTextodePalavras({tela = atributos.tela,texto = textoAColocar,x = 0,Y = 0,fonte = "Fontes/segoeui.ttf",tamanho = tamanho + atributos.modificar,cor = {0,0,0},largura = larguraTexto,url = url, alinhamento = alinhamento,margem = margem,xNegativo = 0, modificou = 0, embeded = nil, endereco = atributos.enderecoArquivos, contTexto = contador,whenOpenedURL = nil--[[clearNativeScreenElements]],whenClosedURL = nil--[[restoreNativeScreenElements]],mudarTamanhoFonte = mudarTamanhoFonte,EhIndice = false,dic = atributos.dicPalavras, tipoTTS = varGlobal.TTSTipo,temHistorico = varGlobal.temHistorico})
		
		--local texto = colocarFormatacaoTexto.criarTextodePalavras({contTexto = contador,texto = textoAColocar,x = 0,Y = 0,fonte = "Fontes/segoeui.ttf",tamanho = tamanho + atributos.modificar,cor = {0,0,0},largura = larguraTexto,url = url, alinhamento = alinhamento,margem = margem,xNegativo = 0, modificou = 0, endereco = varGlobal.enderecoArquivos, tipoTTS = varGlobal.TTSTipo})
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
		
		
		
		function grupoRemover.removerTudo(e)
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
			restoreNativeScreenElements()
			if grupoRemover then
				grupoRemover:removeSelf()
				grupoRemover = nil
			end
			timer.performWithDelay(1,function()
				local date = os.date( "*t" )
				local data = date.day.."/"..date.month.."/"..date.year
				local hora = date.hour..":"..date.min..":"..date.sec
				local artigo = "do"
				if atributos.tipoInteracao == "imagem" or atributos.tipoInteracao == "animacao" then
					artigo = "da"
				end
				local pH = funcGlobal.pegarNumeroPaginaRomanosHistorico(varGlobal.PagH)
				local vetorJson = {
					tipoInteracao = atributos.tipoInteracao,
					pagina_livro = varGlobal.PagH,
					objeto_id = contador,
					acao = "fechar detalhes",
					tempo_aberto = varGlobal.tempoAbertoDetalhesNumero,
					relatorio = data.."| Fechou a descrição "..artigo.." "..atributos.tipoInteracao.." "..contador.." da página "..pH.." às "..hora..". A vizualização foi de ".. auxFuncs.SecondsToClock(varGlobal.tempoAbertoDetalhesNumero).."."
				};
				if GRUPOGERAL.subPagina then
					vetorJson.subPagina = GRUPOGERAL.subPagina;
				end
				funcGlobal.escreverNoHistorico(varGlobal.HistoricoDetalhesSomFechar..contador,vetorJson);
				if varGlobal.tempoAbertoDetalhes then
					timer.cancel(varGlobal.tempoAbertoDetalhes)
				end
				varGlobal.tempoAbertoDetalhesNumero = 0
				restoreNativeScreenElements()
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
		backButtonTelaAluno:addEventListener("tap",grupoRemover.removerTudo)
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
				grupoRemover.removerTudo(); 
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
		fundoPreto:addEventListener("tap",grupoRemover.removerTudo)
		
		
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
						grupoRemover.removerTudo()
						funcGlobal.criarDescricao(atributos,false,contador)
					elseif condicao1 < condicao2 then
						print("diminuir")
						atributos.modificar = atributos.modificar - 5
						grupoRemover.removerTudo()
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
			local date = os.date( "*t" )
			local data = date.day.."/"..date.month.."/"..date.year
			local hora = date.hour..":"..date.min..":"..date.sec
			local artigo = "do"
			if atributos.tipoInteracao == "imagem" or atributos.tipoInteracao == "animacao" then
				artigo = "da"
			end
			local pH = funcGlobal.pegarNumeroPaginaRomanosHistorico(varGlobal.PagH)
			local vetorJson = {
				tipoInteracao = atributos.tipoInteracao,
				pagina_livro = varGlobal.PagH,
				objeto_id = contador,
				acao = "abrir detalhes",
				relatorio = data.."| Abriu a descrição "..artigo.." "..atributos.tipoInteracao.." "..contador.." da página "..pH.." às "..hora.."."
			};
			if GRUPOGERAL.subPagina then
				vetorJson.subPagina = GRUPOGERAL.subPagina;
			end
			funcGlobal.escreverNoHistorico(varGlobal.HistoricoDetalhesSom..contador,vetorJson)
			if varGlobal.tempoAbertoDetalhes then
				timer.cancel(varGlobal.tempoAbertoDetalhes)
			end
			varGlobal.tempoAbertoDetalhesNumero = 0
			varGlobal.tempoAbertoDetalhes = timer.performWithDelay(100,function() varGlobal.tempoAbertoDetalhesNumero = varGlobal.tempoAbertoDetalhesNumero + 100 end,-1)
			
		end
		timer.performWithDelay(100,function()clearNativeScreenElements()end,1)
	end
end
----------------------------------------------------------
--  COLOCAR CONFIGS VOZ (TTS)
----------------------------------------------------------
function funcGlobal.colocarBotaoConfig(atributos,telas,varGlobal)
	local grupoBotao = display.newGroup()
	local botaoConfigRect = display.newImageRect(grupoBotao,varGlobal.menuConfigBotaoImagem,60,60)
	botaoConfigRect.anchorX = 1;botaoConfigRect.anchorY = 0
	botaoConfigRect.x = W - 130;botaoConfigRect.y = atributos.y
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
			--[[local params = {}
			-- Tell network.request() that we want the "began" and "progress" events:
			params.progress = "download"
			params.response = {
				filename = "diminuiAudio0.MP3",
				baseDirectory = system.DocumentsDirectory
			}
			local frase = "diminuiu para 0"
			local url = "https://api.voicerss.org/?key="..APIkey.thithou1.."&hl="..varGlobal.TTSVozIdioma.."&c=MP3&r=-1".."&f=".."12khz_16bit_mono".."&src="..frase
			requerimentoDownload = network.request( url, "GET", networkListener000,  params )
			params.response.filename = "diminuiAudio1.MP3"
			local frase = "diminuiu para mais 1"
			local url = "https://api.voicerss.org/?key="..APIkey.thithou1.."&hl="..varGlobal.TTSVozIdioma.."&c=MP3&r=-1".."&f=".."12khz_16bit_mono".."&src="..frase
			requerimentoDownload = network.request( url, "GET", networkListener000,  params )
			params.response.filename = "diminuiAudio2.MP3"
			local frase = "diminuiu para mais 2"
			local url = "https://api.voicerss.org/?key="..APIkey.thithou1.."&hl="..varGlobal.TTSVozIdioma.."&c=MP3&r=-1".."&f=".."12khz_16bit_mono".."&src="..frase
			requerimentoDownload = network.request( url, "GET", networkListener000,  params )
			params.response.filename = "diminuiAudio3.MP3"
			local frase = "diminuiu para mais 3"
			local url = "https://api.voicerss.org/?key="..APIkey.thithou1.."&hl="..varGlobal.TTSVozIdioma.."&c=MP3&r=-1".."&f=".."12khz_16bit_mono".."&src="..frase
			requerimentoDownload = network.request( url, "GET", networkListener000,  params )
			params.response.filename = "diminuiAudio4.MP3"
			local frase = "diminuiu para mais 4"
			local url = "https://api.voicerss.org/?key="..APIkey.thithou1.."&hl="..varGlobal.TTSVozIdioma.."&c=MP3&r=-1".."&f=".."12khz_16bit_mono".."&src="..frase
			requerimentoDownload = network.request( url, "GET", networkListener000,  params )
			params.response.filename = "diminuiAudio5.MP3"
			local frase = "diminuiu para mais 5"
			local url = "https://api.voicerss.org/?key="..APIkey.thithou1.."&hl="..varGlobal.TTSVozIdioma.."&c=MP3&r=-1".."&f=".."12khz_16bit_mono".."&src="..frase
			requerimentoDownload = network.request( url, "GET", networkListener000,  params )
			params.response.filename = "diminuiAudio6.MP3"
			local frase = "diminuiu para mais 6"
			local url = "https://api.voicerss.org/?key="..APIkey.thithou1.."&hl="..varGlobal.TTSVozIdioma.."&c=MP3&r=-1".."&f=".."12khz_16bit_mono".."&src="..frase
			requerimentoDownload = network.request( url, "GET", networkListener000,  params )
			params.response.filename = "diminuiAudio_1.MP3"
			local frase = "diminuiu para menos 1"
			local url = "https://api.voicerss.org/?key="..APIkey.thithou1.."&hl="..varGlobal.TTSVozIdioma.."&c=MP3&r=-1".."&f=".."12khz_16bit_mono".."&src="..frase
			requerimentoDownload = network.request( url, "GET", networkListener000,  params )]]
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
			
			grupoBotao.GMenu.telaProtetiva = auxFuncs.TelaProtetiva()
			grupoBotao.GMenu.telaProtetiva.alpha = .5
			
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
			local function abrirMenuLocalizar(event)
				-- fechar menu config ------------------------------------
				audio.stop()
				media.stopSound()
				grupoBotao.GMenu.MenuConfig:removeSelf()
				grupoBotao.GMenu.quantidadeAtual:removeSelf()
				grupoBotao.GMenu.botaoDeslogar:removeSelf()
				grupoBotao.GMenu.localizar:removeSelf()
				grupoBotao.GMenu.newStepper:removeSelf()
				grupoBotao.GMenu.fecharMenu:removeSelf()
				----------------------------------------------------------
				-- criarVetorPalavrasComContexto
				if not grupoBotao.GMenu.vetorPalavras then
					grupoBotao.GMenu.vetorPalavras = auxFuncs.loadTable("palavrasEContextosLivro.json","res")
				end
				----------------------------------------------------------
				grupoBotao.GMenu.fundoLocalizar = display.newImageRect("menuPagina.png",W,H)
				grupoBotao.GMenu.fundoLocalizar.height = 800
				grupoBotao.GMenu.fundoLocalizar.alpha = 1
				grupoBotao.GMenu.fundoLocalizar.x,grupoBotao.GMenu.fundoLocalizar.y = W/2,H/2
				grupoBotao.GMenu.fundoLocalizar.isHitTestable = true
				grupoBotao.GMenu.fundoLocalizar:addEventListener("tap",function()return true end)
				grupoBotao.GMenu.fundoLocalizar:addEventListener("touch",function()return true end)
				grupoBotao.GMenu.textoLocalizar = display.newText("LOCALIZAR",0,0,"Fontes/segoeui.ttf",70)
				grupoBotao.GMenu.textoLocalizar:setFillColor(0,0,0)
				grupoBotao.GMenu.textoLocalizar.x = 95 + grupoBotao.GMenu.textoLocalizar.width/2
				grupoBotao.GMenu.textoLocalizar.y = 325 + grupoBotao.GMenu.textoLocalizar.height/2
				
				grupoBotao.GMenu.campoDeTexto = native.newTextField(W/2 - 60,475,400,80)
				grupoBotao.GMenu.palavraPesquisada = ""
				function grupoBotao.localizarPeloCampoDeTexto(event)
					
					if grupoBotao.GMenu.campoDeTexto.text and type(grupoBotao.GMenu.campoDeTexto.text) == "string" and #grupoBotao.GMenu.campoDeTexto.text > 0 then
						local resultados = false
						local palavra = grupoBotao.GMenu.campoDeTexto.text--string.gsub(grupoBotao.GMenu.campoDeTexto.text,"%-","%%-")
						local vetVarPalavras = {}
						vetVarPalavras[1] = grupoBotao.GMenu.vetorPalavras[conversor.stringLowerAcento(palavra)]
						if vetVarPalavras[1] then
							vetVarPalavras[1].palavraa = conversor.stringLowerAcento(palavra)
						end
						vetVarPalavras[2] = grupoBotao.GMenu.vetorPalavras[conversor.stringUpperAcento(palavra)]
						if vetVarPalavras[2] then
							vetVarPalavras[2].palavraa = conversor.stringUpperAcento(palavra)
						end
						if #palavra > 1 then
							local palavraM = conversor.stringUpperAcento(string.sub(palavra,1,1))..conversor.stringLowerAcento(string.sub(palavra,2,#palavra))
							vetVarPalavras[3] = grupoBotao.GMenu.vetorPalavras[palavraM]
							if vetVarPalavras[3] then
								vetVarPalavras[3].palavraa = palavraM
							end
						end
						
						grupoBotao.GMenu.palavraPesquisada = grupoBotao.GMenu.campoDeTexto.text
						if vetVarPalavras and vetVarPalavras[1] and vetVarPalavras[1].PalavrasIDs then
							for i=1,#vetVarPalavras do
								local aux = vetVarPalavras[i]
								local paginasAux = {}
								local forFunc = {}
								function forFunc.loopAux(i,limite)
									if not resultados then resultados = {} end
									table.insert(resultados,{string.match(aux.PalavrasIDs[i],"([%d]+)"),aux.frases[i]["2"],aux.palavraa,string.match(aux.PalavrasIDs[i],"|([%d]+)|")})
									forFunc.loop(i+1,limite)
								end
								function forFunc.loop(i,limite) if i<=limite then forFunc.loopAux(i,limite) end end
								local limite = #aux.PalavrasIDs
								forFunc.loop(1,limite)
							end
						end
						grupoBotao.GMenu.tableViewResults:deleteAllRows()
						if not resultados then -- se não achou nada para a palavra
							grupoBotao.GMenu.tableViewResults:insertRow{rowHeight = 100, params = {results = false}}
						else
							-- encontrou resultados, criar table com eles:
							for i=1,#resultados do
								grupoBotao.GMenu.tableViewResults:insertRow{rowHeight = 60,params = {results = resultados[i]}}
							end
						end
					end
				end
				grupoBotao.GMenu.botaoOK = widget.newButton {
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
					onRelease = grupoBotao.localizarPeloCampoDeTexto
				}
				grupoBotao.GMenu.botaoOK.x = grupoBotao.GMenu.campoDeTexto.x + grupoBotao.GMenu.campoDeTexto.width/2 + grupoBotao.GMenu.botaoOK.width/2 + 10
				grupoBotao.GMenu.botaoOK.y = grupoBotao.GMenu.campoDeTexto.y
				
				function grupoBotao.gerarLinha( event )
					local phase = event.phase
					local row = event.row
					local groupContentHeight = row.contentHeight
					
					local result = row.params.results
				 
					local rowHeight = row.contentHeight
					local rowWidth = row.contentWidth
					local linhaSuperior = display.newRect(row,250,0,500,1)
					linhaSuperior:setFillColor(0,0,0)
					if not result then
						row.rowTitle = display.newText( row, "Nenhuma ocorrência da palavra: "..grupoBotao.GMenu.campoDeTexto.text,0,0, 500, rowHeight,"Fontes/segoeui.ttf", 40 )
						row.rowTitle.x = 10
						row.rowTitle.anchorX = 0
						row.rowTitle.y = groupContentHeight * 0.5
						row.rowTitle:setFillColor(0,0,0)
					else
						local pagina = result[1]
						local frase = result[2]
						local palavraa = result[3]
						local elemento = result[4]
						row.rowTitle = display.newText( row, "Página "..pagina,0,0,0, rowHeight,"Fontes/segoeui.ttf", 30 )
						row.rowTitle.x = 10
						row.rowTitle.anchorX = 0
						row.rowTitle.y = groupContentHeight * 0.5 + 5
						row.rowTitle:setFillColor(0,0,0)
						local function irParaPagina()
							print(telas.pagina)
							local paginaAux = tonumber(pagina)
							telas.localizar = grupoBotao.GMenu.palavraPesquisada
							if paginaAux then
								local paginaReal = paginaAux - varGlobal.contagemInicialPaginas + telas.numeroTotal.PaginasPre+telas.numeroTotal.Indices +1
								GRUPOGERAL.irParaElemento = elemento
								print("elemento = ",elemento)
								criarCursoAux(telas, paginaReal)
							else
								if elemento then
									GRUPOGERAL.irParaElemento = elemento
								end
								criarCursoAux(telas, pagina)
							end
						end
						row.botaoIr = widget.newButton {
							shape= "roundedRect",
							fillColor = {default = {46/255,171/255,200/255},over = {46/510,171/510,200/510}},
							strokeColor = {default = {0,0,0},over = {0,0,0,0.5}},
							labelColor = {default = {0,0,0},over = {0,0,0,0.5}},
							labelAlign = "center",
							label = "Ir",
							font = "Fontes/segoeui.ttf",
							fontSize = 40,
							strokeWidth = 1,
							radius = 5,
							width = 40,
							height = 40,
							onRelease = irParaPagina
						}
						row.botaoIr.y = 5 + row.botaoIr.height/2
						row.botaoIr.x = row.width - row.botaoIr.width/2 - 10
						row:insert(row.botaoIr)
						local function AbrirFrase()
							local function onComplete(event)
								if ( event.action == "clicked" ) then
									local i = event.index
									if ( i == 1 ) then
										irParaPagina()
									elseif ( i == 2 ) then
										--sair, não faça nada
									end
								end
							end
							native.showAlert(palavraa.."-> Frase",frase,{"Ir","cancelar"},onComplete )
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
						row.botaoFrase.x = row.botaoIr.x - row.botaoIr.width/2 - row.botaoFrase.width/2 - 20
						row:insert(row.botaoFrase)
					end
					local linhaInferior = display.newRect(row,250,groupContentHeight,500,1)
					linhaInferior:setFillColor(0,0,0)
				end
				
				grupoBotao.GMenu.tableViewResults = widget.newTableView(
					{
						height = 400,
						width = 500,
						onRowRender = grupoBotao.gerarLinha,
						onRowTouch = function()end,
						listener = scrollListener,
						rowTouchDelay =0
					}
				)
				grupoBotao.GMenu.tableViewResults.x = W/2
				grupoBotao.GMenu.tableViewResults.y = grupoBotao.GMenu.botaoOK.y + grupoBotao.GMenu.botaoOK.height/2 + 20 + grupoBotao.GMenu.tableViewResults.height/2
				
				local function fecharMenulocalizar(event)
					grupoBotao.GMenu.fecharMenu:setEnabled(false)
					grupoBotao.GMenu:removeSelf()
					audio.stop()
					media.stopSound()
					return true
				end
				grupoBotao.GMenu.fecharMenu = widget.newButton {
					onRelease = fecharMenulocalizar,
					emboss = false,
					-- Properties for a rounded rectangle button
					defaultFile = "closeMenuButton2.png",
					overFile = "closeMenuButton2D.png"
				}
				grupoBotao.GMenu.fecharMenu.anchorX=1
				grupoBotao.GMenu.fecharMenu.anchorY=0
				grupoBotao.GMenu.fecharMenu.x = W - 100
				grupoBotao.GMenu.fecharMenu.y = 335
				
				grupoBotao.GMenu:insert(grupoBotao.GMenu.fundoLocalizar)
				grupoBotao.GMenu:insert(grupoBotao.GMenu.textoLocalizar)
				grupoBotao.GMenu:insert(grupoBotao.GMenu.fecharMenu)
				grupoBotao.GMenu:insert(grupoBotao.GMenu.campoDeTexto)
				grupoBotao.GMenu:insert(grupoBotao.GMenu.botaoOK)
				grupoBotao.GMenu:insert(grupoBotao.GMenu.tableViewResults)
				return true
			end
			grupoBotao.GMenu.localizar = widget.newButton(
				{
					shape = "roundedRect",
					strokeWidth = 3,
					width = 350,
					height = 60,
					fontSize = 50,
					strokeColor = {default = {0,0,0,0.8},over = {1,1,1,0.5}},
					fillColor = {default = {110/255,161/255,164/255,0},over = {110/255,161/255,164/255,0}},
					label = "LOCALIZAR",
					font = "Fontes/segoeui.ttf",
					labelColor = {default = {1,1,1},over = {0,0,0}},
					onRelease = abrirMenuLocalizar
				}
			)
			grupoBotao.GMenu.localizar.x = 260
			grupoBotao.GMenu.localizar.y = 170
			
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
						print(event.response)
						LimparTemporaryDirectory()
						LimparDocumentsDirectory()
						local function onComplete()
							os.exit()
						end
						local som = audio.loadStream(varGlobal.menuConfigBotaoDeslogar)
						timerRequerimento = timer.performWithDelay(16,function() audio.play(som,{onComplete=onComplete}) end,1)
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
				defaultFile = "closeMenuButton2.png",
				overFile = "closeMenuButton2D.png"
			}
			grupoBotao.GMenu.fecharMenu.clicado = false
			grupoBotao.GMenu.fecharMenu.anchorX=1
			grupoBotao.GMenu.fecharMenu.anchorY=0
			grupoBotao.GMenu.fecharMenu.x = W - 85
			grupoBotao.GMenu.fecharMenu.y = 140
			--------------------------------------------------------------------------
			--------------------------------------------------------------------------
			grupoBotao.GMenu:insert(grupoBotao.GMenu.telaProtetiva)
			grupoBotao.GMenu:insert(grupoBotao.GMenu.MenuConfig)
			grupoBotao.GMenu:insert(grupoBotao.GMenu.newStepper)
			grupoBotao.GMenu:insert(grupoBotao.GMenu.quantidadeAtual)
			grupoBotao.GMenu:insert(grupoBotao.GMenu.localizar)
			grupoBotao.GMenu:insert(grupoBotao.GMenu.botaoDeslogar)
			grupoBotao.GMenu:insert(grupoBotao.GMenu.fecharMenu)
			
			
			return true
		end
		e.target.clicado = false
		return true
	end
	botaoConfigRect:addEventListener("tap",abrirMenuConfig)
	
	return grupoBotao
end
M.colocarBotaoConfig = colocarBotaoConfig
----------------------------------------------------------
--	COLOCAR IMAGEM										--
--	Funcao responsavel por colocar uma imagem			--
--  na tela, podendo ser tela inteira					-- 
--  ou dimensionada										--
--  ATRIBUTOS: arquivo,comprimento,altura,x,y,*posicao	--
--  *Posicao: (base, centro, topo), zoom (sim ou nao)--
----------------------------------------------------------
local function colocarImagem(atributos,telas)
	if naoVazio(atributos) then
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
					local aux2 = W/imagem.width
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
					local auxiliarW = imagem.width
					local auxiliarH = imagem.height
					local aux2 = (W-margem)/imagem.width
					imagem.width = aux2*imagem.width
					imagem.height = aux2*imagem.height
				end
				
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
				if TemUmaImagem[1] == 0 then
					TemUmaImagem[3] = imagem.y
					TemUmaImagem[2] = imagem.x
					TemUmaImagem[5] = imagem.height
					TemUmaImagem[4] = imagem.width
				elseif TemUmaImagem[1] == 1 then
					if TemUmaImagem[3] < H/2 then
					else
						TemUmaImagem[3] = imagem.y
						TemUmaImagem[2] = imagem.x
						TemUmaImagem[5] = imagem.height
						TemUmaImagem[4] = imagem.width
					end
				end
				TemUmaImagem[1] = 1
				imagem.pOsicao = imagem.y + imagem.height
				imagem.posicao1 = atributos.posicao
				if(atributos.posicao=='base') then
					if telas then
							if telas.texto then
								local texto = elemTela.colocarTexto(telas.texto,telas)
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
									local textos = elemTela.colocarTexto(telas.textos[txt],telas)
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
M.colocarImagem = colocarImagem

------------------------------------------------------------------
--	COLOCAR HTML View											--
--	Funcao responsavel por abrir arquivo de html e mostra-lo, 	--
--  aceita arquivos htm, html									--
--  ATRIBUTOS: arquivo, x, y, largura, altura					--
------------------------------------------------------------------
local function colocarHTML(atributos)
	if naoVazio(atributos) then
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
M.colocarHTML = colocarHTML
--------------------------------------------------------------------------------------
--	COLOCAR BOTAO 																	--
--	Funcao responsavel por criar um botao 											--
--  de acordo com as opcoes desejadas e acoes pre-definidas							--
--  ATRIBUTOS: fundo,titulo(texto,tamanho,cor),altura,comprimento,x,y,*posicao,*acao--													--
--  *tipo: texto, botao 	  														--
--  *Acoes: iniciaCurso, iniciaPagina, irPara 										--
--------------------------------------------------------------------------------------
-- colocarBotao({fundoUp = "",fundoDown = "",acao = "",altura = 0,comprimento = 0,x = 0,y = 0, posicao = "",tipo = "",titulo = {texto = "",tamanho = 30,cor={0,0,0}}},telas)
local function colocarBotao(atributos,telas)
	
	local botao = {}
	local grupoBotao = display.newGroup()
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
	if telas[paginaAtual] and telas[paginaAtual].cont then
		contBotao = telas[paginaAtual].cont.botoes
	end
	
	local pAuSaDo = false
	local function handleButtonEvent( event )
		local botao = event.target
		if ( "began" == event.phase ) then

		elseif("moved" == event.phase or "cancelled" == event.phase) then

		elseif ( "ended" == event.phase ) then
			print(atributos.acao)
			print(atributos.som)
			--== AÇÃO SELECIONAR MATERIAL ==--
			if botao.evento == "selecionar material" then
				if grupoBotao.selecionarMaterial then
					grupoBotao.selecionarMaterial()
				end
			--== AÇÃO IR PARA ==--
			elseif botao.evento == "irPara" then
				if botao.tempoAberto then
					timer.cancel(botao.tempoAberto)
					botao.tempoAberto = nil
				end
				if atributos.exercicioVoltar then
					local date = os.date( "*t" )
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
					funcGlobal.escreverNoHistorico(varGlobal.HistoricoVoltarParaQuestao,vetorJson)
				else
					local date = os.date( "*t" )
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
					funcGlobal.escreverNoHistorico(varGlobal.HistoricoBotaoPagina..atributos.numero,vetorJson)
				end
				if atributos.Telas then

					verificaAcaoBotao(botao,atributos.Telas)
				else
					verificaAcaoBotao(botao,telas)
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
							local date = os.date( "*t" )
							local data = date.day.."/"..date.month.."/"..date.year
							local hora = date.hour..":"..date.min..":"..date.sec
							local pH = funcGlobal.pegarNumeroPaginaRomanosHistorico(varGlobal.PagH)
							local vetorJson = {
								tipoInteracao = "botao",
								pagina_livro = varGlobal.PagH,
								objeto_id = contBotao,
								acao = "cancelar",
								subtipo = "de audio",
								tempo_aberto = botao.tempoAbertoNumero,
								relatorio = data.."| Cancelou o áudio do botão "..contBotao.." da página "..pH.. " às ".. hora.."."
							}
							if GRUPOGERAL.subPagina then
								vetorJson.subPagina = GRUPOGERAL.subPagina
							end
							funcGlobal.escreverNoHistorico(varGlobal.HistoricoBotaoSomCancelou..contBotao,vetorJson)--atributos.som)
							if botao.tempoAberto then
								timer.cancel(botao.tempoAberto)
								botao.tempoAberto = nil
							end
							botao.tempoAbertoNumero = 0
						else
							local date = os.date( "*t" )
							local data = date.day.."/"..date.month.."/"..date.year
							local hora = date.hour..":"..date.min..":"..date.sec
							local pH = funcGlobal.pegarNumeroPaginaRomanosHistorico(varGlobal.PagH)
							local vetorJson = {
								tipoInteracao = "botao",
								pagina_livro = varGlobal.PagH,
								objeto_id = contBotao,
								acao = "terminar",
								subtipo = "de audio",
								tempo_aberto = botao.tempoAbertoNumero,
								relatorio = data.."| Terminou de ouvir o áudio do botão "..contBotao.." da página "..pH.. " às ".. hora.."."
							}
							if GRUPOGERAL.subPagina then
								vetorJson.subPagina = GRUPOGERAL.subPagina
							end
							funcGlobal.escreverNoHistorico(varGlobal.HistoricoBotaoSomFechou..contBotao,vetorJson)--atributos.som)
							if botao.tempoAberto then
								timer.cancel(botao.tempoAberto)
								botao.tempoAberto = nil
							end
							botao.tempoAbertoNumero = 0
						end
						
						if atributos.avancar and atributos.avancar == "sim" then
							if event.completed then
								criarCursoAux(telas, paginaAtual+1)
								paginaAtual=paginaAtual+1
							end
						end
					end
					event.target.som = audio.play(som, {onComplete = onComplete})
					
				end
				local date = os.date( "*t" )
				local data = date.day.."/"..date.month.."/"..date.year
				local hora = date.hour..":"..date.min..":"..date.sec
				local pH = funcGlobal.pegarNumeroPaginaRomanosHistorico(varGlobal.PagH)
				local vetorJson = {
					tipoInteracao = "botao",
					pagina_livro = varGlobal.PagH,
					objeto_id = contBotao,
					acao = "executar",
					subtipo = "de audio",
					relatorio = data.."| Executou o áudio do botão "..contBotao.." da página "..pH.. " às ".. hora.."."
				}
				if GRUPOGERAL.subPagina then
					vetorJson.subPagina = GRUPOGERAL.subPagina
				end
				funcGlobal.escreverNoHistorico(varGlobal.HistoricoBotaoSom..contBotao,vetorJson)--atributos.som)
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
						funcGlobal.escreverNoHistorico(varGlobal.HistoricoBotaoVideo..contBotao,vetorJson)
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
									local date = os.date( "*t" )
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
									funcGlobal.escreverNoHistorico(varGlobal.HistoricoBotaoVideoFechou..contBotao,vetorJson)--atributos.video)
									if botao.tempoAberto then
										timer.cancel(botao.tempoAberto)
										botao.tempoAberto = nil
									end
									botao.tempoAbertoNumero = 0
								else
									local date = os.date( "*t" )
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
									funcGlobal.escreverNoHistorico(varGlobal.HistoricoBotaoVideoCancelou..contBotao,vetorJson)--atributos.video)
									if botao.tempoAberto then
										timer.cancel(botao.tempoAberto)
										botao.tempoAberto = nil
									end
									botao.tempoAbertoNumero = 0
								end
							end
							--print(atributos.video)
							
							media.playVideo( atributos.video, true, onComplete )
							local date = os.date( "*t" )
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
							funcGlobal.escreverNoHistorico(varGlobal.HistoricoBotaoVideo..contBotao,vetorJson)--atributos.video)
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
						local function mudarTamanhoFonte(atrib)
							if atrib.acao == "aumentar" then
								print("aumentar")
								atributos.modificar = atributos.modificar + 5
								grupoTexto.removerTudo()
								criarTexto()
							elseif atrib.acao == "diminuir" then
								print("diminuir")
								atributos.modificar = atributos.modificar - 5
								grupoTexto.removerTudo()
								criarTexto()
							end
							return true
						end
						
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
										grupoTexto.removerTudo()
										criarTexto()
									elseif condicao1 < condicao2 then
										print("diminuir")
										atributos.modificar = atributos.modificar - 5
										grupoTexto.removerTudo()
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
						
						texto = colocarFormatacaoTexto.criarTextodePalavras({tela = atributos.tela,texto = textoAColocar,x = 0,Y = 0,fonte = "Fontes/segoeui.ttf",tamanho = tamanho + atributos.modificar,cor = {0,0,0},largura = larguraTexto,url = url, alinhamento = alinhamento,margem = margem,xNegativo = 0, modificou = 0, embeded = nil, endereco = atributos.enderecoArquivos, contTexto = contador,whenOpenedURL = clearNativeScreenElements,whenClosedURL = restoreNativeScreenElements,mudarTamanhoFonte = mudarTamanhoFonte,EhIndice = false,dic = atributos.dicPalavras, tipoTTS = varGlobal.TTSTipo,temHistorico = varGlobal.temHistorico})
						--local texto = colocarFormatacaoTexto.criarTextodePalavras({texto = textoAColocar,x = 0,Y = 0,fonte = "Fontes/segoeui.ttf",tamanho = tamanho + atributos.modificar,cor = {0,0,0},largura = largura,url = url, alinhamento = alinhamento,margem = margem,xNegativo = 0, modificou = 0, endereco = varGlobal.enderecoArquivos, tipoTTS = varGlobal.TTSTipo})
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
						
						
						function grupoTexto.removerTudo()
							if scrollView.timer then
								timer.cancel(scrollView.timer)
								scrollView.timer = nil
							end
							scrollView:removeSelf(); 
							if texto.botaoAumentar then
								texto.botaoAumentar:removeSelf()
								texto.botaoAumentar = nil
							end
							if fundoPreto then
								fundoPreto:removeSelf();
								fundoPreto = nil
							end
							timer.performWithDelay(1,function()
								
								local date = os.date( "*t" )
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
								funcGlobal.escreverNoHistorico(varGlobal.HistoricoBotaoTextoFechou..contBotao,vetorJson);
								if botao.tempoAberto then
									timer.cancel(botao.tempoAberto)
									botao.tempoAberto = nil
								end
								botao.tempoAbertoNumero = 0
								restoreNativeScreenElements()
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
							onRelease = grupoTexto.removerTudo
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
								grupoTexto.removerTudo(); 
								criarTexto(true) 
							end 
						end
						scrollView.timer = timer.performWithDelay(1000,mudarOrientacaoTexto,-1)
						
						
						local widget = require( "widget" )
	  
						-- ScrollView listener

						scrollView:insert( backButtonTelaAluno )
						
						scrollView:addEventListener("touch",function() return true end)
						scrollView:addEventListener("tap",function() return true end)
						fundoPreto:addEventListener("tap",grupoTexto.removerTudo)
						
						

						if jaClicou == true then
							local date = os.date( "*t" )
							local data = date.day.."/"..date.month.."/"..date.year
							local hora = date.hour..":"..date.min..":"..date.sec
							local pH = funcGlobal.pegarNumeroPaginaRomanosHistorico(varGlobal.PagH)
							local vetorJson = {
								tipoInteracao = "botao",
								pagina_livro = varGlobal.PagH,
								objeto_id = contBotao,
								acao = "abrir",
								subtipo = "de texto",
								relatorio = data.."| Clicou no botão "..contBotao.." de texto na página "..pH.. " às ".. hora.."."
							};
							if GRUPOGERAL.subPagina then
								vetorJson.subPagina = GRUPOGERAL.subPagina;
							end
							funcGlobal.escreverNoHistorico(varGlobal.HistoricoBotaoTexto..contBotao,vetorJson)
							clearNativeScreenElements()
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
						telaPreta.xScale = varGlobal.aspectRatio;telaPreta.yScale = varGlobal.aspectRatio;
						telaPreta.x = telaPreta.x + 100
						grupoZoom.xScale = varGlobal.aspectRatio;grupoZoom.yScale = varGlobal.aspectRatio;
						grupoZoom.rotation = 90
						grupoZoom.x = 0 + grupoZoom.height/2
						grupoZoom.y = 0
						texto.y = W/2 + 110
						texto.x = W - 90
						grupoZoom.imgFunc.x=W/2 ;grupoZoom.imgFunc.y=H/2- grupoZoom.imgFunc.height/2
					elseif system.orientation == "landscapeLeft" then 
						telaPreta.xScale = varGlobal.aspectRatio;telaPreta.yScale = varGlobal.aspectRatio;
						grupoZoom.xScale = varGlobal.aspectRatio;grupoZoom.yScale = varGlobal.aspectRatio;
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
								telaPreta.xScale = varGlobal.aspectRatio;telaPreta.yScale = varGlobal.aspectRatio;
								telaPreta.x = telaPreta.x + 100
								grupoZoom.xScale = varGlobal.aspectRatio;grupoZoom.yScale = varGlobal.aspectRatio;
								grupoZoom.rotation = 90
								grupoZoom.x = 0 + grupoZoom.height/2
								grupoZoom.y = 0
								texto.y = W/2 +250
								texto.x = W + 100
								grupoZoom.imgFunc.x=H/2- (grupoZoom.imgFunc.width/2);grupoZoom.imgFunc.y=W/2
							elseif system.orientation == "landscapeLeft" then 
								telaPreta.xScale = varGlobal.aspectRatio;telaPreta.yScale = varGlobal.aspectRatio;
								grupoZoom.xScale = varGlobal.aspectRatio;grupoZoom.yScale = varGlobal.aspectRatio;
								grupoZoom.rotation = -90
								grupoZoom.x = 0
								grupoZoom.y = 0 + grupoZoom.width
								texto.y = W/2 + 110
								texto.x = W
								grupoZoom.imgFunc.y=W/2 ;grupoZoom.imgFunc.x=H/2 - (grupoZoom.imgFunc.width*varGlobal.aspectRatio/2)
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
						local date = os.date( "*t" )
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
						funcGlobal.escreverNoHistorico(varGlobal.HistoricoBotaoImagemFechou..contBotao,vetorJson)--imagemoutra)
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
					GRUPOGERAL.grupoZoom = grupoZoom
					local date = os.date( "*t" )
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
					funcGlobal.escreverNoHistorico(varGlobal.HistoricoBotaoImagem..contBotao,vetorJson)--imagemoutra)
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
	
	print("Options:")
	print(options.width)
	print(options.height)
	print(options.defaultFile)
	print(options.overFile)
	print(options.label)
	print(options.fontSize)
	print(options.x)
	print(options.y)
	print("close")
	
	
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
	
	
	print(atributos.tipo)
	grupoBotao.botao = {}
	for i=1,#EventoDoBotao do
		grupoBotao.botao[i] = widget.newButton(options)
		grupoBotao:insert(grupoBotao.botao[i])
		grupoBotao.botao[i].evento = EventoDoBotao[i]
		if grupoBotao.botao[i].evento == "irPara" then
			grupoBotao.botao[i].numero = 1
			if atributos.numero then
				grupoBotao.botao[i].numero = atributos.numero - varGlobal.contagemInicialPaginas +varGlobal.numeroTotal.PaginasPre+varGlobal.numeroTotal.Indices +1
			end 
		else
			grupoBotao.botao[i]:setLabel(grupoBotao.botao[i].evento)
		end
		if grupoBotao.botao[i].evento == "som" then
			if atributos.som then
				local som = audio.loadSound(atributos.som)
				audio.stop()
				local date = os.date( "*t" )
				local data = date.day.."/"..date.month.."/"..date.year
				local hora = date.hour..":"..date.min..":"..date.sec
				local pH = funcGlobal.pegarNumeroPaginaRomanosHistorico(varGlobal.PagH)
				local vetorJson = {
					tipoInteracao = "botao",
					pagina_livro = varGlobal.PagH,
					objeto_id = contBotao,
					acao = "executar",
					subtipo = "de audio",
					relatorio = data.."| Executou o botão "..contBotao.." de áudio da página "..pH.. " às ".. hora.."."
				};
				if GRUPOGERAL.subPagina then
					vetorJson.subPagina = GRUPOGERAL.subPagina;
				end
				funcGlobal.escreverNoHistorico(varGlobal.HistoricoBotaoSomAutomatico..contBotao,vetorJson)--atributos.som)
				local function onComplete( event )
					print( "audio session ended" )
					if event.completed then
						local date = os.date( "*t" )
						local data = date.day.."/"..date.month.."/"..date.year
						local hora = date.hour..":"..date.min..":"..date.sec
						local pH = funcGlobal.pegarNumeroPaginaRomanosHistorico(varGlobal.PagH)
						local vetorJson = {
							tipoInteracao = "botao",
							pagina_livro = varGlobal.PagH,
							objeto_id = contBotao,
							acao = "terminar",
							subtipo = "de audio",
							relatorio = data.."| Terminou de ouvir o áudio do botão "..contBotao.." da página "..pH.. " às ".. hora.."."
						};
						if GRUPOGERAL.subPagina then
							vetorJson.subPagina = GRUPOGERAL.subPagina;
						end
						funcGlobal.escreverNoHistorico(varGlobal.HistoricoBotaoSomFechou..contBotao,vetorJson)--atributos.som)
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
				
				grupoBotao.botao[i].pausarSom = function(e)
					if pAuSaDo == false and grupoBotao.botao[i].som then
						audio.pause(grupoBotao.botao[i].som)
						pAuSaDo = true
						local date = os.date( "*t" )
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
						funcGlobal.escreverNoHistorico(varGlobal.HistoricoBotaoSomPausou..contBotao,vetorJson)--atributos.som)
					elseif grupoBotao.botao[i].som then
						pAuSaDo = false
						audio.resume(grupoBotao.botao[i].som)
						local date = os.date( "*t" )
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
						funcGlobal.escreverNoHistorico(varGlobal.HistoricoBotaoSomDespausou..contBotao,vetorJson)--atributos.som)
						
					end
				end
				grupoBotao.botao[i].som = audio.play(som, {onComplete = onComplete})
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
				optionsPause.x = grupoBotao.botao[i].x + grupoBotao.botao[i].width + 5
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
				optionsPause.onRelease = grupoBotao.botao[i].pausarSom
				local botaoPause = widget.newButton(optionsPause)
				botaoPause.anchorY = 0
				
				grupoBotao:insert(botaoPause)
			end
		end
		grupoBotao.botao[i].anchorY = 0
		grupoBotao.botao[i].clicado = false
		if atributos.titulo and #EventoDoBotao == 1 then
			grupoBotao.botao[i]:setLabel( atributos.titulo.texto[i] )
			local texto = display.newText(atributos.titulo.texto[i],0,0,0,0,native.systemFontBold,options.fontSize)
			while texto.width > grupoBotao.botao[i].width -10 do
				texto.size = texto.size-1
			end
			while texto.height > grupoBotao.botao[i].height -1 do
				texto.size = texto.size-1
			end
			local novoTamanho = texto.size
			grupoBotao.botao[i]._view._label.size = novoTamanho
			texto:removeSelf()
		end
		grupoBotao.botao[i].setDefaultFile =atributos.fundoUp
		grupoBotao.botao[i].setOverFile =atributos.fundoDown
		if atributos.titulo then
			grupoBotao.botao[i].fontSize = TamanhoDaFonte
		end
	end
	local distanciaHorizontal = 10
	local distanciaVertical = 10
	if  #EventoDoBotao > 1 then
		if #EventoDoBotao == 2 then
			grupoBotao.botao[1].x = W/3 - distanciaHorizontal/2
			grupoBotao.botao[2].x = 2*W/3 + distanciaHorizontal/2
		elseif #EventoDoBotao == 3 then
			grupoBotao.botao[1].x = W/3 - distanciaHorizontal/2
			grupoBotao.botao[2].x = 2*W/3 + distanciaHorizontal/2
			grupoBotao.botao[3].y = grupoBotao.botao[2].y + grupoBotao.botao[2].height + distanciaVertical
		elseif #EventoDoBotao == 4 then
			grupoBotao.botao[1].x = W/3 -distanciaHorizontal/2
			grupoBotao.botao[2].x = 2*W/3 + distanciaHorizontal/2
			grupoBotao.botao[3].x = W/3 -distanciaHorizontal/2
			grupoBotao.botao[4].x = 2*W/3 + distanciaHorizontal/2
			grupoBotao.botao[3].y = grupoBotao.botao[2].y + grupoBotao.botao[2].height + distanciaVertical
			grupoBotao.botao[4].y = grupoBotao.botao[2].y + grupoBotao.botao[2].height + distanciaVertical
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
M.colocarBotao = colocarBotao

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
local colocarFormatacaoTexto = require "colocarFormatacaoTexto"
local function colocarImagemTexto(atributos,telas)
	local temImagem = false
	local grImText = display.newGroup()
	if naoVazio(atributos) then
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
		if naoVazio(atributos) then
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

				
				grImText.texto = colocarFormatacaoTexto.criarTextodePalavras({texto = textoASerUsado,x = atributos.x,Y = grImText.imagem.y,fonte = options.font,tamanho = options.fontSize,cor = {r,g,b},largura = largurax,url = atributos.urlTexto, alinhamento = atributos.alinhamento,posicao = atributos.posicao,imagemW = imagemWidth ,imagemH = grImText.imagem.height,margem = atributos.margem, xNegativo = xNegativo, embeded = atributos.urlEmbeded, endereco = varGlobal.enderecoArquivos, tipoTTS = varGlobal.TTSTipo,temHistorico = varGlobal.temHistorico})
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
M.colocarImagemTexto = colocarImagemTexto


local JaConveRTEU = false

----------------------------------------------------------------------
--	COLOCAR SEPARADOR 												--
-- função responsável por adicionar um Separador retangular			--
-- ATRIBUTOS: espessura, cor, largura									--
----------------------------------------------------------------------
local function colocarSeparador(atributos)
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
M.colocarSeparador = colocarSeparador

--------------------------------------------------
--	COLOCAR VIDEO 								--
--	Funcao responsavel por tocar um Video 		--
--  de acordo com arquivo: (mp4,mov, m4v) 		--
--	ATRIBUTOS: arquivo 	,tipo, largura, altura	--
--	velocidade, url							--
--  *¨tipo = local,player,incorporado			--
--------------------------------------------------
local function colocarVideo(atributos,telas)
	if naoVazio(atributos) then
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
										estado = "terminar"
										enviarHistorico = true
									elseif aux == "1" then
										estado = "executar"
										enviarHistorico = true
									elseif aux == "2" then
										estado = "pausar"
										enviarHistorico = true
									elseif aux == "3" then
										estado = "armazenando em buffer"
									end
									if enviarHistorico then
										local date = os.date( "*t" )
										local data = date.day.."/"..date.month.."/"..date.year
										local hora = date.hour..":"..date.min..":"..date.sec
										local pH = funcGlobal.pegarNumeroPaginaRomanosHistorico(varGlobal.PagH)
										local vetorJson = {
											tipoInteracao = "video",
											pagina_livro = varGlobal.PagH,
											objeto_id = videoID,
											acao = estado,
											subtipo = "youtube",
											tempo_total = dur,
											relatorio = data.."| Realizou ação de "..estado.." o vídeo ".. videoID .."de youtube da página "..pH.. " às ".. hora.."."
										};
										if GRUPOGERAL.subPagina then
											vetorJson.subPagina = GRUPOGERAL.subPagina;
										end
										funcGlobal.escreverNoHistorico(varGlobal.HistoricoVideoYoutube..estado.."|Video "..contVideo,vetorJson)
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
					local date = os.date( "*t" )
					local data = date.day.."/"..date.month.."/"..date.year
					local hora = date.hour..":"..date.min..":"..date.sec
					local pH = funcGlobal.pegarNumeroPaginaRomanosHistorico(varGlobal.PagH)
					local vetorJson = {
						tipoInteracao = "video",
						pagina_livro = varGlobal.PagH,
						objeto_id = videoID,
						acao = "executar",
						subtipo = "no livro",
						relatorio = data.."| Executou o vídeo ".. videoID .." dentro do livro na página "..pH.. " às ".. hora.."."
					};
					if GRUPOGERAL.subPagina then
						vetorJson.subPagina = GRUPOGERAL.subPagina;
					end
					funcGlobal.escreverNoHistorico(varGlobal.HistoricoVideoYoutubeRodar..contVideo,vetorJson)
					
					
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
							--criarCursoAux(telas, paginaAtual+1)
							--paginaAtual = paginaAtual+1
							local date = os.date( "*t" )
							local data = date.day.."/"..date.month.."/"..date.year
							local hora = date.hour..":"..date.min..":"..date.sec
							local pH = funcGlobal.pegarNumeroPaginaRomanosHistorico(varGlobal.PagH)
							local vetorJson = {
								tipoInteracao = "video",
								pagina_livro = varGlobal.PagH,
								objeto_id = contVideo,
								acao = "terminar",
								subtipo = "nativo",
								relatorio = data.."| Terminou o vídeo ".. contVideo .." na página "..pH.. " às ".. hora.."."
							};
							if GRUPOGERAL.subPagina then
								vetorJson.subPagina = GRUPOGERAL.subPagina;
							end
							funcGlobal.escreverNoHistorico(varGlobal.HistoricoVideoNativoTerminar..contVideo,vetorJson)--atributos.arquivo)
							
						else
							local date = os.date( "*t" )
							local data = date.day.."/"..date.month.."/"..date.year
							local hora = date.hour..":"..date.min..":"..date.sec
							local pH = funcGlobal.pegarNumeroPaginaRomanosHistorico(varGlobal.PagH)
							local vetorJson = {
								tipoInteracao = "video",
								pagina_livro = varGlobal.PagH,
								objeto_id = contVideo,
								acao = "cancelar",
								subtipo = "nativo",
								relatorio = data.."| Cancelou o vídeo ".. contVideo .." na página "..pH.. " às ".. hora.."."
							};
							if GRUPOGERAL.subPagina then
								vetorJson.subPagina = GRUPOGERAL.subPagina;
							end
							funcGlobal.escreverNoHistorico(varGlobal.HistoricoVideoNativoCancelar..contVideo,vetorJson)--atributos.arquivo)
							
						end
					end
					local videooow
					if varGlobal.tipoSistema == "PC" then
					--if system.pathForFile() then
						local webView = native.newWebView( botaoPlay.x, botaoPlay.y,480, 320 )
						webView.anchorY = 0
						webView.isVisible = false
						webView:request( atributos.arquivo,system.ResourceDirectory )
						grupoVideo:insert(webView)
						local date = os.date( "*t" )
						local data = date.day.."/"..date.month.."/"..date.year
						local hora = date.hour..":"..date.min..":"..date.sec
						local pH = funcGlobal.pegarNumeroPaginaRomanosHistorico(varGlobal.PagH)
						local vetorJson = {
							tipoInteracao = "video",
							pagina_livro = varGlobal.PagH,
							objeto_id = contVideo,
							acao = "executar",
							subtipo = "nativo",
							relatorio = data.."| Executou o vídeo ".. contVideo .." na página "..pH.. " às ".. hora.."."
						};
						if GRUPOGERAL.subPagina then
							vetorJson.subPagina = GRUPOGERAL.subPagina;
						end
						funcGlobal.escreverNoHistorico(varGlobal.HistoricoVideoNativoAbrir..contVideo,vetorJson)
					else
						local videooow = media.playVideo( atributos.arquivo,system.ResourceDirectory,true,oncomplete)
						local date = os.date( "*t" )
						local data = date.day.."/"..date.month.."/"..date.year
						local hora = date.hour..":"..date.min..":"..date.sec
						local pH = funcGlobal.pegarNumeroPaginaRomanosHistorico(varGlobal.PagH)
						local vetorJson = {
							tipoInteracao = "video",
							pagina_livro = varGlobal.PagH,
							objeto_id = contVideo,
							acao = "executar",
							subtipo = "nativo",
							tempo_total = grupoVideo.tempoTotalVideo * 1000,
							relatorio = data.."| Executou o vídeo ".. contVideo .." na página "..pH.. " às ".. hora..". A duração total do video é de: "..auxFuncs.SecondsToClock(grupoVideo.tempoTotalVideo * 1000).."."
						};
						if GRUPOGERAL.subPagina then
							vetorJson.subPagina = GRUPOGERAL.subPagina;
						end
						funcGlobal.escreverNoHistorico(varGlobal.HistoricoVideoNativoAbrir.."|Total: "..tostring(grupoVideo.tempoTotalVideo)..contVideo,vetorJson)--atributos.arquivo)
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
						local date = os.date( "*t" )
						local data = date.day.."/"..date.month.."/"..date.year
						local hora = date.hour..":"..date.min..":"..date.sec
						local pH = funcGlobal.pegarNumeroPaginaRomanosHistorico(varGlobal.PagH)
						local vetorJson = {
							tipoInteracao = "video",
							pagina_livro = varGlobal.PagH,
							objeto_id = contVideo,
							acao = "terminar",
							subtipo = "no livro",
							tempo_total = grupoVideo.tempoTotalVideo * 1000,
							tempo_total_executado = grupoVideo.TempoExecutadoValorMax,
							tempo_total_repetindo = grupoVideo.TempoRepetindoValor,
							relatorio = data.."| Terminou de assistir o vídeo ".. contVideo .." na página "..pH.. " às ".. hora..". O tempo total de execução do video foi de: "..auxFuncs.SecondsToClock(grupoVideo.TempoRepetindoValor).."."
						};
						if GRUPOGERAL.subPagina then
							vetorJson.subPagina = GRUPOGERAL.subPagina;
						end
						funcGlobal.escreverNoHistorico(varGlobal.HistoricoVideoNormalTerminar..contVideo.."|Total: "..tostring(grupoVideo.tempoTotalVideo),vetorJson)--atributos.arquivo)
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
							local date = os.date( "*t" )
							local data = date.day.."/"..date.month.."/"..date.year
							local hora = date.hour..":"..date.min..":"..date.sec
							local pH = funcGlobal.pegarNumeroPaginaRomanosHistorico(varGlobal.PagH)
							local vetorJson = {
								tipoInteracao = "video",
								pagina_livro = varGlobal.PagH,
								objeto_id = contVideo,
								acao = "pausar",
								subtipo = "no livro",
								tempo_atual_video = grupoVideo.SeeK * 1000,
								tempo_total = grupoVideo.tempoTotalVideo * 1000,
								relatorio = data.."| Pausou o vídeo ".. contVideo .." aos "..auxFuncs.SecondsToClock(grupoVideo.SeeK * 1000).." de execução na página "..pH.. " às ".. hora.."."
							};
							if GRUPOGERAL.subPagina then
								vetorJson.subPagina = GRUPOGERAL.subPagina;
							end
							funcGlobal.escreverNoHistorico(varGlobal.HistoricoVideoNormalPausar..contVideo.."|Mudou orientacao".."|Tempo: "..grupoVideo.SeeK.."|Total: "..tostring(grupoVideo.tempoTotalVideo),vetorJson)--atributos.arquivo)
							if grupoVideo.video then
								grupoVideo.video:pause()
							end
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
					local date = os.date( "*t" )
					local data = date.day.."/"..date.month.."/"..date.year
					local hora = date.hour..":"..date.min..":"..date.sec
					local pH = funcGlobal.pegarNumeroPaginaRomanosHistorico(varGlobal.PagH)
					local vetorJson = {
						tipoInteracao = "video",
						pagina_livro = varGlobal.PagH,
						objeto_id = contVideo,
						acao = "retroceder",
						subtipo = "no livro",
						tempo_atual_video = grupoVideo.SeeK * 1000,
						tempo_total = grupoVideo.tempoTotalVideo * 1000,
						relatorio = data.."| Retrocedeu a execução do vídeo ".. contVideo .." aos "..auxFuncs.SecondsToClock(grupoVideo.SeeK * 1000).." na página "..pH.. " às ".. hora.."."
					};
					if GRUPOGERAL.subPagina then
						vetorJson.subPagina = GRUPOGERAL.subPagina;
					end
					funcGlobal.escreverNoHistorico(varGlobal.HistoricoVideoNormalVoltar..contVideo.."|Tempo: "..grupoVideo.SeeK.."|Total: "..tostring(grupoVideo.tempoTotalVideo),vetorJson)
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
						local date = os.date( "*t" )
						local data = date.day.."/"..date.month.."/"..date.year
						local hora = date.hour..":"..date.min..":"..date.sec
						local pH = funcGlobal.pegarNumeroPaginaRomanosHistorico(varGlobal.PagH)
						local vetorJson = {
							tipoInteracao = "video",
							pagina_livro = varGlobal.PagH,
							objeto_id = contVideo,
							acao = "cancelar",
							subtipo = "no livro",
							tempo_atual_video = grupoVideo.SeeK * 1000,
							tempo_total = grupoVideo.tempoTotalVideo * 1000,
							tempo_total_executado = grupoVideo.TempoExecutadoValorMax,
							tempo_total_repetindo = grupoVideo.TempoRepetindoValor,
							relatorio = data.."| Cancelou a execução do vídeo ".. contVideo .." aos "..auxFuncs.SecondsToClock(grupoVideo.SeeK * 1000).." na página "..pH.. " às ".. hora..". O tempo total gasto no vídeo foi de: "..auxFuncs.SecondsToClock(grupoVideo.TempoRepetindoValor).."."
						};
						if GRUPOGERAL.subPagina then
							vetorJson.subPagina = GRUPOGERAL.subPagina;
						end
						funcGlobal.escreverNoHistorico(varGlobal.HistoricoVideoNormalCancelar..contVideo.."|Tempo: "..grupoVideo.SeeK.."|Total: "..tostring(grupoVideo.tempoTotalVideo),vetorJson)--atributos.arquivo)
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
						local date = os.date( "*t" )
						local data = date.day.."/"..date.month.."/"..date.year
						local hora = date.hour..":"..date.min..":"..date.sec
						local pH = funcGlobal.pegarNumeroPaginaRomanosHistorico(varGlobal.PagH)
						local vetorJson = {
							tipoInteracao = "video",
							pagina_livro = varGlobal.PagH,
							objeto_id = contVideo,
							acao = "executar",
							subtipo = "no livro",
							tempo_atual_video = grupoVideo.SeeK * 1000,
							tempo_total = grupoVideo.tempoTotalVideo * 1000,
							relatorio = data.."| Executou o vídeo ".. contVideo .." dentro do livro na página "..pH.. " às ".. hora..". O tempo total do vídeo é de: "..auxFuncs.SecondsToClock(grupoVideo.tempoTotalVideo * 1000).."."
						};
						if GRUPOGERAL.subPagina then
							vetorJson.subPagina = GRUPOGERAL.subPagina;
						end
						funcGlobal.escreverNoHistorico(varGlobal.HistoricoVideoNormalExecutar..contVideo.."|Tempo: "..grupoVideo.SeeK.."|Total: "..tostring(grupoVideo.tempoTotalVideo),vetorJson)--atributos.arquivo)
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
						
						local date = os.date( "*t" )
						local data = date.day.."/"..date.month.."/"..date.year
						local hora = date.hour..":"..date.min..":"..date.sec
						local pH = funcGlobal.pegarNumeroPaginaRomanosHistorico(varGlobal.PagH)
						local vetorJson = {
							tipoInteracao = "video",
							pagina_livro = varGlobal.PagH,
							objeto_id = contVideo,
							acao = "despausar",
							subtipo = "no livro",
							tempo_atual_video = grupoVideo.SeeK * 1000,
							tempo_total = grupoVideo.tempoTotalVideo * 1000,
							relatorio = data.."| Despausou o vídeo ".. contVideo .." dentro do livro aos "..auxFuncs.SecondsToClock(grupoVideo.SeeK * 1000).." na página "..pH.. " às ".. hora.."."
						};
						if GRUPOGERAL.subPagina then
							vetorJson.subPagina = GRUPOGERAL.subPagina;
						end
						funcGlobal.escreverNoHistorico(varGlobal.HistoricoVideoNormalDespausar..contVideo.."|Tempo: "..grupoVideo.SeeK.."|Total: "..tostring(grupoVideo.tempoTotalVideo),vetorJson)--atributos.arquivo)
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
						local date = os.date( "*t" )
						local data = date.day.."/"..date.month.."/"..date.year
						local hora = date.hour..":"..date.min..":"..date.sec
						local pH = funcGlobal.pegarNumeroPaginaRomanosHistorico(varGlobal.PagH)
						local vetorJson = {
							tipoInteracao = "video",
							pagina_livro = varGlobal.PagH,
							objeto_id = contVideo,
							acao = "pausar",
							subtipo = "no livro",
							tempo_atual_video = grupoVideo.SeeK * 1000,
							tempo_total = grupoVideo.tempoTotalVideo * 1000,
							relatorio = data.."| Pausou o vídeo ".. contVideo .." dentro do livro aos "..auxFuncs.SecondsToClock(grupoVideo.SeeK * 1000).." na página "..pH.. " às ".. hora.."."
						};
						if GRUPOGERAL.subPagina then
							vetorJson.subPagina = GRUPOGERAL.subPagina;
						end
						funcGlobal.escreverNoHistorico(varGlobal.HistoricoVideoNormalPausar..contVideo.."|Mudou orientacao".."|Tempo: "..grupoVideo.SeeK.."|Total: "..tostring(grupoVideo.tempoTotalVideo),vetorJson)--atributos.arquivo)
						
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
					local date = os.date( "*t" )
					local data = date.day.."/"..date.month.."/"..date.year
					local hora = date.hour..":"..date.min..":"..date.sec
					local pH = funcGlobal.pegarNumeroPaginaRomanosHistorico(varGlobal.PagH)
					local vetorJson = {
						tipoInteracao = "video",
						pagina_livro = varGlobal.PagH,
						objeto_id = contVideo,
						acao = "avançar",
						subtipo = "no livro",
						tempo_atual_video = grupoVideo.SeeK * 1000,
						tempo_total = grupoVideo.tempoTotalVideo * 1000,
						relatorio = data.."| Avançou a execução do vídeo ".. contVideo .." dentro do livro aos "..auxFuncs.SecondsToClock(grupoVideo.SeeK * 1000).." na página "..pH.. " às ".. hora.."."
					};
					if GRUPOGERAL.subPagina then
						vetorJson.subPagina = GRUPOGERAL.subPagina;
					end
					funcGlobal.escreverNoHistorico(varGlobal.HistoricoVideoNormalAvancar..contVideo.."|Tempo: "..grupoVideo.SeeK.."|Total: "..tostring(grupoVideo.tempoTotalVideo),vetorJson)
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
						local date = os.date( "*t" )
						local data = date.day.."/"..date.month.."/"..date.year
						local hora = date.hour..":"..date.min..":"..date.sec
						local pH = funcGlobal.pegarNumeroPaginaRomanosHistorico(varGlobal.PagH)
						local vetorJson = {
							tipoInteracao = "video",
							pagina_livro = varGlobal.PagH,
							objeto_id = contVideo,
							acao = "pausar",
							subtipo = "no livro",
							tempo_atual_video = grupoVideo.SeeK * 1000,
							tempo_total = grupoVideo.tempoTotalVideo * 1000,
							relatorio = data.."| Pausou o vídeo ".. contVideo .." dentro do livro aos "..auxFuncs.SecondsToClock(grupoVideo.SeeK * 1000).." na página "..pH.. " às ".. hora.."."
						};
						if GRUPOGERAL.subPagina then
							vetorJson.subPagina = GRUPOGERAL.subPagina;
						end
						if grupoVideo.executou == true then
							grupoVideo.pausado = true
						end
						funcGlobal.escreverNoHistorico(varGlobal.HistoricoVideoNormalPausar..contVideo.."|Mudou orientacao".."|Tempo: "..grupoVideo.SeeK.."|Total: "..tostring(grupoVideo.tempoTotalVideo),vetorJson)--atributos.arquivo)
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
				
				if varGlobal.tipoSistema == "PC" then
				--if system.pathForFile(nil,system.ResourceDirectory) ~= nil then
					grupoVideo.videoH = botaoPlay.height + barra.height
				else
					grupoVideo.videoH = botaoPlay.height + barra.height
				end
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
M.colocarVideo = colocarVideo

-------------------------------------------------------------------------
--  COLOCAR EXERCICIOS												   --
-- atributos: enunciado,tamanhoFonte, corFonte, alternativas, corretas,--
-- justificativas, posicaoTexto("centro","topo")					   --
-- para montador: numeroalternativas								   --
-------------------------------------------------------------------------
varGlobal.NumeroExerciciosControlador = 1
function criarExercicio(atributos,telas)
	if naoVazio(atributos) then
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
		if TemUmaImagem[1] == 1 then
			if TemUmaImagem[3] >= H/2 then
				posicaoTexto = 50;
				--print(inicioX,inicioY)
			elseif TemUmaImagem[3] < H/2 then
				posicaoTexto = TemUmaImagem[3] + TemUmaImagem[5];
			end
			--print ("TEM UMA IMAGEM")
		end
		if TemUmaImagem[1] == 0 then
			posicaoTexto = 50;
			--print ("NÃO TEM UMA IMAGEM")
		end
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
		local textoEnunciado = colocarFormatacaoTexto.criarTextodePalavras({texto = options.text,x = atributos.x,Y = atributos.y + botaoExercicio.height,fonte = options.font,tamanho = options.fontSize,cor = {red,green,blue}, alinhamento = atributos.alinhamento,margem = margem,xNegativo = xNegativo,largura = largura, endereco = varGlobal.enderecoArquivos,tipoTTS = varGlobal.TTSTipo,temHistorico = varGlobal.temHistorico})
		
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
				
				local textoExerc = auxFuncs.lerTextoRes(atributos.pasta.."/"..textoAlternativas[i].temArquivo..".txt")
				print(atributos.pasta.."/"..textoAlternativas[i].temArquivo..".txt")
				auxFuncs.overwriteTable(arquivoTxtDaTela,nomePaginaExercicio..".json")
				if tipoSistema == "PC" then
					tablesave(  VetorDeVetorTTS,system.pathForFile("VetorTTS.json",system.DocumentsDirectory) )
				end
				VetorDeVetorTTS[nomePaginaExercicio].numero = #VetorDeVetorTTS[nomePaginaExercicio]
				--auxFuncs.overwriteTable(VetorDeVetorTTS,"VetorTTS.json")
				auxFuncs.criarTxTDocWSemMais(arquivoPaginaExercicio,textoExerc)
				
				criarCursoAux(vetor, nomePaginaExercicio)
				paginaAtual = nomePaginaExercicio
			--end
		end
		local tipoquestao = "simples"
		if #atributos.corretas > 2 then
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
								local date = os.date( "*t" )
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
								funcGlobal.escreverNoHistorico(varGlobal.HistoricoVerificarQuestao.. grupoBotaoExercicio.numero .."|alternativa "..i.."|".."correta",vetorJson)
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
								local date = os.date( "*t" )
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
								funcGlobal.escreverNoHistorico(varGlobal.HistoricoVerificarQuestao.. grupoBotaoExercicio.numero .."|alternativa "..i.."|".."incorreta",vetorJson)
								if Pasta ~= nil then
									criarPaginaAlternativaMarcada(i,textoAlertaQuestoesCorretas)
								else
									alert = native.showAlert( textoAlertaQuestoesCorretas, 'Clique em "Saber Mais.." para ver as explicações das alternativas. Senão pressione "OK".', { "OK", "Saber Mais.." }, onComplete )
								end
								somatoriaCertas = 0

								
								return true
							elseif i == #atributos.alternativas then
								local date = os.date( "*t" )
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
								funcGlobal.escreverNoHistorico(varGlobal.HistoricoVerificarQuestao.. grupoBotaoExercicio.numero .."|alternativa "..i.."|".."incorreta",vetorJson)
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
				textoAlternativas[i] = colocarFormatacaoTexto.criarTextodePalavras({texto = i..") - "..atributos.alternativas[i],x = atributos.x,Y = atributos.y,fonte = optionsAlternativas.font,tamanho = optionsAlternativas.fontSize,cor = {red,green,blue}, alinhamento = atributos.alinhamento,margem = margem,xNegativo = xNegativo,largura = largura, endereco = varGlobal.enderecoArquivos,tipoTTS = varGlobal.TTSTipo,temHistorico = varGlobal.temHistorico})
				textoAlternativas[i].y = textoAlternativas[i].y + botaoExercicio.height + textoEnunciado.height+ 50
				
				--textoAlternativas[i] = display.newText(optionsAlternativas)
				--textoAlternativas[i].text = i.." ( ) "..atributos.alternativas[i]
				textoAlternativas[i].marcada = "nao"
				--textoAlternativas[i].anchorX = 0; textoAlternativas[i].anchorY = 0
				--textoAlternativas[i]:setFillColor(red,green,blue)
				--textoAlternativas[i].y = atributos.y + botaoExercicio.height + textoEnunciado.height+ 50
				textoAlternativas[i].temArquivo = false
				if Pasta ~= nil and auxFuncs.fileExists(Pasta.."/"..i..".txt") then

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
							local date = os.date( "*t" )
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
							funcGlobal.escreverNoHistorico(varGlobal.HistoricoDesmarcarQuestao.. grupoBotaoExercicio.numero .."|alternativa "..i,vetorJson)
						elseif e.target.marcada == "nao" then
							--print("marcou",textoAlternativas[i].i)
							e.target.marcada = "sim"
							--e.target.text = e.target.i.." (X) ".. e.target.textoOriginal
							e.target.alpha = .5
							e.target.marcada = "sim"
							alternativaMarcada = "sim"
							local numeroAux = numeroDeMarcadas 
							numeroDeMarcadas = numeroAux + 1
							local date = os.date( "*t" )
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
							funcGlobal.escreverNoHistorico(varGlobal.HistoricoMarcarQuestao.. grupoBotaoExercicio.numero .."|alternativa "..i,vetorJson)
						end
						
					else
						e.target.marcada = "sim"
						--e.target.text = e.target.i.." (X) "..atributos.alternativas[i]
						e.target.alpha = .5
						alternativaMarcada = "sim"
						local numeroAux = numeroDeMarcadas 
						numeroDeMarcadas = numeroAux + 1
						local date = os.date( "*t" )
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
						funcGlobal.escreverNoHistorico(varGlobal.HistoricoMarcarQuestao.. grupoBotaoExercicio.numero .."|alternativa "..i,vetorJson)
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
		

		
		--atributos.tempo = "sim"
		--if atributos.tempo then
		local tempo = auxFuncs.SecondsToClock(0)
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
		grupo:insert(imagesAux)
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
M.criarExercicio = criarExercicio
------------------------------------------------------------------
-- INDICE MENU BOTOES --------------------------------------------
-- titulo,alinhamento,tamanhoTitulo,eNegrito,cor				--
-- imagem,largura,altura,opcoes									--
------------------------------------------------------------------
local inicio
local function criarIndiceIrPara(atributos)
		local grupoIndice = display.newGroup()
		if naoVazio(atributos) then
			if atributos.fundo then
				local fundo = display.newImageRect(atributos.fundo,W,H)
				fundo.anchorX=.5;fundo.anchorY=.5
				fundo.x=W/2;fundo.y=H/2
				grupoIndice:insert(fundo)
			end
			local optionsTitulo = 
			{
				text = "",
				x = (W/2),
				y = 30,
				width = W-20,
				height = 0,
				font = native.systemFont,
				fontSize = 40,
				align = "center"
			}
			if(atributos.alinhamento=='esquerda') then
				optionsTitulo.align = "left"
			--ALINHAMENTO DIREITA
			elseif(atributos.alinhamento=='direita') then
				optionsTitulo.align = "right"
			--ALINHAMENTO MEIO
			elseif(atributos.alinhamento=='centro') then
				optionsTitulo.align = "center"
			end
			if atributos.titulo then
				optionsTitulo.text = atributos.titulo
			end
			if(atributos.tamanhoTitulo) then
				optionsTitulo.fontSize = atributos.tamanhoTitulo;
			end
			if(atributos.eNegrito and atributos.eNegrito=='sim') then
				optionsTitulo.font = native.systemFontBold;
			end
			if optionsTitulo.align == "right" then
				local textinho = optionsTitulo.text
				optionsTitulo.text = textinho .. " "
			end
			
			titulodoIndice = display.newText( optionsTitulo ) 
			titulodoIndice:setFillColor( 0, 0.2, 0.13 ) --Verde escuro
			titulodoIndice.y = titulodoIndice.height/2 + 20
			grupoIndice:insert(titulodoIndice)
			if(atributos.cor) then
				local r = atributos.cor[1]/255; local g = atributos.cor[2]/255; local b = atributos.cor[3]/255
				if atributos.titulo then
					titulodoIndice:setFillColor(r,g,b);
				end
			end
			optionsOpcoes = {
				x= W/2,
				y= titulodoIndice.y + titulodoIndice.height + 200,
				width = 400,
				height = 150
			}
			if atributos.largura then
				optionsOpcoes.width = atributos.largura
			end
			if atributos.altura then
				optionsOpcoes.height = atributos.altura
			end
			local botao = {}
			local function handleButtonEvent(e)
				grupoIndice:removeSelf()
				local opcao = require (atributos.opcoes[e.target.numero])
				opcao.criarTela()
				local botaoInicio = widget.newButton(
				{
					width = 200,
					height = 50,
					defaultFile = "botaoPadrao.png",
					label = "INÍCIO",
					fontSize = 30,
					x = W/2,
					y = H-25
				})
				local function criarBotaoInicio()
					
					ead.destruirCursoAux(Telas,1)
					botaoInicio:removeSelf()
				end
				botaoInicio:addEventListener("tap",criarBotaoInicio)
			end
			local TamanhoDaFonte = 40
			if atributos.tamanhoFonteBotao then
				TamanhoDaFonte = atributos.tamanhoFonteBotao
			end
			local arquivoPadrao = "botaoPadrao.png"
			if atributos.opcoes then
				if atributos.imagem then
					arquivoPadrao = atributos.imagem
				end
				for i=1,#atributos.opcoes do
					botao[i] = widget.newButton(
					{
						width = optionsOpcoes.width,
						height = optionsOpcoes.height,
						defaultFile = arquivoPadrao,
						label = atributos.opcoes[i],
						fontSize = TamanhoDaFonte,
						--onRelease = handleButtonEvent(i)
					})
					
					botao[i].x = optionsOpcoes.x
					botao[i].y = optionsOpcoes.y
					botao[i].numero = i
					botao[i]:addEventListener("tap",handleButtonEvent)
					grupoIndice:insert(botao[i])
					optionsOpcoes.y = botao[i].y+botao[i].height+100
				end
			end
		end
		if atributos.index then imagem.index = atributos.index end
		return grupoIndice
end
M.criarIndiceIrPara = criarIndiceIrPara
--------------------------------------------------
--	COLOCAR PLANO DE FUNDO						--
--	Funcao responsavel por colocar um plano de 	--
--  fundo em todas as telas.					--
--  ATRIBUTOS: cor, arquivo 					--
--------------------------------------------------
local function colocarPlanoDeFundo(atributos)
	if naoVazio(atributos) then
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
					GRUPOPLANODEFUNDO.xScale = varGlobal.aspectRatio
					GRUPOPLANODEFUNDO.yScale = varGlobal.aspectRatio
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
						GRUPOPLANODEFUNDO.xScale = varGlobal.aspectRatio
						GRUPOPLANODEFUNDO.yScale = varGlobal.aspectRatio
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
M.colocarPlanoDeFundo = colocarPlanoDeFundo
----------------------------------------------------------------------
-- NUMERO DAS PAGINAS ------------------------------------------------
----------------------------------------------------------------------
verificarNumeroPaginasPre = auxFuncs.lerTextoResNumeroLinhas("PaginasPre/dllTelas.txt")
verificarNumeroIndices = auxFuncs.lerTextoResNumeroLinhas("Indices/dllIndices.txt")
totalPaginasAnteriores = verificarNumeroPaginasPre + verificarNumeroIndices + 1

local function criarNumeroDasPaginas(numeroTotal)

	varGlobal.numeroTotal = numeroTotal
	
	local retanguloNumeroPagina = display.newRect(20,20,20,20)
	retanguloNumeroPagina.anchorX = 1
	retanguloNumeroPagina.anchorY = 0
	
	local NumeroPaginasGlow = display.newText(paginaAtual+varGlobal.contagemInicialPaginas,0,0,"Fontes/segoeui.ttf",42)
	NumeroPaginasGlow.anchorX=1;NumeroPaginasGlow.anchorY=0;
	
	local NumeroPaginas = display.newText(paginaAtual+varGlobal.contagemInicialPaginas,0,0,"Fontes/segoeui.ttf",45)
	NumeroPaginas.anchorX = 1; NumeroPaginas.anchorY = 0
	NumeroPaginas.diferencaX = ((NumeroPaginasGlow.width - NumeroPaginas.width)/2)
	NumeroPaginas.diferencaY = ((NumeroPaginasGlow.width - NumeroPaginas.height)/2)
	
	
	
	
	NumeroPaginas.rotation = 90
	NumeroPaginasGlow.rotation = NumeroPaginas.rotation
	NumeroPaginas.y = H- NumeroPaginas.width - H/20 -- 50
	NumeroPaginasGlow.y = NumeroPaginas.y
	NumeroPaginas.x =  W - 50
	
	NumeroPaginasGlow.x = NumeroPaginas.x
	
	local rGeral = 0
	local gGeral = 0
	local bGeral = 0
	
	if varGlobal.preferenciasGerais.cor and type(varGlobal.preferenciasGerais.cor) == "table" then
		rGeral = varGlobal.preferenciasGerais.cor[1]
		gGeral = varGlobal.preferenciasGerais.cor[2]
		bGeral = varGlobal.preferenciasGerais.cor[3]
	end
	
	NumeroPaginas:setFillColor(rGeral,gGeral,bGeral)
	
	NumeroPaginasGlow:setFillColor(0.5,0.5,0.5,0)
	
	retanguloNumeroPagina.rotation = 90
	retanguloNumeroPagina.width = NumeroPaginas.width + 6
	retanguloNumeroPagina.height = NumeroPaginas.height
	retanguloNumeroPagina.y = H- NumeroPaginas.width - H/20
	retanguloNumeroPagina.x = NumeroPaginas.x + 3
	retanguloNumeroPagina:setFillColor(46/255,171/255,200/255)
	
	if PlanoDeFundoLibEA == "branco" then
		NumeroPaginas:setFillColor(0,0,0)
		NumeroPaginasGlow:setFillColor(0.5,0.5,0.5,0)
	elseif PlanoDeFundoLibEA == "preto" then
		NumeroPaginas:setFillColor(1,1,1)
		NumeroPaginasGlow:setFillColor(0.5,0.5,0.5,0)
	elseif PlanoDeFundoLibEA == "custom" then
		local newR = 255 - rGeral
		local newG = 255 - gGeral
		local newB = 255 - bGeral
		NumeroPaginas:setFillColor(newR,newG,newB)
		NumeroPaginasGlow:setFillColor(0.5,0.5,0.5,0)
	end

	if travarOrientacaoLado == false then
		NumeroPaginas.rotation = 0
		retanguloNumeroPagina.rotation = 0
		NumeroPaginasGlow.rotation = 0
		NumeroPaginas.x = W - 50
		retanguloNumeroPagina.x = W - 50
		NumeroPaginasGlow.x = NumeroPaginas.x
		NumeroPaginas.y = H - NumeroPaginas.height - H/20-- 50
		retanguloNumeroPagina.y = H - NumeroPaginas.height - H/20
		NumeroPaginasGlow.y = NumeroPaginas.y
		local function mudarLocalNumeroPagina()
				if system.orientation == "landscapeRight" then
					if system.getInfo( "platform" ) == "win32" then--win32
						NumeroPaginas.rotation = 0
						retanguloNumeroPagina.rotation = 0
						NumeroPaginas.x = W - 50
						retanguloNumeroPagina.x = W - 50
						NumeroPaginasGlow.x = NumeroPaginas.x
						NumeroPaginas.y = H - NumeroPaginas.height*1.35 - NumeroPaginas.height-- 50
						retanguloNumeroPagina.y = H - NumeroPaginas.height*1.35 - NumeroPaginas.height
						NumeroPaginasGlow.y = NumeroPaginas.y
					else
						if NumeroPaginas.width then
							NumeroPaginas.rotation = 90
							retanguloNumeroPagina.rotation = 90
							NumeroPaginasGlow.rotation = NumeroPaginas.rotation
							NumeroPaginas.y = H - NumeroPaginas.height
							retanguloNumeroPagina.y = H - NumeroPaginas.height
							NumeroPaginasGlow.y = NumeroPaginas.y
							NumeroPaginas.x = 50 + NumeroPaginas.height 
							retanguloNumeroPagina.x = 50 + NumeroPaginas.height 
							NumeroPaginasGlow.x = NumeroPaginas.x
						end
					end
					--print("\n\nRIGHT NUMERO\n\n")
				elseif system.orientation == "landscapeLeft" then
					if NumeroPaginas.width then
						NumeroPaginas.rotation = 270
						retanguloNumeroPagina.rotation = 270
						NumeroPaginasGlow.rotation = NumeroPaginas.rotation
						NumeroPaginas.y = 50 + NumeroPaginas.width
						retanguloNumeroPagina.y = 50 + NumeroPaginas.width
						NumeroPaginasGlow.y = NumeroPaginas.y
						NumeroPaginas.x = W - H/30 -NumeroPaginas.height
						retanguloNumeroPagina.x = NumeroPaginas.x
						NumeroPaginasGlow.x = NumeroPaginas.x
					end
					--print("\n\nRIGHT NUMERO\n\n")
				elseif system.orientation == "portrait" then
					if NumeroPaginas.width then
						NumeroPaginas.rotation = 0
						retanguloNumeroPagina.rotation = 0
						NumeroPaginasGlow.rotation = NumeroPaginas.rotation
						NumeroPaginas.x = W - 50
						retanguloNumeroPagina.x = NumeroPaginas.x + 3
						NumeroPaginasGlow.x = NumeroPaginas.x
						NumeroPaginas.y = H - NumeroPaginas.height - H/20
						retanguloNumeroPagina.y = H - NumeroPaginas.height - H/20
						NumeroPaginasGlow.y = NumeroPaginas.y
					end
					--print("\n\nPORTRAIT NUMERO\n\n")
				end 
		end
		Runtime:addEventListener("orientation", mudarLocalNumeroPagina)
	end

	local telasPosteriores = nil
	Runtime:addEventListener("enterFrame",
		function()
			if type(paginaAtual) == "number" then
				NumeroPaginas.text = paginaAtual + varGlobal.contagemInicialPaginas -numeroTotal.PaginasPre-numeroTotal.Indices -1
				
--				NumeroPaginas.isVisible = true
				if tonumber(NumeroPaginas.text) < 0 then
					local numero = (tonumber(NumeroPaginas.text)+ (numeroTotal.paginasAntesZero+1))
					NumeroPaginas.text = auxFuncs.ToRomanNumerals(numero)
				end
				NumeroPaginasGlow.text = NumeroPaginas.text
				if paginaAtual - telasAnteriores + varGlobal.contagemInicialPaginas < varGlobal.contagemInicialPaginas+1 then
					NumeroPaginas.isVisible = false;
					NumeroPaginasGlow.isVisible = false
				else
					NumeroPaginas.isVisible = true;
					NumeroPaginasGlow.isVisible = true
				end
				retanguloNumeroPagina.width = NumeroPaginas.width + 6
				if retanguloNumeroPagina.width > retanguloNumeroPagina.height then -- fazer ficar quadradom'
					--retanguloNumeroPagina.height = retanguloNumeroPagina.width
				else
					--retanguloNumeroPagina.width = retanguloNumeroPagina.height
				end
				retanguloNumeroPagina.x = NumeroPaginas.x + 3
			
				if telasPosteriores ~= nil then
					if paginaAtual > telasPosteriores then
						NumeroPaginas.isVisible = false;
						NumeroPaginasGlow.isVisible = false
					elseif paginaAtual - telasAnteriores + varGlobal.contagemInicialPaginas < varGlobal.contagemInicialPaginas+1 then
						NumeroPaginas.isVisible = false;
						NumeroPaginasGlow.isVisible = false
					else
						NumeroPaginas.isVisible = true;
						NumeroPaginasGlow.isVisible = true
					end;
				end;
				if paginaAtual > 99999 then
					NumeroPaginas.isVisible = false;
					NumeroPaginasGlow.isVisible = false;
				end	
				if paginaAtual == 1 then
					NumeroPaginas.isVisible = false
				else
					NumeroPaginas.isVisible = true
				end
				retanguloNumeroPagina.isVisible = NumeroPaginas.isVisible
			else
				NumeroPaginas.isVisible = false
				retanguloNumeroPagina.isVisible = NumeroPaginas.isVisible
			end
		end
	)
	
	NumeroPaginas.x = W-50
	
	return NumeroPaginas,NumeroPaginasGlow
end
M.criarNumeroDasPaginas = criarNumeroDasPaginas

ComecouNumeroPaginas = false

------------------------------------------------------------------
-- CRIAR PAGINACAO 			               						--
-- Cria a paginacao para alteracao de telas para direita ou     --
-- para esquerda. A interface de paginacao fica disponivel em   --
-- todas telas. E nao é permitido alternar de paginas enquanto  --
-- houver uma animacao em andamento.  							--
------------------------------------------------------------------

local function  criarPaginacao(telas,pagina)
	tamnhomenos = 400
	varGlobal.botaoEsquerdo = display.newImageRect("passarPaginaE.png",W/4,H-200-tamnhomenos)
	
	varGlobal.botaoEsquerdo:setFillColor(0,0,0)
	varGlobal.botaoEsquerdo.anchorX=0
	varGlobal.botaoEsquerdo.anchorY=0
	varGlobal.botaoEsquerdo.isVisible = botaoPassarPaginaTrue
	varGlobal.botaoEsquerdo.isHitTestable = true
	varGlobal.botaoEsquerdo.alpha = .2
--varGlobal.botaoEsquerdo:setFillColor(0,0,1)
	varGlobal.botaoEsquerdo.y = varGlobal.botaoEsquerdo.y + 100 + tamnhomenos/2
	varGlobal.botaoDireito = display.newImageRect("passarPagina.png",W/4,H-200-tamnhomenos)
	varGlobal.botaoDireito:setFillColor(0,0,0)
	varGlobal.botaoDireito.x = W - (varGlobal.botaoDireito.width);
	varGlobal.botaoDireito.isVisible = botaoPassarPaginaTrue
	varGlobal.botaoDireito.isHitTestable = true
	varGlobal.botaoDireito.alpha = .2
	varGlobal.botaoDireito.anchorX=0
	varGlobal.botaoDireito.anchorY=0
--varGlobal.botaoDireito:setFillColor(1,0,0)
	varGlobal.botaoDireito.y = varGlobal.botaoDireito.y + 100+ tamnhomenos/2

	if system.getInfo("platform") == "win32" then
		varGlobal.botaoEsquerdo.height = H
		varGlobal.botaoEsquerdo.y=0
		varGlobal.botaoDireito.height = H
		varGlobal.botaoDireito.y=0
	end

	local rodou
	rodou = false
	
	local function passarPaginaDireita(e)
		if 	type(paginaAtual) == "number" then
			if e.phase == "began" then
				display.currentStage:setFocus( e.target )
				clicouInicio = true
				toqueYY = e.y
				targetYY = e.target.y
				toqueXX = e.x
				targetXX = e.target.x
				
			elseif e.phase == "moved"  then
				if toqueXX then
					if system.orientation == "portrait" then
						if e.x < toqueXX -varGlobal.pixelsPassarPage then
							e.target.isVisible = true
						else
							e.target.isVisible = false
						end
					elseif system.orientation == "landscapeLeft" then
						if e.y > toqueYY +varGlobal.pixelsPassarPage then
							e.target.isVisible = true
						else
							e.target.isVisible = false
						end
					elseif system.orientation == "landscapeRight" then
						if e.y < toqueYY -varGlobal.pixelsPassarPage then
							e.target.isVisible = true
						else
							e.target.isVisible = false
						end
					end
				end
			elseif e.phase == "ended" and clicouInicio == true then
				e.target.isVisible = false
				rodou = false
				if toqueXX then
					local passarPagina = false
					if system.orientation == "portrait" then
						if e.x <toqueXX -varGlobal.pixelsPassarPage then
							passarPagina = true
						end
					elseif system.orientation == "landscapeLeft" then
						if e.y > toqueYY +varGlobal.pixelsPassarPage then
							passarPagina = true
						end
					elseif system.orientation == "landscapeRight" then
						if e.y < toqueYY -varGlobal.pixelsPassarPage then
							passarPagina = true
						end
					end
					if passarPagina == true then
						if(paginaAtual<telas.numeroTotal.Todas and toqueHabilitado == true) then
							if TemUmaImagem[1] then
								TemUmaImagem[2] = 0
								TemUmaImagem[3] = 0
								TemUmaImagem[4] = 0
								TemUmaImagem[5] = 0
								TemUmaImagem[1] = 0
							end
							paginaAtual=paginaAtual+1
							print("foi para: "..paginaAtual.." de "..telas.numeroTotal.Todas)
							media.stopSound()
							GRUPOGERAL.subPagina = nil
							criarCursoAux(telas, paginaAtual)
							if GRUPOGERAL.grupoZoom then
								GRUPOGERAL.grupoZoom:removeSelf()
							end

							girarTelaOrientacao(GRUPOGERAL)
						end
					end
				end
				display.currentStage:setFocus( nil )
			end
		end
		
	end
	--M.passarPaginaDireita = passarPaginaDireita
	local clicouInicio = false
	local function passarPaginaEsquerda(e)
		if 	type(paginaAtual) == "number" then
			if e.phase == "began" then
				display.currentStage:setFocus( e.target )
				clicouInicio = true
				toqueYY = e.y
				targetYY = e.target.y
				toqueXX = e.x
				targetXX = e.target.x
			elseif e.phase == "moved"  then
				if toqueXX then
					if system.orientation == "portrait" then
						if e.x > toqueXX +varGlobal.pixelsPassarPage then
							e.target.isVisible = true
						else
							e.target.isVisible = false
						end
					elseif system.orientation == "landscapeLeft" then
						if e.y < toqueYY -varGlobal.pixelsPassarPage then
							e.target.isVisible = true
						else
							e.target.isVisible = false
						end
					elseif system.orientation == "landscapeRight" then
						if e.y > toqueYY +varGlobal.pixelsPassarPage then
							e.target.isVisible = true
						else
							e.target.isVisible = false
						end
					end
				end
			elseif e.phase == "ended" and clicouInicio == true then
				e.target.isVisible = false
				if toqueXX then
					local passarPagina = false
					if system.orientation == "portrait" then
						if e.x > toqueXX +varGlobal.pixelsPassarPage then
							passarPagina = true
						end
					elseif system.orientation == "landscapeLeft" then
						if e.y < toqueYY -varGlobal.pixelsPassarPage then
							passarPagina = true
						end
					elseif system.orientation == "landscapeRight" then
						if e.y > toqueYY +varGlobal.pixelsPassarPage then
							passarPagina = true
						end
					end
					if passarPagina == true then
						if(paginaAtual<=telas.numeroTotal.Todas and paginaAtual>1 and toqueHabilitado == true) then
							clicouInicio = false
							if TemUmaImagem[1] then
								TemUmaImagem[2] = 0
								TemUmaImagem[3] = 0
								TemUmaImagem[4] = 0
								TemUmaImagem[5] = 0
								TemUmaImagem[1] = 0
							end
							paginaAtual=paginaAtual-1
							print("voltou para: "..paginaAtual.." de "..telas.numeroTotal.Todas)
							media.stopSound()
							GRUPOGERAL.subPagina = nil
							criarCursoAux(telas, paginaAtual)
							if GRUPOGERAL.grupoZoom then
								GRUPOGERAL.grupoZoom:removeSelf()
							end

							girarTelaOrientacao(GRUPOGERAL)
						end
					end
				end
				display.currentStage:setFocus( nil )
			end
		end
	end
	--M.passarPaginaEsquerda = passarPaginaEsquerda
	varGlobal.botaoDireito.ycorreto = varGlobal.botaoDireito.y
	varGlobal.botaoEsquerdo.ycorreto = varGlobal.botaoEsquerdo.y
	varGlobal.botaoDireito.hcorreto = varGlobal.botaoDireito.height
	varGlobal.botaoEsquerdo.hcorreto = varGlobal.botaoEsquerdo.height
	local function girarTelaOrientacaoBotaoInterface()
		if system.orientation == "landscapeRight" then
			
			transition.to(grupoBotaoAumentar,{time = 0,rotation = 90,x = W,y = H/2})
			transition.to(varGlobal.botaoEsquerdo,{time = 0,rotation = 90,x = W,y = 0,height = W-50,width = 270})
			transition.to(varGlobal.botaoDireito,{time = 0,rotation = 90,x=W,y=H-270,height = W-50,width = 270})
		elseif system.orientation == "landscapeLeft" then
			
			transition.to(grupoBotaoAumentar,{time = 0,rotation = -90,x = 0,y = H/2})
			transition.to(varGlobal.botaoEsquerdo,{time = 0,rotation = -90,x = 0,height = W-50,width = 270,y = H})
			transition.to(varGlobal.botaoDireito,{time = 0,rotation = -90,x=0,y=270,height = W-50,width = 270})
		elseif system.orientation == "portrait" then
			
			transition.to(grupoBotaoAumentar,{time = 0,rotation = 0,x = W/2,y = 0,height = 100,width = 200})
			transition.to(varGlobal.botaoEsquerdo,{time = 0,rotation = 0,x=0,y = 100 + tamnhomenos/2,width = W/4,height = H-200-tamnhomenos})
			transition.to(varGlobal.botaoDireito,{time = 0,rotation = 0,x=W-W/4,y=100 + tamnhomenos/2,width = W/4,height = H-200-tamnhomenos})

		end
	end
	if travarOrientacaoLado == true then
		system.orientation = "landscapeRight"-- deletar!!!!!!!!!!!!!!!!!!!!!!!!!
		girarTelaOrientacaoBotaoInterface()-- deletar!!!!!!!!!!!!!!!!!!!!!!!!!
	else
		Runtime:addEventListener("orientation",girarTelaOrientacaoBotaoInterface)-- arrumar!!!!!!!!!!!!!!!!!!!!!!!!!
	end
	--Define Pagina Atual
	paginaAtual=pagina

	--varGlobal.botaoDireito:addEventListener("touch", passarPaginaDireita)
	--varGlobal.botaoEsquerdo:addEventListener("touch", passarPaginaEsquerda)
	
	local function habilitaDesabilitaMenu2()
			local aux = 0
			if toqueHabilitado == false or aux ==  paginaAtual then
				varGlobal.botaoDireito.isHitTestable = false
				varGlobal.botaoEsquerdo.isHitTestable = false
			elseif toqueHabilitado == true then
				varGlobal.botaoDireito.isHitTestable = true
				varGlobal.botaoEsquerdo.isHitTestable = true
			end
		end
		Runtime:addEventListener("enterFrame",habilitaDesabilitaMenu2)
end
M.criarPaginacao = criarPaginacao

-- CRIAR BOTAO FALAR PAGINA --
local function FalarPagina()
	local function doesFileExist2( fname, path )
 
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
	local params = {}
	-- Tell network.request() that we want the "began" and "progress" events:
	params.progress = "download"
	params.response = {
		filename = "textoVozGeral pagina("..paginaAtual..").MP3",
		baseDirectory = system.DocumentsDirectory
	}
	local fileExists2 = doesFileExist2( "textoVozGeral pagina("..paginaAtual..").MP3", system.pathForFile(nil,system.DocumentsDirectory) )
	if fileExists2 == false then
		--print("WARNING: "..pagina)

		if paginaAtual-telasAnteriores+varGlobal.contagemInicialPaginas == 0 then
			funcGlobal.requisitarTTSOnline({tipo = varGlobal.TTSTipo,voz = varGlobal.TTSVoz,params = params,qualidade = qualidadeSom,idioma = varGlobal.TTSVozIdioma,texto = "Índice",extensao = varGlobal.extensao,funcao = networkListener00})
		else
			local origFrase = "Tela ".. paginaAtual-telasAnteriores + varGlobal.contagemInicialPaginas -1
			local frase = origFrase:urlEncode()
			
			-- Tell network.request() that we want the "began" and "progress" events:
			funcGlobal.requisitarTTSOnline({tipo = varGlobal.TTSTipo,voz = varGlobal.TTSVoz,params = params,qualidade = qualidadeSom,idioma = varGlobal.TTSVozIdioma,texto = frase,extensao = varGlobal.extensao,funcao = networkListener00})
		end
	else
		audio.pause()
		local function onComplete()
			audio.resume()
		end
		local som = audio.loadSound("textoVozGeral pagina("..paginaAtual..").MP3",system.DocumentsDirectory)
		audio.play(som,{onComplete = onComplete})
	end
	return true
end
local function botaoFalarPagina()
	local botao = display.newRect(W,H/2,100,200)
	botao.anchorX =.5;botao.anchorY =0.5;
	botao.x = W-botao.width/2;botao.y = H/2;
	botao:setFillColor(1,0,0)
	botao.isVisible = false
	botao.isHitTestable = true
	botao:addEventListener("tap",FalarPagina)
	return botao
end
M.botaoFalarPagina = botaoFalarPagina
----------------------------------------------------------------------
--	COLOCAR INTERFACE TTS											--
----------------------------------------------------------------------
varGlobal.GRUPOTTS = display.newGroup()
varGlobal.GRUPOBotoes = display.newGroup()
grupoAguarde.Grupo = display.newGroup()
local function rodarProximaPaginaTTS(telas)
	if varGlobal.vaiPassarPraFrente == true and paginaAtual < telas.numeroTotal.Todas then
		paginaAtual = paginaAtual+1
		media.stopSound()
		audio.stop()
		criarCursoAux(telas, paginaAtual)
		local evento = {}
		evento.phase = "ended"
		evento.target = {}
		evento.target.selecionado1 = true
		evento.target.selecionado2 = true
		handleButtonEventPlayTTS(evento)
	end
end
local function rodarAnteriorPaginaTTS(telas)
	media.stopSound()
	audio.stop()
	paginaAtual = paginaAtual-1
	-- media.stopSound()
	-- audio.stop()
	criarCursoAux(telas, paginaAtual)
	local evento = {}
	evento.phase = "ended"
	evento.target = {}
	evento.target.selecionado1 = true
	evento.target.selecionado2 = true
	handleButtonEventPlayTTS(evento)
end
botaoVoltarFoiApertado = false

function criarBotaoTTS(atributos,telas)
	local params = {}
	--local caminhoSalvarEAbrir = system.pathForFile("_TTS Offline",system.ResourceDirectory)
	local auxCaminho = string.gsub(system.pathForFile("infoPaginas.txt",system.ResourceDirectory),"infoPaginas.txt","")
	local Var = {}
	local caminhoSalvarEAbrir = auxCaminho:sub(1, -2)

	function copyFile( srcName, srcPath, dstName, dstPath, overwrite )
		local results = false
		local function doesFileExist( fname, path )
 
			local results = false
		 
			-- Path for the file
			local filePath = system.pathForFile( fname, path )
		 
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
		local rFilePath = system.pathForFile( srcName, srcPath )
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
	 
	-- Copy "readme.txt" from "system.ResourceDirectory" to "system.DocumentsDirectory"
	
	local function	copiarDocumentsParaPasta()
		local lfs = require( "lfs" )
		local path = system.pathForFile( nil, system.DocumentsDirectory )
		 
		for file in lfs.dir( path ) do
			print( "Found file or directory: " .. file )
			--local function desativarCopiaTTS()
			--copyFile( file, system.DocumentsDirectory, file..".txt", caminhoSalvarEAbrir, true )
			--copyFile( file, system.DocumentsDirectory, file, "TTS", true )
			--end
		end
	end
	
		 
		-- Tell network.request() that we want the "began" and "progress" events:
	params.progress = "download"
		 
		-- Tell network.request() that we want the output to go to a file:
	
	local function clearTTSelements()
		if grupoAguarde.telaPreta then
			grupoAguarde.telaPreta:removeSelf()
			grupoAguarde.texto:removeSelf()
			grupoAguarde.telaPreta = nil
			grupoAguarde.texto = nil
		end
		if varGlobal.grupoVideoTTS and varGlobal.grupoVideoTTS.videoTTS then
			varGlobal.grupoVideoTTS.videoTTS:removeSelf()
			varGlobal.grupoVideoTTS.videoTTS = nil
		end--varGlobal.grupoAnimacaoTTS
		if varGlobal.grupoVideoTTS then
			varGlobal.grupoVideoTTS:removeSelf()
			varGlobal.grupoVideoTTS = nil
		elseif varGlobal.grupoBotaoTTS then
			varGlobal.grupoBotaoTTS:removeSelf()
		end
		if varGlobal.grupoVideoTTS and varGlobal.grupoVideoTTS.videoTTS then
			varGlobal.grupoVideoTTS.videoTTS:removeSelf()
			varGlobal.grupoVideoTTS.videoTTS = nil
		end
		if varGlobal.grupoAnimacaoTTS and varGlobal.grupoAnimacaoTTS.videoTTS then
			varGlobal.grupoAnimacaoTTS.videoTTS:removeSelf()
			varGlobal.grupoAnimacaoTTS.videoTTS = nil
		end
		if(varGlobal.grupoAnimacaoTTS ~= nil) then
			if varGlobal.grupoAnimacaoTTS.timer then
				for i=1,#varGlobal.grupoAnimacaoTTS.timer do
					timer.cancel(varGlobal.grupoAnimacaoTTS.timer[i])
					varGlobal.grupoAnimacaoTTS.timer[i] = nil
				end
			end
			if varGlobal.grupoAnimacaoTTS.timer2 then
				timer.cancel(varGlobal.grupoAnimacaoTTS.timer2)
				varGlobal.grupoAnimacaoTTS.timer2 = nil
			end
			if varGlobal.grupoAnimacaoTTS.som then
				audio.stop(varGlobal.grupoAnimacaoTTS.som)
				varGlobal.grupoAnimacaoTTS.som = nil
			end
			varGlobal.grupoAnimacaoTTS:removeSelf()
			varGlobal.grupoAnimacaoTTS=nil
		end
	end
	
	local function rodarAudiosParagrafos()
			media.stopSound()
			audio.stop()
			clearTTSelements()
			restoreNativeScreenElements()
			local function onComplete(event)
				clearTTSelements()
				restoreNativeScreenElements()
				if ( event.completed ) then
					controladorSons = controladorSons +1
				else
					return true
				end
				if controladorSons <= #nomesArquivosParagrafos then
					media.stopSound()
					if nomesArquivosParagrafos.video[controladorSons] then
						clearNativeScreenElements()
						clearTTSelements()
						funcGlobal.criarVideoTTS()
					elseif nomesArquivosParagrafos.botao[controladorSons] then
					
					elseif nomesArquivosParagrafos.animacao[controladorSons] then
						clearNativeScreenElements()
						clearTTSelements()
						funcGlobal.criarAnimacaoTTS()
					else
						local som
						if nomesArquivosParagrafos.audio[controladorSons] then
							print(nomesArquivosParagrafos.audio[controladorSons])
							som = audio.loadStream(nomesArquivosParagrafos.audio[controladorSons] , system.ResourcesDirectory)
						else
							print(nomesArquivosParagrafos[controladorSons])
							som = audio.loadStream(nomesArquivosParagrafos[controladorSons] , varGlobal.pastaBaseTTS)
						end
						varGlobal.TTSduracaoTotal = audio.getDuration(som)
						timer.performWithDelay(16,
						function()
							local audioRodando = audio.play(som,{onComplete=onComplete});
							local date = os.date( "*t" )
							local data = date.day.."/"..date.month.."/"..date.year
							local hora = date.hour..":"..date.min..":"..date.sec
							local pH = funcGlobal.pegarNumeroPaginaRomanosHistorico(varGlobal.PagH)
							local vetorJson = {
								tipoInteracao = "TTS",
								pagina_livro = varGlobal.PagH,
								objeto_id = nil,
								acao = "executar",
								tts_valores = nomesArquivosParagrafos,
								valor_id = controladorSons,
								tempo_total = varGlobal.TTSduracaoTotal,
								velocidade_tts = varGlobal.VelocidadeTTS,
								relatorio = data.."| Executou o áudio "..controladorSons.." do TTS da página "..pH.." às "..hora.." com velocidade  "..varGlobal.VelocidadeTTS..". O áudio tem duração de ".. auxFuncs.SecondsToClock(varGlobal.TTSduracaoTotal)..". Numero de elementos TTS da página: "..controladorSons.."/"..#nomesArquivosParagrafos.."."
							};
							if GRUPOGERAL.subPagina then
								vetorJson.subPagina = GRUPOGERAL.subPagina;
							end
							funcGlobal.escreverNoHistorico(varGlobal.HistoricoTTSExecutar.. controladorSons .."|Página: "..contagemDaPaginaHistorico().."|Total = "..varGlobal.TTSduracaoTotal,vetorJson);  
							
						end,1)
					end
					--timer.performWithDelay(16,function() media.playSound( nomesArquivosParagrafos[controladorSons] , system.DocumentsDirectory,onComplete)end,1)
				elseif controladorSons > #nomesArquivosParagrafos then
					rodarProximaPaginaTTS(telas)
					return true
				end
			end
			botaoPause.isVisible = true
			botaoBackward.isVisible = true
			botaoForward.isVisible = true
			botaoReiniciar.isVisible = true
			media.stopSound()
			
			function funcGlobal.criarVideoTTS()
				
				local function videoListener(e)
					local tempoTotal = varGlobal.grupoVideoTTS.videoTTS.totalTime
					
					if e.errorCode then
						native.showAlert( "Error!", e.errorMessage, { "OK" } )
					
					elseif e.phase == "ready" then -- .currentTime
						local date = os.date( "*t" )
						local data = date.day.."/"..date.month.."/"..date.year
						local hora = date.hour..":"..date.min..":"..date.sec
						local pH = funcGlobal.pegarNumeroPaginaRomanosHistorico(varGlobal.PagH)
						local vetorJson = {
							tipoInteracao = "TTS",
							pagina_livro = varGlobal.PagH,
							objeto_id = controladorSons,
							acao = "executar",
							subtipo = "video",
							tempo_atual_video = 0,
							tempo_total = tempoTotal,
							relatorio = data.."| Executou o vídeo "..controladorSons.." no TTS na página "..pH.." às "..hora..". O video tem duração de "..auxFuncs.SecondsToClock(tempoTotal)..". Numero de elementos TTS da página: "..controladorSons.."/"..#nomesArquivosParagrafos.."."
						};
						funcGlobal.escreverNoHistorico(varGlobal.HistoricoVideoNormalExecutar..controladorSons.."|Total: "..tostring(tempoTotal),vetorJson)
					elseif e.phase == "ended" then
						local date = os.date( "*t" )
						local data = date.day.."/"..date.month.."/"..date.year
						local hora = date.hour..":"..date.min..":"..date.sec
						local pH = funcGlobal.pegarNumeroPaginaRomanosHistorico(varGlobal.PagH)
						
						local vetorJson = {
							tipoInteracao = "TTS",
							pagina_livro = varGlobal.PagH,
							objeto_id = controladorSons,
							acao = "terminar",
							subtipo = "video",
							tempo_atual_video = 0,
							tempo_total = tempoTotal,
							relatorio = data.."| Terminou de assistir o vídeo "..controladorSons.." no TTS na página "..pH.." às "..hora..". Numero de elementos TTS da página: "..controladorSons.."/"..#nomesArquivosParagrafos.."."
						};
						funcGlobal.escreverNoHistorico(varGlobal.HistoricoVideoNormalTerminar..controladorSons.."|Total: "..tostring(tempoTotal),vetorJson)
						
						funcGlobal.passarTTSHiperParaFrente()
					end
				end
				varGlobal.grupoVideoTTS = display.newGroup()
				local telaPreta = display.newRect(0,0,W,H)
				telaPreta.anchorX = 0.5; telaPreta.anchorY = 0.5
				telaPreta.anchorX = 0.5; telaPreta.anchorY = 0.5
				telaPreta.x = W/2; telaPreta.y = H/2
				telaPreta.x = W/2; telaPreta.y = H/2
				telaPreta:setFillColor(0,0,0)
				telaPreta.alpha=1
				telaPreta:addEventListener("tap",function() return true end)
				telaPreta:addEventListener("touch",function() return true end)
				varGlobal.grupoVideoTTS.videoTTS = native.newVideo(display.contentCenterX,display.contentCenterY,720,480)
				varGlobal.grupoVideoTTS.videoTTS.anchorX=.5
				varGlobal.grupoVideoTTS.videoTTS.anchorY=.5
				varGlobal.grupoVideoTTS:insert(telaPreta)
				varGlobal.grupoVideoTTS:insert(varGlobal.grupoVideoTTS.videoTTS)
				varGlobal.grupoVideoTTS.videoTTS:load(nomesArquivosParagrafos.video[controladorSons],system.ResourcesDirectory )
				varGlobal.grupoVideoTTS.videoTTS:addEventListener( "video", videoListener )
				varGlobal.grupoVideoTTS.videoTTS:play()
				varGlobal.GRUPOTTS:insert(1,varGlobal.grupoVideoTTS)
			end
			
			function funcGlobal.criarAnimacaoTTS()
				
				
				varGlobal.grupoAnimacaoTTS = display.newGroup()
				local telaPreta = display.newRect(0,0,W,H)
				telaPreta.anchorX = 0.5; telaPreta.anchorY = 0.5
				telaPreta.anchorX = 0.5; telaPreta.anchorY = 0.5
				telaPreta.x = W/2; telaPreta.y = H/2
				telaPreta.x = W/2; telaPreta.y = H/2
				telaPreta:setFillColor(0,0,0)
				telaPreta.alpha=1
				telaPreta:addEventListener("tap",function() return true end)
				telaPreta:addEventListener("touch",function() return true end)
				nomesArquivosParagrafos.animacao[controladorSons].loop = "nao"
				nomesArquivosParagrafos.animacao[controladorSons].automatico = "sim"
				nomesArquivosParagrafos.animacao[controladorSons].souTTS = true
				varGlobal.grupoAnimacaoTTS.animacaoTTS = elemTela.colocarAnimacao(nomesArquivosParagrafos.animacao[controladorSons],telas,varGlobal,funcGlobal)
				varGlobal.grupoAnimacaoTTS.animacaoTTS.botaoPlay.anchorY=.5
				for i=1,#varGlobal.grupoAnimacaoTTS.animacaoTTS.imagens do
					varGlobal.grupoAnimacaoTTS.animacaoTTS.imagens[i].anchorY=.5
				end
				--varGlobal.grupoAnimacaoTTS.animacaoTTS.y = varGlobal.grupoAnimacaoTTS.animacaoTTS.y - varGlobal.grupoAnimacaoTTS.animacaoTTS.imagens[1].height/2
				varGlobal.grupoAnimacaoTTS:insert(telaPreta)
				varGlobal.grupoAnimacaoTTS:insert(varGlobal.grupoAnimacaoTTS.animacaoTTS)
				varGlobal.GRUPOTTS:insert(1,varGlobal.grupoAnimacaoTTS)
				local date = os.date( "*t" )
				local data = date.day.."/"..date.month.."/"..date.year
				local hora = date.hour..":"..date.min..":"..date.sec
				local pH = funcGlobal.pegarNumeroPaginaRomanosHistorico(varGlobal.PagH)
				local vetorJson = {
					tipoInteracao = "TTS",
					pagina_livro = varGlobal.PagH,
					objeto_id = controladorSons,
					acao = "executar",
					subtipo = "animação",
					relatorio = data.."| Executou a animação "..controladorSons.." no TTS na página "..pH.." às "..hora..". Numero de elementos TTS da página: "..controladorSons.."/"..#nomesArquivosParagrafos.."."
				};
				funcGlobal.escreverNoHistorico(varGlobal.HistoricoRodarAnimacao..controladorSons,vetorJson)
			end
			function funcGlobal.passarTTSHiperParaFrente()
				local evento = {}
				evento.completed = true
				onComplete(evento)
			end
			if nomesArquivosParagrafos.video[controladorSons] then
			
				clearNativeScreenElements()
				clearTTSelements()
				
				funcGlobal.criarVideoTTS()
				
			elseif nomesArquivosParagrafos.botao[controladorSons] then
			
			elseif nomesArquivosParagrafos.animacao[controladorSons] then
				clearNativeScreenElements()
				clearTTSelements()
				funcGlobal.criarAnimacaoTTS()
			else
				local som
				if nomesArquivosParagrafos.audio[controladorSons] then
					som = audio.loadStream(nomesArquivosParagrafos.audio[controladorSons] , system.ResourcesDirectory)
				else
					som = audio.loadStream(nomesArquivosParagrafos[controladorSons] , varGlobal.pastaBaseTTS)
				end
				if not som then
					print(nomesArquivosParagrafos[controladorSons],varGlobal.pastaBaseTTS)
					local evento = {}
					evento.completed = true
					onComplete(evento)
				else
					if som then
						varGlobal.TTSduracaoTotal = audio.getDuration(som)
					else
						varGlobal.TTSduracaoTotal = 0
					end
					timer.performWithDelay(16,
					function()
						
						local audioRodando = audio.play(som,{onComplete=onComplete});
						local date = os.date( "*t" )
						local data = date.day.."/"..date.month.."/"..date.year
						local hora = date.hour..":"..date.min..":"..date.sec
						local pH = funcGlobal.pegarNumeroPaginaRomanosHistorico(varGlobal.PagH)
						local vetorJson = {
							tipoInteracao = "TTS",
							pagina_livro = varGlobal.PagH,
							objeto_id = nil,
							acao = "executar",
							tts_valores = nomesArquivosParagrafos,
							valor_id = controladorSons,
							tempo_total = varGlobal.TTSduracaoTotal,
							velocidade_tts = varGlobal.VelocidadeTTS,
								relatorio = data.."| Executou o áudio "..controladorSons.." do TTS da página "..pH.." às "..hora.." com velocidade  "..varGlobal.VelocidadeTTS..". O áudio tem duração de ".. auxFuncs.SecondsToClock(varGlobal.TTSduracaoTotal)..". Numero de elementos TTS da página: "..controladorSons.."/"..#nomesArquivosParagrafos.."."
						};
						if GRUPOGERAL.subPagina then
							vetorJson.subPagina = GRUPOGERAL.subPagina;
						end
						funcGlobal.escreverNoHistorico(varGlobal.HistoricoTTSExecutar.. controladorSons .."|Página: "..contagemDaPaginaHistorico().."|Total = "..varGlobal.TTSduracaoTotal,vetorJson);  
						
					end,1)
				end
			end

	end
	
	local function rodarAudiosParagrafosOffline()
		media.stopSound()
		audio.stop()
		clearTTSelements()
		restoreNativeScreenElements()
		local function onComplete(event)
			clearTTSelements()
			restoreNativeScreenElements()
			if ( event.completed ) then
				controladorSons = controladorSons +1
			else
				return true
			end
			if controladorSons <= #nomesArquivosParagrafos then
				media.stopSound()
				if nomesArquivosParagrafos.video[controladorSons] then
					clearNativeScreenElements()
					clearTTSelements()
					funcGlobal.criarVideoTTS()
				elseif nomesArquivosParagrafos.botao[controladorSons] then
				
				elseif nomesArquivosParagrafos.animacao[controladorSons] then
					clearNativeScreenElements()
					clearTTSelements()
					funcGlobal.criarAnimacaoTTS()
				else
					local som
					if nomesArquivosParagrafos.audio[controladorSons] then
						som = audio.loadStream(nomesArquivosParagrafos.audio[controladorSons] , system.ResourcesDirectory)
					else
						som = audio.loadStream("TTS/"..nomesArquivosParagrafos[controladorSons] , system.ResourcesDirectory)
					end
					if som then
						varGlobal.TTSduracaoTotal = audio.getDuration(som)
					else
						varGlobal.TTSduracaoTotal = 0
					end
					timer.performWithDelay(16,
					function()
						local audioRodando = audio.play(som,{onComplete=onComplete});
						local date = os.date( "*t" )
						local data = date.day.."/"..date.month.."/"..date.year
						local hora = date.hour..":"..date.min..":"..date.sec
						local pH = funcGlobal.pegarNumeroPaginaRomanosHistorico(varGlobal.PagH)
						local vetorJson = {
							tipoInteracao = "TTS",
							pagina_livro = varGlobal.PagH,
							objeto_id = nil,
							acao = "executar",
							tts_valores = nomesArquivosParagrafos,
							valor_id = controladorSons,
							tempo_total = varGlobal.TTSduracaoTotal,
							velocidade_tts = varGlobal.VelocidadeTTS,
							relatorio = data.."| Executou o áudio "..controladorSons.." do TTS da página "..pH.." às "..hora.." com velocidade  "..varGlobal.VelocidadeTTS..". O áudio tem duração de ".. auxFuncs.SecondsToClock(varGlobal.TTSduracaoTotal)..". Numero de elementos TTS da página: "..controladorSons.."/"..#nomesArquivosParagrafos.."."
						};
						if GRUPOGERAL.subPagina then
							vetorJson.subPagina = GRUPOGERAL.subPagina;
						end
						funcGlobal.escreverNoHistorico(varGlobal.HistoricoTTSExecutar.. controladorSons .."|Página: "..contagemDaPaginaHistorico().."|Total = "..varGlobal.TTSduracaoTotal,vetorJson);  
						
					end,1)
				end
				--timer.performWithDelay(16,function() media.playSound( nomesArquivosParagrafos[controladorSons] , system.DocumentsDirectory,onComplete)end,1)
			elseif controladorSons > #nomesArquivosParagrafos then
				rodarProximaPaginaTTS(telas)
				return true
			end
		end
		botaoPause.isVisible = true
		botaoBackward.isVisible = true
		botaoForward.isVisible = true
		botaoReiniciar.isVisible = true
		media.stopSound()
		
		function funcGlobal.criarVideoTTS()
			
			local function videoListener(e)
				local tempoTotal = varGlobal.grupoVideoTTS.videoTTS.totalTime
				
				if e.errorCode then
					native.showAlert( "Error!", e.errorMessage, { "OK" } )
				
				elseif e.phase == "ready" then -- .currentTime
					local date = os.date( "*t" )
					local data = date.day.."/"..date.month.."/"..date.year
					local hora = date.hour..":"..date.min..":"..date.sec
					local pH = funcGlobal.pegarNumeroPaginaRomanosHistorico(varGlobal.PagH)
					local vetorJson = {
						tipoInteracao = "TTS",
						pagina_livro = varGlobal.PagH,
						objeto_id = controladorSons,
						acao = "executar",
						subtipo = "video",
						tempo_atual_video = 0,
						tempo_total = tempoTotal,
						relatorio = data.."| Executou o vídeo "..controladorSons.." no TTS na página "..pH.." às "..hora..". O video tem duração de "..auxFuncs.SecondsToClock(tempoTotal)..". Numero de elementos TTS da página: "..controladorSons.."/"..#nomesArquivosParagrafos.."."
					};
					funcGlobal.escreverNoHistorico(varGlobal.HistoricoVideoNormalExecutar..controladorSons.."|Total: "..tostring(tempoTotal),vetorJson)
				elseif e.phase == "ended" then
					local date = os.date( "*t" )
					local data = date.day.."/"..date.month.."/"..date.year
					local hora = date.hour..":"..date.min..":"..date.sec
					local pH = funcGlobal.pegarNumeroPaginaRomanosHistorico(varGlobal.PagH)
					local vetorJson = {
						tipoInteracao = "TTS",
						pagina_livro = varGlobal.PagH,
						objeto_id = controladorSons,
						acao = "terminar",
						subtipo = "video",
						tempo_atual_video = 0,
						tempo_total = tempoTotal,
						relatorio = data.."| Terminou de assistir o vídeo "..controladorSons.." no TTS na página "..pH.." às "..hora..". Numero de elementos TTS da página: "..controladorSons.."/"..#nomesArquivosParagrafos.."."
					};
					funcGlobal.escreverNoHistorico(varGlobal.HistoricoVideoNormalTerminar..controladorSons.."|Total: "..tostring(tempoTotal),vetorJson)
					
					funcGlobal.passarTTSHiperParaFrente()
				end
			end
			varGlobal.grupoVideoTTS = display.newGroup()
			local telaPreta = display.newRect(0,0,W,H)
			telaPreta.anchorX = 0.5; telaPreta.anchorY = 0.5
			telaPreta.anchorX = 0.5; telaPreta.anchorY = 0.5
			telaPreta.x = W/2; telaPreta.y = H/2
			telaPreta.x = W/2; telaPreta.y = H/2
			telaPreta:setFillColor(0,0,0)
			telaPreta.alpha=1
			telaPreta:addEventListener("tap",function() return true end)
			telaPreta:addEventListener("touch",function() return true end)
			varGlobal.grupoVideoTTS.videoTTS = native.newVideo(display.contentCenterX,display.contentCenterY,720,480)
			varGlobal.grupoVideoTTS.videoTTS.anchorX=.5
			varGlobal.grupoVideoTTS.videoTTS.anchorY=.5
			varGlobal.grupoVideoTTS:insert(telaPreta)
			varGlobal.grupoVideoTTS:insert(varGlobal.grupoVideoTTS.videoTTS)
			varGlobal.grupoVideoTTS.videoTTS:load(nomesArquivosParagrafos.video[controladorSons],system.ResourcesDirectory )
			varGlobal.grupoVideoTTS.videoTTS:addEventListener( "video", videoListener )
			varGlobal.grupoVideoTTS.videoTTS:play()
			varGlobal.GRUPOTTS:insert(1,varGlobal.grupoVideoTTS)
		end
		
		function funcGlobal.criarAnimacaoTTS()
			
			
			varGlobal.grupoAnimacaoTTS = display.newGroup()
			local telaPreta = display.newRect(0,0,W,H)
			telaPreta.anchorX = 0.5; telaPreta.anchorY = 0.5
			telaPreta.anchorX = 0.5; telaPreta.anchorY = 0.5
			telaPreta.x = W/2; telaPreta.y = H/2
			telaPreta.x = W/2; telaPreta.y = H/2
			telaPreta:setFillColor(0,0,0)
			telaPreta.alpha=1
			telaPreta:addEventListener("tap",function() return true end)
			telaPreta:addEventListener("touch",function() return true end)
			nomesArquivosParagrafos.animacao[controladorSons].loop = "nao"
			nomesArquivosParagrafos.animacao[controladorSons].automatico = "sim"
			varGlobal.grupoAnimacaoTTS.animacaoTTS = elemTela.colocarAnimacao(nomesArquivosParagrafos.animacao[controladorSons],telas,varGlobal,funcGlobal)
			varGlobal.grupoAnimacaoTTS.animacaoTTS.botaoPlay.anchorY=.5
			for i=1,#varGlobal.grupoAnimacaoTTS.animacaoTTS.imagens do
				varGlobal.grupoAnimacaoTTS.animacaoTTS.imagens[i].anchorY=.5
			end
			--varGlobal.grupoAnimacaoTTS.animacaoTTS.y = varGlobal.grupoAnimacaoTTS.animacaoTTS.y - varGlobal.grupoAnimacaoTTS.animacaoTTS.imagens[1].height/2
			varGlobal.grupoAnimacaoTTS:insert(telaPreta)
			varGlobal.grupoAnimacaoTTS:insert(varGlobal.grupoAnimacaoTTS.animacaoTTS)
			varGlobal.GRUPOTTS:insert(1,varGlobal.grupoAnimacaoTTS)
			local date = os.date( "*t" )
			local data = date.day.."/"..date.month.."/"..date.year
			local hora = date.hour..":"..date.min..":"..date.sec
			local pH = funcGlobal.pegarNumeroPaginaRomanosHistorico(varGlobal.PagH)
			local vetorJson = {
				tipoInteracao = "TTS",
				pagina_livro = varGlobal.PagH,
				objeto_id = controladorSons,
				acao = "executar",
				subtipo = "animação",
				relatorio = data.."| Executou a animação "..controladorSons.." no TTS na página "..pH.." às "..hora..". Numero de elementos TTS da página: "..controladorSons.."/"..#nomesArquivosParagrafos.."."
			};
			funcGlobal.escreverNoHistorico(varGlobal.HistoricoRodarAnimacao..controladorSons,vetorJson)
		end
		function funcGlobal.passarTTSHiperParaFrente()
			local evento = {}
			evento.completed = true
			onComplete(evento)
		end
		if nomesArquivosParagrafos.video[controladorSons] then
		
			clearNativeScreenElements()
			clearTTSelements()
			
			funcGlobal.criarVideoTTS()
			
		elseif nomesArquivosParagrafos.botao[controladorSons] then
		
		elseif nomesArquivosParagrafos.animacao[controladorSons] then
			clearNativeScreenElements()
			clearTTSelements()
			funcGlobal.criarAnimacaoTTS()
		else
			local som
			if nomesArquivosParagrafos.audio[controladorSons] then
				som = audio.loadStream(nomesArquivosParagrafos.audio[controladorSons] , system.ResourcesDirectory)
			else
				som = audio.loadStream("TTS/"..nomesArquivosParagrafos[controladorSons] , system.ResourcesDirectory)
			end
			if not som then
				local evento = {}
				evento.completed = true
				onComplete(evento)
			else
				varGlobal.TTSduracaoTotal = audio.getDuration(som)
				timer.performWithDelay(16,
				function()
					
					local audioRodando = audio.play(som,{onComplete=onComplete});
					local date = os.date( "*t" )
					local data = date.day.."/"..date.month.."/"..date.year
					local hora = date.hour..":"..date.min..":"..date.sec
					local pH = funcGlobal.pegarNumeroPaginaRomanosHistorico(varGlobal.PagH)
					local vetorJson = {
						tipoInteracao = "TTS",
						pagina_livro = varGlobal.PagH,
						objeto_id = nil,
						acao = "executar",
						tts_valores = nomesArquivosParagrafos,
						valor_id = controladorSons,
						tempo_total = varGlobal.TTSduracaoTotal,
						velocidade_tts = varGlobal.VelocidadeTTS,
						relatorio = data.."| Executou o áudio "..controladorSons.." do TTS da página "..pH
					}
					if GRUPOGERAL.subPagina then
						vetorJson.subPagina = GRUPOGERAL.subPagina;
					end
					funcGlobal.escreverNoHistorico(varGlobal.HistoricoTTSExecutar.. controladorSons .."|Página: "..contagemDaPaginaHistorico().."|Total = "..varGlobal.TTSduracaoTotal,vetorJson);  
					
				end,1)
			end
		end
			--[[if grupoAguarde.telaPreta then
				grupoAguarde.telaPreta:removeSelf()
				grupoAguarde.texto:removeSelf()
				grupoAguarde.telaPreta = nil
				grupoAguarde.texto = nil
			end
			if varGlobal.grupoVideoTTS then
				varGlobal.grupoVideoTTS:removeSelf()
			elseif varGlobal.grupoBotaoTTS then
				varGlobal.grupoBotaoTTS:removeSelf()
			end
			local function onComplete(event)
				if grupoAguarde.telaPreta then
					grupoAguarde.telaPreta:removeSelf()
					grupoAguarde.texto:removeSelf()
					grupoAguarde.telaPreta = nil
					grupoAguarde.texto = nil
				end
				if varGlobal.grupoVideoTTS then
					varGlobal.grupoVideoTTS:removeSelf()
				elseif varGlobal.grupoBotaoTTS then
					varGlobal.grupoBotaoTTS:removeSelf()
				end
				if event.completed then
					controladorSons = controladorSons +1
				else
					return true
				end
				if controladorSons <= #nomesArquivosParagrafos then
					media.stopSound()
					audio.stop()
					local som = audio.loadSound("TTS/"..nomesArquivosParagrafos[controladorSons] , system.ResourceDirectory)
					varGlobal.TTSduracaoTotal = audio.getDuration(som)
					timer.performWithDelay(16,
						function()
							
							local audioRodando = audio.play(som,{onComplete=onComplete});
							local date = os.date( "*t" )
							local data = date.day.."/"..date.month.."/"..date.year
							local hora = date.hour..":"..date.min..":"..date.sec
							local vetorJson = {
								tipoInteracao = "TTS",
								pagina_livro = varGlobal.PagH,
								objeto_id = nil,
								acao = "executar",
								tts_valores = nomesArquivosParagrafos,
								valor_id = controladorSons,
								tempo_total = varGlobal.TTSduracaoTotal,
								velocidade_tts = varGlobal.VelocidadeTTS,
								relatorio = data.."| Executou o áudio "..controladorSons.." do TTS da página "..varGlobal.PagH.." às "..hora.." com velocidade  "..varGlobal.VelocidadeTTS..". O áudio tem duração de ".. auxFuncs.SecondsToClock(varGlobal.TTSduracaoTotal)..". Numero de elementos TTS da página: "..controladorSons.."/"..#nomesArquivosParagrafos.."."
							};
							if GRUPOGERAL.subPagina then
								vetorJson.subPagina = GRUPOGERAL.subPagina;
							end
							funcGlobal.escreverNoHistorico(varGlobal.HistoricoTTSExecutar.. controladorSons .."|Página: "..contagemDaPaginaHistorico().."|Total = "..varGlobal.TTSduracaoTotal,vetorJson); 
						end,1)
					--timer.performWithDelay(16,function() media.playSound( "TTS/"..nomesArquivosParagrafos[controladorSons] , system.ResourceDirectory,onComplete)end,1)
				elseif controladorSons > #nomesArquivosParagrafos then
					rodarProximaPaginaTTS(telas)
					return true
				end
			end
			botaoPause.isVisible = true
			botaoBackward.isVisible = true
			botaoForward.isVisible = true
			botaoReiniciar.isVisible = true
			media.stopSound()
			local som = audio.loadSound("TTS/"..nomesArquivosParagrafos[controladorSons] , system.ResourceDirectory)
			varGlobal.TTSduracaoTotal = audio.getDuration(som)
			timer.performWithDelay(16,
				function()
				
					local audioRodando = audio.play(som,{onComplete=onComplete});
					local date = os.date( "*t" )
					local data = date.day.."/"..date.month.."/"..date.year
					local hora = date.hour..":"..date.min..":"..date.sec
					local vetorJson = {
						tipoInteracao = "TTS",
						pagina_livro = varGlobal.PagH,
						objeto_id = nil,
						acao = "executar",
						tts_valores = nomesArquivosParagrafos,
						valor_id = controladorSons,
						tempo_total = varGlobal.TTSduracaoTotal,
						velocidade_tts = varGlobal.VelocidadeTTS,
						relatorio = data.."| Executou o áudio "..controladorSons.." do TTS da página "..varGlobal.PagH.." às "..hora.." com velocidade  "..varGlobal.VelocidadeTTS..". O áudio tem duração de ".. auxFuncs.SecondsToClock(varGlobal.TTSduracaoTotal)..". Numero de elementos TTS da página: "..controladorSons.."/"..#nomesArquivosParagrafos.."."
					};
					if GRUPOGERAL.subPagina then
						vetorJson.subPagina = GRUPOGERAL.subPagina;
					end
					funcGlobal.escreverNoHistorico(varGlobal.HistoricoTTSExecutar.. controladorSons .."|Página: "..contagemDaPaginaHistorico().."|Total = "..varGlobal.TTSduracaoTotal,vetorJson); 
				end,1)
			--timer.performWithDelay(16,function() media.playSound( "TTS/"..nomesArquivosParagrafos[controladorSons] , system.ResourceDirectory,onComplete)end,1)
	]]
	end
	local function converterTexto(texto,tipo,vetorTTS)
	
	
		grupoAguarde.telaPreta = display.newRect(0,0,W,H)
		grupoAguarde.telaPreta.anchorX = 0.5; grupoAguarde.telaPreta.anchorY = 0.5
		grupoAguarde.telaPreta.anchorX = 0.5; grupoAguarde.telaPreta.anchorY = 0.5
		grupoAguarde.telaPreta.x = W/2; grupoAguarde.telaPreta.y = H/2
		grupoAguarde.telaPreta.x = W/2; grupoAguarde.telaPreta.y = H/2
		grupoAguarde.telaPreta:setFillColor(1,1,1)
		grupoAguarde.telaPreta.alpha=0.9
		grupoAguarde.telaPreta:addEventListener("tap",function() return true end)
		grupoAguarde.telaPreta:addEventListener("touch",function() return true end)
		grupoAguarde.texto = display.newText("gerando áudio",W/2,H/2,"Fontes/segoeuib.ttf",50)
		grupoAguarde.texto:setFillColor(0,0,0)
		grupoAguarde.Grupo:insert(grupoAguarde.telaPreta)
		grupoAguarde.Grupo:insert(grupoAguarde.texto)
		audio.stop()
		

		varGlobal.extencao = "MP3"
		
		if system.getInfo("platform") == "win32" then
			varGlobal.extencao = "MP3"
		end
		if verificarWindows == true then
			varGlobal.extencao = "MP3"
		end
		varGlobal.ExtencaoSendoUsada = varGlobal.extencao
		local function tirarQuebrasDeLinhaRestantes(texto)
			local texto1 = ""
			local comprimento = string.len(texto)
			local numeroPalavras = 0
			for words in texto:gmatch("[^%s]+") do
				numeroPalavras = numeroPalavras + 1
			end
			local controlePalavras = 0
			
			for words in texto:gmatch("[^%s]+") do
				controlePalavras = controlePalavras + 1

				texto1 = texto1 .. " " .. words
			end
			return texto1
		end
		
		--print("*******************************************")
		--print("Texto Inicial")
		--print(texto)
		texto = conversor.substituirQuebrasDeLinha(texto)
		--print("*******************************************")
		--print("Texto Substituido")
		--print(texto)
		texto = tirarQuebrasDeLinhaRestantes(texto)
		for i=1,#vetorTTS do
			vetorTTS[i] = conversor.substituirQuebrasDeLinha(vetorTTS[i])
			vetorTTS[i] = tirarQuebrasDeLinhaRestantes(vetorTTS[i])
		end
		--print("*******************************************")
		--print("Texto Sem quebras de linha falsas")
		--print(texto)
		local paginaExecutada = paginaAtual
		local requestId = nil
		local idcancelado = false
		local function networkListener( event )
			if paginaExecutada ~= paginaAtual then

				return true
			end
			local arquivo = "textoVozGeral Tela("..paginaAtual..")."..varGlobal.extencao
			if ( event.isError ) then
				print( "Network error: ", event.response )
			elseif ( event.phase == "began" ) then
				if ( event.bytesEstimated <= 0 ) then
					print( "Download starting, size unknown" )
				else
					print( "Download starting, estimated size: " .. event.bytesEstimated )
				end
				if paginaExecutada ~= paginaAtual then
					network.cancel( requestId )
					idcancelado  = true

					return true
				end
			elseif ( event.phase == "progress" ) then
				if paginaExecutada ~= paginaAtual then
					network.cancel( requestId )
					idcancelado = true

					return true
				end
				if ( event.bytesEstimated <= 0 ) then
					print( "Download progress: " .. event.bytesTransferred )
				else
					print( "Download progress: " .. event.bytesTransferred .. " of estimated: " .. event.bytesEstimated )
				end
				 
			elseif ( event.phase == "ended" ) then
				print( "Download complete, total bytes transferred: " .. event.bytesTransferred )
				print("textoVozGeral Tela("..paginaAtual..")."..varGlobal.extencao)
				media.stopSound()
				local function onComplete(event)
					rodarProximaPaginaTTS(telas)
					return true
				end
				timer.performWithDelay(16,function() media.playSound( arquivo , system.DocumentsDirectory,onComplete);end,1)
				botaoPause.isVisible = true
				botaoReiniciar.isVisible = true
			end
		end
		
		tableParagrafosFinais = {}
		tableParagrafosFinais.audio = {}
		tableParagrafosFinais.video = {}
		tableParagrafosFinais.animacao = {}
		tableParagrafosFinais.botao = {}
		nomesArquivosParagrafos = {}
		nomesArquivosParagrafos.audio = {}
		nomesArquivosParagrafos.animacao = {}
		nomesArquivosParagrafos.video = {}
		nomesArquivosParagrafos.botao = {}
		controladorParagrafos = 1
		controladorSons = 1
		
			 
		local function networkListenerTTS( event )
			if ( event.isError ) then
				print( "Network error: ", event.response )
				network.cancel( requestId )
				idcancelado  = true
				local destDir = system.DocumentsDirectory  -- Location where the file is stored
				local result, reason = os.remove( system.pathForFile( "Tela"..paginaExecutada.."somTTS 1".."Vec"..varGlobal.acrescimoVeloc.."."..varGlobal.extencao, destDir ) )
				if grupoAguarde.telaPreta then
					grupoAguarde.telaPreta:removeSelf()
					grupoAguarde.texto:removeSelf()
					grupoAguarde.telaPreta = nil
					grupoAguarde.texto = nil
				end
				

				timer.performWithDelay(100,function()media.stopSound();audio.stop();local som = audio.loadSound(varGlobal.botaoSemInternetTTS);audio.play(som);end,1)
			elseif ( event.phase == "began" ) then
				if ( event.bytesEstimated <= 0 ) then
					print( "Download starting, size unknown" )
				else
					print( "Download starting, estimated size: " .. event.bytesEstimated )
				end
				if paginaExecutada ~= paginaAtual then
					network.cancel( requestId )
					idcancelado  = true
					local destDir = system.DocumentsDirectory  -- Location where the file is stored
					local result, reason = os.remove( system.pathForFile( "Tela"..paginaExecutada.."somTTS 1".."."..varGlobal.extencao, destDir ) )
					print(result,reason)
					if grupoAguarde.telaPreta then
						grupoAguarde.telaPreta:removeSelf()
						grupoAguarde.texto:removeSelf()
						grupoAguarde.telaPreta = nil
						grupoAguarde.texto = nil
					end

					return true
				end
			elseif ( event.phase == "progress" ) then
				if paginaExecutada ~= paginaAtual then
					network.cancel( requestId )
					idcancelado  = true
					local destDir = system.DocumentsDirectory  -- Location where the file is stored
					local result, reason = os.remove( system.pathForFile( "Tela"..paginaExecutada.."somTTS 1".."Vec"..varGlobal.acrescimoVeloc.."."..varGlobal.extencao, destDir ) )
					return true
				end
				if ( event.bytesEstimated <= 0 ) then
					print( "Download progress: " .. event.bytesTransferred )
				else
					print( "Download progress: " .. event.bytesTransferred .. " of estimated: " .. event.bytesEstimated )
				end
				 
			elseif ( event.phase == "ended" ) then
				
				print( "Download complete, total bytes transferred: " .. event.bytesTransferred )

				controladorParagrafos = controladorParagrafos + 1

				if controladorParagrafos <= #nomesArquivosParagrafos then
					
					if tableParagrafosFinais.audio[controladorParagrafos] then
						nomesArquivosParagrafos.audio[controladorParagrafos] = tableParagrafosFinais.audio[controladorParagrafos]
						controladorParagrafos = controladorParagrafos + 1
					elseif tableParagrafosFinais.video[controladorParagrafos] then
						nomesArquivosParagrafos.video[controladorParagrafos] = tableParagrafosFinais.video[controladorParagrafos]
						controladorParagrafos = controladorParagrafos + 1
					elseif tableParagrafosFinais.animacao[controladorParagrafos] then
						nomesArquivosParagrafos.animacao[controladorParagrafos] = tableParagrafosFinais.animacao[controladorParagrafos]
						controladorParagrafos = controladorParagrafos + 1
					elseif tableParagrafosFinais.botao[controladorParagrafos] then
						copyFile( tableParagrafosFinais.botao[controladorParagrafos], system.ResourcesDirectory, nomesArquivosParagrafos[controladorParagrafos], system.pathForFile(nil,system.DocumentsDirectory), true )
						nomesArquivosParagrafos.botao[controladorParagrafos] = tableParagrafosFinais.botao[controladorParagrafos]
						controladorParagrafos = controladorParagrafos + 1
					end
					if controladorParagrafos <= #nomesArquivosParagrafos then
						params.response = {
							filename = nomesArquivosParagrafos[controladorParagrafos],
							baseDirectory = varGlobal.pastaBaseTTS
						}
						params.progress = "download"
						local frase = tableParagrafosFinais[controladorParagrafos]:urlEncode()
						--local textoTTSFINAL = "https://api.voicerss.org/?key="..APIkey.thithou1.."&hl="..varGlobal.TTSVozIdioma.."&c="..varGlobal.extencao.."&r="..varGlobal.VelocidadeTTS.."&f="..qualidadeSom.."&src="..frase
						funcGlobal.requisitarTTSOnline({tipo = varGlobal.TTSTipo,params = params,qualidade = qualidadeSom,voz = varGlobal.TTSVoz,idioma = varGlobal.TTSVozIdioma,texto = frase,extensao = varGlobal.extensao,funcao = networkListenerTTS})
					elseif idcancelado == false then
						if botaoVoltarFoiApertado == true then
							controladorSons = #nomesArquivosParagrafos
							botaoVoltarFoiApertado = false
						end
						if grupoAguarde.telaPreta then
							grupoAguarde.telaPreta:removeSelf()
							grupoAguarde.texto:removeSelf()
							grupoAguarde.telaPreta = nil
							grupoAguarde.texto = nil
						end
						timer.performWithDelay(16,function()media.stopSound();audio.stop();rodarAudiosParagrafos() end,1)
					else
						if nomesArquivosParagrafos and nomesArquivosParagrafos[controladorParagrafos] then
							os.remove(nomesArquivosParagrafos[controladorParagrafos])
						end
					end
				elseif idcancelado == false then
					if botaoVoltarFoiApertado == true then
						controladorSons = #nomesArquivosParagrafos
						botaoVoltarFoiApertado = false
					end
					if grupoAguarde.telaPreta then
						grupoAguarde.telaPreta:removeSelf()
						grupoAguarde.texto:removeSelf()
						grupoAguarde.telaPreta = nil
						grupoAguarde.texto = nil
					end
					timer.performWithDelay(16,function()media.stopSound();audio.stop();rodarAudiosParagrafos() end,1)
				else
					if nomesArquivosParagrafos and nomesArquivosParagrafos[controladorParagrafos] then
						os.remove(nomesArquivosParagrafos[controladorParagrafos])
					end
				end
				idcancelado  = false
					
			end
		end
		  
		arquivo = "textoVozGeral Tela("..paginaAtual..")."..varGlobal.extencao

		
		local function fileExistsInTTSFolder(fileName)
			local filePath = system.pathForFile("TTS/dllTTS.txt", system.ResourceDirectory)

			local caminho2 = filePath
		
			local file2, errorString = io.open( caminho2, "r" )
			local vetor = {}
			local texto = ""
			local xx = 0
			if not file2 then
				print( "File error: " .. errorString )
			else
				-- Output lines
				local contents = file2:read( "*a" )
				local filtrado = string.gsub(contents,".",{ ["\13"] = "",["\10"] = "\13\10"})
				for line in string.gmatch(filtrado,"([^\13\10]+)") do
					if string.len(line)>1 then
						for past in string.gmatch(line, '([A-Za-z0-9%?!@#$=%&"[%-]:;/%.,\\_+-*ÂÃÁ ÀÉÊÍÎÕÔÓÚÜ%âãáàéêíîõôóúü%(%)]+)') do
							line = past
						end
						table.insert(vetor,line)
						xx = xx+1
					end
				end
				for i=1,#vetor do
					if i~= #vetor then
						if varGlobal.tipoSistema == "android" then
							--vetor[i] = vetor[i]:sub(1, #vetor[i] - 1)
						end
					end
				end
				io.close( file2 )
				file2 = nil
			end
			local temArquivo = false
			for i=1,#vetor do
				--print(vetor[i],fileName)
				if vetor[i] == fileName then
					temArquivo = true
				end
			end
			print("EXISTE??",temArquivo)
			return temArquivo
		end
		local function fileExists2(fileName)
			local filePath = system.pathForFile(fileName, varGlobal.pastaBaseTTS)
				local results = false
			if filePath == nil then
				return false
			else
				local file = io.open(filePath, "r")
				--If the file exists, return true
				if file then
					io.close(file)
					results = true
				end
				return results
			end
		end
		
		local ParAgraFoFinal0 = 100--200
		local ParAgraFo0 = 75--150
		
		-- VERIFICANDO VELOCIADE TTS ATUAL --
		varGlobal.acrescimoVeloc = varGlobal.VelocidadeTTS
		varGlobal.pastaBaseTTS = system.DocumentsDirectory
		if varGlobal.VelocidadeTTS ~= varGlobal.preferenciasGerais.VelocidadeTTS then
			varGlobal.acrescimoVeloc = varGlobal.VelocidadeTTS
			varGlobal.pastaBaseTTS = system.TemporaryDirectory
		end
		-------------------------------------	
		-- Caso tenha arquivo offline em pasta TTS -----------------
		if fileExistsInTTSFolder("Tela"..paginaExecutada.."somTTS ".. 1 .."Vec"..varGlobal.acrescimoVeloc.."."..varGlobal.extencao) then
		--if media.newEventSound("TTS/".."Tela"..paginaExecutada.."somTTS ".. 1 .."Vec"..varGlobal.acrescimoVeloc.."."..varGlobal.extencao,system.ResourceDirectory)  then
			media.stopSound()
			audio.stop()
			--[[local ParAgraFoFinal0 = ParAgraFoFinal0
			local ParAgraFo0 = ParAgraFo0
			if type(tonumber(paginaAtual)) == "number" and telasAnteriores >= paginaAtual and  paginaAtual < telasAnteriores + verificarNumeroIndices  then
				print("lendo indice")
				
				
				local textoSimples = string.gsub(texto,"\n","#$*$##$*$#")
				local is_valid, error_position = validarUTF8.validate(textoSimples)
				if not is_valid then print('non-utf8 sequence detected at position ' .. tostring(error_position))
					textoSimples = conversor.converterANSIparaUTFsemBoom(textoSimples)
				end
				local textoSimples = string.gsub(textoSimples,"SUMÃ.ARIO","SUMÁRIO")
				textoSimples = string.gsub(textoSimples,"Ã.MNDICE","Índice")
				textoSimples = string.gsub(textoSimples,"QUESTÃ.UES","QUESTÕES")
				ParAgraFoFinal0 = 50
				ParAgraFo0 = 30
			end
			local nTTS = 1
			local ultimoParagrafoPequeno = {}
			local xxx = 1
			local paragrafoFinal = ""
			local ultimaFraseSemUltimoParagrafoPequeno = ""
			for paragrafo in string.gmatch(texto,"[^#$*$#]+") do
				paragrafoFinal = paragrafoFinal .. paragrafo .. "\n"
				
				if string.len(paragrafoFinal) > ParAgraFoFinal0 and string.len(paragrafo) > ParAgraFo0 then
					--print("Paragrafo "..nTTS.." = "..paragrafoFinal)
					table.insert(nomesArquivosParagrafos,"Tela"..paginaAtual.."somTTS "..nTTS.."Vec"..varGlobal.acrescimoVeloc.."."..extencao)
					table.insert(tableParagrafosFinais,paragrafoFinal)
					print("WARNING: nTTS",nTTS)
					nTTS = nTTS+1
					paragrafoFinal = ""
					ultimaFraseSemUltimoParagrafoPequeno = ""
				end	
			end
			if paragrafoFinal ~= "" then

				--print("Paragrafo "..nTTS.." = "..paragrafoFinal)
				table.insert(nomesArquivosParagrafos,"Tela"..paginaAtual.."somTTS "..nTTS.."Vec"..varGlobal.acrescimoVeloc.."."..varGlobal.extencao)
				table.insert(tableParagrafosFinais,paragrafoFinal)

				paragrafoFinal = ""
				nTTS = nTTS+1
			end
			if tableParagrafosFinais and not string.find(tableParagrafosFinais[1],"%a+") then
				print("ACHOU NADA NA PAGINA")
				if string.find(varGlobal.TTSVozIdioma,"en") then
					tableParagrafosFinais[1] = "Empty Page, going for the next one:"
				elseif string.find(varGlobal.TTSVozIdioma,"br") then
					tableParagrafosFinais[1] = "Página sem áudio, indo para a próxima!"
				end
			end
			controladorSons = 1
			if botaoVoltarFoiApertado == true then
				controladorSons = #nomesArquivosParagrafos
				botaoVoltarFoiApertado = false
				if grupoAguarde.telaPreta then
					grupoAguarde.telaPreta:removeSelf()
					grupoAguarde.texto:removeSelf()
					grupoAguarde.telaPreta = nil
					grupoAguarde.texto = nil
				end
			end
			timer.performWithDelay(16,function()rodarAudiosParagrafosOffline() end,1)]]
			
			local paragrafoFinal = ""

			for i=1,#vetorTTS do
				print("vetorTTS")
				vetorTTS[i] = string.gsub(vetorTTS[i],"\n","#$*$#")
			end
			if not vetorTTS.audio then vetorTTS.audio = {} end
			if not vetorTTS.video then vetorTTS.video = {} end
			if not vetorTTS.botao then vetorTTS.botao = {} end
			if not vetorTTS.animacao then vetorTTS.animacao = {} end
			media.stopSound()
			audio.stop()

			
			local nTTS = 1
			local ultimoParagrafoPequeno = {}
			local xxx = 1
			local ultimaFraseSemUltimoParagrafoPequeno = ""
			for i=1,#vetorTTS do
				local texto = vetorTTS[i]
				print("texto = ",texto)
				for paragrafo in string.gmatch(texto,"[^#$*$#]+") do
					 
					paragrafoFinal = paragrafoFinal .. paragrafo .. "\n"

					if string.len(paragrafoFinal) > ParAgraFoFinal0 and string.len(paragrafo) > ParAgraFo0 then
						--print("Paragrafo "..nTTS.." = "..paragrafoFinal)
						table.insert(nomesArquivosParagrafos,"Tela"..paginaAtual.."somTTS "..nTTS.."Vec"..varGlobal.acrescimoVeloc.."."..varGlobal.extencao)
						table.insert(tableParagrafosFinais,paragrafoFinal)
						nTTS = nTTS+1
						
						paragrafoFinal = ""
						ultimaFraseSemUltimoParagrafoPequeno = ""
					end
					xxx = xxx + 1
				end
				if paragrafoFinal ~= "" then
					table.insert(nomesArquivosParagrafos,"Tela"..paginaAtual.."somTTS "..nTTS.."Vec"..varGlobal.acrescimoVeloc.."."..varGlobal.extencao)
					table.insert(tableParagrafosFinais,paragrafoFinal)
					print("print(paragrafoFinal)",paragrafoFinal)
					paragrafoFinal = ""
					nTTS = nTTS+1
				end
				if vetorTTS.audio[i] then

					table.insert(tableParagrafosFinais,paragrafoFinal)
					table.insert(nomesArquivosParagrafos,vetorTTS.audio[i])
					tableParagrafosFinais.audio[#tableParagrafosFinais] = vetorTTS.audio[i]
					nomesArquivosParagrafos.audio[nTTS] = vetorTTS.audio[i]
					nTTS = nTTS+1
				elseif vetorTTS.video[i] then
					table.insert(tableParagrafosFinais,paragrafoFinal)
					table.insert(nomesArquivosParagrafos,vetorTTS.video[i])
					tableParagrafosFinais.video[#tableParagrafosFinais] = vetorTTS.video[i]
					nomesArquivosParagrafos.video[nTTS] = vetorTTS.video[i]
					nTTS = nTTS+1
				elseif vetorTTS.animacao[i] then
					table.insert(tableParagrafosFinais,paragrafoFinal)
					table.insert(nomesArquivosParagrafos,vetorTTS.animacao[i].som)
					tableParagrafosFinais.animacao[#tableParagrafosFinais] = vetorTTS.animacao[i]
					nomesArquivosParagrafos.animacao[nTTS] = vetorTTS.animacao[i]
					nTTS = nTTS+1
				elseif vetorTTS.botao[i] then
					
					table.insert(tableParagrafosFinais,paragrafoFinal)
					table.insert(nomesArquivosParagrafos,vetorTTS.botao[i])
					tableParagrafosFinais.botao[#tableParagrafosFinais] = vetorTTS.botao[i]
					nomesArquivosParagrafos.botao[nTTS] = vetorTTS.botao[i]
					nTTS = nTTS+1
				end
			end
			if botaoVoltarFoiApertado == true then
				controladorSons = #nomesArquivosParagrafos
				botaoVoltarFoiApertado = false
			end
			print(nomesArquivosParagrafos[1])
			params.response = {
				filename = nomesArquivosParagrafos[1],
				baseDirectory = varGlobal.pastaBaseTTS
			}
			if tableParagrafosFinais and not string.find(tableParagrafosFinais[1],"%a+") then
				print("ACHOU NADA NA PAGINA")
				if string.find(varGlobal.TTSVozIdioma,"en") then
					tableParagrafosFinais[1] = "Empty Page, going for the next one:"
				elseif string.find(varGlobal.TTSVozIdioma,"br") then
					tableParagrafosFinais[1] = "Página sem áudio, indo para a próxima!"
				end
			end
			media.stopSound()
			controladorSons = 1
			if botaoVoltarFoiApertado == true then
				controladorSons = #nomesArquivosParagrafos
				botaoVoltarFoiApertado = false
				if grupoAguarde.telaPreta then
					grupoAguarde.telaPreta:removeSelf()
					grupoAguarde.texto:removeSelf()
					grupoAguarde.telaPreta = nil
					grupoAguarde.texto = nil
				end
			end
			timer.performWithDelay(16,function()rodarAudiosParagrafosOffline() end,1)
		-------------------------------------------------------------
		-- se já tem áudio gerado para a página
		elseif fileExists2("Tela"..paginaAtual.."somTTS ".. 1 .."Vec"..varGlobal.acrescimoVeloc.."."..varGlobal.extencao) then
				texto = conversor.substituirQuebrasDeLinha(texto)
				texto = tirarQuebrasDeLinhaRestantes(texto)
				for i=1,#vetorTTS do
					
					vetorTTS[i] = string.gsub(vetorTTS[i],"\n","#$*$#")
				end
				if not vetorTTS.audio then vetorTTS.audio = {} end
				if not vetorTTS.video then vetorTTS.video = {} end
				if not vetorTTS.animacao then vetorTTS.animacao = {} end
				if not vetorTTS.botao then vetorTTS.botao = {} end
				media.stopSound()
				audio.stop()
				local nTTS = 1
				local ultimoParagrafoPequeno = {}
				local xxx = 1
				local paragrafoFinal = ""
				for i=1,#vetorTTS do
					local texto = vetorTTS[i]
					print("texto 2 = ",texto)
					for paragrafo in string.gmatch(texto,"[^#$*$#]+") do
						 
						paragrafoFinal = paragrafoFinal .. paragrafo .. "\n"

						if string.len(paragrafoFinal) > ParAgraFoFinal0 and string.len(paragrafo) > ParAgraFo0 then
							--print("Paragrafo "..nTTS.." = "..paragrafoFinal)
							table.insert(nomesArquivosParagrafos,"Tela"..paginaAtual.."somTTS "..nTTS.."Vec"..varGlobal.acrescimoVeloc.."."..varGlobal.extencao)
							table.insert(tableParagrafosFinais,paragrafoFinal)
							nTTS = nTTS+1

							
							paragrafoFinal = ""
							ultimaFraseSemUltimoParagrafoPequeno = ""
						end
						xxx = xxx + 1
					end
					
					if paragrafoFinal ~= "" then
						table.insert(nomesArquivosParagrafos,"Tela"..paginaAtual.."somTTS "..nTTS.."Vec"..varGlobal.acrescimoVeloc.."."..varGlobal.extencao)
						table.insert(tableParagrafosFinais,paragrafoFinal)
						print("print(paragrafoFinal)",paragrafoFinal)
						paragrafoFinal = ""
						nTTS = nTTS+1
					end
					if tableParagrafosFinais[1] and not string.find(tableParagrafosFinais[1],"%a+") then
						print("ACHOU NADA NA PAGINA")
						if string.find(varGlobal.TTSVozIdioma,"en") then
							tableParagrafosFinais[1] = "Empty Page, going for the next one:"
						elseif string.find(varGlobal.TTSVozIdioma,"br") then
							tableParagrafosFinais[1] = "Página sem áudio, indo para a próxima!"
						end
					end
					if vetorTTS.audio[i] then
						table.insert(tableParagrafosFinais,paragrafoFinal)
						table.insert(nomesArquivosParagrafos,vetorTTS.audio[i])
						tableParagrafosFinais.audio[#tableParagrafosFinais] = vetorTTS.audio[i]
						nomesArquivosParagrafos.audio[nTTS] = vetorTTS.audio[i]
						nTTS = nTTS+1
					elseif vetorTTS.video[i] then
						table.insert(tableParagrafosFinais,paragrafoFinal)
						table.insert(nomesArquivosParagrafos,vetorTTS.video[i])
						tableParagrafosFinais.video[#tableParagrafosFinais] = vetorTTS.video[i]
						nomesArquivosParagrafos.video[nTTS] = vetorTTS.video[i]
						nTTS = nTTS+1
					elseif vetorTTS.animacao[i] then
						table.insert(tableParagrafosFinais,paragrafoFinal)
						table.insert(nomesArquivosParagrafos,vetorTTS.animacao[i].som)
						tableParagrafosFinais.animacao[#tableParagrafosFinais] = vetorTTS.animacao[i]
						nomesArquivosParagrafos.animacao[nTTS] = vetorTTS.animacao[i]
						nTTS = nTTS+1
					elseif vetorTTS.botao[i] then
						
						table.insert(tableParagrafosFinais,paragrafoFinal)
						table.insert(nomesArquivosParagrafos,vetorTTS.botao[i])
						tableParagrafosFinais.botao[#tableParagrafosFinais] = vetorTTS.botao[i]
						nomesArquivosParagrafos.botao[nTTS] = vetorTTS.botao[i]
						nTTS = nTTS+1
					end
					
				end
				controladorSons = 1
				if botaoVoltarFoiApertado == true then
					controladorSons = #nomesArquivosParagrafos
					botaoVoltarFoiApertado = false
					if grupoAguarde.telaPreta then
						grupoAguarde.telaPreta:removeSelf()
						grupoAguarde.texto:removeSelf()
						grupoAguarde.telaPreta = nil
						grupoAguarde.texto = nil
					end
				end
				timer.performWithDelay(16,function()rodarAudiosParagrafos() end,1)

		else
			-- se ainda não tem nenhum áudio gerado para a página
			media.stopSound()
			audio.stop()
			--print("Ainda não tem arquivo baixado de TTS na página")
			local som = audio.loadSound(varGlobal.botaoGenerateAudioTTS,{onComplete = baixarOsAudios})
			--audio.play(som)
			timer.performWithDelay(30,function()audio.play(som)end,1)
			local paragrafoFinal = ""

			for i=1,#vetorTTS do
				--print("vetorTTS")
				vetorTTS[i] = string.gsub(vetorTTS[i],"\n","#$*$#")
			end
			if not vetorTTS.audio then vetorTTS.audio = {} end
			if not vetorTTS.video then vetorTTS.video = {} end
			if not vetorTTS.botao then vetorTTS.botao = {} end
			if not vetorTTS.animacao then vetorTTS.animacao = {} end
			media.stopSound()
			audio.stop()

			
			local nTTS = 1
			local ultimoParagrafoPequeno = {}
			local ultimaFraseSemUltimoParagrafoPequeno = ""
			for i=1,#vetorTTS do
				local texto = vetorTTS[i]
				--print("texto = ",texto)
				for paragrafo in string.gmatch(texto,"[^#$*$#]+") do
					 
					paragrafoFinal = paragrafoFinal .. paragrafo .. "\n"

					if string.len(paragrafoFinal) > ParAgraFoFinal0 and string.len(paragrafo) > ParAgraFo0 then
						--print("Paragrafo "..nTTS.." = "..paragrafoFinal)
						table.insert(nomesArquivosParagrafos,"Tela"..paginaAtual.."somTTS "..nTTS.."Vec"..varGlobal.acrescimoVeloc.."."..varGlobal.extencao)
						table.insert(tableParagrafosFinais,paragrafoFinal)
						nTTS = nTTS+1
						
						paragrafoFinal = ""
						ultimaFraseSemUltimoParagrafoPequeno = ""
					end
				end
				if paragrafoFinal ~= "" then
					table.insert(nomesArquivosParagrafos,"Tela"..paginaAtual.."somTTS "..nTTS.."Vec"..varGlobal.acrescimoVeloc.."."..varGlobal.extencao)
					table.insert(tableParagrafosFinais,paragrafoFinal)
					print("print(paragrafoFinal)",paragrafoFinal)
					paragrafoFinal = ""
					nTTS = nTTS+1
				end
				if vetorTTS.audio[i] then

					table.insert(tableParagrafosFinais,paragrafoFinal)
					table.insert(nomesArquivosParagrafos,vetorTTS.audio[i])
					tableParagrafosFinais.audio[#tableParagrafosFinais] = vetorTTS.audio[i]
					nomesArquivosParagrafos.audio[nTTS] = vetorTTS.audio[i]
					nTTS = nTTS+1
				elseif vetorTTS.video[i] then
					table.insert(tableParagrafosFinais,paragrafoFinal)
					table.insert(nomesArquivosParagrafos,vetorTTS.video[i])
					tableParagrafosFinais.video[#tableParagrafosFinais] = vetorTTS.video[i]
					nomesArquivosParagrafos.video[nTTS] = vetorTTS.video[i]
					nTTS = nTTS+1
				elseif vetorTTS.animacao[i] then
					table.insert(tableParagrafosFinais,paragrafoFinal)
					table.insert(nomesArquivosParagrafos,vetorTTS.animacao[i].som)
					tableParagrafosFinais.animacao[#tableParagrafosFinais] = vetorTTS.animacao[i]
					nomesArquivosParagrafos.animacao[nTTS] = vetorTTS.animacao[i]
					nTTS = nTTS+1
				elseif vetorTTS.botao[i] then
					
					table.insert(tableParagrafosFinais,paragrafoFinal)
					table.insert(nomesArquivosParagrafos,vetorTTS.botao[i])
					tableParagrafosFinais.botao[#tableParagrafosFinais] = vetorTTS.botao[i]
					nomesArquivosParagrafos.botao[nTTS] = vetorTTS.botao[i]
					nTTS = nTTS+1
				end
			end
			if botaoVoltarFoiApertado == true then
				controladorSons = #nomesArquivosParagrafos
				botaoVoltarFoiApertado = false
			end
			params.response = {
				filename = nomesArquivosParagrafos[1],
				baseDirectory = varGlobal.pastaBaseTTS
			}
			if tableParagrafosFinais and not string.find(tableParagrafosFinais[1],"%a+") then
				print("ACHOU NADA NA PAGINA")
				if string.find(varGlobal.TTSVozIdioma,"en") then
					tableParagrafosFinais[1] = "Empty Page, going for the next one:"
				elseif string.find(varGlobal.TTSVozIdioma,"br") then
					tableParagrafosFinais[1] = "Página sem áudio, indo para a próxima!"
				end
			end
			timer.performWithDelay(16,function()media.playSound("som gerando audio.MP3")end,1)
			local frase = tableParagrafosFinais[1]:urlEncode()
			--print(frase)
			funcGlobal.requisitarTTSOnline({tipo = varGlobal.TTSTipo,voz = varGlobal.TTSVoz,params = params,qualidade = qualidadeSom,idioma = varGlobal.TTSVozIdioma,texto = frase,extensao = varGlobal.extensao,funcao = networkListenerTTS})
		end
	end

	-- PADRÃO ------------------------------
	local altura = 100
	local largura = 100
	local arquivoUp = "tts.png"
	local arquivoDown = "ttsDown.png"
	--local arquivoUpReiniciar = "tts reiniciar.png"
	--local arquivoDownReiniciar = "tts reiniciar down.png"
	local arquivoUpReiniciar = "tts parar.png"
	local arquivoDownReiniciar = "tts parar down.png"
	local arquivoUpPause = "tts pausePlay.png"
	local arquivoDownPause = "tts pausePlayD.png"
	local arquivoUpForward = "tts forwardUp.png"
	local arquivoDownForward = "tts forwardDown.png"
	local arquivoUpBackward = "tts backwardUp.png"
	local arquivoDownBackward = "tts backwardDown.png"
	local _x = W
	local _y = 0
	
	-- ATRIBUTOS ---------------------------
	if atributos then
		if atributos.altura then
			altura = atributos.altura
		end
		if atributos.largura then
			largura = atributos.largura
		end
		if atributos.arquivoUp then
			arquivoUp = atributos.arquivoUp
		end
		if atributos.arquivoDown then
			arquivoDown = atributos.arquivoDown
		end
		if atributos.x then
			_x = atributos.x
		end
		if atributos.y then
			_y = atributos.y
		end
	end
	----------------------------------------
	
	local function despausarTudo()
		if botaoPause.isVisible == true then
			audio.resume()
			media.playSound()
		end
		pausarDespausarAnimacao("despausar")
	end
	function handleButtonEventPlayTTS( event )
		
		if event.phase == "began" then
			event.target.selecionado1 = true
			media.pauseSound()
			audio.pause()
			pausarDespausarAnimacao("pausar")
			local som = audio.loadSound(varGlobal.botaoFirstTouchAudioTTS)
			audio.play(som,{onComplete = despausarTudo})
			funcGlobal.escreverNoHistorico(varGlobal.HistoricoTTSClicar1);
			timer.performWithDelay(1000,function() event.target.selecionado1 = false end,1)
		elseif event.phase == "moved" then
			--system.vibrate()
			audio.stop()
			local som = audio.loadSound(varGlobal.botaoFirstTouchAudioTTS)
			audio.play(som)
		elseif event.phase == "ended" and event.target and event.target.selecionado2 == false  then
			event.target.selecionado2 = true
			audio.stop()
			local som = audio.loadSound(varGlobal.botaoFirstTouchAudioTTS)
			audio.play(som)
			timer.performWithDelay(1000,function() event.target.selecionado2 = false end,1)
			if Var then
				if Var.mensagemTemp and Var.mensagemTemp.remover then
					Var.mensagemTemp.remover()
				end
				Var.mensagemTemp = auxFuncs.criarMensagemTemporaria(varGlobal.linguagem_MensagemTemp,event.x,event.y,400,200,2000)
			end
		elseif event.phase == "ended" and event.target.selecionado1 == true and event.target.selecionado2 == true  then
				--toqueHabilitado = false
				if Var then
					if Var.mensagemTemp and Var.mensagemTemp.remover then
						Var.mensagemTemp.remover()
					end
				end
				local date = os.date( "*t" )
				local data = date.day.."/"..date.month.."/"..date.year
				local hora = date.hour..":"..date.min..":"..date.sec
				local pH = funcGlobal.pegarNumeroPaginaRomanosHistorico(varGlobal.PagH)
				local vetorJson = {
					tipoInteracao = "TTS",
					pagina_livro = varGlobal.PagH,
					objeto_id = nil,
					acao = "gerar",
					velocidade_tts = varGlobal.VelocidadeTTS,
					relatorio = data.."| Ativou o TTS da página "..pH.." às "..hora.." com velocidade  "..varGlobal.VelocidadeTTS.."."
				};
				if GRUPOGERAL.subPagina then
					vetorJson.subPagina = GRUPOGERAL.subPagina;
				end
				funcGlobal.escreverNoHistorico(varGlobal.HistoricoTTSClicar2,vetorJson);
				pausarDespausarAnimacao("parar")
				local tipo = "txt"
				--if event.phase == "began" then
				audio.stop()
				media.stopSound()
				if VetorDeVetorTTS[paginaAtual] ~= nil and VetorDeVetorTTS[paginaAtual] ~= {} then
					for i=1,VetorDeVetorTTS[paginaAtual].numero do
						if textoTTS == varGlobal.textoPadRaO then
							textoTTS = VetorDeVetorTTS[paginaAtual][i]
						else
							local auxi = i
							if type(paginaAtual) == "string" then
								--auxi = ""..i..""
							end
							if not textoTTS then textoTTS = "" end
							print(paginaAtual,auxi,VetorDeVetorTTS[paginaAtual][auxi])
							textoTTS = textoTTS .. ". " .. VetorDeVetorTTS[paginaAtual][auxi]
							if VetorDeVetorTTS[paginaAtual].audio then
								--textoTTS = textoTTS .. ". Executando o áudio: #audio#" .. VetorDeVetorTTS[paginaAtual][i].audio .."#/audio#"
							elseif VetorDeVetorTTS[paginaAtual].video then
								--textoTTS = textoTTS .. ". Executando o vídeo: #video#" .. VetorDeVetorTTS[paginaAtual][i].video .."#/video#"
							elseif VetorDeVetorTTS[paginaAtual].animacao then
								--textoTTS = textoTTS .. ". Executando o áudio da animação: #animacao#" .. VetorDeVetorTTS[paginaAtual][i].animacao .."#/animacao#"
							end
						end
					end
					if VetorDeVetorTTS[paginaAtual].tipo and VetorDeVetorTTS[paginaAtual].tipo == "TTS" then
						tipo = "TTS"
					end
				end
				if textoTTS == varGlobal.textoPadRaO then
					local som = audio.loadStream(varGlobal.botaoSemAudioTTS)
					audio.play(som)
				else
					converterTexto(textoTTS,tipo,VetorDeVetorTTS[paginaAtual])
					audio.stop()
					media.stopSound()
					auxFuncs.stopAllSounds()
				end
					--return true
				--end
				--if "cancelled" == event.phase then
				if textoTTS == varGlobal.TeXtOpAdRaO then
					varGlobal.vaiPassarPraFrente = false
				else
					varGlobal.vaiPassarPraFrente = true
				end
					
				--end
				return true
			--end
		end
	end
	local botao = widget.newButton(
    {
        height = altura,
        width = largura,
        defaultFile = arquivoUp,
		overFile = arquivoDown,
        onEvent = handleButtonEventPlayTTS,
		x = _x,
		y = _y
		
    })
	botao.selecionado1 = false
	botao.selecionado2 = false
	botao:addEventListener("tap",function() return true; end)
	if not varGlobal.preferenciasGerais.TTSDesativado or varGlobal.preferenciasGerais.TTSDesativado == "sim" then
		botao.isVisible = false
	end
	local pausado = false
	local function pausePlay(e)
		if e.phase == "moved" then
			--vibrator.vibrate(10)
			system.vibrate()
		elseif e.phase == "ended" then
			if clicouBOTAOtts == false then
				if e.target.tipo == "pause" then
					clicouBOTAOtts = true
					media.pauseSound()
					audio.pause()
					pausarDespausarAnimacao("parar")
					if nomesArquivosParagrafos.video[controladorSons] then
						
						if varGlobal.grupoVideoTTS.videoTTS then
							varGlobal.grupoVideoTTS.videoTTS:pause()
							local date = os.date( "*t" )
							local data = date.day.."/"..date.month.."/"..date.year
							local hora = date.hour..":"..date.min..":"..date.sec
							local pH = funcGlobal.pegarNumeroPaginaRomanosHistorico(varGlobal.PagH)
							local vetorJson = {
								tipoInteracao = "TTS",
								pagina_livro = varGlobal.PagH,
								objeto_id = controladorSons,
								acao = "pausar",
								subtipo = "video",
								tempo_atual_video = 0,
								tempo_total = tempoTotal,
								relatorio = data.."| Pausou o áudio "..controladorSons.." do TTS da página "..pH.." às "..hora.." com velocidade  "..varGlobal.VelocidadeTTS..". O áudio tem duração de ".. auxFuncs.SecondsToClock(varGlobal.TTSduracaoTotal)..". Numero de elementos TTS da página: "..controladorSons.."/"..#nomesArquivosParagrafos.."."
							};
							if GRUPOGERAL.subPagina then
								vetorJson.subPagina = GRUPOGERAL.subPagina;
							end	
							funcGlobal.escreverNoHistorico(varGlobal.HistoricoVideoNormalPausar..controladorSons.."|Total: "..tostring(tempoTotal),vetorJson)
						end
					elseif nomesArquivosParagrafos.animacao[controladorSons] then
						pausarDespausarAnimacaoTTS("pausar",varGlobal.grupoAnimacaoTTS.animacaoTTS)
						local date = os.date( "*t" )
						local data = date.day.."/"..date.month.."/"..date.year
						local hora = date.hour..":"..date.min..":"..date.sec
						local pH = funcGlobal.pegarNumeroPaginaRomanosHistorico(varGlobal.PagH)
						local vetorJson = {
							tipoInteracao = "TTS",
							pagina_livro = varGlobal.PagH,
							objeto_id = controladorSons,
							acao = "pausar",
							subtipo = "animação",
							relatorio = data.."| Pausou a animação "..controladorSons.." do TTS da página"..pH.." às "..hora..". Numero de elementos TTS da página: "..controladorSons.."/"..#nomesArquivosParagrafos.."."
						};
						if GRUPOGERAL.subPagina then
							vetorJson.subPagina = GRUPOGERAL.subPagina;
						end	
						funcGlobal.escreverNoHistorico(varGlobal.HistoricoPausarAnimacao.."|TTS nº: "..controladorSons,vetorJson)
					else
						local date = os.date( "*t" )
						local data = date.day.."/"..date.month.."/"..date.year
						local hora = date.hour..":"..date.min..":"..date.sec
						local pH = funcGlobal.pegarNumeroPaginaRomanosHistorico(varGlobal.PagH)
						local vetorJson = {
							tipoInteracao = "TTS",
							pagina_livro = varGlobal.PagH,
							objeto_id = nil,
							acao = "pausar",
							tts_valores = nomesArquivosParagrafos,
							valor_id = controladorSons,
							tempo_total = varGlobal.TTSduracaoTotal,
							velocidade_tts = varGlobal.VelocidadeTTS,
							relatorio = data.."| Pausou o áudio "..controladorSons.." do TTS da página "..pH.." às "..hora.." com velocidade  "..varGlobal.VelocidadeTTS..". O áudio tem duração de ".. auxFuncs.SecondsToClock(varGlobal.TTSduracaoTotal)..". Numero de elementos TTS da página: "..controladorSons.."/"..#nomesArquivosParagrafos.."."
						};
						if GRUPOGERAL.subPagina then
							vetorJson.subPagina = GRUPOGERAL.subPagina;
						end	
						funcGlobal.escreverNoHistorico(varGlobal.HistoricoTTSPausar.."|Total = "..varGlobal.TTSduracaoTotal,vetorJson);
					end
					
					local som = audio.loadSound(varGlobal.botaoPauseAudioTTS)
					audio.play(som,{onComplete = function()
						clicouBOTAOtts = false
						if botaoReiniciar.isVisible == true then
							botaoplayTTS.isVisible = true
							botaoPause.isVisible = false
						end
						print("pausou")
					end})
					
					
					
				elseif e.target.tipo == "play" then

					clicouBOTAOtts = true
					media.pauseSound()
					audio.pause()
					
					local som = audio.loadSound(varGlobal.botaoResumeAudioTTS)
					audio.play(som,{onComplete = function()
						clicouBOTAOtts = false
						if botaoReiniciar.isVisible == true then
							audio.resume();
							botaoplayTTS.isVisible = false;
							botaoPause.isVisible = true;
							if nomesArquivosParagrafos.video[controladorSons] then
								if varGlobal.grupoVideoTTS.videoTTS then
									varGlobal.grupoVideoTTS.videoTTS:play()
								end
							end
						end
						if nomesArquivosParagrafos.video[controladorSons] then
							local date = os.date( "*t" )
							local data = date.day.."/"..date.month.."/"..date.year
							local hora = date.hour..":"..date.min..":"..date.sec
							local pH = funcGlobal.pegarNumeroPaginaRomanosHistorico(varGlobal.PagH)
							local vetorJson = {
								tipoInteracao = "TTS",
								pagina_livro = varGlobal.PagH,
								objeto_id = controladorSons,
								acao = "despausar",
								subtipo = "video",
								tempo_atual_video = varGlobal.grupoVideoTTS.videoTTS.currentTime,
								tempo_total = tempoTotal,
								relatorio = data.."| Despausou o vídeo "..controladorSons.." do TTS da página "..pH.." aos "..auxFuncs.SecondsToClock(varGlobal.grupoVideoTTS.videoTTS.currentTime).." de execução às "..hora.."."
							};
							if GRUPOGERAL.subPagina then
								vetorJson.subPagina = GRUPOGERAL.subPagina;
							end	
							funcGlobal.escreverNoHistorico(varGlobal.HistoricoVideoNormalExecutar..controladorSons.."|Total: "..tostring(tempoTotal),vetorJson)
						elseif nomesArquivosParagrafos.animacao[controladorSons] then
							pausarDespausarAnimacaoTTS("despausar",varGlobal.grupoAnimacaoTTS.animacaoTTS)
							local date = os.date( "*t" )
							local data = date.day.."/"..date.month.."/"..date.year
							local hora = date.hour..":"..date.min..":"..date.sec
							local pH = funcGlobal.pegarNumeroPaginaRomanosHistorico(varGlobal.PagH)
							local vetorJson = {
								tipoInteracao = "TTS",
								pagina_livro = varGlobal.PagH,
								objeto_id = controladorSons,
								acao = "despausar",
								subtipo = "animação",
								relatorio = data.."| Despausou a animação "..controladorSons.." do TTS da página "..pH.." às "..hora.."."
							};
							if GRUPOGERAL.subPagina then
								vetorJson.subPagina = GRUPOGERAL.subPagina;
							end	
							funcGlobal.escreverNoHistorico(varGlobal.HistoricoDespausarAnimacao.."|TTS nº:"..controladorSons,vetorJson)
						else
							local date = os.date( "*t" )
							local data = date.day.."/"..date.month.."/"..date.year
							local hora = date.hour..":"..date.min..":"..date.sec
							local pH = funcGlobal.pegarNumeroPaginaRomanosHistorico(varGlobal.PagH)
							local vetorJson = {
								tipoInteracao = "TTS",
								pagina_livro = varGlobal.PagH,
								objeto_id = nil,
								acao = "despausar",
								tts_valores = nomesArquivosParagrafos,
								valor_id = controladorSons,
								tempo_total = varGlobal.TTSduracaoTotal,
								velocidade_tts = varGlobal.VelocidadeTTS,
								relatorio = data.."| Despausou o áudio "..controladorSons.." do TTS da página "..pH.." às "..hora.." com velocidade  "..varGlobal.VelocidadeTTS..". O áudio tem duração de ".. auxFuncs.SecondsToClock(varGlobal.TTSduracaoTotal)..". Numero de elementos TTS da página: "..controladorSons.."/"..#nomesArquivosParagrafos.."."
							};
							if GRUPOGERAL.subPagina then
								vetorJson.subPagina = GRUPOGERAL.subPagina;
							end	
							funcGlobal.escreverNoHistorico(varGlobal.HistoricoTTSDespausar.."|Total = "..varGlobal.TTSduracaoTotal,vetorJson);
						end
						print("executou");
					end})
					pausarDespausarAnimacao("parar")
					
				end
				clicouVoltar = false
				clicouAvancar = false
			end
			return true
		end
		return true
	end
	
	botao.anchorX = 1
	botao.anchorY = 0
	varGlobal.GRUPOTTS:insert(botao)
	
	botaoReiniciar = widget.newButton(
    {
        height = altura,
        width = largura,
        defaultFile = arquivoUpReiniciar,
		overFile = arquivoDownReiniciar,
        onEvent = function(event)
        			if event.phase == "moved" then
        				system.vibrate()
        			elseif event.phase == "ended" then
						if clicouBOTAOtts == false then
							toqueHabilitado = true
							local date = os.date( "*t" )
							local data = date.day.."/"..date.month.."/"..date.year
							local hora = date.hour..":"..date.min..":"..date.sec
							local pH = funcGlobal.pegarNumeroPaginaRomanosHistorico(varGlobal.PagH)
							local vetorJson = {
								tipoInteracao = "TTS",
								pagina_livro = varGlobal.PagH,
								objeto_id = nil,
								acao = "parar",
								tts_valores = nomesArquivosParagrafos,
								valor_id = controladorSons,
								tempo_total = varGlobal.TTSduracaoTotal,
								velocidade_tts = varGlobal.VelocidadeTTS,
								relatorio = data.."| Cancelou o áudio "..controladorSons.." do TTS da página "..pH.." às "..hora.." com velocidade  "..varGlobal.VelocidadeTTS..". O áudio tem duração de ".. auxFuncs.SecondsToClock(varGlobal.TTSduracaoTotal)..". Numero de elementos TTS da página: "..controladorSons.."/"..#nomesArquivosParagrafos.."."
							};
							if GRUPOGERAL.subPagina then
								vetorJson.subPagina = GRUPOGERAL.subPagina;
							end	
					
							media.pauseSound()
							audio.pause()
							local som = audio.loadSound(varGlobal.botaoStopAudioTTS)
							clicouBOTAOtts = true
							local function funcaoDeParar()
								media.stopSound();
								audio.stop();
								controladorSons = 1;
								clicouBOTAOtts = false;
								--timer.performWithDelay(100,function()rodarAudiosParagrafos() end,1)
								botao.isVisible = true
								botaoPause.isVisible = false
								botaoBackward.isVisible = false
								botaoForward.isVisible = false
								botaoReiniciar.isVisible = false
								botaoplayTTS.isVisible = false
								restoreNativeScreenElements()
								clearTTSelements()
							end
							audio.play(som,{onComplete = funcaoDeParar})
							pausarDespausarAnimacao("parar")
							clicouVoltar = false
							clicouAvancar = false
							
							funcGlobal.escreverNoHistorico(varGlobal.HistoricoTTSReiniciar.."|Total = "..varGlobal.TTSduracaoTotal,vetorJson);
						end
						
					end
				end,
		x = _x-W,
		y = _y
		
    })
	botaoReiniciar:addEventListener("tap",function() return true; end)
	botaoReiniciar.selecionado = false
	botaoReiniciar.anchorX = 0
	botaoReiniciar.isVisible = false
	botaoReiniciar.anchorY = 0
	varGlobal.GRUPOTTS:insert(botaoReiniciar)
	
	botaoplayTTS = widget.newButton(
    {
        height = altura,
        width = largura,
        defaultFile = "tts Play.png",
		overFile = "tts PlayD.png",
        onEvent = pausePlay,
		x = _x,--x = _x-W
		y = _y
		
    })
	botaoplayTTS.selecionado = false
	botaoplayTTS.tipo = "play"
	--botaoPause.xScale = -1
	botaoplayTTS:addEventListener("tap",function() return true; end)
	
	botaoplayTTS.anchorX = 1--botaoPause.anchorX = 0
	botaoplayTTS.isVisible = false
	botaoplayTTS.anchorY = 0
	varGlobal.GRUPOTTS:insert(botaoplayTTS)
	
	botaoPause = widget.newButton(
    {
        height = altura,
        width = largura,
        defaultFile = "tts pause.png",
		overFile = "tts pause down.png",
        onEvent = pausePlay,
		x = _x,--x = _x-W
		y = _y
		
    })
	--botaoPause.xScale = -1
	botaoPause:addEventListener("tap",function() return true; end)
	botaoPause.tipo = "pause"
	botaoPause.anchorX = 1--botaoPause.anchorX = 0
	botaoPause.isVisible = false
	botaoPause.anchorY = 0
	varGlobal.GRUPOTTS:insert(botaoPause)
	local function fileExistsInTTSFolder(fileName)
		local filePath = system.pathForFile("TTS/dllTTS.txt", system.ResourceDirectory)

		local caminho2 = filePath
	
		local file2, errorString = io.open( caminho2, "r" )
		local vetor = {}
		local texto = ""
		local xx = 0
		if not file2 then
			print( "File error: " .. errorString )
		else
			-- Output lines
			local contents = file2:read( "*a" )
			local filtrado = string.gsub(contents,".",{ ["\13"] = "",["\10"] = "\13\10"})
			for line in string.gmatch(filtrado,"([^\13\10]+)") do
				if string.len(line)>1 then
					for past in string.gmatch(line, '([A-Za-z0-9%?!@#$=%&"[%-]:;/%.,\\_+-*ÂÃÁ ÀÉÊÍÎÕÔÓÚÜ%âãáàéêíîõôóúü%(%)]+)') do
						line = past
					end
					table.insert(vetor,line)
					xx = xx+1
				end
			end
			for i=1,#vetor do
				if i~= #vetor then
					if varGlobal.tipoSistema == "android" then
						--vetor[i] = vetor[i]:sub(1, #vetor[i] - 1)
					end
				end
			end
			io.close( file2 )
			file2 = nil
		end
		local temArquivo = false
		for i=1,#vetor do
			--print(vetor[i],fileName)
			if vetor[i] == fileName then
				temArquivo = true
			end
		end
		print("EXISTE??",temArquivo)
		return temArquivo
	end
	
	local function voltarPlay(e)
		if e.phase == "moved" then
			system.vibrate()
		elseif e.phase == "ended" then
			pausarDespausarAnimacao("parar")
			local date = os.date( "*t" )
			local data = date.day.."/"..date.month.."/"..date.year
			local hora = date.hour..":"..date.min..":"..date.sec
			local pH = funcGlobal.pegarNumeroPaginaRomanosHistorico(varGlobal.PagH)
			local vetorJson = {
				tipoInteracao = "TTS",
				pagina_livro = varGlobal.PagH,
				objeto_id = nil,
				acao = "retroceder",
				tts_valores = nomesArquivosParagrafos,
				valor_id = controladorSons,
				tempo_total = varGlobal.TTSduracaoTotal,
				velocidade_tts = varGlobal.VelocidadeTTS,
				relatorio = data.."| Retrocedeu a execução do áudio "..controladorSons.." do TTS da página "..pH.." às "..hora.." com velocidade  "..varGlobal.VelocidadeTTS..". O áudio tem duração de ".. auxFuncs.SecondsToClock(varGlobal.TTSduracaoTotal)..". Numero de elementos TTS da página: "..controladorSons.."/"..#nomesArquivosParagrafos.."."
			};
			if GRUPOGERAL.subPagina then
				vetorJson.subPagina = GRUPOGERAL.subPagina;
			end	
			funcGlobal.escreverNoHistorico(varGlobal.HistoricoTTSVoltar.."|Total = "..varGlobal.TTSduracaoTotal,vetorJson);
			
			if clicouBOTAOtts == false or clicouVoltar == true then
				

				local function voltar(event)
					if not event or (event and event.completed == true) then
						clicouBOTAOtts = false;
						timerClicouVoltar = nil
						if nomesArquivosParagrafos[1] then
							if controladorSons > 1 then
								media.stopSound();
								audio.stop();
								timer.performWithDelay(10,function()media.stopSound();audio.stop();end,1);
								controladorSons = controladorSons -1;
								if type(paginaAtual) == "number" and paginaAtual-telasAnteriores+varGlobal.contagemInicialPaginas == 0 then
									timer.performWithDelay(16,function()rodarAudiosParagrafosINDICE() end,1);
								else
									
									if fileExistsInTTSFolder("Tela"..paginaAtual.."somTTS ".. 1 .."Vec"..varGlobal.acrescimoVeloc.."."..varGlobal.extencao) then
										timer.performWithDelay(16,function()rodarAudiosParagrafosOffline() end,1);
									else
										timer.performWithDelay(16,function()rodarAudiosParagrafos() end,1);
									end
								end
							else
								if type(paginaAtual) == "number" and paginaAtual > 1 and paginaAtual < telas.numeroTotal.Todas then
									media.stopSound();
									audio.stop();
									--media.playSound()
									botaoVoltarFoiApertado = true;
									rodarAnteriorPaginaTTS(telas);
								elseif type(paginaAtual) == "string" then
									botaoVoltarFoiApertado = true;
									controladorSons = controladorSons
									timer.performWithDelay(16,function()rodarAudiosParagrafos() end,1)
								end
							end
						end
						
						botaoplayTTS.isVisible = false;
						botaoPause.isVisible = true;
						return true;
					end
				end
				media.pauseSound()
				audio.pause()
				if clicouVoltar == false then
					if controladorSons == 1 and type(paginaAtual) == "number" and paginaAtual == 1 then
						local som = audio.loadSound("buttonSound.mp3")
						audio.play(som)
						audio.resume()
					else
						
						local som = audio.loadSound(varGlobal.botaoRewindAudioTTS)
						audio.play(som,{onComplete = voltar})
						timerClicouVoltar = timer.performWithDelay(3000,function()clicouVoltar = false;timerClicouVoltar = nil end,1)
						clicouVoltar = true
						clicouAvancar = false
						clicouBOTAOtts = true
					end
					return true
				else
					if controladorSons == 1 and type(paginaAtual) == "number" and paginaAtual == 1 then
						local som = audio.loadSound("buttonSound.mp3")
						audio.play(som)
						audio.resume()
					else
						if timerClicouVoltar then
							timer.cancel(timerClicouVoltar)
							clicouVoltar = true
							timerClicouVoltar = timer.performWithDelay(3000,function()clicouVoltar = false;timerClicouVoltar = nil end,1)
						end
						clicouVoltar = true
						clicouAvancar = false
						clicouBOTAOtts = true
						voltar()
					end
					return true
				end
				
				return true
			end
		end
		return true
	end

	local function avancarPlay(e)
		if e.phase == "moved" then
			system.vibrate()
		elseif e.phase == "ended" then
			pausarDespausarAnimacao("parar")
			local date = os.date( "*t" )
			local data = date.day.."/"..date.month.."/"..date.year
			local hora = date.hour..":"..date.min..":"..date.sec
			local pH = funcGlobal.pegarNumeroPaginaRomanosHistorico(varGlobal.PagH)
			local vetorJson = {
				tipoInteracao = "TTS",
				pagina_livro = varGlobal.PagH,
				objeto_id = nil,
				acao = "avançar",
				tts_valores = nomesArquivosParagrafos,
				valor_id = controladorSons,
				tempo_total = varGlobal.TTSduracaoTotal,
				velocidade_tts = varGlobal.VelocidadeTTS,
				relatorio = data.."| Avançou a execução do áudio "..controladorSons.." do TTS da página "..pH.." às "..hora.." com velocidade  "..varGlobal.VelocidadeTTS..". O áudio tem duração de ".. auxFuncs.SecondsToClock(varGlobal.TTSduracaoTotal)..". Numero de elementos TTS da página: "..controladorSons.."/"..#nomesArquivosParagrafos.."."
			};
			if GRUPOGERAL.subPagina then
				vetorJson.subPagina = GRUPOGERAL.subPagina;
			end	
			funcGlobal.escreverNoHistorico(varGlobal.HistoricoTTSAvancar.."|Total = "..varGlobal.TTSduracaoTotal,vetorJson);
			if clicouBOTAOtts == false or clicouAvancar == true then
				media.pauseSound()
				audio.pause()
				local function avancar(event)
					clicouBOTAOtts = false
					if not event or (event and event.completed == true) then
						if nomesArquivosParagrafos[1] then
							if controladorSons < #nomesArquivosParagrafos then
								media.stopSound();
								audio.stop();
								controladorSons = controladorSons +1;
								if type(paginaAtual) == "number" and paginaAtual-telasAnteriores+varGlobal.contagemInicialPaginas == 0 then
									timer.performWithDelay(16,function()rodarAudiosParagrafosINDICE() end,1);
								else -- ".."Vec"..varGlobal.acrescimoVeloc.."."..extencao
									if fileExistsInTTSFolder("Tela"..paginaAtual.."somTTS ".. 1 .."Vec"..varGlobal.acrescimoVeloc.."."..varGlobal.extencao) then
										timer.performWithDelay(16,function()rodarAudiosParagrafosOffline() end,1);
									else
										timer.performWithDelay(16,function()rodarAudiosParagrafos() end,1);
									end
								end
							else
								if type(paginaAtual) == "number" and paginaAtual < telas.numeroTotal.Todas then
									rodarProximaPaginaTTS(telas);
								elseif type(paginaAtual) == "string" then
									controladorSons = controladorSons
									timer.performWithDelay(16,function()rodarAudiosParagrafos() end,1);
								end
							end
						end

						botaoplayTTS.isVisible = false;
						botaoPause.isVisible = true;
						return true;
					end
				end
				
				if clicouAvancar == false then
					if controladorSons >= #nomesArquivosParagrafos and type(paginaAtual) == "number" and paginaAtual == telas.numeroTotal.Todas then
						local som = audio.loadSound("buttonSound.mp3")
						audio.play(som)
						audio.resume()
					else
						local som = audio.loadSound(varGlobal.botaoForwardAudioTTS)
						audio.play(som,{onComplete = avancar})
						timerClicouAvancar = timer.performWithDelay(3000,function()clicouAvancar = false;timerClicouAvancar = nil end,1)
						clicouVoltar = false
						clicouAvancar = true
						clicouBOTAOtts = true
					end
					return true
				else
					if controladorSons >= #nomesArquivosParagrafos and type(paginaAtual) == "number" and paginaAtual == telas.numeroTotal.Todas then
						local som = audio.loadSound("buttonSound.mp3")
						audio.play(som)
						audio.resume()
					else
						if timerClicouAvancar then
							timer.cancel(timerClicouAvancar)
							clicouAvancar = true
							timerClicouAvancar = timer.performWithDelay(3000,function()clicouAvancar = false;timerClicouAvancar = nil end,1)
						end
						clicouVoltar = false
						clicouAvancar = true
						clicouBOTAOtts = true
						avancar()
					end
					return true
				end
				return true
			end
		elseif e.phase == "moved" then
			--vibrator.vibrate(10)
			
		end
	end
	
	botaoForward = widget.newButton(
    {
        height = altura,
        width = largura,
        defaultFile = arquivoUpForward,
		overFile = arquivoDownForward,
        onEvent = avancarPlay,
		x = W,
		y = H
		
    })
	botaoForward.selecionado = false
	botaoForward.anchorX = 1
	botaoForward.isVisible = false
	botaoForward.anchorY = 1
	varGlobal.GRUPOTTS:insert(botaoForward)
	botaoForward:addEventListener("tap",function() return true; end)
	botaoBackward = widget.newButton(
    {
        height = altura,
        width = largura,
        defaultFile = arquivoUpBackward,
		overFile = arquivoDownBackward,
        onEvent = voltarPlay,
		x = _x-W,
		y = H
		
    })
	botaoBackward.selecionado = false
	botaoBackward.anchorX = 0
	botaoBackward.isVisible = false
	botaoBackward.anchorY = 1
	botaoBackward:addEventListener("tap",function() return true; end)
	varGlobal.GRUPOTTS:insert(botaoBackward)
	
	
	local function mudarOrientacaoTTS()
		if system.orientation == "landscapeRight" then
			botao.rotation = 90
			botao.y = H
			botao.x = _x
			botaoPause.rotation = 90
			botaoPause.y = H--botaoPause.y = 0
			botaoPause.x = _x
			botaoplayTTS.rotation = 90
			botaoplayTTS.y = H--botaoPause.y = 0
			botaoplayTTS.x = _x
			botaoReiniciar.rotation = 90
			botaoReiniciar.y = 0
			botaoReiniciar.x = _x
			botaoBackward.rotation = 90
			botaoBackward.y = 0
			botaoBackward.x = 0
			botaoForward.rotation = 90
			botaoForward.y = H
			botaoForward.x = 0
		elseif system.orientation == "landscapeLeft" then
			botao.rotation = -90
			botao.y = _y
			botao.x = 0
			botaoPause.rotation = -90
			botaoPause.y = _y
			botaoPause.x = 0
			botaoplayTTS.rotation = -90
			botaoplayTTS.y = _y
			botaoplayTTS.x = 0
			botaoReiniciar.rotation = -90
			botaoReiniciar.y = _y+H
			botaoReiniciar.x = 0
			botaoBackward.rotation = -90
			botaoBackward.y = _y+H
			botaoBackward.x = W
			botaoForward.rotation = -90
			botaoForward.y = 0
			botaoForward.x = W
		elseif system.orientation == "portrait" then
			botao.rotation = 0
			botao.y = _y
			botao.x = _x
			botaoPause.rotation = 0
			botaoPause.y = _y
			botaoPause.x = _x--botaoPause.x = _x-W
			botaoplayTTS.rotation = 0
			botaoplayTTS.y = _y
			botaoplayTTS.x = _x--botaoPause.x = _x-W
			botaoReiniciar.rotation = 0
			botaoReiniciar.y = _y
			botaoReiniciar.x = _x-W
			botaoBackward.rotation = 0
			botaoBackward.y = H
			botaoBackward.x = _x-W
			botaoForward.rotation = 0
			botaoForward.y = H
			botaoForward.x = W
		end
	end
	Runtime:addEventListener("orientation",mudarOrientacaoTTS)
end
M.criarBotaoTTS = criarBotaoTTS
----------------------------------------------------------------------
--	COLOCAR INTERFACE BOTAO												--
--	Funcao responsavel por criar um botao 							--
--  de acordo com as opcoes desejadas e acoes pre-definidas			--
--  ATRIBUTOS: fundo,titulo,altura,comprimento,x,y,*posicao,*acao 	--
--  *Posicao: base, centro, topo 	  								--
--  *Acoes: iniciaCurso, iniciaPagina  								--
----------------------------------------------------------------------
local function criarBotaoIndice(atributos,telas)
	-- DEFINE ATRIBUTOS DEFAULT
	atributos.acao = "BotaoIndice"
	if atributos == nil then
		atributos = {}
		atributos.titulo = {}
	end 
	if atributos.arquivo == nil then 
		atributos.arquivo = "fundo-azul.png"
	end
	-- ACAO DO BOTAO
	local function handleButtonEvent( event )
		print("ACIONOU O BOTAO INDICE!!!")
		if event and event.target and event.target.selecionado == false  then
			event.target.selecionado = true
			media.pauseSound()
			audio.pause()
			pausarDespausarAnimacao("pausar")
			local som = audio.loadSound(atributos.somBotao)
			audio.play(som,{onComplete = despausarTudo})
			timer.performWithDelay(1000,function() event.target.selecionado = false end,1)
		else
			
			audio.stop()
			media.stopSound()
			pausarDespausarAnimacao("despausar")
			
			if event.phase == "began" then
				return true
			elseif ( "ended" == event.phase ) then
				print( "Botao pressionado: "..atributos.acao )
				timer.performWithDelay(1,function() verificaAcaoBotao("indice",telas,atributos.pagina) end,1)
				if GRUPOGERAL.grupoZoom then
					GRUPOGERAL.grupoZoom:removeSelf()
				end
				foiclicado = false
				return true
			end
		end
		return true
	end
	if atributos.titulo then
		if atributos.titulo.tamanho then
			TamanhoDaFonte = atributos.titulo.tamanho
		else
			TamanhoDaFonte = 40
		end
	end
	if W > H then
		TamaNhoBotao = W
	else
		TamaNhoBotao = H
	end
	local altura = 70
	local largura = 70
	if atributos.altura then
		altura =atributos.altura;
	end
	--PARAMETRO COMPRIMENTO
	if atributos.comprimento then
		largura =atributos.comprimento;
	end
	local botao = widget.newButton(
    {
        height = altura,
        width = largura,
        defaultFile = atributos.arquivo,
		overFile = atributos.fundoDown,
        label = "",
		fontSize = TamanhoDaFonte,
        onRelease = handleButtonEvent
		
    })
	botao.selecionado = false
	botao.anchorX = 0; botao.anchorY = 0
	botao.x = W/2-botao.width/2
	botao.y = H-botao.height
	botao.alpha = 0.8
	if atributos.posicaoY then
		if atributos.posicaoY == "topo" then
			botao.y = 0
		elseif atributos.posicaoY == "base" then
			botao.y = H-botao.height-20
		end
	end
	if atributos.posicaoX then
		if atributos.posicaoX == "esquerda" then
			botao.x = W/4-botao.width/3
		elseif atributos.posicaoX == "direita" then
			botao.x = 2*W/3-botao.width/3
		elseif atributos.posicaoX == "meio" then
			botao.x = display.contentCenterX-botao.width/2
		end
	end
	--Runtime:addEventListener("enterFrame",function()if paginaAtual == 1 or paginaAtual == 2 then botao.isVisible = false;else botao.isVisible = true;end;end)
    --PARAMETRO TITULO
	if atributos.titulo then
		botao:setLabel( atributos.titulo.texto )
	end
	--PARAMETRO FUNDO
	botao.setDefaultFile =atributos.arquivo
	botao.setOverFile =atributos.fundoDown
	--PARAMETRO ALTURA
	
	--POSICAO X, Y
	if(atributos.x) then
		botao.x = atributos.x;
	end
	if(atributos.y) then
		botao.y = atributos.y;
	end
	--POSICAO CENTRO
	if(atributos.posicao=='centro') then
		botao.x = display.contentCenterX
		botao.y = display.contentCenterY
	end
	--POSICAO TOPO
	if(atributos.posicao=='topo') then
		botao.x = (W/2)-225
	end
	--POSICAO BASE
	if(atributos.posicao=='base') then
		botao.x = (W/2)-225
		botao.y = H - (botao.height/2)
	end   
	if atributos.titulo then
		botao.fontSize = 40
	end
		local function girarTelaOrientacaoBotaoIndice()
			if system.orientation == "landscapeRight" then
				if system.getInfo( "platform" ) == "win32" then --win32
					botao.rotation = 0
					botao.y = W - botao.width*varGlobal.aumentoProp
					botao.x = botao.height*varGlobal.aumentoProp
					botao.xScale = varGlobal.aumentoProp
					botao.yScale = varGlobal.aumentoProp
					if atributos.posicaoY then
						if atributos.posicaoY == "topo" then
							botao.y = 0
						elseif atributos.posicaoY == "base" then
							botao.y = H-botao.height*varGlobal.aumentoProp-20
						end
					end
					if atributos.posicaoX then
						if atributos.posicaoX == "esquerda" then
							botao.x = W/4-(botao.width*varGlobal.aumentoProp)/2
						elseif atributos.posicaoX == "direita" then
							botao.x = 2*W/3-(botao.width*varGlobal.aumentoProp)/2
						elseif atributos.posicaoX == "meio" then
							botao.x = display.contentCenterX-botao.width*varGlobal.aumentoProp/2
						end
					end
					botao.tipo = "portrait"
					
					print("\n\nPORTRAIT\n\n")
				else
					botao.rotation = 90
					aux = botao.y
					botao.y = W - botao.width*varGlobal.aumentoProp
					botao.x = botao.height*varGlobal.aumentoProp
					botao.xScale = varGlobal.aumentoProp
					botao.yScale = varGlobal.aumentoProp
					if atributos.posicaoX then
						if atributos.posicaoX == "esquerda" then
							botao.y = H/4-(botao.width*varGlobal.aumentoProp)/2
						elseif atributos.posicaoX == "direita" then
							botao.y = 2*H/3-(botao.width*varGlobal.aumentoProp)/2
						elseif atributos.posicaoX == "meio" then
							botao.y = display.contentCenterY-botao.width*varGlobal.aumentoProp/2
						end
					end
					if atributos.posicaoY then
						if atributos.posicaoY == "topo" then
							botao.x = W
						elseif atributos.posicaoY == "base" then
							botao.x = botao.height*varGlobal.aumentoProp+10
						end
						
					end
					botao.tipo = "landscapeRight"
					print("\n\nLEFT\n\n")
				end
			elseif system.orientation == "landscapeLeft" then
				botao.rotation = 270
				botao.y = W- botao.width*varGlobal.aumentoProp/2
				botao.x = botao.y - botao.width*varGlobal.aumentoProp/2
				botao.xScale = varGlobal.aumentoProp
				botao.yScale = varGlobal.aumentoProp
				if atributos.posicaoX then
					if atributos.posicaoX == "direita" then
						botao.y = H/4+(botao.width*varGlobal.aumentoProp)/2
					elseif atributos.posicaoX == "esquerda" then
						botao.y = 3*H/4+(botao.width*varGlobal.aumentoProp)/2
					elseif atributos.posicaoX == "meio" then
						botao.y = display.contentCenterY+botao.width*varGlobal.aumentoProp/2
					end
				end
				if atributos.posicaoY then
					if atributos.posicaoY == "topo" then
						botao.x = 0
					elseif atributos.posicaoY == "base" then
						--botao.x = botao.height/2+10
						botao.x = W-botao.height*varGlobal.aumentoProp - 10
					end
					
				end
				botao.tipo = "landscapeLeft"
				print("\n\nRIGHT\n\n")
			elseif system.orientation == "portrait" then
				botao.rotation = 0
				botao.x = W/2-botao.width/2
				botao.y = H - botao.height
				botao.xScale = 1
				botao.yScale = 1
				if atributos.posicaoY then
					if atributos.posicaoY == "topo" then
						botao.y = 0
					elseif atributos.posicaoY == "base" then
						botao.y = H-botao.height-20
					end
				end
				if atributos.posicaoX then
					if atributos.posicaoX == "esquerda" then
						botao.x = W/4-botao.width/2
					elseif atributos.posicaoX == "direita" then
						botao.x = 2*W/3-botao.width/2
					elseif atributos.posicaoX == "meio" then
						botao.x = display.contentCenterX-botao.width/2
					end
				end
				botao.tipo = "portrait"
				
				print("\n\nPORTRAIT\n\n")
			elseif system.orientation == "portraitUpsideDown" then
				--botao.xScale = 1
				--botao.yScale = 1
				botao.tipo = "portraitUpsideDown"
			end
			local opa = display.newGroup()
			opa:insert(botao)
			botao:addEventListener("tap",function() return true; end)
		end
		botao.pagina = atributos.pagina
		if travarOrientacaoLado == true then
			system.orientation = "landscapeRight"-- deletar!!!!!!!!!!!!!!!!!!!!!!!!!
			girarTelaOrientacaoBotaoIndice()-- deletar!!!!!!!!!!!!!!!!!!!!!!!!!
		else
			Runtime:addEventListener("orientation",girarTelaOrientacaoBotaoIndice)-- arrumar!!!!!!!!!!!!!!!!!!!!!!!!!
		end
		botao:addEventListener("tap",function() return true; end)
		local function habilitaDesabilitaMenu()
			if toqueHabilitado == false or paginaAtual == botao.pagina or varGlobal.paginaComMenu == false then
				botao.isVisible = false
				botao.isHitTestable = false
			elseif toqueHabilitado == true and varGlobal.paginaComMenu == true then
				botao.isVisible = true
				botao.isHitTestable = false
			end
		end
		Runtime:addEventListener("enterFrame",habilitaDesabilitaMenu)
	return botao
end
M.criarBotaoIndice = criarBotaoIndice

-- MOVER A TELA E SLIDE DE TELA ------------------------
 -- MOVER A TELA ----------------------------------------
local function ativarMoverTela(telas,pagina)
	--[[if  system.getInfo( "platform" ) == "win32" then
					local telaMovedora = display.newRect(0,0,0,0)
					telaMovedora.width = W;telaMovedora.height = 5*H
					telaMovedora.x = W/2;telaMovedora.y = H/2
					telaMovedora:setFillColor(1,0,0)
					telaMovedora.alpha = 0; telaMovedora.isHitTestable = true
					GRUPOGERAL:insert(telaMovedora)
					function MoverATela(e)
						VetorBotoesBarra.texto1.isVisible = false
						VetorBotoesBarra.texto2.isVisible = false
						VetorBotoesBarra.texto3.isVisible = false
						VetorBotoesBarra.texto4.isVisible = false
						--print("\nlimite = "..varGlobal.limiteTela.."\n")
						if e.phase == "began" then
							toqueY = e.y
							targetY = e.target.y
							if e.target.som1 then
								targetY2 = e.target.som1.y
							end
						end
						if e.phase == "moved" then
							toqueHabilitado = false
							e.target.y = e.y - toqueY + targetY
							if e.target.y > 0 then
								e.target.y = 0
							end
							if e.target.y < -varGlobal.limiteTela +750  then
								e.target.y = -varGlobal.limiteTela +750
							end
							if e.target.som1 then
								--print(e.target.som1.y)
								--print(e.target.som1.y)
								--print(e.target.som1.y)
								e.target.som1.y = -e.y + (toqueY + targetY2)
								e.target.som2.y = -e.y + (toqueY + targetY2)
								if e.target.som1.y < 0 then
									e.target.som1.y = 0
									e.target.som2.y = 0
								end
								if e.target.som1.y > varGlobal.limiteTela - 750 then
									e.target.som1.y = varGlobal.limiteTela - 750
									e.target.som2.y = varGlobal.limiteTela - 750
								end
							end
						end
						if e.phase == "ended" then
							toqueHabilitado = true
						end
						return true
					end
				GRUPOGERAL:addEventListener("touch",MoverATela)
	]]
	--else
					local telaMovedora = display.newRect(0,0,0,0)
					telaMovedora.width = W;telaMovedora.height = 5*H
					telaMovedora.x = W/2;telaMovedora.y = H/2
					telaMovedora:setFillColor(1,0,0)
					telaMovedora.alpha = 0; telaMovedora.isHitTestable = true
					GRUPOGERAL:insert(telaMovedora)
					function MoverATela(e)
						varGlobal.VetorBotoesBarra.numeroSprite.isVisible = false
						varGlobal.VetorBotoesBarra.retangulo.isVisible = false
						--print("\nlimite = "..varGlobal.limiteTela.."\n")
						if e.phase == "began" then
							if GRUPOGERAL.tipo == "landscapeLeft" or GRUPOGERAL.tipo == "landscapeRight" then
								toqueY = e.x
								targetY = e.target.x
							else
								toqueY = e.y
								targetY = e.target.y
							end
						end
						if e.phase == "moved" then
							toqueHabilitado = false
							if GRUPOGERAL.tipo == "landscapeLeft" then
								if toqueY then
									e.target.x = e.x - toqueY + targetY
									if e.target.x > 0 then
										e.target.x = 0
									end
									if e.target.x < W-varGlobal.limiteTela*varGlobal.aumentoProp then
										e.target.x = W-varGlobal.limiteTela*varGlobal.aumentoProp
									end
								end
							elseif GRUPOGERAL.tipo == "landscapeRight" then
								if toqueY then
									e.target.x = e.x - toqueY + targetY
									if e.target.x < 720 then
										e.target.x = 720
									end
									if e.target.x > varGlobal.limiteTela*varGlobal.aumentoProp then
										e.target.x = varGlobal.limiteTela*varGlobal.aumentoProp
									end
								end
							else
								if toqueY then
									e.target.y = e.y - toqueY + targetY
									if e.target.y > 0 then
										e.target.y = 0
									end
									local numero = 1280
									if system.getInfo("platform") == "win32" then
										numero = varGlobal.numeroWin
									end
									if e.target.y < -varGlobal.limiteTela +numero then
										e.target.y = -varGlobal.limiteTela +numero
									end
								end
							end
						end
						if e.phase == "ended" then
							if system.orientation == "portrait" then
								GRUPOGERAL.YPagina[paginaAtual] = GRUPOGERAL.y
							elseif system.orientation == "landscapeLeft" then
								GRUPOGERAL.YPagina[paginaAtual] = (-1)*math.abs(GRUPOGERAL.x/1.5)
							elseif system.orientation == "landscapeRight" then
								GRUPOGERAL.YPagina[paginaAtual] = (-1)*math.abs(GRUPOGERAL.x/1.5 - W/1.5)
							end
							toqueHabilitado = true
							if system.orientation == "portrait" then
								GRUPOGERAL.YPagina[paginaAtual] = GRUPOGERAL.y
							elseif system.orientation == "landscapeLeft" then
								GRUPOGERAL.YPagina[paginaAtual] = (-1)*math.abs(GRUPOGERAL.x/1.5)
							elseif system.orientation == "landscapeRight" then
								GRUPOGERAL.YPagina[paginaAtual] = (-1)*math.abs(GRUPOGERAL.x/1.5 - W/1.5)
							end
						end
						return true
					end
				GRUPOGERAL:addEventListener("touch",MoverATela)
				
				-- CRIOU O ZOOM ESPECIAL --
				print(telas)
				print(pagina)
				print(telas[pagina])
				--[[if telas[pagina] and telas[pagina].imagem and not (telas[pagina].texto or telas[pagina].textos or telas[pagina].imagens or telas[pagina].imagemTexto or telas[pagina].imagemTextos or telas[pagina].exercicio or telas[pagina].exercicios or telas[pagina].separador or telas[pagina].separadores or telas[pagina].botao or telas[pagina].botoes or telas[pagina].animacao or telas[pagina].animacoes or telas[pagina].video or telas[pagina].videos or telas[pagina].som or telas[pagina].sons) then
					GRUPOGERAL.touch = touch
					GRUPOGERAL.telas = telas
					GRUPOGERAL:addEventListener("touch")
				else
					--GRUPOGERAL:removeEventListener("touch")
				end]]
		
		---------------------------------------------------------------------------	
		-- SLIDE DE TELA ----------------------------------------------------------	
		---------------------------------------------------------------------------		
		local botao = display.newRect(0,0,W+H,H+W)
		botao:setFillColor(1,0,0)
		botao.anchorX = 0.5; botao.anchorY = 0.5
		botao.x = display.contentCenterX
		botao.y = display.contentCenterY
		botao.alpha = 0
		botao.isHitTestable = true
		local function funcaoSlide(e)
			local Y = 0
			local X = 0
			local aux = 1
			
			if system.orientation == "portraitUpsideDown" then
				aux = -1
			end
			if system.orientation == "landscapeLeft" then
				aux = -1
			end
			if system.orientation == "portraitUpsideDown" or system.orientation == "portrait" then
				if e.phase == "began" then
					Y = e.y
					X = e.x
				elseif e.phase == "ended" then
					if e.x < X-(150*aux) then
							if(paginaAtual<=#telas and paginaAtual>1 and toqueHabilitado) then
								paginaAtual=paginaAtual-1
								print("voltou para: "..paginaAtual.." de "..#telas)
								criarCursoAux(telas, paginaAtual)
								if GRUPOGERAL.grupoZoom then
									GRUPOGERAL.grupoZoom:removeSelf()
								end

								girarTelaOrientacao(GRUPOGERAL)
							end
					elseif e.x > X + (150*aux) then
							if(paginaAtual<#telas and toqueHabilitado) then
								paginaAtual=paginaAtual+1
								print("foi para: "..paginaAtual.." de "..#telas)
								criarCursoAux(telas, paginaAtual)
								if GRUPOGERAL.grupoZoom then
									GRUPOGERAL.grupoZoom:removeSelf()
								end

								girarTelaOrientacao(GRUPOGERAL)
							end
					end
				end
			else
				if e.phase == "began" then
					Y = e.y
					X = e.x
				elseif e.phase == "ended" then
					
					if e.y < Y-(150*aux) then
							if(paginaAtual<=#telas and paginaAtual>1 and toqueHabilitado) then
								paginaAtual=paginaAtual-1
								print("voltou para: "..paginaAtual.." de "..#telas)
								criarCursoAux(telas, paginaAtual)
								if GRUPOGERAL.grupoZoom then
									GRUPOGERAL.grupoZoom:removeSelf()
								end

								girarTelaOrientacao(GRUPOGERAL)
							end
					elseif e.y > Y + (150*aux) then
							if(paginaAtual<#telas and toqueHabilitado) then
								paginaAtual=paginaAtual+1
								print("foi para: "..paginaAtual.." de "..#telas)
								criarCursoAux(telas, paginaAtual)
								if GRUPOGERAL.grupoZoom then
									GRUPOGERAL.grupoZoom:removeSelf()
								end

								girarTelaOrientacao(GRUPOGERAL)
							end
					end
				end
			end
		end
		--botao:addEventListener("touch",funcaoSlide)
	--end	
end
M.ativarMoverTela = ativarMoverTela

local function escolherOrientacao(atributo)
	if atributo then
		if atributo == "deitado" then
			travarOrientacaoLado = true
		elseif atributo == "padrao" then
			travarOrientacaoLado = false
		end
	end
end
M.escolherOrientacao = escolherOrientacao

-- CRIAR BARRA DE PÁGINAS ---------------------------------------------

local clicado = false
local function criarBarraDePaginas(telas,numeroTotal)
	local slider =  require("slider")
	local json = require("json")
	local filenameUI = system.pathForFile( "UI/UI elements.json", system.ResourceDirectory )
	local UI, pos, msg = json.decodeFile( filenameUI )
	if not UI then
		print( "Decode failed at criarBarraDePaginas at "..tostring(pos)..": "..tostring(msg) )
		UI = {}
	else
		print( "File successfully decoded!" )
		UI = UI.Tela.selection_bar
	end
	local numeroTelasAnteriores = telas.numeroTotal.PaginasPre+telas.numeroTotal.Indices
	varGlobal.VetorBotoesBarra = {}
	if UI and UI.number then
		if UI.number.rect.shape then
			varGlobal.VetorBotoesBarra.retangulo = display.newRoundedRect(20,20,20,20,10)
			if UI.number.rect.fillColor then
				varGlobal.VetorBotoesBarra.retangulo:setFillColor(UI.number.rect.fillColor[1]/255,UI.number.rect.fillColor[2]/255,UI.number.rect.fillColor[3]/255)
			else
				varGlobal.VetorBotoesBarra.retangulo:setFillColor(46/255,171/255,200/255)
			end
		elseif UI.number.rect.file then
			varGlobal.VetorBotoesBarra.retangulo = display.newImageRect(UI.number.rect.file,20,20,20,20,10)
		else
			varGlobal.VetorBotoesBarra.retangulo = display.newRoundedRect(20,20,20,20,10)
		end
		
	
		local fonte = UI.number.label.font or "Fontes/arial.ttf"
		local size = UI.number.label.size or 50
		local color = {255,255,255}
		if UI.number.label.fillColor then
			color = {UI.number.label.fillColor[1]/255,UI.number.label.fillColor[2]/255,UI.number.label.fillColor[3]/255}
		end
		local x = UI.number.label.x or 100
		local y = UI.number.label.y or 100
		varGlobal.VetorBotoesBarra.numeroSprite = display.newText("",0,0,fonte,size)
		
		varGlobal.VetorBotoesBarra.numeroSprite:setFillColor(color[1],color[2],color[3])
		varGlobal.VetorBotoesBarra.numeroSprite.y = y
		varGlobal.VetorBotoesBarra.numeroSprite.x = x
	else
		varGlobal.VetorBotoesBarra.retangulo = display.newRoundedRect(20,20,20,20,10)
		varGlobal.VetorBotoesBarra.retangulo:setFillColor(46/255,171/255,200/255)
		varGlobal.VetorBotoesBarra.numeroSprite = display.newText("",0,0,"Fontes/arial.ttf",50)
		varGlobal.VetorBotoesBarra.numeroSprite:setFillColor(1,1,1)
		varGlobal.VetorBotoesBarra.numeroSprite.y = 100
		varGlobal.VetorBotoesBarra.numeroSprite.x = 100
	end
	varGlobal.VetorBotoesBarra.numeroSprite.isVisible	= false
	
	
	
	varGlobal.VetorBotoesBarra.retangulo.width = varGlobal.VetorBotoesBarra.numeroSprite.width
	varGlobal.VetorBotoesBarra.retangulo.height = varGlobal.VetorBotoesBarra.numeroSprite.height
	varGlobal.VetorBotoesBarra.retangulo.anchorX = varGlobal.VetorBotoesBarra.numeroSprite.anchorX
	varGlobal.VetorBotoesBarra.retangulo.anchorY = varGlobal.VetorBotoesBarra.numeroSprite.anchorY
	varGlobal.VetorBotoesBarra.retangulo.isVisible = false
	local vars = {}
	local function mostrarEscolha(e)
		if e.phase == "began" then

			system.vibrate()
			--audio.stop()
			vars.somPagina = audio.loadSound("audioTTS_pagina.mp3")
			vars.duracaoAudio = audio.getDuration( vars.somPagina )
			vars.MAXIMA = vars.duracaoAudio-900
			vars.paginaAtualLocal = vetorVoltar[#vetorVoltar] + varGlobal.contagemInicialPaginas -varGlobal.numeroTotal.PaginasPre-varGlobal.numeroTotal.Indices -1
			local function falarPagina()
				local Func = {}
				function Func.forAuxiliar(i,limite)
					local char = string.sub(vars.paginaAtualLocal,i,i)
					print(char)
					local som = audio.loadSound(char..".mp3")
						if som then
						vars.duracaoAudio = audio.getDuration( som  )
						vars.MAXIMA = vars.duracaoAudio-900
						local function onComplete()
							Func.rodarLoopFor(i+1,limite)
						end
						local options =
						{
							duration = vars.MAXIMA,
							onComplete = onComplete
						}
						audio.seek( 110, som )
				
						audio.play(som,options)
					end
				end
				function Func.rodarLoopFor(i,limite)
					if i<=limite then
						Func.forAuxiliar(i,limite)
					end
				end
				Func.rodarLoopFor(1,string.len(vars.paginaAtualLocal))
			end
			local options =
			{
				duration = vars.MAXIMA,
				fadein = 110,
				onComplete = falarPagina
			}
			timer.performWithDelay(10,function()audio.play(vars.somPagina,options)end,1)
			e.target.clicouBegan = true
		elseif e.phase == "moved" then
			
			if e.target.clicouBegan == true then
				audio.stop()
					if varGlobal.VetorBotoesBarra.timer then
						timer.cancel(varGlobal.VetorBotoesBarra.timer)
						varGlobal.VetorBotoesBarra.timer = nil
					end
				
					varGlobal.VetorBotoesBarra.numeroSprite.x = e.target.X + varGlobal.VetorBotoesBarra.meuSlider.x
					varGlobal.VetorBotoesBarra.numeroSprite.y = e.target.Y + varGlobal.VetorBotoesBarra.meuSlider.y - e.target.sliderHeight - 10
					varGlobal.VetorBotoesBarra.numeroSprite.isVisible = true
					varGlobal.VetorBotoesBarra.retangulo.x = e.target.X + varGlobal.VetorBotoesBarra.meuSlider.x
					varGlobal.VetorBotoesBarra.retangulo.y = e.target.Y + varGlobal.VetorBotoesBarra.meuSlider.y - e.target.sliderHeight - 10
					varGlobal.VetorBotoesBarra.retangulo.isVisible = true
					varGlobal.VetorBotoesBarra.retangulo.width = varGlobal.VetorBotoesBarra.numeroSprite.width + 4
					local textoNumero = math.floor(e.target.choice) - numeroTotal.paginasAntesZero
					varGlobal.VetorBotoesBarra.numeroSprite.text = textoNumero
					if tonumber(textoNumero) < 0 then--auxFuncs.verificarNumeroPaginaRomanosHistorico(Func.paginaReal,telas.numeroTotal.paginasAntesZero)
						textoNumero = (textoNumero + numeroTotal.paginasAntesZero+1)
						varGlobal.VetorBotoesBarra.numeroSprite.text = tostring(auxFuncs.ToRomanNumerals(tonumber(textoNumero)))
					elseif e.target.choice == e.target.value then
						varGlobal.VetorBotoesBarra.numeroSprite.text = textoNumero -1
					end
					local Func = {}
					function Func.forAuxiliar(i,limite)
						local char = string.sub(varGlobal.VetorBotoesBarra.numeroSprite.text,i,i)
						print(char)
						local som = audio.loadSound(char..".mp3")
						if som then
							vars.duracaoAudio = audio.getDuration( som  )
							vars.MAXIMA = vars.duracaoAudio-900
							local function onComplete()
								Func.rodarLoopFor(i+1,limite)
							end
							local options =
							{
								duration = vars.MAXIMA,
								onComplete = onComplete
							}
							audio.seek( 110, som )
						
							audio.play(som,options)
						end
					end
					function Func.rodarLoopFor(i,limite)
						if i<=limite then
							Func.forAuxiliar(i,limite)
						end
					end
					if varGlobal.VetorBotoesBarra.numeroSprite then
						varGlobal.VetorBotoesBarra.timer = timer.performWithDelay(200,function()Func.rodarLoopFor(1,string.len(varGlobal.VetorBotoesBarra.numeroSprite.text))end,1)
					end
			else
				--audio.pause()
				--local som = audio.loadSound("audioTTS_barraDePaginas.mp3",{onComplete = function()audio.resume()end})
				--audio.play(som)
			end
		elseif e.phase == "ended" then
			if e.target.clicouBegan == true then
				audio.stop()
				e.target.clicouBegan = false
				varGlobal.VetorBotoesBarra.numeroSprite.isVisible = false
				barraclicada = false
				print(e.target.choice,varGlobal.VetorBotoesBarra.numeroSprite.text)
				GRUPOGERAL.subPagina = nil
				telas.pagina= tonumber(e.target.choice) +1
				if telas.pagina > telas.numeroTotal.PaginasPre+telas.numeroTotal.Indices+telas.numeroTotal.Paginas then
					telas.pagina = telas.numeroTotal.PaginasPre+telas.numeroTotal.Indices+telas.numeroTotal.Paginas
				end
				e.target.paginaEscolhida = telas.pagina
				criarCursoAux(telas, telas.pagina)
				display.getCurrentStage():setFocus( e.target,nil )
				display.getCurrentStage():setFocus(nil)
				toqueHabilitado = true
			end
		end
		return true
	end
	local sliderFillColor = {192/255,0,0,1}
	local barFillColor = {243/255,129/255,33/255,1}
	local sliderStrokeColor = {0/255,0/255,0/255,1} 
	local sliderStrokeWidth = 6
	local barStrokeWidth = 4
	local sliderShape = "circle"
	local sliderRadius = 20
	local sliderWidth = 19
	local barHeight = 10
	local barWidth = 500
	local sliderHeight = 80
	local SliderX = W/2
	local SliderY = 1130
	if UI and UI.bar then
		if UI.bar.fillColor then
			barFillColor = {UI.bar.fillColor[1]/255,UI.bar.fillColor[2]/255,UI.bar.fillColor[3]/255}
		else 
			barFillColor = {243/255,129/255,33/255,1} 
		end
		barStrokeWidth = UI.bar.strokeWidth or 4
		barHeight = UI.bar.height or 10
		barWidth = UI.bar.width or 500
	end
	if UI and UI.slider then
		if UI.slider.fillColor then
			sliderFillColor = {UI.slider.fillColor[1]/255,UI.slider.fillColor[2]/255,UI.slider.fillColor[3]/255}
		else 
			sliderFillColor = {192/255,0/255,0/255,1} 
		end
		if UI.slider.strokeColor then
			sliderStrokeColor = {UI.slider.strokeColor[1]/255,UI.slider.strokeColor[2]/255,UI.slider.strokeColor[3]/255}
		else 
			sliderStrokeColor = {0/255,0/255,0/255,1} 
		end
		sliderStrokeColor = {UI.slider.strokeColor[1],UI.slider.strokeColor[2],UI.slider.strokeColor[3]} or {0,0,0,1}
		sliderStrokeWidth = UI.slider.strokeWidth or 6
		sliderShape = UI.slider.shape or "circle"
		sliderRadius = UI.slider.radius or 20
		sliderWidth = UI.slider.width or 19
		sliderHeight = UI.slider.height or 80
		if UI.slider.x then
			if tostring(UI.slider.x) == "center" then 
				SliderX = W/2
			else
				SliderX = UI.slider.x or W/2
			end
		end
		SliderY = UI.slider.y or 1130
	end
	varGlobal.VetorBotoesBarra.meuSlider = slider.newSlider(
		{
			sliderFillColor = sliderFillColor,
			barFillColor = barFillColor,
			sliderStrokeWidth = sliderStrokeWidth,
			sliderStrokeColor = sliderStrokeColor,
			barStrokeWidth = barStrokeWidth,
			sliderShape = sliderShape,
			radius = sliderRadius,
			sliderWidth = sliderWidth,
			barHeight = barHeight,
			barWidth = barWidth,
			sliderHeight = sliderHeight,
			onEvent = mostrarEscolha,
			value = telas.numeroTotal.PaginasPre+telas.numeroTotal.Indices+telas.numeroTotal.Paginas,
			initialPosition = paginaAtual
		}
	)
	varGlobal.VetorBotoesBarra.meuSlider:addEventListener("tap",function() return true end)
	varGlobal.VetorBotoesBarra.meuSlider.paginaEscolhida = paginaAtual
	varGlobal.VetorBotoesBarra.meuSlider.movedor.paginaEscolhida = paginaAtual
	varGlobal.VetorBotoesBarra.meuSlider.barra.paginaEscolhida = paginaAtual
	varGlobal.VetorBotoesBarra.meuSlider.clicouBegan = false
	varGlobal.VetorBotoesBarra.meuSlider.movedor.clicouBegan = false
	varGlobal.VetorBotoesBarra.meuSlider.barra.clicouBegan = false
	varGlobal.VetorBotoesBarra.meuSlider.x = SliderX
	varGlobal.VetorBotoesBarra.meuSlider.y = SliderY
	varGlobal.GRUPOBotoes:insert(varGlobal.VetorBotoesBarra.meuSlider)
	
	
	local function EsconderBarra()
		if toqueHabilitado == false or varGlobal.paginaComMenu == false then
			varGlobal.VetorBotoesBarra.meuSlider.isVisible = false
		else
			varGlobal.VetorBotoesBarra.meuSlider.isVisible = true
		end
	end
	Runtime:addEventListener("enterFrame",EsconderBarra)
end
M.criarBarraDePaginas = criarBarraDePaginas
local function criarBarraDePaginasOld(telas,numeroTotal)
	local ajuste = 160+120
	local ajusteLetra = 80
	local numeroTelas = numeroTotal.Todas
	local numeroTelasAnteriores = telas.numeroTotal.PaginasPre+telas.numeroTotal.Indices
	VetorBotoesBarra = {}
	comprimetoTotal = W-60-ajuste
	--print("WARNING: "..comprimetoTotal/numeroTelas)
	comprimetoCadaBotao = comprimetoTotal/numeroTelas
	
		 
	VetorBotoesBarra.retangulo = display.newRoundedRect(20,20,20,20,10)
	VetorBotoesBarra.retangulo:setFillColor(46/255,171/255,200/255)
	 
	VetorBotoesBarra.numeroSprite = display.newText("",0,0,"paolaAccent.ttf",50)
	VetorBotoesBarra.numeroSprite:setFillColor(1,1,1)
	VetorBotoesBarra.numeroSprite.isVisible	= false
	
	VetorBotoesBarra.numeroSprite.y = 100
	VetorBotoesBarra.numeroSprite.x = 100
	
	VetorBotoesBarra.retangulo.width = VetorBotoesBarra.numeroSprite.width
	VetorBotoesBarra.retangulo.height = VetorBotoesBarra.numeroSprite.height
	VetorBotoesBarra.retangulo.anchorX = VetorBotoesBarra.numeroSprite.anchorX
	VetorBotoesBarra.retangulo.anchorY = VetorBotoesBarra.numeroSprite.anchorY
	VetorBotoesBarra.retangulo.isVisible = false
	
	for i=1,numeroTelas do
		VetorBotoesBarra[i] = display.newRect(0,0,0,0)
		VetorBotoesBarra[i].anchorX,VetorBotoesBarra[i].anchorY = 1,1
		VetorBotoesBarra[i].width,VetorBotoesBarra[i].height = comprimetoCadaBotao,50
		VetorBotoesBarra[i].x,VetorBotoesBarra[i].y = 30+(comprimetoCadaBotao*i)+ajuste/2,1280-(1280/20)-5
		VetorBotoesBarra[i]:setFillColor(1,1,1)
		VetorBotoesBarra[i].strokeWidth = 1
		VetorBotoesBarra[i]:setStrokeColor( .5, .5, .5 )
		VetorBotoesBarra[i].alpha = .5
		VetorBotoesBarra[i].i = i
		if system.orientation == "landscapeRight" then
			comprimetoTotal = H-60-ajuste
			comprimetoCadaBotao = comprimetoTotal/numeroTelas
			VetorBotoesBarra[i].anchorX,VetorBotoesBarra[i].anchorY = 0,0
			VetorBotoesBarra[i].height,VetorBotoesBarra[i].width = comprimetoCadaBotao,50
			VetorBotoesBarra[i].y,VetorBotoesBarra[i].x = 30+(comprimetoCadaBotao*i)+ajuste/2,5 + (H/20)
		end
		--print("BARRA "..i-telasAnteriores+1+contagemInicialPaginas)
		print(telas.numeroTotal.PaginasPre,telas.numeroTotal.Indices)

		local function escolherTela(event)
			
			if event.phase == "began" then
				--display.getCurrentStage():setFocus( event.target, event.id )
				
				--clicado = true
				-- MOSTRAR BARRA SELECIONADA -------------------------
				for i=1,numeroTelas do
					if event.target.i ~= i then
						VetorBotoesBarra[i]:setFillColor(1,1,1)
					end
				end
				VetorBotoesBarra[event.target.i]:setFillColor(0,.4,.5)
				------------------------------------------------------

				barraclicada = true
			elseif event.phase == "moved" then
				
				-- MOSTRAR BARRA SELECIONADA -------------------------
				for i=1,numeroTelas do
					if event.target.i ~= i then
						VetorBotoesBarra[i]:setFillColor(1,1,1)
					end
				end
				VetorBotoesBarra[event.target.i]:setFillColor(0,.4,.5)
				------------------------------------------------------
				
				local algs = {}
				--totalPaginasAnteriores = verificarNumeroPaginasPre + verificarNumeroIndices + 1
				local textoNumero
				textoNumero = tostring(event.target.i-numeroTotal.PaginasPre-numeroTotal.Indices-1+ varGlobal.contagemInicialPaginas)
				if tonumber(textoNumero) < 0 then
					textoNumero = tostring(auxFuncs.ToRomanNumerals(tonumber(textoNumero)*-1))
				end
				local function mudarMostrarNumero(event)
					VetorBotoesBarra.numeroSprite.isVisible = true
					VetorBotoesBarra.retangulo.isVisible = true
					VetorBotoesBarra.numeroSprite.text = textoNumero
					VetorBotoesBarra.retangulo.width = VetorBotoesBarra.numeroSprite.width
				end
				if event.target.i == 1 then
					display.getCurrentStage():setFocus( event.target )
					--print("WARNING: "..paginaAtual)
				end
				if event.target.i == #VetorBotoesBarra then
					display.getCurrentStage():setFocus( event.target )
				end
				
				mudarMostrarNumero(event)
				
				if system.orientation == "portrait" then
					if (event.x > VetorBotoesBarra[1].x) and (event.x < VetorBotoesBarra[#VetorBotoesBarra].x - VetorBotoesBarra[#VetorBotoesBarra].width/2)  then
						display.getCurrentStage():setFocus(nil )
					end
					VetorBotoesBarra.numeroSprite.x = event.target.x - comprimetoCadaBotao/2
					VetorBotoesBarra.numeroSprite.y = event.target.y - 80
					VetorBotoesBarra.retangulo.x= VetorBotoesBarra.numeroSprite.x
					VetorBotoesBarra.retangulo.y= VetorBotoesBarra.numeroSprite.y
					
				elseif system.orientation == "landscapeRight" then
					if (event.y > VetorBotoesBarra[1].y ) and (event.y < VetorBotoesBarra[#VetorBotoesBarra].y - VetorBotoesBarra[#VetorBotoesBarra].height)  then
						display.getCurrentStage():setFocus(nil )
					end
					
					VetorBotoesBarra.numeroSprite.x = event.target.x + 80
					VetorBotoesBarra.numeroSprite.y = event.target.y - comprimetoCadaBotao/2
					VetorBotoesBarra.retangulo.x= VetorBotoesBarra.numeroSprite.x
					VetorBotoesBarra.retangulo.y= VetorBotoesBarra.numeroSprite.y
					
				elseif system.orientation == "landscapeLeft" then
					if (event.y < VetorBotoesBarra[1].y) and (event.y > VetorBotoesBarra[#VetorBotoesBarra].y + VetorBotoesBarra[#VetorBotoesBarra].height)  then
						display.getCurrentStage():setFocus(nil )
					end
					
					VetorBotoesBarra.numeroSprite.x = event.target.x - 80
					VetorBotoesBarra.numeroSprite.y = event.target.y + comprimetoCadaBotao/2
					VetorBotoesBarra.retangulo.x= VetorBotoesBarra.numeroSprite.x
					VetorBotoesBarra.retangulo.y= VetorBotoesBarra.numeroSprite.y

				end	
			elseif event.phase == "ended" then
				VetorBotoesBarra.numeroSprite.isVisible = false
				VetorBotoesBarra.retangulo.isVisible = false
				if barraclicada == true then
					if system.orientation == "portrait" then
						if (event.x < event.target.x or event.x > (event.target.x + event.target.width)) then
							display.getCurrentStage():setFocus( event.target, nil )
						end
					elseif system.orientation == "landscapeRight" then
						if event.y < event.target.y or event.y > (event.target.y + event.target.height) then
							display.getCurrentStage():setFocus( event.target, nil )
						end
					elseif system.orientation == "landscapeLeft" then
						if event.y > event.target.y or event.y < (event.target.y - event.target.height) then
							display.getCurrentStage():setFocus( event.target, nil )
						end
					end
					GRUPOGERAL.subPagina = nil
					paginaAtual= event.target.i
					criarCursoAux(telas, paginaAtual)
					display.getCurrentStage():setFocus( event.target,nil )
					display.getCurrentStage():setFocus(nil )
					toqueHabilitado = true
				end
				barraclicada = false
			end
			return true
		end
		VetorBotoesBarra[i]:addEventListener("touch",escolherTela)
		VetorBotoesBarra[i]:addEventListener("tap",function() return true end)
		
		varGlobal.GRUPOBotoes:insert(VetorBotoesBarra[i])
	end

	local function mudarOrientacaoBarra()
		VetorBotoesBarra.numeroSprite.isVisible = false
		VetorBotoesBarra.retangulo.isVisible = false
		if system.orientation == "landscapeRight" then -- rotate Left
			comprimetoTotal = H-60-ajuste
			comprimetoCadaBotao = comprimetoTotal/numeroTelas
			for i=1,numeroTelas do
				VetorBotoesBarra[i].anchorX,VetorBotoesBarra[i].anchorY = 0,1
				VetorBotoesBarra[i].height,VetorBotoesBarra[i].width = comprimetoCadaBotao,50
				VetorBotoesBarra[i].y,VetorBotoesBarra[i].x = 30+(comprimetoCadaBotao*i)+ajuste/2,5 + (H/30)
			end
			VetorBotoesBarra.numeroSprite.rotation = 90
			VetorBotoesBarra.retangulo.rotation = 90
		elseif system.orientation == "landscapeLeft" then -- rotate Right
			comprimetoTotal = H-60-ajuste
			comprimetoCadaBotao = comprimetoTotal/numeroTelas
			for i=1,numeroTelas do
				VetorBotoesBarra[i].anchorX,VetorBotoesBarra[i].anchorY = 1,0
				VetorBotoesBarra[i].height,VetorBotoesBarra[i].width = comprimetoCadaBotao,50
				VetorBotoesBarra[i].y,VetorBotoesBarra[i].x = H-30-(comprimetoCadaBotao*i)-ajuste/2,W-5 - (H/30)
			end
			VetorBotoesBarra.numeroSprite.rotation = -90
			VetorBotoesBarra.retangulo.rotation = -90
		elseif system.orientation == "portrait" then
			comprimetoTotal = W-60-ajuste
			comprimetoCadaBotao = comprimetoTotal/numeroTelas
			for i=1,numeroTelas do
				VetorBotoesBarra[i].anchorX,VetorBotoesBarra[i].anchorY = 1,1
				VetorBotoesBarra[i].width,VetorBotoesBarra[i].height = comprimetoCadaBotao,50
				VetorBotoesBarra[i].x,VetorBotoesBarra[i].y = 30+(comprimetoCadaBotao*i)+ajuste/2,H-(H/20)-5
			end
			VetorBotoesBarra.numeroSprite.rotation = 0
			VetorBotoesBarra.retangulo.rotation = 0
		end
	end
	
	local function EsconderBarra()
		for i=1,numeroTelas do
			if toqueHabilitado == false or varGlobal.paginaComMenu == false then
				VetorBotoesBarra[i].isVisible = false
			else
				VetorBotoesBarra[i].isVisible = true
			end
		end
		barraMostrada = display.newGroup()
	end
	
	Runtime:addEventListener("orientation",mudarOrientacaoBarra)
	Runtime:addEventListener("enterFrame",EsconderBarra)
end
M.criarBarraDePaginasOld = criarBarraDePaginasOld

-- INICIAR TELAS E PAGINAÇÃO -------------------------------------
local INTERFACEX;

function criarCurso(telas, pagina)
	ead.criarPaginacao(telas, pagina)
	ead.criarCursoAux(telas, pagina)
	Var.botaoConfigTTS = funcGlobal.colocarBotaoConfig({y=0},telas,varGlobal)
				--GRUPOGERAL:insert(Var.botaoConfigTTS)
	--ead.ativarMoverTela(telas, pagina)
	if varGlobal.temHistorico == true then
		timer.performWithDelay(30000,function()
									local conteudo = auxFuncs.lerTextoDoc("historico.txt")
									if conteudo and type(conteudo) == "string" then
										RegistrarHistorico("\n"..conteudo)
									end
									local parameters = {}
									local ID = system.getInfo( "deviceID" )
									parameters.body = "livro_id=" .. varGlobal.idLivro1 .. "&usuario_id=" .. varGlobal.idAluno1
									local URL = "https://omniscience42.com/EAudioBookDB/verificarPermissaoAcessoLivro.php"
									
									local function verificarLoginDuplo(event)
										if ( event.isError ) then 
										else
											local data2 = json.decode(event.response)
											if data2 and data2.result then
												if data2.login == "ON" and data2.ID ~= ID then 
													auxFuncs.deslogarEsair()
												end
											end
										end
										
									end
									--network.request(URL, "POST", verificarLoginDuplo,parameters) -- baixando base de dados completa
							
									
								 end,-1)
	end
end
M.criarCurso = criarCurso

-- EVENTOS DE SYSTEMA --
local function onSystemEvent( event )
    if event.type == "applicationExit" then
		--local conteudo = auxFuncs.lerTextoDoc("historico "..Login1 .. " " .. EmailLogin1 .. ".txt")
		--RegistrarHistorico("\n"..conteudo.."|fechou o livro|")
	end
	if event.type == "applicationSuspend" then
		if varGlobal.temHistorico == true then
			
			local subPagina = GRUPOGERAL.subPagina
			historicoLib.Criar_e_salvar_vetor_historico({
				tipoInteracao = "generica",
				pagina_livro = varGlobal.PagH,
				objeto_id = nil,
				acao = "suspender livro",
				tempo_aberto_pagina = auxFuncs.SecondsToClock(tonumber(varGlobal.tempoAbertoPaginaNumero))..".",
				tempo_aberto = auxFuncs.SecondsToClock(tonumber(varGlobal.tempoAbertoLivroNumero)),
				subPagina = subPagina,
				tela = {contagemDaPaginaHistorico = varGlobal.PagH}
			})
			
		end
	end
	if event.type == "applicationExit" then
		if varGlobal.temHistorico == true then
			
			local subPagina = GRUPOGERAL.subPagina
			historicoLib.Criar_e_salvar_vetor_historico({
				tipoInteracao = "generica",
				pagina_livro = varGlobal.PagH,
				objeto_id = nil,
				acao = "fechar livro",
				tempo_aberto_pagina = auxFuncs.SecondsToClock(tonumber(varGlobal.tempoAbertoPaginaNumero))..".",
				tempo_aberto = auxFuncs.SecondsToClock(tonumber(varGlobal.tempoAbertoLivroNumero)),
				subPagina = subPagina,
				tela = {contagemDaPaginaHistorico = varGlobal.PagH}
			})
			LimparTemporaryDirectory()
		end
	end
end
  
Runtime:addEventListener( "system", onSystemEvent )

local function eventoDeMouse(event)
	local function verificarLimites()
		if GRUPOGERAL.y > 0 then
			GRUPOGERAL.y = 0
		end
		if GRUPOGERAL.y < -varGlobal.limiteTela +1280  then
			GRUPOGERAL.y = -varGlobal.limiteTela +1280
		end
		if varGlobal.limiteTela < 1280 then
			GRUPOGERAL.y = 0
		end
	end
	auxFuncs.onMouseEventRolagem( event,GRUPOGERAL,verificarLimites )
end

Runtime:addEventListener( "mouse", eventoDeMouse )
------------------------

local function onKeyEvent( event )

	-- Print which key was pressed down/up
	local message = "Key '" .. event.keyName .. "' was pressed " .. event.phase
	--print( message )
 
	-- If the "back" key was pressed on Android, prevent it from backing out of the app
	--[[
	if ( event.keyName == "back" ) then
		if event.phase == "up" then
			if Var.anotComInterface.telaProtetiva then
				Var.anotComInterface.telaProtetiva:removeSelf()
				Var.anotComInterface.telaProtetiva=nil
				Var.anotComInterface.fundoBranco:removeSelf()
				Var.anotComInterface.fundoBranco=nil
				Var.anotComInterface.fechar:removeSelf()
				Var.anotComInterface.fechar=nil
				Var.anotacao.Barra:removeSelf()
				Var.comentario.Barra:removeSelf()
				Var.anotacao.BarraEsconder1:removeSelf()
				Var.comentario.BarraEsconder2:removeSelf()
				Var.anotComInterface.BarraTextoTopo:removeSelf()
				Var.anotComInterface.BarraTextoTopo2:removeSelf()
				Var.anotacao.Barra=nil
				Var.comentario.Barra=nil
				Var.anotacao.BarraEsconder1=nil
				Var.comentario.BarraEsconder2=nil
				Var.anotComInterface.BarraTextoTopo=nil
				Var.anotComInterface.BarraTextoTopo2=nil
				Var.anotacao:removeSelf()
				Var.comentario:removeSelf()
				Var.anotacao=nil
				Var.comentario=nil
			elseif Var.GMenuBotao then
				Var.GMenuBotao:removeSelf()
				Var.GMenuBotao = nil
			else
				if #vetorVoltar > 1 then
					print( "Button was pressed and released" )
					table.remove(vetorVoltar,#vetorVoltar)
					paginaAtual = vetorVoltar[#vetorVoltar]
					table.remove(vetorVoltar,#vetorVoltar)
					GRUPOGERAL.subPagina = nil
					criarCursoAux(TelasMenuGeral,paginaAtual)
					--funcGlobal.escreverNoHistorico("Voltou para página: "..pagina)
				end
				if clicado == true then
					clicado = false
					
					return true
				else
					--grupoMenuGeralTTS.isVisible = false
					clicado = true
					return true
				end
			end
			return true
		end
	end
	]]
	--print(event.keyName)
	--print(event.phase)
	
	-- IMPORTANT! Return false to indicate that this app is NOT overriding the received key
	-- This lets the operating system execute its default handling of the key
	return false
end
 
-- Add the key event listener
Runtime:addEventListener( "key", onKeyEvent )
	--====================================================================
	--====================================================================
	--====================================================================
	-- QUANDO MUDAR TAMANHO TELA WINDOWS --===============================
	--====================================================================

	local function onResize( event )

		local numero = 1280
		if system.getInfo("platform") == "win32" then
			numero = varGlobal.numeroWin
		end
		varGlobal.limiteTela = varGlobal.limiteTela - (H - numero)
	end
	 
	-- Add the "resize" event listener
	Runtime:addEventListener( "resize", onResize )
	--====================================================================
	--====================================================================
	--====================================================================
return M;

				
--[[
function checkAppExixts()
	local platform = system.getInfo( "platformName" )
	local storestring = system.getInfo( "targetAppStore")
	local appinstalled = false
	 
	 
	local function getappfromstore()
		local options =
		{
		 
		iOSAppId = "xxxxxxxxxx", 
		nookAppEAN = "xxxxxxxxxxxxxxxx",
		androidAppPackageName = "com.icyspark.bargainhunter",
		supportedAndroidStores = {storestring},
		}
		native.showPopup("appStore", options)
	end
	 
	 
	 
	if platform == "win32" then
		local appIcon = display.newImage("android.app.icon://com.icyspark.bargainhunter",160,-200)
		if appIcon then
			-- App is installed.
			display.remove(appIcon)
			appIcon = nil
			appinstalled = true
			 
		else
			-- App is not installed.
			appinstalled = false
			 
		end
	 
		local otherappbutton = display.newRect(sceneGroup,160,240,50,50)
		otherappbutton:setFillColor(0.5)
		 
		 
		local function clickbanner(self,e)
			-- button listener for when you press the button to either load other app or get it from store
			if e.phase == "began" then
				self:setFillColor(0.88)
			elseif e.phase == "ended" then
				self:setFillColor(0.5)
				if platform == "win32" then
					if appinstalled == true then
						if not system.openURL("bargainhunter://") then
							getappfromstore()
							--print("App Not Installed")
							end
						else
							getappfromstore()
						end
					elseif platform == "iPhone OS" then
						if not system.openURL("bargainhunter://") then
						getappfromstore()
					end
				end
			end
			return true
		end
		 
		 
		 
		otherappbutton.touch = clickbanner
		otherappbutton:addEventListener("touch")
	end
end

checkAppExixts()]]