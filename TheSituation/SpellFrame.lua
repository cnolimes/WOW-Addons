----------
-- Name: TheSituation
-- Version: 2.0.x
-- License: All Rights Reserved
----------


--=====--=====--=====--
-- [PRIVATE PROPERTIES]
--=====--=====--=====--

local SITUATION = SITUATION;
local Libs = SITUATION.Libs;
local Spells = SITUATION.Spells;
local Tools = SITUATION.Tools;
local SpellFrame = SITUATION.SpellFrame;


SpellFrame.frames = {};
SpellFrame.textures = {};
SpellFrame.text = {};

local frames = SpellFrame.frames;
local textures = SpellFrame.textures;
local text = SpellFrame.text;


local TEXTURE_COUNT = 3
local TEXTURE_Y_OFFSET=-22
local SQUARE_SIZE = 30
local ANCHOR_BACKDROP = "Interface\FullScreenTextures\OutOfControl"
local ANCHOR_EDGE = "Interface\DialogFrame\UI-DialogBox-Border"

local ANCHOR_HEIGHT = SQUARE_SIZE + 28
local ANCHOR_WIDTH 	= ((TEXTURE_COUNT * SQUARE_SIZE) + 40 + (4 * TEXTURE_COUNT))


--=====--=====--=====--
-- [PRIVATE METHODS]
--=====--=====--=====--

function SpellFrame.build()
	SpellFrame.lastColor1 = 0
	SpellFrame.lastColor2 = 0
	SpellFrame.lastColor3 = 0
	frames.anchor = CreateFrame('Frame', 'SITUATION_SPELL_FRAME_ANCHOR', UIParent);
	frames.anchor:SetPoint("CENTER", UIParent, 0, 0);
	frames.anchor:SetClampedToScreen(true);
	frames.anchor:SetBackdrop(GameTooltip:GetBackdrop())
	-- frames.anchor:SetBackdropColor(GameTooltip:GetBackdropColor())
	-- frames.anchor:SetBackdrop({bgFile = ANCHOR_BACKDROP, edgeFile = ANCHOR_EDGE, tile = true, tileSize = 15, edgeSize = 15});
	frames.anchor:SetBackdropColor(0,0,0);
	frames.anchor:SetSize(ANCHOR_WIDTH, ANCHOR_HEIGHT);
	
	frames.anchor:EnableMouse(true);
	frames.anchor:SetMovable(true);
	frames.anchor:SetFrameStrata('MEDIUM');
	frames.anchor:SetScript('OnDragStart', function() frames.anchor:StartMoving(); end);
	frames.anchor:SetScript('OnDragStop', function() frames.anchor:StopMovingOrSizing(); end);
	frames.anchor:SetScript('OnMouseDown', function() frames.anchor:StartMoving(); end);
	frames.anchor:SetScript('OnMouseUp', function() frames.anchor:StopMovingOrSizing(); end);
	frames.anchor:SetScript('OnUpdate', SpellFrame.onUpdate)
	frames.anchor:SetScript('OnEvent', SpellFrame.onEvent)
	
	frames.colorbox = SpellFrame.colorBox()
	for i = 1, TEXTURE_COUNT do
		textures[i] = SpellFrame.newTexture(i)
	end
	text = frames.anchor:CreateFontString(nil, nil, "GameFontNormal")
	text:SetJustifyH("LEFT")
	text:SetPoint("TOPLEFT", 10, -7)
	frames.anchor:Show()
end

function SpellFrame.setTitle(msgText)
	text:SetText(msgText)
end

function SpellFrame.colorBox()
	texture = frames.anchor:CreateTexture("COLORBOX", "OVERLAY");
	texture:SetHeight(SQUARE_SIZE);
	texture:SetWidth(SQUARE_SIZE);
	TEXTURE_X_OFFSET = 8
	texture:SetPoint("TOPLEFT", TEXTURE_X_OFFSET , TEXTURE_Y_OFFSET);
	texture:SetTexture(0,0,0);
	texture:Show();
	return texture
end

function SpellFrame.newTexture(count)
	texture = frames.anchor:CreateTexture("ABILITY_" .. count, "OVERLAY");
	texture:SetSize(SQUARE_SIZE, SQUARE_SIZE);
	TEXTURE_X_OFFSET = ((count * SQUARE_SIZE) + 8 + (2*count));
	texture:SetPoint("TOPLEFT", TEXTURE_X_OFFSET , TEXTURE_Y_OFFSET);
	tcolor = count * .3;
	texture:SetTexture(0,0,0);
	texture:Show();
	return texture
end

function SpellFrame.setColor(spell1,spell2,spell3)
	frames.colorbox:SetTexture(spell1,spell2,spell3);
end
function SpellFrame.setIcon(textureNum, icon)
	textures[textureNum]:SetTexture(icon)
end

function SpellFrame.onUpdate(pSelf, pElapsed)
	if( not(SpellFrame.lastColor1 == SITUATION.spellColor1 and SpellFrame.lastColor2 == SITUATION.spellColor2 and SpellFrame.lastColor3 == SITUATION.spellColor3)) then
		SpellFrame.setColor(SITUATION.spellColor1,SITUATION.spellColor2,SITUATION.spellColor3);
		SpellFrame.setIcon(1,SITUATION.abilityTexture1)
		SpellFrame.setIcon(2,SITUATION.abilityTexture2)
		SpellFrame.setIcon(3,SITUATION.abilityTexture3)
	end
end


function SpellFrame.onEvent(pSelf, pEventType, ...)


end