----------
-- Name: TheSituation
-- Version: 2.0.x
-- License: All Rights Reserved
----------

local Libs = SITUATION.Libs;


Libs.font = {
	frizqt = {name = 'Frizqt (Default)', path = [[fonts\frizqt__.ttf]]},
	adventure = {name = 'Adventure', path = [[interface\addons\sharedmedia\fonts\adventure.ttf]]},
	bazooka = {name = 'Bazooka', path = [[interface\addons\sharedmedia\fonts\bazooka.ttf]]},
	blackChancery = {name = 'Black Chancery', path = [[interface\addons\sharedmedia\fonts\blackchancery.ttf]]},
	enigmatic = {name = 'Enigmatic', path = [[interface\addons\sharedmedia\fonts\enigma__2.ttf]]},
	moviePoster = {name = 'Movie Poster', path = [[interface\addons\sharedmedia\fonts\sfmovieposter-bold.ttf]]},
	veraSerif = {name = 'Vera Serif', path = [[interface\addons\sharedmedia\fonts\verase.ttf]]},
	yellowjacket = {name = 'Yellowjacket', path = [[interface\addons\sharedmedia\fonts\yellowjacket.ttf]]},
	dorisPp = {name = 'DorisPP', path = [[interface\addons\sharedmedia\fonts\dorispp.ttf]]},
	fitzgerald = {name = 'Fitzgerald', path = [[interface\addons\sharedmedia\fonts\fitzgerald.ttf]]},
	gentium = {name = 'Gentium', path = [[interface\addons\sharedmedia\fonts\gentium.ttf]]},
	hookedUp = {name = 'Hooked Up', path = [[interface\addons\sharedmedia\fonts\hookedup.ttf]]},
	liberationSans = {name = 'Liberation Sans', path = [[interface\addons\sharedmedia\fonts\liberationsans.ttf]]},
	atarianSystem = {name = 'Atarian System', path = [[interface\addons\sharedmedia\fonts\sfatariansystem.ttf]]},
	covington = {name = 'Covington', path = [[interface\addons\sharedmedia\fonts\sfcovington.ttf]]},
	wonderComic = {name = 'Wonder Comic', path = [[interface\addons\sharedmedia\fonts\sfwonderComic.ttf]]},
	swfit = {name = 'Swf!t', path = [[interface\addons\sharedmedia\fonts\swfit.ttf]]},
	
	albaSuper = {name = 'Alba Super', path = [[interface\addons\sharedmediaadditionalfonts\fonts\albas___.ttf]]},
	accidentalPresidency = {name = 'Accidental Presidency', path = [[interface\addons\sharedmediaadditionalfonts\fonts\accidental presidency.ttf]]},
	blazed = {name = 'Blazed', path = [[interface\addons\sharedmediaadditionalfonts\fonts\blazed.ttf]]},
	diogenes = {name = 'Diogenes', path = [[interface\addons\sharedmediaadditionalfonts\fonts\diogenes.ttf]]},
	disko = {name = 'Disko', path = [[interface\addons\sharedmediaadditionalfonts\fonts\disko.ttf]]},
	frakturikaSpamless = {name = 'Frakturika Spamless', path = [[interface\addons\sharedmediaadditionalfonts\fonts\fraks___.ttf]]},
	impact = {name = 'Impact', path = [[interface\addons\sharedmediaadditionalfonts\fonts\impact.ttf]]},
	liberationSans = {name = 'Liberation Sans', path = [[interface\addons\sharedmediaadditionalfonts\fonts\liberationsans-regular.ttf]]},
	liberationSerif = {name = 'Liberation Serif', path = [[interface\addons\sharedmediaadditionalfonts\fonts\liberationserif-regular.ttf]]},
	mysticOrbs = {name = 'Mystic Orbs', path = [[interface\addons\sharedmediaadditionalfonts\fonts\mystikorbs.ttf]]},
	pokemonSolid = {name = 'Pokemon Solid', path = [[interface\addons\sharedmediaadditionalfonts\fonts\pokemon solid.ttf]]},
	rockShowWhiplash = {name = 'Rock Show Whiplash', path = [[interface\addons\sharedmediaadditionalfonts\fonts\rock show whiplash.ttf]]},
	solange = {name = 'Solange', path = [[interface\addons\sharedmediaadditionalfonts\fonts\solange.ttf]]},
	starCine = {name = 'Star Cine', path = [[interface\addons\sharedmediaadditionalfonts\fonts\starcine.ttf]]},
	trashco = {name = 'Trashco', path = [[interface\addons\sharedmediaadditionalfonts\fonts\trashco.ttf]]},
	waltographUi = {name = 'Waltograph UI', path = [[interface\addons\sharedmediaadditionalfonts\fonts\waltographui.ttf]]},
	x360 = {name = 'X360', path = [[interface\addons\sharedmediaadditionalfonts\fonts\x360.ttf]]},
};


