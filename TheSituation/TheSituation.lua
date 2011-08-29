----------
-- Name: TheSituation
-- Version: 2.0.x
-- License: All Rights Reserved
----------

SITUATION = {
	version = '2.0.0-alpha15',
	addonName = 'TheSituation',
	enabled = true, 
	trace = true,
	firstInit = false,
	serial = 0,
	ShowDataTimeFactor = 0.150,			-- Time prior to a GCD finish when the color box will be shown
	GCD_Duration = 1.5,
	GCDSpell = "Survey",	
	classModules = {},
	cmdList = {},
	spellColor1	= 0,
	spellColor2	= 0,
	spellColor3	= 0,
	abilityTexture1	= nil,
	abilityTexture2	= nil,
	abilityTexture3	= nil,
	spellColors = {	0.10, 0.20,  0.30, 0.40, 0.50, 0.60, 0.70, 0.80, 0.90, 1.00, 
					0.06, 0.15, 0.25, 0.35, 0.45, 0.55, 0.65, 0.75, 0.85, 0.95, 
					0.07, 0.17, 0.27, 0.37, 0.47, 0.57, 0.67, 0.77, 0.87, 0.97},
	delay20 = 0.0,
	delay100 = 0.01,
	delay300 = 0.02,
	delay900 = 0.05,
	bypassColor	= 0.05,
	time = {
		now = 0,
		gcd = 0,
		frames = {
			last = 0,
			cooldown = 100,
		},
		deleteInvalidUnits = {
			last = 0,
			cooldown = 10000,
		},
		woogsCheck = {
			last = 0,
			cooldown = 5000,
			counter = 0,
			found = 0,
			state = false,
		},
	},
	player = {
		serial = 0,
		combo = 0,
		rage = 0,
		mana = 0,
		focus = 0,
		runicPower = 0,
		shard = 0,
		eclipse = 0,
		holyPower = 0,
		healthMax = 0,
		health = 0,
		healthPercent = 0,
		stance = 0,
		stealthed = false,
		petPresent = false,
		speed = 0,
		rune = {},
		spells = {},
		buffs = {},
		debuffs = {},
		buffcount = 0,
		bufflist = {},
		debuffcount = 0,
		debufflist = {},
		spellcount = 0,
		spellList = {},
		spells = {}
	},
	pet = {
		serial = 0,
		focus = 0,
		healthMax = 0,
		health = 0,
		healthPercent = 0,
		buffs = {},
		debuffs = {},
		buffcount = 0,
		bufflist = {},
		debuffcount = 0,
		debufflist = {}

	},
	target = {
		mana = 0,
		buffs = {},
		debuffs = {},
		buffcount = 0,
		bufflist = {},
		debuffcount = 0,
		debufflist = {}
	},
	focus = {	
		mana = 0,
		buffs = {},
		debuffs = {},
		buffcount = 0,
		bufflist = {},
		debuffcount = 0,
		debufflist = {}
	},
	Libs = {},
	Spells = {},
	Tools = {},
	MinimapFrame = {},
	SpellFrame = {},
	PlayerFrame = {},
	UnitFrame = {},
	DebugFrame = {},
	NotificationFrame = {}
}
	

local SITUATION = SITUATION;
local Libs = SITUATION.Libs;
local Spells = SITUATION.Spells;
local Tools = SITUATION.Tools;
local MinimapFrame = SITUATION.MinimapFrame;
local SpellFrame = SITUATION.SpellFrame;
local DebugFrame = SITUATION.DebugFrame;
local Notify = SITUATION.NotificationFrame;
local Player = SITUATION.player;
local Target = SITUATION.target;
local Focus = SITUATION.focus;
local Pet = SITUATION.pet;




--================= Extra Function Mappings ===================


