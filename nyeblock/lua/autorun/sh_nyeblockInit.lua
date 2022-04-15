NYEBLOCK = {}
NYEBLOCK.DATABASES_INFO = {}
NYEBLOCK.FUNCTIONS = {}

//Automatically add files to their appropriate realm
-- local clientFiles = {}
-- local serverFiles = {}
-- local initialFiles, initialDirectories = file.Find("addons/nyeblock/lua/*","GAME")

-- for k,v in pairs(initialFiles) do
-- 	AddCSLuaFile(v)
-- 	include(v)
-- end
-- for k,v in pairs(initialDirectories) do
-- 	if v != "autorun" then
-- 		local files = file.Find("addons/nyeblock/lua/"..v.."/*","GAME")
		
-- 		for k2,v2 in pairs(files) do
-- 			if !string.find(v2,"disabled_") then
-- 				if string.find(v2,"cl_") then
-- 					table.insert(clientFiles,v.."/"..v2)
-- 				elseif string.find(v2,"sv_") then
-- 					table.insert(serverFiles,v.."/"..v2)
-- 				else
-- 					AddCSLuaFile(v.."/"..v2)
-- 					include(v.."/"..v2)
-- 				end
-- 			end
-- 		end
-- 	end
-- end

//Shared files to include
AddCSLuaFile("nyeblock_config.lua")
include("nyeblock_config.lua")
AddCSLuaFile("levels/sh_levels.lua")
include("levels/sh_levels.lua")
AddCSLuaFile("seasons/sh_seasonManager.lua")
include("seasons/sh_seasonManager.lua")
AddCSLuaFile("donations/sh_donationManager.lua")
include("donations/sh_donationManager.lua")
AddCSLuaFile("user/sh_functions.lua")
include("user/sh_functions.lua")