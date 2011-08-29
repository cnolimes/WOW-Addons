----------
-- Name: TheSituation
-- Version: 2.0.x
-- License: All Rights Reserved
----------

local SITUATION = SITUATION;
local Libs = SITUATION.Libs;
local Spells = SITUATION.Spells;
local Tools = SITUATION.Tools;


--=====--=====--=====--
-- [PRIVATE PROPERTIES]
--=====--=====--=====--

local Player 	= SITUATION.player;
local Target 	= SITUATION.target;
local Focus 	= SITUATION.focus;
local Pet 		= SITUATION.pet;


-- ======================================================================== --
-- PPPPPPP  	LL			  AAAA		YY    YY	EEEEEEEEEE	RRRRRRR
-- PP    PP		LL			 AA	 AA		 YY  YY		EE			RR	  RR
-- PP    PP		LL			 AA  AA		 YY  YY		EE			RR	  RR
-- PPPPPPP		LL			AAAAAAAA	  YYYY		EEEEEEE		RRRRRRR
-- PP			LL			AA    AA       YY		EE			RR	 RR
-- PP			LLLLLLLL   AA      AA      YY		EEEEEEEEEE	RR	  RR
-- ======================================================================== --
function Player.build()
	SITUATION.debug("Player Build")
end

function Player.update()
	if(Player.serial == SITUATION.serial) then
		return Player
	end
	Player.combo 		= GetComboPoints("player")
	Player.mana 		= UnitPower("player")
	Player.rage 		= Player.mana
	Player.energy 		= Player.mana
	Player.focus 		= Player.mana
	Player.runicPower 	= Player.mana
	Player.shard 		= UnitPower("player", 7)
	Player.holyPower 	= UnitPower("player", 9)
	Player.stance 		= GetShapeshiftForm(true)
	Player.stealthed = IsStealthed()
	Player.petPresent = UnitExists("pet") and not UnitIsDead("pet")
	Player.targetTargetIsPlayer = UnitIsUnit("player","targettarget")
	Player.casting, Player.castEnd = SITUATION:GetCasting("player")

	if Player.className == "DEATHKNIGHT" then
		for i=1,6 do
			Player.rune[i].type = GetRuneType(i)
			local start, duration, runeReady = GetRuneCooldown(i)
			if runeReady then
				Player.rune[i].cd = start
			else
				Player.rune[i].cd = duration + start
				if Player.rune[i].cd<0 then
					Player.rune[i].cd = 0
				end
			end
		end
	end
	Player.serial = SITUATION.serial
	if((Player.serial % 10 == 0) or(Player.refresh) ) then
		Player:UpdateSpellCooldowns()
		Player:UpdateBuffs()
		Player:UpdateDebuffs()
		Player.refresh = false
	end
	return Player
end

function Player:CanCast(SpellId)
	if(Player.spells[SpellId].cost < Player.mana  and Player:GetSpellCooldown(SpellId) == 0 ) then
		return true
	end
	return false
end



function Player:GetSpellCooldown(SpellId)
	if(Player.spells[SpellId].serial ~= Player.serial) then
		if (Player.spells[SpellId].start ~= 0) then
			if (Player.spells[SpellId].duration > SITUATION.time.gcd ) then			-- Calc CD based on a non GCD duration 
				Player.spells[SpellId].finish = Player.spells[SpellId].start + Player.spells[SpellId].duration
				Player.spells[SpellId].cd = Player.spells[SpellId].finish - SITUATION.time.now
			else
				if (Player.spells[SpellId].finish - SITUATION.time.now > 0) then		--check if finish is even relevant, if not cd = 0
					if (Player.spells[SpellId].finish - (Player.spells[SpellId].start + Player.spells[SpellId].duration) - SITUATION.ShowDataTimeFactor > 0) then
						Player.spells[SpellId].cd = 0
					else
						Player.spells[SpellId].cd = Player.spells[SpellId].finish - SITUATION.time.now
					end
				else
					Player.spells[SpellId].cd = 0
				end
			end
		else
			Player.spells[SpellId].cd = 0
		end
		Player.spells[SpellId].serial = Player.serial
	end
	return Player.spells[SpellId].cd
end

-- ======================================================================== --
-- Updates the Cooldown on the registered player spells
-- ======================================================================== --
function Player:UpdateSpellCooldowns()
	for i = 1, Player.spellcount do
		SpellId = Player.spellList[i]
		SpellCDStart, SpellCDDuration, enabled = GetSpellCooldown(SpellId)
		Player.spells[SpellId].start = SpellCDStart
		Player.spells[SpellId].duration = SpellCDDuration
	end
end