SITUATION.eventHandler = CreateFrame('Frame', 'SITUATION_EVENTHANDLER');
SITUATION.eventHandler:RegisterEvent('ADDON_LOADED');
SITUATION.eventHandler:RegisterEvent('PLAYER_ENTERING_WORLD');
SITUATION.eventHandler:RegisterEvent('PLAYER_LOGIN');
SITUATION.eventHandler:RegisterEvent('COMBAT_LOG_EVENT_UNFILTERED');
SITUATION.eventHandler:RegisterEvent('ZONE_CHANGED_NEW_AREA');
SITUATION.eventHandler:RegisterEvent('PLAYER_TARGET_CHANGED');
SITUATION.eventHandler:RegisterEvent('PLAYER_FOCUS_CHANGED');
SITUATION.eventHandler:RegisterEvent('CHAT_MSG_SYSTEM');
SITUATION.eventHandler:RegisterEvent('DUEL_FINISHED');
SITUATION.eventHandler:RegisterEvent("ACTIVE_TALENT_GROUP_CHANGED")
SITUATION.eventHandler:RegisterEvent("PLAYER_ENTERING_WORLD")
SITUATION.eventHandler:RegisterEvent("PLAYER_TALENT_UPDATE")
SITUATION.eventHandler:RegisterEvent("PLAYER_REGEN_ENABLED")
SITUATION.eventHandler:RegisterEvent("PLAYER_REGEN_DISABLED")
SITUATION.eventHandler:SetScript('OnUpdate', function(self, elapsed) SITUATION.onUpdate(self, elapsed); end);
SITUATION.eventHandler:SetScript('OnEvent', function(self, eventType, ...) SITUATION.onEvent(self, eventType, ...); end);


function SITUATION.onUpdate(pSelf, pElapsed)
	if (SITUATION.InCombat()) then		
		-- Do Stuff --
		if(SITUATION.rotation ~= nil) then
			SITUATION.serial = SITUATION.serial + 1;
			SITUATION.time.update(pElapsed);
			
			Player.update();
			Target.update();
			Focus.update();
			Pet.update();
			
			if(SITUATION.serial % 2 == 0) then
				-- Check for Interrupt Opportunity
				if(SITUATION.interruptRotation ~= nil) then
					SITUATION.interruptRotation(SITUATION.player, SITUATION.target, SITUATION.focus, SITUATION.pet);
				end
				-- Should We Delay
				if (SITUATION.time.gcd > SITUATION.ShowDataTimeFactor) then						-- NOT inside spam window
							-- Do OFF GCD Rotation
					if(SITUATION.offgcdrotation ~= nil) then
						SITUATION.offgcdrotation(SITUATION.player, SITUATION.target, SITUATION.focus, SITUATION.pet);
					else
						if ((SITUATION.time.gcd - SITUATION.ShowDataTimeFactor) > .100) then			-- Check Longer Delayse
							SITUATION.SpellDelay(100)
						else
							SITUATION.SpellDelay(20)
						end
					end
				else
					SITUATION.rotation(SITUATION.player, SITUATION.target, SITUATION.focus, SITUATION.pet)
				end
			end
		else
			SITUATION.debug("No Rotation", SITUATION.time.now)
		end
	end	
end


function SITUATION.onEvent(pSelf, pEventType, ...)
	if ( pEventType == 'ADDON_LOADED' and select(1, ...) == 'TheSituation' ) then
		SITUATION.print("SNAFU")
		SITUATION.buildDefaultOptions();
		SITUATION.checkSavedVariables();
		SITUATION.player.locale = GetLocale();
		MinimapFrame.build();
		Notify.build();
		DebugFrame.build();
		SpellFrame.build();
		SLASH_SITUATION1 = '/SITUATION';
		SITUATION.LibSharedMedia = LibStub("LibSharedMedia-3.0");
		SITUATION.CombatDisabled()
	elseif ( pEventType == 'PLAYER_LOGIN' ) then
		SITUATION.player.guid = UnitGUID('player');
		SITUATION.player.name = UnitName('player');
		SITUATION.player.faction = UnitFactionGroup('player');
		SITUATION.player.realm = GetRealmName();
		SITUATION.player.class = UnitClass("player");
		SITUATION.reload()
	elseif ( pEventType == 'COMBAT_LOG_EVENT_UNFILTERED' and SITUATION.parse ) then
		-- Units.processEvent(select(1, ...)*1000, select(2, ...), select(4, ...), select(5, ...), select(8, ...), select(9, ...), select(12, ...));
	elseif ( pEventType == 'PLAYER_TARGET_CHANGED' ) then
		SITUATION.target.refresh=true;
	elseif ( pEventType == 'PLAYER_FOCUS_CHANGED' ) then
		SITUATION.focus.refresh=true;
	elseif ( pEventType == "PLAYER_TALENT_UPDATE" or pEventType == "PLAYER_ENTERING_WORLD" or pEventType == "ACTIVE_TALENT_GROUP_CHANGED" ) then
		SITUATION.reload()
	elseif ( pEventType == 	"PLAYER_REGEN_ENABLED" ) then
		SITUATION.CombatDisabled()
	elseif ( pEventType == "PLAYER_REGEN_DISABLED" ) then
		SITUATION.CombatEnabled()
	end
