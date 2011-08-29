local LBCT = LibStub("LibBabble-CreatureType-3.0"):GetLookupTable()
local LRC = LibStub("LibRangeCheck-2.0", true)

local runes = {}
local runesCD = {}

local runeType = 
{
	blood = 1,
	unholy = 2,
	frost = 3,
	death = 4
}	

local totemType =
{
	ghoul = 1,
	fire = 1,
	earth = 2,
	water = 3,
	air = 4
}

WA.buffSpellList =
{
	fear =
	{
		5782, -- Fear
		5484, -- Howl of terror
		5246, -- Intimidating Shout 
		8122, -- Psychic scream
	},
	root =
	{
		23694, -- Improved Hamstring
		339, -- Entangling Roots
		122, -- Frost Nova
		47168, -- Improved Wing Clip
	},
	incapacitate = 
	{
		6770, -- Sap
		12540, -- Gouge
		20066, -- Repentance
	},
	stun = 
	{
		5211, -- Bash
		44415, -- Blackout
		6409, -- Cheap Shot
		22427, -- Concussion Blow
		853, -- Hammer of Justice
		408, -- Kidney Shot
		46968, -- Shockwave
	},
	strengthagility=
	{
		6673, -- Battle Shout
		8076, -- Strength of Earth
		57330, -- Horn of Winter
		93435 --Roar of Courage (Cat, Spirit Beast)
	},
	stamina =
	{
		21562, -- Fortitude TODO: vérifier
		469, -- Commanding Shout
		6307, -- Blood Pact
		90364 -- Qiraji Fortitude
	},
	lowerarmor=
	{
		58567, -- Sunder Armor (x3)
		8647, -- Expose Armor
		91565, -- Faerie Fire (x3)
		35387, --Corrosive Spit (x3 Serpent)
		50498 --Tear Armor (x3 Raptor)
	},
	magicaldamagetaken=
	{
		65142, -- Ebon Plague
		60433, -- Earth and Moon
		93068, -- Master Poisoner 
		1490, -- Curse of the Elements
		85547, -- Jinx 1
		86105, -- Jinx 2
		34889, --Fire Breath (Dragonhawk)
		24844 --Lightning Breath (Wind serpent)
	},
	magicalcrittaken=
    {
        17800, -- Shadow and Flame
        22959 -- Critical Mass
    },
	-- physicaldamagetaken
	lowerphysicaldamage=
	{
		99, -- Demoralizing Roar
		702, -- Curse of Weakness
		1160, -- Demoralizing Shout
		26017, -- Vindication
		81130, -- Scarlet Fever
		50256 --Demoralizing Roar (Bear)
	},
	meleeslow=
	{
		55095, --Icy Touch
		58179, --Infected Wounds rank 1
		58180, --Infected Wounds rank 2
		68055, --Judgments of the just
		6343, --Thunderclap
		8042, --Earth Shock
		50285 --Dust Cloud (Tallstrider)
	},
	castslow =
	{
		1714, --Curse of Tongues
        58604, --Lava Breath (Core Hound)
        50274, --Spore Cloud (Sporebat)
        5761, --Mind-numbing Poison
        73975, --Necrotic Strike
        31589 --Slow
	},
	bleed=
	{
		33876, --Mangle cat
		33878, --Mangle bear
		46856, -- Trauma rank 1
		46857, -- Trauma rank 2
		16511, --Hemorrhage
		50271, --Tendon Rip (Hyena)
		35290 --Gore (Boar)
	},
	heroism=
	{
		2825, --Bloodlust
		32182, --Heroism
		80353, --Time warp
		90355 -- Ancient Hysteria (Core Hound)
	},
	meleehaste =
	{
		8515, -- Windfury
		55610, -- Improved Icy Talons
		53290 -- Hunting Party
	},
	spellhaste = 
	{
		24907, -- Moonkin aura
		2895 -- Wrath of Air Totem
	},
	enrage =
	{
		49016, -- Unholy Frenzy
		18499, -- Berserker Rage
		12292, -- Death Wish
		12880, -- Enrage (rank 1)
		14201, -- Enrage (rank 2)
		14202, -- Enrage (rank 3)
	}
}



function WA:GetTargetHealthPercentage() 
    local target_health_max = UnitHealthMax("target")         
    if (target_health_max > 0) then
        return UnitHealth("target") / target_health_max
    else
        -- maximum health
        return 1.0
    end
end


function WA:GetBuffCount(SpellID)
	return WA:GetBuffCountOn(SpellID, "player")
end

function WA:GetBuff(SpellID)
	return WA:GetBuffOn(SpellID, "player", true)
end

function WA:GetPetBuff(SpellID)
	return WA:GetBuffOn(SpellID, "pet", true)
end

function WA:GetPetBuffCount(SpellID)
	return WA:GetBuffCountOn(SpellID, "pet")
end

function WA:GetTargetDebuff(SpellID)
	return WA:GetDebuffsOn(SpellID, "target")
end

function WA:GetTargetDebuffStacks(SpellID)
	return WA:GetDebuffStacksOn(SpellID, "target")
end

function WA:GetFocusDebuff(SpellID)
	return WA:GetDebuffsOn(SpellID, "focus")
end

function WA:GetBuffOn(SpellID, Unit, Mine)
	local left
	if(Mine == true) then
		MyBuff = "PLAYER"
	else
		MyBuff = nil
	end
	_, _, _, _, _, _, expires = UnitBuff(Unit, SpellID, nil, MyBuff)
	if expires then
		left = expires - WA.StartTime - WA.StartGCD
		if left < 0 then left = 0 end
	else
		left = 0
	end
	return left
