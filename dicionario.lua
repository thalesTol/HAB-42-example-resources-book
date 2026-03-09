local M = {}
-- bibliotecas necessárias --
local validarUTF8 = require("utf8Validator")
local conversor = require("conversores")
local leituraTXT = require("leituraArquivosTxT")
local auxFuncs = require("ferramentasAuxiliares")
------------------------------------------------------------------
-- funções internas ----------------------------------------------
------------------------------------------------------------------
local function tirarAExtencao(str)
	local inverso = string.reverse(str)
	local inversoReduzidoNome = string.sub( inverso, 5 )
	local nome = string.reverse(inversoReduzidoNome)
	return nome
end
-- NUMERAIS ROMANOS --
local RomanNumerals = { }

RomanNumerals.map = { 
    I = 1,
    V = 5,
    X = 10,
    L = 50,
    C = 100, 
    D = 500, 
    M = 1000,
}
RomanNumerals.numbers = { 1, 5, 10, 50, 100, 500, 1000 }
RomanNumerals.chars = { "I", "V", "X", "L", "C", "D", "M" }

function RomanNumerals.ToRomanNumerals(s)
    --s = tostring(s)
    s = tonumber(s)
    if not s or s ~= s then error"Unable to convert to number" end
    if s == math.huge then error"Unable to convert infinity" end
    s = math.floor(s)
    if s <= 0 then return s end
	local ret = ""
        for i = #RomanNumerals.numbers, 1, -1 do
        local num = RomanNumerals.numbers[i]
        while s - num >= 0 and s > 0 do
            ret = ret .. RomanNumerals.chars[i]
            s = s - num
        end
        --for j = i - 1, 1, -1 do
        for j = 1, i - 1 do
            local n2 = RomanNumerals.numbers[j]
            if s - (num - n2) >= 0 and s < num and s > 0 and num - n2 ~= n2 then
                ret = ret .. RomanNumerals.chars[j] .. RomanNumerals.chars[i]
                s = s - (num - n2)
                break
            end
        end
    end
    return ret
end

function RomanNumerals.ToNumber(s)
    s = s:upper()
    local ret = 0
    local i = 1
    while i <= s:len() do
    --for i = 1, s:len() do
        local c = s:sub(i, i)
        if c ~= " " then -- allow spaces
            local m = RomanNumerals.map[c] or error("Unknown Roman Numeral '" .. c .. "'")
            
            local next = s:sub(i + 1, i + 1)
            local nextm = RomanNumerals.map[next]
            
            if next and nextm then
                if nextm > m then 
                -- if string[i] < string[i + 1] then result += string[i + 1] - string[i]
                -- This is used instead of programming in IV = 4, IX = 9, etc, because it is
                -- more flexible and possibly more efficient
                    ret = ret + (nextm - m)
                    i = i + 1
                else
                    ret = ret + m
                end
            else
                ret = ret + m
            end
        end
        i = i + 1
    end
    return ret
end
------------------------------------------------------------------

------------------------------------------------------------------
-- funções externas ----------------------------------------------
------------------------------------------------------------------