end


function SITUATION.checkSavedVariables()
	if ( SITUATION_OPTIONS == nil ) then
		SITUATION_OPTIONS = {};
		Tools.compareTables('copy', SITUATION.defaultOptions, SITUATION_OPTIONS);
		return;
	end
	for k, v in pairs ( SITUATION.defaultOptions ) do
		if ( type(v) == 'table' ) then
			if ( k ~= 'ignoreSpells' ) then
				if ( SITUATION_OPTIONS[k] == nil or type(SITUATION_OPTIONS[k]) ~= 'table' ) then SITUATION_OPTIONS[k] = {}; end
				Tools.compareTables('remove', SITUATION.defaultOptions[k], SITUATION_OPTIONS[k]);
				Tools.compareTables('add', SITUATION.defaultOptions[k], SITUATION_OPTIONS[k]);
			end
		else
			SITUATION_OPTIONS[k] = nil;
		end
	end
	Tools.compareTables('copy', SITUATION.defaultOptions.of, SITUATION_OPTIONS.of);
end


function SITUATION.buildDefaultOptions()
	SITUATION.defaultOptions = {
		parse = {
			self = true,
			insideRaid = true,
			outsideRaid = true,
			pet = true,
		},
-- [MINIMAP FRAME] --
		mf = {
			angle = 90
		},
		ignoreSpells = {
			-- built below
		}
	}	
	local defaultOptions = SITUATION.defaultOptions;
	-- Set up table structure from zone groups
end

function SITUATION.print(pString, pColor)
	if ( pColor ~= nil ) then
		DEFAULT_CHAT_FRAME:AddMessage('\124cff'..pColor..'[SITUATION] -- '..tostring(pString)..'\124r');
	else
		DEFAULT_CHAT_FRAME:AddMessage('[SITUATION] -- '..tostring(pString));
	end
end

function SITUATION.debug(pString1, pString2)
	if(SITUATION.trace) then
		DebugFrame.AddBoth(SITUATION.nilstring(pString1), SITUATION.nilstring(pString2))
	end
end

function SITUATION.nilstring(msg)
	if(msg == nil) then
		return "nil"
	end
	return msg
end

-- ======================================================================== --
-- Returns the classification of the target:
--		worldboss / elite / normal
-- ======================================================================== --
function SITUATION:GetClassification(target)
	local classification
	if UnitLevel(target) == -1 then
		classification = "worldboss"
	else
		classification = UnitClassification(target)
		if (classification == "rareelite") then
			classification = "elite"
		elseif (classification == "rare") then
			classification = "normal"
		end
	end
	return classification
end

function SITUATION:GetCasting(target)
	local name, _, _, _, startTime, endTime, _, catID, interrupt = UnitCastingInfo(target)
	local casting = false
	if (name ~= nil) then
		casting = true
		finish = (endTime / 1000) + 0.3
	end
	return casting, finish
end

-- ======================================================================== --
-- Use LibRangeCheck to get the range to the target (min / max)
-- ======================================================================== --
function SITUATION:GetDistance(target)
	if LRC then
		local minRange, maxRange = LRC:GetRange(target)
		if maxRange == nil or minRange == nil then
			return nil
		end
		return minRange, maxRange
	end
end

