

--[[
*******************************************************************************
* FPDF                                                                         *
*                                                                              *
* Version: 1.7                                                                 *
* Date:    2011-06-18                                                          *
* Author:  Olivier PLATHEY                                                     *
* Lua Port Date:    2012-12-01                                                *
* Lua Port Author:  Domingo Alvarez Duarte                                     *
*******************************************************************************
]]
local diretorioThales = system.pathForFile(nil,system.TemporaryDirectory).."/"--,system.TemporaryDirectory
if APP_ROOT_FOLDER then
	loadfile(APP_CODE_FOLDER .. "/pdf-fonts.lua")()
	loadfile(APP_CODE_FOLDER .. "/get_image_info.lua")()
else
	require("pdf-fonts")
	require("get_image_info")
end

local strfmt = string.format
local strfind = string.find
local strbyte = string.byte
local tblinsert = table.insert

PDF_USING_ZLIB = false
FPDF_VERSION = "1.7"
FPDF_FONTPATH = false

pdf_e_orientation_none = 0
pdf_e_orientation_portrait = 1
pdf_e_orientation_landscape = 2

pdf_e_units_none = 0
pdf_e_units_mm = 1
pdf_e_units_pt = 2
pdf_e_units_cm = 3
pdf_e_units_inch = 4

pdf_e_page_size_none = 0
pdf_e_A3 = 1
pdf_e_A4 = 2
pdf_e_A5 = 3
pdf_e_Letter = 4
pdf_e_Legal = 5
pdf_e_page_sizes_last = 6

pdf_e_zoom_default = 0
pdf_e_zoom_fullpage = 1
pdf_e_zoom_fullwidth = 2
pdf_e_zoom_real = 3

pdf_e_layout_default = 0
pdf_e_layout_single = 1
pdf_e_layout_continuous = 2
pdf_e_layout_two = 3

