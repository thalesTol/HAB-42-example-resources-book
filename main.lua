display.setStatusBar( display.HiddenStatusBar )

-- INDICE -----------------------------------------------------------------
-- VERIFICAR SE EXISTE ARQUIVO LOGIN ANDROID --
-- function AposLogin0()
-- dicionário leitura --
-- local BotaoFalarPagina
-- EXECUÇÃO DO LIVRO --
-- FUNÇÃO DE RETORNO DE VOZ --
---------------------------------------------------------------------------

--====================================================--
-- leitura de bibliotecas para o MAIN --
local conversor = require("conversores")
local historicoLib = require("historico")
local validarUTF8 = require("utf8Validator")
local android = require("ManejarArquivosAndroid")
local mime = require("mime")
local auxFuncs = require("ferramentasAuxiliares")
local leituraTxT = require("leituraArquivosTxT")
local logF = require("libraries.loginFuncs")
local json = require("json")
--====================================================--
-- Função que previne a tela de dormir durante seu uso
system.setIdleTimer( false )
-- remover e retirar barra de status do sistema
auxFuncs.verificarERetirarBarraStatusSystem()
--====================================================--
-- Reservando canais de som para a aplicação --
-- Apenas o primeiro está sendo usado de forma específica
audio.reserveChannels( 1 )
audio.reserveChannels( 2 )
audio.reserveChannels( 3 )
audio.setVolume( 1 )
--====================================================--

--====================================================--
-- criando variáveis de controle do MAIN --
-- 1 - Table que vai guardar os dados principais para a execução do main
-- para evitar a criação excessiva de variáveis locais na raiz do arquivo
-- pois existe um limite de 200 variáveis locais para cada nível de execução
local funcGlobais = {}
local varGlobais = {}
varGlobais.Login0 = nil
varGlobais.NomeLogin0 = nil
varGlobais.EmailLogin0 = nil
varGlobais.codigoLivro0 = "teste"
varGlobais.idLivro0 = nil
varGlobais.idProprietario0 = 15
varGlobais.idAluno0 = nil
varGlobais.apelidoAluno0 = nil
varGlobais.permissaoMensagens0 = "N"
varGlobais.restricaoLivro = "L"
varGlobais.temLogin = true
varGlobais.temHistorico = true
varGlobais.vetorPastasAndroid = {}
-- 2 - Variável de idetificação do sistema
local tipoSistema = auxFuncs.checarPortatil()
-- 3 - Variáveis de medida da tela do aparelho
local W = display.viewableContentWidth;
local H = display.viewableContentHeight;
--====================================================--


