-- don't load if class is wrong
local _, class = UnitClass("player")
if class ~= "PRIEST" then return end

-- mod name in lower case
local modName = "Shadow Priest"
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
local StartTime					= GetTime()
local MindBlastFinish 			= StartTime
local ShadowWordDeathFinish 	= StartTime
local ShadowFiendFinish 		= StartTime
local ArchAngelFinish 			= StartTime
local VampiricTouchFinish 		= StartTime
--------------------------------------------------------------------------------

function mod.offgcdrotation(StartTime, GCDTimeLeft)
	if(enabled) then
		MindFlayName, _, _, _, _, MindFlayDuration, MindFlayExpirationTime, UnitCaster, _ = UnitDebuff("target", "Mind Flay")
		if (MindFlayName ~= nil and UnitCaster == "player") then
			MindFlayCD = MindFlayExpirationTime - GetTime()
		else
			MindFlayCD = 0
		end
		
		if (MindFlayCD > 0) then		-- Check if channeling mind flay
			if (MindFlayCD > 0.300) then
				Spell1 = WA.Delay300
			elseif (MindFlayCD > 0.100) then
				Spell1 = WA.Delay100
			else
				Spell1 = WA.Delay20
			end
		elseif (GCDTimeLeft > WA.ShowDataTimeFactor) then							-- NOT inside spam window
			if ((GCDTimeLeft - WA.ShowDataTimeFactor) > 0.300) then						-- Check Longer Delay
				Spell1 = WA.Delay300
			elseif ((GCDTimeLeft - WA.ShowDataTimeFactor) > 0.100) then						-- Check Medium Delay
				Spell1 = WA.Delay100
			else
				Spell1 = WA.Delay20									-- Else Short Delay
			end
		end
		
		Spell2 = Spell1
		Spell3 = Spell1
		WA:SpellFire(Spell1, Spell2, Spell3)
	end
end

