-- don't load if class is wrong
local _, class = UnitClass("player")
if class ~= "DRUID" then return end

local SITUATION=SITUATION
local Libs = SITUATION.Libs;
local Spells = SITUATION.Spells;
local Tools = SITUATION.Tools;

-- mod name in lower case
local modName = "Feral"
local version = 1


-- create a module in the main addon
local mod = SITUATION:RegisterClassModule(modName)

-- any error sets this to false
local enabled = true


local Barkskin 			= 22812		-- cat+bear+caster def cd
local Berserk 			= 50334 	-- cat+bear cd buff
local FrenziedRegen 	= 22842	-- bear
local SurvivalInstincts = 61336		-- cat+bear surv cd

-- Bear
local DemoRoar 			= 99 		-- bear
local Enrage 			= 5229 		-- bear
local Lacerate 			= 33745		-- bear bleed*3
local MangleBear 		= 33878 	-- bear bleed+debuff
local Maul 				= 6807 		-- bear
local Pulverize 		= 80313		-- bear after lacerate*3
local SwipeBear 		= 779		-- bear aoe
local Thrash 			= 77758		-- bear aoe bleed
local FeralChargeBear	= 49377		-- bear feral charge

-- Cat
local FeralChargeCat 	= 49376
local FerociousBite 	= 22568		-- cat finish 35-70 mana
local MangleCat 		= 33876 	-- cat bleed+debuff
local Rake 				= 1822		-- cat bleed
local Ravage 			= 6785		-- cat behind+(prowling or stampede)
local Rip 				= 1079		-- cat bleed
local SavageRoar 		= 52610		-- cat damage buff
local Shred 			= 5221		-- cat behind
local SwipeCat		 	= 62078		-- cat aoe
local TigersFury 		= 5217		-- cat buff

-- Both
local FaerieFire 		= 16857 	-- bear+cat

-- Buff
local ClearCasting 		= 16870
local Stampede			= 81022
local PulverizeBuff 	= 80951	-- buff has a different spellid then the ability

local BearForm 		= 1
local AquaticForm 	= 2
local CatForm 		= 3
local TravelForm	= 4
local MoonKinTOL	= 5
local FlightForm	= 6


function mod.OnInitialize()
	mod.checkSpec()
	if (enabled) then
		SITUATION.GCD_Duration	= 1.0
		
		-- ==================== REGISTER SPELL COLORS ==============================
		SITUATION:AddSpell(1, Shred)
		SITUATION:AddSpell(1, Pulverize)
		SITUATION:AddSpell(2, MangleCat)
		SITUATION:AddSpell(2, MangleBear)
		SITUATION:AddSpell(3, Rake)
		SITUATION:AddSpell(3, Lacerate)
		SITUATION:AddSpell(4, Ravage)
		SITUATION:AddSpell(4, Maul)
		SITUATION:AddSpell(5, Rip)
		SITUATION:AddSpell(5, Thrash)
		SITUATION:AddSpell(6, SwipeCat)
		SITUATION:AddSpell(6, SwipeBear)
		SITUATION:AddSpell(7, FerociousBite)
		SITUATION:AddSpell(7, DemoRoar)
		SITUATION:AddSpell(8, SavageRoar)
		SITUATION:AddSpell(9, TigersFury)
		SITUATION:AddSpell(10, FaerieFire)
				
		SITUATION:AddBuff(PulverizeBuff)
		SITUATION:AddBuff(ClearCasting)
		SITUATION:AddBuff(Stampede)
		SITUATION:AddBuff(SavageRoar)
		SITUATION:AddBuff(Berserk)
		SITUATION:AddBuff(TigersFury)
		
		SITUATION:AddEnemyDebuff(Lacerate)
		SITUATION:AddEnemyDebuff(Rip)
		SITUATION:AddEnemyDebuff(Rake)
		SITUATION:AddEnemyDebuff(FaerieFire)
		SITUATION:AddEnemyDebuff(DemoRoar)
		SITUATION:AddEnemyDebuff(MangleCat)
		SITUATION:AddEnemyDebuff(MangleBear)
		
		-- ==================== REGISTER ROTATION ==============================
		SITUATION:setRotation(mod.rotation, "Feral")
	end
end


