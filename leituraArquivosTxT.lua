local M = {}
local W = display.viewableContentWidth ;
local H = display.viewableContentHeight;
local validarUTF8 = require("utf8Validator")
local conversor = require("conversores")
local auxFuncs = require("ferramentasAuxiliares")
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
--CRIAR FUNDO APARTIR DE ARQUIVOS
--CRIAR IMAGEM E TEXTO APARTIR DE ARQUIVOS
--CRIAR DICIONARIO APARTIR DE ARQUIVOS
--CRIAR RODAPÉ APARTIR DE ARQUIVOS
--CRIAR CARDDECK APARTIR DE ARQUIVO

------------------------------------------------------------------
-- FUNÇÃO GENÉRICA -----------------------------------------------
------------------------------------------------------------------
function M.lerArquivoPadrao(atributos)
	local vetor = {}
	local path = system.pathForFile( atributos.pasta.."/"..atributos.arquivo, system.ResourceDirectory )
	print("|||||||||||||||||||||",atributos.pasta.."/"..atributos.arquivo)
	
	if path then
		print(path)
		local file, errorString = io.open( path, "r" )
		local xx=1
		local ignorar = true
		if not file then
			print( "File error: " .. errorString )
		else
			for line in file:lines() do
				print(line)
				if string.len( line ) > 3 then
					local is_valid, error_position = validarUTF8.validate(line)
					if not is_valid then 
						--print('non-utf8 sequence detected at position ' .. tostring(error_position))
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
	else
		print("no path found")
	end
	
	return vetor
end

