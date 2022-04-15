local season = nyeblock_getCurrentSeason()
local seasonData = nyeblock_getSeasonMenuInfo(season)

NYEBLOCK.DONATION_PACKAGES = {
	{
		name = "VIP Rank",
		price = (season != nil) and 1000-(1000*seasonData.packageSale) or 1000,
		type = "rank",
		points = 8000,
		ulxgroups = {
			Moderator = "vipmod",
			jukeboxer = "jukeboxervip",
			user = "vip"
		},
		restrictedGroups = {
			"vip",
			"vipmod",
			"jukeboxervip"
		},
		description = [[
			What you get in this package:
	
			- Rainbow [Vip] rank displayed in chat
			- Green name on the scoreboard
			- Ad free
			- Access to more commands
			- Win bonus increased to 225
			- Access to donator/vip pointshop items
			- 25% off all pointshop items
			- 8000 Pointshop Points
			- Our appreciation
		]]
	},
	{
		name = "Donator Rank",
		price = (season != nil) and 600-(600*seasonData.packageSale) or 600,
		type = "rank",
		points = 2000,
		ulxgroups = {
			Moderator = "donatormod",
			jukeboxer = "jukeboxerdonator",
			user = "donator"
		},
		restrictedGroups = {
			"vip",
			"vipmod",
			"jukeboxervip",
			"donator",
			"donatormod",
			"jukeboxerdonator"
		},
		description = [[
			What you get in this package:
	
			- Yellow [Donator] rank displayed in chat
			- Yellow name on the scoreboard
			- Ad free
			- Access to more commands
			- Win bonus increased to 125
			- Access to donator pointshop items (Doesn't include vip items)
			- 2000 Pointshop Points
			- Our appreciation
		]]
	},
	{
		name = "10,000 Points",
		price = (season != nil) and 500-(500*seasonData.packageSale) or 500,
		type = "points",
		points = 10000,
		description = [[
			What you get in this package:
	
			- 10,000 Pointshop Points
		]]
	},
	{
		name = "20,000 Points",
		price = (season != nil) and 900-(900*seasonData.packageSale) or 900,
		type = "points",
		points = 20000,
		description = [[
			What you get in this package:
	
			- 20,000 Pointshop Points
		]]
	},
	{
		name = "50,000 Points",
		price = (season != nil) and 1500-(1500*seasonData.packageSale) or 1500,
		type = "points",
		points = 50000,
		description = [[
			What you get in this package:
	
			- 50,000 Pointshop Points
		]]
	},
	-- {
	-- 	name = "10 Case Keys",
	-- 	price = (season != nil) and 400-(400*seasonData.packageSale) or 400,
	-- 	type = "keys",
	-- 	amount = 10,
	-- 	description = [[
	-- 		What you get in this package:
	
	-- 		- 10 Keys to open cases
	-- 	]]
	-- },
}