function Player:BuffTimeLeft(SpellId)
	if( not Player.buffs[SpellId]) then
		SITUATION.debug("Buff Not Found", SpellId)
		return 0
	end
	return Player.buffs[SpellId].expirationTime - SITUATION.time.now
end

function Player:UpdateBuffs()
	for i = 1, Player.buffcount do
		SpellId = Player.bufflist[i]		
		local _, _, _, count, _, _, expirationTime, unitCaster, _, _, _ = UnitBuff("player", Player.buffs[SpellId].name)
		if(expirationTime) then
			Player.buffs[SpellId].count=count
			Player.buffs[SpellId].expirationTime = expirationTime
		else
			Player.buffs[SpellId].expirationTime = 0
			Player.buffs[SpellId].count = 0
		end		
	end
end

function Player:UpdateDebuffs()


end

-- ======================================================================== --
-- Utility Function:
-- Returns a table containing info on every buff on the player keyed
-- by SpellId.
-- ======================================================================== --
function Player:buffList()
	local i = 1
	local name, rank, icon, count, debuffType, duration, expirationTime, unitCaster, isStealable, shouldConsolidate, spellId = UnitBuff("player", i)
	while name do
		buffs[spellId] = {}
		buffs[spellId].name=name
		buffs[spellId].icon=icon
		buffs[spellId].count=count
		buffs[spellId].duration=duration
		buffs[spellId].timeLeft = expirationTime - SITUATION.time.now
		i = i + 1
		name, rank, icon, count, debuffType, duration, expirationTime, unitCaster, isStealable, shouldConsolidate, spellId = UnitBuff("player", i)
	end
	return buffs
end

function Player.moving()
	Player.speed = GetUnitSpeed("player")
	if(Player.speed > 0) then
		return true
	end
	return false
end

function Player.health()
	return UnitHealth("player")
end

function Player.healthMax()
	return UnitHealthMax("player")
end
function Player.healthPercent()
	return (Player.health() / Player.healthMax()) * 100
end

function Player.hasFullControl()
	return true
end


-- ============================================================================
-- Target:
-- 			serial			:Matched to global serial to see if update needed
--			guid			:UnitGUID of target for detecting if it changed
-- 			healthMax 		:Maximum Health of Target
--			health			:Current Health of Target
-- 			healtPercent	:Current Health Percentage of Target
--			classification	:"worldboss", "elite", "normal"
--			
-- ============================================================================
function Target.update()
	if(Target.serial == SITUATION.serial) then
		return Target
	end
	local guid = UnitGUID("target")
	if( guid ~= nil ) then
		if(Target.loaded == nil or Target.guid ~= guid) then
			Target.isFriend = UnitIsFriend("player", "target")
			Target.classification = SITUATION:GetClassification("target")
			Target.creatureType = UnitCreatureType("target")
			Target.creatureFamily = UnitCreatureFamily("target")
			Target.guid = UnitGUID("target")
			Target.name = UnitName("target")
			Target.loaded=true
		end

		Target.serial = SITUATION.serial
		if((Target.serial % 10 == 0) or(Target.refresh) ) then
			Target.UpdateBuffs()
			Target.UpdateDebuffs()
			Target.refresh = false
		end
		return Target
	else
		return nil
	end
end

function Target:DebuffTimeLeft(SpellId)
	return Target.debuffs[SpellId].expirationTime - SITUATION.time.now
end

function Target:DebuffCount(SpellId)
	if( not Target.debuffs[SpellId] ) then
		SITUATION.debug("Debuff not found", SpellId)
		return 0
	end
	return Target.debuffs[SpellId].count
end
-- ======================================================================== --
-- 
-- ======================================================================== --
function Target.UpdateDebuffs()
	for i = 1, Target.debuffcount do
		SpellId = Target.debufflist[i]
		local _, _, _, count, _, duration, expirationTime, unitCaster, _, _, _ = UnitDebuff("target", Target.debuffs[SpellId].name)
		if (expirationTime) then			
			Target.debuffs[SpellId].count=count
			Target.debuffs[SpellId].duration=duration
			Target.debuffs[SpellId].expirationTime = expirationTime
			Target.debuffs[SpellId].timeLeft = expirationTime - SITUATION.time.now
		else
			Target.debuffs[SpellId].count = 0
			Target.debuffs[SpellId].duration = 0
			Target.debuffs[SpellId].expirationTime = 0
		end
	end
end

-- ======================================================================== --
-- 
-- ======================================================================== --
function Target.UpdateBuffs()

end

