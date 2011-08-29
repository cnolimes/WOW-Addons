----------
-- Name: TheSituation
-- Version: 2.0.x
-- License: All Rights Reserved
----------


--=====--=====--=====--
-- [PRIVATE PROPERTIES]
--=====--=====--=====--

local SITUATION = SITUATION;
local DebugFrame = SITUATION.DebugFrame;
DebugFrame.lastLeft = ""
DebugFrame.lastRight = ""

local NUM_LINES = 30
local LINE_HEIGHT = 10
local FRAME_X = 100
local FRAME_Y = -100


local function InitDF()
	DebugFrame.frame = CreateFrame("Frame", "SITUATIONDebugFrame")
	DebugFrame.frame:SetSize(200, NUM_LINES * (LINE_HEIGHT + 2))
	DebugFrame.frame:SetPoint("LEFT", UIParent, 300, 30)
	DebugFrame.frame:SetBackdrop(GameTooltip:GetBackdrop())
	DebugFrame.frame:SetBackdropColor(GameTooltip:GetBackdropColor())

	-- Make the fame movable
	DebugFrame.frame:EnableMouse(true);
	DebugFrame.frame:SetMovable(true);
	DebugFrame.frame:SetScript('OnMouseDown', 	function() DebugFrame.frame:StartMoving(); end);
	DebugFrame.frame:SetScript('OnMouseUp', 	function() DebugFrame.frame:StopMovingOrSizing(); end);
	DebugFrame.frame:SetScript('OnDragStart', 	function() DebugFrame.frame:StartMoving(); end);
	DebugFrame.frame:SetScript('OnDragStop', 	function() DebugFrame.frame:StopMovingOrSizing(); end);
	
	DebugFrame.frame.numLeft, DebugFrame.frame.numRight = 0, 0
	DebugFrame.frame.left, DebugFrame.frame.right = {}, {}
	
	for i = 1, NUM_LINES do
		DebugFrame.frame.left[i] = DebugFrame.frame:CreateFontString(nil, nil, "SystemFont_Tiny")
		DebugFrame.frame.left[i]:SetJustifyH("LEFT")
		DebugFrame.frame.left[i]:SetPoint("TOPLEFT", 10, -(LINE_HEIGHT + 1) * i)
		DebugFrame.frame.right[i] = DebugFrame.frame:CreateFontString(nil, nil, "SystemFont_Tiny")
		DebugFrame.frame.right[i]:SetJustifyH("RIGHT")
		DebugFrame.frame.right[i]:SetPoint("TOPRIGHT", -10, -(LINE_HEIGHT + 1) * i)
	end
end

function DebugFrame.build()
	if DebugFrame.frame == nil then InitDF() end
	DebugFrame.frame:SetPoint("TOPLEFT", UIParent, "TOPLEFT", FRAME_X, FRAME_Y)
	if SITUATION.trace then	
		DebugFrame.frame:Show()
	else
		if DebugFrame.frame then DebugFrame.frame:Hide() end
	end
end

function DebugFrame.Clear()
	DebugFrame.frame.numLeft, DebugFrame.frame.numRight = 0, 0
	for i = 1, NUM_LINES do
		DebugFrame.frame.left[i]:SetText("")
		DebugFrame.frame.right[i]:SetText("")
	end
end

function DebugFrame.AddLeft(text)
	if(text == DebugFrame.lastLeft) then
		return
	else
		if(DebugFrame.frame.numLeft >= NUM_LINES or DebugFrame.frame.numRight >= NUM_LINES) then
			DebugFrame.frame.numLeft = 0
			DebugFrame.frame.numRight = 0
		end
		DebugFrame.lastLeft = text
		DebugFrame.frame.numLeft = DebugFrame.frame.numLeft + 1
		DebugFrame.frame.numRight = DebugFrame.frame.numRight + 1
		DebugFrame.frame.left[DebugFrame.frame.numLeft]:SetText(DebugFrame.lastLeft)
	end
end

function DebugFrame.AddRight(text)
	if(text == DebugFrame.lastRight) then
		return
	else
		DebugFrame.lastRight = text
		if(DebugFrame.frame.numLeft >= NUM_LINES or DebugFrame.frame.numRight >= NUM_LINES) then
			DebugFrame.frame.numLeft = 0
			DebugFrame.frame.numRight = 0
		end
		DebugFrame.frame.numLeft = DebugFrame.frame.numLeft + 1
		DebugFrame.frame.numRight = DebugFrame.frame.numRight + 1
		DebugFrame.frame.right[DebugFrame.frame.numRight]:SetText(DebugFrame.lastRight)
	end
end

function DebugFrame.AddBoth(t1, t2)
	if( t1 == DebugFrame.lastLeft or t2 == DebugFrame.lastRight) then
		return
	else
		DebugFrame.lastLeft = t1
		DebugFrame.lastRight = t2
		if(DebugFrame.frame.numLeft >= NUM_LINES or DebugFrame.frame.numRight >= NUM_LINES) then
			DebugFrame.frame.numLeft = 0
			DebugFrame.frame.numRight = 0
		end
		DebugFrame.frame.numLeft = DebugFrame.frame.numLeft + 1
		DebugFrame.frame.numRight = DebugFrame.frame.numRight + 1
		DebugFrame.frame.left[DebugFrame.frame.numLeft]:SetText(DebugFrame.lastLeft)
		DebugFrame.frame.right[DebugFrame.frame.numRight]:SetText(DebugFrame.lastRight)
	end
end
