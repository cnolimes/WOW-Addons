-- don't load if class is wrong
local _, class = UnitClass("player")
if class ~= "PRIEST" then return end

-- mod name in lower case
local modName = "Shadow"
local version = 1

-- create a module in the main addon
local mod = PA:RegisterClassModule(modName)

-- any error sets this to false
local enabled = true


local ShadowOrbs = 7748
local MindSpikeEffect = 87178
local Evangelism = 87118
local DarkArchangel = 87153
local MindMelt = 81292
local EmpoweredShadows = 95799
local InnerFire = 588
local InnerWill = 73413
local ShadowForm = 15473
local VampiricEmbrace = 15286
		
-- Spells
local DevouringPlague = 2944
local Dispersion = 47585
local MindBlast = 8092
local MindFlay = 15407
local MindSear = 48045
local ShadowFiend = 34433
local ShadowWordPain = 589
local VampiricTouch = 34914
local MindSpike = 73510
local ShadowWordDeath = 32379
local Archangel = 87151

--------------------------------------------------------------------------------
function mod.offgcdrotation(player, target, focus, pet)
	if(enabled) then
		
		if (target.debuffs[MindFlay].timeLeft > PA.ShowDataTimeFactor) then							-- Check if channeling mind flay
			PA:Debug("off gcd - Mind Flay")
			if (target.debuffs[MindFlay].timeLeft > 0.100) then
				PA:SpellDelay(100)
			else
				PA:SpellDelay(20)
			end
		elseif (PA.gcd > PA.ShowDataTimeFactor) then							-- NOT inside spam window
			-- PA:Debug("off gcd - sleeping")
			if ((PA.gcd - PA.ShowDataTimeFactor) > 0.100) then				-- Check Medium Delay
				PA:SpellDelay(100)
			else
				PA:SpellDelay(20)												-- Else Short Delay
			end
		end
	end
end

-- ======================================================================== --
-- Detect Type of Target, and perform rotation appropriate to target type
-- ======================================================================== --
function mod.rotation(player, target, focus, pet)
	if(enabled) then
		-- PA:Debug("gcd - main rotation")
		-- =============== Single Target / focus Logic ==================
		if(target.debuffs[MindFlay].timeLeft > PA.ShowDataTimeFactor) then							-- Check if channeling mind flay
			if (target.debuffs[MindFlay].timeLeft > 0.100) then
				PA:SpellDelay(100)
			else
				PA:SpellDelay(20)
			end
		elseif(player.moving) then
			mod.movingrotation(player, target, focus, pet)
		else
			if(target.classification == "worldboss" or target.classification == "elite") then 					-- PVE Boss / Elite Rotation
				mod.bossrotation(player, target, focus, pet)
			elseif(target.classification == "normal") then						-- Same Level Mob (PVP Rotation is most likely)
				mod.pvprotation(player, target, focus, pet)
			end
		end
	end
end

