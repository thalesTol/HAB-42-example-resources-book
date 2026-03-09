local M ={}
local W = display.viewableContentWidth ;
local H = display.viewableContentHeight;
local json = require("json")
local validarUTF8 = require("utf8Validator")
-- SUMÁRIO ----------
--[[
	M.alphanumsort(o)
	M.Alphanumsort(o)
	M.addTxTRes(arquivo,texto)
	M.addTxTDoc(arquivo,texto)
	M.checarBissexto(ano)
	M.checarExtensaoImagem(str)
	M.checarExtensaoAudio(str)
	M.checarExtensaoVideo(str)
	M.checarPortatil()
	M.checarSimulator()
	M.checarSistema()
	M.clearNativeScreenElements(Var)
	M.clipTextByWidth(text, maxWidth, sufix)
	M.copyFile( srcName, srcPath, dstName, dstPath, overwrite )
	M.contagemDaPaginaHistorico(atributos)
	M.contagemDaPaginaRetroativa(atributos)
	M.criarMensagemTemporaria(imagem,x,y,width,height)
	M.criarTxTRes(arquivo,texto)
	M.criarTxTRes2(arquivo,texto)
	M.criarTxTDoc(arquivo,texto)
	M.criarTxTDocWSemMais(arquivo,texto)
	M.createNewButton(atrib)
	M.displayImage(atrib)
	M.displayShape(atrib)
	M.deslogarEsair()
	M.downloadArquivo(arquivo,link,funcao)
	M.fileExistsDiretorioBase(fileName,diretorioBase)
	M.fileExists(fileName)
	M.fileExistsDoc(fileName)
	M.fileExistsTemp(fileName)
	M.filtrarCodigos(str)
	M.filtrarCodigosCompleto(str)
	M.GetImageWidthHeight(file)
	M.getMatchesString(inputString)
	M.hasPhonePermission(permissao)
	M.lerTextoRes(arquivo)
	M.lerTextoResLinhasNaoVazias(arquivo)
	M.lerTextoResNumeroLinhas(arquivo)
	M.lerTextoDoc(arquivo)
	M.lerTextoDocReturnVetorNumbers(arquivo)
	M.lerArquivoTXTCaminho(atributos)
	M.lerPreferenciasAutorAux(vetorTodas,padrao)
	M.LimparTemporaryDirectory()
	M.LimparDocumentsDirectory()
	M.loadTable(filename, location)
	M.moverComLimiteVertical(e)
	M.naoVazio(s)
	M.onMouseEventRolagem( event )
	M.overwriteTable( t, filename, location )
	M.pausar(tempo)
	M.pausarDespausarAnimacao(Var,tipo)
	M.pausarDespausarAnimacaoTTS(tipo,animacao)
	M.pegarNumeroPaginaRomanosHistorico(pagina)
	M.pegarPalavrasEContextos(texto)
	M.restoreNativeScreenElements(Var)
	M.RGBdetectAndTransformTo1(colors)
	M.saveTable(t, filename,location)
	M.SecondsToClock(seconds)
	M.stopAllButOne( keep )
	M.stopAllSounds()
	M.TelaProtetiva()
	M.TelaAguarde()
	M.TelaAguardeGerarAudio()
	M.testarNoAndroid(texto,posicaoy)
	M.timeCount(numSec)
	M.tirarAExtencao(str)
	M.tirarAExtencao(str)
	M.toBinary(atrib)
	M.ToRomanNumerals(s)
	M.ToNumber(s)
	M.verificarComentario(texto)
	M.verificarERetirarBarraStatusSystem()
	M.verificarNumeroPaginaRomanosHistorico(pagina,paginasAntesZero)
	M.verificarQuestoesEPaginasBloqueadas(data)
	M.writebyn(str,fh)
	M.zoomArquivo( event )

]]
local function openBinary(atributos)
	local path = system.pathForFile(atributos.arquivo,system.ResourcesDirectory)
	local file,erro = io.open(path, "rb")
	local f = assert(file)
	
	local binaryTable = {}
	local data = f:read("*all")
	for b in string.gfind(data, ".") do
		table.insert(binaryTable,string.format("%d", string.byte(b)))
	end

	return binaryTable
end
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