function mod.rotation(StartTime, GCDTimeLeft)
	if(enabled) then
		
		Mana = UnitPower("player")	
		MaxMana = UnitManaMax("player")
		ManaPercent = Mana / MaxMana

		
		-- ============================ Mind Blast =============================
		-- Outputs:
		-- MindBlastCD
		--------------------------------------
		MindBlastStart, MindBlastDuration , _ = GetSpellCooldown("Mind Blast")
		if (MindBlastStart ~= 0) then
			if (MindBlastDuration > 1.5) then
				MindBlastFinish = MindBlastStart + MindBlastDuration
			end	
		end
		MindBlastCD = MindBlastFinish - GetTime()
		if (MindBlastCD < 0) then
			MindBlastCD = 0
		end

		-- ============================ Shadow Fiend =============================
		-- Outputs:
		-- ShadowFiendCD
		--------------------------------------
		ShadowFiendStart, ShadowFiendDuration , _ = GetSpellCooldown("Shadowfiend")
		if (ShadowFiendStart ~= 0) then
			if (ShadowFiendDuration > 1.5) then
				ShadowFiendFinish = ShadowFiendStart + ShadowFiendDuration
			end	
		end
		ShadowFiendCD = ShadowFiendFinish - GetTime()
		if (ShadowFiendCD < 0) then
			ShadowFiendCD = 0
		end

		-- ============================ ArchAngel =============================
		-- Outputs:
		-- ArchAngelCD
		--------------------------------------
		ArchAngelStart, ArchAngelDuration , _ = GetSpellCooldown("Archangel")
		if (ArchAngelStart ~= 0) then
			if (ArchAngelDuration > 1.5) then
				ArchAngelFinish = ArchAngelStart + ArchAngelDuration
			end	
		end
		ArchAngelCD = ArchAngelFinish - GetTime()
		if (ArchAngelCD < 0) then
			ArchAngelCD = 0
		end

		-- ============================ Mind Flay  ==============================
		-- Outputs:
		--MindFlayCD
		--------------------------------------
		--SpellName, _, _, _, MindFlayStartTime, MindFlayEndTime, _, _ = UnitChannelInfo("player")
		--if (SpellName == "Mind Flay") then
		--	MindFlayCD = (MindFlayEndTime / 1000) - GetTime()
		--else
		--	MindFlayCD = 0
		--end

		MindFlayName, _, _, _, _, MindFlayDuration, MindFlayExpirationTime, UnitCaster, _ = UnitDebuff("target", "Mind Flay")
		if (MindFlayName ~= nil and UnitCaster == "player") then
			MindFlayCD = MindFlayExpirationTime - GetTime()
		else
			MindFlayCD = 0
		end
		-- ============================ Vampiric Touch =============================
		-- Outputs:
		-- VampiricTouchCD
		-- VampiricTouchDelay
		--------------------------------------
		VampiricTouchName, _, _, _, _, VampiricTouchDuration, VampiricTouchExpirationTime, UnitCaster, _ = UnitDebuff("target", "Vampiric Touch")
		if (VampiricTouchName ~= nil and UnitCaster == "player") then
			_, _, _, _, _, _, VampiricTouchCastTime, _, _ = GetSpellInfo("Vampiric Touch")
			VampiricTouchCD = (VampiricTouchExpirationTime - GetTime()) - (VampiricTouchCastTime/1000)
			if (VampiricTouchCD < 0) then
				VampiricTouchCD = 0
			end
		else
			VampiricTouchCD = 0
		end
		VampiricTouchSpellName, _, _, _, _, VampiricTouchEndTime, _, _, _ = UnitCastingInfo("player")
		if (VampiricTouchSpellName ~= nil) then
			VampiricTouchFinish = (VampiricTouchEndTime / 1000) + 0.3
		end
		VampiricTouchDelay = VampiricTouchFinish - GetTime()
		if (VampiricTouchDelay < 0) then
			VampiricTouchDelay = 0
		end
		-- ============================ Shadow Word Pain ============================
		-- Outputs:
		-- ShadowWordPainCD 	
		--------------------------------------
		ShadowWordPainName, _, _, _, _, ShadowWordPainDuration, ShadowWordPainExpirationTime, UnitCaster, _ = UnitDebuff("target", "Shadow Word: Pain")
		if (ShadowWordPainName ~= nil and UnitCaster == "player") then
			ShadowWordPainCD = ShadowWordPainExpirationTime - GetTime()
		else
			ShadowWordPainCD = 0
		end

		-- ============================ Devouring Plague ===========================
		-- Outputs:
		-- DevouringPlagueCD
		--------------------------------------
		DevouringPlagueName, _, _, _, _, DevouringPlagueDuration, DevouringPlagueExpirationTime, UnitCaster, _ = UnitDebuff("target", "Devouring Plague")
		if (DevouringPlagueName ~= nil and UnitCaster == "player") then
			DevouringPlagueCD = DevouringPlagueExpirationTime - GetTime()
		else
			DevouringPlagueCD = 0
		end
		-- ============================ Shadow Word Death ================================
		-- Outputs:
		-- ShadowWordDeathCD
		--------------------------------------
		ShadowWordDeathStart, ShadowWordDeathDuration , _ = GetSpellCooldown("Shadow Word: Death")
		if (ShadowWordDeathStart ~= 0) then
			if (ShadowWordDeathDuration > 1.5) then
				ShadowWordDeathFinish = ShadowWordDeathStart + ShadowWordDeathDuration
			end	
		end
		ShadowWordDeathCD = ShadowWordDeathFinish - GetTime()
		if (ShadowWordDeathCD < 0) then
			ShadowWordDeathCD = 0
		end
		-- ============================ Mind Spike============================
		-- Outputs:
		-- MindSpikeCD
		--------------------------------------
		SpellName, _, _, _, MindSpikeStartTime, MindSpikeEndTime, _, _ = UnitChannelInfo("player")
		if (SpellName == "Mind Spike") then
			MindSpikeCD = (MindSpikeEndTime / 1000) - GetTime()
		else
			MindSpikeCD = 0
		end

		-- ============================ Mind Sear ============================
		-- Outputs:
		-- MindSearCD
		--------------------------------------
		SpellName, _, _, _, MindSearStartTime, MindSearEndTime, _, _ = UnitChannelInfo("player")
		if (SpellName == "Mind Sear") then
			MindSearCD = (MindSearEndTime / 1000) - GetTime()
		else
			MindSearCD = 0
		end

		DarkEvangelismCount 		= WA:GetBuffCount("Dark Evangelism")
		ShadowOrbCount				= WA:GetBuffCount("Shadow Orb")
		EmpoweredShadowTimeLeft		= WA:GetBuff("Empowered Shadow")
		MindMeltCount				= WA:GetBuffCount("Mind Melt")

		--====================================================================
		--============================== LOGIC TREE ===========================
		--====================================================================

		-- SW:P -> Shadowfiend -> VT -> DP -> MF (until Orb) -> MB -> MF until DoT refresh -> Dark Archangel -> MF -> MF -> Mind Blast (once you have an Orb)
		-- After re-upping Dark Evangelism post Dark Archangel, it's simple spell priority:
		-- VT > SW:P* > DP > MB(1+ Orbs) > (SW:D)** > MF
		-- Shadowfiend on every cooldown
		-- Dark Archangel when DoTs are ticking away (2+ ticks remaining, to make sure you have time to refresh DE)
		-- *Should never be relevant, really, but just so it's clear
		-- **If you cast Shadow Word: Death on cooldown below a certain threshold of mana (I prefer 80%), you will stay pretty well topped off through most of the fight.
		
		
		-- =============== Single Target Boss Logic ==================
		if (ShadowWordPainCD  == 0) then
			Spell1 = ShadowWordPain
		elseif (ShadowFiendCD == 0 and WA_Shadow_Toggle_Do_1 == true) then
			Spell1 = ShadowFiend
		elseif (VampiricTouchCD == 0 and VampiricTouchDelay == 0) then
			Spell1 = VampiricTouch
		elseif (DevouringPlagueCD == 0) then
			Spell1 = DevouringPlague
		elseif (ShadowOrbCount > 0 and MindBlastCD == 0) then 
			Spell1 = MindBlast
		elseif (ArchAngelCD == 0 and WA_Shadow_Toggle_Do_2  == true and DarkEvangelismCount == 5) then
			Spell1 = ArchAngel
		elseif (ManaPercent < 0.80 and ShadowWordDeathCD == 0) then
			Spell1 = ShadowWordDeath
		else
			Spell1 = MindFlay
		end

		-- =============== AOE  Logic ==================
		if (ManaPercent < 0.80 and ShadowWordDeathCD == 0) then
			Spell2 = ShadowWordDeath
		elseif (ShadowFiendCD == 0 and WA_Shadow_Toggle_Do_1 == true) then
			Spell2 = ShadowFiend
		elseif (DevouringPlagueCD == 0) then
			Spell2 = DevouringPlague		
		elseif (ShadowWordPainCD  == 0) then
			Spell2 = ShadowWordPain
		elseif (VampiricTouchCD == 0 and VampiricTouchDelay == 0) then
			Spell2 = VampiricTouch
		else
			Spell2 = MindFlay
		end

		-- =============== Weak Add  Logic ==================
		if (ManaPercent < 0.80 and ShadowWordDeathCD == 0) then
			Spell3 = ShadowWordDeath
		elseif (MindMeltCount == 2 and MindBlastCD == 0) then
			Spell3 = MindBlast
		elseif (MindMeltCount < 2) then
			Spell3 = MindSpike
		else		
			Spell3 = MindFlay
		end
		WA:SpellFire(Spell1, Spell2, Spell3)
	end
