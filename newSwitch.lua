local M = {}
local W = display.contentWidth
local H = display.contentHeight

local widget = require "widget"


local function new(atributos,listener)
	local widget = require( "widget" )
	local width = atributos.width or 200
	local height = atributos.height or 100
	local label1 = atributos.label1 or "LIVRO"
	local label2 = atributos.label2 or "OUTROS"
	local fontSize = atributos.fontSize or 60
	-- Create a group for the radio button set
	local radioGroup = display.newGroup()
	
	-- Image sheet options and declaration
	local options = {
		width = 200,
		height = 100,
		numFrames = 2,
		sheetContentWidth = 400,
		sheetContentHeight = 100
	}
	local radioButtonSheet = graphics.newImageSheet( "chatSwitch.png", options )
	 
	-- Create two associated radio buttons (inserted into the same display group)
	radioGroup.btn1 = widget.newSwitch(
		{
			left = 0,
			top = 0,
			style = "radio",
			id = label1,
			width = atributos.width,
			height = atributos.height,
			initialSwitchState = true,
			onPress = listener,
			sheet = radioButtonSheet,
			frameOff = 1,
			frameOn = 2
		}
	)
	radioGroup:insert( radioGroup.btn1 )
	radioGroup.btn1.label = display.newText(radioGroup,label1,radioGroup.btn1.x,radioGroup.btn1.y,"Fontes/paolaAccent.ttf",fontSize)
	radioGroup.btn1.label:setFillColor(1,1,1)
	 
	radioGroup.btn2 = widget.newSwitch(
		{
			left = radioGroup.btn1.x + radioGroup.btn1.width/2 + 20,
			top = 0,
			style = "radio",
			id = label2,
			width = atributos.width,
			height = atributos.height,
			onPress = listener,
			sheet = radioButtonSheet,
			frameOff = 1,
			frameOn = 2
		}
	)
	radioGroup:insert( radioGroup.btn2 )
	radioGroup.btn2.label = display.newText(radioGroup,label2,radioGroup.btn2.x,radioGroup.btn2.y,"Fontes/paolaAccent.ttf",fontSize)
	radioGroup.btn2.label:setFillColor(0,0,0)
	
	return radioGroup
end
M.new = new

return M