-- ======================================================================== --
-- Sets the Spell to be cast on the target
-- ======================================================================== --
function SITUATION:SpellCast(thread, SpellId)
	-- Debugging
	if(thread == 1) then
		SITUATION.debug(SITUATION.player.spells[SpellId].name, "Color:" .. SITUATION.player.spells[SpellId].color)
		SITUATION.abilityTexture1 = SITUATION.player.spells[SpellId].icon
		SITUATION.spellColor1 = SITUATION.player.spells[SpellId].color
	elseif(thread ==2) then
		SITUATION.abilityTexture2 = SITUATION.player.spells[SpellId].icon
		SITUATION.spellColor2 = SITUATION.player.spells[SpellId].color
	elseif(thread == 3) then
		SITUATION.abilityTexture3 = SITUATION.player.spells[SpellId].icon
		SITUATION.spellColor3 = SITUATION.player.spells[SpellId].color
	end
end

-- ======================================================================== --
-- Sets the Spell to be cast on the focus target
-- ======================================================================== --
function SITUATION:FocusCast(thread, SpellId)
	if(thread > 0 and thread < 4) then
		if(thread == 1) then
			SITUATION.abilityTexture1 = SITUATION.player.spells[SpellId].icon
			SITUATION.spellColor1 = SITUATION.player.spells[SpellId].focusColor
		elseif(thread == 2) then
			SITUATION.abilityTexture2 = SITUATION.player.spells[SpellId].icon
			SITUATION.spellColor2 = SITUATION.player.spells[SpellId].focusColor
		elseif(thread == 3) then
			SITUATION.abilityTexture3 = SITUATION.player.spells[SpellId].icon
			SITUATION.spellColor3 = SITUATION.player.spells[SpellId].focusColor
		end
	end
end

-- ======================================================================== --
-- Setup the Spell Delay Color
-- ======================================================================== --
function SITUATION:SpellDelay(duration)
	if(duration == 100) then
		SITUATION.spellColor1 = SITUATION.Delay100
		SITUATION.spellColor2 = SITUATION.Delay100
		SITUATION.spellColor3 = SITUATION.Delay100
	else
		SITUATION.spellColor1 = SITUATION.Delay20
		SITUATION.spellColor2 = SITUATION.Delay20
		SITUATION.spellColor3 = SITUATION.Delay20
	end
	SITUATION.abilityTexture1 = nil
	SITUATION.abilityTexture2 = nil
	SITUATION.abilityTexture3 = nil
end

-- ============================ Actual Spell Cooldown on non GCD duration ============================
-- Outputs: 
-- SpellCD: Returns the cooldown of the Given spell 
-- SpellFinish: Returns when the spell will finish
-- =======================================================================
function SITUATION.GetActualSpellCD(SpellFinishCurrent, SpellName)
	NewSpellCD = 0
	SpellFinish = SpellFinishCurrent
	
	SpellCDStart, SpellCDDuration, _ = GetSpellCooldown(SpellName)
	if (SpellCDStart ~= 0) then
		if (SpellCDDuration > SITUATION.time.gcd) then			-- Calc CD based on a non GCD duration 
			SpellFinish = SpellCDStart + SpellCDDuration
			NewSpellCD = SpellFinish - SITUATION.time.now
		else
			if (SpellFinish - SITUATION.time.now > 0) then		--check if finish is even relevant, if not cd = 0
				if (SpellFinish - (SpellCDStart + SpellCDDuration) - SITUATION.ShowDataTimeFactor > 0) then
					NewSpellCD = 0
				else
					NewSpellCD = SpellFinish - SITUATION.time.now
				end
			else
				NewSpellCD = 0
			end
		end
	else
		NewSpellCD = 0
	end
	return NewSpellCD, SpellFinish
end

-- ======================================================================== --
-- Returns the color value to display for a specific key location identifier
-- ======================================================================== --
function SITUATION:GetColor(location)
	return SITUATION.spellColors[location]
end

-- ======================================================================== --
-- Returns the color value to display for a specific key location identifier 
-- + 10 to get the focus value 1-10 = target 11-20 = focus 21-x other stuff
-- ======================================================================== --
function SITUATION:GetFocusColor(location)
	local focus_location = location + 10
	return SITUATION.spellColors[focus_location]
end

