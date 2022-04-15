/*

	ETC

*/
//Ulx groups able to access admin functions
NYEBLOCK.ADMINGROUPS = {
	"superadmin"
}

//Staff ulx groups
NYEBLOCK.STAFFGROUPS = {
	"Moderator",
	"vipmod",
	"donatormod",
	"jukeboxer",
	"jukeboxervip",
	"jukeboxerdonator"
}

/*

	MOTD

*/

//Rules
NYEBLOCK.RULES = {
	{
		rule = "Don't harass/be disrespectful to other players",
		example = "Telling someone they are stupid.",
		discipline = "mute/gag/kick/ban"
	},
	{
		rule = "Don't chat/mic spam",
		example = "Playing music through your mic.",
		discipline = "gag/kick/ban"
	},
	{
		rule = "Don't cheat/hack",
		example = "Using a Lenny script.",
		discipline = "ban"
	},
	{
		rule = "Don't exploit",
		example = "Climbing ontop of the map",
		discipline = "slay/kick/ban"
	},
	{
		rule = "Don't advertise",
		example = "Saying in chat 'Join my server guys, it's better'",
		discipline = "mute/gag/kick/ban"
	},
	{
		rule = "Don't ask for points",
		example = "Saying in chat 'Im so close to getting super speed, can anyone give me 2k?'",
		discipline = "mute/gag/kick/ban"
	},
	{
		rule = "Don't post disgusting/pornographic sprays",
		example = "Spraying a picture of porn.",
		discipline = "ban"
	},
	{
		rule = "Stay out of the staffs business",
		example = "Saying 'Who did you just ban? Why?'",
		discipline = "mute/gag/kick/ban"
	},
	{
		rule = "Obey all staff members",
		example = "When an staff member tells you to be quiet and you say 'No, fuck you.'",
		discipline = "mute/gag/kick/ban"
	},
	{
		rule = "Don't ghost",
		example = "Saying where a player is.",
		discipline = "mute/gag/kick/ban"
	},
	{
		rule = "Don't kill your teammates",
		example = "Standing in the way so your teammate falls off the map.",
		discipline = "slay/kick/ban"
	},
	{
		rule = "Don't threat anyone",
		example = "Saying you are going to ddoss the server.",
		discipline = "kick/ban"
	},
	{
		rule = "Don't false report",
		example = "Reporting someone for no reason.",
		discipline = "kick"
	},
	{
		rule = "No racism/sexism",
		example = "Calling someone a ...",
		discipline = "mute/gag/kick/ban"
	},
	{
		rule = "No voice changers",
		example = "Making your voice sound really high pitched.",
		discipline = "gag/kick/ban"
	},
	{
		rule = "Only speak english",
		example = "Talking in French, Spanish, Russian etc.",
		discipline = "mute/gag/kick/ban"
	},
	{
		rule = "Do not trap spam",
		example = "Spamming traps regardless of a runner being present.",
		discipline = "kick/ban"
	},
	{
		rule = "Do not delay",
		example = "You are last alive and stay at spawn.",
		discipline = "slay/kick/ban"
	},
	{
		rule = "Do not target players",
		example = "Only pressing traps when a certain player passes it.",
		discipline = "slay/kick/ban"
	},
	{
		rule = "Do not advertise any application",
		example = "Saying people should vote on a certain application.",
		discipline = "kick/ban/application being denied"
	},
	{
		rule = "Do not boost other players",
		example = "Pressing a trap with an explosion to give a player a lot of speed.",
		discipline = "slay/kick/ban"
	},
	-- {
	-- 	rule = "Do not use any macros",
	-- 	example = "Binding a key to your keyboard/mouse.",
	-- 	discipline = "kick/ban"
	-- },
	{
		rule = "Do not use auto srafers",
		example = "Using a script to strafe for you.",
		discipline = "kick/ban"
	},
	-- {
	-- 	rule = "Do not use spinning to gain speed",
	-- 	example = "Spinning to give yourself a speed boost.",
	-- 	discipline = "slay/kick/ban"
	-- },
}