-- VERIFICAR LOGIN PARA CEGOS --
logF.lerArquivoAndroidParaLoginCegos({
	arquivo = "arquivoLoginLibEA.txt",
	pasta = "Download"
},varGlobais)
-----------------------------------------------	

	
	
	local function exists(file)
   	   local ok, err, code = os.rename(file, file)
	   if not ok then
	      if code == 13 then
	         -- Permission denied, but it exists
	         return true
	      end
	   end
	   return ok, err
	end
	--- Check if a directory exists in this path
	local function isdir(path)
	   -- "/" works on both Unix and Windows
	   return exists(path.."/")
	end
	
	local function RegistrarHistorico(conteudo)
		
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
		
		-- Path for the file to write
		local path = system.pathForFile( "historico offline.txt", system.DocumentsDirectory )
		 
		-- Open the file handle
		local file, errorString = io.open( path, "a+" )
		 
		if not file then
			-- Error occurred; output the cause
			print( "File error: " .. errorString )
		else
			-- Write data to file
			file:write( conteudo )
			-- Close the file handle
			io.close( file )
		end
		 
		file = nil
		
		local vetorJsonAux = auxFuncs.loadTable("historico.json")
		if not vetorJsonAux then vetorJsonAux = {} end

		vetorJsonAux.usuario_id = varGlobais.idAluno0
		vetorJsonAux.livro_id = tostring(varGlobais.idLivro0)
		vetorJsonAux.identificador = system.getInfo( "deviceID" )
		vetorJsonAux.dispositivo = system.getInfo( "model" )
		local date = os.date( "*t" )
		vetorJsonAux.data_horario = date.year.."-"..date.month.."-"..date.day.." "..date.hour..":"..date.min..":"..date.sec..".0"
		

		local function cadastroListener2( event )

			if ( event.isError ) then
				  --local alert = native.showAlert( "Network Error . Check Connection", "Connect to Internet", { "Try again" }  )
				  print("Network Error . Check Connection", "Connect to Internet")
			else
				print("WARNING: Começo MONGODB\n", event.response,"\n","WARNING: FIM MONGODB")
				local resposta = json.decode(event.response)
				print(resposta)
				if string.find(tostring(event.response),"Dados inseridos com sucesso!") or string.find(tostring(event.response),"sucesso") then
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
		parameters1.body = "Register=1&idAluno=" .. varGlobais.idAluno0 .. "&idProprietario=" .. varGlobais.idProprietario0 .. "&codigoLivro=" .. varGlobais.codigoLivro0 .. "&conteudo=".. conteudo
		local URL2 = "https://omniscience42.com/EAudioBookDB/CadastrarHistorico.php"
		network.request(URL2, "POST", cadastroListener1,parameters1) -- baixando base de dados completa
		local URL2 = "https://omniscience42.com/EAudioBookDB/mongo.php"
		network.request(URL2, "POST", cadastroListener2,parameters2) -- baixando base de dados completa
	end
	
	local paginaInicialNumero = 1
	if auxFuncs.fileExistsDoc("paginaSalva.txt") then
		local paginaInicial = auxFuncs.lerTextoDoc("paginaSalva.txt")
		if string.find(paginaInicial,"_Pagina%d+_PagExerc") then
			paginaInicialNumero = paginaInicial
		else
			paginaInicialNumero = tonumber(paginaInicial)
			if not paginaInicialNumero then
				paginaInicialNumero = 1
			end
		end
	end
	
	local paginasParaVoltar = {paginaInicialNumero}
	print("paginaInicialNumero = ",paginaInicialNumero)
	if auxFuncs.fileExistsDoc("paginaVoltar.txt") then
		paginasParaVoltar = auxFuncs.lerTextoDocReturnVetorNumbers("paginaVoltar.txt")
	end
	
	local function lerTextoRes(arquivo)
		local path = system.pathForFile( arquivo, system.ResourceDirectory )
 
		local file, errorString = io.open( path, "r" )
		local contents = file:read( "*a" )
		io.close( file )
		 
		file = nil
		
		return contents
	end
	
	
	------------------------------------------------------------------
	-- LER PREFERæNCIAS GENƒRICAS DO AUTOR --------------------------------
	------------------------------------------------------------------

	function varGlobais.lerPreferenciasAutor()
		local function criarArquivoTXT(atributos) -- vetor ou variavel
			local caminho2 = system.pathForFile(atributos.arquivo,system.DocumentsDirectory)
			local file2, errorString = io.open( caminho2, "w+" )
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
		local function lerArquivoPadrao()
			local vetor = {}
			local path = system.pathForFile( "Preferencias Autor.txt", system.ResourceDirectory )
			local file, errorString = io.open( path, "r" )
			local xx=1
			local ignorar = true
			if not file then
				print( "File error: " .. errorString )
			else
				for line in file:lines() do
					if string.len( line ) > 3 then
						local is_valid, error_position = validarUTF8.validate(line)
						if not is_valid then 
							line = conversor.converterANSIparaUTFsemBoom(line)
						end
						if string.find(line,"=") then
							vetor[xx] = line
							xx = xx+1
						end
					end
				end
				io.close( file )
			end
			for i=0,#vetor do
				local aux = vetor[i]
				vetor[i] = aux
			end
			file = nil
			return vetor
		end

		local vetorTodas = lerArquivoPadrao()
		
		-- VERIFICANDO QUAL ƒ O LIVRO
		if auxFuncs.fileExists("codigoLivro.txt") then
			varGlobais.codigoLivro0 = lerTextoRes("codigoLivro.txt")
		end
		local function lerPreferenciasLivroBanco()
			local function listenerLivro(event)
				if ( event.isError ) then
					if not auxFuncs.fileExistsDoc("idLivro.txt") and varGlobais.temLogin then
						local function onComplete()
							os.exit()
						end
						native.showAlert("Erro de conexão","Não foi poss’vel estabelecer uma conexão com a internet.\né necessária uma conexão com a internet na primeira vez que o aplicativo for executado em seu aparelho!",{"sair e fechar"},onComplete)
					end
					--Var.comentario.vetorComentarios = {}
					--Var.comentario.vetorComentarios[1] = {}
					--Var.comentario.vetorComentarios[1].conteudo = "Conexão com a internet falhou:"
				else
					local json = require("json")
					local vetorBancoDeDados = json.decode(event.response)
					print("DADOS LIVRO = ",event.response)
					if vetorBancoDeDados then 
						if vetorBancoDeDados.permissao_mensagens and vetorBancoDeDados.permissao_mensagens == "S" then
							varGlobais.permissaoMensagens0 = criarArquivoTXT({arquivo = "permissaoMensagens.txt",variavel = vetorBancoDeDados.permissao_mensagens})
							varGlobais.permissaoMensagens0 = vetorBancoDeDados.permissao_mensagens
							vetorTodas.permissaoComentarios = varGlobais.permissaoMensagens0
						end
						if vetorBancoDeDados.autor_id then
							varGlobais.idProprietario0 = criarArquivoTXT({arquivo = "idProprietario.txt",variavel = vetorBancoDeDados.autor_id})
							varGlobais.idProprietario0 = tonumber(vetorBancoDeDados.autor_id)
						end
						if vetorBancoDeDados.livro_id then
							varGlobais.idLivro0 = criarArquivoTXT({arquivo = "idLivro.txt",variavel = vetorBancoDeDados.livro_id})
							varGlobais.idLivro0 = tonumber(vetorBancoDeDados.livro_id)
						end
						if vetorBancoDeDados.nome_livro then
							criarArquivoTXT({arquivo = "nomeLivro.txt",variavel = vetorBancoDeDados.nome_livro})
							varGlobais.nomeLivro0 = vetorBancoDeDados.nome_livro
						end
						if vetorBancoDeDados.restricao then
							varGlobais.restricaoLivro = vetorBancoDeDados.restricao
						end
					end
				end
			end
			local parameters = {}
			parameters.body = "codigoLivro=" .. varGlobais.codigoLivro0
			local URL2 = "https://omniscience42.com/EAudioBookDB/lerDadosLivro.php"
			network.request(URL2, "POST", listenerLivro,parameters)
		end
		local vetorBancoDeDados = lerPreferenciasLivroBanco()
		
		
		--thales1
		local padrao = {
			permissaoComentarios = "nao",
			ativarHistorico = "sim",
			ativarLogin = "sim",
			primeiraNumeracao = 1,
			cor = "branco",
			linguagem = "portugues_br",
			ajudaTTS = "sim",
			TTSDesativado = "nao"
		}
		--vetorTodas.permissaoComentarios = padrao.permissaoComentarios
		vetorTodas.ativarHistorico = padrao.ativarHistorico
		vetorTodas.ativarLogin = padrao.ativarLogin
		vetorTodas.primeiraNumeracao = padrao.primeiraNumeracao
		vetorTodas.linguagem = padrao.linguagem
		vetorTodas.VelocidadeTTS = padrao.VelocidadeTTS
		vetorTodas.ajudaTTS = padrao.ajudaTTS
		vetorTodas.TTSDesativado = padrao.TTSDesativado
		
		vetorTodas = auxFuncs.lerPreferenciasAutorAux(vetorTodas,padrao)
		
		return vetorTodas
	end

	-- verificar preferências autor
	local preferenciasGerais = varGlobais.lerPreferenciasAutor()
	
	contagemInicialPaginas = 0
	print("contagemInicialPaginas",contagemInicialPaginas)
	if preferenciasGerais.primeiraNumeracao then
		contagemInicialPaginas = tonumber(preferenciasGerais.primeiraNumeracao)
		print("contagemInicialPaginas",contagemInicialPaginas)
	end
	
	if preferenciasGerais.ativarLogin then
		varGlobais.auxTemLogin = preferenciasGerais.ativarLogin
		if string.find(varGlobais.auxTemLogin,"nao") then
			varGlobais.temLogin = false
		elseif string.find(varGlobais.auxTemLogin,"sim") then
			varGlobais.temLogin = true
		end
		varGlobais.auxTemLogin = nil
	end
	
	if preferenciasGerais.ativarHistorico then
		varGlobais.auxTemHistorico = preferenciasGerais.ativarHistorico
		if string.find(varGlobais.auxTemHistorico,"nao") then
			varGlobais.temHistorico = false
		elseif string.find(varGlobais.auxTemHistorico,"sim") then
			varGlobais.temHistorico = true
		end
		varGlobais.auxTemHistorico = nil
	end
	
	--varGlobais.temLogin = false
	--varGlobais.temHistorico = false
	
	--=================================================--
	--LIMPAR system.DocumentsDirectory
	--=================================================--
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
	local function pegarDocumentsDirectory()
		local lfs = require "lfs";
		local vetor = {}
		local doc_dir = system.DocumentsDirectory;
		local doc_path = system.pathForFile(nil, doc_dir);
		local resultOK, errorMsg;
		 
		for file in lfs.dir(doc_path) do
			local theFile = system.pathForFile(file, doc_dir);
		 
			if (lfs.attributes(theFile, "mode") ~= "directory") then
				if string.find(theFile,"Pagina%d+_PagExerc%d+Alt%d+_") then
					table.insert(vetor,file)
				end
			end
		end
		return vetor
	end
	
	local yy = 1
	local function copyFile( srcName, srcPath, dstName, dstPath, overwrite )
		
		local results = false
		local function doesFileExist( fname, path )
 
			local results = false
		 
			-- Path for the file
			local filePath = path .. "/"..fname
			--testarNoAndroid(filePath.."!",60*yy)
			
			if ( filePath ) then
				local file, errorString = io.open( filePath, "r" )
				--testarNoAndroid(tostring(errorString).."!",(60*yy)+30)
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
	
	local function	copiarPastaParaDocuments(path)
		local lfs = require( "lfs" )
		 local xx = 1
		 local dest = system.pathForFile(nil,system.DocumentsDirectory)
		for file in lfs.dir( path ) do
			if string.find(file,".txt") then
				print( "Found file or directory: " .. file )
				copyFile( file, path, string.gsub(file,".txt",""), dest, true )
				xx = xx+1
			end
		end
	end
	
	local function criarArquivoTXT(atributos) -- vetor ou variavel
		local caminho2 = atributos.caminho .. "/"..atributos.arquivo
		local file2, errorString = io.open( caminho2, "w" )
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
	
	
	local function escreverNoHistorico(texto,vetorJson)
		if varGlobais.temHistorico == true then
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
				

				auxFuncs.saveTable( vetorJsonAux, "historico.json")
			end
			
			if auxFuncs.fileExistsDoc("historico offline.txt") then
				if varGlobais.tipoSistema == "android" then
					copyFileHistorico( "historico offline.txt", string.gsub(system.pathForFile("historico offline.txt",system.DocumentsDirectory),"historico offline.txt",""), "historico offline.txt", "/sdcard", true )
				elseif varGlobais.tipoSistema == "PC" then
					if tipoSistemaMac == "macos" then
						copyFileHistorico( "historico offline.txt", string.gsub(system.pathForFile("historico offline.txt",system.DocumentsDirectory),"historico offline.txt",""), "historico offline.txt", ssk.files.desktop.getDesktopRoot(), true )
					else
						copyFileHistorico( "historico offline.txt", string.gsub(system.pathForFile("historico offline.txt",system.DocumentsDirectory),"historico offline.txt",""), "historico offline.txt", "C:/!E-book Hipermidia!", true )
					end
				end
			end
		end
		
		
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
				for line in file2:lines() do
					if string.len(line)>1 then
						for past in string.gmatch(line, '([A-Za-z0-9%?!@##=%&"[%-]:;/%.,\\_+*åÃç ËƒæêëÕïîò†‰ãáˆéê’”õ™óúŸ%(%)]+)') do
							line = past 
							
						end
						table.insert(vetor,line)
						xx = xx+1
					end
				end
				for i=1,#vetor do
					if i~= #vetor then
						if tipoSistema == "android" then
							vetor[i] = vetor[i]:sub(1, #vetor[i] - 1)
						end
					end
				end
				io.close( file2 )
				file2 = nil
			end
			return vetor
		end
	end
	
	local function lerArquivoTXTAndroid(arquivo,vetor) -- vetor ou variavel

		local caminho2 = system.pathForFile(arquivo)
			
		local file2, errorString = io.open( caminho2, "r" )
			
		--local file2, errorString = io.open( caminho2, "r" )
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
					for past in string.gmatch(line, '([A-Za-z0-9%?!@##=%&"[%-]:;/%.,\\_+%*åÃç ËƒæêëÕïîò†‰ãáˆéê’”õ™óúŸ%(%)]+)') do
						line = past 
						
					end
					table.insert(vetor,line)
					xx = xx+1
				end
			end
			io.close( file2 )
			file2 = nil
		end
		return vetor
	end
	
	local function pegarNumeroLinhasTxT(atributo)
		local caminho = system.pathForFile(atributo.caminho)
		local file, errorString = io.open( caminho, "r" )
		local numeroArquivos = 0
		if not file then
			print( "File error: ", errorString )
		else
			for line in file:lines() do
				if string.len(line)>3 then
					numeroArquivos = numeroArquivos + 1
				end
			end
		end
		return numeroArquivos
	end
	-- =========================================================--
	-- verificar Login --
	
	function AposLogin0()
		-- primeiro tentar baixar anotações pessoais do livro --
		local function saveTable2( t, filename, location )
 
			local loc = location
			if not location then
				loc = system.DocumentsDirectory
			end
		 
			-- Path for the file to write
			local path = system.pathForFile( filename, loc )
		 
			-- Open the file handle
			local file, errorString = io.open( path, "w" )
		 
			if not file then
				-- Error occurred; output the cause
				print( "File error: " .. errorString )
				return false
			else
				
				file:write( json.encode( t ) )
				-- Close the file handle
				io.close( file )
				return true
			end
		end
		function funcGlobais.anotacaoListener( event )
			print("WARNING: COME‚OU Anots")
			if ( event.isError ) then
				print("Conexão com a internet falhou: Não foi poss’vel restaurar as anotações")
			else
				local json = require("json")
				print(event.response)
				local vetorAnotacoes = json.decode(event.response)
				if vetorAnotacoes and #vetorAnotacoes == 0 then
					print("O usuário não possui anotações nesse livro")
				elseif vetorAnotacoes and #vetorAnotacoes > 0 then
					for i=1,#vetorAnotacoes do
						vetorAnotacoes[i].anotacao_id = vetorAnotacoes[i][1]
						vetorAnotacoes[i].livro_id = vetorAnotacoes[i][2]
						vetorAnotacoes[i].usuario_id = vetorAnotacoes[i][3]
						vetorAnotacoes[i].conteudo = vetorAnotacoes[i][4]
						vetorAnotacoes[i].numero_pag = vetorAnotacoes[i][5]
						vetorAnotacoes[i].dt_criacao = vetorAnotacoes[i][6]
						local caminho = system.pathForFile(nil,system.DocumentsDirectory)
						criarArquivoTXT({caminho = caminho,arquivo = "anotacaoPagina"..vetorAnotacoes[i].numero_pag..".txt",variavel = vetorAnotacoes[i].conteudo});
					end
				end
			end
			print("WARNING: ACABOU Anots")
		end
		if varGlobais.idLivro0 and varGlobais.idAluno0 then -- se tiver conectado na internet
			local parameters = {}
			parameters.body = "consulta_todas=1&idLivro=" .. varGlobais.idLivro0 .."&idUsuario=" .. varGlobais.idAluno0
			local URL2 = "https://omniscience42.com/EAudioBookDB/anotacoes.php"
			network.request(URL2, "POST", funcGlobais.anotacaoListener,parameters)
		end
		--------------------------------------------------------
		
		Runtime:removeEventListener( "key", funcGlobais.onKeyEvent )
		ead = require ("libEA")
		
		-- verificar se é windows e criar lista de TTS offline
		local function alphanumsort(o)
		  local function padnum(d) local dec, n = string.match(d, "(%.?)0*(.+)")
			return #dec > 0 and ("%.12f"):format(d) or ("%s%03d%s"):format(dec, #n, n) end
		  table.sort(o, function(a,b)
			return string.lower(tostring(a):gsub("%.?%d+",padnum)..("%3d"):format(#b))
				 <  string.lower(tostring(b):gsub("%.?%d+",padnum)..("%3d"):format(#a)) end)
		  return o
		end
		
		if tipoSistema == "PC" and system.getInfo("environment") == "simulator" then
			local arquivosPaginasPre = {}
			local arquivosPaginas = {}
			--print("está no windows")
			local path = system.pathForFile(nil,system.ResourceDirectory)
			local audioFiles = {}
			for file in lfs.dir ( path.."/TTS" ) do
				if string.find( file, ".MP3" )or string.find( file, ".WAV" )then
					table.insert(audioFiles,file)
				end
			end
			audioFiles = alphanumsort(audioFiles)
			criarArquivoTXT({caminho = system.pathForFile(nil,system.ResourceDirectory).."/TTS",arquivo = "dllTTS.txt",vetor = audioFiles})
			
			local fontFiles = {}
			for file in lfs.dir ( path.."/Fontes" ) do
				if string.find( file, ".ttf" )or string.find( file, ".otf" )or string.find( file, ".fnt" )then
					table.insert(fontFiles,file)
				end
			end
			fontFiles = alphanumsort(fontFiles)
			criarArquivoTXT({caminho = system.pathForFile(nil,system.ResourceDirectory).."/Fontes",arquivo = "dllFontes.txt",vetor = fontFiles})
			
			local imageFilesPaginas = {}
			for file in lfs.dir ( path.."/Paginas" ) do
				if auxFuncs.checarExtensaoImagem(file) then
					table.insert(imageFilesPaginas,file)
				end
			end
			imageFilesPaginas = alphanumsort(imageFilesPaginas)
			criarArquivoTXT({caminho = system.pathForFile(nil,system.ResourceDirectory).."/Paginas",arquivo = "dllImagens.txt",vetor = imageFilesPaginas})
			local imageFilesPaginasOutrosArquivos = {}
			for file in lfs.dir ( path.."/Paginas/Outros Arquivos" ) do
				if auxFuncs.checarExtensaoImagem(file) then
					table.insert(imageFilesPaginasOutrosArquivos,file)
				end
			end
			imageFilesPaginasOutrosArquivos = alphanumsort(imageFilesPaginasOutrosArquivos)
			criarArquivoTXT({caminho = system.pathForFile(nil,system.ResourceDirectory).."/Paginas/Outros Arquivos",arquivo = "dllImagens.txt",vetor = imageFilesPaginasOutrosArquivos})
			
			local imageFilesPaginasPre = {}
			for file in lfs.dir ( path.."/PaginasPre" ) do
				if auxFuncs.checarExtensaoImagem(file) then
					table.insert(imageFilesPaginasPre,file)
				end
			end
			imageFilesPaginasPre = alphanumsort(imageFilesPaginasPre)
			criarArquivoTXT({caminho = system.pathForFile(nil,system.ResourceDirectory).."/PaginasPre",arquivo = "dllImagens.txt",vetor = imageFilesPaginasPre})
			local imageFilesPaginasPreOutrosArquivos = {}
			for file in lfs.dir ( path.."/PaginasPre/Outros Arquivos" ) do
				if auxFuncs.checarExtensaoImagem(file) then
					table.insert(imageFilesPaginasPreOutrosArquivos,file)
				end
			end
			imageFilesPaginasPreOutrosArquivos = alphanumsort(imageFilesPaginasPreOutrosArquivos)
			criarArquivoTXT({caminho = system.pathForFile(nil,system.ResourceDirectory).."/PaginasPre/Outros Arquivos",arquivo = "dllImagens.txt",vetor = imageFilesPaginasPreOutrosArquivos})
			
			-- criando dllTelas Pré
			local vetorTxTs0 = {}
			for file in lfs.dir ( path.."/PaginasPre"  ) do
				local arquivoExt = string.sub(file,#file-3,#file)
				if file ~= "Config Padrao Animacao.txt" and file ~= "Config Padrao Botao.txt" and file ~= "Config Padrao Exercicio.txt" and file ~= "Config Padrao Fundo.txt" and  file ~= "Config Padrao Imagem.txt" and file ~= "Config Padrao Som.txt" and file ~= "Config Padrao Texto.txt" and file ~= "Config Padrao Video.txt"and file ~= "Config Padrao ImagemTexto.txt" and file ~= "Config Padrao Separador.txt" and file ~= "dllTelas.txt" and file ~= "dllImagens.txt"and file ~= "dllAlturaImagens.txt" and file ~= "Sons" and file ~= "TTS" and file ~= "Videos" and file ~= "Outros Arquivos" and file ~= "." and file ~= ".." and file ~= "Animacoes" and arquivoExt == ".txt"then
					table.insert(arquivosPaginasPre,file)
					table.insert( vetorTxTs0, file )
				end
			end
			vetorTxTs0 = alphanumsort(vetorTxTs0)
			criarArquivoTXT({caminho = path.."/PaginasPre",arquivo = "dllTelas.txt",vetor = vetorTxTs0})
			-- criando dllTelas
			local vetorTxTs0 = {}
			for file in lfs.dir ( path.."/Paginas" ) do
				local arquivoExt = string.sub(file,#file-3,#file)
				if file ~= "Config Padrao Animacao.txt" and file ~= "Config Padrao Botao.txt" and file ~= "Config Padrao Exercicio.txt" and file ~= "Config Padrao Fundo.txt" and file ~= "Config Padrao Imagem.txt" and file ~= "Config Padrao Som.txt" and file ~= "Config Padrao Texto.txt" and file ~= "Config Padrao Video.txt"and file ~= "Config Padrao ImagemTexto.txt" and file ~= "Config Padrao Separador.txt" and file ~= "dllTelas.txt" and file ~= "dllImagens.txt"and file ~= "dllAlturaImagens.txt" and file ~= "Sons" and file ~= "TTS" and file ~= "Videos" and file ~= "Outros Arquivos" and file ~= "." and file ~= ".." and file ~= "Animacoes" and arquivoExt == ".txt"then
					table.insert(arquivosPaginas,file)
					table.insert( vetorTxTs0, file )
				end
			end
			vetorTxTs0 = alphanumsort(vetorTxTs0)
			criarArquivoTXT({caminho = path.."/Paginas",arquivo = "dllTelas.txt",vetor = vetorTxTs0})
			-- criando dllIndices
			-- primeiro e segundo passo deve ocorrer só durente a build
			if system.getInfo("environment") == "simulator" then
				-- primeiro vamos pegar os indices e guardar em vetores sem o numero real das páginas
				arquivosPaginasPre = alphanumsort(arquivosPaginasPre)
				arquivosPaginas = alphanumsort(arquivosPaginas)
				varGlobais.vetorIndicesPaginasPre = leituraTxT.formarVetorParaTxTsDeIndicesAutomatico(arquivosPaginasPre,"PaginasPre")
				varGlobais.vetorIndicesPaginas = leituraTxT.formarVetorParaTxTsDeIndicesAutomatico(arquivosPaginas,"Paginas")
				-- devemos pegar o vetor do índice remissivo também
				varGlobais.vetorRemissivo = nil
				if auxFuncs.fileExists("Dicionario Palavras/dllIndiceRemissivo.txt") then
					varGlobais.vetorRemissivo = auxFuncs.lerArquivoTXTCaminho({caminho = system.pathForFile("Dicionario Palavras/dllIndiceRemissivo.txt"),tipo = "vetor"})
				end
				-- segundo vamos criar os txts dos indices sem os numeros das páginas de indices
				os.remove(system.pathForFile(nil).."/Indices/indice 1.txt")
				os.remove(system.pathForFile(nil).."/Indices/indice 2.txt")
				os.remove(system.pathForFile(nil).."/Indices/indice 3.txt")
				os.remove(system.pathForFile(nil).."/Indices/indice 4.txt")
				os.remove(system.pathForFile(nil).."/Indices/indice 5.txt")
				os.remove(system.pathForFile(nil).."/Indices/indice 6.txt")
				os.remove(system.pathForFile(nil).."/Indices/indice 7.txt")
				if varGlobais.vetorIndicesPaginasPre[1][1] or varGlobais.vetorIndicesPaginas[1][1] then
					auxFuncs.criarTxTRes2("Indices/indice 1.txt","Sumário\n")
				end
				if varGlobais.vetorIndicesPaginasPre[2][1] or varGlobais.vetorIndicesPaginas[2][1] then
					auxFuncs.criarTxTRes2("Indices/indice 2.txt","Índice de Figuras\n")
				end
				if varGlobais.vetorIndicesPaginasPre[3][1] or varGlobais.vetorIndicesPaginas[3][1] then
					auxFuncs.criarTxTRes2("Indices/indice 3.txt","Índice de Audios\n")
				end
				if varGlobais.vetorIndicesPaginasPre[4][1] or varGlobais.vetorIndicesPaginas[4][1] then
					auxFuncs.criarTxTRes2("Indices/indice 4.txt","Índice de Videos\n")
				end
				if varGlobais.vetorIndicesPaginasPre[5][1] or varGlobais.vetorIndicesPaginas[5][1] then
					auxFuncs.criarTxTRes2("Indices/indice 5.txt","Índice de Animações\n")
				end
				if varGlobais.vetorIndicesPaginasPre[6][1] or varGlobais.vetorIndicesPaginas[6][1] then
					auxFuncs.criarTxTRes2("Indices/indice 6.txt","Índice de Questões\n")
				end
				
				if varGlobais.vetorRemissivo and varGlobais.vetorRemissivo[1] then
					local scriptIndiceRemissivo = ""
					for pal=1,#varGlobais.vetorRemissivo do
						scriptIndiceRemissivo = scriptIndiceRemissivo .."\n" .. varGlobais.vetorRemissivo[pal]
					end
					auxFuncs.criarTxTRes2("Indices/indice 7.txt","Índice Remissivo"..scriptIndiceRemissivo)
				end

			end
			-- agora vamos pegar os txts dos indices
			local vetorTxTs0 = {}
			for file in lfs.dir ( path.."/Indices"  ) do
				local arquivoExt = string.sub(file,#file-3,#file)
				if file ~= "config indices.txt" and file ~= "dllIndices.txt" and file ~= "." and file ~= ".." and arquivoExt == ".txt"then
					
					table.insert( vetorTxTs0, file )
				end
			end
			vetorTxTs0 = alphanumsort(vetorTxTs0)
			criarArquivoTXT({caminho = path.."/Indices",arquivo = "dllIndices.txt",vetor = vetorTxTs0})
			
			local foldersPre = {}
			for file in lfs.dir(path.."/PaginasPre/Outros Arquivos") do
				local theFile = system.pathForFile(file, system.ResourceDirectory);
					 
				--if theFile and (lfs.attributes(theFile, "mode") == "directory") then
				if not string.find(file,"%.") or string.find(file,".lib") then
					table.insert(foldersPre,file)
				end
			end
			foldersPre = alphanumsort(foldersPre)
			criarArquivoTXT({caminho = system.pathForFile(nil,system.ResourceDirectory).."/PaginasPre/Outros Arquivos",arquivo = "dllFolders.txt",vetor = foldersPre})
			
			local foldersPaginas = {}
			for file in lfs.dir(path.."/Paginas/Outros Arquivos") do
				local theFile = system.pathForFile(file, system.ResourceDirectory);
					 
				--if theFile and (lfs.attributes(theFile, "mode") == "directory") then
				if not string.find(file,"%.") or string.find(file,".lib") then
					table.insert(foldersPaginas,file)
				end
				
			end
			foldersPaginas = alphanumsort(foldersPaginas)
			criarArquivoTXT({caminho = system.pathForFile(nil,system.ResourceDirectory).."/Paginas/Outros Arquivos",arquivo = "dllFolders.txt",vetor = foldersPaginas})
			
			for i=1,#foldersPre do
				local imageFilesFoldersPre = {}
				for file in lfs.dir ( path.."/PaginasPre/Outros Arquivos/"..foldersPre[i] ) do
					if auxFuncs.checarExtensaoImagem(file) then
						table.insert(imageFilesFoldersPre,file)
					end
				end
				imageFilesFoldersPre = alphanumsort(imageFilesFoldersPre)
				criarArquivoTXT({caminho = system.pathForFile(nil,system.ResourceDirectory).."/PaginasPre/Outros Arquivos/"..foldersPre[i],arquivo = "dllImagens.txt",vetor = imageFilesFoldersPre})
				local imageFilesFoldersPre = {}
				if isdir(path.."/PaginasPre/Outros Arquivos/"..foldersPre[i].."/Outros Arquivos") then
					for file in lfs.dir(path.."/PaginasPre/Outros Arquivos/"..foldersPre[i].."/Outros Arquivos") do
						local theFile = system.pathForFile(file, system.ResourceDirectory);
						--if theFile and (lfs.attributes(theFile, "mode") == "directory") then
						if auxFuncs.checarExtensaoImagem(file) then
							table.insert(imageFilesFoldersPre,file)
						end
					end
				end
				imageFilesFoldersPre = alphanumsort(imageFilesFoldersPre)
				criarArquivoTXT({caminho = system.pathForFile(nil,system.ResourceDirectory).."/PaginasPre/Outros Arquivos/"..foldersPre[i].."/Outros Arquivos",arquivo = "dllImagens.txt",vetor = imageFilesFoldersPre})
				
				local vetorTxTs = {}
				if tipoSistema ~= "android" then
					local pngFiles = {}
					local pngFilesNames = {}
					local path = system.pathForFile( "PaginasPre/", system.ResourceDirectory)
					for file in lfs.dir ( path ) do
						if auxFuncs.checarExtensaoImagem(file) then
							local inverso = string.reverse(file)
							local extencaoinver = string.sub( inverso, 1,4 )
							local extencao = string.lower(string.reverse(extencaoinver))
							local inversoReduzidoNome = string.sub( inverso, 5 )
							local nome = string.reverse(inversoReduzidoNome)
							
							table.insert( pngFiles, file )
						end
					end
					alphanumsort(pngFiles)
					for i=1,#pngFiles do
						local inverso = string.reverse(pngFiles[i])
						local extencaoinver = string.sub( inverso, 1,4 )
						local extencao = string.lower(string.reverse(extencaoinver))
						local inversoReduzidoNome = string.sub( inverso, 5 )
						local nome = string.reverse(inversoReduzidoNome)
						if auxFuncs.fileExists("PaginasPre/"..nome..".txt") == false then
							
							local caminho = system.pathForFile("",system.ResourceDirectory)
							criarArquivoTXT({caminho = caminho.."/PaginasPre",arquivo = nome..".txt",variavel = "1 - imagem\n arquivo = "..pngFiles[i]})
						end
					end
				end
				for file in lfs.dir (system.pathForFile(nil,system.ResourceDirectory).."/PaginasPre/Outros Arquivos/"..foldersPre[i] ) do
					if string.find( file, ".txt" ) and not string.find(file,"dllImagens") and not string.find(file,"dllTelas")  then
						table.insert(vetorTxTs,file)
						--print("vetorTxTs =+ ",vetorTxTs,file)
					end
				end
				vetorTxTs = alphanumsort(vetorTxTs)
				criarArquivoTXT({caminho = system.pathForFile(nil,system.ResourceDirectory).."/PaginasPre/Outros Arquivos/"..foldersPre[i],arquivo = "dllTelas.txt",vetor = vetorTxTs})
				
			end
			
			for i=1,#foldersPaginas do
				local imageFilesFoldersPaginas = {}
				for file in lfs.dir ( path.."/Paginas/Outros Arquivos/"..foldersPaginas[i] ) do
					if auxFuncs.checarExtensaoImagem(file) then
						table.insert(imageFilesFoldersPaginas,file)
					end
				end
				
				imageFilesFoldersPaginas = alphanumsort(imageFilesFoldersPaginas)
				criarArquivoTXT({caminho = system.pathForFile(nil,system.ResourceDirectory).."/Paginas/Outros Arquivos/"..foldersPaginas[i],arquivo = "dllImagens.txt",vetor = imageFilesFoldersPaginas})
				
				local imageFilesFoldersPaginas = {}
				if isdir(path.."/Paginas/Outros Arquivos/"..foldersPaginas[i].."/Outros Arquivos") then
					for file in lfs.dir(path.."/Paginas/Outros Arquivos/"..foldersPaginas[i].."/Outros Arquivos") do
						local theFile = system.pathForFile(file, system.ResourceDirectory);
						--if theFile and (lfs.attributes(theFile, "mode") == "directory") then
						if auxFuncs.checarExtensaoImagem(file) then
							table.insert(imageFilesFoldersPaginas,file)
						end
					end
				end
				imageFilesFoldersPaginas = alphanumsort(imageFilesFoldersPaginas)
				criarArquivoTXT({caminho = system.pathForFile(nil,system.ResourceDirectory).."/Paginas/Outros Arquivos/"..foldersPaginas[i].."/Outros Arquivos",arquivo = "dllImagens.txt",vetor = imageFilesFoldersPaginas})
				
				local vetorTxTs = {}
				if tipoSistema ~= "android" then
					local pngFiles = {}
					local pngFilesNames = {}
					local path = system.pathForFile( "Paginas/", system.ResourceDirectory)
					for file in lfs.dir ( path ) do
						if auxFuncs.checarExtensaoImagem(file) then
							local inverso = string.reverse(file)
							local extencaoinver = string.sub( inverso, 1,4 )
							local extencao = string.lower(string.reverse(extencaoinver))
							local inversoReduzidoNome = string.sub( inverso, 5 )
							local nome = string.reverse(inversoReduzidoNome)
							
							table.insert( pngFiles, file )
						end
					end
					alphanumsort(pngFiles)
					for i=1,#pngFiles do
						local inverso = string.reverse(pngFiles[i])
						local extencaoinver = string.sub( inverso, 1,4 )
						local extencao = string.lower(string.reverse(extencaoinver))
						local inversoReduzidoNome = string.sub( inverso, 5 )
						local nome = string.reverse(inversoReduzidoNome)
						if auxFuncs.fileExists("Paginas/"..nome..".txt") == false then
							
							local caminho = system.pathForFile("",system.ResourceDirectory)
							criarArquivoTXT({caminho = caminho.."/Paginas",arquivo = nome..".txt",variavel = "1 - imagem\n arquivo = "..pngFiles[i]})
						end
					end
				end
				
				for file in lfs.dir (system.pathForFile(nil,system.ResourceDirectory).."/Paginas/Outros Arquivos/"..foldersPaginas[i] ) do
					if string.find( file, ".txt" ) and not string.find(file,"dllImagens") and not string.find(file,"dllTelas")  then
						table.insert(vetorTxTs,file)
						--print("vetorTxTs =+ ",vetorTxTs,file)
					end
				end
				vetorTxTs = alphanumsort(vetorTxTs)
				criarArquivoTXT({caminho = system.pathForFile(nil,system.ResourceDirectory).."/Paginas/Outros Arquivos/"..foldersPaginas[i],arquivo = "dllTelas.txt",vetor = vetorTxTs})
				
			end
			
			local imageFilesPaginasDic = {}
			for file in lfs.dir ( path.."/Dicionario Palavras/Outros Arquivos" ) do
				if auxFuncs.checarExtensaoImagem(file) then
					table.insert(imageFilesPaginasDic,file)
				end
			end
			imageFilesPaginasDic = alphanumsort(imageFilesPaginasDic)
			criarArquivoTXT({caminho = system.pathForFile(nil,system.ResourceDirectory).."/Dicionario Palavras/Outros Arquivos",arquivo = "dllImagens.txt",vetor = imageFilesPaginasDic})
			
		end
		
		-- criar dlls para o DICIONARIO
		
		
		
		
		-- LER SE TRAVA A TELA EM ARQUiVO --
		
		local travar = "padrao"
		local travar = "padrao"
		
		ead.escolherOrientacao(travar) -- padrao
		
		local corEscolhida = "branco"
		if preferenciasGerais.cor then
			corEscolhida = preferenciasGerais.cor
		end
		
		ead.colocarPlanoDeFundo({cor = corEscolhida}) -- preto branco
		
		local Telas = {}
		local listaDeErros = {}

		Telas.paginasParaVoltar = paginasParaVoltar

		local caminhoAux0 = string.gsub(system.pathForFile("infoPaginas.txt",system.ResourceDirectory),"/infoPaginas.txt","")
		caminhoAux0 = string.gsub(caminhoAux0,"/infoPaginas.txt","")
		caminhoAux0 = string.gsub(caminhoAux0,"\\infoPaginas.txt","")
		
		

		local caminhoAux = caminhoAux0 .. "/PaginasPre"
		print("5 - ",caminhoAux)

		-- Pegar numero de telas para Barra de páginas: --
		local numeroTotal = {}
		numeroTotal.PaginasPre = pegarNumeroLinhasTxT({caminho = "PaginasPre/dllTelas.txt"})
		numeroTotal.Indices = pegarNumeroLinhasTxT({caminho = "Indices/dllIndices.txt"})
		numeroTotal.Paginas = pegarNumeroLinhasTxT({caminho = "Paginas/dllTelas.txt"})
		
		if system.getInfo("environment") == "simulator" then
			local vetoresIndicesSumario = {}
			local cont = 0
			if varGlobais.vetorRemissivo and varGlobais.vetorRemissivo[1] then
				table.insert(vetoresIndicesSumario,1,{0 - cont,"Índice Remissivo",1})
				cont = cont + 1
			end
			if varGlobais.vetorIndicesPaginasPre[6][1] or varGlobais.vetorIndicesPaginas[6][1] then
				table.insert(vetoresIndicesSumario,1,{0 - cont,"Índice de Questões",1})
				cont = cont + 1
			end
			if varGlobais.vetorIndicesPaginasPre[5][1] or varGlobais.vetorIndicesPaginas[5][1] then
				table.insert(vetoresIndicesSumario,1,{0 - cont,"Índice de Animações",1})
				cont = cont + 1
			end
			if varGlobais.vetorIndicesPaginasPre[4][1] or varGlobais.vetorIndicesPaginas[4][1] then
				table.insert(vetoresIndicesSumario,1,{0 - cont,"Índice de Videos",1})
				cont = cont + 1
			end
			if varGlobais.vetorIndicesPaginasPre[3][1] or varGlobais.vetorIndicesPaginas[3][1] then
				table.insert(vetoresIndicesSumario,1,{0 - cont,"Índice de Audios",1})
				cont = cont + 1
			end
			if varGlobais.vetorIndicesPaginasPre[2][1] or varGlobais.vetorIndicesPaginas[2][1] then
				table.insert(vetoresIndicesSumario,1,{0 - cont,"Índice de Figuras",1})
			end
			
			for i=1,#varGlobais.vetorIndicesPaginasPre do
				if varGlobais.vetorIndicesPaginasPre[i][1] then
					for j=1,#varGlobais.vetorIndicesPaginasPre[i] do
						varGlobais.vetorIndicesPaginasPre[i][j][1] = varGlobais.vetorIndicesPaginasPre[i][j][1] - numeroTotal.PaginasPre - numeroTotal.Indices
					end
					local tipo = ""
					if i == 1 then tipo = "texto"
					elseif i == 2 then tipo = "imagem"
					elseif i == 3 then tipo = "som"
					elseif i == 4 then tipo = "video"
					elseif i == 5 then tipo = "animacao"
					elseif i == 6 then tipo = "questao" end
					leituraTxT.formarScriptTxTIndiceAutomatico(varGlobais.vetorIndicesPaginasPre[i],tipo)
				end
			end
			leituraTxT.formarScriptTxTIndiceAutomatico(vetoresIndicesSumario,"texto",contagemInicialPaginas)
			for i=1,#varGlobais.vetorIndicesPaginas do
				if varGlobais.vetorIndicesPaginas[i][1] then
					local tipo = ""
					if i == 1 then tipo = "texto"
					elseif i == 2 then tipo = "imagem"
					elseif i == 3 then tipo = "som"
					elseif i == 4 then tipo = "video"
					elseif i == 5 then tipo = "animacao"
					elseif i == 6 then tipo = "questao" end
					leituraTxT.formarScriptTxTIndiceAutomatico(varGlobais.vetorIndicesPaginas[i],tipo,contagemInicialPaginas)
				end
			end
		end
		
		
		local vetorExercicios = pegarDocumentsDirectory()
		numeroTotal.PaginasExerc = 0
		if vetorExercicios and vetorExercicios ~= {} then
			numeroTotal.PaginasExerc = #vetorExercicios
		end
		numeroTotal.Todas = numeroTotal.PaginasPre + numeroTotal.Indices + numeroTotal.Paginas

		if paginaInicialNumero > numeroTotal.Todas then
			paginaInicialNumero = numeroTotal.Todas
		end
		local PaginaIndice = numeroTotal.PaginasPre + 1
		if numeroTotal.PaginasPre + numeroTotal.Indices == 0 then
			PaginaIndice = 1
		elseif numeroTotal.Indices == 0 then
			PaginaIndice = 1
		end
		if contagemInicialPaginas == 0 then
			numeroTotal.paginasAntesZero = numeroTotal.Indices + numeroTotal.PaginasPre
		elseif contagemInicialPaginas > 0 then
			numeroTotal.paginasAntesZero = numeroTotal.Indices + numeroTotal.PaginasPre - contagemInicialPaginas
		elseif contagemInicialPaginas < 0 then
			numeroTotal.paginasAntesZero = numeroTotal.Indices + numeroTotal.PaginasPre + (-1*contagemInicialPaginas)
		end	
		print("numeroTotal.paginasAntesZero = ",numeroTotal.paginasAntesZero,numeroTotal.Indices,numeroTotal.PaginasPre)		
		varGlobais.vetorIPPreTitulos,varGlobais.vetorIPPreImagens,varGlobais.vetorIPPreSons,varGlobais.vetorIPPreVideos,varGlobais.vetorIPPreAnimacoes = nil,nil,nil,nil,nil
		varGlobais.vetorIPTitulos,varGlobais.vetorIPImagens,varGlobais.vetorIPSons,varGlobais.vetorIPVideos,varGlobais.vetorIPAnimacoes = nil,nil,nil,nil,nil

		local caminhoAuxIndice = caminhoAux0.."/Indices"

		temIndice = "sim"
		if 	caminhoAuxIndice then	
			if auxFuncs.fileExists("ativar indice.txt") then
				temIndice = ead.lerArquivoTXT({caminho = caminhoAux0,arquivo = "ativar indice.txt",tipo = "texto"})
			end
		end
				
		local TemUmindice = false
		
		if auxFuncs.fileExists("Indices/config indices.txt") and  string.find(temIndice,"sim")then
			TemUmindice = true
		end
		 
		--ead.criarTelasImagens(Telas,{pasta = "Paginas"},listaDeErros)
		Telas.numeroTotal = numeroTotal
		Telas.arquivos = {}
		if numeroTotal.PaginasPre > 0 then
			lerArquivoTXTAndroid("PaginasPre/dllTelas.txt",Telas.arquivos)
		end
		--testarNoAndroid(Telas.arquivos[1],100)
		if numeroTotal.Indices > 0 then
			lerArquivoTXTAndroid("Indices/dllIndices.txt",Telas.arquivos)
		end
		if numeroTotal.Paginas > 0 then
			lerArquivoTXTAndroid("Paginas/dllTelas.txt",Telas.arquivos)
		end
		
		local function contagemDaPaginaHistorico(pag)
			local pagina
			if type(pag) == "number" then
				pagina = pag + contagemInicialPaginas - numeroTotal.PaginasPre-numeroTotal.Indices -1
			else
				pagina = pag 
			end
			return pagina
		end
		function SecondsToClock(seconds)
		  local seconds = tonumber(seconds)

		  if seconds <= 0 then
			return "00:00:00";
		  else
			hours = string.format("%02.f", math.floor(seconds/3600));
			mins = string.format("%02.f", math.floor(seconds/60 - (hours*60)));
			secs = string.format("%02.f", math.floor(seconds - hours*3600 - mins *60));
			if hours == "00" then
				return mins..":"..secs.." minutos"
			elseif hours == "01" then
				return hours..":"..mins..":"..secs.." hora"
			else
				return hours..":"..mins..":"..secs.." horas"
			end
			
		  end
		end
		function funcGlobais.pegarNumeroPaginaRomanosHistorico(pagina)
			local auxPaginaLivro = tostring(pagina)
			if string.find(auxPaginaLivro,"%-") then
				auxPaginaLivro = auxFuncs.ToRomanNumerals(string.gsub(auxPaginaLivro,"%-",""))
			else
				auxPaginaLivro = auxPaginaLivro
			end
			return auxPaginaLivro
		end
		if varGlobais.temHistorico == true then
			-- criar HISTÓRICO
				
				local paginaHistorico = auxFuncs.contagemDaPaginaHistorico(
					{
						pagina_livro = paginaInicialNumero,
						contagemInicialPaginas = contagemInicialPaginas,
						PaginasPre= numeroTotal.PaginasPre,
						Indices = numeroTotal.Indices,
						paginasAntesZero = numeroTotal.paginasAntesZero
					}
				)
				
				historicoLib.Criar_e_salvar_vetor_historico({
					tipoInteracao = "generica",
					pagina_livro = paginaHistorico,
					objeto_id = nil,
					acao = "abrir livro",
					tela = {contagemDaPaginaHistorico = paginaInicialNumero}
				})
				-----------------------------------------------------
		end
		local function exportstring( s )
			return string.format("%q", s)
		end
		function table.save(  tbl,filename )
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
		
			
		local function saveTable( t, filename, location )
 
			local loc = location
			if not location then
				loc = system.DocumentsDirectory
			end
		 
			-- Path for the file to write
			local path = system.pathForFile( filename, loc )
		 
			-- Open the file handle
			local file, errorString = io.open( path, "w" )
		 
			if not file then
				-- Error occurred; output the cause
				print( "File error: " .. errorString )
				return false
			else
				
				file:write( json.encode( t ) )
				-- Close the file handle
				io.close( file )
				return true
			end
		end
		local function loadTable( filename, location )
 
			local loc = location
			if not location then
				loc = system.DocumentsDirectory
			end
		 
			-- Path for the file to read
			local path = system.pathForFile( filename, loc )
		 
			-- Open the file handle
			local file, errorString = io.open( path, "r" )
		 
			if not file then
				-- Error occurred; output the cause
				print( "File error: " .. errorString )
			else
				-- Read data from file
				local contents = file:read( "*a" )
				-- Decode JSON data into Lua table
				local t = json.decode( contents )
				-- Close the file handle
				io.close( file )
				-- Return table
				return t
			end
		end
		if numeroTotal.PaginasExerc > 0 then
			for i=1,#vetorExercicios do
				print(vetorExercicios[i])
				Telas.arquivos[#Telas.arquivos+1] =  vetorExercicios[i]
				local aux = string.gsub(vetorExercicios[i],"%.txt","%.json")
				local conteudo = loadTable(aux)
				print("conteudo = ",conteudo,aux)
				local nome = string.gsub(vetorExercicios[i],"%.txt","")
				Telas[nome] = conteudo
			end
		end
		--testarNoAndroid(Telas.arquivos[1],200)
		
		-------------------------------------------------------------------------------
		-- Leitor TXTs P/ DICIONARIO
		local function tirarAExtencao(str)
			print(str)
			local inverso = string.reverse(str)
			local inversoReduzidoNome = string.sub( inverso, 5 )
			local nome = string.reverse(inversoReduzidoNome)
			return nome
		end
		
		local vetorPalavrasContextoPaginas = {}
		
		-- dicionário leitura --------------------------------------------------------
		local Dicionario = require("dicionario")
		
		if system.getInfo("environment") == "simulator" then
			varGlobais.vetorDicionario = {}
			Dicionario.pegarTextosEPalavras(
				{nPaginas = numeroTotal.PaginasPre,pasta = "PaginasPre",arquivos = Telas.arquivos,idLivro0 = varGlobais.idLivro0,idAluno0 = varGlobais.idAluno0,idProprietario0 = varGlobais.idProprietario0,idLivro = varGlobais.idLivro0},
				Telas,{},varGlobais.vetorDicionario,contagemInicialPaginas,numeroTotal
			)
			Dicionario.pegarTextosEPalavras(
				{nPaginas = numeroTotal.Paginas,pasta = "Paginas",arquivos = Telas.arquivos,idLivro0 = varGlobais.idLivro0,idAluno0 = varGlobais.idAluno0,idProprietario0 = varGlobais.idProprietario0,idLivro = varGlobais.idLivro0},
				Telas,{},varGlobais.vetorDicionario,contagemInicialPaginas,numeroTotal
			)
			auxFuncs.saveTable(Telas,"telas.json","res")
			auxFuncs.saveTable(varGlobais.vetorDicionario,"palavrasEContextosLivro.json","res")
		end
		-------------------------------------------------------------------------------
		
		timer.performWithDelay(10,function()ead.criarCurso(Telas,paginaInicialNumero) end,1)
		
		
		local imagemBotaoInterfaceUp = "botaoRecomecarUp.png"
		local imagemBotaoInterfaceDown = "botaoRecomecarDown.png"
		
		if preferenciasGerais.linguagem then
			if preferenciasGerais.linguagem == "portugues_br" then
				imagemBotaoInterfaceUp = "botaoRecomecarUp.png"
				imagemBotaoInterfaceDown = "botaoRecomecarDown.png"
			elseif preferenciasGerais.linguagem == "ingles_us" then
				imagemBotaoInterfaceUp = "botaoRecomecarUp ingles.png"
				imagemBotaoInterfaceDown = "botaoRecomecarDown ingles.png"
			end
		end
		local somBotao = "inicio.MP3"
		if TemUmindice == true then
			imagemBotaoInterfaceUp = "botaoIndiceUp.png"
			imagemBotaoInterfaceDown = "botaoIndiceDown.png"
			somBotao = "indice.MP3"
			if preferenciasGerais.linguagem then
				if preferenciasGerais.linguagem == "portugues_br" then
					imagemBotaoInterfaceUp = "botaoIndiceUp.png"
					imagemBotaoInterfaceDown = "botaoIndiceDown.png"
					somBotao = "indice.MP3"
				elseif preferenciasGerais.linguagem == "ingles_us" then
					imagemBotaoInterfaceUp = "botaoIndiceUp ingles.png"
					imagemBotaoInterfaceDown = "botaoIndiceDown ingles.png"
					somBotao = "indice ingles.MP3"
				end
			end
		end
			INTERFACE = ead.criarBotaoIndice({arquivo = imagemBotaoInterfaceUp,
										fundoDown = imagemBotaoInterfaceDown,
										somBotao = somBotao,
										altura = 40,
										comprimento = 110,
										posicaoY = "topo",
										posicaoX = "esquerda",
										pagina = PaginaIndice},
										Telas)

		ead.criarBotaoTTS({},Telas)
		
		local function girarTelaOrientacaoBotaoFalarPagina(botao)
			if system.orientation == "landscapeRight" then
				if system.getInfo( "platform" ) == "win32" then --win32
					botao.rotation = 0
					botao.y = W - botao.width*1.5
					botao.x = botao.height*1.5
					botao.xScale = 1.5
					botao.yScale = 1.5
					botao.tipo = "portrait"
					
					print("\n\nPORTRAIT\n\n")
				else
					botao.rotation = 90
					aux = botao.y
					botao.y = H - botao.width/2
					botao.x = W/2
					botao.xScale = 1.5
					botao.yScale = 1.5
					botao.tipo = "landscapeRight"
					print("\n\nLEFT\n\n")
				end
			elseif system.orientation == "landscapeLeft" then
				botao.rotation = 270
				botao.y = 0+ botao.width/2
				botao.x = W/2
				botao.xScale = 1.3
				botao.yScale = 1.3
				botao.tipo = "landscapeLeft"
				print("\n\nRIGHT\n\n")
			elseif system.orientation == "portrait" then
				botao.rotation = 0
				botao.x = W-botao.width/2;
				botao.y = H/2;
				botao.xScale = 1
				botao.yScale = 1
				botao.tipo = "portrait"
				
				print("\n\nPORTRAIT\n\n")
			end
			botao:addEventListener("tap",function() return true; end)
		end
		
		--local BotaoFalarPagina = ead.botaoFalarPagina()
		--Runtime:addEventListener("orientation",function() girarTelaOrientacaoBotaoFalarPagina(BotaoFalarPagina) end)
		
		ead.criarNumeroDasPaginas(numeroTotal)
		ead.criarBarraDePaginas(Telas,numeroTotal)
									
		print("------------------------\nLISTA DE ERROS")
		local textoErros = ""
		if listaDeErros[1] ~= nil then
			for i=1,#listaDeErros do
				print(listaDeErros[i])
				textoErros = textoErros..listaDeErros[i].."\n"
			end
			native.showAlert( "Lista de Erros", "Atenção! Onde houver erros serão usadas as configurações padrão:\n\n"..textoErros, { "OK" })
		end
		print("------------------------")
		
		--ead.colocarSom({arquivo = "Paginas/Outros Arquivos/2 - BencaoApostolica.mp3"})
		-- retangulo = display.newRect(0,display.contentHeight/10,111.5,10)
		-- retangulo:setFillColor()
		-- retangulo.anchorX = 0
		local function webListener(event)
			print("showWebPopup callback")
			
			local url = event.url

			if string.find(url, "http://www.youtube.com") or string.find(url, "https://www.youtube.com") then
				return true
			end

			if( string.find( url, "https:" ) ~= nil or string.find( url, "http:" ) ~= nil or string.find( url, "mailto:" ) ~= nil ) then
				print("url: ".. url)
				system.openURL(url)
			end

			return true
		end
	end
	
	local function AposLogin()
		-- verificar e criar arquivo de conversões --
		local json = require("json")
		local substituicoes = {}
		parameters = {}
		parameters.body = "tipo=geral"
		local URL = "https://omniscience42.com/EAudioBookDB/leituraSubstituicoes.php"
		local function networkListener( event )
			if ( event.isError ) then
				print("Network Error . Check Connection", "Connect to Internet")
				AposLogin0()
			else
				
				if event.response ~= "null " and event.response ~= "null" then
					substituicoes = json.decode(event.response)
					
					print("WARNING: SUBSTITUIÇÕES")
					if type(substituicoes) == "table" then
						substituicoes.original = {}
						substituicoes.novo = {}
					end
					if type(substituicoes) == "table" and #substituicoes > 0 then
						for i=1,#substituicoes do
							substituicoes.original[i] = substituicoes[i][3]
							substituicoes.novo[i] = substituicoes[i][4]
						end
						
						if substituicoes.original and #substituicoes.original > 0 then
							local documentos = system.pathForFile("substituicoes.txt",system.DocumentsDirectory)
							local substituicoesMescladas = ""
							for i=1,#substituicoes.original do
								substituicoesMescladas = substituicoesMescladas..substituicoes.original[i].."||"..substituicoes.novo[i].."\n"
							end
							auxFuncs.criarTxTDoc("substituicoes.txt",substituicoesMescladas)
							AposLogin0()
						end
					else
						AposLogin0()
						print("Atenção!", "Não existem substituições para esse tipo")
					end
				else
					print("RESPONSE NULL", event.response)
					AposLogin0()
				end
			end
		end
		network.request(URL, "POST", networkListener,parameters)
		---------------------------------------------
		---------------------------------------------
	end
	
	-- fazer upload do histórico --
	
	local widget = require "widget"
	
	local function uploadHistorico(arquivo)
	
		local function uploadListener( event )
		   if ( event.isError ) then
			  print( "Network Error." )
		 
			  -- This is likely a time out or server being down. In other words,
			  -- It was unable to communicate with the web server. Now if the
			  -- connection to the web server worked, but the request is bad, this
			  -- will be false and you need to look at event.status and event.response
			  -- to see why the web server failed to do what you want.
		   else
			  if ( event.phase == "began" ) then
				 print( "Upload started" )
			  elseif ( event.phase == "progress" ) then
				 print( "Uploading... bytes transferred ", event.bytesTransferred )
			  elseif ( event.phase == "ended" ) then
				 print( "Upload ended..." )
				 print( "Status:", event.status )
				 print( "Response:", event.response )
			  end
		   end
		end
		 
		-- Sepcify the URL of the PHP script to upload to. Do this on your own server.
		-- Also define the method as "PUT".
		local url = "https://omniscience42.com/EAudioBookDB/uploadHistorico.php"
		local method = "PUT"
		 
		-- Set some reasonable parameters for the upload process:
		local params = {
		   timeout = 60,
		   progress = true,
		   bodyType = "binary"
		}
		 
		-- Specify what file to upload and where to upload it from.
		-- Also, set the MIME type of the file so that the server knows what to expect.
		local filename = arquivo
		local baseDirectory = system.DocumentsDirectory
		local contentType = "text/plain"  --another option is "image/jpeg"
		 
		-- There is no standard way of using HTTP PUT to tell the remote host what
		-- to name the file. We'll make up our own header here so that our PHP script
		-- expects to look for that and provides the name of the file. Your PHP script
		-- needs to be "hardened" because this is a security risk. For example, someone
		-- could pass in a path name that might try to write arbitrary files to your
		-- server and overwrite critical system files with malicious code.
		-- Don't assume "This won't happen to me!" because it very well could.
		local headers = {}
		headers.filename = filename
		params.headers = headers
		 
		network.upload( url , method, uploadListener, params, filename, baseDirectory, contentType )
		
	end
	
	-- VERIFICAR LOGIN SENÃO RODAR O LIVRO --
	
	local function criarSemLogin()
		local grupoTravarTela = display.newGroup()
		local telaPreta = display.newRect(0,0,W,H)
		telaPreta.anchorX = 0.5; telaPreta.anchorY = 0.5
		telaPreta.anchorX = 0.5; telaPreta.anchorY = 0.5
		telaPreta.x = W/2; telaPreta.y = H/2
		telaPreta.x = W/2; telaPreta.y = H/2
		telaPreta:setFillColor(1,1,1)
		telaPreta.alpha=0.9
		telaPreta:addEventListener("tap",function() return true end)
		telaPreta:addEventListener("touch",function() return true end)
		local texto = display.newText("aguarde",W/2,H/2,"Fontes/segoeuib.ttf",50)
		texto:setFillColor(0,0,0)
		grupoTravarTela:insert(telaPreta)
		grupoTravarTela:insert(texto)
		toqueHabilitado = false
		
		-- verificar e criar arquivo de conversões --
		local json = require("json")
		local substituicoes = {}
		parameters = {}
		parameters.body = "tipo=geral"
		local URL = "https://omniscience42.com/EAudioBookDB/leituraSubstituicoes.php"
		local function networkListener( event )
			if ( event.isError ) then
				print("Network Error . Check Connection", "Connect to Internet")
			else
				if event.response ~= "null " and event.response ~= "null" then
					substituicoes = json.decode(event.response)
					if type(substituicoes) == "table" then
						substituicoes.original = {}
						substituicoes.novo = {}
					end
					if type(substituicoes) == "table" and #substituicoes > 0 then
						for i=1,#substituicoes do
							print(substituicoes[i][1])
							substituicoes.original[i] = substituicoes[i][3]
							substituicoes.novo[i] = substituicoes[i][4]
						end
						
						if substituicoes.original and #substituicoes.original > 0 then
							print("WOOOOAAAA")
							local documentos = system.pathForFile("substituicoes.txt",system.DocumentsDirectory)
							local substituicoesMescladas = ""
							for i=1,#substituicoes.original do
								substituicoesMescladas = substituicoesMescladas..substituicoes.original[i].."||"..substituicoes.novo[i].."\n"
							end
							local file2, errorString = io.open( documentos, "w" )
							if not file2 then
								print( "File error: " .. errorString )
							else
								file2:write(substituicoesMescladas)
								io.close( file2 )
								file2 = nil
							end
							criarArquivoTXT({caminho = documentos,arquivo = "",variavel = substituicoesMescladas})
						end
					else
						print("Atenção!", "Não existem substituições para esse tipo")
					end
				else
					print("RESPONSE NULL", event.response)
				end
			end
		end
		
		network.request(URL, "POST", networkListener,parameters)
		
		AposLogin0()
		
		timer.performWithDelay(2001,function() grupoTravarTela:removeSelf()end,1)
	end
	
	-- EXECUÇÃO DO LIVRO --
	
	-- 1- verificar se tem updates para o livro --
	
	-- 1.1-- verificar versão do livro --
	if auxFuncs.fileExistsDiretorioBase("version.txt",system.DocumentsDirectory) then
		local aux = string.gsub(auxFuncs.lerTextoDoc("version.txt"),"version = ","")
		varGlobais.version = tonumber(aux)
	else
		auxFuncs.criarTxTDoc("version.txt","version = 1")
		varGlobais.version = 1
	end
	
	-- 1.2 -- baixar arquivos da versão se não for a última versão 
	
	
	
	if varGlobais.temLogin == false then
		timer.performWithDelay(100,criarSemLogin,1)
	elseif varGlobais.temLogin == true then
		
		local function telaDeLogin()
			local grupoLogin = display.newGroup()
		
			--==========================--
			-- criar interface de login --
			local retangulo = display.newRect(W/2,H/2,W,H)
			retangulo:setFillColor(1,1,1)
			grupoLogin:insert(retangulo)
			retangulo.alpha = 1
			
			local campoLogin = native.newTextField(W/2, 268, 2*W/3, 80)
			local campoLoginFundo = display.newRect(W/2, 268, 2*W/3, 80)
			local function textListenerConta( event )
 
				if ( event.phase == "began" ) then
					audio.stop()
					campoLogin.retangulo.alpha = 0
				else
					varGlobais.talkBack(event)
				end
			end
			campoLogin.retangulo = display.newRect(campoLoginFundo.x,campoLoginFundo.y,campoLoginFundo.width,campoLoginFundo.height)
			campoLogin.retangulo.strokeWidth = 5
			campoLogin.retangulo:setStrokeColor(1,0,0)
			campoLogin.retangulo.anchorX,campoLogin.retangulo.anchorY = campoLoginFundo.anchorX,campoLoginFundo.anchorY
			campoLogin.retangulo.alpha = 0
			
			campoLogin:addEventListener( "userInput", textListenerConta )
			--native.setKeyboardFocus( campoLogin )
			--WW.campoLogin.anchorX = 0
			--campoLogin.hasBackground = false
			campoLogin.placeholder = "apelido ou e-mail"
			campoLogin:setReturnKey( "next" );
			grupoLogin:insert(campoLogin)
			grupoLogin:insert(campoLoginFundo)
			grupoLogin:insert(campoLogin.retangulo)
			if system.getInfo("platform") == "win32" then
				--campoLogin.width = campoLogin.width/2
			end
			local function limparListenerL(e)
				campoLogin.text = ""
				campoLogin.retangulo.alpha = 0
			end
			local botaoLimparLogin = widget.newButton{
					defaultFile = "X.png",
					overFile = "XD.png",
					onRelease =limparListenerL,
					height = campoLogin.height,
					width = 48
			}
			if system.getInfo("platform") == "win32" then
				--botaoLimparLogin.width = botaoLimparLogin.width/2
			end
			botaoLimparLogin.anchorX=0
			botaoLimparLogin.anchorY=0.5
			botaoLimparLogin.y = campoLogin.y
			botaoLimparLogin.x = campoLogin.x+campoLogin.width/2+10
			grupoLogin:insert(botaoLimparLogin)
		
			local campoSenha = native.newTextField(W/2, 398, 2*W/3, 80)
			local campoSenhaFundo = display.newRect(W/2, 398, 2*W/3, 80)
			local function textListenerSenha( event )
			
				if ( event.phase == "began" ) then
					audio.stop()
					campoSenha.retangulo.alpha = 0
					--audio.play(som)
				else
					varGlobais.talkBack(event)
				end
			
			end
		
			campoSenha:addEventListener( "userInput", textListenerSenha )
			if system.getInfo("platform") == "win32" then
				--campoSenha.width = campoSenha.width/2
			end
			campoSenha.placeholder = "senha"
			--WW.campoSenha.hasBackground = false
			campoSenha.isSecure = true
			campoSenha.retangulo = display.newRect(campoSenhaFundo.x,campoSenhaFundo.y,campoSenhaFundo.width,campoSenhaFundo.height)
			campoSenha.retangulo.strokeWidth = 5
			campoSenha.retangulo:setStrokeColor(1,0,0)
			campoSenha.retangulo.anchorX,campoSenha.retangulo.anchorY = campoSenhaFundo.anchorX,campoSenhaFundo.anchorY
			campoSenha.retangulo.alpha = 0
			grupoLogin:insert(campoSenha)
			grupoLogin:insert(campoSenhaFundo)
			grupoLogin:insert(campoSenha.retangulo)
		
			local function limparListenerS(e)
				campoSenha.text = ""
				campoSenha.retangulo.alpha = 0
			end
			local botaoLimparSenha = widget.newButton{
					defaultFile = "X.png",
					overFile = "XD.png",
					onRelease =limparListenerS,
					height = campoSenha.height,
					width = 48
			}
			if system.getInfo("platform") == "win32" then
				--botaoLimparSenha.width = botaoLimparSenha.width/2
			end
			botaoLimparSenha.anchorX=0
			botaoLimparSenha.anchorY=0.5
			botaoLimparSenha.y = campoSenha.y
			botaoLimparSenha.x = campoSenha.x+campoSenha.width/2+10
			grupoLogin:insert(botaoLimparSenha)
		
			local function checkboxSwitchListener( event )
				if event.target.isOn == true then
					campoSenha.isSecure = false
				else
					campoSenha.isSecure = true
				end
			end
		
			local options = {
				width = 128,
				height = 128,
				numFrames = 2,
				sheetContentWidth = 256,
				sheetContentHeight = 128
			}
			local checkboxSheet = graphics.newImageSheet( "eye.png", options )
		
			local botaoMostrarSenha = widget.newSwitch {
					style = "checkbox",
					sheet = checkboxSheet,
					frameOff = 2,
					frameOn = 1,
					initialSwitchState = false,
					onPress = checkboxSwitchListener,
					width = W/9,--80
					height = H/12.8,--100
			}
			if system.getInfo("platform") == "win32" then
				botaoMostrarSenha.width = botaoMostrarSenha.width/2
			end
			botaoMostrarSenha.alpha = .5
			botaoMostrarSenha.anchorX=1
			botaoMostrarSenha.anchorY=0.5
			botaoMostrarSenha.y = campoSenha.y
			botaoMostrarSenha.x = campoSenha.x -campoSenha.width/2 -10
			grupoLogin:insert(botaoMostrarSenha)
		
		
			------------------------------
			--==========================--
			local botaoLogin
			local botaoRegistrar
			local botaoRegistrarRapido
			local function erroLoginDuplo(livro,IDlogin)
					local grupoTravarTela = display.newGroup()
					local telaPreta = display.newRect(0,0,W,H)
					telaPreta.anchorX = 0.5; telaPreta.anchorY = 0.5
					telaPreta.anchorX = 0.5; telaPreta.anchorY = 0.5
					telaPreta.x = W/2; telaPreta.y = H/2
					telaPreta.x = W/2; telaPreta.y = H/2
					telaPreta:setFillColor(1,1,1)
					telaPreta.alpha=0.9
					telaPreta:addEventListener("tap",function() return true end)
					telaPreta:addEventListener("touch",function() return true end)
					grupoTravarTela:insert(telaPreta)
					native.setKeyboardFocus(nil)
					local grupo = display.newGroup()
					local function deletarTelaDeslogar()
						grupo:removeSelf()
						grupoTravarTela:removeSelf()
						campoLogin.isVisible = true
						campoSenha.isVisible = true
						botaoLogin.isVisible = true
						toqueHabilitado = false	
					end
					local function removerTelaLoginParaAcessoAutomatico()
						while grupoLogin.numChildren > 0 do
							local child = grupoLogin[1]
							if child then child:removeSelf() end
							print("grupoLogin.numChildren" , grupoLogin.numChildren )
						end
					
						if varGlobais.temHistorico == true and auxFuncs.fileExistsDoc("historico.txt") then
							--uploadHistorico("historico "..Login0 .. " " .. EmailLogin0 .. ".txt")
							local conteudo = auxFuncs.lerTextoDoc("historico.txt")
							RegistrarHistorico(conteudo)
						end
					end
					
					local function realizarLoginAposVerificacaoDeAcesso()
						local grupoTravarTela = display.newGroup()
						local telaPreta = display.newRect(0,0,W,H)
						telaPreta.anchorX = 0.5; telaPreta.anchorY = 0.5
						telaPreta.anchorX = 0.5; telaPreta.anchorY = 0.5
						telaPreta.x = W/2; telaPreta.y = H/2
						telaPreta.x = W/2; telaPreta.y = H/2
						telaPreta:setFillColor(1,1,1)
						telaPreta.alpha=0.9
						telaPreta:addEventListener("tap",function() return true end)
						telaPreta:addEventListener("touch",function() return true end)
						local texto = display.newText("aguarde",W/2,H/2,"Fontes/segoeuib.ttf",50)
						texto:setFillColor(0,0,0)
						grupoTravarTela:insert(telaPreta)
						grupoTravarTela:insert(texto)
						toqueHabilitado = false
						campoLogin.isVisible = false
						campoSenha.isVisible = false
					
						print(varGlobais.Login0,varGlobais.NomeLogin0,varGlobais.EmailLogin0)
						timer.performWithDelay(500,AposLogin,1)
						timer.performWithDelay(1000,function() grupoTravarTela:removeSelf()end,1)
					end
					
					local function DeslogarEContinuar(e)
						local function aposDeslogarDoOutroLivro(event)
							if ( event.isError ) then
								print( "Network error!")
								native.showAlert("Atenção","Falha na comunicação com a internet, por favor, verifique sua conexão com a internet e tente novamente!")
							else
								print("Response: ",event.response)
								-- quando clicar em continuar --------
								local ID = system.getInfo( "deviceID" )
								local parameters = {}
								parameters.body = "logarID&livro_id=" .. varGlobais.idLivro0 .. "&usuario_id=" .. varGlobais.idAluno0 .. "&ID="..ID
								local URL = "https://omniscience42.com/EAudioBookDB/verificarPermissaoAcessoLivro.php"
								network.request(URL, "POST", function(event) print(event.response);print("||||||||||") end,parameters) -- baixando base de dados completa
								deletarTelaDeslogar()
								removerTelaLoginParaAcessoAutomatico()
								realizarLoginAposVerificacaoDeAcesso()
								--------------------------------------
							end
						end
						local parameters = {}
						parameters.body = "deslogar&livro_id=" .. livro .. "&usuario_id=" .. IDlogin
						local URL = "https://omniscience42.com/EAudioBookDB/verificarPermissaoAcessoLivro.php"
						network.request(URL, "POST", aposDeslogarDoOutroLivro,parameters)
					end
			
					local elemTela = require("elementosDaTela")
					
					
					toqueHabilitado = false	
				
					campoLogin.isVisible = false
					campoSenha.isVisible = false
				
					
					
					local textoAtencao = display.newText("Atenção!!",W/2+5,40,0,0,"paolaAccent.ttf",80)
					textoAtencao:setFillColor(0,0,0)
					textoAtencao.anchorY=0
					
					local texto2 = elemTela.colocarTexto({texto="Esta conta já está sendo usada em outro aparelho (ou livro).",y=textoAtencao.y+textoAtencao.height+30,margem=50,fonte="segoeui.ttf",tamanho=30,alinhamento="justificado"})
					texto2.anchorY=0
					
					local retanguloFundo = display.newRoundedRect(
						W/2,
						textoAtencao.y - 10,
						texto2.width + 20,
						textoAtencao.height+texto2.height+20+30,
						12)
					retanguloFundo.strokeWidth = 2
					retanguloFundo:setStrokeColor(0,0,0)
					retanguloFundo.anchorX=0.5;retanguloFundo.anchorY=0
					retanguloFundo:setFillColor(1,1,.9)
					
					local texto3 = elemTela.colocarTexto({texto="Se você continuar, seu outro aparelho (ou livro) será desconectado.",y=textoAtencao.y+textoAtencao.height+30+texto2.height+20,margem=50,fonte="segoeui.ttf",tamanho=30,alinhamento="justificado"})
					--texto3.anchorY=0
					
					local retanguloFundo2 = display.newRoundedRect(
						W/2,
						texto3.y+texto3.height/2,
						texto2.width + 20,
						texto3.height+10,
						12)
					retanguloFundo2.strokeWidth = 2
					retanguloFundo2:setStrokeColor(0,0,0)
					retanguloFundo2.anchorX=0.5;retanguloFundo.anchorY=0
					retanguloFundo2:setFillColor(1,1,.9)
					
					grupo:insert(retanguloFundo)
					grupo:insert(retanguloFundo2)
					grupo:insert(textoAtencao)
					grupo:insert(texto2)
					grupo:insert(texto3)
				
					local botaoVoltar = widget.newButton{
						shape = "roundedRect",
						fillColor = {default={ 177/255,6/255,15/255, 1 },over={ 229/255,9/255,19/255,0.5 }},
						width = 270,
						height = 90,
						label = "Cancelar",
						fontSize = 60,
						strokeWidth = 3,
						font = "Fontes/timesbd.ttf",
						strokeColor = { default={ 0, 0, 0, .1 }, over={ 1, 1, 1, 1 } },
						labelColor = { default={ 1, 1, 1, 1 }, over={ 0, 0, 0, 1 } },
						onRelease = deletarTelaDeslogar,
					}
					--grupoComentario[i].opcoes.alpha = .5
					botaoVoltar.x = W/2 + 50
					botaoVoltar.y = texto2.y + texto2.height + 10 + texto3.height + 30
					botaoVoltar.anchorX=0
					botaoVoltar.anchorY=0
					grupo:insert(botaoVoltar)
					
					local botaoContinuar = widget.newButton{
						shape = "roundedRect",
						fillColor = {default={ 0.18, 0.67, 0.785, 1 },over={ 0.004, 0.368, 0.467, .5 }},
						width = 270,
						height = 90,
						label = "Continuar",
						fontSize = 60,
						strokeWidth = 3,
						font = "Fontes/timesbd.ttf",
						strokeColor = { default={ 0, 0, 0, .1 }, over={ 1, 1, 1, 1 } },
						labelColor = { default={ 0, 0, 0, 1 }, over={ 1, 1, 1, 1 } },

						onRelease = DeslogarEContinuar
					}
					botaoContinuar.x = W/2 - 50
					botaoContinuar.y = texto2.y + texto2.height + 10 + texto3.height + 30
					botaoContinuar.anchorX=1
					botaoContinuar.anchorY=0
					grupo:insert(botaoContinuar)
					
				
				end
			function tentarLoginAux()
				if auxFuncs.fileExistsDoc("idAlunoEfetuado.txt") then
					varGlobais.idAluno0 = auxFuncs.lerTextoDoc("idAlunoEfetuado.txt")
				
					if auxFuncs.fileExistsDoc("nomeEfetuado.txt") then
						varGlobais.NomeLogin0 = auxFuncs.lerTextoDoc("nomeEfetuado.txt")
					end
					if auxFuncs.fileExistsDoc("apelidoEfetuado.txt") then
						varGlobais.apelidoAluno0 = auxFuncs.lerTextoDoc("apelidoEfetuado.txt")
					end
					if auxFuncs.fileExistsDoc("emailEfetuado.txt") then
						varGlobais.EmailLogin0 = auxFuncs.lerTextoDoc("emailEfetuado.txt")
					end
					if auxFuncs.fileExistsDoc("loginEfetuado.txt") then
						varGlobais.Login0 = auxFuncs.lerTextoDoc("loginEfetuado.txt")
					end
					if auxFuncs.fileExists("idProprietario.txt") then
						varGlobais.idProprietario0 = lerTextoRes("idProprietario.txt")
						varGlobais.idProprietario0 = tonumber(varGlobais.idProprietario0)
					end
					if auxFuncs.fileExists("codigoLivro.txt") then
						varGlobais.codigoLivro0 = lerTextoRes("codigoLivro.txt")
					end
					if auxFuncs.fileExistsDoc  ("idLivro.txt") then
						varGlobais.idLivro0 = auxFuncs.lerTextoDoc("idLivro.txt")
					end
					local function realizarLoginAposVerificacaoDeAcesso()
						local grupoTravarTela = display.newGroup()
						local telaPreta = display.newRect(0,0,W,H)
						telaPreta.anchorX = 0.5; telaPreta.anchorY = 0.5
						telaPreta.anchorX = 0.5; telaPreta.anchorY = 0.5
						telaPreta.x = W/2; telaPreta.y = H/2
						telaPreta.x = W/2; telaPreta.y = H/2
						telaPreta:setFillColor(1,1,1)
						telaPreta.alpha=0.9
						telaPreta:addEventListener("tap",function() return true end)
						telaPreta:addEventListener("touch",function() return true end)
						local texto = display.newText("aguarde",W/2,H/2,"Fontes/segoeuib.ttf",50)
						texto:setFillColor(0,0,0)
						grupoTravarTela:insert(telaPreta)
						grupoTravarTela:insert(texto)
						toqueHabilitado = false
						campoLogin.isVisible = false
						campoSenha.isVisible = false
					
						print(varGlobais.Login0,varGlobais.NomeLogin0,varGlobais.EmailLogin0)
						timer.performWithDelay(500,AposLogin,1)
						timer.performWithDelay(1000,function() grupoTravarTela:removeSelf()end,1)
					end
					local function removerTelaLoginParaAcessoAutomatico()
						while grupoLogin.numChildren > 0 do
							local child = grupoLogin[1]
							if child then child:removeSelf() end
							print("grupoLogin.numChildren" , grupoLogin.numChildren )
						end
					
						if varGlobais.temHistorico == true and auxFuncs.fileExistsDoc("historico.txt") then
							--uploadHistorico("historico "..Login0 .. " " .. EmailLogin0 .. ".txt")
							local conteudo = auxFuncs.lerTextoDoc("historico.txt")
							RegistrarHistorico(conteudo)
						end
					end
					local function verificarRestricaoAluno(event)
						print("WARNING: verificando restrição aluno (Login Automático)")
						if ( event.isError ) then
							print( "Network error!")
							removerTelaLoginParaAcessoAutomatico()
						
							realizarLoginAposVerificacaoDeAcesso()
						else
							print(event.response)
						
							local data2 = json.decode(event.response)
						
							local ID = system.getInfo( "deviceID" )
							if data2 and data2.message then
								-- verificar paginas e questoes bloqueadas
								auxFuncs.verificarQuestoesEPaginasBloqueadas(data2)
							
								if data2.result == false then
									if grupoTravarTela then
										grupoTravarTela:removeSelf()
									end
									if varGlobais.restricaoLivro == "R" then
										local alert = native.showAlert( "Seu acesso foi negado!", "Seu login não está cadastrado para acessar esse livro. Contate seu vendedor para que seu login seja autorizado a acessá-lo.", { "Ok" } )
										botaoLogin.isVisible = true
										campoLogin.isVisible = true
										campoSenha.isVisible = true
									elseif varGlobais.restricaoLivro == "L" then -- PRIMEIRO LOGIN
										local parameters2 = {}
										parameters2.body = "livro_id=" .. varGlobais.idLivro0 .. "&usuario_id=" .. varGlobais.idAluno0 .. "&ID="..ID
										local URL2 = "https://omniscience42.com/EAudioBookDB/PrimeiroLoginLivro.php"
										network.request(URL2, "POST", function(event) print(event.response);print("||||||||||") end,parameters2) -- baixando base de dados completa
										removerTelaLoginParaAcessoAutomatico()
										realizarLoginAposVerificacaoDeAcesso()
									end
								elseif data2.result == true then
									if varGlobais.restricaoLivro == "L" then
										print("automático, Livre")
										print(data2.ID);print(data2.login)
										print(varGlobais.idLivro0,varGlobais.idAluno0,ID)
										if not data2.ID or data2.login == "OFF" then	
											local parameters = {}
											parameters.body = "logarID&livro_id=" .. varGlobais.idLivro0 .. "&usuario_id=" .. varGlobais.idAluno0 .. "&ID="..ID
											local URL = "https://omniscience42.com/EAudioBookDB/verificarPermissaoAcessoLivro.php"
											network.request(URL, "POST", function(event) print(event.response);print("||||||||||") end,parameters) -- baixando base de dados completa
											removerTelaLoginParaAcessoAutomatico()
											realizarLoginAposVerificacaoDeAcesso()
										elseif data2.login == "ON" and data2.ID ~= ID then
											if grupoTravarTela then
												grupoTravarTela:removeSelf()
											end
											erroLoginDuplo(varGlobais.idLivro0,varGlobais.idAluno0)
											--local alert = native.showAlert( "Seu acesso foi negado!", "A sua conta já está logada em outro aparelho. Deslogue sua conta do aparelho anterior ou contate o suporte!", { "Ok" } )
										elseif data2.login == "ON" and data2.ID == ID then 
											removerTelaLoginParaAcessoAutomatico()
											realizarLoginAposVerificacaoDeAcesso()
										end
									elseif varGlobais.restricaoLivro == "R" then
									
										if data2.status and data2.status == "P" then
										
											if not data2.ID or data2.login == "OFF" then
											
												local parameters = {}
												parameters.body = "logarID&livro_id=" .. varGlobais.idLivro0 .. "&usuario_id=" .. varGlobais.idAluno0 .. "&ID="..ID
												local URL = "https://omniscience42.com/EAudioBookDB/verificarPermissaoAcessoLivro.php"
												network.request(URL, "POST", function()end,parameters) -- baixando base de dados completa
											elseif data2.login == "ON" and data2.ID == ID then 
												removerTelaLoginParaAcessoAutomatico()
												realizarLoginAposVerificacaoDeAcesso()
											elseif data2.login == "ON" and data2.ID ~= ID then 
												if grupoTravarTela then
													grupoTravarTela:removeSelf()
												end
												local alert = native.showAlert( "Seu acesso foi negado!", "A sua conta já está logada em outro aparelho. Deslogue sua conta do aparelho anterior ou contate o suporte!", { "Ok" } )
												botaoLogin.isVisible = true
												campoLogin.isVisible = true
												campoSenha.isVisible = true
											end
										
										elseif data2.status and data2.status == "N" then
											local alert = native.showAlert( "Seu acesso foi negado!", "Verifique com o resposável para receber mais informações sobre a restrição do seu acesso ao livro", { "Ok" } )
											if auxFuncs.fileExistsDoc("nomeEfetuado.txt") then
												os.remove(system.pathForFile("nomeEfetuado.txt",system.DocumentsDirectory))
												varGlobais.NomeLogin0 = nil
											end
											if auxFuncs.fileExistsDoc("emailEfetuado.txt") then
												os.remove(system.pathForFile("emailEfetuado.txt",system.DocumentsDirectory))
												varGlobais.EmailLogin0 = nil
											end
											if auxFuncs.fileExistsDoc("loginEfetuado.txt") then
												os.remove(system.pathForFile("loginEfetuado.txt",system.DocumentsDirectory))
												varGlobais.Login0 = nil
											end
											if auxFuncs.fileExistsDoc("idAlunoEfetuado.txt") then
												os.remove(system.pathForFile("idAlunoEfetuado.txt",system.DocumentsDirectory))
												varGlobais.idAluno0 = nil
											end
											if auxFuncs.fileExistsDoc("apelidoEfetuado.txt") then
												os.remove(system.pathForFile("apelidoEfetuado.txt",system.DocumentsDirectory))
												varGlobais.apelidoAluno0 = nil
											end
											if not data2.ID then
												local ID = system.getInfo( "deviceID" )
											
												local parameters = {}
												parameters.body = "deslogar&livro_id=" .. varGlobais.idLivro0 .. "&usuario_id=" .. varGlobais.idAluno0
												local URL = "https://omniscience42.com/EAudioBookDB/verificarPermissaoAcessoLivro.php"
												network.request(URL, "POST", function()end,parameters) -- baixando base de dados completa
											end
											botaoLogin.isVisible = true
											campoLogin.isVisible = true
											campoSenha.isVisible = true
										end
									end
								end
							else
								removerTelaLoginParaAcessoAutomatico()
								realizarLoginAposVerificacaoDeAcesso()
							end
						end
					end
					timer.performWithDelay(500,function()
						local parameters = {}
						parameters.body = "livro_id=" .. varGlobais.idLivro0 .. "&usuario_id=" .. varGlobais.idAluno0
						local URL = "https://omniscience42.com/EAudioBookDB/verificarPermissaoAcessoLivro.php"
						network.request(URL, "POST", verificarRestricaoAluno,parameters) 
					end,1)
				else
					-- verificar se tem arquivo de login --
					timer.performWithDelay(100,function()
					if varGlobais.vetorAndroidLogin and varGlobais.vetorAndroidLogin.login then
						-- verificar se o login tem permissão --
					
						local function criarArquivoTXT(arquivo,texto) -- vetor ou variavel
							local caminho = system.pathForFile(arquivo,system.DocumentsDirectory)
							local file, errorString = io.open( caminho, "w" )
							if not file then
								print( "File error: " .. errorString )
							else
								file:write(texto)
								io.close( file )
							end
							file = nil
						end
						local parameters = {}
						local function realizarLoginAposVerificacaoDeAcesso()
							criarArquivoTXT("loginEfetuado.txt",varGlobais.Login0)
							criarArquivoTXT("emailEfetuado.txt",varGlobais.EmailLogin0)
							criarArquivoTXT("nomeEfetuado.txt",varGlobais.NomeLogin0)
							criarArquivoTXT("idAlunoEfetuado.txt",varGlobais.idAluno0)
							criarArquivoTXT("apelidoEfetuado.txt",varGlobais.apelidoAluno0)
					
							local grupoTravarTela = display.newGroup()
							local telaPreta = display.newRect(0,0,W,H)
							telaPreta.anchorX = 0.5; telaPreta.anchorY = 0.5
							telaPreta.anchorX = 0.5; telaPreta.anchorY = 0.5
							telaPreta.x = W/2; telaPreta.y = H/2
							telaPreta.x = W/2; telaPreta.y = H/2
							telaPreta:setFillColor(1,1,1)
							telaPreta.alpha=0.9
							telaPreta:addEventListener("tap",function() return true end)
							telaPreta:addEventListener("touch",function() return true end)
							local texto = display.newText("aguarde",W/2,H/2,"Fontes/segoeuib.ttf",50)
							texto:setFillColor(0,0,0)
							grupoTravarTela:insert(telaPreta)
							grupoTravarTela:insert(texto)
							toqueHabilitado = false
							campoLogin.isVisible = false
							campoSenha.isVisible = false
					
						
							timer.performWithDelay(500,AposLogin,1)
							timer.performWithDelay(1000,function() grupoTravarTela:removeSelf()end,1)
						end
						local function removerTelaLoginParaAcessoAutomatico()
							while grupoLogin.numChildren > 0 do
								local child = grupoLogin[1]
								if child then child:removeSelf() end
								print("grupoLogin.numChildren" , grupoLogin.numChildren )
							end
					
							if varGlobais.temHistorico == true and auxFuncs.fileExistsDoc("historico.txt") then
								--uploadHistorico("historico "..Login0 .. " " .. EmailLogin0 .. ".txt")
								local conteudo = auxFuncs.lerTextoDoc("historico.txt")
								RegistrarHistorico(conteudo)
							end
						end
						local function verificarRestricaoAluno(event)
							print("WARNING: verificando restrição aluno (Login Automático)")
							if ( event.isError ) then
								print( "Network error!")
								removerTelaLoginParaAcessoAutomatico()
								realizarLoginAposVerificacaoDeAcesso()
							else
								print(event.response)
								local data2 = json.decode(event.response)
						
								local ID = system.getInfo( "deviceID" )
								if data2 and data2.message then
									-- verificar paginas e questoes bloqueadas
									auxFuncs.verificarQuestoesEPaginasBloqueadas(data2)
							
									if data2.result == false then
										if grupoTravarTela then
											grupoTravarTela:removeSelf()
										end
										if varGlobais.restricaoLivro == "R" then
											local alert = native.showAlert( "Seu acesso foi negado!", "Seu login não está cadastrado para acessar esse livro. Contate seu vendedor para que seu login seja autorizado a acessá-lo.", { "Ok" } )
											botaoLogin.isVisible = true
											campoLogin.isVisible = true
											campoSenha.isVisible = true
										elseif varGlobais.restricaoLivro == "L" then -- PRIMEIRO LOGIN
											local parameters2 = {}
											parameters2.body = "livro_id=" .. varGlobais.idLivro0 .. "&usuario_id=" .. varGlobais.idAluno0 .. "&ID="..ID
											local URL2 = "https://omniscience42.com/EAudioBookDB/PrimeiroLoginLivro.php"
											network.request(URL2, "POST", function(event) print(event.response);print("||||||||||") end,parameters2) -- baixando base de dados completa
											removerTelaLoginParaAcessoAutomatico()
											realizarLoginAposVerificacaoDeAcesso()
										end
									elseif data2.result == true then
										if varGlobais.restricaoLivro == "L" then
											print("automático, Livre")
											print(data2.ID);print(data2.login)
											print(varGlobais.idLivro0,varGlobais.idAluno0,ID)
											if not data2.ID or data2.login == "OFF" then	
												local parameters = {}
												parameters.body = "logarID&livro_id=" .. varGlobais.idLivro0 .. "&usuario_id=" .. varGlobais.idAluno0 .. "&ID="..ID
												local URL = "https://omniscience42.com/EAudioBookDB/verificarPermissaoAcessoLivro.php"
												network.request(URL, "POST", function(event) print(event.response);print("||||||||||") end,parameters) -- avisando para a base de dados que o login foi efetuado
												removerTelaLoginParaAcessoAutomatico()
												realizarLoginAposVerificacaoDeAcesso()
											elseif data2.login == "ON" and data2.ID ~= ID then
												if grupoTravarTela then
													grupoTravarTela:removeSelf()
												end
												erroLoginDuplo(varGlobais.idLivro0,varGlobais.idAluno0)
												--local alert = native.showAlert( "Seu acesso foi negado!", "A sua conta já está logada em outro aparelho. Deslogue sua conta do aparelho anterior ou contate o suporte!", { "Ok" } )
											elseif data2.login == "ON" and data2.ID == ID then 
												removerTelaLoginParaAcessoAutomatico()
												realizarLoginAposVerificacaoDeAcesso()
											end
										elseif varGlobais.restricaoLivro == "R" then
									
											if data2.status and data2.status == "P" then
										
												if not data2.ID or data2.login == "OFF" then
											
													local parameters = {}
													parameters.body = "logarID&livro_id=" .. varGlobais.idLivro0 .. "&usuario_id=" .. varGlobais.idAluno0 .. "&ID="..ID
													local URL = "https://omniscience42.com/EAudioBookDB/verificarPermissaoAcessoLivro.php"
													network.request(URL, "POST", function()end,parameters) -- avisando para a base de dados que o login foi efetuado
													removerTelaLoginParaAcessoAutomatico()
													realizarLoginAposVerificacaoDeAcesso()
												elseif data2.login == "ON" and data2.ID == ID then 
													removerTelaLoginParaAcessoAutomatico()
													realizarLoginAposVerificacaoDeAcesso()
												elseif data2.login == "ON" and data2.ID ~= ID then 
													if grupoTravarTela then
														grupoTravarTela:removeSelf()
													end
													local alert = native.showAlert( "Seu acesso foi negado!", "A sua conta já está logada em outro aparelho. Deslogue sua conta do aparelho anterior ou contate o suporte!", { "Ok" } )
													botaoLogin.isVisible = true
													campoLogin.isVisible = true
													campoSenha.isVisible = true
												end
										
											elseif data2.status and data2.status == "N" then
												local alert = native.showAlert( "Seu acesso foi negado!", "Verifique com o resposável para receber mais informações sobre a restrição do seu acesso ao livro", { "Ok" } )
												if auxFuncs.fileExistsDoc("nomeEfetuado.txt") then
													os.remove(system.pathForFile("nomeEfetuado.txt",system.DocumentsDirectory))
													varGlobais.NomeLogin0 = nil
												end
												if auxFuncs.fileExistsDoc("emailEfetuado.txt") then
													os.remove(system.pathForFile("emailEfetuado.txt",system.DocumentsDirectory))
													varGlobais.EmailLogin0 = nil
												end
												if auxFuncs.fileExistsDoc("loginEfetuado.txt") then
													os.remove(system.pathForFile("loginEfetuado.txt",system.DocumentsDirectory))
													varGlobais.Login0 = nil
												end
												if auxFuncs.fileExistsDoc("idAlunoEfetuado.txt") then
													os.remove(system.pathForFile("idAlunoEfetuado.txt",system.DocumentsDirectory))
													varGlobais.idAluno0 = nil
												end
												if auxFuncs.fileExistsDoc("apelidoEfetuado.txt") then
													os.remove(system.pathForFile("apelidoEfetuado.txt",system.DocumentsDirectory))
													varGlobais.apelidoAluno0 = nil
												end
												if not data2.ID then
													local ID = system.getInfo( "deviceID" )
											
													local parameters = {}
													parameters.body = "deslogar&livro_id=" .. varGlobais.idLivro0 .. "&usuario_id=" .. varGlobais.idAluno0
													local URL = "https://omniscience42.com/EAudioBookDB/verificarPermissaoAcessoLivro.php"
													network.request(URL, "POST", function()end,parameters) -- baixando base de dados completa
												end
												botaoLogin.isVisible = true
												campoLogin.isVisible = true
												campoSenha.isVisible = true
											end
										end
									end
								else
									removerTelaLoginParaAcessoAutomatico()
									realizarLoginAposVerificacaoDeAcesso()
								end
							end
						end
						if auxFuncs.fileExists("idProprietario.txt") then
							varGlobais.idProprietario0 = lerTextoRes("idProprietario.txt")
							varGlobais.idProprietario0 = tonumber(varGlobais.idProprietario0)
						end
						if auxFuncs.fileExists("codigoLivro.txt") then
							varGlobais.codigoLivro0 = lerTextoRes("codigoLivro.txt")
						end
						if auxFuncs.fileExistsDoc  ("idLivro.txt") then
							varGlobais.idLivro0 = auxFuncs.lerTextoDoc("idLivro.txt")
						end
						varGlobais.Login0= varGlobais.vetorAndroidLogin.login
						varGlobais.EmailLogin0 = varGlobais.vetorAndroidLogin.email
						varGlobais.NomeLogin0 = varGlobais.vetorAndroidLogin.nome
						varGlobais.idAluno0 = varGlobais.vetorAndroidLogin.id
						varGlobais.apelidoAluno0 = varGlobais.vetorAndroidLogin.login
					
						parameters.body = "livro_id=" .. varGlobais.idLivro0 .. "&usuario_id=" .. varGlobais.idAluno0
						local URL = "https://omniscience42.com/EAudioBookDB/verificarPermissaoAcessoLivro.php"
						network.request(URL, "POST", verificarRestricaoAluno,parameters) 
					
					
					
					else -- senão voltar para a tela de login --
						botaoLogin.isVisible = true
						audio.stop()
						local som = audio.loadSound("audioTTS_mensagem inicial livro.mp3")
						--audio.play(som)
					end
				
					end,1)
				end
			end
			local function Logar(event)
				if event and event.phase == "began" then
					event.target.selecionado1 = true
					timer.performWithDelay(1000,function() event.target.selecionado1 = false end,1)
				elseif event.phase == "moved" then
					system.vibrate()
					audio.stop()
					local som = audio.loadSound("botaoEntrar.mp3")
					audio.play(som)
				
				elseif event.phase == "ended" and event.target and event.target.selecionado2 == false  then
					event.target.selecionado2 = true
					audio.stop()
					local som = audio.loadSound("botaoEntrar.mp3")
					audio.play(som)
					timer.performWithDelay(1000,function() event.target.selecionado2 = false end,1)
				elseif event.phase == "ended" then--and event.target.selecionado1 == true and event.target.selecionado2 == true  then	
					local function criarArquivoTXT(arquivo,texto) -- vetor ou variavel
						local caminho = system.pathForFile(arquivo,system.DocumentsDirectory)
						local file, errorString = io.open( caminho, "w" )
						if not file then
							print( "File error: " .. errorString )
						else
							file:write(texto)
							io.close( file )
						end
						file = nil
					end
					-- EFETUAR LOGIN com CRIPTOGRAFIA --------
			
					local grupoTravarTela = display.newGroup()
					local telaPreta = display.newRect(0,0,W,H)
					telaPreta.anchorX = 0.5; telaPreta.anchorY = 0.5
					telaPreta.anchorX = 0.5; telaPreta.anchorY = 0.5
					telaPreta.x = W/2; telaPreta.y = H/2
					telaPreta.x = W/2; telaPreta.y = H/2
					telaPreta:setFillColor(1,1,1)
					telaPreta.alpha=0.9
					telaPreta:addEventListener("tap",function() return true end)
					telaPreta:addEventListener("touch",function() return true end)
					local texto = display.newText("aguarde",W/2,H/2,"Fontes/segoeuib.ttf",50)
					texto:setFillColor(0,0,0)
					grupoTravarTela:insert(telaPreta)
					grupoTravarTela:insert(texto)
					toqueHabilitado = false	
				
					campoLogin.isVisible = false
					campoSenha.isVisible = false
			
					local json = require("json")
			
					function funcGlobais.loginCallback(event)
						if ( event.isError ) then
							print( "Network error!")
							grupoTravarTela:removeSelf()
							campoLogin.isVisible = true
							campoSenha.isVisible = true
							audio.stop()
							local som = audio.loadSound("audioTTS_falhaConexaoLogin.mp3")
							audio.play(som)
							--local alert = native.showAlert( "Erro de conexão","Verifique sua conexão com a internet e depois tente novamente!", { "Ok" }  )
						else
							local data = json.decode(event.response)
							local ID = system.getInfo( "deviceID" )
							if data and data.message then
								if data.result == false then
									audio.stop()
									if data.message == "Usuario invalido" then
										campoLogin.retangulo.alpha = 1
										campoSenha.retangulo.alpha = 0
										campoLogin.text = ""
									elseif data.message == "Senha invalida" then
										campoSenha.retangulo.alpha = 1
										campoLogin.retangulo.alpha = 0
										campoSenha.text = ""
									end
									native.setKeyboardFocus(nil)
									local som = audio.loadSound("audioTTS_contaSenhaIncorreto.mp3")
									audio.play(som)
									grupoTravarTela:removeSelf()
									campoLogin.isVisible = true
									campoSenha.isVisible = true
								elseif data.result == true then
									local function onComplete()

										print(event.response)
										varGlobais.Login0= data.login
										varGlobais.EmailLogin0 = data.email
										varGlobais.NomeLogin0 = data.nome
										varGlobais.idAluno0 = data.id
										varGlobais.apelidoAluno0 = data.login
										print("data.id = ",data.id)
										varGlobais.imagemAluno0 = data.avatar
										varGlobais.statusAluno0 = data.status
										criarArquivoTXT("loginEfetuado.txt",varGlobais.Login0)
										criarArquivoTXT("emailEfetuado.txt",varGlobais.EmailLogin0)
										criarArquivoTXT("nomeEfetuado.txt",varGlobais.NomeLogin0)
										criarArquivoTXT("idAlunoEfetuado.txt",varGlobais.idAluno0)
										criarArquivoTXT("apelidoEfetuado.txt",varGlobais.apelidoAluno0)
										criarArquivoTXT("codigoLivro.txt",varGlobais.codigoLivro0)
										criarArquivoTXT("idLivro.txt",varGlobais.idLivro0)
										native.setKeyboardFocus(nil)
										while grupoLogin.numChildren > 0 do
											local child = grupoLogin[1]
											if child then child:removeSelf() end
											print("grupoLogin.numChildren" , grupoLogin.numChildren )
										end
								
										AposLogin()
										timer.performWithDelay(1000,function() grupoTravarTela:removeSelf()end,1)
									end
							
									local function verificarRestricaoAluno(event)
										if ( event.isError ) then
											print( "Network error!")
											grupoTravarTela:removeSelf()
											campoLogin.isVisible = true
											campoSenha.isVisible = true
											local alert = native.showAlert( "Erro de conexão","Verifique sua conexão com a internet e depois tente novamente!", { "Ok" }  )
										else
											print(event.response)
											local data2 = json.decode(event.response)
									
											if data2 and data2.message then
												-- verificar paginas e questoes bloqueadas
												auxFuncs.verificarQuestoesEPaginasBloqueadas(data2)
												if data2.result == false then
													if varGlobais.restricaoLivro == "L" then
														--local alert = native.showAlert( data.message, "Login efetuado com sucesso!", { "Ok" } , onComplete )
														audio.stop()
														local som = audio.loadSound("audioTTS_entrando no livro.mp3")
														audio.play(som,{onComplete = onComplete})
														local parameters = {}
														print("chegou aqui1",varGlobais.idLivro0,varGlobais.idAluno0,ID)
														parameters.body = "livro_id=" .. varGlobais.idLivro0 .. "&usuario_id=" .. data.id .. "&ID="..ID
														local URL = "https://omniscience42.com/EAudioBookDB/PrimeiroLoginLivro.php"
														network.request(URL, "POST", function() print(event.response);print("||||||||||") end,parameters) -- baixando base de dados completa
													elseif varGlobais.restricaoLivro == "R" then
														local alert = native.showAlert( "",data2.message, { "Ok" }  )
														grupoTravarTela:removeSelf()
														campoLogin.isVisible = true
														campoSenha.isVisible = true
													end
												elseif data2.result == true then
											
													if varGlobais.restricaoLivro == "L" then
														if not data2.ID or data2.login == "OFF" then
															local parameters = {}
															parameters.body = "logarID&livro_id=" .. varGlobais.idLivro0 .. "&usuario_id=" .. data.id .. "&ID="..ID
															local URL = "https://omniscience42.com/EAudioBookDB/verificarPermissaoAcessoLivro.php"
															network.request(URL, "POST", function()
																--local alert = native.showAlert( data.message, "Login efetuado com sucesso!", { "Ok" } , onComplete )
																audio.stop()
																local som = audio.loadSound("audioTTS_entrando no livro.mp3")
																audio.play(som,{onComplete = onComplete})
															end,
															parameters) -- baixando base de dados completa
														elseif data2.login == "ON" and data2.ID == ID then 
															--local alert = native.showAlert( data.message, "Login efetuado com sucesso!", { "Ok" } , onComplete )
															audio.stop()
															local som = audio.loadSound("audioTTS_entrando no livro.mp3")
															audio.play(som,{onComplete = onComplete})
														elseif data2.login == "ON" and data2.ID ~= ID then 
															if grupoTravarTela then
																grupoTravarTela:removeSelf()
															end
															campoLogin.isVisible = true
															campoSenha.isVisible = true
															varGlobais.idAluno0 = data.id
															erroLoginDuplo(varGlobais.idLivro0,data.id)
															--local alert = native.showAlert( "Seu acesso foi negado!", "A sua conta já está logada em outro aparelho. Deslogue sua conta do aparelho anterior ou contate o suporte!", { "Ok" } )
														end
														print("chegou aqui2",varGlobais.idLivro0,varGlobais.idAluno0,ID)
												
													elseif varGlobais.restricaoLivro == "R" then
														if data2.status and data2.status == "P" then
															--local alert = native.showAlert( data.message, "Login efetuado com sucesso!", { "Ok" } , onComplete )
															audio.stop()
															local som = audio.loadSound("audioTTS_entrando no livro.mp3")
															audio.play(som,{onComplete = onComplete})
														elseif data2.status and data2.status == "N" then
															local alert = native.showAlert( "Seu acesso foi negado!", "Verifique com o resposável para receber mais informações sobre a restrição do seu acesso ao livro", { "Ok" } )
															grupoTravarTela:removeSelf()
															campoLogin.isVisible = true
															campoSenha.isVisible = true
														end
													end
												end
											else
												local alert = native.showAlert( "Falha na conexão", "Verifique sua conexão com a internet.", { "Ok" }  )
												grupoTravarTela:removeSelf()
												campoLogin.isVisible = true
												campoSenha.isVisible = true
											end
										end
									end
									local parameters = {}
									if not varGlobais.idLivro0 then
										preferenciasGerais = varGlobais.lerPreferenciasAutor()
									end
									parameters.body = "livro_id=" .. varGlobais.idLivro0 .. "&usuario_id=" .. data.id
									local URL = "https://omniscience42.com/EAudioBookDB/verificarPermissaoAcessoLivro.php"
									network.request(URL, "POST", verificarRestricaoAluno,parameters) -- baixando base de dados completa
							
							
								end
							else
								--local alert = native.showAlert( "Falha na conexão", "Verifique sua conexão com a internet.", { "Ok" }  )
								audio.stop()
								local som = audio.loadSound("audioTTS_falhaConexaoLogin.mp3")
								audio.play(som)
								grupoTravarTela:removeSelf()
								campoLogin.isVisible = true
								campoSenha.isVisible = true
							end
						end
						return true
					end
					------------------------------------------
					local usuario = campoLogin.text
					local password = campoSenha.text
					if usuario ~= nil and usuario ~= "" then
						if password ~= nil then
							parameters3 = {}
							if password == "" then
								parameters3.body = "login=" .. mime.b64(usuario) .. "&senha=" .. ""
							else
								parameters3.body = "login=" .. mime.b64(usuario) .. "&senha=" .. mime.b64(password)
							end
							local URL3 = "https://omniscience42.com/EAudioBookDB/login.php"
							network.request(URL3, "POST", funcGlobais.loginCallback,parameters3) -- baixando base de dados completa
						else
							audio.stop()
							local som = audio.loadSound("audioTTS_campoVazioContaSenha.mp3")
							audio.play(som)
							--local alert = native.showAlert( "Atenção", "Coloque uma senha antes de prosseguir.", { "Ok" }  )
							grupoTravarTela:removeSelf()
							campoLogin.isVisible = true
							campoSenha.isVisible = true
						end
					else
						audio.stop()
						local som = audio.loadSound("audioTTS_campoVazioContaSenha.mp3")
						audio.play(som)
						--local alert = native.showAlert( "Atenção", "Preencha o campo login antes de prosseguir.", { "Ok" }  )
						grupoTravarTela:removeSelf()
						campoLogin.isVisible = true
						campoSenha.isVisible = true
					end
				end
			end
		
			botaoLogin = widget.newButton{
					defaultFile = "loginUp.png",
					overFile = "loginDown.png",
					onEvent = Logar,
					width = 480,
					height = 122,

			} 
			botaoLogin.anchorX=.5
			botaoLogin.anchorY=.5
			botaoLogin.y = 525
			botaoLogin.x = W/2
			botaoLogin.isVisible = false
			botaoLogin.contentDescription = "Botão Entrar"
			botaoLogin.selecionado1 = false
			botaoLogin.selecionado2 = false
			grupoLogin:insert(botaoLogin)
						

						
			local options = {text = "esqueci minha senha!",
							 x = botaoLogin.x,
							 y = botaoLogin.y + botaoLogin.height/2 + 10,
							 font = "Fontes/segoeui.ttf",
							 size = 40,
							 align = "center"}
			local textoPedirSenha = display.newText(options)
			textoPedirSenha.y = textoPedirSenha.y + textoPedirSenha.height/2
			textoPedirSenha:setFillColor(.9,0,0)
			textoPedirSenha.isVisible = true
			grupoLogin:insert(textoPedirSenha)
			local function janelaPedirNovaSenha()
				campoLogin.isVisible = false
				campoSenha.isVisible = false
				local grupoPedir = display.newGroup()
				local function removerGrupo()
					grupoPedir:removeSelf()
					grupoPedir = nil
					campoLogin.isVisible = true
					campoSenha.isVisible = true
				end
				local telaRemovedora = display.newRect(grupoPedir,W/2,H/2,W,H)
				telaRemovedora:addEventListener("touch",function() return true end)
				telaRemovedora:addEventListener("tap",removerGrupo)
				telaRemovedora.alpha = .8
				telaRemovedora:setFillColor(0,0,0)
				telaRemovedora.isHitTestable = true
			
				local retanguloPedido = display.newRoundedRect(1,1,1,1,20)
				grupoPedir:insert(retanguloPedido)
			
				local campoEmail = native.newTextField(W/2, H/3, W/1.565, H/17.2)
				campoEmail.placeholder = "E-mail cadastrado"
				campoEmail.size = H/34
				campoEmail.align = "center"
				grupoPedir:insert(campoEmail)
				local botaoCancelar
				local botaoConfirmar
				local function criarEenviarNovaSenha(e)
					if botaoCancelar then
						e.target:setEnabled( false )
						botaoCancelar:setEnabled( false )
					end
					local function cadastroListener(event)
						print("|"..tostring(event.response).."|")
						if ( event.isError ) then
							  --local alert = native.showAlert( "Network Error . Check Connection", "Connect to Internet", { "Try again" }  )
							  print("Network Error . Check Connection", "Connect to Internet")
						else
							if string.find(event.response,"Email nao enviado") then
								native.showAlert("Envio não sucedido","Não foi possivel enviar o e-mail para o endereço requisitado neste momento, tente novamente mais tarde",{"ok"})
								print(event.response)
							elseif string.find(event.response,"Email enviado") then
								print(event.response)
								native.showAlert("Sucesso","Uma nova senha foi enviada para seu e-mail, copie a nova senha e entre novamente com o seu login.",{"OK"})
								removerGrupo()
							elseif string.find(event.response,"Email nao encontrado") then
								print(event.response)
								native.showAlert("E-mail inválido","Não foi possivel enviar o e-mail para o endereço requisitado,  o e-mail utilizado está incorreto ou não está cadastrado no sistema.",{"ok"})
							else
								print(event.response)
								native.showAlert("Erro de conexão","Sua conexão com a internet está instável. Favor verificar antes de tentar novamente",{"OK"})
							end
						end
						if botaoCancelar then
							e.target:setEnabled( true )
							botaoCancelar:setEnabled( true )
						end
					end
				
					local function random_str(length,keyspace)
						local str = ''
						for i = 0,length do
							local n = math.random(1,#keyspace)
							local letra = string.sub(keyspace,n,n)
							str = str..letra
						end
						return str;
					end
					local vetorJson = {}
					vetorJson.tipoDeAcesso = "mudarSenha"
					vetorJson.toMail = campoEmail.text
					local keyspace = '0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ!@$#%&_,'
					local senhaNova = random_str(math.random(8,12),keyspace)
					print("SENHA NOVA = ",senhaNova)
					vetorJson.novaSenha = senhaNova
				
					local headers = {}
					headers["Content-Type"] = "application/json"
					local parameters = {}
					parameters.headers = headers
					local data = json.encode(vetorJson)

					parameters.body = data
				
					local URL = "https://omniscience42.com/EAudioBookDB/sendMail.php" --mongo.php"
					network.request(URL, "POST", cadastroListener,parameters)
				end
				botaoConfirmar = widget.newButton {
					shape = "roundedRect",
					fillColor = {default={ 0.18, 0.67, 0.785, 1 },over={ 0.004, 0.368, 0.467, .5 }},
					width = 230,
					height = 60,
					label = "Enviar",
					fontSize = 40,
					strokeWidth = 3,
					font = "Fontes/timesbd.ttf",
					strokeColor = { default={ 0, 0, 0, .1 }, over={ 1, 1, 1, 1 } },
					labelColor = { default={ 0, 0, 0, 1 }, over={ 1, 1, 1, 1 } },
					onRelease = criarEenviarNovaSenha
				}
				botaoConfirmar.anchorX=0
				botaoConfirmar.y = campoEmail.y + 100 + campoEmail.height/2
				botaoConfirmar.x = campoEmail.x + 10
				grupoPedir:insert(botaoConfirmar)
			
				botaoCancelar = widget.newButton {
					shape = "roundedRect",
					fillColor = {default={ 177/255,6/255,15/255, 1 },over={ 229/255,9/255,19/255,0.5 }},
					width = 230,
					height = 60,
					label = "Cancelar",
					fontSize = 40,
					strokeWidth = 3,
					font = "Fontes/timesbd.ttf",
					strokeColor = { default={ 0, 0, 0, .1 }, over={ 1, 1, 1, 1 } },
					labelColor = { default={ 1, 1, 1, 1 }, over={ 0, 0, 0, 1 } },
					onRelease = removerGrupo
				}
				botaoCancelar.anchorX=1
				botaoCancelar.y = campoEmail.y + 100 + campoEmail.height/2
				botaoCancelar.x = campoEmail.x - 10
				grupoPedir:insert(botaoCancelar)
			
				retanguloPedido.x = campoEmail.x
				retanguloPedido.y = campoEmail.y + campoEmail.height/2 + 50
				retanguloPedido.height = 400
				retanguloPedido.width = 550
				retanguloPedido:setFillColor(1,1,1)
				retanguloPedido.strokeWidth = 1
				retanguloPedido:addEventListener("tap",function() return true end)
				retanguloPedido:addEventListener("touch",function() return true end)
			end
			textoPedirSenha:addEventListener("tap",janelaPedirNovaSenha)

		
			local function TeladeRegistro(event)
				if event.phase == "moved" then
					system.vibrate()
					audio.stop()
					local som = audio.loadSound("botaoRegistro.mp3")
					audio.play(som)
				elseif event.phase == "ended" then
					campoLogin.isVisible = false
					campoSenha.isVisible = false
		
					local grupoTelaRegistro = display.newGroup()
			
					local telaPreta = display.newRect(0,0,W,H)
					telaPreta.anchorX = 0.5; telaPreta.anchorY = 0.5
					telaPreta.anchorX = 0.5; telaPreta.anchorY = 0.5
					telaPreta.x = W/2; telaPreta.y = H/2
					telaPreta.x = W/2; telaPreta.y = H/2
					telaPreta:setFillColor(1,1,1)
					telaPreta.alpha=0.98
					telaPreta:addEventListener("tap",function() return true end)
					telaPreta:addEventListener("touch",function() return true end)
					grupoTelaRegistro:insert(telaPreta)
			
					local tamanhoLabels = 30
					local Ytudo = H/25.6
					local labelsX = W/4.8
					local camposX = W/1.7
					local camposH = H/32
					local camposW = W/2.06
					local cor = {0,0,0}
					local fonte = "Fontes/paolaAccent.ttf"
					local optionsGeral = {text = "",y = H/2,parent = grupoTelaRegistro,x= labelsX,align = "center",width = W/4,fontSize = tamanhoLabels,font = fonte}
			
					local title = display.newText(grupoTelaRegistro, "Ficha de Registro", W/2.0571, H/15, fonte, 50)
					title:setTextColor( 0.18, 0.67, 0.785, 1 )
					optionsGeral.text = "Nome Completo";optionsGeral.y = H/6.4+Ytudo
					local nameLabel = display.newText(optionsGeral)
					nameLabel:setTextColor(cor)
					local LoginLabel = display.newText(grupoTelaRegistro, "Login", labelsX, H/4.2666+Ytudo, fonte, tamanhoLabels)
					LoginLabel:setTextColor(cor)
					local senhaLabel = display.newText(grupoTelaRegistro, "Senha", labelsX, H/3.20+Ytudo, fonte, tamanhoLabels)
					senhaLabel:setTextColor(cor)
					optionsGeral.text = "Confirmar Senha";optionsGeral.y = H/2.56+Ytudo
					local confirmarsenhaLabel = display.newText(optionsGeral)
					confirmarsenhaLabel:setTextColor(cor)
					local emailLabel = display.newText(grupoTelaRegistro, "e-mail", labelsX, H/2.133+Ytudo, fonte, tamanhoLabels)
					emailLabel:setTextColor(cor)
			
					local borda = 2
					local CC = {}
					local FundoNomedoCliente = display.newRoundedRect(camposX, nameLabel.y,0,0,5)
					FundoNomedoCliente.height = camposH + 5;FundoNomedoCliente.width = camposW + 10
					FundoNomedoCliente.stroke = { 0.18, 0.67, 0.785, 1 }
					FundoNomedoCliente.strokeWidth = borda
					grupoTelaRegistro:insert(FundoNomedoCliente)
					local FundoLogindoCliente = display.newRoundedRect(camposX, LoginLabel.y,0,0,5)
					FundoLogindoCliente.height = camposH + 5;FundoLogindoCliente.width = camposW + 10
					FundoLogindoCliente.stroke = { 0.18, 0.67, 0.785, 1 }
					FundoLogindoCliente.strokeWidth = borda
					grupoTelaRegistro:insert(FundoLogindoCliente)
					local FundoSenhadoCliente = display.newRoundedRect(camposX, senhaLabel.y,0,0,5)
					FundoSenhadoCliente.height = camposH + 5;FundoSenhadoCliente.width = camposW + 10
					FundoSenhadoCliente.stroke = { 0.18, 0.67, 0.785, 1 }
					FundoSenhadoCliente.strokeWidth = borda
					grupoTelaRegistro:insert(FundoSenhadoCliente)
					FundoCFdoCliente = display.newRoundedRect(camposX, confirmarsenhaLabel.y,0,0,5)
					FundoCFdoCliente.height = camposH + 5;FundoCFdoCliente.width = camposW + 10
					FundoCFdoCliente.stroke = { 0.18, 0.67, 0.785, 1 }
					FundoCFdoCliente.strokeWidth = borda
					grupoTelaRegistro:insert(FundoCFdoCliente)
					local FundoEmaildoCliente = display.newRoundedRect(camposX, emailLabel.y,0,0,5)
					FundoEmaildoCliente.height = camposH + 5;FundoEmaildoCliente.width = camposW + 10
					FundoEmaildoCliente.stroke = { 0.18, 0.67, 0.785, 1 }
					FundoEmaildoCliente.strokeWidth = borda
					grupoTelaRegistro:insert(FundoEmaildoCliente)
			
					CC.NomedoCliente = native.newTextField(camposX, nameLabel.y, camposW, camposH)
					CC.NomedoCliente.hasBackground = false
					grupoTelaRegistro:insert(CC.NomedoCliente)
					CC.LogindoCliente = native.newTextField(camposX, LoginLabel.y, camposW, camposH)
					CC.LogindoCliente.hasBackground = false
					grupoTelaRegistro:insert(CC.LogindoCliente)
					CC.SenhadoCliente = native.newTextField(camposX, senhaLabel.y, camposW, camposH)
					CC.SenhadoCliente.hasBackground = false
					grupoTelaRegistro:insert(CC.SenhadoCliente)
					CC.SenhadoCliente.isSecure = true
					CC.CFdoCliente = native.newTextField(camposX, confirmarsenhaLabel.y, camposW, camposH)
					CC.CFdoCliente.hasBackground = false
					grupoTelaRegistro:insert(CC.CFdoCliente)
					CC.CFdoCliente.isSecure = true
					CC.EmaildoCliente = native.newTextField(camposX, emailLabel.y, camposW, camposH)
					CC.EmaildoCliente.hasBackground = false
					grupoTelaRegistro:insert(CC.EmaildoCliente)
			
					local function submitCadastro_function(event)
						local function cadastroListener( event )
							if ( event.isError ) then
								  local alert = native.showAlert( "Network Error . Check Connection", "Connect to Internet", { "Try again" }  )
								  print(event.response)
							else
								print("|"..event.response.."|"..type(event.response).."|")
								if event.response == "1" then
									local alert = native.showAlert( "Cadastrando no banco de dados", "Resultado: Sucesso", { "Ok" } )
									grupoTelaRegistro:removeSelf();
									campoLogin.isVisible = true;
									campoSenha.isVisible = true
								else
									local alert = native.showAlert( "Erro ao Cadastrar", event.response, { "Try again" }  )
								end
							end
						end
						if (CC.SenhadoCliente.text == CC.CFdoCliente.text) then
							parameters = {}
							parameters.body = "Register=1&nome=" .. CC.NomedoCliente.text .. "&login=" .. CC.LogindoCliente.text .. "&senha=" .. CC.SenhadoCliente.text .. "&email="..CC.EmaildoCliente.text
							local URL2 = "https://omniscience42.com/EAudioBookDB/cadastrar.php"
							network.request(URL2, "POST", cadastroListener,parameters)
						else
							native.showAlert("As senhas não são iguais!","Verifique sua senha e tente novamente!",{"OK"})
						end
					end
			
					local addButton_Cadastro = widget.newButton{
						shape = "roundedRect",
						onRelease = submitCadastro_function,
						fillColor = { default={ 0.18, 0.67, 0.785, 1 }, over={ 0.004, 0.368, 0.467, .5 } },
						width = W/2.5,
						height = H/15,
						label = "Confirmar",
						fontSize = 50,
						x = W/2,
						y = CC.EmaildoCliente.y + CC.EmaildoCliente.height/2 + H/30 + 50,
						strokeWidth = 4,
						strokeColor = { default={ 0, 0, 0, .1 }, over={ 1, 1, 1, 1 } },
						labelColor = { default={ 1, 1, 1, 1 }, over={ 0, 0, 0, 1 } },
					}	
					grupoTelaRegistro:insert(addButton_Cadastro)
			
					local backButton = widget.newButton {
						shape = "roundedRect",
						fillColor = { default={ 0.18, 0.67, 0.785, 1 }, over={ 0.004, 0.368, 0.467, 1 } },
						width = 250,
						height = 75,
						label = "voltar",
						fontSize = 50,
						strokeWidth = 4,
						labelColor = { default={ 0, 0, 0, 1 }, over={ 1, 1, 1, 1 } },
						onRelease = function()grupoTelaRegistro:removeSelf();campoLogin.isVisible = true;campoSenha.isVisible = true;end
					}
					backButton.x = addButton_Cadastro.x
					backButton.y = addButton_Cadastro.y + addButton_Cadastro.height/2 + backButton.height/2 + 50
			
					grupoTelaRegistro:insert(backButton)
				end
			end
			local function TeladeRegistro2(event)
			
				if event and event.phase == "began" then
					event.target.selecionado1 = true
					timer.performWithDelay(1000,function() event.target.selecionado1 = false end,1)
				elseif event and event.phase == "moved" then
					system.vibrate()
					audio.stop()
					local som = audio.loadSound("botaoRegistro.mp3")
					audio.play(som)
				elseif event.phase == "ended" and event.target and event.target.selecionado2 == false  then
					event.target.selecionado2 = true
					audio.stop()
					local som = audio.loadSound("botaoRegistro.mp3")
					audio.play(som)
					timer.performWithDelay(1000,function() event.target.selecionado2 = false end,1)
				elseif event.phase == "ended" and event.target.selecionado1 == true and event.target.selecionado2 == true  then
					audio.stop()
					campoLogin.isVisible = false
					campoSenha.isVisible = false
					local function novoCampoDeTexto(funcao,texto,texto2)
					
						local grupo = display.newGroup()
						local options = {text = texto2,align="center",x=W/2,y=100,fontSize=40,width=550,font="Fontes/ariblk.ttf"}
						if texto == "FINALIZAR" then
							options.align = "left"
							options.fontSize = 30
							options.x = 60
							options.width = 600
						end
						local textoExplanativo = display.newText(options)
						textoExplanativo.anchorY=0
						local arquivosom = "audioTTS_botaoContinuar.mp3"

						if texto == "FINALIZAR" then
							textoExplanativo.anchorX=0
							arquivosom = "audioTTS_finalizar_cadastro.mp3"
						end
						textoExplanativo:setFillColor(0,0,0)
						--audioTTS_CampoLocalizou.mp3
						grupo.campo = native.newTextField(W/2,textoExplanativo.y + textoExplanativo.height + 35 + 20,540,70)
						grupo.campoFundo = display.newRect(grupo.campo.x,grupo.campo.y,grupo.campo.width,grupo.campo.height)
						local function lerCampo(event)
							if event.phase == "moved" or event.phase == "began" then
								system.vibrate()
								--audio.stop()
								--local som = audio.loadSound("audioTTS_CampoLocalizou.mp3")
								--audio.play(som)
							end
							if event.phase == "submitted"  then
								funcao(e)
							end
						end
						grupo.campoFundo:addEventListener("touch",lerCampo)
						native.setKeyboardFocus( grupo.campo )
						if texto == "FINALIZAR" then
							native.setKeyboardFocus( nil )
						end
						grupo.campo:addEventListener("userInput",lerCampo)
						local function lerBotao(e)
							if e.phase == "began" then
								event.target.selecionado1 = true
								audio.stop()
								local som = audio.loadSound(arquivosom)
								audio.play(som)
								timer.performWithDelay(1000,function() event.target.selecionado1 = false end,1)
							elseif e.phase == "moved" then
								system.vibrate()
								audio.stop()
								local som = audio.loadSound(arquivosom)
								audio.play(som)
							elseif event.phase == "ended" and event.target and event.target.selecionado2 == false  then
								event.target.selecionado2 = true
								audio.stop()
								local som = audio.loadSound(arquivosom)
								audio.play(som)
								timer.performWithDelay(1000,function() event.target.selecionado2 = false end,1)
							elseif event.phase == "ended" and event.target.selecionado1 == true and event.target.selecionado2 == true  then
								funcao(e)
							end
						end
						local tamanhoFonte = 40
						local tamanhoBotaoY = 50
						local tamanhoBotaoX = 275
						if texto == "FINALIZAR" then
							tamanhoFonte = 60
							tamanhoBotaoY = 70
							tamanhoBotaoX = 350
						end
						grupo.botaoConfirma = widget.newButton{
							shape = "rect",
							fillColor = { default={ 0.18, 0.67, 0.785, 1 }, over={ 0.004, 0.368, 0.467, .5 } },
							width = tamanhoBotaoX,
							height = tamanhoBotaoY,
							label = texto,
							fontSize = tamanhoFonte,
							strokeWidth = 5,
							font = "Fontes/timesbd.ttf",
							strokeColor = { default={ 0, 0, 0, .1 }, over={ 1, 1, 1, .5 } },
							labelColor = { default={ 0, 0, 0, 1 }, over={ 1, 1, 1, 1 } },
							onEvent = lerBotao
						}
						grupo.botaoConfirma.selecionado1 = false
						grupo.botaoConfirma.selecionado2 = false
						grupo.botaoConfirma.x = W/2 + grupo.botaoConfirma.width/2
						grupo.botaoConfirma.y = grupo.campo.y + grupo.campo.height/2 + grupo.botaoConfirma.height/2 + 20
						if texto == "FINALIZAR" then
							grupo.botaoConfirma.x = W/2
							grupo.botaoConfirma.anchorY = 1
							grupo.botaoConfirma.y = H - 150
						end
					
					
						grupo:insert(textoExplanativo)
						grupo:insert(grupo.campo)
						grupo:insert(grupo.campoFundo)
						grupo:insert(grupo.botaoConfirma)
						if texto == "FINALIZAR" then
							grupo.campo:removeSelf()
							grupo.campoFundo:removeSelf()
							grupo.campo = nil
							grupo.campoFundo = nil
						end
					
						return grupo
					end
				
					local vetorTelaAtual = {}
					vetorTelaAtual.dados = {}
					local grupoRegistro = display.newGroup()
					local TelaBranca = display.newRect(grupoRegistro,W/2,H/2,W,H)
					TelaBranca:setFillColor(1,1,1)
					TelaBranca:addEventListener("tap",function() return true end)
					TelaBranca:addEventListener("touch",function() return true end)
					function vetorTelaAtual.cancelarRegistro()
						grupoRegistro:removeSelf()
						grupoRegistro=nil
						campoLogin.isVisible = true
						campoSenha.isVisible = true
					end
					local function lerBotaoVoltar(event)
						if event.phase == "began" then
							event.target.selecionado1 = true
							audio.stop()
							local som = audio.loadSound("audioTTS_botaoVoltar.mp3")
							audio.play(som)
							timer.performWithDelay(1000,function() event.target.selecionado1 = false end,1)
						elseif event.phase == "moved" then
							system.vibrate()
							audio.stop()
							local som = audio.loadSound("audioTTS_botaoVoltar.mp3")
							audio.play(som)
						elseif event.phase == "ended" and event.target and event.target.selecionado2 == false  then
							event.target.selecionado2 = true
							audio.stop()
							local som = audio.loadSound("audioTTS_botaoVoltar.mp3")
							audio.play(som)
							timer.performWithDelay(1000,function() event.target.selecionado2 = false end,1)
						elseif event.phase == "ended" and event.target.selecionado1 == true and event.target.selecionado2 == true  then
							vetorTelaAtual.cancelarRegistro(e)
							audio.stop()
							local som = audio.loadSound("audioTTS_telaInicial.mp3")
							audio.play(som)
						end
					end
					local botaoVoltar = widget.newButton{
						shape = "rect",
						fillColor = { default={ 192/255, 0, 0, 1 }, over={ 168/255, 0, 0, 1 } },
						width = 225,
						height = 60,
						label = "<  Voltar",
						fontSize = 50,
						strokeWidth = 2,
						font = "Fontes/timesbd.ttf",
						strokeColor = { default={ 0, 0, 0, .1 }, over={ 1, 1, 1, .5 } },
						labelColor = { default={ 0, 0, 0, 1 }, over={ 1, 1, 1, 1 } },
						onEvent = lerBotaoVoltar
					}
					botaoVoltar.selecionado1 = false
					botaoVoltar.selecionado2 = false
					botaoVoltar.anchorX=0;botaoVoltar.anchorY=0
					botaoVoltar.x=10
					botaoVoltar.y=10
					grupoRegistro:insert(botaoVoltar)
				
				
					function vetorTelaAtual.tocarSom(audio1)
						audio.stop()
						local som = audio.loadSound(audio1)
						audio.play(som)
					end
					function vetorTelaAtual.mostrarTelaNome()
						local function aposConfirmar()
							vetorTelaAtual.dados.nome = vetorTelaAtual.atual.campo.text
							if vetorTelaAtual.atual.campo.text and #vetorTelaAtual.atual.campo.text > 0 then
								vetorTelaAtual.mostrarTelaApelido()
							else
								audio.stop()
								local som = audio.loadSound("audioTTS_0_campoVazio.mp3")
								audio.play(som)
							end
						end
					
						if vetorTelaAtual.atual then vetorTelaAtual.atual:removeSelf();vetorTelaAtual.atual=nil end
						vetorTelaAtual.atual = novoCampoDeTexto(aposConfirmar,"CONTINUAR","NOME COMPLETO")
						vetorTelaAtual.tocarSom("audioTTS_0_nome.mp3")
						grupoRegistro:insert(vetorTelaAtual.atual)
					end
					function vetorTelaAtual.mostrarTelaApelido()
						local function aposConfirmar()
							vetorTelaAtual.dados.apelido = vetorTelaAtual.atual.campo.text
							local function requestListener(event)
								if ( event.isError ) then
									audio.stop()
									local som = audio.loadSound("audioTTS_6_falhaConexao.mp3")
									audio.play(som)
								else
									local json = require("json")
									print(event.response)
									local resposta = json.decode(event.response)
									if resposta and resposta.message == "falha" then
										audio.stop()
										local som = audio.loadSound("audioTTS_1_Apelido2.mp3")
										audio.play(som)
									elseif resposta and resposta.message == "sucesso" then
									
										vetorTelaAtual.mostrarTelaEmail()
									else
										audio.stop()
										local som = audio.loadSound("audioTTS_6_falhaConexao.mp3")
										audio.play(som)
									end
								end
							end
							if vetorTelaAtual.atual.campo.text and #vetorTelaAtual.atual.campo.text >= 1 then
								local parameters = {}
								parameters.body = "Apelido=1&apelido=" .. vetorTelaAtual.dados.apelido
								local URL2 = "https://omniscience42.com/EAudioBookDB/verificarSeExiste.php"
								network.request(URL2, "POST", requestListener,parameters)
							else
								audio.stop()
								local som = audio.loadSound("audioTTS_0_campoVazio.mp3")
								audio.play(som)
							end
						end
					
						if vetorTelaAtual.atual then vetorTelaAtual.atual:removeSelf();vetorTelaAtual.atual=nil end
						vetorTelaAtual.atual = novoCampoDeTexto(aposConfirmar,"CONTINUAR","APELIDO (SEU LOGIN)")
						vetorTelaAtual.tocarSom("audioTTS_1_Apelido.mp3")
						grupoRegistro:insert(vetorTelaAtual.atual)
					
					end
					function vetorTelaAtual.mostrarTelaEmail()
						local function aposConfirmar()
							vetorTelaAtual.dados.email = vetorTelaAtual.atual.campo.text
							local function requestListener(event)
								if ( event.isError ) then
									audio.stop()
									local som = audio.loadSound("audioTTS_6_falhaConexao.mp3")
									audio.play(som)
								else
									local json = require("json")
									print(event.response)
									local resposta = json.decode(event.response)
									if resposta and resposta.message == "falha" then
										audio.stop()
										local som = audio.loadSound("audioTTS_4_email2.mp3")
										audio.play(som)
									elseif resposta and resposta.message == "sucesso" then
									
										vetorTelaAtual.mostrarTelaSenha()
									else
										audio.stop()
										local som = audio.loadSound("audioTTS_6_falhaConexao.mp3")
										audio.play(som)
									end
								end
							end
							if vetorTelaAtual.atual.campo.text and string.match(vetorTelaAtual.atual.campo.text,".+@.+%..+") then
								local parameters = {}
								parameters.body = "Email=1&email=" .. vetorTelaAtual.dados.email
								local URL2 = "https://omniscience42.com/EAudioBookDB/verificarSeExiste.php"
								network.request(URL2, "POST", requestListener,parameters)
							else
								audio.stop()
								local som = audio.loadSound("audioTTS_4_email3.mp3")
								audio.play(som)
							end
						end
					
						if vetorTelaAtual.atual then vetorTelaAtual.atual:removeSelf();vetorTelaAtual.atual=nil end
						vetorTelaAtual.atual = novoCampoDeTexto(aposConfirmar,"CONTINUAR","E-MAIL (USO ALTERNATIVO PARA LOGIN)")
						vetorTelaAtual.tocarSom("audioTTS_4_email.mp3")
						grupoRegistro:insert(vetorTelaAtual.atual)
						--audioTTS_4_email2.mp3
					end
					function vetorTelaAtual.mostrarTelaSenha(semSom)
						local function aposConfirmar()
							print(vetorTelaAtual.atual.campo.text)
							vetorTelaAtual.dados.senha = vetorTelaAtual.atual.campo.text
							vetorTelaAtual.mostratTelaSenhaConfirmar()
						end
					
						if vetorTelaAtual.atual then vetorTelaAtual.atual:removeSelf();vetorTelaAtual.atual=nil end
						vetorTelaAtual.atual = novoCampoDeTexto(aposConfirmar,"CONTINUAR","SENHA (SEM RESTRIÇÕES, ESCOLHA UMA DIFÍCIL)")
						if not semSom then
							vetorTelaAtual.tocarSom("audioTTS_2_senha.mp3")
						end
						grupoRegistro:insert(vetorTelaAtual.atual)
					end
					function vetorTelaAtual.mostratTelaSenhaConfirmar()
						local function aposConfirmar()
							vetorTelaAtual.dados.senhaConfirmada = vetorTelaAtual.atual.campo.text
							print(vetorTelaAtual.dados.senhaConfirmada)
							print(vetorTelaAtual.dados.senha)
							if (vetorTelaAtual.dados.senhaConfirmada ~= vetorTelaAtual.dados.senha) then
								audio.stop()
								local som = audio.loadSound("audioTTS_3_senhaConfirmar2.mp3")
								audio.play(som)
								vetorTelaAtual.mostrarTelaSenha(true)
							else
								vetorTelaAtual.mostrarTelaTelefone()
							end
						end
					
						if vetorTelaAtual.atual then vetorTelaAtual.atual:removeSelf();vetorTelaAtual.atual=nil end
						vetorTelaAtual.atual = novoCampoDeTexto(aposConfirmar,"CONTINUAR","CONFIRME SUA SENHA")
						vetorTelaAtual.tocarSom("audioTTS_3_senhaConfirmar.mp3")
						grupoRegistro:insert(vetorTelaAtual.atual)
					end
					function vetorTelaAtual.mostrarTelaTelefone()
						local function aposConfirmar()
							vetorTelaAtual.dados.telefone = vetorTelaAtual.atual.campo.text
							vetorTelaAtual.mostrarTelaFinalizar()
						end
					
					
						if vetorTelaAtual.atual then vetorTelaAtual.atual:removeSelf();vetorTelaAtual.atual=nil end
						vetorTelaAtual.atual = novoCampoDeTexto(aposConfirmar,"CONTINUAR","CELULAR/WHATSAPP (COLOCAR DDD ANTES)")
						vetorTelaAtual.atual.campo.inputType = "number"
						vetorTelaAtual.tocarSom("audioTTS_5_telefone.mp3")
						grupoRegistro:insert(vetorTelaAtual.atual)
					end
					function vetorTelaAtual.mostrarTelaFinalizar()
						native.setKeyboardFocus( nil )
						local function aposConfirmar()
							local function submitCadastro_function(event)
								local function cadastroListener( event )
									if ( event.isError ) then
										  vetorTelaAtual.tocarSom("audioTTS_6_falhaConexao.mp3")
									else
										print("|"..event.response.."|"..type(event.response).."|")
										if event.response == "1" then
											local function onComplete()
												vetorTelaAtual.tocarSom("audioTTS_telaInicial.mp3")
											end
											vetorTelaAtual.tocarSom("audioTTS_6_finalizou.mp3",{onComplete = onComplete})
										
											vetorTelaAtual.cancelarRegistro()
											campoLogin.isVisible = true;
											campoSenha.isVisible = true
											campoLogin.text = vetorTelaAtual.dados.apelido
											campoSenha.text = vetorTelaAtual.dados.senha
											local evento = {}
											evento.target = {}
											evento.target.selecionado2 = true
											Logar(event)
										else
											audio.stop()
											local som = audio.loadSound("audioTTS_6_finalizou2falhou.mp3")
											audio.play(som)
										end
									end
								end
								
								parameters = {}
								parameters.body = "Register=1&nome=" .. vetorTelaAtual.dados.nome .. "&login=" .. vetorTelaAtual.dados.apelido .. "&senha=" .. vetorTelaAtual.dados.senha .. "&email="..vetorTelaAtual.dados.email.."&telefone="..vetorTelaAtual.dados.telefone
								local URL2 = "https://omniscience42.com/EAudioBookDB/cadastrar.php"
								network.request(URL2, "POST", cadastroListener,parameters)
							end
							submitCadastro_function()
						end
					
						native.setKeyboardFocus( nil )
						--
						if vetorTelaAtual.atual then vetorTelaAtual.atual:removeSelf();vetorTelaAtual.atual=nil end
						vetorTelaAtual.atual = novoCampoDeTexto(
							aposConfirmar,
							"FINALIZAR",
							"Verifique seus dados e finalize:\n\nNome: "..
							vetorTelaAtual.dados.nome..
							"\nApelido: "..
							vetorTelaAtual.dados.apelido..
							"\nE-mail: "..
							vetorTelaAtual.dados.email..
							"\nTelefone: "..
							vetorTelaAtual.dados.telefone)
						vetorTelaAtual.tocarSom("audioTTS_finalizeCadastro.mp3")
						grupoRegistro:insert(vetorTelaAtual.atual)
					end
				
					--
					vetorTelaAtual.mostrarTelaNome()
					print("clicou duas vezes")
				end
			end
			local text_options = {
				align = "center",
				font = "Fontes/segoeui.ttf",
				fontSize = textoPedirSenha.size,
				x = textoPedirSenha.x,
				text = "Caso não tenha conta, clique\nno botão abaixo para"
			}
			local textoRegistre = display.newText(text_options)
			textoRegistre.y = textoPedirSenha.y + textoPedirSenha.height/2 + textoRegistre.height/2 + 20
			textoRegistre:setFillColor(0,0,0)
			textoRegistre.isVisible = false
			local textoRegistre2 = display.newText("registrar:",W/2,0,"Fontes/segoeui.ttf",textoPedirSenha.size)
			textoRegistre2.y = textoRegistre.y + textoRegistre.height/2 + textoRegistre2.height/2
			textoRegistre2:setFillColor(1,0,0)
			textoRegistre2.isVisible = false
			grupoLogin:insert(textoRegistre)
			grupoLogin:insert(textoRegistre2)
		
			botaoRegistrar = widget.newButton {
				shape = "roundedRect",
				fillColor = { default={ 0.18, 0.67, 0.785, 1 }, over={ 0.004, 0.368, 0.467, .5 } },
				width = 480,
				height = 122,
				label = "Registrar",
				fontSize = 65,
				strokeWidth = 4,
				font = "Fontes/timesbd.ttf",
				strokeColor = { default={ 0, 0, 0, .1 }, over={ 1, 1, 1, 1 } },
				labelColor = { default={ 0, 0, 0, 1 }, over={ 1, 1, 1, 1 } },
				onEvent = TeladeRegistro2
			}
			botaoRegistrar.contentDescription = "Botão Registrar"
			botaoRegistrar.selecionado1 = false
			botaoRegistrar.selecionado2 = false
			botaoRegistrar.anchorX=.5
			botaoRegistrar.anchorY=.5
			botaoRegistrar.y = textoRegistre2.y + textoRegistre2.height/2 + 20 + botaoRegistrar.height/2
			botaoRegistrar.x = botaoLogin.x
			botaoRegistrar.isVisible = false
			grupoLogin:insert(botaoRegistrar)
			local function comparacoesLetras(som,charactere)
				if charactere == "'" then
					som = audio.loadSound("Teclado/apostrofo.mp3")
				elseif charactere == "@" then
					som = audio.loadSound("Teclado/arroba.mp3")
				elseif charactere == '"' then
					som = audio.loadSound("Teclado/aspas.mp3")
				elseif charactere == "%*" then
					som = audio.loadSound("Teclado/asterisco.mp3")
				elseif charactere == "/" then
					som = audio.loadSound("Teclado/barra.mp3")
				elseif charactere == "#" then
					som = audio.loadSound("Teclado/cerquilha.mp3")
				elseif charactere == "$" then
					som = audio.loadSound("Teclado/cifrao.mp3")
				elseif charactere == "\\" then
					som = audio.loadSound("Teclado/contra barra.mp3")
				elseif charactere == ":" then
					som = audio.loadSound("Teclado/dois pontos.mp3")
				elseif charactere == "&" then
					som = audio.loadSound("Teclado/E comercial.mp3")
				elseif charactere == " " then
					som = audio.loadSound("Teclado/espaco.mp3")
				elseif charactere == "%+" then
					som = audio.loadSound("Teclado/mais.mp3")
				elseif charactere == ")" then
					som = audio.loadSound("Teclado/parentese direito.mp3")
				elseif charactere == "(" then
					som = audio.loadSound("Teclado/parentese esquerdo.mp3")
				elseif charactere == "!" then
					som = audio.loadSound("Teclado/ponto de exclamacao.mp3")
				elseif charactere == "%?" then
					som = audio.loadSound("Teclado/ponto de interrogacao.mp3")
				elseif charactere == ";" then
					som = audio.loadSound("Teclado/ponto e virgula.mp3")
				elseif charactere == "%." then
					som = audio.loadSound("Teclado/ponto.mp3")
				elseif charactere == "%-" then
					som = audio.loadSound("Teclado/traco.mp3")
				elseif charactere == "," then
					som = audio.loadSound("Teclado/virgula.mp3")
				else
					som = audio.loadSound("Teclado/"..charactere..".mp3")
				end
				return som
			end
		
			timer.performWithDelay(500,function()
				if varGlobais.restricaoLivro == "L" then
					textoRegistre.isVisible = true
					textoRegistre2.isVisible = true
					botaoRegistrar.isVisible = true
					--botaoRegistrarRapido.isVisible = true
				end
			end,1)
		
			tentarLoginAux()
		end
		
		-- VERIFICAR ARQUIVO DE LOGIN
		
		
		if varGlobais.vetorPastasAndroid.armazenamentoInterno and android.fileExist(varGlobais.vetorPastasAndroid.armazenamentoInterno.."/Download","arquivoLoginLibEA.txt") then
			
			-- VERIFICAR PERMISSåO LEITURA DE ARQUIVOS	
			if tipoSistema ~= "PC" and system.getInfo("androidApiLevel") >= 23 then
				local permissaoConcedida = android.checkPermissions()
				if not permissaoConcedida then
					local function aoAceitarOuRecusarPermissao(event)
						local permsGranted = android.checkPermissions()
						if permsGranted then -- permissão concedida
							lerArquivoAndroidParaLogin()
							telaDeLogin()
						else
							telaDeLogin()
						end
					end
					local permissionOptions =
					{
						appPermission = "Storage",
						urgency = "Critical",
						listener = aoAceitarOuRecusarPermissao,
						rationaleTitle = "Foi detectado um arquivo de conta para realizar login!",
						rationaleDescription = "Para entrar com a conta utilizando o arquivo baixado, é necessário que seja dada a permissão para acessar o arquivo de login, se você deseja utilizar o arquivo para entrar com a conta por favor aceite a permissão de armazenamento. Senão apenas recuse e realize o login da forma padrão.",
						settingsRedirectTitle = "Alert",
						settingsRedirectDescription = "Tem certeza que não deseja dar a permissão? Se o fizer você será redirecionado para a tela de login. Lembrando que é recomendado que o arquivo seja excluido para que o sistema não pergunte novamente caso você saia posteriormente de sua conta."
					}
					native.showPopup( "requestAppPermission", permissionOptions )
				else -- permissão já concedida
					lerArquivoAndroidParaLogin()
					telaDeLogin()
				end
			else -- android não precisa de permissão
				lerArquivoAndroidParaLogin()
				telaDeLogin()
			end	
		else -- não existe arquivo
			telaDeLogin()
		end
	end
	local clicado = false
	function funcGlobais.onKeyEvent( event )

		-- Print which key was pressed down/up
		local message = "Key '" .. event.keyName .. "' was pressed " .. event.phase
		--print( message )
	 
		-- If the "back" key was pressed on Android, prevent it from backing out of the app
		if ( event.keyName == "back" ) then
			if event.phase == "up" then
				if campoLogin and campoSenha and campoLogin.isVisible == false and campoSenha.isVisible == false then
					grupoTelaRegistro:removeSelf();campoLogin.isVisible = true;campoSenha.isVisible = true
				end
				if clicado == true then
					clicado = false
					
					return true
				else
					--grupoMenuGeralTTS.isVisible = false
					clicado = true
					return true
				end
				return true
			end
		end
		if event.isShiftDown then
			local som = audio.loadSound("Teclado/Comandos/shift ativado.mp3")
			audio.play(som)
		end
		--print(event.keyName)
		--print(event.phase)
		
		-- IMPORTANT! Return false to indicate that this app is NOT overriding the received key
		-- This lets the operating system execute its default handling of the key
		return false
	end
	 
	-- Add the key event listener
	Runtime:addEventListener( "key", funcGlobais.onKeyEvent )
	
	varGlobais.menuRetratil = display.newRect(W/2,H,W,H/2)
	varGlobais.menuRetratil.anchorY=0
	varGlobais.menuRetratil:setFillColor(preferenciasGerais.cor[1],preferenciasGerais.cor[2],preferenciasGerais.cor[3])
	
	-- FUN‚ÃO DE RETORNO DE VOZ --
	
	
	function varGlobais.talkBack(event)
		local function desativar() 
			if event.phase == "editing" then
			
				audio.stop()
				local som
				print("event.newCharacters = ",event.newCharacters)
				print("event.numDeleted = ",event.numDeleted)
				if event.newCharacters and event.numDeleted == 0 then
					comparacoesLetras(som,event.newCharacters)
					audio.play(som)
				elseif event.numDeleted > string.len(event.text) then
					local function onDeleteAudioEnd()
						print("event.oldText = ",event.oldText)
						print("event.text = ",event.text)
						local letraApagada = string.sub(event.oldText,#event.oldText,#event.oldText)
						print("event.oldText = ",event.oldText)
						print("letra apagada = ",letraApagada)
						som = comparacoesLetras(som,letraApagada)
						audio.play(som)
					end
					som = audio.loadSound("Teclado/Comandos/delete.mp3")
					audio.play(som,{onComplete = onDeleteAudioEnd})
				end
			
			end
		end
	end
	

	-- verificar se existe arquivo de login e ler
		
	--testarNoAndroid(varGlobais.vetorPastasAndroid.armazenamentoInterno.."/Download",100)
	
	
	--android.criarPastaAndroid({caminho = varGlobais.vetorPastasAndroid.armazenamentoInterno,pasta = "1pasta"})
	
	
	--local url = "https://api.voicerss.org/?key=07aa9b6dabdc4c1abe01c94cb560441e&hl=pt-br&c=MP3&r=0&f=12khz_16bit_mono&src= Dicionário, clique duas vezes para abrir as palavras com dicionário da página."
	--local url = "https://api.voicerss.org/?key=07aa9b6dabdc4c1abe01c94cb560441e&hl=pt-br&c=MP3&r=0&f=12khz_16bit_mono&src= Relatório, clique duas vezes para abrir o gerador de relatórios."
	--local url = "https://api.voicerss.org/?key=07aa9b6dabdc4c1abe01c94cb560441e&hl=pt-br&c=MP3&r=0&f=12khz_16bit_mono&src= Rodapé, clique duas vezes para abrir o rodapé da página."
	--local url = "https://api.voicerss.org/?key=07aa9b6dabdc4c1abe01c94cb560441e&hl=pt-br&c=MP3&r=0&f=12khz_16bit_mono&src= Anotação e fórum, clique duas vezes para abrir a anotação e fórum da página"
	--local url = "https://api.voicerss.org/?key=07aa9b6dabdc4c1abe01c94cb560441e&hl=pt-br&c=MP3&r=0&f=12khz_16bit_mono&src= Déck de Cárdis, clique duas vezes para abrir o Déck de Cárdis da página"
	--local url = "https://api.voicerss.org/?key=07aa9b6dabdc4c1abe01c94cb560441e&hl=pt-br&c=MP3&r=0&f=12khz_16bit_mono&src= Pê.DÊ.F, clique duas vezes para abrir o Gerador de Pê.DÊ.éFes do livro"
	--local url = "https://api.voicerss.org/?key=07aa9b6dabdc4c1abe01c94cb560441e&hl=pt-br&c=MP3&r=0&f=12khz_16bit_mono&src= Abrindo o Déck de Cárdis da página"
	--local url = "https://api.voicerss.org/?key=07aa9b6dabdc4c1abe01c94cb560441e&hl=pt-br&c=MP3&r=0&f=12khz_16bit_mono&src= Agora, coloque um apelido para sua conta, este apelido poderá ser usado para entrar em sua conta. Após criar o apelido, confirme ou toque em continuar!"
	
	
	--"https://api.voicerss.org/?key=07aa9b6dabdc4c1abe01c94cb560441e&hl=en-us&c=MP3&r=0&f=12khz_16bit_mono&src= Dictionary, tap two times to open the dictionary words on this page!  "
	--"https://api.voicerss.org/?key=07aa9b6dabdc4c1abe01c94cb560441e&hl=en-us&c=MP3&r=0&f=12khz_16bit_mono&src= Log History, tap two times to open the log history generator!  "
	--"https://api.voicerss.org/?key=07aa9b6dabdc4c1abe01c94cb560441e&hl=en-us&c=MP3&r=0&f=12khz_16bit_mono&src= footnotes, tap two times to open the page's footnotes  "
	--"https://api.voicerss.org/?key=07aa9b6dabdc4c1abe01c94cb560441e&hl=en-us&c=MP3&r=0&f=12khz_16bit_mono&src= Forum and anotations, tap two times to open anotations and forum on this page!  "
	--"https://api.voicerss.org/?key=07aa9b6dabdc4c1abe01c94cb560441e&hl=en-us&c=MP3&r=0&f=12khz_16bit_mono&src= Deck of Cards, tap two times to open the cards on this page!  "
	--"https://api.voicerss.org/?key=07aa9b6dabdc4c1abe01c94cb560441e&hl=en-us&c=MP3&r=0&f=12khz_16bit_mono&src= P.D.F., tap two times to open the P.D.F Generator!  "
	--"https://api.voicerss.org/?key=07aa9b6dabdc4c1abe01c94cb560441e&hl=en-us&c=MP3&r=0&f=12khz_16bit_mono&src= opening the page's deck of cards!  "
	--"https://api.voicerss.org/?key=07aa9b6dabdc4c1abe01c94cb560441e&hl=en-us&c=MP3&r=0&f=12khz_16bit_mono&src= Closing the page's deck of cards!  "
	
	
	--request = network.request( url, "GET", cadastroListener,  params )
	
	--========================================
	-- local path = system.pathForFile( "story.html", system.TemporaryDirectory )
 
	-- -- io.open opens a file at path. returns nil if no file found
	-- local fh, errStr = io.open( path, "w" )
 
	-- 
	-- Write out the required headers to make sure the content fits into our
	-- window and then dump the body.
	--
	-- if fh then
		-- print( "Created file" )
		-- fh:write("<!doctype html>\n<html>\n<head>\n<meta charset=\"utf-8\">")
		-- fh:write("<meta name=\"viewport\" content=\"width=320; initial-scale=1.0; maximum-scale=1.0; user-scalable=0;\"/>\n")
		-- fh:write("<style type=\"text/css\">\n html { -webkit-text-size-adjust: none; font-family: HelveticaNeue-Light, Helvetica, Droid-Sans, Arial, san-serif; font-size: 1.0em; } h1 {font-size:1.25em;} p {font-size:0.9em; } </style>")
		-- fh:write("</head>\n<body>\n")

		-- --fh:write("<h1>" .. story.title .. "</h1>\n")

		-- local videoID = "AVcKdr6ODpM" --story.link:sub(33, 43)
		-- --print(videoID)
		-- local height = 200
		-- fh:write([[<iframe width="100%" height="]] .. height .. [[" src="https://www.youtube.com/embed/]] .. videoID .. [[?html5=1" frameborder="0" ></iframe>]])

		-- fh:write( "\n</body>\n</html>\n" )
		-- io.close( fh )
	-- else
		-- print( "Create file failed!" )
	-- end

	-- webView = native.newWebView(0, 71, display.contentWidth, display.actualContentHeight - 170)
	-- webView.x = display.contentCenterX
	-- webView.y = 100 + display.topStatusBarContentHeight
	-- webView.anchorY  = 0
	-- --<iframe width="403" height="238" src="https://www.youtube.com/embed/AVcKdr6ODpM" frameborder="0" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>
	-- webView:request("story.html", system.TemporaryDirectory)
	-- webView:addEventListener( "urlRequest", webListener )
