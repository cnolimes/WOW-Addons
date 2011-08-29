-- don't load if class is wrong
local _, class = UnitClass("player")
if class ~= "DEATHKNIGHT" then return end

-- mod name in lower case
local modName = "Unholy"
local version = 1

--================== Initialize Variables =====================
local Spell1 = nil
local Spell2 = nil
local Spell3 = nil

-- create a module in the main addon
local mod = PA:RegisterClassModule(modName)

-- any error sets this to false
local enabled = true

--================== Initialize Spec Variables =====================
local StartTime					= GetTime()
local ScourgeStrikeFinish 		= StartTime
local FesteringStrikeFinish 	= StartTime
local IcyTouchFinish 			= StartTime
local PlagueStrikeFinish		= StartTime
local DeathStrikeFinish 		= StartTime
local BloodBoilFinish 			= StartTime
local DarkTransformationFinish 	= StartTime
local BloodTapFinish 			= StartTime
local PestilenceFinish 			= StartTime
local HornOfWinterFinish 		= StartTime
local DarkTransformationFinish 	= StartTime
local DarkTransformationHoldoffTime	= 10


function mod.rotation(StartTime, GCDTimeLeft)
	if (enabled) then
		RunicPower = UnitPower("player")	
		Health = UnitHealth("player")
		HealthMax = UnitHealthMax("player")
		HealthPercent = (Health / HealthMax) * 100

		ScourgeStrikeCD, ScourgeStrikeFinish 		= PA:GetActualSpellCD(ScourgeStrikeFinish, "Scourge Strike")
		IcyTouchCD, IcyTouchFinish					= PA:GetActualSpellCD(IcyTouchFinish, "Icy Touch")
		PlagueStrikeCD, PlagueStrikeFinish			= PA:GetActualSpellCD(PlagueStrikeFinish, "Plague Strike")
		DeathStrikeCD, DeathStrikeFinish			= PA:GetActualSpellCD(DeathStrikeFinish, "Death Strike")
		BloodTapCD, BloodTapFinish					= PA:GetActualSpellCD(BloodTapFinish, "Blood Tap")
		BloodBoilCD, BloodBoilFinish				= PA:GetActualSpellCD(BloodBoilFinish, "Blood Boil")
		PestilenceCD, PestilenceFinish				= PA:GetActualSpellCD(PestilenceFinish, "Pestilence")
		FesteringStrikeCD, FesteringStrikeFinish 	= PA:GetActualSpellCD(FesteringStrikeFinish, "Festering Strike")
		HornOfWinterCD, HornOfWinterFinish 			= PA:GetActualSpellCD(HornOfWinterFinish, "Horn of Winter")
		DarkTransformationCD, DarkTransformationFinish = PA:GetActualSpellCD(DarkTransformationFinish, "Dark Transformation")
		
		-- ============================ Outbreak ============================
		-- Outputs:
		-- OutbreakCD
		--------------------------------------
		OutbreakStart, OutbreakDuration, _ = GetSpellCooldown("Outbreak")
		OutbreakCD = OutbreakStart + OutbreakDuration - GetTime()
		if (OutbreakCD < 0) then
			OutbreakCD = 0
		end
		
		
		ShadowInfusionCount 	= PA:GetPetBuffCount("Shadow Infusion")
		SuddenDoomCD			= PA:GetBuff("Sudden Doom")
		RunicCorruptionCD		= PA:GetBuff("Runic Corruption")
		PetDarkTransformationCD = PA:GetPetBuff("Dark Transformation")
		
		FrostFeverCD			= PA:GetTargetDebuff("Frost Fever")
		BloodPlagueCD			= PA:GetTargetDebuff("Blood Plague")

		-- Disable if Toggled
		if (PA.Toggle_Do_2 == false) then
			DarkTransformationCD = 30
		end
	
		-- Hold off on DC's until enough RP for Gargoyle
		if(PA.Toggle_Do_1 == false) then
			RunicPower = RunicPower - 60
		end

		-- Hold off on DC's until enough RP for Mind Freeze
		if(PA.Toggle_Do_4 == false) then
			RunicPower = RunicPower - 20
		end
		
		-- ============================ DeathCoil ============================
		-- Outputs:
		-- DeathCoilCD
		--------------------------------------
		_, _, _, DeathCoilCost, _, _, _, _, _ = GetSpellInfo("Death Coil")
		if (RunicPower < DeathCoilCost) then
			DeathCoilCD = 30
		else
			DeathCoilCD = 0
		end
		
		IcyTouchName, _, _, _, _, IcyTouchDuration, IcyTouchExpirationTime, IcyTouchUnitCaster, _ = UnitDebuff("target", "Frost Fever")
		if (IcyTouchName ~= nil and IcyTouchUnitCaster == "player") then
			IcyTouchCD = 30
		end
		
		PlagueStrikeName, _, _, _, _, PlagueStrikeDuration, PlagueStrikeExpirationTime, PlagueStrikeUnitCaster, _ = UnitDebuff("target", "Blood Plague")
		if (PlagueStrikeName ~= nil and PlagueStrikeUnitCaster == "player") then
			PlagueStrikeCD = 30
		end
		-- PA:SetText(IcyTouchCD)
		PA:SetText(PlagueStrikeCD)


		--====================================================================
		--============================== LOGIC TREE ===========================
		--====================================================================
		if (IcyTouchCD == 0 ) then
			if (OutbreakCD == 0) then
				Spell1 = Outbreak
			else
				Spell1 = IcyTouch
			end
		elseif (PlagueStrikeCD == 0 ) then
			if (OutbreakCD == 0) then
				Spell1 = Outbreak
			else
				Spell1 = PlagueStrike
			end
		elseif (FrostFeverCD < 3 or BloodPlagueCD < 3) then
			if (FesteringStrikeCD == 0) then
				Spell1 = FesteringStrike
			elseif (DeathCoilCD == 0 and PetDarkTransformationCD >= DarkTransformationHoldoffTime) then
				Spell1 = DeathCoil
			elseif (HornOfWinterCD == 0) then
				Spell1 = HornOfWinter
			elseif (OutbreakCD == 0) then
				Spell1 = Outbreak
			else
				Spell1 = Delay20
			end
		elseif (ShadowInfusionCount == 5) then
			if (DarkTransformationCD == 0) then
				Spell1 = DarkTransformation
			elseif (BloodTapCD == 0) then
				Spell1 = BloodTap
			elseif (FesteringStrikeCD == 0) then
				Spell1 = FesteringStrike
			elseif ((DeathCoilCD == 0 and PetDarkTransformationCD >= DarkTransformationHoldoffTime) or SuddenDoomCD == 0) then
				Spell1 = DeathCoil
			elseif (HornOfWinterCD == 0) then
				Spell1 = HornOfWinter
			elseif (OutbreakCD == 0) then
				Spell1 = Outbreak
			else
				Spell1 = Delay20
			end
		elseif (SuddenDoomCD == 0 or RunicPower >= 80) then
			Spell1 = DeathCoil
		elseif (ScourgeStrikeCD == 0) then
			Spell1 = ScourgeStrike
		elseif (DeathCoilCD == 0 and PetDarkTransformationCD >= DarkTransformationHoldoffTime) then
			Spell1 = DeathCoil
			PA:SetText("DC")
		elseif (FesteringStrikeCD == 0) then
			Spell1 = FesteringStrike
			PA:SetText("Fester")
		else
			if (BloodTapCD == 0) then
				Spell1 = BloodTap
				PA:SetText("Tap")
			elseif (HornOfWinterCD == 0) then
				PA:SetText("Horn")
				Spell1 = HornOfWinter
			else
				Spell1 = Delay20
			end
		end
		PA:SpellFire(Spell1, Spell2, Spell3)
	end
