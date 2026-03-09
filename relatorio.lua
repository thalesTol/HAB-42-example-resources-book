local M = {}

						--local url = "https://api.voicerss.org/?key=07aa9b6dabdc4c1abe01c94cb560441e&hl=pt-br&c=MP3&r=-1&f=12khz_16bit_mono&src=botão de registro, clique para criar sua conta."
						--request = network.request( url, "GET", cadastroListener,  params )

local json = require("json")
local vetorJsonAux = {}
local resultadoInicial = nil
local funcGlobal = {}

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

local function disp_time(time)
	  local days = math.floor(time/86400)
	  local hours = math.floor(math.mod(time, 86400)/3600)
	  local minutes = math.floor(math.mod(time,3600)/60)
	  local seconds = math.floor(math.mod(time,60))
	  local result = string.format("%d:%02d:%02d:%02d",days,hours,minutes,seconds)
	  if days == 0 then
		result = string.format("%02d:%02d:%02d horas",hours,minutes,seconds)
		if hours == 0 then
			result = string.format("%02d:%02d minutos",minutes,seconds)
			if minutes == 0 then
				result = string.format("%02d segundos",seconds)
			end
		end
	  end 
	  return result
end
local function datediff(d1, d2, ...)
		col_date1 = os.time({year = d1.year, month = d1.month, day = d1.day , hour = d1.hour, min = d1.min, sec = d1.sec})
		col_date2 = os.time({year = d2.year, month = d2.month, day = d2.day , hour = d2.hour, min = d2.min, sec = d2.sec })

		local arg={...}
		if arg[1] ~= nil then
			if arg[1] == "min" then
				return math.abs((col_date1 - col_date2) / 60)
			elseif arg[1] == "hour" then
				return math.abs((col_date1 - col_date2) / 3600)
			elseif arg[1] == "day" then
				return math.abs((col_date1 - col_date2) / 86400)
			end
		end
	
	
		return math.abs(col_date1 - col_date2)
		--return 0
end
function funcGlobal.RequestBusca( vetor,funcaoRetorno )
	local resultadoInicial = {}
	local function cadastroListener(event)
		if ( event.isError ) then
			  --local alert = native.showAlert( "Network Error . Check Connection", "Connect to Internet", { "Try again" }  )
			  print("Network Error . Check Connection", "Connect to Internet")
		else
			if event.response == "sem resultados" then
				native.showAlert("sem resultados encontrados","",{"ok"})
				if funcaoRetorno then
					funcaoRetorno({})
				end
			else
				resultadoInicial = json.decode(event.response)
				saveTable( resultadoInicial, "Relatorio_resultadosIniciais.json" )
				if funcaoRetorno then
					funcaoRetorno(resultadoInicial)
				end
			end
		end
	end
	local headers = {}
	headers["Content-Type"] = "application/json"
	local parameters = {}
	parameters.headers = headers

	local data = json.encode(vetor)
	parameters.body = data
	--print("OLÁ")
	--local URL = "https://18.218.25.234/EAudioBookDB/buscarNoHistoricoMongo.php" --mongo.php"
	local URL = "https://omniscience42.com/EAudioBookDB/buscarNoHistoricoMongo.php" --mongo.php"
	network.request(URL, "POST", cadastroListener,parameters)
end

local function criarTxTDoc(arquivo,texto) -- vetor ou variavel
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

