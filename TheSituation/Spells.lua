----------
-- Name: TheSituation
-- Version: 2.0.x
-- License: All Rights Reserved
----------


-- [OBJECTS] --
local Spells = SITUATION.Spells;
local Libs = SITUATION.Libs;
local Tools = SITUATION.Tools;

-- by spell guid name
Spells.cooldownIndex = {};
Spells.unitTypeIndexByCooldownName = {};

Spells.cooldownIndexByUnitType = {};

-- by spell id
Spells.cooldownNameIndex = {};
Spells.cooldownTableIndex = {};
Spells.classNameIndex = {};
Spells.specNameIndex = {};
Spells.hookTableIndex = {};
Spells.resetTableIndex = {};
Spells.reverseCooldownIndex = {};
Spells.classNameEventIndex  = {};


--[[
	cooldownVarName = {
	
			-- Required properties
		event = '',								-- Index for event table found in Libs.event
		mainId = 0,								-- The spell that will be used to represent the cooldown (e.g. name, icon)
		baseDuration = 0,						-- The base cooldown duration.
		
			-- Optional properties
		name = '',								-- The name that will represent the cooldown, instead of using info from mainId
		icon = '',								-- The icon path that will represent the cooldown, instead of using info from mainId
		recordBuffer = 0,						-- The time in milliseconds before new data for this cooldown can be recorded for any one unit.
		
		isCasted = true,						-- The interval between a cooldown-trigger-event and a start-cast-event is used instead of the interval between cooldown-trigger-events.
		ignoreInterval = true,					-- Spell-use-intervals won't be recorded. 'baseDuration' used; 'allDurations', 'maxDuration', and 'minDuration' ignored.
		multiCaster = true,						-- The spell ID(s) can be casted by multiple units. Unit information determined from the cooldown will only be used on cooldown-trigger-events.
		
		allIds = {},							-- Used when multiple spell ids can trigger the cooldown. The value of 'mainId' must be included in this array if you want it to trigger the cooldown.
		
		allDurations = {},						-- Used when there are multiple possible durations. The value of 'baseDuration' must be included in this array. Requires 'minDuration' and 'maxDuration' properties.
		maxDuration = 0,						-- The longest duration from the 'allDurations' array. Requires 'allDurations' and 'minDuration' properties.
		minDuration = 0,						-- the shortest duration from the 'allDurations' array. Requires 'allDurations' and 'maxDuration' properties.
		
		tree = '',								-- The talent tree where the cooldown is located. Requires the 'tier' property.
		tier = 0,								-- The talent tree tier  where the cooldown is located. Requires the 'tree' property.
	}
]]


local lowestTier = 3; -- Lowest talent tier that can determine a player's tree

