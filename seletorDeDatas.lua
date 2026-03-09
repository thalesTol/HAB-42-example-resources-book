local M = {}

local widget = require("widget")
local auxFuncs = require("ferramentasAuxiliares")

function M.newPicker(atrib)
	local left = atrib.left or 100 
	local top = atrib.top or 320
	local fontSize = atrib.fontSize or 28
	local width = atrib.width or 400
	local height = atrib.height or 400
	local align = atrib.align or "center"
	local rowHeight = atrib.rowHeight or 30
	local borderSize = atrib.borderSize or 4
	local borderRGBColor = atrib.borderRGBAColor or {0,0,0,0.5}
	local marcador = atrib.marcador or "pickerwheel.png"
	local mask = atrib.mask or "pickerwheelMask.png"
	local backgroundWidth = atrib.backgroundWidth or width
	local backgroundHeight = atrib.backgroundHeight or height
	local diffW,diffH = 0,0
	if backgroundWidth > height then diffW = backgroundWidth - width end
	if backgroundHeight > height then diffH = backgroundHeight - height end
	
	local data = os.date( "*t" )
	local vetorMesesAux = {}
	vetorMesesAux[1] = 31
	vetorMesesAux[2] = 28
	vetorMesesAux[3] = 31
	vetorMesesAux[4] = 30
	vetorMesesAux[5] = 31
	vetorMesesAux[6] = 30
	vetorMesesAux[7] = 31
	vetorMesesAux[8] = 31
	vetorMesesAux[9] = 30
	vetorMesesAux[10] = 31
	vetorMesesAux[11] = 30
	vetorMesesAux[12] = 31

	local vetorDiasAux1 = {"01","02","03","04","05","06","07","08","09","10","11","12","13","14","15","16","17","18","19","20","21","22","23","24","25","26","27","28","29","30"}
	local vetorDiasAux2 = {"01","02","03","04","05","06","07","08","09","10","11","12","13","14","15","16","17","18","19","20","21","22","23","24","25","26","27","28","29","30","31"}
	local vetorDiasAuxF1 = {"01","02","03","04","05","06","07","08","09","10","11","12","13","14","15","16","17","18","19","20","21","22","23","24","25","26","27","28"}
	local vetorDiasAuxF2 = {"01","02","03","04","05","06","07","08","09","10","11","12","13","14","15","16","17","18","19","20","21","22","23","24","25","26","27","28","29"}
	local vetorMeses = {"01","02","03","04","05","06","07","08","09","10","11","12"}
	
	
	local anoMax = tonumber(data.year)
	local anomMin = 2017
	local anoTotal = anoMax - anomMin
	local anoBissexto = auxFuncs.checarBissexto(anoMax)
	local vetorAnos = {}
	for i=0,anoTotal do
		table.insert(vetorAnos,anomMin+i)
	end
	
	local vetorMesesAux2 = {}
	vetorMesesAux2[1] = vetorDiasAux2

	vetorMesesAux2[3] = vetorDiasAux2
	vetorMesesAux2[4] = vetorDiasAux1
	vetorMesesAux2[5] = vetorDiasAux2
	vetorMesesAux2[6] = vetorDiasAux1
	vetorMesesAux2[7] = vetorDiasAux2
	vetorMesesAux2[8] = vetorDiasAux2
	vetorMesesAux2[9] = vetorDiasAux1
	vetorMesesAux2[10] = vetorDiasAux2
	vetorMesesAux2[11] = vetorDiasAux1
	vetorMesesAux2[12] = vetorDiasAux2
	if anoBissexto then
		vetorMesesAux2[2] = vetorDiasAuxF2
	else
		vetorMesesAux2[2] = vetorDiasAuxF1
	end
	
	local vetorDias = vetorDiasAuxF1
	if vetorMesesAux[tonumber(data.month)] == 30 then
		vetorDias = vetorDiasAux1
	elseif vetorMesesAux[tonumber(data.month)] == 31 then
		vetorDias = vetorDiasAux2
	else
		vetorDias = vetorMesesAux2[2]
	end
	
	
	
	
	local grupo = display.newGroup()
	
	grupo.nRowsDiaMesAno = {#vetorDias,#vetorMeses,#vetorAnos}
	grupo.areaDeEscolha = {height/2 - rowHeight/2,height/2 + rowHeight/2}
	
	local rowSelecionadaDiaMesAno = {1,1,1}
	-- detectar diaMesAno atual e selecionar na row.
	for i=1,#vetorDias do
		if tonumber(vetorDias[i]) == tonumber(data.day) then
			rowSelecionadaDiaMesAno[1] = tonumber(vetorDias[i])
			
		end
	end
	for i=1,#vetorMeses do
		if tonumber(vetorMeses[i]) == tonumber(data.month) then
			rowSelecionadaDiaMesAno[2] = tonumber(vetorMeses[i])
			
		end
	end
	for i=1,#vetorAnos do
		
		if tonumber(vetorAnos[i]) == tonumber(data.year) then
			print("checando ano",i,vetorAnos[i],data.year)
			rowSelecionadaDiaMesAno[3] = tonumber(vetorAnos[i])
			
		end
	end
	grupo.chosenDay = rowSelecionadaDiaMesAno[1]
	grupo.chosenMonth = rowSelecionadaDiaMesAno[2]
	grupo.chosenYear = rowSelecionadaDiaMesAno[3]
	------------------------------------------------
	
	
	grupo.createAllRows = function(tableView,vetor)
		if vetor and #vetor > 0 then
			local indexTipo = 1
			if tableView.tipo == "dia" then indexTipo = 1 
			elseif tableView.tipo == "mes" then indexTipo = 2 
			elseif tableView.tipo == "ano" then indexTipo = 3 end
			local heightDiff = height/rowHeight
			local heightAux = (height/heightDiff)/2 + height/3
			for i=0,#vetor+1 do
				if i<1 or i>#vetor then
					tableView:insertRow{rowHeight = heightAux,params = {result = "",tipo = tableView.tipo}}
				else
					tableView:insertRow{rowHeight = rowHeight,params = {result = vetor[i],tipo = tableView.tipo}}
					print(tableView.tipo,i,indexTipo,rowSelecionadaDiaMesAno[indexTipo])
					if i == rowSelecionadaDiaMesAno[indexTipo] or i + anomMin - 1 == rowSelecionadaDiaMesAno[indexTipo] then
						tableView:scrollToY({ y=(-1)*((i-1)*(rowHeight)), time=0 })
					end
				end
			end
		end
	end
	grupo.selecionarEMover = function(event)
		if event.phase == "stopped" then
			
			print("stopped")
			if not grupo.escolheu then
				print("não escolheu")
				local tipo = grupo.tipoMovido
				grupo.tipoMovido = nil
				if event.target.params then
					tipo = event.target.params.tipo
				elseif event._targetRow then
					tipo = event.target._targetRow.params.tipo
				end
				print("tipo",tipo)
				auxFuncs.saveTable(event,"eventoStopped.json")
				if tipo then
					local anoBissexto = auxFuncs.checarBissexto(grupo.chosenYear)
					if anoBissexto then
						vetorMesesAux2[2] = vetorDiasAuxF2
					else
						vetorMesesAux2[2] = vetorDiasAuxF1
					end
					print(event.limitReached,event.direction)
					if event.target._hasHitBottomLimit then
						if tipo and tipo == "dia" then
							grupo.tableDias:scrollToY({ y=0, time=0 })
							grupo.chosenDay= 1
							print("Selecionado = "..grupo.tableDias._view._rows[grupo.chosenDay+1]._view.params.result)
							grupo.chosenDay = grupo.tableDias._view._rows[grupo.chosenDay+1]._view.params.result
						elseif tipo and tipo == "mes" then
							grupo.tableMes:scrollToY({ y=0, time=0 })
							grupo.chosenMonth = 1
							print("Selecionado = "..grupo.tableMes._view._rows[grupo.chosenMonth+1]._view.params.result)
							grupo.chosenMonth = grupo.tableMes._view._rows[grupo.chosenMonth+1]._view.params.result
							if vetorMesesAux[tonumber(grupo.chosenMonth)] == 30 then
								vetorDias = vetorDiasAux1
							elseif vetorMesesAux[tonumber(grupo.chosenMonth)] == 31 then
								vetorDias = vetorDiasAux2
							else
								vetorDias = vetorMesesAux2[2]
							end
							if tonumber(grupo.chosenDay) > tonumber(vetorDias[#vetorDias]) then
								grupo.chosenDay = vetorDias[#vetorDias]
							end
							if #vetoDiaAux ~= #vetorDias then
								-- atualizar table dias
								grupo.tableDias:deleteAllRows()
								grupo.createAllRows(grupo.tableDias,vetorDias)
							end
						elseif tipo and tipo == "ano" then
							grupo.tableAno:scrollToY({ y=0, time=0 })
							grupo.chosenYear = 1
							auxFuncs.saveTable(grupo.tableAno,"eventoAno.json")
							print("Selecionado = "..grupo.tableAno._view._rows[grupo.chosenYear+1]._view.params.result)
							grupo.chosenYear = grupo.tableAno._view._rows[grupo.chosenYear+1]._view.params.result
							local anoBissexto = auxFuncs.checarBissexto(grupo.chosenYear)
							if anoBissexto then
								vetorMesesAux2[2] = vetorDiasAuxF2
							else
								vetorMesesAux2[2] = vetorDiasAuxF1
							end
							if grupo.chosenMonth == "02" then
								vetorDias = vetorMesesAux2[2]
								if tonumber(grupo.chosenDay) > tonumber(vetorDias[#vetorDias]) then
									grupo.chosenDay = vetorDias[#vetorDias]
								end
								if #vetoDiaAux ~= #vetorDias then
									-- atualizar table dias
									grupo.tableDias:deleteAllRows()
									grupo.createAllRows(grupo.tableDias,vetorDias)
								end
							end
						end
					elseif event.target._hasHitTopLimit then
						if tipo and tipo == "dia" then
							local posIndex1 = grupo.tableDias._view._rows[1]._height
							local posAux = (-1)*((grupo.tableDias:getNumRows()-1-2)*rowHeight + posIndex1)
							
							grupo.tableDias:scrollToY({ y=posAux+posIndex1, time=100 })
							
							grupo.chosenDay= grupo.tableDias:getNumRows()-2
							print("Selecionado = "..grupo.tableDias._view._rows[grupo.chosenDay+1]._view.params.result)
							grupo.chosenDay = grupo.tableDias._view._rows[grupo.chosenDay+1]._view.params.result
						elseif tipo and tipo == "mes" then
							local posIndex1 = grupo.tableMes._view._rows[1]._height
							local posAux = (-1)*((grupo.tableMes:getNumRows()-1-2)*rowHeight + posIndex1)
							
							grupo.tableMes:scrollToY({ y=posAux+posIndex1, time=100 })
							
							grupo.chosenMonth = grupo.tableMes:getNumRows()-2
							print("Selecionado = "..grupo.tableMes._view._rows[grupo.chosenMonth+1]._view.params.result)
							grupo.chosenMonth = grupo.tableMes._view._rows[grupo.chosenMonth+1]._view.params.result
							if vetorMesesAux[tonumber(grupo.chosenMonth)] == 30 then
								vetorDias = vetorDiasAux1
							elseif vetorMesesAux[tonumber(grupo.chosenMonth)] == 31 then
								vetorDias = vetorDiasAux2
							else
								vetorDias = vetorMesesAux2[2]
							end
							print(tonumber(grupo.chosenDay),tonumber(vetorDias[#vetorDias]),#vetorDias)
							if tonumber(grupo.chosenDay) > tonumber(vetorDias[#vetorDias]) then
								grupo.chosenDay = vetorDias[#vetorDias]
							end
							print(#vetoDiaAux,#vetorDias)
							if #vetoDiaAux ~= #vetorDias then
								-- atualizar table dias
								grupo.tableDias:deleteAllRows()
								grupo.createAllRows(grupo.tableDias,vetorDias)
							end
						elseif tipo and tipo == "ano" then
							local posIndex1 = grupo.tableAno._view._rows[1]._height
							local posAux = (-1)*((grupo.tableAno:getNumRows()-1-2)*rowHeight + posIndex1)
							
							grupo.tableAno:scrollToY({ y=posAux+posIndex1, time=100 })
							
							grupo.chosenYear = grupo.tableAno:getNumRows()-2
							auxFuncs.saveTable(grupo.tableAno,"eventoAno.json")
							print("Selecionado = "..grupo.tableAno._view._rows[grupo.chosenYear+1]._view.params.result)
							grupo.chosenYear = grupo.tableAno._view._rows[grupo.chosenYear+1]._view.params.result
							
							local anoBissexto = auxFuncs.checarBissexto(grupo.chosenYear)
							if anoBissexto then
								vetorMesesAux2[2] = vetorDiasAuxF2
							else
								vetorMesesAux2[2] = vetorDiasAuxF1
							end
							if grupo.chosenMonth == "02" then
								vetorDias = vetorMesesAux2[2]
								if tonumber(grupo.chosenDay) > tonumber(vetorDias[#vetorDias]) then
									grupo.chosenDay = vetorDias[#vetorDias]
								end
								if #vetoDiaAux ~= #vetorDias then
									-- atualizar table dias
									grupo.tableDias:deleteAllRows()
									grupo.createAllRows(grupo.tableDias,vetorDias)
								end
							end
						end
					end
				end
			end
		elseif event.phase == "ended" then
			print("ENDED")
			--event.direction = up,down
			-- event.limitReached = true, false
			local tipo = nil
			if event.target.params then
				tipo = event.target.params.tipo
			elseif event._targetRow then
				tipo = event.target._targetRow.params.tipo
			end
			grupo.tipoMovido = tipo
			local anoBissexto = auxFuncs.checarBissexto(grupo.chosenYear)
			if anoBissexto then
				vetorMesesAux2[2] = vetorDiasAuxF2
			else
				vetorMesesAux2[2] = vetorDiasAuxF1
			end
			if tipo and tipo == "dia" then
				local posicao = grupo.tableDias:getContentPosition()
				if posicao then
					-- calcular qual index esta na posicao central apartir de onde parou
					local posCentralMinAtual = posicao-grupo.areaDeEscolha[1]
					local posCentralMaxAtual = posicao-grupo.areaDeEscolha[2]
					local posIndex1 = grupo.tableDias._view._rows[1]._height
					grupo.escolheu = false
					for rowIndex=1,grupo.tableDias:getNumRows()-1 do
						local posAux = (-1)*((rowIndex-1)*rowHeight + posIndex1)
						if posAux <= posCentralMinAtual and posAux > posCentralMaxAtual and rowIndex ~= 1 then
							grupo.escolheu = true
							local compararTamanhoMeio = (-1*posAux)-(-1*posCentralMinAtual)
							if compararTamanhoMeio > rowHeight/2 then
								local rowIndexAntes = rowIndex-1
								posAux = (-1)*((rowIndexAntes-1)*rowHeight + posIndex1)
								if rowIndexAntes == grupo.tableDias:getNumRows()-1 then
									posAux = (-1)*((rowIndexAntes-2)*rowHeight + posIndex1)
									grupo.tableDias:scrollToY({ y=posAux+posIndex1, time=100 })
									grupo.chosenDay = rowIndexAntes-1
								else
									grupo.tableDias:scrollToY({ y=posAux+posIndex1, time=100 })
									grupo.chosenDay = rowIndexAntes
								end
							else
								if rowIndex == grupo.tableDias:getNumRows()-1 then
									posAux = (-1)*((rowIndex-2)*rowHeight + posIndex1)
									grupo.tableDias:scrollToY({ y=posAux+posIndex1, time=100 })
									grupo.chosenDay = rowIndex-1
								else
									grupo.tableDias:scrollToY({ y=posAux+posIndex1, time=100 })
									grupo.chosenDay = rowIndex
								end
							end
							print("Selecionado = "..grupo.tableDias._view._rows[grupo.chosenDay+1]._view.params.result)
							grupo.chosenDay = grupo.tableDias._view._rows[grupo.chosenDay+1]._view.params.result
						end
					end
				end
			elseif tipo and tipo == "mes" then
				local posicao = grupo.tableMes:getContentPosition()
				if posicao then
					-- calcular qual index esta na posicao central apartir de onde parou
					local posCentralMinAtual = posicao-grupo.areaDeEscolha[1]
					local posCentralMaxAtual = posicao-grupo.areaDeEscolha[2]
					local posIndex1 = grupo.tableMes._view._rows[1]._height
					grupo.escolheu = false
					for rowIndex=1,grupo.tableMes:getNumRows()-1 do
						local posAux = (-1)*((rowIndex-1)*rowHeight + posIndex1)
						if posAux <= posCentralMinAtual and posAux > posCentralMaxAtual and rowIndex ~= 1 then
							grupo.escolheu = true
							local compararTamanhoMeio = (-1*posAux)-(-1*posCentralMinAtual)
							if compararTamanhoMeio > rowHeight/2 then
								local rowIndexAntes = rowIndex-1
								posAux = (-1)*((rowIndexAntes-1)*rowHeight + posIndex1)
								if rowIndexAntes == grupo.tableMes:getNumRows()-1 then
									posAux = (-1)*((rowIndexAntes-2)*rowHeight + posIndex1)
									grupo.tableMes:scrollToY({ y=posAux+posIndex1, time=100 })
									grupo.chosenMonth = rowIndexAntes-1
								else
									grupo.tableMes:scrollToY({ y=posAux+posIndex1, time=100 })
									grupo.chosenMonth = rowIndexAntes
								end
							else
								if rowIndex == grupo.tableMes:getNumRows()-1 then
									posAux = (-1)*((rowIndex-2)*rowHeight + posIndex1)
									grupo.tableMes:scrollToY({ y=posAux+posIndex1, time=100 })
									grupo.chosenMonth = rowIndex-1
								else
									grupo.tableMes:scrollToY({ y=posAux+posIndex1, time=100 })
									grupo.chosenMonth = rowIndex
								end
							end
							print("Selecionado = "..grupo.tableMes._view._rows[grupo.chosenMonth+1]._view.params.result)
							grupo.chosenMonth = grupo.tableMes._view._rows[grupo.chosenMonth+1]._view.params.result
							local vetoDiaAux = vetorDias
							print("vetoDiaAux",#vetoDiaAux,#vetorDias)
							if vetorMesesAux[tonumber(grupo.chosenMonth)] == 30 then
								vetorDias = vetorDiasAux1
							elseif vetorMesesAux[tonumber(grupo.chosenMonth)] == 31 then
								vetorDias = vetorDiasAux2
							else
								vetorDias = vetorMesesAux2[2]
							end
							print(tonumber(grupo.chosenDay),tonumber(vetorDias[#vetorDias]),#vetorDias)
							
							if tonumber(grupo.chosenDay) > tonumber(vetorDias[#vetorDias]) then
								grupo.chosenDay = vetorDias[#vetorDias]
							end
							print("vetoDiaAux",#vetoDiaAux,#vetorDias)
							if #vetoDiaAux ~= #vetorDias then
								-- atualizar table dias
								grupo.tableDias:deleteAllRows()
								grupo.createAllRows(grupo.tableDias,vetorDias)
							end
						end
					end
				end
			elseif tipo and tipo == "ano" then
				local posicao = grupo.tableAno:getContentPosition()
				if posicao then
					-- calcular qual index esta na posicao central apartir de onde parou
					local posCentralMinAtual = posicao-grupo.areaDeEscolha[1]
					local posCentralMaxAtual = posicao-grupo.areaDeEscolha[2]
					local row = grupo.tableAno._rows

					local posIndex1 = grupo.tableAno._view._rows[1]._height
					--grupo.tableAno._rows[i]._view
					--grupo.tableAno._rows[i]._view.index
					--grupo.tableAno._rows[i]._view.params.tipo
					grupo.escolheu = false
					for rowIndex=1,grupo.tableAno:getNumRows()-1 do
						local posAux = (-1)*((rowIndex-1)*rowHeight + posIndex1)
						if posAux <= posCentralMinAtual and posAux > posCentralMaxAtual and rowIndex ~= 1 then
							grupo.escolheu = true
							local compararTamanhoMeio = (-1*posAux)-(-1*posCentralMinAtual)
							if compararTamanhoMeio > rowHeight/2 then
								local rowIndexAntes = rowIndex-1
								posAux = (-1)*((rowIndexAntes-1)*rowHeight + posIndex1)
								if rowIndexAntes == grupo.tableAno:getNumRows()-1 then
									posAux = (-1)*((rowIndexAntes-2)*rowHeight + posIndex1)
									grupo.tableAno:scrollToY({ y=posAux+posIndex1, time=100 })
									grupo.chosenYear = rowIndexAntes-1
								else
									grupo.tableAno:scrollToY({ y=posAux+posIndex1, time=100 })
									grupo.chosenYear = rowIndexAntes
								end
							else
								if rowIndex == grupo.tableAno:getNumRows()-1 then
									posAux = (-1)*((rowIndex-2)*rowHeight + posIndex1)
									grupo.tableAno:scrollToY({ y=posAux+posIndex1, time=100 })
									grupo.chosenYear = rowIndex-1
								else
									grupo.tableAno:scrollToY({ y=posAux+posIndex1, time=100 })
									grupo.chosenYear = rowIndex
								end
							end
							print("Selecionado = "..grupo.tableAno._view._rows[grupo.chosenYear+1]._view.params.result)
							grupo.chosenYear = grupo.tableAno._view._rows[grupo.chosenYear+1]._view.params.result
							local anoBissextoEscolhido = auxFuncs.checarBissexto(grupo.chosenYear)
							if anoBissexto then
								vetorMesesAux2[2] = vetorDiasAuxF2
							else
								vetorMesesAux2[2] = vetorDiasAuxF1
							end
							if grupo.chosenMonth == "02" then
								vetorDias = vetorMesesAux2[2]
								if tonumber(grupo.chosenDay) > tonumber(vetorDias[#vetorDias]) then
									grupo.chosenDay = vetorDias[#vetorDias]
								end
								if #vetoDiaAux ~= #vetorDias then
									-- atualizar table dias
									grupo.tableDias:deleteAllRows()
									grupo.createAllRows(grupo.tableDias,vetorDias)
								end
							end
						end
					end
				end
			end
		end
	end
	grupo.selecionar = function()
		--[[local phase = event.phase
		if phase == "release" then
			local row = event.row
			local groupContentHeight = row.contentHeight
			local groupContentWidth = row.contentWidth
			local result = row.params.result
			Var.GMenuBotao.numeroSelecionado = codigoLivro
			local function listener( event )

				if ( event.isError ) then
					  --local alert = native.showAlert( "Network Error . Check Connection", "Connect to Internet", { "Try again" }  )
					  print("Network Error . Check Connection", "Connect to Internet")
				else
					local arquivos = json.decode(event.response)
					
					if arquivos and #arquivos and #arquivos>0 then
						local txtFiles = {}
						Var.GMenuBotao.materiaisSalvos = {}
						for i=1,#arquivos do
							if string.sub(arquivos[i],#arquivos[i]-3,#arquivos[i]) == ".txt" then
								table.insert(txtFiles,arquivos[i])
								table.insert(Var.GMenuBotao.paginasSelecionadas,{arquivos[i],false})
							elseif string.sub(arquivos[i],#arquivos[i]-4,#arquivos[i]) == ".json" and string.sub(arquivos[i],1,4) == "MPS_" then
								table.insert(Var.GMenuBotao.materiaisSalvos,arquivos[i])
							end
						end
						if #txtFiles == 0 then txtFiles = {"Não há material para selecionar"} end
						txtFiles = auxFuncs.Alphanumsort(txtFiles)
						if Var.GMenuBotao.tablePags then
							Var.GMenuBotao.tablePags:deleteAllRows()
							Var.GMenuBotao.createAllRows(Var.GMenuBotao.tablePags,txtFiles)
						end
						if Var.GMenuBotao.tableLivros then
							Var.GMenuBotao.tableLivrosY = Var.GMenuBotao.tableLivros:getContentPosition()
							Var.GMenuBotao.tableLivrosLinhaSelecionada = row.index
							Var.GMenuBotao.tableLivros:deleteAllRows()
							Var.GMenuBotao.createAllRows(Var.GMenuBotao.tableLivros,Var.GMenuBotao.tableLivros.livros)
							Var.GMenuBotao.tableLivros:scrollToY({ y=Var.GMenuBotao.tableLivrosY, time=0 })
						end
						-- atualizar tabela de materias salvos
						Var.GMenuBotao.checarMateriaisSalvoseAtualizarTable()
					end
				end
			end
			
			grupo.selecionarEMover()
		end
		]]
	end
	grupo.gerarLinhas = function(event)
		local phase = event.phase
		local row = event.row
		local groupContentHeight = row.contentHeight
		local groupContentWidth = row.contentWidth
		local numero = tostring(row.params.result)
		
		row.barraEsq = display.newRect(row,0,0,1,groupContentHeight)
		row.barraEsq.anchorX=0
		row.barraEsq.anchorY=0
		row.barraEsq:setFillColor(0,0,0)
		
		row.barraDir = display.newRect(row,groupContentWidth,0,1,groupContentHeight)
		row.barraDir.anchorX=1
		row.barraDir.anchorY=0
		row.barraDir:setFillColor(0,0,0)
		
		row.numero = display.newText(row,numero,0,0,0,0,"Fontes/arial.ttf", fontSize )
		row.numero.anchorX = 0.5
		row.numero.x = groupContentWidth/2
		row.numero.y = groupContentHeight * 0.5
		row.numero:setFillColor(0,0,0)
	end
	
	
	
	
	
	grupo.tableDias = widget.newTableView(
		{
			height = height,
			width = width/4,
			onRowRender = grupo.gerarLinhas,
			onRowTouch = grupo.selecionar,
			listener = grupo.selecionarEMover,
			rowTouchDelay =0,
			backgroundColor = { 0.8, 0.8, 0.8,.4 },
			hideBackground  = true,
			noLines = true
		}
	)
	grupo.tableDias.anchorX = 0;grupo.tableDias.anchorY = 0
	grupo.tableDias.x = diffW/2
	grupo.tableDias.y = diffH/2
	grupo.tableDias.tipo = "dia"
	grupo:insert(grupo.tableDias)
	grupo.createAllRows(grupo.tableDias,vetorDias)
	
	grupo.tableMes = widget.newTableView(
		{
			height = height,
			width = width/4,
			onRowRender = grupo.gerarLinhas,
			onRowTouch = grupo.selecionar,
			listener = grupo.selecionarEMover,
			rowTouchDelay =0,
			backgroundColor = { 1, 1, 1,.4 },
			hideBackground  = true,
			noLines = true
		}
	)
	grupo.tableMes.anchorX = 0;grupo.tableMes.anchorY = 0
	grupo.tableMes.x = grupo.tableDias.x+grupo.tableDias.width
	grupo.tableMes.y = 0
	grupo.tableMes.tipo = "mes"
	grupo:insert(grupo.tableMes)
	grupo.createAllRows(grupo.tableMes,vetorMeses)
	
	grupo.tableAno = widget.newTableView(
		{
			height = height,
			width = width/2,
			onRowRender = grupo.gerarLinhas,
			onRowTouch = grupo.selecionar,
			listener = grupo.selecionarEMover,
			rowTouchDelay =0,
			backgroundColor = { 0.8, 0.8, 0.8,.4 },
			hideBackground  = true,
			noLines = true
		}
	)
	grupo.tableAno.anchorX = 0;grupo.tableAno.anchorY = 0
	grupo.tableAno.x = grupo.tableMes.x+grupo.tableMes.width
	grupo.tableAno.y = 0
	grupo.tableAno.tipo = "ano"
	grupo:insert(grupo.tableAno)
	grupo.createAllRows(grupo.tableAno,vetorAnos)
	
	grupo.marcador = display.newImageRect(marcador,width,height)
	grupo.marcador.anchorY,grupo.marcador.anchorX=0,0
	grupo.marcador.y,grupo.marcador.x = 0,0
	grupo:insert(grupo.marcador)
	
	grupo.mask = display.newImageRect(mask,width,height)
	grupo.mask.alpha=0.5
	grupo.mask.anchorY,grupo.mask.anchorX=0,0
	grupo.mask.y,grupo.mask.x = grupo.tableDias.y,grupo.tableDias.x
	grupo:insert(grupo.mask)
	
	
	grupo.fundoBorda = display.newRect(0,0,0,0)
	grupo.fundoBorda:setFillColor(1,1,1,0)
	grupo.fundoBorda.anchorY,grupo.fundoBorda.anchorX=0,0
	grupo.fundoBorda.width=width; grupo.fundoBorda.height=height
	grupo.fundoBorda.x=(-1)*borderSize/2;grupo.fundoBorda.y=(-1)*borderSize/2
	grupo.fundoBorda.strokeWidth=borderSize
	grupo.fundoBorda:setStrokeColor(borderRGBColor[1]/255,borderRGBColor[2]/255,borderRGBColor[3]/255)
	if borderRGBColor[4] then grupo.fundoBorda.alpha=borderRGBColor[4]end
	grupo:insert(grupo.fundoBorda)
		
	return grupo
end

return M