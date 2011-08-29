-- don't load if class is wrong
local _, class = UnitClass("player")
if class ~= "WARRIOR" then return end

-- mod name in lower case
local modName = "Arms"
local version = 1

local SITUATION=SITUATION
local Libs = SITUATION.Libs;
local Spells = SITUATION.Spells;
local Tools = SITUATION.Tools;

-- create a module in the main addon
local mod = SITUATION:RegisterClassModule(modName)

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
		if(player:CanCast(HeroicStrike) and player.rage >= HeroicStrikeRage ) then
			SITUATION:SpellCast(1, HeroicStrike)
			SITUATION:SpellCast(2, Cleave)
		elseif (SITUATION.time.gcd > SITUATION.ShowDataTimeFactor) then							-- NOT inside sSITUATIONm window
			if ((SITUATION.time.gcd - SITUATION.ShowDataTimeFactor) > 0.100) then				-- Check Medium Delay
				SITUATION:SpellDelay(100)
			else
				SITUATION:SpellDelay(20)												-- Else Short Delay
			end
		end
	end
end


-- ======================================================================== --
-- Detect Type of Target, and perform rotation appropriate to target type
-- ======================================================================== --
function mod.rotation(player, target, focus, pet)
	if(enabled) then

		if(player.mana <  20 or player:BuffTimeLeft(BattleShout) <= 0 and player:CanCast(BattleShout)) then
			SITUATION:SpellCast(1, BattleShout)
			SITUATION:SpellCast(2, BattleShout)
		elseif(target.classification == "worldboss" or target.classification == "elite") then		-- PVE Boss Rotation			
			mod.bossrotation(player, target, focus, pet)
		elseif(target.classification == "normal") then
			mod.pvprotation(player, target, focus, pet)
		end
	end
end


-- ======================================================================== --
-- Boss Target Rotation
-- ======================================================================== --
function mod.bossrotation(player, target, focus, pet)
--	if( target:DebuffCount(SunderArmorDebuff) < 3 or target:DebuffTimeLeft(SunderArmorDebuff) < 2) then
--		SITUATION:SpellCast(1, SunderArmor)
--	elseif(player:BuffTimeLeft(DeadlyCalm) <= 0 and player.rage < 71 and player:CanCast(BerserkerRage)) then
--		SITUATION:SpellCast(1, BerserkerRage)
--	else
	if(player:BuffTimeLeft(TasteForBlood) < 1.5 and player:BuffTimeLeft(TasteForBlood) > 0) then
		SITUATION:SpellCast(1, OverPower)
	elseif(target.healthPercent() > 20 and player:CanCast(MortalStrike)) then
		SITUATION:SpellCast(1, MortalStrike)
	elseif(player:BuffTimeLeft(BattleTrance) >0 and target.healthPercent() < 20 and player:CanCast(Execute)) then
		SITUATION:SpellCast(1, Execute)
	elseif(target:DebuffTimeLeft(RendDebuff) <= 0) then
		SITUATION:SpellCast(1, Rend)
	elseif(target:DebuffTimeLeft(ColossusSmash) < 1.5 and player:CanCast(ColossusSmash)) then
		SITUATION:SpellCast(1, ColossusSmash)
	elseif(player:BuffTimeLeft(DeadlyCalm) > 0.5 or player:BuffTimeLeft(Recklessness) > 0.5 and target.healthPercent() < 20 and player:CanCast(Execute)) then
		SITUATION:SpellCast(1, Execute)
	elseif(player:CanCast(MortalStrike)) then
		SITUATION:SpellCast(1, MortalStrike)
	elseif(player:CanCast(OverPower)) then
		SITUATION:SpellCast(1, OverPower)
	elseif(target.healthPercent() < 20 and player:CanCast(Execute)) then
		SITUATION:SpellCast(1, Execute)
	elseif(player:GetSpellCooldown(MortalStrike) > 1.5 and (player.rage > 34 or player:BuffTimeLeft(DeadlyCalm) > 0.1 or target:DebuffTimeLeft(ColossusSmash) > 0.1)) then
		SITUATION:SpellCast(1, Slam)
	elseif(player:GetSpellCooldown(MortalStrike) > 1.2 and target:DebuffTimeLeft(ColossusSmash) > 0.1 and player.rage > 34) then
		SITUATION:SpellCast(1, Slam)
	elseif(player.rage < 20) then
		SITUATION:SpellCast(1, BattleShout)
	else
		SITUATION:SpellCast(1, Slam)
	end
	
	if(target:DebuffTimeLeft(RendDebuff) <= 0) then
		SITUATION:SpellCast(2, Rend)
	elseif(player:CanCast(ThunderClap)) then
		SITUATION:SpellCast(2, ThunderClap)
	elseif(player:BuffTimeLeft(TasteForBlood) > 0.2) then				-- Overpower when Available
		SITUATION:SpellCast(2, OverPower)
	elseif(target.healthPercent() > 20 and player:CanCast(MortalStrike)) then
		SITUATION:SpellCast(2, MortalStrike)
	elseif(target.healthPercent() < 20 and player:CanCast(Execute)) then
		SITUATION:SpellCast(2, Execute)
	elseif(target:DebuffTimeLeft(ColossusSmash) <= 1.5 and player:CanCast(ColossusSmash) and player:GetSpellCooldown(DeadlyCalm) > 20) then
		SITUATION:SpellCast(2, ColossusSmash)
	elseif(player:CanCast(MortalStrike)) then
		SITUATION:SpellCast(2, MortalStrike)
	elseif(player:GetSpellCooldown(MortalStrike) > 1.5 and (player.rage > 34 or player:BuffTimeLeft(DeadlyCalm) > 0.1 or target:DebuffTimeLeft(ColossusSmash) > 0.1)) then
		SITUATION:SpellCast(2, Slam)
	elseif(player:GetSpellCooldown(MortalStrike) > 1.2 and target:DebuffTimeLeft(ColossusSmash) > 0.1 and player.rage > 34) then
		SITUATION:SpellCast(2, Slam)
	elseif(player.rage < 20) then
		SITUATION:SpellCast(2, BattleShout)
	else
		SITUATION:SpellCast(2, Slam)
	end
