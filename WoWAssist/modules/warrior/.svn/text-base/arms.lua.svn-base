-- don't load if class is wrong
local _, class = UnitClass("player")
if class ~= "WARRIOR" then return end

-- mod name in lower case
local modName = "Arms Warrior"
local version = 1

--================== Initialize Variables =====================
local Spell1 				= nil
local Spell2 				= nil
local Spell3 				= nil

-- create a module in the main addon
local mod = WA:RegisterClassModule(modName)

-- any error sets this to false
local enabled = true

local MinimumThreatForDebuffs 		= 000000
local HeroicStrikeRage				= 75
local CleaveRage					= 75


--================== Initialize Spec Variables =====================
local StartTime					= GetTime()
local MortalStrikeFinish 		= StartTime
local ColossusSmashFinish 		= StartTime
local HeroicStrikeFinish 		= StartTime
local CleaveFinish 				= StartTime
local CommandingShoutFinish 	= StartTime
local BattleShoutFinish 		= StartTime
local OverPowerFinish 			= StartTime
local ThunderClapFinish 		= StartTime


function mod.offGCDrotation(StartTime, GCDTimeLeft)
	if(enabled) then
		Rage = UnitPower("player")
		
		HeroicStrikeCD 		= WA:GetCooldown("Heroic Strike")
		-- Cleave == Heroic Strike
		CleaveCD = HeroicStrikeCD
		
		if (HeroicStrikeCD == 0 and Rage > HeroicStrikeRage) then					-- Check Heroic Strike
			Spell1 = HeroicStrike
		elseif ((WA.StartGCD - WA.ShowDataTimeFactor) > .300) then						-- Check Longer Delay
			Spell1 = WA.Delay300
		elseif ((WA.StartGCD - WA.ShowDataTimeFactor) > .100) then						-- Check Medium Delay
			Spell1 = WA.Delay100
		else
			Spell1 = WA.Delay20									-- Else Short Delay
		end
		
		if (CleaveCD == 0 and Rage > CleaveRage) then						-- Check Cleave
			Spell2 = Cleave
		elseif ((WA.StartGCD - WA.ShowDataTimeFactor) > .300) then						-- Check Longer Delay
			Spell2 = Delay300
		elseif ((WA.StartGCD - WA.ShowDataTimeFactor) > .100) then						-- Check Medium Delay
			Spell2 = Delay100
		else
			Spell2 = Delay20									-- Else Short Delay
		end
		
		WA:SpellFire(Spell1, Spell2, Spell3)
	end
end