Libs.texture = {
	aluminium = {name = 'Aluminium', path = [[interface\addons\SharedMedia\statusbar\Aluminium.tga]]},
	armory = {name = 'Armory', path = [[interface\addons\SharedMedia\statusbar\Armory.tga]]},
	bantoBar = {name = 'BantoBar', path = [[interface\addons\SharedMedia\statusbar\BantoBar.tga]]},
	bars = {name = 'Bars', path = [[interface\addons\SharedMedia\statusbar\Bars.tga]]},
	bumps = {name = 'Bumps', path = [[interface\addons\SharedMedia\statusbar\Bumps.tga]]},
	button = {name = 'Button', path = [[interface\addons\SharedMedia\statusbar\Button.tga]]},
	charcoal = {name = 'Charcoal', path = [[interface\addons\SharedMedia\statusbar\Charcoal.tga]]},
	cilo = {name = 'Cilo', path = [[interface\addons\SharedMedia\statusbar\Cilo.tga]]},
	cloud = {name = 'Cloud', path = [[interface\addons\SharedMedia\statusbar\Cloud.tga]]},
	combo = {name = 'Combo', path = [[interface\addons\SharedMedia\statusbar\combo.tga]]},
	comet = {name = 'Comet', path = [[interface\addons\SharedMedia\statusbar\Comet.tga]]},
	dabs = {name = 'Dabs', path = [[interface\addons\SharedMedia\statusbar\Dabs.tga]]},
	darkBottom = {name = 'DarkBottom', path = [[interface\addons\SharedMedia\statusbar\DarkBottom.tga]]},
	diagonal = {name = 'Diagonal', path = [[interface\addons\SharedMedia\statusbar\Diagonal.tga]]},
	empty = {name = 'Empty', path = [[interface\addons\SharedMedia\statusbar\Empty.tga]]},
	falumn = {name = 'Falumn', path = [[interface\addons\SharedMedia\statusbar\Falumn.tga]]},
	fifths = {name = 'Fifths', path = [[interface\addons\SharedMedia\statusbar\Fifths.tga]]},
	flat = {name = 'Flat', path = [[interface\addons\SharedMedia\statusbar\Flat.tga]]},
	fourths = {name = 'Fourths', path = [[interface\addons\SharedMedia\statusbar\Fourths.tga]]},
	frost = {name = 'Frost', path = [[interface\addons\SharedMedia\statusbar\Frost.tga]]},
	glamour = {name = 'Glamour', path = [[interface\addons\SharedMedia\statusbar\Glamour.tga]]},
	glamour2 = {name = 'Glamour2', path = [[interface\addons\SharedMedia\statusbar\Glamour2.tga]]},
	glamour3 = {name = 'Glamour3', path = [[interface\addons\SharedMedia\statusbar\Glamour3.tga]]},
	glamour4 = {name = 'Glamour4', path = [[interface\addons\SharedMedia\statusbar\Glamour4.tga]]},
	glamour5 = {name = 'Glamour5', path = [[interface\addons\SharedMedia\statusbar\Glamour5.tga]]},
	glamour6 = {name = 'Glamour6', path = [[interface\addons\SharedMedia\statusbar\Glamour6.tga]]},
	glamour7 = {name = 'Glamour7', path = [[interface\addons\SharedMedia\statusbar\Glamour7.tga]]},
	glass = {name = 'Glass', path = [[interface\addons\SharedMedia\statusbar\Glass.tga]]},
	glaze = {name = 'Glaze', path = [[interface\addons\SharedMedia\statusbar\Glaze.tga]]},
	glaze2 = {name = 'Glaze2', path = [[interface\addons\SharedMedia\statusbar\Glaze2.tga]]},
	gloss = {name = 'Gloss', path = [[interface\addons\SharedMedia\statusbar\Gloss.tga]]},
	graphite = {name = 'Graphite', path = [[interface\addons\SharedMedia\statusbar\Graphite.tga]]},
	grid = {name = 'Grid', path = [[interface\addons\SharedMedia\statusbar\Grid.tga]]},
	hatched = {name = 'Hatched', path = [[interface\addons\SharedMedia\statusbar\Hatched.tga]]},
	healbot = {name = 'Healbot', path = [[interface\addons\SharedMedia\statusbar\Healbot.tga]]},
	liteStep = {name = 'LiteStep', path = [[interface\addons\SharedMedia\statusbar\LiteStep.tga]]},
	liteStepLite = {name = 'LiteStepLite', path = [[interface\addons\SharedMedia\statusbar\LiteStepLite.tga]]},
	lyfe = {name = 'Lyfe', path = [[interface\addons\SharedMedia\statusbar\Lyfe.tga]]},
	melli = {name = 'Melli', path = [[interface\addons\SharedMedia\statusbar\Melli.tga]]},
	melliDark = {name = 'MelliDark', path = [[interface\addons\SharedMedia\statusbar\MelliDark.tga]]},
	melliDarkRough = {name = 'MelliDarkRough', path = [[interface\addons\SharedMedia\statusbar\MelliDarkRough.tga]]},
	minimalist = {name = 'Minimalist', path = [[interface\addons\SharedMedia\statusbar\Minimalist.tga]]},
	otravi = {name = 'Otravi', path = [[interface\addons\SharedMedia\statusbar\Otravi.tga]]},
	outline = {name = 'Outline', path = [[interface\addons\SharedMedia\statusbar\Outline.tga]]},
	perl = {name = 'Perl', path = [[interface\addons\SharedMedia\statusbar\Perl.tga]]},
	perl2 = {name = 'Perl2', path = [[interface\addons\SharedMedia\statusbar\Perl2.tga]]},
	pill = {name = 'Pill', path = [[interface\addons\SharedMedia\statusbar\Pill.tga]]},
	rain = {name = 'Rain', path = [[interface\addons\SharedMedia\statusbar\Rain.tga]]},
	rocks = {name = 'Rocks', path = [[interface\addons\SharedMedia\statusbar\Rocks.tga]]},
	round = {name = 'Round', path = [[interface\addons\SharedMedia\statusbar\Round.tga]]},
	ruben = {name = 'Ruben', path = [[interface\addons\SharedMedia\statusbar\Ruben.tga]]},
	runes = {name = 'Runes', path = [[interface\addons\SharedMedia\statusbar\Runes.tga]]},
	skewed = {name = 'Skewed', path = [[interface\addons\SharedMedia\statusbar\Skewed.tga]]},
	smooth = {name = 'Smooth', path = [[interface\addons\SharedMedia\statusbar\Smooth.tga]]},
	smoothv2 = {name = 'Smoothv2', path = [[interface\addons\SharedMedia\statusbar\Smoothv2.tga]]},
	smudge = {name = 'Smudge', path = [[interface\addons\SharedMedia\statusbar\Smudge.tga]]},
	steel = {name = 'Steel', path = [[interface\addons\SharedMedia\statusbar\Steel.tga]]},
	striped = {name = 'Striped', path = [[interface\addons\SharedMedia\statusbar\Striped.tga]]},
	tube = {name = 'Tube', path = [[interface\addons\SharedMedia\statusbar\Tube.tga]]},
	water = {name = 'Water', path = [[interface\addons\SharedMedia\statusbar\Water.tga]]},
	wglass = {name = 'Wglass', path = [[interface\addons\SharedMedia\statusbar\Wglass.tga]]},
	wisps = {name = 'Wisps', path = [[interface\addons\SharedMedia\statusbar\Wisps.tga]]},
	xeon = {name = 'Xeon', path = [[interface\addons\SharedMedia\statusbar\Xeon.tga]]},
};


