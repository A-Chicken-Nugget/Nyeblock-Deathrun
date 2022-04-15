//
// Log player kills
//
hook.Add("PlayerDeath","logKills",function(victim,_,attacker)
	if attacker:IsPlayer() and !attacker:IsBot() and victim != attacker then
		local qs = [[
			UPDATE nyeblock_killLogs
			SET count = (count + 1)
			WHERE userId = %i
		]]
		NYEBLOCK.DATABASES.NB_QUERY("nyeblock",string.format(qs,attacker:GetNWInt("nyeblock_userId")))
	end
end)
//
// Log player deaths
//
hook.Add("PostPlayerDeath","logDeaths",function(ply)
	if ply:IsPlayer() and !ply:IsBot() then
		local qs = [[
			UPDATE nyeblock_deathLogs
			SET count = (count + 1)
			WHERE userId = %i
		]]
		NYEBLOCK.DATABASES.NB_QUERY("nyeblock",string.format(qs,ply:GetNWInt("nyeblock_userId")))
	end
end)
//
// Log player teams/wins
//
hook.Add("OnRoundSet","logTeams",function(round,winner)
	if round == ROUND_PREPARING then
		local runnerIdsString = ""
		local deathIdsString = ""

		for k,v in pairs(player.GetAll()) do
			if v:Team() == 2 then
				if deathIdsString == "" then
					deathIdsString = "userId = "..v:GetNWInt("nyeblock_userId")
				else
					deathIdsString = deathIdsString.." AND userId = "..v:GetNWInt("nyeblock_userId")
				end
			elseif v:Team() == 3 then
				if runnerIdsString == "" then
					runnerIdsString = "userId = "..v:GetNWInt("nyeblock_userId")
				else
					runnerIdsString = runnerIdsString.." AND userId = "..v:GetNWInt("nyeblock_userId")
				end
			end
		end
		//Update all runners
		local qs = [[
			UPDATE nyeblock_teamLogs
			SET runnerCount = (runnerCount + 1)
			WHERE %s
		]]
		NYEBLOCK.DATABASES.NB_QUERY("nyeblock",string.format(qs,runnerIdsString))
		//Update all deaths
		local qs = [[
			UPDATE nyeblock_teamLogs
			SET deathCount = (deathCount + 1)
			WHERE %s
		]]
		NYEBLOCK.DATABASES.NB_QUERY("nyeblock",string.format(qs,deathIdsString))
	elseif round == ROUND_ENDING then
		local winnerIdsString = ""

		for k,v in pairs(player.GetAll()) do
			if v:Alive() and v:Team() == winner then
				if winnerIdsString == "" then
					winnerIdsString = "userId = "..v:GetNWInt("nyeblock_userId")
				else
					winnerIdsString = winnerIdsString.." AND userId = "..v:GetNWInt("nyeblock_userId")
				end
			end
		end
		if winnerIdsString != "" then
			if winner == 2 then
				local qs = [[
					UPDATE nyeblock_winLogs
					SET deathCount = (deathCount + 1)
					WHERE %s
				]]
				NYEBLOCK.DATABASES.NB_QUERY("nyeblock",string.format(qs,winnerIdsString))
			elseif winner == 3 then
				local qs = [[
					UPDATE nyeblock_winLogs
					SET runnerCount = (runnerCount + 1)
					WHERE %s
				]]
				NYEBLOCK.DATABASES.NB_QUERY("nyeblock",string.format(qs,winnerIdsString))
			end
		end
	end
end)
//
// Log ulx commands
//
hook.Add("ULibCommandCalled","ulxlogCommands",function(ply,command,args)
	if IsValid(ply) then
		local qs = [[
			INSERT INTO nyeblock_ulxCommandLogs (userId,command,args,created)
			VALUES (%i,'%s','%s',%i)
		]]
		NYEBLOCK.DATABASES.NB_QUERY("nyeblock",string.format(qs,ply:GetNWInt("nyeblock_userId"),command,NYEBLOCK.DATABASES.NB:escape(util.TableToJSON(args)),os.time()))
	end
end)