-- ======================================================================== --
-- Utility Function: 
-- Returns a table containing info on every debuff on the target keyed by
-- SpellId.
-- ======================================================================== --
function Target.GetDebuffList()
	target = "target"
	local buffs = { }
	local i = 1
	local name, rank, icon, count, debuffType, duration, expirationTime, unitCaster, isStealable, shouldConsolidate, spellId = UnitDebuff(target, i)
	while name do
		buffs[spellId] = {}
		buffs[spellId].name=name
		buffs[spellId].icon=icon
		buffs[spellId].count=count
		buffs[spellId].duration=duration
		buffs[spellId].timeLeft = expirationTime - SITUATION.time.now
		i = i + 1
		name, rank, icon, count, debuffType, duration, expirationTime, unitCaster, isStealable, shouldConsolidate, spellId = UnitDebuff(target, i)
	end
	return buffs
end

function Target.health()
	return UnitHealth("target")
end

function Target.healthMax()
	return UnitHealthMax("target")
end
function Target.healthPercent()
	return (Target.health() / Target.healthMax()) * 100
end


-- ======================================================================== --
-- 
-- ======================================================================== --
function Focus.update()
	if(Focus.serial == SITUATION.serial) then
		return Focus
	end
	local guid = UnitGUID("focus")
	if( guid ~= nil ) then
		if(Focus.loaded == nil or Focus.guid ~= guid) then
			Focus.minRange, Focus.maxRange = SITUATION.GetDistance("focus")
			Focus.classification = SITUATION:GetClassification("focus")
			Focus.creatureType = UnitCreatureType("focus")
			Focus.creatureFamily = UnitCreatureFamily("focus")
			Focus.isFriend = UnitIsFriend("player", "focus")
			Focus.guid = guid
			Focus.name = UnitName("focus")
		end
		Focus.serial = SITUATION.serial
		if((Focus.serial % 10 == 0) or(Focus.refresh) ) then
			Focus.UpdateBuffs()
			Focus.UpdateDebuffs()
			Focus.refresh = false
		end
		return Focus
	else
		return nil
	end
end

function Focus:DebuffTimeLeft(SpellId)
	return Focus.debuffs[SpellId].expirationTime - SITUATION.time.now
end

function Focus:DebuffCount(SpellId)
	return Focus.debuffs[SpellId].count
end


-- ======================================================================== --
-- 
-- ======================================================================== --
function Focus.UpdateDebuffs()
	for i = 1, Focus.debuffcount do
		SpellId = Focus.debufflist[i]
		local _, _, _, count, _, duration, expirationTime, unitCaster, _, _, _ = UnitDebuff("focus", Focus.debuffs[SpellId].name)
		if (expirationTime) then
			Focus.debuffs[SpellId].count=count
			Focus.debuffs[SpellId].duration=duration
			Focus.debuffs[SpellId].expirationTime = expirationTime
		else
			Focus.debuffs[SpellId].count = 0
			Focus.debuffs[SpellId].duration = 0
			Focus.debuffs[SpellId].expirationTime = 0
		end
	end
end

-- ======================================================================== --
-- 
-- ======================================================================== --
function Focus.UpdateBuffs()

end

-- ======================================================================== --
-- Utility Function: 
-- Returns a table containing info on every debuff on the target keyed by
-- SpellId.
-- ======================================================================== --
function Focus.GetDebuffList()
	target = "focus"
	local buffs = { }
	local i = 1
	local name, rank, icon, count, debuffType, duration, expirationTime, unitCaster, isStealable, shouldConsolidate, spellId = UnitDebuff(target, i)
	while name do
		buffs[spellId] = {}
		buffs[spellId].name=name
		buffs[spellId].icon=icon
		buffs[spellId].count=count
		buffs[spellId].duration=duration
		buffs[spellId].timeLeft = expirationTime - SITUATION.time.now
		i = i + 1
		name, rank, icon, count, debuffType, duration, expirationTime, unitCaster, isStealable, shouldConsolidate, spellId = UnitDebuff(target, i)
	end
	return buffs
end

function Focus.health()
	return UnitHealth("focus")
end

function Focus.healthMax()
	return UnitHealthMax("focus")
end
function Focus.healthPercent()
	return (Target.health() / Target.healthMax()) * 100
end


-- ======================================================================== --
-- 
-- ======================================================================== --
function Pet.update()
	if(UnitExists("pet") and not UnitIsDead("pet")) then
		if(Pet.serial == SITUATION.serial) then
			return Pet
		end
		Pet.healthMax = UnitHealthMax("pet")
		Pet.health = UnitHealth("pet")
		Pet.healthPercent = (Pet.health / Pet.healthMax) * 100
		Pet.mana = UnitPower("pet")
		Pet.serial = SITUATION.serial
		return Pet
	else
		return nil
	end
end
