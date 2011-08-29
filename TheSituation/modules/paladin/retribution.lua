-- don't load if class is wrong
local _, class = UnitClass("player")
if class ~= "PALADIN" then return end

local SITUATION=SITUATION
local Libs = SITUATION.Libs;
local Spells = SITUATION.Spells;
local Tools = SITUATION.Tools;

-- mod name in lower case
local modName = "Retribution"
local version = 1

SITUATION.ret_name = modName

-- create a module in the main addon
local mod = SITUATION:RegisterClassModule(modName)
SITUATION.ret_result = mod

-- any error sets this to false
local enabled = true

--================== Initialize Spec Variables =====================
local InquisitionRefresh 	= 5
local InquisitionApplyMin 	= 3
local InquisitionRefreshMin	= 3
local undead				= "Undead"
local demon					= "Demon"
local ConsecrateManaMin		= 20000


--------------------------------------------------------------------------------
local HammerOfWrath 				= 24275	-- hammer of wrath
local CrusaderStrike 				= 35395	-- crusader strike
local TemplarsVerdict				= 85256	-- templar's verdict
local Inquisition					= 84963	-- inquisition
local DivineStorm					= 53385	-- divine storm
local Judgement						= 20271	-- judgement
local Consecration					= 26573	-- consecration
local Exorcism						= 879	-- exorcism
local HolyWrath						= 2812 	-- holy wrath
local Zealotry						= 85696 -- zealotry
local Inquisition					= 84963 -- inquisition
local DivinePurpose					= 90174
local ArtOfWar						= 59578
local JudgementsOfThePure			= 53655
local Rebuke						= 96231


-- ======================================================================== --
-- Detect Type of Target, and perform rotation appropriate to target type
-- ======================================================================== --
function mod.rotation(player, target, focus, pet)
	if(enabled) then
		if(target.classification == "worldboss" or target.classification == "elite") then		-- PVE Boss Rotation			
			mod.bossrotation(player, target, focus, pet)
		elseif(target.classification == "normal") then
			mod.pvprotation(player, target, focus, pet)
		end
	end
end

function mod.pvprotation(player, target, focus, pet)
	if(player:BuffTimeLeft(Inquisition) <= 0 and (player.holyPower > InquisitionApplyMin or player:BuffTimeLeft(DivinePurpose) > 0)) then -- Apply Inquisition at 3HP
		SITUATION:SpellCast(1, Inquisition)
		SITUATION:SpellCast(2, Inquisition)
	elseif(player:BuffTimeLeft(Inquisition) < InquisitionRefresh and player.holyPower >= InquisitionRefreshMin) then		-- Refresh Inquisition at 3HP
		SITUATION:SpellCast(1, Inquisition)
		SITUATION:SpellCast(2, Inquisition)
	elseif(player.holyPower >= 3) then			-- TV at 3HP
		SITUATION:SpellCast(1, TemplarsVerdict)
		SITUATION:SpellCast(2, TemplarsVerdict)
	elseif(player.holyPower < 3 and player:CanCast(CrusaderStrike)) then
		SITUATION:SpellCast(1, CrusaderStrike)
		SITUATION:SpellCast(2, DivineStorm)
	elseif(player:BuffTimeLeft(Inquisition) <= 0 and player:BuffTimeLeft(DivinePurpose) > 0) then
		SITUATION:SpellCast(1, Inquisition)
		SITUATION:SpellCast(2, Inquisition)
	elseif(player:BuffTimeLeft(DivinePurpose) > 0)then
		SITUATION:SpellCast(1, TemplarsVerdict)
		SITUATION:SpellCast(2, TemplarsVerdict)
	elseif((target.creatureType == "undead" or target.creatureType == "demon") and player:BuffTimeLeft(ArtOfWar) > 0) then
		SITUATION:SpellCast(1, Exorcism)
		SITUATION:SpellCast(2, Exorcism)
	elseif(target.healthPercent() <= 20.0 and player:CanCast(HammerOfWrath))then
		SITUATION:SpellCast(1, HammerOfWrath)
		SITUATION:SpellCast(2, HammerOfWrath)
	elseif(player:BuffTimeLeft(ArtOfWar) > 0) then
		SITUATION:SpellCast(1, Exorcism)
		SITUATION:SpellCast(2, Exorcism)
	elseif(player:CanCast(Judgement))then
		SITUATION:SpellCast(1, Judgement)
		SITUATION:SpellCast(2, Judgement)
	elseif(player:CanCast(HolyWrath))then
		SITUATION:SpellCast(1, HolyWrath)
		SITUATION:SpellCast(2, HolyWrath)
	else
		SITUATION:SpellDelay(20)
	end
end

