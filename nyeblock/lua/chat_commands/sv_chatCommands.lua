hook.Add( "PlayerSay", "ChatCheck", function( ply, text, bteam )
	if (table.HasValue( {"!moderator","!mod"}, text:lower() ) ) then
		net.Start("mp_panel")
		net.Send( ply )
		return ""
	elseif (table.HasValue( {"!level","!LEVEL","!levels"}, text:lower() ) ) then
		net.Start("nyeblock_levelMenu")
		net.Send(ply)
		return ""
	elseif (table.HasValue({"!profile","!PROFILE"},text:lower())) then
		net.Start("nyeblock_profileMenu")
    	net.Send(ply)
		return ""
	elseif (table.HasValue( {"!donate","!DONATE"}, text:lower() ) ) then
		local qs = [[
			SELECT credits
			FROM `playerDonationProfiles`
			WHERE steamid64 = '%s'
		]]
		NYEBLOCK.DATABASES.NB_QUERY("nyeblock",string.format(qs,ply:SteamID64()),function(data)
			local e = 0
			if table.Count(data) > 0 then
				e = data[1].credits
			end
			net.Start("nyeblock_donationPanel")
				net.WriteString(e)
			net.Send(ply)
		end)
		return ""
	elseif (table.HasValue( {"!motd","!MOTD"}, text:lower() ) ) then
		local season = nyeblock_getCurrentSeason()
		if season != nil then
			local year = os.date("%Y",os.time())

			local qs = [[
				SELECT *
				FROM `season_seasonLogs`
				WHERE steamid64 = '%s' AND season = '%s' AND year = '%i'
			]]
			NYEBLOCK.DATABASES.NB_QUERY("nyeblock",string.format(qs,ply:SteamID64(),season,year),function(data)
				if table.Count(data) == 0 then
					net.Start("nyeblock_motd")
						net.WriteBool(true)
					net.Send(ply)
				else
					net.Start("nyeblock_motd")
						net.WriteBool(false)
					net.Send(ply)
				end
			end)
		else
			net.Start("nyeblock_motd")
				net.WriteBool(false)
			net.Send(ply)
		end
		return ""
	elseif (table.HasValue( {"!reportexploit","!exploitreport"}, text:lower() ) ) then
		ply:ChatPrint("This feature is currently being redone and is disabled.")
		-- local tbl = {}
		-- if !file.Exists("ers","DATA") then
		-- 	file.CreateDir("ers/reports")
		-- 	file.CreateDir("ers/images")
		-- end

		-- for k,v in pairs(file.Find("ers/reports/*.txt","DATA")) do
		-- 	local data = util.JSONToTable(file.Read("ers/reports/"..v))
		-- 	if data.steamid64 == ply:SteamID64() then
		-- 		table.insert(tbl, data)
		-- 	end
		-- end

		-- net.Start("ers_panel")
		-- 	net.WriteTable(tbl)
		-- net.Send(ply)
		return ""
	elseif table.HasValue({"!sr","!serverrecords"},text:lower()) then
		net.Start("nyeblock_serverRecordsPanel")
		net.Send(ply)
		return ""
	elseif table.HasValue({"!ghost","!GHOST"},text:lower()) then
		ply:ChatPrint("Please use the command !redie")
		return ""
	elseif table.HasValue({"!usersearch","!USERSEARCH"},text:lower()) then
		local playersString = ""

		for k,v in pairs(player.GetAll()) do
			if playersString == "" then
				playersString = "steamid64 = "..v:SteamID64()
			else
				playersString = playersString.." OR steamid64 = "..v:SteamID64()
			end
		end

		local qs = [[
			SELECT id, steamid64, name, links
			FROM nyeblock_users
			WHERE %s
		]]
		NYEBLOCK.DATABASES.NB_QUERY("nyeblock",string.format(qs,playersString),function(data)
			if table.Count(data) > 0 then
				for k,v in pairs(data) do
					if data[k].links != nil then
						data[k].links = util.JSONToTable(v.links)
						for k2,v2 in pairs(v.links) do
							data[k].links[k2].value = NYEBLOCK.FUNCTIONS.decodeURL(data[k].links[k2].value)
						end
					end
				end
				net.Start("nyeblock_userSearch")
					net.WriteTable(data)
				net.Send(ply)
			else
				net.Start("nyeblock_userSearch")
					net.WriteTable({})
				net.Send(ply)
			end
		end)
		return ""
	end
end)