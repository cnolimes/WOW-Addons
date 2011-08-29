-- don't load if class is wrong
local _, class = UnitClass("player")
if class ~= "VWARRIOR" then return end

-- mod name in lower case
local modName 			= "Protection"
local version 			= 1

-- create a module in the main addon
local mod = PA:RegisterClassModule(modName)

-- any error sets this to false
local enabled 			= true
	
local BattleStance 		= 2457
local BerserkerStance 	= 2458
local DefensiveStance 	= 71
		
local BerserkerRage 	= 18499
local BladeStorm 		= 46924
local BloodThirst 		= 23881
local Charge 			= 100
local Intercept 		= 20252
local Intervene 		= 3411
local Cleave 			= 845
local HeroicStrike 		= 78
local ConcussionBlow 	= 12809
local Devastate 		= 20243			-- Spell
local Execute 			= 5308
local HeroicThrow 		= 57755
local HeroicFury 		= 60970
local MortalStrike 		= 12294
local LastStand 		= 12975
local Pummel 			= 6552
local RagingBlow 		= 85288
local Revenge 			= 6572			-- Spell
local ShatteringThrow 	= 64382
local Slam 				= 1464						
local Strike 			= 88161
local VictoryRush 		= 34428			-- Spell
local Whirlwind 		= 1680

-- Debuffs Too
local DemoShout 		= 1160			-- Spell & debuff
local ThunderClap 		= 6343			-- Spell & debuff
local Rend 				= 772			-- Spell & debuff
local SunderArmor 		= 7386			-- Spell & debuff
local ColossusSmash 	= 86346			-- Spell & debuff
local SunderArmorDebuff = 58567
local RendDebuff 		= 94009


--Buffs
local BattleShout 		= 6673			-- Spell & buff
local CommandingShout 	= 469			-- Spell & buff
local DeadlyCalm 		= 85730			-- Spell & Buff
local DeathWish 		= 12292			-- Spell & Buff
local ShieldBlock 		= 2565			-- Spell & buff
local ShieldWall 		= 871			-- Spell & buff
local ShieldSlam 		= 23922			-- Spell & buff
local Shockwave 		= 46968			-- Spell & buff
local Retaliation 		= 20230			-- Spell & Buff
local SweepingStrikes 	= 12328			-- Spell & Buff
local Recklessness 		= 1719			-- Spell & Buff
local InnerRage 		= 1134			-- Spell & buff
local OverPower 		= 7384			-- Spell & buff
local SuddenDeath 		= 52437

local Bloodsurge 		= 46916
local TasteForBlood 	= 60503
local Executioner 		= 90806
local Incite 			= 86627
local BattleTrance 		= 12964
local Slaughter 		= 84584
local Thunderstruck 	= 87096
local Victorious 		= 32216

local HeroicStrikeRage	= 65

local Stance_Battle 	= 1
local Stance_Berserker 	= 2
local Stance_Defensive 	= 3

function mod.offGCDrotation(player, target, focus, pet)
	if(enabled) then		
		if(player.spells[HeroicStrike].canCast and player.rage >= HeroicStrikeRage ) then
			PA:SpellCast(1, HeroicStrike)
			PA:SpellCast(2, Cleave)
		elseif (PA.gcd > PA.ShowDataTimeFactor) then							-- NOT inside spam window
			if ((PA.gcd - PA.ShowDataTimeFactor) > 0.100) then					-- Check Medium Delay
				PA:SpellDelay(100)
			else
				PA:SpellDelay(20)												-- Else Short Delay
			end
		end
		PA:SpellFire()
	end
end

function mod.oldRotation(StartTime, GCDTimeLeft)
	if(enabled) then

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
		elseif (CommandingShoutTimeLeft < 5 and CommandingShoutCD == 0 and PA.Toggle_Do_3 == true) then 		-- Check CommandingShout 
			Spell1 = CommandingShout
		elseif (ShockwaveCD == 0 and PA.Toggle_Do_2 == true) then
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
		elseif (ShockwaveCD == 0 and PA.Toggle_Do_2 == true) then
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
	
		PA:SpellFire(Spell1, Spell2, Spell3)
	end
end