function M.Alphanumsort(o)
  local function padnum(d) local dec, n = string.match(d, "(%.?)0*(.+)")
	return #dec > 0 and ("%.12f"):format(d) or ("%s%03d%s"):format(dec, #n, n) end
  table.sort(o, function(a,b)
	return string.lower(tostring(a):gsub("%.?%d+",padnum)..("%3d"):format(#b))
		 <  string.lower(tostring(b):gsub("%.?%d+",padnum)..("%3d"):format(#a)) end)
  return o
end

function M.alphanumsort(o)
  local function padnum(d) local dec, n = string.match(d, "(%.?)0*(.+)")
	return #dec > 0 and ("%.12f"):format(d) or ("%s%03d%s"):format(dec, #n, n) end
  table.sort(o, function(a,b)
	return string.lower(tostring(a):gsub("%.?%d+",padnum)..("%3d"):format(#b))
		 <  string.lower(tostring(b):gsub("%.?%d+",padnum)..("%3d"):format(#a)) end)
  return o
end

function M.addTxTRes(arquivo,texto) -- vetor ou variavel
	local caminho = system.pathForFile(arquivo,system.ResourceDirectory)
	local file2,errorString = io.open( caminho, "a" )
	print("caminho",caminho)
	print(arquivo)
	if not file2 then
		print( "File ".. tostring(arquivo) .." error: " .. errorString )
	else
		file2:write(texto)
		io.close( file2 )
	end
	file2 = nil
end

function M.addTxTDoc(arquivo,texto) -- vetor ou variavel
	local caminho = system.pathForFile(arquivo,system.DocumentsDirectory)
	local file2,errorString = io.open( caminho, "a" )
	print("caminho",caminho)
	print(arquivo)
	if not file2 then
		print( "File ".. tostring(arquivo) .." error: " .. errorString )
	else
		file2:write(texto)
		io.close( file2 )
	end
	file2 = nil
end

function M.checarBissexto(ano)
	local div400 = ano%400
	local div100 = ano%100
	local div4 = ano%4
	if div4 == 0 then
		if div100 == 0 and div400 == 0 then
			return true
		elseif div100 ~= 0 then
			return true
		else
			return false
		end
	else
		return false
	end
end

function M.checarExtensaoImagem(str)
	local fileAux = string.lower(str)
	if string.find( fileAux, "%.jpg" )or string.find( fileAux, "%.png" )or string.find( fileAux, "%.bmp" )or string.find( fileAux, "%.jpeg" ) or string.find( fileAux, "%.heic" )then
		return true
	else
		return false
	end
end

function M.checarExtensaoAudio(str)
	local fileAux = string.lower(str)
	if string.find( fileAux, "%.mp3" )or string.find( fileAux, "%.wav" )or string.find( fileAux, "%.ogg" )or string.find( fileAux, "%.wma" )then
		return true
	else
		return false
	end
end

function M.checarExtensaoVideo(str)
	local fileAux = string.lower(str)
	if string.find( fileAux, "%.mp4" )or string.find( fileAux, "%.mkv" )or string.find( fileAux, "%.m4v" )or string.find( fileAux, "%.3gp" )or string.find( fileAux, "%.mov" )then
		return true
	else
		return false
	end
end

function M.checarPortatil()
	local tipoSistema = system.getInfo("platform")
	local tipoDevice = system.getInfo("environment")

	if tipoDevice == "simulator" or tipoSistema == "win32" or tipoSistema == "macos" then
		return "PC"
	elseif tipoDevice == "device" and tipoSistema == "android" then
		return "android"
	else
		return "outro"
	end
end

function M.checarSimulator()
	local tipoDevice = system.getInfo("environment")

	if tipoDevice == "simulator" then
		return "simulator"
	else
		return "device"
	end
end

function M.checarSistema()
	local tipoSistema = system.getInfo("platform")
	local tipoDevice = system.getInfo("environment")
	print(tipoSistema)
	print(tipoDevice)
	if tipoDevice == "simulator" or tipoSistema == "win32" or tipoSistema == "macos" then
		return "PC"
	elseif tipoDevice == "device" and tipoSistema == "android" then
		return "android"
	else
		return "outro"
	end
end

function M.clearNativeScreenElements(Var)
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

function M.clipTextByWidth(text, maxWidth, sufix)
  if text.width <= maxWidth then
	return;
  end
  while text.width > maxWidth do
	  text.text = text.text:sub(1, -2)
  end
  text.text = text.text .. sufix
end

function M.copyFile( srcName, srcPath, dstName, dstPath, overwrite )
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

function M.contagemDaPaginaHistorico(atributos)
	local pagina = atributos.paginaAtual or atributos.pagina_livro
	if pagina then
		if type(pagina) == "number" then
			pagina = pagina + atributos.contagemInicialPaginas -atributos.PaginasPre-atributos.Indices -1
			pagina = M.verificarNumeroPaginaRomanosHistorico(pagina,atributos.paginasAntesZero)
		else
			--paginaPaginas_Pagina49_PagExerc1Alt3_3
			local aux1 = string.match(pagina,"_Pagina%d+")
			local aux1_2 = string.match(aux1,"%d+")
			local pagina_atual = tonumber(aux1_2) + atributos.contagemInicialPaginas -atributos.PaginasPre-atributos.Indices -1
			
			local aux2 = string.match(pagina,"_PagExerc%d+")
			local aux2_1 = string.match(aux2,"%d+")
			local exerc_atual = tonumber(aux2_1)
			
			local aux3 = string.match(pagina,"Alt%d+")
			local aux3_1 = string.match(aux3,"%d+")
			local alt_atual = tonumber(aux3_1)
			
			pagina = tostring(pagina_atual)..", exercício "..exerc_atual..", alternativa "..alt_atual
			
		end
	else
		pagina = "remissivo"
	end
	return pagina
end

function M.contagemDaPaginaRetroativa(atributos)
	local pagina = atributos.paginaReal
	local paginasAntesZero = atributos.paginasAntesZero
	if pagina then
		if type(pagina) == "number" then
			if string.find(tostring(pagina),"%-") then
				pagina = pagina + paginasAntesZero + 1
			else
				
				pagina = pagina +atributos.PaginasPre+atributos.Indices
			end
		end
	end
	return pagina
end
-------------------
--[[createNewButton
	Properties:
		width
		height
		defaultFile
		overFile
		shape
		strokeWidth
		strokeColor
		fillColor
		label
		labelcolor
 		radius
 		size
		font
]]
function M.createNewButton(atrib)
	if not atrib then atrib = {} end
	local G = display.newGroup()
	G.myWidth = atrib.width
	G.myHeight = atrib.height
	G.imageUpFile = atrib.defaultFile
	G.imageDownFile = atrib.overFile or G.imageUpFile
	G.shape = atrib.shape or "rect"
	G.strokeWidth = atrib.strokeWidth or 0
	G.radius = atrib.radius or 5
	G.size = atrib.size or 70
	G.font = atrib.font or native.systemFont
	
	if atrib.strokeColor and atrib.strokeColor.default and atrib.strokeColor.over then G.strokeColor = atrib.strokeColor 
	else G.strokeColor = {default = {0,0,0,1},over = {0.5,0.5,0.5,1}} end
	G.strokeColor.default = M.RGBdetectAndTransformTo1(G.strokeColor.default)
	G.strokeColor.over = M.RGBdetectAndTransformTo1(G.strokeColor.over)
	
	if atrib.fillColor and atrib.fillColor.default and atrib.fillColor.over then G.fillColor = atrib.fillColor 
	else G.fillColor = {default = {192/255,0,0,1},over = {168/255,0,0,1}} end
	G.fillColor.default = M.RGBdetectAndTransformTo1(G.fillColor.default)
	G.fillColor.over = M.RGBdetectAndTransformTo1(G.fillColor.over)
	if G.imageUpFile then G.fillColor = {default = {1,1,1,1},over = {1,1,1,.9}} end
	
	G.label = atrib.label
	if atrib.labelColor and atrib.labelColor.default and atrib.labelColor.over then G.labelColor = atrib.labelColor 
	else G.labelColor = {default = {1-G.fillColor.default[1],1-G.fillColor.default[2],1-G.fillColor.default[3],1},over = {1-G.fillColor.over[1],1-G.fillColor.over[2],1-G.fillColor.over[3],1}} end
	
	G.btn = display.newGroup()
	G:insert(G.btn)
	
	if G.imageUpFile then
		G.btn.buttonDown = display.newGroup()
		if G.imageDownFile then G.btn.buttonDownImage = M.displayImage({file = G.imageDownFile,width=G.myWidth,height=G.myHeight})
		else G.btn.buttonDownImage = M.displayImage({file = G.imageUpFile,x = W/2,y = 100,width=G.myWidth,height=G.myHeight}) end
		G.btn.buttonDownImage.fill.effect = "filter.vignette"
		G.btn.buttonDownImage.fill.effect.radius = 0.2
		
		G.btn.buttonDown:insert(G.btn.buttonDownImage)
		print("G.btn.buttonDownImage",G.btn.buttonDownImage)
		if G.label then
			local optionsText = {text=G.label,x=G.btn.buttonDown.x,y=G.btn.buttonDown.y,font=G.font,fontSize=G.size,align="center"}
			G.btn.buttonDownLabel = display.newText(optionsText)
			G.btn.buttonDownLabel.anchorX,G.btn.buttonDownLabel.anchorY = 0.5,0.5
			G.btn.buttonDownLabel:setFillColor(G.labelColor.over[1],G.labelColor.over[2],G.labelColor.over[3],G.labelColor.over[4])
			G.btn.buttonDown:insert(G.btn.buttonDownLabel)
		end
		G.btn:insert(G.btn.buttonDown)
		
		G.btn.buttonUp = display.newGroup()
		G.btn.buttonUpImage = M.displayImage({file = G.imageUpFile,width=G.myWidth,height=G.myHeight})
		G.btn.buttonUp:insert(G.btn.buttonUpImage)
		print("G.btn.buttonUpImage",G.btn.buttonUpImage)
		if G.label then 
			local optionsText = {text=G.label,x=G.btn.buttonDown.x,y=G.btn.buttonDown.y,font=G.font,fontSize=G.size,align="center"}
			G.btn.buttonUpLabel = display.newText(optionsText)
			G.btn.buttonUpLabel.anchorX,G.btn.buttonUpLabel.anchorY = 0.5,0.5
			G.btn.buttonUpLabel:setFillColor(G.labelColor.default[1],G.labelColor.default[2],G.labelColor.default[3],G.labelColor.default[4])
			G.btn.buttonUp:insert(G.btn.buttonUpLabel)
		end
		G.btn:insert(G.btn.buttonUp)
	else
		G.btn.buttonDown = display.newGroup()
		G.btn.buttonDownImage = M.displayShape({shape = G.shape,x = 0,y = 0,width=G.myWidth,height=G.myHeight,radius = G.radius})
		G.btn.buttonDown:insert(G.btn.buttonDownImage)
		if G.label then 
			local optionsText = {text=G.label,x=G.btn.buttonDown.x,y=G.btn.buttonDown.y,font=G.font,fontSize=G.size,align="center"}
			G.btn.buttonDownLabel = display.newText(optionsText)
			G.btn.buttonDownLabel.anchorX,G.btn.buttonDownLabel.anchorY = 0.5,0.5
			G.btn.buttonDownLabel:setFillColor(G.labelColor.over[1],G.labelColor.over[2],G.labelColor.over[3],G.labelColor.over[4])
			G.btn.buttonDown:insert(G.btn.buttonDownLabel)
		end
		G.btn:insert(G.btn.buttonDown)
		
		G.btn.buttonUp = display.newGroup()
		G.btn.buttonUpImage = M.displayShape({shape = G.shape,x = 0,y = 0,width=G.myWidth,height=G.myHeight,radius = G.radius})
		G.btn.buttonUp:insert(G.btn.buttonUpImage)
		if G.label then 
			local optionsText = {text=G.label,x=G.btn.buttonDown.x,y=G.btn.buttonDown.y,font=G.font,fontSize=G.size,align="center"}
			G.btn.buttonUpLabel = display.newText(optionsText)
			G.btn.buttonUpLabel.anchorX,G.btn.buttonUpLabel.anchorY = 0.5,0.5
			G.btn.buttonUpLabel:setFillColor(G.labelColor.default[1],G.labelColor.default[2],G.labelColor.default[3],G.labelColor.default[4])
			G.btn.buttonUp:insert(G.btn.buttonUpLabel)
		end
		G.btn:insert(G.btn.buttonUp)
	end
	G.btn.buttonDownImage:setFillColor(G.fillColor.over[1],G.fillColor.over[2],G.fillColor.over[3],G.fillColor.over[4])
	G.btn.buttonUpImage:setFillColor(G.fillColor.default[1],G.fillColor.default[2],G.fillColor.default[3],G.fillColor.default[4])
	if G.strokeWidth then 
		G.btn.buttonDownImage.strokeWidth = G.strokeWidth
		G.btn.buttonDownImage:setStrokeColor(G.strokeColor.over[1],G.strokeColor.over[2],G.strokeColor.over[3],G.strokeColor.over[4])
		G.btn.buttonUpImage.strokeWidth = G.strokeWidth
		G.btn.buttonUpImage:setStrokeColor(G.strokeColor.default[1],G.strokeColor.default[2],G.strokeColor.default[3],G.strokeColor.default[4])
	end
	
	if atrib.onRelease then G.extFunc = atrib.onRelease
	elseif atrib.onBegan then G.extFunc = atrib.onBegin
	elseif atrib.onEvent then G.extFunc = atrib.onEvent
	end
	G.btn.onTouch = function(e)
		if e.phase == "began" then
			display.getCurrentStage():setFocus( e.target, e.id )
			G.btn.buttonUp.alpha = 0
			e.target.touchBegan = true
			if atrib.onBegan then
				atrib.onBegan(e)
			end
			if atrib.onEvent then
				atrib.onEvent(e)
			end
			return true
		elseif e.phase == "moved" then
			if e.target.touchBegan then
				local bounds = e.target.contentBounds
				if (
					e.x < bounds.xMin or
					e.x > bounds.xMax or
					e.y < bounds.yMin or
					e.y > bounds.yMax
				) then
					display.getCurrentStage():setFocus( e.target, nil )
					-- soltar imagem do botão
					G.btn.buttonUp.alpha = 1
					e.target.touchBegan = false
				end
				if atrib.onEvent then
					atrib.onEvent(e)
				end
			end
			return true
		elseif e.phase == "ended" then
			display.getCurrentStage():setFocus( e.target, nil )
			if e.target.touchBegan then
				e.target.touchBegan = false
				G.btn.buttonUp.alpha = 1
				if atrib.onRelease then
					atrib.onRelease(e)
				end
				if atrib.onEvent then
					atrib.onEvent(e)
				end
			end
			return true
		end
		
	end
	 G.btn.onTap = function(e)
		if atrib.onTap then
			atrib.onTap(e)
		end
		return true
	end
	G.btn.touchBegan = false
	G.btn:addEventListener("tap",G.btn.onTap)
	G.btn:addEventListener("touch",G.btn.onTouch)
	
	return G
end

function M.criarMensagemTemporaria(img,x,y,width,height,tempo)
	local imagem = display.newImageRect(img,width,height)
	imagem.anchorX=0.5;imagem.anchorY=0.5
	imagem.x = x; imagem.y = y
	if x + imagem.width/2 > W then imagem.x = x - 20; imagem.anchorX = 1;
	elseif x - imagem.width/2 < 0 then imagem.x = x + 20; imagem.anchorX = 0 end
	if y + imagem.height/2 > H then imagem.y = y - 50; imagem.anchorY = 1
	elseif y - imagem.height/2 < 0 then imagem.y = y + 50; imagem.anchorY = 0 end
	local function onComplete(e)
		if imagem and imagem.alpha and imagem.alpha then
			imagem:removeSelf()
			imagem = nil
		elseif imagem and not imagem.alpha then
			imagem = nil
		end
	end
	imagem.fade = timer.performWithDelay(tempo,
		function() 
			if imagem and imagem.alpha and imagem.alpha == 1 then 
				transition.to(imagem,{tempo = 1000,alpha = 0,onComplete = onComplete}) 
			end 
		end,1)
	function imagem.remover()
		if imagem then
			if imagem.fade then 
				timer.cancel(imagem.fade) 
			end
			imagem:removeSelf()
			imagem = nil 
		end
	end
	return imagem
end

function M.criarTxTRes(arquivo,texto) -- vetor ou variavel
	local caminho = system.pathForFile(arquivo,system.ResourceDirectory)
	local file2,errorString = io.open( caminho, "w+" )
	
	if not file2 then
		print( "File ".. tostring(arquivo) .." error: " .. errorString )
	else
		file2:write(texto)
		io.close( file2 )
	end
	file2 = nil
end

function M.criarTxTRes2(arquivo,texto) -- vetor ou variavel
	local caminho = system.pathForFile(nil,system.ResourceDirectory)
	if caminho then caminho = caminho .. "/" .. arquivo end
	local file2,errorString = io.open( caminho, "w" )
	if not file2 then
		print( "File ".. tostring(arquivo) .." error: " .. errorString )
	else
		file2:write(texto)
		io.close( file2 )
	end
	file2 = nil
end

function M.criarTxTDoc(arquivo,texto) -- vetor ou variavel
	local caminho = system.pathForFile(arquivo,system.DocumentsDirectory)
	local file2,errorString = io.open( caminho, "w+" )
	print("caminho",caminho)
	print(arquivo)
	if not file2 then
		print( "File ".. tostring(arquivo) .." error: " .. errorString )
	else
		file2:write(texto)
		io.close( file2 )
	end
	file2 = nil
end

function M.criarTxTDocWSemMais(arquivo,texto) -- vetor ou variavel
	local caminho = system.pathForFile(arquivo,system.DocumentsDirectory)
	local file2,errorString = io.open( caminho, "w" )
	if not file2 then
		print( "File ".. tostring(arquivo) .." error: " .. errorString )
	else
		file2:write(texto)
		io.close( file2 )
	end
	file2 = nil
end

function M.displayImage(atrib)
	if not atrib then atrib = {} end
	local x = atrib.x or 0
	local y = atrib.y or 0
	local width = atrib.width or nil
	local height = atrib.height or nil
	local anchorX = atrib.anchorX or 0.5
	local anchorY = atrib.anchorY or 0.5
	local file = atrib.file
	if file then
		if not width or not height then
			local auxImage = display.newImage(file,x,y)
			width = auxImage.width
			height = auxImage.height
			auxImage:removeSelf()
			auxImage = nil
		end
		print("file",file)
		local myImage = display.newImageRect(file,width,height)
		myImage.x = x
		myImage.y = y
		myImage.anchorX = anchorX
		myImage.anchorY = anchorY
		return myImage
	else
		return "Missing 'file' atribute!"..tostring(file)
	end
end

function M.displayShape(atrib)
	if not atrib then atrib = {} end
	local x = atrib.x or 0
	local y = atrib.y or 0
	local width = atrib.width or 300
	local height = atrib.height or 70
	local anchorX = atrib.anchorX or 0.5
	local anchorY = atrib.anchorY or 0.5
	local shape = atrib.shape or "roundedRect"
	local radius = atrib.radius or 5
	local Rect
	if shape == "roundedRect" then
		Rect = display.newRoundedRect(x,y,width,height,radius)
	elseif shape == "rect" then
		Rect = display.newRect(x,y,width,height)
	elseif shape == "circle" then
		Rect = display.newCircle(x,y,radius)
	end
	Rect.x = x
	Rect.y = y
	Rect.anchorX = anchorX
	Rect.anchorY = anchorY

	return Rect
end

function M.deslogarEsair()
	M.LimparDocumentsDirectory()
	--local function onComplete()
	os.exit()
	--end
	--local som = audio.loadStream(varGlobal.menuConfigBotaoDeslogar)
	--timerRequerimento = timer.performWithDelay(16,function() audio.play(som,{onComplete=onComplete}) end,1)

end

function M.downloadArquivo(arquivo,link,funcao)
	 
	local params = {}
	params.progress = true
	 
	local ID = network.download(
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

function M.fileExistsDiretorioBase(fileName,diretorioBase)
	local filePath = system.pathForFile(fileName, diretorioBase)
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

function M.fileExists(fileName)
	local filePath = system.pathForFile(fileName, system.ResourceDirectory)
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

function M.fileExistsDoc(fileName)
	local filePath = system.pathForFile(fileName, system.DocumentsDirectory)
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

function M.fileExistsTemp(fileName)
	local filePath = system.pathForFile(fileName, system.TemporaryDirectory)
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

function M.filtrarCodigos(str)
	local texto = str
	local vetor = {
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
		"#dic=[^#]+#","#/dic=[^#]+#",
		"#c=%d+,%d+,%d+#","#/c#",
		"#r=.+#",
		"#/r=.+#",
	}
	for i=1,#vetor do
		texto = string.gsub(texto,vetor[i],"")
	end

	return texto
end

function M.filtrarCodigosCompleto(str)
	local texto = str
	local vetor = {
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
		"#dic=[^#]+#","#/dic=[^#]+#",
		"#c=%d+,%d+,%d+#","#/c#",
		"#r=.+#",
		"#/r=.+#",
		"|>%[",
		"|<%[",
		"|<>%[",
		"|t%d+%[",
		"|n%[",
		"|i%[",
		"|ni%[",
		"|f=[^%[]+%[",
		"|c=[^%[]+%["
	}
	for i=1,#vetor do
		texto = string.gsub(texto,vetor[i],"")
	end

	return texto
end

function M.filtrarCodigosSemRodape(str)
	local texto = str
	local vetor = {
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
		"#dic=[^#]+#","#/dic=[^#]+#",
		"#c=%d+,%d+,%d+#","#/c#",
		"#r=.+#"
	}
	for i=1,#vetor do
		texto = string.gsub(texto,vetor[i],"")
	end
	
	return texto
end

function M.GetImageWidthHeight(file)
	local fileinfo=type(file)
	if type(file)=="string" then
		file=assert(io.open(file,"rb"))
	else
		fileinfo=file:seek("cur")
	end
	local function refresh()
		if type(fileinfo)=="number" then
			file:seek("set",fileinfo)
		else
			file:close()
		end
	end
	local width,height=0,0
	file:seek("set",1)
	-- Detect if PNG
	if file:read(3)=="PNG" then
		--[[
			The strategy is
			1. Seek to position 0x10
			2. Get value in big-endian order
		]]
		file:seek("set",16)
		local widthstr,heightstr=file:read(4),file:read(4)
		if type(fileinfo)=="number" then
			file:seek("set",fileinfo)
		else
			file:close()
		end
		width=widthstr:sub(1,1):byte()*16777216+widthstr:sub(2,2):byte()*65536+widthstr:sub(3,3):byte()*256+widthstr:sub(4,4):byte()
		height=heightstr:sub(1,1):byte()*16777216+heightstr:sub(2,2):byte()*65536+heightstr:sub(3,3):byte()*256+heightstr:sub(4,4):byte()
		return width,height
	end
	file:seek("set")
	-- Detect if BMP
	if file:read(2)=="BM" then
		--[[ 
			The strategy is:
			1. Seek to position 0x12
			2. Get value in little-endian order
		]]
		file:seek("set",18)
		local widthstr,heightstr=file:read(4),file:read(4)
		refresh()
		width=widthstr:sub(4,4):byte()*16777216+widthstr:sub(3,3):byte()*65536+widthstr:sub(2,2):byte()*256+widthstr:sub(1,1):byte()
		height=heightstr:sub(4,4):byte()*16777216+heightstr:sub(3,3):byte()*65536+heightstr:sub(2,2):byte()*256+heightstr:sub(1,1):byte()
		return width,height
	end
	-- Detect if JPG/JPEG
	file:seek("set")
	if file:read(2)=="\255\216" then
		--[[
			The strategy is
			1. Find necessary markers
			2. Store biggest value in variable
			3. Return biggest value
		]]
		local lastb,curb=0,0
		local xylist={}
		local sstr=file:read(1)
		while sstr~=nil do
			lastb=curb
			curb=sstr:byte()
			if (curb==194 or curb==192) and lastb==255 then
				file:seek("cur",3)
				local sizestr=file:read(4)
				local h=sizestr:sub(1,1):byte()*256+sizestr:sub(2,2):byte()
				local w=sizestr:sub(3,3):byte()*256+sizestr:sub(4,4):byte()
				if w>width and h>height then
					width=w
					height=h
				end
			end
			sstr=file:read(1)
		end
		if width>0 and height>0 then
			refresh()
			return width,height
		end
	end
	file:seek("set")
	-- Detect if GIF
	if file:read(4)=="GIF8" then
		--[[
			The strategy is
			1. Seek to 0x06 position
			2. Extract value in little-endian order
		]]
		file:seek("set",6)
		width,height=file:read(1):byte()+file:read(1):byte()*256,file:read(1):byte()+file:read(1):byte()*256
		refresh()
		return width,height
	end
	-- More image support
	file:seek("set")
	-- Detect if Photoshop Document
	if file:read(4)=="8BPS" then
		--[[
			The strategy is
			1. Seek to position 0x0E
			2. Get value in big-endian order
		]]
		file:seek("set",14)
		local heightstr,widthstr=file:read(4),file:read(4)
		refresh()
		width=widthstr:sub(1,1):byte()*16777216+widthstr:sub(2,2):byte()*65536+widthstr:sub(3,3):byte()*256+widthstr:sub(4,4):byte()
		height=heightstr:sub(1,1):byte()*16777216+heightstr:sub(2,2):byte()*65536+heightstr:sub(3,3):byte()*256+heightstr:sub(4,4):byte()
		return width,height
	end
	file:seek("end",-18)
	-- Detect if Truevision TGA file
	if file:read(10)=="TRUEVISION" then
		--[[
			The strategy is
			1. Seek to position 0x0C
			2. Get image width and height in little-endian order
		]]
		file:seek("set",12)
		width=file:read(1):byte()+file:read(1):byte()*256
		height=file:read(1):byte()+file:read(1):byte()*256
		refresh()
		return width,height
	end
	file:seek("set")
	-- Detect if JPEG XR/Tagged Image File (Format)
	if file:read(2)=="II" then
		-- It would slow, tell me how to get it faster
		--[[
			The strategy is
			1. Read all file contents
			2. Find "Btomlong" and "Rghtlong" string
			3. Extract values in big-endian order(strangely, II stands for Intel byte ordering(little-endian) but it's in big-endian)
		]]
		temp=file:read("*a")
		btomlong={temp:find("Btomlong")}
		rghtlong={temp:find("Rghtlong")}
		if #btomlong==2 and #rghtlong==2 then
			heightstr=temp:sub(btomlong[2]+1,btomlong[2]+5)
			widthstr=temp:sub(rghtlong[2]+1,rghtlong[2]+5)
			refresh()
			width=widthstr:sub(1,1):byte()*16777216+widthstr:sub(2,2):byte()*65536+widthstr:sub(3,3):byte()*256+widthstr:sub(4,4):byte()
			height=heightstr:sub(1,1):byte()*16777216+heightstr:sub(2,2):byte()*65536+heightstr:sub(3,3):byte()*256+heightstr:sub(4,4):byte()
			return width,height
		end
	end
	-- Video support
	file:seek("set",4)
	-- Detect if MP4
	if file:read(7)=="ftypmp4" then
		--[[
			The strategy is
			1. Seek to 0xFB
			2. Get value in big-endian order
		]]
		file:seek("set",0xFB)
		local widthstr,heightstr=file:read(4),file:read(4)
		refresh()
		width=widthstr:sub(1,1):byte()*16777216+widthstr:sub(2,2):byte()*65536+widthstr:sub(3,3):byte()*256+widthstr:sub(4,4):byte()
		height=heightstr:sub(1,1):byte()*16777216+heightstr:sub(2,2):byte()*65536+heightstr:sub(3,3):byte()*256+heightstr:sub(4,4):byte()
		return width,height
	end
	file:seek("set",8)
	-- Detect if AVI
	if file:read(3)=="AVI" then
		file:seek("set",0x40)
		width=file:read(1):byte()+file:read(1):byte()*256+file:read(1):byte()*65536+file:read(1):byte()*16777216
		height=file:read(1):byte()+file:read(1):byte()*256+file:read(1):byte()*65536+file:read(1):byte()*16777216
		refresh()
		return width,height
	end
	refresh()
	return nil
end

function M.getMatchesString(inputString,vetor,num)
    
    --hits = {}
    if not num then num = 1 end
    beginSection = 1
    
    consecutive = 0
    
    for index=0,#inputString do
        chr = string.sub(inputString,index,index)
        if chr=="|" then
            consecutive = consecutive+1
            if consecutive >= 2 then
                consecutive = 0
                table.insert(vetor,string.sub(inputString,beginSection,index-2))
                beginSection = index + 1
				num = num + 1
            end
        else
            consecutive = 0
        end
    end
    
    if beginSection ~= #inputString then
        table.insert(vetor,string.sub(inputString,beginSection,#inputString))
    end
    
    --return hits
end

function M.hasPhonePermission(permissao)
    local grantedPermissions = system.getInfo( "grantedAppPermissions" )
    local hasPhonePermission = false
 
    for i = 1,#grantedPermissions do
        if ( permissao == grantedPermissions[i] ) then
            hasPhonePermission = true
            break
        end
    end
    return hasPhonePermission
end

function M.lerTextoRes(arquivo)
	local path = system.pathForFile( arquivo, system.ResourceDirectory )
	if path then
		local file, errorString = io.open( path, "r" )
		if file then
			local contents = file:read( "*a" )
			io.close( file )
			 
			file = nil
			return contents
		else
			return false
		end
	else
		return ""
	end
end

function M.lerTextoResLinhasNaoVazias(arquivo)
	local path = system.pathForFile( arquivo, system.ResourceDirectory )
	local vetor = {}
	if path then
		
		local file, errorString = io.open( path, "r" )
		if file then
			local contents = file:read( "*a" )
			local filtrado = string.gsub(contents,".",{ ["\13"] = "",["\10"] = "\13\10"})
			local xx = 1
			for line in string.gmatch(filtrado,"([^\13\10]+)") do
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
		end
	end
	return vetor
end

function M.lerTextoResNumeroLinhas(arquivo)
	local path = system.pathForFile( arquivo, system.ResourceDirectory )
	local xx = 0
	if path then
		local file, errorString = io.open( path, "r" )
		if file then
			local contents = file:read( "*a" )
			local filtrado = string.gsub(contents,".",{ ["\13"] = "",["\10"] = "\13\10"})
			for line in string.gmatch(filtrado,"([^\13\10]+)") do
				xx = xx+1
			end
			io.close( file )
			 
			file = nil
			return xx
		else
			return false
		end
	else
		return xx
	end
	return xx
end

function M.lerTextoDoc(arquivo)
	local path = system.pathForFile( arquivo, system.DocumentsDirectory )
	if path then
		local file, errorString = io.open( path, "r" )
		if file then
			local contents = file:read( "*a" )
			io.close( file )
			 
			file = nil
			return contents
		else
			return false
		end
	else
		return ""
	end
	
end

function M.lerTextoDocReturnVetorNumbers(arquivo)
	local path = system.pathForFile( arquivo, system.DocumentsDirectory )
	if path then
		local file, errorString = io.open( path, "r" )
		if file then
			local contents = file:read( "*a" )
			local vetor = {}
			for line in file:lines() do
				table.insert(vetor,tonumber(string.match(line,'%d+')))
			end
			io.close( file )
			file = nil
			return vetor
		else
			return false
		end
	else
		return false
	end
	
end

function M.lerArquivoTXTCaminho(atributos) -- vetor ou variavel
	local sistema = M.checarSistema()
	
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
					if sistema == "android" then
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

function M.lerPreferenciasAutorAux(vetorTodas,padrao)

	for j=1,#vetorTodas do
		if vetorTodas[j] ~= nil then
			
			if string.find( vetorTodas[j]:match("([^=]+)="), "Aprovação comentários" ) ~= nil then
				local aux = nil
				lixo,str = vetorTodas[j]:match("([^=]+)=+([^\13]+)")
				for past in string.gmatch(str, '([a-z]+)') do
					aux = past
				end
				vetorTodas.permissaoComentarios = aux
				if (vetorTodas.permissaoComentarios ~= "sim") and (vetorTodas.permissaoComentarios ~= "nao") then
					vetorTodas.permissaoComentarios = padrao.permissaoComentarios
				end
			end
			
			if string.find( vetorTodas[j]:match("([^=]+)="), "Histórico Ativado" ) ~= nil then
				local aux = nil
				lixo,str = vetorTodas[j]:match("([^=]+)=+([^\13]+)")
				for past in string.gmatch(str, '([a-z]+)') do
					aux = past
				end
				vetorTodas.ativarHistorico = aux
				if (vetorTodas.ativarHistorico ~= "sim") and (vetorTodas.ativarHistorico ~= "nao") then
					vetorTodas.ativarHistorico = padrao.ativarHistorico
				end
			end
			
			if string.find( vetorTodas[j]:match("([^=]+)="), "Login Ativado" ) ~= nil then
				local aux = nil
				lixo,str = vetorTodas[j]:match("([^=]+)=+([^\13]+)")
				for past in string.gmatch(str, '([a-z]+)') do
					aux = past
				end
				vetorTodas.ativarLogin = aux
				if (vetorTodas.ativarLogin ~= "sim") and (vetorTodas.ativarLogin ~= "nao") then
					vetorTodas.ativarLogin = padrao.ativarLogin
				end
			end
			if string.find( vetorTodas[j]:match("([^=]+)="), "ajudaTTS Ativado" ) ~= nil then
				local aux = nil
				lixo,str = vetorTodas[j]:match("([^=]+)=+([^\13]+)")
				for past in string.gmatch(str, '([a-z]+)') do
					aux = past
				end
				vetorTodas.ajudaTTS = aux
				if (vetorTodas.ajudaTTS ~= "sim") and (vetorTodas.ajudaTTS ~= "nao") then
					vetorTodas.ajudaTTS = padrao.ajudaTTS
				end
			end
			if string.find( vetorTodas[j]:match("([^=]+)="), "TTS desativado" ) ~= nil then
				local aux = nil
				lixo,str = vetorTodas[j]:match("([^=]+)=+([^\13]+)")
				for past in string.gmatch(str, '([a-z]+)') do
					aux = past
				end
				vetorTodas.TTSDesativado = aux
				if (vetorTodas.TTSDesativado ~= "sim") and (vetorTodas.TTSDesativado ~= "nao") then
					vetorTodas.TTSDesativado = padrao.TTSDesativado
				end
			end
			if string.find( vetorTodas[j]:match("([^=]+)="), "Pagina Numero 1" ) then
				local aux = -1
				local aux2 = ""
				lixo,str = vetorTodas[j]:match("([^=]+)=+([^\13]+)")
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
					vetorTodas.primeiraNumeracao = aux
				end
			end
			
			if string.find( vetorTodas[j]:match("([^=]+)="), "corFundo" ) ~= nil then
				vetorTodas.cor = {}
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
			
			if string.find( vetorTodas[j]:match("([^=]+)="), "linguagem" ) ~= nil then
				local aux = nil
				lixo,str = vetorTodas[j]:match("([^=]+)=+([^\13]+)")
				for past in string.gmatch(str, '([a-z_]+)') do
					aux = past
				end
				vetorTodas.linguagem = aux
				if (vetorTodas.linguagem ~= "portugues_br") and (vetorTodas.linguagem ~= "ingles_us") then
					vetorTodas.linguagem = padrao.linguagem
				end
			end
			
			if string.find( vetorTodas[j]:match("([^=]+)="), "Velocidade padrao do TTS" ) then
				local aux = -1
				local aux2 = ""
				lixo,str = vetorTodas[j]:match("([^=]+)=+([^\13]+)")
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
					vetorTodas.VelocidadeTTS = aux
				end
			end
			
			if string.find( vetorTodas[j]:match("([^=]+)="), "contato de bloqueio" ) ~= nil then
				local aux = nil
				lixo,str = vetorTodas[j]:match("([^=]+)=+([^\13]+)")
				for past in string.gmatch(str, '%s+(.+)') do
					aux = past
				end
				vetorTodas.contatoBloqueio = aux
			end
			
			if string.find( vetorTodas[j]:match("([^=]+)="), "link contato" ) ~= nil then
				local aux = nil
				lixo,str = vetorTodas[j]:match("([^=]+)=+([^\13]+)")
				for past in string.gmatch(str, '%s+(.+)') do
					aux = past
				end
				vetorTodas.linkContato = aux
			end
			if string.find( vetorTodas[j]:match("([^=]+)="), "vozTTS" ) ~= nil then
				local aux = nil
				lixo,str = vetorTodas[j]:match("([^=]+)=+([^\13]+)")
				for past in string.gmatch(str, '%s+(.+)') do
					aux = past
				end
				vetorTodas.vozTTS = aux
			end
			if string.find( vetorTodas[j]:match("([^=]+)="), "tipoTTS" ) ~= nil then
				local aux = nil
				lixo,str = vetorTodas[j]:match("([^=]+)=+([^\13]+)")
				for past in string.gmatch(str, '%s+(.+)') do
					aux = past
				end
				vetorTodas.tipoTTS = aux
			end
			if string.find( vetorTodas[j]:match("([^=]+)="), "neuralTTS" ) ~= nil then
				local aux = nil
				lixo,str = vetorTodas[j]:match("([^=]+)=+([^\13]+)")
				for past in string.gmatch(str, '%s+(.+)') do
					aux = past
				end
				vetorTodas.TTSNeural = aux
			end
		end
	end

	return vetorTodas
end

function M.LimparTemporaryDirectory()
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

function M.LimparDocumentsDirectory()
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

function M.loadTable( filename, location )
 
    local loc = location
    if not location then
        loc = system.DocumentsDirectory
	elseif location == "res" then
		loc = system.ResourceDirectory
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

function M.moverComLimiteVertical(e)
	if e.phase == "began" then
		toqueY = e.y
		targetY = e.target.y
			
		toqueXX = e.x
		targetXX = e.target.x
		toqueYY = e.y
		targetYY = e.target.y
	end
	if e.phase == "moved" then
		if toqueY then
			e.target.y = e.y - toqueY + targetY
			if e.target.y > -display.contentHeight/2 then
				e.target.y = -display.contentHeight/2
			end
			
			if system.getInfo("platform") == "win32" then
				numero = varGlobal.numeroWin
			end
			if e.target.y < e.target.yInicial - e.target.height + 100+display.contentHeight/2 then
				e.target.y = e.target.yInicial - e.target.height+ 100+display.contentHeight/2
			end
			if e.target.height < e.target.limiteV-display.contentHeight/2 then
				e.target.y = -display.contentHeight/2
			end
		end

	end
	if e.phase == "ended" then
		if e.target.height- 100 < e.target.limiteV and system.orientation == "portrait" then
			--e.target.y = -display.contentHeight/2
		end
	end
	return true
end

function M.naoVazio(s)
  return s ~= nil or s ~= ''
end

function M.onMouseEventRolagem( event,objeto,funcExt )
    if event.type == "scroll" then
        if event.scrollY < 0 then
            objeto.y = objeto.y - 200
			funcExt()
        elseif event.scrollY > 0 then
            objeto.y = objeto.y + 200
			funcExt()
        end
    end
end

function M.overwriteTable( t, filename, location )
 
    local loc = location
    if not location then
        loc = system.DocumentsDirectory
	elseif location == "res" then
		loc = system.ResourceDirectory
    end
 
    -- Path for the file to write
	local path = system.pathForFile(nil,loc)
	if path then path = path .. "/" .. filename end
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

function M.pausar(tempo)
	local start = os.clock()
	while os.clock() - start < tempo do print(os.clock() - start) end
end

function M.pausarDespausarAnimacao(Var,tipo)
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

function M.pausarDespausarAnimacaoTTS(tipo,animacao)
	if animacao and animacao.som then
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

function M.pegarNumeroPaginaRomanosHistorico(pagina,prePaginas)
	local auxPaginaLivro = tostring(pagina)
	if string.find(auxPaginaLivro,"%-") then
		print("PAGINAAAAA",auxPaginaLivro,prePaginas)
		auxPaginaLivro = auxPaginaLivro + prePaginas
		auxPaginaLivro = M.ToRomanNumerals(string.gsub(auxPaginaLivro,"%-",""))
	else
		auxPaginaLivro = auxPaginaLivro
	end
	return auxPaginaLivro
end

function M.pegarPalavrasEContextos(texto)
	local frases = {}
	local F = {}
	local vetorRetorno = {}
	local textoFrasesTemp = string.gsub(texto,"%?","%?|")
	textoFrasesTemp = string.gsub(textoFrasesTemp,"%.[^%a]","%.|")
	textoFrasesTemp = string.gsub(textoFrasesTemp,"!","!|")
	
	for str in textoFrasesTemp:gmatch("([^|]+)") do
		if #str > 5 then
			table.insert(frases,str)
		end
	end
	textoFrasesTemp = nil
	local vetorPalavrasAux = {}
	local vetorPalavras = {}
	vetorPalavras.link = {}
	vetorPalavras.Tam = {}
	vetorPalavras.Som = {}
	vetorPalavras.Var = {}
	vetorPalavras.Cor = {}
	vetorPalavras.texto = {}
	vetorPalavras.tipo = {}
	for str in texto:gmatch("([^ ]+)") do
		if not string.find(str,"#l%d##/l%d#") and not string.find(str,"#t=%d##/t=%d#") and not string.find(str,"#s##/s#") and not string.find(str,"#n##/n#") and not string.find(str,"#i##/i#")and not string.find(str,"#audio_[^#]+#/audio_[^#]+")and not string.find(str,"#c=%d+,%d+,%d+##/c#")then
			if string.find(str,"|e|") then
				local aux = string.gsub(str,"|e|","  ")
				table.insert(vetorPalavrasAux,aux)
			elseif string.find(str,"|tab|") then
				local aux = string.gsub(str,"|tab|","        ")
				table.insert(vetorPalavrasAux,aux)
			else
				table.insert(vetorPalavrasAux,str)
			end
		end
	end
	--===============================--
	function F.forAuxiliar0(i,limite)
		if string.find(vetorPalavrasAux[i],"#s#(.+)#/s#") or string.find(vetorPalavrasAux[i],"#l%d+#(.+)#/l%d+#") or string.find(vetorPalavrasAux[i],"#n#(.+)#/n#")  or string.find(vetorPalavrasAux[i],"#t=%d+#(.+)#/t=%d+#")  or string.find(vetorPalavrasAux[i],"#i#(.+)#/i#") or string.find(vetorPalavrasAux[i],"#audio_[^#]+(.+)#/audio_[^#]+") or string.find(vetorPalavrasAux[i],"#c=%d+,%d+,%d+#(.+)#/c#")or string.find(vetorPalavrasAux[i],"#Var%a%d+#")then
			local nadaAinda = true
			local textoAUsar = vetorPalavrasAux[i]
			vetorPalavras.tipo[i] = ""
			if string.find(vetorPalavrasAux[i],"#s#(.+)#/s#") then
				vetorPalavras.texto[i] = string.gsub(textoAUsar,"#s#","")
				vetorPalavras.texto[i] = string.gsub(vetorPalavras.texto[i],"#/s#","")
				vetorPalavras.tipo[i] = "sublinhado"
				nadaAinda = false
				textoAUsar = vetorPalavras.texto[i]
			end	
			if string.find(vetorPalavrasAux[i],"#n#(.+)#/n#") then
				vetorPalavras.texto[i] = string.gsub(textoAUsar,"#n#","")
				vetorPalavras.texto[i] = string.gsub(vetorPalavras.texto[i],"#/n#","")
				vetorPalavras.tipo[i] = vetorPalavras.tipo[i] .. "negrito"
				nadaAinda = false
				textoAUsar = vetorPalavras.texto[i]
				print("textoAUsar = ",textoAUsar)
			end	
			if string.find(vetorPalavrasAux[i],"#i#(.+)#/i#") then
				vetorPalavras.texto[i] = string.gsub(textoAUsar,"#i#","")
				vetorPalavras.texto[i] = string.gsub(vetorPalavras.texto[i],"#/i#","")
				vetorPalavras.tipo[i] = vetorPalavras.tipo[i] .. "italico"
				nadaAinda = false
				textoAUsar = vetorPalavras.texto[i]
			end	
			if string.find(vetorPalavrasAux[i],"#l%d+#(.+)#/l%d+#") then
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
			if string.find(vetorPalavrasAux[i],"#t=%d+#(.+)#/t=%d+#") then
				local auxT,auxT2 = string.find(textoAUsar,"#t=%d+#")
				local aux = string.sub(textoAUsar,auxT,auxT2)
				local nTamT = string.match(aux,"%d+")
				
				vetorPalavras.texto[i] = string.gsub(textoAUsar,"#t=%d+#","")
				vetorPalavras.texto[i] = string.gsub(vetorPalavras.texto[i],"#/t=%d+#","")
				vetorPalavras.tipo[i] = vetorPalavras.tipo[i] .. "tamanho"
				
				vetorPalavras.Tam[i] = tonumber(nTamT)*1.5
			end
			if string.find(vetorPalavrasAux[i],"#audio_[^#]+(.+)#/audio_[^#]+") then
				local auxSom,auxSom2 = string.find(textoAUsar,"#audio_[^#]+")
				local aux = string.sub(textoAUsar,auxSom,auxSom2)
				local nSom = string.match(aux,"#audio_[^#]+")
				nSom = string.gsub(nSom,"#audio_","")
				
				vetorPalavras.texto[i] = string.gsub(textoAUsar,"#audio_[^#]+#","") -- retirando os códigos do texto
				vetorPalavras.texto[i] = string.gsub(vetorPalavras.texto[i],"#/audio_[^#]+#","")
				vetorPalavras.tipo[i] = vetorPalavras.tipo[i] .. "audio"
				vetorPalavras.Som[i] = nSom
			end

			if string.find(vetorPalavrasAux[i],"#c=%d+,%d+,%d+#(.+)#/c#") then
				print("vetorPalavrasAux[i]",vetorPalavrasAux[i])
				print("Veio aqui",vetorPalavrasAux[i])
				local auxCor,auxCor2 = string.find(textoAUsar,"#c=%d+,%d+,%d+#")
				local aux = string.sub(textoAUsar,auxCor,auxCor2)
				local nCor1,nCor2,nCor3 = string.match(aux,"(%d+),(%d+),(%d+)")
				
				vetorPalavras.texto[i] = string.gsub(textoAUsar,"#c=%d+,%d+,%d+#","")
				vetorPalavras.texto[i] = string.gsub(vetorPalavras.texto[i],"#/c#","")
				vetorPalavras.tipo[i] = vetorPalavras.tipo[i] .. "corPalavras"
				vetorPalavras.Cor[i] = {nCor1/255,nCor2/255,nCor3/255}
			end
			if string.find(vetorPalavrasAux[i],"#Var%a%d+#") then
				local auxVar,auxVar2 = string.find(textoAUsar,"#Var%a%d+#")
				local aux = string.sub(textoAUsar,auxVar,auxVar2)
				local nVar = string.match(aux,"%d+")
				local tVar = string.sub(aux,4,4)
				local Nrandomico = nil
				local varEscolhida= "(vazio)" 

				vetorPalavras.texto[i] = string.gsub(textoAUsar,"#Var%a%d+#",varEscolhida)
				vetorPalavras.tipo[i] = vetorPalavras.tipo[i] .. "variável"
				vetorPalavras.Var[i] = tonumber(nLinkL)
				if vetorPalavras.link[i] == 0 then
					vetorPalavras.link[i] = 1
				end
			end
		else
			vetorPalavras.texto[i] = vetorPalavrasAux[i]
			vetorPalavras.tipo[i] = "normal"
		end
	
		F.rodarLoopFor0(i+1,limite)
	end
	function F.rodarLoopFor0(i,limite)
		if i<=limite then F.forAuxiliar0(i,limite); end
	end
	F.rodarLoopFor0(1,#vetorPalavrasAux)
	--===============================--
	--
	--===============================--
	local contadorFrases = 1
	function F.forAuxiliar0(i,limite)
		local contexto = frases[contadorFrases]
		
		table.insert(vetorRetorno,{vetorPalavras.texto[i],contexto})
		
		local lastChar = string.sub(vetorPalavras.texto[i],#vetorPalavras.texto[i],#vetorPalavras.texto[i])
		if lastChar == "." or lastChar == "!" or lastChar == "?" or string.find(vetorPalavras.texto[i],"%.[^%a]") then
			contadorFrases = contadorFrases + 1
		end
		F.rodarLoopFor0(i+1,limite)
	end
	function F.rodarLoopFor0(i,limite)
		if i<=limite then F.forAuxiliar0(i,limite); end
	end
	F.rodarLoopFor0(1,#vetorPalavras.texto)
	--===============================--
	return vetorRetorno
end

function M.restoreNativeScreenElements(Var)
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

function M.RGBdetectAndTransformTo1(colors)
	if colors[1] + colors[2] + colors[3] > 3 then
		colors[1] = colors[1]/255
		colors[2] = colors[2]/255
		colors[3] = colors[3]/255
	end
	return colors
end

function M.saveTable( t, filename, location )
 
    local loc = location
    if not location then
        loc = system.DocumentsDirectory
	elseif location == "res" then
		loc = system.ResourceDirectory
    end
 
    -- Path for the file to write
	local path = system.pathForFile(nil,loc)
	
	if path then path = path .. "/" .. filename end
    -- Open the file handle
    local file, errorString = io.open( path, "w+" )
 
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

function M.SecondsToClock(seconds)
  local seconds = tonumber(seconds)
	
  if not seconds or seconds <= 0 then
	return "00:00";
  else
	hours = string.format("%02.f", math.floor(seconds/3600));
	mins = string.format("%02.f", math.floor(seconds/60 - (hours*60)));
	secs = string.format("%02.f", math.floor(seconds - hours*3600 - mins *60));
	return --[[hours..":"..]]mins..":"..secs
  end
end

function M.stopAllButOne( keep )
   for i = 1, audio.totalChannels do
      if( i ~= keep ) then 
         audio.stop(i)
      end
   end
end

function M.stopAllSounds()
   for i = 1, audio.totalChannels do
      audio.stop(i)
   end
end

function M.TelaProtetiva()
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

function M.TelaAguarde()
	local grupoAguarde = display.newGroup()
	grupoAguarde.telaPreta = display.newRect(0,0,W,H)
	grupoAguarde.telaPreta.anchorX = 0.5; grupoAguarde.telaPreta.anchorY = 0.5
	grupoAguarde.telaPreta.anchorX = 0.5; grupoAguarde.telaPreta.anchorY = 0.5
	grupoAguarde.telaPreta.x = W/2; grupoAguarde.telaPreta.y = H/2
	grupoAguarde.telaPreta:setFillColor(1,1,1)
	grupoAguarde.telaPreta.alpha=0.9
	grupoAguarde.telaPreta:addEventListener("tap",function() return true end)
	grupoAguarde.telaPreta:addEventListener("touch",function() return true end)
	grupoAguarde.texto = display.newText("Aguarde",W/2,H/2,"Fontes/segoeuib.ttf",50)
	grupoAguarde.texto:setFillColor(0,0,0)
	grupoAguarde:insert(grupoAguarde.telaPreta)
	grupoAguarde:insert(grupoAguarde.texto)
	return grupoAguarde
end

function M.TelaAguardeGerarAudio()
	local grupoAguarde = display.newGroup()
	grupoAguarde.telaPreta = display.newRect(0,0,W,H)
	grupoAguarde.telaPreta.anchorX = 0.5; grupoAguarde.telaPreta.anchorY = 0.5
	grupoAguarde.telaPreta.anchorX = 0.5; grupoAguarde.telaPreta.anchorY = 0.5
	grupoAguarde.telaPreta.x = W/2; grupoAguarde.telaPreta.y = H/2
	grupoAguarde.telaPreta.x = W/2; grupoAguarde.telaPreta.y = H/2
	grupoAguarde.telaPreta:setFillColor(1,1,1)
	grupoAguarde.telaPreta.alpha=0.9
	grupoAguarde.telaPreta:addEventListener("tap",function() return true end)
	grupoAguarde.telaPreta:addEventListener("touch",function() return true end)
	grupoAguarde.texto = display.newText("gerando áudio",W/2,H/2,W,0,"Fontes/segoeuib.ttf",50)
	grupoAguarde.texto:setFillColor(0,0,0)
	grupoAguarde:insert(grupoAguarde.telaPreta)
	grupoAguarde:insert(grupoAguarde.texto)
	return grupoAguarde
end

function M.testarNoAndroid(texto,posicaoy)
	texto = display.newText(texto,0,posicaoy,W,0,native.systemFont,15)
	texto.anchorX = 0;texto.anchorY = 0
	texto.x=0
	texto:setFillColor(1,0,0)
	return texto
end

function M.tirarAExtencao(str)
	local inverso = string.reverse(str)
	local inversoReduzidoNome = string.sub( inverso, 5 )
	local nome = string.reverse(inversoReduzidoNome)
	return nome
end

function M.tirarAExtencao(str)
	local inverso = string.reverse(str)
	local inversoReduzidoNome = string.sub( inverso, 5 )
	local nome = string.reverse(inversoReduzidoNome)
	return nome
end

function M.toBinary(atrib)
	local tipo = atrib.type
	local bytes = atrib.byte or {}
	local arquivo = atrib.arquivo
    
	local path = system.pathForFile(nil,system.ResourceDirectory)
	path = path .. "/" .. arquivo
	if arquivo then
		local file,errorString = io.open(path,"wb")
		if file then
			M.writebyn(str,fh)
		end
	end
end

function M.ToRomanNumerals(s)
	-- NUMERAIS ROMANOS --
	
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

function M.ToNumber(s)
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

function M.verificarComentario(texto)
	if type(texto) == "string" and #texto >= 2 then
		local comment = string.match(texto,"%s*(.+)")
		comment = string.sub(comment,1,2)
		if comment == "//" then
			texto = "a=a"
		end
	end
	return texto
end

function M.verificarERetirarBarraStatusSystem()
	if system.getInfo( "androidApiLevel" ) and system.getInfo( "androidApiLevel" ) <= 19 then 
		native.setProperty( "androidSystemUiVisibility", "lowProfile" ) 
	else
		native.setProperty( "androidSystemUiVisibility", "immersiveSticky" ) 
	end
end

function M.verificarNumeroPaginaRomanosHistorico(pagina,paginasAntesZero)
	local auxPaginaLivro = tostring(pagina)
	if string.find(auxPaginaLivro,"%-") then
		auxPaginaLivro = auxPaginaLivro + paginasAntesZero+1
		auxPaginaLivro = M.ToRomanNumerals(string.gsub(auxPaginaLivro,"%-",""))
	else
		auxPaginaLivro = auxPaginaLivro
	end
	return auxPaginaLivro
end

function M.verificarQuestoesEPaginasBloqueadas(data)
	local vetor = {}
	if data.paginas_bloqueadas then
		vetor = {}
		for pagina in string.gmatch(data.paginas_bloqueadas,"%d+") do
			table.insert(vetor,{pagina,data.senhaDesbloqueio})
		end
		M.saveTable( vetor, "paginas_bloqueadas.json" )
	end
	if data.questoes_bloqueadas then
		vetor = {}
		for pagina in string.gmatch(data.questoes_bloqueadas,"%d+") do
			table.insert(vetor,{pagina,data.senhaDesbloqueio})
		end
		M.saveTable( vetor, "questoes_bloqueadas.json" )
	end
	vetor = nil
end

function M.writebyn(str,fh)
	local b = tonumber(str)
	local c = string.char(b)
	fh:write(c)
end

-- o zoom vai para a variável "event.target.img" ou a normal
function M.zoomArquivo( event )
	local scale
	local result = true
	local girado = "portrait"
	if event.target.img then
		event.target = event.target.img
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
			event.target.startX=event.x
			event.target.startY=event.y
			
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
					local deltaX = event.target.prevX+event.x - event.target.startX
					local deltaY = event.target.prevY+event.y - event.target.startY
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
				if event.target.startY then

					--event.target.y = (event.x - startX)/varGlobal.aspectRatio + event.target.prevY
					
					--event.target.x = -(event.y - startY)/varGlobal.aspectRatio + event.target.prevX
				end
			elseif system.orientation == "landscapeRight" then
				if event.target.startY then
					--event.target.y = -(event.x - startX)/varGlobal.aspectRatio + event.target.prevY
					
					--event.target.x = (event.y - startY)/varGlobal.aspectRatio + event.target.prevX
				end
			else
				if event.target.startY then
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
				if (math.abs(event.target.startX-event.x)<12) and (math.abs(event.target.startY-event.y)<12) and (not isMulti) then submitTouch(event.x,event.y) end
				event.target.prevX = event.target.x
				event.target.prevY = event.target.y

				----------------------------
			end

		end
	end
	return true
end

return M

