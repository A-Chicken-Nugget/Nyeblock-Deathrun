util.AddNetworkString("nyeblock_rtdPrintAll")
util.AddNetworkString("nyeblock_rtdRandomTaunt")
util.AddNetworkString("nyeblock_rtdBlind")

local rtds = {}

local function printToAll(text)
	net.Start("nyeblock_rtdPrintAll")
		net.WriteString(text)
	net.Broadcast()
end

rtds[1] = function(ply)  -- NOTHING
	printToAll(ply:Nick().." got nothing.")
end
rtds[2] = function(ply)  -- HP+
	local rand = math.random(1,50)
	ply:SetHealth(ply:Health()+rand);
	printToAll(ply:Nick().." got their health increased by "..rand..".")
end
rtds[3] = function(ply)  -- HP-
	local rand = math.random(1,50)
	ply:SetHealth(ply:Health()-rand);
	if (ply:Health()<=0) then 
		ply:Kill()
		printToAll(ply:Nick().." has been killed!")
	else
		printToAll(ply:Nick().." got their health decreased by "..rand..".")
	end
end
rtds[4] = function(ply)  -- HEALTH SET
	local rand = math.random(1,32)
	ply:SetHealth(rand)
	printToAll(ply:Nick().." got their health set to "..rand..".")
end
rtds[5] = function(ply)  -- IGNITE
	local rand = math.random(1,30)
	ply:Ignite(rand);
	printToAll(ply:Nick().." has been ignited for "..rand.." seconds.")
	RunConsoleCommand("ulx","logecho","0")
	RunConsoleCommand( "ulx", "playsound", "taunts/mlg.wav" )
	RunConsoleCommand("ulx","logecho","2")
end
rtds[6] = function(ply)  -- SPEED
	ply:SetWalkSpeed(400)
	printToAll(ply:Nick().." got increased speed.")
end
rtds[7] = function(ply)  -- RESPAWN
	if deathrun_GetRoundType() == 2 then
		local tempHrtd = ply:Health()
		local tempArtd = ply:Armor()
		local tempGrav = ply:GetGravity()
		ply:Spawn()
		ply:SetHealth(tempHrtd)
		ply:SetArmor(tempArtd)
		ply:SetGravity(tempGrav)
		ply:Give("weapon_crowbar")
		printToAll(ply:Nick().." has been respawned.")
	else
		ply:ChatPrint("Unable to use respawn RTD! The round is not active.")
	end
end
rtds[8] = function(ply) -- HIGH GRAVITY
	local tempGravity = ply:GetGravity()
	ply:SetGravity(1.4);
	timer.Simple(30,function() if IsValid(ply) then ply:SetGravity(tempGravity) end end)
	printToAll(ply:Nick().." got high gravity for 30 seconds.")
end
rtds[9] = function(ply) -- 1 HP
	ply:SetHealth(1)
	printToAll(ply:Nick().." got their health set to 1.")
end
rtds[10] = function(ply) -- TAKE WEAPONS
	ply:StripWeapons();
	printToAll(ply:Nick().." has had all weapons taken.")
end
rtds[11] = function(ply)  -- GIVE POINTS
	local rand = math.random(1,3000)
	ply:PS_GivePoints(rand);
	printToAll(ply:Nick().." has received "..rand.." points.")
end
rtds[12] = function(ply) -- DEDUCT POINTS
	local rand = math.random(1,500)
	ply:PS_TakePoints(rand);
	printToAll(ply:Nick().." has lost "..rand.." points.")
end
rtds[13] = function(ply)  -- GIVE POINTS
	local rand = math.random(10,1500)
	ply:PS_GivePoints(rand);
	printToAll(ply:Nick().." has found "..rand.." points in his "..table.Random(NYEBLOCK.RANDOMTHINGS)..".")
