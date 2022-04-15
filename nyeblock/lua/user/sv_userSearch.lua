util.AddNetworkString("nyeblock_userSearch")
util.AddNetworkString("nyeblock_findSearchedUsers")
util.AddNetworkString("nyeblock_returnSearchedUsers")

net.Receive("nyeblock_findSearchedUsers",function(_,ply)
	local textToSearch = NYEBLOCK.DATABASES.NB:escape(net.ReadString())
	local isUsingName = false
	local isUsingSteamID = false
	local isUsingSteam64ID = false

	if textToSearch != nil then
		if tostring(util.SteamIDTo64(textToSearch)) != "0" then
			isUsingSteamID = true
		elseif tostring(util.SteamIDFrom64(textToSearch)) != "STEAM_0:0:0" then
			isUsingSteam64ID = true
		else
			isUsingName = true
		end

		if isUsingName then
			local qs = [[
				SELECT id, steamid64, name, links
				FROM nyeblock_users
				WHERE name LIKE '%s'
				LIMIT 15
			]]
			NYEBLOCK.DATABASES.NB_QUERY("nyeblock",string.format(qs,"%"..textToSearch.."%"),function(data)
				for k,v in pairs(data) do
					if data[k].links != nil then
						data[k].links = util.JSONToTable(v.links)
						for k2,v2 in pairs(v.links) do
							data[k].links[k2].value = NYEBLOCK.FUNCTIONS.decodeURL(data[k].links[k2].value)
						end
					end
				end
				if table.Count(data) > 0 then
					net.Start("nyeblock_returnSearchedUsers")
						net.WriteTable(data)
					net.Send(ply)
				else
					net.Start("nyeblock_returnSearchedUsers")
						net.WriteTable({})
					net.Send(ply)
				end
			end)
		elseif isUsingSteam64ID then
			local qs = [[
				SELECT id, steamid64, name, links
				FROM nyeblock_users
				WHERE steamid64 LIKE '%s'
				LIMIT 15
			]]
			NYEBLOCK.DATABASES.NB_QUERY("nyeblock",string.format(qs,textToSearch),function(data)
				for k,v in pairs(data) do
					if data[k].links != nil then
						data[k].links = util.JSONToTable(v.links)
						for k2,v2 in pairs(v.links) do
							data[k].links[k2].value = NYEBLOCK.FUNCTIONS.decodeURL(data[k].links[k2].value)
						end
					end
				end
				if table.Count(data) > 0 then
					net.Start("nyeblock_returnSearchedUsers")
						net.WriteTable(data)
					net.Send(ply)
				else
					net.Start("nyeblock_returnSearchedUsers")
						net.WriteTable({})
					net.Send(ply)
				end
			end)
		else
			local qs = [[
				SELECT id, steamid64, name, links
				FROM nyeblock_users
				WHERE steamid64 LIKE '%s'
				LIMIT 15
			]]
			NYEBLOCK.DATABASES.NB_QUERY("nyeblock",string.format(qs,util.SteamIDTo64(textToSearch)),function(data)
				for k,v in pairs(data) do
					if data[k].links != nil then
						data[k].links = util.JSONToTable(v.links)
						for k2,v2 in pairs(v.links) do
							data[k].links[k2].value = NYEBLOCK.FUNCTIONS.decodeURL(data[k].links[k2].value)
						end
					end
				end
				if table.Count(data) > 0 then
					net.Start("nyeblock_returnSearchedUsers")
						net.WriteTable(data)
					net.Send(ply)
				else
					net.Start("nyeblock_returnSearchedUsers")
						net.WriteTable({})
					net.Send(ply)
				end
			end)
		end
	end
end)