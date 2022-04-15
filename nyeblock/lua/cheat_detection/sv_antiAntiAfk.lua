local players = {}

hook.Add("KeyPress","blah",function(ply,key)
	if players[ply:SteamID64()] != nil then
		local diff = CurTime()-players[ply:SteamID64()].lastKeyPress

		if diff < 0.4 then
			players[ply:SteamID64()].keySpamCount = players[ply:SteamID64()].keySpamCount + 1
		else
			players[ply:SteamID64()].normalKeyCount = players[ply:SteamID64()].normalKeyCount + 1
		end
		if players[ply:SteamID64()].normalKeyCount > 10 then
			players[ply:SteamID64()].normalKeyCount = 0
			players[ply:SteamID64()].keySpamCount = 0
			if ply:GetNWBool("IsAfk",false) then
				local logs = file.Read("keySpamLogs.txt")
				logs = logs.."\r\n"..os.time().." - "..ply:Nick().." :: Set to not afk"
				file.Write("keySpamLogs.txt",logs)
				ply:SetNWBool("IsAfk",false)
			end
		end
		if players[ply:SteamID64()].keySpamCount > 75 then
			players[ply:SteamID64()].normalKeyCount = 0
			players[ply:SteamID64()].keySpamCount = 0
			if !ply:GetNWBool("IsAfk",false) then
				local logs = file.Read("keySpamLogs.txt")
				logs = logs.."\r\n"..os.time().." - "..ply:Nick().." :: Set to afk"
				file.Write("keySpamLogs.txt",logs)
				ply:SetNWBool("IsAfk",true)
			end
		end
		players[ply:SteamID64()].lastKeyPress = CurTime()
	else
		players[ply:SteamID64()] = {
			lastKeyPress = CurTime(),
			keySpamCount = 0,
			normalKeyCount = 0
		}
	end
end)