-- ======================================================================== --
-- Detect Type of Target, and perform rotation appropriate to target type
-- ======================================================================== --
function mod.rotation(player, target, focus, pet)
	if(enabled) then
		if(player.stance == BearForm) then
			mod.bearrotation(player, target, focus, pet)
		elseif(player.stance == CatForm) then
			if(target.classification == "worldboss" or target.classification == "elite") then		-- PVE Boss Rotation			
				mod.catrotationboss(player, target, focus, pet)
			elseif(target.classification == "normal") then
				mod.catrotationpvp(player, target, focus, pet)
			end
		elseif(player.stance == 5) then
			-- Moonkin
		else
			-- Put up something else
		end
	end
end

function mod.catrotationboss(player, target, focus, pet)
	--
	-- Single Target Rotation
	-- 
	if (player:CanCast(TigersFury) and player.energy < 35) then
		SITUATION:SpellCast(TigersFury)
	-- keep Faerie Fire up, maximum priority since it boosts damage of every melee/hunter and tank threat generation
	elseif (target:DebuffTimeLeft(FaerieFire) == 0 and player:CanCast(FaerieFire) ) then 
		SITUATION:SpellCast(1, FaerieFire)
	elseif (player:GetSpellCooldown(MangleCat) < 2 and  player:CanCast(MangleCat)) then
		SITUATION:SpellCast(1, MangleCat)
	-- below 25%, rip about to fall off, at least 1 cp --> FB
	elseif (player.combo > 0 and target.healthPercent() < 20 and target:DebuffTimeLeft(Rip) < 3 and target:DebuffTimeLeft(Rip) > 0 and player:CanCast(FerociousBite) ) then
		SITUATION:SpellCast(1, FerociousBite)
	elseif (player.combo == 5 and target.healthPercent() < 25 and target:DebuffTimeLeft(Rip) > 1 and player:CanCast(FerociousBite)) then 
		SITUATION:SpellCast(1, FerociousBite)
--	elseif (state.can_extend_rip > 0 and target:DebuffTimeLeft(Rip) < 4  and target:DebuffTimeLeft(Rip) > 0 and not (target.healthPercent() < 25) and player:CanCast(Shred)) then 
--		SITUATION:SpellCast(1, Shred)
	elseif (player.combo == 5 and target:DebuffTimeLeft(Rip) < 3 and (player:BuffTimeLeft(Berserk) > 0 or target:DebuffTimeLeft(Rip) <= player:BuffTimeLeft(TigersFury)) and player:CanCast(Rip)) then
		SITUATION:SpellCast(1,  Rip)
	elseif (target:DebuffTimeLeft(Rake) < 9 and player:GetSpellCooldown(TigersFury) > 0 and player:CanCast(Rake)) then 
		SITUATION:SpellCast(1,  Rake)
	elseif (target:DebuffTimeLeft(Rake) < 3 and (player:BuffTimeLeft(Berserk) > 0 or target:DebuffTimeLeft(Rake) - 0.8 <= player:GetSpellCooldown(TigersFury) or player.energy > 71) and player:CanCast(Rake)) then
		SITUATION:SpellCast(1,  Rake)
	elseif (player:BuffTimeLeft(ClearCasting) > 0) then
		SITUATION:SpellCast(1,  Shred)
	elseif (player.combo > 0 and player:BuffTimeLeft(SavageRoar) < 3 and target:DebuffTimeLeft(Rip) > 6 and player:CanCast(SavageRoar)) then 
		SITUATION:SpellCast(1,  SavageRoar)
	elseif (player.combo == 5 and target:DebuffTimeLeft(Rip) < 12 and math.abs(target:DebuffTimeLeft(Rip) - player:BuffTimeLeft(SavageRoar)) < 3 and player:CanCast(SavageRoar)) then 
		SITUATION:SpellCast(1,  SavageRoar)
	elseif (player:BuffTimeLeft(Stampede) > 0 and player.combo < 5 and player.energy < 100) then
		SITUATION:SpellCast(1,  Ravage)
	elseif (player.combo < 5 and target:DebuffTimeLeft(Rake) > 3  and target:DebuffTimeLeft(Rip) > 3 and (player.energy > 80 or (player:BuffTimeLeft(Berserk) > 0 and player.energy > 20)) and player:CanCast(Shred)) then
		SITUATION:SpellCast(1,  Shred)
	elseif (player:GetSpellCooldown(TigersFury) < 3  or (player.combo == 0 and (player:BuffTimeLeft(SavageRoar) < 2 or target:DebuffTimeLeft(Rake) > 5)) and player:CanCast(Shred)) then
		SITUATION:SpellCast(1,  Shred)
	elseif (target:DebuffTimeLeft(Rip) == 0 or player.energy > 90 or player:BuffTimeLeft(Berserk) > 0 and player:CanCast(Shred)) then 
		SITUATION:SpellCast(1,  Shred)
	else
		SITUATION:SpellDelay(20)
	end
	
	--
	-- AOE Rotation
	-- 
	if (player:CanCast(TigersFury) and player.energy < 35 and player.BuffTimeLeft(Berserk) == 0) then
		SITUATION:SpellCast(2, TigersFury)
	-- keep Faerie Fire up, maximum priority since it boosts damage of every melee/hunter and tank threat generation
	elseif(target:DebuffTimeLeft(FaerieFire) == 0 and player:CanCast(FaerieFire) ) then 
		SITUATION:SpellCast(2, FaerieFire)
	elseif(player.BuffTimeLeft(OmenOfClarity)) then 
		SITUATION:SpellCast(2, SwipeCat)
	elseif(player:CanCast(Swipe)) then
		SITUATION:SpellCast(2, SwipeCat)
	else
		SITUATION:SpellDelay(20)
	end
