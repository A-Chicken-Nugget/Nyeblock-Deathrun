// Calculation stuff
levels = {}

function levels.LevelFromXP( xp )
	local level = math.floor( 0.1 * math.sqrt( xp ) )
	return level
end

function levels.XPFromLevel( level )
	local xp = ( 10 * level )^2
    return xp
end
	
local plyMeta = FindMetaTable( "Player" )

function plyMeta:GetLevel()
	return levels.LevelFromXP( self:GetNWInt( "xp" ) )
end

function plyMeta:GetPrestige()
	return tonumber(self:GetNWInt( "prestige" ))
end

function plyMeta:GetXP()
	return self:GetNWInt( "xp" )
end

function plyMeta:GetTag()
	if self:GetLevel() >= 0 and self:GetLevel() <= 5 then
		--return "-   Newbie"
	end
	if self:GetLevel() >= 6 and self:GetLevel() <= 10 then
		--return "-   Getting there"
	end
	if self:GetLevel() >= 11 and self:GetLevel() <= 15 then
		--return "-   Average"
	end
	if self:GetLevel() >= 16 and self:GetLevel() <= 25 then
		--return "-   Experienced"
	end
	if self:GetLevel() >= 26 and self:GetLevel() <= 35 then
		--return "-   Veteran"
		self:PS_GivePoints(6000)
	end
	if self:GetLevel() >= 36 and self:GetLevel() <= 50 then
		--return "-   Golden"
	end
	if self:GetLevel() >= 51 and self:GetLevel() <= 100 then
		--return "-   Jesus"
	end
	return ""
end

