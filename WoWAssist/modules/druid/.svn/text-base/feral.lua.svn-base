-- don't load if class is wrong
local _, class = UnitClass("player")
if class ~= "DRUID" then return end

-- mod name in lower case
local modName = "Feral"
local version = 1

--================== Initialize Variables =====================
local Spell1 = nil
local Spell2 = nil
local Spell3 = nil

-- create a module in the main addon
local mod = WA:RegisterClassModule(modName)
local db

local shreds_on_rips = {}

local spellcost = {}
local L = {}


-- any error sets this to false
local enabled = true


-- this function, if it exists, will be called at init
function mod.OnInitialize()
	db = WA:RegisterClassModuleDB(modName, defaults)
end


--================== Initialize Spec Variables =====================
local StartTime					= GetTime()
local BloodTapFinish 			= StartTime
local HornOfWinterFinish 		= StartTime
local DeathAndDecayFinish		= StartTime
local FrostStrikeCost			= 40



function mod.rotation(StartTime, GCDTimeLeft)
	if (enabled) then
		UpdateAbilityCost()
		
		state = {}
		state.boss_target 		= (UnitLevel("target") == -1)
		state.fffBuff 			= WA:GetArmorDebuff()
		state.fff 				= WA:GetCooldown("Faerie Fire (Feral)")
		state.OoC 				= WA:GetBuff("Clearcasting")
		state.berserk 			= WA:GetCooldown("Berserk")
		state.berserkBuff 		= WA:GetBuff("Berserk")
		state.GCD 				= GCDTimeLeft
		state.target_health 	= WA:GetTargetHealthPercentage()
		state.stampede1 		= WA:GetBuff(78892)
		state.stampede2 		= WA:GetBuff(78893)
		stampede = state.stampede2 + state.stampede1
		
		if(isCat()) then
			WA:SetTitle("Cat")
			state.energy 		= UnitPower("player", 3)
			state.cp 			= GetComboPoints("player")
			OoC = 0;
			state.rake 			= WA:GetTargetDebuff("Rake")
			state.rip			= WA:GetTargetDebuff("Rip")
			-- Checks only Trauma. Blood Frenzy is the buff on warrior, not the debuff!
			state.mangle 		= WA:GetTraumaDebuff()
			state.sr 			= WA:GetBuff("Savage Roar")        
			state.tf 			= WA:GetCooldown("Tiger's Fury")
			state.tfBuff 		= WA:GetBuff("Tiger's Fury")
			state.ER 			= 10 * (1 + GetCombatRating(18) / 3279)
			state.can_extend_rip = 0
			
			
			if shreds_on_rip then 
				state.can_extend_rip = 3 - shreds_on_rip
			end
			
		    if (state.OoC > 1) then OoC = 1 end
		
			--
			-- Single Target Rotation
			-- 
			if (state.tf == 0 and state.energy < 35) then
				WA:SetTitle("E<35: Tiger's Fury")
				Spell1 = TigersFury
			-- keep Faerie Fire up, maximum priority since it boosts damage of every melee/hunter and tank threat generation
			elseif (state.boss_target and state.fff == 0 and state.fffBuff < 3 ) then 
				WA:SetTitle("NoFFF: Feral Faerie Fire")
				Spell1 = FFF
			elseif (state.mangle < 2 and  state.energy > spellcost.mangle_cat) then
				WA:SetTitle("Trauma: Mangle")
				Spell1 = Mangle
			-- below 25%, rip about to fall off, at least 1 cp --> FB
			elseif (state.cp > 0 and state.target_health < 0.25 and state.rip < 3 and state.rip > 0 and state.energy > spellcost.ferociousbite ) then
				WA:SetTitle("Rip: Ferocious Bite")
				Spell1 = FerociousBite
			elseif (state.cp == 5 and state.target_health < 0.25 and state.rip > 1 and state.energy > spellcost.ferociousbite) then 
				WA:SetTitle("5CP: Ferocious Bite")
				Spell1 = FerociousBite
			elseif (state.can_extend_rip > 0 and state.rip < 4  and state.rip > 0 and not (state.target_health < 0.25) and state.energy > spellcost.shred) then 
				WA:SetTitle("ER: Shred")
				Spell1 =  Shred
			elseif (state.cp == 5 and state.rip < 3 and (state.berserkBuff > 0 or state.rip <= state.tf) and state.energy > spellcost.rip) then
				WA:SetTitle("5CP: Rip")
				Spell1 = Rip
			elseif (state.rake < 9 and state.tfBuff > 0 and  state.energy > spellcost.rake) then 
				WA:SetTitle("TF: Rake")
				Spell1 = Rake
			elseif (state.rake < 3 and (state.berserkBuff > 0 or state.rake - 0.8 <= state.tf or state.energy > 71) and state.energy > spellcost.rake) then
				WA:SetTitle("Rake: Rake")
				Spell1 = Rake
			elseif (OoC == 1) then
				WA:SetTitle("OOC: Shred")
				Spell1 = Shred
			elseif (state.cp > 0 and state.sr < 3 and state.rip > 6 and state.energy > spellcost.sr) then 
				WA:SetTitle("SR: Savage Roar")
				Spell1 = SavageRoar
			elseif (state.cp == 5 and state.rip < 12 and math.abs(state.rip - state.sr) < 3 and state.energy > spellcost.sr) then 
				WA:SetTitle("5CP: SR")
				Spell1 = SavageRoar
			elseif (OoC == 0 and stampede > 0 and state.tfBuff > 0 and state.energy > spellcost.ravage) then
				WA:SetTitle("ST: Ravage")
				Spell1 = Ravage
			elseif (state.cp < 5 and state.rake > 3  and state.rip > 3 and (state.energy > 80 or (state.berserkBuff > 0 and state.energy > 20)) and state.energy > spellcost.shred) then
				WA:SetTitle("Shred")
				Spell1 = Shred
			elseif (state.tf < 3  or (state.cp == 0 and (state.sr < 2 or state.rake > 5)) and state.energy > spellcost.shred) then
				WA:SetTitle("Shred")
				Spell1 = Shred
			elseif (state.rip == 0 or state.energy > 90 or state.berserkBuff > 0 and state.energy > spellcost.shred) then 
				WA:SetTitle("Shred")
				Spell1 = Shred
			else
				Spell1 = WA.Delay20
			end
			
			--
			-- AOE Rotation
			-- 
			if (state.tf == 0 and state.energy < 35 and state.berserkBuff == 0) then
				Spell2 = TigersFury
			-- keep Faerie Fire up, maximum priority since it boosts damage of every melee/hunter and tank threat generation
			elseif (state.boss_target and state.fff == 0 and state.fffBuff < 3 ) then 
				Spell2 = FFF
			elseif (OoC == 1) then 
				Spell2 = Swipe
			elseif(state.energy > spellcost.swipe_cat) then
				Spell2 = Swipe
			else
				Spell2 = WA.Delay20
			end
		
			WA:SpellFire(Spell1, Spell2, Spell3)
		elseif(isBear()) then
			WA:SetTitle("Bear")
			DebuffCount = 0
			state.rage 				= UnitPower("player", 1)
			state.lacerate 			= WA:GetTargetDebuff(33745)

			if not UnitDebuff("target","Lacerate",nil, "PLAYER") then
				state.lacerate_stack 	= 0
				WA:SetText("No Lac")
			else
				local name, _, _, stackCount, _, _, expirationTime, caster = UnitDebuff("target", "Lacerate",nil, "PLAYER");
				state.lacerate_stack 	= stackCount
				WA:SetText("LC: " .. state.lacerate_stack)
			end
			--state.lacerate_stack 	= WA:GetTargetDebuffStacks(33745)
			state.pulverize 		= WA:GetBuff(80313)        
			state.demoshout 		= WA:GetAttackPowerDebuff()
			_, state.tanking_status = UnitDetailedThreatSituation("player","target")
			state.mangle_bear 		= WA:GetCooldown(33878)
			state.swipe 			= WA:GetCooldown(779)
			state.thrash			= WA:GetCooldown(77758)
			

			-- We are targeting (tanking) boss and demoshout is not on. Apply it as it significantly reduces the boss' damage.
			if (state.demoshout < 3 and state.boss_target and state.tanking_status == 3 and state.rage > spellcost.demoshout) then
				WA:SetTitle("Demo Roar")
				Spell1 = DemoRoar
			-- Mangle is ready after this GCD.
			elseif (state.mangle_bear == 0 and state.rage > spellcost.mangle_bear) then
				WA:SetTitle("Mangle")
				Spell1 = MangleBear
			-- FF on target if not apply it.
			elseif (state.fffBuff <= 6 and state.fff == 0) then
				WA:SetTitle("Feral Faerie Fire")
				Spell1 = FFF      
			-- Pulverize less than 3 second and Lacerate = 3 stacks refresh it
			elseif (state.pulverize <= 3 and state.lacerate_stack >= 3) then
				WA:SetTitle("L3: Pulverize")
				Spell1 = Pulverize
			-- Lacerate has not 1 stacks apply it.
			elseif (state.lacerate_stack < 1) then
				WA:SetTitle("L<3: Lacerate")
				Spell1 = Lacerate
			-- Faerie Fire is ready after this GCD and rage is low use FFF. 
			elseif (state.fff == 0 and state.rage < 25) then
				WA:SetTitle("FFF Rage Starved")
				Spell1 = FFF
			-- Lacerate has not 3 stacks or is about to fall off in this or next Mangle-FF cycle. Refresh it.
			elseif (state.lacerate <= 4.5 or state.lacerate_stack < 3) then
				WA:SetTitle("Refresh Lacerate")
				Spell1 = Lacerate
			-- Faerie Fire is ready after this GCD use as filler
			elseif (state.fff == 0) then
				WA:SetTitle("FFF Bored")
				Spell1 = FFF
			elseif (state.demoshout < 3 and st_boss_target) then
				WA:SetTitle("Demo Roar, Bored")
				Spell1 = DemoRoar
			elseif (state.thrash == 0 and state.rage > spellcost.thrash) then
				WA:SetTitle("Thrash")
				Spell1 = Thrash
			elseif (state.swipe == 0) then
				WA:SetTitle("Swipe")
				Spell1 = SwipeBear
			else
				Spell1 = WA.Delay20
			end
		
		
		
		end
		WA:SpellFire(Spell1, Spell2, Spell3)
	end
