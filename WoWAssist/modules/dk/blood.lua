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
local mod = WA:RegisterClassModule(modName)

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
		
		
		
		IcyTouchCD, IcyTouchFinish					= WA:GetActualSpellCD(IcyTouchFinish, "Icy Touch")
		PlagueStrikeCD, PlagueStrikeFinish			= WA:GetActualSpellCD(PlagueStrikeFinish, "Plague Strike")
		DeathStrikeCD, DeathStrikeFinish			= WA:GetActualSpellCD(DeathStrikeFinish, "Death Strike")
		BloodTapCD, BloodTapFinish					= WA:GetActualSpellCD(BloodTapFinish, "Blood Tap")
		BloodBoilCD, BloodBoilFinish				= WA:GetActualSpellCD(BloodBoilFinish, "Blood Boil")
		PestilenceCD, PestilenceFinish				= WA:GetActualSpellCD(PestilenceFinish, "Pestilence")
		FesteringStrikeCD, FesteringStrikeFinish 	= WA:GetActualSpellCD(FesteringStrikeFinish, "Festering Strike")
		HornOfWinterCD, HornOfWinterFinish 			= WA:GetActualSpellCD(HornOfWinterFinish, "Horn of Winter")

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
		WA:SpellFire(Spell1, Spell2, Spell3)
	end
end



function mod.OnInitialize()
	mod.checkSpec()
	if (enabled) then
		WA:Print("Initializing Blood")
		WA:SetToggle(1, 0, "Death Coil")		
		-- WA:SetToggle(2, 0, "Dark Transformation")
		-- WA:SetToggle(3, 1, "Necrotic Strike")
		WA:SetToggle(4, 1, "Mind Freeze")
		
		WA:RegisterGCDSpell("Plague Strike")
		WA:RegisterRangeSpell("Icy Touch")
		
		-- ==================== REGISTER SPELL COLORS ==============================
		HeartStrike				= WA:RegisterSpell(1, "Heart Strike")
		RuneStrike				= WA:RegisterSpell(2, "Rune Strike")
		DeathStrike				= WA:RegisterSpell(3, "Death Strike")
		IcyTouch				= WA:RegisterSpell(4, "Icy Touch")
		BloodTap				= WA:RegisterSpell(5, "BloodTap")
		Outbreak				= WA:RegisterSpell(6, "Outbreak")
		BloodBoil				= WA:RegisterSpell(7, "Blood Boil")
		Pestilence				= WA:RegisterSpell(8, "Pestilence")
		RuneTap					= WA:RegisterSpell(9, "Rune Tap")
		PlagueStrike			= WA:RegisterSpell(10, "Plague Strike")
		HornOfWinter			= WA:RegisterSpell(11, "Horn of Winter")

		-- ==================== REGISTER ROTATION ==============================
		WA:setRotation(mod.rotation, "Unholy")
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