end



function mod.OnInitialize()
	mod.checkSpec()
	if (enabled) then
		PA:Print("Initializing Unholy")
		PA:SetToggle(1, 0, "Death Coil")		
		PA:SetToggle(2, 0, "Dark Transformation")
		PA:SetToggle(3, 1, "Necrotic Strike")
		PA:SetToggle(4, 1, "Mind Freeze")
		PA.GCD_Duration	= 1.0
		
		PA:RegisterRangeSpell("Icy Touch")
		
		-- ==================== REGISTER SPELL COLORS ==============================
		Outbreak				= PA:RegisterSpell(1, "Outbreak")
		IcyTouch				= PA:RegisterSpell(2, "Icy Touch")
		PlagueStrike			= PA:RegisterSpell(3, "Plague Strike")
		BloodTap				= PA:RegisterSpell(4, "Blood Tap")
		HornOfWinter			= PA:RegisterSpell(5, "Horn of Winter")
		DeathCoil				= PA:RegisterSpell(6, "Death Coil")
		DeathAndDecay			= PA:RegisterSpell(7, "Death and Decay")
		BloodBoil				= PA:RegisterSpell(8, "Blood Boil")
		ScourgeStrike			= PA:RegisterSpell(9, "Scourge Strike")
		FesteringStrike			= PA:RegisterSpell(10, "Festering Strike")
		DarkTransformation		= PA:RegisterSpell(11, "Dark Transformation")
		NecroticStrike			= PA:RegisterSpell(12, "Mind Freeze")

		-- ==================== REGISTER ROTATION ==============================
		PA:setRotation(mod.rotation, "Unholy")
	end
end

function mod.checkSpec()
	PointsSpent = 0
	_, _, _, _, PointsSpent, _, _, _ = GetTalentTabInfo(3)	-- Check that enough points are spent in the right tree
	if(PointsSpent >= 30) then
		enabled = true
	else
		enabled = false
	end
end