-- RODAPÉ
local M = {}
local W = display.viewableContentWidth ;
local H = display.viewableContentHeight;
local MenuRapido = require("MenuBotaoDireito")
local leituraTXT = require("leituraArquivosTxT")
local auxFuncs = require("ferramentasAuxiliares")
local conversor = require("conversores")
local historicoLib = require("historico")
local function escreverNoHistorico(texto)
	local date = os.date( "*t" )
	local dataHistorico = date.day.."|"..date.month.."|"..date.year.."|"..date.hour..":"..date.min..":"..date.sec.."|||"
	
	local path = system.pathForFile( "historico.txt", system.DocumentsDirectory )
	local file, errorString = io.open( path, "a" )
	file:write(dataHistorico..texto.."\n")
	io.close( file )
	file = nil
	
	if system.pathForFile("",system.ResourceDirectory) == nil then
		--copyFileHistorico( "historico.txt", string.gsub(system.pathForFile("historico.txt",system.DocumentsDirectory),"historico.txt",""), "historico.txt", "/sdcard", true )
	end

end
local function lerTextoArquivo(arquivo)
	local path = system.pathForFile( arquivo, system.ResourceDirectory )

	local file, errorString = io.open( path, "r" )
	local contents = file:read( "*a" )
	io.close( file )
	 
	file = nil
	
	return contents
end
local function pegarNumeroPaginaRomanosHistorico(pagina)
	local auxPaginaLivro = tostring(paginaLivro)
	if string.find(auxPaginaLivro,"%-") then
		auxPaginaLivro = RomanNumerals.ToRomanNumerals(string.gsub(auxPaginaLivro,"%-",""))
	else
		auxPaginaLivro = auxPaginaLivro
	end
	return pagina