end

function mod.printdebug(player, target, focus, pet)
	if(SITUATION.serial % 400 == 0) then
		SITUATION.debug("CS:" .. player:GetSpellCooldown(ColossusSmash), player:GetSpellCooldown(MortalStrike) .. ":MS")
		SITUATION.debug("TFB:" .. player:BuffTimeLeft(TasteForBlood), target:DebuffTimeLeft(RendDebuff) .. ":REND")
	end
end

-- ======================================================================== --
-- PVP and Normal Target Rotation
-- ======================================================================== --
function mod.pvprotation(player, target, focus, pet)
	mod.printdebug(player, target, focus, pet)

	if(player:BuffTimeLeft(TasteForBlood) > 0.2) then				-- Overpower when Available
		SITUATION:SpellCast(1, OverPower)
	elseif(target.healthPercent() > 20 and player:CanCast(MortalStrike)) then
		SITUATION:SpellCast(1, MortalStrike)
	elseif(target.healthPercent() < 20 and player:CanCast(Execute)) then
		SITUATION:SpellCast(1, Execute)
	elseif(target:DebuffTimeLeft(RendDebuff) <= 0) then
		SITUATION:SpellCast(1, Rend)
	elseif(target:DebuffTimeLeft(ColossusSmash) <= 1.5 and player:CanCast(ColossusSmash) and player:GetSpellCooldown(DeadlyCalm) > 20) then
		SITUATION:SpellCast(1, ColossusSmash)
	elseif(player:CanCast(MortalStrike)) then
		SITUATION:SpellCast(1, MortalStrike)
	elseif(player:CanCast(ColossusSmash) and player:GetSpellCooldown(DeadlyCalm) > 20) then
		SITUATION:SpellCast(1, ColossusSmash)
	elseif(player:GetSpellCooldown(MortalStrike) > 1.5 and (player.rage > 34 or player:BuffTimeLeft(DeadlyCalm) > 0.1 or target:DebuffTimeLeft(ColossusSmash) > 0.1)) then
		SITUATION:SpellCast(1, Slam)
	elseif(player:GetSpellCooldown(MortalStrike) > 1.2 and target:DebuffTimeLeft(ColossusSmash) > 0.1 and player.rage > 34) then
		SITUATION:SpellCast(1, Slam)
	elseif(player.rage < 20) then
		SITUATION:SpellCast(1, BattleShout)
	else
		SITUATION:SpellCast(1, Slam)
	end
	-- AOE Logic
	if(target:DebuffTimeLeft(RendDebuff) <= 0) then
		SITUATION:SpellCast(2, Rend)
	elseif(player:CanCast(ThunderClap)) then
		SITUATION:SpellCast(2, ThunderClap)
	elseif(player:BuffTimeLeft(TasteForBlood) > 0.2) then				-- Overpower when Available
		SITUATION:SpellCast(2, OverPower)
	elseif(target.healthPercent() > 20 and player:CanCast(MortalStrike)) then
		SITUATION:SpellCast(2, MortalStrike)
	elseif(target.healthPercent() < 20 and player:CanCast(Execute)) then
		SITUATION:SpellCast(2, Execute)
	elseif(target:DebuffTimeLeft(ColossusSmash) <= 1.5 and player:CanCast(ColossusSmash) and player:GetSpellCooldown(DeadlyCalm) > 20) then
		SITUATION:SpellCast(2, ColossusSmash)
	elseif(player:CanCast(MortalStrike)) then
		SITUATION:SpellCast(2, MortalStrike)
	elseif(player:CanCast(ColossusSmash) and player:GetSpellCooldown(DeadlyCalm) > 20) then
		SITUATION:SpellCast(1, ColossusSmash)				
	elseif(player:GetSpellCooldown(MortalStrike) > 1.5 and (player.rage > 34 or player:BuffTimeLeft(DeadlyCalm) > 0.1 or target:DebuffTimeLeft(ColossusSmash) > 0.1)) then
		SITUATION:SpellCast(2, Slam)
	elseif(player:GetSpellCooldown(MortalStrike) > 1.2 and target:DebuffTimeLeft(ColossusSmash) > 0.1 and player.rage > 34) then
		SITUATION:SpellCast(2, Slam)
	elseif(player.rage < 20) then
		SITUATION:SpellCast(2, BattleShout)
	else
		SITUATION:SpellCast(2, Slam)
	end
