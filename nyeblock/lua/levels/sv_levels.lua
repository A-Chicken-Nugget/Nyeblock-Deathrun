util.AddNetworkString( "XPReply" )
util.AddNetworkString( "LevelUp" )
util.AddNetworkString("nyeblock_levelMenu")
util.AddNetworkString("nyeblock_levelMenu_prestige")

net.Receive( "XPReply", function( len, ply )
	ply:BypassGive( ply.ToGive )
	ply.ToGive = 0
end )

local plyMeta = FindMetaTable( "Player" )

resource.AddFile("materials/levelmenu/newbie.png")
resource.AddFile("materials/levelmenu/gettingthere.png")
resource.AddFile("materials/levelmenu/average.png")
resource.AddFile("materials/levelmenu/golden.png")
resource.AddFile("materials/levelmenu/experienced.png")
resource.AddFile("materials/levelmenu/legendary.png")
resource.AddFile("materials/levelmenu/jesus.png")
resource.AddFile("materials/levelmenu/veteran.png")
resource.AddFile("materials/levelmenu/insane.png")
resource.AddFile("materials/levelmenu/unknown.png")

function plyMeta:GiveXP( xp ) -- This is the way that XP should be given. If you call this somewhere else without using GiveXP the player will have issues with leveling up.
	local level = self:GetLevel()
	if level != NYEBLOCK.LEVEL_CAP then
		self:SetNWInt( "xp", self:GetNWInt( "xp" ) + xp )
		self:SetPData( "xp", self:GetNWInt( "xp" ) + xp )
		if self:GetLevel() != level then
			hook.Call( "OnPlayerLevelUp", GAMEMODE, self, self:GetLevel() ) -- Args: Player, Level
			net.Start( "LevelUp" )
			net.WriteEntity( self )
			net.Broadcast()
			local rewardAddition = self:GetPrestige() != 0 and self:GetPrestige() * 10000 or 0
			
			if self:GetLevel() == 6 then
				self:PS_GivePoints(1000 + rewardAddition)
				self:ChatPrint("You have received "..(1000 + rewardAddition).." Points for ranking up!")
			end
			if self:GetLevel() == 11 then
				self:PS_GivePoints(2000 + rewardAddition)
				self:ChatPrint("You have received "..(2000 + rewardAddition).." Points for ranking up!")
			end
			if self:GetLevel() == 16 then
				self:PS_GivePoints(3000 + rewardAddition)
				self:ChatPrint("You have received "..(3000 + rewardAddition).." Points for ranking up!")
			end
			if self:GetLevel() == 26 then
				self:PS_GivePoints(6000 + rewardAddition)
				self:ChatPrint("You have received "..(6000 + rewardAddition).." Points for ranking up!")
			end
			if self:GetLevel() == 36 then
				self:PS_GivePoints(10000 + rewardAddition)
				self:ChatPrint("You have received "..(10000 + rewardAddition).." Points for ranking up!")
			end
			if self:GetLevel() == 51 then
				self:PS_GivePoints(15000 + rewardAddition)
				self:ChatPrint("You have received "..(15000 + rewardAddition).." Points for ranking up!")
			end
			if self:GetLevel() == 61 then
				self:PS_GivePoints(17500 + rewardAddition)
				self:ChatPrint("You have received "..(17500 + rewardAddition).." Points for ranking up!")
			end
			if self:GetLevel() == 86 then
				self:PS_GivePoints(20000 + rewardAddition)
				self:ChatPrint("You have received "..(20000 + rewardAddition).." Points for ranking up!")
			end
		end
	end
	hook.Call( "PostPlayerGiveXP", GAMEMODE, self, xp ) -- Args: Player, xp
end

hook.Add( "PlayerAuthed", "LevelSetup", function( ply )
	local xp = ply:GetPData( "xp", -1 )
	 
	if xp == -1 then
		ply:SetPData( "xp", 0 )
		ply:SetNWInt( "xp", 0 )
	else
		ply:SetNWInt( "xp", xp )
	end

	local prestige = ply:GetPData( "prestige", -1 )

	if prestige == -1 then
		ply:SetPData( "prestige", 0 )
		ply:SetNWInt( "prestige", 0 )
	else
		ply:SetNWInt( "prestige", prestige )
	end
end )

hook.Add( "OnRoundSet", "LevelGiveXP", function( round, winner )
	if round == ROUND_ENDING then
		for k,v in pairs( team.GetPlayers( winner ) ) do
			if v:Alive() then
				v:GiveXP( 75 )
			end
		end
	end
end )

net.Receive("nyeblock_levelMenu_prestige",function(_,ply)
	if ply:GetLevel() >= 100 then
		if ply:GetPrestige() < 10 then
			local nextPrestige = ply:GetPrestige() + 1
			ply:SetPData( "xp", 0 )
			ply:SetNWInt( "xp", 0 )
			ply:SetNWInt( "prestige", nextPrestige )
			ply:SetPData( "prestige", nextPrestige )
		end
	end
end)