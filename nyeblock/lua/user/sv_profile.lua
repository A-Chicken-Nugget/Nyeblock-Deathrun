util.AddNetworkString("nyeblock_setProfile")

//
// MANAGE USER PROFILE
//
hook.Add("PlayerAuthed","checkProfile",function(ply)
	//Select users profile
	local qs = [[
		SELECT *
		FROM nyeblock_users
		WHERE steamid64 = "%s"
	]]
	NYEBLOCK.DATABASES.NB_QUERY("nyeblock",string.format(qs,ply:SteamID64()),function(data)
		//If the users profile exists then...
		if #data > 0 then
			//If the players ip does not match the one in the db update and log
			if data[1].ip != ply:IPAddress() then
				//Update users ip
				local qs = [[
					UPDATE nyeblock_users
					SET ip = "%s"
					WHERE id = %i
				]]
				NYEBLOCK.DATABASES.NB_QUERY("nyeblock",string.format(qs,ply:IPAddress(),data[1].id))
				//Log new ip
				local qs = [[
					INSERT INTO nyeblock_ipLogs (userId,ip)
					VALUES (%i,"%s")
				]]
				NYEBLOCK.DATABASES.NB_QUERY("nyeblock",string.format(qs,data[1].id,ply:IPAddress()))
			end
			//If the players uniqueId is not filled
			if data[1].uniqueId == nil then
				local qs = [[
					UPDATE nyeblock_users
					SET uniqueId = %i
					WHERE id = %i
				]]
				NYEBLOCK.DATABASES.NB_QUERY("nyeblock",string.format(qs,ply:UniqueID(),data[1].id))
			end
			//If the players name is not filled
			if data[1].name == nil then
				local qs = [[
					UPDATE nyeblock_users
					SET name = "%s"
					WHERE id = %i
				]]
				NYEBLOCK.DATABASES.NB_QUERY("nyeblock",string.format(qs,NYEBLOCK.DATABASES.NB:escape(ply:Nick()),data[1].id))
			else
				//If the players name has changed from what is in the db
				if data[1].name != NYEBLOCK.DATABASES.NB:escape(ply:Nick()) then
					local qs = [[
						UPDATE nyeblock_users
						SET name = "%s"
						WHERE id = %i
					]]
					NYEBLOCK.DATABASES.NB_QUERY("nyeblock",string.format(qs,NYEBLOCK.DATABASES.NB:escape(ply:Nick()),data[1].id))
				end
			end
			//If the players ulx group does not match the one in the db
			if data[1].ulxGroup != ply:GetUserGroup() then
				//Update users ulx group
				local qs = [[
					UPDATE nyeblock_users
					SET ulxGroup = "%s"
					WHERE id = %i
				]]
				NYEBLOCK.DATABASES.NB_QUERY("nyeblock",string.format(qs,ply:GetUserGroup(),data[1].id))
			end
			//Create join log
			local qs = [[
				INSERT INTO nyeblock_joinLogs (userId,timestamp)
				VALUES (%i,%i)
			]]
			NYEBLOCK.DATABASES.NB_QUERY("nyeblock",string.format(qs,data[1].id,os.time()))
			//Handles profile links
			if data[1].links != nil then
				local links = util.JSONToTable(data[1].links)
				
				for k,v in pairs(links) do
					links[k].value = NYEBLOCK.FUNCTIONS.decodeURL(v.value)
				end
				data[1].links = links
			end
			//Send profile to client side
			net.Start("nyeblock_setProfile")
				net.WriteTable(data)
			net.Send(ply)
			//Set var to hold the users DB id
			ply:SetNWInt("nyeblock_userId",data[1].id)
		else
			//Create user profile
			local qs = [[
				INSERT INTO nyeblock_users (steamid64,uniqueId,name,ulxGroup,ip,motto,signature)
				VALUES ("%s",%i,"%s","%s","%s","","")
			]]
			NYEBLOCK.DATABASES.NB_QUERY("nyeblock",string.format(qs,ply:SteamID64(),ply:UniqueID(),NYEBLOCK.DATABASES.NB:escape(ply:Nick()),ply:GetUserGroup(),ply:IPAddress()),function()
				//Select created profile
				local qs = [[
					SELECT *
					FROM nyeblock_users
					WHERE steamid64 = "%s"
				]]
				NYEBLOCK.DATABASES.NB_QUERY("nyeblock",string.format(qs,ply:SteamID64()),function(data)
					//Create log tables
					local qs = [[
						INSERT INTO nyeblock_deathLogs (userId,count)
						VALUES (%i,0)
					]]
					NYEBLOCK.DATABASES.NB_QUERY("nyeblock",string.format(qs,data[1].id))
					local qs = [[
						INSERT INTO nyeblock_killLogs (userId,count)
						VALUES (%i,0)
					]]
					NYEBLOCK.DATABASES.NB_QUERY("nyeblock",string.format(qs,data[1].id))
					local qs = [[
						INSERT INTO nyeblock_winLogs (userId,runnerCount,deathCount)
						VALUES (%i,0,0)
					]]
					NYEBLOCK.DATABASES.NB_QUERY("nyeblock",string.format(qs,data[1].id))
					local qs = [[
						INSERT INTO nyeblock_teamLogs (userId,runnerCount,deathCount)
						VALUES (%i,0,0)
					]]
					NYEBLOCK.DATABASES.NB_QUERY("nyeblock",string.format(qs,data[1].id))
					//Log ip
					local qs = [[
						INSERT INTO nyeblock_ipLogs (userId,ip)
						VALUES (%i,"%s")
					]]
					NYEBLOCK.DATABASES.NB_QUERY("nyeblock",string.format(qs,data[1].id,ply:IPAddress()))
					//Create join log
					local qs = [[
						INSERT INTO nyeblock_joinLogs (userId,timestamp)
						VALUES (%i,%i)
					]]
					NYEBLOCK.DATABASES.NB_QUERY("nyeblock",string.format(qs,data[1].id,os.time()))
					//Send profile to client side
					net.Start("nyeblock_setProfile")
						net.WriteTable(data)
					net.Send(ply)
					//Set player var to hold the users DB id
					ply:SetNWInt("nyeblock_userId",data[1].id)
				end)
			end)
		end
	end)
end)