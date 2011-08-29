-- don't load if class is wrong
local _, class = UnitClass("player")
if class ~= "WARRIOR" then return end

-- mod name in lower case
local modName = "Protection Warrior"
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
local HeroicStrikeRage				= 50
local CleaveRage					= 50
local InnerRageThreshold			= 85

--================== Initialize Spec Variables =====================
local StartTime					= GetTime()
local ShieldSlamFinish 			= StartTime
local RevengeFinish 			= StartTime
local ThunderClapFinish 		= StartTime
local ShockwaveFinish 			= StartTime
local HeroicStrikeFinish 		= StartTime
local CleaveFinish 				= StartTime
local CommandingShoutFinish 	= StartTime
local InterruptFinish			= StartTime

function mod.offGCDrotation(StartTime, GCDTimeLeft)
	if(enabled) then
		Rage = UnitPower("player")
		
		InnerRageCD 		= WA:GetBuff("Inner Rage")
		HeroicStrikeCD 		= WA:GetCooldown("Heroic Strike")
		-- Cleave == Heroic Strike
		CleaveCD = HeroicStrikeCD
		
		if (InnerRageCD == 0 and Rage >= InnerRageThreshold and WA.Toggle_Do_1 == true ) then		-- Check Inner rage
			Spell1 = InnerRage
		elseif (HeroicStrikeCD == 0 and Rage > HeroicStrikeRage) then					-- Check Heroic Strike
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
		elseif (InnerRageCD == 0 and Rage >= InnerRageThreshold and WA.Toggle_Do_1 == true ) then		-- Check Inner rage
			Spell2 = InnerRage
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
		_, _, _, _, Threat = UnitDetailedThreatSituation("player", "target")
		if (Threat == nil) then
			Threat = 0
		end
		
		ShieldSlamCD, ShieldSlamFinish				= WA:GetActualSpellCD(ShieldSlamFinish, "Shield Slam")
		ThunderClapCD, ThunderClapFinish			= WA:GetActualSpellCD(ThunderClapFinish, "Thunder Clap")
		ShockwaveCD, ShockwaveFinish				= WA:GetActualSpellCD(ShockwaveFinish, "Shockwave")
		
		DemoShoutCD				= WA:GetAttackPowerDebuff()
		ThunderClapTimeLeft		= WA:GetAttackSpeedDebuff()
		
		_, _, _, ShieldSlamCost, _, _, _, _, _ = GetSpellInfo("Shield Slam")
		if (Rage < ShieldSlamCost) then
			ShieldSlamCD = 30
		end

		if (ShieldSlamCD < WA.ShowDataTimeFactor) then
			ShieldSlamCD = 0
		end
		
		-- ============================ Revenge  ==============================
		-- Outputs:
		-- RevengeCD 	(0 if ready, 30 if not enough rage or unusable, 0 to 5 if on cooldown)
		--------------------------------------
		RevengeUsable, nomana = IsUsableSpell("Revenge")
		if (RevengeUsable ~= nil) then
			RevengeStart, RevengeDuration, _ = GetSpellCooldown("Revenge")
			if (RevengeStart ~= 0) then
				if (RevengeDuration > WA.GCD_Duration) then			-- Calc CD based on a non GCD duration 
					RevengeFinish = RevengeStart + RevengeDuration
					RevengeCD = RevengeFinish - WA.StartTime
				else
					if (RevengeFinish - WA.StartTime > 0) then		--check if finish is even relevant, if not cd = 0
						if (RevengeFinish - (RevengeStart + RevengeDuration) - WA.ShowDataTimeFactor > 0) then
							RevengeCD = 0
						else
							RevengeCD = RevengeFinish - WA.StartTime
						end
					else
						RevengeCD = 0
					end
				end
			
			else
				RevengeCD = 0
			end
			_, _, _, RevengeCost, _, _, _, _, _ = GetSpellInfo("Revenge")
			if (Rage < RevengeCost) then
				RevengeCD = 30
			end
		else
			RevengeCD = 30
		end
		-- ============================ Check Rage Costs =============================
		_, _, _, DevastateCost, _, _, _, _, _ = GetSpellInfo("Devastate")
		if (Rage < DevastateCost) then
			CanDevastate = false
		else
			CanDevastate = true
		end
		_, _, _, ShockwaveCost, _, _, _, _, _ = GetSpellInfo("Shockwave")
		if (Rage < ShockwaveCost) then
			ShockwaveCD = 30
		end
		_, _, _, ThunderClapCost, _, _, _, _, _ = GetSpellInfo("Thunder Clap")
		if (Rage < ThunderClapCost) then
			ThunderClapCD = 30
		end
		
		-- ============================ Rend ================================
		-- Outputs:
		-- RendCD
		--------------------------------------
		RendName, _, _, _, _, RendDuration, RendExpirationTime, UnitCaster, _ = UnitDebuff("target", "Rend")
		if (RendName ~= nil) then
			if (UnitCaster == "player") then
				RendCD = RendExpirationTime - GetTime()
			else
				RendCD = 0
			end
		else
			RendCD = 0	
		end		
		_, _, _, RendCost, _, _, _, _, _ = GetSpellInfo("Rend")
		if (Rage < RendCost) then
			RendCD = 30
		end

		
		
		-- Check for Redundant Debuffs
		ThunderClapName, _, _, _, _, ThunderClapDuration, ThunderClapExpirationTime, UnitCaster, _ = UnitDebuff("target", "Thunder Clap")
		if (ThunderClapName ~= nil) then
			ThunderClapTimeLeft = ThunderClapExpirationTime - WA.StartTime
		else
			ThunderClapTimeLeft = 0
		end
		IcyTouchName, _, _, _, _, _, _, _, _ = UnitDebuff("target", "Frost Fever")
		if (IcyTouchName ~= nil) then
			AttackSpeedSlowIsPresent = true
		else
			AttackSpeedSlowIsPresent = false
		end
		
		
		-- ============================ Sunder Armor ============================
		-- Outputs:
		-- SunderArmorCount
		-- SunderArmorTimeLeft (0 if not up, 0 to 45 if up)
		--------------------------------------
		SunderArmorName, _, _, SunderArmorCount, _, SunderArmorDuration, SunderArmorExpirationTime, UnitCaster, _ = UnitDebuff("target", "Sunder Armor")
		if (SunderArmorName ~= nil) then
			SunderArmorTimeLeft = SunderArmorExpirationTime - WA.StartTime
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
		CommandingShoutCD		= WA:GetActualSpellCD(CommandingShoutFinish, "Commanding Shout")
		
		CommandingShoutName, _, _, _, _, _, CommandingShoutExpirationTime, _, _, _, _ = UnitBuff("player", "Commanding Shout") 
		if (CommandingShoutName == nil) then
			CanCommandingShout = true
			CommandingShoutTimeLeft = 0
		else
			CommandingShoutTimeLeft = CommandingShoutExpirationTime - WA.StartTime
			CanCommandingShout = false		
		end


		--====================================================================
		--============================== LOGIC TREE ===========================
		--====================================================================
		-- http://elitistjerks.com/f81/t110315-cataclysm_protection_warrior/

		-- =============== Single Target Logic ==================
		-- Shield Slam > Revenge > Rend > Devastate
		-- Note: A single Rend application is only worth using on a 30%-bleed debuffed single target if it ticks at least four times. 
		-- Unbuffed, it must tick all six times. Never refresh an existing Rend -- always wait for it to run its full duration or else you
		--  lose the initial application tick. Whenever possible, immediately follow up a Shield Slam with either a Revenge or Devastate. 
		-- The Sword and Board talent is most effective when it procs the first GCD after a Shield Slam is used. If it fails to proc, use 
		-- the remaining 2 GCDs to refresh debuffs/buffs as needed.Applying three Sunder Armor stacks should typically be a high
		--  priority, as should be applying damage-reducing debuffs such as Demoralizing Shout and Thunder Clap. The exact order 
		-- and urgency of applying debuffs isn't set in stone, and it's up to you to prioritize personal threat, group DPS, and reducing 
		-- incoming damage depending on the circumstances.		
		
		if (ShieldSlamCD == 0) then									-- Check for Shield Slam
			Spell1 = ShieldSlam
		elseif (SunderArmorCount < 3 or SunderArmorTimeLeft < 5) then						-- Stack Sunder Up
			Spell1 = Devastate
		elseif (ShieldSlamCD > 4.3) then									-- In GCD after SS, use Rev or Dev
			if (RevengeCD == 0) then
				Spell1 = Revenge									-- Revenge if up
			else
				Spell1 = Devastate									-- else do Devastate
			end
		elseif ((ThunderClapTimeLeft < 5 or AttackSpeedSlowIsPresent == false) and ThunderClapCD == 0) then		-- Check ThunderClap 
			Spell1 =  ThunderClap
		elseif (DemoShoutCD  <= 5) then									-- Check DemoShout 
			Spell1 = DemoShout
		elseif (CommandingShoutTimeLeft < 5 and CommandingShoutCD == 0 and WA.Toggle_Do_3 == true) then 		-- Check CommandingShout 
			Spell1 = CommandingShout
		elseif (ShockwaveCD == 0 and WA.Toggle_Do_2 == true) then
			Spell1 = Shockwave
		elseif (RevengeCD == 0) then									-- Check Revenge
			Spell1 = Revenge
		else
			Spell1 = Devastate									-- Else Do Devastate
		end
		
		-- =============== Multi Target Logic===================
		-- Rend > Thunder Clap > Shockwave > Revenge
		-- This is assuming you have Blood and Thunder talent. Using T. Clap like clockwork will help your threat somewhat, 
		-- especially by adding Thunderstruck charges for the next Shockwave, but the most important step is to keep Rend 
		-- rolling on all your targets. It makes a dramatic difference in your sustained threat versus not having the talent. Remaining 
		-- GCDs should be occupied prioritizing Revenge and then single-target abilities.	
		
	
		if (RendCD ==0) then
			Spell2 = Rend
		elseif (ThunderClapCD == 0) then
			Spell2 = ThunderClap
		elseif (ShockwaveCD == 0 and WA.Toggle_Do_2 == true) then
			Spell2 = Shockwave
		elseif (RevengeCD == 0) then
			Spell2 = Revenge
		elseif (ShieldSlamCD == 0) then
			Spell2 = ShieldSlam
		elseif (DemoShoutCD  <= 5) then					-- Check DemoShout
			Spell2 = DemoShout
		else
			Spell2 = Devastate
		end
	
		WA:SpellFire(Spell1, Spell2, Spell3)
	end