function mod.bossrotation(player, target, focus, pet)
	if(player:BuffTimeLeft(Inquisition) <= 0 and (player.holyPower > InquisitionApplyMin or player:BuffTimeLeft(DivinePurpose) > 0)) then -- Apply Inquisition at 3HP
		SITUATION:SpellCast(1, Inquisition)
		SITUATION:SpellCast(2, Inquisition)
	elseif(player:BuffTimeLeft(Inquisition) < InquisitionRefresh and player.holyPower >= InquisitionRefreshMin) then		-- Refresh Inquisition at 3HP
		SITUATION:SpellCast(1, Inquisition)
		SITUATION:SpellCast(2, Inquisition)
	elseif(player.holyPower >= 3) then			-- TV at 3HP
		SITUATION:SpellCast(1, TemplarsVerdict)
		SITUATION:SpellCast(2, TemplarsVerdict)
	elseif(player.holyPower < 3 and player:CanCast(CrusaderStrike)) then
		SITUATION:SpellCast(1, CrusaderStrike)
		SITUATION:SpellCast(2, DivineStorm)
	elseif(player:BuffTimeLeft(Inquisition) <= 0 and player:BuffTimeLeft(DivinePurpose) > 0) then
		SITUATION:SpellCast(1, Inquisition)
		SITUATION:SpellCast(2, Inquisition)
	elseif(player:BuffTimeLeft(DivinePurpose) > 0)then
		SITUATION:SpellCast(1, TemplarsVerdict)
		SITUATION:SpellCast(2, TemplarsVerdict)
	elseif((target.creatureType == "undead" or target.creatureType == "demon") and player:BuffTimeLeft(ArtOfWar) > 0) then
		SITUATION:SpellCast(1, Exorcism)
		SITUATION:SpellCast(2, Exorcism)
	elseif(target.healthPercent() <= 20 and player:CanCast(HammerOfWrath))then
		SITUATION:SpellCast(1, HammerOfWrath)
		SITUATION:SpellCast(2, HammerOfWrath)
	elseif(player:BuffTimeLeft(ArtOfWar) > 0) then
		SITUATION:SpellCast(1, Exorcism)
		SITUATION:SpellCast(2, Exorcism)
	elseif(player:CanCast(Judgement))then
		SITUATION:SpellCast(1, Judgement)
		SITUATION:SpellCast(2, Judgement)
	elseif(player:CanCast(HolyWrath))then
		SITUATION:SpellCast(1, HolyWrath)
		SITUATION:SpellCast(2, HolyWrath)
	elseif(player.mana > ConsecrateManaMin and player:CanCast(Consecration)) then
		SITUATION:SpellCast(1, Consecration)
		SITUATION:SpellCast(2, Consecration)
	else
		SITUATION:SpellDelay(20)
	end
end


-- ======================================================================== --
-- Status Update Code
-- ======================================================================== --
function mod.statusupdate(player, target, focus, pet)
	SITUATION:Status1(SITUATION.serial .. ":" .. target.classification)
	SITUATION:Status2("HP:" .. player.holyPower .. " Mana: " .. player.mana)
	SITUATION:Status3("INQtl: " .. string.format("%.2f", player:BuffTimeLeft(Inquisition)) .. " AOWtl: " .. string.format("%.2f", player:BuffTimeLeft(ArtOfWar)))
	SITUATION:Status4("CScd: " .. string.format("%.2f",player.GetSpellCooldown(CrusaderStrike)) .. " DPtl: " .. string.format("%.2f", player:BuffTimeLeft(DivinePurpose)))
	if(player:CanCast(CrusaderStrike)) then
		SITUATION:Status5("CScc: true")
	else
		SITUATION:Status5("CScc: false")
	end
end

function mod.OnInitialize()
	mod.checkSpec()
	if (enabled) then
	
		SITUATION:AddSpell(1, CrusaderStrike)
		SITUATION:AddSpell(2, DivineStorm)
		SITUATION:AddSpell(3, Judgement)
		SITUATION:AddSpell(4, Inquisition)
		SITUATION:AddSpell(5, HammerOfWrath)
		SITUATION:AddSpell(6, HolyWrath)
		SITUATION:AddSpell(7, Consecration)
		SITUATION:AddSpell(8, TemplarsVerdict)
		SITUATION:AddSpell(9, Exorcism)
		SITUATION:AddSpell(10, Rebuke)
		
		SITUATION:AddBuff(ArtOfWar)
		SITUATION:AddBuff(DivinePurpose)
		SITUATION:AddBuff(Zealotry)
		SITUATION:AddBuff(Inquisition)
	
		-- ==================== REGISTER ROTATION ==============================
		SITUATION:setRotation(mod.rotation, "Retribution")
		-- SITUATION:StatusDisplayOn()
	end
end

function mod.checkSpec()
	PointsSpent = 0
	_, _, _, _, PointsSpent, _, _, _ = GetTalentTabInfo(3)	-- Check that enough points are spent in the right tree
	if(PointsSpent >= 30) then
		enabled = true
	else
		enabled =  false
	end
end