-- ======================================================================== --
-- Add a spell to the spellList table to be updated by the 
-- SITUATION.UpdateSpellCooldowns() ability
-- ======================================================================== --
function SITUATION:AddSpell(location, SpellId)
	if not SITUATION.player.spells[SpellId] then
		SITUATION.player.spells[SpellId] = {}
	end
	
	name, rank, icon, cost, isFunnel, powerType, castTime, minRange, maxRange = GetSpellInfo(SpellId)	
	SITUATION.player.spellcount = SITUATION.player.spellcount + 1
	SITUATION.player.spellList[SITUATION.player.spellcount] = SpellId
		
	SITUATION.player.spells[SpellId].id = SpellId
	SITUATION.player.spells[SpellId].name = name
	SITUATION.player.spells[SpellId].icon = icon
	SITUATION.player.spells[SpellId].cost = cost
	SITUATION.player.spells[SpellId].isFunnel = isFunnel
	SITUATION.player.spells[SpellId].castTime = castTime
	SITUATION.player.spells[SpellId].minRange = minRange
	SITUATION.player.spells[SpellId].maxRange = maxRange
	SITUATION.player.spells[SpellId].duration = 0
	SITUATION.player.spells[SpellId].color = SITUATION:GetColor(location)
	SITUATION.player.spells[SpellId].focusColor = SITUATION:GetFocusColor(location)
	SITUATION.player.spells[SpellId].finish = SITUATION.time.now
	SITUATION.player.spells[SpellId].cd = 0
end




-- ======================================================================== --
-- 
-- ======================================================================== --
function SITUATION:AddBuff(SpellId)
	if not SITUATION.player.bufflist then
		SITUATION.player.bufflist = {}
		SITUATION.player.buffcount = 0
	end
	if not SITUATION.player.buffs then
		SITUATION.player.buffs = {}
	end
	if not SITUATION.player.buffs[SpellId] then
		SITUATION.player.buffcount = SITUATION.player.buffcount + 1
		SITUATION.player.buffs[SpellId] = {}
		SITUATION.player.bufflist[SITUATION.player.buffcount] = SpellId
		local name, rank, icon, cost, isFunnel, powerType, castTime, minRange, maxRange = GetSpellInfo(SpellId)
		SITUATION.player.buffs[SpellId].count = 0
		SITUATION.player.buffs[SpellId].duration = 0
		SITUATION.player.buffs[SpellId].timeLeft = 0
		SITUATION.player.buffs[SpellId].expirationTime = 0
		SITUATION.player.buffs[SpellId].name = name
		SITUATION.player.buffs[SpellId].icon = icon
		SITUATION.player.buffs[SpellId].serial = SITUATION.serial
	end
end


-- ======================================================================== --
-- 
-- ======================================================================== --
function SITUATION:AddEnemyDebuff(SpellId)
	SITUATION.debug("Adding Debuff", SpellId)
	if not SITUATION.target.debuffs[SpellId] then
		local name, rank, icon, _, _, _, _, _, _ = GetSpellInfo(SpellId)
		SITUATION.debug(name, "debuff")
		SITUATION.target.debuffs[SpellId] = {}
		SITUATION.target.debuffs[SpellId].duration = 0
		SITUATION.target.debuffs[SpellId].timeLeft = 0
		SITUATION.target.debuffs[SpellId].count = 0
		SITUATION.target.debuffs[SpellId].isStealable = false
		SITUATION.target.debuffs[SpellId].icon = icon
		SITUATION.target.debuffs[SpellId].name = name
		SITUATION.target.debuffs[SpellId].spellId = SpellId
		SITUATION.target.debuffcount = SITUATION.target.debuffcount + 1
		SITUATION.target.debufflist[SITUATION.target.debuffcount] = SpellId
		
		SITUATION.focus.debuffs[SpellId] = {}
		SITUATION.focus.debuffs[SpellId].duration = 0
		SITUATION.focus.debuffs[SpellId].timeLeft = 0
		SITUATION.focus.debuffs[SpellId].count = 0
		SITUATION.focus.debuffs[SpellId].isStealable = false
		SITUATION.focus.debuffs[SpellId].icon = icon
		SITUATION.focus.debuffs[SpellId].name = name
		SITUATION.focus.debuffs[SpellId].spellId = SpellId
		SITUATION.focus.debuffcount = SITUATION.focus.debuffcount + 1
		SITUATION.focus.debufflist[SITUATION.focus.debuffcount] = SpellId		
	end
end