local function procurar_aberturas_livro(livro_id,usuario_id)
	local vetorJsonAux = {}
	vetorJsonAux.livro_id = livro_id
	if usuario_id then
		vetorJsonAux.usuario_id = usuario_id
	end
	vetorJsonAux.interacoes = {	{["tipo"] = "genérica",["acao"] = "fechou o livro"},
								{["tipo"] = "genérica",["acao"] = "suspendeu o livro"},
								{["tipo"] = "genérica",["acao"] = "Abriu o livro"}}
	
	local function filtrarOsResultados(vetorInicial)
		if vetorInicial.nResults then
			local contadorAberturas = 0
			local vetorTempos = {}
			local tempoTotal = 0
			local contAbr = 1
			local contFech = 1
			local vetorDeControle = {}
			for i=1,vetorInicial.nResults do
				local iStr = tostring(i)
				if vetorInicial[iStr]["acao"] == "Abriu o livro" then
					contadorAberturas = contadorAberturas + 1;
					table.insert(vetorDeControle, vetorInicial[iStr])
				end
				if vetorInicial[iStr]["acao"] ~= "Abriu o livro" then
				  local lastElement = vetorDeControle[#vetorDeControle]
				  if (lastElement and lastElement["acao"] ~= "Abriu o livro" and (vetorInicial[iStr]["acao"] ~= "Abriu o livro")) then
					  table.remove(vetorDeControle,#vetorDeControle);
				  end
				  
				  table.insert(vetorDeControle, vetorInicial[iStr]);
				end
			end
			for i=1,#vetorDeControle do
				local iStr = tostring(i)
				
				if not vetorTempos[contAbr] then vetorTempos[contAbr] = {} end
				if not vetorTempos[contFech] then vetorTempos[contFech] = {} end
				
				if vetorDeControle[i].acao == "Abriu o livro" then
					vetorTempos[contAbr].horario = vetorDeControle[i].data
					contAbr = contAbr + 1
				else
					vetorTempos[contFech].numero = vetorDeControle[i].tempo_aberto
					tempoTotal = tempoTotal + vetorDeControle[i].tempo_aberto
					contFech = contFech + 1
				end
			end
			local vetor_retorno = {}
			vetor_retorno["numero_aberturas"] = contadorAberturas
			vetor_retorno["tempo_total_aberturas"] = tempoTotal
			vetor_retorno["vetor_tempos"] = vetorTempos
			saveTable( vetor_retorno, "aberturaslivro.json" )
		end
	end
	funcGlobal.RequestBusca(vetorJsonAux,filtrarOsResultados)
end

local dadosLivro = {}
local dadosUsuario = {}
local function fileExistsDoc(fileName)
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
local function pegarRelatorioAuxOrganizar(vetorRelatorios,atributos)
	require("luaFpdf")

	local pdf = luaFPDF:new()
	pdf:AddPage()
	local function PDFseparador(size,salto)
		pdf:Ln(salto)
		pdf:Cell(0,size, "",0,1,'L',true)
		pdf:Ln(1)
	end
	local function PDFseparador2(size,salto)
		pdf:Ln(salto)
		pdf:SetFillColor(150,150,150)
		pdf:Cell(0,size, "",0,1,'L',true)
		pdf:Ln(1)
		pdf:SetFillColor(255,255,255)
	end
	local result = "" -- relatorio final
	local htm = '<!DOCTYPE html>\n<html>\n<head><meta charset="UTF-8"></head>\n<body>\n'
	local nomeLivro = dadosLivro.nome_livro or "HAB 42"
	local nomeUsuario = dadosUsuario.nome_usuario or "leitor"
	-------------------------------------------------------------------------------------------------
	-- Separando pelo filtro primário ---------------------------------------------------------------
	local organizar1 = {} -- vetor para separar pelo filtro primário escolhido
	local organizar1Num = {} -- vetor para separar quais subfiltros primários foram encontrados
	local organizar2 = {} -- vetor para separar pelo filtro primário escolhido
	local organizar2Num = {} -- vetor para separar quais subfiltros primários foram encontrados
	for i=1,#vetorRelatorios do
		
		local tipoAux = vetorRelatorios[i][atributos.Organizar1_por] -- pegando o subfiltro primário
		if atributos.Organizar1_por == "data" then
			local aux1,aux2,aux3 = string.match(tipoAux,"(%d+)%-(%d+)%-(%d+)")
			if string.len(aux3) == 1 then aux3 = "0"..aux3 end
			if string.len(aux2) == 1 then aux2 = "0"..aux2 end
			tipoAux = aux3.."/"..aux2.."/"..aux1
		end
		

		if vetorRelatorios[i].relatorio then -- verificar se a entrada possui um relatorio no banco
			if not organizar1[tipoAux] then -- se for o primeiro daquele subfiltro primário, adicionar a uma lista para futuro mapeamento
				organizar1[tipoAux] = {}
				table.insert(organizar1Num,tipoAux) 
			end
			table.insert(organizar1[tipoAux],vetorRelatorios[i])-- separando os relatorios nos respectivos subfiltros primários
		end
		
	end
	if atributos.Organizar2_por then
		for i2=1,#organizar1Num do
			local tipoAux = organizar1Num[i2]
			organizar2[tipoAux] = {}
			organizar2Num[tipoAux] = {}
			for j=1,#organizar1[tipoAux] do

				local tipoAux2 = organizar1[tipoAux][j][atributos.Organizar2_por] -- pegando o subfiltro secundário
				
				if atributos.Organizar2_por == "data" then
					local aux1,aux2,aux3 = string.match(tipoAux2,"(%d+)%-(%d+)%-(%d+)")
					if string.len(aux3) == 1 then aux3 = "0"..aux3 end
					if string.len(aux2) == 1 then aux2 = "0"..aux2 end
					tipoAux2 = aux3.."/"..aux2.."/"..aux1
				end
				--print("\n|"..tipoAux.."|"..tipoAux2.."|\n")
				if not organizar2[tipoAux][tipoAux2] then -- se for o primeiro daquele subfiltro secundário, adicionar a uma lista para futuro mapeamento
					organizar2[tipoAux][tipoAux2] = {}
					table.insert(organizar2Num[tipoAux],tipoAux2) 
				end
				table.insert(organizar2[tipoAux][tipoAux2],organizar1[tipoAux][j])-- separando os relatorios nos respectivos subfiltros secundários
			end
		end
	end
	htm = htm .. "<a href=''><img src='https://www.coronasdkgames.com/Thales/ThalesCOMPred.png' align='right' style='width:64px;height:50px;' alt='Logo da empresa onisciência 42'/></a>\n<p></p>"
	--htm = htm .. '<form action="corona:close" /><input type="submit" /></form><p></p>'
	pdf:SetFont('Arial','B',30)
	pdf:Cell(0,12,"RELATÓRIO DO LIVRO",0,0,'C')
	pdf:Ln(20)
		pdf:SetFont('Arial','B',30)
		local widTH = pdf:GetStringWidth(nomeLivro)+6
		--pdf:SetX(0)
		-- Colors of frame, background and text
		pdf:SetDrawColor(0,0,0)
		--pdf:SetFillColor(230,230,0)
		pdf:SetTextColor(196,0,0)
		-- Thickness of frame (1 mm)
		--pdf:SetLineWidth(1)
		-- Title
		pdf:MultiCell(0,10,nomeLivro,0,'C')

	pdf:SetTextColor(0,0,0)
	--pdf:SetFont('Arial','B',50)
	--pdf:Cell(40,10,dadosLivro.nome_livro)
	--pdf:Ln(20)
	PDFseparador(.5,10)
	pdf:SetFont('Arial','B',20)
	pdf:Cell(40,10,"Nome: "..dadosUsuario.nome_usuario)
	PDFseparador(.5,10)
	pdf:Cell(40,10,"Identificador(ID): "..dadosUsuario.usuario_id)
	PDFseparador(.5,10)
	pdf:Cell(40,10,"Período: ")
	pdf:Ln(10)
	local anoTemp,mesTemp,diaTemp,horaTemp,minTemp,segTemp = string.match(atributos.periodoInicial,"(%d+)%-(%d+)%-(%d+) (%d+):(%d+):(%d+)")

	pdf:Cell(10)
	pdf:Cell(40,10,"de:  "..diaTemp.." do "..mesTemp.." de "..anoTemp)
	pdf:Ln(10)
	local anoTemp2,mesTemp2,diaTemp2,horaTemp2,minTemp2,segTemp2 = string.match(atributos.periodoFinal,"(%d+)%-(%d+)%-(%d+) (%d+):(%d+):(%d+)")

	pdf:Cell(10)
	pdf:Cell(40,10,"até: "..diaTemp2.." do "..mesTemp2.." de "..anoTemp2)
	PDFseparador(.5,10)
	local formato1 = atributos.Organizar1_por
	if formato1 == "tipoInteracao" then formato1 = "tipo" end
	local formato2 = nil
	if atributos.Organizar2_por then
		formato2 = atributos.Organizar2_por
		if formato2 == "tipoInteracao" then formato2 = "tipo" end 
	end
	if not formato2 then
		pdf:Cell(40,10,"Formatação: "..formato1)
	else
		pdf:Cell(40,10,"Formatação: "..formato1.." e "..formato2)
	end
	PDFseparador(.5,10)
	for j=1,#vetorRelatorios.periodosAberto do
		
	end
	pdf:Cell(40,10,"Tempo de uso do livro: ")
	pdf:Ln(10)
	pdf:Cell(10)
	pdf:SetFont('Arial','B',15)
	pdf:Cell(40,10,disp_time(vetorRelatorios.tempoTotalAbertoPeriodo))
	PDFseparador(.5,10)
	pdf:SetFont('Arial','B',20)
	pdf:Cell(40,10,"Intervalos de uso do livro: ")
	pdf:Ln(5)
	for j=1,#vetorRelatorios.periodosAberto do
		local date1 = {}
		date1.year,date1.month,date1.day,date1.hour,date1.min,date1.sec = string.match(vetorRelatorios.periodosAberto[j][1],"(%d+)%-(%d+)%-(%d+) (%d+):(%d+):(%d+)")
		local date2 = {}
		date2.year,date2.month,date2.day,date2.hour,date2.min,date2.sec = string.match(vetorRelatorios.periodosAberto[j][2],"(%d+)%-(%d+)%-(%d+) (%d+):(%d+):(%d+)")
		
		pdf:Ln(5)
		pdf:Cell(10)
		pdf:SetFont('Arial','B',15)
		
		pdf:MultiCell(0,5,"Dia: "..date1.day.."/"..date1.month.."/"..date1.year.." das:  "..date1.hour..":"..date1.min..":"..date1.sec.." horas, às "..date2.hour..":"..date2.min..":"..date2.sec.." horas por "..vetorRelatorios.periodosAberto[j][3],0,'J')
		--pdf:Cell(40,10,"de:  "..vetorRelatorios.periodosAberto[j][1].." a "..vetorRelatorios.periodosAberto[j][2].." por "..vetorRelatorios.periodosAberto[j][3])
	end
	pdf:SetFont('Arial','B',20)
	PDFseparador(.5,10)
	
	--acrescentar espaços
	--pdf:Cell(80)
	htm = htm .. "<meta charset='UTF-8'><h1 style='display:block;font-family:Helvetica,Arial,sans-serif;font-style:normal;font-weight:bold;line-height:100%;letter-spacing:normal;margin-top:0;margin-right:0;margin-bottom:0;margin-left:0;text-align:left;color:#404040;font-size:25px'><strong style='color:#0a5151;font-weight:600'>RELATÓRIO DO LIVRO:</strong></h1><p></p>"
	htm = htm .. "<h1 style='display:block;font-family:Helvetica,Arial,sans-serif;font-style:normal;font-weight:bold;line-height:100%;letter-spacing:normal;margin-top:0;margin-right:0;margin-bottom:0;margin-left:0;text-align:left;color:#404040;font-size:30px'><strong style='color:#0a5151;font-weight:600'>"..nomeLivro.."</p></strong></h1><p></p>\n<p></p>\n<hr>"
	if dadosUsuario.nome_usuario then
		htm = htm .. "<h1 style='display:block;font-family:Helvetica,Arial,sans-serif;font-style:normal;font-weight:bold;line-height:100%;letter-spacing:normal;margin-top:0;margin-right:0;margin-bottom:0;margin-left:0;text-align:left;color:#404040;font-size:19px'><strong style='color:#0;font-weight:600'>Nome: "..dadosUsuario.nome_usuario.."</strong></h1>\n<hr>\n"
		htm = htm .. "<h1 style='display:block;font-family:Helvetica,Arial,sans-serif;font-style:normal;font-weight:bold;line-height:100%;letter-spacing:normal;margin-top:0;margin-right:0;margin-bottom:0;margin-left:0;text-align:left;color:#404040;font-size:19px'><strong style='color:#0;font-weight:600'>Identificador: "..dadosUsuario.usuario_id.."</strong></h1>\n<hr>\n"
		htm = htm .. "<h1 style='display:block;font-family:Helvetica,Arial,sans-serif;font-style:normal;font-weight:bold;line-height:100%;letter-spacing:normal;margin-top:0;margin-right:0;margin-bottom:0;margin-left:0;text-align:left;color:#404040;font-size:19px'><strong style='color:#0;font-weight:600'>Período: </strong></h1>\n\n"
		htm = htm .. "<h1 style='display:block;font-family:Helvetica,Arial,sans-serif;font-style:normal;font-weight:bold;line-height:100%;letter-spacing:normal;margin-top:0;margin-right:0;margin-bottom:0;margin-left:0;text-align:left;color:#404040;font-size:19px'><strong style='color:#0;font-weight:600'>&nbsp&nbspde:  "..diaTemp.." do "..mesTemp.." de "..anoTemp.."</strong></h1>\n\n"
		htm = htm .. "<h1 style='display:block;font-family:Helvetica,Arial,sans-serif;font-style:normal;font-weight:bold;line-height:100%;letter-spacing:normal;margin-top:0;margin-right:0;margin-bottom:0;margin-left:0;text-align:left;color:#404040;font-size:19px'><strong style='color:#0;font-weight:600'>&nbsp&nbspaté:  "..diaTemp2.." do "..mesTemp2.." de "..anoTemp2.."</strong></h1>\n<hr>\n"
		if not formato2 then
			htm = htm .. "<h1 style='display:block;font-family:Helvetica,Arial,sans-serif;font-style:normal;font-weight:bold;line-height:100%;letter-spacing:normal;margin-top:0;margin-right:0;margin-bottom:0;margin-left:0;text-align:left;color:#404040;font-size:17px'><strong style='color:#0;font-weight:600'>Formatado por: "..formato1.."</strong></h1>\n<p></p>\n<p></p>\n<hr>\n"
		else
			htm = htm .. "<h1 style='display:block;font-family:Helvetica,Arial,sans-serif;font-style:normal;font-weight:bold;line-height:100%;letter-spacing:normal;margin-top:0;margin-right:0;margin-bottom:0;margin-left:0;text-align:left;color:#404040;font-size:17px'><strong style='color:#0;font-weight:600'>Formatado por: "..formato1.." e "..formato2.."</strong></h1>\n<p></p>\n<p></p>\n<hr>\n"
		end
	end
	-------------------------------------------------------------------------------------------------
	-- Agora vamos formatar as informações separadas pelo filtro primário e secundário escolhidos ---
	for i=1,#organizar1Num do
		local tipoAux = organizar1Num[i]
		local impresso_aux = tipoAux
		if impresso_aux == "genérica" then impresso_aux = "Atividade Genérica" end
		if impresso_aux == "audio" then impresso_aux = "Audio" end
		if impresso_aux == "video" then impresso_aux = "Video" end
		if impresso_aux == "imagem" then impresso_aux = "Imagem" end
		if impresso_aux == "texto" then impresso_aux = "Texto" end
		pdf:Ln(10)
		if atributos.Organizar1_por == "data" then
			htm = htm .. "<h2>\n<b>Dia: "..impresso_aux.."</b>\n</h2>"
			pdf:SetFillColor(220,220,220)
	    	-- Title
	    	pdf:Cell(0,10, "Dia: "..impresso_aux,0,1,'L',true)
			--pdf:Cell(40,10,"Dia: "..impresso_aux)
			pdf:Ln(1)
			pdf:SetFillColor(255,255,255)
		else
			htm = htm .. "<h2>\n<b>"..impresso_aux.."</b>\n</h2>"
			pdf:SetFillColor(220,220,220)
	    	-- Title
	    	pdf:Cell(0,10,impresso_aux,0,1,'L',true)
			--pdf:Cell(40,10,impresso_aux)
			pdf:Ln(1)
			pdf:SetFillColor(255,255,255)
		end
		result = result .. "\n|"..tipoAux.."|\n"
		--print("\n|"..tipoAux.."|\n")
		-- Se tiver apenas um tipo de organização fazer:
		
		if not atributos.Organizar2_por then 
			
			for k=1,#organizar1[tipoAux] do
				
				local relatorio = organizar1[tipoAux][k].relatorio
				if atributos.Organizar1_por == "data" then
					relatorio = string.gsub(relatorio,"(.+)|","")
				end
				result = result.. "	" .. k .." - "..relatorio.."\n"
				htm = htm.. "<p><b>&nbsp&nbsp&nbsp&nbsp" .. k .." - </b>"
				htm = htm .. relatorio.."</p>\n"
				pdf:Cell(10)
				--pdf:Cell(40,10,k.." - "..relatorio)
				pdf:MultiCell(0,10,k.." - "..relatorio,0,'J')
				pdf:Ln(10)
			end
		-- Se tiver um subtipo de organização fazer:
		else
			--------------------------------------------	
			for k=1,#organizar2Num[tipoAux] do
				local tipoAux2 = organizar2Num[tipoAux][k]
				local impresso_aux = tipoAux2
				if impresso_aux == "genérica" then impresso_aux = "Atividade Genérica" end
				if impresso_aux == "audio" then impresso_aux = "Audio" end
				if impresso_aux == "video" then impresso_aux = "Video" end
				if impresso_aux == "imagem" then impresso_aux = "Imagem" end
				if impresso_aux == "texto" then impresso_aux = "Texto" end
				PDFseparador2(.5,10)
				if atributos.Organizar2_por == "data" then
					htm = htm .. "<h3>\n<b>&nbsp&nbsp&nbsp&nbsp|Dia: "..impresso_aux.."|</b>\n</h3>"
					pdf:Cell(10)
					pdf:Cell(0,10,"Dia: "..impresso_aux)
				else
					htm = htm .. "<h3>\n<b>&nbsp&nbsp&nbsp&nbsp|"..impresso_aux.."|</b>\n</h3>"
					pdf:Cell(10)
					pdf:Cell(40,10,impresso_aux)
				end
				PDFseparador2(.5,10)
				result = result .. "\n	|"..tipoAux2.."|\n"
				
				for k2=1,#organizar2[tipoAux][tipoAux2] do
				
					local relatorio = organizar2[tipoAux][tipoAux2][k2].relatorio
					if atributos.Organizar1_por == "data" or atributos.Organizar2_por == "data" then
						relatorio = string.gsub(relatorio,"(.+)|","")
					end
					result = result.. "		" .. k2 .." - "..relatorio.."\n"
					htm = htm.. "<p><b>&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp" .. k2 .." - </b>"
					htm = htm .. relatorio.."</p>\n"
					pdf:Cell(20)
					--pdf:Cell(40,10,k2.." - "..relatorio)
					pdf:MultiCell(0,10,k2.." - "..relatorio,0,'J')
					pdf:Ln(10)
				end
			end
		end
	end	
	htm = htm .. "\n</body>\n</html>"
	if not fileExistsDoc("relatorio.htm") then
		criarTxTDoc("relatorio.txt",result)
		criarTxTDoc("relatorio.htm",htm)
		print("CHAMANDO FUNÇÂO SUCESSO")
		atributos.onComplete("sucesso",atributos.tipoBotao)
		
		
		--require("fpdf2")
		local diretorioThales = system.pathForFile(nil,system.TemporaryDirectory).."/"--,system.TemporaryDirectory
		local now = os.time()

		--require("profiler")
		--local profiler = newProfiler()
		--ocal profiler = newProfiler(nil, 10000)
		--profiler:start()

		
		
		--pdf:Output()
		pdf:Output("relatorio.pdf")
	end
end
local function pegarRelatorio(atributos)
	os.remove(system.pathForFile("relatorio.htm",system.DocumentsDirectory))
	local dataAtualSeNil = os.date( "*t" )
	
	local vetorJsonAux = {}
	if string.len(dataAtualSeNil.month) == 1 then dataAtualSeNil.month = "0"..dataAtualSeNil.month end
	if string.len(dataAtualSeNil.day) == 1 then dataAtualSeNil.day = "0"..dataAtualSeNil.day end
	
	vetorJsonAux.data_final = atributos.periodoFinal or dataAtualSeNil.year.."-"..dataAtualSeNil.month.."-"..dataAtualSeNil.day.." "..dataAtualSeNil.hour..":"..dataAtualSeNil.min..":"..dataAtualSeNil.sec..".0"
	
	if not atributos.periodoInicial then
		vetorJsonAux.data_inicio = string.gsub(vetorJsonAux.data_final," %d+:%d+:%d+%.%d+"," 00:00:00.0")
	else
		vetorJsonAux.data_inicio = atributos.periodoInicial
	end
	--vetorJsonAux.data_inicio = atributos.periodoInicial or dataAtualSeNil.year.."-"..dataAtualSeNil.month.."-"..dataAtualSeNil.day.." 00:00:00.0"
	
	
	--vetorJsonAux.data_periodos = {	{["inicio"] = vetorJsonAux.data_inicio,["final"] = vetorJsonAux.data_final}}
	vetorJsonAux.livro_id = atributos.livroId or nil
	vetorJsonAux.usuario_id = atributos.usuarioId or nil
	
	print("----------------------------------")
	print("Dados da busca do Relatório:")
	print("----------------------------------")
	print(vetorJsonAux.livro_id)
	print(vetorJsonAux.usuario_id)
	print(vetorJsonAux.data_inicio)
	print(vetorJsonAux.data_final)
	print("----------------------------------")
	local function pegarTemposAberto(vetorInicial)
		
		
		local abriu = false
		vetorInicial.periodosAberto = {}
		vetorInicial.tempoTotalAbertoPeriodo = 0
		for i=1,#vetorInicial do
			print(vetorInicial[i]["tipoInteracao"],vetorInicial[i]["acao"])
			if vetorInicial[i]["tipoInteracao"] == "genérica" and vetorInicial[i]["acao"] == "Abriu o livro" then
				print("ABRIU")
				abriu = vetorInicial[i]["data"]
			elseif vetorInicial[i]["tipoInteracao"] == "genérica" and (vetorInicial[i]["acao"] == "fechou o livro" or vetorInicial[i]["acao"] == "suspendeu o livro") and abriu then
				print("FECHOU")
				local date1 = {}
				date1.year,date1.month,date1.day,date1.hour,date1.min,date1.sec = string.match(abriu,"(%d+)%-(%d+)%-(%d+) (%d+):(%d+):(%d+)")
				local date2 = {}
				date2.year,date2.month,date2.day,date2.hour,date2.min,date2.sec = string.match(vetorInicial[i]["data"],"(%d+)%-(%d+)%-(%d+) (%d+):(%d+):(%d+)%.%d")
				local tempoAbertoAux = datediff(date1, date2)
				vetorInicial.tempoTotalAbertoPeriodo = vetorInicial.tempoTotalAbertoPeriodo + tempoAbertoAux
				local tempoAberto = disp_time(tempoAbertoAux)
				
				table.insert(vetorInicial.periodosAberto,{abriu,vetorInicial[i]["data"],tempoAberto})
				abriu = false
			end
			if i == #vetorInicial and abriu then
				local date1 = {}
				date1.year,date1.month,date1.day,date1.hour,date1.min,date1.sec = string.match(abriu,"(%d+)%-(%d+)%-(%d+) (%d+):(%d+):(%d+)")
				local date2 = {}
				date2.year,date2.month,date2.day,date2.hour,date2.min,date2.sec = string.match(vetorJsonAux.data_final,"(%d+)%-(%d+)%-(%d+) (%d+):(%d+):(%d+)%.%d")
				local date3 = os.date("*t")
				local tempoAbertoAux0 = datediff(date2, date3)
				if tempoAbertoAux0 <= 0 then
					date2 = date3
				end
				local tempoAbertoAux = datediff(date1, date2)
				local tempoAberto = disp_time(tempoAbertoAux)
				table.insert(vetorInicial.periodosAberto,{abriu,vetorJsonAux.data_final,tempoAberto})
			end
		end
	end
	local function imprimirRelatorio(vetorInicial)
		local vetorRelatorios = {}
		local mesmoDia = false
		if vetorInicial.nResults then
			
			for i=1,vetorInicial.nResults do
				local iStr = tostring(i)
				table.insert(vetorRelatorios, vetorInicial[iStr])
			end
			pegarTemposAberto(vetorRelatorios)
			local result = "Sem atividade no período\n\nInicial: "..vetorJsonAux.data_inicio.."\nFinal: "..vetorJsonAux.data_final
			local diaMatch = ""
			local diaAntes = ""
			for i=1,#vetorRelatorios do
				if vetorRelatorios[i].relatorio then
					if atributos.Organizar1_por then
						atributos.periodoInicial = vetorJsonAux.data_inicio
						atributos.periodoFinal = vetorJsonAux.data_final
						
						pegarRelatorioAuxOrganizar(vetorRelatorios,atributos)
						break
					else
						local relatorio = vetorRelatorios[i].relatorio
						diaMatch = string.match(vetorRelatorios[i].relatorio,"(.+)|")
						if diaMatch ~= diaAntes then
							result = result .. "\n|Dia "..diaMatch.."|\n"
						end
						relatorio = string.gsub(relatorio,"(.+)|","")
						result = result .. relatorio.."\n"
						diaAntes = diaMatch
					end
				end
			end
			criarTxTDoc("resultado_final_pesquisa_padrao.txt",result)
		end
	end
	
	local function lerDadosUsuario()
		local parameters = {}
		parameters.body = "usuario_id=" .. atributos.usuarioId
		local tentativas = 0
		local function listenerUsuario(event)
			if ( event.isError ) then
				atributos.onComplete("erro",atributos.tipoBotao)
				--Var.comentario.vetorComentarios = {}
				--Var.comentario.vetorComentarios[1] = {}
				--Var.comentario.vetorComentarios[1].conteudo = "Conexão com a internet falhou:"
			else
				local json = require("json")
				print("DADOS USUÁRIO: ",event.response)
				dadosUsuario = json.decode(event.response)
				if not dadosUsuario.nome_usuario then
					if tentativas == 3 then
						native.showAlert("Atenção!","Seu aparelho não pode recuperar seus dados da internet, verifique sua conexão e tente novamente. Caso necessário, entre em contato com o suporte!","OK")
					else
						tentativas = tentativas + 1
						local URL2 = "https://omniscience42.com/EAudioBookDB/lerDadosUsuario.php"
						network.request(URL2, "POST", listenerUsuario,parameters)
					end
				else
					funcGlobal.RequestBusca(vetorJsonAux,imprimirRelatorio)
				end
			end
		end
		local URL2 = "https://omniscience42.com/EAudioBookDB/lerDadosUsuario.php"
		network.request(URL2, "POST", listenerUsuario,parameters)
	end
	local function lerPreferenciasLivroBanco(usuario)
		local function listenerLivro(event)
			if ( event.isError ) then
				atributos.onComplete("erro",atributos.tipoBotao)
				--Var.comentario.vetorComentarios = {}
				--Var.comentario.vetorComentarios[1] = {}
				--Var.comentario.vetorComentarios[1].conteudo = "Conexão com a internet falhou:"
			else
				local json = require("json")
				dadosLivro = json.decode(event.response)
				print("DADOS LIVRO = ",event.response)
				if atributos.usuarioId then
					lerDadosUsuario()
				else
					funcGlobal.RequestBusca(vetorJsonAux,imprimirRelatorio)
				end
			end
		end
		local parameters = {}
		parameters.body = "livro_id=" .. atributos.livroId
		local URL2 = "https://omniscience42.com/EAudioBookDB/lerDadosLivro.php"
		network.request(URL2, "POST", listenerLivro,parameters)
	end
	if atributos.livroId then
	
		lerPreferenciasLivroBanco()
	else
		lerDadosUsuario()
	end
end
--pegarRelatorio({livroId = "5",usuarioId = "2",periodoInicial = "2021-02-01 01:00:00.0",periodoFinal = "2021-02-04 23:00:00.0",Organizar1_por = "tipoInteracao",Organizar2_por = "data"})

--pegarRelatorio({livroId = "5",usuarioId = "19",periodoInicial = "2021-02-28 01:00:00.0",periodoFinal = "2021-03-04 23:00:00.0",Organizar1_por = "data"})
--pegarRelatorio({livroId = "5",usuarioId = "19",periodoInicial = "2021-02-28 00:00:00.0",Organizar1_por = "tipoInteracao",periodoFinal = "2021-03-03 23:00:00.0",Organizar2_por = "data"})
local function gerarRelatorio(atrib)
	dadosLivro = {}
	dadosUsuario = {}
	pegarRelatorio({livroId = atrib.livroID,usuarioId = atrib.usuarioID,periodoInicial = atrib.periodoInicial,periodoFinal = atrib.periodoFinal,Organizar1_por = atrib.formatar1,Organizar2_por = atrib.formatar2,onComplete = atrib.onComplete,tipoBotao = atrib.tipoBotao})
end
M.gerarRelatorio = gerarRelatorio

function funcGlobal.cadastroListener(event)
	if ( event.isError ) then
		  --local alert = native.showAlert( "Network Error . Check Connection", "Connect to Internet", { "Try again" }  )
		  print("Network Error . Check Connection", "Connect to Internet")
	else
		if event.response == "sem resultados" then
			native.showAlert("sem resultados encontrados","",{"ok"})
		else
			print(event.response)
			resultadoInicial = json.decode(event.response)
			saveTable( resultadoInicial, "resultadosIniciais.json" )
			funcaoRetorno(resultadoInicial)
		end
	end
end

return M