end

function WA:GetBuffCountOn(SpellID, Unit)
	local BuffName, BuffCount
	BuffName, _, _,BuffCount, _, _, _, _, _, _, _ = UnitBuff(Unit, SpellID) 
	if (BuffName == nil) then
		BuffCount = 0
	end
	return BuffCount
end

function WA:GetDebuffStacksOn(SpellID, Unit)
	DebuffName, _, _,DebuffCount, _, _, DebuffExpiration, _, _, _, _ = UnitDebuff(Unit, SpellID) 
	if (DebuffName ~= nil) then
		DebuffCount = 0
	end
	return DebuffCount
end
function WA:GetDebuffsOn(SpellID, Unit)
	DebuffName, _, _,DebuffCount, _, _, DebuffExpiration, _, _, _, _ = UnitDebuff(Unit, SpellID) 
	if (DebuffName ~= nil) then
		DebuffCount = 0
	end
	return DebuffCount
end


local function nilstring(text)
	if text == nil then
		return "nil"
	else
		return text
	end
end

function WA:GetArmorDebuff()
	-- [Faerie Fire] /  [Faerie Fire (Feral)]: -4% per application, stacks up to 3 times, also prevents stealth.
	-- [Tear Armor]: Raptor ability, -4% per application, stacks up to 3 times.
	-- [Corrosive Spit]: Serpent ability, -4% per application, stacks up to 3 times.
	-- [Expose Armor]: -12%.
	-- [Sunder Armor]: -4% per application, stacks up to 3 times.
	
	SACD = WA:GetTargetDebuff("Sunder Armor")
	FFCD = WA:GetTargetDebuff("Faerie Fire")
	TACD = WA:GetTargetDebuff("Tear Armor")
	CSCD = WA:GetTargetDebuff("Corrosive Spit")
	XACD = WA:GetTargetDebuff("Expose Armor")
	return math.max(SACD, FFCD, TACD, CSCD, XACD)
end


function WA:GetAttackPowerDebuff()
	-- [Vindication]: Scales with level, -574 fully talented @ level 80.
	-- [Demoralizing Roar]: -408 @ max rank (~571.2 fully talented with  [Feral Aggression], a tier 1 Feral Combat talent with 5 ranks), Bear Form and Dire Bear form only.
	-- [Demoralizing Screech]: Carrion Bird ability, -410 @ max rank.
	-- [Curse of Weakness]: -478 @ max rank (573 fully talented w/  [Improved Curse of Weakness], a tier 2 Affliction talent with 2 ranks), also reduces armor.
	-- [Demoralizing Shout]: -410 @ max rank (-574 fully talented with  [Improved Demoralizing Shout], a tier 2 Fury talent with 5 ranks).
	
	VICD = WA:GetTargetDebuff("Vindication")
	DRCD = WA:GetTargetDebuff("Demoralizing Roar")
	DSCCD = WA:GetTargetDebuff("Demoralizing Screech")
	CWCD = WA:GetTargetDebuff("Curse of Weakness")
	DSCD = WA:GetTargetDebuff("Demoralizing Shout")
	
	return math.max(VICD, DRCD, DSCCD, CWCD, DSCD)
end

function WA:GetAttackSpeedDebuff()
	--  Frost Fever: Caused by  [Icy Touch],  [Hungering Cold], glyphed  [Howling Blast] and glyphed  [Scourge Strike]. Can also be caused by using  [Pestilence] on a nearby creature that already has Frost Fever. Increases melee and ranged attack intervals by 20%.
	-- [Infected Wounds]: Tier 8 Feral Combat talent, 3 ranks, causes Mangle,  [Maul] and  [Shred] to apply the Infected Wound debuff, which increases melee attack interval by 20% @ max rank, also reduces movement speed.
	-- [Judgements of the Just]: Tier 9 Protection talent, 2 ranks, causes Judgements to increase melee attack intervals 20% @ max rank.
	-- [Earth Shock]: Reduces melee and ranged attack intervals by 10%, 20% when talented.
	-- [Thunder Clap]: Reduces melee and ranged attack intervals by 10%, 20% when talented.
	-- [Slow]: Tier 7 Arcane talent ability, increases melee and ranged attack intervals by 60%, also increases casting time.

	ITCD = WA:GetTargetDebuff("Frost Fever")
	TCCD = WA:GetTargetDebuff("Thunder Clap")
	IWCD = WA:GetTargetDebuff("Infected Wounds")
	JJCD = WA:GetTargetDebuff("Judgements of the Just")
	ESCD = WA:GetTargetDebuff("Earth Shock")
	return math.max(ITCD, TCCD, IWCD, JJCD, ESCD)
	
end

function WA:GetTraumaDebuff()
	-- FBNLite.L["Mangle (Cat)"] = GetSpellInfo(33876)
	-- FBNLite.L["Mangle (Bear)"] = GetSpellInfo(33878)
	-- FBNLite.L["Trauma"] = GetSpellInfo(46857)
	-- FBNLite.L["Hemorrhage"] = GetSpellInfo(16511)
	MAB = WA:GetTargetDebuff("Mangle")
	-- MAC = WA:GetTargetDebuff(33878)
	TRA = WA:GetTargetDebuff("Trauma")
	HEM = WA:GetTargetDebuff("Hemorrhage")
	return math.max(MAB, TRA, HEM)
end