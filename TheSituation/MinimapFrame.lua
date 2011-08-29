----------
-- Name: TheSituation
-- Version: 2.0.x
-- License: All Rights Reserved
----------


--=====--=====--=====--
-- [PRIVATE PROPERTIES]
--=====--=====--=====--


SITUATION.MinimapFrame.frames = {};
SITUATION.MinimapFrame.buttons = {};
SITUATION.MinimapFrame.text = {};


local Libs = SITUATION.Libs;
local Spells = SITUATION.Spells;
local Tools = SITUATION.Tools;
local Units = SITUATION.Units;
local MinimapFrame = SITUATION.MinimapFrame;

local frames = SITUATION.MinimapFrame.frames;
local buttons = SITUATION.MinimapFrame.buttons;
local text = SITUATION.MinimapFrame.text;


--=====--=====--=====--
-- [PRIVATE METHODS]
--=====--=====--=====--


function MinimapFrame.build()
	frames.anchor = CreateFrame('Button', 'SITUATION_MINIMAPFRAME_FRAMES_ANCHOR', Minimap);
	frames.anchor:SetWidth(32);
	frames.anchor:SetHeight(32);
	frames.anchor:EnableMouse(true);
	frames.anchor:SetMovable(true);
	frames.anchor:SetFrameStrata('LOW');
	frames.anchor:SetScript('OnDragStart', MinimapFrame.onDragStart);
	frames.anchor:SetScript('OnDragStop', MinimapFrame.onDragStop);
	frames.anchor:SetScript('OnClick', function() SITUATION.setParse(not SITUATION.parse) end);
	local radius = frames.anchor:GetWidth() / 2 + 63;
	frames.anchor:SetPoint('CENTER', Minimap, 'CENTER', 0.0 - (radius * cos(SITUATION_OPTIONS.mf.angle)), (radius * sin(SITUATION_OPTIONS.mf.angle)) - 1.0)
	frames.anchor:RegisterForClicks('LeftButtonUp');
	frames.anchor:RegisterForDrag('LeftButton');
	
	frames.anchorBgTexture = frames.anchor:CreateTexture('SITUATION_MINIMAPFRAME_FRAMES_ANCHORBGTEXTURE', 'BACKGROUND');
	frames.anchorBgTexture:SetTexture('Interface\\Icons\\Inv_misc_summerfest_brazierred');
	frames.anchorBgTexture:SetWidth(19);
	frames.anchorBgTexture:SetHeight(19);
	frames.anchorBgTexture:SetPoint('CENTER', frames.anchor, 'CENTER', -0.5, 1.5); 
	
	frames.anchorBorderTexture = frames.anchor:CreateTexture('SITUATION_MINIMAPFRAME_FRAMES_ANCHORBORDERTEXTURE', 'OVERLAY');
	frames.anchorBorderTexture:SetWidth(52);
	frames.anchorBorderTexture:SetHeight(52);
	frames.anchorBorderTexture:SetTexture('Interface\\Minimap\\MiniMap-TrackingBorder');
	frames.anchorBorderTexture:SetPoint('TOPLEFT', frames.anchor, 'TOPLEFT');
	
	frames.anchor.texture = frames.anchorBgTexture;
	frames.anchor.texture = frames.anchorBorderTexture;
end


function MinimapFrame.onDragStart()
	frames.anchor:SetScript('OnUpdate', MinimapFrame.move);
end


function MinimapFrame.onDragStop()
	frames.anchor:SetScript('OnUpdate', nil)
end


function MinimapFrame.getAngle()
	local mouseX, mouseY = GetCursorPosition();
	local mapX, mapY = Minimap:GetLeft(), Minimap:GetBottom();

	mouseX = (mapX - (mouseX / UIParent:GetScale())) + 70.5;
	mouseY = ((mouseY / UIParent:GetScale()) - mapY) - 70.5;
	
	local angle = math.deg(math.atan2(mouseY, mouseX));
	
	return angle;
end


function MinimapFrame.move()
	local angle = MinimapFrame.getAngle();
	local radius = frames.anchor:GetWidth() / 2 + 63;
	frames.anchor:SetPoint('CENTER', Minimap, 'CENTER', 0.0 - (radius * cos(angle)), (radius * sin(angle)) - 1.0);
	SITUATION_OPTIONS.mf.angle = angle;
end