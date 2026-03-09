	local M = {}

	local function testarNoAndroid(texto,posicaoy)
				texto = display.newText(texto,0,posicaoy,display.contentWidth,0,native.systemFont,20)
				texto.anchorX = 0;texto.anchorY = 0
				texto.x=20
				texto:setFillColor(1,0,0)
				return texto
	end
	local function filtrar_palavras(palavra)
		local filtro = {
			"ele","ela","eles","elas","eu","tu","você","vocês","nós","vós","VOCÊ","VOCÊS",
			"dele","dela","deles","delas",
			"daquele","daquela","daquilo","daqueles","daquelas",
			"do","da","dos","das",
			"a","o","as","os",
			"no","na","nos","nas",
			"esse","essa","esses","essas","nesse","nessa","nesses","nessas","isso","nisso",
			"este","esta","estes","estas","neste","nesta","nestes","nestas","nisto","isto",
			"desse","dessa","deste","desta","disto","desses","dessas","destes","destas",
			"aquele","aquela","aqueles","aquelas","aquilo",
			"um","uma","uns","umas",
			"seu","seus","sua","suas",
			"pelo","pela","pelos","pelas",
			"ao","à","às","À","ÀS",
			"de","que","em","e","para","mas","por","quê","QUÊ","com","mesmo","mesma","portanto","entretanto","qual","quando","tanto","quanto","assim","tão","TÃO","como",
			"se","senão","SENÃO","cada","então","ENTÃO","até","ATÉ",
			"menos","mais","dobro","triplo","metade","dezena","centena",
			"milhão","bilhão","trilhão","mil","MILHÃO","BILHÃO","TRILHÃO","milhões","MILHÕES","bilhões","BILHÕES","trilhões","TRILHÕES",
			"dois","três","quatro","cinco","seis","sete","oito","nove",
			"dez","vinte","trinta","quarenta","cinquenta","sessenta","setenta","oitenta","noventa","cem",
			"é","são","SÃO","É",
			"sim","não","NÃO"
		}
		local descartar = false
		for l=1,#filtro do
			if string.len(palavra) == 1 or string.lower(palavra) == filtro[l] or palavra == string.upper(filtro[l]) then
				descartar = true
				l = #filtro
			end
		end
		return descartar
	end
	M.filtrar_palavras = filtrar_palavras
	local function converterUTFsemBoomparaANSI(texto)
		texto = string.gsub(texto,".", 
		{ ['\195\64'] = '\128',
		  ['\195\65'] = '\129',
		  ['\195\66'] = '\130',
		  ['\195\67'] = '\131',
		  ['\195\68'] = '\132',
		  ['\195\69'] = '\133',
		  ['\195\70'] = '\134',
		  ['\195\71'] = '\135',
		  ['\195\72'] = '\136',
		  ['\195\73'] = '\137',
		  ['\195\74'] = '\138',
		  ['\195\75'] = '\139',
		  ['\195\76'] = '\140',
		  ['\195\77'] = '\141',
		  ['\195\78'] = '\142',
		  ['\195\79'] = '\143',
		  ['\195\80'] = '\144',
		  ['\195\81'] = '\145',
		  ['\195\82'] = '\146',
		  ['\34'] = '\147',
		  ['\34'] = '\148',
		  ['\195\85'] = '\149',
		  ['\45'] = '\150',
		  ['\195\87'] = '\151',
		  ['\195\88'] = '\152',
		  ['\195\89'] = '\153',
		  ['\195\90'] = '\154',
		  ['\195\91'] = '\155',
		  ['\195\92'] = '\156',
		  ['\195\93'] = '\157',
		  ['\195\94'] = '\158',
		  ['\195\95'] = '\159',
		  ['\195\96'] = '\160',
		  ['\195\97'] = '\161',
		  ['\195\98'] = '\162',
		  ['\195\99'] = '\163',
		  ['\195\100'] = '\164',
		  ['\195\101'] = '\165',
		  ['\195\102'] = '\166',
		  ['\195\103'] = '\167',
		  ['\195\104'] = '\168',
		  ['\195\105'] = '\169',
		  ['\195'] = '\170',
		  ['\195\107'] = '\171',
		  ['\195\108'] = '\172',
		  ['\195\109'] = '\173',
		  ['\195\110'] = '\174',
		  ['\195\111'] = '\175',
		  ['\195\112'] = '\176',
		  ['\195\113'] = '\177',
		  ['\195\114'] = '\178',
		  ['\195\115'] = '\179',
		  ['\195\116'] = '\180',
		  ['\195\117'] = '\181',
		  ['\195\118'] = '\182',
		  ['\195\119'] = '\183',
		  ['\195\120'] = '\184',
		  ['\195\121'] = '\185',
		  ['\195\186'] = '\186',
		  ['\195\123'] = '\187',
		  ['\195\124'] = '\188',
		  ['\195\125'] = '\189',
		  ['\195\126'] = '\190',
		  ['\195\127'] = '\191',
		  ['\195\128'] = '\192',
		  ['\195\129'] = '\193',
		  ['\195\130'] = '\194',
		  ['\195\131'] = '\195',
		  ['\195\132'] = '\196',
		  ['\195\133'] = '\197',
		  ['\195\134'] = '\198',
		  ['\195\135'] = '\199',
		  ['\195\136'] = '\200',
		  ['\195\137'] = '\201',
		  ['\195\138'] = '\202',
		  ['\195\139'] = '\203',
		  ['\195\140'] = '\204',
		  ['\195\141'] = '\205',
		  ['\195\142'] = '\206',
		  ['\195\143'] = '\207',
		  ['\195\144'] = '\208',
		  ['\195\145'] = '\209',
		  ['\195\146'] = '\210',
		  ['\195\147'] = '\211',
		  ['\195\148'] = '\212',
		  ['\195\149'] = '\213',
		  ['\195\150'] = '\214',
		  ['\195\151'] = '\215',
		  ['\195\152'] = '\216',
		  ['\195\153'] = '\217',
		  ['\195\154'] = '\218',
		  ['\195\155'] = '\219',
		  ['\195\156'] = '\220',
		  ['\195\157'] = '\221',
		  ['\195\158'] = '\222',
		  ['\195\159'] = '\223',
		  ['\195\160'] = '\224',
		  ['\195\161'] = '\225',
		  ['\195\162'] = '\226',
		  ['\195\163'] = '\227',
		  ['\195\164'] = '\228',
		  ['\195\165'] = '\229',
		  ['\195\166'] = '\230',
		  ['\195\167'] = '\231',
		  ['\195\168'] = '\232',
		  ['\195\169'] = '\233',
		  ['\195\170'] = '\234',
		  ['\195\171'] = '\235',
		  ['\195\172'] = '\236',
		  ['\195\173'] = '\237',
		  ['\195\174'] = '\238',
		  ['\195\175'] = '\239',
		  ['\195\176'] = '\240',
		  ['\195\177'] = '\241',
		  ['\195\178'] = '\242',
		  ['\195\179'] = '\243',
		  ['\195\180'] = '\244',
		  ['\195\181'] = '\245',
		  ['\195\182'] = '\246',
		  ['\195\183'] = '\247',
		  ['\195\184'] = '\248',
		  ['\195\185'] = '\249',
		  ['\195\186'] = '\250',
		  ['\195\187'] = '\251',
		  ['\195\188'] = '\252',
		  ['\195\189'] = '\253',
		  ['\195\190'] = '\254',
		  ['\195\191'] = '\255'})
		
		
		return texto
	end
	M.converterUTFsemBoomparaANSI = converterUTFsemBoomparaANSI
	local function converterANSIparaUTFsemBoom(texto)
		texto = string.gsub(texto,".", 
		{ ['\128'] = '\195\64',
		  ['\129'] = '\195\65',
		  ['\130'] = '\195\66',
		  ['\131'] = '\195\67',
		  ['\132'] = '\195\68',
		  ['\133'] = '\195\69',
		  ['\134'] = '\195\70',
		  ['\135'] = '\195\71',
		  ['\136'] = '\195\72',
		  ['\137'] = '\195\73',
		  ['\138'] = '\195\74',
		  ['\139'] = '\195\75',
		  ['\140'] = '\195\76',
		  ['\141'] = '\195\77',
		  ['\142'] = '\195\78',
		  ['\143'] = '\195\79',
		  ['\144'] = '\195\80',
		  ['\145'] = '\195\81',
		  ['\146'] = '-',
		  ['\147'] = '"',
		  ['\148'] = '"',
		  ['\149'] = '\195\85',
		  ['\150'] = '-',
		  ['\151'] = '\195\87',
		  ['\152'] = '\195\88',
		  ['\153'] = '\195\89',
		  ['\154'] = '\195\90',
		  ['\155'] = '\195\91',
		  ['\156'] = '\195\92',
		  ['\157'] = '\195\93',
		  ['\158'] = '\195\94',
		  ['\159'] = '\195\95',
		  ['\160'] = '\195\96',
		  ['\161'] = '\195\97',
		  ['\162'] = '\195\98',
		  ['\163'] = '\195\99',
		  ['\164'] = '\195\100',
		  ['\165'] = '\195\101',
		  ['\166'] = '\195\102',
		  ['\167'] = '\195\103',
		  ['\168'] = '\195\104',
		  ['\169'] = '\195\105',
		  ['\170'] = 'ª',
		  ['\171'] = '\195\107',
		  ['\172'] = '\195\108',
		  ['\173'] = '-',
		  ['\174'] = '\195\110',
		  ['\175'] = '\195\111',
		  ['\176'] = '\195\112',
		  ['\177'] = '\195\113',
		  ['\178'] = '\195\114',
		  ['\179'] = '\195\115',
		  ['\180'] = "'",
		  ['\181'] = '\195\117',
		  ['\182'] = '\195\118',
		  ['\183'] = '\195\119',
		  ['\184'] = '\195\120',
		  ['\185'] = '\195\121',
		  ['\186'] = 'º',
		  ['\187'] = '\195\123',
		  ['\188'] = '\195\124',
		  ['\189'] = '\195\125',
		  ['\190'] = '\195\126',
		  ['\191'] = '\195\127',
		  ['\192'] = '\195\128',
		  ['\193'] = '\195\129',
		  ['\194'] = '\195\130',
		  ['\195'] = '\195\131',
		  ['\196'] = '\195\132',
		  ['\197'] = '\195\133',
		  ['\198'] = '\195\134',
		  ['\199'] = '\195\135',
		  ['\200'] = '\195\136',
		  ['\201'] = '\195\137',
		  ['\202'] = '\195\138',
		  ['\203'] = '\195\139',
		  ['\204'] = '\195\140',
		  ['\205'] = '\195\141',
		  ['\206'] = '\195\142',
		  ['\207'] = '\195\143',
		  ['\208'] = '\195\144',
		  ['\209'] = '\195\145',
		  ['\210'] = '\195\146',
		  ['\211'] = '\195\147',
		  ['\212'] = '\195\148',
		  ['\213'] = '\195\149',
		  ['\214'] = '\195\150',
		  ['\215'] = '\195\151',
		  ['\216'] = '\195\152',
		  ['\217'] = '\195\153',
		  ['\218'] = '\195\154',
		  ['\219'] = '\195\155',
		  ['\220'] = '\195\156',
		  ['\221'] = '\195\157',
		  ['\222'] = '\195\158',
		  ['\223'] = '\195\159',
		  ['\224'] = '\195\160',
		  ['\225'] = '\195\161',
		  ['\226'] = '\195\162', -- â
		  ['\227'] = '\195\163',
		  ['\228'] = '\195\164',
		  ['\229'] = '\195\165',
		  ['\230'] = '\195\166',
		  ['\231'] = '\195\167',
		  ['\232'] = '\195\168',
		  ['\233'] = '\195\169',
		  ['\234'] = '\195\170',
		  ['\235'] = '\195\171',
		  ['\236'] = '\195\172',
		  ['\237'] = '\195\173',
		  ['\238'] = '\195\174',
		  ['\239'] = '\195\175',
		  ['\240'] = '\195\176',
		  ['\241'] = '\195\177',
		  ['\242'] = '\195\178',
		  ['\243'] = '\195\179',
		  ['\244'] = '\195\180',
		  ['\245'] = '\195\181',
		  ['\246'] = '\195\182',
		  ['\247'] = '\195\183',
		  ['\248'] = '\195\184',
		  ['\249'] = '\195\185',
		  ['\250'] = '\195\186',
		  ['\251'] = '\195\187',
		  ['\252'] = '\195\188',
		  ['\253'] = '\195\189',
		  ['\254'] = '\195\190',
		  ['\255'] = '\195\191',
		  ['\255'] = '\195\191',})
		
		
		return texto
	end
	M.converterANSIparaUTFsemBoom = converterANSIparaUTFsemBoom
	
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
	
	local function lerTextoDoc(arquivo)
		local path = system.pathForFile( arquivo, system.DocumentsDirectory )
 
		local file, errorString = io.open( path, "r" )
		local contents = file:read( "*a" )
		io.close( file )
		 
		file = nil
		
		return contents
	end

	function M.stringLowerAcento(texto)

		texto = string.lower(texto)
		texto = string.gsub(texto,"Ç","ç")
		texto = string.gsub(texto,"Â","â")
		texto = string.gsub(texto,"Ã","ã")
		texto = string.gsub(texto,"À","à")
		texto = string.gsub(texto,"Á","á")
		
		texto = string.gsub(texto,"Ê","ê")
		texto = string.gsub(texto,"É","é")
		texto = string.gsub(texto,"è","è")
		
		texto = string.gsub(texto,"Î","î")
		texto = string.gsub(texto,"Í","í")
		texto = string.gsub(texto,"Ì","ì")
		
		texto = string.gsub(texto,"Ô","ô")
		texto = string.gsub(texto,"Õ","õ")
		texto = string.gsub(texto,"Ò","ò")
		texto = string.gsub(texto,"Ó","ó")
		
		texto = string.gsub(texto,"Û","û")
		texto = string.gsub(texto,"Ù","ù")
		texto = string.gsub(texto,"Ú","ú")
		texto = string.gsub(texto,"Ü","ü")
		
		return texto
	end
	
	function M.stringUpperAcento(texto)

		texto = string.upper(texto)
		texto = string.gsub(texto,"ç","Ç")
		texto = string.gsub(texto,"â","Â")
		texto = string.gsub(texto,"ã","Ã")
		texto = string.gsub(texto,"à","À")
		texto = string.gsub(texto,"á","Á")
		
		texto = string.gsub(texto,"ê","Ê")
		texto = string.gsub(texto,"é","É")
		texto = string.gsub(texto,"è","è")
		
		texto = string.gsub(texto,"î","Î")
		texto = string.gsub(texto,"í","Í")
		texto = string.gsub(texto,"ì","Ì")
		
		texto = string.gsub(texto,"ô","Ô")
		texto = string.gsub(texto,"õ","Õ")
		texto = string.gsub(texto,"ò","Ò")
		texto = string.gsub(texto,"ó","Ó")
		
		texto = string.gsub(texto,"û","Û")
		texto = string.gsub(texto,"ù","Ù")
		texto = string.gsub(texto,"ú","Ú")
		texto = string.gsub(texto,"ü","Ü")
		
		return texto
	end
	
	local function converterTextoParaFala(texto,substituicoesOnline,tipo)
		local vetor = {}

		--lei-------------------------------------
		--[[
		local vetorItens = {}
		for k in string.gmatch(texto,"\n%a%)") do
			table.insert(vetorItens,k)
		end
		for i=1,#vetorItens do
			local aux = string.gsub(vetorItens[i],'%)',',;')
			local aux = string.gsub(aux,'\n','')
			local aux2 = string.gsub(vetorItens[i],'%)','%%)')
			texto = string.gsub(texto,aux2,"\nItem, "..aux)
		end
		]]
		------------------------------------------
		
		
		--[[texto = string.gsub(texto,'%(',',,')
		texto = string.gsub(texto,'%)',',,')
		texto = string.gsub(texto,'%(','%. Aspas%.!')
		texto = string.gsub(texto,'%(','%. apóstrofo%.!')
		--texto = string.gsub(texto,'\32','\32%.%.')
		texto = string.gsub(texto,' %- ',',%-,')
		texto = string.gsub(texto,' cegos',' cégos')
		texto = string.gsub(texto,' notoriais',' notôriais')
		texto = string.gsub(texto,' visores',' visôris')
		texto = string.gsub(texto,'Por que','Por quê')
		texto = string.gsub(texto,' detalha',' detálha')
		texto = string.gsub(texto,'Cegos','Cégos')
		texto = string.gsub(texto,'Notoriais','Notôriais')
		texto = string.gsub(texto,'Visores','Visôris')
		texto = string.gsub(texto,'Detalha','Detálha')
		texto = string.gsub(texto,'sobre','sôbre')
		texto = string.gsub(texto,'SOBRE','SÔBRE')
		
		texto = string.gsub(texto,' desse',' dêsse')
		texto = string.gsub(texto,' chimbal',' chimbál')
		texto = string.gsub(texto,' acordo',' acôrdo')
		texto = string.gsub(texto,'pode%-se','póde%-se')
		texto = string.gsub(texto,' acorde',' acórde')
		texto = string.gsub(texto,' apresentadas',' aprezentadas')
		texto = string.gsub(texto,' vez',' vêz')
		texto = string.gsub(texto,'Obs','Observação')
		texto = string.gsub(texto,'obs','observação')
		
		texto = string.gsub(texto,' utiliza-se','utilííza-se')
		texto = string.gsub(texto,'sabe%-se','sábe%-se')
		texto = string.gsub(texto,'coloca%-se','colóca%-se')
		texto = string.gsub(texto,'compassos','compáássos')
		texto = string.gsub(texto,'deve%-se','déve%-se')
		texto = string.gsub(texto,'exemplifica','exemplifííca')
		
		texto = string.gsub(texto,'ilustra','ilústra')
		texto = string.gsub(texto,'Desse','Dêsse')
		texto = string.gsub(texto,'Chimbal','Chimbál')
		texto = string.gsub(texto,'Acordo','Acôrdo')
		texto = string.gsub(texto,'Pode%-se','Póde%-se')
		texto = string.gsub(texto,'Acorde','Acórde')
		texto = string.gsub(texto,'Apresentadas','Aprezentadas')
		texto = string.gsub(texto,'Vez','Vêz')
		texto = string.gsub(texto,'Utiliza%-se','Utilíza%-se')
		texto = string.gsub(texto,'Sabe%-se','Sábe%-se')
		texto = string.gsub(texto,'Coloca%-se','Colóca%-se')
		texto = string.gsub(texto,'Compassos','Compáássos')
		texto = string.gsub(texto,'Deve%-se','Déve%-se')
		texto = string.gsub(texto,'Exemplifica','Exemplifííca')
		texto = string.gsub(texto,'Ilustra','Ilústra')
		texto = string.gsub(texto,'especificada','especificáda')
		texto = string.gsub(texto,'especifica','especifííca')
		texto = string.gsub(texto,'Especifica','Especifííca')
		
		
		
		texto = string.gsub(texto,'ligadura','ligaduura')
		texto = string.gsub(texto,'assemelha%-se','assemêlha%-se')
		texto = string.gsub(texto,'cifrada','cifráda')
		
		texto = string.gsub(texto,'nota%-se','nóta%-se')
		texto = string.gsub(texto,' que ',' quê ')
		texto = string.gsub(texto,' que,',' quê,')
		texto = string.gsub(texto,',que ',',quê ')
		texto = string.gsub(texto,'ncontra%-se','ncoontra%-se')--e
		texto = string.gsub(texto,'ncontram%-se','ncoontram%-se')--e
		texto = string.gsub(texto,'emorizados','emorizaados')--m
		texto = string.gsub(texto,'numéric','numeéric')--a o os
		texto = string.gsub(texto,'diférem%-se','diféérem%-se')
		texto = string.gsub(texto,'tilizando%-se','tilizândo%-se')--u
		texto = string.gsub(texto,'iferencia','iferencíía')--d
		texto = string.gsub(texto,'sa%-se','usa%-se')--u
		texto = string.gsub(texto,'frequência','frecuência')
		texto = string.gsub(texto,'acentos','assentos')
		texto = string.gsub(texto,'Acentos','Assentos')
		texto = string.gsub(texto,' deste ',' dêste ')
		texto = string.gsub(texto,',deste',',dêste')
		texto = string.gsub(texto,' deste,',' dêste,')
		texto = string.gsub(texto,' deste.',' dêste.')
		texto = string.gsub(texto,'fortíssimo','fortííssimo')
		texto = string.gsub(texto,'Numerofonia','Numerofoníía')
		texto = string.gsub(texto,'memorizem','memoríízem')
		texto = string.gsub(texto,' vazia ',' vazíía ')
		texto = string.gsub(texto,' vazia.',' vazíía.')
		texto = string.gsub(texto,',vazia ',',vazíía ')
		texto = string.gsub(texto,' vazia,',' vazíía,')
		texto = string.gsub(texto,' vazias ',' vazíías ')
		texto = string.gsub(texto,' vazias.',' vazíías.')
		texto = string.gsub(texto,',vazias ',',vazíías ')
		texto = string.gsub(texto,' vazias,',' vazíías,')
		texto = string.gsub(texto,'situam%-se','sitúúam%-se')
		texto = string.gsub(texto,'quiálteras','quiáálteras')
		texto = string.gsub(texto,'Quiálteras','Quiáálteras')
		texto = string.gsub(texto,'mostra-se','móstra-se')
		texto = string.gsub(texto,'compasso','compáásso')
		texto = string.gsub(texto,'binária','binááária')
		texto = string.gsub(texto,'ternária','ternááária')
		texto = string.gsub(texto,'situando%-se','situuando%-se')
		texto = string.gsub(texto,'pontuada','pontuááda')
		texto = string.gsub(texto,'situam','situuuam')
		texto = string.gsub(texto,'codificado','codificááádo')
		texto = string.gsub(texto,'fecham','feécham')
		texto = string.gsub(texto,'acompanhantes','acompanhaantes')-- palavra sozinha
		texto = string.gsub(texto,',extra ',',êxtra ')
		texto = string.gsub(texto,' extra ',' êxtra ')
		texto = string.gsub(texto,' extra,',' êxtra,')
		texto = string.gsub(texto,' extra.',' êxtra.')
		texto = string.gsub(texto,'semínima','semíínima')
		texto = string.gsub(texto,'itornello','itornééllo')--R
		texto = string.gsub(texto,'ilustrada','ilustraada') -- com mais palavras junto
		texto = string.gsub(texto,'uaternari','uaternááári')--q -- a/o
		texto = string.gsub(texto,' pausa ',' pá usa ')
		texto = string.gsub(texto,' pausa,',' pá usa,')
		texto = string.gsub(texto,' pausa%.',' pá usa%.')
		texto = string.gsub(texto,',pausa ',',pá usa ')
		texto = string.gsub(texto,'Ex:','Exemplo:')
		texto = string.gsub(texto,'sequência','secuência')
		texto = string.gsub(texto,'apresentando','aprezentando')
		
		texto = string.gsub(texto,'tablaturas','tablatúúras')
		texto = string.gsub(texto,'Tablaturas','Tablatúúras')
		texto = string.gsub(texto,'tocada','tocááda')
		texto = string.gsub(texto,'apresentadas','aprezentáádas')
		texto = string.gsub(texto,'pressionadas','pressionááádas')
		texto = string.gsub(texto,'numérica','numéérica')
		texto = string.gsub(texto,'preexistente','pré existente')
		texto = string.gsub(texto,'subitem','subi item')
		texto = string.gsub(texto,'memorizadas','memorizádas')
		texto = string.gsub(texto,'diferencia%-se','diferencíía%-se')
		texto = string.gsub(texto,'executá%-la','executáá%-la')
		texto = string.gsub(texto,'possuem','possúúem')
		texto = string.gsub(texto,'sforzato','isforzato')
		
		texto = string.gsub(texto,'intensidades','intensidáádes')
		texto = string.gsub(texto,'decorados','decoraados')
		texto = string.gsub(texto,'modificam','modifíícam')
		texto = string.gsub(texto,'smoke on the water','ismôuke on dê uóótér')
		texto = string.gsub(texto,'deep purple','diipe paôrpo')
		texto = string.gsub(texto,'Deep Purple','diipe paôrpo')
		texto = string.gsub(texto,'DEEP PURPLE','diipe paôrpo')
		texto = string.gsub(texto,'Deep purple','diipe paôrpo')
		texto = string.gsub(texto,'comparamos','comparãmos')
		texto = string.gsub(texto,'codificações','codificaçõões')
		texto = string.gsub(texto,'harmônico','harmôônico')
		
		
		texto = string.gsub(texto,'tv','têvê')
		
		
		
		-- correção da correção --
		texto = string.gsub(texto,'Exemplifíícar','Exemplificar')
		texto = string.gsub(texto,'exemplifíícar','exemplificar')
		texto = string.gsub(texto,'specifíícad','specificad')
		texto = string.gsub(texto,'xemplifíícad','xemplificad')
		texto = string.gsub(texto,'xemplifíícand','xemplificand')
		texto = string.gsub(texto,'iferencííad','iferenciad')
		texto = string.gsub(texto,'conéctad','conectad')
		--------------------------
		
		texto = string.gsub(texto,'night','naijit')
		texto = string.gsub(texto,'writing','uraiting')
		
		texto = string.gsub(texto,'nºs','números')
		texto = string.gsub(texto,'nº','número')
		texto = string.gsub(texto,'Nº','número')
		texto = string.gsub(texto,'/',',barra,')
		texto = string.gsub(texto,'\195\103','!parágrafo!')
		
		if #substituicoesOnline.original > 0 then
			for i=1,#substituicoesOnline.original do
				texto = string.gsub(texto,substituicoesOnline.original[i],substituicoesOnline.novo[i])
			end
		end]]
		-- LEIS --
		--[[
		texto = string.gsub(texto,'Art%.','Artigo,;')
		texto = string.gsub(texto,'art%.','artigo,;')
		texto = string.gsub(texto,'LIVRO VIII,-,','LIVRO 8,;')
		texto = string.gsub(texto,'LIVRO VII,-,','LIVRO 7,;')
		texto = string.gsub(texto,'LIVRO VI,-,','LIVRO 6,;')
		texto = string.gsub(texto,'LIVRO V,-,','LIVRO 5,;')
		texto = string.gsub(texto,'LIVRO IV,-,','LIVRO 4,;')
		texto = string.gsub(texto,'LIVRO III,-,','LIVRO 3,;')
		texto = string.gsub(texto,'LIVRO II,-,','LIVRO 2,;')
		texto = string.gsub(texto,'LIVRO I,-,','LIVRO 1,;')
		texto = string.gsub(texto,'TÍTULO XVI,-,','TÍTULO 16,;')
		texto = string.gsub(texto,'TÍTULO XV,-,','TÍTULO 15,;')
		texto = string.gsub(texto,'TÍTULO XIV,-,','TÍTULO 14,;')
		texto = string.gsub(texto,'TÍTULO XIII,-,','TÍTULO 13,;')
		texto = string.gsub(texto,'TÍTULO XII,-,','TÍTULO 12,;')
		texto = string.gsub(texto,'TÍTULO XI,-,','TÍTULO 11,;')
		texto = string.gsub(texto,'TÍTULO X,-,','TÍTULO 10,;')
		texto = string.gsub(texto,'TÍTULO IX,-,','TÍTULO 9,;')
		texto = string.gsub(texto,'TÍTULO VIII,-,','TÍTULO 8,;')
		texto = string.gsub(texto,'TÍTULO VII,-,','TÍTULO 7,;')
		texto = string.gsub(texto,'TÍTULO VI,-,','TÍTULO 6,;')
		texto = string.gsub(texto,'TÍTULO V,-,','TÍTULO 5,;')
		texto = string.gsub(texto,'TÍTULO IV,-,','TÍTULO 4,;')
		texto = string.gsub(texto,'TÍTULO III,-,','TÍTULO 3,;')
		texto = string.gsub(texto,'TÍTULO II,-,','TÍTULO 2,;')
		texto = string.gsub(texto,'TÍTULO I,-,','TÍTULO 1,;')
		texto = string.gsub(texto,'CAPÍTULO XVI,-,','CAPÍTULO 16,;')
		texto = string.gsub(texto,'CAPÍTULO XV,-,','CAPÍTULO 15,;')
		texto = string.gsub(texto,'CAPÍTULO XIV,-,','CAPÍTULO 14,;')
		texto = string.gsub(texto,'CAPÍTULO XIII,-,','CAPÍTULO 13,;')
		texto = string.gsub(texto,'CAPÍTULO XII,-,','CAPÍTULO 12,;')
		texto = string.gsub(texto,'CAPÍTULO XI,-,','CAPÍTULO 11,;')
		texto = string.gsub(texto,'CAPÍTULO X,-,','CAPÍTULO 10,;')
		texto = string.gsub(texto,'CAPÍTULO IX,-,','CAPÍTULO 9,;')
		texto = string.gsub(texto,'CAPÍTULO VIII,-,','CAPÍTULO 8,;')
		texto = string.gsub(texto,'CAPÍTULO VII,-,','CAPÍTULO 7,;')
		texto = string.gsub(texto,'CAPÍTULO VI,-,','CAPÍTULO 6,;')
		texto = string.gsub(texto,'CAPÍTULO V,-,','CAPÍTULO 5,;')
		texto = string.gsub(texto,'CAPÍTULO IV,-,','CAPÍTULO 4,;')
		texto = string.gsub(texto,'CAPÍTULO III,-,','CAPÍTULO 3,;')
		texto = string.gsub(texto,'CAPÍTULO II,-,','CAPÍTULO 2,;')
		texto = string.gsub(texto,'CAPÍTULO I,-,','CAPÍTULO 1,;')
		texto = string.gsub(texto,'\nXX,-,','\ninciso 20,;')
		texto = string.gsub(texto,'\nXIX,-,','\ninciso 19,;')
		texto = string.gsub(texto,'\nXVIII,-,','\ninciso 18,;')
		texto = string.gsub(texto,'\nXVII,-,','\ninciso 17,;')
		texto = string.gsub(texto,'\nXVI,-,','\ninciso 16,;')
		texto = string.gsub(texto,'\nXV,-,','\ninciso 15,;')
		texto = string.gsub(texto,'\nXIV,-,','\ninciso 14,;')
		texto = string.gsub(texto,'\nXIII,-,','\ninciso 13,;')
		texto = string.gsub(texto,'\nXII,-,','\ninciso 12,;')
		texto = string.gsub(texto,'\nXI,-,','\ninciso onze,;')
		texto = string.gsub(texto,'\nIX,-,','\ninciso nove,;')
		texto = string.gsub(texto,'\nX,-,','\ninciso dez,;')
		texto = string.gsub(texto,'\nVIII,-,','\ninciso oito,;')
		texto = string.gsub(texto,'\nVII,-,','\ninciso sete,;')
		texto = string.gsub(texto,'\nVI,-,','\ninciso seis,;')
		texto = string.gsub(texto,'\nIV,-,','\ninciso quatro,;')
		texto = string.gsub(texto,'\nIII,-,','\ninciso três,;')
		texto = string.gsub(texto,'\nII,-,','\ninciso dois,;')
		texto = string.gsub(texto,'\nI,-,','\ninciso um,;')
		texto = string.gsub(texto,'\nV,-,','\ninciso cinco,;')
		]]
		
		-----------------
		print("substituicoesOnline",substituicoesOnline)
		print("substituicoesOnline.original",substituicoesOnline.original)
		if substituicoesOnline and substituicoesOnline.original and #substituicoesOnline.original > 0 then
			print("texto antes = ",texto)
			for i=1,#substituicoesOnline.original do
				local function trocarTexto(fonte, encontre, trocar, wholeword)
					if wholeword then
						encontre = "%f[^%z%s]"..encontre.."%f[%z%s]"
					end
					return (fonte:gsub(encontre,trocar))
				end
				texto = trocarTexto(texto, substituicoesOnline.original[i], substituicoesOnline.novo[i], true)
				
			end
			print("texto depois = ",texto)
		end
		
		local subOnline = {}
		texto = string.lower(texto)
		texto = string.gsub(texto,"Ç","ç")
		texto = string.gsub(texto,"Â","â")
		texto = string.gsub(texto,"Ã","ã")
		texto = string.gsub(texto,"À","à")
		texto = string.gsub(texto,"Á","á")
		
		texto = string.gsub(texto,"Ê","ê")
		texto = string.gsub(texto,"É","é")
		texto = string.gsub(texto,"è","è")
		
		texto = string.gsub(texto,"Î","î")
		texto = string.gsub(texto,"Í","í")
		texto = string.gsub(texto,"Ì","ì")
		
		texto = string.gsub(texto,"Ô","ô")
		texto = string.gsub(texto,"Õ","õ")
		texto = string.gsub(texto,"Ò","ò")
		texto = string.gsub(texto,"Ó","ó")
		
		texto = string.gsub(texto,"Û","û")
		texto = string.gsub(texto,"Ù","ù")
		texto = string.gsub(texto,"Ú","ú")
		texto = string.gsub(texto,"Ü","ü")

		if fileExistsDoc("substituicoes.txt") then
			local subOnlineAux = lerTextoDoc("substituicoes.txt")
			local filtrado = string.gsub(subOnlineAux,".",{ ["\13"] = "",["\10"] = "\13\10"})
			local subOnlineAux2 = {}
			for line in string.gmatch(filtrado,"([^\13\10]+)") do
				local aux1,aux2 = string.match(line,"(.+)||(.+)")
				if string.find(aux1,"%s") then -- se é mais de uma palavra
					texto = string.gsub(texto,aux1,aux2)
				else -- se é uma única palavra
					table.insert(subOnlineAux2,{aux1,aux2})
				end
			end
			for i=1,#subOnlineAux2 do
				subOnline[subOnlineAux2[i][1]] = subOnlineAux2[i][2]
			end
			-- desenvolver substituicoes quando for uma única palavra
			
			texto = string.gsub(texto,"[^%s%p]+", subOnline)
			print("WARNING: 2",texto) --"[%w]+"
		end

		for k in string.gmatch(texto,"%d+%p%d+ ") do
			table.insert(vetor,k)
		end
		
		for k in string.gmatch(texto,"%d+%p%d+%-") do
			table.insert(vetor,k)
		end
		for k in string.gmatch(texto,"%d+%p%d+%p") do
			table.insert(vetor,k)
		end
		

		for i=1,#vetor do
			vetor[i] = string.gsub(vetor[i],"%[","%%[")
			local aux = string.gsub(vetor[i],'%.','%.ponto!')
			print(aux,vetor[i])
			texto = string.gsub(texto,vetor[i],aux)
		end
		texto = string.gsub(texto,'%.ponto!ponto!','%.ponto!')
		
		local vetor2 = {}
		for k in string.gmatch(texto,"\n%d+%p ") do
			table.insert(vetor2,k)
		end
		for k in string.gmatch(texto,"%.ponto!%d+ ") do
			table.insert(vetor2,k)
		end
		for i=1,#vetor2 do
			local aux = string.gsub(vetor2[i],' ',', ')
			texto = string.gsub(texto,vetor2[i],aux)
		end
		
		-- rodapés ----------------------------------------------------
		
		local vetor3 = {}
		

		
		for k in string.gmatch(texto,"%a%d") do
			table.insert(vetor3,k)
		end
		for k in string.gmatch(texto,"%d%a") do
			table.insert(vetor3,k)
		end
		
		
		for i=1,#vetor3 do
			local aux1 = string.sub(vetor3[i],1,1)
			local aux3 = string.sub(vetor3[i],2,2)
			local aux2 = ","
			texto = string.gsub(texto,vetor3[i],aux1..aux2..aux3)
		end
		
		
		---------------------------------------------------------------

		return texto,rodape
	end
	M.converterTextoParaFala = converterTextoParaFala
	
	
	
	local function substituirQuebrasDeLinha(texto)

		local textoAux = string.gsub(texto,"\n \n","#$*$#")
		textoAux = string.gsub(textoAux,"\n\n","#$*$#")			
		textoAux = string.gsub(textoAux," \n\n","#$*$#")
		textoAux = string.gsub(textoAux," \n \n","#$*$#")
		textoAux = string.gsub(textoAux,"%.\n\n","%.#$*$#")
		textoAux = string.gsub(textoAux,"%. \n\n","%.#$*$#")
		textoAux = string.gsub(textoAux,"%. \n \n","%.#$*$#")
		textoAux = string.gsub(textoAux,"%: \n\n","%:#$*$#")
		textoAux = string.gsub(textoAux,"%: \n \n","%:#$*$#")
		textoAux = string.gsub(textoAux," \n%. "," #$*$#%. ")
		textoAux = string.gsub(textoAux,"\n\t","#$*$#\t")
		textoAux = string.gsub(textoAux,"\n\n\t","#$*$#\t")
		textoAux = string.gsub(textoAux,"\n \n\t","#$*$#\t")
		textoAux = string.gsub(textoAux,"%. \n","%.#$*$#")
		textoAux = string.gsub(textoAux,"%.\n","%.#$*$#")

		-- lei --
		--[[
		textoAux = string.gsub(textoAux,";\n",";#$*$#")
		textoAux = string.gsub(textoAux,"; \n",";#$*$#")
		]]
		--
		
		local teste = {}
		local tabelaNumeroPontos = {}
		local palavras = {"Este","Estes","O","Os","A","As","Isso","Esse","Esses","Essa","Essas","Esta","Estas","Em","Desde","Por","Destaca-se","Dentre","Apesar","Pode-se","Na","Nas","No","Nos","Conforme","Uma","Porém","Além","Capacitar","Até","Atualmente","Para","Através","São","É","Algumas","Observe","Existem","Assim","Dessa","Como","Com","Ela","Um","Tal","Trabalhando","Após","Baseando","Hoje","Outro","Utilizando","Mesmo","Projetou-se","Ao","Cada"}
		
		for i=1,#palavras do
			textoAux = string.gsub(textoAux,'\n'..palavras[i].." ",'#$*$#'..palavras[i].." ")
		end
		
		
		for result in string.gmatch(textoAux,"%.%d%s\n") do
			table.insert(tabelaNumeroPontos,result)
		end
		for result in string.gmatch(textoAux,"%.%d%d%s\n") do
			table.insert(tabelaNumeroPontos,result)
		end
		for result in string.gmatch(textoAux,"%.[%d+]\n") do
			table.insert(tabelaNumeroPontos,result)
		end
		for result in string.gmatch(textoAux,"%s\n%d") do
			table.insert(tabelaNumeroPontos,result)
		end
		for result in string.gmatch(textoAux,"%. \n[A-Z]") do
			table.insert(tabelaNumeroPontos,result)
		end
		
		
		

		
		for i = 1,#tabelaNumeroPontos do
			local aux = string.gsub(tabelaNumeroPontos[i],'\n','#$*$#')
			textoAux = string.gsub(textoAux,tabelaNumeroPontos[i],aux)
		end
		
		
		textoAux = string.gsub(textoAux,"%: \n","%:#$*$#")
		
		for result in string.gmatch(textoAux,"%: \n[A-Z]") do
			table.insert(teste,result)
		end
		for result in string.gmatch(textoAux," \n[A-Z]") do
			table.insert(teste,result)
		end
		for result in string.gmatch(textoAux,"\n[A-Z]") do
			table.insert(teste,result)
		end
		for i = 1,#teste do
			local aux = string.gsub(teste[i],'\n',',')
			textoAux = string.gsub(textoAux,teste[i],aux)
		end
		
		
		
		--print("Warning: ")
		--print(textoAux)
		--testarNoAndroid(textoAux,0)
		--print("Warning: ")
		return textoAux
	end
	M.substituirQuebrasDeLinha = substituirQuebrasDeLinha
	
	local function SepararTextoDePDFemTextos(atributosGeral)
		
		local function lerArquivoTXT(atributos) -- vetor ou variavel

			local caminho2 = atributos.caminho.."\\"..atributos.arquivo
			local file2, errorString = io.open( caminho2, "r" )
			local texto = ""

			if not file2 then
				print( "File error: " .. errorString )
				return "Warning: !Erro ao ler o arquivo!"
			else
				texto = file2:read( "*a" )

				io.close( file2 )
				file2 = nil
				return texto
			end	
		end
		local function criarArquivoTXT(atributos) -- vetor ou variavel
			local caminho2 = atributos.caminho .. "\\" .. atributos.arquivo
			local file2 = io.open( caminho2, "w" )
			if file2 then
				if atributos.texto then
					file2:write(atributos.texto)
				end
				io.close( file2 )
				file2 = nil
				--native.showAlert("Arquivo criado com sucesso!", "\nNome do Arquivo:'"..atributos.arquivo.."'",{"ok"})
			else
				native.showAlert("Arquivo não criado!", "Falha ao tentar criar o arquivo, você não tem permissões para criar o arquivo em: '"..atributos.caminho.."'",{"ok"})
			end
		end
		
		local vetor = {}
		local texto = lerArquivoTXT({caminho = atributosGeral.caminho,arquivo = atributosGeral.arquivo})
		
		local numeroPagina = 1
		for pagina in string.gmatch(texto,"[^\f]+") do
			if pagina == "Warning: !Erro ao ler o arquivo!" then
				criarArquivoTXT({caminho = atributosGeral.caminho, arquivo = "_Erro_.txt",texto = pagina})
			else
				criarArquivoTXT({caminho = atributosGeral.caminho, arquivo = atributosGeral.nome..numeroPagina..".txt",texto = pagina})
			end
			numeroPagina = numeroPagina+1
			
		end
	end
	M.SepararTextoDePDFemTextos = SepararTextoDePDFemTextos
	
	
	
	local function reformatarArquivoIndice(textoIndiceOriginal)
		local vetorIndice = {}
		local vetorLinhas = {}
		for w in string.gmatch(textoIndiceOriginal, "[^\n]+") do
		   table.insert(vetorLinhas,w)
		end
		local vetorTitulos = {}
		local vetorNumeros = {}
		local vetorTipos = {}
		vetorNumeros[1] = 0
		vetorTipos[1] = ""
		local auxVetorLinhas = 1
		if string.match(vetorLinhas[1],"\t%d") or string.match(vetorLinhas[1],"[...]") or string.match(vetorLinhas[1],"%.\t%d") then
			table.insert(vetorTitulos,1," Sumário")
		else
			table.insert(vetorTitulos,1,vetorLinhas[1])
			auxVetorLinhas = 2
		end
		local auxNumber = 0
		for i=auxVetorLinhas,#vetorLinhas do
			local subString = string.sub(vetorLinhas[i],#vetorLinhas[i])
			--print(i.." = "..tostring(subString))
			local teste = string.find(subString,"%d")
			local testeResultado = false
			if teste ~= nil and i ~= #vetorLinhas then
				testeResultado = true
			end
			if testeResultado == true then
				local aux = ""
				local numero = 0
				for titulos in string.gmatch(vetorLinhas[i],"([^\t%.\n]+[^\n%d+]+)") do
					aux = aux .. titulos
					if string.match(aux,"%a") then
						aux = string.gsub(aux,"%.%.","")
						aux = string.gsub(aux,"\32%.\32","")
						table.insert(vetorTitulos,aux)
						--print("TITULOS = "..aux)
					end
					numero = numero + 1
				end
				if numero <=1 then
					table.insert(vetorTipos,"titulo")
				elseif numero == 2 then
					table.insert(vetorTipos,"subtitulo")
				elseif numero > 2 then
					table.insert(vetorTipos,"subtitulo2")
				else
					table.insert(vetorTipos,"titulo")
				end
				--print("tipo = "..vetorTipos[#vetorTipos])
				local auxiliarNumeros = string.reverse(vetorLinhas[i])
				
				local auxiliarNumerosResult = string.match(auxiliarNumeros,"(%d+[^%d])")

				if auxiliarNumerosResult == nil then
					-- mudando numero se não existir
					auxiliarNumerosResult = 1
				end
				
				local Reinvertido = string.reverse(auxiliarNumerosResult)
				--print("numero = "..Reinvertido)
				if i==auxVetorLinhas then
					auxNumber = tonumber(Reinvertido)
				end

				if auxNumber and (tonumber(Reinvertido)-auxNumber+1) < 1 then
					-- mudando numero se for menor que o anterior
					Reinvertido = auxNumber-1
				end
				
				if auxNumber and Reinvertido then
					table.insert(vetorNumeros,tonumber(Reinvertido)-auxNumber+1)
				else
					table.insert(vetorNumeros,0)
				end
				
				--print("numeros = "..vetorNumeros[#vetorNumeros])
			else
				if vetorLinhas[i+1] then
					vetorLinhas[i+1] = vetorLinhas[i].." ".. vetorLinhas[i+1]
				end
			end
			--print(i.." = "..tostring(subString))
		end
		local textoFinal = ""
		for i=1,#vetorTitulos do
			if not vetorTipos[i] then
				vetorTipos[i] = "titulo"
			end
			if not vetorTitulos[i] then
				vetorTitulos[i] = " "
			end
			if not vetorNumeros[i] then
				vetorNumeros[i] = 0
			end
			if i == 1 then
				textoFinal = textoFinal .. vetorTitulos[i].."\n"
			else 
				textoFinal = textoFinal .. vetorTipos[i].."|||"..vetorTitulos[i].."|||"..vetorNumeros[i].."\n"
			end
		end
		for i=1,#vetorTitulos do
			if i==1 then
				vetorIndice[i] = {"titulo",vetorTitulos[i],0}
			else
				vetorIndice[i] = {vetorTipos[i],vetorTitulos[i],tonumber(vetorNumeros[i])}
			end
		end
		
		return vetorIndice
	end
	M.reformatarArquivoIndice = reformatarArquivoIndice
	
	
	return M
	
	