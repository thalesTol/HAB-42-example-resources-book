
local aspectRatio = display.pixelHeight / display.pixelWidth
local largura = 720 -- 540
local altura = 1280 -- 960
if system.getInfo("platform") == "win32" then
	largura = largura*2/3
	altura = altura*2/3
end
if system.getInfo("platform") == "win32" then
	application =
	{
	content =
		{
			--width = largura,
			--height = altura,
			width = 720,
			height = 1280,
			scale = "letterbox",
			fps = 30,
			antialias = true,
			xAlign = "center",
			yAlign = "top"
		},
	}
else
	application =
	{
	notification =
    {
        iphone = 
        {
            types = 
            {
                "badge",
                "sound",
                "alert"
            },
        },
    },
	license =
		{
			google =
			{
				key = "MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEA1a++dRPY4zDVXZZz5FiAJYgGhXI6ipLuOtbeCHmlHKbd4GzCj9rUa5Cc8DYL5k1Z9AhP2tlgX9nq6svtSm7bXCE8TAZaV3tDtjI3Oacv0VxZ5I5p6qHZFiNs2zieGiKSThI8sAmx6FC4KEhaAf9fiaIb6N3ZwCg6UnNaF4USbjN2hE4CZdoiMcyPMCUqFHuarzc/mdRhrPEFNUpbo0qknea5yuVo963xIc/VvardrLfS6fj3YQxc212nNiQqO6nhRFiX68ftct5efcj8uW7iIqQj14tExp5B1Qb1/znA+RePaXUrOCmG0rgaZWUiBlHyraGouXoGc3K0A1znejBXmwIDAQAB",
				policy = "serverManaged"
			},
		},
	content =
		{
			--width = largura,
			--height = altura,
			width = 720, -- BETTER
			height = 1280, -- BETTER
			--width = 1000,
			--height = 600,
			scale = "letterbox",
			fps = 30,
			antialias = true,
			xAlign = "center",
			yAlign = "center"
		},
	}
end