//Seasons and their menu info
NYEBLOCK.SEASONS = {
	["christmas"] = {
		title = "Christmas",
		menuImg = "http://www.pngall.com/wp-content/uploads/2016/05/Santa-Claus-Download-PNG.png",
		backgroundImg = "https://i.gifer.com/2ii9.gif",
		updateFeatures = {
			"Free 10k points",
			"Santa Playermodel now available",
			"25% off all donation packages"
		},
		pointsInfo = {
			givePoints = true,
			amount = 10000,
			message = "You have received 10k points for the Christmas update. Merry Christmas!"
		},
		packageSale = .25
	},
	["halloween"] = {
		title = "Halloween",
		menuImg = "https://gallery.yopriceville.com/var/resizes/Free-Clipart-Pictures/Halloween-PNG-Pictures/Halloween_Scary_Pumpkin_PNG_Clipart.png?m=1507172109",
		backgroundImg = "http://media.tnh.me/55254465067d7b644fbf3dbf/565c404ad51e036e5932b4c0",
		updateFeatures = {
			"Free 10k points",
			"Halloween Playermodel now available",
			"25% off all donation packages"
		},
		pointsInfo = {
			givePoints = true,
			amount = 10000,
			message = "You have received 10k points for the Halloween update. Happy halloween!"
		},
		packageSale = .25
	},
	["thanksgiving"] = {
		title = "Thanksgiving",
		menuImg = "https://i.pinimg.com/originals/7d/f8/a1/7df8a1e6869f924a0fb75b74722b262c.png",
		backgroundImg = "https://img1.picmix.com/output/stamp/normal/1/9/1/4/644191_960b6.gif",
		updateFeatures = {
			"Free 10k points",
			"Thanksgiving Playermodel now available",
			"25% off all donation packages"
		},
		pointsInfo = {
			givePoints = true,
			amount = 10000,
			message = "You have received 10k points for the Thanksgiving update. Happy thanksgiving!"
		},
		packageSale = .25
	}
}

//Commands
NYEBLOCK.COMMANDS = {
	{
		text = "Commands available to users, donators and vips",
		commands = {
			"!donate - Opens the donation menu where you can view/purchase all the packages",
			"!profile - Opens a menu that displays your nyeblock profile",
			"!tag - Opens a menu that allows you to purchase a custom tag and create tag clans",
			"!steam - Opens our steam group page. Join for points",
			"!jukebox - Opens a jukebox styled music player",
			"!chatcolor - Opens a menu that allows you to edit your chat text color",
			"!shop - Opens the pointshop",
			"!level - Opens a menu that displays your rank statistics",
			"!freerun - If death, starts a vote to disable traps for that round",
			"!menu or !ulx - Opens the ulx menu",
			"!lottery - Opens the pointshop lottery menu",
			"!redie - If dead, allows you to play as a ghost",
			"!togglevape - Enables/Disables vape smoke visibility",
			"!toggletrails - Enables/Disables trail visibility",
			"!exploitreport - Opens the exploit report menu",
			"!sr - Opens the server map records menu",
			"!usersearch - Opens a menu allowing you to view every players profile"
		}
	},
	{
		text = "Commands available to donators and vips",
		commands = {
			"!votekick - Starts a vote to kick a certain player (it is against the rules to abuse this)"
		}
	},
	{
		text = "Commands available to vips",
		commands = {
			"!voteban - Starts a vote to ban a certain player (it is against the rules to abuse this)"
		}
	}
}

/*

	TAG SYSTEM

*/

//Tag length prices
NYEBLOCK.TAG_LENGTH_PRICES = {
	["1 Week"] = 5000,
	["1 Month"] = 15000,
	["6 Months"] = 30000,
	["1 Year"] = 50000,
	["Permanent"] = 500000
}

//Price of a clan
NYEBLOCK.CLAN_PRICE = 30000

//Price to join a clan
NYEBLOCK.CLAN_JOIN_PRICE = 15000

//Blocked words
NYEBLOCK.BLOCKED_WORDS = {
	"fuck",
	"shit",
	"bitch",
	"cunt",
	"pussy",
	"vagina",
	"dick",
	"donator",
	"nb",
	"admin",
	"moderator",
	"administrator",
	"owner",
	"creator",
	"nyeblock",
	"co-owner",
	"fuck you",
	"fuckyou",
	"staff",
	"myserver",
	"my server",
	"nigger",
	"experienced",
	"average",
	"golden",
	"jesus",
	"veteran",
	"newbie",
	"insane",
	"legendary",
	"nb moderator",
	"nb owner",
	"sr"
}

//Blocked symbols
NYEBLOCK.BLOCKED_SYMBOLS = {
	"[",
	"]"
}

/*

	CHAT SYSTEM

*/