-- ======================================================================== --
-- Boss Target Rotation
-- ======================================================================== --
function mod.bossrotation(player, target, focus, pet)
	focusCast = false
	if (focus.guid ~= nil and not focus.isFriend and focus.guid ~= target.guid) then	-- Focus Present and is Enemy and is not the target
		PA:Debug("Focus Cast: On")
		focusCast = true
	end
	if((player.buffs[EmpoweredShadows].timeLeft < 1.5) and player.buffs[ShadowOrbs].count > 1 and player.spells[MindBlast].canCast) then
		PA:SpellCast(1, MindBlast)
	elseif (player.buffs[EmpoweredShadows].timeLeft < 6) then
		if (target.debuffs[ShadowWordPain].timeLeft <= 0 ) then										-- Refresh SW:P
			PA:SpellCast(1, ShadowWordPain)
		elseif (target.debuffs[ShadowWordPain].timeLeft > 1.5) then 								-- Refresh SW:P with MF if its going to expire
			PA:SpellCast(1, MindFlay)
		elseif(target.debuffs[VampiricTouch].timeLeft < 3) then										-- Refresh VT
			PA:SpellCast(1, VampiricTouch)
		elseif(focus.debuffs[ShadowWordPain].timeLeft <= 0 and focusCast) then						-- Refresh SW:P on Focus
			PA:FocusCast(1, ShadowWordPain)
		elseif(focus.debuffs[VampiricTouch].timeLeft < 3 and focusCast) then						-- Refresh VT on Focus
			PA:FocusCast(1, VampiricTouch)
		elseif(target.debuffs[DevouringPlague].timeLeft < 2) then 									-- Refresh DP on Target Only
			PA:SpellCast(1, DevouringPlague)
		elseif( (target.healthPercent <  25) and (player.healtPercent > 20) ) then					-- SW:D if safe
			PA:SpellCast(1, ShadowWordDeath)
		elseif( (focus.healthPercent <  25) and (focus.healtPercent > 20) and focusCast ) then		-- SW:D focus if safe
			PA:FocusCast(1, ShadowWordDeath)
		elseif(player.manaPercent < 60 and player.spells[ShadowFiend].cd <= 0) then					-- Fiend
			PA:SpellCast(1, ShadowFiend)
		else																						-- Filler
			PA:SpellCast(1, MindFlay)
		end
	elseif(player.buffs[EmpoweredShadows].timeLeft > 6) then
		if (target.debuffs[ShadowWordPain].timeLeft <= 0 ) then										-- Refresh SW:P
			PA:SpellCast(1, ShadowWordPain)
		elseif (target.debuffs[ShadowWordPain].timeLeft > 1.5) then 								-- Refresh SW:P with MF if its going to expire
			PA:SpellCast(1, MindFlay)
		elseif(target.debuffs[VampiricTouch].timeLeft < 3) then										-- Refresh VT
			PA:SpellCast(1, VampiricTouch)
		elseif(focus.debuffs[ShadowWordPain].timeLeft <= 0 and focusCast) then						-- Refresh SW:P on Focus
			PA:FocusCast(1, ShadowWordPain)
		elseif(focus.debuffs[VampiricTouch].timeLeft < 3  and focusCast) then						-- Refresh VT on Focus
			PA:FocusCast(1, VampiricTouch)
		elseif(target.debuffs[DevouringPlague].timeLeft < 2) then 									-- Refresh DP on Target Only
			PA:SpellCast(1, DevouringPlague)
		elseif( (target.healthPercent <  25) and (player.healtPercent > 20) ) then					-- SW:D if safe
			PA:SpellCast(1, ShadowWordDeath)
		elseif( (focus.healthPercent <  25) and (focus.healtPercent > 20) and focusCast) then		-- SW:D focus if safe
			PA:FocusCast(1, ShadowWordDeath)
		elseif(player.manaPercent < 60 and player.spells[ShadowFiend].cd <= 0) then					-- Fiend
			PA:SpellCast(1, ShadowFiend)
		elseif(player.spells[MindBlast].canCast) then												-- Wont need to refresh emp shadows for a bit
			PA:SpellCast(1, MindBlast)
		else																						-- Filler
			PA:SpellCast(1, MindFlay)
		end
	else
		if(player.buffs[ShadowOrbs].count > 1 and player.spells[MindBlast].canCast) then			-- Setup Empowered Shadows if Possible
			PA:SpellCast(1, MindBlast)
		elseif (target.debuffs[ShadowWordPain].timeLeft <= 0 ) then									-- Refresh SW:P
			PA:SpellCast(1, ShadowWordPain)
		elseif (target.debuffs[ShadowWordPain].timeLeft > 1.5) then 								-- Refresh SW:P with MF if its going to expire
			PA:SpellCast(1, MindFlay)
		elseif(target.debuffs[VampiricTouch].timeLeft < 3) then										-- Refresh VT
			PA:SpellCast(1, VampiricTouch)
		elseif(focus.debuffs[ShadowWordPain].timeLeft <= 0 and focusCast) then						-- Refresh SW:P on Focus
			PA:FocusCast(1, ShadowWordPain)
		elseif(focus.debuffs[VampiricTouch].timeLeft < 3 and focusCast) then					 	-- Refresh VT on Focus
			PA:FocusCast(1, VampiricTouch)
		elseif(target.debuffs[DevouringPlague].timeLeft < 2) then 									-- Refresh DP on Target Only
			PA:SpellCast(1, DevouringPlague)
		elseif( (target.healthPercent <  25) and (player.healtPercent > 20) ) then					-- SW:D if safe
			PA:SpellCast(1, ShadowWordDeath)
		elseif( (focus.healthPercent <  25) and (focus.healtPercent > 20) and focusCast) then		-- SW:D focus if safe
			PA:FocusCast(1, ShadowWordDeath)
		elseif(player.manaPercent < 60 and player.spells[ShadowFiend].cd <= 0) then					-- Fiend
			PA:SpellCast(1, ShadowFiend)
		else
			PA:SpellCast(1, MindFlay)																-- Filler
		end			
	end