------------------------------------------------------------------
--	CRIAR INDICE APARTIR DE ARQUIVOS - auxiliar do indice Manual--
------------------------------------------------------------------
function criarIndicedeArquivo(atributos,listaDeErros)
	local function lerArquivoIndice()
		local vetor = {}
		print("WARNING: começo line")
		local auxArquivo = atributos.arquivo
		if atributos.tipoSistema == "android" then
			--auxArquivo = auxArquivo:sub(1, #auxArquivo - 1)
		end
		local path = system.pathForFile( auxArquivo, system.ResourceDirectory )
		if atributos.caminho then
			path = atributos.caminho
		end
		
		-- Open the file handle
		local file, errorString = io.open( path, "r" )
		local xx=1
		local ignorar = true
		local contents = ""
		if not file then
			-- Error occurred; output the cause
			print( "File error: " .. errorString )
		else
			-- Output lines

			for line in file:lines() do
				if string.len( line ) > 4 then
					local is_valid, error_position = validarUTF8.validate(line)
					if not is_valid then print('non-utf8 sequence detected at position ' .. tostring(error_position))
						line = conversor.converterANSIparaUTFsemBoom(line)
					end
					vetor[xx] = line
					xx = xx+1
					--print(line)
				end
			end
			-- Close the file handle
			io.close( file )
		end
		for i=0,#vetor do
			local aux = vetor[i]
			vetor[i] = aux
		end
		
		file = nil
		print("WARNING: fim line")
		return vetor
	end
	local VetorIndice = {}
	local vetorIndiceAux = lerArquivoIndice()
	-- verificar estrutura de indice remissivo
	local indiceRemissivo = false
	if string.find(conversor.stringLowerAcento(vetorIndiceAux[1]),"índice remissivo") then
		indiceRemissivo = true
	end
	------------------------------------------
	
	if atributos.TTSTipo and atributos.TTSTipo == "RSS" then
		VetorIndice[1] = {".titolo..",vetorIndiceAux[1],0}
	else
		VetorIndice[1] = {".título..",vetorIndiceAux[1],0}
	end
	if indiceRemissivo then	VetorIndice[1] = {vetorIndiceAux[1]} end
	for i = 2, #vetorIndiceAux do
		VetorIndice[i] = {}
		local aux = vetorIndiceAux[i]
		local xx = 1
		auxFuncs.getMatchesString(aux,VetorIndice[i],xx)
		print("matches",vetorIndiceAux[i],aux)
		if not indiceRemissivo then
			print("VetorIndice[i][x]",VetorIndice[i][1],VetorIndice[i][2],VetorIndice[i][3],VetorIndice[i][4])
			if xx > 4 then
				table.insert(listaDeErros, "Arquivo: "..atributos.arquivo.. " -> Item: ".. aux)
				VetorIndice[i][1],VetorIndice[i][2],VetorIndice[i][3] = "titulo","nil",1
			elseif string.len(VetorIndice[i][3]) > 8 then
				table.insert(listaDeErros, "Arquivo: "..atributos.arquivo.. " -> Item: ".. aux)
				VetorIndice[i][1],VetorIndice[i][2],VetorIndice[i][3] = "titulo","nil",1
			elseif VetorIndice[i][1] == nil or VetorIndice[i][2] == nil or VetorIndice[i][3] == nil then
				table.insert(listaDeErros, "Arquivo: "..atributos.arquivo.. " -> Item: ".. aux)
				VetorIndice[i][1],VetorIndice[i][2],VetorIndice[i][3] = "titulo","nil",1
			end
		
			local titulo = string.gsub(tostring(VetorIndice[i][1]),"[ ]+","")

			if (titulo ~= "titulo") and (titulo ~= "subtitulo") and (titulo ~= "subtitulo2") and (titulo ~= "subtitulo3") then
				 
				table.insert(listaDeErros, "Arquivo: "..atributos.arquivo.. " -> Item ".. i)
				local aux = ""
				for past in string.gmatch(VetorIndice[i][1], '([a-z0-9]+)') do
					aux = past
				end
				VetorIndice[i][1] = aux
			end
		
			VetorIndice[i][1] = tostring(VetorIndice[i][1])
			VetorIndice[i][2] = tostring(VetorIndice[i][2])
			VetorIndice[i][3] = tonumber(VetorIndice[i][3])
			VetorIndice.indiceRemissivo = false
		else
			for ir=2,#VetorIndice[i] do
				print(VetorIndice[i][ir])
				VetorIndice[i][ir] = tonumber(VetorIndice[i][ir])
			end
			VetorIndice.indiceRemissivo = VetorIndice[i]
			VetorIndice[i].localizar = VetorIndice[i][1]
			print("localizar",VetorIndice[i][1])
		end
	end
	return VetorIndice
end
M.criarIndicedeArquivo = criarIndicedeArquivo
function criarIndicesDeArquivoConfig(atributos,Telas,listaDeErros,VetorDeVetorTTS)
	local Indices = {}

	local function lerArquivoIndice()
		local vetor = {}
		
		local path = system.pathForFile( atributos.pasta.."/"..atributos.arquivo, system.ResourceDirectory )
		
		-- Open the file handle
		local file, errorString = io.open( path, "r" )
		local xx=1
		local ignorar = true
		if not file then
			-- Error occurred; output the cause
			print( "File error: " .. errorString )
		else
			-- Output lines
			local contents = file:read( "*a" )
			local filtrado = string.gsub(contents,".",{ ["\13"] = "",["\10"] = "\13\10"})
			for line in string.gmatch(filtrado,"([^\13\10]+)") do
			--for line in file:lines() do
				if string.len( line ) > 3 then
					
					local is_valid, error_position = validarUTF8.validate(line)
					if not is_valid then print('non-utf8 sequence detected at position ' .. tostring(error_position))
						line = conversor.converterANSIparaUTFsemBoom(line)
					end
					--print("!"..tostring(line).."!")
					vetor[xx] = line
					xx = xx+1
					
				end
			end
			-- Close the file handle
			io.close( file )
			
		end
		for i=0,#vetor do
			local aux = vetor[i]
			vetor[i] = aux
		end
		
		file = nil
		return vetor
	end
	
	local vetorCorTitulo = {180,180,180}
	local vetorCorTexto = {180,180,180}
	local xalinhamento = "meio"
	local xtamanhoTitulo = 60
	local xeNegrito = "nao"
	local xtamanhoTexto = 40
	local xalinhamentoTexto = "meio"
	local xfonte = native.systemFont
	local xmargem = 0
	local xX = nil
	local xY = nil
	local xfonte = "Fontes/ariblk.ttf"
	
	local vetorIndiceAux = lerArquivoIndice()
	
	for k=1,#vetorIndiceAux do
		
		vetorIndiceAux[k] = auxFuncs.verificarComentario(vetorIndiceAux[k])
		
		if string.find( vetorIndiceAux[k]:match("([^=]+)="), 'alinhamento do titulo' ) ~= nil then
			local aux = "meio"
			lixo,str = vetorIndiceAux[k]:match("([^=]+) *=+ *([^\13]+)")
			for past in string.gmatch(str, '([a-z]+)') do
				aux = past
			end
			xalinhamento = aux
			
			if (xalinhamento ~= "meio") and (xalinhamento ~= "esquerda") and (xalinhamento ~= "direita") and (xalinhamento ~= "justificado") then
				table.insert(listaDeErros, "Arquivo: "..atributos.arquivo.. " -> alinhamento do titulo")
				xalinhamento = "meio"
			end
		end
		
		if string.find( vetorIndiceAux[k]:match("([^=]+)="), 'tamanho do titulo' ) ~= nil then
			local aux = 60
			lixo,str = vetorIndiceAux[k]:match("([^=]+) *=+ *([^\13]+)")
			for past in string.gmatch(str, '([0-9]+)') do
				aux = tonumber(past)
			end
			xtamanhoTitulo = aux
			if xtamanhoTitulo < 1 or xtamanhoTitulo >= 300 then
				table.insert(listaDeErros, "Arquivo: "..atributos.arquivo.. " -> tamanho do titulo")
				xtamanhoTitulo = 60
			end
		end
		
		if string.find( vetorIndiceAux[k]:match("([^=]+)="), 'cor do titulo' ) ~= nil then
			local xxy = 1
			lixo,str = vetorIndiceAux[k]:match("([^=]+) *=+ *([^\13]+)")
			for num in string.gmatch(str, '([0-9]+)') do
				vetorCorTitulo[xxy] = tonumber(num)
				xxy = xxy+1
			end
			local i = 1
			while i < 3 do
				if vetorCorTitulo[i] < 0 or vetorCorTitulo[i] > 255 or #vetorCorTitulo > 3 then
					table.insert(listaDeErros, "Arquivo: "..atributos.arquivo.. " -> cor do titulo")
					vetorCorTitulo[1],vetorCorTitulo[2],vetorCorTitulo[3] = 180,180,180
					i=3
				end
				i = i+1
			end
		end
		
		if string.find( vetorIndiceAux[k]:match("([^=]+)="), 'Negrito' ) ~= nil then
			local aux = "nao"
			lixo,str = vetorIndiceAux[k]:match("([^=]+) *=+ *([^\13]+)")
			for past in string.gmatch(str, '([a-z]+)') do
				aux = past
			end
			xeNegrito = aux
			if (xeNegrito ~= "sim") and (xeNegrito ~= "nao") then
				table.insert(listaDeErros, "Arquivo: "..atributos.arquivo.. " -> Negrito")
				xeNegrito = "nao"
			end
		end

		if string.find( vetorIndiceAux[k]:match("([^=]+)="), 'cor do texto' ) ~= nil then
			local xxy = 1
			lixo,str = vetorIndiceAux[k]:match("([^=]+) *=+ *([^\13]+)")
			for num in string.gmatch(str, '([0-9]+)') do
				vetorCorTexto[xxy] = tonumber(num)
				xxy = xxy+1
			end
			local i = 1 
			while i < 3 do
				if vetorCorTexto[i] < 0 or vetorCorTexto[i] > 255 or #vetorCorTexto > 3 then
					table.insert(listaDeErros, "Arquivo: "..atributos.arquivo.. " -> cor do texto")
					vetorCorTexto[1],vetorCorTexto[2],vetorCorTexto[3] = 180,180,180
					i=3
				end
				i = i+1
			end
		end
		
		if string.find( vetorIndiceAux[k]:match("([^=]+)="), 'tamanho do texto' ) ~= nil then
			local aux = 40
			lixo,str = vetorIndiceAux[k]:match("([^=]+) *=+ *([^\13]+)")
			for past in string.gmatch(str, '([0-9]+)') do
				aux = tonumber(past)
			end
			xtamanhoTexto = aux
			if xtamanhoTexto < 1 or xtamanhoTexto >= 300 then
				table.insert(listaDeErros, "Arquivo: "..atributos.arquivo.. " -> tamanho do texto")
				xtamanhoTexto = 40
			end
		end

		if string.find( vetorIndiceAux[k]:match("([^=]+)="), 'alinhamento do texto' ) ~= nil then
			local aux = "meio"
			lixo,str = vetorIndiceAux[k]:match("([^=]+) *=+ *([^\13]+)")
			for past in string.gmatch(str, '([a-z]+)') do
				aux = past
			end
			xalinhamentoTexto = aux
			if (xalinhamentoTexto ~= "meio") and (xalinhamentoTexto ~= "esquerda") and (xalinhamentoTexto ~= "direita") and (xalinhamentoTexto ~= "justificado")  then
				table.insert(listaDeErros, "Arquivo: "..atributos.arquivo.. " -> alinhamento do texto")
				xalinhamentoTexto = "esquerda"
			end
		end
		
		if string.find( vetorIndiceAux[k]:match("([^=]+)="), " x" ) ~= nil or string.find( vetorIndiceAux[k]:match("([^=]+)="), "x " ) then
			local aux = -1
			local aux2 = ""
			lixo,str = vetorIndiceAux[k]:match("([^=]+) *=+ *([^\13]+)")
			for past in string.gmatch(str, '([a-z]+)') do
				aux2 = past
			end
			for past in string.gmatch(str, '([0-9]+)') do
				aux = tonumber(past)
			end
			if aux2 == "nil" then
			else
				xX = aux
			end
		end
		
		if string.find( vetorIndiceAux[k]:match("([^=]+)="), "y " ) or string.find( vetorIndiceAux[k]:match("([^=]+)="), " saltar " ) ~= nil then
			local multiplicador = 1
			if string.find( vetorIndiceAux[k]:match("([^=]+)="), " saltar " ) then
				multiplicador = 30
			end
			local aux = -1
			local aux2 = ""
			lixo,str = vetorIndiceAux[k]:match("([^=]+) *=+ *([^\13]+)")
			for past in string.gmatch(str, '([a-z]+)') do
				aux2 = past
			end
			for past in string.gmatch(str, '([0-9]+)') do
				if string.find(str,"-") then
					aux = -1*(tonumber(past) * multiplicador)
				else
					aux = tonumber(past * multiplicador)
				end
			end
			if aux2 == "nil" then
			else
				xY = aux  * multiplicador
			end
		end
		
		if string.find( vetorIndiceAux[k]:match("([^=]+)="), "margem" ) ~= nil then
			local aux = -1
			local aux2 = ""
			lixo,str = vetorIndiceAux[k]:match("([^=]+) *=+ *([^\13]+)")
			for past in string.gmatch(str, '([a-z]+)') do
				aux2 = past
			end
			for past in string.gmatch(str, '([0-9]+)') do
				aux = tonumber(past)
			end
			if aux2 == "nil" then
			else
				xmargem = aux
			end
		else
			--table.insert(listaDeErros, "Arquivo: "..atributos.arquivo.. " -> Item "..i.." - 'f)' não encontrado")
		end
		
		if string.find( vetorIndiceAux[k]:match("([^=]+)="), "fonte" ) ~= nil then
			local aux = " "
			lixo,str = vetorIndiceAux[k]:match("([^=]+) *=+ *([^\13]+)")
			for past in string.gmatch(str, '([A-Za-z.0-9]+)') do
				aux = past
			end
			xfonte = aux
			if (xfonte ~= "arial") and (xfonte ~= "times") and (xfonte ~= "calibri") and not string.find(xfonte, "%.ttf") and not string.find(xfonte, "%.otf") == nil then
				xfonte = "ariblk.ttf"
			end
			if (string.find(xfonte, ".ttf") ~= nil or string.find(xfonte, ".otf") ~= nil) and (xfonte ~= "arial") and (xfonte ~= "times") and (xfonte ~= "calibri") then
				xfonte = "Fontes/"..aux
			else
				xfonte = aux
			end
		end
	end
		
	local vetorTitulos = criarIndicedeArquivo({arquivo = atributos.pasta.."/"..Telas.arquivos[atributos.pagina]},listaDeErros)
	
	
	local auxVetorTTS = criarIndicedeArquivo({arquivo = atributos.pasta.."/"..Telas.arquivos[atributos.pagina]},{})
	local auxStringTTS = ""
	VetorTTS = {}
	local vetorStringTTS = {}
	for i=2,#auxVetorTTS do
		local textoTTS = auxVetorTTS[i][2]
		if auxVetorTTS.indiceRemissivo then
			textoTTS = ""
			for ir=1,#auxVetorTTS[i] do
				print(i,ir,#auxVetorTTS[i],auxVetorTTS[i],auxVetorTTS[i][ir])
				textoTTS = textoTTS .. auxVetorTTS[i][ir] .. ", "
			end
		end
		if not textoTTS then textoTTS = "" end
		local is_valid, error_position = validarUTF8.validate(textoTTS)
		if not is_valid then print('non-utf8 sequence detected at position ' .. tostring(error_position))
			textoTTS = conversor.converterANSIparaUTFsemBoom(textoTTS)
		end
		
		if auxVetorTTS[i][1] == "titulo" then
			table.insert( vetorStringTTS,auxStringTTS)
			auxStringTTS = ""
		end
		auxStringTTS = auxStringTTS .. " .; \n\n "..textoTTS .. ". \n\n"
		if i == #auxVetorTTS then
			table.insert( vetorStringTTS,auxStringTTS)
		end
	end
	if vetorTitulos[1][2] or (vetorTitulos.indiceRemissivo and vetorTitulos[1][1]) then
		local tituloAtual = vetorTitulos[1][2]
		if vetorTitulos.indiceRemissivo then tituloAtual = vetorTitulos[1][1] end
		local voz = string.gsub(tituloAtual,"\\n"," .")
		local is_valid, error_position = validarUTF8.validate(voz)
		if not is_valid then print('non-utf8 sequence detected at position ' .. tostring(error_position))
			voz = conversor.converterANSIparaUTFsemBoom(voz)
		end
		--voz = ""
		for i=1,#vetorStringTTS do
			if i==1 then
				table.insert( VetorTTS, voz.." \n\n" .. vetorStringTTS[i] )
			elseif i == #vetorStringTTS then
				table.insert( VetorTTS, vetorStringTTS[i].." ." )
			else
				table.insert(VetorTTS,vetorStringTTS[i])
			end
		end
	end
	VetorDeVetorTTS[atributos.paginaAtual] = VetorTTS
	VetorDeVetorTTS[atributos.paginaAtual].numero = #VetorDeVetorTTS[atributos.paginaAtual]
	VetorTTS = {}
	--print("WARNING:",vetorTitulos[1][2],vetorTitulos[1][1])
	local titulo = vetorTitulos[1][2]
	if vetorTitulos.indiceRemissivo then titulo = vetorTitulos[1][1] end
	local indice = {
		titulo = titulo,
		alinhamento = xalinhamento,
		tamanhoTitulo = xtamanhoTitulo,
		margem = xmargem,
		fonte = xfonte,
		x = xX,
		y = xY,
		cor = {vetorCorTitulo[1],vetorCorTitulo[2],vetorCorTitulo[3]},
		eNegrito = xeNegrito,
		vetorTitulos = vetorTitulos,
		corTexto = {vetorCorTexto[1],vetorCorTexto[2],vetorCorTexto[3]},
		tamanhoTexto = xtamanhoTexto,
		alinhamentoTexto = xalinhamentoTexto,
	}
	local vetor = {indiceManual = indice}
	vetor.ordemElementos = {}
	vetor.ordemElementos[1] = "indiceManual"
	
	return vetor
end
M.criarIndicesDeArquivoConfig = criarIndicesDeArquivoConfig

local numerosIndice = {1,2,3,4,5}--{0,1,2,3,4}
function M.formarScriptTxTIndiceAutomatico(vetor,tipo,contagemInicialPaginas)
	local script = ""
	contagemInicialPaginas = contagemInicialPaginas or 0
	if contagemInicialPaginas > 0 then
		contagemInicialPaginas = contagemInicialPaginas-1
	end
	for i=1,#vetor do
		local titulo = ""
		if vetor[i][3] == numerosIndice[1] then titulo = "titulo"
		elseif vetor[i][3] == numerosIndice[2] then titulo = "subtitulo"
		elseif vetor[i][3] == numerosIndice[3] then titulo = "subtitulo2"
		elseif vetor[i][3] == numerosIndice[4] then titulo = "subtitulo3"
		elseif vetor[i][3] == numerosIndice[5] then titulo = "subtitulo4"
		else
			titulo = "titulo"
		end
		script = script .. titulo .. "||" .. vetor[i][2] .. "||" .. vetor[i][1]+contagemInicialPaginas .. "||".. tostring(vetor[i][4]).."||\n"
	end
	if tipo == "texto" then
		if not auxFuncs.fileExists("Indices/indice 1.txt") then
			auxFuncs.criarTxTRes2("Indices/indice 1.txt",script)
		else
			auxFuncs.addTxTRes("Indices/indice 1.txt",script)
		end
	elseif tipo == "imagem" then
		auxFuncs.addTxTRes("Indices/indice 2.txt",script)
	elseif tipo == "som" then
		auxFuncs.addTxTRes("Indices/indice 3.txt",script)
	elseif tipo == "video" then
		auxFuncs.addTxTRes("Indices/indice 4.txt",script)
	elseif tipo == "animacao" then
		auxFuncs.addTxTRes("Indices/indice 5.txt",script)
	elseif tipo == "questao" then
		auxFuncs.addTxTRes("Indices/indice 6.txt",script)
	end
end
function M.formarVetorParaTxTsDeIndicesAutomatico(arquivos,tipo)
	local vetorIndices = {{},{},{},{},{},{}}
	
	for i=1,#arquivos do
		local textoArquivo = auxFuncs.lerTextoRes(tipo.."/"..arquivos[i])
		
		local filtrado = string.gsub(textoArquivo,".",{ ["\13"] = "",["\10"] = "\13\10"})
		local is_valid, error_position = validarUTF8.validate(filtrado)
		if not is_valid then
			filtrado = conversor.converterANSIparaUTFsemBoom(filtrado)
		end
		local tipoAtual = ""
		local ignorar = true
		local comecou = 0
		local primeiro = false
		local primeiraLinha = false
		local ordemElementos = {}
		for line in string.gmatch(filtrado,"([^\13\10]+)") do
			line = auxFuncs.verificarComentario(line)
			if string.len( line ) > 4 then
				local aux = tonumber(line:match("([^-]+)-"))
				if aux ~= nil then
					primeiro = false
				end
				if aux ~= nil and primeiro == false then
					if string.find( line, "texto" ) ~= nil then
						tipoAtual = "texto"
					elseif string.find( line, "imagem" ) ~= nil then
						tipoAtual = "imagem"
					elseif string.find( line, "som" ) ~= nil then
						tipoAtual = "som"
					elseif string.find( line, "video" ) ~= nil then
						tipoAtual = "video"
					elseif string.find( line, "animacao" ) ~= nil then
						tipoAtual = "animacao"
					elseif string.find( line, "exercicio" ) ~= nil then
						tipoAtual = "questao"
					end
					primeiro = true
					if primeiraLinha == false then
						comecou = 1
						primeiraLinha = true
					else
						comecou = #arquivos+1
					end
					-----------------------------
					-- pegando numero Elemento --
					-----------------------------
					if string.find( line, "imagem com texto" ) ~= nil then
						table.insert(ordemElementos,"imagemTexto")
					elseif string.find( line, "imagem" ) ~= nil or string.find( line, "figura" )then
						table.insert(ordemElementos,"imagem")
					elseif string.find( line, "texto" ) ~= nil then
						table.insert(ordemElementos,"texto")
					elseif string.find( line, "exercicio" ) ~= nil or string.find( line, "questao" ) ~= nil then
						table.insert(ordemElementos,"exercicio")
					elseif string.find( line, "video" ) ~= nil then
						table.insert(ordemElementos,"video")
					elseif string.find( line, "som" ) ~= nil then
						table.insert(ordemElementos,"som")
					elseif string.find( line, "botao" ) ~= nil then
						table.insert(ordemElementos,"botao")
					elseif string.find( line, "animacao" ) ~= nil then
						table.insert(ordemElementos,"animacao")
					elseif string.find( line, "separador" ) ~= nil then
						table.insert(ordemElementos,"separador")
					elseif string.find( line, "espaco" ) ~= nil then
						table.insert(ordemElementos,"espaco")
					elseif string.find( line, "card" ) ~= nil then
						table.insert(ordemElementos,"card")
					elseif string.find( line, "fundo" ) ~= nil then
						table.insert(ordemElementos,"fundo")
					end
					-----------------------------
					-----------------------------
				elseif primeiro == true and string.find(line,"=") then
					local linhaReduzida = line:match("=([^=]+)")
					if linhaReduzida then -- mudança 12/11/2021 devido a palavra seguida de igual sem texto posterior
						local propriedade,aux,num = string.match(line,"([^%s]+)%s*=(.+)||(%d+)")
						if not num then num = "1" end
						num = tonumber(num)
						
						if propriedade and string.find(string.lower(propriedade),"indice") and aux then
							if tipoAtual == "texto" then
								table.insert(vetorIndices[1],{i,aux,num,#ordemElementos})
							elseif tipoAtual == "imagem" then
								table.insert(vetorIndices[2],{i,aux,num,#ordemElementos})
							elseif tipoAtual == "som" then
								table.insert(vetorIndices[3],{i,aux,num,#ordemElementos})
							elseif tipoAtual == "video" then
								table.insert(vetorIndices[4],{i,aux,num,#ordemElementos})
							elseif tipoAtual == "animacao" then
								table.insert(vetorIndices[5],{i,aux,num,#ordemElementos})
							elseif tipoAtual == "questao" then
								table.insert(vetorIndices[6],{i,aux,num,#ordemElementos})
							end
						end
						propriedade,aux,num = nil,nil,nil
					end
				end
			end
		end
	end
	
	return vetorIndices
end
------------------------------------------------------------------
--CRIAR SOM APARTIR DE ARQUIVO --------------------------------
------------------------------------------------------------------
function criarSonsDeArquivoPadraoAux(vetorTodas,padrao,atributos,listaDeErros)
--ATRIBUTOS: arquivo ,temImagem, imagemReiniciar,	largura, altura					--
-- imagemPause, imagemPauseHeight, imagemPauseWidth
	--print(atributos.arquivo)
	for j=1,#vetorTodas do
		if vetorTodas[j] ~= nil then
			vetorTodas[j] = auxFuncs.verificarComentario(vetorTodas[j])
			--vetorTodas[j] = conversor.converterANSIparaUTFsemBoom(vetorTodas[j])
			if string.find( vetorTodas[j]:match("([^=]+)="), "arquivo" ) ~= nil then
				lixo,str = vetorTodas[j]:match("([^=]+)=+%s*([^\13]+)")
				local jaAdicionou = false
				for past in string.gmatch(str, '([^\13]+)') do
					if string.len(past) > 4 and string.find( past, '[.]' ) ~= nil and auxFuncs.checarExtensaoAudio(past) then
						vetorTodas.arquivo = atributos.pasta.."/Outros Arquivos/"..past
						--vetorTodas.arquivo = string.gsub(vetorTodas.arquivo,"\13","")
					else
						if jaAdicionou == false then
							jaAdicionou = true
						end
					end
				end
			end
			
			if string.find( vetorTodas[j]:match("([^=]+)="), "URL" ) ~= nil or string.find( vetorTodas[j]:match("([^=]+)="), 'url' ) ~= nil and not string.find( vetorTodas[j]:match("([^=]+)="), 'beded' )then
				vetorTodas.url = {}
				local arquivos = {}
				local xxy = 1
				lixo,str = vetorTodas[j]:match("([^=]+)=+%s*([^\13]+)")
				str = string.gsub(str,"[ ]+","")
				if string.gsub(str," ","") == "nil" then
					vetorTodas.url = nil
				else
					for past in string.gmatch(str, '([^|]+)') do
						vetorTodas.url[xxy] = past
						xxy = xxy + 1
					end
					local i = 1
					while i <= #vetorTodas.url do
						if string.len(vetorTodas.url[i]) < 1 then
							vetorTodas.url = {}
							i = #vetorTodas.url+1
						end
						i = i+1
					end
				end
			end
			
			if string.find( vetorTodas[j]:match("([^=]+)="), "atributo ALT" ) ~= nil or string.find( vetorTodas[j]:match("([^=]+)="), "atributo alt" ) ~= nil or string.find( vetorTodas[j]:match("([^=]+)="), "atributoAlt" ) ~= nil or string.find( vetorTodas[j]:match("([^=]+)="), "atributoALT" ) ~= nil then
				lixo,str = vetorTodas[j]:match("([^=]+)=+([^\13]+)")
				if string.len(str) > 0 then
					local aux = str
					vetorTodas.atributoALT = aux
					if string.gsub(aux," ","") == "nil" then
						vetorTodas.atributoALT = ""
					end
				else
					table.insert(listaDeErros, "Arquivo: "..atributos.arquivo.. " -> Item - 'atributo ALT'".." está vazio")
					
					vetorTodas.atributoALT = padrao.atributoALT
				end
			end
			
			if string.find( vetorTodas[j]:match("([^=]+)="), "conteudo" ) ~= nil  then
				lixo,str = vetorTodas[j]:match("([^=]+)=+([^\13]+)")
				if string.len(str) > 0 then
					local aux = str
					vetorTodas.conteudo = aux
					if string.gsub(aux," ","") == "nil" then
						vetorTodas.conteudo = ""
					end
				else
					table.insert(listaDeErros, "Arquivo: "..atributos.arquivo.. " -> Item - 'conteudo'".." está vazio")
					
					vetorTodas.conteudo = padrao.conteudo
				end
			end
			
			if string.find( vetorTodas[j]:match("([^=]+)="), 'avancar automatico' ) ~= nil then
				local aux = "nao"
				local lixo,str = vetorTodas[j]:match("([^=]+)%s*=+%s*([^\13]+)")
				for past in string.gmatch(str, '([a-z]+)') do
					aux = past
				end
				vetorTodas.avancar = aux
				if (vetorTodas.avancar ~= "sim") and (vetorTodas.avancar ~= "nao") then
					vetorTodas.avancar = "nao"
				end
			end
			
			if string.find( vetorTodas[j]:match("([^=]+)="), 'tocar automatico' ) ~= nil then
				local aux = "nao"
				lixo,str = vetorTodas[j]:match("([^=]+)=+([^?]+)")
				for past in string.gmatch(str, '([a-z]+)') do
					aux = past
				end
				vetorTodas.automatico = aux
				if (vetorTodas.automatico ~= "sim") and (vetorTodas.automatico ~= "nao") then
					vetorTodas.automatico = "nao"
				end
			end
			
			
			
			if string.find( vetorTodas[j]:match("([^=]+)="), "x " ) ~= nil or string.find( vetorTodas[j]:match("([^=]+)="), "x " ) then
				local aux = -1
				local aux2 = ""
				lixo,str = vetorTodas[j]:match("([^=]+)=+([^\13]+)")
				for past in string.gmatch(str, '([a-z]+)') do
					aux2 = past
				end
				for past in string.gmatch(str, '([0-9]+)') do
					aux = tonumber(past)
				end
				if aux2 == "nil" then
				else
					vetorTodas.x = aux
				end
				if aux2 ~= "nil" then
					if (vetorTodas.x < 0 or vetorTodas.x > W)then
						vetorTodas.x = padrao.x
					end
				end
			end
			
			if string.find( vetorTodas[j]:match("([^=]+)="), "y " ) or string.find( vetorTodas[j]:match("([^=]+)="), " saltar " ) ~= nil then
				local multiplicador = 1
				if string.find( vetorTodas[j]:match("([^=]+)="), " saltar " ) then
					multiplicador = 30
				end
				local aux = -1
				local aux2 = ""
				lixo,str = vetorTodas[j]:match("([^=]+)=+([^\13]+)")
				for past in string.gmatch(str, '([a-z]+)') do
					aux2 = past
				end
				for past in string.gmatch(str, '([0-9]+)') do
					if string.find(str,"-") then
						aux = -1*(tonumber(past) * multiplicador)
					else
						aux = tonumber(past * multiplicador)
					end
				end
				if aux2 == "nil" then
				else
					vetorTodas.y = aux  * multiplicador
				end
			end
		
			M.lerPropDicionario(atributos,vetorTodas,j)
		
		end
	end
end
M.criarSonsDeArquivoPadraoAux = criarSonsDeArquivoPadraoAux
function criarSonsDeArquivoPadrao(atributos,listaDeErros)
	
	local function lerArquivoPadrao()
		local vetor = {}
		local path = system.pathForFile( atributos.pasta.."/"..atributos.arquivo, system.ResourceDirectory )
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
						--print('non-utf8 sequence detected at position ' .. tostring(error_position))
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
	--thales1
	--ATRIBUTOS: arquivo ,temImagem, imagemReiniciar,	largura, altura					--
	-- imagemPause, imagemPauseHeight, imagemPauseWidth
	local padrao = {
						arquivo = atributos.pasta.."/Sons/som vazio.WAV",
						imagemReiniciar = nil,
						largura = nil,
						altura = nil,
						imagemPause = "pause 2.png",
						imagemPauseHeight = nil,
						imagemPauseWidth = nil,
						atributoALT = nil,
						x = nil,
						y = nil
					}
					vetorTodas.arquivo = padrao.arquivo
					vetorTodas.atributoALT = padrao.atributoALT
					vetorTodas.imagemReiniciar = padrao.imagemReiniciar
					vetorTodas.largura = padrao.largura
					vetorTodas.altura = padrao.altura
					vetorTodas.imagemPause = padrao.imagemPause
					vetorTodas.imagemPauseHeight = padrao.imagemPauseHeight
					vetorTodas.imagemPauseWidth = padrao.imagemPauseWidth
					vetorTodas.x = padrao.x
					vetorTodas.y = padrao.y
	
	criarSonsDeArquivoPadraoAux(vetorTodas,padrao,atributos,listaDeErros)
	
	return vetorTodas
end
M.criarSonsDeArquivoPadrao = criarSonsDeArquivoPadrao
------------------------------------------------------------------
--CRIAR VIDEO APARTIR DE ARQUIVO --------------------------------
------------------------------------------------------------------
function criarVideosDeArquivoPadraoAux(vetorTodas,padrao,atributos,listaDeErros)
	
	for j=1,#vetorTodas do
		if vetorTodas[j] ~= nil then
			vetorTodas[j] = auxFuncs.verificarComentario(vetorTodas[j])
			--local matchy = vetorTodas[j]:match("[%z\1-\127\194-\244][\128-\191]*")
			--if matchy and string.len(vetorTodas[j] )<= 5 then
			--	vetorTodas[j] = string.gsub(vetorTodas[j],matchy,"a = a")
			--end
			if string.find( vetorTodas[j]:match("([^=]+)="), "conteudo" ) ~= nil  then
				lixo,str = vetorTodas[j]:match("([^=]+)=+([^\13]+)")
				if string.len(str) > 0 then
					local aux = str
					
					vetorTodas.conteudo = aux
					if string.gsub(aux," ","") == "nil" then
						vetorTodas.conteudo = ""
					end
				else
					table.insert(listaDeErros, "Arquivo: "..atributos.arquivo.. " -> Item - 'conteudo'".." está vazio")
					
					vetorTodas.conteudo = padrao.conteudo
				end
			end
			if string.find( vetorTodas[j]:match("([^=]+)="), "arquivo" ) ~= nil then
				lixo,str = vetorTodas[j]:match("([^=])=+ *([^\13]+)")
				local jaAdicionou = false
				if str then
					for past in string.gmatch(str, '([A-Za-z0-9?!@#$%&":;/.,\\-_+-*ÂÃÁ ÀÉÊÍÎÕÔÓÚÜâãáàéêíîõôóúü()]+)') do
						if string.len(past) > 4 and string.find( past, '[%.]' ) ~= nil and auxFuncs.checarExtensaoVideo(past) then
							vetorTodas.arquivo = atributos.pasta.."/Outros Arquivos/"..past
						else
							if jaAdicionou == false then
								table.insert(listaDeErros, "Arquivo: "..atributos.pasta.."/"..atributos.arquivo.. " -> 'arquivo'".." contem um erro (Atenção: não use acentuações no nome do arquivo)\n")
								jaAdicionou = true
							else
								
							end
						end
					end
				else
					vetorTodas.arquivo = ""
					table.insert(listaDeErros, "Arquivo: "..atributos.pasta.."/"..atributos.arquivo.. " -> Video-> 'arquivo'".." está vazio ou não foi encontrado.")
				end
			end
			--<iframe width="403" height="238" src="https://www.youtube.com/embed/AVcKdr6ODpM" frameborder="0" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>
			if string.find( vetorTodas[j]:match("([^=]+)="), "youtube" ) ~= nil then
				lixo,str = vetorTodas[j]:match("([^=])=+ *([^\13]+)")
				local jaAdicionou = false
				if string.find(str,"be/") then
					vetorTodas.youtube = str
				elseif string.find(str,"be.com/watch%?v=") then
					vetorTodas.youtube = str
				else
					if string.gsub(str," ","") == "nil" then
						vetorTodas.youtube = nil
					else
						vetorTodas.youtube = ""
					end
				end
				if vetorTodas.youtube and string.len(vetorTodas.youtube) and string.len(vetorTodas.youtube) <= 3 then
					table.insert(listaDeErros, "Arquivo: "..atributos.arquivo.. " -> Item - 'youtube'".." está incorreto ou vazio")
					vetorTodas.youtube = nil
				end
			end
			
			if string.find( vetorTodas[j]:match("([^=]+)="), "atributo ALT" ) ~= nil or string.find( vetorTodas[j]:match("([^=]+)="), "atributo alt" ) ~= nil or string.find( vetorTodas[j]:match("([^=]+)="), "atributoAlt" ) ~= nil or string.find( vetorTodas[j]:match("([^=]+)="), "atributoALT" ) ~= nil then
				lixo,str = vetorTodas[j]:match("([^=]+)=+([^\13]+)")
				if string.len(str) > 0 then
					vetorTodas.atributoALT = str
					if string.gsub(str," ","") == "nil" then
						vetorTodas.atributoALT = ""
					end
				else
					table.insert(listaDeErros, "Arquivo: "..atributos.arquivo.. " -> Item - 'atributo ALT'".." está vazio")
					vetorTodas.atributoALT = padrao.atributoALT
				end
			end
			
			if string.find( vetorTodas[j]:match("([^=]+)="), "URL" ) ~= nil or string.find( vetorTodas[j]:match("([^=]+)="), 'url' ) ~= nil and not string.find( vetorTodas[j]:match("([^=]+)="), 'beded' )then
				vetorTodas.url = {}
				local arquivos = {}
				local xxy = 1
				print(vetorTodas[j])
				lixo,str = vetorTodas[j]:match("([^=]+)=+%s*([^\13]+)")
				str = string.gsub(str,"[ ]+","")
				if string.gsub(str," ","") == "nil" then
					vetorTodas.url = nil
				else
					for past in string.gmatch(str, '([^|]+)') do
						vetorTodas.url[xxy] = past
						xxy = xxy + 1
					end
					local i = 1
					while i <= #vetorTodas.url do
						if string.len(vetorTodas.url[i]) < 1 then
							vetorTodas.url = {}
							i = #vetorTodas.url+1
						end
						i = i+1
					end
				end
			end
			
			if string.find( vetorTodas[j]:match("([^=]+)="), " x" ) ~= nil or string.find( vetorTodas[j]:match("([^=]+)="), "-x" ) then
				local aux = -1
				local aux2 = ""
				lixo,str = vetorTodas[j]:match("([^=]+)=+([^\13]+)")
				for past in string.gmatch(str, '([a-z]+)') do
					aux2 = past
				end
				for past in string.gmatch(str, '([0-9]+)') do
					aux = tonumber(past)
				end
				if aux2 == "nil" then
				else
					vetorTodas.x = aux
				end
				if aux2 ~= "nil" then
					if (vetorTodas.x < 0 or vetorTodas.x > W)then
						table.insert(listaDeErros, "Arquivo: "..atributos.arquivo.. " -> Item - 'x'".." contem um erro no valor")
						vetorTodas.x = padrao.x
					end
				end
			end
			
			if string.find( vetorTodas[j]:match("([^=]+)="), "y" ) or string.find( vetorTodas[j]:match("([^=]+)="), " saltar " ) ~= nil then
				local multiplicador = 1
				if string.find( vetorTodas[j]:match("([^=]+)="), " saltar " ) then
					multiplicador = 30
				end
				local aux = -1
				local aux2 = ""
				lixo,str = vetorTodas[j]:match("([^=]+)=+([^\13]+)")
				for past in string.gmatch(str, '([a-z]+)') do
					aux2 = past
				end
				for past in string.gmatch(str, '([0-9]+)') do
					if string.find(str,"-") then
						aux = -1*(tonumber(past) * multiplicador)
					else
						aux = tonumber(past * multiplicador)
					end
				end
				if aux2 == "nil" then
				else
					vetorTodas.y = aux  * multiplicador
				end
			end
		
			M.lerPropDicionario(atributos,vetorTodas,j)
		
		end
	end
end
M.criarVideosDeArquivoPadraoAux = criarVideosDeArquivoPadraoAux
function criarVideosDeArquivoPadrao(atributos,listaDeErros)
	
	local function lerArquivoPadrao()
		local vetor = {}
		local path = system.pathForFile( atributos.pasta.."/"..atributos.arquivo, system.ResourceDirectory )
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
						--print('non-utf8 sequence detected at position ' .. tostring(error_position))
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
	--thales1
	local padrao = {
						arquivo = atributos.pasta.."/Outros Arquivos/video.mp4",
						url = nil,
						atributoALT = nil,
						youtube = nil,
						x = nil,
						y = nil
					}
					vetorTodas.arquivo = padrao.arquivo
					vetorTodas.url = padrao.url
					vetorTodas.atributoALT = padrao.atributoALT
					vetorTodas.youtube = padrao.youtube
					vetorTodas.x = padrao.x
					vetorTodas.y = padrao.y
	
	criarVideosDeArquivoPadraoAux(vetorTodas,padrao,atributos,listaDeErros)
	
	return vetorTodas
end
M.criarVideosDeArquivoPadrao = criarVideosDeArquivoPadrao
------------------------------------------------------------------
--CRIAR IMAGEM APARTIR DE ARQUIVO --------------------------------
------------------------------------------------------------------
function criarImagensDeArquivoPadraoAux(vetorTodas,padrao,atributos,listaDeErros)

	for j=1,#vetorTodas do
		if vetorTodas[j] ~= nil then
			local lowerString = string.lower(vetorTodas[j])
			lowerString = auxFuncs.verificarComentario(lowerString)
			
			if string.find( lowerString:match("([^=]+)="), "atributo alt" ) ~= nil or string.find( lowerString:match("([^=]+)="), "atributoalt" ) ~= nil then
				lixo,str = vetorTodas[j]:match("([^=]+)=+([^\13]+)")
				if string.len(str) > 0 then
					vetorTodas.atributoALT = str
					if string.gsub(str," ","") == "nil" then
						vetorTodas.atributoALT = ""
					end
				else
					table.insert(listaDeErros, "Arquivo: "..atributos.arquivo.. " -> Item - 'atributo ALT'".." está vazio")
					vetorTodas.atributoALT = padrao.atributoALT
				end
			end
			if string.find( lowerString:match("([^=]+)="), "conteudo" ) ~= nil  then
				lixo,str = vetorTodas[j]:match("([^=]+)=+([^\13]+)")
				if string.len(str) > 0 then
					local aux = str
					
					vetorTodas.conteudo = aux
					if string.gsub(aux," ","") == "nil" then
						vetorTodas.conteudo = ""
					end
				else
					table.insert(listaDeErros, "Arquivo: "..atributos.arquivo.. " -> Item - 'conteudo'".." está vazio")
					
					vetorTodas.conteudo = padrao.conteudo
				end
			end
			if string.find( lowerString:match("([^=]+)="), "url" ) ~= nil and not string.find( lowerString:match("([^=]+)="), 'beded' )then
				vetorTodas.url = {}
				local arquivos = {}
				local xxy = 1
				print(vetorTodas[j])
				lixo,str = vetorTodas[j]:match("([^=]+)=+%s*([^\13]+)")
				str = string.gsub(str,"[ ]+","")
				if string.gsub(str," ","") == "nil" then
					vetorTodas.url = nil
				else
					for past in string.gmatch(str, '([^|]+)') do
						vetorTodas.url[xxy] = past
						xxy = xxy + 1
					end
					local i = 1
					while i <= #vetorTodas.url do
						if string.len(vetorTodas.url[i]) < 1 then
							vetorTodas.url = {}
							i = #vetorTodas.url+1
						end
						i = i+1
					end
				end
			end
			if string.find( lowerString:match("([^=]+)="), "embeded" ) ~= nil then
				vetorTodas.urlembeded = {}
				local arquivos = {}
				local xxy = 1
				print(vetorTodas[j])
				lixo,str = vetorTodas[j]:match("([^=]+)=+%s*([^\13]+)")
				str = string.gsub(str,"[ ]+","")
				if string.gsub(str," ","") == "nil" then
					vetorTodas.urlembeded = nil
				else
					for past in string.gmatch(str, '([^|]+)') do
						vetorTodas.urlembeded[xxy] = past
						xxy = xxy + 1
					end
					local i = 1
					while i <= #vetorTodas.urlembeded do
						if string.len(vetorTodas.urlembeded[i]) < 1 then
							vetorTodas.urlembeded = {}
							i = #vetorTodas.urlembeded+1
						end
						i = i+1
					end
				end
			end
			
			if string.find( lowerString:match("([^=]+)="), "margem" ) ~= nil then
				local aux = -1
				local aux2 = ""
				lixo,str = vetorTodas[j]:match("([^=]+)=+([^\13]+)")
				for past in string.gmatch(str, '([a-z]+)') do
					aux2 = past
				end
				for past in string.gmatch(str, '([0-9]+)') do
					aux = tonumber(past)
				end
				if aux2 == "nil" then
				else
					vetorTodas.margem = aux
				end
				if aux2 ~= "nil" then
					if (vetorTodas.margem < 0 or vetorTodas.margem > W)then
						table.insert(listaDeErros, "Arquivo: "..atributos.arquivo.. " -> Item  - 'margem'".." contem um erro no valor")
						vetorTodas.margem = padrao.margem
					end
				end
			else
				--table.insert(listaDeErros, "Arquivo: "..atributos.arquivo.. " -> Item "..i.." - 'f)' não encontrado")
			end
			
			if string.find( lowerString:match("([^=]+)="), "arquivo" ) ~= nil then
				lixo,str = vetorTodas[j]:match("([^=])=+ *([^\13]+)")
				local jaAdicionou = false
				for past in string.gmatch(str, '([^\13]+)') do
					local lowerPast = string.lower(past)
					if string.len(past) > 4 and string.find( past, '[%.]' ) ~= nil and auxFuncs.checarExtensaoImagem(past) then
						vetorTodas.arquivo = atributos.pasta.."/Outros Arquivos/"..past
					else
						if jaAdicionou == false then
							table.insert(listaDeErros, "Arquivo: "..atributos.pasta.."/"..atributos.arquivo.. " -> 'arquivo'".." contem um erro (Atenção: não use acentuações no nome do arquivo)\n")
							jaAdicionou = true
						else
							
						end
					end
				end
			end
			
			if string.find( lowerString:match("([^=]+)="), "altura" ) ~= nil then
				local aux = 0
				local aux2 = ""
				lixo,str = vetorTodas[j]:match("([^=]+)=+([^\13]+)")
				for past in string.gmatch(str, '([a-z]+)') do
					aux2 = past
				end
				for past in string.gmatch(str, '([0-9]+)') do
					aux = tonumber(past)
				end
				if aux2 == "nil" then
				else
					vetorTodas.altura = aux
				end
				if aux2 ~= "nil" then
					if vetorTodas.altura < 1 then
						table.insert(listaDeErros, "Arquivo: "..atributos.arquivo.. " -> 'altura'".." contem um erro\n")
						vetorTodas.altura = padrao.altura
					end
				end
			end
			
			if string.find( lowerString:match("([^=]+)="), "comprimento" ) ~= nil then
				local aux = 0
				local aux2 = ""
				lixo,str = vetorTodas[j]:match("([^=]+)=+([^\13]+)")
				for past in string.gmatch(str, '([a-z]+)') do
					aux2 = past
				end
				for past in string.gmatch(str, '([0-9]+)') do
					aux = tonumber(past)
				end
				if aux2 == "nil" then
				else
					vetorTodas.comprimento = aux
				end
				if aux2 ~= "nil" then
					if vetorTodas.comprimento < 1 then
						table.insert(listaDeErros, "Arquivo: "..atributos.arquivo.. " -> Item 'comprimento' - 'c)'".." contem um erro\n")
						vetorTodas.comprimento = padrao.comprimento
					end
				end
			else
				--table.insert(listaDeErros, "Arquivo: "..atributos.arquivo.. " -> Item "..i.." - 'c)' não encontrado")
			end
			
			if string.find( lowerString:match("([^=]+)="), "escala" ) ~= nil then
				local aux = 0
				local aux2 = ""
				
				lixo,str = vetorTodas[j]:match("([^=]+)=+([^\13]+)")
				print("WARNING: ESCALA",str)
				for past in string.gmatch(str, '([a-z]+)') do
					aux2 = past
				end
				local aux01,aux02 = string.match(str, '(%d+)%.(%d+)')
				if aux01 and aux02 then
					aux = aux01 + aux02/(10 ^ #tostring(aux02))
				else
					aux = vetorTodas.escala
				end	
				if aux2 == "nil" then
				else
					vetorTodas.escala = aux
					if vetorTodas.escala < 0 then
						table.insert(listaDeErros, "Arquivo: "..atributos.arquivo.. " -> 'escala'".." contem um erro\n")
						vetorTodas.escala = padrao.escala
					end
				end
			end
			
			if string.find( lowerString:match("([^=]+)="), "zoom" ) ~= nil then
				local aux = nil
				lixo,str = vetorTodas[j]:match("([^=]+)=+([^\13]+)")
				for past in string.gmatch(str, '([a-z]+)') do
					aux = past
				end
				vetorTodas.zoom = aux
				if (vetorTodas.zoom ~= "sim") and (vetorTodas.zoom ~= "nao") then
					table.insert(listaDeErros, "Arquivo: "..atributos.arquivo.. " -> Item 'zoom' - 'e)'".." contem um erro\n")
					vetorTodas.zoom = padrao.zoom
				end
			else
				--table.insert(listaDeErros, "Arquivo: "..atributos.arquivo.. " -> Item "..i.." - 'e)' não encontrado")
			end
			
			if string.find( lowerString:match("([^=]+)="), "alinhamento" ) ~= nil then
				local aux = nil
				lixo,str = vetorTodas[j]:match("([^=]+)=+([^\13]+)")
				for past in string.gmatch(str, '([a-z]+)') do
					aux = past
				end
				vetorTodas.alinhamento = aux
				if (vetorTodas.alinhamento ~= "esquerda") and (vetorTodas.alinhamento ~= "meio" and vetorTodas.alinhamento ~= "direita") and (vetorTodas.alinhamento ~= "justificado") then
					table.insert(listaDeErros, "Arquivo: "..atributos.arquivo.. " -> Item  - 'alinhamento'".." contem um erro")
					vetorTodas.alinhamento = padrao.alinhamento
				end
			else
				--table.insert(listaDeErros, "Arquivo: "..atributos.arquivo.. " -> Item "..i.." - 'e)' não encontrado")
			end
			
			if string.find( lowerString:match("([^=]+)="), " x" ) ~= nil or string.find( vetorTodas[j]:match("([^=]+)="), "-x" ) then
				local aux = -1
				local aux2 = ""
				lixo,str = vetorTodas[j]:match("([^=]+)=+([^\13]+)")
				for past in string.gmatch(str, '([a-z]+)') do
					aux2 = past
				end
				for past in string.gmatch(str, '([0-9]+)') do
					aux = tonumber(past)
				end
				if aux2 == "nil" then
				else
					vetorTodas.x = aux
				end
				if aux2 ~= "nil" then
					if (vetorTodas.x < 0 or vetorTodas.x > W)then
						table.insert(listaDeErros, "Arquivo: "..atributos.arquivo.. " -> Item 'x' - 'f)'".." contem um erro no valor\n")
						vetorTodas.x = padrao.x
					end
				end
			else
				--table.insert(listaDeErros, "Arquivo: "..atributos.arquivo.. " -> Item "..i.." - 'f)' não encontrado")
			end
			
			if string.find( lowerString:match("([^=]+)="), "y" ) or string.find( vetorTodas[j]:match("([^=]+)="), " saltar " ) ~= nil then
				local multiplicador = 1
				if string.find( vetorTodas[j]:match("([^=]+)="), " saltar " ) then
					multiplicador = 30
				end
				local aux = -1
				local aux2 = ""
				lixo,str = vetorTodas[j]:match("([^=]+)=+([^\13]+)")
				for past in string.gmatch(str, '([a-z]+)') do
					aux2 = past
				end
				for past in string.gmatch(str, '([0-9]+)') do
					if string.find(str,"-") then
						aux = -1*(tonumber(past) * multiplicador)
					else
						aux = tonumber(past * multiplicador)
					end
				end
				if aux2 == "nil" then
				else
					vetorTodas.y = aux  * multiplicador
				end
			end
		
			M.lerPropDicionario(atributos,vetorTodas,j)
		
		end
	end
end
M.criarImagensDeArquivoPadraoAux = criarImagensDeArquivoPadraoAux
function criarImagensDeArquivoPadrao(atributos,listaDeErros)
	
	local function lerArquivoPadrao()
		local vetor = {}
		local path = system.pathForFile( atributos.pasta.."/"..atributos.arquivo, system.ResourceDirectory )
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
						--print('non-utf8 sequence detected at position ' .. tostring(error_position))
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
	
	--thales1
	local padrao = {
						arquivo = atributos.pasta.."/Outros Arquivos/imagemErro.jpg",
						atributoALT = nil,
						altura = nil,
						comprimento = nil,
						posicao = "topo",
						zoom = "sim",
						url = nil,
						urlembeded = nil,
						alinhamento = "meio",
						x = nil,
						y = nil,
						escala = 1
					}
					vetorTodas.arquivo = padrao.arquivo
					vetorTodas.atributoALT = padrao.atributoALT
					vetorTodas.altura = padrao.altura
					vetorTodas.comprimento = padrao.comprimento
					vetorTodas.posicao = padrao.posicao
					vetorTodas.zoom = padrao.zoom
					vetorTodas.url = padrao.url
					vetorTodas.urlembeded = padrao.urlembeded
					vetorTodas.alinhamento = padrao.alinhamento
					vetorTodas.x = padrao.x
					vetorTodas.y = padrao.y
					vetorTodas.escala = padrao.escala
	
	criarImagensDeArquivoPadraoAux(vetorTodas,padrao,atributos,listaDeErros)
	
	return vetorTodas
end
M.criarImagensDeArquivoPadrao = criarImagensDeArquivoPadrao
------------------------------------------------------------------
--CRIAR TEXTO APARTIR DE ARQUIVO --------------------------------
------------------------------------------------------------------
function criarTextosDeArquivoPadraoAux(vetorTodas,padrao,atributos,listaDeErros)
	for j=1,#vetorTodas do
		if vetorTodas[j] ~= nil then
			vetorTodas[j] = auxFuncs.verificarComentario(vetorTodas[j])
			local lowerString = string.lower(vetorTodas[j])
			if string.find( lowerString:match("([^=]+)="), "texto" ) ~= nil then
				lixo,str = vetorTodas[j]:match("([^=]+) *=+([^\13]+)")
				if string.len(str) > 0 then
					vetorTodas.texto = str
					vetorTodas.texto = string.gsub(vetorTodas.texto,"\\n","\n")
				else
					table.insert(listaDeErros, "Arquivo: "..atributos.arquivo.. " -> Item - 'texto'".." está vazio")
					vetorTodas.texto = padrao.texto
				end
			end
			
			if string.find( lowerString:match("([^=]+)="), "atributo alt" ) ~= nil or string.find( lowerString:match("([^=]+)="), "atributoalt" ) ~= nil then
				lixo,str = vetorTodas[j]:match("([^=]+) *=+ *([^\13]+)")
				if string.len(str) > 0 then
					vetorTodas.atributoALT = str
					if string.gsub(str," ","") == "nil" then
						vetorTodas.atributoALT = ""
					end
				else
					table.insert(listaDeErros, "Arquivo: "..atributos.arquivo.. " -> Item - 'atributo ALT'".." está vazio")
					vetorTodas.atributoALT = padrao.atributoALT
				end
			end
			
			if string.find( lowerString:match("([^=]+)="), "url" ) ~= nil and not string.find( lowerString:match("([^=]+)="), 'beded' )then
				vetorTodas.url = {}
				local arquivos = {}
				local xxy = 1
				print(vetorTodas[j])
				lixo,str = vetorTodas[j]:match("([^=]+) *=+ *([^\13]+)")
				str = string.gsub(str,"%s+","")
				if string.len(str) > 0 then
					if str == "nil" then
						vetorTodas.url = nil
					else
						for past in string.gmatch(str, '([^|]+)') do
							vetorTodas.url[xxy] = past
							xxy = xxy + 1
						end
						local i = 1
						while i <= #vetorTodas.url do
							if string.len(vetorTodas.url[i]) < 1 then
								vetorTodas.url = {}
								i = #vetorTodas.url+1
							end
							i = i+1
						end
					end
				else
					table.insert(listaDeErros, "Arquivo: "..atributos.arquivo.. " -> Item  - 'url'".." está vazio")
					vetorTodas.url = padrao.url
				end
			end
			
			if string.find( lowerString:match("([^=]+)="), "urlembeded" ) ~= nil or string.find( lowerString:match("([^=]+)="), "url embeded" ) then
				vetorTodas.urlEmbeded = {}
				local arquivos = {}
				local xxy = 1
				print(vetorTodas[j])
				lixo,str = vetorTodas[j]:match("([^=]+) *=+ *([^\13]+)")
				str = string.gsub(str,"%s+","")
				if string.len(str) > 0 then
					if str == "nil" then
						vetorTodas.urlEmbeded = nil
					else
						for past in string.gmatch(str, '([^|]+)') do
							vetorTodas.urlEmbeded[xxy] = past
							xxy = xxy + 1
						end
						local i = 1
						while i <= #vetorTodas.urlEmbeded do
							if string.len(vetorTodas.urlEmbeded[i]) < 1 then
								vetorTodas.urlEmbeded = {}
								i = #vetorTodas.urlEmbeded+1
							end
							i = i+1
						end
					end
				else
					table.insert(listaDeErros, "Arquivo: "..atributos.arquivo.. " -> Item  - 'urlEmbeded'".." está vazio")
					vetorTodas.urlEmbeded = padrao.urlEmbeded
				end
			end
		
			if string.find( lowerString:match("([^=]+)="), "tamanho" ) ~= nil then
				local aux = -1
				local aux2 = ""
				lixo,str = vetorTodas[j]:match("([^=]+) *=+ *([^\13]+)")
				for past in string.gmatch(str, '([a-z]+)') do
					aux2 = past
				end
				for past in string.gmatch(str, '([0-9]+)') do
					aux = tonumber(past)
				end
				if aux2 == "nil" then
					vetorTodas.tamanho = nil
				else
					vetorTodas.tamanho = aux
				end
				if aux2 ~= "nil" then
					if (vetorTodas.tamanho < 1 or vetorTodas.tamanho > W)then
						table.insert(listaDeErros, "Arquivo: "..atributos.arquivo.. " -> Item  - 'tamanho'".." contem um erro no valor ou um valor muito alto")
						vetorTodas.tamanho = padrao.tamanho
					end
				end
			end
			if string.find( lowerString:match("([^=]+)="), "espacamento" ) ~= nil then
				local aux = -1
				local aux2 = ""
				lixo,str = vetorTodas[j]:match("([^=]+) *=+ *([^\13]+)")
				for past in string.gmatch(str, '([a-z]+)') do
					aux2 = past
				end
				for past in string.gmatch(str, '([0-9]+)') do
					aux = tonumber(past)
				end
				if aux2 == "nil" then
					vetorTodas.espacamento = nil
				else
					vetorTodas.espacamento = aux
				end
				if aux2 ~= "nil" then
					if vetorTodas.espacamento < 0 then
						table.insert(listaDeErros, "Arquivo: "..atributos.arquivo.. " -> Item  - 'espacamento'".." contem um erro.")
						vetorTodas.espacamento = padrao.espacamento
					end
				end
			end
			if string.find( lowerString:match("([^=]+)="), "margem" ) ~= nil then
				local aux = -1
				local aux2 = ""
				lixo,str = vetorTodas[j]:match("([^=]+) *=+ *([^\13]+)")
				for past in string.gmatch(str, '([a-z]+)') do
					aux2 = past
				end
				for past in string.gmatch(str, '([0-9]+)') do
					aux = tonumber(past)
				end
				if aux2 == "nil" then
					vetorTodas.margem = nil
				else
					vetorTodas.margem = aux
				end
				if aux2 ~= "nil" then
					if (vetorTodas.margem < 0 or vetorTodas.margem > W/2)then
						table.insert(listaDeErros, "Arquivo: "..atributos.arquivo.. " -> Item  - 'margem'".." contem um erro no valor ou um valor muito alto")
						vetorTodas.margem = padrao.margem
					end
				end
			end
		
			if string.find( lowerString:match("([^=]+)="), "negrito" ) ~= nil then
				local aux = nil
				lixo,str = vetorTodas[j]:match("([^=]+) *=+ *([^\13]+)")
				for past in string.gmatch(str, '([a-z]+)') do
					aux = past
				end
				vetorTodas.negrito = aux
				if (vetorTodas.negrito ~= "sim") and (vetorTodas.negrito ~= "nao") then
					table.insert(listaDeErros, "Arquivo: "..atributos.arquivo.. " -> Item  - 'negrito'".." contem um erro")
					vetorTodas.negrito = padrao.negrito
				end
			end
		
			if string.find( lowerString:match("([^=]+)="), "fonte" ) ~= nil then
				local aux = " "
				lixo,str = vetorTodas[j]:match("([^=]+) *=+ *([^\13]+)")
				for past in string.gmatch(str, '([A-Za-z.0-9]+)') do
					aux = past
				end
				vetorTodas.fonte = aux
				if (vetorTodas.fonte ~= "arial") and (vetorTodas.fonte ~= "times") and (vetorTodas.fonte ~= "calibri") and not string.find(vetorTodas.fonte, "%.ttf") and not string.find(vetorTodas.fonte, "%.otf") == nil then
					table.insert(listaDeErros, "Arquivo: "..atributos.arquivo.. " -> Item  - 'fonte'".." contem um erro")
					vetorTodas.fonte = padrao.fonte
				end
				if (string.find(vetorTodas.fonte, ".ttf") ~= nil or string.find(vetorTodas.fonte, ".otf") ~= nil) and (vetorTodas.fonte ~= "arial") and (vetorTodas.fonte ~= "times") and (vetorTodas.fonte ~= "calibri") then
					vetorTodas.fonte = "Fontes/"..aux
				else
					vetorTodas.fonte = aux
				end
			end
		
			if string.find( lowerString:match("([^=]+)="), "alinhamento" ) ~= nil then
				local aux = nil
				lixo,str = vetorTodas[j]:match("([^=]+) *=+ *([^\13]+)")
				for past in string.gmatch(str, '([a-z]+)') do
					aux = past
				end
				vetorTodas.alinhamento = aux
				if (vetorTodas.alinhamento ~= "esquerda") and (vetorTodas.alinhamento ~= "meio" and vetorTodas.alinhamento ~= "direita") and (vetorTodas.alinhamento ~= "justificado") then
					table.insert(listaDeErros, "Arquivo: "..atributos.arquivo.. " -> Item  - 'alinhamento'".." contem um erro")
					vetorTodas.alinhamento = padrao.alinhamento
				end
			end

			if string.find( lowerString:match("([^=]+)="), "cor" ) ~= nil and string.find( lowerString:match("([^=]+)="), "corsombra" ) == nil  and string.find( lowerString:match("([^=]+)="), "cor sombra" ) == nil  then
				if not vetorTodas.cor then vetorTodas.cor = {} end
				local xxy = 1
				local lixo,str = vetorTodas[j]:match("([^=]+) *=+ *([^\13]+)")
				for num in string.gmatch(str,'([0-9]+)')do
					vetorTodas.cor[xxy] = tonumber(num)
					xxy = xxy+1
				end
				local k = 1
				while k < 3 do
					if vetorTodas.cor[k] < 0 or vetorTodas.cor[k] > 255 or #vetorTodas.cor > 3 then
						table.insert(listaDeErros, "Arquivo: "..atributos.arquivo.. " -> Item  - 'cor'".." contem um erro")
						vetorTodas.cor[1],vetorTodas.cor[2],vetorTodas.cor[3] = padrao.cor[1],padrao.cor[2],padrao.cor[3]
						k=3
					end
					k = k+1
				end
			end
			
			if string.find( lowerString:match("([^=]+)="), "corsombra" ) ~= nil or string.find( lowerString:match("([^=]+)="), "cor sombra" ) ~= nil then
				local xxy = 1
				if not vetorTodas.corSombra then vetorTodas.corSombra = {} end
				local lixo,str = vetorTodas[j]:match("([^=]+) *=+ *([^\13]+)")
				for num in string.gmatch(str,'([0-9%.]+)')do
					vetorTodas.corSombra[xxy] = tonumber(num)
					xxy = xxy+1
				end
				local k = 1
				while k < 4 do
					if vetorTodas.corSombra[k] < 0 or vetorTodas.corSombra[k] > 255 or #vetorTodas.corSombra > 4 then
						table.insert(listaDeErros, "Arquivo: "..atributos.arquivo.. " -> Item  - 'corSombra'".." contem um erro")
						vetorTodas.corSombra[1],vetorTodas.corSombra[2],vetorTodas.corSombra[3],vetorTodas.corSombra[4] = padrao.corSombra[1],padrao.corSombra[2],padrao.corSombra[3],padra.corSombra[4]
						k=4
					end
					k = k+1
				end
			end
			
			if string.find( lowerString:match("([^=]+)="), "sombra" ) ~= nil and string.find( lowerString:match("([^=]+)="), "corsombra" ) == nil  and string.find( lowerString:match("([^=]+)="), "cor sombra" ) == nil then
				local xxy = 1
				if not vetorTodas.sombra then vetorTodas.sombra = {} end
				local lixo,str = vetorTodas[j]:match("([^=]+) *=+ *([^\13]+)")
				for num in string.gmatch(str,'([0-9%-]+)')do
					vetorTodas.sombra[xxy] = tonumber(num)
					xxy = xxy+1
				end
				local k = 1
				while k <= #vetorTodas.sombra do
					print("sombra?",k,#vetorTodas.sombra)
					if not vetorTodas.sombra[1] or not vetorTodas.sombra[2] then
						table.insert(listaDeErros, "Arquivo: "..atributos.arquivo.. " -> Item  - 'sombra'".." contem um erro")
						vetorTodas.sombra[1],vetorTodas.sombra[2] = 1,1
						k=2
					end
					k = k+1
				end
				print("tentando ler sombra2:"..vetorTodas.sombra[1]..vetorTodas.sombra[2])
			end
			
			if string.find( lowerString:match("([^=]+)="), " x" ) ~= nil or string.find( lowerString:match("([^=]+)="), "-x" ) then
				local aux = -1
				local aux2 = ""

				lixo,str = vetorTodas[j]:match("([^=]+) *=+ *([^\13]+)")
				for past in string.gmatch(str, '([a-z]+)') do
					aux2 = past
				end
				for past in string.gmatch(str, '([0-9]+)') do
					aux = tonumber(past)
				end
				if aux2 == "nil" then
				else
					vetorTodas.x = aux
				end
				if aux2 ~= "nil" then
					if (vetorTodas.x < 0 or vetorTodas.x > W)then
						table.insert(listaDeErros, "Arquivo: "..atributos.arquivo.. " -> Item  - 'x'".." contem um erro no valor ou um valor muito alto.")
						vetorTodas.x = padrao.x
					end
				end
			end
			
			if string.find( lowerString:match("([^=]+)="), "y" ) then
				local aux = nil
				local aux2 = ""
				lixo,str = vetorTodas[j]:match("([^=]+) *=+ *([^\13]+)")
				for past in string.gmatch(str, '([a-z]+)') do
					aux2 = past
				end
				for past in string.gmatch(str, '([0-9]+)') do
					if string.find(str,"-") then
						aux = -1*(tonumber(past))
					else
						aux = tonumber(past)
					end
				end
				if aux2 == "nil" then
				else
					if aux then
						vetorTodas.y = aux
					else
						table.insert(listaDeErros, "Arquivo: "..atributos.arquivo.. " -> Item  - 'y'".." contem um erro no valor")
						vetorTodas.x = padrao.x
					end
				end
			end
			
			M.lerPropDicionario(atributos,vetorTodas,j)
		
		end
	end
end
M.criarTextosDeArquivoPadraoAux = criarTextosDeArquivoPadraoAux
function criarTextosDeArquivoPadrao(atributos,listaDeErros)
	
	local function lerArquivoPadrao()
		local vetor = {}
		local path = system.pathForFile( atributos.pasta.."/"..atributos.arquivo, system.ResourceDirectory )
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
						--print('non-utf8 sequence detected at position ' .. tostring(error_position))
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
	--thales1
	local padrao = {
						texto = "(Erro no texto)",
						url = nil,
						urlEmbeded = nil,
						tamanho = 40,
						negrito = "nao",
						posicao = "topo",
						fonte = nil,
						alinhamento = nil,
						atributoALT = nil,
						margem = 0,
						cor = {180,180,180},
						x = nil,
						y = nil,
						espacamento = 0
					}
							
					vetorTodas.texto = padrao.texto
					vetorTodas.url = padrao.url
					vetorTodas.urlEmbeded = padrao.urlEmbeded
					vetorTodas.tamanho = padrao.tamanho
					vetorTodas.negrito = padrao.negrito
					vetorTodas.posicao = padrao.posicao
					vetorTodas.fonte = padrao.fonte
					vetorTodas.alinhamento = padrao.alinhamento
					vetorTodas.cor = padrao.cor
					vetorTodas.margem = padrao.margem
					vetorTodas.atributoALT = padrao.atributoALT
					vetorTodas.x = padrao.x
					vetorTodas.y = padrao.y
					vetorTodas.espacamento = padrao.espacamento
					
	criarTextosDeArquivoPadraoAux(vetorTodas,padrao,atributos,listaDeErros)
	
					
	return vetorTodas
end
M.criarTextosDeArquivoPadrao = criarTextosDeArquivoPadrao
------------------------------------------------------------------
--CRIAR BOTÃO APARTIR DE ARQUIVO ---------------------------------
------------------------------------------------------------------
-- colocarBotao({fundoUp = "",fundoDown = "",acao = "",altura = 0,comprimento = 0,x = 0,y = 0, posicao = "",tipo = "",titulo = {texto = "",tamanho = 30,cor={0,0,0}}},telas)
function criarBotoesDeArquivoPadraoAux(vetorTodas,padrao,atributos,listaDeErros)

	for j=1,#vetorTodas do
		if vetorTodas[j] ~= nil then
			vetorTodas[j] = auxFuncs.verificarComentario(vetorTodas[j])
			local auxMatch = vetorTodas[j]:match("([^=]+)=")
			if string.find( vetorTodas[j]:match("([^=]+)="), "conteudo" ) ~= nil  then
				lixo,str = vetorTodas[j]:match("([^=]+)=+([^\13]+)")
				if string.len(str) > 0 then
					local aux = str
					
					vetorTodas.conteudo = aux
					if string.gsub(aux," ","") == "nil" then
						vetorTodas.conteudo = ""
					end
				else
					table.insert(listaDeErros, "Arquivo: "..atributos.arquivo.. " -> Item - 'conteudo'".." está vazio")
					
					vetorTodas.conteudo = padrao.conteudo
				end
			end
			if string.find( string.lower(auxMatch), "video" ) ~= nil  and string.find( vetorTodas[j]:match("([^=]+)="), "acao" ) == nil then
				lixo,str = vetorTodas[j]:match("([^=])=+ +([^\13]+)")
				local jaAdicionou = false
				for past in string.gmatch(str, '([^\13]+)') do
					if string.find(past,"be/") or string.find(past,"be.com/watch%?v=") then
						vetorTodas.video = past
					elseif string.len(past) > 4 and string.find( past, '[%.]' ) ~= nil and auxFuncs.checarExtensaoVideo(past) then
						vetorTodas.video = atributos.pasta.."/Outros Arquivos/"..past
					else
						if string.gsub(past," ","") == "nil" then
							vetorTodas.video = nil
						else
							if jaAdicionou == false then
								table.insert(listaDeErros, "Arquivo: "..atributos.pasta.."/"..atributos.arquivo.. " -> 'video'".." contem um erro (Atenção: não use acentuações no nome do arquivo)\n")
								jaAdicionou = true
							end
						end
					end
				end
			end
			
			if string.find( string.lower(auxMatch), "imagem" ) ~= nil and string.find( vetorTodas[j]:match("([^=]+)="), "acao" ) == nil then
				lixo,str = vetorTodas[j]:match("([^=])=+ *([^\13]+)")
				local jaAdicionou = false
				for past in string.gmatch(str, '([A-Za-z0-9?!@#$%&":;/.,\\-_+-*ÂÃÁ ÀÉÊÍÎÕÔÓÚÜâãáàéêíîõôóúü()]+)') do
					if string.len(past) > 4 and string.find( past, '[%.]' ) ~= nil and auxFuncs.checarExtensaoImagem(past) then
						vetorTodas.imagem = atributos.pasta.."/Outros Arquivos/"..past
					else
						if string.gsub(past," ","") == "nil" then
							vetorTodas.imagem = nil
						else
							if jaAdicionou == false then
								table.insert(listaDeErros, "Arquivo: "..atributos.pasta.."/"..atributos.arquivo.. " -> 'imagem'".." contem um erro (Atenção: não use acentuações no nome do arquivo)\n")
								jaAdicionou = true
							end
						end
					end
				end
			end
			if string.find( string.lower(auxMatch), "cor" ) ~= nil then
				local xxy = 1
				vetorTodas.cor = {}
				local lixo,str = vetorTodas[j]:match("([^=]+)%s*=+%s*([^\13]+)")
				for num in string.gmatch(str, '([0-9]+)') do
					vetorTodas.cor[xxy] = tonumber(num)
					xxy = xxy+1
				end
				local k = 1
				while k < 3 do
					if vetorTodas.cor[k] < 0 or vetorTodas.cor[k] > 255 or #vetorTodas.cor > 3 then
						
						vetorTodas.cor[1],vetorTodas.cor[2],vetorTodas.cor[3] = padrao.cor[1],padrao.cor[2],padrao.cor[3]
						k=3
					end
					k = k+1
				end
			end
			if string.find( string.lower(auxMatch), "fundoup" ) ~= nil then
				if j == 1 then
					print("Vaii...")
					print(vetorTodas[j])
				end
				lixo,str = vetorTodas[j]:match("([^=])=+ *([^\13]+)")
				local jaAdicionou = false
				if j == 1 then
					print("Oque achou?")
					print(str)
				end
				for past in string.gmatch(str, '([A-Za-z0-9?!@#$%&":;/.,\\-_+-*ÂÃÁ ÀÉÊÍÎÕÔÓÚÜâãáàéêíîõôóúü()]+)') do
					if string.len(past) > 4 and string.find( past, '[.]' ) ~= nil and (string.find( past, "jpg" ) ~= nil or string.find( past, "JPG" ) ~= nil or string.find( past, "png" ) ~= nil or string.find( past, "PNG" ) ~= nil or string.find( past, "bmp" ) ~= nil or string.find( past, "BMP" ) ~= nil) then
						vetorTodas.fundoUp = atributos.pasta.."/Outros Arquivos/"..past
					else
						if jaAdicionou == false then
							jaAdicionou = true
						end
					end
				end
				if j == 1 then
					print("huum")
					print(vetorTodas.fundoUp)
				end
			end
			if string.find( string.lower(auxMatch), "fundodown" ) ~= nil then
				lixo,str = vetorTodas[j]:match("([^=])=+ *([^\13]+)")
				local jaAdicionou = false
				for past in string.gmatch(str, '([A-Za-z0-9?!@#$%&":;/.,\\-_+-*ÂÃÁ ÀÉÊÍÎÕÔÓÚÜâãáàéêíîõôóúü()]+)') do
					if string.len(past) > 4 and string.find( past, '[.]' ) ~= nil and (string.find( past, "jpg" ) ~= nil or string.find( past, "JPG" ) ~= nil or string.find( past, "png" ) ~= nil or string.find( past, "PNG" ) ~= nil or string.find( past, "bmp" ) ~= nil or string.find( past, "BMP" ) ~= nil) then
						vetorTodas.fundoDown = atributos.pasta.."/Outros Arquivos/"..past
					else
						if jaAdicionou == false then
							jaAdicionou = true
						end
					end
				end
			end
			
			if string.find( string.lower(auxMatch), "atributo alt" ) ~= nil or string.find( string.lower(auxMatch), "atributoalt" ) ~= nil then
				lixo,str = vetorTodas[j]:match("([^=]+)=+([^\13]+)")
				if string.len(str) > 0 then
					vetorTodas.atributoALT = str
					if string.gsub(str," ","") == "nil" then
						vetorTodas.atributoALT = ""
					end
				else
					table.insert(listaDeErros, "Arquivo: "..atributos.arquivo.. " -> Item - 'atributo ALT'".." está vazio")
					vetorTodas.atributoALT = padrao.atributoALT
				end
			end
			if string.find( vetorTodas[j]:match("([^=]+)="), "URL" ) ~= nil or string.find( vetorTodas[j]:match("([^=]+)="), 'url' ) ~= nil and not string.find( vetorTodas[j]:match("([^=]+)="), 'beded' )then
				vetorTodas.url = {}
				local arquivos = {}
				local xxy = 1
				print(vetorTodas[j])
				lixo,str = vetorTodas[j]:match("([^=]+)=+%s*([^\13]+)")
				str = string.gsub(str,"[ ]+","")
				if string.gsub(str," ","") == "nil" then
					vetorTodas.url = nil
				else
					for past in string.gmatch(str, '([^|]+)') do
						vetorTodas.url[xxy] = past
						xxy = xxy + 1
					end
					local i = 1
					while i <= #vetorTodas.url do
						if string.len(vetorTodas.url[i]) < 1 then
							vetorTodas.url = {}
							i = #vetorTodas.url+1
						end
						i = i+1
					end
				end
			end
			
			if string.find( vetorTodas[j]:match("([^=]+)="), "numero" ) or string.find( vetorTodas[j]:match("([^=]+)="), " saltar " ) ~= nil then
				local multiplicador = 1
				local aux = -1
				local aux2 = ""
				lixo,str = vetorTodas[j]:match("([^=]+)=+([^\13]+)")
				for past in string.gmatch(str, '([a-z]+)') do
					aux2 = past
					print("AUXX2",aux2)
				end
				for past in string.gmatch(str, '([0-9]+)') do
					if string.find(str,"%-") then
						aux = -1*(tonumber(past) * multiplicador)
					else
						aux = tonumber(past * multiplicador)
					end
				end
				if aux2 == "nil" then
				else
					vetorTodas.numero = aux  * multiplicador
				end
			end
			
			if string.find( string.lower(auxMatch), "som" ) ~= nil  and string.find( vetorTodas[j]:match("([^=]+)="), "acao" ) == nil then
				lixo,str = vetorTodas[j]:match("([^=])=+ +([^\13]+)")
				for past in string.gmatch(str, '([^\13]+)') do
					if string.len(past) > 4 and string.find( past, '[.]' ) ~= nil and auxFuncs.checarExtensaoAudio(past) then
						vetorTodas.som = atributos.pasta.."/Outros Arquivos/"..past
						--vetorTodas.arquivo = string.gsub(vetorTodas.arquivo,"\13","")
					else
						if string.gsub(past," ","") == "nil" then
							vetorTodas.som = nil
						else
							vetorTodas.som = padrao.som
						end
					end
				end
			end
			
			if string.find( string.lower(auxMatch), 'automatico' ) ~= nil then
				local aux = "nao"
				lixo,str = vetorTodas[j]:match("([^=]+)%s*=+%s*([^?]+)")
				for past in string.gmatch(str, '([a-z]+)') do
					aux = past
				end
				vetorTodas.automatico = aux
				if (vetorTodas.automatico ~= "sim") and (vetorTodas.automatico ~= "nao") then
					vetorTodas.automatico = "nao"
				end
			end
			
			if string.find( string.lower(auxMatch), 'avancar automaticamente' ) ~= nil then
				local aux = "nao"
				lixo,str = vetorTodas[j]:match("([^=]+)=+([^\13]+)")
				for past in string.gmatch(str, '([a-z]+)') do
					aux = past
				end
				vetorTodas.avancar = aux
				if (vetorTodas.avancar ~= "sim") and (vetorTodas.avancar ~= "nao") then
					vetorTodas.avancar = "nao"
				end
			end
			if string.find( string.lower(auxMatch), 'botao pause' ) ~= nil then
				local aux = "nao"
				lixo,str = vetorTodas[j]:match("([^=]+)=+([^\13]+)")
				for past in string.gmatch(str, '([a-z]+)') do
					aux = past
				end
				vetorTodas.pause = aux
				if (vetorTodas.pause ~= "sim") and (vetorTodas.pause ~= "nao") then
					vetorTodas.pause = "nao"
				end
			end
			
			if string.find( string.lower(auxMatch), "altura" ) ~= nil then
				local aux = 0
				local aux2 = ""
				lixo,str = vetorTodas[j]:match("([^=]+)=+([^\13]+)")
				for past in string.gmatch(str, '([a-z]+)') do
					aux2 = past
				end
				for past in string.gmatch(str, '([0-9]+)') do
					aux = tonumber(past)
				end
				if aux2 == "nil" then
				else
					vetorTodas.altura = aux
				end
				if aux2 ~= "nil" then
					if vetorTodas.altura < 1 then
						table.insert(listaDeErros, "Arquivo: "..atributos.arquivo.. " -> 'altura'".." contem um erro\n")
						vetorTodas.altura = padrao.altura
					end
				end
			end
			
			if string.find( string.lower(auxMatch), "comprimento" ) ~= nil then
				local aux = 0
				local aux2 = ""
				lixo,str = vetorTodas[j]:match("([^=]+) *=+ *([^\13]+)")
				for past in string.gmatch(str, '([a-z]+)') do
					aux2 = past
				end
				for past in string.gmatch(str, '([0-9]+)') do
					aux = tonumber(past)
				end
				if aux2 == "nil" then
				else
					vetorTodas.comprimento = aux
				end
				if aux2 ~= "nil" then
					if vetorTodas.comprimento < 1 then
						table.insert(listaDeErros, "Arquivo: "..atributos.arquivo.. " -> comprimento contem um erro\n")
						vetorTodas.comprimento = padrao.comprimento
					end
				end
			end
			
			if string.find( string.lower(auxMatch), 'acao' ) ~= nil then
				vetorTodas.acao = {}
				local xxy = 1
				lixo,str = vetorTodas[j]:match("([^=]+) *=+ *([^\13]+)")
				print(vetorTodas[j])
				for past in string.gmatch(str, '([^|]+)') do
					vetorTodas.acao[xxy] = past
					xxy = xxy + 1
					print("acao!!!!!!",past)
				end
				local i = 1
				while i <= #vetorTodas.acao do
					if string.len(vetorTodas.acao[i]) < 2 then
						table.insert(listaDeErros, "Arquivo: "..atributos.arquivo.. " -> Item 'acao' contém um erro")
						vetorTodas.acao = {}
						i = #vetorTodas.acao+1
					end
					i = i+1
				end
			end
			
			if string.find( string.lower(auxMatch), "texto" ) ~= nil  and string.find( string.lower(auxMatch), "acao" ) == nil then
				lixo,str = vetorTodas[j]:match("([^=]+) *=+ *([^\13]+)")
				if string.len(str) > 0 then
					vetorTodas.texto = str
					if string.gsub(str," ","") == "nil" then
						vetorTodas.texto = nil
					end
				else
					vetorTodas.texto = padrao.texto
				end
			end
			
			if string.find( string.lower(auxMatch), 'label' ) ~= nil then
				local xxy = 1
				if not vetorTodas.titulo then vetorTodas.titulo = {} end
				if not vetorTodas.titulo.texto then vetorTodas.titulo.texto = {} end
				lixo,str = vetorTodas[j]:match("([^=]+) *=+ *([^\13]+)")
				for past in string.gmatch(str, '([^|]+)') do
					vetorTodas.titulo.texto[xxy] = past
					if string.gsub(past," ","") == "nil" then
						vetorTodas.titulo.texto[xxy] = "Ir Para"
					end
					xxy = xxy + 1
				end
				local i = 1
				if not vetorTodas.acao then vetorTodas.acao = {} end
				while i <= #vetorTodas.titulo.texto do
					if vetorTodas.acao[i] and string.len(vetorTodas.acao[i]) < 2 then
						table.insert(listaDeErros, "Arquivo: "..atributos.arquivo.. " -> Item 'acao' contém um erro")
						vetorTodas.titulo.texto = {}
						i = #vetorTodas.titulo.texto+1
					end
					i = i+1
				end
			end
			
			if string.find( string.lower(auxMatch), "tamanho" ) ~= nil then
				local aux = -1
				local aux2 = ""
				lixo,str = vetorTodas[j]:match("([^=]+) *=+ *([^\13]+)")
				for past in string.gmatch(str, '([a-z]+)') do
					aux2 = past
				end
				for past in string.gmatch(str, '([0-9]+)') do
					aux = tonumber(past)
				end
				if aux2 == "nil" then
				else
					vetorTodas.titulo.tamanho = aux
				end
				if aux2 ~= "nil" then
					if (vetorTodas.titulo.tamanho < 1 or vetorTodas.titulo.tamanho > W)then
						table.insert(listaDeErros, "Arquivo: "..atributos.arquivo.. " -> Item  - 'tamanho'".." contem um erro no valor")
						vetorTodas.titulo.tamanho = padrao.titulo.tamanho
					end
				end
			end
			
			if string.find( string.lower(auxMatch), "tipo" ) ~= nil then
				lixo,str = vetorTodas[j]:match("([^=]+) *=+ *([^\13]+)")
				if string.len(str) > 0 then
					vetorTodas.tipo = str
				else
					vetorTodas.tipo = padrao.tipo
				end
			end

			if string.find( string.lower(auxMatch), "cor" ) ~= nil then
				local xxy = 1
				local lixo,str = vetorTodas[j]:match("([^=]+) *=+ *([^\13]+)")
				if not vetorTodas.titulo then vetorTodas.titulo = {} end
				if not vetorTodas.titulo.cor then vetorTodas.titulo.cor = {} end
				for num in string.gmatch(str, '([0-9]+)') do
					vetorTodas.titulo.cor[xxy] = tonumber(num)
					xxy = xxy+1
				end
				local k = 1
				while k < 3 do
					if vetorTodas.titulo.cor[k] < 0 or vetorTodas.titulo.cor[k] > 255 or #vetorTodas.titulo.cor > 3 then
						table.insert(listaDeErros, "Arquivo: "..atributos.arquivo.. " -> Item  - 'cor'".." contem um erro")
						vetorTodas.titulo.cor[1],vetorTodas.titulo.cor[2],vetorTodas.titulo.cor[3] = padrao.titulo.cor[1],padrao.titulo.cor[2],padrao.titulo.cor[3]
						k=3
					end
					k = k+1
				end
			end
			
			if string.find( string.lower(auxMatch), " x" ) ~= nil or string.find( vetorTodas[j]:match("([^=]+)="), "-x" ) then
				local aux = -1
				local aux2 = ""
				lixo,str = vetorTodas[j]:match("([^=]+) *=+ *([^?]+)")
				for past in string.gmatch(str, '([a-z]+)') do
					aux2 = past
				end
				for past in string.gmatch(str, '([0-9]+)') do
					aux = tonumber(past)
				end
				if aux2 == "nil" then
				else
					vetorTodas.x = aux
				end
				if aux2 ~= "nil" then
					if (vetorTodas.x < 0 or vetorTodas.x > W)then
						table.insert(listaDeErros, "Arquivo: "..atributos.arquivo.. " -> Item  - 'x'".." contem um erro no valor")
						vetorTodas.x = padrao.x
					end
				end
			else
				--table.insert(listaDeErros, "Arquivo: "..atributos.arquivo.. " -> Item "..i.." - 'f)' não encontrado")
			end
			
			if string.find( string.lower(auxMatch), " y" ) or string.find( vetorTodas[j]:match("([^=]+)="), "-y" ) or string.find( vetorTodas[j]:match("([^=]+)="), " saltar " ) ~= nil then
				local multiplicador = 1
				if string.find( vetorTodas[j]:match("([^=]+)="), " saltar " ) then
					multiplicador = 30
				end
				local aux = -1
				local aux2 = ""
				lixo,str = vetorTodas[j]:match("([^=]+) *=+ *([^\13]+)")
				for past in string.gmatch(str, '([a-z]+)') do
					aux2 = past
				end
				for past in string.gmatch(str, '([0-9]+)') do
					if string.find(str,"-") then
						aux = -1*(tonumber(past) * multiplicador)
					else
						aux = tonumber(past * multiplicador)
					end
				end
				if aux2 == "nil" then
				else
					vetorTodas.y = aux  * multiplicador
				end
			end
		
			M.lerPropDicionario(atributos,vetorTodas,j)
	
		end
	end
end
M.criarBotoesDeArquivoPadraoAux = criarBotoesDeArquivoPadraoAux
-- colocarBotao({fundoUp = "",fundoDown = "",acao = "",altura = 0,comprimento = 0,x = 0,y = 0, posicao = "",tipo = "",titulo = {texto = "",tamanho = 30,cor={0,0,0}}},telas)
function criarBotoesDeArquivoPadrao(atributos,listaDeErros)
	
	local function lerArquivoPadrao()
		local vetor = {}
		local path = system.pathForFile( atributos.pasta.."/"..atributos.arquivo, system.ResourceDirectory )
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
						--print('non-utf8 sequence detected at position ' .. tostring(error_position))
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
	--thales1
	local padrao = 
	{
		fundoUp = nil,
		fundoDown = nil,
		acao = {"irPara"},
		numero = 0,
		altura = nil,
		comprimento = nil,
		titulo = {
			texto = {"Ir para!"},
			tamanho = 40,
			cor = {180,180,180}
		},
		tipo = "texto",
		posicao = "topo",
		atributoALT = nil,
		som = nil,
		texto = nil,
		video = nil,
		automatico = nil,
		avancar = nil,
		pause = nil,
		x = nil,
		y = nil
	}
							
	vetorTodas.fundoUp = padrao.fundoUp
	vetorTodas.fundoDown = padrao.fundoDown
	vetorTodas.acao = padrao.acao
	vetorTodas.numero = padrao.numero
	vetorTodas.tamanho = padrao.tamanho
	vetorTodas.altura = padrao.altura
	vetorTodas.comprimento = padrao.comprimento
	vetorTodas.titulo = padrao.titulo
	vetorTodas.tipo = padrao.tipo
	vetorTodas.posicao = padrao.posicao
	vetorTodas.atributoALT = padrao.atributoALT
	vetorTodas.som = padrao.som
	vetorTodas.texto = padrao.texto
	vetorTodas.video = padrao.video
	vetorTodas.automatico = padrao.automatico
	vetorTodas.avancar = padrao.avancar
	vetorTodas.pause = padrao.pause
	vetorTodas.x = padrao.x
	vetorTodas.y = padrao.y
					
	criarBotoesDeArquivoPadraoAux(vetorTodas,padrao,atributos,listaDeErros)
	
					
	return vetorTodas
end
M.criarBotoesDeArquivoPadrao = criarBotoesDeArquivoPadrao
------------------------------------------------------------------
--CRIAR EXERCICIO APARTIR DE ARQUIVO -----------------------------
------------------------------------------------------------------
function criarExerciciosDeArquivoPadraoAux(vetorTodas,padrao,atributos,listaDeErros)
	for j=1,#vetorTodas do
		if vetorTodas[j] ~= nil then
			vetorTodas[j] = auxFuncs.verificarComentario(vetorTodas[j])
			local Menor = string.lower(vetorTodas[j])
			if string.find( vetorTodas[j]:match("([^=]+)="), "conteudo" ) ~= nil  then
				lixo,str = vetorTodas[j]:match("([^=]+)=+([^\13]+)")
				if string.len(str) > 0 then
					local aux = str
					
					vetorTodas.conteudo = aux
					if string.gsub(aux," ","") == "nil" then
						vetorTodas.conteudo = ""
					end
				else
					table.insert(listaDeErros, "Arquivo: "..atributos.arquivo.. " -> Item - 'conteudo'".." está vazio")
					
					vetorTodas.conteudo = padrao.conteudo
				end
			end
			if string.find( vetorTodas[j]:match("([^=]+)="), 'url' ) ~= nil then
				vetorTodas.url = {}
				local arquivos = {}
				local xxy = 1
				lixo,str = vetorTodas[j]:match("([^=]+)=+%s*[^\13]+)")
				str = string.gsub(str,"[ ]+","")
				for past in string.gmatch(str, '([^|]+)') do
					vetorTodas.url[xxy] = past
					xxy = xxy + 1
				end
				local i = 1
				while i <= #vetorTodas.url do
					if string.len(vetorTodas.url[i]) < 1 then
						vetorTodas.url = {}
						i = #vetorTodas.url+1
					end
					i = i+1
				end
			end
			if string.find( vetorTodas[j]:match("([^=]+)="), "pasta" ) ~= nil then
				lixo,str = vetorTodas[j]:match("([^=]+)=+%s*([^\13]+)")	
				if type(str) == "string" and string.len(str) > 1 then
					vetorTodas.pasta = atributos.pasta.."/Outros Arquivos/"..str
					if string.gsub(str," ","") == "nil" then
						vetorTodas.pasta = nil
					end
				else
					lixo,str = vetorTodas[j]:match("([^=]+)=+%s*([^\13]+)")
					if type(str) == "string" and string.len(str) > 1 then
						vetorTodas.pasta = atributos.pasta.."/Outros Arquivos/"..str
						if string.gsub(str," ","") == "nil" then
							vetorTodas.pasta = nil
						end
					else
						vetorTodas.pasta = nil
					end
				end
			end
			
			if string.find( string.match(string.lower(vetorTodas[j]),"([^=]+)="), "tempo" ) ~= nil then
				lixo,str = vetorTodas[j]:match("([^=]+)=+%s*([^\13]+)")	
				if type(str) == "string" and string.len(str) > 1 then
					vetorTodas.tempo = str
					if string.gsub(str," ","") == "nil" then
						vetorTodas.tempo = nil
					end
				else
					lixo,str = vetorTodas[j]:match("([^=]+)=+%s*([^\13]+)")
					if type(str) == "string" and string.len(str) > 1 then
						vetorTodas.tempo = str
						if string.gsub(str," ","") == "nil" then
							vetorTodas.tempo = nil
						end
					else
						vetorTodas.tempo = nil
					end
				end
			end
			
			if string.find( string.match(string.lower(vetorTodas[j]),"([^=]+)="), "mensagem correta" ) ~= nil then
				lixo,str = vetorTodas[j]:match("([^=]+)=+%s*([^\13]+)")	
				if type(str) == "string" and string.len(str) > 1 then
					vetorTodas.mensagemCorreta = str
					if string.gsub(str," ","") == "nil" then
						vetorTodas.mensagemCorreta = nil
					end
				else
					lixo,str = vetorTodas[j]:match("([^=]+)=+%s*([^\13]+)")
					if type(str) == "string" and string.len(str) > 1 then
						vetorTodas.mensagemCorreta = str
						if string.gsub(str," ","") == "nil" then
							vetorTodas.mensagemCorreta = nil
						end
					else
						vetorTodas.mensagemCorreta = nil
					end
				end
				
			end
			
			if string.find( string.match(string.lower(vetorTodas[j]),"([^=]+)="), "mensagem incorreta" ) ~= nil then
				lixo,str = vetorTodas[j]:match("([^=]+)=+%s*([^\13]+)")	
				if type(str) == "string" and string.len(str) > 1 then
					vetorTodas.mensagemErrada = str
					if string.gsub(str," ","") == "nil" then
						vetorTodas.mensagemErrada = nil
					end
				else
					lixo,str = vetorTodas[j]:match("([^=]+)=+%s*([^\13]+)")
					if type(str) == "string" and string.len(str) > 1 then
						vetorTodas.mensagemErrada = str
						if string.gsub(str," ","") == "nil" then
							vetorTodas.mensagemErrada = nil
						end
					else
						vetorTodas.mensagemErrada = nil
					end
				end
				
			end
			
			if string.find( vetorTodas[j]:match("([^=]+)="), "margem" ) ~= nil then
				local aux = -1
				local aux2 = ""
				lixo,str = vetorTodas[j]:match("([^=]+)=+%s*([^\13]+)")
				for past in string.gmatch(str, '([a-z]+)') do
					aux2 = past
				end
				for past in string.gmatch(str, '([0-9]+)') do
					aux = tonumber(past)
				end
				if aux2 == "nil" then
				else
					vetorTodas.margem = aux
				end
				if aux2 ~= "nil" then
					if (vetorTodas.margem < 0 or vetorTodas.margem > W)then
						table.insert(listaDeErros, "Arquivo: "..atributos.arquivo.. " -> Item  - 'margem'".." contem um erro no valor")
						vetorTodas.margem = padrao.margem
					end
				end
			else
				--table.insert(listaDeErros, "Arquivo: "..atributos.arquivo.. " -> Item "..i.." - 'f)' não encontrado")
			end
			
			if string.find( vetorTodas[j]:match("([^=]+)="), "numero" ) ~= nil then
				local aux = -1
				local aux2 = ""
				lixo,str = vetorTodas[j]:match("([^=]+)=+%s*([^\13]+)")
				for past in string.gmatch(str, '([a-z]+)') do
					aux2 = past
				end
				for past in string.gmatch(str, '([0-9]+)') do
					aux = tonumber(past)
				end
				if aux2 == "nil" then
				else
					vetorTodas.numero = aux
				end
				if aux2 ~= "nil" then
					if (vetorTodas.numero < 0 or vetorTodas.numero > W)then
						table.insert(listaDeErros, "Arquivo: "..atributos.arquivo.. " -> Item  - 'numero'".." contem um erro no valor")
						vetorTodas.numero = padrao.numero
					end
				end
			else
				--table.insert(listaDeErros, "Arquivo: "..atributos.arquivo.. " -> Item "..i.." - 'f)' não encontrado")
			end
			
			if string.find( Menor:match("([^=]+)="), "fonte" ) ~= nil and string.find( vetorTodas[j]:match("([^=]+)="), "corFonte" ) == nil then
				local aux = " "
				lixo,str = vetorTodas[j]:match("([^=]+)=+%s*([^\13]+)")
				for past in string.gmatch(str, '([A-Za-z.0-9]+)') do
					aux = past
				end
				vetorTodas.fonte = aux
				if (vetorTodas.fonte ~= "arial") and (vetorTodas.fonte ~= "times") and (vetorTodas.fonte ~= "calibri") and string.find(vetorTodas.fonte, ".ttf") == nil then
					table.insert(listaDeErros, "Arquivo: "..atributos.arquivo.. " -> Item  - 'fonte'".." contem um erro")
					vetorTodas.fonte = padrao.fonte
				end
				if string.find(vetorTodas.fonte, ".ttf") ~= nil and (vetorTodas.fonte ~= "arial") and (vetorTodas.fonte ~= "times") and (vetorTodas.fonte ~= "calibri") then
					vetorTodas.fonte = "Fontes/"..aux

				end
			else
				--table.insert(listaDeErros, "Arquivo: "..atributos.arquivo.. " -> Item "..i.." - 'e)' não encontrado")
			end
			
			if string.find( vetorTodas[j]:match("([^=]+)="), "alinhamento" ) ~= nil then
				local aux = nil
				lixo,str = vetorTodas[j]:match("([^=]+)=+%s*([^\13]+)")
				for past in string.gmatch(str, '([a-z]+)') do
					aux = past
				end
				vetorTodas.alinhamento = aux
				if (vetorTodas.alinhamento ~= "esquerda") and (vetorTodas.alinhamento ~= "meio" and vetorTodas.alinhamento ~= "direita") and (vetorTodas.alinhamento ~= "justificado") then
					table.insert(listaDeErros, "Arquivo: "..atributos.arquivo.. " -> Item  - 'alinhamento'".." contem um erro")
					vetorTodas.alinhamento = padrao.alinhamento
				end
			else
				--table.insert(listaDeErros, "Arquivo: "..atributos.arquivo.. " -> Item "..i.." - 'e)' não encontrado")
			end

			if string.find( vetorTodas[j]:match("([^=]+)="), "enunciado" ) ~= nil then
				lixo,str = vetorTodas[j]:match("([^=]+)=+%s*([^\13]+)")
				if str then
					vetorTodas.enunciado = str
				else
					vetorTodas.enunciado = padrao.enunciado
				end
			end
			
			if string.find( vetorTodas[j]:match("([^=]+)="), "tamanhoEnunciado" ) ~= nil then
				local aux = -1
				local aux2 = ""
				lixo,str = vetorTodas[j]:match("([^=]+)=+%s*([^\13]+)")
				for past in string.gmatch(str, '([a-z]+)') do
					aux2 = past
				end
				for past in string.gmatch(str, '([0-9]+)') do
					aux = tonumber(past)
				end
				if aux2 == "nil" then
				else
					vetorTodas.tamanhoFonte = aux
				end
				if aux2 ~= "nil" then
					if (vetorTodas.tamanhoFonte < 1 or vetorTodas.tamanhoFonte > W)then
						vetorTodas.tamanhoFonte = padrao.tamanhoFonte
					end
				end
			end
			
			if string.find( vetorTodas[j]:match("([^=]+)="), 'alternativas' ) ~= nil and not string.find( vetorTodas[j]:match("([^=]+)="), 'alternativas sorteadas' ) then

				local arquivos = {}
				local xxy = 1
				lixo,str = vetorTodas[j]:match("([^=]+)=+%s*([^\13]+)")
				for past in string.gmatch(str, '([^|]+)') do
					vetorTodas.alternativas[xxy] = past
					xxy = xxy + 1
				end
				if xxy-1 ~= vetorTodas.numeroAlternativas then
				end
				local i = 1
				while i <= #vetorTodas.alternativas do
					if string.len(vetorTodas.alternativas[i]) < 1 then
						vetorTodas.alternativas = {}
						i = #vetorTodas.alternativas+1
					end
					i = i+1
				end
				vetorTodas.numeroAlternativas = #vetorTodas.alternativas
			end
			
			if string.find( vetorTodas[j]:match("([^=]+)="), "tamanhoAlternativas" ) ~= nil then
				local aux = -1
				local aux2 = ""
				lixo,str = vetorTodas[j]:match("([^=]+)=+%s*([^\13]+)")
				for past in string.gmatch(str, '([a-z]+)') do
					aux2 = past
				end
				for past in string.gmatch(str, '([0-9]+)') do
					aux = tonumber(past)
				end
				if aux2 == "nil" then
				else
					vetorTodas.tamanhoFonteAlternativas = aux
				end
				if aux2 ~= "nil" then
					if (vetorTodas.tamanhoFonteAlternativas < 1 or vetorTodas.tamanhoFonteAlternativas > W)then
						vetorTodas.tamanhoFonteAlternativas = padrao.tamanhoFonteAlternativas
					end
				end
			end
			
			if string.find( vetorTodas[j]:match("([^=]+)="), 'correta' ) ~= nil then
				local arquivos = {}
				local xxy = 1
				lixo,str = vetorTodas[j]:match("([^=]+)=+%s*([^\13]+)")
				for past in string.gmatch(str, '([0-9]+)') do
					vetorTodas.corretas[xxy] = tonumber(past)
					xxy = xxy + 1
					if tonumber(past) > vetorTodas.numeroAlternativas or tonumber(past) < 1 then
						native.showAlert("Atenção","O arquivo: "..atributos.arquivo.. " contém um erro!\nO campo de alternativa correta está com um número inválido.\nFavor verificar e corrigir.",{"OK"})
					end
				end
				if xxy-1 > vetorTodas.numeroAlternativas then
					table.insert(listaDeErros, "Arquivo: "..atributos.arquivo.. " -> O numero de corretas não corresponde ao de alternativas")
				end
				local i = 1
				while i <= #vetorTodas.corretas do
					if vetorTodas.corretas[i] < 1 then
						vetorTodas.corretas = {}
						i = #vetorTodas.corretas+1
					end
					i = i+1
				end
				if vetorTodas.corretas[1] then
					vetorTodas.corretas = {vetorTodas.corretas[1]}
				end
			end
			
			if string.find( vetorTodas[j]:match("([^=]+)="), 'justificativas' ) ~= nil then
				local arquivos = {}
				local xxy = 1
				lixo,str = vetorTodas[j]:match("([^=]+)=+%s*([^\13]+)")
				for past in string.gmatch(str, '([^|]+)') do
					vetorTodas.justificativas[xxy] = past
					xxy = xxy + 1
				end
				if xxy-1 ~= vetorTodas.numeroAlternativas then
				end
				local i = 1
				while i <= #vetorTodas.justificativas do
					if string.len(vetorTodas.justificativas[i]) < 1 then
						vetorTodas.justificativas = {}
						i = #vetorTodas.justificativas+1
					end
					i = i+1
				end
			end
		
			if string.find( vetorTodas[j]:match("([^=]+)="), "posicao" ) ~= nil then
				local aux = nil
				lixo,str = vetorTodas[j]:match("([^=]+)=+%s*([^\13]+)")
				for past in string.gmatch(str, '([a-z]+)') do
					aux = past
				end
				vetorTodas.posicao = aux
				if (vetorTodas.posicao ~= "topo") and (vetorTodas.posicao ~= "centro") and (vetorTodas.posicao ~= "base") then
					vetorTodas.posicao = padrao.posicao
				end
			end

			if string.find( vetorTodas[j]:match("([^=]+)="), "corFonte" ) ~= nil then
				local xxy = 1
				local lixo,str = vetorTodas[j]:match("([^=]+)=+%s*([^\13]+)")
				for num in string.gmatch(str, '([0-9]+)') do
					vetorTodas.corFonte[xxy] = tonumber(num)
					xxy = xxy+1
				end
				local k = 1
				while k < 3 do
					if vetorTodas.corFonte[k] < 0 or vetorTodas.corFonte[k] > 255 or #vetorTodas.corFonte > 3 then
						vetorTodas.corFonte[1],vetorTodas.corFonte[2],vetorTodas.corFonte[3] = padrao.corFonte[0],padrao.corFonte[1],padrao.corFonte[2]
						k=3
					end
					k = k+1
				end
			end
			
			if string.find( vetorTodas[j]:match("([^=]+)="), " x" ) ~= nil or string.find( vetorTodas[j]:match("([^=]+)="), "-x" ) then
				local aux = -1
				local aux2 = ""
				lixo,str = vetorTodas[j]:match("([^=]+)=+%s*([^\13]+)")
				for past in string.gmatch(str, '([a-z]+)') do
					aux2 = past
				end
				for past in string.gmatch(str, '([0-9]+)') do
					aux = tonumber(past)
				end
				if aux2 == "nil" then
				else
					vetorTodas.x = aux
				end
				if aux2 ~= "nil" then
					if (vetorTodas.x < 0 or vetorTodas.x > W)then
						vetorTodas.x = padrao.x
					end
				end
			else
				--table.insert(listaDeErros, "Arquivo: "..atributos.arquivo.. " -> Item "..i.." - 'f)' não encontrado")
			end
			
			if string.find( vetorTodas[j]:match("([^=]+)="), "y" ) or string.find( vetorTodas[j]:match("([^=]+)="), " saltar " ) ~= nil then
				local multiplicador = 1
				if string.find( vetorTodas[j]:match("([^=]+)="), " saltar " ) then
					multiplicador = 30
				end
				local aux = -1
				local aux2 = ""
				lixo,str = vetorTodas[j]:match("([^=]+)=+%s*([^\13]+)")
				for past in string.gmatch(str, '([a-z]+)') do
					aux2 = past
				end
				for past in string.gmatch(str, '([0-9]+)') do
					if string.find(str,"-") then
						aux = -1*(tonumber(past) * multiplicador)
					else
						aux = tonumber(past * multiplicador)
					end
				end
				if aux2 == "nil" then
				else
					vetorTodas.y = aux  * multiplicador
				end
			end
			
			if string.find( string.lower(vetorTodas[j]:match("([^=]+)=")), 'variáveis' ) ~= nil then
				local xxy = 1
				vetorTodas.vars = {}
				
				lixo,str = vetorTodas[j]:match("([^=]+)=+%s*([^\13]+)")
				str = string.gsub(str,"[ ]+","")
				for past in string.gmatch(str, '([^#]+)') do
					vetorTodas.vars[xxy] = past
					xxy = xxy + 1
				end
				local i = 1
				while i <= #vetorTodas.vars do
					if string.len(vetorTodas.vars[i]) < 1 then
						vetorTodas.vars = {}
						i = #vetorTodas.vars+1
					end
					i = i+1
				end
			end
		
			M.lerPropDicionario(atributos,vetorTodas,j)
		
		end
	end
end
M.criarExerciciosDeArquivoPadraoAux = criarExerciciosDeArquivoPadraoAux
function criarExerciciosDeArquivoPadrao(atributos,listaDeErros)
	
	local function lerArquivoPadrao()
		local vetor = {}
		local path = system.pathForFile( atributos.pasta.."/"..atributos.arquivo, system.ResourceDirectory )
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
						--print('non-utf8 sequence detected at position ' .. tostring(error_position))
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
	--thales1
	local padrao = {
						enunciado = "Assinale a alternativa correta:",
						tamanhoFonte = 70,
						alternativas = {"opção 1","opção 2"},
						tamanhoFonteAlternativas = 40,
						corretas = {1},
						correta = {1},
						justificativas = {"não possui" , "não possui"},
						posicao = "topo",
						corFonte = {180,180,180},
						x = nil,
						y = nil,
						numeroAlternativas = 2,
						mensagemCorreta = nil,
						mensagemErrada = nil,
						fonte = nil,
						alinhamento = "justificado",
						margem = 0,
						numero = 1
					}
							
					vetorTodas.enunciado = padrao.enunciado
					vetorTodas.tamanhoFonte = padrao.tamanhoFonte
					vetorTodas.alternativas = padrao.alternativas
					vetorTodas.tamanhoFonteAlternativas = padrao.tamanhoFonteAlternativas
					vetorTodas.corretas = padrao.corretas
					vetorTodas.correta = padrao.correta
					vetorTodas.justificativas = padrao.justificativas
					vetorTodas.corFonte = padrao.corFonte
					vetorTodas.posicao = padrao.posicao
					vetorTodas.numeroAlternativas = padrao.numeroAlternativas
					vetorTodas.mensagemCorreta = padrao.mensagemCorreta
					vetorTodas.mensagemErrada = padrao.mensagemErrada
					vetorTodas.x = padrao.x
					vetorTodas.y = padrao.y
					vetorTodas.fonte = padrao.fonte
					vetorTodas.alinhamento = padrao.alinhamento
					vetorTodas.margem = padrao.margem
					vetorTodas.numero = padrao.numero
					
	criarExerciciosDeArquivoPadraoAux(vetorTodas,padrao,atributos,listaDeErros)
	
					
	return vetorTodas
end
M.criarExerciciosDeArquivoPadrao = criarExerciciosDeArquivoPadrao
------------------------------------------------------------------
--CRIAR ANIMAÇÃO APARTIR DE ARQUIVOS - auxiliar do indice Manual--
------------------------------------------------------------------
function criarAnimacoesDeArquivoConfig(atributos,Telas,listaDeErros)

	local function lerArquivoIndice()
		local vetor = {}
		local path = system.pathForFile( atributos.pasta.."/"..atributos.arquivo, system.ResourceDirectory )
		local file, errorString = io.open( path, "r" )
		local xx=0
		local ignorar = true
		if not file then
			print( "File error: " .. errorString )
		else
			for line in file:lines() do
				if string.len( line ) > 7 then
					vetor[xx] = line
					xx = xx+1
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
	
	local vetorCorTexto = {}
	local vetorAnimacao = {}
	local vetorIndiceAux = lerArquivoIndice()
	for i=1,8 do
		vetorIndiceAux[#vetorIndiceAux+1] = " ="
	end
			
			ImagensAnimacao = {20,79}
			VetorAnimacao = {"Cap1Anim1","Cap1Anim1"}
			VetorTempoPorAnimacao = {150,150}
			VetorSomAnimacao = {"raio.wav","raio.wav"}
			NumeroImagensAnimacao = 45
			ExtensaoImagensAnimacao = "BMP"
			
		if string.find( vetorIndiceAux[0]:match("([^=]+)="), '1' ) ~= nil then
			local confirma = "nao"
			lixo,str = vetorIndiceAux[0]:match("([^=]+)=+([^?]+)")
			for past in string.gmatch(str, '([a-z]+)') do
				confirma = past
			end
			vetorAnimacao.temAnimacao = confirma
			if (vetorAnimacao.temAnimacao ~= "sim") and (vetorAnimacao.temAnimacao ~= "nao") then
				table.insert(listaDeErros, "Arquivo: "..atributos.arquivo.. " -> Item 1")
				vetorAnimacao.temAnimacao = "nao"
			end
		else
			table.insert(listaDeErros, "Arquivo: "..atributos.arquivo.. " -> Item 1 não encontrado")
			vetorAnimacao.temAnimacao = "nao"
		end
		
		if string.find( vetorIndiceAux[1]:match("([^=]+)="), '2' ) ~= nil then
			local aux = 0
			local xxy = 0
			lixo,str = vetorIndiceAux[1]:match("([^=]+)=+([^?]+)")
			for past in string.gmatch(str, '([0-9]+)') do
				aux = tonumber(past)
				xxy = xxy + 1
			end
			vetorAnimacao.numeroTelasComAnimacao = aux
			if xxy < 1 or  vetorAnimacao.numeroTelasComAnimacao < 1 then
				table.insert(listaDeErros, "Arquivo: "..atributos.arquivo.. " -> Item 1")
				if vetorAnimacao.numeroTelasComAnimacao < 1 then
					vetorAnimacao.numeroTelasComAnimacao = 1
				end
			end
		else
			table.insert(listaDeErros, "Arquivo: "..atributos.arquivo.. " -> Item 2 não encontrado")
			vetorAnimacao.numeroTelasComAnimacao = 1
		end
		
		if string.find( vetorIndiceAux[2]:match("([^=]+)="), '3' ) ~= nil then
			local numbers = {}
			local xxy = 1
			local lixo,str = vetorIndiceAux[2]:match("([^=]+)=+([^?]+)")
			for num in string.gmatch(str, '([0-9]+)') do
				table.insert(numbers, tonumber(num))
				xxy = xxy + 1
			end
			vetorAnimacao.telasAnimacoes = numbers
			if xxy-1 ~= vetorAnimacao.numeroTelasComAnimacao then
				table.insert(listaDeErros, "Arquivo: "..atributos.arquivo.. " -> Item 2 ou 3")
			end
			local i = 1
			while i <= #vetorAnimacao.telasAnimacoes do
				if vetorAnimacao.telasAnimacoes[i] < 1 then
					table.insert(listaDeErros, "Arquivo: "..atributos.arquivo.. " -> Item 3")
					vetorAnimacao.telasAnimacoes[i] = -10
				end
				i = i+1
			end
		else
			table.insert(listaDeErros, "Arquivo: "..atributos.arquivo.. " -> Item 3 não encontrado")
			vetorAnimacao.telasAnimacoes = {}
		end
		
		if string.find( vetorIndiceAux[3]:match("([^=]+)="), '4' ) ~= nil then
			local pastas = {}
			local xxy = 1
			lixo,str = vetorIndiceAux[3]:match("([^=]+)=+([^?]+)")
			for past in string.gmatch(str, '([^, ]+)') do
				table.insert(pastas, atributos.pasta.."/"..past)
				xxy = xxy+1
			end
			vetorAnimacao.pastasAnimacoes = pastas
			if xxy-1 ~= vetorAnimacao.numeroTelasComAnimacao then
				table.insert(listaDeErros, "Arquivo: "..atributos.arquivo.. " -> Item 2 ou 4")
			end
			local i = 1
			while i <= #vetorAnimacao.pastasAnimacoes do
				if string.len(vetorAnimacao.pastasAnimacoes[i]) < 1 then
					table.insert(listaDeErros, "Arquivo: "..atributos.arquivo.. " -> Item 4")
					i=#vetorAnimacao.pastasAnimacoes+1
					vetorAnimacao.pastasAnimacoes = {}
				end
				i = i+1
			end
		else
			table.insert(listaDeErros, "Arquivo: "..atributos.arquivo.. " -> Item 4 não encontrado")
			vetorAnimacao.pastasAnimacoes = {}
		end
		
		if string.find( vetorIndiceAux[4]:match("([^=]+)="), '5' ) ~= nil then
			local numbers = {}
			local xxy = 1
			local lixo,str = vetorIndiceAux[4]:match("([^=]+)=+([^?]+)")
			for num in string.gmatch(str, '([0-9]+)') do
				table.insert(numbers, tonumber(num))
				xxy = xxy+1
			end
			vetorAnimacao.tempoPorAnimacao = numbers
			if xxy-1 ~= vetorAnimacao.numeroTelasComAnimacao then
				table.insert(listaDeErros, "Arquivo: "..atributos.arquivo.. " -> Item 2 ou 5")
			end
			local i = 1
			while i <= #vetorAnimacao.tempoPorAnimacao do
				if vetorAnimacao.tempoPorAnimacao[i] < 1 then
					table.insert(listaDeErros, "Arquivo: "..atributos.arquivo.. " -> Item 5")
					vetorAnimacao.tempoPorAnimacao[i] = 100
				end
				i = i+1
			end
		else
			table.insert(listaDeErros, "Arquivo: "..atributos.arquivo.. " -> Item 5 não encontrado")
			vetorAnimacao.pastasAnimacoes = {}
		end
		
		if string.find( vetorIndiceAux[5]:match("([^=]+)="), '6' ) ~= nil then
			local pastas = {}
			local xxy = 1
			lixo,str = vetorIndiceAux[5]:match("([^=]+)=+([^?]+)")
			for past in string.gmatch(str, '([^, ]+)') do
				table.insert(pastas, past)
				xxy = xxy+1
			end
			vetorAnimacao.sonsAnimacoes = pastas
			if xxy-1 ~= vetorAnimacao.numeroTelasComAnimacao then
				table.insert(listaDeErros, "Arquivo: "..atributos.arquivo.. " -> Item 2 ou 6")
			end
			local i = 1
			while i <= #vetorAnimacao.sonsAnimacoes do
				if string.len(vetorAnimacao.sonsAnimacoes[i]) < 5 then
					table.insert(listaDeErros, "Arquivo: "..atributos.arquivo.. " -> Item 6")
					vetorAnimacao.sonsAnimacoes = {}
					i = #vetorAnimacao.sonsAnimacoes+1
				end
				i = i+1
			end
		else
			table.insert(listaDeErros, "Arquivo: "..atributos.arquivo.. " -> Item 6 não encontrado")
			vetorAnimacao.sonsAnimacoes = {}
		end
		
		if string.find( vetorIndiceAux[6]:match("([^=]+)="), '7' ) ~= nil then
			local numbers = {}
			local xxy = 1
			local lixo,str = vetorIndiceAux[6]:match("([^=]+)=+([^?]+)")
			for num in string.gmatch(str, '([0-9]+)') do
				table.insert(numbers, tonumber(num))
				xxy = xxy + 1
			end
			vetorAnimacao.numeroImagensPastas = numbers
			if xxy-1 ~= vetorAnimacao.numeroTelasComAnimacao then
				table.insert(listaDeErros, "Arquivo: "..atributos.arquivo.. " -> Item 2 ou 7")
			end
			local i = 1
			while i <= #vetorAnimacao.numeroImagensPastas do
				if vetorAnimacao.numeroImagensPastas[i] < 1 then
					table.insert(listaDeErros, "Arquivo: "..atributos.arquivo.. " -> Item 7")
					vetorAnimacao.numeroImagensPastas[i] = 0
				end
				i = i+1
			end
		else
			table.insert(listaDeErros, "Arquivo: "..atributos.arquivo.. " -> Item 7 não encontrado")
			vetorAnimacao.numeroImagensPastas = {}
		end
		
		if string.find( vetorIndiceAux[7]:match("([^=]+)="), '8' ) ~= nil then
			local pastas = {}
			xxy = 1
			lixo,str = vetorIndiceAux[7]:match("([^=]+)=+([^?]+)")
			for past in string.gmatch(str, '([^, ]+)') do
				table.insert(pastas, past)
				xxy = xxy + 1
			end
			vetorAnimacao.extencoes = pastas
			if xxy-1 ~= vetorAnimacao.numeroTelasComAnimacao then
				table.insert(listaDeErros, "Arquivo: "..atributos.arquivo.. " -> Item 2 ou 8")
			end
			local i = 1
			while i <= #vetorAnimacao.extencoes do
				if string.len(vetorAnimacao.extencoes[i]) < 3 then
					table.insert(listaDeErros, "Arquivo: "..atributos.arquivo.. " -> Item 8")
					vetorAnimacao.extencoes = {}
					i = #vetorAnimacao.extencoes + 1
				end
				i = i+1
			end
		else
			table.insert(listaDeErros, "Arquivo: "..atributos.arquivo.. " -> Item 8 não encontrado")
			vetorAnimacao.extencoes = {}
			vetorAnimacao.temAnimacao = "nao"
		end
		
		-- verificando arquivo de animações --
		-- for i=1,#vetorAnimacao.telasAnimacoes do
			-- print(vetorAnimacao.telasAnimacoes[i])
		-- end
		-- for i=1,#vetorAnimacao.pastasAnimacoes do
						-- print(vetorAnimacao.pastasAnimacoes[i])
					-- end
		-- for i=1,#vetorAnimacao.tempoPorAnimacao do
						-- print(vetorAnimacao.tempoPorAnimacao[i])
					-- end
		-- for i=1,#vetorAnimacao.sonsAnimacoes do
						-- print(vetorAnimacao.sonsAnimacoes[i])
					-- end
		-- if vetorAnimacao.numeroImagensPastas then
			-- for i=1,#vetorAnimacao.numeroImagensPastas do
						-- print(vetorAnimacao.numeroImagensPastas[i])
					-- end
		-- end
		-- if vetorAnimacao.extencoes then
			-- for i=1,#vetorAnimacao.extencoes do
							-- print(vetorAnimacao.extencoes[i])
						-- end
		-- end
		
		if vetorAnimacao.temAnimacao == "sim" then
			return vetorAnimacao
		else
			return nil
		end
	--Telas[#Telas+1] = {imagem = {arquivo = atributos.pasta.."/fundo.jpg"},titulo = capa1}
end
M.criarAnimacoesDeArquivoConfig = criarAnimacoesDeArquivoConfig

function criarAnimacoesDeArquivoPadraoAux(vetorTodas,padrao,atributos,listaDeErros)
	local vetorRetornado = {}

	for j=1,#vetorTodas do

		if vetorTodas[j] ~= nil then
			vetorTodas[j] = auxFuncs.verificarComentario(vetorTodas[j])
			if string.find( vetorTodas[j]:match("([^=]+)="), "conteudo" ) ~= nil  then
				lixo,str = vetorTodas[j]:match("([^=]+)=+([^\13]+)")
				if string.len(str) > 0 then
					local aux = str
					
					vetorTodas.conteudo = aux
					if string.gsub(aux," ","") == "nil" then
						vetorTodas.conteudo = ""
					end
				else
					table.insert(listaDeErros, "Arquivo: "..atributos.arquivo.. " -> Item - 'conteudo'".." está vazio")
					
					vetorTodas.conteudo = padrao.conteudo
				end
			end
			if string.find( vetorTodas[j]:match("([^=]+)="), "margem" ) ~= nil then
				local aux = -1
				local aux2 = ""
				lixo,str = vetorTodas[j]:match("([^=]+) *=+ *([^\13]+)")
				for past in string.gmatch(str, '([a-z]+)') do
					aux2 = past
				end
				for past in string.gmatch(str, '([0-9]+)') do
					aux = tonumber(past)
				end
				if aux2 == "nil" then
				else
					vetorTodas.margem = aux
				end
				if aux2 ~= "nil" then
					if (vetorTodas.margem < 0 or vetorTodas.margem > W)then
						table.insert(listaDeErros, "Arquivo: "..atributos.arquivo.. " -> Item  - 'margem'".." contem um erro no valor")
						vetorTodas.margem = padrao.margem
					end
				end
			else
				--table.insert(listaDeErros, "Arquivo: "..atributos.arquivo.. " -> Item "..i.." - 'f)' não encontrado")
			end
			if string.find( vetorTodas[j]:match("([^=]+)="), 'url' ) ~= nil then
				vetorTodas.url = {}
				local arquivos = {}
				local xxy = 1
				lixo,str = vetorTodas[j]:match("([^=]+) *=+ *([^\13]+)")
				str = string.gsub(str,"[ ]+","")
				for past in string.gmatch(str, '([^|]+)') do
					vetorTodas.url[xxy] = past
					xxy = xxy + 1
				end
				local i = 1
				while i <= #vetorTodas.url do
					if string.len(vetorTodas.url[i]) < 1 then
						vetorTodas.url = {}
						i = #vetorTodas.url+1
					end
					i = i+1
				end
			end
			if string.find( vetorTodas[j]:match("([^=]+)="), "pasta" ) ~= nil then
				lixo,str = vetorTodas[j]:match("([^=]+) *=+ *([^\13]+)")	
				if type(str) == "string" and string.len(str) > 1 then
					vetorTodas.pasta = str
				else
					vetorTodas.pasta = padrao.pasta
				end
				
			end
			if string.find( vetorTodas[j]:match("([^=]+)="), "atributo ALT" ) ~= nil or string.find( vetorTodas[j]:match("([^=]+)="), "atributo alt" ) ~= nil or string.find( vetorTodas[j]:match("([^=]+)="), "atributoAlt" ) ~= nil or string.find( vetorTodas[j]:match("([^=]+)="), "atributoALT" ) ~= nil then
				lixo,str = vetorTodas[j]:match("([^=]+)=+([^\13]+)")

				if string.len(str) > 2 then
					vetorTodas.atributoALT = str
					if string.gsub(str," ","") == "nil" then
						vetorTodas.atributoALT = ""
					end
				else
					vetorTodas.atributoALT = padrao.atributoALT
				end
			end
			if string.find( vetorTodas[j]:match("([^=]+)="), 'avancar automatico' ) ~= nil then
				local aux = "nao"
				lixo,str = vetorTodas[j]:match("([^=]+) *=+ *([^\13]+)")
				for past in string.gmatch(str, '([a-z]+)') do
					aux = past
				end
				vetorTodas.avancar = aux
				if (vetorTodas.avancar ~= "sim") and (vetorTodas.avancar ~= "nao") then
					vetorTodas.avancar = "nao"
				end
			end
			if string.find( string.lower(vetorTodas[j]:match("([^=]+)=")), 'limite avancar' ) ~= nil then
				local aux = "imagem"
				lixo,str = vetorTodas[j]:match("([^=]+) *=+ *([^\13]+)")
				for past in string.gmatch(str, '([a-z]+)') do
					aux = past
				end
				vetorTodas.limitador = aux
				if (vetorTodas.limitador ~= "som") and (vetorTodas.limitador ~= "imagem") then
					vetorTodas.limitador = "imagem"
				end
			end
			if string.find( vetorTodas[j]:match("([^=]+)="), 'imagens' ) ~= nil then
				local arquivos = {}
				vetorTodas.imagens = {}
				local xxy = 1
				lixo,str = vetorTodas[j]:match("([^=]+) *=+ *([^\13]+)")
				for past in string.gmatch(str, '([^#]+)') do
					vetorTodas.imagens[xxy] = past
					xxy = xxy + 1
				end
				local i = 1
				while i <= #vetorTodas.imagens do
					if string.len(vetorTodas.imagens[i]) < 1 then
						i = #vetorTodas.imagens+1
					end
					i = i+1
				end
				vetorTodas.numeroImagens = #vetorTodas.imagens
			end
			if string.find( vetorTodas[j]:match("([^=]+)="), "intervalo" ) ~= nil or string.find( vetorTodas[j]:match("([^=]+)="), "timer" ) ~= nil then
				
				lixo,str = vetorTodas[j]:match("([^=]+) *=+ *([^\13]+)")
				local xxy = 1
				for past in string.gmatch(str, '([0-9]+)') do
					aux = tonumber(past)
					
				end
				if aux and aux > 1 then
					vetorTodas.tempoPorImagem = aux
					
				else
					vetorTodas.tempoPorImagem = padrao.tempoPorImagem
					
				end
			end
			if string.find( vetorTodas[j]:match("([^=]+)="), "posicao" ) ~= nil then
				local aux = nil
				lixo,str = vetorTodas[j]:match("([^=]+) *=+ *([^\13]+)")
				for past in string.gmatch(str, '([a-z]+)') do
					aux = past
				end
				vetorTodas.posicao = aux
				if (vetorTodas.posicao ~= "topo") and (vetorTodas.posicao ~= "centro") and (vetorTodas.posicao ~= "base") then
					vetorTodas.posicao = padrao.posicao
				end
			end
			
			
			if string.find( vetorTodas[j]:match("([^=]+)="), "som" ) ~= nil then
				lixo,str = vetorTodas[j]:match("([^=]) *=+ *([^\13]+)")
				local jaAdicionou = false
				for past in string.gmatch(str, '([A-Za-z0-9?!@#$%&":;/.,\\-_+-*ÂÃÁ ÀÉÊÍÎÕÔÓÚÜâãáàéêíîõôóúü()]+)') do
					if string.len(past) > 4 and string.find( past, '[.]' ) ~= nil and auxFuncs.checarExtensaoAudio(past) then
						vetorTodas.som = past
					elseif string.find( past, 'nil' )~= nil and string.find( past, '[.]' ) ~= nil then
						if jaAdicionou == false then
							jaAdicionou = true
							vetorTodas.som = nil
						else
							vetorTodas.som = nil
						end
					end
				end
			end
			
			if string.find( vetorTodas[j]:match("([^=]+)="), "executar automatico" ) ~= nil then
				local aux = nil
				lixo,str = vetorTodas[j]:match("([^=]+) *=+ *([^\13]+)")
				for past in string.gmatch(str, '([a-z]+)') do
					aux = past
				end
				vetorTodas.automatico = aux
				if (vetorTodas.automatico ~= "sim") and (vetorTodas.automatico ~= "nao") then
					vetorTodas.automatico = padrao.automatico
				end
			else
				--table.insert(listaDeErros, "Arquivo: "..atributos.arquivo.. " -> Item "..i.." - 'e)' não encontrado")
			end
			
			if string.find( vetorTodas[j]:match("([^=]+)="), "loop" ) ~= nil then
				local aux = nil
				lixo,str = vetorTodas[j]:match("([^=]+) *=+ *([^\13]+)")
				for past in string.gmatch(str, '([a-z]+)') do
					aux = past
				end
				vetorTodas.loop = aux
				if (vetorTodas.loop ~= "sim") and (vetorTodas.loop ~= "nao") then
					vetorTodas.loop = padrao.loop
				end
			else
				--table.insert(listaDeErros, "Arquivo: "..atributos.arquivo.. " -> Item "..i.." - 'e)' não encontrado")
			end
			
			if string.find( vetorTodas[j]:match("([^=]+)="), " x" ) ~= nil or string.find( vetorTodas[j]:match("([^=]+)="), "-x" ) then
				local aux = -1
				local aux2 = ""
				lixo,str = vetorTodas[j]:match("([^=]+) *=+ *([^\13]+)")
				for past in string.gmatch(str, '([a-z]+)') do
					aux2 = past
				end
				for past in string.gmatch(str, '([0-9]+)') do
					aux = tonumber(past)
				end
				if aux2 == "nil" then
				else
					vetorTodas.x = aux
				end
				if aux2 ~= "nil" then
					if (vetorTodas.x < 0 or vetorTodas.x > W)then
						--vetorRetornado.x = padrao.x
					end
				end
			end
			
			if string.find( vetorTodas[j]:match("([^=]+)="), "y" ) or string.find( vetorTodas[j]:match("([^=]+)="), " saltar " ) ~= nil then
				local multiplicador = 1
				if string.find( vetorTodas[j]:match("([^=]+)="), " saltar " ) then
					multiplicador = 30
				end
				local aux = -1
				local aux2 = ""
				lixo,str = vetorTodas[j]:match("([^=]+) *=+ *([^\13]+)")
				for past in string.gmatch(str, '([a-z]+)') do
					aux2 = past
				end
				for past in string.gmatch(str, '([0-9]+)') do
					if string.find(str,"-") then
						aux = -1*(tonumber(past) * multiplicador)
					else
						aux = tonumber(past * multiplicador)
					end
				end
				if aux2 == "nil" then
				else
					vetorTodas.y = aux  * multiplicador
				end
			end
		
			M.lerPropDicionario(atributos,vetorTodas,j)
		
		end
	end
	
	local function lerArquivo(atributos)
		local vetor = {}
		local path = system.pathForFile(atributos.caminho.."/"..atributos.arquivo, system.ResourceDirectory )
		
		local file, errorString = io.open( path, "r" )
		local xx=1
		local ignorar = true
		if not file then
			print( "File error: " .. errorString )
		else
			for line in file:lines() do
				if type(line) == "string" and string.len( line ) then
					vetor[xx] = line
					xx = xx+1
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
	local vetorAux = {}
	
	if vetorTodas.pasta and auxFuncs.fileExists(atributos.pasta.."/Outros Arquivos/"..vetorTodas.pasta.."/dllImagens.txt") == true then
		vetorAux = lerArquivo({caminho = atributos.pasta.."/Outros Arquivos/"..vetorTodas.pasta,arquivo = "dllImagens.txt"})
		for i=1,#vetorAux do
			vetorAux[i] = string.gsub(vetorAux[i],"\13","")

		end
		vetorTodas.imagens = vetorAux
	end
	if vetorTodas.imagens and vetorTodas.imagens[1] == "imagemErro1.png" then
		vetorTodas.pasta = "Anim Padrao.lib"
	end
	vetorTodas.caminho = vetorTodas.caminho
	
	return vetorTodas
end
M.criarAnimacoesDeArquivoPadraoAux = criarAnimacoesDeArquivoPadraoAux
function criarAnimacoesDeArquivoPadrao(atributos,listaDeErros)

	
	
	local function lerArquivoPadrao()
		local vetor = {}
		local path = system.pathForFile( atributos.pasta.."/"..atributos.arquivo, system.ResourceDirectory )
		
		local file, errorString = io.open( path, "r" )
		local xx=1
		local ignorar = true
		if not file then
			print( "File error: " .. errorString )
		else
			for line in file:lines() do
				if string.len( line ) > 4 then
					local is_valid, error_position = validarUTF8.validate(line)
					if not is_valid then 
						--print('non-utf8 sequence detected at position ' .. tostring(error_position))
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
	
	if vetorTodas == nil then
		vetorTodas = {}
	end
	
	local imagensErro = {}
	for i=1,5 do
		imagensErro[i] = "imagemErro"..i..".png"
	end
	local padrao = {
						pasta = atributos.pasta.."/Outros Arquivos/Anim Padrao.lib",
						imagens = imagensErro,
						tempoPorImagem = 300,
						numeroImagens = #imagensErro,
						som = nil,
						automatico = "nao",
						posicao = nil,
						atributoALT = nil,
						loop = "nao",
						avancar = nil,
						limitador = "imagem",
						x = nil,
						y = nil
					}
	vetorTodas.pasta = padrao.pasta
	vetorTodas.imagens = padrao.imagens
	vetorTodas.som = padrao.som
	vetorTodas.tempoPorImagem = padrao.tempoPorImagem
	vetorTodas.automatico = padrao.automatico
	vetorTodas.numeroImagens = padrao.numeroImagens
	vetorTodas.posicao = padrao.posicao
	vetorTodas.atributoALT = padrao.atributoALT
	vetorTodas.loop = padrao.loop
	vetorTodas.avancar = padrao.avancar
	vetorTodas.limitador = padrao.limitador
	vetorTodas.x = padrao.x
	vetorTodas.y = padrao.y
	
	
	--thales1
	vetorTodas.xxx = true
	
	vetorTodas = criarAnimacoesDeArquivoPadraoAux(vetorTodas,padrao,atributos,listaDeErros)
	
	if system.getInfo("platform") == "win32" then
		vetorTodas.posicao = "windows"
	end
	
	return vetorTodas
end
M.criarAnimacoesDeArquivoPadrao = criarAnimacoesDeArquivoPadrao
------------------------------------------------------------------
--CRIAR ESPAÇO APARTIR DE ARQUIVOS -------------------------------
------------------------------------------------------------------
function criarEspacoDeArquivoPadraoAux(vetorTodas,padrao,atributos,listaDeErros)
	for j=1,#vetorTodas do
		if vetorTodas[j] ~= nil then
			vetorTodas[j] = auxFuncs.verificarComentario(vetorTodas[j])
			if string.find( vetorTodas[j]:match("([^=]+)="), "numero" ) ~= nil then
					
				lixo,str = vetorTodas[j]:match("([^=]+) *=+ *([^\13]+)")
				for past in string.gmatch(str, '([0-9]+)') do
					aux = tonumber(past)
				end
				if aux and aux > 0 then
					vetorTodas.distancia = aux*10
				else
					vetorTodas.distancia = padrao.distancia
				end
			end
			if string.find( vetorTodas[j]:match("([^=]+)="), "distancia" ) ~= nil then
					
				lixo,str = vetorTodas[j]:match("([^=]+) *=+ *([^\13]+)")
				for past in string.gmatch(str, '(%d+)') do
					aux = tonumber(past)
				end
				if aux and aux > 0 then
					vetorTodas.distancia = aux
				else
					vetorTodas.distancia = padrao.distancia
				end
			end
			
		end
	end
	return vetorTodas
end
M.criarEspacoDeArquivoPadraoAux = criarEspacoDeArquivoPadraoAux
------------------------------------------------------------------
--CRIAR SEPARADOR APARTIR DE ARQUIVOS ----------------------------
------------------------------------------------------------------
function M.criarSeparadorDeArquivoPadraoAux(vetorTodas,padrao,atributos,listaDeErros)
	for j=1,#vetorTodas do
		if vetorTodas[j] ~= nil then
			vetorTodas[j] = auxFuncs.verificarComentario(vetorTodas[j])
			if string.find( vetorTodas[j]:match("([^=]+)="), "conteudo" ) ~= nil  then
				lixo,str = vetorTodas[j]:match("([^=]+)=+([^\13]+)")
				if string.len(str) > 0 then
					local aux = str
					
					vetorTodas.conteudo = aux
					if string.gsub(aux," ","") == "nil" then
						vetorTodas.conteudo = ""
					end
				else
					table.insert(listaDeErros, "Arquivo: "..atributos.arquivo.. " -> Item - 'conteudo'".." está vazio")
					
					vetorTodas.conteudo = padrao.conteudo
				end
			end
			if string.find( vetorTodas[j]:match("([^=]+)="), "margem" ) ~= nil then
				local aux = -1
				local aux2 = ""
				lixo,str = vetorTodas[j]:match("([^=]+)=+%s*([^\13]+)")
				for past in string.gmatch(str, '([a-z]+)') do
					aux2 = past
				end
				for past in string.gmatch(str, '([0-9]+)') do
					aux = tonumber(past)
				end
				if aux2 == "nil" then
				else
					vetorTodas.margem = aux
				end
				if aux2 ~= "nil" then
					if (vetorTodas.margem < 0 or vetorTodas.margem > W)then
						table.insert(listaDeErros, "Arquivo: "..atributos.arquivo.. " -> Item  - 'margem'".." contem um erro no valor")
						vetorTodas.margem = padrao.margem
					end
				end
			else
				--table.insert(listaDeErros, "Arquivo: "..atributos.arquivo.. " -> Item "..i.." - 'f)' não encontrado")
			end
			if string.find( vetorTodas[j]:match("([^=]+)="), "espessura" ) ~= nil then
				lixo,str = vetorTodas[j]:match("([^=]+)=+([^\13]+)")
				for past in string.gmatch(str, '([0-9]+)') do
					aux = tonumber(past)
				end
				if aux and aux > 0 then
					vetorTodas.espessura = aux
				else
					table.insert(listaDeErros, "Arquivo: "..atributos.arquivo.. " -> Item - 'espessura'".." contem um erro")
					vetorTodas.espessura = padrao.espessura
				end
			end
			if string.find( vetorTodas[j]:match("([^=]+)="), "largura" ) ~= nil then
				lixo,str = vetorTodas[j]:match("([^=]+)=+([^\13]+)")
				for past in string.gmatch(str, '([0-9]+)') do
					aux = tonumber(past)
				end
				if aux and aux > 0 then
					vetorTodas.largura = aux
				else
					table.insert(listaDeErros, "Arquivo: "..atributos.arquivo.. " -> Item - 'largura'".." contem um erro")
					vetorTodas.largura = padrao.largura
				end
			end
			if string.find( vetorTodas[j]:match("([^=]+)="), "cor" ) ~= nil then
				local xxy = 1
				local lixo,str = vetorTodas[j]:match("([^=]+)=+([^\13]+)")
				for num in string.gmatch(str, '([0-9]+)') do
					vetorTodas.cor[xxy] = tonumber(num)
					xxy = xxy+1
				end
				local k = 1
				while k < 3 do
					if vetorTodas.cor[k] < 0 or vetorTodas.cor[k] > 255 or #vetorTodas.cor > 3 then
						table.insert(listaDeErros, "Arquivo: "..atributos.arquivo.. " -> Item  - 'cor'".." contem um erro")
						vetorTodas.cor[1],vetorTodas.cor[2],vetorTodas.cor[3] = padrao.cor[1],padrao.cor[2],padrao.cor[3]
						k=3
					end
					k = k+1
				end
			end
			if string.find( vetorTodas[j]:match("([^=]+)="), " x" ) ~= nil or string.find( vetorTodas[j]:match("([^=]+)="), "-x" )or string.find( vetorTodas[j]:match("([^=]+)="), "x " ) then
				local aux = -1
				local aux2 = ""
				lixo,str = vetorTodas[j]:match("([^=]+)=+([^\13]+)")
				for past in string.gmatch(str, '([a-z]+)') do
					aux2 = past
				end
				for past in string.gmatch(str, '([0-9]+)') do
					aux = tonumber(past)
				end
				if aux2 == "nil" then
				else
					vetorTodas.x = aux
				end
				if aux2 ~= "nil" then
					if (vetorTodas.x < 0)then
						table.insert(listaDeErros, "Arquivo: "..atributos.arquivo.. " -> Item - 'x'".." contem um erro no valor")
						vetorTodas.x = padrao.x
					end
				end
			end
			if string.find( vetorTodas[j]:match("([^=]+)="), " y" ) ~= nil or string.find( vetorTodas[j]:match("([^=]+)="), "-y" )or string.find( vetorTodas[j]:match("([^=]+)="), "y " ) then
				local aux = -1
				local aux2 = ""
				lixo,str = vetorTodas[j]:match("([^=]+)=+([^\13]+)")
				for past in string.gmatch(str, '([a-z]+)') do
					aux2 = past
				end
				for past in string.gmatch(str, '([0-9]+)') do
					aux = tonumber(past)
				end
				if aux2 == "nil" then
				else
					vetorTodas.y = aux
				end
				if aux2 ~= "nil" then
					if (vetorTodas.y < 0)then
						table.insert(listaDeErros, "Arquivo: "..atributos.arquivo.. " -> Item - 'y'".." contem um erro no valor")
						vetorTodas.y = padrao.y
					end
				end
			end
		end
	end
end

function M.criarSeparadoresDeArquivoPadrao(atributos,listaDeErros)
	
	local function lerArquivoPadrao()
		local vetor = {}
		local path = system.pathForFile( atributos.pasta.."/"..atributos.arquivo, system.ResourceDirectory )
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
						--print('non-utf8 sequence detected at position ' .. tostring(error_position))
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
	--thales1
	local padrao = {
						espessura = 5,
						cor = {0,0,0},
						largura = W,
						x = nil,
						y = nil
					}
					vetorTodas.espessura = padrao.espessura
					vetorTodas.cor = padrao.cor
					vetorTodas.largura = padrao.largura
					vetorTodas.x = padrao.x
					vetorTodas.y = padrao.y
	
	M.criarSeparadorDeArquivoPadraoAux(vetorTodas,padrao,atributos,listaDeErros)
	
	return vetorTodas
end

------------------------------------------------------------------
--CRIAR FUNDO APARTIR DE ARQUIVOS -----------------------
------------------------------------------------------------------
function M.criarFundoDeArquivoPadraoAux(vetorTodas,padrao,atributos,listaDeErros)
	for j=1,#vetorTodas do
		if vetorTodas[j] ~= nil then
			vetorTodas[j] = auxFuncs.verificarComentario(vetorTodas[j])
			local lowerString = string.lower(vetorTodas[j])
			
			if string.find( lowerString:match("([^=]+)="), "cor" ) ~= nil then
				local xxy = 1
				local lixo,str = vetorTodas[j]:match("([^=]+) *=+ *([^\13]+)")
				for num in string.gmatch(str, '([0-9]+)') do
					vetorTodas.cor[xxy] = tonumber(num)
					xxy = xxy+1
				end
				local k = 1
				while k < 3 do
					if vetorTodas.cor[k] < 0 or vetorTodas.cor[k] > 255 or #vetorTodas.cor > 3 then
						table.insert(listaDeErros, "Arquivo: "..atributos.arquivo.. " -> Item  - 'cor'".." contem um erro")
						vetorTodas.cor[1],vetorTodas.cor[2],vetorTodas.cor[3] = padrao.cor[1],padrao.cor[2],padrao.cor[3]
						k=3
					end
					k = k+1
				end
			end
			
			if string.find( lowerString, "arquivo" ) ~= nil then
				lixo,str = vetorTodas[j]:match("([^=]) *=+ *([^\13]+)")
				local jaAdicionou = false
				for past in string.gmatch(str, '([A-Za-z0-9%?!@#$%%&":;/%.,\\%-_%+%*ÂÃÁ ÀÉÊÍÎÕÔÓÚÜâãáàéêíîõôóúü%(%)]+)') do
					if string.len(past) > 4 and string.find( past, '[%.]' ) ~= nil and auxFuncs.checarExtensaoImagem(past) then
						vetorTodas.imagem = atributos.pasta.."/Outros Arquivos/"..past
					else
						if string.gsub(past," ","") == "nil" then
							vetorTodas.imagem = nil
						else
							if jaAdicionou == false then
								table.insert(listaDeErros, "Arquivo: "..atributos.pasta.."/"..atributos.arquivo.. " -> 'imagem'".." contem um erro (Atenção: não use acentuações no nome do arquivo)\n")
								jaAdicionou = true
							end
						end
					end
				end
			end
			
		end
	end
end

function M.criarFundoDeArquivoPadrao(atributos,listaDeErros)
	
	local function lerArquivoPadrao()
		local vetor = {}
		local path = system.pathForFile( atributos.pasta.."/"..atributos.arquivo, system.ResourceDirectory )
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
						--print('non-utf8 sequence detected at position ' .. tostring(error_position))
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
	--thales1
	local padrao = {
						cor = {192,0,0},
						arquivo = nil
					}
					vetorTodas.arquivo = padrao.arquivo
					vetorTodas.cor = padrao.cor
	
	M.criarFundoDeArquivoPadraoAux(vetorTodas,padrao,atributos,listaDeErros)
	
	return vetorTodas
end

------------------------------------------------------------------
--CRIAR IMAGEM E TEXTO APARTIR DE ARQUIVOS -----------------------
------------------------------------------------------------------
function M.criarImagemTextosDeArquivoPadraoAux(vetorTodas,padrao,atributos,listaDeErros)
	for j=1,#vetorTodas do
		if vetorTodas[j] ~= nil then
			vetorTodas[j] = auxFuncs.verificarComentario(vetorTodas[j])
			if string.find( vetorTodas[j]:match("([^=]+)="), "conteudo" ) ~= nil  then
				lixo,str = vetorTodas[j]:match("([^=]+)=+([^\13]+)")
				if string.len(str) > 0 then
					local aux = str
					
					vetorTodas.conteudo = aux
					if string.gsub(aux," ","") == "nil" then
						vetorTodas.conteudo = ""
					end
				else
					table.insert(listaDeErros, "Arquivo: "..atributos.arquivo.. " -> Item - 'conteudo'".." está vazio")
					
					vetorTodas.conteudo = padrao.conteudo
				end
			end
			if string.find( vetorTodas[j]:match("([^=]+)="), "atributo ALT" ) ~= nil or string.find( vetorTodas[j]:match("([^=]+)="), "atributo alt" ) ~= nil or string.find( vetorTodas[j]:match("([^=]+)="), "atributoAlt" ) ~= nil or string.find( vetorTodas[j]:match("([^=]+)="), "atributoALT" ) ~= nil then
				lixo,str = vetorTodas[j]:match("([^=]+)=+([^\13]+)")
				if string.len(str) > 0 then
					vetorTodas.atributoALT = str
					if string.gsub(str," ","") == "nil" then
						vetorTodas.atributoALT = ""
					end
				else
					table.insert(listaDeErros, "Arquivo: "..atributos.arquivo.. " -> Item - 'atributo ALT'".." está vazio")
					vetorTodas.atributoALT = padrao.atributoALT
				end
			end
			
			if string.find( vetorTodas[j]:match("([^=]+)="), "urlImagem" ) ~= nil then
				lixo,str = vetorTodas[j]:match("([^=]+)=+ *([^\13]+)")
				if string.len(str) > 0 then
					if str == "nil" then
						vetorTodas.urlImagem = nil
					else
						vetorTodas.urlImagem = str
					end
				else
					table.insert(listaDeErros, "Arquivo: "..atributos.arquivo.. " -> Item - 'urlImagem'".." está vazio")
					vetorTodas.urlImagem = padrao.urlImagem
				end
			end
			
			if string.find( vetorTodas[j]:match("([^=]+)="), "arquivo" ) ~= nil then
				lixo,str = vetorTodas[j]:match("([^=]) *=+ *([^\13]+)")
				local jaAdicionou = false
				for past in string.gmatch(str, '([A-Za-z0-9?!@#$%&":;/.,\\-_+-*ÂÃÁ ÀÉÊÍÎÕÔÓÚÜâãáàéêíîõôóúü()]+)') do
					if string.len(past) > 4 and string.find( past, '[.]' ) ~= nil and (string.find( past, "jpg" ) ~= nil or string.find( past, "JPG" ) ~= nil or string.find( past, "png" ) ~= nil or string.find( past, "PNG" ) ~= nil or string.find( past, "bmp" ) ~= nil or string.find( past, "BMP" ) ~= nil) then
						vetorTodas.arquivo = atributos.pasta.."/Outros Arquivos/"..past
					else
						if jaAdicionou == false then
							table.insert(listaDeErros, "Arquivo: "..atributos.pasta.."/"..atributos.arquivo.. " -> 'arquivo'".." contem um erro (Atenção: não use acentuações no nome do arquivo)\n")
							jaAdicionou = true
						else
							
						end
					end
				end
			end
			
			if string.find( vetorTodas[j]:match("([^=]+)="), "margem" ) ~= nil then
				local aux = -1
				local aux2 = ""
				lixo,str = vetorTodas[j]:match("([^=]+)=+([^\13]+)")
				for past in string.gmatch(str, '([a-z]+)') do
					aux2 = past
				end
				for past in string.gmatch(str, '([0-9]+)') do
					aux = tonumber(past)
				end
				if aux2 == "nil" then
				else
					vetorTodas.margem = aux
				end
				if aux2 ~= "nil" then
					if (vetorTodas.margem < 0 or vetorTodas.margem > W)then
						table.insert(listaDeErros, "Arquivo: "..atributos.arquivo.. " -> Item  - 'margem'".." contem um erro no valor")
						vetorTodas.margem = padrao.margem
					end
				end
			else
				--table.insert(listaDeErros, "Arquivo: "..atributos.arquivo.. " -> Item "..i.." - 'f)' não encontrado")
			end
			
			if string.find( vetorTodas[j]:match("([^=]+)="), "altura" ) ~= nil then
				local aux = 0
				local aux2 = ""
				lixo,str = vetorTodas[j]:match("([^=]+)=+([^\13]+)")
				for past in string.gmatch(str, '([a-z]+)') do
					aux2 = past
				end
				for past in string.gmatch(str, '([0-9]+)') do
					aux = tonumber(past)
				end
				if aux2 == "nil" then
				else
					vetorTodas.altura = aux
				end
				if aux2 ~= "nil" then
					if vetorTodas.altura < 1 then
						table.insert(listaDeErros, "Arquivo: "..atributos.arquivo.. " -> 'altura'".." contem um erro\n")
						vetorTodas.altura = padrao.altura
					end
				end
			end
			
			if string.find( vetorTodas[j]:match("([^=]+)="), "comprimento" ) ~= nil then
				local aux = 0
				local aux2 = ""
				lixo,str = vetorTodas[j]:match("([^=]+)=+([^\13]+)")
				for past in string.gmatch(str, '([a-z]+)') do
					aux2 = past
				end
				for past in string.gmatch(str, '([0-9]+)') do
					aux = tonumber(past)
				end
				if aux2 == "nil" then
				else
					vetorTodas.comprimento = aux
				end
				if aux2 ~= "nil" then
					if vetorTodas.comprimento < 1 then
						table.insert(listaDeErros, "Arquivo: "..atributos.arquivo.. " -> Item "..i.." - 'c)'".." contem um erro\n")
						vetorTodas.comprimento = padrao.comprimento
					end
				end
			else
				--table.insert(listaDeErros, "Arquivo: "..atributos.arquivo.. " -> Item "..i.." - 'c)' não encontrado")
			end
			
			if string.find( vetorTodas[j]:match("([^=]+)="), "distancia" ) ~= nil then
				local aux = 0
				local aux2 = ""
				lixo,str = vetorTodas[j]:match("([^=]+)=+([^\13]+)")
				for past in string.gmatch(str, '([a-z]+)') do
					aux2 = past
				end
				for past in string.gmatch(str, '([0-9]+)') do
					aux = tonumber(past)
				end
				if aux2 == "nil" then
				else
					vetorTodas.distancia = aux
				end
				if aux2 ~= "nil" then
					if vetorTodas.distancia < 0 then
						table.insert(listaDeErros, "Arquivo: "..atributos.arquivo.. " -> 'distancia'".." contem um erro\n")
						vetorTodas.distancia = padrao.distancia
					end
				end
			end
			
			if string.find( vetorTodas[j]:match("([^=]+)="), "zoom" ) ~= nil then
				local aux = nil
				lixo,str = vetorTodas[j]:match("([^=]+)=+([^\13]+)")
				for past in string.gmatch(str, '([a-z]+)') do
					aux = past
				end
				vetorTodas.zoom = aux
				if (vetorTodas.zoom ~= "sim") and (vetorTodas.zoom ~= "nao") then
					table.insert(listaDeErros, "Arquivo: "..atributos.arquivo.. " -> Item "..i.." - 'e)'".." contem um erro\n")
					vetorTodas.zoom = padrao.zoom
				end
			else
				--table.insert(listaDeErros, "Arquivo: "..atributos.arquivo.. " -> Item "..i.." - 'e)' não encontrado")
			end
		
		
		
		
			if string.find( vetorTodas[j]:match("([^=]+)="), "texto" ) ~= nil and not string.find( vetorTodas[j]:match("([^=]+)="), 'urlTexto' ) then
				lixo,str = vetorTodas[j]:match("([^=]+)=+([^\13]+)")
				if string.len(str) > 0 then
					vetorTodas.texto = str
					vetorTodas.texto = string.gsub(vetorTodas.texto,"\\n","\n")
				else
					table.insert(listaDeErros, "Arquivo: "..atributos.arquivo.. " -> Item - 'texto'".." está vazio")
					vetorTodas.texto = padrao.texto
				end
			else
				--table.insert(listaDeErros, "Arquivo: "..atributos.arquivo.. " -> Item "..i.." - 'a)' não encontrado")
			end
			
			if string.find( vetorTodas[j]:match("([^=]+)="), 'urlTexto' ) ~= nil then
				vetorTodas.urlTexto = {}
				local arquivos = {}
				local xxy = 1
				lixo,str = vetorTodas[j]:match("([^=]+)=+ *([^\13]+)")
				str = string.gsub(str,"[ ]+","")
				for past in string.gmatch(str, '([^#]+)') do
					vetorTodas.urlTexto[xxy] = past
					xxy = xxy + 1
				end
				local i = 1
				while i <= #vetorTodas.urlTexto do
					if string.len(vetorTodas.urlTexto[i]) < 1 then
						vetorTodas.urlTexto = {}
						i = #vetorTodas.urlTexto+1
					end
					i = i+1
				end
			end
			
			
			if string.find( vetorTodas[j]:match("([^=]+)="), "urlEmbeded" ) ~= nil then
				lixo,str = vetorTodas[j]:match("([^=]+)=+([^\13]+)")
				if string.len(str) > 0 then
					vetorTodas.urlEmbeded = str
				else
					table.insert(listaDeErros, "Arquivo: "..atributos.arquivo.. " -> Item  - 'urlEmbeded'".." está vazio")
					vetorTodas.urlEmbeded = padrao.urlEmbeded
				end
			else
				--table.insert(listaDeErros, "Arquivo: "..atributos.arquivo.. " -> Item "..i.." - 'a)' não encontrado")
			end
		
			if string.find( vetorTodas[j]:match("([^=]+)="), "tamanho" ) ~= nil then
				local aux = -1
				local aux2 = ""
				lixo,str = vetorTodas[j]:match("([^=]+)=+([^\13]+)")
				for past in string.gmatch(str, '([a-z]+)') do
					aux2 = past
				end
				for past in string.gmatch(str, '([0-9]+)') do
					aux = tonumber(past)
				end
				if aux2 == "nil" then
				else
					vetorTodas.tamanho = aux
				end
				if aux2 ~= "nil" then
					if (vetorTodas.tamanho < 1 or vetorTodas.tamanho > W)then
						table.insert(listaDeErros, "Arquivo: "..atributos.arquivo.. " -> Item  - 'tamanho'".." contem um erro no valor")
						vetorTodas.tamanho = padrao.tamanho
					end
				end
			else
				--table.insert(listaDeErros, "Arquivo: "..atributos.arquivo.. " -> Item "..i.." - 'f)' não encontrado")
			end
		
			if string.find( vetorTodas[j]:match("([^=]+)="), "negrito" ) ~= nil then
				local aux = nil
				lixo,str = vetorTodas[j]:match("([^=]+)=+([^\13]+)")
				for past in string.gmatch(str, '([a-z]+)') do
					aux = past
				end
				vetorTodas.negrito = aux
				if (vetorTodas.negrito ~= "sim") and (vetorTodas.negrito ~= "nao") then
					table.insert(listaDeErros, "Arquivo: "..atributos.arquivo.. " -> Item  - 'negrito'".." contem um erro")
					vetorTodas.negrito = padrao.negrito
				end
			else
				--table.insert(listaDeErros, "Arquivo: "..atributos.arquivo.. " -> Item "..i.." - 'e)' não encontrado")
			end
		
			if string.find( vetorTodas[j]:match("([^=]+)="), "fonte" ) ~= nil then
				local aux = " "
				lixo,str = vetorTodas[j]:match("([^=]+)=+([^\13]+)")
				for past in string.gmatch(str, '([A-Za-z.0-9]+)') do
					aux = past
				end
				vetorTodas.fonte = aux
				if (vetorTodas.fonte ~= "arial") and (vetorTodas.fonte ~= "times") and (vetorTodas.fonte ~= "calibri") and string.find(vetorTodas.fonte, ".ttf") == nil then
					table.insert(listaDeErros, "Arquivo: "..atributos.arquivo.. " -> Item  - 'fonte'".." contem um erro")
					vetorTodas.fonte = padrao.fonte
				end
				if string.find(vetorTodas.fonte, ".ttf") ~= nil and (vetorTodas.fonte ~= "arial") and (vetorTodas.fonte ~= "times") and (vetorTodas.fonte ~= "calibri") then
					vetorTodas.fonte = "Fontes/"..aux

				end
			else
				--table.insert(listaDeErros, "Arquivo: "..atributos.arquivo.. " -> Item "..i.." - 'e)' não encontrado")
			end
		
			if string.find( vetorTodas[j]:match("([^=]+)="), "alinhamento" ) ~= nil then
				local aux = nil
				lixo,str = vetorTodas[j]:match("([^=]+)=+([^\13]+)")
				for past in string.gmatch(str, '([a-z]+)') do
					aux = past
				end
				vetorTodas.alinhamento = aux
				if (vetorTodas.alinhamento ~= "esquerda") and (vetorTodas.alinhamento ~= "meio" and vetorTodas.alinhamento ~= "direita") and (vetorTodas.alinhamento ~= "justificado") then
					table.insert(listaDeErros, "Arquivo: "..atributos.arquivo.. " -> Item  - 'alinhamento'".." contem um erro")
					vetorTodas.alinhamento = padrao.alinhamento
				end
			else
				--table.insert(listaDeErros, "Arquivo: "..atributos.arquivo.. " -> Item "..i.." - 'e)' não encontrado")
			end

			if string.find( vetorTodas[j]:match("([^=]+)="), "cor" ) ~= nil then
				local xxy = 1
				local lixo,str = vetorTodas[j]:match("([^=]+)=+([^\13]+)")
				for num in string.gmatch(str, '([0-9]+)') do
					vetorTodas.cor[xxy] = tonumber(num)
					xxy = xxy+1
				end
				local k = 1
				while k < 3 do
					if vetorTodas.cor[k] < 0 or vetorTodas.cor[k] > 255 or #vetorTodas.cor > 3 then
						table.insert(listaDeErros, "Arquivo: "..atributos.arquivo.. " -> Item  - 'cor'".." contem um erro")
						vetorTodas.cor[1],vetorTodas.cor[2],vetorTodas.cor[3] = padrao.cor[1],padrao.cor[2],padrao.cor[3]
						k=3
					end
					k = k+1
				end
			else
				--table.insert(listaDeErros, "Arquivo: "..atributos.arquivo.. " -> Item "..i.." - 'cor' não encontrado")
				--vetorCorTitulo[1],vetorCorTitulo[2],vetorCorTitulo[3] = 180,180,180
			end
			
			if string.find( vetorTodas[j]:match("([^=]+)="), " x" ) ~= nil or string.find( vetorTodas[j]:match("([^=]+)="), "-x" ) then
				local aux = -1
				local aux2 = ""
				lixo,str = vetorTodas[j]:match("([^=]+)=+([^\13]+)")
				for past in string.gmatch(str, '([a-z]+)') do
					aux2 = past
				end
				for past in string.gmatch(str, '([0-9]+)') do
					aux = tonumber(past)
				end
				if aux2 == "nil" then
				else
					vetorTodas.x = aux
				end
				if aux2 ~= "nil" then
					if (vetorTodas.x < 0 or vetorTodas.x > W)then
						table.insert(listaDeErros, "Arquivo: "..atributos.arquivo.. " -> Item  - 'x'".." contem um erro no valor")
						vetorTodas.x = padrao.x
					end
				end
			else
				--table.insert(listaDeErros, "Arquivo: "..atributos.arquivo.. " -> Item "..i.." - 'f)' não encontrado")
			end
			
			if string.find( vetorTodas[j]:match("([^=]+)="), "y" ) or string.find( vetorTodas[j]:match("([^=]+)="), " saltar " ) ~= nil then
				local multiplicador = 1
				if string.find( vetorTodas[j]:match("([^=]+)="), " saltar " ) then
					multiplicador = 30
				end
				local aux = -1
				local aux2 = ""
				lixo,str = vetorTodas[j]:match("([^=]+)=+([^\13]+)")
				for past in string.gmatch(str, '([a-z]+)') do
					aux2 = past
				end
				for past in string.gmatch(str, '([0-9]+)') do
					if string.find(str,"-") then
						aux = -1*(tonumber(past) * multiplicador)
					else
						aux = tonumber(past * multiplicador)
					end
				end
				if aux2 == "nil" then
				else
					vetorTodas.y = aux  * multiplicador
				end
			end
		
			M.lerPropDicionario(atributos,vetorTodas,j)
		
		end
	end
end

function M.criarImagemTextosDeArquivoPadrao(atributos,listaDeErros)
	
	local function lerArquivoPadrao()
		local vetor = {}
		local path = system.pathForFile( atributos.pasta.."/"..atributos.arquivo, system.ResourceDirectory )
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
						--print('non-utf8 sequence detected at position ' .. tostring(error_position))
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
	--thales1
	local padrao = {
						texto = "(Erro no texto)",
						urlTexto = nil,
						urlEmbeded = nil,
						tamanho = 40,
						negrito = "nao",
						fonte = nil,
						alinhamento = nil,
						cor = {180,180,180},
						x = nil,
						y = nil,
						arquivo = atributos.pasta.."/Outros Arquivos/imagemErro.jpg",
						atributoALT = nil,
						altura = nil,
						posicao = "esquerda",
						comprimento = nil,
						zoom = "sim",
						urlImagem = nil,
						margem = 0,
						distancia = 0,
						x = nil,
						y = nil
						
					}
							
					vetorTodas.texto = padrao.texto
					vetorTodas.urlTexto = padrao.urlTexto
					vetorTodas.urlEmbeded = padrao.urlEmbeded
					vetorTodas.tamanho = padrao.tamanho
					vetorTodas.negrito = padrao.negrito
					vetorTodas.fonte = padrao.fonte
					vetorTodas.alinhamento = padrao.alinhamento
					vetorTodas.cor = padrao.cor
					vetorTodas.x = padrao.x
					vetorTodas.y = padrao.y
					vetorTodas.arquivo = padrao.arquivo
					vetorTodas.atributoALT = padrao.atributoALT
					vetorTodas.altura = padrao.altura
					vetorTodas.comprimento = padrao.comprimento
					vetorTodas.posicao = padrao.posicao
					vetorTodas.zoom = padrao.zoom
					vetorTodas.urlImagem = padrao.urlImagem
					vetorTodas.margem = padrao.margem
					vetorTodas.distancia = padrao.distancia
					
	M.criarImagemTextosDeArquivoPadraoAux(vetorTodas,padrao,atributos,listaDeErros)
	
					
	return vetorTodas
end

------------------------------------------------------------------
--CRIAR DICIONARIO APARTIR DE ARQUIVOS -----------------------
------------------------------------------------------------------
function M.lerPropDicionario(atributos,vetorTodas,j)
	local lixo,str = vetorTodas[j]:match("([^=]+)=+%s*([^\13]+)")
	for past in string.gmatch(str, '([^\13]+)') do
		if string.len(past) > 4 and string.find( past, "%.txt" ) ~= nil and not string.find( past, "#/r=.+%.txt#" )  then
			vetorTodas.dicionario = "Dicionario/"..past
		end
	end
	lixo,str = nil,nil
end
function M.pegarListaDeArquivosTxT(atributos)
	local vetorLinhas = M.lerArquivoPadrao(atributos)
	for j=1,#vetorLinhas do
		vetorLinhas[j] = string.gsub(vetorLinhas[j],"#/r=.+#","")
		local auxMatch = vetorLinhas[j]:match("%s*([^=]+)%s*=")
		if not vetorLinhas.palavras then vetorLinhas.palavras = {} end
		lixo,str = vetorLinhas[j]:match("([^=]+)=+%s*([^\13]+)")
		if string.len(str) > 4 and string.find( str, "%.txt" ) ~= nil  then
			table.insert(vetorLinhas.palavras,{auxMatch,str})
		end
	end
	
	return vetorLinhas
end
function M.criarDicionarioDeArquivoPadraoAux(vetorTodas,padrao,atributos,listaDeErros)
	--[[
		traducao = "mangue",
		significado = "fruta de comar, apresenta cor amarelada quando madura",
		categoriaG = "substantivo",
		fonetica = "mãn-gá",
		pronuncia = "audio.mp3",
		imagens = "manga.png",
		video = "comendoManga.mp4",
		origem = "do tupi-guarani - mon-gul",
		referenciasContextuais = "wikipedia/manga|||A beleza da manga - por thales O L",
		referencia = "dicio.dicionario.com.br/?=manga"
	]]
	
	for j=1,#vetorTodas do
		if vetorTodas[j] ~= nil then
			local auxVar = nil
			--print("LINHA = ",vetorTodas[j])
			if 	string.find( vetorTodas[j]:match("([^=]+)="), "traducao" ) ~= nil then auxVar = "traducao"
			elseif 	string.find( vetorTodas[j]:match("([^=]+)="), "significado" ) ~= nil then auxVar = "significado"
			elseif 	string.find( vetorTodas[j]:match("([^=]+)="), "classeG" ) ~= nil then auxVar = "categoriaG"
			elseif 	string.find( vetorTodas[j]:match("([^=]+)="), "fonetica" ) ~= nil then auxVar = "fonetica"
			elseif 	string.find( vetorTodas[j]:match("([^=]+)="), "atributoALT pronuncia" ) ~= nil then auxVar = "atributoALTpronuncia"
			elseif 	string.find( vetorTodas[j]:match("([^=]+)="), "pronuncia" ) ~= nil then auxVar = "pronuncia"
			elseif 	string.find( vetorTodas[j]:match("([^=]+)="), "atributoALT imagens" ) ~= nil then auxVar = "atributoALTimagens"
			elseif 	string.find( vetorTodas[j]:match("([^=]+)="), "imagens" ) ~= nil then auxVar = "imagem"
			elseif 	string.find( vetorTodas[j]:match("([^=]+)="), "atributoALT video" ) ~= nil then auxVar = "atributoALTvideo"
			elseif 	string.find( vetorTodas[j]:match("([^=]+)="), "video" ) ~= nil then auxVar = "video" 
			elseif 	string.find( vetorTodas[j]:match("([^=]+)="), "origem" ) ~= nil then auxVar = "origem"
			elseif 	string.find( vetorTodas[j]:match("([^=]+)="), "complementos" ) ~= nil then auxVar = "complementos"
			elseif 	string.find( vetorTodas[j]:match("([^=]+)="), "referencias" ) ~= nil then auxVar = "referencias"
			elseif 	string.find( vetorTodas[j]:match("([^=]+)="), "contextos" ) ~= nil then auxVar = "contextos"
			elseif 	string.find( vetorTodas[j]:match("([^=]+)="), "contexto" ) ~= nil then auxVar = "contexto"
			elseif 	string.find( vetorTodas[j]:match("([^=]+)="), "plural" ) ~= nil then auxVar = "plural"
			elseif 	string.find( vetorTodas[j]:match("([^=]+)="), "silabas " ) ~= nil then auxVar = "silabas" end
			
			--print("auxVar = ",auxVar)
			if 	auxVar == "significado" or auxVar == "traducao" or auxVar == "categoriaG" or auxVar == "origem" or auxVar == "contexto" or auxVar == "plural" or auxVar == "silabas" or auxVar == "atributoALTvideo" then
				
				lixo,str = vetorTodas[j]:match("([^=]+)=+([^\13]+)")
				if string.len(str) > 0 then
					local aux = str
					
					vetorTodas[auxVar] = aux
					if string.gsub(aux," ","") == "nil" then
						vetorTodas[auxVar] = ""
					end
				else
					table.insert(listaDeErros, "Arquivo: "..atributos.arquivo.. " -> Item - '"..auxVar.."' está vazio")
					
					vetorTodas[auxVar] = padrao[auxVar]
				end
			end
			
			if auxVar == "imagem" then
				vetorTodas.imagens = {}
				local xxy = 1
				lixo,str = vetorTodas[j]:match("([^=]+)=+%s*([^\13]+)")
				local auxComp = string.lower(str)
				if auxComp == "nil" then
					vetorTodas.imagens = nil
				else
					local past = {}
					local firstMatch = string.match(str,"(.+)|+")
					if firstMatch == nil then
						firstMatch = string.match(str,"(.+)")
					end
					table.insert(past,firstMatch)
					string.gsub(str, "|+(.+)",
						function (s)
							table.insert(past,s)
						end)
					for i=1,#past  do
						local arquivo,var2,var3 = nil,nil,nil
						local cont = 1
						print(past[i])
						for text in string.gmatch(past[i],"([^|]+)") do
							print("texto "..cont.." = "..text)
							if cont == 1 then arquivo = text
							elseif cont == 2 then var2 = text
							elseif cont == 3 then var3 = text end
							cont = cont + 1
						end
						local fonte = nil
						local titulo = nil
						print("IMAGEM: arquivo,fonte,titulo = ",arquivo,var2,var3)
						if string.len(arquivo) > 4 and (string.find( arquivo, "%.jpg" ) ~= nil or string.find( arquivo, "%.png" ) ~= nil or string.find( arquivo, "%.bmp" ) ~= nil) then
							vetorTodas.imagens[xxy] = {}
							if var2 and string.find(var2,"titulo%s*=%s*") then
								titulo = string.gsub(var2,"titulo%s*=%s*","")
							elseif var2 and string.find(var2,"fonte%s*=%s*") then
								fonte = string.gsub(var2,"fonte%s*=%s*","")
							end
							if var3 and string.find(var3,"titulo%s*=%s*") then
								titulo = string.gsub(var3,"titulo%s*=%s*","")
							elseif var3 and string.find(var3,"fonte%s*=%s*") then
								fonte = string.gsub(var3,"fonte%s*=%s*","")
							end
							
							vetorTodas.imagens[xxy].arquivo = arquivo
							vetorTodas.imagens[xxy].titulo = titulo
							vetorTodas.imagens[xxy].fonte = fonte
							xxy = xxy + 1
						end
					end
					local i = 1
					while i <= #vetorTodas.imagens do
						if string.len(vetorTodas.imagens[i].arquivo) < 1 then
							i = #vetorTodas.imagens+1
						end
						i = i+1
					end
				end
			end
			
			if auxVar == "contextos" or auxVar == "complementos" or auxVar == "referencias" or auxVar == "atributoALTimagens" or auxVar == "atributoALTpronuncia" then
				vetorTodas[auxVar] = {}
				local xxy = 1
				lixo,str = vetorTodas[j]:match("([^=]+)=+%s*([^\13]+)")
				local auxComp = string.lower(str)
				if auxComp == "nil" then
					vetorTodas[auxVar] = nil
				else
					for past in string.gmatch(str, '([^|]+)') do
						if string.len(past) > 6 then
							vetorTodas[auxVar][xxy] = past
							xxy = xxy + 1
						end
					end
					local i = 1
					while i <= #vetorTodas[auxVar] do
						if string.len(vetorTodas[auxVar][i]) < 1 then
							i = #vetorTodas[auxVar]+1
						end
						i = i+1
					end
				end
			end
			
			if auxVar == "fonetica" then
				vetorTodas.foneticasEpronuncias = {}
				local arquivos = {}
				local xxy = 1
				lixo,str = vetorTodas[j]:match("([^=]+)=+%s*([^\13]+)")
				local auxComp = string.lower(str)
				if auxComp == "nil" then
					vetorTodas.foneticas = nil
				else
					for past in string.gmatch(str, '([^|]+)') do
						local fonetica,pronuncia = nil,nil
						if string.find(past,"#(.+)#") then
							fonetica,pronuncia = string.match(past,"(.*)#(.+)#")
						else
							fonetica = string.match(past,"(.+)")
						end
						local aumentar = false
						if fonetica and string.len(fonetica) > 1 and string.find(fonetica,"%a") then
							vetorTodas.foneticasEpronuncias[xxy] = {}
							vetorTodas.foneticasEpronuncias[xxy][1] = fonetica
							aumentar = true
						end
						if pronuncia and string.len(pronuncia) > 4 and (string.find( pronuncia, "%.mp3" ) ~= nil or string.find( pronuncia, "%.wav" ) ~= nil or string.find( pronuncia, "%.ogg" ) ~= nil or string.find( pronuncia, "%.wma" ) ~= nil) then
							if not vetorTodas.foneticasEpronuncias[xxy] then vetorTodas.foneticasEpronuncias[xxy] = {} end
							vetorTodas.foneticasEpronuncias[xxy][2] = pronuncia
							aumentar = true
						end
						if aumentar then
							xxy = xxy + 1
						end
					end
					local i = 1
					while i <= #vetorTodas.foneticasEpronuncias do
						if not vetorTodas.foneticasEpronuncias[i][1] and not vetorTodas.foneticasEpronuncias[i][2] then
							vetorTodas.foneticasEpronuncias = {}
							i = #vetorTodas.foneticasEpronuncias+1
						end
						i = i+1
					end
				end
			end
			
			if auxVar == "video" then
				lixo,str = vetorTodas[j]:match("([^=])=+ *([^\13]+)")
				local auxComp = string.lower(str)
				if string.len(auxComp) > 4 and (string.find( auxComp, "%.mp4" ) ~= nil or string.find( auxComp, "%.mkv" ) ~= nil or string.find( auxComp, "%.m4v" ) ~= nil or string.find( auxComp, "%.3gp" ) ~= nil or string.find( auxComp, "%.mov" ) ~= nil) then
					vetorTodas.video = {}
					local arquivo,var2,var3
					local cont = 1
					for text in string.gmatch(auxComp,"([^|]*)") do
						if cont == 1 then arquivo = text end
						if cont == 2 then var2 = text end
						if cont == 3 then var3 = text end
						cont = cont + 1
					end
					if var2 and string.find(var2,"titulo=") then
						titulo = string.gsub(var2,"titulo=%s*","")
					elseif var2 and string.find(var2,"fonte=") then
						fonte = string.gsub(var2,"fonte=%s*","")
					end
					if var3 and string.find(var3,"titulo=") then
						titulo = string.gsub(var3,"titulo=%s*","")
					elseif var3 and string.find(var3,"fonte=") then
						fonte = string.gsub(var3,"fonte=%s*","")
					end
					local fonte = nil
					local titulo = nil
					vetorTodas.video.arquivo = arquivo
					vetorTodas.video.titulo = titulo
					vetorTodas.video.fonte = fonte
				else
					table.insert(listaDeErros, "Arquivo: "..atributos.pasta.."/"..atributos.arquivo.. " -> 'video'".." contem um erro (Atenção: não use acentuações no nome do arquivo)\n")
				end
			end
			
		end
	end
end
function M.criarDicionarioDeArquivoPadrao(atributos,listaDeErros)
	
	
	local function lerArquivoPadrao()
		local vetor = {}
		local path = system.pathForFile( atributos.pasta.."/"..atributos.arquivo, system.ResourceDirectory )
		if path then
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
							--print('non-utf8 sequence detected at position ' .. tostring(error_position))
							line = conversor.converterANSIparaUTFsemBoom(line)
						end
						if string.find(line,"=") then
							vetor[xx] = line
							--print("Line = ",line)
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
		else
			vetor.vazio = true
			native.showAlert("Atenção!","Não existe o arquivo: ".. atributos.arquivo ..".",{"ok"})
		end
		
		return vetor
	end

	local vetorTodas = lerArquivoPadrao()
	--thales1
	local padrao = {
						traducao = nil,
						significado = nil,
						categoriaG = nil,
						fonetica = nil,
						pronuncia = nil,
						imagens = nil,
						video = nil,
						origem = nil,
						referenciasContextuais = nil,
						referencia = nil
					}
							
					vetorTodas.traducao = padrao.traducao
					vetorTodas.significado = padrao.significado
					vetorTodas.categoriaG = padrao.categoriaG
					vetorTodas.fonetica = padrao.fonetica
					vetorTodas.pronuncia = padrao.pronuncia
					vetorTodas.imagens = padrao.imagens
					vetorTodas.video = padrao.video
					vetorTodas.referenciasContextuais = padrao.referenciasContextuais
					vetorTodas.referencia = padrao.referencia

					
	M.criarDicionarioDeArquivoPadraoAux(vetorTodas,padrao,atributos,listaDeErros)
	
					
	return vetorTodas
end

------------------------------------------------------------------
--CRIAR RODAPÉ APARTIR DE ARQUIVOS --------------------------------
------------------------------------------------------------------
function criarRodapeDeArquivoPadraoAux(vetorTodas,padrao,atributos,listaDeErros)
	for j=1,#vetorTodas do
	
		if vetorTodas[j] ~= nil then
		
			local lowerString = string.lower(vetorTodas[j])
			
			if string.find( lowerString:match("([^=]+)="), "texto" ) ~= nil then
				if not vetorTodas.texto or  vetorTodas.texto == {"vazio"} or type(vetorTodas.texto) ~= "table" then
					vetorTodas.texto = {}
				end
				
				local lixo,str = vetorTodas[j]:match("([^=]+)=+%s*([^\13]+)")
				
				local past = {}
				local firstMatch = string.match(str,"(.+)|+")
				print("firstMatch",firstMatch)
				if firstMatch == nil then
					firstMatch = string.match(str,"(.+)")
				end
				table.insert(vetorTodas.texto,firstMatch)
				string.gsub(str, "|+(.+)",
					function (s)
						table.insert(vetorTodas.texto,s)
					end)
				
				local i = 1
				print(#vetorTodas.texto,vetorTodas.texto[i])
				while i <= #vetorTodas.texto do
					if string.len(vetorTodas.texto[i]) <= 1 then
						table.remove(vetorTodas.texto,i)
						i = i-1
					end
					i = i+1
				end

			end
			
			if string.find( lowerString:match("([^=]+)="), "url" ) ~= nil and not string.find( lowerString:match("([^=]+)="), 'beded' )then
				if not vetorTodas.url then
					vetorTodas.url = {}
				end
				
				local lixo,str = vetorTodas[j]:match("([^=]+)=+%s*([^\13]+)")
				
				local past = {}
				local firstMatch = string.match(str,"(.+)|+")
				if firstMatch == nil then
					firstMatch = string.match(str,"(.+)")
				end
				table.insert(past,firstMatch)
				string.gsub(str, "|+(.+)",
					function (s)
						table.insert(past,s)
					end)
				
				local i = 1
				while i <= #vetorTodas.url do
					if string.len(vetorTodas.url[i]) <= 1 then
						table.remove(vetorTodas.url,i)
						i = i-1
					end
					i = i+1
				end
			end
			
			if string.find( lowerString:match("([^=]+)="), "tamanho" ) ~= nil then
				local aux = -1
				local aux2 = ""
				lixo,str = vetorTodas[j]:match("([^=]+)=+%s*([^\13]+)")
				for past in string.gmatch(str, '([a-z]+)') do
					aux2 = past
				end
				for past in string.gmatch(str, '([0-9]+)') do
					aux = tonumber(past)
				end
				if aux2 == "nil" then
				else
					vetorTodas.tamanho = aux
				end
				if aux2 ~= "nil" then
					if (vetorTodas.tamanho < 1 or vetorTodas.tamanho > W)then
						table.insert(listaDeErros, "Arquivo: "..atributos.arquivo.. " -> Item  - 'tamanho'".." contem um erro no valor")
						vetorTodas.tamanho = padrao.tamanho
					end
				end
			end
			
			
			if string.find( lowerString:match("([^=]+)="), "urlembeded" ) ~= nil then
				if not vetorTodas.urlembeded then
					vetorTodas.urlembeded = {}
				end
				
				local lixo,str = vetorTodas[j]:match("([^=]+)=+%s*([^\13]+)")
				
				local past = {}
				local firstMatch = string.match(str,"(.+)|+")
				if firstMatch == nil then
					firstMatch = string.match(str,"(.+)")
				end
				table.insert(past,firstMatch)
				string.gsub(str, "|+(.+)",
					function (s)
						table.insert(past,s)
					end)
				
				local i = 1
				while i <= #vetorTodas.urlembeded do
					if string.len(vetorTodas.urlembeded[i]) <= 1 then
						table.remove(vetorTodas.urlembeded,i)
						i = i-1
					end
					i = i+1
				end
			end
		
			
			M.lerPropDicionario(atributos,vetorTodas,j)
		
		end
	end
end
M.criarRodapeDeArquivoPadraoAux = criarRodapeDeArquivoPadraoAux
function criarRodapeDeArquivoPadrao(atributos,listaDeErros)
	
	local function lerArquivoPadrao()
		local vetor = {}
		local path = system.pathForFile( atributos.pasta.."/"..atributos.arquivo, system.ResourceDirectory )
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
						--print('non-utf8 sequence detected at position ' .. tostring(error_position))
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
	--thales1
	local padrao = {
						texto = {"vazio"},
						url = nil,
						urlEmbeded = nil,
						dicionario = nil,
						tamanho = 20
					}
							
	vetorTodas.texto = padrao.texto
	vetorTodas.url = padrao.url
	vetorTodas.urlEmbeded = padrao.urlEmbeded
	vetorTodas.dicionario = padrao.dicionario
	vetorTodas.tamanho = padrao.tamanho
					
	criarRodapeDeArquivoPadraoAux(vetorTodas,padrao,atributos,listaDeErros)
	
					
	return vetorTodas
end
M.criarRodapeDeArquivoPadrao = criarRodapeDeArquivoPadrao

------------------------------------------------------------------
--CRIAR CARDDECK APARTIR DE ARQUIVO --------------------------------
------------------------------------------------------------------
function criarDeckDeArquivoPadraoAux(vetorTodas,padrao,atributos,listaDeErros)
	
	for j=1,#vetorTodas do
		if vetorTodas[j] ~= nil then
			vetorTodas[j] = auxFuncs.verificarComentario(vetorTodas[j])
			local lowerString = conversor.stringLowerAcento(vetorTodas[j])
			if string.find( lowerString:match("([^=]+)="), "conteudo" ) ~= nil  then
				lixo,str = vetorTodas[j]:match("([^=]+)=+([^\13]+)")
				str = string.gsub(str,"\\n","\n")
				if string.len(str) > 0 then
					local aux = str
					
					vetorTodas.conteudo = aux
					if string.gsub(aux," ","") == "nil" then
						vetorTodas.conteudo = ""
					end
				else
					table.insert(listaDeErros, "Arquivo: "..atributos.arquivo.. " -> Item - 'conteudo'".." está vazio")
					
					vetorTodas.conteudo = padrao.conteudo
				end
			end
			if string.find( lowerString:match("([^=]+)="), "som" ) ~= nil then
				lixo,str = vetorTodas[j]:match("([^=])=+ *([^\13]+)")
				local jaAdicionou = false
				for past in string.gmatch(str, '([^\13]+)') do
					if string.len(past) > 4 and string.find( past, '%.' ) ~= nil and (string.find( past, "mp3" ) ~= nil or string.find( past, "MP3" ) ~= nil or string.find( past, "wav" ) ~= nil or string.find( past, "WAV" ) ~= nil or string.find( past, "aac" ) ~= nil or string.find( past, "AAC" ) ~= nil or string.find( past, "ogg" ) ~= nil or string.find( past, "OGG" ) ~= nil or string.find( past, "wma" ) ~= nil or string.find( past, "WMA" ) ~= nil ) then
						vetorTodas.som = past
					elseif string.find( past, 'nil' )~= nil and string.find( past, '[.]' ) ~= nil then
						if jaAdicionou == false then
							jaAdicionou = true
							vetorTodas.som = nil
						else
							vetorTodas.som = nil
						end
					end
					
				end
			end
			if string.find( lowerString:match("([^=]+)="), "titulo" ) ~= nil  then
				lixo,str = vetorTodas[j]:match("([^=]+)=+%s*([^\13]+)")
				str = string.gsub(str,"\\n","\n")
				if string.len(str) > 0 then
					local aux = str
					
					vetorTodas.titulo = aux
					if string.gsub(aux," ","") == "nil" then
						vetorTodas.titulo = ""
					end
				else
					table.insert(listaDeErros, "titulo: "..atributos.titulo.. " -> Item - 'titulo'".." está vazio")
					
					vetorTodas.titulo = padrao.titulo
				end
			end
			if string.find( lowerString:match("([^=]+)="), "tipo" ) ~= nil  then
				lixo,str = vetorTodas[j]:match("([^=]+)=+%s*([^\13]+)")
				if string.len(str) > 0 then
					local aux = str
					
					vetorTodas.tipo = aux
					if string.gsub(aux," ","") == "nil" then
						vetorTodas.tipo = ""
					end
				else
					table.insert(listaDeErros, "tipo: "..atributos.tipo.. " -> Item - 'tipo'".." está vazio")
					
					vetorTodas.tipo = padrao.tipo
				end
			end
			
			if string.find( vetorTodas[j]:match("([^=]+)="), "pasta" ) ~= nil then
				lixo,str = vetorTodas[j]:match("([^=]+)=+%s*([^\13]+)")	
				if type(str) == "string" and string.len(str) > 1 then
					vetorTodas.pasta = str
				else
					vetorTodas.pasta = padrao.pasta
				end
			end
			if string.find( lowerString:match("([^=]+)="), "texto" ) ~= nil  then
				lixo,str = vetorTodas[j]:match("([^=]+)=+%s*([^\13]+)")
				str = string.gsub(str,"\\n","\n")
				if string.len(str) > 0 then
					local aux = str
					
					vetorTodas.texto = aux
					if string.gsub(aux," ","") == "nil" then
						vetorTodas.texto = nil
					end
				else
					table.insert(listaDeErros, "texto: "..atributos.texto.. " -> Item - 'texto'".." está vazio")
					
					vetorTodas.texto = padrao.texto
				end
			end
			if string.find( lowerString:match("([^=]+)="), "arquivo" ) ~= nil then
				lixo,str = vetorTodas[j]:match("([^=])=+%s*([^\13]+)")
				local jaAdicionou = false
				if str then
					for past in string.gmatch(str, '([^\13]+)') do
						if string.len(past) > 4 and string.find( past, '%.' ) ~= nil and (string.find( past, "mp4" ) ~= nil or string.find( past, "jpg" ) ~= nil or string.find( past, "mkv" ) ~= nil or string.find( past, "png" ) ~= nil or string.find( past, "m4v" ) ~= nil or string.find( past, "mp3" ) ~= nil or string.find( past, "3gp" ) ~= nil or string.find( past, "wav" ) ~= nil or string.find( past, "mov" ) ~= nil or string.find( past, "ogg" ) ~= nil or string.find( past, "wma" ) ~= nil) then
							vetorTodas.arquivo = atributos.pasta.."/Outros Arquivos/"..past
						else
							vetorTodas.arquivo = ""
							if jaAdicionou == false then
								table.insert(listaDeErros, "Arquivo: "..atributos.pasta.."/"..atributos.arquivo.. " -> 'arquivo'".." contem um erro (Atenção: não use acentuações no nome do arquivo)\n")
								jaAdicionou = true
							else
								
							end
						end
					end
				else
					vetorTodas.arquivo = ""
					table.insert(listaDeErros, "Arquivo: "..atributos.pasta.."/"..atributos.arquivo.. " -> Video-> 'arquivo'".." está vazio ou não foi encontrado.")
				end
			end
			
			if string.find( lowerString:match("([^=]+)="), "youtube" ) ~= nil then
				lixo,str = vetorTodas[j]:match("([^=])=+ *([^\13]+)")
				local jaAdicionou = false
				if string.find(str,"be/") then
					vetorTodas.youtube = str
				elseif string.find(str,"be.com/watch%?v=") then
					vetorTodas.youtube = str
				else
					if string.gsub(str," ","") == "nil" then
						vetorTodas.youtube = nil
					else
						vetorTodas.youtube = ""
					end
				end
				if vetorTodas.youtube and string.len(vetorTodas.youtube) and string.len(vetorTodas.youtube) <= 3 then
					table.insert(listaDeErros, "Arquivo: "..atributos.arquivo.. " -> Item - 'youtube'".." está incorreto ou vazio")
					vetorTodas.youtube = nil
				end
			end
			
			if string.find( lowerString:match("([^=]+)="), "atributo alt" ) ~= nil or string.find( lowerString:match("([^=]+)="), "atributoalt" ) ~= nil then
				lixo,str = vetorTodas[j]:match("([^=]+)=+([^\13]+)")
				str = string.gsub(str,"\\n","\n")
				if string.len(str) > 0 then
					vetorTodas.atributoALT = str
					if string.gsub(str," ","") == "nil" then
						vetorTodas.atributoALT = ""
					end
				else
					table.insert(listaDeErros, "Arquivo: "..atributos.arquivo.. " -> Item - 'atributo ALT'".." está vazio")
					vetorTodas.atributoALT = padrao.atributoALT
				end
			end
			if string.find( lowerString:match("([^=]+)="), "urlembeded" ) ~= nil or string.find( lowerString:match("([^=]+)="), 'url' ) ~= nil and not string.find( 	lowerString:match("([^=]+)="), 'embeded' )then
				vetorTodas.url = {}
				local arquivos = {}
				local xxy = 1
				lixo,str = vetorTodas[j]:match("([^=]+)=+%s*([^\13]+)")
				str = string.gsub(str,"[ ]+","")
				if string.gsub(str," ","") == "nil" then
					vetorTodas.url = nil
				else
					for past in string.gmatch(str, '([^|]+)') do
						vetorTodas.url[xxy] = past
						xxy = xxy + 1
					end
					local i = 1
					while i <= #vetorTodas.url do
						if string.len(vetorTodas.url[i]) < 1 then
							vetorTodas.url = {}
							i = #vetorTodas.url+1
						end
						i = i+1
					end
				end
			end
			if string.find( lowerString:match("([^=]+)="), 'url' ) ~= nil and not string.find( lowerString:match("([^=]+)="), 'embeded' )then
				vetorTodas.url = {}
				local arquivos = {}
				local xxy = 1
				lixo,str = vetorTodas[j]:match("([^=]+)=+%s*([^\13]+)")
				str = string.gsub(str,"[ ]+","")
				if string.gsub(str," ","") == "nil" then
					vetorTodas.url = nil
				else
					for past in string.gmatch(str, '([^|]+)') do
						vetorTodas.url[xxy] = past
						xxy = xxy + 1
					end
					local i = 1
					while i <= #vetorTodas.url do
						if string.len(vetorTodas.url[i]) < 1 then
							vetorTodas.url = {}
							i = #vetorTodas.url+1
						end
						i = i+1
					end
				end
			end
			if string.find( lowerString:match("([^=]+)="), " x" ) ~= nil or string.find( lowerString:match("([^=]+)="), "-x" ) then
				local aux = -1
				local aux2 = ""
				lixo,str = vetorTodas[j]:match("([^=]+)=+([^\13]+)")
				for past in string.gmatch(str, '([a-z]+)') do
					aux2 = past
				end
				for past in string.gmatch(str, '([0-9]+)') do
					aux = tonumber(past)
				end
				if aux2 == "nil" then
				else
					vetorTodas.x = aux
				end
				if aux2 ~= "nil" then
					if (vetorTodas.x < 0 or vetorTodas.x > W)then
						table.insert(listaDeErros, "Arquivo: "..atributos.arquivo.. " -> Item - 'x'".." contem um erro no valor")
						vetorTodas.x = padrao.x
					end
				end
			end
			if string.find( lowerString:match("([^=]+)="), "y" ) or string.find( lowerString:match("([^=]+)="), " saltar " ) ~= nil then
				local multiplicador = 1
				if string.find( lowerString:match("([^=]+)="), " saltar " ) then
					multiplicador = 30
				end
				local aux = -1
				local aux2 = ""
				lixo,str = vetorTodas[j]:match("([^=]+)=+([^\13]+)")
				for past in string.gmatch(str, '([a-z]+)') do
					aux2 = past
				end
				for past in string.gmatch(str, '([0-9]+)') do
					if string.find(str,"-") then
						aux = -1*(tonumber(past) * multiplicador)
					else
						aux = tonumber(past * multiplicador)
					end
				end
				if aux2 == "nil" then
				else
					vetorTodas.y = aux  * multiplicador
				end
			end



			if string.find( lowerString:match("([^=]+)="), "enunciado" ) ~= nil  then
				lixo,str = vetorTodas[j]:match("([^=]+)=+%s*([^\13]+)")
				str = string.gsub(str,"\\n","\n")
				if string.len(str) > 0 then
					vetorTodas.enunciado = str
					if string.gsub(str," ","") == "nil" then
						vetorTodas.enunciado = nil
					end
				else
					table.insert(listaDeErros, "Arquivo: "..atributos.arquivo.. " -> Item - 'enunciado'".." está vazio")
					
					vetorTodas.enunciado = padrao.enunciado
				end
			end
			
			if string.find( lowerString:match("([^=]+)="), 'alternativas' ) ~= nil and not string.find( lowerString:match("([^=]+)="), 'alternativas sorteadas' ) then
				vetorTodas.alternativas = {}
				local arquivos = {}
				local xxy = 1
				lixo,str = vetorTodas[j]:match("([^=]+) *=+ *([^\13]+)")
				for past in string.gmatch(str, '([^|]+)') do
					vetorTodas.alternativas[xxy] = past
					xxy = xxy + 1
					print("ALTERNATIVA?",vetorTodas.alternativas[xxy],xxy-1)
				end
				if xxy-1 ~= vetorTodas.numeroAlternativas then
					
				end
				local i = 1
				while i <= #vetorTodas.alternativas do
					if string.len(vetorTodas.alternativas[i]) < 1 then
						vetorTodas.alternativas = {}
						i = #vetorTodas.alternativas+1
					end
					i = i+1
				end
				vetorTodas.numeroAlternativas = #vetorTodas.alternativas
			end
			
			if string.find( lowerString:match("([^=]+)="), 'correta' ) ~= nil then
				local arquivos = {}
				local xxy = 1
				vetorTodas.corretas = {}
				lixo,str = vetorTodas[j]:match("([^=]+)=+%s*([^\13]+)")
				for past in string.gmatch(str, '([0-9]+)') do
					vetorTodas.corretas[xxy] = tonumber(past)
					xxy = xxy + 1
					print("correta?",tonumber(past),vetorTodas.numeroAlternativas)
					local numAlternativas = vetorTodas.numeroAlternativas
					if not numAlternativas then numAlternativas = tonumber(past) end
					if tonumber(past) > numAlternativas or tonumber(past) < 1 then
						native.showAlert("Atenção","O card: "..vetorTodas.numeroCard.. " contém um erro!\n O campo de alternativa correta está com um número inválido. favor verificar e corrigir.",{"OK"})
					end
				end
				if xxy-1 > vetorTodas.numeroAlternativas then
					table.insert(listaDeErros, "Arquivo: "..atributos.arquivo.. " -> O numero de corretas não corresponde ao de alternativas")
				end
				local i = 1
				while i <= #vetorTodas.corretas do
					if vetorTodas.corretas[i] < 1 then
						vetorTodas.corretas = {}
						i = #vetorTodas.corretas+1
					end
					i = i+1
				end
				if vetorTodas.corretas[1] then
					local aux = {vetorTodas.corretas[1]}
					vetorTodas.corretas = aux
					aux = nil
				end
			end
			
			if string.find( vetorTodas[j]:match("([^=]+)="), "intervalo" ) ~= nil or string.find( vetorTodas[j]:match("([^=]+)="), "timer" ) ~= nil then
				
				lixo,str = vetorTodas[j]:match("([^=]+) *=+ *([^\13]+)")
				local xxy = 1
				for past in string.gmatch(str, '([0-9]+)') do
					aux = tonumber(past)
					
				end
				if aux and aux > 1 then
					vetorTodas.tempoPorImagem = aux
					
				else
					vetorTodas.tempoPorImagem = 300
				end
			end
			
			M.lerPropDicionario(atributos,vetorTodas,j)
		end
	end

	local function lerArquivo(atributos)
		local vetor = {}
		local path = system.pathForFile(atributos.caminho.."/"..atributos.arquivo, system.ResourceDirectory )
		
		local file, errorString = io.open( path, "r" )
		local xx=1
		local ignorar = true
		if not file then
			print( "File error: " .. errorString )
		else
			for line in file:lines() do
				if type(line) == "string" and string.len( line ) then
					vetor[xx] = line
					xx = xx+1
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
	local vetorAux = {}
	
	if vetorTodas.pasta and vetorTodas.tipo and vetorTodas.tipo == "animacao" and auxFuncs.fileExists(atributos.pasta.."/Outros Arquivos/"..vetorTodas.pasta.."/dllImagens.txt") == true then
		print("ANIMAÇÂO?",atributos.pasta.."/Outros Arquivos/"..vetorTodas.pasta)
		vetorAux = lerArquivo({caminho = atributos.pasta.."/Outros Arquivos/"..vetorTodas.pasta,arquivo = "dllImagens.txt"})
		print(vetorAux)
		for i=1,#vetorAux do
			vetorAux[i] = string.gsub(vetorAux[i],"\13","")
			print(vetorAux[i])
		end
		vetorTodas.imagens = vetorAux
	end
	if vetorTodas.imagens and vetorTodas.imagens[1] == "imagemErro1.png" then
		vetorTodas.pasta = "Anim Padrao.lib"
	end

end
M.criarDeckDeArquivoPadraoAux = criarDeckDeArquivoPadraoAux
function criarDeckDeArquivoPadrao(atributos,listaDeErros)

	local vetorTodas = M.lerArquivoPadrao()
	
	criarDeckDeArquivoPadraoAux(vetorTodas,padrao,atributos,listaDeErros)
	
	return vetorTodas
end
M.criarDeckDeArquivoPadrao = criarDeckDeArquivoPadrao

return M