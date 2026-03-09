local M = {}

local function newSlider(atrib)
	local orientacao = atrib.orientation or "horizontal"
	local largura_barra = tonumber(atrib.barWidth) or 300
	local altura_barra = tonumber(atrib.barHeight) or 45
	local largura_movedor = tonumber(atrib.sliderWidth) or 70
	local altura_movedor = tonumber(atrib.sliderHeight) or 70
	local forma_movedor = atrib.sliderShape or "circle"
	local raio = tonumber(atrib.radius) or 35
	local imagemBarra = atrib.barImage or nil
	local imagemMovedor = atrib.sliderImage or nil
	local corInternaBarra = atrib.barFillColor or {1,1,1,1}
	local corBordaBarra = atrib.barStrokeColor or {0,0,0,1}
	local corInternaMovedor = atrib.sliderFillColor or {1,1,1,1}
	local corBordaMovedor = atrib.sliderStrokeColor or {0,0,0,1}
	local espessuraBordaBarra = atrib.barStrokeWidth or 0
	local espessuraBordaMovedor = atrib.sliderStrokeWidth or 0
	local valor = atrib.value or 100
	local posicaoInicial = atrib.initialPosition or valor/2
	if not corInternaBarra[4] then corInternaBarra[4] = 1 end
	if not corBordaBarra[4] then corBordaBarra[4] = 1 end
	if not corInternaMovedor[4] then corInternaMovedor[4] = 1 end
	if not corBordaMovedor[4] then corBordaMovedor[4] = 1 end
	
	local grupo = display.newGroup()
	if imagemBarra then
		grupo.barra = display.newImageRect(grupo,imagemBarra,largura_barra,altura_barra)
		if not grupo.barra.x then
			grupo.barra = display.newRect(grupo,0,0,largura_barra,altura_barra)
		end
	else
		grupo.barra = display.newRect(grupo,0,0,largura_barra,altura_barra)
	end
	grupo.barra.anchorX=0.5;grupo.barra.anchorY=0.5
	grupo.barra.strokeWidth = espessuraBordaBarra
	grupo.barra:setFillColor(corInternaBarra[1],corInternaBarra[2],corInternaBarra[3],corInternaBarra[4])
	grupo.barra:setStrokeColor(corBordaBarra[1],corBordaBarra[2],corBordaBarra[3],corBordaBarra[4])
	if imagemMovedor then
		grupo.movedor = display.newImageRect(grupo,imagemBarra,largura_movedor,altura_movedor)
		if not grupo.movedor.x then
			if forma == "rect" then
				grupo.movedor = display.newRect(grupo,0,0,largura_movedor,altura_movedor)
			elseif forma == "roundedRect" then
				if not atrib.radius then
					grupo.movedor = display.newRoundedRect(grupo,0,0,largura_movedor,altura_movedor,raio)
				else
					grupo.movedor = display.newRoundedRect(grupo,0,0,largura_movedor,altura_movedor,atrib.radius)
				end
			else
				grupo.movedor = display.newCircle(grupo,0,0,raio)
			end
		end
	else
		if forma_movedor == "rect" then
			grupo.movedor = display.newRect(grupo,0,0,largura_movedor,altura_movedor)
		elseif forma_movedor == "roundedRect" then
			if not atrib.radius then
				grupo.movedor = display.newRoundedRect(grupo,0,0,largura_movedor,altura_movedor,raio)
			else
				grupo.movedor = display.newRoundedRect(grupo,0,0,largura_movedor,altura_movedor,atrib.radius)
			end
		else
			grupo.movedor = display.newCircle(grupo,0,0,raio)
		end
	end
	grupo.movedor.anchorX=0.5;grupo.movedor.anchorY=0.5
	grupo.movedor.strokeWidth = espessuraBordaMovedor
	grupo.movedor:setFillColor(corInternaMovedor[1],corInternaMovedor[2],corInternaMovedor[3],corInternaMovedor[4])
	grupo.movedor:setStrokeColor(corBordaMovedor[1],corBordaMovedor[2],corBordaMovedor[3],corBordaMovedor[4])
	
	local function moverSlider(event)
		if event.phase == "began" then
			display.getCurrentStage():setFocus( event.target, event.id )
			if atrib.onEvent then
				atrib.onEvent(event)
			end
			event.target.X = grupo.movedor.x
			event.target.Y = grupo.movedor.Y
			event.target.inicialX = grupo.movedor.x
			event.target.inicialY = grupo.movedor.y
			event.target.clicouBegan = true
		elseif event.phase == "moved" then
			if event.target.clicouBegan then
				if orientacao == "vertical" then
					if event.y < grupo.barra.y + grupo.y - grupo.barra.height/2 then
						grupo.movedor.y = grupo.barra.y - grupo.barra.height/2
					elseif event.y > grupo.barra.y + grupo.y + grupo.barra.height/2 then
						grupo.movedor.y = grupo.barra.y + grupo.barra.height/2
					else
						grupo.movedor.y = event.y - grupo.y
					end
					local valorLocal = grupo.movedor.y
					event.target.choice = (valorLocal/grupo.barra.height) + 0.5
					if event.x > grupo.barra.x + grupo.barra.width + 50 + grupo.x or
						event.x < grupo.barra.x - grupo.barra.width - 50 + grupo.x then
						display.getCurrentStage():setFocus( event.target, nil )
						grupo.movedor.y = event.target.inicialY
					end
				else
					if event.x < grupo.barra.x + grupo.x - grupo.barra.width/2 then
						grupo.movedor.x = grupo.barra.x - grupo.barra.width/2
					elseif event.x > grupo.barra.x + grupo.x + grupo.barra.width/2 then
						grupo.movedor.x = grupo.barra.x + grupo.barra.width/2
					else
						grupo.movedor.x = event.x - grupo.x
					end
					local valorLocal = grupo.movedor.x
					event.target.choice = (valorLocal/grupo.barra.width) + 0.5
					if event.y > grupo.barra.y + grupo.barra.height + 50 + grupo.y or
						event.y < grupo.barra.y - grupo.barra.height - 50 + grupo.y then
						display.getCurrentStage():setFocus( event.target, nil )
						grupo.movedor.x = event.target.inicialX
					end
				end
				event.target.X = grupo.movedor.x
				event.target.Y = grupo.movedor.Y
				event.target.choice = math.floor(event.target.value*event.target.choice)
				if atrib.onEvent then
					atrib.onEvent(event)
				end
			end
		elseif event.phase == "ended" then
			if orientacao == "vertical" then
				local valorLocal = grupo.movedor.y
				event.target.choice = (valorLocal/grupo.barra.height) + 0.5
			else
				local valorLocal = grupo.movedor.x
				event.target.choice = (valorLocal/grupo.barra.width) + 0.5
			end
			event.target.choice = math.floor(event.target.value*event.target.choice)
			
			display.getCurrentStage():setFocus( event.target, nil )
			event.target.X = grupo.movedor.x
			event.target.Y = grupo.movedor.Y
			if atrib.onEvent then
				atrib.onEvent(event)
			end
			if atrib.onRelease then
				atrib.onRelease(event)
			end
			event.target.clicouBegan = false
			--event.target.choice = event.target.choice - 1
		end
		return true
	end
	
	
	grupo.movedor.choice = 0.5
	grupo.movedor.value = valor
	grupo.movedor.barWidth = grupo.barra.width
	grupo.movedor.barHeight = grupo.barra.height
	grupo.movedor.sliderWidth = grupo.movedor.width
	grupo.movedor.sliderHeight = grupo.movedor.height
	grupo.movedor.X = grupo.movedor.x
	grupo.movedor.Y = grupo.movedor.y
	grupo.movedor.inicialX = grupo.movedor.x
	grupo.movedor.inicialY = grupo.movedor.y
	
	grupo.barra.choice = 0.5
	grupo.barra.value = valor
	grupo.barra.barWidth = grupo.barra.width
	grupo.barra.barHeight = grupo.barra.height
	grupo.barra.sliderWidth = grupo.movedor.width
	grupo.barra.sliderHeight = grupo.movedor.height
	grupo.barra.X = grupo.movedor.x
	grupo.barra.Y = grupo.movedor.y
	grupo.barra.inicialX = grupo.movedor.x
	grupo.barra.inicialY = grupo.movedor.y
	if tonumber(posicaoInicial) then
		local aux1 = tonumber(posicaoInicial)/valor
		local posicao = ((aux1-0.5)*grupo.barra.width)
		grupo.movedor.x = posicao
	end
	grupo.movedor:addEventListener("touch",moverSlider)
	grupo.barra:addEventListener("touch",moverSlider)
	
	function grupo.updatePosition(posicaoInicial)
		if tonumber(posicaoInicial) then
			if orientacao == "vertical" then
				local aux1 = tonumber(posicaoInicial)/valor
				local posicao = ((aux1-0.5)*grupo.barra.height)
				grupo.movedor.y = posicao
				grupo.barra.inicialY = grupo.movedor.y
				grupo.movedor.inicialY = grupo.movedor.y
			else
				local aux1 = tonumber(posicaoInicial)/valor
			
				local posicao = ((aux1-0.5)*grupo.barra.width)
				grupo.movedor.x = posicao
				grupo.barra.inicialX = grupo.movedor.x
				grupo.movedor.inicialX = grupo.movedor.x
			end	
		end
	end
	
	return grupo
end
M.newSlider = newSlider

return M