end
local function criarTextodePalavras(atributos)
	if not atributos.margem then
		atributos.margem = 0
	end
	if not atributos.x then
		atributos.x = 0
	end
	if not atributos.Y then
		atributos.Y = 0
	end
	if not atributos.font then
		atributos.font = native.systemFont
	end
	if not atributos.fonte then
		atributos.fonte = native.systemFont
	end
	if not atributos.tamanho then
		atributos.tamanho = 40
	end
	if not atributos.largura then
		atributos.largura = 720
	end
	if not atributos.espacamento then
		atributos.espacamento = 0
	end
	
	if atributos.x < 0 then
		if not atributos.xNegativo then
			atributos.xNegativo = atributos.x
		end
		atributos.x = 0
	else
		if not atributos.xNegativo then
			atributos.xNegativo = 0
		end
	end
	if not atributos.cor then
		atributos.cor = {.5,.5,.5}
	end
	if not atributos.alinhamento then
		atributos.alinhamento = "meio"
	end
	if not atributos.texto then
		atributos.texto = "texto inválido"
	end
	if not atributos.embeded then
		atributos.embeded = "nao"
	end
	if not atributos.modificou then atributos.modificou = 0 end
	-- Verificando as fontes da pasta Fontes -------------
	local Fontes = lerTextoArquivo("Fontes/dllFontes.txt")
	------------------------------------------------------

	
	
	local grupoTexto = display.newGroup()
	grupoTexto.vetorContextos = {}
	local vetorTextoAux = {}
	local vetorPalavras = {}
	vetorPalavras.texto = {}
	vetorPalavras.tipo = {}
	local imagemW = 0
	local imagemH = 0
	if atributos.imagemW then
		imagemW = atributos.imagemW
	end
	if atributos.imagemH then
		imagemH = atributos.imagemH
	end
	
	atributos.texto = string.gsub(atributos.texto," +\n","\n")
	atributos.texto = string.gsub(atributos.texto,"\n ","\n")
	atributos.texto = string.gsub(atributos.texto,"\n"," \n ")
	atributos.texto = string.gsub(atributos.texto,"	"," |tab| ")
	atributos.texto = string.gsub(atributos.texto,"  "," |e| ")
	
	local temNegrito = false
	local temSublinhado = false
	local temItalico = false
	local temLink = false
	local temTam = false
	local temRod = false
	local temVar = false
	local temSom = false
	local temImagem = false
	local temVideo = false
	local temAnimacao = false
	local temFonte = false
	local nLink = 0
	local nVar = 0
	local tVar = nil
	local nTam = 0
	local nRod = 0
	local nCor1 = 0
	local nCor2 = 0
	local nCor3 = 0
	local nSom = 0
	local nVideo = 0
	local nImagem = 0
	local nAnimacao = 0
	local nFonte = 0
	local nDic = 0
	local frases = {}
	local PalavraComposta = ""
	vetorPalavras.DicPalavrasComp = {}
	-- função para guardar as frases
	local textoFrasesTemp = string.gsub(atributos.texto,"%?","%?|")
	textoFrasesTemp = string.gsub(textoFrasesTemp,"%.[^%w|<>%[%]]","%.|")
	textoFrasesTemp = string.gsub(textoFrasesTemp,"!","!|")
	
	for str in textoFrasesTemp:gmatch("([^|]+)") do
		if #str > 5 then
			table.insert(frases,str)
		end
	end
	textoFrasesTemp = nil
	-- função para criar fechadores para cada palavra se precisar (no caso de propriedde que alcança multiplas palavras)
	local contadorPalavras = 0
	local vetorAuxPComposta = {}
	
	-- criando vetor dos códigos de palavras --
	local vetorCodigos = {
		"#s#","#/s#",
		"#n#","#/n#",
		"#i#","#/i#",
		"#l%d+#","#/l%d+#",
		"#t=%d+#","#/t=%d+#",
		"#audio=[^#]+#","#/audio#",
		"#imagem=[^#]+#","#/imagem#",
		"#video=[^#]+#","#/video#",
		"#animacao=[^#]+#","#/animacao#",
		"#font=[^#]+#","#/font#",
		"#dic=[^#]+#","#/dic[^#]+#",
		"#c=%d+,%d+,%d+#","#/c#",
		"#r=.+#",
		"#/r=.+#"
	}
	local espArq = "%+%+%+" -- espaço entre palavras dos arquivos
	-------------------------------------------
	local function filtrarCodigosDaPalavra(str)
		local palavra = str
		local vetor = vetorCodigos
		for i=1,#vetor do
			palavra = string.gsub(palavra,vetor[i],"")
		end
		
		return palavra
	end
	
	for str in atributos.texto:gmatch("([^ ]+)") do -- loop para acrescentar código em palavras intermediárias.
		contadorPalavras = contadorPalavras + 1
		-- sublinhado --
		local auxS = string.find(str,"#s#")
		local auxFecharS = string.find(str,"#/s#")
		if auxS	then temSublinhado = true end
		if auxFecharS then temSublinhado = false; str ="#s#".. str   end
		if temSublinhado == true and not auxFecharS then
			if auxS then str = str .. "#/s#";
			else str = "#s#"..str .. "#/s#"; end 
		end
		-- negrito --
		local auxN = string.find(str,"#n#")
		local auxFecharN = string.find(str,"#/n#")
		if auxN	then temNegrito = true end
		if auxFecharN then temNegrito = false; str ="#n#".. str   end
		if temNegrito == true and not auxFecharN then
			if auxN then str = str .. "#/n#";
			else str = "#n#"..str .. "#/n#"; end
		end
		-- italico --
		local auxI = string.find(str,"#i#")
		local auxFecharI = string.find(str,"#/i#")
		if auxI	then temItalico = true end
		if auxFecharI then temItalico = false; str ="#i#".. str   end
		if temItalico == true and not auxFecharI then
			if auxI then str = str .. "#/i#";
			else str = "#i#"..str .. "#/i#"; end 
		end
		-- link --
		local auxL,auxL2 = string.find(str,"#l%d+#")
		local auxFecharL = string.find(str,"#/l%d+#")
		
		if auxL then
			local aux = string.sub(str,auxL,auxL2)
			nLink = string.match(aux,"%d+")
		end
		if auxL	then temLink = true end
		if auxFecharL and auxL ~= "#l%d+#"then temLink = false; str ="#l"..nLink.."#".. str   end
		if temLink == true and not auxFecharL then
			if auxL then str = str .. "#/l"..nLink.."#";
			else str = "#l"..nLink.."#"..str .. "#/l"..nLink.."#"; end 
		end
		-- tamanho letra --
		local auxT,auxT2 = string.find(str,"#t=%d+#")
		local auxFecharT = string.find(str,"#/t=%d+#")
		
		if auxT then
			local aux = string.sub(str,auxT,auxT2)
			nTam = string.match(aux,"%d+")
		end
		if auxT	then temTam = true end
		if auxFecharT and auxT ~= "#t=%d+#"then temTam = false; str ="#t="..nTam.."#".. str   end
		if not nTam then
			nTam = atributos.tamanho
		end
		if temTam == true and not auxFecharT then
			if auxT then str = str .. "#/t="..nTam.."#";
			else str = "#t="..nTam.."#"..str .. "#/t="..nTam.."#"; end 
		end
		----------
		-- efeito de audio --
		local auxSom,auxSom2 = string.find(str,"#audio=[^#]+")
		local auxFecharSom = string.find(str,"#/audio#")

		if auxSom then
			local aux = string.sub(str,auxSom,auxSom2)
			nSom = string.match(aux,"#audio=[^#]+")
			nSom = string.gsub(nSom,"#audio=","")
		end
		if auxSom	then temSom = true end
		if auxFecharSom and auxSom ~= "#audio=[^#]+"then temSom = false; str ="#audio="..nSom.."#".. str   end
		if not nSom then
			nSom = "nil"
		end
		if temSom == true and not auxFecharSom then
			if auxSom then str = str .. "#/audio#";
			else str = "#audio="..nSom.."#"..str .. "#/audio#"; end 
		end
		----------
		-- efeito de imagem --
		local auxImagem,auxImagem2 = string.find(str,"#imagem=[^#]+")
		local auxFecharImagem = string.find(str,"#/imagem#")

		if auxImagem then
			local aux = string.sub(str,auxImagem,auxImagem2)
			nImagem = string.match(aux,"#imagem=[^#]+")
			nImagem = string.gsub(nImagem,"#imagem=","")
		end
		if auxImagem	then temImagem = true end
		if auxFecharImagem and auxImagem ~= "#imagem=[^#]+"then temImagem = false; str ="#imagem="..nImagem.."#".. str   end
		if not nImagem then
			nImagem = "nil"
		end
		if temImagem == true and not auxFecharImagem then
			if auxImagem then str = str .. "#/imagem#";
			else str = "#imagem="..nImagem.."#"..str .. "#/imagem#"; end 
		end
		----------
		-- efeito de video --
		local auxVideo,auxVideo2 = string.find(str,"#video=[^#]+")
		local auxFecharVideo = string.find(str,"#/video#")

		if auxVideo then
			local aux = string.sub(str,auxVideo,auxVideo2)
			nVideo = string.match(aux,"#video=[^#]+")
			nVideo = string.gsub(nVideo,"#video=","")
		end
		if auxVideo	then temVideo = true end
		if auxFecharVideo and auxVideo ~= "#video=[^#]+"then temVideo = false; str ="#video="..nVideo.."#".. str   end
		if not nVideo then
			nVideo = "nil"
		end
		if temVideo == true and not auxFecharVideo then
			if auxVideo then str = str .. "#/video#";
			else str = "#video="..nVideo.."#"..str .. "#/video#"; end 
		end
		----------
		-- efeito de animacao --
		local auxAnimacao,auxAnimacao2 = string.find(str,"#animacao=[^#]+")
		local auxFecharAnimacao = string.find(str,"#/animacao#")

		if auxAnimacao then
			local aux = string.sub(str,auxAnimacao,auxAnimacao2)
			nAnimacao = string.match(aux,"#animacao=[^#]+")
			nAnimacao = string.gsub(nAnimacao,"#animacao=","")
		end
		if auxAnimacao	then temAnimacao = true end
		if auxFecharAnimacao and auxAnimacao ~= "#animacao=[^#]+"then temAnimacao = false; str ="#animacao="..nAnimacao.."#".. str   end
		if not nAnimacao then
			nAnimacao = "nil"
		end
		if temAnimacao == true and not auxFecharAnimacao then
			if auxAnimacao then str = str .. "#/animacao#";
			else str = "#animacao="..nAnimacao.."#"..str .. "#/animacao#"; end 
		end
		-- dicionario --
		local auxDic,auxDic2 = string.find(str,"#dic=[^#]+")
		local auxFecharDic = string.find(str,"#/dic=[^#]+")
		if auxDic then
			local aux = string.sub(str,auxDic,auxDic2)
			nDic = string.match(aux,"#dic=[^#]+")
			nDic = string.gsub(nDic,"#dic=","")
		end
		if auxDic then 
			temDic= true 
		end
		
		
		if temDic or auxFecharDic then
			local palavra = filtrarCodigosDaPalavra(str)
			
			local auxPalavraDic = string.sub(palavra,#palavra,#palavra)
			if auxPalavraDic == '%.' or auxPalavraDic == ';' or auxPalavraDic == ',' or auxPalavraDic == '!' or auxPalavraDic == '%?' or auxPalavraDic == ':' then
				palavra = string.sub(palavra,1,#palavra-1)
			end
			PalavraComposta = PalavraComposta .. " " .. palavra
			table.insert(vetorAuxPComposta,contadorPalavras)
		end
		if temDic and auxFecharDic then
			for dic=1,#vetorAuxPComposta do
				vetorPalavras.DicPalavrasComp[vetorAuxPComposta[dic]] = PalavraComposta
			end
			PalavraComposta = ""
			vetorAuxPComposta = {}
		end	
		
		if auxFecharDic then 
			temDic = false; 
			str ="#dic="..nDic.."#".. str   
		end
		if not nDic then
			nDic = "nil"
		end
		
		if temDic == true and not auxFecharDic then -- tem dic mas não fecha na palavra
			if auxDic then 
				str = str .. "#/dic="..nDic.."#";
			else 
				str = "#dic="..nDic.."#"..str .. "#/dic="..nDic.."#"; 
			end 
		end
		-----------------
		-- mudar fonte --
		local auxFonte,auxFonte2 = string.find(str,"#font=[^#]+")
		local auxFecharFonte = string.find(str,"#/font#")

		if auxFonte then
			local aux = string.sub(str,auxFonte,auxFonte2)
			nFonte = string.match(aux,"#font=[^#]+")
			nFonte = string.gsub(nFonte,"#font=","")
		end
		if auxFonte	then temFonte = true end
		if auxFecharFonte then temFonte = false; str ="#font="..nFonte.."#".. str   end
		if not nFonte then
			nFonte = "nil"
		end
		if temFonte == true and not auxFecharFonte then
			if auxFonte then str = str .. "#/font#";
			else str = "#font="..nFonte.."#"..str .. "#/font#"; end 
		end
		---------------
		-- cor letra --
		local auxCor,auxCor2 = string.find(str,"#c=%d+,%d+,%d+#")
		local auxFecharCor = string.find(str,"#/c#")
		
		if auxCor then
			local aux = string.sub(str,auxCor,auxCor2)
			nCor1,nCor2,nCor3 = string.match(aux,"(%d+),(%d+),(%d+)")
			temCor = true
		end
		if auxFecharCor and auxCor ~= "#c=%d+,%d+,%d+#"then temCor = false; str ="#c="..nCor1..","..nCor2..","..nCor3.."#".. str   end
		if not (nCor1 or nCor2 or nCor3) then
			nCor1,nCor2,nCor3 = atributos.cor[1],atributos.cor[2],atributos.cor[3]
		end
		if temCor == true and not auxFecharCor then
			if auxCor1 and auxCor2 and auxCor3 then str = str .. "#/c#";
			else str = "#c="..nCor1..","..nCor2..","..nCor3.."#"..str .. "#/c#"; end
		end
		
		if not string.find(str,"#l%d##/l%d#") and not string.find(str,"#t=%d##/t=%d#") and not string.find(str,"#s##/s#") and not string.find(str,"#n##/n#") and not string.find(str,"#i##/i#")and not string.find(str,"#audio=[^#]+#/audio#")and not string.find(str,"#imagem=[^#]+#/imagem#")and not string.find(str,"#video=[^#]+#/video#")and not string.find(str,"#animacao=[^#]+#/animacao#")and not string.find(str,"#c=%d+,%d+,%d+##/c#") and not string.find(str,"#dic=[^#]+#/dic=[^#]+")and not string.find(str,"#font=[^#]+#/font#") then
			if string.find(str,"|e|") then
				local aux = string.gsub(str,"|e|","  ")
				table.insert(vetorTextoAux,aux)
			elseif string.find(str,"|tab|") then
				local aux = string.gsub(str,"|tab|","        ")
				table.insert(vetorTextoAux,aux)
			else
				table.insert(vetorTextoAux,str)
			end
		end
	end
	
	vetorPalavras.link = {}
	vetorPalavras.Tam = {}
	vetorPalavras.Rod = {}
	vetorPalavras.Dic = {}
	vetorPalavras.DicPalavrasCompostas = {}
	vetorPalavras.Som = {}
	vetorPalavras.Imagem = {}
	vetorPalavras.Video = {}
	vetorPalavras.Animacao = {}
	vetorPalavras.Fonte = {}
	vetorPalavras.Var = {}
	vetorPalavras.Cor = {}
	local vetorTamLetra = {}
	
	--print(atributos.texto.."\n\n")
	local contadorPalavrasRodape = 1
	local textoRodape = ""
	local contadorPalavrasDic = 1
	local vCodigos = {{"|>%[","sobre"},{"|<%[","sub"},{"|<>%[","sobreSub"},{"|t%d+%[","tam"},{"|n%[","neg"},{"|i%[","ita"},{"|ni%[","neg ita"},{"|f=[^%[]+%[","fonte"},{"|c=[^%[]+%[","cor"}}
	local metricaBase = graphics.getFontMetrics( atributos.fonte, atributos.tamanho )
	local function forAuxiliar0(i,limite) -- remover os códigos do texto
		textoRodape = textoRodape .. "|"..i.."|" .. vetorTextoAux[i]
		if string.match(vetorTextoAux[i],"%s+") then contadorPalavrasRodape = contadorPalavrasRodape - 1 end
		if string.find(vetorTextoAux[i],"#s#(.+)#/s#") or string.find(vetorTextoAux[i],"#l%d+#(.+)#/l%d+#") or string.find(vetorTextoAux[i],"#n#(.+)#/n#")  or string.find(vetorTextoAux[i],"#t=%d+#(.+)#/t=%d+#")  or string.find(vetorTextoAux[i],"#i#(.+)#/i#") or string.find(vetorTextoAux[i],"#audio=[^#]+(.+)#/audio#")or string.find(vetorTextoAux[i],"#imagem=[^#]+(.+)#/imagem#")or string.find(vetorTextoAux[i],"#video=[^#]+(.+)#/video#")or string.find(vetorTextoAux[i],"#animacao=[^#]+(.+)#/animacao#")  or string.find(vetorTextoAux[i],"#font=[^#]+(.+)#/font#") or string.find(vetorTextoAux[i],"#c=%d+,%d+,%d+#(.+)#/c#")or string.find(vetorTextoAux[i],"#Var%a%d+#")or string.find(vetorTextoAux[i],"#r=.+#")or string.find(vetorTextoAux[i],"#/r=.+#") or string.find(vetorTextoAux[i],"#dic=[^#]+(.+)#/dic=[^#]+")then
			local nadaAinda = true
			local textoAUsar = vetorTextoAux[i]
			vetorPalavras.tipo[i] = ""
			local fonteAtual = atributos.fonte
			if string.find(vetorTextoAux[i],"#s#(.+)#/s#") then
				vetorPalavras.texto[i] = string.gsub(textoAUsar,"#s#","")
				vetorPalavras.texto[i] = string.gsub(vetorPalavras.texto[i],"#/s#","")
				vetorPalavras.tipo[i] = "sublinhado"
				nadaAinda = false
				textoAUsar = vetorPalavras.texto[i]
			end	
			if string.find(vetorTextoAux[i],"#n#(.+)#/n#") then
				vetorPalavras.texto[i] = string.gsub(textoAUsar,"#n#","")
				vetorPalavras.texto[i] = string.gsub(vetorPalavras.texto[i],"#/n#","")
				vetorPalavras.tipo[i] = vetorPalavras.tipo[i] .. "negrito"
				nadaAinda = false
				textoAUsar = vetorPalavras.texto[i]
			end	
			if string.find(vetorTextoAux[i],"#i#(.+)#/i#") then
				vetorPalavras.texto[i] = string.gsub(textoAUsar,"#i#","")
				vetorPalavras.texto[i] = string.gsub(vetorPalavras.texto[i],"#/i#","")
				vetorPalavras.tipo[i] = vetorPalavras.tipo[i] .. "italico"
				nadaAinda = false
				textoAUsar = vetorPalavras.texto[i]
			end	
			if string.find(vetorTextoAux[i],"#l%d+#(.+)#/l%d+#") then
				local auxL,auxL2 = string.find(textoAUsar,"#l%d+#")
				local aux = string.sub(textoAUsar,auxL,auxL2)
				local nLinkL = string.match(aux,"%d+")
				
				vetorPalavras.texto[i] = string.gsub(textoAUsar,"#l%d+#","")
				vetorPalavras.texto[i] = string.gsub(vetorPalavras.texto[i],"#/l%d+#","")
				vetorPalavras.tipo[i] = vetorPalavras.tipo[i] .. "link"
				vetorPalavras.link[i] = tonumber(nLinkL)
				if vetorPalavras.link[i] == 0 then
					vetorPalavras.link[i] = 1
				end
			end
			if string.find(textoAUsar,"#r=.+#") then
				print("rodappé000 ",textoAUsar)
				vetorPalavras.texto[i] = string.gsub(textoAUsar,"#r=[^#]+#","")
				textoAUsar = vetorPalavras.texto[i]
			end
			if string.find(textoAUsar,"(.+)#/r=.+#") then
				print("rodappé ",textoAUsar)
				print(atributos.tela)
				print(atributos.tela.vetorRodapes)
				if atributos.tela.vetorRodapes then
					print("ACHOU UM RODAPE")
					local aux = string.match(textoAUsar,"#/r=(.+)#")
					aux = string.gsub(aux,espArq," ")
					--local aux = string.sub(textoAUsar,auxR+4,#textoAUsar-2)
					local nRodR = aux
					local paginaReal = tostring(atributos.tela.contagemDaPaginaHistorico)
					vetorPalavras.texto[i] = string.gsub(textoAUsar,"#/r=.+#","")
					vetorPalavras.texto[i] = string.gsub(vetorPalavras.texto[i],"#/r=.+#","")
					vetorPalavras.tipo[i] = vetorPalavras.tipo[i] .. "rodape"
					--vetorPalavras.Rod[i] = nRodR
					local numRodape = 0
					local palavras = ""
					for rod=1,#atributos.tela.vetorRodapes[paginaReal] do
						print("numPalavra",atributos.tela.vetorRodapes[paginaReal][rod].numPalavra,"palavra",vetorPalavras.texto[i],contadorPalavrasRodape)
						print(textoRodape)
						
						if 	atributos.tela.vetorRodapes[paginaReal][rod].numPalavra == tostring(contadorPalavrasRodape) and
							atributos.tela.vetorRodapes[paginaReal][rod].numElem == tostring(atributos.tela.elementoAtual) then
							palavras = atributos.tela.vetorRodapes[paginaReal][rod].palavras
							numRodape = atributos.tela.vetorRodapes[paginaReal][rod].numRodape
						end
					end
					local auxRodapeFiltrado = filtrarCodigosDaPalavra(vetorPalavras.texto[i])
					local auxRodape = string.sub(auxRodapeFiltrado,#auxRodapeFiltrado,#auxRodapeFiltrado)
					auxRodapeFiltrado = nil
					print("auxRodape",auxRodape)
					if auxRodape == '.' or auxRodape == ';' or auxRodape == ',' or auxRodape == '!' or auxRodape == '?' or auxRodape == ':' then
						vetorPalavras.texto[i] = string.sub(vetorPalavras.texto[i],1,#vetorPalavras.texto[i]-1).."|>["..numRodape.."]"..auxRodape
					else
						vetorPalavras.texto[i] = vetorPalavras.texto[i].."|>["..numRodape.."]"
					end
					print("rodpapé "..numRodape,vetorPalavras.texto[i])
					
					local jaAdicionou = false
					for c=1,#vetorPalavras.Rod do
						if vetorPalavras.Rod[c] == nRodR then jaAdicionou = true end
					end
					if not jaAdicionou and not atributos.sombra then
						auxFuncs.addTxTDoc("rodape.txt",nRodR.."|||"..numRodape.."|||"..palavras.."\n")
						print(nRodR.."|||"..numRodape.."|||"..palavras.."\n")
						--table.insert(vetorPalavras.Rod,nRodR)
					end
				else
					vetorPalavras.texto[i] = string.gsub(textoAUsar,"#r=.+#","")
					vetorPalavras.texto[i] = string.gsub(vetorPalavras.texto[i],"#/r=.+#","")
					--vetorPalavras.tipo[i] = vetorPalavras.tipo[i] .. "rodape"
				end
			end
			if string.find(textoAUsar,"#dic=[^#]+(.+)#/dic=[^#]+") then
				if atributos.tela.vetorDic then
					
					local auxDic1,auxDic2 = string.find(textoAUsar,"#dic=[^#]+")
					local aux = string.sub(textoAUsar,auxDic1,auxDic2)
					local nDicR = string.match(aux,"#dic=.+#")
					nDicR = string.gsub(aux,"#dic=","")
					nDicR = string.gsub(nDicR,espArq," ")
					vetorPalavras.texto[i] = string.gsub(textoAUsar,"#dic=[^#]+#","")
					vetorPalavras.texto[i] = string.gsub(vetorPalavras.texto[i],"#/dic=[^#]+#","")
					print("vetorPalavras.texto[i] = ",vetorPalavras.texto[i])
					vetorPalavras.tipo[i] = vetorPalavras.tipo[i] .. "dicionario"
					local numDic = 0
					for dic=1,#atributos.tela.vetorDic[tostring(atributos.tela.contagemDaPaginaHistorico)] do
						if 	atributos.tela.vetorDic[tostring(atributos.tela.contagemDaPaginaHistorico)][dic].numPalavra == tostring(contadorPalavrasDic) and
							atributos.tela.vetorDic[tostring(atributos.tela.contagemDaPaginaHistorico)][dic].numElem == tostring(atributos.tela.elementoAtual) then
							numDic = atributos.tela.vetorDic[atributos.tela.contagemDaPaginaHistorico][dic].numDic
						end
					end
					
					local jaAdicionou = false
					for c=1,#vetorPalavras.Dic do
						if vetorPalavras.Dic[c] == nDicR then jaAdicionou = true end
					end
					if not jaAdicionou then
						local palavra = vetorPalavras.DicPalavrasComp[i]
						auxFuncs.addTxTDoc("dicionario.txt",nDicR.."|||"..palavra.."\n")
					end
					vetorPalavras.Dic[i] = nDicR
					textoAUsar = vetorPalavras.texto[i]
				else
					vetorPalavras.texto[i] = string.gsub(textoAUsar,"#dic=[^#]+#","")
					vetorPalavras.texto[i] = string.gsub(vetorPalavras.texto[i],"#/dic=[^#]+#","")
				end
			end
			if string.find(vetorTextoAux[i],"#audio=[^#]+(.+)#/audio#") then
				local auxSom,auxSom2 = string.find(textoAUsar,"#audio=[^#]+")
				local aux = string.sub(textoAUsar,auxSom,auxSom2)
				local nSom = string.match(aux,"#audio=[^#]+")
				nSom = string.gsub(nSom,"#audio=","")
				nSom = string.gsub(nSom,espArq," ")
				vetorPalavras.texto[i] = string.gsub(textoAUsar,"#audio=[^#]+#","") -- retirando os códigos do texto
				vetorPalavras.texto[i] = string.gsub(vetorPalavras.texto[i],"#/audio#","")
				vetorPalavras.tipo[i] = vetorPalavras.tipo[i] .. "audio"
				vetorPalavras.Som[i] = nSom
				textoAUsar = vetorPalavras.texto[i]
			end
			if string.find(vetorTextoAux[i],"#imagem=[^#]+(.+)#/imagem#") then
				local auxImagem,auxImagem2 = string.find(textoAUsar,"#imagem=[^#]+")
				local aux = string.sub(textoAUsar,auxImagem,auxImagem2)
				local nImagem = string.match(aux,"#imagem=[^#]+")
				nImagem = string.gsub(nImagem,"#imagem=","")
				nImagem = string.gsub(nImagem,espArq," ")
				vetorPalavras.texto[i] = string.gsub(textoAUsar,"#imagem=[^#]+#","") -- retirando os códigos do texto
				vetorPalavras.texto[i] = string.gsub(vetorPalavras.texto[i],"#/imagem#","")
				vetorPalavras.tipo[i] = vetorPalavras.tipo[i] .. "imagem"
				vetorPalavras.Imagem[i] = nImagem
				textoAUsar = vetorPalavras.texto[i]
			end
			if string.find(vetorTextoAux[i],"#video=[^#]+(.+)#/video#") then
				local auxVideo,auxVideo2 = string.find(textoAUsar,"#video=[^#]+")
				local aux = string.sub(textoAUsar,auxVideo,auxVideo2)
				local nVideo = string.match(aux,"#video=[^#]+")
				nVideo = string.gsub(nVideo,"#video=","")
				nVideo = string.gsub(nVideo,espArq," ")
				vetorPalavras.texto[i] = string.gsub(textoAUsar,"#video=[^#]+#","") -- retirando os códigos do texto
				vetorPalavras.texto[i] = string.gsub(vetorPalavras.texto[i],"#/video#","")
				vetorPalavras.tipo[i] = vetorPalavras.tipo[i] .. "video"
				vetorPalavras.Video[i] = nVideo
				textoAUsar = vetorPalavras.texto[i]
			end
			if string.find(vetorTextoAux[i],"#animacao=[^#]+(.+)#/animacao#") then
				local auxAnimacao,auxAnimacao2 = string.find(textoAUsar,"#animacao=[^#]+")
				local aux = string.sub(textoAUsar,auxAnimacao,auxAnimacao2)
				local nAnimacao = string.match(aux,"#animacao=[^#]+")
				nAnimacao = string.gsub(nAnimacao,"#animacao=","")
				nAnimacao = string.gsub(nAnimacao,espArq," ")
				vetorPalavras.texto[i] = string.gsub(textoAUsar,"#animacao=[^#]+#","") -- retirando os códigos do texto
				vetorPalavras.texto[i] = string.gsub(vetorPalavras.texto[i],"#/animacao#","")
				vetorPalavras.tipo[i] = vetorPalavras.tipo[i] .. "animacao"
				vetorPalavras.video[i] = nAnimacao
				textoAUsar = vetorPalavras.texto[i]
			end
			
			if string.find(vetorTextoAux[i],"#font=[^#]+(.+)#/font#") then
				
				local auxFonte,auxFonte2 = string.find(textoAUsar,"#font=[^#]+")
				local aux = string.sub(textoAUsar,auxFonte,auxFonte2)
				local nFonte = string.match(aux,"#font=[^#]+")
				nFonte = string.gsub(nFonte,"#font=","")
				nFonte = string.gsub(nFonte,espArq," ")
				vetorPalavras.texto[i] = string.gsub(textoAUsar,"#font=[^#]+#","") -- retirando os códigos do texto
				vetorPalavras.texto[i] = string.gsub(vetorPalavras.texto[i],"#/font#","")
				vetorPalavras.tipo[i] = vetorPalavras.tipo[i] .. "fonte"
				vetorPalavras.Fonte[i] = "Fontes/"..nFonte
				textoAUsar = vetorPalavras.texto[i]
				fonteAtual = vetorPalavras.Fonte[i]
			end
			if string.find(vetorTextoAux[i],"#t=%d+#(.+)#/t=%d+#") then
				local auxT,auxT2 = string.find(textoAUsar,"#t=%d+#")
				local aux = string.sub(textoAUsar,auxT,auxT2)
				local nTamT = string.match(aux,"%d+")
				vetorPalavras.texto[i] = string.gsub(textoAUsar,"#t=%d+#","")
				vetorPalavras.texto[i] = string.gsub(vetorPalavras.texto[i],"#/t=%d+#","")
				vetorPalavras.tipo[i] = vetorPalavras.tipo[i] .. "tamanho"
				if atributos.modificou then
					vetorPalavras.Tam[i] = {tonumber(nTamT)*1.5 + atributos.modificou,fonteAtual}
				else
					vetorPalavras.Tam[i] = {tonumber(nTamT)*1.5,fonteAtual}
				end
				--table.insert(vetorTamanhos,vetorPalavras.Tam[i])
				if vetorPalavras.Tam[i] and vetorPalavras.Tam[i][1] == 0 then
					vetorPalavras.Tam[i] = {20*1.5 + atributos.modificou,fonteAtual}
				end
			end
			if not vetorPalavras.Tam[i] then
				vetorPalavras.Tam[i] = {atributos.tamanho,fonteAtual}
			end
			if string.find(vetorTextoAux[i],vCodigos[4][1]) then
				local Aux = string.match(vetorTextoAux[i],vCodigos[4][1])
				Aux = tonumber(string.match(Aux,"%d+"))
				if Aux and Aux>0 then
					vetorTamLetra[i] = {Aux,fonteAtual}
				end
			end
			if string.find(vetorTextoAux[i],"#c=%d+,%d+,%d+#(.+)#/c#") then
				print("vetorTextoAux[i]",vetorTextoAux[i])
				print("Veio aqui",vetorTextoAux[i])
				local auxCor,auxCor2 = string.find(textoAUsar,"#c=%d+,%d+,%d+#")
				local aux = string.sub(textoAUsar,auxCor,auxCor2)
				local nCor1,nCor2,nCor3 = string.match(aux,"(%d+),(%d+),(%d+)")
				
				vetorPalavras.texto[i] = string.gsub(textoAUsar,"#c=%d+,%d+,%d+#","")
				vetorPalavras.texto[i] = string.gsub(vetorPalavras.texto[i],"#/c#","")
				vetorPalavras.tipo[i] = vetorPalavras.tipo[i] .. "corPalavras"
				vetorPalavras.Cor[i] = {nCor1/255,nCor2/255,nCor3/255}
				textoAUsar = vetorPalavras.texto[i]
			end
			if not vetorPalavras.Cor[i] then
				vetorPalavras.Cor[i] = atributos.cor
			end
			if string.find(vetorTextoAux[i],"#Var%a%d+#") then
				local auxVar,auxVar2 = string.find(textoAUsar,"#Var%a%d+#")
				local aux = string.sub(textoAUsar,auxVar,auxVar2)
				local nVar = string.match(aux,"%d+")
				local tVar = string.sub(aux,4,4)
				local Nrandomico = nil
				local varEscolhida= "(vazio)" 
				-- pegar string da lista de acordo com o número --
				if atributos.listaVars then
					Nrandomico = math.random(#atributos.listaVars[nVar])
					varEscolhida = Nrandomico
				end
				---------------------------------------------------------
				vetorPalavras.texto[i] = string.gsub(textoAUsar,"#Var%a%d+#",varEscolhida)
				vetorPalavras.tipo[i] = vetorPalavras.tipo[i] .. "variável"
				vetorPalavras.Var[i] = tonumber(nLinkL)
				if vetorPalavras.link[i] == 0 then
					vetorPalavras.link[i] = 1
				end
			end
		else
			vetorPalavras.texto[i] = vetorTextoAux[i]
			vetorPalavras.tipo[i] = "normal"
		end
		print("OBSERVAR: ",contadorPalavrasRodape,vetorTextoAux[i])
		contadorPalavrasRodape = contadorPalavrasRodape + 1
		rodarLoopFor0(i+1,limite)
	end
	function rodarLoopFor0(i,limite)
		if i<=limite then forAuxiliar0(i,limite); end
	end
	rodarLoopFor0(1,#vetorTextoAux)
	
	local contadorGLinha = 1
	local contadorPalavras = {{}}
	--print(atributos.texto.."\n\n")
	
	-- calcular tamanho linhas --
	local maiorTamanhoLinha = metricaBase.height
	for i=1,#vetorPalavras.Tam do
		if vetorPalavras.Tam[i] then
			print("OPA",vetorPalavras.texto[i])
			local auxTam = graphics.getFontMetrics( vetorPalavras.Tam[i][2], vetorPalavras.Tam[i][1] )
			if auxTam.height> maiorTamanhoLinha then
				maiorTamanhoLinha = auxTam.height
			end
		end
	end
	for i=1,#vetorTamLetra do
		if vetorTamLetra[i] then
			local auxTam = graphics.getFontMetrics( vetorTamLetra[i][2], vetorTamLetra[i][1] )
			if auxTam.height> maiorTamanhoLinha then
				maiorTamanhoLinha = auxTam.height
			end
		end
	end
	
	local auxEspaco = display.newText(" ",((atributos.x + atributos.margem) + imagemW)/2 + 5,atributos.Y,atributos.fonte,atributos.tamanho)
	local metrics = graphics.getFontMetrics( atributos.fonte, maiorTamanhoLinha )
	local maiorMetrica = metrics.ascent
	local EsPacoOrigin = auxEspaco.width
	local EsPaco = EsPacoOrigin
	local AlTuRa = maiorTamanhoLinha
	auxEspaco:removeSelf()
	auxEspaco = nil
	-----------------------------
	local alturaSublinhado = 2
	
	
	--============================================================================================--
	--==== ORGANIZAR PALAVRAS EM LINHAS ==========================================================--
	-- Organizar as palavras em linhas -- de acordo com tamanho da 'margem', 'imagem' e 'posição x'
	--============================================================================================--
	local LarguraX = atributos.largura - atributos.margem*2 - atributos.x
	if atributos.xNegativo < 0 then
		LarguraX = atributos.largura - atributos.margem*2 + atributos.xNegativo
	end
	local primeiroDaLinha = true
	local guardarLinhas = {""}
	guardarLinhas.iniciouLinha = true
	guardarLinhas.numero = 0
	guardarLinhas[guardarLinhas.numero] = ""
	local devoAdicionarAltura = 0
	
	local contadorFrases = 1
	
	
	local function modificarNegritoItalico(fonte,tipo)
		local fonteVerificarAux = string.sub(fonte,1,#fonte-4)
		local fonteVerificar = string.gsub(fonteVerificarAux,"Fontes/","")
		local extencao = string.sub(fonte,#fonte-3,#fonte)
		if tipo == "negrito e italico" then
			if string.find(Fontes,fonteVerificar.."z"..extencao) then
				fonte = fonteVerificarAux.."z"..extencao
			elseif string.find(Fontes,fonteVerificar.."bi"..extencao) then
				fonte = fonteVerificarAux.."bi"..extencao
			elseif string.find(Fontes,fonteVerificar.."b"..extencao) then
				fonte = fonteVerificarAux.."b"..extencao
			elseif string.find(Fontes,fonteVerificar.."bd"..extencao) then
				fonte = fonteVerificarAux.."bd"..extencao
			elseif string.find(Fontes,fonteVerificar.."i"..extencao) then
				fonte = fonteVerificarAux.."i"..extencao
			end
		elseif tipo == "negrito" then
			if string.find(Fontes,fonteVerificar.."b"..extencao) then 
				fonte = fonteVerificarAux.."b"..extencao
			elseif string.find(Fontes,fonteVerificar.."bd"..extencao) then 
				fonte = fonteVerificarAux.."bd"..extencao
			end
		elseif tipo == "italico" then 
			if string.find(Fontes,fonteVerificar.."i"..extencao) then 
				fonte = fonteVerificarAux.."i"..extencao
			end
		end
		
		return fonte
	end
	local function modificarPalavra(vetorIndices,palavra,X,Y,fonte,tamanho)
		local grupoPalavra = display.newGroup()
		grupoPalavra.xNegGrupo = 0
		grupoPalavra.anchorChildren = true
		grupoPalavra.anchorX = 0
		grupoPalavra.anchorY = 1
		grupoPalavra.x = X
		grupoPalavra.y = Y
		-- retirar os simbolos para outros usos
		grupoPalavra.text = palavra
		for i=1,#vCodigos do
			if vCodigos[i][2] == "sobre" then
				grupoPalavra.text = string.gsub(grupoPalavra.text,vCodigos[i][1]," elevado a ")
			elseif vCodigos[i][2] == "sub" then
				grupoPalavra.text = string.gsub(grupoPalavra.text,vCodigos[i][1]," subescrito ")
			elseif vCodigos[i][2] == "sobreSub" then
				grupoPalavra.text = string.gsub(grupoPalavra.text,vCodigos[i][1],"")
			elseif vCodigos[i][2] == "tam" then
				grupoPalavra.text = string.gsub(grupoPalavra.text,vCodigos[i][1],"")
			elseif vCodigos[i][2] == "neg" then
				grupoPalavra.text = string.gsub(grupoPalavra.text,vCodigos[i][1],"")
			elseif vCodigos[i][2] == "ita" then
				grupoPalavra.text = string.gsub(grupoPalavra.text,vCodigos[i][1],"")
			elseif vCodigos[i][2] == "neg ita" then
				grupoPalavra.text = string.gsub(grupoPalavra.text,vCodigos[i][1],"")
			elseif vCodigos[i][2] == "fonte" then
				grupoPalavra.text = string.gsub(grupoPalavra.text,vCodigos[i][1],"")
			elseif vCodigos[i][2] == "cor" then
				grupoPalavra.text = string.gsub(grupoPalavra.text,vCodigos[i][1],"")
			end
		end
		---------------------------------------
		local vetorPartes = {}                   -- table to store the indices
		local palavra = string.match(palavra," *(.+)")
		print("palavraAA",palavra)
		for i=1,#vetorIndices+1 do 
			if i == 1 then
				if vetorIndices[i][1] ~= 1 then
					table.insert(vetorPartes,string.sub(palavra,1,vetorIndices[i][1]))
					print("i == 1",vetorPartes[#vetorPartes])
				end
			elseif i == #vetorIndices+1 then
				local pp = string.sub(palavra,vetorIndices[i-1][1],#palavra)
				if #pp > 1 then
					if vetorIndices[i-1][2] == "fim" then
						table.insert(vetorPartes,string.sub(palavra,vetorIndices[i-1][1]+1,#palavra))
					else
						table.insert(vetorPartes,string.sub(palavra,vetorIndices[i-1][1],#palavra))
					end
				end
				print("i == #vetorIndices+1",vetorPartes[#vetorPartes])
			else
				if vetorIndices[i-1][2] == "fim" then
					table.insert(vetorPartes,string.sub(palavra,vetorIndices[i-1][1]+1,vetorIndices[i][1]-1))
				else
					table.insert(vetorPartes,string.sub(palavra,vetorIndices[i-1][1],vetorIndices[i][1]-1))
				end
				print("i == else",vetorPartes[#vetorPartes])
			end
			
		end
		if #vetorPartes > 1 then if vetorPartes[#vetorPartes-1] == vetorPartes[#vetorPartes] then table.remove(vetorPartes,#vetorPartes) end end
		grupoPalavra.partes = {}
		local metricAntes = graphics.getFontMetrics( fonte, tamanho )
		local maiorY = Y
		local maiorX = 0
		local yExtra = 0
		local function forAuxiliar(i,limite)
			
			local posX = X
			local tamanhoAux = tamanho
			
			if i > 1 and grupoPalavra.partes[i-1].width == 0 then 
				posX = grupoPalavra.partes[i-1].x + grupoPalavra.partes[i-1].width
				if maiorX > 0 then
					posX = maiorX
					maiorX = 0
				end
			elseif i > 1 then 
				posX = grupoPalavra.partes[i-1].x + grupoPalavra.partes[i-1].width
				if maiorX > 0 then
					posX = maiorX
					maiorX = 0
				end
			end
			
			-- casos de filtros diferentes
			local tempY = Y
			local tipo = nil
			local df = 0
			local metricTemp = metricAntes
			local fonteTemp = nil
			local corTemp = nil
			print(posX,tamanhoAux,vetorPartes[i+1])
			for k=1,#vCodigos do
				
				if string.find(vetorPartes[i],vCodigos[k][1]) then
					if vCodigos[k][2] == "sobre" then
						tipo = "sobre"
						tamanhoAux = tamanhoAux/2
						metricTemp = graphics.getFontMetrics( fonte, tamanhoAux )
						tempY = Y - metricAntes.ascent + metricTemp.ascent/2
					elseif vCodigos[k][2] == "tam" then
						tipo = "tam"
						local Aux = string.match(vetorPartes[i],vCodigos[k][1])
						Aux = tonumber(string.match(Aux,"%d+"))
						if Aux then Aux = (Aux*1.5) + atributos.modificou end
						if Aux and Aux > 0 then
							tamanhoAux = Aux
						end
						metricTemp = graphics.getFontMetrics( fonte, tamanhoAux )
						df = ((-1*metricTemp.descent)-(-1*metricAntes.descent))
					elseif vCodigos[k][2] == "sub" then
						tipo = "sub"
						tamanhoAux = (tamanhoAux)/2
					elseif vCodigos[k][2] == "sobreSub" then
						local aux1,aux2 = string.match(vetorPartes[i],"([%w%p]+),([%w%p]+)")
						aux1 = string.gsub(aux1,vCodigos[k][1],"")
						tipo = "sobre"
						tamanhoAux = tamanhoAux/2
						metricTemp = graphics.getFontMetrics( fonte, tamanhoAux )
						tempY = Y - metricAntes.ascent + metricTemp.ascent/2
						grupoPalavra.partes[i] = display.newText(aux1,posX,tempY,fonte,tamanhoAux)
						grupoPalavra.partes[i].tipo = tipo
						grupoPalavra.partes[i].metric = metricTemp
						grupoPalavra.partes[i].df = df
						grupoPalavra.partes[i].anchorX = 0
						grupoPalavra.partes[i].anchorY = 1
						grupoPalavra:insert(grupoPalavra.partes[i])
						maiorX = grupoPalavra.partes[i].x + grupoPalavra.partes[i].width
						table.insert(vetorPartes,i,aux1)
						limite = limite+1
						i = i+1
						vetorPartes[i] = aux2
						tipo = "sub"
						tempY = Y
					elseif vCodigos[k][2] == "neg" then
						fonte = modificarNegritoItalico(fonte,"negrito")
					elseif vCodigos[k][2] == "ita" then
						fonte = modificarNegritoItalico(fonte,"italico")
					elseif vCodigos[k][2] == "neg ita" then
						fonte = modificarNegritoItalico(fonte,"negrito e italico")
					elseif vCodigos[k][2] == "fonte" then
						local Aux = string.match(vetorPartes[i],vCodigos[k][1])
						print("verificar fonte",Aux)
						Aux = string.match(Aux,"|f=([^%[]+)")
						print("verificar fonte",Aux)
						if string.find(Fontes,Aux) then
							fonteTemp = "Fontes/"..Aux
						end
					elseif vCodigos[k][2] == "cor" then
						local Aux = string.match(vetorPartes[i],vCodigos[k][1])
						Aux = string.match(Aux,"|c=([^%[]+)")
						local Aux1,Aux2,Aux3,Aux4 = string.match(Aux,"(%d*),*(%d*),*(%d*),*(%d*)")
						
						local red = tonumber(Aux1) or 0
						local green = tonumber(Aux2) or 0
						local blue = tonumber(Aux3) or 0
						local alpha = tonumber(Aux4) or 1
						corTemp = {red/255,green/255,blue/255,alpha}
						print("COREEES",Aux1,Aux2,Aux3,Aux4)
					end
				end
				vetorPartes[i] = string.gsub(vetorPartes[i],vCodigos[k][1],"")
			end
			if tempY> maiorY then maiorY = tempY end
			--vetorPartes[i] = string.gsub(vetorPartes[i],"[|<%[%]]+","")
			if i == 1 then
				vetorPartes[i] = " "..vetorPartes[i]
			end
			local fonteUsada = fonte
			local corUsada = nil
			if fonteTemp then fonteUsada = fonteTemp end
			if corTemp then corUsada = corTemp end
			if i == 1 and X == 0 then -- se for primeiro elemento de uma linha, recuar a palavra
				local espaco = display.newText(" ",posX,tempY,fonteUsada,tamanhoAux)
				grupoPalavra.xNegGrupo = espaco.width
				espaco:removeSelf()
				espaco = nil
			else 
				local espaco = display.newText(" ",posX,tempY,fonteUsada,tamanhoAux)
				grupoPalavra.espacoAtual = espaco.width
				espaco:removeSelf()
				espaco = nil
			end
			grupoPalavra.partes[i] = display.newText(vetorPartes[i],posX,tempY,fonteUsada,tamanhoAux)
			grupoPalavra.partes[i].tamanho = tamanhoAux
			grupoPalavra.partes[i].metric = graphics.getFontMetrics( fonteUsada, tamanhoAux )
			
			if i>1 then -- fazer ajuste de acordo com ultima letra
				local ultimaLetra = string.sub(vetorPartes[i-1],#vetorPartes[i-1],#vetorPartes[i-1])
				local ultimaLetraAtual = string.sub(vetorPartes[i],#vetorPartes[i],#vetorPartes[i])
	
				if (string.match(ultimaLetraAtual,"%u") or tamanhoAux > tamanho) and not string.match(ultimaLetra,"%u") then -- se a letra atual for upper case e a anterior não
					local espProv = grupoPalavra.espacoAtual/4
					grupoPalavra.partes[i].x = grupoPalavra.partes[i].x - espProv
					if tamanhoAux > tamanho then
						grupoPalavra.partes[i].y = grupoPalavra.partes[i].y + (grupoPalavra.partes[i].metric.ascent - grupoPalavra.partes[i-1].metric.ascent)/3
						if yExtra < (grupoPalavra.partes[i].metric.ascent - grupoPalavra.partes[i-1].metric.ascent)/3 then
							yExtra = (grupoPalavra.partes[i].metric.ascent - grupoPalavra.partes[i-1].metric.ascent)/3
						end
					end
				else
					local espProv = 1
					if string.match(ultimaLetra,"%d") then
						espProv = 1
					end
					if tamanhoAux > tamanho then
						
					end
					grupoPalavra.partes[i].x = grupoPalavra.partes[i].x - espProv
				end
				if string.match(ultimaLetraAtual,"%u") and string.match(ultimaLetra,"%u") then
					--grupoPalavra.partes[i].x = grupoPalavra.partes[i].x - 1
				end
			end
			if corUsada then
				print("pintei a parte: ",corUsada[1],corUsada[2],corUsada[3],corUsada[4])
				grupoPalavra.partes[i]:setFillColor(corUsada[1],corUsada[2],corUsada[3],corUsada[4])
				grupoPalavra.partes[i].corParte = corUsada
			end
			if string.gsub(vetorPartes[i],"%s+","") == "" then
				grupoPalavra.partes[i].width = 0
			end
			if maiorX > 0 then
				local auxX = grupoPalavra.partes[i].x + grupoPalavra.partes[i].width
				if auxX > maiorX then
					maiorX = auxX
				end
				auxX = nil
			end
			grupoPalavra.partes[i].tipo = tipo
			grupoPalavra.partes[i].metric = metricTemp
			grupoPalavra.partes[i].df = df
			grupoPalavra.partes[i].anchorX = 0
			grupoPalavra.partes[i].anchorY = 1
			grupoPalavra.yExtra = yExtra
			grupoPalavra:insert(grupoPalavra.partes[i])
			grupoPalavra.rodarLoopPartesFor(i+1,limite)
			
		end
		function grupoPalavra.rodarLoopPartesFor(i,limite)
			if i<=limite then
				forAuxiliar(i,limite)
			end
		end
		grupoPalavra.rodarLoopPartesFor(1,#vetorPartes)
		return grupoPalavra
	end
	local function verificarPalavra(texto,modificarDentroPalavra)
		local textoAux = string.match(texto,"%s*(.+)")
		for i=1,#vCodigos do
			if string.find(textoAux,vCodigos[i][1]) then
				modificarDentroPalavra = {}
				break
			end
		end
		
		if modificarDentroPalavra then
			local i = 0
			local tipo = "nada"
			while true do
				local iaux = i
				
				if tipo == "inicio" then
					i = string.find(textoAux, "%]", iaux+1)
					if i then
						tipo = "fim" 
					else
						i = string.find(textoAux, "|.+%[", iaux+1)
						if not i then tipo = "nada" end
					end
				else
					i = string.find(textoAux, "|.+%[", iaux+1)
					if i then 
						tipo = "inicio" 
					else
						i = string.find(textoAux, "%]", iaux+1)
						tipo = "nada"
					end
				end
				if i == nil then break end
				table.insert(modificarDentroPalavra, {i,tipo})
				print("indice = ",i,tipo)
			end
			if modificarDentroPalavra[1][1] > 1 then table.insert(modificarDentroPalavra,1, {1,"nada"}) end
			return modificarDentroPalavra
		end
	end
	local yLinha = atributos.Y
	local function forAuxiliar(i,limite)
		local metricDescent = -1*metricaBase.descent
		local fonte = atributos.fonte
		
		-- criar indices dentro das palavras se tiver --
		local modificarDentroPalavra = false
		modificarDentroPalavra = verificarPalavra(vetorPalavras.texto[i],modificarDentroPalavra)

		-- Aplicar negrito ou itálico --
		if string.find(vetorPalavras.tipo[i],"negrito") or string.find(vetorPalavras.tipo[i],"italico") then
			
			local fonteVerificarAux = string.sub(atributos.fonte,1,#atributos.fonte-4)
			local fonteVerificar = string.gsub(fonteVerificarAux,"Fontes/","")
			local extencao = string.sub(atributos.fonte,#atributos.fonte-3,#atributos.fonte)
			
			
			if string.find(vetorPalavras.tipo[i],"negrito") and string.find(vetorPalavras.tipo[i],"italico") then
				if string.find(Fontes,fonteVerificar.."z"..extencao) then
					fonte = fonteVerificarAux.."z"..extencao
				elseif string.find(Fontes,fonteVerificar.."bi"..extencao) then
					fonte = fonteVerificarAux.."bi"..extencao
				elseif string.find(Fontes,fonteVerificar.."b"..extencao) then
					fonte = fonteVerificarAux.."b"..extencao
				elseif string.find(Fontes,fonteVerificar.."bd"..extencao) then
					fonte = fonteVerificarAux.."bd"..extencao
				elseif string.find(Fontes,fonteVerificar.."i"..extencao) then
					fonte = fonteVerificarAux.."i"..extencao
				end
			elseif string.find(vetorPalavras.tipo[i],"negrito") then
				if string.find(Fontes,fonteVerificar.."b"..extencao) then 
					fonte = fonteVerificarAux.."b"..extencao
				elseif string.find(Fontes,fonteVerificar.."bd"..extencao) then 
					fonte = fonteVerificarAux.."bd"..extencao
				end
			elseif string.find(vetorPalavras.tipo[i],"italico") then 
				if string.find(Fontes,fonteVerificar.."i"..extencao) then 
					fonte = fonteVerificarAux.."i"..extencao
				end
			end
		end
		
		-- aplicar nova fonte se houver --
		if vetorPalavras.Fonte[i] then
			fonte = vetorPalavras.Fonte[i]
		end
		-------------------------------
		-- aplicar novo Tamanho Letra --
		local tamanho = atributos.tamanho
		
		
		if string.find(vetorPalavras.tipo[i],"tamanho") and vetorPalavras.Tam[i] then
			tamanho = vetorPalavras.Tam[i][1]
		end
		
		local function criarSublinhado(X,Y,Height,Width,cor)
		
			if not alturaSublinhado or alturaSublinhado <= 2 then
				alturaSublinhado = 2
			end
			local sublinhado = display.newRect(X + EsPaco,Y,Width - EsPaco,alturaSublinhado)
			sublinhado.anchorY = 0
			sublinhado.anchorX = 0
			sublinhado:setFillColor(cor[1],cor[2],cor[3])
			return sublinhado
		end
		
		LarguraX = atributos.largura - atributos.margem*2 - atributos.x
		if atributos.xNegativo < 0 then
			LarguraX = atributos.largura - atributos.margem*2 + atributos.xNegativo
		end
		local cores = {}
		EsPaco = EsPacoOrigin
		contadorPalavras[contadorGLinha].barraN = false
		if contadorPalavras[contadorGLinha] and #contadorPalavras[contadorGLinha] == 1 and contadorPalavras[contadorGLinha][1] then
			yLinha = contadorPalavras[contadorGLinha][1].y
			if contadorPalavras[contadorGLinha][1].yExtra then yLinha = contadorPalavras[contadorGLinha][1].y - contadorPalavras[contadorGLinha][1].yExtra end
		end
		
		if i==1 then
			EsPaco = 0
			atributos.Y = atributos.Y + AlTuRa
			if string.find(vetorPalavras.tipo[i],"link") then
				cores = {0,0,1}
			else
				cores = {atributos.cor[1],atributos.cor[2],atributos.cor[3]}
				if vetorPalavras.Cor[i] then
					cores = {vetorPalavras.Cor[i][1],vetorPalavras.Cor[i][2],vetorPalavras.Cor[i][3]}
				end
			end
			
			if string.find(vetorPalavras.texto[i],"\n") then
				local textoAux, count = string.gsub(vetorPalavras.texto[i], "\n", "")
				if modificarDentroPalavra then
					vetorPalavras[i] = modificarPalavra(modificarDentroPalavra,textoAux,0,atributos.Y + (AlTuRa*count),fonte,tamanho)
					vetorPalavras[i].x = vetorPalavras[i].x - vetorPalavras[i].xNegGrupo
				else
					vetorPalavras[i] = display.newText(textoAux,0,atributos.Y + (AlTuRa*count),fonte,tamanho)
				end
				vetorPalavras[i].anchorX,vetorPalavras[i].anchorY = 0,1
				
				--grupoTexto:insert(vetorPalavras[i])
				primeiroDaLinha = false
				
				devoAdicionarAltura = vetorPalavras[i].height
			else
				primeiroDaLinha = true
				guardarLinhas.numero = guardarLinhas.numero + 1
				if modificarDentroPalavra then
					vetorPalavras[i] = modificarPalavra(modificarDentroPalavra,vetorPalavras.texto[i],0,atributos.Y,fonte,tamanho)
					vetorPalavras[i].x = vetorPalavras[i].x - vetorPalavras[i].xNegGrupo
				else
					vetorPalavras[i] = display.newText(vetorPalavras.texto[i],0,atributos.Y,fonte,tamanho)
				end
				vetorPalavras[i].anchorX,vetorPalavras[i].anchorY = 0,1
				
				guardarLinhas[guardarLinhas.numero] = guardarLinhas[guardarLinhas.numero]..vetorPalavras.texto[i].." "
			end
			
			if string.find(vetorPalavras.tipo[i],"sublinhado") and string.gsub(vetorPalavras[i].text,"%s+","") ~= "" then
				vetorPalavras[i].sublinhado = criarSublinhado(vetorPalavras[i].x,atributos.Y,AlTuRa,vetorPalavras[i].width,cores)
				vetorPalavras[i].sublinhado.y = vetorPalavras[i].y - metricDescent
			end
			if vetorPalavras[i].yExtra then vetorPalavras[i].y = vetorPalavras[i].y+vetorPalavras[i].yExtra end
			--AlTuRa = vetorPalavras[i].height
			
			table.insert(contadorPalavras[contadorGLinha],vetorPalavras[i])
			
			--===============================--
			-- SE FOR SAIR DA TELA A PALAVRA --
			--===============================--
			
			-- se tiver imagem no caminho, diminuir tamanho da imagem --
			if imagemW ~= 0 and vetorPalavras[i].y <= atributos.Y + imagemH then
				LarguraX = LarguraX - imagemW
			elseif imagemW ~= 0 and atributos.alinhamento == "meio" then
				LarguraX = LarguraX - imagemW
			end
			--------------------------------------------------------------------
			local YYY = 0
			if vetorPalavras[i].width > LarguraX and #vetorPalavras.texto[i] > 4 then
				local quantoPassou = LarguraX - (vetorPalavras[i].x + vetorPalavras[i].width)
				local quantoDividir = (vetorPalavras[i].x + vetorPalavras[i].width)/quantoPassou
				local NmetadeCaracteres = math.abs(math.floor(#vetorPalavras.texto[i]/quantoDividir))
				if NmetadeCaracteres < 2 then
					NmetadeCaracteres = 2
				end
				local primeiraMetade = string.sub(vetorPalavras.texto[i],1,#vetorPalavras.texto[i]-NmetadeCaracteres)
				local segundaMetade = string.sub(vetorPalavras.texto[i],#vetorPalavras.texto[i]-NmetadeCaracteres+1,#vetorPalavras.texto[i])
				-- print("PrimeiraMetade = ",primeiraMetade)
				-- print("SegundaMetade = ",segundaMetade)
				vetorPalavras[i]:removeSelf()
				vetorPalavras[i] = nil
				table.insert(vetorPalavras.texto,i+1,segundaMetade)
				table.insert(vetorPalavras.tipo,i+1,vetorPalavras.tipo[i])
				table.insert(vetorPalavras.link,i+1,vetorPalavras.link[i])
				table.insert(vetorPalavras.Tam,i+1,vetorPalavras.Tam[i])
				table.insert(vetorPalavras.Rod,i+1,vetorPalavras.Rod[i])
				table.insert(vetorPalavras.Dic,i+1,vetorPalavras.Dic[i])
				table.insert(vetorPalavras.DicPalavrasCompostas,i+1,vetorPalavras.DicPalavrasCompostas[i])
				table.insert(vetorPalavras.Som,i+1,vetorPalavras.Som[i])
				table.insert(vetorPalavras.Imagem,i+1,vetorPalavras.Imagem[i])
				table.insert(vetorPalavras.Video,i+1,vetorPalavras.Video[i])
				table.insert(vetorPalavras.Animacao,i+1,vetorPalavras.Animacao[i])
				table.insert(vetorPalavras.Fonte,i+1,vetorPalavras.Fonte[i])
				table.insert(vetorPalavras.Cor,i+1,vetorPalavras.Cor[i])

				if modificarDentroPalavra then
					vetorPalavras[i] = modificarPalavra(modificarDentroPalavra,primeiraMetade,0,yLinha + atributos.espacamento,fonte,tamanho,yExtra)
					vetorPalavras[i].x = vetorPalavras[i].x - vetorPalavras[i].xNegGrupo
				else
					vetorPalavras[i] = display.newText(primeiraMetade,0,atributos.Y + atributos.espacamento,fonte,tamanho)
				end
				
				vetorPalavras[i].anchorX,vetorPalavras[i].anchorY = 0,1
				vetorPalavras[i].numeroLinha = contadorGLinha
				limite = limite+1
				primeiroDaLinha = true
				YYY = atributos.Y + atributos.espacamento
				
				if string.find(vetorPalavras.tipo[i],"sublinhado") and string.gsub(vetorPalavras[i].text,"%s+","") ~= "" then
					vetorPalavras[i].sublinhado = criarSublinhado(vetorPalavras[i].x+ EsPaco,YYY,AlTuRa,vetorPalavras[i].width - EsPaco,cores)
					vetorPalavras[i].sublinhado.y = vetorPalavras[i].y - metricDescent
					vetorPalavras[i].sublinhado.width = vetorPalavras[i].width
					vetorPalavras[i].sublinhado.x = vetorPalavras[i].x
				end
				contadorGLinha = contadorGLinha+1
				contadorPalavras[contadorGLinha] = {}
				
				table.insert(contadorPalavras[contadorGLinha],vetorPalavras[i])
			end
			
			
			if string.find(vetorPalavras.tipo[i],"link")  and not atributos.sombra then
				local function onClickLink(event)
					if type(atributos.embeded) == "string" and string.find(atributos.embeded,"sim") then
						local botaoFechar
						local telaPreta
						local webView
						local function fecharSite()
							webView:removeSelf()
							botaoFechar:removeSelf()
							telaPreta:removeSelf()
							
							local subPagina = atributos.tela.subPagina
							historicoLib.Criar_e_salvar_vetor_historico({
								tipoInteracao = "texto",
								link = atributos.url[vetorPalavras.link[i]],
								pagina_livro = atributos.tela.pagina,
								objeto_id = atributos.contTexto,
								acao = "fechar link do texto",
								subtipo = atributos.subtipo,
								subPagina = subPagina,
								tela = atributos.tela
							})
							
							if atributos.whenClosedURL then
								atributos.whenClosedURL()
							end
							return true
						end
						local function gerarEmbeded()
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
							webView:request( atributos.url[vetorPalavras.link[i]] )
							botaoFechar = display.newRoundedRect(W/2 + 270,H/2 + 720,50,50,5)
							botaoFechar.y = webView.y -webView.height/2 - botaoFechar.height/2
							botaoFechar:setFillColor(.7,.7,.7);botaoFechar.strokeWidth = 5; botaoFechar:setStrokeColor(0.4,0.4,0.4)
							botaoFechar.texto = display.newText("X",botaoFechar.x,botaoFechar.y,native.systemFont,40)
							botaoFechar:addEventListener("tap",fecharSite)
						end
						gerarEmbeded()
						
						local subPagina = atributos.tela.subPagina
						historicoLib.Criar_e_salvar_vetor_historico({
							tipoInteracao = "texto",
							link = atributos.url[vetorPalavras.link[i]],
							pagina_livro = atributos.tela.pagina,
							objeto_id = atributos.contTexto,
							acao = "abrir link do texto",
							subtipo = atributos.subtipo,
							subPagina = subPagina,
							tela = atributos.tela
						})
						
						if atributos.whenOpenedURL then
							atributos.whenOpenedURL()
						end
					else
						system.openURL(atributos.url[vetorPalavras.link[i]])
						
						local subPagina = atributos.tela.subPagina
						historicoLib.Criar_e_salvar_vetor_historico({
							tipoInteracao = "texto",
							link = atributos.url[vetorPalavras.link[i]],
							pagina_livro = atributos.tela.pagina,
							objeto_id = atributos.contTexto,
							acao = "abrir link externo do texto",
							subtipo = atributos.subtipo,
							subPagina = subPagina,
							tela = atributos.tela
						})
					end
				end
				vetorPalavras[i]:addEventListener('tap', onClickLink)
				
			end
			
		else
			if vetorPalavras.tipo[i] and string.find(vetorPalavras.tipo[i],"link") then
				cores = {0,0,1}
			else
				cores = {atributos.cor[1],atributos.cor[2],atributos.cor[3]}
				if vetorPalavras.Cor[i] then
					cores = {vetorPalavras.Cor[i][1],vetorPalavras.Cor[i][2],vetorPalavras.Cor[i][3]}
				end
			end
			if string.find(vetorPalavras.texto[i],"\n") then
				guardarLinhas.numero = guardarLinhas.numero+1
				local textoAux, count = string.gsub(vetorPalavras.texto[i], "\n", "")
				yLinha = yLinha + (AlTuRa*count) + atributos.espacamento
				if modificarDentroPalavra then
					vetorPalavras[i] = modificarPalavra(modificarDentroPalavra,textoAux,0,yLinha,fonte,tamanho)
					vetorPalavras[i].x = vetorPalavras[i].x - vetorPalavras[i].xNegGrupo
				else
					vetorPalavras[i] = display.newText(textoAux,0,yLinha,fonte,tamanho)
				end
				vetorPalavras[i].numeroLinha = contadorGLinha
				vetorPalavras[i].anchorX,vetorPalavras[i].anchorY = 0,1
				
				--AlTuRa = vetorPalavras[i].height
				contadorPalavras[contadorGLinha].barraN = true
				contadorGLinha = contadorGLinha+1
				contadorPalavras[contadorGLinha] = {}
				
				table.insert(contadorPalavras[contadorGLinha],vetorPalavras[i])
				primeiroDaLinha = false
				-- posicao esquerda com imagem --
			else 
				local foiSaltaLinha = false
				-- SE for \n modificar o X para zero e tirar espaço anterior || Senão colocar na frente com espaço --
				local yExtra = 0
				if vetorPalavras[i-1] and vetorPalavras[i-1].yExtra then
					yExtra = vetorPalavras[i-1].yExtra
				end
				local X = vetorPalavras[i-1].x + vetorPalavras[i-1].width
				local palavra = " "..vetorPalavras.texto[i]
				if string.find(vetorPalavras.texto[i-1],"\n") then
					X = 0
					palavra = vetorPalavras.texto[i]
				end
				if string.find(vetorPalavras.tipo[i-1] ,"sublinhado") then
					EsPaco = 0
				end
				if primeiroDaLinha == false then
					primeiroDaLinha = true
					--yLinha = contadorPalavras[contadorGLinha][1].y + atributos.espacamento
				end
				local YY = yLinha
				local Y = yLinha
				if modificarDentroPalavra then
					vetorPalavras[i] = modificarPalavra(modificarDentroPalavra,palavra,X,Y ,fonte,tamanho,yExtra)
					vetorPalavras[i].x = vetorPalavras[i].x - vetorPalavras[i].xNegGrupo
				else
					vetorPalavras[i] = display.newText(palavra,X,Y,fonte,tamanho)
				end
				if not vetorPalavras[i].yExtra then 
					--vetorPalavras[i].yExtra = yExtra
					--vetorPalavras[i].nAumentarSublinhado = true
				elseif vetorPalavras[i].yExtra and vetorPalavras[i-1].yExtra and vetorPalavras[i].yExtra > vetorPalavras[i-1].yExtra then
					--vetorPalavras[i].yExtra = vetorPalavras[i].yExtra + (vetorPalavras[i].yExtra - vetorPalavras[i-1].yExtra)
				end
				
				vetorPalavras[i].numeroLinha = contadorGLinha
				vetorPalavras[i].anchorX,vetorPalavras[i].anchorY = 0,1
				
				-- atualizar altura da linha 
				if vetorPalavras[i].height > vetorPalavras[i-1].height then
					--AlTuRa = vetorPalavras[i].height
				end
				------------------------------
				if string.find(vetorPalavras.tipo[i],"sublinhado") and string.gsub(vetorPalavras[i].text,"%s+","") ~= "" then

					vetorPalavras[i].sublinhado = criarSublinhado(vetorPalavras[i].x,Y,AlTuRa,vetorPalavras[i].width,cores)
					vetorPalavras[i].sublinhado.y = vetorPalavras[i].y - metricDescent
					if vetorPalavras[i] and vetorPalavras[i].yExtra and not vetorPalavras[i].nAumentarSublinhado then
						--vetorPalavras[i].sublinhado.y = vetorPalavras[i].sublinhado.y - vetorPalavras[i].yExtra
					end
				end
				if vetorPalavras[i].yExtra then vetorPalavras[i].y = vetorPalavras[i].y+vetorPalavras[i].yExtra end
				
				table.insert(contadorPalavras[contadorGLinha],vetorPalavras[i])
				-------------------------------------------------------
				--===============================--
				-- SE FOR SAIR DA TELA A PALAVRA --
				--===============================--
				
				-- se tiver imagem no caminho, diminuir tamanho da imagem --
				if imagemW ~= 0 and vetorPalavras[i].y <= atributos.Y + imagemH then
					LarguraX = LarguraX - imagemW
				elseif imagemW ~= 0 and atributos.alinhamento == "meio" then
					LarguraX = LarguraX - imagemW
				end
				--------------------------------------------------------------------

				if vetorPalavras[i].x + vetorPalavras[i].width > LarguraX and not string.find(vetorPalavras[i-1].text,"\n") and foiSaltaLinha == false then
					if vetorPalavras[i].sublinhado then
						vetorPalavras[i].sublinhado:removeSelf()
						vetorPalavras[i].sublinhado = nil
					end
					local X = 0
					
					--local Y = contadorPalavras[contadorGLinha][1].y + AlTuRa + atributos.espacamento
					local Y = yLinha + AlTuRa + atributos.espacamento
					local yExtra = 0
					if vetorPalavras[i-1].yExtra then yExtra = vetorPalavras[i-1].yExtra end
					vetorPalavras[i]:removeSelf()
					vetorPalavras[i] = nil
					table.remove(contadorPalavras[contadorGLinha],#contadorPalavras[contadorGLinha])

					if string.find(vetorPalavras.tipo[i-1] ,"sublinhado") then
						EsPaco = 0
					end
					if modificarDentroPalavra then
						vetorPalavras[i] = modificarPalavra(modificarDentroPalavra,vetorPalavras.texto[i],X,Y,fonte,tamanho)
						vetorPalavras[i].x = vetorPalavras[i].x - vetorPalavras[i].xNegGrupo
					else
						vetorPalavras[i] = display.newText(vetorPalavras.texto[i],X,Y,fonte,tamanho)
					end
					vetorPalavras[i].anchorX,vetorPalavras[i].anchorY = 0,1
					vetorPalavras[i].numeroLinha = contadorGLinha
					
					primeiroDaLinha = false
					--AlTuRa = vetorPalavras[i].height
					local YYY = Y
					
					if vetorPalavras[i].width > LarguraX and #vetorPalavras.texto[i] > 4 then
						local quantoPassou = LarguraX - (vetorPalavras[i].x + vetorPalavras[i].width)
						local quantoDividir = (vetorPalavras[i].x + vetorPalavras[i].width)/quantoPassou
						local NmetadeCaracteres = math.abs(math.floor(#vetorPalavras.texto[i]/quantoDividir))
						if NmetadeCaracteres < 2 then
							NmetadeCaracteres = 2
						end
						local primeiraMetade = string.sub(vetorPalavras.texto[i],1,#vetorPalavras.texto[i]-NmetadeCaracteres)
						local segundaMetade = string.sub(vetorPalavras.texto[i],#vetorPalavras.texto[i]-NmetadeCaracteres+1,#vetorPalavras.texto[i])
						-- print("PrimeiraMetade = ",primeiraMetade)
						-- print("SegundaMetade = ",segundaMetade)
						vetorPalavras[i]:removeSelf()
						vetorPalavras[i] = nil
						table.insert(vetorPalavras.texto,i+1,segundaMetade)
						table.insert(vetorPalavras.tipo,i+1,vetorPalavras.tipo[i])
						table.insert(vetorPalavras.link,i+1,vetorPalavras.link[i])
						table.insert(vetorPalavras.Tam,i+1,vetorPalavras.Tam[i])
						table.insert(vetorPalavras.Rod,i+1,vetorPalavras.Rod[i])
						table.insert(vetorPalavras.Dic,i+1,vetorPalavras.Dic[i])
						table.insert(vetorPalavras.DicPalavrasCompostas,i+1,vetorPalavras.DicPalavrasCompostas[i])
						table.insert(vetorPalavras.Som,i+1,vetorPalavras.Som[i])
						table.insert(vetorPalavras.Imagem,i+1,vetorPalavras.Imagem[i])
						table.insert(vetorPalavras.Video,i+1,vetorPalavras.Video[i])
						table.insert(vetorPalavras.Animacao,i+1,vetorPalavras.Animacao[i])
						table.insert(vetorPalavras.Fonte,i+1,vetorPalavras.Fonte[i])
						table.insert(vetorPalavras.Cor,i+1,vetorPalavras.Cor[i])
						if modificarDentroPalavra then
							vetorPalavras[i] = modificarPalavra(modificarDentroPalavra,primeiraMetade,X,Y,fonte,tamanho)
							vetorPalavras[i].x = vetorPalavras[i].x - vetorPalavras[i].xNegGrupo
						else
							vetorPalavras[i] = display.newText(primeiraMetade,X,Y,fonte,tamanho)
						end
						vetorPalavras[i].anchorX,vetorPalavras[i].anchorY = 0,1
						vetorPalavras[i].numeroLinha = contadorGLinha
						limite = limite+1
						primeiroDaLinha = true
						YYY = Y
					end
					
					if string.find(vetorPalavras.tipo[i],"sublinhado") and string.gsub(vetorPalavras[i].text,"%s+","") ~= ""  then
						vetorPalavras[i].sublinhado = criarSublinhado(vetorPalavras[i].x+ EsPaco,YYY,AlTuRa,vetorPalavras[i].width - EsPaco,cores)
						vetorPalavras[i].sublinhado.y = vetorPalavras[i].y - metricDescent
						vetorPalavras[i].sublinhado.width = vetorPalavras[i].width
						vetorPalavras[i].sublinhado.x = vetorPalavras[i].x
					end
					if vetorPalavras[i].yExtra then vetorPalavras[i].y = vetorPalavras[i].y+vetorPalavras[i].yExtra end
					contadorGLinha = contadorGLinha+1
					contadorPalavras[contadorGLinha] = {}
					
					table.insert(contadorPalavras[contadorGLinha],vetorPalavras[i])
				end

			end
			
			
			
			if string.find(vetorPalavras.tipo[i],"link") and not atributos.sombra then
				local function onClickLink(event)
					if not event.target.abriuLink then
						vetorPalavras[i].abriuLink = true
						vetorPalavras[i].timer = timer.performWithDelay(2000,
							function() 
								if event.target then
									if event.target.abriuLink then
										event.target.abriuLink = false
									end
								end
							end
						,1)
						if type(atributos.embeded) == "string" and string.find(atributos.embeded,"sim") then
							local botaoFechar
							local telaPreta
							local webView
							local function fecharSite()
								webView:removeSelf()
								botaoFechar:removeSelf()
								telaPreta:removeSelf()
								
								local subPagina = atributos.tela.subPagina
								historicoLib.Criar_e_salvar_vetor_historico({
									tipoInteracao = "texto",
									link = atributos.url[vetorPalavras.link[i]],
									pagina_livro = atributos.tela.pagina,
									objeto_id = atributos.contTexto,
									acao = "fechar link do texto",
									subtipo = atributos.subtipo,
									subPagina = subPagina,
									tela = atributos.tela
								})
								
								if atributos.whenClosedURL then
									atributos.whenClosedURL()
								end
								return true
							end
							local function gerarEmbeded()
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
								webView:request( atributos.url[vetorPalavras.link[i]] )
								botaoFechar = display.newRoundedRect(W/2 + 270,H/2 + 720,50,50,5)
								botaoFechar.y = webView.y -webView.height/2 - botaoFechar.height/2
								botaoFechar:setFillColor(.7,.7,.7);botaoFechar.strokeWidth = 5; botaoFechar:setStrokeColor(0.4,0.4,0.4)
								botaoFechar.texto = display.newText("X",botaoFechar.x,botaoFechar.y,native.systemFont,40)
								botaoFechar:addEventListener("tap",fecharSite)
							end
							gerarEmbeded()
							
							local subPagina = atributos.tela.subPagina
							historicoLib.Criar_e_salvar_vetor_historico({
								tipoInteracao = "texto",
								link = atributos.url[vetorPalavras.link[i]],
								pagina_livro = atributos.tela.pagina,
								objeto_id = atributos.contTexto,
								acao = "abrir link do texto",
								subtipo = atributos.subtipo,
								subPagina = subPagina,
								tela = atributos.tela
							})
							
							if atributos.whenOpenedURL then
								atributos.whenOpenedURL()
							end
						else
							system.openURL(atributos.url[vetorPalavras.link[i]])
							
							local subPagina = atributos.tela.subPagina
							historicoLib.Criar_e_salvar_vetor_historico({
								tipoInteracao = "texto",
								link = atributos.url[vetorPalavras.link[i]],
								pagina_livro = atributos.tela.pagina,
								objeto_id = atributos.contTexto,
								acao = "abrir link externo do texto",
								subtipo = atributos.subtipo,
								subPagina = subPagina,
								tela = atributos.tela
							})
						end
					end
				end
				vetorPalavras[i].abriuLink = false
				vetorPalavras[i]:addEventListener('tap', onClickLink)
				
			end
			
		end
		vetorPalavras[i].contexto = frases[contadorFrases]
		table.insert(grupoTexto.vetorContextos,{string.match(vetorPalavras[i].text,"%s*(.+)"),vetorPalavras[i].contexto})
		-- criando Retangulos ----
		if string.gsub(vetorPalavras[i].text,"%s+","") ~= "" and not atributos.sombra then
			
			vetorPalavras[i].rect = display.newRect(vetorPalavras[i].x,vetorPalavras[i].y,vetorPalavras[i].width,vetorPalavras[i].height)
			vetorPalavras[i].rect.alpha = 0
			-- verificar se veio do localizar
			if atributos.tela and atributos.tela.localizar and conversor.stringLowerAcento(string.gsub(vetorPalavras[i].text,"[ *%.,!%?:;]","")) == conversor.stringLowerAcento(atributos.tela.localizar) then
				vetorPalavras[i].rect.alpha = .3
				vetorPalavras[i].rect:setFillColor(46/255,171/255,200/255)
			else
				vetorPalavras[i].rect:setFillColor(46/255,171/255,200/255,0)
			end
			vetorPalavras[i].rect.anchorX = vetorPalavras[i].anchorX
			vetorPalavras[i].rect.anchorY = vetorPalavras[i].anchorY
			vetorPalavras[i].rect.strokeWidth = 2
			vetorPalavras[i].rect:setStrokeColor(cores[1],cores[2],cores[3],.5)
			
			local escolhas = {}
			escolhas[1] = ""
			local tamanhoRetangulo = tamanho/3
			local posicaoCorX = vetorPalavras[i].rect.x + vetorPalavras[i].rect.width - tamanhoRetangulo/2
			table.insert(escolhas,"aumentar letra" )
			table.insert(escolhas,"diminuir letra" )
			if string.find(vetorPalavras.tipo[i],"audio") then
				table.insert(escolhas,"tocar som" )
				vetorPalavras[i].rect.alpha = 0.5
				--[[vetorPalavras[i].iconeAudio = display.newRect(vetorPalavras[i].rect.x + vetorPalavras[i].rect.width,vetorPalavras[i].rect.y - vetorPalavras[i].rect.height,9,9)
				vetorPalavras[i].iconeAudio:setFillColor(1,0,0) -- red
				vetorPalavras[i].iconeAudio.anchorX = 1
				vetorPalavras[i].iconeAudio.anchorY = 0
				vetorPalavras[i].iconeAudio.strokeWidth = 1
				vetorPalavras[i].iconeAudio:setStrokeColor(0,0,0)]]
			end
			if string.find(vetorPalavras.tipo[i],"imagem") then
				table.insert(escolhas,"abrir imagem" )
				vetorPalavras[i].rect.alpha = 0.5
				--[[vetorPalavras[i].iconeImagem = display.newRect(vetorPalavras[i].rect.x + vetorPalavras[i].rect.width-(10*1),vetorPalavras[i].rect.y - vetorPalavras[i].rect.height,9,9)
				vetorPalavras[i].iconeImagem:setFillColor(0,0,1) -- blue
				vetorPalavras[i].iconeImagem.anchorX = 1
				vetorPalavras[i].iconeImagem.anchorY = 0
				vetorPalavras[i].iconeImagem.strokeWidth = 1
				vetorPalavras[i].iconeImagem:setStrokeColor(0,0,0)]]
				
			end
			if string.find(vetorPalavras.tipo[i],"video") then
				table.insert(escolhas,"executar video" )
				vetorPalavras[i].rect.alpha = 0.5
				--[[vetorPalavras[i].iconeVideo = display.newRect(vetorPalavras[i].rect.x + vetorPalavras[i].rect.width-(10*2),vetorPalavras[i].rect.y - vetorPalavras[i].rect.height,9,9)
				vetorPalavras[i].iconeVideo:setFillColor(.5,.5,.5) -- gray
				vetorPalavras[i].iconeVideo.anchorX = 1
				vetorPalavras[i].iconeVideo.anchorY = 0
				vetorPalavras[i].iconeVideo.strokeWidth = 1
				vetorPalavras[i].iconeVideo:setStrokeColor(0,0,0)]]
			end
			if string.find(vetorPalavras.tipo[i],"animacao") then
				table.insert(escolhas,"executar animacao" )
				vetorPalavras[i].rect.alpha = 0.5
				--[[vetorPalavras[i].iconeAnimacao = display.newRect(vetorPalavras[i].rect.x + vetorPalavras[i].rect.width-(10*3),vetorPalavras[i].rect.y - vetorPalavras[i].rect.height,9,9)
				vetorPalavras[i].iconeAnimacao:setFillColor(0,1,0) -- green
				vetorPalavras[i].iconeAnimacao.anchorX = 1
				vetorPalavras[i].iconeAnimacao.anchorY = 0
				vetorPalavras[i].iconeAnimacao.strokeWidth = 1
				vetorPalavras[i].iconeAnimacao:setStrokeColor(0,0,0)]]
			end
			-- DICIONARIO CONTORNO
			if string.find(vetorPalavras.tipo[i],"dicionario") then
				--vetorPalavras[i].rect.alpha = 0
				vetorPalavras[i].dicionario = vetorPalavras.Dic[i]
				local palavraAtual = string.gsub(vetorPalavras[i].text,"%s","")
				
				table.insert(escolhas,"dicionario" )
				
			end
			local verificarEmail = string.match(vetorPalavras[i].text,".+@%a+%.[%a%.]+")
			if verificarEmail then
				vetorPalavras[i].email = verificarEmail
				table.insert(escolhas,"enviar e-mail" )
			end
			
			local function TelaProtetiva()
				local telaPreta = display.newRect(0,0,W,H)
				telaPreta.anchorX = 0.5; telaPreta.anchorY = 0.5
				telaPreta.anchorX = 0.5; telaPreta.anchorY = 0.5
				telaPreta.x = W/2; telaPreta.y = H/2
				telaPreta.x = W/2; telaPreta.y = H/2
				telaPreta:setFillColor(1,1,1)
				telaPreta.alpha=0.4
				telaPreta:addEventListener("tap",function() return true end)
				telaPreta:addEventListener("touch",function() return true end)
	
				return telaPreta
			end
			local function abrirMenuRapido(event)
				audio.stop()
				local Texto = event.target
				if Texto.partes then
					for j=1,#vetorPalavras[i].partes do
						if not Texto.partes[j].corParte then
							Texto.partes[j]:setFillColor(192/255,0,0)
						end
					end
				else
					Texto:setFillColor(192/255,0,0)
				end
				Texto.telaPreta = TelaProtetiva()
				
				local function aoFecharMenuRapido()
					if Texto.MenuRapido then
						Texto.MenuRapido:removeSelf()
						Texto.MenuRapido = nil
					end
					if Texto.telaPreta then
						Texto.telaPreta:removeSelf()
						Texto.telaPreta = nil
					end
					if Texto.partes then
						for j=1,#vetorPalavras[i].partes do
							if not Texto.partes[j].corParte then
								Texto.partes[j]:setFillColor(cores[1],cores[2],cores[3])
							end
						end
					else
						Texto:setFillColor(cores[1],cores[2],cores[3])
					end
					local verificarEmail = string.match(Texto.text,".+@%a+%.[%a%.]+")
					if verificarEmail then Texto:setFillColor(0,.5,0) end
				end
				Texto.telaPreta:addEventListener("tap",function()aoFecharMenuRapido()end)
				
				local function rodarOpcao(e)
					if e.target.params.tipo == "aumentar letra" then
						atributos.mudarTamanhoFonte({acao = "aumentar",event = event,contador = atributos.contTexto,pH = pegarNumeroPaginaRomanosHistorico(historicoTexto),tela = atributos.tela})
					elseif e.target.params.tipo == "diminuir letra" then
						atributos.mudarTamanhoFonte({acao = "diminuir",event = event,contador = atributos.contTexto,pH = pegarNumeroPaginaRomanosHistorico(historicoTexto),tela = atributos.tela})
					elseif e.target.params.tipo == "tocar som" then
						--print(atributos.endereco.."/"..vetorPalavras.Som[i]);
						local som = audio.loadSound(atributos.endereco.."/"..vetorPalavras.Som[i]);
						if som then 
							audio.play(som);
							local subPagina = atributos.tela.subPagina
							historicoLib.Criar_e_salvar_vetor_historico({
								tipoInteracao = "texto",
								audio = vetorPalavras.Som[i],
								pagina_livro = atributos.tela.pagina,
								palavra = vetorPalavras[i].text,
								numero_palavra = i,
								objeto_id = atributos.contTexto,
								acao = "executar som do texto",
								subtipo = atributos.subtipo,
								subPagina = subPagina,
								tela = atributos.tela
							})
						end
					elseif e.target.params.tipo == "dicionario" then
						if vetorPalavras.Dic[i] then
							local elemTela = require "elementosDaTela";
							local manipularTela = require("manipularTela")
							local widget = require("widget")
							
							
							local tamanho_fonte = " tamanho = 20\n"
							local cor_fonte = " cor = 0,0,0\n"
							local alinhamento = " alinhamento = justificado\n"
							local fonteAriblk = " fonte = ariblk.ttf\n"
							local recuo = " x = 10\n"
							
							local scriptPagina = auxFuncs.lerTextoRes("Dicionario Palavras/"..vetorPalavras.Dic[i])
							
							local telaProtetiva = TelaProtetiva()
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
										arquivo = e.target.params.dicionario,
										scriptDaPagina = scriptPagina,
										vetorRefazer = atribut.tela,
										temHistorico = atributos.temHistorico
									},
									refazerTela
								)
								Tela.y = -200
								--Tela.y = Tela.height/10 - 200
								--Tela.x = Tela.width/20
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
									arquivo = e.target.params.dicionario,
									scriptDaPagina = scriptPagina,
									temHistorico = atributos.temHistorico
								},
								refazerTela
							)
							

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
							
							function fundo.fecharTela()
								Tela.removerTela()
							
								Tela:removeSelf()
								
								telaProtetiva:removeSelf()
								fundo.fechar:removeSelf()
								fundo.fechar = nil
								fundo.container:removeSelf()
								fundo.container = nil
								
								Tela = nil
								fundo:removeSelf()
								fundo = nil
								telaProtetiva = nil
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
							fundo.fechar.anchorX=1
							fundo.fechar.anchorY=0
							fundo.fechar.x = W - 50 + fundo.fechar.width/2
							fundo.fechar.y = 100
						end
					elseif  e.target.params.tipo == "abrir imagem" then
						local Imagem = display.newGroup()
						local arquivo = atributos.endereco.."/"..vetorPalavras.Imagem[i]
						Imagem.telaPreta = display.newRect(0,0,W*2,H*2)
						Imagem.telaPreta.anchorX = 0.5; Imagem.telaPreta.anchorY = 0.5
						Imagem.telaPreta.x = W/2; Imagem.telaPreta.y = H/2
						Imagem.telaPreta:setFillColor(1,1,1)
						Imagem.telaPreta.alpha=1
						Imagem.img = display.newImage(arquivo,W/2,H/2)
						if not Imagem.img then Imagem.img = display.newImage("Paginas/Outros Arquivos/imagemErro.jpg",W/2,H/2) end
						Imagem.img.anchorX = .5; Imagem.img.anchorY= .5
						Imagem.img.x=W/2;Imagem.img.y=H/2
						local auxiliarW = Imagem.img.width
						local auxiliarH = Imagem.img.height
						local aux2 = (W-20)/Imagem.img.width
						Imagem.img.width = aux2*Imagem.img.width
						Imagem.img.height = aux2*Imagem.img.height
						Imagem:insert(Imagem.telaPreta)
						Imagem:insert(Imagem.img)
						Imagem:addEventListener("tap",function() if Imagem then Imagem:removeSelf(); Imagem = nil end return true end)
						Imagem.img.prevX=Imagem.img.x
						Imagem.img.prevY=Imagem.img.y
						Imagem.img.anchorChildren = true
						Imagem:addEventListener("touch",auxFuncs.zoomArquivo)
						
						local subPagina = atributos.tela.subPagina
						historicoLib.Criar_e_salvar_vetor_historico({
							tipoInteracao = "texto",
							subtipo = atributos.subtipo,
							pagina_livro = atributos.tela.pagina,
							palavra = e.target.text,
							objeto_id = atributos.contTexto,
							acao = "abrir imagem",
							arquivo = vetorPalavras.Imagem[i],
							subPagina = subPagina,
							tela = atributos.tela
						})
					elseif  e.target.params.tipo == "executar video" then
						local sistema = auxFuncs.checarSistema()
						local arquivo = atributos.endereco.."/"..vetorPalavras.Video[i]
						if e.target.grupoVideo then e.target.grupoVideo:removeSelf(); e.target.grupoVideo = nil end
						e.target.grupoVideo = display.newGroup()
						grupoTexto:insert(e.target.grupoVideo)
						if sistema == "PC" then
							grupoTexto:insert(e.target.grupoVideo)
							if e.target.webView then e.target.webView:removeSelf(); e.target.webView = nil end
							e.target.webView = native.newWebView( W/2,H/2,480, 320 )
							e.target.webView.anchorY = 0
							e.target.webView.isVisible = false
							e.target.grupoVideo:insert(e.target.webView)
							e.target.webView:request( arquivo,system.ResourceDirectory )	
						else
							if e.target.video then e.target.video:removeSelf(); e.target.video = nil end
							e.target.video = media.playVideo( arquivo,system.ResourceDirectory,true,oncomplete)
							if e.target.video then
								grupoVideo:insert(e.target.video)
							end
						end
						
						local subPagina = atributos.tela.subPagina
						historicoLib.Criar_e_salvar_vetor_historico({
							tipoInteracao = "texto",
							subtipo = atributos.subtipo,
							pagina_livro = atributos.tela.pagina,
							palavra = e.target.text,
							objeto_id = atributos.contTexto,
							acao = "executar video",
							arquivo = vetorPalavras.Video[i],
							subPagina = subPagina,
							tela = atributos.tela
						})
					elseif  e.target.params.tipo == "executar animacao" then
						local arquivo = atributos.endereco.."/"..vetorPalavras.Animacao[i]
						
						
						
						local subPagina = atributos.tela.subPagina
						historicoLib.Criar_e_salvar_vetor_historico({
							tipoInteracao = "texto",
							subtipo = atributos.subtipo,
							pagina_livro = atributos.tela.pagina,
							palavra = e.target.text,
							objeto_id = atributos.contTexto,
							acao = "executar animacao",
							arquivo = vetorPalavras.Animacao[i],
							subPagina = subPagina,
							tela = atributos.tela
						})
					elseif  e.target.params.tipo == "enviar e-mail" then
						local options =
						{
						   to = { e.target.params.email},
						   subject = "",
						   body = ""
						}
						native.showPopup( "mail", options )
					elseif e.target.params.tipo == "" then
						
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
						params = {tipo = escolhas[i],dicionario = Texto.dicionario,contexto = Texto.contexto,palavra = Texto.text,email = Texto.email},
						cor = {37/225,185/225,219/225},
					})
					if escolhas[i] == "aumentar letra" then
						escolhasGerais[#escolhasGerais].iconeEsq =  {imagem = "botaoAumentar.png",alt = 70,larg = 70}
					elseif escolhas[i] == "diminuir letra" then
						escolhasGerais[#escolhasGerais].iconeEsq =  {imagem = "botaoDiminuir.png",alt = 70,larg = 70}
					elseif escolhas[i] == "tocar som" then
						escolhasGerais[#escolhasGerais].iconeEsq =  {imagem = "menuRapidoAudio.png",alt = 70,larg = 70}
						elseif escolhas[i] == "abrir imagem" then
						escolhasGerais[#escolhasGerais].iconeEsq =  {imagem = "menuRapidoImagem.png",alt = 70,larg = 70}
						elseif escolhas[i] == "executar video" then
						escolhasGerais[#escolhasGerais].iconeEsq =  {imagem = "menuRapidoVideo.png",alt = 70,larg = 70}
						elseif escolhas[i] == "executar animacao" then
						escolhasGerais[#escolhasGerais].iconeEsq =  {imagem = "menuRapidoAnimacao.png",alt = 70,larg = 70}
					elseif escolhas[i] == "dicionario" then
						escolhasGerais[#escolhasGerais].iconeEsq =  {imagem = "menuRapidoDic.png",alt = 70,larg = 70}
					elseif escolhas[i] == "enviar e-mail" then
						escolhasGerais[#escolhasGerais].iconeEsq =  {imagem = "sendMail.png",alt = 70,larg = 70}
					elseif escolhas[i] == "" then
						escolhasGerais[#escolhasGerais].iconeDir =  {imagem = "closeMenuButton2.png",alt = 50,larg = 50}
					else
						escolhasGerais[#escolhasGerais].fonte = "Fontes/paolaAccent.ttf"
					end
				end
				
				Texto.MenuRapido = MenuRapido.New(
				{
					escolhas = escolhasGerais,
					rowWidthGeneric = 280,
					rowHeightGeneric = 70,
					tamanhoTexto = 50,
					closeListener = aoFecharMenuRapido,
					telaProtetiva = "nao"
					}
				)
			
				--Texto.MenuRapido.x = event.x
				--Texto.MenuRapido.y = event.y - GRUPOGERAL.y
				Texto.MenuRapido.x = event.x
				Texto.MenuRapido.y = event.y
				Texto.MenuRapido.anchorY=1
				if Texto.MenuRapido.x + Texto.MenuRapido.width > W and system.orientation == "portrait" then
					Texto.MenuRapido.x = event.x - Texto.MenuRapido.width
				end
				--if Texto.MenuRapido.y + Texto.MenuRapido.height > H and system.orientation == "portrait" then
				--	Texto.MenuRapido.y = event.y - Texto.MenuRapido.height - GRUPOGERAL.y
				--end
				local oritantacaoAtual = system.orientation
				if oritantacaoAtual == "landscapeLeft" then
					Texto.MenuRapido.y = event.y
					Texto.MenuRapido.x = event.x
					Texto.MenuRapido.rotation = -90
				elseif oritantacaoAtual == "landscapeRight" then
					Texto.MenuRapido.y = event.y
					Texto.MenuRapido.x = event.x
					Texto.MenuRapido.rotation = 90
				end
				Texto.timerOrientacao = timer.performWithDelay(100,function()
					if Texto.MenuRapido and Texto.timerOrientacao and oritantacaoAtual ~= system.orientation then
						aoFecharMenuRapido()
						timer.cancel(Texto.timerOrientacao)
						Texto.timerOrientacao = nil
					elseif not Texto.MenuRapido and Texto.timerOrientacao then
						timer.cancel(Texto.timerOrientacao)
						Texto.timerOrientacao = nil
					end
				end,-1)
			
				return true
			end
			
			if not string.find(vetorPalavras.tipo[i],"link") and atributos.EhIndice == false --[[and not atributos.card]] then
				vetorPalavras[i].isHitTestable = true
				
				vetorPalavras[i]:addEventListener("tap",abrirMenuRapido)
			end
			
		end
		--------------------------
		if vetorPalavras[i].partes then
			for j=1,#vetorPalavras[i].partes do
				if not vetorPalavras[i].partes[j].corParte then
					vetorPalavras[i].partes[j]:setFillColor(cores[1],cores[2],cores[3])
				end
			end
		else
			vetorPalavras[i]:setFillColor(cores[1],cores[2],cores[3])
		end
		local verificarEmail = string.match(vetorPalavras[i].text,".+@%a+%.[%a%.]+")
		if verificarEmail then vetorPalavras[i]:setFillColor(0,.5,0) end
		
		if atributos.indiceRemissivo then
			if vetorPalavras[i].partes then
				for j=1,#vetorPalavras[i].partes do
					vetorPalavras[i].partes[j]:addEventListener("tap",atributos.funcaoExterna)
				end
			else
				vetorPalavras[i]:addEventListener("tap",atributos.funcaoExterna)
			end
		end
		
		local lastChar = string.sub(vetorPalavras[i].text,#vetorPalavras[i].text,#vetorPalavras[i].text)
		if lastChar == "." or lastChar == "!" or lastChar == "?" or string.find(vetorPalavras[i].text,"%.[^%w|<>%[%]]") then
			contadorFrases = contadorFrases + 1
		end
		rodarLoopFor(i+1,limite)
	end
	
	
	--============================================================================================--
	--==== FIM -- ORGANIZOU PALAVRAS EM LINHAS ===================================================--
	--============================================================================================--
	
	function rodarLoopFor(i,limite)
		if i<=limite then
			forAuxiliar(i,limite)
		end
	end
	if guardarLinhas.numero < 2 and devoAdicionarAltura == 0 and contadorPalavras[1][1] then
		--devoAdicionarAltura = contadorPalavras[1][1].height
	end
	rodarLoopFor(1,#vetorPalavras.texto)
	grupoTexto.alturaExtra = devoAdicionarAltura
	--============================================================================================--
	--==== ARRUMAR LINHAS POR ALINHAMENTO ========================================================--
	-- arrumar as linhas de acordo com o alinhamento e a posição da imagem --=====================--
	--============================================================================================--
	if atributos.alinhamento then
		local grupoLinhas = {}
		if atributos.alinhamento ~= "justificado" then
			for i=1,#contadorPalavras do
				grupoLinhas[i] = display.newGroup()
				local textoAux = ""
				for k=1,#contadorPalavras[i] do
					if contadorPalavras[i][k].sublinhado then
						grupoLinhas[i]:insert(contadorPalavras[i][k].sublinhado)
					end
					if contadorPalavras[i][k].rect then
						grupoLinhas[i]:insert(contadorPalavras[i][k].rect)
						if contadorPalavras[i][k].iconeAudio then
							grupoLinhas[i]:insert(contadorPalavras[i][k].iconeAudio)
						end
						if contadorPalavras[i][k].iconeImagem then
							grupoLinhas[i]:insert(contadorPalavras[i][k].iconeImagem)
						end
						if contadorPalavras[i][k].iconeAnimacao then
							grupoLinhas[i]:insert(contadorPalavras[i][k].iconeAnimacao)
						end
						if contadorPalavras[i][k].iconeVideo then
							grupoLinhas[i]:insert(contadorPalavras[i][k].iconeVideo)
						end
					end
					grupoLinhas[i]:insert(contadorPalavras[i][k])
					-- guardando valor Y para depois alinhar corretamente com a imagem --
					grupoLinhas[i].yy = contadorPalavras[i][k].y
					---------------------------------------------------------------------
				end
			end
			for i=1,#grupoLinhas do
				grupoTexto:insert(grupoLinhas[i])
			end
		else
		-----------------------------------------------------------------------------------------
		-- ALINHAMENTO JUSTIFICADO --------------------------------------------------------------
			local k = 1
			while k<#contadorPalavras do
				kk = 1
				while kk<#contadorPalavras[k] do
					if string.gsub(contadorPalavras[k][kk].text,"%s+","") == "" then
						table.remove(contadorPalavras[k],kk)
					else
						kk = kk+1
					end
				end
				k = k+1
			end
			-- arrumando as linhas --
			for i=1,#contadorPalavras do
				local uu = #contadorPalavras[i]
				
				-- LARGURA JUSTIFICADO--
				local largura = atributos.largura - atributos.margem*2 - atributos.x
				if atributos.xNegativo < 0 then
					largura = atributos.largura - atributos.margem*2 + atributos.xNegativo
				end
				-- verificar a imagemH e posição Y do texto para justificar as linhas de acordo --
				if imagemH ~= 0 and contadorPalavras[i][uu].y <= atributos.Y + imagemH  then
					largura = largura - imagemW
				end
				----------------------------------------------------------------------------------
				------------------------
				
				-- calcular quanto falta de espaço para justificar o texto na linha --
				local faltante = largura - contadorPalavras[i][uu].x - contadorPalavras[i][uu].width
				local Espacos = faltante/(uu-1)
				----------------------------------------------------------------------
				
				-- colocar os espaços entre os textos para justificar --
				grupoLinhas[i] = display.newGroup()
				local textoAux = ""
				for k=1,uu do
					if uu > 1 and i ~= #contadorPalavras then
						if k>1 and (faltante < 300 or (i < #contadorPalavras)) then
							if not contadorPalavras[i].barraN or (contadorPalavras[i].barraN and contadorPalavras[i].barraN == false) then
								contadorPalavras[i][k].x = contadorPalavras[i][k].x + Espacos*(k-1)
								if contadorPalavras[i][k].sublinhado then
									contadorPalavras[i][k].sublinhado.x = contadorPalavras[i][k].sublinhado.x + Espacos*(k-1)
									if k > 1 and contadorPalavras[i][k-1].sublinhado then
										contadorPalavras[i][k].sublinhado.x = contadorPalavras[i][k-1].sublinhado.x + contadorPalavras[i][k-1].sublinhado.width -- Espacos*(k-1)
										contadorPalavras[i][k].sublinhado.width = contadorPalavras[i][k].sublinhado.width + Espacos
									end
								end
								if contadorPalavras[i][k].rect then
									contadorPalavras[i][k].rect.x = contadorPalavras[i][k].rect.x + Espacos*(k-1)
									if k > 1 and contadorPalavras[i][k-1].rect then
										--contadorPalavras[i][k].rect.x = contadorPalavras[i][k-1].rect.x + contadorPalavras[i][k-1].rect.width -- Espacos*(k-1)
										--contadorPalavras[i][k].rect.width = contadorPalavras[i][k].rect.width + Espacos
										contadorPalavras[i][k].rect.x = contadorPalavras[i][k].x 
										contadorPalavras[i][k].rect.width = contadorPalavras[i][k].width
										if contadorPalavras[i][k].iconeAudio then
											contadorPalavras[i][k].iconeAudio.x = contadorPalavras[i][k].rect.x + contadorPalavras[i][k].rect.width
											--contadorPalavras[i][k].iconeAudio.y = contadorPalavras[i][k].iconeAudio.y - contadorPalavras[i][k].rect.height + 5
										end
										if contadorPalavras[i][k].iconeImagem then
											contadorPalavras[i][k].iconeImagem.x = contadorPalavras[i][k].rect.x + contadorPalavras[i][k].rect.width-((contadorPalavras[i][k].iconeImagem.width+1)*1)
										end
										if contadorPalavras[i][k].iconeAnimacao then
											contadorPalavras[i][k].iconeAnimacao.x = contadorPalavras[i][k].rect.x + contadorPalavras[i][k].rect.width-((contadorPalavras[i][k].iconeAnimacao.width+1)*2)
										end
										if contadorPalavras[i][k].iconeVideo then
											contadorPalavras[i][k].iconeVideo.x = contadorPalavras[i][k].rect.x + contadorPalavras[i][k].rect.width-((contadorPalavras[i][k].iconeVideo.width+1)*3)
										end
									end
								end
							end
						end
					end
					if contadorPalavras[i][k].sublinhado then
						grupoLinhas[i]:insert(contadorPalavras[i][k].sublinhado)
					end
					if contadorPalavras[i][k].rect then
						grupoLinhas[i]:insert(contadorPalavras[i][k].rect)
					end
					if contadorPalavras[i][k].iconeAudio then
						grupoLinhas[i]:insert(contadorPalavras[i][k].iconeAudio)
					end
					if contadorPalavras[i][k].iconeImagem then
						grupoLinhas[i]:insert(contadorPalavras[i][k].iconeImagem)
					end
					if contadorPalavras[i][k].iconeAnimacao then
						grupoLinhas[i]:insert(contadorPalavras[i][k].iconeAnimacao)
					end
					if contadorPalavras[i][k].iconeVideo then
						grupoLinhas[i]:insert(contadorPalavras[i][k].iconeVideo)
					end
					grupoLinhas[i].yy = contadorPalavras[i][k].y
					grupoLinhas[i]:insert(contadorPalavras[i][k])
					-- arrumar a posição X das linhas do texto de acordo com 'margem','imagem' e 'x' --
					
					-- COM IMAGEM --
					if imagemH ~= 0 and contadorPalavras[i][uu].y <= atributos.Y + imagemH  then
						-- texto na imagem
						if atributos.posicao == "direita" then
							grupoLinhas[i].x = atributos.x + atributos.margem
						elseif atributos.posicao == "esquerda" then
							grupoLinhas[i].x = atributos.x + atributos.margem + imagemW
						end
					-- SEM IMAGEM -- ou -- PARA BAIXO DA IMAGEM --
					else
						grupoLinhas[i].x = atributos.x + atributos.margem
					end
					----------------    --------------------------
					-----------------------------------------------------------------------------------
				end
				--------------------------------------------------------
			end
			-------------------------
			for i=1,#grupoLinhas do
				grupoTexto:insert(grupoLinhas[i])
			end
		end
		-- FIM JUSTIFICADO ----------------------------------------------------------------------
		-----------------------------------------------------------------------------------------
		
		----------------------------------------------------------------------------------
		-- ALINHAMENTO MEIO -------------------------------------------------------------- 
		if atributos.alinhamento == "meio" then
			local maiorLargura = {}
			maiorLargura.width = 0
			
			-- identificar a linha de maior largura para ajustar as outras --
			for i=1,#grupoLinhas do
				if grupoLinhas[i].width > maiorLargura.width then
					maiorLargura = grupoLinhas[i]
				end
				grupoTexto.xx = maiorLargura.x
			end
			-----------------------------------------------------------------
			
			-- criar grupo para armazenar as linhas depois de ajustadas --
			local grupoMeio = display.newGroup()
			grupoMeio.anchorX = 0
			grupoMeio.anchorY = 0
			grupoMeio.x = maiorLargura.x
			grupoTexto:insert(grupoMeio)
			--------------------------------------------------------------
			
			-- ajustar a linha de acordo com a maior --
			for i=1,#grupoLinhas do
				
				if grupoLinhas[i].width < maiorLargura.width then
					grupoLinhas[i].x = maiorLargura.width/2 - grupoLinhas[i].width/2
					grupoMeio:insert(grupoLinhas[i])
				else
					grupoMeio:insert(grupoLinhas[i])
				end
				
			end
			-------------------------------------------
			
			-- mover as linhas para a posição final correta --
			if imagemW ~= 0 and atributos.posicao == "direita" then
				grupoMeio.x = atributos.largura - imagemW - atributos.margem - grupoMeio.width + atributos.xNegativo
			elseif imagemW ~= 0 and atributos.posicao == "esquerda" then
				grupoMeio.x = atributos.x + atributos.margem + imagemW
			else
				grupoMeio.x = W/2 - grupoMeio.width/2 + atributos.x/2
				if atributos.xNegativo < 0 then
					grupoMeio.x = W/2 - grupoMeio.width/2 + atributos.xNegativo/2
				end
			end
			--------------------------------------------------
		-- FIM MEIO -------------------------------------------------------------- 
		--------------------------------------------------------------------------
		
		--------------------------------------------------------------------------
		-- ALINHAMENTO DIREITA --------------------------------------------------- 
		elseif atributos.alinhamento == "direita" then
			for i=1,#grupoLinhas do
				if imagemW ~= 0 and atributos.posicao == "direita" and grupoLinhas[i].yy <= atributos.Y + imagemH  then
					grupoLinhas[i].x = atributos.largura - grupoLinhas[i].width - atributos.margem - imagemW + atributos.xNegativo 
				elseif imagemW ~= 0 and atributos.posicao == "esquerda"  then
					grupoLinhas[i].x = atributos.largura - atributos.margem - grupoLinhas[i].width + atributos.xNegativo
				else
					grupoLinhas[i].x = atributos.largura - atributos.margem - grupoLinhas[i].width + atributos.x
					if atributos.xNegativo < 0 then
						grupoLinhas[i].x = atributos.largura - atributos.margem - grupoLinhas[i].width + atributos.xNegativo
					end
				end 
			end
		-- FIM DIREITA -----------------------------------------------------------
		--------------------------------------------------------------------------
		
		--------------------------------------------------------------------------
		-- ALINHAMENTO ESQUERDA --------------------------------------------------
		elseif atributos.alinhamento == "esquerda" then
			
			for i=1,#grupoLinhas do
				if imagemW ~= 0 and atributos.posicao == "direita" then
					grupoLinhas[i].x = grupoLinhas[i].x + atributos.x + atributos.xNegativo + atributos.margem
				elseif imagemW ~= 0 and atributos.posicao == "esquerda" and grupoLinhas[i].yy <= atributos.Y + imagemH then
					grupoLinhas[i].x = grupoLinhas[i].x + atributos.x + atributos.xNegativo + atributos.margem + imagemW
				else
					print("ALINHAMENTO ESQUERDA",grupoLinhas[i].x)
					print("atributos.xNegativo",atributos.xNegativo)
					grupoLinhas[i].x = atributos.x + atributos.margem 
					if atributos.xNegativo < 0 then
						grupoLinhas[i].x = atributos.x + atributos.margem
					end
				end 
			end
		end
		-- FIM ESQUERDA ---------------------------------------------------------
		-------------------------------------------------------------------------
		
		-- calcular texto maior e texto menor pelo numero de linhas ----------------------------
		local alturaMaior = atributos.tamanho
		local alturaMenor = atributos.tamanho
		if atributos.tamanho <= 80 then
			alturaMaior = alturaMaior +5
			if alturaMaior > 85 then
				alturaMaior = 85
			end
		end
		if atributos.tamanho > 20 then
			alturaMenor = alturaMenor -5
			if alturaMenor < 15 then
				alturaMenor = 15
			end
		end
		local pegarAlturaMaior = display.newText("aTaque",0,0,atributos.fonte,alturaMaior)
		local pegarAlturaMenor = display.newText("aTaque",0,0,atributos.fonte,alturaMenor)
		local pegarAlturaAtual = display.newText("aTaque",0,0,atributos.fonte,atributos.tamanho)
		grupoTexto.alturaMaior = alturaMaior
		grupoTexto.alturaMenor = alturaMenor
		alturaMaior = nil
		alturaMenor = nil
		
		grupoTexto.HMaior = pegarAlturaMaior.height*contadorGLinha
		grupoTexto.HMenor = pegarAlturaMenor.height*contadorGLinha
		if imagemH then
			if imagemH>=grupoTexto.HMaior then
				grupoTexto.HMaior = imagemH
			end
			if imagemH>=grupoTexto.HMenor then
				grupoTexto.HMenor = imagemH
			end
		end
		--print("AtualNova =",pegarAlturaAtual.height*contadorGLinha,"AtualReal",grupoTexto.height)
		--print(pegarAlturaAtual.height*contadorGLinha)
		pegarAlturaMaior:removeSelf()
		pegarAlturaMenor:removeSelf()
		pegarAlturaAtual:removeSelf()
		pegarAlturaMaior = nil
		pegarAlturaMenor = nil
		
		grupoTexto.HAtual = grupoTexto.height
		grupoTexto.alturaAtual = atributos.tamanho
		----------------------------------------------------------------------------------------
		
	end
	
	return grupoTexto
end
M.criarTextodePalavras = criarTextodePalavras

return M