end

function mod.catrotationpvp(player, target, focus, pet)
	if (player:CanCast(TigersFury) and player.energy < 35) then
		SITUATION:SpellCast(TigersFury)
	-- keep Faerie Fire up, maximum priority since it boosts damage of every melee/hunter and tank threat generation
	elseif (target:DebuffTimeLeft(FaerieFire) == 0 and player:CanCast(FaerieFire) ) then 
		SITUATION:SpellCast(1, FaerieFire)
	-- Put mangle up before it drops
	elseif (target:DebuffTimeLeft(MangleCat) < 2 and  player:CanCast(MangleCat)) then
		SITUATION:SpellCast(1, MangleCat)
	elseif (player.combo == 5 and target.healthPercent() < 25 and target:DebuffTimeLeft(Rip) > 1 and player:CanCast(FerociousBite)) then 
		SITUATION:SpellCast(1, FerociousBite)
	elseif (player.combo == 5 and target:DebuffTimeLeft(Rip) < 3 and (player:BuffTimeLeft(Berserk) > 0 or target:DebuffTimeLeft(Rip) <= player:BuffTimeLeft(TigersFury)) and player:CanCast(Rip)) then
		SITUATION:SpellCast(1,  Rip)
	elseif (target:DebuffTimeLeft(Rake) < 9 and player:GetSpellCooldown(TigersFury) > 0 and player:CanCast(Rake)) then 
		SITUATION:SpellCast(1,  Rake)
	elseif (target:DebuffTimeLeft(Rake) < 3 and (player:BuffTimeLeft(Berserk) > 0 or target:DebuffTimeLeft(Rake) - 0.8 <= player:GetSpellCooldown(TigersFury) or player.energy > 71) and player:CanCast(Rake)) then
		SITUATION:SpellCast(1,  Rake)
	elseif (player:BuffTimeLeft(ClearCasting) > 0) then
		SITUATION:SpellCast(1,  Shred)
	elseif (player.combo > 0 and player:BuffTimeLeft(SavageRoar) < 3 and target:DebuffTimeLeft(Rip) > 6 and player:CanCast(SavageRoar)) then 
		SITUATION:SpellCast(1,  SavageRoar)
	elseif (player.combo == 5 and target:DebuffTimeLeft(Rip) < 12 and math.abs(target:DebuffTimeLeft(Rip) - player:BuffTimeLeft(SavageRoar)) < 3 and player:CanCast(SavageRoar)) then 
		SITUATION:SpellCast(1,  SavageRoar)
	elseif (player:BuffTimeLeft(Stampede) > 0 and player.combo < 5 and player.energy < 100) then
		SITUATION:SpellCast(1,  Ravage)
	elseif (player.combo < 5 and target:DebuffTimeLeft(Rake) > 3  and target:DebuffTimeLeft(Rip) > 3 and (player.energy > 80 or (player:BuffTimeLeft(Berserk) > 0 and player.energy > 20)) and player:CanCast(Shred)) then
		SITUATION:SpellCast(1,  Shred)
	elseif (player:GetSpellCooldown(TigersFury) < 3  or (player.combo == 0 and (player:BuffTimeLeft(SavageRoar) < 2 or target:DebuffTimeLeft(Rake) > 5)) and player:CanCast(Shred)) then
		SITUATION:SpellCast(1,  Shred)
	elseif (target:DebuffTimeLeft(Rip) == 0 or player.energy > 90 or player:BuffTimeLeft(Berserk) > 0 and player:CanCast(Shred)) then 
		SITUATION:SpellCast(1,  Shred)
	else
		SITUATION:SpellDelay(20)
	end



	--
	-- AOE Rotation
	-- 
	if (player:CanCast(TigersFury) and player.energy < 35 and player.BuffTimeLeft(Berserk) == 0) then
		SITUATION:SpellCast(2, TigersFury)
	-- keep Faerie Fire up, maximum priority since it boosts damage of every melee/hunter and tank threat generation
	elseif(target:DebuffTimeLeft(FaerieFire) == 0 and player:CanCast(FaerieFire) ) then 
		SITUATION:SpellCast(2, FaerieFire)
	elseif(player.BuffTimeLeft(OmenOfClarity)) then 
		SITUATION:SpellCast(2, SwipeCat)
	elseif(player:CanCast(Swipe)) then
		SITUATION:SpellCast(2, SwipeCat)
	else
		SITUATION:SpellDelay(20)
	end
	--
	-- Burst Rotation
	--
	