Libs.duel = {
	name = {
		enUS = 'Duels',
	},
	trigger = {
		enUS = 'Duel starting: 1',
	},
};


Libs.zones = {
	nagrandArena = {
		names = {
			enUS = 'Nagrand Arena',
			frFR = 'Arène de Nagrand',
			deDE = 'Arena von Nagrand',
			koKR = '???? ???',
			esMX = 'Arena de Nagrand',
			ruRU = '????? ????????',
			zhCN = '??????',
			esES = 'Arena de Nagrand',
			zhTW = '??????',
		},
		playersPerTeam = 5,
		hasMap = false,
		groupId = 'arenas',
	},
	bladesEdgeArena = {
		names = {
			enUS = "Blade's Edge Arena",
			frFR = 'Arène des Tranchantes',
			deDE = 'Arena des Schergrats',
			koKR = '?? ???',
			esMX = 'Arena Filospada',
			ruRU = '????? ??????????',
			zhCN = '??????',
			esES = 'Arena Filospada',
			zhTW = '?????',
		},
		playersPerTeam = 5,
		hasMap = false,
		groupId = 'arenas',
	},
	ruinsOfLordaeron = {
		names = {
			enUS = 'Ruins of Lordaeron',
			frFR = 'Ruines de Lordaeron',
			deDE = 'Ruinen von Lordaeron',
			koKR = '???? ??',
			esMX = 'Ruinas de Lordaeron',
			ruRU = '????? ?????????',
			zhCN = '?????',
			esES = 'Ruinas de Lordaeron',
			zhTW = '?????',
		},
		playersPerTeam = 5,
		hasMap = false,
		groupId = 'arenas',
	},
	dalaranArena = {
		names = {
			enUS = 'Dalaran Arena',
			frFR = 'Arène de Dalaran',
			deDE = 'Arena von Dalaran',
			koKR = '??? ???',
			esMX = 'Arena de Dalaran',
			ruRU = '????? ????????',
			zhCN = '??????',
			esES = 'Arena de Dalaran',
			zhTW = '??????',
		},
		playersPerTeam = 5,
		hasMap = false,
		groupId = 'arenas',
	},
	theRingOfValor = {
		names = {
			enUS = 'The Ring of Valor',
			frFR = "L'Arène des valeureux",
			deDE = 'Der Ring der Ehre',
			koKR = '??? ???',
			esMX = 'El Anillo del Valor',
			ruRU = '???? ????????',
			zhCN = '?????',
			esES = 'El Anillo del Valor',
			zhTW = '????',
		},
		playersPerTeam = 5,
		hasMap = false,
		groupId = 'arenas',
	},
	battle_for_gilneas = {
		names = {
			enUS = 'The Battle for Gilneas',
			frFR = 'La bataille de Gilnéas',
			deDE = 'Die Schlacht um Gilneas',
			--koKR = '',
			esMX = 'La Batalla por Gilneas',
			ruRU = '????? ?? ???????',
			--zhCN = '',
			esES = 'La Batalla por Gilneas',
			--zhTW = '',
		},
		playersPerTeam = 10,
		hasMap = true,
	},
	twin_peaks = {
		names = {
			enUS = 'Twin Peaks',
			frFR = 'Pics-Jumeaux',
			deDE = 'Zwillingsgipfel',
			--koKR = '',w
			esMX = 'Cumbres Gemelas',
			ruRU = '??? ????',
			--zhCN = '',
			esES = 'Cumbres Gemelas',
			--zhTW = '',
		},
		playersPerTeam = 10,
		hasMap = true,
	},
	warsongGulch = {
		names = {
			enUS = 'Warsong Gulch',
			frFR = 'Goulet des Chanteguerres',
			deDE = 'Kriegshymnenschlucht',
			koKR = '???? ??',
			esMX = 'Garganta Grito de Guerra',
			ruRU = '?????? ????? ?????',
			zhCN = '????',
			esES = 'Garganta Grito de Guerra',
			zhTW = '????',
		},
		playersPerTeam = 10,
		hasMap = true,
	},
	arathiBasin = {
		names = {
			enUS = 'Arathi Basin',
			frFR = "Bassin d'Arathi",
			deDE = 'Arathibecken',
			koKR = '??? ??',
			esMX = 'Cuenca de Arathi',
			ruRU = '?????? ?????',
			zhCN = '?????',
			esES = 'Cuenca de Arathi',
			zhTW = '?????',
		},
		playersPerTeam = 15,
		hasMap = true,
	},
	eyeOfTheStorm = {
		names = {
			enUS = 'Eye of the Storm',
			frFR = "L'Œil du cyclone",
			deDE = 'Auge des Sturms',
			koKR = '??? ?',
			esMX = 'Ojo de la Tormenta',
			ruRU = '??? ????',
			zhCN = '????',
			esES = 'Ojo de la Tormenta',
			zhTW = '????',
		},
		playersPerTeam = 15,
		hasMap = true,
	},
	strandOfTheAncients = {
		names = {
			enUS = 'Strand of the Ancients',
			frFR = 'Rivage des anciens',
			deDE = 'Strand der Uralten',
			koKR = '??? ??',
			esMX = 'Playa de los Ancestros',
			ruRU = '????? ???????',
			zhCN = '????',
			esES = 'Playa de los Ancestros',
			zhTW = '????',
		},
		playersPerTeam = 15,
		hasMap = true,
	},
	alteracValley = {
		names = {
			enUS = 'Alterac Valley',
			frFR = "Vallée d'Alterac",
			deDE = 'Alteractal',
			koKR = '??? ??',
			esMX = 'Valle de Alterac',
			ruRU = '???????????? ??????',
			zhCN = '??????',
			esES = 'Valle de Alterac',
			zhTW = '??????',
		},
		playersPerTeam = 40,
		hasMap = true,
	},
	isleOfConquest = {
		names = {
			enUS = 'Isle of Conquest',
			frFR = 'Île des Conquérants',
			deDE = 'Insel der Eroberung',
			koKR = '??? ?',
			esMX = 'Isla de la Conquista',
			ruRU = '?????? ??????????',
			zhCN = '????',
			esES = 'Isla de la Conquista',
			zhTW = '????',
		},
		playersPerTeam = 40,
		hasMap = true,
	},
	tol_barad = {
		names = {
			enUS = 'Tol Barad',
			frFR = 'Tol Barad',
			deDE = 'Tol Barad',
			--koKR = '',
			esMX = 'Tol Barad',
			ruRU = '??? ?????',
			--zhCN = '',
			esES = 'Tol Barad',
			--zhTW = '',
		},
		playersPerTeam = 120,
		hasMap = true,
	},
	wintergrasp = {
		names = {
			enUS = 'Wintergrasp',
			frFR = "Joug-d'hiver",
			deDE = 'Tausendwintersee',
			koKR = '????? ??',
			esMX = 'Conquista del Invierno',
			ruRU = '????? ??????? ????',
			zhCN = '???',
			esES = 'Conquista del Invierno',
			zhTW = '???',
		},
		playersPerTeam = 120,
		hasMap = true,
	},
};