end

function mod.OnInitialize()
	mod.checkSpec()
	if (enabled) then
		SITUATION:AddSpell(1, MortalStrike)
		SITUATION:AddSpell(2, ColossusSmash)
		SITUATION:AddSpell(3, Rend)
		SITUATION:AddSpell(4, OverPower)
		SITUATION:AddSpell(5, Slam)
		SITUATION:AddSpell(6, HeroicStrike)
		SITUATION:AddSpell(7, Cleave)
		SITUATION:AddSpell(8, BattleShout)
		SITUATION:AddSpell(9, CommandingShout)
		SITUATION:AddSpell(10, VictoryRush)
		SITUATION:AddSpell(11, ThunderClap)
		
		SITUATION:AddSpell(21, InnerRage)
		SITUATION:AddSpell(22, DeadlyCalm)

		
		SITUATION:AddBuff(BattleShout)
		SITUATION:AddBuff(CommandingShout)
		SITUATION:AddBuff(DeadlyCalm)
		SITUATION:AddBuff(DeathWish)
		SITUATION:AddBuff(ShieldWall)
		SITUATION:AddBuff(ShieldBlock)
		SITUATION:AddBuff(Retaliation)
		SITUATION:AddBuff(SweepingStrikes)
		SITUATION:AddBuff(Recklessness)
		SITUATION:AddBuff(InnerRage)
		SITUATION:AddBuff(OverPower)
		SITUATION:AddBuff(Bloodsurge)
		SITUATION:AddBuff(TasteForBlood)
		SITUATION:AddBuff(Executioner)
		SITUATION:AddBuff(Incite)
		SITUATION:AddBuff(BattleTrance)
		SITUATION:AddBuff(Slaughter)
		SITUATION:AddBuff(Victorious)
		SITUATION:AddBuff(SuddenDeath)
		
		
		SITUATION:AddEnemyDebuff(DemoShout)
		SITUATION:AddEnemyDebuff(ThunderClap)
		SITUATION:AddEnemyDebuff(RendDebuff)
		SITUATION:AddEnemyDebuff(SunderArmor)
		SITUATION:AddEnemyDebuff(ColossusSmash)
		SITUATION:AddEnemyDebuff(SunderArmorDebuff)
		SITUATION:AddEnemyDebuff(MortalStrike)

		-- ==================== REGISTER ROTATION ==============================
		SITUATION:setRotation(mod.rotation, modName)
		SITUATION:setOffGCDRotation(mod.offGCDrotation)
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
	