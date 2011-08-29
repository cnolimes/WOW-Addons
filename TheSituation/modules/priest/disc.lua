-- don't load if class is wrong
local _, class = UnitClass("player")
if class ~= "PRIEST" then return end

-- mod name in lower case
local modName = "Disc"
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


function mod.rotation(player, target, focus, pet)
	if(enabled) then
		-- PA:Debug("gcd - main rotation")
		-- =============== Single Target / focus Logic ==================
		focusCast = false
		if (focus ~= nil and not focus.isFriend and focus.guid ~= target.guid) then	-- Focus Present and is Enemy and is not the target
			PA:SetText("Focus Cast: On")
			focusCast = true
		end
	end
end

function mod.OnInitialize()
	mod.checkSpec()
	if (enabled) then
		PA:RegisterGCDSpell("Mind Blast")
		-- Buff	
		PA:AddSpell(1, MindBlast)
		PA:AddSpell(4, ShadowWordPain)
		PA:AddSpell(5, DevouringPlague)
		PA:AddSpell(6, ShadowWordDeath)
		PA:AddSpell(7, MindSpike)
		PA:AddSpell(8, MindSear)
		PA:AddSpell(9, ShadowFiend)
		

		PA:AddBuff(InnerFire)
		PA:AddBuff(InnerWill)

		
		PA:AddTargetDebuff(DevouringPlague)
		PA:AddTargetDebuff(ShadowWordPain)
		
		PA:AddFocusDebuff(DevouringPlague)
		PA:AddFocusDebuff(ShadowWordPain)

		-- ==================== REGISTER ROTATION ==============================
		PA:setOffGCDRotation(mod.offgcdrotation, modName)
		PA:setRotation(mod.rotation, modName)
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