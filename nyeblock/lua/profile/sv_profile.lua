util.AddNetworkString("nyeblock_profileMenu")
util.AddNetworkString("nyeblock_getUserStats")
util.AddNetworkString("nyeblock_returnUserStats")
util.AddNetworkString("nyeblock_updateProfile")
util.AddNetworkString("nyeblock_getUserSettings")
util.AddNetworkString("nyeblock_returnUserSettings")
util.AddNetworkString("nyeblock_updateSettings")

net.Receive("nyeblock_getUserStats",function(_,ply)
	local userId = ply:GetNWInt("nyeblock_userId")
	local queries = {
		string.format([[
			SELECT count
			FROM nyeblock_killLogs
			WHERE userId = %i
		]],userId),
		string.format([[
			SELECT count
			FROM nyeblock_deathLogs
			WHERE userId = %i
		]],userId),
		string.format([[
			SELECT runnerCount, deathCount
			FROM nyeblock_teamLogs
			WHERE userId = %i
		]],userId),
		string.format([[
			SELECT runnerCount, deathCount
			FROM nyeblock_winLogs
			WHERE userId = %i
		]],userId)
	}

	NYEBLOCK.DATABASES.NB_MULTI_QUERY("nyeblock",queries,function(data)
		local tbl = {
			{
				text = "Kills count",
				value = data[1][1].count
			},
			{
				text = "Deaths count",
				value = data[2][1].count
			},
			{
				text = "Rounds played as runner",
				value = data[3][1].runnerCount
			},
			{
				text = "Rounds played as death",
				value = data[3][1].deathCount
			},
			{
				text = "Rounds won as runner",
				value = data[4][1].runnerCount
			},
			{
				text = "Rounds won as death",
				value = data[4][1].deathCount
			},
			{
				text = "Total play time",
				value = math.Round(TimeKeeper.Users[ply:SteamID()].server_hours).." hours"
			}
		}

		net.Start("nyeblock_returnUserStats")
			net.WriteTable(tbl)
		net.Send(ply)
	end)
end)
net.Receive("nyeblock_updateProfile",function(_,ply)
	local data = net.ReadTable()

	if data.links == nil or table.Count(data.links) == 0 then
		local qs = [[
			UPDATE nyeblock_users
			SET motto = "%s", signature = "%s", links = NULL
			WHERE steamid64 = "%s"
		]]
		NYEBLOCK.DATABASES.NB_QUERY("nyeblock",string.format(qs,NYEBLOCK.DATABASES.NB:escape(data.motto),NYEBLOCK.DATABASES.NB:escape(data.signature),ply:SteamID64()))
	else
		local links = data.links

		for k,v in pairs(links) do
			links[k].linkType = NYEBLOCK.DATABASES.NB:escape(v.linkType)
			links[k].value = NYEBLOCK.DATABASES.NB:escape(v.value)
			links[k].value = NYEBLOCK.FUNCTIONS.encodeURL(links[k].value)
		end
		local qs = [[
			UPDATE nyeblock_users
			SET motto = "%s", signature = "%s", links = '%s'
			WHERE steamid64 = "%s"
		]]
		NYEBLOCK.DATABASES.NB_QUERY("nyeblock",string.format(qs,NYEBLOCK.DATABASES.NB:escape(data.motto),NYEBLOCK.DATABASES.NB:escape(data.signature),util.TableToJSON(links),ply:SteamID64()))
	end
end)
net.Receive("nyeblock_getUserSettings",function(_,ply)
	local qs = [[
		SELECT displayPoints, displayPlayTime
		FROM nyeblock_users
		WHERE id = %i
	]]
	NYEBLOCK.DATABASES.NB_QUERY("nyeblock",string.format(qs,ply:GetNWInt("nyeblock_userId")),function(data)
		if table.Count(data) > 0 then
			local tbl = {
				displayPoints = data[1].displayPoints,
				displayPlayTime = data[1].displayPlayTime
			}

			net.Start("nyeblock_returnUserSettings")
				net.WriteTable(tbl)
			net.Send(ply)
		end
	end)
end)
net.Receive("nyeblock_updateSettings",function(_,ply)
	local settings = net.ReadTable()

	local qs = [[
		UPDATE nyeblock_users
		SET displayPoints = %i, displayPlayTime = %i
		WHERE id = %i
	]]
	NYEBLOCK.DATABASES.NB_QUERY("nyeblock",string.format(qs,settings.displayPoints,settings.displayPlayTime,ply:GetNWInt("nyeblock_userId")))
end)