--  ===================================================================================================================
--  ===================================================================================================================
--  
--  Utility Functions
--  
--  ===================================================================================================================
--  ===================================================================================================================

	
-- ======================================================================== --
-- Sets Up the time variables
-- ======================================================================== --
function SITUATION.time.update(pElapsed)
	SITUATION.time.now = GetTime();
	pElapsed = Tools.roundNumber(pElapsed * 1000);
	SITUATION.time.frames.last = SITUATION.time.frames.last + pElapsed;
	local start, duration = GetSpellCooldown(SITUATION.GCDSpell);
	SITUATION.time.gcd = start + duration - SITUATION.time.now;
	if SITUATION.time.gcd < 0 then SITUATION.time.gcd = 0 end;	 
end

function SITUATION.print(msg)
	DEFAULT_CHAT_FRAME:AddMessage("|cff33ff99SA|r: " .. msg)
end

-- ======================================================================== --
-- TODO: Probably not used.
-- OLD
-- Consider removing
-- ======================================================================== --
function SITUATION.GetIcon(spellName)
	name, _, texture = GetSpellInfo(spellName)
	return texture
end


--  ===================================================================================================================
--  ===================================================================================================================
--  
--  Registry Functions
--  
--  ===================================================================================================================
--  ===================================================================================================================

-- ======================================================================== --
-- Registers the class module
-- ======================================================================== --
function SITUATION:RegisterClassModule(name)
	SITUATION.mod_name_passed = name
	name = string.lower(name)
	SITUATION.classModules[name] = {}
	return SITUATION.classModules[name]
end

-- ======================================================================== --
-- Returns whether you are InCombat
-- ======================================================================== --
function SITUATION.InCombat()
	return SITUATION.incombat
end

-- ======================================================================== --
-- Enable Combat: Called from the event handler for the combat_regen_disabled
-- event.
-- ======================================================================== --
function SITUATION.CombatEnabled()
	SITUATION.player.inCombat = true
	SITUATION.incombat = true
	SITUATION.player.combatStartTime = SITUATION.time.now
end

-- ======================================================================== --
-- Disable Combat: Called from the event handler for the combat_regen_enabled
-- event.
-- ======================================================================== --
function SITUATION.CombatDisabled()
	SITUATION.player.inCombat = false
	SITUATION.serial = 0
	SITUATION.incombat = false
	SITUATION.player.combatEndTime = SITUATION.time.now
	SITUATION.spellColor1 = SITUATION.bypassColor
	SITUATION.spellColor2 = SITUATION.bypassColor
	SITUATION.spellColor3 = SITUATION.bypassColor
	SITUATION.abilityTexture1 = [[interface\icons\PVPCurrency-Honor-Horde]]
	SITUATION.abilityTexture2 = [[interface\icons\PVPCurrency-Honor-Horde]]
	SITUATION.abilityTexture3 = [[interface\icons\PVPCurrency-Honor-Horde]]
	DebugFrame.Clear()
end


--  ===================================================================================================================
--  ===================================================================================================================
--  Init Code
--  ===================================================================================================================
--  ===================================================================================================================
function SITUATION.reload()
	SITUATION.debug("Reload Initiated", GetTime())
	SITUATION.InitializeRotation()
end


-- ======================================================================== --
-- Initialize Class Modules
-- ======================================================================== --
function SITUATION.InitializeRotation()
	for k in pairs(SITUATION.classModules) do
		if SITUATION.classModules[k].OnInitialize then
			if(first_load) then
				SITUATION.debug("Initializing " .. k )
			end
			SITUATION.classModules[k].OnInitialize()
		end
	end
end

-- ======================================================================== --
-- Set the combat rotation to the PA object for call during 
-- the onUpdate code
-- ======================================================================== --
function SITUATION:setRotation(rotation, rotationText)
	SITUATION.debug("Rotation Set To:", rotationText)
	SITUATION.rotation=rotation
	SpellFrame.setTitle("SA: " .. rotationText .. " " .. SITUATION.player.class)
end

-- ======================================================================== --
-- Set the off global cooldown rotation to the PA object for call
-- during the onUpdate code
-- ======================================================================== --
function SITUATION:setOffGCDRotation(rotation)
	SITUATION.debug("Enabling", "OFF GCD Rotation")
	SITUATION.offgcdrotation = rotation
end