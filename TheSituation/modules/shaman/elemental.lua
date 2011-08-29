-- don't load if class is wrong
local _, class = UnitClass("player")
if class ~= "SHAMAN" then return end

-- mod name in lower case
local modName = "Elemental"
local version = 1

--================== Initialize Variables =====================
local Spell1 				= nil
local Spell2 				= nil
local Spell3 				= nil

-- create a module in the main addon
local mod = PA:RegisterClassModule(modName)

-- any error sets this to false
local enabled = true

--================== Initialize Spec Variables =====================
local StartTime					= GetTime()
local InterruptFinish			= StartTime
local LavaBurstFinish			= StartTime
local FlameShockFinish			= StartTime
local UnleashElementsFinish		= StartTime
local FireNovaFinish			= StartTime
local ChainLightningFinish		= StartTime

local FlameShockRefreshTime		= 3
--------------------------------------------------------------------------------


function mod.rotation(StartTime, GCDTimeLeft)
	if(enabled) then		
		Mana = UnitPower("player")	
		MaxMana = UnitManaMax("player")
		ManaPercent = Mana / MaxMana

		FlameShockCD, FlameShockFinish 			= PA:GetActualSpellCD(FlameShockFinish, "Flame Shock")
		EarthShockCD = FlameShockCD
		LavaBurstCD, LavaBurstFinish 			= PA:GetActualSpellCD(LavaBurstFinish, "Lava Burst")
		FireNovaCD, FireNovaFinish 				= PA:GetActualSpellCD(FireNovaFinish, "Fire Nova")
		ChainLightningCD, ChainLightningFinish 	= PA:GetActualSpellCD(ChainLightningFinish, "Chain Lightning")
		UnleashElementsCD, UnleashElementsFinish = PA:GetActualSpellCD(UnleashElementsFinish, "Unleash Elements")
		
		UnleashFlameCount		= PA:GetBuffCount("Unleash Flame")
		LightningShieldCount	= PA:GetBuffCount("Lightning Shield")
		
		FlameShockDebuffCD		= PA:GetTargetDebuff("Flame Shock")
		EarthShockDebuffCD		= PA:GetTargetDebuff("Earth Shock")

		
		-- ============================ Fire Totem ===========================
		-- Outputs:
		-- FireTotem Check
		--------------------------------------
		FireTotemCD = FireTotemNeeded()

		-- ============================= Single Target =========================
		if(FireTotemCD <= PA.ShowDataTimeFactor) then
			Spell1 = SearingTotem
		elseif(FlameShockDebuffCD <= FlameShockRefreshTime and FlameShockCD == 0) then
			Spell1 = FlameShock
		elseif(LavaBurstCD == 0) then
			PA:SetTitle("LBurst")
			Spell1 = LavaBurst
		elseif( LightningShieldCount > 6 and EarthShockCD == 0) then
			PA:SetTitle("ES")
			Spell1 = EarthShock
		elseif(UnleashElementsCD == 0 and PA.Toggle_Do_3) then
			PA:SetTitle("UE")
			Spell1 = UnleashElements
		else
			Spell1 = LightningBolt
		end
		
		
		-- ============================= Multi Target =========================
		if(FireTotemCD == 0) then
			Spell2 = SearingTotem
		elseif(FlameShockCD == 0) then
			Spell2 = FlameShock			
		elseif(FireNovaCD == 0) then
			Spell2 = FireNova
		elseif(LavaLashCD == 0) then
			Spell2 = LavaLash
		elseif(MaelstromWeaponCount == 5 and PA.Toggle_Do_3) then
			Spell2 = ChainLightning
		elseif(UnleashElementsCD == 0) then
			Spell2 = UnleashElements
		elseif(StormStrikeCD == 0) then
			Spell2 = StormStrike
		elseif(FeralSpiritCD == 0 and PA.Toggle_Do_1 ) then
			Spell2 = FeralSpirit
		elseif(FireTotemCD < 10 and PA.Toggle_Do_2 == false) then
			Spell2 = SearingTotem
		else
			Spell2 = LightningBolt
		end
		
		PA:SpellFire(Spell1, Spell2, Spell3)
	end
end

function FireTotemNeeded()
	-- only bother checking for totem availabilty if we have a GCD
	local _, totemname, start, duration = GetTotemInfo(1)
	if totemname == nil or totemname == "" then -- no fire totem deployed so recommend it be dropped
		return 0
	end
	return start + duration - GetTime()
end

function mod.OnInitialize()
	mod.checkSpec()
	if (enabled) then
		PA:Print("Initializing Elemental Shamman")
		PA:SetToggle(1, 1, "Searing Totem")		
		PA:SetToggle(2, 1, "Fire Elemental Totem")
		PA:SetToggle(3, 1, "Unleash Elements")
		PA:SetToggle(4, 1, "Wind Shear")
		
		PA:RegisterGCDSpell("Lightning Bolt")
		PA:RegisterRangeSpell("Wind Shear")
		
		LightningBolt	= PA:RegisterSpell(1, "Lightning Bolt")
		ChainLightning	= PA:RegisterSpell(2, "Chain Lightning")
		FlameShock		= PA:RegisterSpell(3, "Flame Shock")
		EarthShock		= PA:RegisterSpell(4, "Earth Shock")
		FireNova 		= PA:RegisterSpell(5, "Fire Nova")
		UnleashElements	= PA:RegisterSpell(6, "Unleash Elements")
		LavaBurst	 	= PA:RegisterSpell(7, "Lava Burst")
		FireNova 		= PA:RegisterSpell(8, "Spiritwalker's Grace")
		ThunderStorm	= PA:RegisterSpell(9, "Thunderstorm")
		SearingTotem 	= PA:RegisterSpell(10, "Searing Totem")
		FireElemental	= PA:RegisterSpell(11, "Fire Elemental Totem")
		WindShear 		= PA:RegisterSpell(12, "Wind Shear")
		
		-- ==================== REGISTER ROTATION ==============================
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