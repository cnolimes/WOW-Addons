-- don't load if class is wrong
local _, class = UnitClass("player")
if class ~= "DRUID" then return end

local version = 1

local Duid = {}

-- create a module in the main addon
local modName = "global"
local mod = WA:RegisterClassModule(modName)

function mod.OnInitialize()
	-- WoWAssist:Print("Loading Duid Global")
end