//Ulx rank tags
NYEBLOCK.ULX_RANK_TAGS = {
	["Moderator"]		= { "[nB Moderator] ", Color(143, 138, 138, 255) },
	["superadmin"]		= { "[nB Owner] ", Color(255, 100, 0, 255) },
	["donator"]			= { "[Donator] ", Color(233, 246, 9, 255) },
	["donatormod"]		= { "[nB Donator Moderator] ", Color(233, 246, 9, 255) },
	["pluginmanager"]	= { "[nB Developer] ", Color(47, 219, 222, 255) },
	["trailmod"]		= { "[Trail Mod] ", Color(144, 195, 212, 255) },
	["donatortrailmod"]		= { "[Trail Mod] ", Color(144, 195, 212, 255) },
	["viptrailmod"]		= { "[rainbow][Trail Mod] ", Color(144, 195, 212, 255) },
	["vip"]				= { "[rainbow][VIP] ", Color( 0, 255, 0, 255 ) },
	["vipmod"]			= { "[rainbow][nB VIP Moderator] ", Color( 0, 255, 0, 255 ) },
	["staffmanager"] 	= { "[nB Manager] ", Color( 245, 5, 5, 255 )},
	["staffmanagervip"]	= { "[nB Manager] ", Color( 245, 5, 5, 255)},
	["staffmanagerdonator"]	= { "[nB Manager] ", Color( 245, 5, 5, 255 )},
	["admin"]           = { "[nB Admin] ", Color( 255, 51, 0, 255 )},
	["jukeboxer"]           = { "[JukeBoxer] ", Color( 170, 244, 66, 255 )},
	["jukeboxervip"]           = { "[rainbow][nB VIP JukeBoxer] ", Color( 170, 244, 66, 255 )},
	["jukeboxerdonator"]           = { "[nB Donator JukeBoxer] ", Color( 170, 244, 66, 255 )},
	["executiveadmin"] = { "[nB ExecutiveAdmin] ", Color( 41, 128, 185, 255 )},
}

//Server record tags
NYEBLOCK.SR_TAGS = {
	["first"]			= { "[rainbow][SR #1] ", Color(255, 255, 255) },
	["second"]			= { "[SR #2] ", Color(255,215,0) },
	["third"]			= { "[SR #3] ", Color(240,230,140) },
	["fourth"]			= { "[SR #4] ", Color(255, 247, 183) },
	["fifth"]			= { "[SR #5] ", Color(255, 250, 214) }
}

/*

	POPUPS

*/

//Hint popup messages
NYEBLOCK.HINT_POPUPS = {
	"Type !profile to edit your nyeblock profile.",
	"Type !profile to edit your nyeblock profile.",
	"Type !steam in chat to join our steam group and get 1500 points.",
	"Type !donate in chat to view our donation page/packages.",
	"Type !rank in chat to create your own rank.",
	"Press F4 to toggle thirdperson mode.",
	"Type !rtd to roll the dice.",
	"Want to donate for points? Type !donate in chat.",
	"Type !redie in chat to play while dead.",
	"Type !level to view you level statistics.",
	"Type !togglevape to disable vape smoke.",
	"Type !toggletrails to disable trails.",
	"Type !clearvape to clear vape smoke.",
	"Type !chatcolor to edit your chat text color.",
	"Need points? Type !donate to view our point donation packages.",
	"Type !motd to view server information.",
	"Want to apply for a staff position? Press F2 to open the application system.",
	"Interested in applying for staff? Press F2 to open the application system.",
	"Type !exploitreport to report an exploit you've found.",
	"Type !sr to view the servers current season map records.",
	"Join the lottery for a chance to win points! Type !lottery in chat.",
	"To create a custom tag that is visible when you talk in chat. Type !tag in chat.",
	"Want to disable trails/vape smoke? Press F1 and navigate to the settings page."
}

/*

	RTD

*/

//Rtd timeout (seconds)
NYEBLOCK.RTDTIMEOUT = 60

//Taunt list
NYEBLOCK.TAUNTS = {
	"taunts/weed.wav",
	"taunts/mlg.wav",
	"taunts/goteem.wav",
	"taunts/ahh.wav",
	"taunts/ballsofsteel.wav",
	"taunts/bestcry.wav",
	"taunts/evil.wav",
	"taunts/gay.wav",
	"taunts/getthecamera.wav",
	"taunts/goteem.wav",
	"taunts/hallelujah.wav",
	"taunts/headshot.wav",
	"taunts/icansmellyou.wav",
	"taunts/illuminati.wav",
	"taunts/noscope.wav",
	"taunts/sparta.wav",
	"taunts/suprise.wav",
	"rtd/pussy.mp3",
	"rtd/weed.wav",
	"taunts/15yearold.mp3",
	"taunts/best.mp3",
	"taunts/inc.mp3",
	"taunts/leroy.mp3",
	"taunts/mlg2.mp3",
	"taunts/ohh.mp3",
	"taunts/parking.mp3",
	"taunts/pop.mp3",
	"taunts/run.mp3",
	"taunts/wtf.mp3",
	"taunts/omfgtrickshot.mp3",
	"taunts/damnsonwow.mp3"
}

//Random things list
NYEBLOCK.RANDOMTHINGS = {
	"ass",
	"ear",
	"toilet",
	"car",
	"butt crack",
	"forehead",
	"vagina",
	"dick",
	"belly button",
	"shed",
	"loose anal cavity"
}

/*

	LEVELS

*/

//Max level a player could achieve
NYEBLOCK.LEVEL_CAP = 100