end


function mod.bearrotation(player, target, focus, pet)
	_, tanking_status = UnitDetailedThreatSituation("player","target")

	-- We are targeting (tanking) boss and demoshout is not on. Apply it as it significantly reduces the boss' damage.
	if (target:DebuffTimeLeft(DemoRoar) < 3 and target.classification == "worldboss" or target.classification == "elite" and player:CanCast(DemoRoar)) then
		SITUATION:SpellCast(1,  DemoRoar)
	-- Mangle is ready after this GCD.
	elseif (player:CanCast(MangleBear)) then
		SITUATION:SpellCast(1,  MangleBear)
	-- FF on target if not apply it.
	elseif (target:DebuffTimeLeft(FaerieFire) <= 6 and player:CanCast(FaerieFire)) then
		SITUATION:SpellCast(1, FaerieFire)
	-- Pulverize less than 3 second and Lacerate = 3 stacks refresh it
	elseif (player:BuffTimeLeft(PulverizeBuff) <= 3 and target:DebuffCount(Lacerate) >= 3) then
		SITUATION:SpellCast(1,  Pulverize)
	-- Lacerate has not 1 stacks apply it.
	elseif (target:DebuffCount(Lacerate) < 1) then
		SITUATION:SpellCast(1,  Lacerate)
	-- Faerie Fire is ready after this GCD and rage is low use FFF. 
	elseif (player:CanCast(FaerieFire) and state.rage < 25) then
		SITUATION:SpellCast(1,  FaerieFire)
	-- Lacerate has not 3 stacks or is about to fall off in this or next Mangle-FF cycle. Refresh it.
	elseif (target:DebuffTimeLeft(Lacerate) <= 4.5 or target:DebuffCount(Lacerate) < 3) then
		SITUATION:SpellCast(1,  Lacerate)
	-- Faerie Fire is ready after this GCD use as filler
	elseif (player:CanCast(FaerieFire)) then
		SITUATION:SpellCast(1,  FaerieFire)
	elseif (player:CanCast(DemoRoar) and target:DebuffTimeLeft(DemoRoar) > 3) then
		SITUATION:SpellCast(1,  DemoRoar)
	elseif (player:CanCast(Thrash)) then
		SITUATION:SpellCast(1,  Thrash)
	elseif (player:CanCast(SwipeBear)) then
		SITUATION:SpellCast(1,  SwipeBear)
	else
		SITUATION:SpellDelay(20)
	end
end

function mod.checkSpec()
	PointsSpent = 0
	_, _, _, _, PointsSpent, _, _, _ = GetTalentTabInfo(2)	-- Check that enough points are spent in the right tree
	if(PointsSpent >= 30) then
		enabled = true
	else
		enabled = false
	end
end