end

function mod.OnInitialize()
	mod.checkSpec()
	if (enabled) then
		WA:Print("Initializing Shadow Priest")
		WA:SetToggle(1, 1, "Shadowfiend")		
		WA:SetToggle(2, 0, "Archangel")
		WA:SetToggle(3, 1, "Shadow Word: Death")
		-- WA:SetToggle(4, 1, "Rebuke")
		
		WA:RegisterGCDSpell("Mind Blast")
		WA:RegisterRangeSpell("Mind Blast")
		
		MindBlast 		= WA:RegisterSpell(1, "Mind Blast")
		MindFlay 		= WA:RegisterSpell(2, "Mind Flay")
		VampiricTouch	= WA:RegisterSpell(3, "Vampiric Touch")
		ShadowWordPain 	= WA:RegisterSpell(4, "Shadow Word: Pain")
		DevouringPlague = WA:RegisterSpell(5, "Devouring Plague")
		ShadowWordDeath = WA:RegisterSpell(6, "Shadow Word: Death")
		MindSpike 		= WA:RegisterSpell(7, "Mind Spike")
		MindSear 		= WA:RegisterSpell(8, "Mind Sear")
		ShadowFiend 	= WA:RegisterSpell(9, "Shadowfiend")
		ArchAngel 		= WA:RegisterSpell(10, "Archangel")

		-- ==================== REGISTER ROTATION ==============================
		WA:setOffGCDRotation(mod.offgcdrotation, modName)
		WA:setRotation(mod.rotation, modName)
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