end

-- ======================================================================== --
-- Moving Rotation
-- ======================================================================== --
function mod.movingrotation(player, target, focus, pet)
	focusCast = false
	if (focus.guid ~= nil and not focus.isFriend and focus.guid ~= target.guid) then	-- Focus Present and is Enemy and is not the target
		PA:Debug("Focus Cast: On")
		focusCast = true
	end
	if(target.healthPercent < 25 and healthPercent > 50 and player.spells[ShadowWordDeath].canCast) then
		PA:SpellCast(1, ShadowWordDeath)
	elseif( (focus.healthPercent <  25) and (player.healthPercent > 50) and focusCast and player.spells[ShadowWordDeath].canCast) then		-- SW:D focus if safe
		PA:FocusCast(1, ShadowWordDeath)
	elseif(target.debuffs[MindSpikeEffect].count == 2 and player.spells[MindBlast].canCast) then
		PA:SpellCast(1, MindBlast)
	elseif(focus.debuffs[MindSpikeEffect].count == 2 and player.spells[MindBlast].canCast) then
		PA:FocusCast(1, MindBlast)
	elseif(player.healthPercent > 75 and player.spells[ShadowWordDeath].canCast) then
		PA:SpellCast(1, ShadowWordDeath)
	elseif(target.debuffs[ShadowWordPain].timeLeft < 3) then
		PA:SpellCast(1, ShadowWordPain)
	elseif(focus.debuffs[ShadowWordPain].timeLeft < 3 and focusCast) then												-- Refresh SW:P on Focus
		PA:FocusCast(1, ShadowWordPain)
	elseif(target.debuffs[DevouringPlague].timeLeft < 3 and focus.debuffs[DevouringPlague].timeLeft <= 0) then 			-- Refresh DP on Target Only
		PA:SpellCast(1, DevouringPlague)
	else
		PA:SpellCast(1, DevouringPlague)
	end
end

-- ======================================================================== --
-- PVP and Normal Target Rotation
-- ======================================================================== --
function mod.pvprotation(player, target, focus, pet)
	focusCast = false
	if (focus.guid ~= nil and not focus.isFriend and focus.guid ~= target.guid) then	-- Focus Present and is Enemy and is not the target
		PA:Debug("Focus Cast: On")
		focusCast = true
	end
	focusCast = false
	if(target.healthPercent < 25 and player.healthPercent > 50 and player.spells[ShadowWordDeath].canCast) then
		PA:SpellCast(1, ShadowWordDeath)
	elseif( (focus.healthPercent <  25) and (player.healthPercent > 50) and focusCast and player.spells[ShadowWordDeath].canCast) then		-- SW:D focus if safe
		PA:FocusCast(1, ShadowWordDeath)
	elseif(player.buffs[ShadowOrbs].count > 1 and player.spells[MindBlast].canCast) then		-- Setup Empowered Shadows if Possible
		PA:SpellCast(1, MindBlast)
	elseif( target.debuffs[ShadowWordPain].timeLeft <= 0 ) then									-- Refresh SW:P
		PA:SpellCast(1, ShadowWordPain)
	elseif(target.debuffs[ShadowWordPain].timeLeft > 1.5) then 									-- Refresh SW:P with MF if its going to expire
		PA:SpellCast(1, MindFlay)
	elseif(target.debuffs[VampiricTouch].timeLeft < 3) then										-- Refresh VT
		PA:SpellCast(1, VampiricTouch)
	elseif(focus.debuffs[ShadowWordPain].timeLeft <= 0 and focusCast) then						-- Refresh SW:P on Focus
		PA:FocusCast(1, ShadowWordPain)
	elseif(focus.debuffs[VampiricTouch].timeLeft < 3 and focusCast) then					 	-- Refresh VT on Focus
		PA:FocusCast(1, VampiricTouch)
	elseif(target.debuffs[DevouringPlague].timeLeft < 2) then 									-- Refresh DP on Target Only
		PA:SpellCast(1, DevouringPlague)
	else
		PA:SpellCast(1, MindFlay)																-- Filler
	end