end

function mod.OnInitialize()
	mod.checkSpec()
	if (enabled) then
		-- WA:Print("Initializing Protection Warrior")
		WA:SetToggle(1, 0, "Inner Rage")		
		WA:SetToggle(2, 0, "Shockwave")
		WA:SetToggle(3, 0, "Battle Shout")
		WA:SetToggle(4, 0, "Pummel")
		
		WA:RegisterGCDSpell("Vigilance")
		WA:RegisterRangeSpell("Heroic Throw")
		
		
		ShieldSlam			= WA:RegisterSpell(1, "Shield Slam")
		Revenge				= WA:RegisterSpell(2, "Revenge")
		Devastate			= WA:RegisterSpell(3, "Devastate")
		Shockwave			= WA:RegisterSpell(4, "Shockwave")
		ThunderClap 		= WA:RegisterSpell(5, "Thunderclap")
		Rend 				= WA:RegisterSpell(6, "Rend")
		DemoShout			= WA:RegisterSpell(7, "Demoralizing Shout")
		CommandingShout		= WA:RegisterSpell(8, "Commanding Shout")
		HeroicStrike		= WA:RegisterSpell(9, "Heroic Strike")
		Cleave				= WA:RegisterSpell(10, "Cleave")
		InnerRage			= WA:RegisterSpell(11, "Inner Rage")		
	
		-- ==================== REGISTER ROTATION ==============================
		WA:setRotation(mod.rotation, modName)
		WA:setOffGCDRotation(mod.offGCDrotation)
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
	