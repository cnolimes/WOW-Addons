-- don't load if class is wrong
local _, class = UnitClass("player")
if class ~= "DEATHKNIGHT" then return end

-- mod name in lower case
local modName = "Blood"
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
local HeartStrikeFinish = GetTime()
local IcyTouchFinish = GetTime()
local DeathStrikeFinish = GetTime()
local BloodBoilFinish = GetTime()
local BloodTapFinish = GetTime()
local PestilenceFinish = GetTime()
local HornOfWinterFinish = GetTime()


function mod.rotation(StartTime, GCDTimeLeft)
	if (enabled) then
		RunicPower = UnitPower("player")	
		Health = UnitHealth("player")
		HealthMax = UnitHealthMax("player")
		HealthPercent = (Health / HealthMax) * 100
		
		
		
		IcyTouchCD, IcyTouchFinish					= PA:GetActualSpellCD(IcyTouchFinish, "Icy Touch")
		PlagueStrikeCD, PlagueStrikeFinish			= PA:GetActualSpellCD(PlagueStrikeFinish, "Plague Strike")
		DeathStrikeCD, DeathStrikeFinish			= PA:GetActualSpellCD(DeathStrikeFinish, "Death Strike")
		BloodTapCD, BloodTapFinish					= PA:GetActualSpellCD(BloodTapFinish, "Blood Tap")
		BloodBoilCD, BloodBoilFinish				= PA:GetActualSpellCD(BloodBoilFinish, "Blood Boil")
		PestilenceCD, PestilenceFinish				= PA:GetActualSpellCD(PestilenceFinish, "Pestilence")
		FesteringStrikeCD, FesteringStrikeFinish 	= PA:GetActualSpellCD(FesteringStrikeFinish, "Festering Strike")
		HornOfWinterCD, HornOfWinterFinish 			= PA:GetActualSpellCD(HornOfWinterFinish, "Horn of Winter")

		-- ============================ HeartStrike ============================
		-- Outputs:
		-- HeartStrikeCD
		--------------------------------------
		HeartStrikeStart, HeartStrikeDuration, _ = GetSpellCooldown("Heart Strike")
		if (HeartStrikeStart ~= 0) then
			if (HeartStrikeDuration > 1.5) then
				HeartStrikeFinish = HeartStrikeStart + HeartStrikeDuration
			end
		else
			HeartStrikeFinish = GetTime()
		end
		HeartStrikeCD = HeartStrikeFinish - GetTime()
		if (HeartStrikeCD <= 0) then
			HeartStrikeCD = 0
		end
		BloodRune1Start, _, _ = GetRuneCooldown(1)
		BloodRune2Start, _, _ = GetRuneCooldown(2)
		if (BloodRune1Start  > 0 and BloodRune2Start > 0) then
			HeartStrikeCD  = 50
		end

		IcyTouchName, _, _, _, _, IcyTouchDuration, IcyTouchExpirationTime, UnitCaster, _ = UnitDebuff("target", "Frost Fever")
		if (IcyTouchName ~= nil) then
			IcyTouchCD = 30
		end

		PlagueStrikeName, _, _, _, _, PlagueStrikeDuration, PlagueStrikeExpirationTime, UnitCaster, _ = UnitDebuff("target", "Blood Plague")
		if (PlagueStrikeName ~= nil) then
			PlagueStrikeCD = 30
		end
	

		-- ============================ RuneStrike ============================
		-- Outputs:
		-- RuneStrikeCD
		--------------------------------------
		_, _, _, RuneStrikeCost, _, _, _, _, _ = GetSpellInfo("Rune Strike")
		if (RunicPower < RuneStrikeCost) then
			RuneStrikeCD = 30
		else
			RuneStrikeCD = 0
		end

		-- ============================ Outbreak ============================
		-- Outputs:
		-- OutbreakCD
		--------------------------------------
		OutbreakStart, OutbreakDuration, _ = GetSpellCooldown("Outbreak")
		OutbreakCD = OutbreakStart + OutbreakDuration - GetTime()
		if (OutbreakCD < 0) then
			OutbreakCD = 0
		end
	

		
		--====================================================================
		--============================== LOGIC TREE ===========================
		--====================================================================
		if (HealthPercent <= 93 and DeathStrikeCD == 0) then
			Spell1 = DeathStrike
		elseif (IcyTouchCD == 0 ) then
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
		elseif (RuneStrikeCD == 0 and RunicPower >= 110) then
			Spell1 = RuneStrike
		elseif (DeathStrikeCD == 0) then
			Spell1 = DeathStrike
		elseif (HeartStrikeCD == 0) then
			Spell1 = HeartStrike
		elseif (RuneStrikeCD == 0 and RunicPower >= 70) then
			Spell1 = RuneStrike
		else
			if (BloodTapCD == 0) then
				Spell1 = BloodTap
			elseif (HornOfWinterCD == 0) then
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
		PA:Print("Initializing Blood")
		PA:SetToggle(1, 0, "Death Coil")		
		-- PA:SetToggle(2, 0, "Dark Transformation")
		-- PA:SetToggle(3, 1, "Necrotic Strike")
		PA:SetToggle(4, 1, "Mind Freeze")
		
		PA:RegisterGCDSpell("Plague Strike")
		PA:RegisterRangeSpell("Icy Touch")
		
		-- ==================== REGISTER SPELL COLORS ==============================
		HeartStrike				= PA:RegisterSpell(1, "Heart Strike")
		RuneStrike				= PA:RegisterSpell(2, "Rune Strike")
		DeathStrike				= PA:RegisterSpell(3, "Death Strike")
		IcyTouch				= PA:RegisterSpell(4, "Icy Touch")
		BloodTap				= PA:RegisterSpell(5, "BloodTap")
		Outbreak				= PA:RegisterSpell(6, "Outbreak")
		BloodBoil				= PA:RegisterSpell(7, "Blood Boil")
		Pestilence				= PA:RegisterSpell(8, "Pestilence")
		RuneTap					= PA:RegisterSpell(9, "Rune Tap")
		PlagueStrike			= PA:RegisterSpell(10, "Plague Strike")
		HornOfWinter			= PA:RegisterSpell(11, "Horn of Winter")

		-- ==================== REGISTER ROTATION ==============================
		PA:setRotation(mod.rotation, "Unholy")
	end
end



function mod.checkSpec()
	PointsSpent = 0
	_, _, _, _, PointsSpent, _, _, _ = GetTalentTabInfo(1)	-- Check that enough points are spent in the right tree
	if(PointsSpent >= 30) then
		enabled = true
	else
		enabled = false
	end
end
