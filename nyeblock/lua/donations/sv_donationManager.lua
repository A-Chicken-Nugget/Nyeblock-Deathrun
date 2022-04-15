util.AddNetworkString("nyeblock_donationPanel")
util.AddNetworkString("nyeblock_purchaseDonationPackage")
util.AddNetworkString("nyeblock_donationNotification")
util.AddNetworkString("nyeblock_autoRefreshPoints")
util.AddNetworkString("nyeblock_checkForDonation")

//NET MESSAGES
net.Receive("nyeblock_purchaseDonationPackage",function(_,ply)
	local tbl = net.ReadTable()
	local pkg = nil

	for k,v in pairs(NYEBLOCK.DONATION_PACKAGES) do
		if v.name == tbl.name then
			pkg = v
		end
	end
	if pkg != nil then
		local qs = [[
			SELECT credits
			FROM playerDonationProfiles
			WHERE steamid64 = '%s'
		]]
		NYEBLOCK.DATABASES.NB_QUERY("nyeblock",string.format(qs,ply:SteamID64()),function(data)
			if tonumber(data[1].credits) >= pkg.price then
				if tbl.type == "rank" then
					for k,v in pairs(tbl.ulxgroups) do
						if ply:GetUserGroup() == tostring(k) then
							RunConsoleCommand("ulx","logecho","0")
							RunConsoleCommand("ulx", "adduserid", ply:SteamID(), v)
							RunConsoleCommand("ulx","logecho","2")
							ply:PS_GivePoints(tbl.points)
						end
					end
				elseif tbl.type == "points" then
					ply:PS_GivePoints(tbl.points)
				else
					for i=1,tbl.amount do
						ply:ub_addItem("Points Key")
					end
				end
				local qs = [[
					UPDATE `playerDonationProfiles`
					SET credits = (credits - %i)
					WHERE steamid64 = '%s'
				]]
				NYEBLOCK.DATABASES.NB_QUERY("nyeblock",string.format(qs,tbl.price,ply:SteamID64()))
				for k,v in pairs(player.GetAll()) do
					net.Start("nyeblock_donationNotification")
						net.WriteTable({
							name = ply:Nick(),
							package = tbl.name
						})
					net.Send(v)
					if ply:Alive() then
						local headPos = ply:GetBonePosition(ply:LookupBone("ValveBiped.Bip01_Head1"))
						local effectdata = EffectData()
						effectdata:SetOrigin(headPos)
						effectdata:SetStart(headPos)
						effectdata:SetScale(1)
						util.Effect("balloon_pop",effectdata,true,true)
					end
				end
			end
		end)
	end
end)
net.Receive("nyeblock_checkForDonation",function(_,ply)
	local qs = [[
		SELECT *
		FROM `donationLogs`
		WHERE received = 'false' AND steamid64 = '%s'
	]]
	NYEBLOCK.DATABASES.NB_QUERY("nyeblock",string.format(qs,ply:SteamID64()),function(data)
		if #data > 0 then
			local amount = 0
			for k,v in pairs(data) do
				amount = amount + v.amount
			end
			net.Start("nyeblock_autoRefreshPoints")
				net.WriteString(amount)
			net.Send(ply)
			local qs = [[
				UPDATE `donationLogs`
				SET received = 'true'
				WHERE received = 'false' AND steamid64 = '%s'
			]]
			NYEBLOCK.DATABASES.NB_QUERY("nyeblock",string.format(qs,ply:SteamID64()),function()
				local qs = [[
					SELECT *
					FROM `playerDonationProfiles`
					WHERE steamid64 = '%s'
				]]
				NYEBLOCK.DATABASES.NB_QUERY("nyeblock",string.format(qs,ply:SteamID64()),function(data)
					if #data > 0 then
						local qs = [[
							UPDATE `playerDonationProfiles`
							SET credits = (credits + %s)
							WHERE steamid64 = '%s'
						]]
						NYEBLOCK.DATABASES.NB_QUERY("nyeblock",string.format(qs,amount,ply:SteamID64()))
					else
						local qs = [[
							INSERT INTO `playerDonationProfiles` (`steamid64`,`credits`)
							VALUES ('%s','%s')
						]]
						NYEBLOCK.DATABASES.NB_QUERY("nyeblock",string.format(qs,ply:SteamID64(),amount))
					end
				end)
			end)
		end
	end)
end)