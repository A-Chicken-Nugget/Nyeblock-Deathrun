NYEBLOCK.DATABASES = {}

require( "mysqloo" )
local nb_queue = {}
local nb_applications_queue = {}

//NyeBlock DB
NYEBLOCK.DATABASES.NB = mysqloo.connect("nyeblock.site.nfoservers.com","nyeblock","25nz4Q^7nef7KN3+","nyeblock_deathrun",3306)
function NYEBLOCK.DATABASES.NB:onConnected()
	for k, v in pairs(nb_queue) do
		NYEBLOCK.DATABASES.NB_QUERY("nyeblock",v[1],v[2])
	end
	nb_queue = {}
end
NYEBLOCK.DATABASES.NB:connect()
//Applications DB
NYEBLOCK.DATABASES.NB_APPLICATIONS = mysqloo.connect("nyeblock.site.nfoservers.com","nyeblock","25nz4Q^7nef7KN3+","nyeblock_serverManagement",3306)
function NYEBLOCK.DATABASES.NB_APPLICATIONS:onConnected()
	for k, v in pairs(nb_applications_queue) do
		NYEBLOCK.DATABASES.NB_QUERY("applications",v[1],v[2])
	end
	nb_applications_queue = {}
end
NYEBLOCK.DATABASES.NB_APPLICATIONS:connect()
//Single query function
function NYEBLOCK.DATABASES.NB_QUERY(database,sql,callback)
	if database == "nyeblock" then
		local q = NYEBLOCK.DATABASES.NB:query(sql)
		function q:onSuccess(data)
			if callback then
				callback(data)
			end
		end
		function q:onError(err)
			if NYEBLOCK.DATABASES.NB:status() == mysqloo.DATABASE_NOT_CONNECTED then
				table.insert(nb_queue,{sql,callback})
				NYEBLOCK.DATABASES.NB:connect()
				return
			end
			print("[nB] Database Query Errored, error: ",err," sql: ",sql)
		end
		q:start()
	elseif database == "applications" then
		local q = NYEBLOCK.DATABASES.NB_APPLICATIONS:query(sql)
		function q:onSuccess(data)
			if callback then
				callback(data)
			end
		end
		function q:onError(err)
			if NYEBLOCK.DATABASES.NB_APPLICATIONS:status() == mysqloo.DATABASE_NOT_CONNECTED then
				table.insert(nb_queue,{sql,callback})
				NYEBLOCK.DATABASES.NB_APPLICATIONS:connect()
				return
			end
			print("[nB] Database Query Errored, error: ",err," sql: ",sql)
		end
		q:start()
	end
end
//Multi query function
function NYEBLOCK.DATABASES.NB_MULTI_QUERY(database,queries,callback)
	local tbl = {}
	local id = os.time()
	local completedCount = 0

	if database == "nyeblock" then
		for k,v in pairs(queries) do
			local q = NYEBLOCK.DATABASES.NB:query(v)
			function q:onSuccess(data)
				tbl[k] = data
				completedCount = completedCount + 1
			end
			function q:onError(err)
				print("[nB] Database Query Errored, error: ",err," sql: ",sql)
				completedCount = completedCount + 1
			end
			q:start()
		end
	elseif database == "applications" then
		for k,v in pairs(queries) do
			local q = NYEBLOCK.DATABASES.NB_APPLICATIONS:query(v)
			function q:onSuccess(data)
				tbl[k] = data
				completedCount = completedCount + 1
			end
			function q:onError(err)
				print("[nB] Database Query Errored, error: ",err," sql: ",sql)
				completedCount = completedCount + 1
			end
			q:start()
		end
	end
	if callback then
		timer.Create("nyeblock_awaitQueries_"..id,.1,150,function()
			if completedCount == #queries then
				timer.Destroy("nyeblock_awaitQueries_"..id)
				callback(tbl)
			end
		end)
	end
end

//Files to include
include("chat_commands/sv_chatCommands.lua")
include("cheat_detection/sv_antiAntiAfk.lua")
include("cheat_detection/sv_syncTrack.lua")
include("donations/sv_donationManager.lua")
AddCSLuaFile("donations/cl_donationManager.lua")
include("profile/sv_profile.lua")
AddCSLuaFile("profile/cl_profile.lua")
include("profile/sv_viewProfile.lua")
AddCSLuaFile("profile/cl_viewProfile.lua")
include("exploit_reporting/sv_exploitReporting.lua")
AddCSLuaFile("exploit_reporting/cl_exploitReporting.lua")
include("f1/sv_f1.lua")
AddCSLuaFile("f1/cl_f1.lua")
include("levels/sv_levels.lua")
AddCSLuaFile("levels/cl_levels.lua")
include("logs/sv_logs.lua")
include("motd/sv_motd.lua")
AddCSLuaFile("motd/cl_motd.lua")
include("popups/sv_hints.lua")
AddCSLuaFile("popups/cl_hints.lua")
include("popups/sv_roundPopup.lua")
AddCSLuaFile("popups/cl_roundPopup.lua")
include("rtd/sv_rtd.lua")
AddCSLuaFile("rtd/cl_rtd.lua")
include("tag_system/sv_tagSystem.lua")
AddCSLuaFile("tag_system/cl_tagSystem.lua")
include("user/sv_profile.lua")
AddCSLuaFile("user/cl_profile.lua")
include("user/sv_userSearch.lua")
AddCSLuaFile("user/cl_userSearch.lua")
include("shared_functions/sh_urlEncoding.lua")
AddCSLuaFile("shared_functions/sh_urlEncoding.lua")

-- for k,v in pairs(serverFiles) do
-- 	include(v)
-- end
-- for k,v in pairs(clientFiles) do
-- 	AddCSLuaFile(v)
-- end