Libs.zoneGroups = {
	arenas = {
		names = {
			enUS = 'Arenas',
			frFR = 'Arènes',
			deDE = 'Arenen',
			--koKR = '',
			esMX = 'Arenas',
			ruRU = '?????',
			--zhCN = '',
			esES = 'Arenas',
			--zhTW = '',
		},
		playersPerTeam = 5,
		hasMap = false,
	},
};


Libs.classes = {
	deathknight = {
		pets = {
			ghoul = 1,
		},
		names = {
			enUS = 'Death Knight',
		},
		spec = {
			blood = {
				name = {
					enUS = 'Blood',
				},
			},
			frost = {
				name = {
					enUS = 'Frost',
				},
			},
			unholy = {
				name = {
					enUS = 'Unholy',
				},
			},
		},
	},
	druid = {
		names = {
			enUS = 'Druid',
		},
		spec = {
			balance = {
				name = {
					enUS = 'Balance',
				},
			},
			feralCombat = {
				name = {
					enUS = 'Feral Combat',
				},
			},
			restoration = {
				name = {
					enUS = 'Restoration',
				},
			},
		},
	},
	hunter = {
		pets = {
			hunter_pet = 1,
		},
		names = {
			enUS = 'Hunter',
		},
		spec = {
			beastMastery = {
				name = {
					enUS = 'Beast Mastery',
				},
			},
			marksmanship = {
				name = {
					enUS = 'Marksmanship',
				},
			},
			survival = {
				name = {
					enUS = 'Survival',
				},
			},
		},
	},
	mage = {
		pets = {
			water_elemental = 1,
		},
		names = {
			enUS = 'Mage',
		},
		spec = {
			arcane = {
				name = {
					enUS = 'Arcane',
				},
			},
			fire = {
				name = {
					enUS = 'Fire',
				},
			},
			frost = {
				name = {
					enUS = 'Frost',
				},
			},
		},
	},
	paladin = {
		names = {
			enUS = 'Paladin',
		},
		spec = {
			holy = {
				name = {
					enUS = 'Holy',
				},
			},
			protection = {
				name = {
					enUS = 'Protection',
				},
			},
			retribution = {
				name = {
					enUS = 'Retribution',
				},
			},
		},
	},
	priest = {
		names = {
			enUS = 'Priest',
		},
		spec = {
			discipline = {
				name = {
					enUS = 'Discipline',
				},
			},
			holy = {
				name = {
					enUS = 'Holy',
				},
			},
			shadow = {
				name = {
					enUS = 'Shadow',
				},
			},
		},
	},
	rogue = {
		names = {
			enUS = 'Rogue',
		},
		spec = {
			assassination = {
				name = {
					enUS = 'Assassination',
				},
			},
			combat = {
				name = {
					enUS = 'Combat',
				},
			},
			subtlety = {
				name = {
					enUS = 'Subtlety',
				},
			},
		},
	},
	shaman = {
		names = {
			enUS = 'Shaman',
		},
		spec = {
			elemental = {
				name = {
					enUS = 'Elemental',
				},
			},
			enhancement = {
				name = {
					enUS = 'Enhancement',
				},
			},
			restoration = {
				name = {
					enUS = 'Restoration',
				},
			},
		},
	},
	warlock = {
		pets = {
			felguard = 1,
			felhunter = 1,
			imp = 1,
			succubus = 1,
			voidwalker = 1,
		},
		names = {
			enUS = 'Warlock',
		},
		spec = {
			affliction = {
				name = {
					enUS = 'Affliction',
				},
			},
			demonology = {
				name = {
					enUS = 'Demonology',
				},
			},
			destruction = {
				name = {
					enUS = 'Destruction',
				},
			},
		},
	},
	warrior = {
		names = {
			enUS = 'Warrior',
			frFR = 'Guerrier',
			deDE = 'Krieger',
			--koKR = '',
			esMX = 'Guerrero',
			ruRU = '????',
			--zhCN = '',
			esES = 'Guerrero',
			--zhTW = '',
		},
		spec = {
			arms = {
				name = {
					enUS = 'Arms',
					frFR = 'Armes',
					deDE = 'Waffen',
					--koKR = '',
					esMX = 'Armas',
					ruRU = '??????',
					--zhCN = '',
					esES = 'Armas',
					--zhTW = '',
				},
			},
			fury = {
				name = {
					enUS = 'Fury',
					frFR = 'Fureur',
					deDE = 'Furor',
					--koKR = '',
					esMX = 'Furia',
					ruRU = '???????????',
					--zhCN = '',
					esES = 'Furia',
					--zhTW = '',
				},
			},
			protection = {
				name = {
					enUS = 'Protection',
					frFR = 'Protection',
					deDE = 'Schutz',
					--koKR = '',
					esMX = 'Protección',
					ruRU = '??????',
					--zhCN = '',
					esES = 'Protección',
					--zhTW = '',
				},
			},
		},
	},
};


