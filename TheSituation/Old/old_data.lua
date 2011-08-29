
-- ======================================================================== --
-- TODO: Consider Removing
-- OLD:
-- Return Target Health Percentage, now available on the target object
-- ======================================================================== --
function SITUATION.GetTargetHealthPercentage() 
    local target_health_max = UnitHealthMax("target")         
    if (target_health_max > 0) then
        return UnitHealth("target") / target_health_max
    else
        -- maximum health
        return 1.0
    end
end

-- ======================================================================== --
-- TODO: Consider Removing
-- OLD
-- Returns the cooldown of a spellId
-- ======================================================================== --
function SITUATION.GetCooldown(id)
	local start, duration = GetSpellCooldown(id)
	local cd = start + duration - SITUATION.time.now - SITUATION.time.gcd
	if cd < 0 then return 0 end
	return cd
end

-- ======================================================================== --
-- TODO: Consider Removing
-- OLD
-- Returns the count count of the number of buffs by name
-- ======================================================================== --
function SITUATION.GetBuffCount(buff)
	local BuffName, BuffCount, BuffExpirationTime
	BuffName, _, _,BuffCount, _, _, BuffExpirationTime, _, _, _, _ = UnitBuff("player", buff) 
	if (BuffName == nil) then
		BuffCount = 0
	end
	return BuffCount
end

-- ======================================================================== --
-- TODO: Consider Removing
-- OLD
-- Returns the time left for a buff on the player by name
-- ======================================================================== --
function SITUATION.GetBuff(buff)
	local left
	_, _, _, _, _, _, expires = UnitBuff("player", buff, nil, "PLAYER")
	if expires then
		left = expires - SITUATION.time.now - SITUATION.time.gcd
		if left < 0 then left = 0 end
	else
		left = 0
	end
	return left
end

-- ======================================================================== --
-- TODO: Consider Removing
-- OLD
-- Returns the time left for a buff on the players pet by name
-- ======================================================================== --
function SITUATION.GetPetBuff(buff)
	local left
	_, _, _, _, _, _, expires = UnitBuff("pet", buff, nil, "PLAYER")
	if expires then
		left = expires - SITUATION.time.now - SITUATION.time.gcd
		if left < 0 then left = 0 end
	else
		left = 0
	end
	return left
end

-- ======================================================================== --
-- TODO: Consider Removing
-- OLD
-- Returns the buff count for a buff on a pet by name
-- ======================================================================== --
function SITUATION.GetPetBuffCount(buff)
	local BuffName, BuffCount
	BuffName, _, _,BuffCount, _, _, _, _, _, _, _ = UnitBuff("pet", buff) 
	if (BuffName == nil) then
		BuffCount = 0
	end
	return BuffCount
end

-- ======================================================================== --
-- TODO: Consider Removing
-- OLD
-- Returns a debuff time left on the target by name
-- ======================================================================== --
function SITUATION.GetTargetDebuff(debuff)
	DebuffName, _, _, _, _, DebuffDuration, DebuffExpiration, DebuffUnitCaster, _ = UnitDebuff("target", debuff)
	if (DebuffName ~= nil) then
		DebuffTimeLeft = DebuffExpiration - SITUATION.time.now
	else
		DebuffTimeLeft = 0
	end	
	return DebuffTimeLeft
end

-- ======================================================================== --
-- TODO: Consider Removing
-- OLD
-- Returns the stacks of a debuff on the target by name
-- ======================================================================== --
function SITUATION.GetTargetDebuffStacks(debuff)
	DebuffName, _, _,DebuffCount, _, _, DebuffExpiration, _, _, _, _ = UnitDebuff("target", debuff) 
	if (DebuffName ~= nil) then
		DebuffCount = 0
	end
	return DebuffCount
end

-- ======================================================================== --
-- TODO: Consider Removing
-- OLD
-- Returns the time left on a debuff on your focus
-- ======================================================================== --
function SITUATION:GetFocusDebuff(debuff)
	DebuffName, _, _, _, _, DebuffDuration, DebuffExpirationTime, UnitCaster, _ = UnitDebuff("focus", debuff)
	DebuffCD = 0
	if (DebuffName ~= nil and UnitCaster == "player") then
		DebuffNameCD = DebuffExpirationTime - SITUATION.time.now
	end
	return DebuffCD
end

