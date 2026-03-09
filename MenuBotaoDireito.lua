local W = display.contentWidth
local H = display.contentHeight

local  M = {}
local widget = require("widget")

local function New(atribs)
	local vectProtetivo = display.newGroup()
	local vect = display.newGroup()
	if not atribs then atribs = {} end
	print(1)
	vect.rowHeightGeneric = atribs.rowHeightGeneric or 30
	vect.rowWidthGeneric = atribs.rowWidthGeneric or 100
	vect.shape = atribs.shape or nil
	vect.imagem = atribs.imagem or nil
	vect.tamanhoTexto = atribs.tamanhoTexto or 20
	vect.fonteTexto = atribs.fonteTexto or native.systemFont
	vect.closeListener = atribs.closeListener or nil
	vect.telaProtetivaAtivada = atribs.telaProtetiva or "sim"
	print(2)
	vect.escolhas = atribs.escolhas or {
											{
											iconeEsq =  {imagem = nil,alt = 20,larg = 20},
											iconeDir =  {imagem = nil,alt = 20,larg = 20},
											texto = "opção 1",
											fonte = vect.fonteTexto,
											tamanho = vect.tamanhoTexto,
											listener = function() print("rodou opção 1") end,
											barraInf = {imagem = nil,alt = 0,larg = 0},
											barraSup = {imagem = nil,alt = 0,larg = 0},
											rowHeight = vect.rowHeightGeneric,
											rowWidth = vect.rowWidthGeneric,
											corTexto = {0,0,0},
											cor = {1,1,1},
											juntoAnterior = false
											},
											{
											iconeEsq =  {imagem = nil,alt = 20,larg = 20},
											iconeDir =  {imagem = nil,alt = 20,larg = 20},
											texto = "opção 2",
											tamanho = vect.tamanhoTexto,
											fonte = vect.fonteTexto,
											listener = function() print("rodou opção 2") end,
											barraInf = {imagem = nil,alt = 0,larg = 0},
											barraSup = {imagem = nil,alt = 0,larg = 0},
											rowHeight = vect.rowHeightGeneric,
											rowWidth = vect.rowWidthGeneric,
											corTexto = {0,0,0},
											cor = {.2,.2,.2},
											juntoAnterior = false
											},
										}
									
	
	vect.opcao = {}	
	print(3)	
	function vect.forAuxiliar(i,limite)
		
		vect.escolhas[i].iconeEsq = vect.escolhas[i].iconeEsq or {imagem = nil,alt = 0,larg = 0}
		
		vect.escolhas[i].iconeEsq.imagem = vect.escolhas[i].iconeEsq.imagem or nil
		
		vect.escolhas[i].iconeDir = vect.escolhas[i].iconeDir or {imagem = nil,alt = 0,larg = 0}
		vect.escolhas[i].iconeDir.imagem = vect.escolhas[i].iconeDir.imagem or nil
		
		vect.escolhas[i].texto = vect.escolhas[i].texto or "opção "..i
		vect.escolhas[i].fonte = vect.escolhas[i].fonte or vect.fonteTexto
		vect.escolhas[i].tamanho = vect.escolhas[i].tamanho or vect.tamanhoTexto
		vect.escolhas[i].listener = vect.escolhas[i].listener or function() print("rodou opção "..i) end
		vect.escolhas[i].barraInf = vect.escolhas[i].barraInf or {imagem = nil,alt = 0,larg = 0}
		vect.escolhas[i].barraInf.imagem = vect.escolhas[i].barraInf.imagem or nil
		vect.escolhas[i].barraInf.alt = vect.escolhas[i].barraInf.alt or nil
		vect.escolhas[i].barraInf.larg = vect.escolhas[i].barraInf.larg or nil
		vect.escolhas[i].barraSup = vect.escolhas[i].barraSup or {imagem = nil,alt = 0,larg = 0}
		vect.escolhas[i].barraSup.imagem = vect.escolhas[i].barraSup.imagem or nil
		vect.escolhas[i].barraSup.alt = vect.escolhas[i].barraSup.alt or nil
		vect.escolhas[i].barraSup.larg = vect.escolhas[i].barraSup.larg or nil
		vect.escolhas[i].rowHeight = vect.escolhas[i].rowHeight or vect.rowHeightGeneric
		vect.escolhas[i].rowWidth = vect.escolhas[i].rowWidth or vect.rowWidthGeneric
		vect.escolhas[i].corTexto = vect.escolhas[i].corTexto or {0,0,0}
		vect.escolhas[i].cor = vect.escolhas[i].cor or {1,1,1}
		vect.escolhas[i].juntoAnterior = vect.escolhas[i].juntoAnterior or false
		vect.escolhas[i].iconeEsq.alt = vect.escolhas[i].iconeEsq.alt or vect.escolhas[i].rowHeight
		vect.escolhas[i].iconeEsq.larg = vect.escolhas[i].iconeEsq.larg or vect.escolhas[i].iconeEsq.alt
		vect.escolhas[i].iconeDir.alt = vect.escolhas[i].iconeDir.alt or vect.escolhas[i].rowHeight
		vect.escolhas[i].iconeDir.larg = vect.escolhas[i].iconeDir.larg or vect.escolhas[i].iconeDir.alt
		vect.escolhas[i].params = vect.escolhas[i].params or nil
		
		vect.opcao[i] = display.newRect(vect,0,0,vect.escolhas[i].rowWidth,vect.escolhas[i].rowHeight)
		vect.opcao[i].anchorX=0; vect.opcao[i].anchorY=0
		vect.opcao[i]:setFillColor(vect.escolhas[i].cor[1],vect.escolhas[i].cor[2],vect.escolhas[i].cor[3])
		vect.opcao[i].i = i
		if i > 1 then
			vect.opcao[i].y = vect.opcao[i-1].y + vect.opcao[i-1].height
			if vect.escolhas[i].juntoAnterior == true  then
				vect.opcao[i].y = vect.opcao[i-1].y
			end
		end
		if vect.escolhas[i].params then
			vect.opcao[i].params = vect.escolhas[i].params
		end
		vect.opcao[i]:addEventListener("touch",function() return true; end)
		vect.opcao[i]:addEventListener("tap",function(e) vect.escolhas[i].listener(e); return true; end)
		
		local distImDir = 0
		local distImEsq = 0
		local distanciaEsq = 5
		local distanciaDir = 0
		
		
		
		if vect.escolhas[i].iconeEsq.imagem then -- adicionando texto se houver
		
			vect.opcao[i].iconeEsq = display.newImage(vect,vect.escolhas[i].iconeEsq.imagem,vect.opcao[i].x + distanciaEsq,vect.opcao[i].y+ vect.opcao[i].height/2)
			vect.opcao[i].iconeEsq.width = vect.escolhas[i].iconeEsq.larg
			vect.opcao[i].iconeEsq.height = vect.escolhas[i].iconeEsq.alt
			vect.opcao[i].iconeEsq.anchorX=0
			local proporcao = vect.escolhas[i].iconeEsq.alt/vect.escolhas[i].iconeEsq.larg
			
			while vect.opcao[i].iconeEsq.width > vect.opcao[i].width - 1 - distanciaEsq do
				vect.opcao[i].iconeEsq.width = vect.opcao[i].iconeEsq.width-1
			end
			while vect.opcao[i].iconeEsq.height > vect.opcao[i].height -1 do
				vect.opcao[i].iconeEsq.height = vect.opcao[i].iconeEsq.height-1
			end
			
			vect.opcao[i].iconeEsq.width = vect.opcao[i].iconeEsq.height/proporcao
			
			distanciaEsq = distanciaEsq + 5
		end
		
		if vect.opcao[i].iconeEsq and vect.opcao[i].iconeEsq.width then
			distImEsq = vect.opcao[i].iconeEsq.width
		end
		
		if vect.escolhas[i].iconeDir.imagem then -- adicionando texto se houver
		
			vect.opcao[i].iconeDir = display.newImage(vect,vect.escolhas[i].iconeDir.imagem,vect.opcao[i].x + vect.opcao[i].width - 5,vect.opcao[i].y+ vect.opcao[i].height/2)
			vect.opcao[i].iconeDir.width = vect.escolhas[i].iconeDir.larg
			vect.opcao[i].iconeDir.height = vect.escolhas[i].iconeDir.alt
			vect.opcao[i].iconeDir.anchorX=1
			print("antes")
			print(vect.opcao[i].iconeDir.height)
			print(vect.opcao[i].iconeDir.width)
			local proporcao = vect.escolhas[i].iconeDir.alt/vect.escolhas[i].iconeDir.larg
			
			while vect.opcao[i].iconeDir.width > vect.opcao[i].width - 1 - distanciaEsq - distImEsq - 5 do
				vect.opcao[i].iconeDir.width = vect.opcao[i].iconeDir.width-1
			end
			while vect.opcao[i].iconeDir.height > vect.opcao[i].height -1 do
				vect.opcao[i].iconeDir.height = vect.opcao[i].iconeDir.height-1
			end
			
			vect.opcao[i].iconeDir.width = vect.opcao[i].iconeDir.height/proporcao
			if vect.escolhas[i].texto == "" then
				vect.opcao[i].iconeDir.x = vect.opcao[i].iconeDir.x + 5
				vect.opcao[i].iconeDir.y = vect.opcao[i].y + vect.opcao[i].iconeDir.height/2
			end
			
			
			distanciaDir = distanciaDir + 5 + 3
		end
		
		
		if vect.opcao[i].iconeDir and vect.opcao[i].iconeDir.width then
			distImDir = vect.opcao[i].iconeDir.width
		end
		
		if vect.escolhas[i].texto then -- adicionando texto se houver
			
			vect.opcao[i].texto = display.newText(vect,vect.escolhas[i].texto,vect.opcao[i].x + distImEsq + distanciaEsq,vect.opcao[i].y+ vect.opcao[i].height/2,"Fontes/times.ttf",vect.escolhas[i].tamanho)
			vect.opcao[i].texto.anchorX=0
			vect.opcao[i].texto:setFillColor(vect.escolhas[i].corTexto[1],vect.escolhas[i].corTexto[2],vect.escolhas[i].corTexto[3])
			
			while vect.opcao[i].texto.width > vect.opcao[i].width - distImEsq - distImDir - 1 - distanciaEsq - distanciaDir do
				vect.opcao[i].texto.size = vect.opcao[i].texto.size-1
			end
			while vect.opcao[i].texto.height > vect.opcao[i].height -1 do
				vect.opcao[i].texto.size = vect.opcao[i].texto.size-1
			end
			
			
		end
		
		
		vect.rodarLoopFor(i+1,limite)
	end
	function vect.rodarLoopFor(i,limite)
		if i<=limite then vect.forAuxiliar(i,limite); end
	end
	vect.rodarLoopFor(1,#vect.escolhas)
	
	print(4)
	
	---- Criar Efeito Janela --------------------------------------------------------------------------- 
	
	local tamanhoSombra = 9--vect.height/10
	local tamanhoSombraH = 0
	local tamanhoSombraW = vect.opcao[1].width
	for i=1,#vect.opcao do
		tamanhoSombraH = tamanhoSombraH+vect.opcao[i].height
	end
	
	vect.strokeFundo = display.newRoundedRect(vect.x-2,vect.y-2,tamanhoSombraW+2,tamanhoSombraH+2,3)
	vect.strokeFundo.anchorX=0;vect.strokeFundo.anchorY=0
	vect.strokeFundo.strokeWidth = 3
	vect.strokeFundo:setFillColor(vect.escolhas[1].cor[1],vect.escolhas[1].cor[2],vect.escolhas[1].cor[3])
	vect.strokeFundo:setStrokeColor(.3,.3,.3)--((46/225)*.3,(171/225)*.3,(200/225)*.3)
	vect:insert(1,vect.strokeFundo)
	
	vect.fundoJanelaEsq = display.newRect(vect.x-7,vect.y,7,tamanhoSombraH)
	vect.fundoJanelaEsq.anchorX=0;vect.fundoJanelaEsq.anchorY=0
	vect.fundoJanelaEsq.alpha=0.1
	local gradient = {
		type="gradient",
		color1={ 0, 0, 0 }, color2={ 0, 0, 0,0 }, direction="left"
	}
	vect.fundoJanelaEsq:setFillColor( gradient )
	vect:insert(1,vect.fundoJanelaEsq)
	
	vect.fundoJanelaDir = display.newRect(vect.x + tamanhoSombraW,vect.y,7,tamanhoSombraH)
	vect.fundoJanelaDir.anchorX=0;vect.fundoJanelaDir.anchorY=0
	vect.fundoJanelaDir.alpha=0.1
	local gradient = {
		type="gradient",
		color1={ 0, 0, 0 }, color2={ 0, 0, 0,0 }, direction="right"
	}
	vect.fundoJanelaDir:setFillColor( gradient )
	vect:insert(1,vect.fundoJanelaDir)
	
	vect.fundoJanelaDown = display.newRect(vect.x,vect.y+tamanhoSombraH,tamanhoSombraW,tamanhoSombra)
	vect.fundoJanelaDown.anchorX=0;vect.fundoJanelaDown.anchorY=0
	vect.fundoJanelaDown.alpha=0.1
	local gradient = {
		type="gradient",
		color1={ 0, 0, 0 }, color2={ 0, 0, 0,0 }, direction="down"
	}
	vect.fundoJanelaDown:setFillColor( gradient )
	vect:insert(1,vect.fundoJanelaDown)
	
	vect.fundoJanelaUp = display.newRect(vect.x,vect.y-tamanhoSombra,tamanhoSombraW,tamanhoSombra)
	vect.fundoJanelaUp.anchorX=0;vect.fundoJanelaUp.anchorY=0
	vect.fundoJanelaUp.alpha=0.1
	local gradient = {
		type="gradient",
		color1={ 0, 0, 0 }, color2={ 0, 0, 0,0 }, direction="up"
	}
	vect.fundoJanelaUp:setFillColor( gradient )
	vect:insert(1,vect.fundoJanelaUp)
	----------------------------------------------------------------------------------------------------
	
	if vect.telaProtetivaAtivada == "sim" then
		vect.telaProtetiva = display.newRect(0,0,W*2,H*2)
		vect.telaProtetiva.alpha=.2
		vect.telaProtetiva.isHitTestable = true
		vect.telaProtetiva.anchorX=0.5;vect.telaProtetiva.anchorY=0.5
		if vect.closeListener then
			vect.telaProtetiva:addEventListener("tap",function(e) vect:removeSelf();vect.telaProtetiva:removeSelf(); vect.closeListener(e);return true; end)
		else
			vect.telaProtetiva:addEventListener("tap",function(e) vect:removeSelf();vect.telaProtetiva:removeSelf();return true; end)
		end
		vect.telaProtetiva:addEventListener("touch",function() return true; end)
		--vect:insert(1,vect.telaProtetiva)
	end
	
	return vect
end
M.New = New

return M