Libs.icons = {
	default = [[interface\icons\trade_engineering]],
	of = {
		panel = {
			extraFrames = [[interface\icons\inv_misc_stonetablet_09]],
			focusFrame = [[interface\icons\inv_misc_stonetablet_07]],
			targetFrame = [[interface\icons\inv_misc_stonetablet_01]],
			general = [[interface\icons\inv_misc_wrench_01]],
		},
		group = {
			row = [[interface\icons\inv_gizmo_mithrilcasing_02]],
			anchor = [[interface\icons\trade_blacksmithing]],
			endpoint = [[interface\icons\spell_shadow_soulgem]],
			font = [[interface\icons\inv_stone_weightstone_05]],
			player = [[interface\icons\spell_holy_crusade]],
			pet = [[interface\icons\ability_hunter_ferociousinspiration]],
			color = 'interface\\icons\\inv_ore_arcanite_01',
			texture = 'interface\\icons\\inv_fabric_wool_01',
			allClasses = {
				general = 'interface\\icons\\spell_magic_polymorphchicken',
				standards = 'interface\\icons\\inv_brd_banner',
			},
		},
	},
	profession = {
		firstAid = 'interface\\icons\\spell_holy_sealofsacrifice',
		alchemy = 'interface\\icons\\trade_alchemy',
		engineering = 'interface\\icons\\trade_engineering',
		herbalism = 'interface\\icons\\spell_nature_naturetouchgrow',
		leatherworking = 'interface\\icons\\inv_misc_armorkit_17',
		tailoring = 'interface\\icons\\trade_tailoring',
	},
	misc = {
		close = 'Interface\\BUTTONS\\UI-Panel-MinimizeButton-Up';
		petLink = 'Interface\\Icons\\Ability_Hunter_BeastWithin',
		alliance = 'Interface\\Icons\\Inv_Misc_Tournaments_Banner_Human',
		horde = 'Interface\\Icons\\Inv_Misc_Tournaments_Banner_Orc',
		rangeMode = 'Interface\\Icons\\Spell_nature_timestop',
		teamMode = 'Interface\\Icons\\Inv_misc_grouplooking',
		pin = 'Interface\\Icons\\Ability_Hunter_SniperShot',
		unpin = 'Interface\\Icons\\Spell_shadow_twilight'
	},
	player = {
		general = 'Interface\\Icons\\Spell_magic_polymorphchicken';
		class = {
			deathknight = 'Interface\\Addons\\WOOGLED\\icons\\death_knight',
			druid = 'Interface\\Icons\\INV_Misc_MonsterClaw_04',
			hunter = 'Interface\\Icons\\INV_Weapon_Bow_07',
			mage = 'Interface\\Icons\\INV_Staff_13',
			paladin = 'Interface\\Addons\\WOOGLED\\icons\\paladin',
			priest = 'Interface\\Addons\\WOOGLED\\icons\\priest',
			rogue = 'Interface\\Addons\\WOOGLED\\icons\\rogue',
			shaman = 'Interface\\Icons\\Spell_Nature_BloodLust',
			warlock = 'Interface\\Icons\\Spell_Nature_Drowsy',
			warrior = 'Interface\\Icons\\INV_Sword_27'
		},
		spec = {
			deathknight = {
				blood = 'interface\\icons\\spell_deathknight_bloodpresence',
				frost = 'interface\\icons\\spell_deathknight_frostpresence',
				unholy = 'interface\\icons\\spell_deathknight_unholypresence',
			},
			druid = {
				balance = 'interface\\icons\\spell_nature_starfall',
				feralCombat = 'interface\\icons\\ability_racial_bearform',
				restoration = 'interface\\icons\\spell_nature_healingtouch',
			},
			hunter = {
				beastMastery = 'interface\\icons\\ability_hunter_bestialdiscipline',
				marksmanship = 'interface\\icons\\ability_hunter_focusedaim',
				survival = 'interface\\icons\\ability_hunter_camouflage',
			},
			mage = {
				arcane = 'interface\\icons\\spell_holy_magicalsentry',
				fire = 'interface\\icons\\spell_fire_firebolt02',
				frost = 'interface\\icons\\spell_frost_frostbolt02',
			},
			paladin = {
				holy = 'interface\\icons\\spell_holy_holybolt',
				protection = 'interface\\icons\\ability_paladin_shieldofthetemplar',
				retribution = 'interface\\icons\\spell_holy_auraoflight',
			},
			priest = {
				discipline = 'interface\\icons\\spell_holy_powerwordshield',
				holy = 'interface\\icons\\spell_holy_guardianspirit',
				shadow = 'interface\\icons\\spell_shadow_shadowwordpain',
			},
			rogue = {
				assassination = 'interface\\icons\\ability_rogue_eviscerate',
				combat = 'interface\\icons\\ability_backStab',
				subtlety = 'interface\\icons\\ability_stealth',
			},
			shaman = {
				elemental = 'interface\\icons\\spell_nature_lightning',
				enhancement = 'interface\\icons\\spell_nature_lightningshield',
				restoration = 'interface\\icons\\spell_nature_resistmagic',
			},
			warlock = {
				affliction = 'interface\\icons\\spell_shadow_deathCoil',
				demonology = 'interface\\icons\\spell_shadow_metamorphosis',
				destruction = 'interface\\icons\\spell_shadow_rainoffire',
			},
			warrior = {
				arms = 'interface\\icons\\ability_warrior_savageblow',
				fury = 'interface\\icons\\ability_warrior_innerrage',
				protection = 'interface\\icons\\ability_warrior_defensivestance',
			}
		}
	},
	pet = {
		class = {
			voidwalker = 'Interface\\Icons\\Spell_Shadow_SummonVoidWalker',
			felhunter = 'Interface\\Icons\\Spell_Shadow_SummonFelHunter',
			felguard = 'Interface\\Icons\\Spell_Shadow_SummonFelguard',
			ghoul = 'Interface\\Icons\\Spell_shadow_RaiseDead',
			hunterPet = 'Interface\\Icons\\Ability_Hunter_BeastTraining',
			imp = 'Interface\\Icons\\spell_shadow_summonimp',
			succubus = 'Interface\\Icons\\spell_shadow_summonsuccubus',
			waterElemental = 'Interface\\Icons\\spell_frost_summonwaterelemental_2',
		}
	}
};