-- ======================================================================== --
-- Detect Type of Target, and perform rotation appropriate to target type
-- ======================================================================== --
function mod.rotation(player, target, focus, pet)
	if(enabled) then
		mod.statusupdate(player, target, focus, pet)
		if(player.mana <  20 or player.buffs[BattleShout].timeLeft <= 0 and player.spells[BattleShout].canCast) then
			PA:SpellCast(1, BattleShout)
			PA:SpellCast(2, BattleShout)
		elseif(target.classification == "worldboss" or target.classification == "elite") then		-- PVE Boss Rotation			
			mod.bossrotation(player, target, focus, pet)
		elseif(target.classification == "normal") then
			mod.pvprotation(player, target, focus, pet)
		end
	end
end


-- ======================================================================== --
-- The Boss Rotation
-- ======================================================================== --
function mod.bossrotation(player, target, focus, pet)


end

-- ======================================================================== --
-- The Pvp / Normal Target Rotation
-- ======================================================================== --
function mod.pvprotation(player, target, focus, pet)


end

-- ======================================================================== --
-- Status Update Code
-- ======================================================================== --
function mod.statusupdate(player, target, focus, pet)
	PA:Status1(target.classification)
	PA:Status2("Sunderc:" .. target.debuffs[SunderArmorDebuff].count)
	-- PA:Status3("DCtl: " .. string.format("%.2f", player.buffs[DeadlyCalm].timeLeft) .. " TFBtl: " .. string.format("%.2f", player.buffs[TasteForBlood].timeLeft))
	-- PA:Status4("CStl: " .. string.format("%.2f", target.debuffs[ColossusSmash].timeLeft) .. " Rtl: " .. string.format("%.2f", target.debuffs[RendDebuff].timeLeft))
	-- PA.Status5("MScd: " .. string.format("%.2f", player.spells[MortalStrike].cd) .. " CScd: " .. string.format("%.2f", player.spells[ColossusSmash].cd))
end

function mod.OnInitialize()
	mod.checkSpec()
	if (enabled) then
				
		ShieldSlam			= PA:RegisterSpell(1, "Shield Slam")
		Revenge				= PA:RegisterSpell(2, "Revenge")
		Devastate			= PA:RegisterSpell(3, "Devastate")
		Shockwave			= PA:RegisterSpell(4, "Shockwave")
		ThunderClap 		= PA:RegisterSpell(5, "Thunderclap")
		Rend 				= PA:RegisterSpell(6, "Rend")
		DemoShout			= PA:RegisterSpell(7, "Demoralizing Shout")
		CommandingShout		= PA:RegisterSpell(8, "Commanding Shout")
		HeroicStrike		= PA:RegisterSpell(9, "Heroic Strike")
		Cleave				= PA:RegisterSpell(10, "Cleave")
		InnerRage			= PA:RegisterSpell(11, "Inner Rage")
		
		PA:AddSpell(1, ShieldSlam)
		PA:AddSpell(2, Revenge)
		PA:AddSpell(3, Devastate)
		PA:AddSpell(4, Shockwave)
		PA:AddSpell(5, Thunderclap)
		PA:AddSpell(6, Rend)
		PA:AddSpell(7, DemoShout)
		PA:AddSpell(8, CommandingShout)
		PA:AddSpell(9, HeroicStrike)
		PA:AddSpell(10, Cleave)
		PA:AddSpell(11, InnerRage)
		
		
		PA:AddBuff(BattleShout)
		PA:AddBuff(CommandingShout)
		PA:AddBuff(DeadlyCalm)
		PA:AddBuff(DeathWish)
		PA:AddBuff(ShieldWall)
		PA:AddBuff(ShieldBlock)
		PA:AddBuff(Retaliation)
		PA:AddBuff(SweepingStrikes)
		PA:AddBuff(Recklessness)
		PA:AddBuff(InnerRage)
		PA:AddBuff(OverPower)
		PA:AddBuff(Bloodsurge)
		PA:AddBuff(TasteForBlood)
		PA:AddBuff(Executioner)
		PA:AddBuff(Incite)
		PA:AddBuff(BattleTrance)
		PA:AddBuff(Slaughter)
		PA:AddBuff(Victorious)
		PA:AddBuff(SuddenDeath)		
		
		
	
		-- ==================== REGISTER ROTATION ==============================
		PA:setRotation(mod.rotation, modName)
		PA:setOffGCDRotation(mod.offGCDrotation)
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
	