-- don't load if class is wrong
local _, class = UnitClass("player")
if class ~= "PALADIN" then return end

-- mod name in lower case
local modName = "Protection Paladin"
local version = 1

--================== Initialize Variables =====================
local Spell1 = nil
local Spell2 = nil
local Spell3 = nil

-- create a module in the main addon
local mod = WA:RegisterClassModule(modName)

-- any error sets this to false
local enabled = true


--================== Initialize Spec Variables =====================
local CrusaderStrikeFinish 	= GetTime()
local JudgementFinish 		= GetTime()
local HammerOfWrathFinish 	= GetTime()
local HolyWrathFinish	 	= GetTime()
local ConsecrationFinish 	= GetTime()
local RebukeFinish			= GetTime()
local AvengersShieldFinish 	= GetTime()
local RebukeFinish 			= GetTime()

local InquisitionRefresh 	= 3.0
local HolyShieldRefresh		= 3.0


function mod.rotation(StartTime, GCDTimeLeft)
	if(enabled) then
		HolyPower = UnitPower("player",SPELL_POWER_HOLY_POWER)
		Health = UnitHealth("player")
		HealthMax = UnitHealthMax("player")
		HealthPercent = (Health / HealthMax) * 100

		CrusaderStrikeCD, CrusaderStrikeFinish 	= WA:GetActualSpellCD(CrusaderStrikeFinish, "Crusader Strike")
		JudgementCD, JudgementFinish 			= WA:GetActualSpellCD(JudgementFinish, "Judgement")
		HammerOfWrathCD, HammerOfWrathFinish	= WA:GetActualSpellCD(HammerOfWrathFinish, "Hammer of Wrath")
		HolyWrathCD, HolyWrathFinish			= WA:GetActualSpellCD(HolyWrathFinish, "Holy Wrath")
		ConsecrationCD, ConsecrationFinish		= WA:GetActualSpellCD(ConsecrationFinish, "Consecration")
		AvengersShieldCD, AvengersShieldFinish	= WA:GetActualSpellCD(AvengersShieldFinish, "Avenger's Shield")
		
		InquisitionCD 							= WA:GetBuff("Inquisition")
		HolyShieldCD							= WA:GetBuff("Holy Shield")
		SacredDutyCD							= WA:GetBuff("Aacred Duty")
		
		-- Single Target Rotation
		
		if (HolyPower == 3) then
			if (WA.Toggle_Do_2) then			-- WOG Enabled			
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
		elseif(WA:ExecuteRange() and HammerOfWrathCD == 0) then
			Spell1 = HammerOfWrath
		elseif(AvengersShieldCD == 0 and WA.Toggle_Do_1) then
			Spell1 = AvengersShield
		elseif(ConsecrationCD == 0 and WA.Toggle_Do_3) then
			Spell1 = Consecration
		elseif(HolyWrathCD == 0) then
			Spell1 = HolyWrath
		else
			Spell1 = mod.Delay20
		end
		
		-- Multi-Target Rotation
		
		if (HolyPower == 3) then
			if (WA.Toggle_Do_2) then 
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
		elseif(ConsecrationCD == 0 and WA.Toggle_Do_3) then
			Spell2 = Consecration
		elseif(HolyWrathCD == 0) then
			Spell2 = HolyWrath
		elseif(AvengersShieldCD == 0 and WA.Toggle_Do_1) then
			Spell2 = AvengersShield
		elseif(WA:ExecuteRange() and HammerOfWrathCD == 0) then
			Spell2 = HammerOfWrath
		elseif(JudgementCD == 0 ) then
			Spell2 = Judgement
		else
			Spell2 = mod.Delay20
		end
		WA:SpellFire(Spell1, Spell2, Spell3)
	end
	
end

function mod.OnInitialize()
	mod.checkSpec()
	if (enabled) then
		WA:Print("Initializing Protection Paladin")
		WA:SetToggle(1, 0, "Avenger's Shield")		
		WA:SetToggle(2, 0, "Word of Glory")
		WA:SetToggle(3, 1, "Consecration")
		WA:SetToggle(4, 1, "Rebuke")
		
		WA:RegisterGCDSpell("Crusader Strike")
		WA:RegisterRangeSpell("Holy Light")
		
		CrusaderStrike			= WA:RegisterSpell(1, "Crusader Strike")
		HOTR					= WA:RegisterSpell(2, "Hammer of the Righteous")
		Judgement				= WA:RegisterSpell(3, "Judgement")
		Inquisition				= WA:RegisterSpell(4, "Inquisition")
		HammerOfWrath			= WA:RegisterSpell(5, "Hammer of Wrath")
		HolyWrath				= WA:RegisterSpell(6, "Holy Wrath")
		Consecration			= WA:RegisterSpell(7, "Consecration")
		WordOfGlory				= WA:RegisterSpell(8, "Word of Glory")
		AvengersShield			= WA:RegisterSpell(9, "Avenger's Shield")
		SOTR					= WA:RegisterSpell(10, "Shield of the Righteous")
		Rebuke					= WA:RegisterSpell(12, "Rebuke")

		-- ==================== REGISTER ROTATION ==============================
		WA:setRotation(mod.rotation, "Protection Paladin")
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