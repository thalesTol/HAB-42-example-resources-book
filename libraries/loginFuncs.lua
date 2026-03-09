-- Biblioteca de funções para o login do usuário
local android = require("ManejarArquivosAndroid")
local M = {}

function M.lerArquivoAndroidParaLoginCegos(atrib,vars)
	local vars = {}
	vars.vetorPastasAndroid = {}
	if tipoSistema == "android" then
		if auxFuncs.hasPhonePermission("android.permission.WRITE_EXTERNAL_STORAGE") then--"android.permission.WRITE_EXTERNAL_STORAGE"
			android.buscarAmazenamentosAndroid(vars.vetorPastasAndroid)
		end
	end 
	if vars.vetorPastasAndroid.armazenamentoInterno then
		vars.vetorAndroidLogin = android.lerArquivoCodificadoAndroid({caminho = vars.vetorPastasAndroid.armazenamentoInterno.."/"..atrib.pasta,arquivo = atrib.arquivo})
		-- pegar os dados do arquivo android para que seja realizado o login no livro
		if vars.vetorAndroidLogin then
			for j=1,#vars.vetorAndroidLogin do
				--testarNoAndroid(vars.vetorAndroidLogin[j],50 + 30*j)
				if vars.vetorAndroidLogin[j] ~= nil then
					
					if string.find( vars.vetorAndroidLogin[j]:match("([^=]+)="), "login" ) ~= nil then
						local aux = nil
						local lixo,str = vars.vetorAndroidLogin[j]:match("([^=]+)=+([^\13]+)")
						for past in string.gmatch(str, '%s*(.+)') do
							aux = past
						end
						vars.vetorAndroidLogin.login = aux
					end
					if string.find( vars.vetorAndroidLogin[j]:match("([^=]+)="), "senha" ) ~= nil then
						local aux = nil
						local lixo,str = vars.vetorAndroidLogin[j]:match("([^=]+)=+([^\13]+)")
						for past in string.gmatch(str, '%s*(.+)') do
							aux = past
						end
						vars.vetorAndroidLogin.senha = aux
					end
					if string.find( vars.vetorAndroidLogin[j]:match("([^=]+)="), "email" ) ~= nil then
						local aux = nil
						local lixo,str = vars.vetorAndroidLogin[j]:match("([^=]+)=+([^\13]+)")
						for past in string.gmatch(str, '%s*(.+)') do
							aux = past
						end
						vars.vetorAndroidLogin.email = aux
					end
					if string.find( vars.vetorAndroidLogin[j]:match("([^=]+)="), "nome" ) ~= nil then
						local aux = nil
						local lixo,str = vars.vetorAndroidLogin[j]:match("([^=]+)=+([^\13]+)")
						for past in string.gmatch(str, '%s*(.+)') do
							aux = past
						end
						vars.vetorAndroidLogin.nome = aux
					end
					if string.find( vars.vetorAndroidLogin[j]:match("([^=]+)="), "ID" ) ~= nil then
						local aux = nil
						local lixo,str = vars.vetorAndroidLogin[j]:match("([^=]+)=+([^\13]+)")
						for past in string.gmatch(str, '%s*(.+)') do
							aux = past
						end
						vars.vetorAndroidLogin.id = aux
					end
				end
			end
		end		
	end
end



return M