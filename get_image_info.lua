--- Parse JPEG image file
local diretorioThales = system.pathForFile(nil,system.TemporaryDirectory).."/"--,system.TemporaryDirectory
-- some defines for the different JPEG block types
local M_SOF0  = 0xC0     -- Start Of Frame N
local M_SOF1  = 0xC1     -- N indicates which compression process
local M_SOF2  = 0xC2     -- Only SOF0-SOF2 are now in common use
local M_SOF3  = 0xC3
local M_SOF5  = 0xC5     -- NB: codes C4 and CC are NOT SOF markers
local M_SOF6  = 0xC6
local M_SOF7  = 0xC7
local M_SOF9  = 0xC9
local M_SOF10 = 0xCA
local M_SOF11 = 0xCB
local M_SOF13 = 0xCD
local M_SOF14 = 0xCE
local M_SOF15 = 0xCF
local M_SOI   = 0xD8
local M_EOI   = 0xD9     -- End Of Image (end of datastream)
local M_SOS   = 0xDA     -- Start Of Scan (begins compressed data)
local M_COM   = 0xFE     -- COMment

local M_PSEUDO = 0xFFD8  -- pseudo marker for start of image(byte 0)

-- Unpack 32-bit unsigned integer (most-significant-byte, MSB, first)
-- from byte string.
local function unpack_msb_uint32(s)
  local a,b,c,d = s:byte(1,#s)
  local num = (((a*256) + b) * 256 + c) * 256 + d
  return num
end

-- Read 32-bit unsigned integer (most-significant-byte, MSB, first) from file.
local function read_msb_uint32(fh)
  return unpack_msb_uint32(fh:read(4))
end

-- Unpack 16-bit unsigned integer (most-significant-byte, MSB, first)
-- from byte string.
local function unpack_msb_uint16(s)
  local a,b = s:byte(1,#s)
  local num = ((a*256) + b) 
  return num
end


-- Read 16-bit unsigned integer (most-significant-byte, MSB, first) from file.
local function read_msb_uint16(fh)
  return unpack_msb_uint16(fh:read(2))
end

-- Read unsigned byte (integer) from file
local function read_byte(fh)
  return fh:read(1):byte()
end

function get_jpeg_info2(fh, path) 

	local function unpackMsbUint16(s) 
		local c,d = s:byte(1,#s) 
		local num = (c / 256) + d 
		return num 
	end 
	local function readMsbUint16(fh) 
		return unpackMsbUint16(fh:read(2)) 
	end 
	local filePath = path or nil 
	local theFile = nil 
	if filePath == nil then 
		theFile = system.pathForFile(fh, system.ResourceDirectory) 
	else 
		theFile = path--system.pathForFile(fh, path) 
	end 
	
	local fileHandle = assert(io.open(theFile, 'rb')) 
	local self = {} 
	-- 
	--JPEG Markers 
	local jpegSOI = string.char( 255 ) .. string.char( 216 ) 
	local jpegAPP0 = string.char( 255 ) .. string.char( 224 ) 
	local jpegSOF0 = string.char( 255 ) .. string.char( 192 ) 
	local jpegSOF2 = string.char( 255 ) .. string.char( 194 ) 
	-- 
	local tempBytes 
	-- 
	repeat tempBytes = fileHandle:read(2) until ( ( tempBytes == jpegSOI ) or ( tempBytes == nil ) ) 
	--assert( tempBytes~=nil, "SOI not found. Are you sure this is a JPEG file?" ) 
	-- 
	local APP0Marker = fileHandle:read(2) 
	--assert( APP0Marker == jpegAPP0, "APP0 Marker not what's expected. Is this really a JPEG file?") 
	-- 
	local APP0Length = readMsbUint16(fileHandle) - 4 
	--we're 4 bytes into this thing already 
	fileHandle:seek( "cur", APP0Length ) 
	-- skipping ahead, but this is where the DPI is stored if you need it. -- 
	local readHead 
	-- repeat 
	repeat tempBytes = fileHandle:read(2) until ( ( tempBytes == jpegSOF0 ) or ( tempBytes == jpegSOF2 ) or ( tempBytes == nil )) 
	if tempBytes ~= nil then 
		readHead = fileHandle:seek() 
		if (tempBytes == jpegSOF0 or tempBytes == jpegSOF2) then 
			print("Found SOF0:", tempBytes == jpegSOF0, "SOF2:", tempBytes == jpegSOF2) 
		end 
	end 
	--until tempBytes == nil
	local bits = 0 
	if readHead then 
		fileHandle:seek("set", readHead) 
		fileHandle:read(3) 
		-- length of frame 
		self.bitDepth = read_byte(fileHandle)
		bits = 	self.bitDepth 
		-- bit depth 
		self.height = readMsbUint16(fileHandle) 
		-- image height 
		self.width = readMsbUint16(fileHandle) 
		-- image width print(readHead); 
	end 
	--close the file 
	io.close(fileHandle) 
	fileHandle = nil 
	function fsize (file)
	  local current = file:seek()      -- get current position
	  local size = file:seek("end")    -- get file size
	  file:seek("set", current)        -- restore position
	  return size
	end
	local fsize = fsize(fh)
	self.bpc = bits
	self.data = fh:read(fsize)
	self.w  = width
	self.h = height
	self.f = "DCTDecode"
	return self 
end

function get_jpeg_info(fp, image_name)
	print("checking jpg info")
	local isValid = false
	local info = {}
	local myfp

	if not fp then
		native.showAlert("Warning!","Invalid path for file: "..image_name,{"ok"})
	end
	
	local buf = fp:read(3)

	if (buf ~= "\255\216\255") then
	    error("Not a JPG image: %s", image_name)
		native.showAlert("Warning!","Invalid jpg file: "..image_name,{"ok"})
	end
	-- get info for thales
	local function getInfoThales()
		local function refresh()
			if type(fileinfo)=="number" then
				fp:seek("set",fileinfo)
			else
				--fp:close()
			end
		end
		local width,height=0,0
		local lastb,curb=0,0
		local xylist={}
		local sstr=fp:read(1)
		print("sstr",sstr)
		while sstr~=nil do
			lastb=curb
			print("lastb",lastb)
			curb=sstr:byte()
			print("curb",curb)
			if (curb==194 or curb==192) and lastb==255 then
				fp:seek("cur",3)
				local sizestr=fp:read(4)
				local h=sizestr:sub(1,1):byte()*256+sizestr:sub(2,2):byte()
				local w=sizestr:sub(3,3):byte()*256+sizestr:sub(4,4):byte()
				if w>width and h>height then
					width=w
					height=h
				end
			end
			sstr=fp:read(1)
			print("sstr",sstr)
		end
		if width>0 and height>0 then
			refresh()
			return width,height
		end
	end
	--getInfoThales()
	-- Extract info from a JPEG file
	local   marker = M_PSEUDO
	local length
	local ffRead = 1
	local bits     = 0
	local image = display.newImage
	local height   = 0
	local width    = 0
	local channels = 0

	local ready = false
	local lastMarker
	local commentCorrection
	local a
	length =read_msb_uint16(fp)
	bits = read_byte(fp)
	height =read_msb_uint16(fp)
	width  = read_msb_uint16(fp)
	channels = 3--read_byte(fp)
	local sstr=fp:read(1)
	local lastMarker=0
	while (not ready) do
	    lastMarker = marker
	    commentCorrection = 1
	    a = 0

	    -- get marker byte, swallowing possible padding
	    if (lastMarker == M_COM and commentCorrection) then
			-- some software does not count the length bytes of COM section
			-- one company doing so is very much envolved in JPEG... so we accept too
			-- by the way: some of those companies changed their code now...
			commentCorrection = 2
	    else
			lastMarker = 0
			commentCorrection = 0
	    end
	    
	    if (ffRead) then
			a = 1 -- already read 0xff in filetype detection
	    end
	    
	    repeat
			marker = sstr:byte()--read_byte(fp)
			print("marker",marker,M_SOS,M_EOI)
			if (marker == nil) then
				marker = M_EOI -- we hit EOF
				break
			end
			if (lastMarker == M_COM and commentCorrection > 0) then
				if (marker ~= 0xFF) then
					marker = 0xff
					commentCorrection = commentCorrection - 1
				else
					lastMarker = M_PSEUDO -- stop skipping non 0xff for M_COM
				end
			end
			a = a + 1
			if  (a > 10) then
				-- who knows the maxim amount of 0xff? though 7
				-- but found other implementations
				marker = M_EOI
				break
			end
	    until (marker == 0xff)

	    if (a < 2) then
			marker = M_EOI -- at least one 0xff is needed before marker code
	    end
	    if (lastMarker == M_COM and commentCorrection) then
			marker = M_EOI -- ah illegal: char after COM section not 0xFF
	    end

	    ffRead = 0
		print("marker2",marker,M_SOS,M_EOI)
	    if (marker==194 or marker==192) and lastMarker==255 then
			fp:seek("cur",3)
			local sizestr=fp:read(4)
			local h=sizestr:sub(1,1):byte()*256+sizestr:sub(2,2):byte()
			local w=sizestr:sub(3,3):byte()*256+sizestr:sub(4,4):byte()
			if w>width and h>height then
				width=w
				height=h
				print("width,height",width,height)
			end
		end    
	    if marker == M_SOF0 or marker == M_SOF1 or marker == M_SOF2
		 or marker == M_SOF3 or marker == M_SOF4 or marker == M_SOF5
		  or marker == M_SOF6 or marker == M_SOF7 or marker == M_SOF8
		   or marker == M_SOF9 or marker == M_SOF10 or marker == M_SOF11
		    or marker == M_SOF13 or marker == M_SOF14 or marker == M_SOF15 then
			-- handle SOFn block]]
			length =read_msb_uint16(fp)
			bits = read_byte(fp)
			height =read_msb_uint16(fp)
			width  = read_msb_uint16(fp)
			channels = read_byte(fp)
			isValid = true
			ready = true
			
	    elseif  marker == M_SOS  or marker == M_EOI then
			isValid = true
			ready = true
			print("isValid",isValid)
	    else
			-- anything else isn't interesting
			local pos = read_msb_uint16(fp)
			print("pos",pos)
			pos = pos-2
			
			if (pos) then
				fp:seek(pos)
				--fp:seek(pos, SEEK_CUR )
			end
		end
	end
	

	if (isValid) then
	    if (channels == 3) then
			info.cs = "DeviceRGB"
	    elseif(channels == 4) then
			info.cs = "DeviceCMYK"
	    else
			info.cs = "DeviceGray"
	    end
	    info.bpc = bits
	    print("bits",bits)

	    --Read whole file
	    function fsize (file)
		  local current = file:seek()      -- get current position
		  local size = file:seek("end")    -- get file size
		  file:seek("set", current)        -- restore position
		  return size
		end
	    local fsize = fsize(fp)
	    info.data = fp:read(fsize)
	    info.w  = width
	    info.h = height
	    info.f = "DCTDecode"
	    if myfp then
			myfp:close()
	    end
		print("width",info.w)
		print("height",info.h)
		print("f",info.f)
	    return info
	end
	error("Invalid JPG image: %s"..image_name)
end

function get_png_info(fp, image_name)
	local info = {}
	local myfp
	
	if not fp then
		fp = io.open(image_name, "rb")
		myfp = fp
	end
	-- Check signature
	local buf = fp:read(8)

	if (buf ~= "\137PNG\13\10\26\10") then
		error("Not a PNG image: %s", image_name)
	end

	-- Read header chunk
	buf = fp:read(4)
	buf = fp:read(4)
	if (buf ~= "IHDR") then
		error("Incorrect PNG image: %s", image_name)
	end
	info.w = read_msb_uint32(fp)
	info.h = read_msb_uint32(fp)
	info.bpc = read_byte(fp)
	if (info.bpc>8) then
		error("16-bit depth not supported: %s", image_name)
	end
	local ct = read_byte(fp)
	if (ct==0 or ct==4) then
		info.cs = "DeviceGray"
	elseif (ct==2 or ct==6) then
		info.cs = "DeviceRGB"
	elseif (ct==3) then
		info.cs = "Indexed"
	else 
		error("Unknown color type: %s", image_name)
	end
	buf = fp:read(3)
	if(buf:byte(1) ~= 0) then
		error("Unknown compression method: %s", image_name)
	end
	if (buf:byte(2) ~=0) then
		error("Unknown filter method: %s", image_name)
	end
	if (buf:byte(3) ~=0 ) then
		error("Interlacing not supported: %s", image_name)
	end
	buf = fp:read(4)
	if info.cs=="DeviceRGB" then
		buf = 3
	else
		buf = 1
	end
	info.dp = string.format("/Predictor 15 /Colors %d /BitsPerComponent %d  /Columns %d",
			buf, info.bpc, info.w)

	-- Scan chunks looking for palette, transparency and image data
	local n
	
	info.trns = {}
	
	repeat
		n = read_msb_uint32(fp)
		buf = fp:read(4)
		if (buf=="PLTE") then
			-- Read palette
			info.pal = fp:read(n)
			buf = fp:read(4)
		elseif (buf=="tRNS") then
			-- Read transparency info
			buf = fp:read(n)
			if (ct==0) then
				table.insert(info.trns, buf:byte(2))
			elseif (ct==2) then
				table.insert(info.trns, buf:byte(2))
				table.insert(info.trns, buf:byte(3))
				table.insert(info.trns, buf:byte(4))
			else
				local pos = buf.find('\0', 1, true)
				if pos then
					table.insert(info.trns, buf:byte(pos))
				end
			end
			buf = fp:read(4)
		elseif (buf=="IDAT") then
			-- Read image data block
			info.data = info.data .. fp:read(n)
			buf = fp:read(4)
		elseif (buf=="IEND") then
			break
		else
			buf = fp:read(n+4)
		end
	until (n)

	if (info.cs=="Indexed" and not (info.pal and #info.pal > 0)) then
		error("Missing palette in %s", image_name)
	end
	info.f = "FlateDecode"
--[[ PDF_USING_ZLIB
	if(ct>=4)
	{
		-- Extract alpha channel
		std::string data;
		gzuncompress(data, info.data);
		std::string color, alpha, line;
		if(ct==4)
		{
			-- Gray image
			int len = 2*info.w;
			for(int i=0; i<info.h; i++)
			{
				int pos = (1+len)*i;
				color.append(data[pos], 1);
				alpha.append(data[pos], 1);
				line.assign(data.c_str()+pos+1,len);
				_getGrayImgColorAndalpha(color, alpha, line);
				--color += preg_replace("/(.)./s","1",line);
				--alpha += preg_replace("/.(.)/s","1",line);
			}
		}
		else
		{
			-- RGB image
			int len = 4*info.w;
			for(int i=0; i<info.h; i++)
			{
				int pos = (1+len)*i;
				color.append(data[pos], 1);
				alpha.append(data[pos], 1);
				line.assign(data.c_str()+pos+1,len);
				_getRGBImgColorAndalpha(color, alpha, line);
				--color += preg_replace("/(.{3})./s","1",line);
				--alpha += preg_replace("/.{3}(.)/s","1",line);
			}
		}
		gzcompress(info.smask, alpha);
		data.clear();
		gzcompress(info.data, color);
		if(m_PDFVersion < "1.4") m_PDFVersion = "1.4";
	}
]]
	if myfp then
		myfp:close()
	end
end

