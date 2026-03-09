local M = {}
local conversor = require("conversores")


local function testarNoAndroid(texto,posicaoy)
	texto = display.newText(texto,0,posicaoy,display.contentWidth,0,native.systemFont,15)
	texto.anchorX = 0;texto.anchorY = 0
	texto.x=0
	texto:setFillColor(1,0,0)
	return texto
end

local function fileExist(path,file)
	local ok, err, code = os.rename(path.."/"..file,path.."/"..file)
	if not ok then
		if code and code == 13 then
		 -- Permission denied, but it exists
			return true
		else
			return false
		end
	else
		return true
	end
end
M.fileExist = fileExist
-- checks STORAGE permissions (required for Android > 6) 
function checkPermissions() 
	-- get all permissions in table 
	local grantedPermissions = system.getInfo("grantedAppPermissions") 
	-- loop through them and check for CAMERA and STORAGE permissions 
	local storageGranted = false
	for i = 1, #grantedPermissions do 
		if("Storage" == grantedPermissions[i]) then 
			storageGranted = true 
		end 
	end 
	-- return true if both permissions are granted 
	if(storageGranted) then 
		return true 
	else 
		return false 
	end 
end
M.checkPermissions = checkPermissions

local function buscarAmazenamentosAndroid(variavel)
				
	local lfs = require( "lfs" )
	while lfs.currentdir() ~= "/" do
		lfs.chdir( lfs.currentdir().."/.." ) -- voltar para o diretório inicial
	end
	local path = "sdcard/"
	local success = lfs.chdir( path ) -- pegando raiz do armazenamento interno
	
	local armazenamentoInterno = lfs.currentdir()
	variavel.armazenamentoInterno = armazenamentoInterno
	
	--local texto = display.newText(variavel.armazenamentoInterno,0,250) -- comentar!!!!
	--texto.anchorX=0;texto.anchorY=0 -- comentar!!!!
	
	local quantia = 0
	for k, v in string.gmatch( lfs.currentdir(), "/" ) do
		quantia = quantia + 1
	end
	while quantia > 1 do
		local success = lfs.chdir( lfs.currentdir().."/.." )
		quantia = 0
		for k, v in string.gmatch( lfs.currentdir(), "/" ) do
			quantia = quantia + 1
		end
	end
	local pathRaiz = lfs.currentdir() .. "/"
	
	
	
	--local success = lfs.chdir( pathRaiz )
	local pastaInicialInterna = string.match(armazenamentoInterno,".+/")
	if pastaInicialInterna then
		pastaInicialInterna = string.gsub(pastaInicialInterna,pathRaiz,"")
		pastaInicialInterna = string.sub(pastaInicialInterna,1,#pastaInicialInterna-1)
	
		local pastasSdCard = {}
		for file in lfs.dir( pathRaiz ) do
			-- "file" is the current file or directory name
			if file ~= "self" and not string.find(file,"%.") and file ~= pastaInicialInterna then
				table.insert(pastasSdCard,file)
			end
		end
	
		local cont = 1
		local caminhoSdCard = nil
		--[[while cont <= #pastasSdCard do
			caminhoSdCard = pathRaiz..pastasSdCard[cont].."/"
		
			local naoEhSdCard = true
			local pastaExtra = ""
			while naoEhSdCard == true do
				local naoAchouNada = true
				for file in lfs.dir( caminhoSdCard ) do
					-- "file" is the current file or directory name
					naoAchouNada = false
					pastaExtra = file
					if file == "LOST.DIR"  then
						naoEhSdCard = false
					end
				end
				if naoEhSdCard == true then
					caminhoSdCard = caminhoSdCard..pastaExtra.."/"
				end
				if naoAchouNada == true then
					caminhoSdCard = nil
					naoEhSdCard = false
				end
			end
			if caminhoSdCard ~= nil then
				cont = #pastasSdCard + 1
			else
				cont = cont + 1
			end
		end
	
		variavel.caminhoSdCard = caminhoSdCard]]
		--local texto = display.newText(variavel.caminhoSdCard,0,300) -- comentar!!!!
		--texto.anchorX=0;texto.anchorY=0 -- comentar!!!!
	
		while lfs.currentdir() ~= "/" do
			lfs.chdir( lfs.currentdir().."/.." ) -- voltar para o diretório inicial
		end
	else
		return false
	end
end
M.buscarAmazenamentosAndroid = buscarAmazenamentosAndroid

local function criarPastaAndroid(atributos) -- caminho e pasta
	local data = os.date( "*t" )
	local pasta = atributos.pasta or "novaPasta"..data.year..data.month..data.day..data.hour..data.min..data.sec
	local caminho = atributos.caminho or "sdcard/"
	
	local lfs = require( "lfs" )
	while lfs.currentdir() ~= "/" do
		lfs.chdir( lfs.currentdir().."/.." ) -- voltar para o diretório inicial
	end
	
	local success = lfs.chdir( caminho )
	if success then
		lfs.mkdir( pasta ) -- criar pasta principal na raiz do sdcard
	end
	
	
	while lfs.currentdir() ~= "/" do
		lfs.chdir( lfs.currentdir().."/.." ) -- voltar para o diretório inicial
	end
end
M.criarPastaAndroid = criarPastaAndroid

local function lerArquivoAndroid(atrib)
	local caminho = atrib.caminho or "sdcard/Download"
	local validarUTF8 = require("utf8Validator")
	local vetor = {}
	local path = caminho .. "/" .. atrib.arquivo
	local file, errorString = io.open( path, "r" )
	local xx=1
	if not file then
		print( "File error: " .. errorString )
	else
		local contents = file:read( "*a" )
		
		local filtrado = string.gsub(contents,".",{ ["\13"] = "",["\10"] = "\13\10"})
		
		for line in string.gmatch(filtrado,"([^\13\10]+)") do
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
	file = nil
	return vetor
end
M.lerArquivoAndroid = lerArquivoAndroid

local function lerArquivoCodificadoAndroid(atrib)
	local mime = require("mime")
	local validarUTF8 = require("utf8Validator")
	local caminho = atrib.caminho or "sdcard/Download"
	
	local vetor = {}
	local path = caminho .. "/" .. atrib.arquivo
	local file, errorString = io.open( path, "r" )
	local xx=1
	--testarNoAndroid(tostring(path),50)
	if not file then
		print( "File error: " .. errorString )
		--testarNoAndroid("|"..tostring(errorString).."|",100)
	else
		local contents = file:read( "*a" )
		--testarNoAndroid("|"..tostring(contents).."|",100)
		local tudo = string.gsub(contents,"&cH&","a")
		tudo = mime.unb64(tudo)
		local filtrado = string.gsub(tudo,".",{ ["\13"] = "",["\10"] = "\13\10"})
		
		for line in string.gmatch(filtrado,"([^\13\10]+)") do
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
	file = nil
	return vetor
end
M.lerArquivoCodificadoAndroid = lerArquivoCodificadoAndroid

return M