end




-- Realtime ability cost update.
function UpdateAbilityCost()
    spellcost.mangle_cat      	= GetPowerCost(33876)
	spellcost.swipe_cat		  	= GetPowerCost(62078)
    spellcost.shred           	= GetPowerCost(5221)
    spellcost.rake            	= GetPowerCost(1822)
    spellcost.rip             	= GetPowerCost(1079)
    spellcost.sr              	= GetPowerCost(52610)
    spellcost.ferociousbite   	= GetPowerCost(22568)
    spellcost.mangle_bear     	= GetPowerCost(33878)
    spellcost.lacerate        	= GetPowerCost(33745)
    spellcost.pulverize       	= GetPowerCost(80313)
    spellcost.demoshout       	= GetPowerCost(99)
    spellcost.swipe         	= GetPowerCost(779)
    spellcost.ravage          	= GetPowerCost(6785)
	spellcost.maul				= GetPowerCost(48480)
	spellcost.thrash			= GetPowerCost(77758)
end

function GetPowerCost(spellName)
    local _, _, _, powerCost = GetSpellInfo(spellName)
    return powerCost
end


function mod.OnInitialize()
	mod.checkSpec()
	if (enabled) then
		WA:Print("Initializing Feral")
		WA:SetToggle(1, 0, "Faerie Fire (Feral)")		
		WA:SetToggle(2, 0, "Berserk")
		-- WA:SetToggle(3, 1, nil)
		WA:SetToggle(4, 0, "Skull Bash(Cat)")
		WA.GCD_Duration	= 1.0
		
		WA:RegisterRangeSpell("Faerie Fire (Feral)")
		
		-- ==================== REGISTER SPELL COLORS ==============================
		Shred					= WA:RegisterSpell(1, "Shred")
		Mangle					= WA:RegisterSpell(2, "Mangle")
		Rake					= WA:RegisterSpell(3, "Rake")
		Ravage					= WA:RegisterSpell(4, "Ravage")
		Rip						= WA:RegisterSpell(5, "Rip")
		Swipe					= WA:RegisterSpell(6, "Swipe(Cat Form)")
		FericousBite			= WA:RegisterSpell(7, "Ferocious Bite")
		SavageRoar				= WA:RegisterSpell(8, "Savage Roar")		
		TigersFury				= WA:RegisterSpell(9, "Tiger's Fury")
		FFF						= WA:RegisterSpell(10, "Faerie Fire (Feral)")
		SkullBash				= WA:RegisterSpell(11, "Skull Bash")
		
		Pulverize				= Shred
		Lacerate				= Rake

		-- ==================== REGISTER ROTATION ==============================
		WA:setRotation(mod.rotation, "Feral")
	end
end


function isCat()
	stance = GetShapeshiftForm();
	if(stance == 3) then
		return true
	else
		return false
	end
end


function isBear()
	stance = GetShapeshiftForm();
	if(stance == 1) then
		return true
	else
		return false
	end
end



function getTargetHealthPercentage() 
    local target_health_max = UnitHealthMax("target")
          
    if (target_health_max > 0) then
        return UnitHealth("target") / target_health_max
    else
        -- maximum health
        return 1.0
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
