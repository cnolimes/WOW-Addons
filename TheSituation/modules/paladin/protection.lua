-- don't load if class is wrong
local _, class = UnitClass("player")
if class ~= "PALADIN" then return end

-- mod name in lower case
local modName = "Protection"
local version = 1

-- create a module in the main addon
local mod = SITUATION:RegisterClassModule(modName)

-- any error sets this to false
local enabled = true

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

local InquisitionRefresh 	= 3.0
local HolyShieldRefresh		= 3.0

-- ======================================================================== --
-- Detect Type of Target, and perform rotation appropriate to target type
-- ======================================================================== --
function mod.rotation(player, target, focus, pet)
	if(enabled) then
		mod.statusupdate(player, target, focus, pet)
		if(target.classification == "worldboss" or target.classification == "elite") then		-- PVE Boss Rotation			
			mod.bossrotation(player, target, focus, pet)
		elseif(target.classification == "normal") then
			mod.pvprotation(player, target, focus, pet)
		end
	end
end

function mod.rotation_old(StartTime, GCDTimeLeft)
	if(enabled) then
		HolyPower = UnitPower("player",SPELL_POWER_HOLY_POWER)
		Health = UnitHealth("player")
		HealthMax = UnitHealthMax("player")
		HealthPercent = (Health / HealthMax) * 100

		CrusaderStrikeCD, CrusaderStrikeFinish 	= PA:GetActualSpellCD(CrusaderStrikeFinish, "Crusader Strike")
		JudgementCD, JudgementFinish 			= PA:GetActualSpellCD(JudgementFinish, "Judgement")
		HammerOfWrathCD, HammerOfWrathFinish	= PA:GetActualSpellCD(HammerOfWrathFinish, "Hammer of Wrath")
		HolyWrathCD, HolyWrathFinish			= PA:GetActualSpellCD(HolyWrathFinish, "Holy Wrath")
		ConsecrationCD, ConsecrationFinish		= PA:GetActualSpellCD(ConsecrationFinish, "Consecration")
		AvengersShieldCD, AvengersShieldFinish	= PA:GetActualSpellCD(AvengersShieldFinish, "Avenger's Shield")
		
		InquisitionCD 							= PA:GetBuff("Inquisition")
		HolyShieldCD							= PA:GetBuff("Holy Shield")
		SacredDutyCD							= PA:GetBuff("Aacred Duty")
		
		-- Single Target Rotation
		
		if (HolyPower == 3) then
			if (PA.Toggle_Do_2) then			-- WOG Enabled			
				if(SacredDutyCD > 0 and HealthPercent >= 75) then
					Spell1 = SOTR
				elseif(HealthPercent < 90) then
					Spell1 = WordOfGlory
				else
					Spell1 = SOTR
				end
			else
				Spell1 = SOTR
			end
		elseif(CrusaderStrikeCD == 0) then
			Spell1 = CrusaderStrike
		elseif(JudgementCD == 0 ) then
			Spell1 = Judgement
		elseif(PA:ExecuteRange() and HammerOfWrathCD == 0) then
			Spell1 = HammerOfWrath
		elseif(AvengersShieldCD == 0 and PA.Toggle_Do_1) then
			Spell1 = AvengersShield
		elseif(ConsecrationCD == 0 and PA.Toggle_Do_3) then
			Spell1 = Consecration
		elseif(HolyWrathCD == 0) then
			Spell1 = HolyWrath
		else
			Spell1 = mod.Delay20
		end
		
		-- Multi-Target Rotation
		
		if (HolyPower == 3) then
			if (PA.Toggle_Do_2) then 
				if (InquisitionCD < InquisitionRefresh and HealthPercent > 75) then
					Spell2 = Inquisition
				else
					Spell2 = WordOfGlory
				end
			else
				if (InquisitionCD < InquisitionRefresh) then
					Spell2 = Inquisition
				else
					Spell2 = SOTR
				end
			end
		elseif(CrusaderStrikeCD == 0) then
			Spell2 = HOTR
		elseif(ConsecrationCD == 0 and PA.Toggle_Do_3) then
			Spell2 = Consecration
		elseif(HolyWrathCD == 0) then
			Spell2 = HolyWrath
		elseif(AvengersShieldCD == 0 and PA.Toggle_Do_1) then
			Spell2 = AvengersShield
		elseif(PA:ExecuteRange() and HammerOfWrathCD == 0) then
			Spell2 = HammerOfWrath
		elseif(JudgementCD == 0 ) then
			Spell2 = Judgement
		else
			Spell2 = mod.Delay20
		end
		PA:SpellFire(Spell1, Spell2, Spell3)
	end
	
end

function mod.OnInitialize()
	mod.checkSpec()
	if (enabled) then
		
--		CrusaderStrike			= PA:RegisterSpell(1, "Crusader Strike")
--		HOTR					= PA:RegisterSpell(2, "Hammer of the Righteous")
--		Judgement				= PA:RegisterSpell(3, "Judgement")
--		Inquisition				= PA:RegisterSpell(4, "Inquisition")
--		HammerOfWrath			= PA:RegisterSpell(5, "Hammer of Wrath")
--		HolyWrath				= PA:RegisterSpell(6, "Holy Wrath")
--		Consecration			= PA:RegisterSpell(7, "Consecration")
--		WordOfGlory				= PA:RegisterSpell(8, "Word of Glory")
--		AvengersShield			= PA:RegisterSpell(9, "Avenger's Shield")
--		SOTR					= PA:RegisterSpell(10, "Shield of the Righteous")
--		Rebuke					= PA:RegisterSpell(12, "Rebuke")

		-- ==================== REGISTER ROTATION ==============================
		PA:setRotation(mod.rotation, "Protection")
	end
end

function mod.checkSpec()
	PointsSpent = 0
	_, _, _, _, PointsSpent, _, _, _ = GetTalentTabInfo(2)	-- Check that enough points are spent in the right tree
	if(PointsSpent >= 30) then
		enabled = true
	else
		enabled =  false
	end
end