function mod.rotation(StartTime, GCDTimeLeft)
	if(enabled) then
		Rage = UnitPower("player")	

		-- ============================ Mortal Strike =============================
		-- Outputs:
		-- MortalStrikeCD 	
		--------------------------------------
		MortalStrikeCD, MortalStrikeFinish			= WA:GetActualSpellCD(MortalStrikeFinish, "Mortal Strike")
		_, _, _, MortalStrikeCost, _, _, _, _, _ = GetSpellInfo("Mortal Strike")
		if (Rage < MortalStrikeCost) then
			MortalStrikeCD = 30
		end

		
		-- ============================ ThunderClap ===========================
		-- Outputs:
		-- ThunderClapCD 	(0 if ready, 30 if not enough rage, 0 to 6 if on cooldown)
		-- ThunderClapTimeLeft (0 if not up, 0 to 30 if up)
		--------------------------------------
		ThunderClapCD, ThunderClapFinish			= WA:GetActualSpellCD(ThunderClapFinish, "Thunder Clap")
		_, _, _, ThunderClapCost, _, _, _, _, _ = GetSpellInfo("Thunder Clap")
		if (Rage < ThunderClapCost) then
			ThunderClapCD = 30
		end
		ThunderClapName, _, _, _, _, ThunderClapDuration, ThunderClapExpirationTime, UnitCaster, _ = UnitDebuff("target", "Thunder Clap")
		if (ThunderClapName ~= nil) then
			ThunderClapTimeLeft = ThunderClapExpirationTime - GetTime()
		else
			ThunderClapTimeLeft = 0
		end
		
		-- ============================ Colossus Smash  ==============================
		-- Outputs:
		-- ColossusSmashCD 
		-- ColossusSmashDebuffCD 
		--------------------------------------
		ColossusSmashCD, ColossusSmashFinish			= WA:GetActualSpellCD(ColossusSmashFinish,"Colossus Smash")
		_, _, _, ColossusSmashCost, _, _, _, _, _ = GetSpellInfo("Colossus Smash")
		if (Rage < ColossusSmashCost) then
			ColossusSmashCD = 30
		end
		ColossusSmashDebuffName, _, _, _, _, ColossusSmashDebuffDuration, ExpirationTime, UnitCaster, _ = UnitDebuff("target", "Colossus Smash")
		if (ColossusSmashDebuffName ~= nil) then
			ColossusSmashDebuffCD = 30
		else
			ColossusSmashDebuffCD = 0
		end		


		-- ============================ OverPower  ==============================
		-- Outputs:
		-- OverPowerCD 
		--------------------------------------
		OverPowerUsable, nomana = IsUsableSpell("Overpower")
		if (OverPowerUsable ~= nil) then
			OverPowerCD = 0
			_, _, _, OverPowerCost, _, _, _, _, _ = GetSpellInfo("Overpower")
			if (Rage < OverPowerCost) then
				OverPowerCD = 30
			end
		else
			OverPowerCD = 30
		end

		-- ============================ Rend ================================
		-- Outputs:
		-- CanRend	(true/false)
		--------------------------------------
		RendName, _, _, _, _, RendDuration, ExpirationTime, UnitCaster, _ = UnitDebuff("target", "Rend", nil, "PLAYER")
		if (RendName ~= nil) then
			CanRend = false
		else
			CanRend = true	
		end		
		_, _, _, RendCost, _, _, _, _, _ = GetSpellInfo("Rend")
		if (Rage < RendCost) then
			CanRend = false
		end

		-- ============================ Sunder Armor ============================
		-- Outputs:
		-- SunderArmorCount
		-- SunderArmorTimeLeft (0 if not up, 0 to 45 if up)
		--------------------------------------
		SunderArmorName, _, _, SunderArmorCount, _, SunderArmorDuration, SunderArmorExpirationTime, UnitCaster, _ = UnitDebuff("target", "Sunder Armor")
		if (SunderArmorName ~= nil) then
			SunderArmorTimeLeft = SunderArmorExpirationTime - GetTime()
		else
			SunderArmorCount = 0
			SunderArmorTimeLeft = 0
		end		

		-- ============================ CommandingShout =======================
		-- Outputs:
		-- CanCommandingShout	(true/false)
		-- CommandingShoutCD	(0 if not up, 0 to 45 if up)
		-- CommandingShoutTimeLeft
		--------------------------------------
		CommandingShoutName, _, _, _, _, _, CommandingShoutExpirationTime, _, _, _, _ = UnitBuff("player", "Commanding Shout") 
		if (CommandingShoutName == nil) then
			CanCommandingShout = true
			CommandingShoutTimeLeft = 0
		else
			CommandingShoutTimeLeft = CommandingShoutExpirationTime - GetTime()
			CanCommandingShout = false		
		end
		CommandingShoutCD, CommandingShoutFinish			= WA:GetActualSpellCD(CommandingShoutFinish,"Commanding Shout")

		-- ============================ Battle Shout =======================
		-- Outputs:
		-- CanBattleShout	(true/false)
		-- BattleShoutCD	(0 if not up, 0 to 45 if up)
		-- BattleShoutTimeLeft
		--------------------------------------
		BattleShoutName, _, _, _, _, _, BattleShoutExpirationTime, _, _, _, _ = UnitBuff("player", "Battle Shout") 
		if (BattleShoutName == nil) then
			CanBattleShout = true
			BattleShoutTimeLeft = 0
		else
			BattleShoutTimeLeft = BattleShoutExpirationTime - GetTime()
			CanBattleShout = false		
		end
		BattleShoutCD, BattleShoutFinish			= WA:GetActualSpellCD(BattleShoutFinish,"Battle Shout")
		
		--====================================================================
		--============================== LOGIC TREE ===========================
		--====================================================================

		-- =============== Single Target Logic ==================T
		if (CanRend == true) then
			Spell1 = Rend
		elseif (ColossusSmashCD == 0 and MortalStrikeCD <= GCDTimeLeft and ColossusSmashDebuffCD == 0) then
			Spell1 = ColossusSmash
		elseif (MortalStrikeCD == 0) then
			Spell1 =  MortalStrike
		elseif (OverPowerCD == 0) then
			Spell1 =  OverPower
		elseif (CanBattleShout == true) then
			Spell1 = BattleShout	
		else
			if (Rage > 40) then
				Spell1 = Slam
			end
		end
		-- =============== Multi Target Logic===================
		
		if (CanRend == true) then
			Spell2 = Rend
		elseif (ThunderClapCD == 0) then
			Spell2 = ThunderClap
		elseif (ColossusSmashCD == 0 and MortalStrikeCD <= GCDTimeLeft and ColossusSmashDebuffCD == 0) then
			Spell2 = ColossusSmash
		elseif (MortalStrikeCD == 0) then
			Spell2 =  MortalStrike
		elseif (OverPowerCD == 0) then
			Spell2 =  OverPower
		elseif (CanBattleShout == true) then
			Spell2 = BattleShout	
		else
			if (Rage > 40) then
				Spell2 = Slam
			end
		end
	
		WA:SpellFire(Spell1, Spell2, Spell3)
	end
end

function mod.OnInitialize()
	mod.checkSpec()
	if (enabled) then
		-- WA:Print("Initializing Arms Warrior")
		WA:SetToggle(1, 0, "Defensive Stance")		
		-- WA:SetToggle(2, 0, "Shockwave")
		-- WA:SetToggle(3, 0, "Battle Shout")
		WA:SetToggle(4, 0, "Pummel")
		
		WA:RegisterGCDSpell("Defensive Stance")
		WA:RegisterRangeSpell("Heroic Throw")
		
		
		MortalStrike			= WA:RegisterSpell(1, "Mortal Strike")
		ColossusSmash 			= WA:RegisterSpell(2, "Colossus Smash")
		Rend					= WA:RegisterSpell(3, "Rend")
		OverPower				= WA:RegisterSpell(4, "Overpower")
		Slam					= WA:RegisterSpell(5, "Slam")
		HeroicStrike			= WA:RegisterSpell(6, "Heroic Strike")
		Cleave					= WA:RegisterSpell(7, "Cleave")
		BattleShout				= WA:RegisterSpell(8, "Battle Shout")
		CommandingShout			= WA:RegisterSpell(9, "Commanding Shout")
		VictoryRush				= WA:RegisterSpell(10, "Victory Rush")
		ThunderClap				= WA:RegisterSpell(11, "Thunderclap")		
	
		-- ==================== REGISTER ROTATION ==============================
		WA:setRotation(mod.rotation, modName)
		WA:setOffGCDRotation(mod.offGCDrotation)
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
	