Spells.player = {
	cooldown = {
		all = {
			test = {
				base = {
					bar1 = {event='success',mainId=1,baseDuration = 180000,name='Player Single Endpoint',icon=Libs.icons.of.group.player},
					bar2 = {event='success',mainId=1,baseDuration = 180000,allDurations={10000,180000},maxDuration=180000,minDuration=10000,name='Player Multiple Endpoints',icon=Libs.icons.of.group.player},
					ignoreInterval = {event='success',mainId=1,baseDuration = 180000,name='Player Ignore Interval Bar',icon=Libs.icons.of.group.player,ignoreInterval=true},
				},
			},
			general = {
				standards = {
					tol_barad_battle_standard = {event='success',mainId=90688,allIds = {90687,90688},baseDuration=600000,name='TB Battle Standard',icon=[[interface\icons\achievement_bg_takexflags_ab]]},
					guild_battle_standard = {event='success',mainId=90633,allIds = {90628,90631,90632,90633,89479,90626},baseDuration=600000,name='Guild Battle Standard',icon=[[interface\icons\inv_guild_standard_alliance_c]]},
					battleground_battle_standard = {event='success',mainId=23035,allIds = {23034,23035},baseDuration=600000,name='BG Battle Standard',icon=[[interface\icons\achievement_bg_takexflags_ab]]},
					alterac_valley_battle_standard = {event='success',mainId=23539,allIds = {23539,23538},baseDuration=900000,name='AV Battle Standard',icon=[[interface\icons\achievement_bg_takexflags_ab]]},
				},
				base = {
					healthstone = {event='success',mainId=6262,baseDuration=120000},
					pvp_trinket = {event='success',mainId=42292,baseDuration=120000},
					light_of_elune = {event='success',mainId=6724,baseDuration=60000,icon=[[interface\icons\inv_potion_13]]},
					temp_health_trinke_2m = {event='auraApply',mainId=92223,allIds = {92223,84960},baseDuration=120000,name='(2m) Temp Health Trinket',icon=[[interface\icons\spell_holy_mindvision]]},
					temp_health_trinket_3m = {event='auraApply',mainId=92186,allIds = {67753,92172,92186,56370,44055,60180,55915,71569,67596,67699},baseDuration=180000,name='(3m) Temp Health Trinket',icon=[[interface\icons\spell_holy_mindvision]]},
				},
			},
			racial = {
				alliance = {
					darkflight = {event='success',mainId=68992,baseDuration=120000},
					stoneform = {event='auraApply',mainId=65116,baseDuration=120000},
					escape_artist = {event='success',mainId=20589,baseDuration=90000},
					every_man_for_himself = {event='success',mainId=59752,baseDuration=120000},
					gift_of_the_naaru = {event='success',mainId=59548,allIds = {28880,59543,59548,59542,59544,59547,59545},baseDuration=180000},
					shadowmeld = {event='success',mainId=58984,baseDuration=120000},
				},
				horde = {
					rocket_jump = {event='success',mainId=69070,baseDuration=120000},
					pack_hobgoblin = {event='success',mainId=69046,baseDuration=1800000},
					blood_fury = {event='success',mainId=33702,allIds = {20572,33697,33702},baseDuration=120000},
					war_stomp = {event='auraApply',mainId=20549,baseDuration=120000},
					berserking = {event='success',mainId=26297,baseDuration=180000},
					arcane_torrent = {event='success',mainId=80483,allIds = {80483,25046,28730,50613},baseDuration=120000},
					will_of_the_forsaken = {event='success',mainId=7744,baseDuration=120000},
					cannibalize = {event='success',mainId=20577,baseDuration=120000},
					rocket_barrage = {event='success',mainId=69041,baseDuration=120000},
				},
			},
			engineering = {
				damageBombs = {
					super_sapper_charge = {event='success',mainId=30486,baseDuration=300000,icon=[[interface\icons\inv_gizmo_supersappercharge]]},
					rough_dynamite = {event='damage',mainId=4054,baseDuration=60000,icon=[[interface\icons\inv_misc_bomb_06]]},
					coarse_dynamite = {event='damage',mainId=4061,baseDuration=60000,icon=[[interface\icons\inv_misc_bomb_06]]},
					ez_thro_dynamite_2 = {event='damage',mainId=23000,baseDuration=60000,name='Ez-Thro Dynamite II',icon=[[interface\icons\inv_misc_bomb_03]]},
					ez_thro_dynamite = {event='damage',mainId=8331,baseDuration=60000,icon=[[interface\icons\inv_misc_bomb_06]]},
					heavy_dynamite = {event='damage',mainId=4062,baseDuration=60000,icon=[[interface\icons\inv_misc_bomb_06]]},
					dense_dynamite = {event='damage',mainId=23063,baseDuration=60000,icon=[[interface\icons\inv_misc_bomb_06]]},
					goblin_sapper_charge = {event='success',mainId=13241,baseDuration=300000},
					solid_dynamite = {event='damage',mainId=12419,baseDuration=60000,icon=[[interface\icons\inv_misc_bomb_06]]},
				},
				siegeBombs = {
					saronite_bomb = {event='damage',mainId=56350,baseDuration=60000,icon=[[interface\icons\inv_misc_enggizmos_32]]},
					global_thermal_sapper_charge = {event='success',mainId=56488,baseDuration=300000,icon=[[interface\icons\inv_gizmo_supersappercharge]]},
				},
				incapacitateBombs = {
					fel_iron_bomb = {event='auraApply',mainId=30216,baseDuration=60000,icon=[[interface\icons\inv_gizmo_felironbomb]]},
					big_daddy = {event='auraApply',mainId=89637,baseDuration=60000,icon=[[interface\icons\inv_misc_enggizmos_38]]},
					dark_iron_bomb = {event='auraApply',mainId=19784,baseDuration=60000,icon=[[interface\icons\inv_misc_bomb_05]]},
					cobalt_frag_bomb = {event='auraApply',mainId=67769,baseDuration=60000,icon=[[interface\icons\inv_misc_enggizmos_31]]},
					big_iron_bomb = {event='auraApply',mainId=4069,baseDuration=60000,icon=[[interface\icons\inv_misc_bomb_01]]},
					adamantite_grenade = {event='auraApply',mainId=30217,baseDuration=60000,icon=[[interface\icons\inv_misc_bomb_08]]},
					big_bronze_bomb = {event='auraApply',mainId=4067,baseDuration=60000,icon=[[interface\icons\inv_misc_bomb_05]]},
					thorium_grenade = {event='auraApply',mainId=19769,baseDuration=60000,icon=[[interface\icons\inv_misc_bomb_08]]},
					the_bigger_one = {event='auraApply',mainId=30461,baseDuration=60000,icon=[[interface\icons\inv_gizmo_thebiggerone]]},
					the_big_one = {event='auraApply',mainId=12562,baseDuration=60000,icon=[[interface\icons\inv_misc_bomb_04]]},
					small_bronze_bomb = {event='auraApply',mainId=4066,baseDuration=60000,icon=[[interface\icons\inv_misc_bomb_09]]},
					rough_copper_bomb = {event='auraApply',mainId=4064,baseDuration=60000,icon=[[interface\icons\inv_misc_bomb_09]]},
					mithril_frag_bomb = {event='auraApply',mainId=12421,baseDuration=60000,icon=[[interface\icons\inv_misc_bomb_02]]},
					large_copper_bomb = {event='auraApply',mainId=4065,baseDuration=60000,icon=[[interface\icons\inv_misc_bomb_01]]},
					iron_grenade = {event='auraApply',mainId=4068,baseDuration=60000,icon=[[interface\icons\inv_misc_bomb_08]]},
					hi_explosive_bomb = {event='auraApply',mainId=12543,baseDuration=60000,icon=[[interface\icons\inv_misc_bomb_07]]},
				},
				uniqueBombs = {
					arcane_bomb = {event='auraApply',mainId=19821,baseDuration=60000,icon=[[interface\icons\spell_shadow_mindbomb]]},
					frost_grenade = {event='auraApply',mainId=39965,baseDuration=60000,icon=[[interface\icons\inv_misc_enggizmos_31]]},
				},
				items = {
					hyper_vision_goggles = {event='success',mainId=30249,baseDuration=120000,name='Hyper-Vision Goggles',icon=[[interface\icons\inv_gizmo_newgoggles]]},
					parachute_cloak = {event='success',mainId=12438,baseDuration=30000,name='Parachute Cloak',icon=[[interface\icons\inv_misc_cape_11]]},
					goblin_rocket_launcher = {event='auraApply',mainId=46567,baseDuration=120000,name='Goblin Rocket Launcher',icon=[[interface\icons\inv_gizmo_rocketlauncher]]},
					high_powered_bolt_gun = {event='damage',mainId=82207,baseDuration=120000,name='High-Powered Bolt Gun',icon=[[interface\icons\inv_musket_02]]},
					gnomish_lightning_generator = {event='success',mainId=55039,baseDuration=60000,icon=[[interface\icons\spell_nature_lightningoverload]]},
					gnomish_universal_remote = {event='success',mainId=8344,baseDuration=180000,name='Gnomish Universal Remote',icon=[[interface\icons\inv_misc_pocketwatch_01]]},
				},
				consumables = {
					goblin_land_mine = {event='summon',mainId=4100,baseDuration=60000},
					goblin_beam_welder = {event='success',mainId=67324,baseDuration=60000},
					explosive_decoy = {event='summon',mainId=54359,baseDuration=120000},
					gnomish_flame_turret = {event='summon',mainId=30526,baseDuration=60000,name='Gnomish Flame Turret',icon=[[interface\icons\inv_gizmo_gnomishflameturret]]},
					explosive_sheep = {event='summon',mainId=4074,baseDuration=60000},
					target_dummy = {event='summon',mainId=4071,baseDuration=120000,icon=[[interface\icons\inv_crate_06]]},
					flash_bomb = {event='success',mainId=5134,baseDuration=60000,icon=[[interface\icons\inv_misc_ammo_bullet_01]]},
					masterwork_target_dummy = {event='summon',mainId=19805,baseDuration=120000,icon=[[interface\icons\inv_crate_02]]},
					discombobulator_ray = {event='success',mainId=4060,baseDuration=60000,name='Discombobulator Ray',icon=[[interface\icons\inv_misc_spyglass_02]]},
					advanced_target_dummy = {event='summon',mainId=4072,baseDuration=120000,icon=[[interface\icons\inv_crate_05]]},
					mechanical_repair_kit = {event='heal',mainId=15057,baseDuration=120000},
				},
				tinkers = {
					hyperspeed_accelerators = {event='success',mainId=54758,baseDuration=60000,name='Hyperspeed Accelerators',icon=[[interface\icons\trade_engineering]]},
					synapse_springs = {event='success',mainId=82174,baseDuration=60000,name='Synapse Springs',icon=[[interface\icons\trade_engineering]]},
					cardboard_assassin = {event='success',mainId=94548,baseDuration=300000,name='Cardboard Assassin',icon=[[interface\icons\trade_engineering]]},
					nitro_boosts = {event='auraApply',mainId=54861,baseDuration=180000,name='Nitro Boosts',icon=[[interface\icons\trade_engineering]]},
					tazik_shocker = {event='success',mainId=82179,baseDuration=120000,name='Tazik Shocker',icon=[[interface\icons\trade_engineering]]},
					grounded_plasma_shield = {event='success',mainId=82626,baseDuration=300000,name='Grounded Plasma Shield',icon=[[interface\icons\trade_engineering]]},
					frag_belt = {event='auraApply',mainId=67890,baseDuration=300000,name='Frag Belt',icon=[[interface\icons\trade_engineering]]},
					z50_mana_gulper = {event='success',mainId=82186,baseDuration=60000,name='Z50 Mana Gulper',icon=[[interface\icons\trade_engineering]]},
					invisibility_field = {event='success',mainId=84348,baseDuration=300000,name='Invisibility Field',icon=[[interface\icons\trade_engineering]]},
					flexweave_underlay = {event='success',mainId=55001,baseDuration=60000,name='Flexweave Underlay',icon=[[interface\icons\trade_engineering]]},
					quickflip_deflection_plates = {event='success',mainId=82176,baseDuration=60000,name='Quickflip Deflection Plates',icon=[[interface\icons\trade_engineering]]},
					hand_mounted_pyro_rocket = {event='success',mainId=54757,baseDuration=45000,name='Hand-Mounted Pyro Rocket',icon=[[interface\icons\trade_engineering]]},
					personal_electromagnetic_pulse_generator = {event='success',mainId=54735,baseDuration=60000,name='Personal Electomagnetic Pulse Generator',icon=[[interface\icons\trade_engineering]]},
					spinal_healing_injector = {event='success',mainId=82184,baseDuration=60000,name='Spinal Healing Injector',icon=[[interface\icons\trade_engineering]]},
					reticulated_armor_webbing = {event='success',mainId=82387,baseDuration=60000,name='Reticulated Armor Webbing',icon=[[interface\icons\trade_engineering]]},
				},
			},
			herbalism = {
				base = {
					lifeblood = {event='success',mainId=81708,allIds = {55502,55503,74497,81708,55428,55480,55500,55501},baseDuration=120000},
				},
			},
			leatherworking = {
				drums = {
					drums_of_speed = {event='success',mainId=35477,baseDuration=120000},
					drums_of_panic = {event='auraApply',mainId=35474,baseDuration=120000},
					drums_of_battle = {event='success',mainId=35476,baseDuration=120000},
					drums_of_restoration = {event='success',mainId=35478,baseDuration=120000},
					drums_of_war = {event='success',mainId=35475,baseDuration=120000},
					drums_of_the_wild = {event='success',mainId=78164,baseDuration=120000},
				},
				items = {
					helm_of_fire = {event='success',mainId=10578,baseDuration=300000,name='Helm of Fire',icon=[[interface\icons\inv_helmet_08]]},
					swift_boots = {event='success',mainId=9175,baseDuration=1200000,name='Swift Boots',icon=[[interface\icons\inv_boots_08]]},
					gauntlets_of_the_sea = {event='success',mainId=10577,baseDuration=1800000,name='Gauntlets of the Sea',icon=[[interface\icons\inv_gauntlets_30]]},
					gem_studded_leather_belt = {event='success',mainId=9163,baseDuration=300000,name='Gem-Studded Leather Belt',icon=[[interface\icons\inv_belt_01]]},
					barbaric_belt = {event='success',mainId=9174,baseDuration=1200000,name='Barbaric Belt',icon=[[interface\icons\inv_belt_09]]},
					dragonscale_breastplate = {event='success',mainId=10618,baseDuration=3600000,name='Dragonscale Breastplate',icon=[[interface\icons\inv_chest_chain_07]]},
				},
			},
			firstAid = {
				base = {
					anti_venom = {event='success',mainId=7932,baseDuration=60000},
					strong_anti_venom = {event='success',mainId=7933,baseDuration=60000},
					powerful_anti_venom = {event='success',mainId=23786,baseDuration=60000},
				},
			},
			tailoring = {
				embroideries = {
					swordguard_embroidery_rank2 = {event='auraApply',mainId=75176,baseDuration=50000,name='Swordguard (Rank 2)'},
					lightweave_embroidery_rank1 = {event='auraApply',mainId=55637,baseDuration=60000,name='Lightweave (Rank 1)'},
					lightweave_embroidery_rank2 = {event='auraApply',mainId=75170,baseDuration=50000,name='Lightweave (Rank 2)'},
					darkglow_embroidery_rank1 = {event='energize',mainId=55767,baseDuration=60000,name='Darkglow (Rank 1)'},
					darkglow_embroidery_rank2 = {event='energize',mainId=75173,baseDuration=50000,name='Darkglow (Rank 2)'},
					swordguard_embroidery_rank1 = {event='auraApply',mainId=55775,baseDuration=60000,name='Swordguard (Rank 1)'},
				},
				items = {
					spider_belt = {event='success',mainId=9774,baseDuration=1800000,name='Spider Belt',icon=[[interface\icons\inv_belt_25]]},
					admirals_hat = {event='success',mainId=12022,baseDuration=60000,icon=[[interface\icons\inv_helmet_29]]},
					robe_of_the_void = {event='success',mainId=18386,baseDuration=600000,name='Robe of the Void',icon=[[interface\icons\inv_chest_cloth_51]]},
					cloak_of_fire = {event='success',mainId=18364,baseDuration=120000,icon=[[interface\icons\inv_misc_cape_18]]},
					robe_of_the_archmage = {event='success',mainId=18385,baseDuration=300000,name='Robe of the Archmage',icon=[[interface\icons\inv_chest_cloth_38]]},
				},
				nets = {
					embersilk_net = {event='success',mainId=75148,baseDuration=60000},
					frostweave_net = {event='success',mainId=55536,baseDuration=60000},
					netherweave_net = {event='success',mainId=31367,baseDuration=60000},
				},
			},
			alchemy = {
				healing = {
					tol_barad_healing_potion = {event='success',mainId=89078,baseDuration=60000,name='Tol Barad Healing Potion',icon=[[interface\icons\inv_potion_142]]},
					healing_potion = {event='success',mainId=441,baseDuration=60000,name='Healing Potion',icon=[[interface\icons\inv_potion_51]]},
					major_healing_potion = {event='success',mainId=17534,baseDuration=60000,name='Major Healing Potion',icon=[[interface\icons\inv_potion_54]]},
					mythical_healing_potion = {event='success',mainId=78989,baseDuration=60000,name='Mythical Healing Potion',icon=[[interface\icons\inv_misc_potionsetf]]},
					lesser_healing_potion = {event='success',mainId=440,baseDuration=60000,name='Lesser Healing Potion',icon=[[interface\icons\inv_potion_50]]},
					superior_healing_potion = {event='success',mainId=4042,baseDuration=60000,name='Superior Healing Potion',icon=[[interface\icons\inv_potion_53]]},
					runic_healing_potion = {event='success',mainId=43185,baseDuration=60000,name='Runic Healing Potion',icon=[[interface\icons\inv_alchemy_elixir_05]]},
					minor_healing_potion = {event='success',mainId=439,baseDuration=60000,name='Minor Healing Potion',icon=[[interface\icons\inv_potion_49]]},
					greater_healing_potion = {event='success',mainId=2024,baseDuration=60000,name='Greater Healing Potion',icon=[[interface\icons\inv_potion_52]]},
					super_healing_potion = {event='success',mainId=67486,allIds = {67486,28495},baseDuration=60000,name='Super Healing Potion',icon=[[interface\icons\inv_potion_131]]},
				},
				mana = {
					mana_potion = {event='success',mainId=2023,baseDuration=60000,name='Mana Potion',icon=[[interface\icons\inv_potion_72]]},
					tol_barad_mana_potion = {event='success',mainId=89083,baseDuration=60000,name='Tol Barad Mana Potion',icon=[[interface\icons\inv_potion_148]]},
					major_mana_potion = {event='success',mainId=17531,baseDuration=60000,name='Major Mana Potion',icon=[[interface\icons\inv_potion_76]]},
					lesser_mana_potion = {event='success',mainId=438,baseDuration=60000,name='Lesser Mana Potion',icon=[[interface\icons\inv_potion_71]]},
					mythical_mana_potion = {event='success',mainId=78990,baseDuration=60000,name='Mythical Mana Potion',icon=[[interface\icons\inv_misc_potionsetc]]},
					superior_mana_potion = {event='success',mainId=17530,baseDuration=60000,name='Superior Mana Potion',icon=[[interface\icons\inv_potion_74]]},
					minor_mana_potion = {event='success',mainId=437,baseDuration=60000,name='Minor Mana Potion',icon=[[interface\icons\inv_potion_70]]},
					runic_mana_potion = {event='success',mainId=43186,baseDuration=60000,name='Runic Mana Potion',icon=[[interface\icons\inv_alchemy_elixir_02]]},
					greater_mana_potion = {event='success',mainId=11903,baseDuration=60000,name='Greater Mana Potion',icon=[[interface\icons\inv_potion_73]]},
					super_mana_potion = {event='success',mainId=67487,allIds = {67487,28499},baseDuration=60000,name='Super Mana Potion',icon=[[interface\icons\inv_potion_137]]},
				},
			},
		},
		class = {
			deathknight = {
				base = {
					lichborne = {event='success',mainId=49039,baseDuration=120000,tier=2,tree='frost'},
					pillar_of_frost = {event='success',mainId=51271,baseDuration=60000,tier=4,tree='frost'},
					blood_tap = {event='success',mainId=45529,baseDuration=60000,allDurations={60000,45000,30000},maxDuration=60000,minDuration=30000},
					hungering_cold = {event='success',mainId=49203,baseDuration=60000,tier=5,tree='frost'},
					raise_ally = {event='success',mainId=61999,baseDuration=600000},
					raise_dead_pet = {event='summon',mainId=52150,baseDuration=120000,name=Tools.getSpellName(52150)..' (Pet)',tier=100,tree='unholy'},
					death_grip = {event='success',mainId=49576,baseDuration=35000,ignoreInterval=true},
					mind_freeze = {event='success',mainId=47528,baseDuration=10000},
					unholy_frenzy = {event='success',mainId=49016,baseDuration=180000,tier=3,tree='unholy'},
					strangulate = {event='success',mainId=47476,baseDuration=120000,allDurations={120000,90000,60000},maxDuration=120000,minDuration=60000},
					anti_magic_zone = {event='success',mainId=51052,baseDuration=120000,tier=5,tree='unholy'},
					empower_rune_weapon = {event='success',mainId=47568,baseDuration=300000},
					summon_gargoyle = {event='success',mainId=49206,baseDuration=180000,tier=7,tree='unholy'},
					army_of_the_dead = {event='success',mainId=42650,baseDuration=600000},
					icebound_fortitude = {event='success',mainId=48792,baseDuration=180000},
					death_pact = {event='success',mainId=48743,baseDuration=120000},
					anti_magic_shell = {event='success',mainId=48707,baseDuration=45000},
					death_gate = {event='create',mainId=50977,baseDuration=60000,recordIntervalOnCast=true},
					dark_simulacrum = {event='success',mainId=77606,baseDuration=60000},
					outbreak = {event='success',mainId=77575,baseDuration=60000},
					raise_dead_guardian = {event='summon',mainId=46585,baseDuration=180000,name=Tools.getSpellName(46585)..' (Guardian)'},
					bone_shield = {event='success',mainId=49222,baseDuration=60000,tier=3,tree='blood'},
					will_of_the_necropolis = {event='auraApply',mainId=81162,baseDuration=45000,tier=5,tree='blood'},
					horn_of_winter = {event='success',mainId=57330,baseDuration=20000},
					rune_tap = {event='success',mainId=48982,baseDuration=30000,tier=5,tree='blood'},
					dark_command = {event='success',mainId=56222,baseDuration=8000,allDurations={8000,6000},maxDuration=8000,minDuration=6000},
					vampiric_blood = {event='success',mainId=55233,baseDuration=60000,allDurations={60000,50000},maxDuration=60000,minDuration=50000,tier=5,tree='blood'},
					death_and_decay = {event='success',mainId=43265,baseDuration=30000},
					dancing_rune_weapon = {event='success',mainId=49028,baseDuration=90000,tier=7,tree='blood'},
				},
			},
			druid = {
				base = {
					solar_beam = {event='success',mainId=78675,baseDuration=60000,tier=4,tree='balance'},
					force_of_nature = {event='success',mainId=33831,baseDuration=180000,tier=5,tree='balance'},
					starfall = {event='success',mainId=48505,baseDuration=90000,tier=7,tree='balance',ignoreInterval=true},
					mangle_bear = {event='success',mainId=33878,baseDuration=6000,name=Tools.getSpellName(33878, true),tier=100,tree='feralCombat'},
					fury_swipes = {event='damage',mainId=80861,baseDuration=3000,tier=2,tree='feralCombat'},
					feral_charge_bear = {event='success',mainId=16979,baseDuration=15000,allDurations={15000,14000},maxDuration=15000,minDuration=14000,name=Tools.getSpellName(16979, true),tier=3,tree='feralCombat'},
					rebirth = {event='resurrect',mainId=20484,baseDuration=600000,allDurations={600000,300000},maxDuration=600000,minDuration=300000,recordIntervalOnCast=true},
					feral_charge_cat = {event='success',mainId=49376,baseDuration=30000,allDurations={30000,28000},maxDuration=30000,minDuration=28000,name=Tools.getSpellName(49376, true),tier=3,tree='feralCombat'},
					thorns = {event='success',mainId=467,baseDuration=45000,allDurations={45000,25000},maxDuration=45000,minDuration=25000},
					maul = {event='success',mainId=6807,baseDuration=3000},
					leader_of_the_pack = {event='energize',mainId=68285,baseDuration=6000,tier=4,tree='feralCombat'},
					thrash = {event='success',mainId=77758,baseDuration=6000},
					survival_instincts = {event='success',mainId=61336,baseDuration=180000,tier=5,tree='feralCombat'},
					faerie_fire_feral = {event='success',mainId=16857,baseDuration=6000},
					berserk = {event='success',mainId=50334,baseDuration=180000,tier=7,tree='feralCombat'},
					swipe_bear = {event='success',mainId=779,baseDuration=3000},
					challenging_roar = {event='success',mainId=5209,baseDuration=180000,allDurations={180000,150000},maxDuration=180000,minDuration=150000},
					swiftmend = {event='success',mainId=18562,baseDuration=15000,tier=100,tree='restoration',ignoreInterval=true},
					cower = {event='success',mainId=8998,baseDuration=10000},
					growl = {event='success',mainId=6795,baseDuration=8000,allDurations={8000,6000},maxDuration=8000,minDuration=6000},
					natures_swiftness = {event='auraRemove',mainId=17116,baseDuration=180000,tier=3,tree='restoration',ignoreInterval=true},
					prowl = {event='auraRemove',mainId=5215,baseDuration=10000},
					revitalize = {event='energize',mainId=81094,baseDuration=12000,tier=3,tree='restoration'},
					barkskin = {event='success',mainId=22812,baseDuration=60000,allDurations={60000,48000},maxDuration=60000,minDuration=48000},
					wild_growth = {event='success',mainId=48438,baseDuration=8000,tier=5,tree='restoration'},
					bash = {event='success',mainId=5211,baseDuration=60000,allDurations={60000,55000,50000},maxDuration=60000,minDuration=50000},
					tree_of_life = {event='success',mainId=33891,baseDuration=180000,tier=7,tree='restoration'},
					dash = {event='success',mainId=1850,baseDuration=180000,allDurations={180000,144000},maxDuration=180000,minDuration=144000},
					enrage = {event='success',mainId=5229,baseDuration=60000},
					frenzied_regeneration = {event='success',mainId=22842,baseDuration=180000},
					innervate = {event='success',mainId=29166,baseDuration=180000,allDurations={180000,132000},maxDuration=180000,minDuration=132000},
					maim = {event='success',mainId=22570,baseDuration=10000},
					natures_grasp = {event='success',mainId=16689,baseDuration=60000},
					tigers_fury = {event='success',mainId=5217,baseDuration=30000,allDurations={30000,27000,24000},maxDuration=30000,minDuration=24000},
					tranquility = {event='success',mainId=740,baseDuration=480000,allDurations={480000,330000,240000,180000,165000,90000},maxDuration=480000,minDuration=90000},
					skull_bash = {event='success',mainId=80965,allIds = {80965,80964},baseDuration=60000,allDurations={60000,35000,10000},maxDuration=60000,minDuration=10000},
					stampeding_roar = {event='success',mainId=77764,allIds = {77764,77761},baseDuration=120000},
					wild_mushroom_detonate = {event='success',mainId=88751,baseDuration=10000},
					pvp_4_set_bonus = {event='energize',mainId=46832,baseDuration=6000,name='PvP 4pc Bonus',tier=0,tree='balance'},
					starsurge = {event='damage',mainId=78674,baseDuration=15000,tier=100,tree='balance'},
					natures_grace = {event='auraApply',mainId=16886,baseDuration=60000,tier=1,tree='balance'},
					typhoon = {event='success',mainId=61391,baseDuration=20000,allDurations={20000,17000},maxDuration=20000,minDuration=17000,icon=[[Interface\Icons\Ability_Druid_Typhoon]],tier=3,tree='balance'},
				},
			},			
			hunter = {
				base = {
					ice_trap = {event='success',mainId=13809,baseDuration=30000,allDurations={30000,28000,26000,24000,22000,20000},maxDuration=30000,minDuration=20000},
					freezing_trap = {event='success',mainId=1499,baseDuration=30000,allDurations={30000,28000,26000,24000,22000,20000},maxDuration=30000,minDuration=20000},
					snake_trap = {event='success',mainId=34600,baseDuration=30000,allDurations={30000,28000,26000,24000,22000,20000},maxDuration=30000,minDuration=20000},
					black_arrow = {event='success',mainId=3674,baseDuration=30000,allDurations={30000,28000,26000,24000},maxDuration=30000,minDuration=24000,tier=7,tree='survival'},
					intimidation = {event='success',mainId=19577,baseDuration=60000,allDurations={60000,54000,48000,42000,40000,36000,32000,28000},maxDuration=60000,minDuration=28000,tier=100,tree='beastMastery'},
					fervor = {event='success',mainId=82726,baseDuration=120000,tier=3,tree='beastMastery'},
					feed_pet = {event='success',mainId=6991,baseDuration=10000},
					wyvern_sting = {event='success',mainId=19386,baseDuration=60000,allDurations={60000,54000},maxDuration=60000,minDuration=54000,tier=5,tree='survival'},
					scatter_shot = {event='success',mainId=19503,baseDuration=30000},
					bestial_wrath = {event='success',mainId=19574,baseDuration=120000,allDurations={120000,108000,96000,84000},maxDuration=120000,minDuration=84000,tier=5,tree='beastMastery'},
					misdirection = {event='success',mainId=34477,baseDuration=30000,ignoreInterval=true},
					silencing_shot = {event='success',mainId=34490,baseDuration=20000,tier=3,tree='marksmanship'},
					distracting_shot = {event='success',mainId=20736,baseDuration=8000},
					focus_fire = {event='success',mainId=82692,baseDuration=15000,tier=3,tree='beastMastery'},
					raptor_strike = {event='success',mainId=2973,baseDuration=6000},
					readiness = {event='success',mainId=23989,baseDuration=180000,tier=5,tree='marksmanship'},
					flare = {event='success',mainId=1543,baseDuration=20000},
					kill_command = {event='success',mainId=34026,baseDuration=6000},
					rapid_fire = {event='success',mainId=3045,baseDuration=300000,allDurations={300000,240000,180000,120000,60000},maxDuration=300000,minDuration=60000},
					kill_shot = {event='success',mainId=53351,baseDuration=10000,ignoreInterval=true},
					counterattack = {event='success',mainId=19306,baseDuration=5000,tier=3,tree='survival'},
					concussive_shot = {event='success',mainId=5116,baseDuration=5000,allDurations={5000,4000,3000},maxDuration=5000,minDuration=3000},
					lock_and_load = {event='auraApply',mainId=56453,baseDuration=22000,tier=3,tree='survival'},
					disengage = {event='success',mainId=781,baseDuration=25000,ignoreInterval=true},
					deterrence = {event='success',mainId=19263,baseDuration=120000,ignoreInterval=true},
					masters_call = {event='success',mainId=53271,baseDuration=45000},
					explosive_shot = {event='success',mainId=53301,baseDuration=6000,tier=100,tree='survival',ignoreInterval=true},
					camouflage = {event='success',mainId=51753,baseDuration=60000},
					chimera_shot = {event='success',mainId=53209,baseDuration=10000,allDurations={10000,9000},maxDuration=10000,minDuration=9000,tier=7,tree='marksmanship'},
					explosive_trap = {event='success',mainId=13813,baseDuration=30000,allDurations={30000,28000,26000,24000,22000,20000},maxDuration=30000,minDuration=20000},
					immolation_trap = {event='success',mainId=13795,baseDuration=30000,allDurations={30000,28000,26000,24000,22000,20000},maxDuration=30000,minDuration=20000},
				},
			},
			mage = {
				base = {
					cone_of_cold = {event='success',mainId=120,baseDuration=10000,allDurations={10000,9300,8600,8000},maxDuration=10000,minDuration=8000},
					blink = {event='success',mainId=1953,baseDuration=15000,ignoreInterval=true},
					blast_wave = {event='success',mainId=11113,baseDuration=15000,allDurations={15000,11000},maxDuration=15000,minDuration=11000,tier=3,tree='fire'},
					counterspell = {event='success',mainId=2139,baseDuration=24000},
					ice_block = {event='success',mainId=45438,baseDuration=300000,allDurations={300000,279000,260000,258000,240000,239000,218000,200000},maxDuration=300000,minDuration=200000},
					evocation = {event='success',mainId=12051,baseDuration=240000,allDurations={240000,180000,120000,60000},maxDuration=240000,minDuration=60000},
					combustion = {event='success',mainId=11129,baseDuration=120000,tier=4,tree='fire'},
					invisibility = {event='success',mainId=66,baseDuration=180000,allDurations={180000,158400,135000},maxDuration=180000,minDuration=135000},
					dragons_breath = {event='success',mainId=31661,baseDuration=20000,allDurations={20000,17000},maxDuration=20000,minDuration=17000,tier=5,tree='fire'},
					time_warp = {event='success',mainId=80353,baseDuration=300000},
					ring_of_frost = {event='success',mainId=82676,baseDuration=120000},
					deep_freeze = {event='success',mainId=44572,baseDuration=30000,tier=7,tree='frost'},
					flame_orb = {event='success',mainId=82731,baseDuration=60000},
					arcane_barrage = {event='success',mainId=44425,baseDuration=4000,tier=100,tree='arcane'},
					fire_blast = {event='success',mainId=2136,baseDuration=8000},
					summon_water_elemental = {event='success',mainId=31687,baseDuration=180000,tier=100,tree='frost'},
					icy_veins = {event='success',mainId=12472,baseDuration=180000,allDurations={180000,167400,154800,144000},maxDuration=180000,minDuration=144000,tier=3,tree='frost'},
					mana_gem = {event='success',mainId=5405,baseDuration=120000},
					cold_snap = {event='success',mainId=11958,baseDuration=480000,allDurations={480000,446400,412800,384000},maxDuration=480000,minDuration=384000,tier=4,tree='frost'},
					ice_barrier = {event='success',mainId=11426,baseDuration=30000,allDurations={30000,27900,25800,24000},maxDuration=30000,minDuration=24000,tier=5,tree='frost'},
					presence_of_mind = {event='auraRemove',mainId=12043,baseDuration=120000,allDurations={120000,105600,96000,90000,81600,66000},maxDuration=120000,minDuration=66000,tier=3,tree='arcane'},
					mirror_image = {event='success',mainId=55342,baseDuration=180000},
					frostfire_orb = {event='success',mainId=92283,baseDuration=60000,tier=6,tree='frost'},
					improved_polymorph = {event='auraApply',mainId=83047,allIds = {83046,83047},baseDuration=10000,tier=4,tree='arcane'},
					arcane_concentration = {event='auraApply',mainId=12536,baseDuration=15000,tier=1,tree='arcane'},
					mana_shield = {event='success',mainId=1463,baseDuration=12000,allDurations={12000,10000},maxDuration=12000,minDuration=10000},
					arcane_power = {event='success',mainId=12042,baseDuration=120000,allDurations={120000,105600,90000},maxDuration=120000,minDuration=90000,tier=7,tree='arcane'},
					mage_ward = {event='success',mainId=543,baseDuration=30000},
					cauterize = {event='auraApply',mainId=87023,baseDuration=60000,tier=3,tree='fire'},
					frost_nova = {event='success',mainId=122,baseDuration=25000,allDurations={25000,23250,21500,20000},maxDuration=25000,minDuration=20000},
				},
			},
			paladin = {
				base = {
					eternal_glory = {event='energize',mainId=88676,baseDuration=15000,tier=1,tree='protection'},
					hammer_of_righteous = {event='success',mainId=53595,baseDuration=4500,tier=3,tree='protection'},
					divine_guardian = {event='success',mainId=70940,baseDuration=180000,tier=5,tree='protection'},
					ardent_defender = {event='success',mainId=31850,baseDuration=180000,tier=7,tree='protection'},
					divine_storm = {event='success',mainId=53385,baseDuration=4500,tier=3,tree='retribution',ignoreInterval=true},
					sacred_shield = {event='auraApply',mainId=96263,baseDuration=60000,tier=4,tree='retribution'},
					repentance = {event='success',mainId=20066,baseDuration=60000,tier=5,tree='retribution'},
					zealotry = {event='success',mainId=85696,baseDuration=120000,tier=7,tree='retribution'},
					crusader_strike = {event='success',mainId=35395,baseDuration=4500,ignoreInterval=true},
					guardian_of_ancient_kings = {event='success',mainId=86150,baseDuration=300000,allDurations={300000,255000,220000,180000},maxDuration=300000,minDuration=180000},
					holy_radiance = {event='success',mainId=82327,baseDuration=60000,allDurations={60000,50000,40000,30000},maxDuration=60000,minDuration=30000},
					hammer_of_wrath = {event='success',mainId=24275,baseDuration=6000},
					righteous_defense = {event='success',mainId=31789,baseDuration=8000},
					holy_wrath = {event='success',mainId=2812,baseDuration=15000},
					consecration = {event='success',mainId=26573,baseDuration=30000,allDurations={36000,30000},maxDuration=36000,minDuration=30000},
					hand_of_reckoning = {event='success',mainId=62124,baseDuration=8000,allDurations={8000,6000},maxDuration=8000,minDuration=6000},
					judgement = {event='success',mainId=20271,baseDuration=8000,allDurations={8000,7000,6000},maxDuration=8000,minDuration=6000},
					avenging_wrath = {event='success',mainId=31884,baseDuration=180000,allDurations={180000,150000,120000},maxDuration=180000,minDuration=120000},
					hammer_of_justice = {event='success',mainId=853,baseDuration=60000,allDurations={60000,50000,40000,30000},maxDuration=60000,minDuration=30000},
					lay_on_hands = {event='success',mainId=633,baseDuration=600000,allDurations={600000,420000,360000,180000},maxDuration=600000,minDuration=180000},
					divine_shield = {event='success',mainId=642,baseDuration=300000},
					divine_protection = {event='success',mainId=498,baseDuration=60000,allDurations={60000,50000,40000,30000,20000,10000},maxDuration=60000,minDuration=10000},
					divine_plea = {event='success',mainId=54428,baseDuration=120000},
					rebuke = {event='success',mainId=96231,baseDuration=10000},
					word_of_glory = {event='success',mainId=85673,baseDuration=20000,ignoreInterval=true},
					hand_of_protection = {event='success',mainId=1022,baseDuration=300000,allDurations={300000,240000,180000},maxDuration=300000,minDuration=180000},
					hand_of_freedom = {event='success',mainId=1044,baseDuration=25000,allDurations={25000,22500,20000},maxDuration=25000,minDuration=20000},
					hand_of_salvation = {event='success',mainId=1038,baseDuration=120000,allDurations={120000,108000,96000},maxDuration=120000,minDuration=96000},
					hand_of_sacrifice = {event='success',mainId=6940,baseDuration=120000,allDurations={120000,108000,105000,96000,94500,90000,84000,81000,72000},maxDuration=120000,minDuration=72000,multiCaster=true},
					holy_shock = {event='success',mainId=20473,baseDuration=6000,tier=100,tree='holy',ignoreInterval=true},
					divine_favor = {event='auraRemove',mainId=31842,baseDuration=180000,allDurations={180000,165000},maxDuration=180000,minDuration=165000,tier=3,tree='holy'},
					aura_mastery = {event='success',mainId=31821,baseDuration=120000,tier=5,tree='holy'},
					blessed_life = {event='energize',mainId=89023,baseDuration=8000,tier=6,tree='holy'},
					avengers_shield = {event='success',mainId=31935,baseDuration=15000,tier=100,tree='protection'},
				},
			},
			priest = {
				base = {
					lightwell = {event='summon',mainId=724,baseDuration=180000,tier=3,tree='holy',recordIntervalOnCast=true},
					fear_ward = {event='success',mainId=6346,baseDuration=180000,allDurations={180000,120000},maxDuration=180000,minDuration=120000},
					chakra = {event='auraRemove',mainId=14751,baseDuration=30000,tier=5,tree='holy'},
					shadow_word_death = {event='success',mainId=32379,baseDuration=10000,ignoreInterval=true},
					holy_word_serenity = {event='success',mainId=88684,baseDuration=15000,allDurations={15000,12750,10500},maxDuration=15000,minDuration=10500,tier=5,tree='holy'},
					shadowfiend = {event='success',mainId=34433,baseDuration=300000,ignoreInterval=true},
					circle_of_healing = {event='success',mainId=34861,baseDuration=10000,tier=6,tree='holy'},
					divine_hymn = {event='success',mainId=64843,baseDuration=480000},
					guardian_spirit = {event='success',mainId=47788,baseDuration=180000,allDurations={180000,150000},maxDuration=180000,minDuration=150000,tier=7,tree='holy'},
					hymn_of_hope = {event='success',mainId=64901,baseDuration=360000},
					silence = {event='success',mainId=15487,baseDuration=45000,tier=4,tree='shadow'},
					fade = {event='success',mainId=586,baseDuration=30000,allDurations={30000,27000,24000,21000,18000,15000},maxDuration=30000,minDuration=15000},
					penance_damage = {event='success',mainId=47666,baseDuration=12000,name=Tools.getSpellName(47666)..' (Damage)',icon=[[Interface\Icons\Spell_Nature_StarFall]],tier=100,tree='discipline',ignoreInterval=true,recordCooldown=2500},
					psychic_horror = {event='success',mainId=64044,baseDuration=120000,allDurations={120000,60000},maxDuration=120000,minDuration=60000,tier=6,tree='shadow'},
					dispersion = {event='success',mainId=47585,baseDuration=120000,allDurations={120000,75000},maxDuration=120000,minDuration=75000,tier=7,tree='shadow'},
					penance_heal = {event='success',mainId=47750,baseDuration=12000,name=Tools.getSpellName(47750)..' (Heal)',tier=100,tree='discipline',ignoreInterval=true,recordCooldown=2500},
					archangel = {event='auraApply',mainId=81700,baseDuration=30000,tier=2,tree='discipline'},
					dark_archangel = {event='auraApply',mainId=87153,baseDuration=90000,tier=2,tree='discipline'},
					power_infusion = {event='success',mainId=10060,baseDuration=120000,tier=3,tree='discipline'},
					inner_focus = {event='auraRemove',mainId=89485,baseDuration=45000,tier=3,tree='discipline',ignoreInterval=true},
					power_word_shield = {event='success',mainId=17,baseDuration=3000,allDurations={3000,2000,1000},maxDuration=3000,minDuration=1000},
					rapture = {event='energize',mainId=47755,baseDuration=12000,tier=4,tree='discipline'},
					mind_blast = {event='damage',mainId=8092,baseDuration=8000,allDurations={8000,7500,7000,6500},maxDuration=8000,minDuration=6500,recordIntervalOnCast=true},
					pain_suppression = {event='success',mainId=33206,baseDuration=180000,tier=9,tree='discipline'},
					leap_of_faith = {event='success',mainId=73325,baseDuration=90000},
					power_word_barrier = {event='summon',mainId=62618,baseDuration=180000,tier=7,tree='discipline'},
					prayer_of_mending = {event='success',mainId=33076,baseDuration=10000,allDurations={10000,8000},maxDuration=10000,minDuration=8000},
					holy_word_chastise = {event='success',mainId=88625,baseDuration=30000,allDurations={30000,25500,21000},maxDuration=30000,minDuration=21000,tier=100,tree='holy'},
					holy_fire = {event='damage',mainId=14914,baseDuration=10000},
					desperate_prayer = {event='success',mainId=19236,baseDuration=120000,tier=2,tree='holy'},
					psychic_scream = {event='success',mainId=8122,baseDuration=30000,allDurations={33000,31000,30000,29000,28000,27000,26000,25000,23000},maxDuration=33000,minDuration=23000},
				},
			},
			rogue = {
				base = {
					shadow_dance = {event='success',mainId=51713,baseDuration=60000,tier=7,tree='subtlety'},
					vanish = {event='success',mainId=1856,baseDuration=180000,allDurations={180000,150000,120000,90000},maxDuration=180000,minDuration=90000},
					kidney_shot = {event='success',mainId=408,baseDuration=20000},
					blind = {event='success',mainId=2094,baseDuration=180000,allDurations={180000,175000,150000,145000,120000,115000},maxDuration=180000,minDuration=115000},
					cloak_of_shadows = {event='success',mainId=31224,baseDuration=120000,allDurations={120000,105000,90000},maxDuration=120000,minDuration=90000},
					tricks_of_the_trade = {event='success',mainId=57934,baseDuration=30000},
					redirect = {event='success',mainId=73981,baseDuration=60000,ignoreInterval=true},
					smoke_bomb = {event='success',mainId=76577,baseDuration=180000},
					combat_readiness = {event='success',mainId=74001,baseDuration=120000},
					cold_blood = {event='auraRemove',mainId=14177,baseDuration=120000,tier=3,tree='assassination'},
					vendetta = {event='success',mainId=79140,baseDuration=120000,tier=7,tree='assassination'},
					blade_flurry = {event='auraApply',mainId=13877,baseDuration=10000,tier=100,tree='combat'},
					adrenaline_rush = {event='success',mainId=13750,baseDuration=180000,tier=5,tree='combat',ignoreInterval=true},
					feint = {event='success',mainId=1966,baseDuration=10000},
					killing_spree = {event='success',mainId=51690,baseDuration=120000,tier=7,tree='combat',ignoreInterval=true},
					stealth = {event='auraRemove',mainId=1784,baseDuration=6000,allDurations={6000,4000,2000},maxDuration=6000,minDuration=2000},
					shadowstep = {event='success',mainId=36554,baseDuration=24000,tier=100,tree='subtlety'},
					distract = {event='success',mainId=1725,baseDuration=30000},
					gouge = {event='success',mainId=1776,baseDuration=10000,allDurations={10000,9000},maxDuration=10000,minDuration=9000},
					premeditation = {event='success',mainId=14183,baseDuration=20000,tier=4,tree='subtlety'},
					evasion = {event='success',mainId=5277,baseDuration=180000,allDurations={180000,120000},maxDuration=180000,minDuration=120000},
					cheat_death = {event='auraApply',mainId=45182,baseDuration=90000,name=Tools.getSpellName(31231),tier=5,tree='subtlety'},
					sprint = {event='success',mainId=2983,baseDuration=60000,ignoreInterval=true},
					kick = {event='success',mainId=1766,baseDuration=10000,ignoreInterval=true},
					preparation = {event='success',mainId=14185,baseDuration=300000,tier=5,tree='subtlety'},
					dismantle = {event='success',mainId=51722,baseDuration=60000},
				},
			},
			shaman = {
				base = {
					elemental_mastery = {event='auraRemove',mainId=16166,baseDuration=180000,tier=5,tree='elemental',ignoreInterval=true},
					lava_lash = {event='success',mainId=60103,baseDuration=10000,tier=100,tree='enhancement'},
					stormstrike = {event='success',mainId=17364,baseDuration=8000,tier=3,tree='enhancement'},
					shamanistic_rage = {event='success',mainId=30823,baseDuration=60000,tier=5,tree='enhancement'},
					feral_spirit = {event='success',mainId=51533,baseDuration=120000,tier=7,tree='enhancement'},
					natures_guardian = {event='auraApply',mainId=31616,baseDuration=30000,tier=2,tree='restoration'},
					cleansing_waters = {event='heal',mainId=86961,allIds = {86958,86961},baseDuration=6000,tier=4,tree='restoration'},
					mana_tide_totem = {event='success',mainId=16190,baseDuration=180000,tier=5,tree='restoration'},
					spirit_link_totem = {event='success',mainId=98008,baseDuration=180000,tier=5,tree='restoration'},
					rip_tide = {event='success',mainId=61295,baseDuration=6000,allDurations={6000,5000},maxDuration=6000,minDuration=5000,tier=7,tree='restoration'},
					natures_swiftness = {event='auraRemove',mainId=16188,baseDuration=120000,allDurations={120000,96000},maxDuration=120000,minDuration=96000,tier=3,tree='restoration'},
					lighting_shield = {event='damage',mainId=26364,baseDuration=3500},
					water_shield = {event='energize',mainId=52128,baseDuration=3500},
					fire_nova = {event='success',mainId=1535,baseDuration=4000},
					chain_lightning = {event='damage',mainId=421,baseDuration=3000,recordIntervalOnCast=true},
					lava_burst = {event='damage',mainId=51505,baseDuration=8000,ignoreInterval=true},
					wind_shear = {event='success',mainId=57994,baseDuration=6000,allDurations={6000,5500,5000},maxDuration=6000,minDuration=5000},
					bloodlust = {event='success',mainId=2825,baseDuration=300000},
					heroism = {event='success',mainId=32182,baseDuration=300000},
					hex = {event='auraApply',mainId=51514,baseDuration=45000,allDurations={45000,30000},maxDuration=45000,minDuration=30000},
					primal_strike = {event='success',mainId=73899,baseDuration=8000},
					spiritwalkers_grace = {event='success',mainId=79206,baseDuration=120000},
					healing_rain = {event='summon',mainId=73920,baseDuration=10000},
					unleash_elements = {event='success',mainId=73680,baseDuration=15000},
					frost_shock = {event='success',mainId=8056,baseDuration=6000,allDurations={6000,5500,5000},maxDuration=6000,minDuration=5000},
					flame_shock = {event='success',mainId=8050,baseDuration=6000,allDurations={6000,5500,5000},maxDuration=6000,minDuration=5000},
					earth_shock = {event='success',mainId=8042,baseDuration=6000,allDurations={6000,5500,5000},maxDuration=6000,minDuration=5000},
					tremor_totem = {event='success',mainId=8143,baseDuration=60000},
					stoneclaw_totem = {event='success',mainId=5730,baseDuration=20000},
					earthbind_totem = {event='success',mainId=2484,baseDuration=15000},
					grounding_totem = {event='success',mainId=8177,baseDuration=25000,allDurations={60000,57000,25000,22000},maxDuration=60000,minDuration=22000},
					earth_elemental_totem = {event='success',mainId=2062,baseDuration=600000},
					fire_elemental_totem = {event='success',mainId=2894,baseDuration=600000,allDurations={600000,300000},maxDuration=600000,minDuration=300000},
					thunderstorm = {event='success',mainId=51490,baseDuration=45000,allDurations={45000,35000},maxDuration=45000,minDuration=35000,tier=100,tree='elemental'},
				},
			},
			warlock = {
				base = {
					summon_doomguard = {event='success',mainId=18540,baseDuration=600000},
					summon_infernal = {event='summon',mainId=1122,baseDuration=600000,recordIntervalOnCast=true},
					demon_soul = {event='success',mainId=77801,baseDuration=120000},
					haunt = {event='auraApply',mainId=48181,baseDuration=8000,tier=7,tree='affliction',recordIntervalOnCast=true},
					demonic_rebirth = {event='auraApply',mainId=88448,baseDuration=120000,tier=2,tree='demonology'},
					demonic_empowerment = {event='success',mainId=47193,baseDuration=60000,tier=3,tree='demonology'},
					hand_of_guldan = {event='success',mainId=71521,baseDuration=12000,tier=4,tree='demonology'},
					metamorphosis = {event='success',mainId=47241,baseDuration=180000,tier=7,tree='demonology',ignoreInterval=true},
					immolation_aura = {event='success',mainId=50589,baseDuration=30000,tier=7,tree='demonology'},
					demon_charge = {event='success',mainId=54785,baseDuration=45000,tier=7,tree='demonology'},
					conflagrate = {event='success',mainId=17962,baseDuration=10000,allDurations={10000,8000},maxDuration=10000,minDuration=8000,tier=100,tree='destruction'},
					soulstone = {event='auraApply',mainId=20707,baseDuration=1800000},
					soulshatter = {event='success',mainId=29858,baseDuration=120000},
					shadowburn = {event='success',mainId=17877,baseDuration=15000,tier=3,tree='destruction',ignoreInterval=true},
					howl_of_terror = {event='auraApply',mainId=5484,baseDuration=40000,allDurations={40000,32000},maxDuration=40000,minDuration=32000},
					backlash = {event='auraApply',mainId=34936,baseDuration=8000,tier=4,tree='destruction'},
					death_coil = {event='success',mainId=6789,baseDuration=120000,allDurations={120000,102000},maxDuration=120000,minDuration=102000},
					nether_ward = {event='success',mainId=91711,baseDuration=30000,tier=4,tree='destruction'},
					shadow_ward = {event='success',mainId=6229,baseDuration=30000},
					shadowfury = {event='success',mainId=30283,baseDuration=20000,tier=5,tree='destruction'},
					shadowflame = {event='success',mainId=47897,baseDuration=12000},
					chaos_bolt = {event='damage',mainId=50796,baseDuration=12000,allDurations={12000,10000},maxDuration=12000,minDuration=10000,tier=7,tree='destruction',recordIntervalOnCast=true},
					demonic_circle_teleport = {event='success',mainId=48020,baseDuration=30000,allDurations={30000,26000,25000,21000},maxDuration=30000,minDuration=21000},
					soul_harvest = {event='success',mainId=79268,baseDuration=30000},
					soul_burn = {event='success',mainId=74434,baseDuration=45000},
				},
			},
			warrior = {
				base = {
					shield_block = {event='success',mainId=2565,baseDuration=60000,allDurations={60000,50000,40000,30000,20000},maxDuration=60000,minDuration=20000},
					disarm = {event='success',mainId=676,baseDuration=60000},
					retaliation = {event='success',mainId=20230,baseDuration=300000},
					intimidating_shout = {event='success',mainId=5246,baseDuration=120000,allDurations={120000,105000},maxDuration=120000,minDuration=105000},
					shield_wall = {event='success',mainId=871,baseDuration=300000,allDurations={420000,360000,300000,240000,180000,120000},maxDuration=420000,minDuration=120000},
					intercept = {event='success',mainId=20252,baseDuration=30000,allDurations={30000,25000,20000},maxDuration=30000,minDuration=20000},
					berserker_rage = {event='success',mainId=18499,baseDuration=30000,allDurations={30000,27000,24000},maxDuration=30000,minDuration=24000},
					recklessness = {event='success',mainId=1719,baseDuration=300000,allDurations={300000,270000,240000},maxDuration=300000,minDuration=240000},
					intervene = {event='success',mainId=3411,baseDuration=30000},
					spell_reflection = {event='success',mainId=23920,baseDuration=25000,allDurations={25000,20000},maxDuration=25000,minDuration=20000},
					shattering_throw = {event='damage',mainId=64382,baseDuration=300000,recordIntervalOnCast=true},
					enraged_regeneration = {event='success',mainId=55694,baseDuration=180000},
					heroic_throw = {event='success',mainId=57755,baseDuration=60000,allDurations={60000,45000,30000},maxDuration=60000,minDuration=30000},
					pummel = {event='success',mainId=6552,baseDuration=10000},
					inner_rage = {event='success',mainId=1134,baseDuration=30000},
					rallying_cry = {event='success',mainId=97462,baseDuration=180000},
					mortal_strike = {event='success',mainId=12294,baseDuration=4500,tier=100,tree='arms'},
					taste_for_blood = {event='auraApply',mainId=60503,baseDuration=5000,tier=3,tree='arms'},
					sweeping_strikes = {event='success',mainId=12328,baseDuration=60000,tier=3,tree='arms'},
					improved_hamstring = {event='auraApply',mainId=23694,baseDuration=60000,allDurations={60000,30000},maxDuration=60000,minDuration=30000,tier=3,tree='arms'},
					deadly_calm = {event='success',mainId=85730,baseDuration=120000,tier=4,tree='arms'},
					throwdown = {event='success',mainId=85388,baseDuration=45000,tier=6,tree='arms'},
					bladestorm = {event='success',mainId=46924,baseDuration=90000,allDurations={90000,75000},maxDuration=90000,minDuration=75000,tier=7,tree='arms'},
					bloodthirst = {event='success',mainId=23881,baseDuration=3000,tier=100,tree='fury'},
					death_wish = {event='success',mainId=12292,baseDuration=180000,allDurations={180000,162000,144000},maxDuration=180000,minDuration=144000,tier=3,tree='fury'},
					die_by_the_sword = {event='auraApply',mainId=86624,allIds = {85386,86624},baseDuration=120000,tier=4,tree='fury'},
					heroic_fury = {event='success',mainId=60970,baseDuration=30000,tier=4,tree='fury'},
					shield_slam = {event='success',mainId=23922,baseDuration=6000,tier=100,tree='protection'},
					cleave = {event='success',mainId=845,baseDuration=3000},
					last_stand = {event='success',mainId=12975,baseDuration=180000,tier=3,tree='protection'},
					colossus_smash = {event='success',mainId=86346,baseDuration=20000,ignoreInterval=true},
					concussion_blow = {event='success',mainId=12809,baseDuration=30000,tier=3,tree='protection'},
					battle_shout = {event='success',mainId=6673,baseDuration=60000,allDurations={60000,45000,30000},maxDuration=60000,minDuration=30000},
					shockwave = {event='success',mainId=46968,baseDuration=20000,allDurations={20000,17000},maxDuration=20000,minDuration=17000,tier=7,tree='protection'},
					commanding_shout = {event='success',mainId=469,baseDuration=60000,allDurations={60000,45000,30000},maxDuration=60000,minDuration=30000},
					heroic_strike = {event='success',mainId=78,baseDuration=3000},
					heroic_leap = {event='success',mainId=52174,baseDuration=60000,allDurations={60000,50000,40000},maxDuration=60000,minDuration=40000},
					strike = {event='success',mainId=88161,baseDuration=3000},
					revenge = {event='success',mainId=6572,baseDuration=5000},
					whirlwind = {event='success',mainId=1680,baseDuration=10000,ignoreInterval=true},
					thunder_clap = {event='success',mainId=6343,baseDuration=6000},
					challenging_shout = {event='success',mainId=1161,baseDuration=180000},
					taunt = {event='success',mainId=355,baseDuration=8000,ignoreInterval=true},
					charge = {event='success',mainId=100,baseDuration=15000,allDurations={15000,13950,13000,12090},maxDuration=15000,minDuration=12090},
				},
			}
		}
	},
	talent = {
		deathknight = {
			[55050] = {tree = 'blood', tier = 100}, -- Heart Strike (Specialization)
			[51789] = {tree = 'blood', tier = 1}, -- Blade Barrier (Rank 1)
			[64855] = {tree = 'blood', tier = 1}, -- Blade Barrier (Rank 2)
			[64856] = {tree = 'blood', tier = 1}, -- Blade Barrier (Rank 3)
			[81130] = {tree = 'blood', tier = 2}, -- Scarlet Fever (Rank 1/2)
			[50463] = {tree = 'blood', tier = 3}, -- blood-Caked Strike (Rank 1/2/3)
			--[49222] = {tree = 'blood', tier = 3}, -- Bone Shield
			[50452] = {tree = 'blood', tier = 4}, -- blood Parasite (Rank 1/2)
			--[48982] = {tree = 'blood', tier = 5}, -- Rune Tap
			--[55233] = {tree = 'blood', tier = 5}, -- Vampiric blood
			[81141] = {tree = 'blood', tier = 6}, -- Crimson Scourge (blood Swarm)(Rank 1/2)
			-- blood Shield (Mastery)
			-- Vengeance
			-- Butchery
			-- Scent of blood
			-- Abomination's Might
			-- Will of the Necropolis
			-- Dancing Rune Weapon
			
			[49143] = {tree = 'frost', tier = 100}, -- frost Strike (Specialization)
			--[49039] = {tree = 'frost', tier = 2}, -- Lichborne
			[51124] = {tree = 'frost', tier = 3}, -- Killing Machine (Rank 1/2/3)
			--[] = {tree = 'frost', tier = 4}, -- Rime (Rank 1/2/3)
			--[51271] = {tree = 'frost', tier = 4}, -- Pillar of frost
			[81325] = {tree = 'frost', tier = 4}, -- Brittle Bones (Rank 1)
			[81326] = {tree = 'frost', tier = 4}, -- Brittle Bones (Rank 2)
			[50434] = {tree = 'frost', tier = 5}, -- Chillblains (Rank 1)
			[50435] = {tree = 'frost', tier = 5}, -- Chillblains (Rank 2)
			--[49203] = {tree = 'frost', tier = 5}, -- Hungering Cold (success)
			[51209] = {tree = 'frost', tier = 5}, -- Hungering Cold (APPLY/auraRemove)
			[81331] = {tree = 'frost', tier = 6}, -- Might of the Frozen Wastes
			-- Improved Icy Talons
			-- Threat of Thassarian
			-- Howling Blast
			
			--[52150] = {tree = 'unholy', tier = 100}, -- Raise Dead (Guardian)(Specialization)
			[55741] = {tree = 'unholy', tier = 2}, -- Desecration (Rank 1)
			[68766] = {tree = 'unholy', tier = 2}, -- Desecration (Rank 2)
			--[49016] = {tree = 'unholy', tier = 2}, -- unholy Frenzy 
			[91342] = {tree = 'unholy', tier = 3}, -- shadow Infusion
			[50536] = {tree = 'unholy', tier = 5}, -- unholy Blight
			--[51052] = {tree = 'unholy', tier = 5}, -- Anti-Magic Zone
			[63560] = {tree = 'unholy', tier = 5}, -- Dark Transformation
			[65142] = {tree = 'unholy', tier = 6}, -- Ebon Plaguebringer (Rank 1)
			[81340] = {tree = 'unholy', tier = 6}, -- Sudden Doom (Rank 1/2/3)
			-- unholy Command
			-- Resilient Infection
			-- Runic Corruption
			-- Magic Suppression
			-- Ebon Plaguebringer (Rank 2/3)
			-- Summon Gargoyle			
		},
		druid = {
			--[78674] = {tree = 'balance', tier = 100}, -- Starsurge (START/DAMAGE)(Specialization)
			[86605] = {tree = 'balance', tier = 100}, -- Starsurge (energize)(Specialization)
			--[16886] = {tree = 'balance', tier = 1}, -- Nature's Grace (Rank 1/2/3)
			[24858] = {tree = 'balance', tier = 3}, -- Moonkin Form (success/APPLY/auraRemove)
			[24907] = {tree = 'balance', tier = 3}, -- Moonkin Form (Moonkin Aura)(APPLY/auraRemove) 
			--[61391] = {tree = 'balance', tier = 3}, -- Typhoon
			[93400] = {tree = 'balance', tier = 3}, -- Shooting Stars (Rank 1/2)
			--[78675] = {tree = 'balance', tier = 4}, -- Solar Beam (success)
			[81261] = {tree = 'balance', tier = 4}, -- Solar Beam (summon/APPLY/auraRemove)
			--[33831] = {tree = 'balance', tier = 5}, -- Force of Nature
			[93402] = {tree = 'balance', tier = 5}, -- Sunfire
			[60433] = {tree = 'balance', tier = 5}, -- Earth and Moon
			[81006] = {tree = 'balance', tier = 6}, -- Lunar Shower (Rank 1)
			[81191] = {tree = 'balance', tier = 6}, -- Lunar Shower (Rank 2)
			[81192] = {tree = 'balance', tier = 6}, -- Lunar Shower (Rank 3)
			--[48505] = {tree = 'balance', tier = 7}, -- Starfall (success/APPLY/auraRemove)
			[50288] = {tree = 'balance', tier = 7}, -- Starfall (DAMAGE)
			-- Moonkin Frenzy
			-- Fungal Growth
			-- Eclipse (energize)
			
			[33876] = {tree = 'feralCombat', tier = 100}, -- Mangle (Cat)(Specialization)
			--[33878] = {tree = 'feralCombat', tier = 100}, -- Mangle (Bear)(Specialization)
			[17057] = {tree = 'feralCombat', tier = 1}, -- Furor (Bear)(Rank 1/2/3)
			[69369] = {tree = 'feralCombat', tier = 1}, -- Predatory Strikes (Predator's Swiftness)(Rank 1/2)
			[58179] = {tree = 'feralCombat', tier = 2}, -- Infected Wounds (Rank 1)
			[58180] = {tree = 'feralCombat', tier = 2}, -- Infected Wounds (Rank 2)
			--[80861] = {tree = 'feralCombat', tier = 2}, -- fury Swipes (Rank 1/2/3)
			[16959] = {tree = 'feralCombat', tier = 2}, -- Primal fury (Bear)(Rank 1/2)
			[51185] = {tree = 'feralCombat', tier = 3}, -- King of the Jungle (Bear)(Rank 1/2/3)
			[51178] = {tree = 'feralCombat', tier = 3}, -- King of the Jungle (Cat)(Rank 1/2/3)
			--[16979] = {tree = 'feralCombat', tier = 3}, -- feralCombat Charge (Bear)
			[45334] = {tree = 'feralCombat', tier = 3}, -- feralCombat Charge (Bear)(feralCombat Charge Effect)
			--[49376] = {tree = 'feralCombat', tier = 3}, -- feralCombat Charge (Cat)
			[50259] = {tree = 'feralCombat', tier = 3}, -- feralCombat Charge (Cat)(Dazed)
			[81016] = {tree = 'feralCombat', tier = 3}, -- Stampede (Bear)(Rank 1)
			[81017] = {tree = 'feralCombat', tier = 3}, -- Stampede (Bear)(Rank 2)
			[81021] = {tree = 'feralCombat', tier = 3}, -- Stampede (Cat)(Rank 1)
			[81022] = {tree = 'feralCombat', tier = 3}, -- Stampede (Cat)(Rank 2)
			[24932] = {tree = 'feralCombat', tier = 4}, -- Leader of the Pack (Crit Buff)
			[34299] = {tree = 'feralCombat', tier = 4}, -- Leader of the Pack (P_HEAL)
			--[68285] = {tree = 'feralCombat', tier = 4}, -- Leader of the Pack (energize)
			[82364] = {tree = 'feralCombat', tier = 4}, -- Brutal Impact (Skull Bash)(Rank 1)
			[82365] = {tree = 'feralCombat', tier = 4}, -- Brutal Impact (Skull Bash)(Rank 2)
			[80879] = {tree = 'feralCombat', tier = 5}, -- Primal Madness (Rank 1)
			[80886] = {tree = 'feralCombat', tier = 5}, -- Primal Madness (Rank 2)
			--[61336] = {tree = 'feralCombat', tier = 5}, -- survival Instincts
			[80313] = {tree = 'feralCombat', tier = 6}, -- Pulverize (success/DAMAGE)
			[80951] = {tree = 'feralCombat', tier = 6}, -- Pulverize (APPLY/auraRemove)
			--[50334] = {tree = 'feralCombat', tier = 7}, -- Berserk
			-- Vengeance
			-- Primal Madness (Bear)(Enrage)(energize fires)
			-- Natural Reaction
			-- berserk proc
			
			--[18562] = {tree = 'restoration', tier = 100}, -- Swiftmend (Specialization)
			[48418] = {tree = 'restoration', tier = 2}, -- Master Shapeshifter (Bear)
			[48420] = {tree = 'restoration', tier = 2}, -- Master Shapeshifter (Cat)
			--[] = {tree = 'restoration', tier = 2}, -- Master Shapeshifter (Moonkin)
			[48504] = {tree = 'restoration', tier = 3}, -- Living Seed (Rank 1/2/3)
			--[81094] = {tree = 'restoration', tier = 3}, -- Revitalize (Rank 1/2/3)
			--[17116] = {tree = 'restoration', tier = 3}, -- Nature's Swiftness
			[81093] = {tree = 'restoration', tier = 3}, -- fury of Stormrage (Rank 1/2)
			[81262] = {tree = 'restoration', tier = 5}, -- Efflorescence (Rank 1/2/3)
			--[48438] = {tree = 'restoration', tier = 5}, -- Wild Growth
			[64801] = {tree = 'restoration', tier = 6}, -- Gift of the Earthmother (Rank 1/2/3)
			--[33891] = {tree = 'restoration', tier = 7}, -- Tree of Life
			[94447] = {tree = 'restoration', tier = 7}, -- Tree of Life (Lifebloom)(P_HEAL)
			-- Living Seed (HEAL)
			-- Revitalize (Replenishment)
			-- Nature's Cure
			-- Nature's Ward
			-- Tree of Life (Entangling Roots)(success fires)
			-- Tree of Life (Regrowth)(success fires)
		},
		hunter = {
			[53257] = {tree = 'beastMastery', tier = 3}, -- Cobra Strikes (Rank 1/2/3)
			--[82726] = {tree = 'beastMastery', tier = 3}, -- Fervor (success)
			[82728] = {tree = 'beastMastery', tier = 3}, -- Fervor (energize)
			--[82692] = {tree = 'beastMastery', tier = 3}, -- Focus fire (success/APPLY/auraRemove)
			[83468] = {tree = 'beastMastery', tier = 3}, -- Focus fire (energize)
			[94006] = {tree = 'beastMastery', tier = 4}, -- Killing Streak (Rank 1)
			[94007] = {tree = 'beastMastery', tier = 4}, -- Killing Streak (Rank 2)
			--[19574] = {tree = 'beastMastery', tier = 5}, -- Bestial Wrath
			[34471] = {tree = 'beastMastery', tier = 6}, -- The Beast Within
			[53398] = {tree = 'beastMastery', tier = 6}, -- Invigoration (Rank 1/2)
			-- Improved Mend Pet
			-- Ferocious Inspiration
			-- Intimidation
			
			[19434] = {tree = 'marksmanship', tier = 100}, -- Aimed Shot (Specialization)
			[76663] = {tree = 'marksmanship', tier = 100}, -- Wild Quiver (Mastery)(Specialization)
			[34952] = {tree = 'marksmanship', tier = 1}, -- Go for the Throat (Rank 1)
			[34953] = {tree = 'marksmanship', tier = 1}, -- Go for the Throat (Rank 2)
			[83359] = {tree = 'marksmanship', tier = 2}, -- Sic' Em! (Rank 1)
			[89388] = {tree = 'marksmanship', tier = 2}, -- Sic' Em! (Rank 2)
			[53220] = {tree = 'marksmanship', tier = 2}, -- Improved Steady Shot (Rank 1/2/3)
			--[34490] = {tree = 'marksmanship', tier = 3}, -- Silencing Shot
			[35101] = {tree = 'marksmanship', tier = 3}, -- Concussive Barrage (Rank 1/2)
			[63468] = {tree = 'marksmanship', tier = 3}, -- Piercing Shots (Rank 1/2/3)
			[82921] = {tree = 'marksmanship', tier = 4}, -- Bombardment (Rank 1/2)
			[82925] = {tree = 'marksmanship', tier = 5}, -- Master Marksman (Ready, Set, Aim...)(Rank 1/2/3)
			--[23989] = {tree = 'marksmanship', tier = 5}, -- Readiness
			[83559] = {tree = 'marksmanship', tier = 6}, -- Posthaste (Rank 1/2)
			[88691] = {tree = 'marksmanship', tier = 6}, -- Marked For Death (Rank 1/2)
			--[53209] = {tree = 'marksmanship', tier = 7}, -- Chimera Shot (success/DAMAGE)
			[53353] = {tree = 'marksmanship', tier = 7}, -- Chimera Shot (HEAL)
			-- Rapid Killing
			-- Trueshot Aura
			-- Termination
			-- Resistance is Futile
			
			--[53301] = {tree = 'survival', tier = 100}, -- Explosive Shot (Specialization)
			[83077] = {tree = 'survival', tier = 1}, -- Improved Serpent Sting (Rank 1/2)
			[34720] = {tree = 'survival', tier = 3}, -- Thrill of the Hunt
			--[19386] = {tree = 'survival', tier = 5}, -- Wyvern Sting
			[64418] = {tree = 'survival', tier = 6}, -- Sniper Training (Rank 1)
			[64419] = {tree = 'survival', tier = 6}, -- Sniper Training (Rank 2)
			[64420] = {tree = 'survival', tier = 6}, -- Sniper Training (Rank 3)
			[88453] = {tree = 'survival', tier = 6}, -- Serpent Spread (Serpent Sting)(Rank 1)
			[88466] = {tree = 'survival', tier = 6}, -- Serpent Spread (Serpent Sting)(Rank 2)
			--[3674] = {tree = 'survival', tier = 7}, -- Black Arrow
			--[56453] = {tree = 'survival', tier = 4}, -- T.N.T. (Rank 1/2)
			-- Entrapment
			-- Counterattack
			-- Lock and Load
			-- Mirrored Blades
			-- Noxious Stings
			-- Hunting Party
		},
		mage = {
			--[44425] = {tree = 'arcane', tier = 100}, -- arcane Barrage (Specialization)
			--[12536] = {tree = 'arcane', tier = 1}, -- arcane Concentration (Clearcasting)(Rank 1/2/3)
			[18469] = {tree = 'arcane', tier = 1}, -- Improved Counterspell (Silenced - Improved Counterspell)(Rank 1)
			[55021] = {tree = 'arcane', tier = 1}, -- Improved Counterspell (Silenced - Improved Counterspell)(Rank 2)
			[47000] = {tree = 'arcane', tier = 2}, -- Improved Blink (Rank 1)
			[46989] = {tree = 'arcane', tier = 2}, -- Improved Blink (Rank 2)
			--[12043] = {tree = 'arcane', tier = 3}, -- Presence of Mind
			[57529] = {tree = 'arcane', tier = 5}, -- arcane Potency (Rank 1)
			[57531] = {tree = 'arcane', tier = 5}, -- arcane Potency (Rank 2)
			[31589] = {tree = 'arcane', tier = 5}, -- Slow
			[83098] = {tree = 'arcane', tier = 6}, -- Improved Mana Gem (Rank 1/2)
			--[12042] = {tree = 'arcane', tier = 7}, -- arcane Power
			-- Invocation
			-- Improved Polymorph
			-- arcane Tatics
			-- Incanter's Absorption
			-- Focus Magic
		
			[11366] = {tree = 'fire', tier = 100}, -- Pyroblast (Specialization)
 			[29077] = {tree = 'fire', tier = 1}, -- Master of Elements (Rank 1/2)
			[12654] = {tree = 'fire', tier = 2}, -- Ignite (Rank 1/2/3)
			[64343] = {tree = 'fire', tier = 2}, -- Impact (Buff)(APPLY/auraRemove)
			[12355] = {tree = 'fire', tier = 2}, -- Impact (Stun)(APPLY/auraRemove)
			--[11113] = {tree = 'fire', tier = 3}, -- Blast Wave
			[48108] = {tree = 'fire', tier = 3}, -- Hot Streak
			--[11129] = {tree = 'fire', tier = 4}, -- Combustion (success/DAMAGE)
			[83853] = {tree = 'fire', tier = 4}, -- Combustion (APPLY/P_DAMAGE/auraRemove)
			[88148] = {tree = 'fire', tier = 5}, -- Improved Flamestrike (Flamestrike)(Rank 1/2)
			--[31661] = {tree = 'fire', tier = 5}, -- Dragon's Breath
			[83582] = {tree = 'fire', tier = 6}, -- Pyromaniac (Rank 1/2)
			[22959] = {tree = 'fire', tier = 6}, -- Critical Mass (Rank 1/2/3)
			[44457] = {tree = 'fire', tier = 7}, -- Living Bomb (success/APPLY/auraRemove)
			[44461] = {tree = 'fire', tier = 7}, -- Living Bomb (DAMAGE)
			-- fire Power
			-- Blazing Speed
			-- Cauterize
			-- Molten Shields
			
			--[31687] = {tree = 'frost', tier = 100}, -- Summon Water elemental (Specialization)
			[83301] = {tree = 'frost', tier = 2}, -- Improved Cone of Cold (Rank 1)
			[83302] = {tree = 'frost', tier = 2}, -- Improved Cone of Cold (Rank 2)
			[83154] = {tree = 'frost', tier = 2}, -- Piercing Chill (Rank 1/2)
			[91394] = {tree = 'frost', tier = 2}, -- Permafrost (HEAL)(Rank 1)
			--[12472] = {tree = 'frost', tier = 3}, -- Icy Veins
			[44544] = {tree = 'frost', tier = 3}, -- Fingers of frost (Rank 1/2/3)
			--[11958] = {tree = 'frost', tier = 4}, -- Cold Snap
			[57761] = {tree = 'frost', tier = 4}, -- Brain Freeze (Rank 1/2/3)
			--[11426] = {tree = 'frost', tier = 5}, -- Ice Barrier
			--[44572] = {tree = 'frost', tier = 7}, -- Deep Freeze
			-- Permafrost
			-- Enduring Winter
			-- Shattered Barrier
			-- Reactive Barrier
			-- Frostfire Orb
			-- Deep Freeze (Damage)
		},
		paladin = {
			--[20473] = {tree = 'holy', tier = 100}, -- holy Shock (Heal)(success/energize)(Specialization)
			[25914] = {tree = 'holy', tier = 100}, -- holy Shock (HEAL/MISS)(Specialization)
			[25912] = {tree = 'holy', tier = 100}, -- holy Shock (DAMAGE/MISS)(Specialization)
			[86273] = {tree = 'holy', tier = 100}, -- Illuminated Healing (Mastery)(Specialization)
			[94286] = {tree = 'holy', tier = 1}, -- Protector of the Innocent (Rank 1)
			[94288] = {tree = 'holy', tier = 1}, -- Protector of the Innocent (Rank 2)
			[94289] = {tree = 'holy', tier = 1}, -- Protector of the Innocent (Rank 3)
			[53655] = {tree = 'holy', tier = 1}, -- Judgements of the Pure (Rank 1)
			[53656] = {tree = 'holy', tier = 1}, -- Judgements of the Pure (Rank 2)
			[53657] = {tree = 'holy', tier = 1}, -- Judgements of the Pure (Rank 3)
			[85509] = {tree = 'holy', tier = 3}, -- Denounce (Rank 1/2)
			--[31842] = {tree = 'holy', tier = 3}, -- Divine Favor
			[53672] = {tree = 'holy', tier = 3}, -- Infusion of Light (Rank 1)
			[54149] = {tree = 'holy', tier = 3}, -- Infusion of Light (Rank 2)
			[88819] = {tree = 'holy', tier = 3}, -- Daybreak (Rank 1/2)
			[87188] = {tree = 'holy', tier = 4}, -- Enlightened Judgements (Rank 1)
			[87189] = {tree = 'holy', tier = 4}, -- Enlightened Judgements (Rank 2)
			[85496] = {tree = 'holy', tier = 4}, -- Speed of Light (holy Shock)(Rank 1)
			[20050] = {tree = 'holy', tier = 5}, -- Conviction (Rank 1)
			[20052] = {tree = 'holy', tier = 5}, -- Conviction (Rank 2)
			[20053] = {tree = 'holy', tier = 5}, -- Conviction (Rank 3)
			--[31821] = {tree = 'holy', tier = 5}, -- Aura Mastery
			[85222] = {tree = 'holy', tier = 7}, -- Light of the Dawn
			-- Beacon of Light
			-- Speed of Light (holy Radiance)(Rank 1/2/3)
			-- Sacred Cleansing
			-- Tower of Radiance
			-- Blessed Life
		
			--[31935] = {tree = 'protection', tier = 100}, -- Avenger's Shield (Specialization)
			[31930] = {tree = 'protection', tier = 100}, -- Judgements of the Wise (Specialization)
			[68055] = {tree = 'protection', tier = 2}, -- Judgements of the Just (Rank 1/2)
			--[53595] = {tree = 'protection', tier = 3}, -- Hammer of the Righteous (success/energize/DAMAGE)
			[88263] = {tree = 'protection', tier = 3}, -- Hammer of the Righteous (success/DAMAGE)
			[53600] = {tree = 'protection', tier = 4}, -- Shield of the Righteous
			[26017] = {tree = 'protection', tier = 5}, -- Vindication
			[87342] = {tree = 'protection', tier = 5}, -- holy Shield
			[88063] = {tree = 'protection', tier = 5}, -- Guarded by the Light (Rank 1/2)
			[85416] = {tree = 'protection', tier = 4}, -- Grand Crusader (Rank 1/2)
			[85433] = {tree = 'protection', tier = 6}, -- Sacred Duty (Rank 1/2)
			--[31850] = {tree = 'protection', tier = 7}, -- Ardent Defender (success/APPLY/auraRemove)
			-- Vengeance
			-- Sanctuary
			-- Reckoning
			-- Vindication
			-- Divine Guardian
			-- Ardent Defender (Heal)
			
			[85256] = {tree = 'retribution', tier = 100}, -- Templar's Verdict (Specialization)
			[90174] = {tree = 'retribution', tier = 100}, -- Hand of Light (Mastery)(Specialization)
			[89906] = {tree = 'retribution', tier = 100}, -- Judgements of the Bold (Specialization)
			[59578] = {tree = 'retribution', tier = 3}, -- The Art of War (Rank 1/2/3)
			[87173] = {tree = 'retribution', tier = 3}, -- Long Arm of the Law (Rank 1/2)
			--[53385] = {tree = 'retribution', tier = 3}, -- Divine Storm (success/DAMAGE)
			[54172] = {tree = 'retribution', tier = 3}, -- Divine Storm (HEAL)
			[20424] = {tree = 'retribution', tier = 4}, -- Seals of Command (Auto attack)
			[90811] = {tree = 'retribution', tier = 5}, -- Selfless Healer (Selfless)(Rank 1/2)
			--[85696] = {tree = 'retribution', tier = 7}, -- Zealotry
			-- Eye for an Eye
			-- Pursuit of Justice
			-- Rebuke
			-- Seals of Command (Cleave)
			-- Repentance
		},
		priest = {			
			[81660] = {tree = 'discipline', tier = 2}, -- Evangelism (Rank 1)(Smite)
			[81661] = {tree = 'discipline', tier = 2}, -- Evangelism (Rank 2)(Smite)
			[91724] = {tree = 'discipline', tier = 2}, -- Inner Sanctum (Rank 1/2/3)(Inner fire)
			[94472] = {tree = 'discipline', tier = 3}, -- Attonement (Rank 1/2)
			[59887] = {tree = 'discipline', tier = 4}, -- Borrowed Time (Rank 1)
			[59888] = {tree = 'discipline', tier = 4}, -- Borrowed Time (Rank 2)
			[47753] = {tree = 'discipline', tier = 5}, -- Divine Aegis (Rank 1/2/3)
			[47930] = {tree = 'discipline', tier = 6}, -- Grace (Rank 1)
			[77613] = {tree = 'discipline', tier = 6}, -- Grace (Rank 2)
			-- Evangelism (Rank 1)(Mind Flay)
			-- Evangelism (Rank 2)(Mind Flay)
			-- Inner Sanctum (Inner Will)(Speed Mod)?
			-- Rapture
			-- Reflective Shield
			-- Focused Will
			 			
			[77489] = {tree = 'holy', tier = 100}, -- Echo of Light (Specialization)
			[88688] = {tree = 'holy', tier = 2}, -- Surge of Light (Rank 1/2)
			[14893] = {tree = 'holy', tier = 2}, -- Inspiration (Rank 1)
			[15357] = {tree = 'holy', tier = 2}, -- Inspiration (Rank 2)
			[63544] = {tree = 'holy', tier = 3}, -- Divine Touch (Rank 1/2)
			[63731] = {tree = 'holy', tier = 4}, -- Serendipity (Rank 1)
			[63735] = {tree = 'holy', tier = 4}, -- Serendipity (Rank 2)
			[64128] = {tree = 'holy', tier = 5}, -- Body and Soul (Rank 1)(Speed Mod)
			[65081] = {tree = 'holy', tier = 5}, -- Body and Soul (Rank 2)(Speed Mod)
			-- holy word sanctuary?
			-- spirit of redemption?
			-- test: blessed resilience
			-- test: test of faith
			-- state of mind = chakra refresh event
						
			[15407] = {tree = 'shadow', tier = 100}, -- Mind Flay (Specialization)
			[77487] = {tree = 'shadow', tier = 100}, -- shadow Orb (Specialization)
			[63675] = {tree = 'shadow', tier = 2}, -- Improved Devouring Plague (Rank 1/2)
			[48301] = {tree = 'shadow', tier = 2}, -- Improved Mind Blast (Rank 1/2/3)(Mind Trauma)
			[15473] = {tree = 'shadow', tier = 3}, -- Shadowform (No Mind Quickening Events)
			[15286] = {tree = 'shadow', tier = 4}, -- Vampiric Embrace (Buff)
			[15290] = {tree = 'shadow', tier = 4}, -- Vampiric Embrace (Heal)
			[34914] = {tree = 'shadow', tier = 5}, -- Vampiric Touch
			[87193] = {tree = 'shadow', tier = 5}, -- Paralysis (Rank 1)
			[87194] = {tree = 'shadow', tier = 5}, -- Paralysis (Rank 2)
			-- Phantasm
			-- Masochism - No events?
			-- Mind Melt
			-- Replenishment general?  57669 yes, it is the same
			-- Sin and Punishment
		},
		rogue = {
			[27576] = {tree = 'assassination', tier = 100}, -- Mutilate (MH?)(Specialization)(success/DAMAGE)
			[1329] = {tree = 'assassination', tier = 100}, -- Mutilate (OH?)(Specialization)(success)
			[5374] = {tree = 'assassination', tier = 100}, -- Mutilate (OH?)(Specialization)(DAMAGE)
			[58427] = {tree = 'assassination', tier = 5}, -- Overkill
			[93068] = {tree = 'assassination', tier = 5}, -- Master Poisoner
			[79136] = {tree = 'assassination', tier = 6}, -- Venomous Wounds (DAMAGE)
			--[51637] = {tree = 'assassination', tier = 6}, -- Venomous Wounds (Venomous Vim)(energize)
			-- Deadly Momentum
			-- Blackjack
			-- Murderous Intent
			-- Venomous Wounds (Death energize)
			
			[86392] = {tree = 'combat', tier = 100}, -- Main Gauche (Specialization)
			[18425] = {tree = 'combat', tier = 2}, -- Improved Kick (Rank 1/2)
			[84617] = {tree = 'combat', tier = 3}, -- Revealing Strike
			[35542] = {tree = 'combat', tier = 4}, -- combat Potency(Rank 1)
			[35545] = {tree = 'combat', tier = 4}, -- combat Potency(Rank 2)
			[35546] = {tree = 'combat', tier = 4}, -- combat Potency(Rank 3)
			[31125] = {tree = 'combat', tier = 4}, -- Blade Twisting (Rank 1)
			[51585] = {tree = 'combat', tier = 4}, -- Blade Twisting (Rank 2)
			[84745] = {tree = 'combat', tier = 5}, -- Bandit's Guile (Shallow Insight)
			[84746] = {tree = 'combat', tier = 5}, -- Bandit's Guile (Moderate Insight)
			[84747] = {tree = 'combat', tier = 5}, -- Bandit's Guile (Deep Insight)
			-- Improved Sprint
			-- Deadly Throw Interrupt
			
			[31665] = {tree = 'subtlety', tier = 100}, -- Master of subtlety (Specialization)
			[14181] = {tree = 'subtlety', tier = 1}, -- Relentless Strikes (Rank 1/2/3)
			[51693] = {tree = 'subtlety', tier = 2}, -- Waylay (Rank 1)
			[16511] = {tree = 'subtlety', tier = 3}, -- Hemorrhage
			-- Find Weakness not working?
			-- Honor Among Thieves
		},
		shaman = {
			[45284] = {tree = 'elemental', tier = 100}, -- elemental Overload (Lightning Bolt)(Specialization)
			--[] = {tree = 'elemental', tier = 100}, -- elemental Overload (Chain Lightning)(Specialization)
			[77451] = {tree = 'elemental', tier = 100}, -- elemental Overload (Lava Burst)(Specialization)
			[88765] = {tree = 'elemental', tier = 3}, -- Rolling Thunder (Rank 1/2)
			[16246] = {tree = 'elemental', tier = 3}, -- elemental Focus
			[88767] = {tree = 'elemental', tier = 5}, -- Fulmination
			--[61882] = {tree = 'elemental', tier = 7}, -- Earthquake (success/APPLY/auraRemove)
			[77478] = {tree = 'elemental', tier = 7}, -- Earthquake (DAMAGE)			
			-- elemental Oath - Raid buff and self damage buff?
			-- Lava Flows - Dispel
			
			
			[63375] = {tree = 'enhancement', tier = 100}, -- Primal Wisdom (Specialization)
			[29178] = {tree = 'enhancement', tier = 2}, -- -- elemental Devastaion (Rank 1/2/3)
			[16257] = {tree = 'enhancement', tier = 2}, -- Flurry (Rank 1)
			[16277] = {tree = 'enhancement', tier = 2}, -- Flurry (Rank 2)
			[16278] = {tree = 'enhancement', tier = 2}, -- Flurry (Rank 3)
			[63685] = {tree = 'enhancement', tier = 4}, -- Frozen Power (Rank 1/2)(Freeze)
			[53817] = {tree = 'enhancement', tier = 6}, -- Maelstrom Weapon (Rank 1/2/3)
			-- Ancestral Swiftness - 2/2 - success event not fired, unlike instant Howl of Terror
			-- Searing Flames
			-- Earthen Power
			-- Unleashed Rage
			
			
			[974] = {tree = 'restoration', tier = 100}, -- Earth Shield (success/APPLY/auraRemove)(Specialization)
			[379] = {tree = 'restoration', tier = 100}, -- Earth Shield (HEAL)(Specialization)(Casted by shaman?)
			[77800] = {tree = 'restoration', tier = 2}, -- Focused Insight (Rank 1/2/3)(Scripted so only 1 aura?)
			[16177] = {tree = 'restoration', tier = 3}, -- Ancestral Fortitude (Rank 1)
			[16236] = {tree = 'restoration', tier = 3}, -- Ancestral Fortitude (Rank 2)
			[52752] = {tree = 'restoration', tier = 5}, -- Ancestral Awakening (Rank 1/2/3)
			[53390] = {tree = 'restoration', tier = 6}, -- Tidal Waves (Rank 1/2/3)
			-- Telluric Currents - Any events?
			-- Cleansing Water
		},
		warlock = {
			[30108] = {tree = 'affliction', tier = 100}, -- Unstable affliction (DoT)(Specialization)
			--[] = {tree = 'affliction', tier = 100}, -- Unstable affliction (Silence)(Specialization)
			[85547] = {tree = 'affliction', tier = 2}, -- Jinx (Rank 1)
			[86105] = {tree = 'affliction', tier = 2}, -- Jinx (Rank 2)
			[63106] = {tree = 'affliction', tier = 2}, -- Siphon Life (Rank 1/2)
			[18223] = {tree = 'affliction', tier = 3}, -- Curse of Exhaustion
			[60946] = {tree = 'affliction', tier = 3}, -- Improved Fear (Rank 1)(Nightmare)
			[60947] = {tree = 'affliction', tier = 3}, -- Improved Fear (Rank 2)(Nightmare)
			[64368] = {tree = 'affliction', tier = 3}, -- Eradication (Rank 1)
			[64370] = {tree = 'affliction', tier = 3}, -- Eradication (Rank 2)
			[64371] = {tree = 'affliction', tier = 3}, -- Eradication (Rank 3)
			[86121] = {tree = 'affliction', tier = 4}, -- Soul Swap (success/DAMAGE)
			[86211] = {tree = 'affliction', tier = 4}, -- Soul Swap (APPLY/auraRemove)
			[86213] = {tree = 'affliction', tier = 4}, -- Soul Swap (success/DAMAGE)(Soul Swap Exhale)
			[32386] = {tree = 'affliction', tier = 4}, -- shadow Embrace (Rank 1)
			[32388] = {tree = 'affliction', tier = 4}, -- shadow Embrace (Rank 2)
			[32389] = {tree = 'affliction', tier = 4}, -- shadow Embrace (Rank 3)
			--[17941] = {tree = 'affliction', tier = 5}, -- Nightfall (Rank 1/2)(shadow Trance)
			[87389] = {tree = 'affliction', tier = 5}, -- Soulburn: Seed of Corruption (Corruption)
			--[87388] = {tree = 'affliction', tier = 5}, -- Soulburn: Seed of Corruption (Soul Shard energize)
			-- Improved Howl of Terror - 2/2 - success event is fired instead of CAST_START
			-- Death's Embrace?
			
			[30146] = {tree = 'demonology', tier = 100}, -- Summon Felguard (Specialization)
			[54181] = {tree = 'demonology', tier = 1}, -- Fel Synergy (Rank 1/2)
			--[47193] = {tree = 'demonology', tier = 3}, -- Demonic Empowerment
			[47383] = {tree = 'demonology', tier = 4}, -- Molten Core (Rank 1)
			[71162] = {tree = 'demonology', tier = 4}, -- Molten Core (Rank 2)
			[71165] = {tree = 'demonology', tier = 4}, -- Molten Core (Rank 3)
			--[71521] = {tree = 'demonology', tier = 4}, -- Hand of Gul'dan
			--[47241] = {tree = 'demonology', tier = 7}, -- Metamorphosis
			--[54785] = {tree = 'demonology', tier = 7}, -- Metamorphosis (Demon Leap)
			[54786] = {tree = 'demonology', tier = 7}, -- Metamorphosis (Demon Leap)(APPLY/DAMAGE/auraRemove)
			--[50589] = {tree = 'demonology', tier = 7}, -- Metamorphosis (Immolation Aura)(success/APPLY/auraRemove)
			[50590] = {tree = 'demonology', tier = 7}, -- Metamorphosis (Immolation Aura)(DAMAGE)
			-- Demonic Rebirth
			-- Mana Feed
			-- Aura of Foreboding
			-- Decimation
			-- Inferno (Hellfire a different id?)
						
			[17800] = {tree = 'destruction', tier = 1}, -- shadow and Flame (shadow Mastery)(Rank 1/2/3)
			--[17962] = {tree = 'destruction', tier = 100}, -- Conflagrate (Specialization)
			--[85383] = {tree = 'destruction', tier = 2}, -- Improved Soul fire (Rank 1/2)
			[18118] = {tree = 'destruction', tier = 3}, -- Aftermath (Conflagrate)(Rank 1/2)
			[85387] = {tree = 'destruction', tier = 3}, -- Aftermath (Rain of fire)(Rank 1/2)
			[54274] = {tree = 'destruction', tier = 3}, -- Backdraft (Rank 1)
			[54276] = {tree = 'destruction', tier = 3}, -- Backdraft (Rank 2)
			[54277] = {tree = 'destruction', tier = 3}, -- Backdraft (Rank 3)
			[85421] = {tree = 'destruction', tier = 4}, -- Burning Embers (Rank 1/2)
			[30294] = {tree = 'destruction', tier = 4}, -- Soul Leech (Rank 1/2)
			--[91711] = {tree = 'destruction', tier = 4}, -- Nether Ward
			--[30283] = {tree = 'destruction', tier = 5}, -- Shadowfury
			[80240] = {tree = 'destruction', tier = 6}, -- Bane of Havoc (success/APPLY/auraRemove)
			[85455] = {tree = 'destruction', tier = 6}, -- Bane of Havoc (DAMAGE)
			--[50796] = {tree = 'destruction', tier = 7}, -- Chaos Bolt
			-- Shadowburn
			-- Shadowburn (energize)
			-- Soul Leech (Replenishment)
			-- Backlash
			-- Nether protection
		},
		warrior = {
			--[12294] = {tree = 'arms', tier = 100}, -- Mortal Strike (Specialization)
			[76858] = {tree = 'arms', tier = 100}, -- Opportunity Strike (Mastery)(Specialization)
			[12721] = {tree = 'arms', tier = 2}, -- Deep Wounds (Rank 1/2/3)
			--[60503] = {tree = 'arms', tier = 3}, -- Taste for blood (Rank 1/2/3)
			--[12328] = {tree = 'arms', tier = 3}, -- Sweeping Strikes (success/APPLY/auraRemove)
			[12723] = {tree = 'arms', tier = 3}, -- Sweeping Strikes (DAMAGE/MISS)
			--[23694] = {tree = 'arms', tier = 3}, -- Improved Hamstring (Rank 1/2)
			--[85730] = {tree = 'arms', tier = 4}, -- Deadly Calm
			[92576] = {tree = 'arms', tier = 4}, -- blood Frenzy (Rank 1/2)(energize)
			[46856] = {tree = 'arms', tier = 4}, -- blood Frenzy (Rank 1)(Trauma)(Physical damage debuff; no events?)
			[46857] = {tree = 'arms', tier = 4}, -- blood Frenzy (Rank 2)(Trauma)(Physical damage debuff; no events?)
			[65156] = {tree = 'arms', tier = 5}, -- Juggernaut (APPLY/auraRemove)
			[84584] = {tree = 'arms', tier = 5}, -- Slaughter (Rank 1)
			[84585] = {tree = 'arms', tier = 5}, -- Slaughter (Rank 2)
			[84586] = {tree = 'arms', tier = 5}, -- Slaughter (Rank 3)
			[57518] = {tree = 'arms', tier = 6}, -- Wrecking Crew (Rank 1)(Enrage)(Unique buff?)
			[57519] = {tree = 'arms', tier = 6}, -- Wrecking Crew (Rank 2)(Enrage)(Unique buff?)
			--[85388] = {tree = 'arms', tier = 6}, -- Throwdown (success/APPLY/auraRemove)
			--[46924] = {tree = 'arms', tier = 7}, -- Bladestorm (success/APPLY/auraRemove)
			[50622] = {tree = 'arms', tier = 7}, -- Bladestorm (Whirlwind)(success/DAMAGE/MISS)
			-- Second Wind
						
			--[23881] = {tree = 'fury', tier = 100}, -- Bloodthirst (success/DAMAGE/MISS)(Specialization)
			[23885] = {tree = 'fury', tier = 100}, -- Bloodthirst (APPLY/auraRemove)(Specialization)
			[23880] = {tree = 'fury', tier = 100}, -- Bloodthirst (HEAL/MISS)(Specialization)
			[12964] = {tree = 'fury', tier = 1}, -- Battle Trance (Rank 1/2/3)
			[12323] = {tree = 'fury', tier = 2}, -- Piercing Howl
			[12966] = {tree = 'fury', tier = 3}, -- Flurry (Rank 1)
			[12967] = {tree = 'fury', tier = 3}, -- Flurry (Rank 2)
			[12968] = {tree = 'fury', tier = 3}, -- Flurry (Rank 3)
			--[12292] = {tree = 'fury', tier = 3}, -- Death Wish
			[12880] = {tree = 'fury', tier = 3}, -- Enrage (Rank 1)
			[14201] = {tree = 'fury', tier = 3}, -- Enrage (Rank 2)
			[14202] = {tree = 'fury', tier = 3}, -- Enrage (Rank 3)
			[85288] = {tree = 'fury', tier = 4}, -- Raging Blow
			[56112] = {tree = 'fury', tier = 5}, -- Furious Attacks
			[85738] = {tree = 'fury', tier = 5}, -- Meat Cleaver (Rank 1)
			[85739] = {tree = 'fury', tier = 5}, -- Meat Cleaver (Rank 2)
			[46916] = {tree = 'fury', tier = 6}, -- Bloodsurge (Rank 1/2/3)
			[50783] = {tree = 'fury', tier = 6}, -- Slam (Bloodsurge)
			[86662] = {tree = 'fury', tier = 2}, -- Rude Interruption (Rank 1)
			[86663] = {tree = 'fury', tier = 2}, -- Rude Interruption (Rank 2)
			--[60970] = {tree = 'fury', tier = 4}, -- Heroic fury (success/APPLY/auraRemove)
			[81101] = {tree = 'fury', tier = 7}, -- Single Minded fury (Second Slam)
			--[85386] = {tree = 'fury', tier = 4}, -- Die by the Sword (Rank 1)
			--[86624] = {tree = 'fury', tier = 4}, -- Die by the Sword (Rank 2)
			[16488] = {tree = 'fury', tier = 1}, -- blood Craze (Rank 1)
			[16490] = {tree = 'fury', tier = 1}, -- blood Craze (Rank 2)
			--[0] = {tree = 'fury', tier = 1}, -- blood Craze (Rank 3)
			[90806] = {tree = 'fury', tier = 2}, -- Executioner (Rank 1/2)
			-- Rampage
			
			--[23922] = {tree = 'protection', tier = 100}, -- Shield Slam (Specialization)
			[86627] = {tree = 'protection', tier = 1}, -- Incite (Rank 1/2/3)
			[18498] = {tree = 'protection', tier = 2}, -- Gag Order (Heroic Throw)(Silenced - Gag Order)(Rank 1/2)
			[74347] = {tree = 'protection', tier = 2}, -- Gag Order (Shield Bash)(Silenced - Gag Order)(Rank 1/2)
			--[12975] = {tree = 'protection', tier = 3}, -- Last Stand (success)
			[12976] = {tree = 'protection', tier = 3}, -- Last Stand (APPLY/auraRemove)
			--[12809] = {tree = 'protection', tier = 3}, -- Concussion Blow
			[20243] = {tree = 'protection', tier = 4}, -- Devastate (success/DAMAGE/MISS)
			[87095] = {tree = 'protection', tier = 5}, -- Thunderstruk (Rank 1)
			[87096] = {tree = 'protection', tier = 5}, -- Thunderstruk (Rank 2)
			[50227] = {tree = 'protection', tier = 6}, -- Sword and Board
			--[46968] = {tree = 'protection', tier = 7}, -- Shockwave
			-- Critical Block (Mastery)
			-- Shield Specialization
			-- Hold the Line
			-- Bastion of Defense
			-- Warbringer (dispell?)
			-- Improved Revenge
			-- Impending Victory
			-- Vigilance
			-- Safeguard
			-- Vengeance
		}
	},
	class = {
		deathknight = {
		},
		druid = {
			--[5215] = {}; -- Prowl
		},
		hunter = {
		},
		mage = {
			[30449] = {}; -- Spellsteal
		},
		paladin = {
		},
		priest = {
		},
		rogue = {
			--[1784] = {}; -- Stealth
			[51724] = {}; -- Sap (Rank 4)
		},
		shaman = {
		},
		warlock = {
		},
		warrior = {
		}
	},
	hook = {
		[30146] = {event = 'summon'}, -- Felguard
		[691] = {event = 'summon'}, -- Felhunter
		[688] = {event = 'summon'}, -- Imp
		[712] = {event = 'summon'}, -- Succubus
		[697] = {event = 'summon'}, -- Voidwalker		
		[32752] = {event = 'auraApply'}, -- Summoning Disorientation		
		[755] = {event = 'auraApplyRemove_periodicHeal'}, -- Health Funnel
		[32553] = {event = 'energize'}, -- Mana Feed (Rank 1/2)(Life Tap)
		[32554] = {event = 'energize'}, -- Mana Feed (Rank 1/2)(Drain Mana)
		[54181] = {event = 'heal'}, -- Fel Synergy (Rank 2)
		[25228] = {event = 'damageSplit'}, -- Soul Link
		
		[31687] = {event = 'summon'}, -- Water elemental	
		[91394] = {event = 'heal'}, -- Permafrost (Rank 1/2/3)
		
		[52150] = {event = 'summon'}, -- Raise Dead
		[91342] = {event = 'auraApplyRemove'}, -- shadow Infusion
		[63560] = {event = 'auraApplyRemove'}, -- Dark Transformation
		
		[883] = {event = 'summon'}, -- Call Pet 1
		[83242] = {event = 'summon'}, -- Call Pet 2
		[83243] = {event = 'summon'}, -- Call Pet 3
		[83244] = {event = 'summon'}, -- Call Pet 4
		[83245] = {event = 'summon'}, -- Call Pet 5
		[982] = {event = 'summon'}, -- Revive Pet
		[1539] = {event = 'auraApplyRemove_periodicEnergize'}, -- Feed Pet		
		[136] = {event = 'auraApplyRemove_periodicHeal'}, -- Mend Pet
		[19577] = {event = 'auraApplyRemove'}, -- Intimidation
		[83468] = {event = 'energize'}, -- Focus fire
		[82728] = {event = 'energize'}, -- Fervor
		[19574] = {event = 'auraApplyRemove'}, -- Bestial Wrath
		[34952] = {event = 'energize'}, -- Go for the Throat (Rank 1)
		[34953] = {event = 'energize'}, -- Go for the Throat (Rank 2)
		
		-- Are player casted auras on pets dispelled when the pet is dismissed?
	},
	reset = {
		deathknight = {
			will_of_necropolis = {allIds = {81162}, event = 'auraApply', cooldowns = {'player_deathknight_base_rune_tap'}},
		},
		druid = {
			shooting_stars = {allIds = {93400}, event = 'auraApply', cooldowns = {'player_druid_base_starsurge'}},
			berserk = {allIds = {50334}, event = 'success', cooldowns = {'player_druid_base_mangle_bear'}},
			berserk_lacerate = {allIds = {93622}, event = 'auraApply', cooldowns = {'player_druid_base_mangle_bear'}},
			natures_grace = {allIds = {48517,48518}, event = 'auraApply', cooldowns = {'player_druid_base_natures_grace'}},
		},
		hunter = {
			readiness = {allIds = {23989}, event = 'success', cooldowns = {'player_hunter_base_wyvern_sting','player_hunter_base_black_arrow','player_hunter_base_scatter_shot','player_hunter_base_chimera_shot','player_hunter_base_silencing_shot','player_hunter_base_intimidation','player_hunter_base_masters_call','player_hunter_base_deterrence','player_hunter_base_disengage','player_hunter_base_concussive_shot','player_hunter_base_kill_shot','player_hunter_base_rapid_fire','player_hunter_base_viper_sting','player_hunter_base_kill_command','player_hunter_base_freezing_arrow','player_hunter_base_snake_trap','player_hunter_base_freezing_trap','player_hunter_base_frost_trap','player_hunter_base_immolation_trap','player_hunter_base_flare','player_hunter_base_aimed_shot','player_hunter_base_distracting_shot','player_hunter_base_counter_attack','player_hunter_base_arcane_shot','player_hunter_base_misdirection','player_hunter_base_raptor_strike','player_hunter_base_explosive_shot','player_hunter_base_multi_shot'}},
		},
		mage = {
			impact = {allIds = {64343}, event = 'auraApply', cooldowns = {'player_mage_base_fire_blast'}},
			cold_snap = {allIds = {11958}, event = 'success', cooldowns = {'player_mage_base_deep_freeze','player_mage_base_summon_water_elemental','player_mage_base_ice_barrier','player_mage_base_icy_veins','player_mage_base_ice_block','player_mage_base_cone_of_cold','player_mage_base_frost_nova'}},
		},
		paladin = {
			grand_crusader = {allIds = {85416}, event = 'auraApply', cooldowns = {'player_paladin_base_avengers_shield'}},
		},
		priest = {
		},
		rogue = {
			preparation = {allIds = {14185}, event = 'success', cooldowns = {'player_rogue_base_evasion', 'player_rogue_base_sprint', 'player_rogue_base_vanish', 'player_rogue_base_shadowstep', 'player_rogue_base_kick', 'player_rogue_base_dismantle', 'player_rogue_base_smoke_bomb'}},
		},
		shaman = {
		},
		warlock = {
		},
		warrior = {
			heroic_fury = {allIds = {60970}, event = 'success', cooldowns = {'player_warrior_base_intercept'}},
			sword_and_board = {allIds = {50227}, event = 'auraApply', cooldowns = {'player_warrior_base_slield_slam'}},
		},
	},
	runeType = {
		blood = 1,
		unholy = 2,
		frost = 3,
		death = 4
	},
	totemType = {
		ghoul = 1,
		fire = 1,
		earth = 2,
		water = 3,
		air = 4
	},
	buffSpellList = {
		fear = {
			5782, -- Fear
			5484, -- Howl of terror
			5246, -- Intimidating Shout 
			8122, -- Psychic scream
		},
		root = {
			23694, -- Improved Hamstring
			339, -- Entangling Roots
			122, -- Frost Nova
			47168, -- Improved Wing Clip
		},
		incapacitate = {
			6770, -- Sap
			12540, -- Gouge
			20066, -- Repentance
		},
		stun =  {
			5211, -- Bash
			44415, -- Blackout
			6409, -- Cheap Shot
			22427, -- Concussion Blow
			853, -- Hammer of Justice
			408, -- Kidney Shot
			46968, -- Shockwave
		},
		strengthagility = {
			6673, -- Battle Shout
			8076, -- Strength of Earth
			57330, -- Horn of Winter
			93435 --Roar of Courage (Cat, Spirit Beast)
		},
		stamina = {
			21562, -- Fortitude TODO: vérifier
			469, -- Commanding Shout
			6307, -- Blood Pact
			90364 -- Qiraji Fortitude
		},
		lowerarmor = {
			58567, -- Sunder Armor (x3)
			8647, -- Expose Armor
			91565, -- Faerie Fire (x3)
			35387, --Corrosive Spit (x3 Serpent)
			50498 --Tear Armor (x3 Raptor)
		},
		magicaldamagetaken = {
			65142, -- Ebon Plague
			60433, -- Earth and Moon
			93068, -- Master Poisoner 
			1490, -- Curse of the Elements
			85547, -- Jinx 1
			86105, -- Jinx 2
			34889, --Fire Breath (Dragonhawk)
			24844 --Lightning Breath (Wind serpent)
		},
		magicalcrittaken = {
			17800, -- Shadow and Flame
			22959 -- Critical Mass
		},
		-- physicaldamagetaken
		lowerphysicaldamage = {
			99, -- Demoralizing Roar
			702, -- Curse of Weakness
			1160, -- Demoralizing Shout
			26017, -- Vindication
			81130, -- Scarlet Fever
			50256 --Demoralizing Roar (Bear)
		},
		meleeslow = {
			55095, --Icy Touch
			58179, --Infected Wounds rank 1
			58180, --Infected Wounds rank 2
			68055, --Judgments of the just
			6343, --Thunderclap
			8042, --Earth Shock
			50285 --Dust Cloud (Tallstrider)
		},
		castslow = {
			1714, --Curse of Tongues
			58604, --Lava Breath (Core Hound)
			50274, --Spore Cloud (Sporebat)
			5761, --Mind-numbing Poison
			73975, --Necrotic Strike
			31589 --Slow
		},
		bleed = {
			33876, --Mangle cat
			33878, --Mangle bear
			46856, -- Trauma rank 1
			46857, -- Trauma rank 2
			16511, --Hemorrhage
			50271, --Tendon Rip (Hyena)
			35290 --Gore (Boar)
		},
		heroism = {
			2825, --Bloodlust
			32182, --Heroism
			80353, --Time warp
			90355 -- Ancient Hysteria (Core Hound)
		},
		meleehaste = {
			8515, -- Windfury
			55610, -- Improved Icy Talons
			53290 -- Hunting Party
		},
		spellhaste = {
			24907, -- Moonkin aura
			2895 -- Wrath of Air Totem
		},
		enrage = {
			49016, -- Unholy Frenzy
			18499, -- Berserker Rage
			12292, -- Death Wish
			12880, -- Enrage (rank 1)
			14201, -- Enrage (rank 2)
			14202, -- Enrage (rank 3)
		}
	}
}

Spells.pet = {
	cooldown = {
		class = {
			test = {
				base = {
					bar1 = {event='success',mainId=1,baseDuration=180000,name='Pet Single Endpoint',icon=Libs.icons.of.group.pet},
					bar2 = {event='success',mainId=1,baseDuration=180000,allDurations={10000,180000},maxDuration=180000,minDuration=10000,name='Pet Multiple Endpoints',icon=Libs.icons.of.group.pet},
					ignoreInterval = {event='success',mainId=1,baseDuration=180000,name='Pet Ignore Interval Bar',icon=Libs.icons.of.group.pet,ignoreInterval = true},
				},
			},
			voidwalker = {
				base = {
					sacrifice = {event='success',mainId=7812,baseDuration=60000},
					suffering = {event='success',mainId=17735,baseDuration=10000},
					torment = {event='success',mainId=3716,baseDuration=5000},
				},
			},
			felhunter = {
				base = {
					devour_magic = {event='success',mainId=19505,baseDuration=15000},
					shadow_bite = {event='success',mainId=54049,baseDuration=6000},
					spell_lock = {event='success',mainId=19647,baseDuration=24000},
				},
			},
			felguard = {
				base = {
					pursuit = {event='success',mainId=30151,baseDuration=15000},
					axe_toss = {event='success',mainId=89766,baseDuration=30000},
					felstorm = {event='success',mainId=89751,baseDuration=45000},
					legion_strike = {event='success',mainId=30213,baseDuration=6000},
				},
			},
			ghoul = {
				base = {
					gnaw = {event='auraApply',mainId=91800,baseDuration=60000},
					huddle = {event='auraApply',mainId=91838,baseDuration=45000},
					monstrous_blow = {event='auraApply',mainId=91797,baseDuration=60000},
					putrid_bulwark = {event='auraApply',mainId=91837,baseDuration=45000},
					shambling_rush = {event='auraApply',mainId=91807,baseDuration=30000},
				},
			},
			hunterPet = {
				base = {
					claw = {event='success',mainId=16827,baseDuration=3000,allDurations={3000,2700,2400,2100},maxDuration=3000,minDuration=2100},
					cower = {event='success',mainId=1742,baseDuration=45000,allDurations={45000,40500,36000,31500},maxDuration=45000,minDuration=31500},
					smack = {event='success',mainId=49966,baseDuration=3000,allDurations={3000,2700,2400,2100},maxDuration=3000,minDuration=2100},
					growl = {event='success',mainId=2649,baseDuration=5000,allDurations={5000,4500,4000,3500},maxDuration=5000,minDuration=3500},
					bite = {event='success',mainId=17253,baseDuration=3000,allDurations={3000,2700,2400,2100},maxDuration=3000,minDuration=2100},
				},
				exotic = {
					spirit_mend = {event='success',mainId=90361,baseDuration=40000,allDurations={40000,36000,32000,28000},maxDuration=40000,minDuration=28000},
					ancient_hysteria = {event='success',mainId=90355,baseDuration=360000,allDurations={360000,324000,288000,252000},maxDuration=360000,minDuration=252000},
					burrow_attack = {event='success',mainId=93433,baseDuration=30000,allDurations={30000,27000,24000,21000},maxDuration=30000,minDuration=21000},
					horn_toss = {event='success',mainId=93434,baseDuration=90000,allDurations={90000,81000,72000,63000},maxDuration=90000,minDuration=63000},
					monstrous_bite = {event='success',mainId=54680,baseDuration=8000,allDurations={8000,7200,6400,5600},maxDuration=8000,minDuration=5600},
				},
				special = {
					serenity_dust = {event='success',mainId=50318,baseDuration=60000,allDurations={60000,54000,48000,42000},maxDuration=60000,minDuration=42000},
					shell_shield = {event='success',mainId=26064,baseDuration=60000,allDurations={60000,54000,48000,42000},maxDuration=60000,minDuration=42000},
					snatch = {event='success',mainId=91644,baseDuration=60000,allDurations={60000,54000,48000,42000},maxDuration=60000,minDuration=42000},
					sonic_blast = {event='success',mainId=50519,baseDuration=60000,allDurations={60000,54000,48000,42000},maxDuration=60000,minDuration=42000},
					spore_cloud = {event='success',mainId=50274,baseDuration=8000,allDurations={8000,7200,6400,5600},maxDuration=8000,minDuration=5600},
					stampede = {event='success',mainId=57386,baseDuration=15000,allDurations={15000,13500,12000,10500},maxDuration=15000,minDuration=10500},
					sting = {event='success',mainId=56626,baseDuration=45000,allDurations={45000,40500,36000,31500},maxDuration=45000,minDuration=31500},
					tailspin = {event='success',mainId=90314,baseDuration=25000,allDurations={25000,22500,20000,17500},maxDuration=25000,minDuration=17500},
					tear_armor = {event='success',mainId=50498,baseDuration=6000,allDurations={6000,5400,4800,4200},maxDuration=6000,minDuration=4200},
					tendon_rip = {event='success',mainId=50271,baseDuration=10000,allDurations={10000,9000,8000,7000},maxDuration=10000,minDuration=7000},
					terrifying_roar = {event='success',mainId=90309,baseDuration=45000,allDurations={45000,40500,36000,31500},maxDuration=45000,minDuration=31500},
					venom_web_spray = {event='success',mainId=54706,baseDuration=40000,allDurations={40000,36000,32000,28000},maxDuration=40000,minDuration=28000},
					web = {event='success',mainId=4167,baseDuration=40000,allDurations={40000,36000,32000,28000},maxDuration=40000,minDuration=28000},
					web_wrap = {event='success',mainId=96201,baseDuration=45000,allDurations={45000,40500,36000,31500},maxDuration=45000,minDuration=31500},
					pummel = {event='success',mainId=26090,baseDuration=30000,allDurations={30000,27000,24000,21000},maxDuration=30000,minDuration=21000},
					acid_spit = {event='success',mainId=55749,baseDuration=10000,allDurations={10000,9000,8000,7000},maxDuration=10000,minDuration=7000},
					ankle_crack = {event='success',mainId=50433,baseDuration=10000,allDurations={10000,9000,8000,7000},maxDuration=10000,minDuration=7000},
					bad_manner = {event='success',mainId=90337,baseDuration=60000,allDurations={60000,54000,48000,42000},maxDuration=60000,minDuration=42000},
					clench = {event='success',mainId=50541,baseDuration=60000,allDurations={60000,54000,48000,42000},maxDuration=60000,minDuration=42000},
					time_warp = {event='success',mainId=35346,baseDuration=15000,allDurations={15000,13500,12000,10500},maxDuration=15000,minDuration=10500},
					demoralizing_roar = {event='success',mainId=50256,baseDuration=10000,allDurations={10000,9000,8000,7000},maxDuration=10000,minDuration=7000},
					demoralizing_screech = {event='success',mainId=24423,baseDuration=10000,allDurations={10000,9000,8000,7000},maxDuration=10000,minDuration=7000},
					dust_cloud = {event='success',mainId=50285,baseDuration=25000,allDurations={25000,22500,20000,17500},maxDuration=25000,minDuration=17500},
					fire_breath = {event='success',mainId=34889,baseDuration=30000,allDurations={30000,27000,24000,21000},maxDuration=30000,minDuration=21000},
					frost_breath = {event='success',mainId=54644,baseDuration=10000,allDurations={10000,9000,8000,7000},maxDuration=10000,minDuration=7000},
					furious_howl = {event='success',mainId=24604,baseDuration=45000,allDurations={45000,40500,36000,31500},maxDuration=45000,minDuration=31500},
					gore = {event='success',mainId=35290,baseDuration=10000,allDurations={10000,9000,8000,7000},maxDuration=10000,minDuration=7000},
					harden_carapace = {event='success',mainId=90339,baseDuration=60000,allDurations={60000,54000,48000,42000},maxDuration=60000,minDuration=42000},
					lava_breath = {event='success',mainId=58604,baseDuration=8000,allDurations={8000,7200,6400,5600},maxDuration=8000,minDuration=5600},
					lightning_breath = {event='success',mainId=24844,baseDuration=30000,allDurations={30000,27000,24000,21000},maxDuration=30000,minDuration=21000},
					lock_jaw = {event='success',mainId=90327,baseDuration=40000,allDurations={40000,36000,32000,28000},maxDuration=40000,minDuration=28000},
					nether_shock = {event='success',mainId=50479,baseDuration=40000,allDurations={40000,36000,32000,28000},maxDuration=40000,minDuration=28000},
					pin = {event='success',mainId=50245,baseDuration=40000,allDurations={40000,36000,32000,28000},maxDuration=40000,minDuration=28000},
					ravage = {event='success',mainId=50518,baseDuration=15000,allDurations={15000,13500,12000,10500},maxDuration=15000,minDuration=10500},
					roar_of_courage = {event='success',mainId=93435,baseDuration=45000,allDurations={45000,40500,36000,31500},maxDuration=45000,minDuration=31500},
				},
				talent = {
					dash = {event='success',mainId=61684,baseDuration=32000,allDurations={32000,28800,25600,24000,22400,21600,19200,16800,16000,14400,12800,11200},maxDuration=32000,minDuration=11200},
					bullheaded = {event='success',mainId=53490,baseDuration=180000,allDurations={180000,162000,144000,126000},maxDuration=180000,minDuration=126000},
					call_of_the_wild = {event='success',mainId=53434,baseDuration=300000,allDurations={300000,270000,240000,210000},maxDuration=300000,minDuration=210000},
					carrion_feeder = {event='success',mainId=54044,baseDuration=30000,allDurations={30000,27000,24000,21000},maxDuration=30000,minDuration=21000},
					dive = {event='success',mainId=23145,baseDuration=32000,allDurations={32000,28800,25600,24000,22400,21600,19200,16800,16000,14400,12800,11200},maxDuration=32000,minDuration=11200},
					heart_of_the_phoenix = {event='success',mainId=55709,baseDuration=480000,allDurations={480000,432000,384000,336000},maxDuration=480000,minDuration=336000},
					lick_your_wounds = {event='success',mainId=53426,baseDuration=180000,allDurations={180000,162000,144000,126000},maxDuration=180000,minDuration=126000},
					rabid = {event='success',mainId=53401,baseDuration=45000,allDurations={45000,40500,36000,31500},maxDuration=45000,minDuration=31500},
					intervene = {event='success',mainId=53476,baseDuration=30000,allDurations={30000,27000,24000,21000},maxDuration=30000,minDuration=21000},
					roar_of_recovery = {event='success',mainId=53517,baseDuration=180000,allDurations={180000,162000,144000,126000},maxDuration=180000,minDuration=126000},
					roar_of_sacrifice = {event='success',mainId=53480,baseDuration=60000,allDurations={60000,54000,48000,42000},maxDuration=60000,minDuration=42000},
					swoop = {event='success',mainId=52825,baseDuration=25000,allDurations={25000,22500,20000,17500},maxDuration=25000,minDuration=17500},
					last_stand = {event='success',mainId=53478,baseDuration=360000,allDurations={360000,324000,288000,252000},maxDuration=360000,minDuration=252000},
					thunderstomp = {event='success',mainId=63900,baseDuration=10000,allDurations={10000,9000,8000,7000},maxDuration=10000,minDuration=7000},
					wolverine_bite = {event='success',mainId=53508,baseDuration=10000,allDurations={10000,9000,8000,7000},maxDuration=10000,minDuration=7000},
					taunt = {event='success',mainId=53477,baseDuration=60000,allDurations={60000,54000,48000,42000},maxDuration=60000,minDuration=42000},
					charge = {event='success',mainId=61685,baseDuration=25000,allDurations={25000,22500,20000,17500},maxDuration=25000,minDuration=17500},
				},
				bonus = {
					prowl = {event='auraRemove',mainId=24450,baseDuration=10000,allDurations={10000,9000,8000,7000},maxDuration=10000,minDuration=7000},
					spirit_walk = {event='auraRemove',mainId=90328,baseDuration=10000,allDurations={10000,9000,8000,7000},maxDuration=10000,minDuration=7000},
				},
			},
			imp = {
				base = {
					singe_magic = {event='success',mainId=89808,baseDuration=6000},
					flee = {event='success',mainId=89792,baseDuration=20000},
				},
			},
			succubus = {
				base = {
					whiplash = {event='success',mainId=6360,baseDuration=25000},
				},
			},
			waterElemental = {
				base = {
					freeze = {event='success',mainId=33395,baseDuration=25000},
				},
			}
		}
	},
	hook = {
		[25228] = {event = 'auraApply'}, -- Soul Link (Remove causes conflicts when summoning another)
		[7812] = {event = 'auraApply'}, -- Sacrifice
		[91706] = {event = 'auraApply'}, -- Mana Feed (Rank 2)
		[47283] = {event = 'auraApply'}, -- Empowered Imp
		
		[19579] = {event = 'auraApply_periodicHeal'}, -- Spirit Bond (Rank 1)
		[24529] = {event = 'auraApply_periodicHeal'}, -- Spirit Bond (Rank 2)
		[70893] = {event = 'auraApply'}, -- Culling the Herd
		[53517] = {event = 'auraApply_periodicEnergize'}, -- Roar of Recovery
		[53434] = {event = 'auraApply'}, -- Call of the Wild
	}
}


-- Methods


function Spells.buildCooldownIndex()
	local unitCooldownArray = {'player', 'pet'};

	for i, unitType in pairs ( unitCooldownArray ) do
		if ( Spells[unitType] ~= nil ) then
			Spells.cooldownIndexByUnitType[unitType] = {};
			if ( Spells[unitType].cooldown ~= nil ) then
				if ( Spells[unitType].cooldown.all ~= nil ) then
					for groupName, groupTable in pairs ( Spells[unitType].cooldown.all ) do
						for subGroupName, subGroupTable in pairs ( groupTable ) do
							for cooldownName, cooldownTable in pairs ( subGroupTable ) do
								local cooldownGuid = unitType..'_'..groupName..'_'..subGroupName..'_'..cooldownName;
								if ( Spells.cooldownIndex[cooldownGuid] ~= nil ) then SITUATION.print('Duplicate cooldownGuid found: '..cooldownGuid); end
								Spells.cooldownIndex[cooldownGuid] = cooldownTable;
								Spells.unitTypeIndexByCooldownName[cooldownGuid] = unitType;
								Spells.cooldownIndexByUnitType[unitType][cooldownGuid] = cooldownTable;
								if ( cooldownTable.allIds ~= nil ) then
									for i, spellId in pairs ( cooldownTable.allIds ) do
										Spells.cooldownNameIndex[spellId] = cooldownGuid;
										Spells.cooldownTableIndex[spellId] = cooldownTable;
										if ( cooldownTable.reverseCooldown ) then
											Spells.reverseCooldownIndex[spellId] = 1;
										end
									end
								else
									Spells.cooldownNameIndex[cooldownTable.mainId] = cooldownGuid;
									Spells.cooldownTableIndex[cooldownTable.mainId] = cooldownTable;
								end
							end
						end
					end
				end
				if ( Spells[unitType].cooldown.class ~= nil ) then
					for className, classTable in pairs ( Spells[unitType].cooldown.class ) do
						for groupName, groupTable in pairs ( classTable ) do
							for cooldownName, cooldownTable in pairs ( groupTable ) do
								local cooldownGuid = unitType..'_'..className..'_'..groupName..'_'..cooldownName;
								if ( Spells.cooldownIndex[cooldownGuid] ~= nil ) then SITUATION.print('Duplicate cooldownGuid found: '..cooldownGuid); end
								Spells.cooldownIndex[cooldownGuid] = cooldownTable;
								Spells.unitTypeIndexByCooldownName[cooldownGuid] = unitType;
								Spells.cooldownIndexByUnitType[unitType][cooldownGuid] = cooldownTable;
								if ( cooldownTable.allIds ~= nil ) then
									for i, spellId in pairs ( cooldownTable.allIds ) do
										Spells.cooldownNameIndex[spellId] = cooldownGuid;
										Spells.cooldownTableIndex[spellId] = cooldownTable;
										Spells.classNameIndex[spellId] = className;
										if ( cooldownTable.tier ~= nil and cooldownTable.tier >= lowestTier ) then
											Spells.specNameIndex[spellId] = cooldownTable.tree;
										end
										if ( cooldownTable.reverseCooldown ) then
											Spells.reverseCooldownIndex[spellId] = 1;
										end
										if ( cooldownTable.multiCaster ) then
											Spells.classNameEventIndex[spellId] = cooldownTable.event;
										end
									end
								else
									Spells.cooldownNameIndex[cooldownTable.mainId] = cooldownGuid;
									Spells.cooldownTableIndex[cooldownTable.mainId] = cooldownTable;
									Spells.classNameIndex[cooldownTable.mainId] = className;
									if ( cooldownTable.tier ~= nil and cooldownTable.tier >= lowestTier ) then
										Spells.specNameIndex[cooldownTable.mainId] = cooldownTable.tree;
									end
									if ( cooldownTable.reverseCooldown ) then
										Spells.reverseCooldownIndex[cooldownTable.mainId] = 1;
									end
									if ( cooldownTable.multiCaster ) then
										Spells.classNameEventIndex[cooldownTable.mainId] = cooldownTable.event;
									end
								end
							end
						end
					end
				end
			end
			if ( Spells[unitType].talent ~= nil ) then
				for className, classTable in pairs ( Spells[unitType].talent ) do
					for talentSpellId, talentSpellTable in pairs ( classTable ) do
						if ( Spells.classNameIndex[talentSpellId] ~= nil ) then SITUATION.print('Duplicate talentSpellId found: '..talentSpellId); end
						Spells.classNameIndex[talentSpellId] = className;
						if ( talentSpellTable.tier >= lowestTier ) then
							Spells.specNameIndex[talentSpellId] = talentSpellTable.tree;
						end
					end
				end
			end
			if ( Spells[unitType].reset ~= nil ) then
				for className, classTable in pairs ( Spells[unitType].reset ) do
					for resetName, resetTable in pairs ( classTable ) do
						for i, spellId in pairs ( resetTable.allIds ) do
							Spells.classNameIndex[spellId] = className;
							Spells.resetTableIndex[spellId] = resetTable;
						end
					end
				end
			end
			if ( Spells[unitType].class ~= nil ) then
				for className, classTable in pairs ( Spells[unitType].class ) do
					for classSpellId, classSpellTable in pairs ( classTable ) do
						if ( Spells.classNameIndex[classSpellId] ~= nil ) then SITUATION.print('Duplicate classSpellId found: '..classSpellId); end
						Spells.classNameIndex[classSpellId] = className;
					end
				end
			end
			if ( Spells[unitType].hook ~= nil ) then
				for hookSpellId, hookSpellTable in pairs ( Spells[unitType].hook ) do
					Spells.hookTableIndex[hookSpellId] = hookSpellTable;
				end
			end
		end
	end
end


function Spells.isReverseCooldown(pSpellId)
	if ( Spells.reverseCooldownIndex[pSpellId] ) then
		return true;
	end
	return nil;
end


function Spells.getSpellInfo(pSpellId, pEvent)
	local cooldownName, cooldownTable, onlyRecordInterval, class, tree, isHook, resetTable;
	if ( Spells.cooldownNameIndex[pSpellId] ~= nil ) then
		if ( Libs.events[Spells.cooldownTableIndex[pSpellId].event][pEvent] ~= nil ) then
			cooldownName = Spells.cooldownNameIndex[pSpellId];
			cooldownTable = Spells.cooldownTableIndex[pSpellId];
		elseif ( not Spells.cooldownTableIndex[pSpellId].ignoreInteval and Spells.cooldownTableIndex[pSpellId].isCasted and pEvent == 'SPELL_CAST_START' ) then
			cooldownName = Spells.cooldownNameIndex[pSpellId];
			cooldownTable = Spells.cooldownTableIndex[pSpellId];
			onlyRecordInterval = true;
		end
	end
	if ( Spells.classNameIndex[pSpellId] ~= nil and (Spells.classNameEventIndex[pSpellId] == nil or Spells.classNameEventIndex[pSpellId] == pEvent) ) then
		class = Spells.classNameIndex[pSpellId];
		if ( Spells.specNameIndex[pSpellId] ~= nil ) then
			tree = Spells.specNameIndex[pSpellId];
		end
	end
	if ( Spells.hookTableIndex[pSpellId] ~= nil and Libs.events[Spells.hookTableIndex[pSpellId].event][pEvent] ~= nil ) then
		isHook = true;
	end
	if ( Spells.resetTableIndex[pSpellId] ~= nil and Libs.events[Spells.resetTableIndex[pSpellId].event][pEvent] ~= nil ) then
		resetTable = Spells.resetTableIndex[pSpellId];
	end
	return cooldownName, cooldownTable, onlyRecordInterval, class, tree, isHook, resetTable;
end