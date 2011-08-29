-- don't load if class is wrong
local _, class = UnitClass("player")
if class ~= "SHAMAN" then return end

-- mod name in lower case
local modName = "Enhancement"
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
local FeralSpiritFinish			= StartTime
local StormStrikeFinish			= StartTime
local LavaLashFinish			= StartTime
local FlameShockFinish			= StartTime
local UnleashElementsFinish		= StartTime
local FireNovaFinish			= StartTime
local ChainLightningFinish		= StartTime

--------------------------------------------------------------------------------


function mod.rotation(StartTime, GCDTimeLeft)
	if(enabled) then		
		Mana = UnitPower("player")	
		MaxMana = UnitManaMax("player")
		ManaPercent = Mana / MaxMana

		FeralSpiritCD, FeralSpiritFinish 		= PA:GetActualSpellCD(FeralSpiritFinish, "Feral Spirit")
		StormStrikeCD, StormStrikeFinish 		= PA:GetActualSpellCD(StormStrikeFinish, "Stormstrike")
		LavaLashCD, LavaLashFinish 				= PA:GetActualSpellCD(LavaLashFinish, "Lava Lash")
		FlameShockCD, FlameShockFinish 			= PA:GetActualSpellCD(FlameShockFinish, "Flame Shock")
		EarthShockCD = FlameShockCD
		FireNovaCD, FireNovaFinish 				= PA:GetActualSpellCD(FireNovaFinish, "Fire Nova")
		ChainLightningCD, ChainLightningFinish 	= PA:GetActualSpellCD(ChainLightningFinish, "Chain Lightning")
		UnleashElementsCD, UnleashElementsFinish = PA:GetActualSpellCD(UnleashElementsFinish, "Unleash Elements")
		
		MaelstromWeaponCount	= PA:GetBuffCount("Maelstrom Weapon")
		UnleashWindCount		= PA:GetBuffCount("Unleash Wind") 
		UnleashFlameCount		= PA:GetBuffCount("Unleash Flame")
		
		FlameShockDebuffCD		= PA:GetTargetDebuff("Flame Shock")
		EarthShockDebuffCD		= PA:GetTargetDebuff("Earth Shock")
		PA:SetText("FS:" .. FlameShockDebuffCD .. " ES:" .. EarthShockDebuffCD)

		
		-- ============================ Fire Totem ===========================
		-- Outputs:
		-- FireTotem Check
		--------------------------------------
		FireTotemCD = FireTotemNeeded()

		-- ============================= Single Target =========================
		if(FireTotemCD == 0) then
			Spell1 = SearingTotem
		elseif(LavaLashCD == 0) then
			Spell1 = LavaLash
		elseif(UnleashFlameCount > 0 and FlameShockCD == 0) then
			Spell1 = FlameShock
		elseif(MaelstromWeaponCount == 5 and PA.Toggle_Do_2) then
			Spell1 = LightningBolt
		elseif(UnleashElementsCD == 0) then
			Spell1 = UnleashElements
		elseif(StormStrikeCD == 0) then
			Spell1 = StormStrike
		elseif(EarthShockCD == 0) then
			Spell1 = EarthShock
		elseif(FeralSpiritCD == 0 and PA.Toggle_Do_1 ) then
			Spell1 = FeralSpirit
		elseif(FireTotemCD < 5 and PA.Toggle_Do_3 == false) then
			Spell1 = SearingTotem
		else
			Spell1 = Delay100
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
			Spell2 = Delay100
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
		PA:Print("Initializing Enhancement Shamman")
		PA:SetToggle(1, 1, "Feral Spirit")		
		PA:SetToggle(2, 1, "Fire Elemental Totem")
		PA:SetToggle(3, 1, "Lightning Bolt")
		PA:SetToggle(4, 1, "Wind Shear")
		
		PA:RegisterGCDSpell("Lightning Bolt")
		PA:RegisterRangeSpell("Wind Shear")
		
		LightningBolt	= PA:RegisterSpell(1, "Lightning Bolt")
		ChainLightning 	= PA:RegisterSpell(2, "Chain Lightning")
		FlameShock		= PA:RegisterSpell(3, "Flame Shock")
		EarthShock		= PA:RegisterSpell(4, "Earth Shock")
		FireNova 		= PA:RegisterSpell(5, "Fire Nova")
		UnleashElements	= PA:RegisterSpell(6, "Unleash Elements")
		LavaLash 		= PA:RegisterSpell(7, "Lava Lash")
		StormStrike		= PA:RegisterSpell(8, "Stormstrike")
		FeralSpirit		= PA:RegisterSpell(9, "Feral Spirit")
		SearingTotem 	= PA:RegisterSpell(10, "Searing Totem")
		FireElemental	= PA:RegisterSpell(11, "Fire Elemental Totem")
		WindShear 		= PA:RegisterSpell(12, "Wind Shear")
		
		-- ==================== REGISTER ROTATION ==============================
		PA:setRotation(mod.rotation, modName)
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