Libs.events = {
	success = {
		SPELL_CAST_SUCCESS = 1,
	},
	create = {
		SPELL_CREATE = 1,
	},
	resurrect = {
		SPELL_RESURRECT = 1,
	},
	summon = {
		SPELL_SUMMON = 1,
	},
	energize = {
		SPELL_ENERGIZE = 1,
	},
	leech = {
		SPELL_LEECH = 1,
	},
	auraRemove = {
		SPELL_AURA_REMOVED = 1,
	},
	damage = {
		SPELL_DAMAGE = 1,
		SPELL_MISSED = 1,
	},
	damageSplit = {
		DAMAGE_SPLIT = 1,
		SPELL_MISSED = 1,
	},
	heal = {
		SPELL_HEAL = 1,
		SPELL_MISSED = 1,
	},
	auraApply = {
		SPELL_AURA_APPLIED = 1,
		SPELL_MISSED = 1,
		SPELL_AURA_REFRESH = 1,
	},
	auraApplyRemove = {
		SPELL_AURA_APPLIED = 1,
		SPELL_AURA_REMOVED = 1,
	},
	auraApplyRemove_periodicEnergize = {
		SPELL_AURA_APPLIED = 1,
		SPELL_AURA_REMOVED = 1,
		SPELL_PERIODIC_ENERGIZE = 1,
	},
	auraApplyRemove_periodicHeal = {
		SPELL_AURA_APPLIED = 1,
		SPELL_AURA_REMOVED = 1,
		SPELL_PERIODIC_HEAL = 1,
	},
	auraApply_periodicHeal = {
		SPELL_AURA_APPLIED = 1,
		SPELL_MISSED = 1,
		SPELL_PERIODIC_HEAL = 1,
	},
	auraApply_periodicEnergize = {
		SPELL_AURA_APPLIED = 1,
		SPELL_MISSED = 1,
		SPELL_PERIODIC_ENERGIZE = 1,
	},
};