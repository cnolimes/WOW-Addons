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
local mod = WA:RegisterClassModule(modName)

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

		FlameShockCD, FlameShockFinish 			= WA:GetActualSpellCD(FlameShockFinish, "Flame Shock")
		EarthShockCD = FlameShockCD
		LavaBurstCD, LavaBurstFinish 			= WA:GetActualSpellCD(LavaBurstFinish, "Lava Burst")
		FireNovaCD, FireNovaFinish 				= WA:GetActualSpellCD(FireNovaFinish, "Fire Nova")
		ChainLightningCD, ChainLightningFinish 	= WA:GetActualSpellCD(ChainLightningFinish, "Chain Lightning")
		UnleashElementsCD, UnleashElementsFinish = WA:GetActualSpellCD(UnleashElementsFinish, "Unleash Elements")
		
		UnleashFlameCount		= WA:GetBuffCount("Unleash Flame")
		LightningShieldCount	= WA:GetBuffCount("Lightning Shield")
		
		FlameShockDebuffCD		= WA:GetTargetDebuff("Flame Shock")
		EarthShockDebuffCD		= WA:GetTargetDebuff("Earth Shock")

		
		-- ============================ Fire Totem ===========================
		-- Outputs:
		-- FireTotem Check
		--------------------------------------
		FireTotemCD = FireTotemNeeded()

		-- ============================= Single Target =========================
		if(FireTotemCD <= WA.ShowDataTimeFactor) then
			Spell1 = SearingTotem
		elseif(FlameShockDebuffCD <= FlameShockRefreshTime and FlameShockCD == 0) then
			Spell1 = FlameShock
		elseif(LavaBurstCD == 0) then
			WA:SetTitle("LBurst")
			Spell1 = LavaBurst
		elseif( LightningShieldCount > 6 and EarthShockCD == 0) then
			WA:SetTitle("ES")
			Spell1 = EarthShock
		elseif(UnleashElementsCD == 0 and WA.Toggle_Do_3) then
			WA:SetTitle("UE")
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
		elseif(MaelstromWeaponCount == 5 and WA.Toggle_Do_3) then
			Spell2 = ChainLightning
		elseif(UnleashElementsCD == 0) then
			Spell2 = UnleashElements
		elseif(StormStrikeCD == 0) then
			Spell2 = StormStrike
		elseif(FeralSpiritCD == 0 and WA.Toggle_Do_1 ) then
			Spell2 = FeralSpirit
		elseif(FireTotemCD < 10 and WA.Toggle_Do_2 == false) then
			Spell2 = SearingTotem
		else
			Spell2 = LightningBolt
		end
		
		WA:SpellFire(Spell1, Spell2, Spell3)
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
		WA:Print("Initializing Elemental Shamman")
		WA:SetToggle(1, 1, "Searing Totem")		
		WA:SetToggle(2, 1, "Fire Elemental Totem")
		WA:SetToggle(3, 1, "Unleash Elements")
		WA:SetToggle(4, 1, "Wind Shear")
		
		WA:RegisterGCDSpell("Lightning Bolt")
		WA:RegisterRangeSpell("Wind Shear")
		
		LightningBolt	= WA:RegisterSpell(1, "Lightning Bolt")
		ChainLightning	= WA:RegisterSpell(2, "Chain Lightning")
		FlameShock		= WA:RegisterSpell(3, "Flame Shock")
		EarthShock		= WA:RegisterSpell(4, "Earth Shock")
		FireNova 		= WA:RegisterSpell(5, "Fire Nova")
		UnleashElements	= WA:RegisterSpell(6, "Unleash Elements")
		LavaBurst	 	= WA:RegisterSpell(7, "Lava Burst")
		FireNova 		= WA:RegisterSpell(8, "Spiritwalker's Grace")
		ThunderStorm	= WA:RegisterSpell(9, "Thunderstorm")
		SearingTotem 	= WA:RegisterSpell(10, "Searing Totem")
		FireElemental	= WA:RegisterSpell(11, "Fire Elemental Totem")
		WindShear 		= WA:RegisterSpell(12, "Wind Shear")
		
		-- ==================== REGISTER ROTATION ==============================
		WA:setRotation(mod.rotation, modName)
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