local function pegarTextosEPalavras(atributos,Telas,listaDeErros,vetorRetornar,contagemInicialPaginas,numeroTotal)
			
	local ppp = numeroTotal.PaginasPre + numeroTotal.Indices + 1
	if atributos.pasta == "PaginasPre" then
		ppp = 1
	end
	Telas[atributos.pasta] = {}
	local totalPaginas = atributos.nPaginas + ppp - 1
	local vetorRodapes = {}
	local vetorCards = {}
	vetorCards.numeroTotalCards =0
	vetorCards.paginasComCards = {}
	vetorCards.idLivro = atributos.idLivro
	local vetorCardsMongo = {}
	vetorCardsMongo.idLivro = atributos.idLivro
	vetorCardsMongo.numeroTotalCards =0
	local vetorDics = {}
	local vetorpalavrasDic = {}
	local vetorpalavrasDicArquivos = {}
	local vetorPalavrasDicComPag = {}
	local vetorPalavrasIndiceRemissivo = {}
	local contadorRodapes = 1
	local contadorDic = 1
	
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
	
	local vetorTelas = {}
	for pag = ppp,  totalPaginas do
		local iii = pag
		atributos.arquivo = Telas.arquivos[iii]
		local nomeArquivo = tirarAExtencao(Telas.arquivos[iii])
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
		local decks = 0
		local vetorTodas = {{}}
		
		local vetorTela = {}
		
		vetorTela.ordemElementos = {}
		vetorTela.cardDeck = {}
		
		
		local function lerArquivoTela()
			local path = system.pathForFile( atributos.pasta.."/"..atributos.arquivo, system.ResourceDirectory )
			if atributos.exercicio then
				path = system.pathForFile( atributos.exercicio.."/"..atributos.arquivo, system.ResourceDirectory )
			end
			
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
							elseif string.find( line, "card" ) ~= nil then
								table.insert(vetorTela.ordemElementos,"card")
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
		
		local function pegarNumeroRealPagina(paginaSistema)
			local pagina
			if type(paginaSistema) == "number" then
				pagina = paginaSistema + contagemInicialPaginas -numeroTotal.PaginasPre-numeroTotal.Indices -1
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
		local function contagemDaPaginaHistorico(pag)
			local pagina
			if type(pag) == "number" then
				pagina = pag + contagemInicialPaginas - numeroTotal.PaginasPre-numeroTotal.Indices -1
			else
				pagina = pag 
			end
			return pagina
		end
		local IDelemento = 1
		local paginaReal = pegarNumeroRealPagina(pag)
		if string.find(paginaReal,"%-") then
			paginaReal = RomanNumerals.ToRomanNumerals(string.gsub(paginaReal,"%-",""))
		else
			paginaReal = paginaReal
		end
		
		if vetorTela ~= nil and vetorTela.ordemElementos ~= nil then

			for ord=1,#vetorTela.ordemElementos do
				local vetorConteudos = procurarConteudo(vetorTodas[ord])
				vetorConteudos.texto = vetorConteudos.texto or ""
				vetorConteudos.textoComControladores = vetorConteudos.textoComControladores or ""
				vetorConteudos.conteudo = vetorConteudos.conteudo or ""
				vetorConteudos.conteudoComControladores = vetorConteudos.conteudoComControladores or ""
				if not vetorTela[ord] then
					vetorTela[ord] = {}
				end
				if vetorConteudos then
					if vetorTela.ordemElementos[ord] == "texto" then
						vetorTela[ord].tipo = vetorTela.ordemElementos[ord] .. " " .. textos
						vetorTela[ord].texto = vetorConteudos.texto
						vetorTela[ord].ID = paginaReal.."|"..IDelemento
						textos = textos + 1
						--IDelemento = IDelemento + 1
					elseif vetorTela.ordemElementos[ord] == "imagem" then
						vetorTela[ord].tipo = vetorTela.ordemElementos[ord] .. " " .. imagens
						vetorTela[ord].texto = vetorConteudos.conteudo
						vetorTela[ord].ID = paginaReal.."|"..IDelemento
						imagens = imagens + 1
						--IDelemento = IDelemento + 1
					elseif vetorTela.ordemElementos[ord] == "video" then
						vetorTela[ord].tipo = vetorTela.ordemElementos[ord] .. " " .. videos
						vetorTela[ord].texto = vetorConteudos.conteudo
						vetorTela[ord].ID = paginaReal.."|"..IDelemento
						videos = videos + 1
						--IDelemento = IDelemento + 1
					elseif vetorTela.ordemElementos[ord] == "animacao" then
						vetorTela[ord].tipo = vetorTela.ordemElementos[ord] .. " " .. animacoes
						vetorTela[ord].texto = vetorConteudos.conteudo
						vetorTela[ord].ID = paginaReal.."|"..IDelemento
						animacoes = animacoes + 1
						--IDelemento = IDelemento + 1
					elseif vetorTela.ordemElementos[ord] == "som" then
						vetorTela[ord].tipo = vetorTela.ordemElementos[ord] .. " " .. sons
						vetorTela[ord].texto = vetorConteudos.conteudo
						vetorTela[ord].ID = paginaReal.."|"..IDelemento
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
						vetorTela[ord].ID = paginaReal.."|"..IDelemento
						exercicios = exercicios + 1
						--IDelemento = IDelemento + 1
					elseif vetorTela.ordemElementos[ord] == "botao" then
						vetorTela[ord].tipo = vetorTela.ordemElementos[ord] .. " " .. botoes
						vetorTela[ord].texto = vetorConteudos.conteudo .. "\n" .. vetorConteudos.texto
						vetorTela[ord].ID = paginaReal.."|"..IDelemento
						botoes = botoes + 1
						--IDelemento = IDelemento + 1
						
					elseif vetorTela.ordemElementos[ord] == "card" then
					
						local padrao = {}
						local VetorPadraoDeck = {}
						local vetorAux = vetorTodas[ord]
						if auxFuncs.fileExists(atributos.pasta.."/Config Padrao Deck.txt") == true then
							VetorPadraoDeck = leituraTXT.criarDeckDeArquivoPadrao({pasta = atributos.pasta,arquivo = "Config Padrao Deck.txt"},listaDeErros)
							padrao = VetorPadraoDeck
						elseif atributos.pasta2 and auxFuncs.fileExists(atributos.pasta2.."/Config Padrao Deck.txt") == true then
							VetorPadraoDeck = leituraTXT.criarDeckDeArquivoPadrao({pasta = atributos.pasta2,arquivo = "Config Padrao Deck.txt"},listaDeErros)
							padrao = VetorPadraoDeck
							
						else
							padrao = {
								tipo = "texto",
								texto = "Este card está vazio",
								arquivo = nil,
								url = nil,
								atributoALT = nil,
								conteudo = nil,
								youtube = nil,
								x = nil,
								y = nil,
								conteudo = nil,
								urlEmbeded = nil,
								titulo = "Flash Card",
								enunciado = nil,
								alternativas = nil,
								corretas = nil,
								pasta = nil
							}
						end
						
						vetorAux.arquivo = padrao.arquivo
						vetorAux.pasta = padrao.pasta
						vetorAux.texto = padrao.texto
						vetorAux.tipo = padrao.tipo
						vetorAux.url = padrao.url
						vetorAux.atributoALT = padrao.atributoALT
						vetorAux.youtube = padrao.youtube
						vetorAux.x = padrao.x
						vetorAux.y = padrao.y
						vetorAux.url = padrao.url
						vetorAux.urlEmbeded = padrao.urlEmbeded
						vetorAux.titulo = padrao.titulo
						vetorAux.enunciado = padrao.enunciado
						vetorAux.alternativas = padrao.alternativas
						vetorAux.corretas = padrao.corretas
						--vetorAux.numeroCard = numeroCard
						vetorAux.conteudo = padrao.conteudo
						vetorAux.pagina = paginaReal
						
						leituraTXT.criarDeckDeArquivoPadraoAux(vetorAux,padrao,atributos,{})
						
						if not vetorCards[paginaReal] then 
							vetorCards[paginaReal] = {} 
							table.insert(vetorCards.paginasComCards,{})
						end
						if not vetorCards[paginaReal].numeroCards then vetorCards[paginaReal].numeroCards = 0 end
						
						
						vetorCards[paginaReal].numeroCards = vetorCards[paginaReal].numeroCards + 1
						
						vetorAux.numeroCard = vetorCards[paginaReal].numeroCards
						-- fazer upload dos docs we download da nuvem para os cards de cada pagina
						if auxFuncs.fileExistsDoc("Deck_pag"..paginaReal..".json") then
							local vetorDeTextosDosCards = auxFuncs.loadTable("Deck_pag"..paginaReal..".json")
							for cad=1,#vetorDeTextosDosCards do
								if tonumber(vetorDeTextosDosCards[cad].numeroCard) == vetorAux.numeroCard then
									vetorAux.textoExtra = vetorDeTextosDosCards[cad].texto
								end
							end
						end
						
						
						table.insert(vetorCards[paginaReal],vetorAux)
						
						-- retirando linhas de programação do vetor para enviar
						for kk1=1,#vetorCards[paginaReal] do
							if vetorCards[paginaReal][kk1] then
								for kk2=0,#vetorCards[paginaReal][kk1] do
									vetorCards[paginaReal][kk1][kk2] = nil
								end
							end
						end
						
						table.insert(vetorCardsMongo,vetorAux)
						
						vetorCardsMongo.numeroTotalCards = vetorCardsMongo.numeroTotalCards + 1
						
						vetorCards.numeroTotalCards = vetorCards.numeroTotalCards + 1
						vetorCards.paginasComCards[#vetorCards.paginasComCards] = {pag=paginaReal,n=vetorCards[paginaReal].numeroCards}
					end
				end
				IDelemento = IDelemento + 1
			end
			
		end
		auxFuncs.saveTable(vetorCards,"cardDeck.json","res")
		
		
		for txts=1,#vetorTela do
			if vetorTela[txts].texto then
				local controleIdPalavra = 1
				local controleNumPalavraRodape = 1
				local controleNumPalavraDic = 1
				local palavrasRodape = ""
				local temEntradaRodape = false
				-- pegar rodape e dicionario de cada palavra --
				for palavra in string.gmatch(vetorTela[txts].texto,"([^%s]+)") do
					-- RODAPÉ -----------------------------
					
					if string.find(palavra,"#r=.+#") then
						local palavra = string.match(palavra,"#r=.+#([^#]+)")
						palavrasRodape = palavra
						temEntradaRodape = true
					elseif temEntradaRodape and not string.find(palavra,"#/r=.+#") then
						palavrasRodape = palavrasRodape .. " " ..palavra
					end
					if string.find(palavra,"#/r=.+#") then
						local arquivoTxT = string.match(palavra,"#/r=(.+)#")
						palavra = string.gsub(palavra,"#/r=.+#","")
						if not temEntradaRodape then palavrasRodape = palavra else palavrasRodape = palavrasRodape .. " " ..palavra end
						local paginaRodape,elementoRodape = string.match(vetorTela[txts].ID,"(.+)|(.+)")
						if not vetorRodapes[tostring(paginaRodape)] then vetorRodapes[tostring(paginaRodape)] = {} end
						table.insert(vetorRodapes[tostring(paginaRodape)],
							{numRodape = tostring(contadorRodapes),
							numElem = tostring(elementoRodape),
							numPalavra = tostring(controleNumPalavraRodape),
							palavras = palavrasRodape
							}
						)
						palavrasRodape = ""
						temEntradaRodape = false
						if contadorRodapes == 1 then
							auxFuncs.criarTxTRes("rodape.txt",arquivoTxT.."\n")
						else
							if not string.find(arquivoTxT,"%.txt") then
								arquivoTxT = arquivoTxT..".txt"
							end
							auxFuncs.addTxTRes("rodape.txt",arquivoTxT.."\n")
						end
						contadorRodapes = contadorRodapes + 1
					end
					controleNumPalavraRodape = controleNumPalavraRodape+1
					-- DICIONÁRIO --------------------------
					if string.find(palavra,"#/dic=.+#") then
						local arquivoTxT = string.match(palavra,"#dic=(.+)#")
						palavra = string.gsub(palavra,"#dic=[^#]+#","")
						palavra = string.gsub(palavra,"#/dic=[^#]+#","")
						local paginaDic,elementoDic = string.match(vetorTela[txts].ID,"(.+)|(.+)")
						if not vetorDics[tostring(paginaDic)] then vetorDics[tostring(paginaDic)] = {} end
						table.insert(vetorDics[tostring(paginaDic)],
							{numDic = tostring(contadorDic),
							numElem = tostring(elementoDic),
							numPalavra = tostring(controleNumPalavraDic)
							}
						)
						table.insert(vetorpalavrasDic,palavra)
						
						if contadorDic == 1 then
							auxFuncs.criarTxTRes("dicionario.txt",arquivoTxT.."\n")
						else
							if not string.find(arquivoTxT,"%.txt") then
								arquivoTxT = arquivoTxT..".txt"
							end
							auxFuncs.addTxTRes("dicionario.txt",arquivoTxT.."\n")
						end
						table.insert(vetorpalavrasDicArquivos,string.match(arquivoTxT,"([^#]+)"))
						contadorDic = contadorDic + 1
					end
					controleNumPalavraDic = controleNumPalavraDic+1
				end
				
				-- filtrar o rodapé do texto --
				vetorTela[txts].texto = string.gsub(vetorTela[txts].texto,"#/r=.+#","")
				----------------------------------
				-- filtrar o Dicionário do texto --
				vetorTela[txts].texto = string.gsub(vetorTela[txts].texto,"#/dic=.+#","")
				----------------------------------
				
				local filtrado = string.gsub(vetorTela[txts].texto,".",{ ["\13"] = "",["\10"] = "\13\10"})
				
				
				if not vetorTela[txts].paragrafos then 
					vetorTela[txts].paragrafos = {}
				end
				local par = 1
				for paragrafo in string.gmatch(filtrado,"([^\13\10]+)") do
					vetorTela[txts].paragrafos[par] = {}
					vetorTela[txts].paragrafos[par].conteudo = paragrafo
					vetorTela[txts].paragrafos[par].IDdados = vetorTela[txts].ID .. "|" ..par
					vetorTela[txts].paragrafos[par].frases = {}
					local fra = 1
					local paragrafoAux = string.gsub(paragrafo,"#dic=.+#","")
					paragrafoAux = string.gsub(paragrafoAux,"#/dic=.+#","")
					for frase in string.gmatch(paragrafoAux,"([^%.!;%?]+)") do
						vetorTela[txts].paragrafos[par].frases[fra] = {}
						vetorTela[txts].paragrafos[par].frases[fra].conteudo = frase
						vetorTela[txts].paragrafos[par].frases[fra].IDdados = vetorTela[txts].ID .. "|" ..par.."|"..fra
						vetorTela[txts].paragrafos[par].frases[fra].palavras = {}
						local pal = 1
						--local fraseaux = string.match(frase,"%s*(.+)")
						--if fraseaux then frase = fraseaux end
						for palavra in string.gmatch(frase,"([^%s%.!;?,:%%#@%/\\%[%]%(%)%d]+)") do
							
							
							if vetorRodapes[paginaRodape] and vetorRodapes[paginaRodape].elem then
								vetorRodapes[paginaRodape].numPalavra = controleIdPalavra
								vetorRodapes[paginaRodape].palavra = palavra
							end
							local is_valid, error_position = validarUTF8.validate(palavra)
							if not is_valid then print('non-utf8 sequence detected at position ' .. tostring(error_position))
								palavra = conversor.converterANSIparaUTFsemBoom(palavra)
							end
							local descartar = false--conversor.filtrar_palavras(palavra)
							if not descartar then
								vetorTela[txts].paragrafos[par].frases[fra].palavras[pal] = {}
								vetorTela[txts].paragrafos[par].frases[fra].palavras[pal].IDdados = vetorTela[txts].ID .. "|" ..par.."|"..fra.."|"..pal
								vetorTela[txts].paragrafos[par].frases[fra].palavras[pal].ID = vetorTela[txts].ID .. "|" ..controleIdPalavra
								vetorTela[txts].paragrafos[par].frases[fra].palavras[pal].conteudo = palavra
								if not vetorRetornar[palavra] then
									vetorRetornar[palavra] = {}
									vetorRetornar[palavra].frases = {{vetorTela[txts].paragrafos[par].frases[fra].IDdados,vetorTela[txts].paragrafos[par].frases[fra].conteudo}}
									vetorRetornar[palavra].frases[1].paragrafo = {vetorTela[txts].paragrafos[par].IDdados,vetorTela[txts].paragrafos[par].conteudo}
									vetorRetornar[palavra].frases[1].palavrasIDs = {vetorTela[txts].ID .. "|" ..controleIdPalavra}
									vetorRetornar[palavra].PalavrasIDs = {vetorTela[txts].ID .. "|" ..controleIdPalavra}
									vetorRetornar[palavra].quantidade = 1
								else
									table.insert(vetorRetornar[palavra].PalavrasIDs,vetorTela[txts].ID .. "|" ..controleIdPalavra)
									vetorRetornar[palavra].quantidade = vetorRetornar[palavra].quantidade + 1
									local existe_a_frase = false
									for existe=1,#vetorRetornar[palavra].frases do
										if vetorRetornar[palavra].frases[existe][1] == vetorTela[txts].paragrafos[par].frases[fra].IDdados then
											--existe_a_frase = true
										end
									end
									if not existe_a_frase then
										table.insert(vetorRetornar[palavra].frases,{vetorTela[txts].paragrafos[par].frases[fra].IDdados,vetorTela[txts].paragrafos[par].frases[fra].conteudo})
										vetorRetornar[palavra].frases[#vetorRetornar[palavra].frases].paragrafo = {vetorTela[txts].paragrafos[par].IDdados,vetorTela[txts].paragrafos[par].conteudo}
									end
									if vetorRetornar[palavra].frases[#vetorRetornar[palavra].frases].palavrasIDs then
										table.insert(vetorRetornar[palavra].frases[#vetorRetornar[palavra].frases].palavrasIDs,vetorTela[txts].ID .. "|" ..controleIdPalavra)
									end
								end
								
								pal = pal + 1
							end
							controleIdPalavra = controleIdPalavra + 1
						end
						
						fra = fra + 1
					end
					par = par + 1
				end
			end
		end
		
		
		
		auxFuncs.saveTable(vetorRodapes,"rodape.json","res")
		auxFuncs.saveTable(vetorDics,"dicionario.json","res")
		-- salvar txt das palavras com paginas para o dicionario
		
		---------------------------------------------------------
		
		local numeroRealPagina = contagemDaPaginaHistorico(pag)
		--vetorRetornar[numeroRealPagina]=vetorTela
		table.insert(vetorTelas,vetorTela)
	end
	
	-- upload cards to database
	local function cardsListener( event )

		if ( event.isError ) then
			  --local alert = native.showAlert( "Network Error . Check Connection", "Connect to Internet", { "Try again" }  )
			  print("Network Error . Check Connection", "Connect to Internet")
		else
			print("WARNING: Começo MONGODB Cards\n","|".. tostring(event.response) .. "|","\n","WARNING: FIM MONGODB Cards")
		end
	end
	local json = require("json")
	local headers = {}
	headers["Content-Type"] = "application/json"
	local parametersCards = {}
	parametersCards.headers = headers
	auxFuncs.saveTable(vetorCardsMongo,"cardsMongo.json","res")
	local dados = json.encode(vetorCardsMongo)
	parametersCards.body = dados
	local URL = "https://omniscience42.com/EAudioBookDB/mongoCards.php"
	network.request(URL, "POST", cardsListener,parametersCards)
	
	-- verificar paginas que aparecem as palavras do dicionario
	local vetorArquivoJsonDicionarioImpressao = {}
	for i=1,#vetorpalavrasDicArquivos do
		table.insert(vetorArquivoJsonDicionarioImpressao,{vetorpalavrasDic[i],vetorpalavrasDicArquivos[i]})
	end
	auxFuncs.saveTable(vetorArquivoJsonDicionarioImpressao,"dicImpressao.json","res")
	vetorpalavrasDic = auxFuncs.alphanumsort(vetorpalavrasDic)
	for p=1,#vetorpalavrasDic do
		table.insert(vetorPalavrasDicComPag,{vetorpalavrasDic[p],{}})
	end
	local textosPaginas = {}
	for pag = ppp,  totalPaginas do
		
		local iii = pag
		atributos.arquivo = Telas.arquivos[iii]
		local nomeArquivo = tirarAExtencao(Telas.arquivos[iii])
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
		
		local function pegarNumeroRealPagina(paginaSistema)
			local pagina
			if type(paginaSistema) == "number" then
				pagina = paginaSistema + contagemInicialPaginas -numeroTotal.PaginasPre-numeroTotal.Indices -1
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
		
		local function lerArquivoTela()
			local vetor = {}
			local path = system.pathForFile( atributos.pasta.."/"..atributos.arquivo, system.ResourceDirectory )

			if atributos.exercicio then
				path = system.pathForFile( atributos.exercicio.."/"..atributos.arquivo, system.ResourceDirectory )
			end
			
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
		local paginaReal = pegarNumeroRealPagina(pag)
		if string.find(paginaReal,"%-") then
			paginaReal = RomanNumerals.ToRomanNumerals(string.gsub(paginaReal,"%-",""))
		else
			paginaReal = paginaReal
		end
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
				local filtrado = string.gsub(vetorTela[txts].texto,".",{ ["\13"] = "",["\10"] = "\13\10"})
				
				-- verificar todas as palavras da página para o dicionario
				
				for pal=1,#vetorPalavrasDicComPag do
					
					local lowerPalavra = conversor.stringLowerAcento(vetorPalavrasDicComPag[pal][1])
					lowerPalavra = string.gsub(lowerPalavra,"%-","%%-")
					local lowerTexto = conversor.stringLowerAcento(filtrado)
					
					if string.find(lowerTexto,"[%s%p]*"..lowerPalavra.."[%s%p]*") then
						print("lowerTexto\n",lowerTexto)
						print("lowerPalavra",lowerPalavra)
						if not vetorPalavrasDicComPag[pal][2][1] then
							vetorPalavrasDicComPag[pal][2][1] = paginaReal
						end
						for pags=1,#vetorPalavrasDicComPag[pal][2] do
							if vetorPalavrasDicComPag[pal][2][pags] == paginaReal then
								
							elseif pags == #vetorPalavrasDicComPag[pal][2] then
								table.insert(vetorPalavrasDicComPag[pal][2],paginaReal)
							end
						end
					end
				end
			end
		end
		vetorTela.ordemElementos = {}
		textosPaginas[paginaReal] = string.gsub(textosPagina,".",{ ["\13"] = " ",["\10"] = "\13\10"})
	end
	auxFuncs.saveTable(textosPaginas,"todasAsPalavrasPorPagina.json","res")
	local TextoTxT = ""
	-- salvar o arquivo TxT --
	if vetorPalavrasDicComPag[1] and vetorPalavrasDicComPag[1][1] then
		for IndRem=1,#vetorPalavrasDicComPag do
			print("vetorPalavrasDicComPag[IndRem][1]",vetorPalavrasDicComPag[IndRem][1])
			TextoTxT = TextoTxT .. vetorPalavrasDicComPag[IndRem][1] .. "||"
			for pag=1,#vetorPalavrasDicComPag[IndRem][2] do
				TextoTxT = TextoTxT ..vetorPalavrasDicComPag[IndRem][2][pag].. "||"
			end
			if #vetorPalavrasDicComPag ~= IndRem then TextoTxT = TextoTxT .. "\n" end
		end
		auxFuncs.criarTxTRes2("Dicionario palavras/dllIndiceRemissivo.txt",TextoTxT)
	else
		auxFuncs.criarTxTRes2("Dicionario palavras/dllIndiceRemissivo.txt","")
	end
	vetorRetornar.id_livro = atributos.idLivro0
	vetorRetornar.id_usuario = atributos.idAluno0
	vetorRetornar.id_autor = atributos.idProprietario0
	-- thales2
	Telas[atributos.pasta] = vetorTelas
	Telas[atributos.pasta].vetorCards = vetorCards
	Telas[atributos.pasta].vetorRodapes = vetorRodapes
	Telas[atributos.pasta].vetorRodapes = vetorDics
	return vetorRetornar
end
M.pegarTextosEPalavras = pegarTextosEPalavras



return M