luaFPDF = {
--[[
    m_page = 0,               -- current page number
    m_n = 0,                  -- current object number
    --starting using at 1
    m_offsets = {},            -- array of object offsets
    m_buffer = {},             -- buffer holding in-memory PDF
    m_pages = {},              -- array containing pages
    m_state = 0,              -- current document state
    m_compress = false,           -- compression flag
    m_k = 1,                  -- scale factor (number of points in user unit)
    m_DefOrientation = pdf_e_orientation_portrait,     -- default orientation
    m_CurOrientation = pdf_e_orientation_portrait,     -- current orientation
    m_DefPageSize = pdf_e_A4,        -- default page size
    m_CurPageSize = pdf_e_A4,        -- current page size
    m_PageSizes = {},          -- used for pages with non default sizes or orientations
    m_wPt = 0, m_hPt = 0,          -- dimensions of current page in points
    m_w = 0, m_h = 0,              -- dimensions of current page in user unit
    m_angle = 0,              --rotation angle
    m_lMargin = 0,            -- left margin
    m_tMargin = 0,            -- top margin
    m_rMargin = 0,            -- right margin
    m_bMargin = 0,            -- page break margin
    m_cMargin = 0,            -- cell margin
    m_x = 0, m_y = 0,              -- current position in user unit
    m_lasth = 0,              -- height of last printed cell
    m_LineWidth = 0,          -- line width in user unit
    m_fontpath = nil,           -- path containing fonts
    -- array of core font names
    m_fonts = {},              -- array of used fonts
    m_FontFiles = {},          -- array of font files
    m_diffs = {},              -- array of encoding differences
    m_FontFamily = nil,         -- current font family
    m_FontStyle = nil,          -- current font style
    m_underline = false,          -- underlining flag
    m_CurrentFont = nil,        -- current font info
    m_FontSizePt = 0,         -- current font size in points
    m_FontSize = 0,           -- current font size in user unit
    m_DrawColor = nil,          -- commands for drawing color
    m_DrawColor_rgb = nil,
    m_FillColor = nil,          -- commands for filling color
    m_FillColor_rgb = nil,
    m_TextColor = nil,          -- commands for text color
    m_TextColor_rgb = nil,
    m_ColorFlag = false,          -- indicates whether fill and text colors are different
    m_ws = 0,                 -- word spacing
    m_images = {},             -- array of used images
    lm_PageLinks = {},          -- array of links in pages
    m_links = {},              -- array of internal links
    m_AutoPageBreak = false,      -- automatic page breaking
    m_PageBreakTrigger = 0,   -- threshold used to trigger page breaks
    m_InHeader = false,           -- flag set when processing header
    m_InFooter = false,           -- flag set when processing footer
    m_ZoomMode = pdf_e_zoom_default,           -- zoom display mode
    m_CustomZoom = pdf_e_zoom_default,
    m_LayoutMode = pdf_e_layout_default,         -- layout display mode
    m_title = nil,              -- title
    m_subject = nil,            -- subject
    m_author = ni,             -- author
    m_keywords = nil,           -- keywords
    m_creator = nil,            -- creator
    m_AliasNbPages = nil,       -- alias for total number of pages
    m_PDFVersion = nil,         -- PDF version number

    m_scratch_buf = '',
]]
--public:

--[[
*******************************************************************************
*                                                                              *
*                               Public methods                                 *
*                                                                              *
*******************************************************************************
]]

    destroy = function(self)
    end,

    reset = function(self, page_orientation, measure_unit, page_size)
	page_orientation = page_orientation or pdf_e_orientation_portrait
	measure_unit = measure_unit or pdf_e_units_mm
	page_size = page_size or pdf_e_A4
	
        -- Scale factor
        if measure_unit == pdf_e_units_pt then
            self.m_k = 1
        elseif measure_unit ==  pdf_e_units_mm then
            self.m_k = 72/25.4
        elseif measure_unit ==  pdf_e_units_cm then
            self.m_k = 72/2.54
        elseif measure_unit ==  pdf_e_units_in then
            self.m_k = 72
        else
            self:Error("Incorrect unit: %s", measure_unit)
        end
	
        -- Some checks
        self:_dochecks()
        -- Initialization of properties
        self.m_page = 0
        self.m_pages = {}
        self.m_PageSizes = {}
        self.m_offsets = {}
        self.m_fonts = {}
        self.m_FontFiles = {}
        self.m_diffs = {}
        self.m_images = {}
        self.m_PageLinks = {}
        self.m_links = {}
        self.m_extgstates = {}
        self.m_offsets = {0,0}
        self.m_n = 2
        self.m_buffer = {}
        self.m_state = 0
        self.m_InHeader = false
        self.m_InFooter = false
        self.m_lasth = 0
        self.m_FontFamily = ""
        self.m_FontStyle = ""
        self.m_FontSizePt = 12
        self.m_underline = false
        self.m_DrawColor = "0 G"
        self.m_DrawColor_rgb = {0,0,0,0}
        self.m_FillColor = "0 g"
        self.m_FillColor_rgb = {0,0,0,0}
        self.m_TextColor = "0 g"
        self.m_TextColor_rgb = {0,0,0,0}
        self.m_ColorFlag = false
        self.m_ws = 0
        -- Font path
--[[	
        if (FPDF_FONTPATH) then
            self.m_fontpath = FPDF_FONTPATH
            char clast = *self.m_fontpath.rbegin();
            if(clast ~= '/' && clast ~= '\\')
                self.m_fontpath += "/";
        }
#if 0
        else if(is_dir(dirname(__FILE__) + "/font"))
            self.m_fontpath = dirname(__FILE__) + "/font/";
#endif
        else
            self.m_fontpath = {}
	end
]]
        self.m_CurrentFont = nil

        local psize =  self:_getpagesize(page_size)
        self.m_DefPageSize = psize
        self.m_CurPageSize = psize
        -- Page orientation
        if (page_orientation == pdf_e_orientation_portrait) then
            self.m_DefOrientation = pdf_e_orientation_portrait
            self.m_w = psize.w
            self.m_h = psize.h
        elseif (page_orientation == pdf_e_orientation_landscape) then
            self.m_DefOrientation = pdf_e_orientation_landscape
            self.m_w = psize.h
            self.m_h = psize.w
        else
            self:Error("Incorrect orientation: %d", page_orientation)
        end

        self.m_CurOrientation = self.m_DefOrientation
        self.m_wPt = self.m_w * self.m_k
        self.m_hPt = self.m_h * self.m_k
        self.m_angle = 0
        -- Page margins (1 cm)
        local margin = 28.35/self.m_k
        self:SetMargins(margin,margin)
        -- Interior cell margin (1 mm)
        self.m_cMargin = margin/10.0
        -- Line width (0.2 mm)
        self.m_LineWidth = .567/self.m_k
        -- Automatic page break
        self:SetAutoPageBreak(true,2*margin)
        -- Default display mode
        self:SetDisplayMode(pdf_e_zoom_default)
        self.m_CustomZoom = pdf_e_zoom_default
        -- Enable compression
        self:SetCompression(false)
        -- Set default PDF version number
        self.m_PDFVersion = "1.3"

        self.m_doubleSided=false -- layout like books?
        self.m_xDelta=0 -- if double-sided, difference between outer and inner
        self.m_innerMargin=10
        self.m_outerMargin=10
        self.m_n_js = 0
	self.m_javascript = nil
    end,

    SetDoubleSided = function(self, inner, outer)
		outer = outer or 13
		inner = inner or 7
        if (outer ~= inner) then
            self.m_doubleSided=true
            self.m_outerMargin=outer
            self.m_innerMargin=inner
        end
    end,

    SetMargins = function(self, left, top, right)
        -- Set left, top and right margins
        self.m_lMargin = left
        self.m_tMargin = top
		if not right or right == 0.0 then
			self.m_rMargin = left
		else
			self.m_rMargin = right
		end
    end,

    SetLeftMargin = function(self, margin)
        -- Set left margin
        self.m_lMargin = margin
        if (self.m_page > 0 and self.m_x < margin) then
            self.m_x = margin
		end
    end,

    SetTopMargin = function(self, margin)
        -- Set top margin
        self.m_tMargin = margin
    end,

    SetRightMargin = function(self, margin)
        -- Set right margin
        self.m_rMargin = margin
    end,

    GetLeftMargin = function(self)
        return self.m_lMargin
    end,

    GeRightMargin = function(self)
        return self.m_rMargin
    end,

    SetAutoPageBreak = function(self, b, margin)
        -- Set auto page break mode and triggering margin
        self.m_AutoPageBreak = b
        self.m_bMargin = margin or 0.0
        self.m_PageBreakTrigger = self.m_h-margin
    end,

    CheckPageBreak = function(self, height)
        --If the height h would cause an overflow, add a new page immediately
        if (self:GetY()+height > self.m_PageBreakTrigger) then
			self:AddPage(self.m_CurOrientation)
		end
    end,

    setCustomZoom = function(self, zoom)
        self.m_CustomZoom = zoom
    end,

    getCustomZoom = function(self)
        return self.m_CustomZoom
    end,

    SetDisplayMode = function(self, zoom, layout)
        -- Set display mode in viewer
        if (zoom==pdf_e_zoom_fullpage or zoom==pdf_e_zoom_fullwidth or
                zoom==pdf_e_zoom_real or zoom==pdf_e_zoom_default) then
            self.m_ZoomMode = zoom
        else
            self:Error("Incorrect zoom display mode %d", zoom)
		end
		layout = layout or pdf_e_layout_default
        if (layout==pdf_e_layout_single or layout==pdf_e_layout_continuous or
                layout==pdf_e_layout_two or layout==pdf_e_layout_default) then
            self.m_LayoutMode = layout
        else
            self:Error("Incorrect layout display mode: %d", layout)
		end
    end,

    SetCompression = function(self, compress)
        -- Set page compression
        self.m_compress = PDF_USING_ZLIB and compress
    end,

    SetTitle = function(self, title)
        -- Title of document
        self.m_title = title
    end,

    SetSubject = function(self, subject)
        -- Subject of document
        self.m_subject = subject
    end,

    SetAuthor = function(self, author)
        -- Author of document
        self.m_author = author
    end,

    SetKeywords = function(self, keywords)
        -- Keywords of document
        self.m_keywords = keywords
    end,

    SetCreator = function(self, creator)
        -- Creator of document
        self.m_creator = creator
    end,

    AliasNbPages = function(self, alias)
        -- Define an alias for total number of pages
        self.m_AliasNbPages = alias or "{nb}"
    end,

    GetAliasNbPages = function(self)
        -- Define an alias for total number of pages
        return self.m_AliasNbPages
    end,

    Error = function(self, fmt, ...)
        -- Fatal error
        error( strfmt(fmt, ...) )
    end,

    Open = function(self)
        -- Begin document
        self.m_state = 1
    end,

    Close = function(self)
        -- Terminate document
        if (self.m_state==3) then return end
        if (self.m_page==0) then self:AddPage() end
        -- Page footer
        self.m_InFooter = true
        self:Footer()
        self.m_InFooter = false
        -- Close page
        self:_endpage()
        -- Close document
        self:_enddoc()
    end,
    
    AddPage = function(self, orientation, psize)
		orientation = orientation or pdf_e_orientation_none
        -- Start a new page
        if (self.m_state==0) then self:Open() end
        local family = self.m_FontFamily
        local style = self.m_FontStyle
        if (self.m_underline) then style = style .. "U" end
        local fontsize = self.m_FontSizePt
        local lw = self.m_LineWidth
        local dc = self.m_DrawColor
        local fc = self.m_FillColor
        local tc = self.m_TextColor
        local cf = self.m_ColorFlag
        if (self.m_page > 0) then
            -- Page footer
            self.m_InFooter = true
            self:Footer()
            self.m_InFooter = false
            -- Close page
            self:_endpage()
        end
        -- Start new page
        self:_beginpage(orientation, psize)
        -- Set line cap style to square
        self:_out("2 J\n")
        -- Set line width
        self.m_LineWidth = lw
        self:_outfmt("%.2f w\n", lw*self.m_k)
        -- Set font
        if (family and #family > 0) then self:SetFont(family,style,fontsize) end
        -- Set colors
        self.m_DrawColor = dc
        if (dc ~= "0 G") then self:_outfmt("%s\n", dc) end
        self.m_FillColor = fc
        if (fc ~= "0 g") then self:_outfmt("%s\n", fc) end
        self.m_TextColor = tc
        self.m_ColorFlag = cf
        -- Page header
        self.m_InHeader = true
        self:Header()
        self.m_InHeader = false
        -- Restore line width
        if (self.m_LineWidth ~= lw) then
            self.m_LineWidth = lw
            self:_outfmt("%.2f w\n", lw*self.m_k)
        end
        -- Restore font
        if (family and #family > 0) then self:SetFont(family,style,fontsize) end
        -- Restore colors
        if (self.m_DrawColor ~= dc) then
            self.m_DrawColor = dc
            self:_outfmt("%s\n", dc)
        end
        if (self.m_FillColor ~= fc) then
            self.m_FillColor = fc
            self:_outfmt("%s\n", fc)
        end
        self.m_TextColor = tc
        self.m_ColorFlag = cf
    end,

    --assume a filename when image_blob is null
    --otherwise a in memory image
	

	Image = function(self, atrib)
        x = atrib.x or -1
        y = atrib.y or -1
        w = atrib.w or 0.0
        h = atrib.h or 0.0
		image_name = atrib.image_name
        atype = atrib.atype or ''
        link = atrib.link or 0
		image_blob = atrib.image_blob
		blob_size = atrib.blob_size
		path = atrib.path or system.pathForFile(nil,system.ResourceDirectory)
        local info
        -- Put an image on the page
        if (not image_name) then
			self:Error("Image name is null !")
		end
        if (not self.m_images[image_name]) then
			-- First use of this image, get info
			local itype
			if (atype and #atype > 0) then
				itype = atype
			else
				if (image_blob) then
					self:Error("Image type was not specified: %s", image_name)
				end
				--else assume image_name is a filename
				local pos = strfind(image_name,'.', 1, true)
				if (not pos) then
					self:Error("Image file has no extension and no type was specified: %s", image_name)
				end
				itype = image_name:sub(pos+1)
			end
			itype = itype:lower()
			if (itype=="jpeg") then
				itype = "jpg"
			end
			if (itype == "jpg") then
				if (image_blob) then
					info = self:_parsejpg_blob(image_name, image_blob, blob_size)
				else 
					print("Enter jpg Parse!")
					info = self:_parsejpg(nil, image_name,path)
					print("Exit jpg Parse!")
				end
			elseif (type == "png") then
				if(image_blob) then
					info = self:_parsepng_blob(image_name, image_blob, blob_size)
				else 
					info = self:_parsepng(nil, image_name)
				end
			else 
				self:Error("Unsupported image type: %s", itype)
			end
			self.m_images[image_name] = info
			print("after parse info",info)
			info.i = self._getLuaTableSize(self.m_images)
			print("after parse info.i",info.i)
        else
			info = self.m_images[image_name]
			print("other info",info)
			-- Automatic width and height calculation if needed
			if (w==0.0 and h==0.0) then
				-- Put image at 96 dpi
				w = -96
				h = -96
			else
				if (w==0) then
					w = h* info.w/info.h
				elseif (w<0) then
					w = - info.w*72.0/w/self.m_k
				end
				if (h==0) then
					h = w* info.h/info.w
				elseif(h<0) then
					h = - info.h*72.0/h/self.m_k
				end
			end

			local _y, _x
			-- Flowing mode
			if (y==-1) then
				if (self.m_y +h > self.m_PageBreakTrigger and not self.m_InHeader and
							not self.m_InFooter and self:AcceptPageBreak()) then
					-- Automatic page break
					local x2 = self.m_x
					self:AddPage(m_CurOrientation, self.m_CurPageSize)
					self.m_x = x2
				end
				_y = self.m_y
				self.m_y = self.m_y + h
			else 
				_y = y
			end

			if (x==-1) then
				_x = self.m_x
			else 
				_x = x
			end
				
			self:_outfmt("q %.2f 0 0 %.2f %.2f %.2f cm /I%d Do Q\n",
					w*self.m_k,h*self.m_k,_x*self.m_k,(self.m_h-(_y+h))*self.m_k,info.i)
			if (link) then
				self:Link(_x,_y,w,h,link)
			end
		end
    end,


    Header = function(self)
        -- To be implemented in your own inherited class
    end,

    Footer = function(self)
        -- To be implemented in your own inherited class
    end,

    PageNo = function(self)
        -- Get current page number
        return self.m_page
    end,
    
    _getParseColor = function(r, g, b)
		if type(r) == 'table' then
			local c = r
			r = c[1]
			g = c[2]
			b = c[3]
		elseif (g == nil) then
			g = r
			b = r
		end
        return r,g,b
    end,

    SetDrawColor = function(self, r, g, b)
        -- Set color for all stroking operations
		r, g, b = self._getParseColor(r, g, b)
        self.m_DrawColor_rgb = {r,g,b,0}
        self.m_DrawColor = strfmt("%.3f %.3f %.3f RG", r/255.0, g/255.0, b/255.0)
        if (self.m_page>0) then self:_outfmt("%s\n", self.m_DrawColor) end
    end,
    
    GetDrawColor = function(self)
        return self.m_DrawColor_rgb
    end,

    SetFillColor = function(self, r, g, b)
        -- Set color for all filling operations
		r, g, b = self._getParseColor(r, g, b)
        self.m_FillColor_rgb = {r,g,b,0}
        self.m_FillColor = strfmt("%.3f %.3f %.3f rg", r/255.0, g/255.0, b/255.0)
        self.m_ColorFlag = (self.m_FillColor ~= self.m_TextColor)
        if (self.m_page>0) then self:_outfmt("%s\n", self.m_FillColor) end
    end,
    
    GetFillColor = function(self)
        return self.m_FillColor_rgb
    end,

    SetTextColor = function(self, r, g, b)
        -- Set color for text
		r, g, b = self._getParseColor(r, g, b)
        self.m_TextColor_rgb = {r,g,b,0}
        self.m_TextColor = strfmt("%.3f %.3f %.3f rg", r/255.0, g/255.0, b/255.0)
        self.m_ColorFlag = (self.m_FillColor ~= self.m_TextColor)
    end,
    
    GetTextColor = function(self)
        return self.m_TextColor_rgb
    end,

    -- alpha: real value from 0 (transparent) to 1 (opaque)
    -- bm:    blend mode, one of the following:
    --          Normal, Multiply, Screen, Overlay, Darken, Lighten, ColorDodge, ColorBurn,
    --          HardLight, SoftLight, Difference, Exclusion, Hue, Saturation, Color, Luminosity
    SetAlpha = function(self, alpha, bm)
        -- set alpha for stroking (CA) and non-stroking (ca) operations
        local gs = {}
        gs.alpha = alpha
		if bm then
			gs.bm = bm
		else
			gs.bm = "Normal"
		end
        tblinsert(self.m_extgstates, gs)
        self:_outfmt("/GS%d gs\n", #self.m_extgstates)
    end,

    GetStringWidth = function(self, s)
        -- Get width of a string in the current font
        local cw = self.m_CurrentFont.font.cw
        local w = 0.0
        if (s) then
            for i=1, #s do
                w = w + cw[s:byte(i)+1]  --lua array is 1 based so we need to add 1
            end
        end
        return w*self.m_FontSize/1000.0
    end,

    SetLineWidth = function(self, width)
        -- Set line width
        self.m_LineWidth = width
        if (self.m_page>0) then self:_outfmt("%.2f w\n", width*self.m_k) end
    end,

    SetDash = function(self, black, white)
		balck = black or -1
		white = white or -1
        if (black >= 0.0 and white >= 0.0) then
            self:_outfmt("[%.3f %.3f] 0 d\n", black*self.m_k, white*self.m_k)
        else
            self:_out("[] 0 d\n")
		end
    end,

    Line = function(self, x1, y1, x2, y2)
        -- Draw a line
		local k = self.m_k
		local h = self.m_h
        self:_outfmt("%.2f %.2f m %.2f %.2f l S\n", x1*k,(h-y1)*k,x2*k,(h-y2)*k)
    end,

    Rect = function(self, x, y, w, h, style)
        -- Draw a rectangle
        local op = "S"
        if (style) then
			style = style:upper()
            if (style == "F") then
				op = "f"
            elseif (style == "FD" or tyle == "DF") then
				op = "B"
			end
        end
		local k = self.m_k
        self:_outfmt("%.2f %.2f %.2f %.2f re %s\n", x*k,(self.m_h-y)*k,w*k,-h*k, op);
    end,
    
    _getLuaTableSize = function(tbl)
		local size = 0
		for k,v in pairs(tbl) do
			size = size + 1
		end
		return size;
    end,
    
    AddFont = function(self, afamily, astyle, afile)
        -- Add a TrueType, OpenType or Type1 font
        local family, style
        if(afamily and #afamily > 0) then
            family = afamily:lower()
        else
            family = self.m_FontFamily
        end
        if(astyle and #astyle >  0) then
            style = astyle:lower()
		else
			style = ""
        end

        if (family=="arial") then family = "helvetica" end
        if (style=="ib") then style = "bi" end
        local fontkey = family .. style
        local iter = self.m_fonts[fontkey]
        if (iter) then return end --already inserted

        local font
        if (fontkey == "helveticai") then font = LuaPDF_Font_HelveticaOblique:new()
        elseif (fontkey == "helveticab") then font = LuaPDF_Font_HelveticaBold:new()
        elseif (fontkey == "helveticabi") then font = LuaPDF_Font_HelveticaBoldOblique:new()
        elseif (fontkey == "times") then font = LuaPDF_Font_Times:new()
        elseif (fontkey == "timesi") then font = LuaPDF_Font_TimesOblique:new()
        elseif (fontkey == "timesb") then font = LuaPDF_Font_TimesBold:new()
        elseif (fontkey == "timesbi") then font = LuaPDF_Font_TimesBoldOblique:new()
        elseif (fontkey == "courier") then font = LuaPDF_Font_Courier:new()
        elseif (fontkey == "courieri") then font = LuaPDF_Font_CourierOblique:new()
        elseif (fontkey == "courierb") then font = LuaPDF_Font_CourierBold:new()
        elseif (fontkey == "courierbi") then font = LuaPDF_Font_CourierBoldOblique:new()
        elseif (fontkey == "symbol") then font = LuaPDF_Font_Symbol:new()
        elseif (fontkey == "zapfdingbats") then font = LuaPDF_Font_ZapfDingbats:new()
        else 
			font = LuaPDF_Font_Helvetica:new()
		end
        self.m_fonts[fontkey] = font
        font.i = self._getLuaTableSize(self.m_fonts)
	--print(fontkey, family, style, afamily, astyle, fonts_size, font.name)
--[[
        if(m_fonts.find(fontkey) == -1) return;
        st_pdf_font info = _loadfont(file);
        info.i = m_fonts.size()+1;
        if(!empty(info["diff"]))
        {
            // Search existing encodings
            n = array_search(info["diff"],m_diffs);
            if(!n)
            {
                n = count(m_diffs)+1;
                m_diffs[n] = info["diff"];
            }
            info["diffn"] = n;
        }
        if(!empty(info["file"]))
        {
            // Embedded font
            if(info["type"]=="TrueType")
                m_FontFiles[info["file"] ] = array("length1"=>info["originalsize"]);
            else
                m_FontFiles[info["file"] ] = array("length1"=>info["size1"], "length2"=>info["size2"]);
        }
        m_fonts[fontkey] = info;
]]
    end,

    GetFontSettings = function(self)
		local fs = {}
        fs.family = self.m_FontFamily
        fs.style = self.m_FontStyle
        fs.size = self.m_FontSizePt
		return fs
    end,

    SetFontSettings = function(self, fs)
        self:SetFont(fs.family, fs.style, fs.size)
    end,
    
     SetFont = function(self, afamily, astyle, size)
        -- Select a font; size given in points
        local family, style
        if (afamily and #afamily > 0) then
            family = afamily:lower()
            if(family=="arial") then family = "helvetica" end
        else
            family = self.m_FontFamily
        end
        if (astyle and #astyle > 0) then
            style = astyle:lower()
		else
			style = ""
        end

        if (style:find("u", 1, true)) then
            self.m_underline = true
            style = style:gsub("u", "")
        else
            self.m_underline = false
		end
        if (style=="ib") then style = "bi" end
        if (not size or size==0) then size = self.m_FontSizePt end
        -- Test if font is already selected
        if (self.m_FontFamily==family and self.m_FontStyle==style and self.m_FontSizePt==size) then
            return
		end
        -- Test if font is already loaded
        local fontkey = family .. style
        local font = self.m_fonts[fontkey]
        if (not font) then
            -- Test if one of the core fonts
            if (isPdfFontCore(family)) then
                if (family=="symbol" or family=="zapfdingbats") then style = '' end
                fontkey = family .. style
                font = self.m_fonts[fontkey]
                if (not font) then self:AddFont(family,style) end
            else
                self:Error("Undefined font: %s %s", family, style)
			end
        end
        -- Select it
        self.m_FontFamily = family
        self.m_FontStyle = style
        self.m_FontSizePt = size
        self.m_FontSize = size/self.m_k
        self.m_CurrentFont = self.m_fonts[fontkey]
        if (self.m_page>0) then
            self:_outfmt("BT /F%d %.2f Tf ET\n", self.m_CurrentFont.i, self.m_FontSizePt)
		end
     end,

    SetFontSize = function(self, size)
        -- Set font size in points
        if (self.m_FontSizePt==size)  then return end
        self.m_FontSizePt = size
        self.m_FontSize = size/self.m_k
        if (self.m_page>0) then
            self:_outfmt("BT /F%d %.2f Tf ET\n", self.m_CurrentFont.i, self.m_FontSizePt)
		end
    end,

    GetFontSize = function(self)
        return self.m_FontSizePt
    end,

    AddLink = function(self)
        -- Create a new internal link
        local link = {0,0}
        tblinsert(self.m_links, link)
        return #self.m_links
    end,

    SetLink = function(self, link, y, page)
        -- Set destination of internal link
        local nlink = self.m_links[link]
        if (not y) then nlink.to = self.m_y end
        if (not page) then page = self.m_page end
        nlink.from = page
    end,

    Link = function(self, x, y, w, h, link)
        -- Put a link on the page
        local pl = {}
		local k = self.m_k
        pl.x = x*k
        pl.y = self.m_hPt-y*k
        pl.w = w*k
        pl.h = h*k
        pl.link = link;
        self.m_PageLinks[self.m_page] = pl
    end,

--protected
    _TextBase = function(self, x, y, txt)
	local color1, color2, underline
        -- Output a string
        if (self.m_ColorFlag) then
            color1 = strfmt("q %s ", self.m_TextColor)
            color2 = " Q "
	else
	    color1 = ''
	    color2 = ''
        end
        if (self.m_underline and txt) then
            underline = strfmt(" %s ", self:_dounderline(x, y, txt))
	else
	   underline = ''
        end
        return strfmt("%sBT %.2f %.2f Td (%s) Tj ET%s%s", color1, x, y, self._escape(txt), underline, color2)
    end,

--public

    Rotate = function(self, angle, x, y)
        if (not x) then x=self.m_x end
        if (not y) then y=self.m_y end
        if (self.m_angle ~= 0) then self:_out("Q\n") end
        self.m_angle=angle
        if (angle~=0) then
            angle = angle * math.pi/180.0;
            local c= math.cos(angle)
            local s= math.sin(angle)
            local cx= x*self.m_k
            local cy=(self.m_h-y)*self.m_k
            self:_outfmt("q %.5f %.5f %.5f %.5f %.2f %.2f cm 1 0 0 1 %.2f %.2f cm\n",
                    c,s,-s,c,cx,cy,-cx,-cy)
        end
    end,

    RotatedText = function(self, x, y, txt, angle)
        --Text rotated around its origin
        self:Rotate(angle,x,y)
        self:Text(x,y,txt)
        self:Rotate(0)
    end,

    ClippingText = function(self, x, y, txt, outline)
        local op
		if outline then
			op = 5
		else
			op = 7
		end
        self:_outfmt("q BT %.2f %.2f Td %d Tr (%s) Tj ET\n", x*self.m_k, (self.m_h-y)*self.m_k, op, self._escape(txt));
    end,

    Text = function(self, x, y, txt)
        local result = self:_TextBase(x*self.m_k, (self.m_h-y)*self.m_k, txt)
        self:_out(result)
    end,

    TextShadow = function(self, x, y, txt, displacement)
        local saved_color = self.m_TextColor_rgb
        self:SetTextColor(200,200,200)
		displacement = displacement or 0.3
        self:Text(x+displacement, y+displacement, txt)
        self:SetTextColor(saved_color)
        self:Text(x, y, txt)
    end,

    AcceptPageBreak = function(self)
        -- Accept automatic page break or not
        return self.m_AutoPageBreak
    end,
    
    Cell = function(self, w, h, txt, border, ln, align, fill, link)
        -- Output a cell
        local s
        local k = self.m_k
		h = h or 0
        if (self.m_y+h > self.m_PageBreakTrigger and (not self.m_InHeader) and (not self.m_InFooter) and self:AcceptPageBreak()) then
            -- Automatic page break
            local x = self.m_x
            local ws = self.m_ws
            if (ws > 0) then
                self.m_ws = 0
                self:_out("0 Tw\n")
            end
            self:AddPage(self.m_CurOrientation, self.m_CurPageSize)
            self.m_x = x + self.m_xDelta
            if (ws>0) then
                self.m_ws = ws
                self:_outfmt("%.3f Tw\n", ws*k)
            end
        end
        if (w==0) then
            w = self.m_w - self.m_rMargin - self.m_x
		end

        if (fill or (border and border == 1)) then
			if fill then
				if border and border == 1 then
					s = "B"
				else
					s = "f"
				end
			else
				s = "S"
			end
            s = strfmt("%.2f %.2f %.2f %.2f re %s ", self.m_x*k,(self.m_h-self.m_y)*k,w*k,-h*k, s)
        end
        if (border) then
            local x = self.m_x
            local y = self.m_y
            s = s or ''
            if(strfind(border, 'L', 1, true)) then
                s = strfmt("%s%.2f %.2f m %.2f %.2f l S ", s, x*k,(self.m_h-y)*k,x*k,(self.m_h-(y+h))*k)
			end
            if (strfind(border, 'T', 1, true)) then
                s = strfmt("%s%.2f %.2f m %.2f %.2f l S ", s, x*k,(self.m_h-y)*k,(x+w)*k,(self.m_h-y)*k)
			end
            if (strfind(border,'R', 1, true)) then
                s = strfmt("%s%.2f %.2f m %.2f %.2f l S ", s, (x+w)*k,(self.m_h-y)*k,(x+w)*k,(self.m_h-(y+h))*k)
			end
            if (strfind(border,'B', 1, true)) then
                s = strfmt("%s%.2f %.2f m %.2f %.2f l S ", s, x*k,(self.m_h-(y+h))*k,(x+w)*k,(self.m_h-(y+h))*k)
			end
        end
        if (txt) then
            local dx
            local txt_width = self:GetStringWidth(txt)
            if (align=='R') then
                dx = w-  self.m_cMargin-txt_width
            elseif (align=='C') then
                dx = (w-txt_width)/2
            else
                dx = self.m_cMargin
	    end

            s = strfmt("%s%s", s or '', self:_TextBase((self.m_x+dx)*k, (self.m_h-(self.m_y+.5*h+.3*self.m_FontSize))*k, txt))

            if (link) then
                self:Link(self.m_x+dx, self.m_y+.5*h-.5*self.m_FontSize, txt_width, self.m_FontSize, link)
			end
        end
        if (s and #s > 0) then self:_outfmt("%s\n", s) end
        self.m_lasth = h
        if (ln and ln>0) then
            -- Go to next line
            self.m_y = self.m_y + h
            if (ln==1) then self.m_x = self.m_lMargin end
        else 
			self.m_x = self.m_x + w
		end
    end,
    
    MultiCell = function(self, w, h, txt, border, align, fill)
		align = align or 'J'
        -- Output text with automatic or explicit line breaks
        local cw = self.m_CurrentFont.font.cw
        if (w==0) then w = self.m_w-self.m_rMargin-self.m_x end
        local wmax = (w-2*self.m_cMargin)*1000.0/self.m_FontSize
        local stmp
		local s = string.gsub(txt or "", "\r", "")
        local nb = #s
		local NL = strbyte("\n", 1)
		local SP = strbyte(" ", 1)
        if (nb>0 and s:byte(nb)==NL) then nb = nb -1 end
        local b, b2
        if (border) then
            if(border== 1) then
                border = "LTRB";
                b = "LRT";
                b2 = "LR";
            else
                if(strfind(border,'L', 1, true)) then  b2 = "L" end
                if(strfind(border,'R', 1, true)) then b2 =  "R" end
                if strfind(border,'T', 1, true) then b = "T"
		else
			b = b2
		end
            end
        end
        local sep = -1
        local i = 1
        local j = 1
        local l = 0
        local ns = 0
        local nl = 1
        local ls = 0
        while (i<=nb) do
            -- Get next character
            local c = s:byte(i)
            if (c==NL) then
                -- Explicit line break
                if (self.m_ws>0) then
                    self.m_ws = 0
                    self:_out("0 Tw\n")
                end
                stmp = s:sub(j, i-1)
                self:Cell(w,h,stmp,b,2,align,fill)
                i = i + 1
                sep = -1
                j = i
                l = 0
                ns = 0
                nl = nl + 1
                if (border and nl==2) then b = b2 end
                --continue --continue on my luajit is broke
			else
				if (c==SP) then
					sep = i
					ls = l
					ns = ns + 1
				end
				l = l + cw[c+1] --lua array is 1 based so we need to add 1
				if (l>wmax) then
					-- Automatic line break
					if (sep==-1) then
						if(i==j) then i = i +1 end
						if (self.m_ws>0) then
							self.m_ws = 0;
							self:_out("0 Tw\n")
						end
						stmp = s:sub(j, i-1)
						self:Cell(w,h,stmp,b,2,align,fill)
					else
						if (align=='J') then
							if (ns>1) then
								self.m_ws = (wmax-ls)/1000.0*self.m_FontSize/(ns-1)
							else
								self.m_ws = 0
							end
							--print(ns, self.m_ws, wmax, ls, self.m_FontSize)
							self:_outfmt("%.3f Tw\n",self.m_ws*self.m_k)
						end
						stmp = s:sub(j, sep-1)
						self:Cell(w,h,stmp,b,2,align,fill)
						i = sep+1
					end
					sep = -1
					j = i
					l = 0
					ns = 0
					nl = nl +1
					if (border and nl==2) then
						b = b2
					end
				else
					i = i + 1
				end
			end
		end
        -- Last chunk
        if (self.m_ws>0) then
            self.m_ws = 0
            self:_out("0 Tw\n")
        end
        if (border and strfind(border,'B', 1, true)) then
            b = b .. "B"
		end
        stmp = s:sub(j, i-1)
        self:Cell(w,h,stmp,b,2,align,fill)
        self.m_x = self.m_lMargin
    end,
    
     CalcLines = function(self, w, txt)
        --Computes the number of lines a MultiCell of width w will take
        local cw = self.m_CurrentFont.font.cw
        if (w==0) then w = self.m_w-self.m_rMargin-self.m_x end
        local wmax = (w-2*self.m_cMargin)*1000.0/self.m_FontSize
        local stmp
		local s = string.gsub(txt or "", "\r", "")
        local nb = #s
		local NL = strbyte("\n", 1)
		local SP = strbyte(" ", 1)
        if (nb>0 and s:byte(nb)==NL) then nb = nb -1 end
        local sep = -1
        local i = 1
        local j = 1
        local l = 0
        local ns = 0
        local nl = 1
        local ls = 0
        while (i<=nb) do
            -- Get next character
            local c = s:byte(i)
            if (c==NL) then
                i = i + 1
                sep = -1
                j = i
                l = 0
                ns = 0
                nl = nl + 1
			else
				if (c==SP) then
					sep = i
					ls = l
					ns = ns + 1
				end
				l = l + cw[c+1] --lua array is 1 based so we need to add 1
				if (l>wmax) then
					-- Automatic line break
					if (sep==-1) then
						if(i==j) then i = i +1 end
					else
						i = sep+1
					end
					sep = -1
					j = i
					l = 0
					ns = 0
					nl = nl +1
				else
					i = i + 1
				end
			end
		end
        return nl
     end,
     
    --MultiCell with bullet
    MultiCellBlt = function(self, w, h, blt, txt, border, align, fill)
		align = align or 'J'
        --Get bullet width including margins
        local blt_width = self:GetStringWidth(blt)+self.m_cMargin*2

        --Save x
        local bak_x = self.m_x

        --Output bullet
        self:Cell(blt_width, h, blt,0,' ', fill)

        --Output text
        self:MultiCell(w-blt_width, h, txt, border, align, fill)

        --Restore x
        self.m_x = bak_x;
    end,

    ClippingRect = function(self, x, y, w, h, outline)
        local op
		if outline then
			op = 'S'
		else
			op = 'n'
		end
		local k = self.m_k
        self:_outfmt("q %.2f %.2f %.2f %.2f re W %s\n",
            x*k, (self.m_h-y)*k, w*k,-h*k, op);
    end,

    UnsetClipping = function(self)
        self:_out("Q\n")
    end,

    ClippedCell = function(self, w, h, txt, border, ln, align, fill, link)
		h = h or 0
        if (border or fill or self.m_y+h>self.m_PageBreakTrigger) then
            self:Cell(w,h,'',border,0,'',fill)
            self.m_x= self.m_x - w
        end
        self:ClippingRect(self.m_x,self.m_y,w,h)
        self:Cell(w,h,txt,0,ln,align,false,link)
        self:UnsetClipping()
    end,

    --Cell with horizontal scaling if text is too wide
    CellFit = function(self, w, h, txt, border, ln, align, fill, link, scale, force)
		h = h or 0
        --Get string width
        local str_width=self:GetStringWidth(txt)

        --Calculate ratio to fit cell
        if (w==0.0) then w = self.m_w-self.m_rMargin-self.m_x end
        local ratio = (w-self.m_cMargin*2)/str_width

        local fit = (ratio < 1 or (ratio > 1 and force))
        if fit then
            if scale then
                --Calculate horizontal scaling
                local horiz_scale=ratio*100.0
                --Set horizontal scaling
                self:_outfmt("BT %.2f Tz ET\n", horiz_scale)
            else
                --Calculate character spacing in points
                -- TODO (mingo2#1#): UTF-8 strlen
                local txt_size = #txt;
                local char_space=(w-self.m_cMargin*2-str_width)/math.max(txt_size-1,1)*self.m_k
                --Set character spacing
                self:_outfmt("BT %.2f Tc ET\n", char_space)
            end
            --Override user alignment (since text will fill up cell)
            align=' '
        end

        --Pass on to Cell method
        self:Cell(w,h,txt,border,ln,align,fill,link)

        --Reset character spacing/horizontal scaling
        if fit then
			if scale then
				scale = "100 Tz"
			else
				scale = "0 Tc"
			end
            self:_outfmt("BT %s ET", scale)
        end
    end,

    --Cell with horizontal scaling only if necessary
    CellFitScale = function(self, w, h, txt, border, ln, align, fill, link)
        self:CellFit(w,h,txt,border,ln,align,fill,link,true,false)
    end,

    --Cell with horizontal scaling always
    CellFitScaleForce = function(self, w, h, txt, border, ln, align, fill, link)
        self:CellFit(w,h,txt,border,ln,align,fill,link,true,true)
    end,

    CellFitSpace = function(self, w, h, txt, border, ln, align, fill, link)
        self:CellFit(w,h,txt,border,ln,align,fill,link,false,false)
    end,

    CellFitSpaceForce = function(self, w, h, txt, border, ln, align, fill, link)
        --Same as calling CellFit directly
        self:CellFit(w,h,txt,border,ln,align,fill,link,false,true)
    end,
    
    Write = function(self, h, txt, link)
        -- Output text in flowing mode
        local cw = self.m_CurrentFont.font.cw
        local w = self.m_w - self.m_rMargin - self.m_x
        local wmax = (w-2 * self.m_cMargin)*1000.0/self.m_FontSize
        local stmp
		local s = string.gsub(txt or "", "\r", "")
        local nb = #s
		local NL = strbyte("\n", 1)
		local SP = strbyte(" ", 1)
        if (nb>0 and s:byte(nb)==NL) then nb = nb -1 end
        local sep = -1;
        local i = 1;
        local j = 1;
        local l = 0;
        local nl = 1;
        while(i<nb) do
        while(i<nb) do --double loop to allow brek anywhere simulating continue
		-- Get next character
		local c = s:byte(i)
		if (c==NL) then
			-- Explicit line break
			stmp = s:sub(j, i-1)
			self:Cell(w,h,stmp,0,2,'',0,link)
			i = i + 1
			sep = -1
			j = i
			l = 0
			if(nl==1) then
				self.m_x = self.m_lMargin
				w = self.m_w-self.m_rMargin-self.m_x
				wmax = (w-2*self.m_cMargin)*1000.0/self.m_FontSize
			end
			nl = nl + 1
		else
			if (c==SP) then sep = i end
			l = l + cw[c+1] --lua array is 1 based so we need to add 1
			if (l>wmax) then
				-- Automatic line break
				if (sep==-1) then
					if (self.m_x > self.m_lMargin) then
						-- Move to next line
						self.m_x = self.m_lMargin
						self.m_y = self.m_y + h
						w = self.m_w-self.m_rMargin-self.m_x
						wmax = (w-2*self.m_cMargin)*1000.0/self.m_FontSize
						i = i + 1
						nl = nl + 1
						break --continue
					else
						if(i==j) then i = i + 1 end
						stmp = s.substr(j, i-j)
						self:Cell(w,h,stmp,0,2,'',0,link)
					end
				else
					stmp = s.substr(j, i-1);
					self:Cell(w,h,stmp,0,2,'',0,link)
					i = sep+1
				end
				sep = -1
				j = i
				l = 0
				if (nl==1) then
					self.m_x = self.m_lMargin;
					w = self.m_w-self.m_rMargin-self.m_x
					wmax = (w-2*self.m_cMargin)*1000.0/self.m_FontSize
				end
				nl = nl + 1
			else
				i = i + 1
			end
		end
	end
	end
        -- Last chunk
        if (i~=j) then
            stmp = s:sub(j, i-1)
            self:Cell(l/1000.0*self.m_FontSize,h,stmp,0,0,'',0,link)
        end
    end,

    Ln = function(self, h)
        -- Line feed; default value is last cell height
        self.m_x = self.m_lMargin
        if (not h) then
			self.m_y = self.m_y + self.m_lasth
        else 
			self.m_y = self.m_y + h
		end
    end,
    
    --Image
    --end,
    
    GetX = function(self)
        -- Get x position
        return self.m_x
    end,

    SetX = function(self, x)
        -- Set x position
        if (x>=0) then
			self.m_x = x
        else 
			self.m_x = self.m_w+x
		end
    end,

    GetY = function(self)
        -- Get y position
        return self.m_y
    end,

    SetY = function(self, y)
        -- Set y position and reset x
        self.m_x = self.m_lMargin
        if (y>=0) then
			self.m_y = y
        else
			self.m_y = self.m_h+y
		end
    end,

    SetXY = function(self, x, y)
        -- Set x and y positions
        self:SetY(y)
        self:SetX(x)
    end,

    GetW = function(self)
        -- Get x position
        return self.m_w
    end,

    GetH = function(self)
        -- Get y position
        return self.m_h
    end,
    
    Output = function(self, name, dest)
        -- Output PDF to some destination
        if (self.m_state<3) then self:Close() end
        if (not dest) then
            if (not name) then
                name = "doc.pdf"
                dest = 'I'
            else
                dest = 'F'
			end
        end
        
--[[
        case 'I':
            // Send to standard output
            _checkoutput();
            if(PHP_SAPI~="cli")
            {
                // We send to a browser
                header("Content-Type: application/pdf");
                header("Content-Disposition: inline; filename="".name.""");
                header("Cache-Control: private, max-age=0, must-revalidate");
                header("Pragma: public");
            }
            echo m_buffer;
            break;
        case 'D':
            // Download file
            _checkoutput();
            header("Content-Type: application/x-download");
            header("Content-Disposition: attachment; filename="".name.""");
            header("Cache-Control: private, max-age=0, must-revalidate");
            header("Pragma: public");
            echo m_buffer;
            break;
]]
	local data = table.concat(self.m_buffer)
        if (dest == 'F') then
            -- Save to local file
            local name2 = system.pathForFile( nil,system.DocumentsDirectory  )
            name2 = name2 .. "/" .. name
            print(name2)
            local f = io.open(name2,"wb")
            if (not f) then
            	local file, errorString = io.open( name2, "w" )
 
				if not file then
					-- Error occurred; output the cause
					print( "File error: " .. errorString )
				end
                self:Error("Unable to create output file: %s", name)
	    end
            f:write(data);
            f:close()
        elseif dest == 'I' then
            -- Send to standard output
            print(data)
        elseif dest == 'S' then
            -- Return as a string
            return data
        else
            self:Error("Incorrect output destination: %c", dest)
        end
        return ""
    end,
    
    RoundedRect = function(self, x, y, w, h, r, style)
        local k = self.m_k;
        local hp = self.m_h;
        local MyArc = 4.0/3.0 * (math.sqrt(2) - 1)
        self:_outfmt("%.2f %.2f m\n",(x+r)*k,(hp-y)*k)
        local xc = x+w-r
        local yc = y+r
        self:_outfmt("%.2f %.2f l\n", xc*k,(hp-y)*k)

        self:_Arc(xc + r*MyArc, yc - r, xc + r, yc - r*MyArc, xc + r, yc)
        xc = x+w-r
        yc = y+h-r
        self:_outfmt("%.2f %.2f l\n",(x+w)*k,(hp-yc)*k)
        self:_Arc(xc + r, yc + r*MyArc, xc + r*MyArc, yc + r, xc, yc + r)
        xc = x+r
        yc = y+h-r
        self:_outfmt("%.2f %.2f l\n",xc*k,(hp-(y+h))*k)
        self:_Arc(xc - r*MyArc, yc + r, xc - r, yc + r*MyArc, xc - r, yc)
        xc = x+r
        yc = y+r
        self:_outfmt("%.2F %.2F l\n",(x)*k,(hp-yc)*k)
        self:_Arc(xc - r, yc - r*MyArc, xc - r*MyArc, yc - r, xc, yc - r)
        if (style=="F") then
			self:_out("f\n")
        elseif (style=="FD" or style=="DF") then
			self:_out("B\n")
        else 
			self:_out("S\n")
		end
    end,

    Circle = function(self, x, y, r, style)
        self:Ellipse(x,y,r,r,style or "D");
    end,

    Ellipse = function(self, x, y, rx, ry, style)
		style = style or "D"
        local op = "S"
        if (style=="F") then
			op ="f"
        elseif (style=="FD" or style=="DF") then
			op ="B"
		end
        local tmp = 4.0/3.0*(math.sqrt(2)-1)
        local lx=tmp*rx
        local ly=tmp*ry
		local h = self.m_h
		local k = self.m_k
        self:_outfmt("%.2f %.2f m %.2f %.2f %.2f %.2f %.2f %.2f c\n",
                (x+rx)*k,(h-y)*k,
                (x+rx)*k,(h-(y-ly))*k,
                (x+lx)*k,(h-(y-ry))*k,
                x*k,(h-(y-ry))*k)
        self:_outfmt("%.2f %.2f %.2f %.2f %.2f %.2f c\n",
                (x-lx)*k,(h-(y-ry))*k,
                (x-rx)*k,(h-(y-ly))*k,
                (x-rx)*k,(h-y)*k)
        self:_outfmt("%.2f %.2f %.2f %.2f %.2f %.2f c\n",
                (x-rx)*k,(h-(y+ly))*k,
                (x-lx)*k,(h-(y+ry))*k,
                x*k,(h-(y+ry))*k)
        self:_outfmt("%.2f %.2f %.2f %.2f %.2f %.2f c %s\n",
                (x+lx)*k,(h-(y+ry))*k,
                (x+rx)*k,(h-(y+ly))*k,
                (x+rx)*k,(h-y)*k,
                op)
    end,

    IncludeJS = function(self, script)
        self.m_javascript=script
    end,

--[[
*******************************************************************************
*                                                                              *
*                              Protected methods                               *
*                                                                              *
*******************************************************************************
]]

    _Arc = function(self, x1, y1, x2, y2, x3, y3)
        local h = self.m_h
	local k = self.m_k
        self:_outfmt("%.2f %.2f %.2f %.2f %.2f %.2f c \n", x1*k,
                (h-y1)*k, x2*k, (h-y2)*k, x3*k, (h-y3)*k);
    end,
    
    --_erasestrch(std::string &str, char c)
    --end,

    _dochecks = function(self)
    end,

    _checkoutput = function(self)
    end,
    
    _getpagesize = function(self, size)
	local result = {}
        if size == pdf_e_A3 then
            result.w = 841.89
            result.h = 1190.55
        elseif size == pdf_e_A5 then
            result.w = 420.94
            result.h = 595.28
        elseif size == pdf_e_Letter then
            result.w = 612
            result.h = 792
        elseif size == pdf_e_Legal then
            result.w = 612
            result.h = 1008
        else
            --case pdf_e_A4
            result.w = 595.28
            result.h = 841.89
        end

        result.w = result.w / self.m_k
        result.h = result.h / self.m_k
        return result
    end,

    _beginpage = function(self, orientation, size)
        self.m_page = self.m_page + 1
	tblinsert(self.m_pages, {})
        self.m_state = 2
        self.m_x = self.m_lMargin
        self.m_y = self.m_tMargin
        self.m_FontFamily = ""
        -- Check page size and orientation
        if (not orientation or orientation==pdf_e_orientation_none)  then orientation = self.m_DefOrientation end
        local psize
        if not size then
		psize = self.m_DefPageSize
        else 
		psize = size
	end
        if (orientation~=self.m_CurOrientation or psize.w ~= self.m_CurPageSize.w or psize.h  ~= self.m_CurPageSize.h) then
            -- New size or orientation
            if (orientation==pdf_e_orientation_portrait) then
                self.m_w = psize.w
                self.m_h = psize.h
            else
                self.m_w = psize.h
                self.m_h = psize.w
            end
            self.m_wPt = self.m_w*self.m_k;
            self.m_hPt = self.m_h*self.m_k;
            self.m_PageBreakTrigger = self.m_h-self.m_bMargin
            self.m_CurOrientation = orientation
            self.m_CurPageSize = psize
        end
	
        if (orientation ~= self.m_DefOrientation or psize.w ~= self.m_DefPageSize.w or psize.h ~= self.m_DefPageSize.h) then
            local ps = {}
            ps.w = self.m_wPt;
            ps.h = self.m_hPt;
            self.m_PageSizes[self.m_page] = ps
        end

        if self.m_doubleSided then
            if self.m_page % 2 == 0 then
                self.m_xDelta = self.m_outerMargin - self.m_innerMargin
                self:SetLeftMargin(self.m_outerMargin)
                self:SetRightMargin(self.m_innerMargin)
            else
                self.m_xDelta=self.m_innerMargin - self.m_outerMargin
                self:SetLeftMargin(self.m_innerMargin)
                self:SetRightMargin(self.m_outerMargin)
            end
            self.m_x=self.m_lMargin;
            self.m_y=self.m_tMargin;
        end
    end,

    _endpage = function(self)
        if self.m_angle ~=0 then
            self.m_angle=0
            self:_out("Q\n")
        end
        self.m_state = 1
    end,
    
    --_loadfont(std::string &font)
    --end,
    
     _escape = function(s)
        local str = s;
        if str and #str > 0 then
	    local needAgain = false
	    str = str:gsub("[\\()\r\226\194\195]", function(m)
		if m == "\\" then
			return "\\\\"
		elseif m == "(" then
			return "\\("
		elseif m == ")" then
			return "\\)"
		elseif m == "\r" then
			return ""
		elseif m == "\226" then
			return "\\200" --euro symbol
		elseif m == "\194" then
			return ""
		elseif m == "\195" then
			needAgain = true
			return m
		end
	    end)
	    if needAgain then
		str = str:gsub("[\195].", function(m)
				return string.char(m:byte(2)+64)
		    end)
	    end
        end
        return str
     end,
     
    _textstring = function(s)
        -- Format a text string
        return strfmt("(%s)", self._escape(s))
    end,
    
     --__UTF8toUTF16(const std::string &s)
     --end,
     
    char_count = function(str, c)
        local count = 0
        if str and #str > 0 then
		local byte_char = strbyte(c)
		for i = 1, #str do
			if str:byte( i) == byte_char then
				count = count + 1 
			end
		end
        end
        return count
    end,

    _dounderline = function(self, x, y, txt)
        -- Underline text
        local up = self.m_CurrentFont.font.up
        local ut = self.m_CurrentFont.font.ut
        local w = self:GetStringWidth(txt) + self.m_ws * self.char_count(txt,' ')
        return strfmt("%.2f %.2f %.2f %.2f re f", x*self.m_k, (self.m_h-(y-up/1000.0*self.m_FontSize))*self.m_k, w*self.m_k,-ut/1000.0*self.m_FontSizePt)
    end,

    _parsejpg = function(self, info, file_name,path)
        -- Extract info from a JPG file
        file_path = path .."\\".. file_name
        local fp = io.open(file_path,"rb")
		print("file_name2",file_path)
        if (not fp) then self:Error("Can't open image file: %s", file_name) end
        --self:blob_stream_file_t sf(fp)
		print("get_jpeg_info")
        info = get_jpeg_info(fp, file_path)
        
        return info
    end,

    _parsejpg_blob = function(self, info, image_name, image_blob, blob_size)
        if (not image_name) then self:Error("Image name is NULL!") end
        if (not image_blob) then self:Error("Image blob is NULL!") end
        if (not blob_size) then self:Error("Image blob size is zero!") end
        --self:blob_stream_memory_t sm(image_blob, blob_size);
        self:_parsejpg(info, sm, image_name)
    end,

    _parsepng = function(self, info, file_name)
        -- Extract info from a PNG file
        
        local fp = io.open(file_name2,"rb")

        if (not fp) then self:Error("Can't open image file: %s", file_name) end
        --blob_stream_file_t sf(fp);
        self:_parsepngstream(info, sf, file_name)
    end,


    _parsepng_blob = function(self, info, image_name, image_blob, blob_size)
        if (not image_name) then self:Error("Image name is NULL!") end
        if (not image_blob) then self:Error("Image blob is NULL!") end
        if (not blob_size) then Error("Image blob size is zero!") end
        --blob_stream_memory_t sm(image_blob, blob_size);
        self:_parsepngstream(info, sm, image_name)
    end,

    _getGrayImgColorAndalpha = function(self, color, alpha, line)
        local size = #line
        for i=1, size, 2 do
            tblinsert(color, line:byte(i))
            tblinsert(alpha, line:byte(i+1))
        end
    end,

    _getRGBImgColorAndalpha = function(self, color, alpha, line)
        local size = #line
        for i=1, size, 4 do
            tblinsert(color, line:sub(i, 3))
            tblinsert(alpha, line:byte(i+3))
        end
    end,

    --_parsepngstream = function(self, st_image &info, blob_stream_t &fp, const char *image_name)
    --end,
    
    _readstream = function(self, fp, n)
    end,
        
    _parsegif = function(self, file)
    end,
    
    _calc_m_buffer_size = function(self)
	local size = 0
	for k,v in pairs(self.m_buffer) do
		size = size + #v
	end
	return size
    end,
    
    _newobj = function(self)
        -- Begin a new object
        self.m_n = self.m_n + 1
        tblinsert(self.m_offsets, self:_calc_m_buffer_size())
        self:_outfmt("%d 0 obj\n", self.m_n)
    end,

    _putstream = function(self, s)
        self:_out("stream\n")
        self:_out(s)
        self:_out("\nendstream\n")
    end,

    _out = function(self, s)
        -- Add a line to the document
        if self.m_state==2 then
	    tblinsert(self.m_pages[self.m_page], s)
        else
            tblinsert(self.m_buffer, s)
        end
    end,
    
    _outfmt = function(self, fmt, ...)
	self:_out(strfmt(fmt, ...))
    end,
    
    _putpages = function(self)
        local nb = self.m_page
	for n=1, nb do
		self.m_pages[n] = table.concat(self.m_pages[n])
	end
        if (self.m_AliasNbPages) then
            -- Replace number of pages
            local str = strfmt("%d", nb)
            for n=1, nb do
                local page = self.m_pages[n]
		self.m_pages[n] = page:gsub(self.m_AliasNbPages, str)
            end
        end
        local wPt, hPt
	local k = self.m_k
        if (self.m_DefOrientation==pdf_e_orientation_portrait) then
            wPt = self.m_DefPageSize.w*k
            hPt = self.m_DefPageSize.h*k
        else
            wPt = self.m_DefPageSize.h*k
            hPt = self.m_DefPageSize.w*k
        end
        local filter
	if (self.m_compress) then
		filter = "/Filter /FlateDecode "
	else
		filter = ""
	end
        for n=1, nb do
            -- Page
            self:_newobj()
            self:_outfmt("<<\n/Type /Page\n/Parent 1 0 R\n");
            if (self.m_PageSizes[n] and #self.m_PageSizes[n] > 0) then
                self:_outfmt("/MediaBox [0 0 %.2f %.2f]\n", self.m_PageSizes[n].w, self.m_PageSizes[n].h)
	    end
            self:_outfmt("/Resources 2 0 R\n")
            if (self.m_PageLinks[n]) then
                -- Links
                local annots = "/Annots ["
--[[
                link_map_t::iterator iter = m_PageLinks[n].begin();
                link_map_t::iterator iend = m_PageLinks[n].end();
                for(; iter ~= iend; ++iter)
                {
                    st_page_link &pl = *iter->second;
                    pdf_snprintf(m_scratch_buf, sizeof(m_scratch_buf), "%.2f %.2f %.2f %.2f",pl[0],pl[1],pl[0]+pl[2],pl[1]-pl[3]);
                    rect = m_scratch_buf;
                    annots += "<<\n/Type /Annot /Subtype /Link /Rect [" +  rect + "] /Border [0 0 0] ";
                    if(is_string(pl[4]))
                        annots += "/A\n<<\n/S /URI /URI " + _3textstring(pl[4]) + "\n>>\n>>\n";
                    else
                    {
                        l = m_links[pl[4] ];
                        int lidx = l[0];
                        h = m_PageSizes.find([lidx]) ~= -1 ? m_PageSizes[lidx].h : hPt;
                        pdf_sprintf_append(annots, "/Dest [%d 0 R /XYZ 0 %.2f null]\n>>\n",1+2*lidx,h-l[1]*m_k);
                    }
                }
]]
               self: _outfmt("%s]\n", annots)
            end
            if (self.m_PDFVersion > "1.3") then
                self:_outfmt("/Group\n<<\n/Type /Group /S /Transparency /CS /DeviceRGB\n>>\n")
	    end
            self:_outfmt("/Contents %d 0 R\n>>\n", self.m_n+1)
            self:_out("endobj\n")
            -- Page content
            local zbuf
	    local p
	    if PDF_USING_ZLIB then
		if self.m_compress then
			p = gzcompress(zbuf, self.m_pages[n])
		else
			p = self.m_pages[n]
		end
	    else
                p = self.m_pages[n]
	    end
            self:_newobj()
            self:_outfmt("<<\n%s/Length %d\n>>\n", filter, #p)
            self:_putstream(p)
            self:_out("endobj\n")
        end
        -- Pages root
        self.m_offsets[1] = self:_calc_m_buffer_size()
        self:_out("1 0 obj\n<<\n/Type /Pages\n")
        local kids = "/Kids ["
        for  i=1, nb do
		kids = strfmt("%s %d 0 R ", kids, (3+2*(i-1)))
	end
        self:_outfmt("%s]\n/Count %d\n/MediaBox [0 0 %.2f %.2f]\n>>\nendobj\n", kids, nb, wPt, hPt);
    end,
    
    _putfonts = function(self)
--[[
        int nf = m_n;
        foreach(m_diffs as diff)
        {
            // Encodings
            _newobj();
            _outfmt(true, "<<\n/Type /Encoding /BaseEncoding /WinAnsiEncoding /Differences [".diff."]\n>>");
            _outfmt(true, "endobj");
        }
        foreach(m_FontFiles as file=>info)
        {
            // Font file embedding
            _newobj();
            m_FontFiles[file].n = m_n;
            font = file_get_contents(m_fontpath + file,true);
            if(!font) Error("Font file not found: ".file);
            compressed = (substr(file,-2)==".z");
            if(!compressed && isset(info.length2))
                font = substr(font,6,info.length1).substr(font,6+info.length1+6,info.length2);
            _outfmt(true, "<<\n/Length %d", strlen(font));
            if(compressed) _outfmt(true, "/Filter /FlateDecode");
            _outfmt(true, "/Length1 %d", info.length1);
            if(isset(info["length2"]))
                _outfmt(true, "/Length2 %d /Length3 0", info.length2);
            _outfmt(true, ">>");
            _putstream(font);
            _outfmt(true, "endobj");
        }
]]
        for k,font in pairs(self.m_fonts) do
            -- Font objects
            font.n = self.m_n+1
            local ftype = font.font.ftype
            local name = font.name
            if(ftype==pdf_e_font_type_core) then
                -- Core font
                self:_newobj()
                self:_outfmt("<<\n/Type /Font\n/BaseFont /%s\n/Subtype /Type1\n", name)
                if (name ~="Symbol" and name ~="ZapfDingbats") then
                    self:_out("/Encoding /WinAnsiEncoding\n")
		end
                self:_out(">>\nendobj\n");
            end
--[[
            else if(type==e_font_type_type1 || type==e_font_type_ttf)
            {
                // Additional Type1 or TrueType/OpenType font
                _newobj();
                _out("<<\n/Type /Font");
                _out("/BaseFont /" + name);
                _out("/Subtype /" + type);
                _out("/FirstChar 32 /LastChar 255");
                _outfmt(true, "/Widths %d 0 R", (m_n+1));
                _outfmt(true, "/FontDescriptor %d 0 R", (m_n+2));
                if(isset(font["diffn"]))
                    _outfmt(true, "/Encoding %d 0 R", nf+font.diffn);
                else
                    _out("/Encoding /WinAnsiEncoding");
                _out(">>");
                _out("endobj");
                // Widths
                _newobj();
                cw = font.cw;
                std::string s = "[";
                s.reserve(1024);
                for(i=32; i<=255; i++)
                    pdf_sprintf_append(s, "%d ", cw[chr(i)]);
                _out(s + "]");
                _out("endobj");
                // Descriptor
                _newobj();
                s = "<<\n/Type /FontDescriptor /FontName /" + name;
                foreach(font["desc"] as k=>v)
                s += " /".k." ".v;
                if(!empty(font["file"]))
                    s += " /FontFile".(type=="Type1" ? "" : "2")." ".m_FontFiles[font["file"] ]["n"]." 0 R";
                _outfmt(true, s.">>");
                _outfmt(true, "endobj");
            }
            else
            {
                // Allow for additional types
                mtd = "_put".strtolower(type);
                if(!method_exists(this,mtd))
                    Error("Unsupported font type: ".type);
                mtd(font);
            }
]]
        end
    end,
    
    _putimages = function(self)
        for k, image in pairs(self.m_images) do
            self:_putimage(image)
            image.data = nil
            image.smask = nil
        end
    end,
    
    _putimage = function(self, info)
        self:_newobj()
        info.n = self.m_n
        self:_out("<<\n/Type /XObject\n/Subtype /Image\n")
        self:_outfmt("/Width %d\n", info.w)
        self:_outfmt("/Height %d\n", info.h)
        if (info.cs=="Indexed") then
            self:_outfmt("/ColorSpace [/Indexed /DeviceRGB %d %d 0 R]\n", (#info.pal)/3-1, (self.m_n+1))
        else
            self:_outfmt("/ColorSpace /%s\n", info.cs)
            if (info.cs=="DeviceCMYK") then
                self:_out("/Decode [1 0 1 0 1 0 1 0]\n")
            end
        end
        self:_outfmt("/BitsPerComponent %d\n", info.bpc)
        if(info.f and #info.f > 0) then
            self:_outfmt("/Filter /%s\n", info.f)
        end
        if (info.dp and #info.dp > 0) then
            self:_outfmt("/DecodeParms\n<<\n%s\n>>", info.dp)
        end
        if(info.trns and #info.trns > 0) then
            local trns = {"/Mask ["}
            for i=1, #info.trns do
				tblinsert(trns, strfmt(" %d", info.trns[i]))
            end
            tblinsert(trns, "]")
            self:_outfmt("%s\n", table.concat(trns))
        end
        if (info.smask and #info.mask > 0) then
            self:_outfmt("/SMask %d  0 R\n", (self.m_n+1))
        end

        self:_outfmt("/Length %d\n>>\n", #info.data)
        self:_putstream(info.data)
        self:_out("endobj\n")
        -- Soft mask
        if(info.smask and #info.smask > 0) then
            local dp = strfmt("/Predictor 15 /Colors 1 /BitsPerComponent 8 /Columns %d", info.w)
            local smask = info
            smask.cs = "DeviceGray"
            smask.bpc = 8
            smask.dp = dp
            smask.data = info.smask
            self:_putimage(smask)
        end
        -- Palette
        if (info.cs=="Indexed") then
            local filter
            if (self.m_compress) then
				filter = "/Filter /FlateDecode "
			else
				filter = ""
			end
            local zbuf
            local pal
			if PDF_USING_ZLIB then
				if self.m_compress then
					pal = gzcompress(zbuf, info.pal)
				else
					pal = info.pal
				end
			else
				pal = info.pal
			end
            self:_newobj()
            self:_outfmt("<<\n%s/Length %d\n>>\n", filter, #pal)
            self:_putstream(pal)
            self:_out("endobj\n")
        end
    end,
    
    _putxobjectdict = function(self)
        for k,v in pairs(self.m_images) do
            self:_outfmt("/I%d %d 0 R\n", v.i, v.n)
		end
    end,

    _putextgstates = function(self)
        for i = 1, #self.m_extgstates do
		self:_newobj()
		local gs = self.m_extgstates[i]
		gs.n = self.m_n;
		self:_outfmt("<<\n/Type /ExtGState\n/ca %0.3f\n/CA %0.3f\n/BM /%s\n>>\nendobj\n", gs.alpha, gs.alpha, gs.bm)
        end
    end,

    _putjavascript = function(self)
        self:_newobj()
        self.m_n_js=self.m_n
        self:_outfmt("<<\n/Names [(EmbeddedJS) %d 0 R]\n>>\nendobj\n", self.m_n+1)
        self:_newobj()
        self:_outfmt("<<\n/S /JavaScript\n/JS (%s)\n>>\nendobj\n", self._escape(self.m_javascript))
    end,

    _putresourcedict = function(self)
        self:_out("/ProcSet [/PDF /Text /ImageB /ImageC /ImageI]\n/Font\n<<\n")
        for k,v in pairs(self.m_fonts) do
            self:_outfmt("/F%d %d 0 R\n", v.i, v.n or 0);
		end
        self:_outfmt(">>\n/XObject\n<<\n")
        self:_putxobjectdict()
        self:_outfmt(">>\n")
        if #self.m_extgstates > 0 then
            self:_out("/ExtGState\n<<\n")
            for i = 1, #self.m_extgstates do
                self:_outfmt("/GS%d %d 0 R\n", i, self.m_extgstates[i].n)
            end
            self:_out(">>\n")
        end
    end,

    _putresources = function(self)
        self:_putextgstates()
        self:_putfonts()
        self:_putimages()
        -- Resource dictionary
        self.m_offsets[2] = self:_calc_m_buffer_size()
        self:_outfmt("2 0 obj\n<<\n")
        self:_putresourcedict()
        self:_out(">>\nendobj\n")
        if  self.m_javascript and #self.m_javascript > 0 then
            self:_putjavascript()
        end
    end,

    _putinfo = function(self)
        local str = self._escape(FPDF_VERSION)
        self:_outfmt("/Producer (LuaFPDF %s)\n", str)
        if self.m_title and #self.m_title > 0 then
            str = self._escape(self.m_title)
            self:_outfmt("/Title (%s)\n", str)
        end
        if self.m_subject and #self.m_subject > 0 then
            str = self._escape(self.m_subject)
            self:_outfmt("/Subject (%s)\n", str)
        end
        if self.m_author and #self.m_author > 0 then
            str = self._escape(self.m_author)
            self:_outfmt("/Author (%s)\n", str);
        end
        if self.m_keywords and #self.m_keywords > 0 then
            str = self._escape(self.m_keywords)
            self:_outfmt("/Keywords (%s)\n", str)
        end
        if self.m_creator and #self.m_creator > 0 then
            str = self._escape(self.m_creator)
            self:_outfmt("/Creator (%s)\n", str)
        end

        self:_out(os.date("/CreationDate (D:%Y%m%d%H%M%S)\n"))
    end,

    _putcatalog = function(self)
        self:_outfmt("/Type /Catalog\n/Pages 1 0 R\n")
        if self.m_CustomZoom ~= pdf_e_zoom_default then
            self:_outfmt("/OpenAction [3 0 R /XYZ null null %.2f]\n", self.m_CustomZoom/100.0)
        elseif self.m_ZoomMode==pdf_e_zoom_fullpage then
            self:_outfmt("/OpenAction [3 0 R /Fit]\n")
        elseif self.m_ZoomMode==pdf_e_zoom_fullwidth then
            self:_outfmt("/OpenAction [3 0 R /FitH null]\n")
        elseif self.m_ZoomMode==pdf_e_zoom_real then
            self:_outfmt("/OpenAction [3 0 R /XYZ null null 1]\n")
	end
	
        if self.m_LayoutMode==pdf_e_layout_single then
            self:_outfmt("/PageLayout /SinglePage\n")
        elseif self.m_LayoutMode==pdf_e_layout_continuous then
            self:_outfmt("/PageLayout /OneColumn\n")
        elseif self.m_LayoutMode==pdf_e_layout_two then
            self:_outfmt("/PageLayout /TwoColumnLeft\n")
	end
	
        if self.m_javascript and #self.m_javascript > 0 then
            self:_outfmt("/Names\n<<\n/JavaScript %d 0 R\n>>\n", self.m_n_js)
        end
    end,

    _putheader = function(self)
        self:_out(strfmt("%%PDF-%s\n", self.m_PDFVersion))
    end,

    _puttrailer = function(self)
		local n = self.m_n
        self:_outfmt("/Size %d\n/Root %d 0 R\n/Info %d 0 R\n", (n+1), n, (n-1))
    end,

    _enddoc = function(self)
        if (#self.m_extgstates > 0 and (self.m_PDFVersion < "1.4") ) then self.m_PDFVersion = "1.4" end
        self:_putheader()
        self:_putpages()
        self:_putresources()
        -- Info
        self:_newobj()
        self:_out("<<\n")
        self:_putinfo()
        self:_out(">>\nendobj\n")
        -- Catalog
        self:_newobj()
        self:_out("<<\n")
        self:_putcatalog()
        self:_out(">>\nendobj\n")
        --save begining of xref
        local saved_startxref = self:_calc_m_buffer_size()
        -- Cross-ref
        self:_outfmt("xref\n0 %d\n0000000000 65535 f \n", (self.m_n+1))
        for i=1, self.m_n do
            self:_outfmt("%010d 00000 n \n", self.m_offsets[i])
        end
        -- Trailer
        self:_out("trailer\n<<\n")
        self:_puttrailer()
        self:_outfmt(">>\nstartxref\n%d\n%%%%EOF\n", saved_startxref)
        self.m_state = 3
    end,
    
}

function luaFPDF:new(obj)
	obj = obj or {}   -- create object if user does not provide one
	setmetatable(obj, self)
	self.__index = self
	obj:reset(pdf_e_orientation_portrait, pdf_e_units_mm, pdf_e_A4)
	return obj
end