end

function mod.statusUpdate()
	-- PAUI:Status1(PA.target.classification .. " THp:" .. string.format("%.2f", PA.target.healthPercent) .. " PHp:" .. string.format("%.2f", PA.player.healthPercent) )
	PAUI:Status2("SORBc:" .. PA.player.buffs[ShadowOrbs].count)
	PAUI:Status3("SWPtl: " .. string.format("%.2f", PA.target.debuffs[ShadowWordPain].timeLeft) .. " VTtl: " .. string.format("%.2f", PA.target.debuffs[VampiricTouch].timeLeft))
	PAUI:Status4("DPtl: " .. string.format("%.2f", PA.target.debuffs[DevouringPlague].timeLeft) .. " MSEtl: " .. PA.target.debuffs[MindSpikeEffect].count)
	PAUI.Status5("SWDcd: " .. string.format("%.2f", PA.player.spells[ShadowWordDeath].cd) .. " MBcd: " .. string.format("%.2f", PA.player.spells[MindBlast].cd))
	PAUI.Status6("EMPStl: " .. string.format("%.2f", PA.player.buffs[EmpoweredShadows].timeLeft) .. " FIENDcd: " .. string.format("%.2f", PA.player.spells[ShadowFiend].cd))	
end


function mod.OnInitialize()
	mod.checkSpec()
	if (enabled) then
		-- Buff	
		PA:AddSpell(1, MindBlast)
		PA:AddSpell(2, MindFlay)
		PA:AddSpell(3, VampiricTouch)
		PA:AddSpell(4, ShadowWordPain)
		PA:AddSpell(5, DevouringPlague)
		PA:AddSpell(6, ShadowWordDeath)
		PA:AddSpell(7, MindSpike)
		PA:AddSpell(8, MindSear)
		PA:AddSpell(9, ShadowFiend)
		PA:AddSpell(10, Archangel)
		
		PA:AddBuff(ShadowOrbs)
		PA:AddBuff(Evangelism)
		PA:AddBuff(DarkArchangel)
		PA:AddBuff(MindMelt)
		PA:AddBuff(EmpoweredShadows)
		PA:AddBuff(InnerFire)
		PA:AddBuff(InnerWill)
		PA:AddBuff(ShadowForm)
		PA:AddBuff(VampiricEmbrace)
		
		PA:AddTargetDebuff(DevouringPlague)
		PA:AddTargetDebuff(ShadowWordPain)
		PA:AddTargetDebuff(VampiricTouch)
		PA:AddTargetDebuff(MindFlay)
		PA:AddTargetDebuff(MindSpikeEffect)
		
		PA:AddFocusDebuff(DevouringPlague)
		PA:AddFocusDebuff(ShadowWordPain)
		PA:AddFocusDebuff(VampiricTouch)

		-- ==================== REGISTER ROTATION ==============================
		PA:setOffGCDRotation(mod.offgcdrotation, modName)
		PA:setRotation(mod.rotation, modName)
		PA:SetStatusUpdate(mod.statusUpdate)
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