end
rtds[14] = function(ply) -- MAKE DEATH
	GAMEMODE.ForceDeath = GAMEMODE.ForceDeath or {}
	GAMEMODE.ForceDeath[#GAMEMODE.ForceDeath+1] = ply:SteamID()
	printToAll(ply:Nick().." is going to be death next round!")
end
rtds[15] = function(ply)  -- GodMode
	local rand = math.random(10,30)
	ply:GodEnable()
	timer.Simple(rand,function()
		if IsValid(ply) then 
			ply:GodDisable()
			printToAll(ply:Nick().."'s godmode has expired.")
		end 
	end)
	printToAll(ply:Nick().." got godmode for "..rand.." seconds.")
end
rtds[16] = function(ply)  -- 2 x health
	ply:SetHealth(ply:Health()*2)
	printToAll(ply:Nick().." has doubled their health.")
end
rtds[17] = function(ply)  -- illuminati
	printToAll(ply:Nick().." has rolled illuminati.")
	RunConsoleCommand("ulx","logecho","0")
	RunConsoleCommand( "ulx", "playsound", "taunts/illuminati.wav" )
	RunConsoleCommand("ulx","logecho","2")
end
rtds[18] = function(ply)  -- taunts
	printToAll(ply:Nick().." has played a random taunt.")
	net.Start("nyeblock_rtdRandomTaunt")
		net.WriteString(table.Random(NYEBLOCK.TAUNTS))
	net.Broadcast()
end
rtds[19] = function(ply)  -- taunts x2
	printToAll(ply:Nick().." has played a random taunt.")
	net.Start("nyeblock_rtdRandomTaunt")
		net.WriteString(table.Random(NYEBLOCK.TAUNTS))
	net.Broadcast()
end
rtds[20] = function(ply) --freeze 
	if deathrun_GetRoundType() == 2 then
		local tempGravity = ply:GetGravity()
		local tempJump = ply:GetJumpPower()
		local rand = math.random(3,10)
		printToAll(ply:Nick().." has gotten frozen for "..rand.." seconds.")
		ply:Freeze(true)
		ply:SetColor(0, 0, 255, 255)
		ply:EmitSound("physics/glass/glass_sheet_break1.wav")
		timer.Simple(rand, function()
			ply:Freeze(false)
			printToAll(ply:Nick().." has gotten unfrozen")
			ply:SetColor(255, 255, 255, 255)
			ply:SetGravity(tempGravity)
			ply:SetJumpPower(tempJump)
		end)
	else
		ply:ChatPrint("Unable to use freeze RTD! The round is not active.")
	end
end
rtds[21] = function(ply)  -- BOI GOT THE SHITS (IDEK)
	local i = 0

	local function createEffect()
		if i < 20 then
			local bodyPos = ply:GetBonePosition(ply:LookupBone("ValveBiped.Bip01_R_Thigh"))
			local effectdata = EffectData()
			effectdata:SetOrigin(bodyPos)
			effectdata:SetStart(bodyPos)
			effectdata:SetScale(1)
			util.Effect(table.Random({"StriderBlood","AntlionGib"}),effectdata,true,true)
			timer.Simple(.5,function()
				createEffect()
			end)
		end
		i = i + 1
	end
	createEffect()
	printToAll(ply:Nick().." has got to use the bathroom bad!")
end
rtds[22] = function(ply)  -- FIRE
	local rand = math.random(3,15)
	ply:Ignite(rand)
	printToAll(ply:Nick().." got set on fire for "..rand.." seconds!")
end
rtds[23] = function(ply)  -- INVISIBLE
	local rand = math.random(5,20)	

	ply:SetNoDraw(true)	
	timer.Simple(rand,function()
		ply:SetNoDraw(false)
		ply:SetColor(255, 255, 255, 255)
		printToAll(ply:Nick().." is now visible.")
	end)
	printToAll(ply:Nick().." is invisible for "..rand.." seconds!")
end
rtds[24] = function(ply)  -- BLINDED
	local rand = math.random(5,15)	

	net.Start("nyeblock_rtdBlind")
		net.WriteString(rand)
	net.Send(ply)
	printToAll(ply:Nick().." got blinded for "..rand.." seconds!")
end

hook.Add("PlayerSay","rtdCommand",function(ply,text)
	if string.lower(text) == "!rtd" then
		if ply:Alive() and !ply:IsSpec() then
			if os.time() - ply:GetNWInt("nyeblock_rtdTimeout",0) >= NYEBLOCK.RTDTIMEOUT then
				rtds[math.random(1,#rtds)](ply)
				ply:SetNWInt("nyeblock_rtdTimeout",os.time())
			else
				ply:ChatPrint("You must wait "..(NYEBLOCK.RTDTIMEOUT-(os.time()-ply:GetNWInt("nyeblock_rtdTimeout",0))).." seconds before you can RTD again!")
			end
		else
			ply:ChatPrint("You must be alive to rtd!")
		end
		return ""
	end
end)