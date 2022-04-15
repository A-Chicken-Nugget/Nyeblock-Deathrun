util.AddNetworkString("nyeblock_motd")
util.AddNetworkString("nyeblock_getLatestUpdate")
util.AddNetworkString("nyeblock_returnLatestUpdate")
util.AddNetworkString("nyeblock_getAllUpdates")
util.AddNetworkString("nyeblock_returnAllUpdates")
util.AddNetworkString("nyeblock_checkPoints")
util.AddNetworkString("nyeblock_seasonReward")

net.Receive("nyeblock_saveSurvey",function(_,ply)
	local questions = net.ReadTable()

	local qs = [[
		SELECT *
		FROM survey_data
		WHERE userId = %i
	]]
	NYEBLOCK.DATABASES.NB_QUERY("nyeblock",string.format(qs,ply:GetNWInt("nyeblock_userId")),function(data)
		if #data == 0 then
			if questions["q1"] != nil then
				local qs = [[
					INSERT INTO survey_data (userId,q1,q2)
					VALUES (%i,"%s","%s")
				]]
				NYEBLOCK.DATABASES.NB_QUERY("nyeblock",string.format(qs,ply:GetNWInt("nyeblock_userId"),NYEBLOCK.DATABASES.NB:escape(questions["q1"]),NYEBLOCK.DATABASES.NB:escape(questions["q2"])))
				ply:PS_GivePoints(5000)
				ply:ChatPrint("Thanks for completing the survey! You have been given 5,000 points!")
			else
				local qs = [[
					INSERT INTO survey_data (userId,q1,q2)
					VALUES (%i,NULL,NULL)
				]]
				NYEBLOCK.DATABASES.NB_QUERY("nyeblock",string.format(qs,ply:GetNWInt("nyeblock_userId")))
			end
		end
	end)
end)

hook.Add("PlayerInitialSpawn", "SpawnCheck", function( ply )
	local season = nyeblock_getCurrentSeason()
	if season != nil then
		local year = os.date("%Y",os.time())

		local qs = [[
			SELECT *
			FROM `season_seasonLogs`
			WHERE steamid64 = '%s' AND season = '%s' AND year = '%i'
		]]
		NYEBLOCK.DATABASES.NB_QUERY("nyeblock",string.format(qs,ply:SteamID64(),season,year),function(data)
			if #data == 0 then
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
end)

net.Receive("nyeblock_getLatestUpdate",function(_,ply)
	local qs = [[
		SELECT *
		FROM nyeblock_updates
		ORDER BY created DESC
		LIMIT 1
	]]
	NYEBLOCK.DATABASES.NB_QUERY("nyeblock",qs,function(latestUpdate)
		net.Start("nyeblock_returnLatestUpdate")
			net.WriteTable(latestUpdate[1])
		net.Send(ply)
	end)
end)
net.Receive("nyeblock_getAllUpdates",function(_,ply)
	local qs = [[
		SELECT *
		FROM nyeblock_updates
		ORDER BY created ASC
	]]
	NYEBLOCK.DATABASES.NB_QUERY("nyeblock",qs,function(updates)
		net.Start("nyeblock_returnAllUpdates")
			net.WriteTable(updates)
		net.Send(ply)
	end)
end)
net.Receive("nyeblock_checkPoints",function(_,ply)
	ply:PS_PlayerSpawn()
	local qs = [[
		SELECT *
		FROM `freePoints`
		WHERE steamid = '%s'
	]]
	NYEBLOCK.DATABASES.NB_QUERY("nyeblock",string.format(qs,ply:SteamID()),function(data)
		if #data == 0 then
			local qs = [[
				INSERT INTO `freePoints` (`name`,`steamid`,`joinDate`)
				VALUES ('%s','%s','%s')
			]]
			NYEBLOCK.DATABASES.NB_QUERY("nyeblock",string.format(qs,NYEBLOCK.DATABASES.NB:escape(ply:Nick()),ply:SteamID(),os.date()),function(data)
				ply:ChatPrint("You have been given 40k points for joining the server, enjoy.")
				ply:PS_GivePoints(40000)
			end)
		end
	end)
end)
net.Receive("nyeblock_seasonReward",function(_,ply)
	local season = nyeblock_getCurrentSeason()
	local year = os.date("%Y",os.time())
	local seasonData = nyeblock_getSeasonMenuInfo(season)

	if seasonData.pointsInfo.givePoints then
		ply:PS_GivePoints(seasonData.pointsInfo.amount)
		ply:ChatPrint(seasonData.pointsInfo.message)
	end

	local qs = [[
		INSERT INTO `season_seasonLogs` (`steamid64`,`season`,`year`)
		VALUES ('%s','%s','%i')
	]]
	NYEBLOCK.DATABASES.NB_QUERY("nyeblock",string.format(qs,ply:SteamID64(),season,year))
end)