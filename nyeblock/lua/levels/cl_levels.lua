surface.CreateFont( "ValidateFont", {
	font = "Roboto Cn",
	weight = 500,
	size = 100
} )

surface.CreateFont( "BarFont", {
	font = "Roboto Cn",
	weight = 500,
	size = 14
} )
surface.CreateFont( "BarFont2", {
	font = "Roboto Cn",
	weight = 500,
	size =20
} )
surface.CreateFont( "BarFont3", {
	font = "Roboto Cn",
	weight = 500,
	size =12
} )
surface.CreateFont( "BarFont4", {
	font = "Roboto Cn",
	weight = 500,
	size =25
} )

surface.CreateFont( "BarFont5", {
	font = "Roboto Cn",
	weight = 500,
	size = 17
} )

net.Receive( "LevelUp", function()
	local ply = net.ReadEntity()
	chat.AddText( Color( 26, 188, 156 ), ply, " just leveled up! They are now level " .. ( ply:GetLevel() + 1 ) .. "." )
end )

hook.Add( "KeyPress", "RemoveOnPress", function( ply, key )
	if IsValid( claimLabel ) then
		if key == IN_USE then
			claimLabel:AlphaTo( 0, 0.5, 0, function() claimLabel:Remove() end )
			net.Start( "XPReply" )
			net.SendToServer()
		end
	end
end )

function levelmenu_getRankInfo(level)
	if level == 1 then
		return "Newbie","0 - 5","0","materials/levelmenu/newbie.png"
	elseif level == 2 then
		return "Getting There","6 - 10","1000","materials/levelmenu/gettingthere.png"
	elseif level == 3 then
		return "Average","11 - 15","2000","materials/levelmenu/average.png"
	elseif level == 4 then
		return "Experienced","16 - 25","3000","materials/levelmenu/experienced.png"
	elseif level == 5 then
		return "Veteran","26 - 35","6000","materials/levelmenu/veteran.png"
	elseif level == 6 then
		return "Golden","36 - 50","10000","materials/levelmenu/golden.png"
	elseif level == 7 then
		return "Jesus","51 - 60","15000","materials/levelmenu/jesus.png"
	elseif level == 8 then
		return "Legendary","61 - 85","17500","materials/levelmenu/legendary.png"
	elseif level == 9 then
		return "Insane","86 - 100","20000","materials/levelmenu/insane.png"
	end
end
function levelmenu_getCurrentRank()
	local plevel = LocalPlayer():GetLevel()

	if plevel >=0 and plevel <= 5 then
		return 1
	elseif plevel >=6 and plevel <= 10 then
		return 2
	elseif plevel >=11 and plevel <= 15 then
		return 3
	elseif plevel >=16 and plevel <= 25 then
		return 4
	elseif plevel >=26 and plevel <= 35 then
		return 5
	elseif plevel >=36 and plevel <= 50 then
		return 6
	elseif plevel >=51 and plevel <= 60 then
		return 7
	elseif plevel >=61 and plevel <= 85 then
		return 8
	elseif plevel >=86 and plevel <= 100 then
		return 9
	end
end

net.Receive("nyeblock_levelMenu",function()
	local panel = vgui.Create("DFrame")
	panel:SetSize(900,385)
	panel:Center()
	panel:SetTitle("")
	panel:SetDraggable(false)
	panel:ShowCloseButton(false)
	panel:MakePopup()
	local close = vgui.Create("DButton",panel)
	close:SetSize(100,30)
	close:SetPos(panel:GetWide()-close:GetWide(),0)
	close:SetText("")
	function close:Paint(w,h)
		draw.RoundedBox(0,0,0,w,h,Color(236,240,241))
		surface.SetDrawColor(149,165,166)
		surface.DrawOutlinedRect(0,0,w,h)
	end
	function close:DoClick()
		panel:Close()
	end
	local closet = vgui.Create("DLabel",close)
	closet:SetText("CLOSE")
	closet:SetFont("nameFont5")
	closet:SetColor(Color(52,73,94))
	closet:SizeToContents()
	closet:Center()
	local header = vgui.Create("DPanel",panel)
	header:SetSize(panel:GetWide(),65)
	header:SetPos(0,40)
	function header:Paint(w,h)
		draw.RoundedBox(0,0,0,w,h,Color(236,240,241))
		surface.SetDrawColor(149,165,166)
		surface.DrawOutlinedRect(0,0,w,h)
	end
	local logo = vgui.Create("DImage",header)
	logo:SetImage("materials/nb/logo.png")
	logo:SetSize(100,100)
	logo:SetPos(0,-17)
	local lbl = vgui.Create("DLabel",header)
	lbl:SetText("Level Stats")
	lbl:SetFont("menuFont")
	lbl:SetColor(Color(52,73,94))
	lbl:SizeToContents()
	lbl:SetPos(95,0)
	lbl:CenterVertical()
	local pagepanel = vgui.Create("DScrollPanel",panel)
	pagepanel:SetSize(panel:GetWide()-40,240)
	pagepanel:SetPos(20,125)
	function pagepanel:Paint(w,h)
		draw.RoundedBox(0,0,0,w,h,Color(236,240,241))
		surface.SetDrawColor(149,165,166)
		surface.DrawOutlinedRect(0,0,w,h)
	end
	local function center(i,y)
		i:SetPos(pagepanel:GetWide()/2-i:GetWide()/2,y)
	end
	local lbl = vgui.Create("DLabel",pagepanel)
	lbl:SetText("Current Level Stats")
	lbl:SetFont("nameFont")
	lbl:SetColor(Color(52,73,94))
	lbl:SizeToContents()
	center(lbl,10)
	local lastLevelSet = vgui.Create("DPanel",pagepanel)
	lastLevelSet:SetSize(105,175)
	lastLevelSet:SetPos(10,50)
	lastLevelSet:SetAlpha(150)
	function lastLevelSet:Paint(w,h)
		draw.RoundedBox(0,0,0,w,h,Color(189,195,199))
		draw.RoundedBox(0,0,h-25,w,25,Color(236,240,241))
		surface.SetDrawColor(149,165,166)
		surface.DrawOutlinedRect(0,0,w,h)
		surface.SetDrawColor(149,165,166)
		surface.DrawOutlinedRect(0,h-25,w,25)
	end
	local currentLevelSet = vgui.Create("DPanel",pagepanel)
	currentLevelSet:SetSize(125,200)
	currentLevelSet:SetPos(115,25)
	function currentLevelSet:Paint(w,h)
		draw.RoundedBox(0,0,0,w,h,Color(189,195,199))
		draw.RoundedBox(0,0,h-35,w,35,Color(236,240,241))
		surface.SetDrawColor(149,165,166)
		surface.DrawOutlinedRect(0,0,w,h)
		surface.SetDrawColor(149,165,166)
		surface.DrawOutlinedRect(0,h-35,w,35)
	end
	local nextLevelSet = vgui.Create("DPanel",pagepanel)
	nextLevelSet:SetSize(105,175)
	nextLevelSet:SetPos(240,50)
	nextLevelSet:SetAlpha(215)
	function nextLevelSet:Paint(w,h)
		draw.RoundedBox(0,0,0,w,h,Color(189,195,199))
		draw.RoundedBox(0,0,h-25,w,25,Color(236,240,241))
		surface.SetDrawColor(149,165,166)
		surface.DrawOutlinedRect(0,0,w,h)
		surface.SetDrawColor(149,165,166)
		surface.DrawOutlinedRect(0,h-25,w,25)
	end
	function panel:Paint(w,h)
		draw.RoundedBox(0,0,40,w,h-40,Color(189,195,199))
		surface.SetDrawColor(149,165,166)
		surface.DrawOutlinedRect(0,40,w,h-40)
	end
	local levelDisplay = vgui.Create("DPanel",pagepanel)
	levelDisplay:SetSize(490,175)
	levelDisplay:SetPos(355,50)
	local xp = 0
	function levelDisplay:Paint(w,h)
		local xpFrac = math.Remap( LocalPlayer():GetXP(), levels.XPFromLevel( LocalPlayer():GetLevel() ), levels.XPFromLevel( LocalPlayer():GetLevel() + 1 ), 0, 1 )
		local target = math.Clamp( xpFrac, 0, 1 )
		xp = Lerp( 2.5 * FrameTime(), xp, target )
		draw.RoundedBox(0,10,65,460,20,Color(38,61,75))
		draw.RoundedBox(0,12,67,462*xp,15,Color(39,174,96))
		local curXP = (  LocalPlayer():GetXP() - levels.XPFromLevel( LocalPlayer():GetLevel() ) )
		local nextXP = ( levels.XPFromLevel( LocalPlayer():GetLevel() + 1 ) - levels.XPFromLevel( LocalPlayer():GetLevel() ) )
		draw.SimpleText( math.abs( curXP ) .. "/" .. nextXP, "BarFont", 215, 90, Color(0,0,0))
		draw.SimpleText( LocalPlayer():GetLevel(), "BarFont4", 10, 85, Color(0,0,0))
		draw.SimpleText( LocalPlayer():GetLevel() + 1, "BarFont4", 445, 85, Color(0,0,0))
	end
	if LocalPlayer():GetLevel() >= 100 then
		local prestige = vgui.Create("DButton",levelDisplay)
		prestige:SetSize(100,25)
		prestige:SetText("")
		prestige:SetPos(levelDisplay:GetWide()/2-prestige:GetWide()/2,125)
		function prestige:Paint(w,h)
			draw.RoundedBox(0,0,0,w,h,Color(236,240,241))
			surface.SetDrawColor(149,165,166)
			surface.DrawOutlinedRect(0,0,w,h)
		end
		local lbl = vgui.Create("DLabel",prestige)
		lbl:SetText("Prestige")
		lbl:SetFont("nameFont5")
		lbl:SetColor(Color(52,73,94))
		lbl:SizeToContents()
		lbl:Center()
		function prestige:DoClick()
			local box = vgui.Create("DPanel",pagepanel)
			box:SetSize(400,160)
			box:Center()
			function box:Paint(w,h)
				draw.RoundedBox(0,0,0,w,h,Color(236,240,241))
				surface.SetDrawColor(149,165,166)
				surface.DrawOutlinedRect(0,0,w,h)
			end
			box:SetPos(0,pagepanel:GetVBar():GetScroll()+pagepanel:GetTall()/2-box:GetTall()/2)
			box:CenterHorizontal()
			local close = vgui.Create("DImageButton",box)
			close:SetSize(15,15)
			close:SetImage("icon16/cross.png")
			close:SetPos(box:GetWide()-close:GetWide()-10,10)
			function close:DoClick()
				box:Remove()
			end
			local lbl = vgui.Create("DLabel",box)
			lbl:SetText("Are you sure?")
			lbl:SetFont("buttonFont")
			lbl:SetColor(Color(52,73,94))
			lbl:SizeToContents()
			lbl:SetPos(0,10)
			lbl:CenterHorizontal()
			local lbl = vgui.Create("DLabel",box)
			lbl:SetText("Are you sure you want to prestige?")
			lbl:SetFont("buttonFont3")
			lbl:SetColor(Color(52,73,94))
			lbl:SizeToContents()
			lbl:SetPos(0,40)
			lbl:CenterHorizontal()
			local lbl = vgui.Create("DLabel",box)
			lbl:SetText("• This will reset your level to 0")
			lbl:SetFont("buttonFont3")
			lbl:SetColor(Color(52,73,94))
			lbl:SizeToContents()
			lbl:SetPos(0,60)
			lbl:CenterHorizontal()
			local lbl = vgui.Create("DLabel",box)
			lbl:SetText("• This will add to your prestige counter")
			lbl:SetFont("buttonFont3")
			lbl:SetColor(Color(52,73,94))
			lbl:SizeToContents()
			lbl:SetPos(0,75)
			lbl:CenterHorizontal()
			local lbl = vgui.Create("DLabel",box)
			lbl:SetText("• Each level set point reward is increased by 10,000 points")
			lbl:SetFont("buttonFont3")
			lbl:SetColor(Color(52,73,94))
			lbl:SizeToContents()
			lbl:SetPos(0,90)
			lbl:CenterHorizontal()
			local yes = vgui.Create("DButton",box)
			yes:SetSize(100,30)
			yes:SetPos(65,120)
			yes:SetText("")
			function yes:Paint(w,h)
				draw.RoundedBox(0,0,0,w,h,Color(236,240,241))
				surface.SetDrawColor(149,165,166)
				surface.DrawOutlinedRect(0,0,w,h)
			end
			function yes:DoClick()
				panel:Remove()
				net.Start("nyeblock_levelMenu_prestige")
				net.SendToServer()
			end
			local lbl = vgui.Create("DLabel",yes)
			lbl:SetText("Yes")
			lbl:SetFont("playerCount")
			lbl:SetColor(Color(52,73,94))
			lbl:SizeToContents()
			lbl:Center()
			local no = vgui.Create("DButton",box)
			no:SetSize(100,30)
			no:SetPos(235,120)
			no:SetText("")
			function no:Paint(w,h)
				draw.RoundedBox(0,0,0,w,h,Color(236,240,241))
				surface.SetDrawColor(149,165,166)
				surface.DrawOutlinedRect(0,0,w,h)
			end
			function no:DoClick()
				box:Remove()
			end
			local lbl = vgui.Create("DLabel",no)
			lbl:SetText("No")
			lbl:SetFont("playerCount")
			lbl:SetColor(Color(52,73,94))
			lbl:SizeToContents()
			lbl:Center()
		end
	end
	if LocalPlayer():GetPrestige() > 0 then
		local lbl = vgui.Create("DLabel",levelDisplay)
		lbl:SetText("You are prestige "..LocalPlayer():GetPrestige())
		lbl:SetFont("BarFont2")
		lbl:SetColor(Color(52,73,94))
		lbl:SizeToContents()
		lbl:SetPos(0,155)
		lbl:CenterHorizontal()
	end

	local currentLevel = levelmenu_getCurrentRank()
	local rewardAddition = LocalPlayer():GetPrestige() != 0 and LocalPlayer():GetPrestige() * 10000 or 0
	for i=1,3 do
		if i == 1 or i == 3 then
			local name, rank, reward, pic = levelmenu_getRankInfo(i == 1 and currentLevel - 1 or currentLevel + 1)

			local lbl = vgui.Create("DLabel",i == 1 and lastLevelSet or nextLevelSet)
			lbl:SetText(name != nil and name or "??????")
			lbl:SetFont("BarFont2")
			lbl:SetColor(Color(52,73,94))
			lbl:SizeToContents()
			lbl:SetPos(0,152)
			lbl:CenterHorizontal()
			local pc = vgui.Create("DImage",i == 1 and lastLevelSet or nextLevelSet)
			pc:SetImage(pic != nil and pic or "materials/levelmenu/unknown.png")
			pc:SetSize(95,95)
			pc:SetPos(0,55)
			pc:CenterHorizontal()
			local img = vgui.Create("DImage",i == 1 and lastLevelSet or nextLevelSet)
			img:SetImage(i == 1 and "icon16/user_delete.png" or "icon16/user_add.png")
			img:SetSize(15,15)
			img:SetPos(25,10)
			local lbl = vgui.Create("DLabel",i == 1 and lastLevelSet or nextLevelSet)
			lbl:SetText(rank != nil and rank or "?????")
			lbl:SetFont("BarFont")
			lbl:SetColor(Color(52,73,94))
			lbl:SizeToContents()
			lbl:SetPos(45,12)
			local img = vgui.Create("DImage",i == 1 and lastLevelSet or nextLevelSet)
			img:SetImage("icon16/coins_add.png")
			img:SetSize(15,15)
			img:SetPos(25,30)
			local lbl = vgui.Create("DLabel",i == 1 and lastLevelSet or nextLevelSet)
			lbl:SetText(reward != nil and reward + rewardAddition or "?????")
			lbl:SetFont("BarFont")
			lbl:SetColor(Color(52,73,94))
			lbl:SizeToContents()
			lbl:SetPos(45,32)
		else
			local name, rank, reward, pic = levelmenu_getRankInfo(currentLevel)

			local lbl = vgui.Create("DLabel",currentLevelSet)
			lbl:SetText(name)
			lbl:SetFont("BarFont4")
			lbl:SetColor(Color(52,73,94))
			lbl:SizeToContents()
			lbl:SetPos(0,169)
			lbl:CenterHorizontal()
			local pc = vgui.Create("DImage",currentLevelSet)
			pc:SetImage(pic)
			pc:SetSize(110,110)
			pc:SetPos(0,55)
			pc:CenterHorizontal()
			local img = vgui.Create("DImage",currentLevelSet)
			img:SetImage("icon16/user.png")
			img:SetSize(17,17)
			img:SetPos(30,10)
			local lbl = vgui.Create("DLabel",currentLevelSet)
			lbl:SetText(rank)
			lbl:SetFont("BarFont5")
			lbl:SetColor(Color(52,73,94))
			lbl:SizeToContents()
			lbl:SetPos(50,11)
			local img = vgui.Create("DImage",currentLevelSet)
			img:SetImage("icon16/coins_add.png")
			img:SetSize(17,17)
			img:SetPos(33,30)
			local lbl = vgui.Create("DLabel",currentLevelSet)
			lbl:SetText(reward + rewardAddition)
			lbl:SetFont("BarFont5")
			lbl:SetColor(Color(52,73,94))
			lbl:SizeToContents()
			lbl:SetPos(53,32)
		end
	end
	-- levelmenu = vgui.Create("DFrame")
	-- levelmenu:SetSize(720,325)
	-- levelmenu:Center()
	-- levelmenu:CenterHorizontal()
	-- levelmenu:SetTitle("Level Menu")
	-- levelmenu:MakePopup()
	-- local background = Material("materials/levelmenu/background.png")
	-- local levelpnl = vgui.Create("DHorizontalScroller",levelmenu)
	-- levelpnl:SetSize(levelmenu:GetWide()-20,200)
	-- levelpnl:SetOverlap(-5)
	-- levelpnl:SetPos(5,35)
	-- for i=1,9 do
	-- 	local name,rank,reward,pic = levelmenu_getRankInfo(i)
	-- 	if i == levelmenu_getCurrentRank(LocalPlayer():GetLevel()) then
	-- 		curlevel = true
	-- 	else
	-- 		curlevel = false
	-- 	end
	-- 	local p = vgui.Create("DPanel")
	-- 	p:SetWide(175)
	-- 	function p:Paint(w,h)
	-- 		draw.RoundedBox(0,0,0,w,h,Color(108,108,108,200))
	-- 		draw.RoundedBox(8,10,115,w-20,1,Color(108,108,108,200))
	-- 		surface.SetDrawColor(85,85,85,200)
	-- 		surface.DrawOutlinedRect(1,1,w-1,h-2)
	-- 	end
	-- 	local pc = vgui.Create("DImage",p)
	-- 	if i <= levelmenu_getCurrentRank(LocalPlayer():GetLevel()) then
	-- 		pc:SetImage(pic)
	-- 	else
	-- 		pc:SetImage("materials/levelmenu/unknown.png")
	-- 	end
	-- 	pc:SetSize(105,105)
	-- 	pc:SetPos(0,10)
	-- 	pc:CenterHorizontal()
	-- 	local lbl = vgui.Create("DLabel",p)
	-- 	lbl:SetText(name)
	-- 	lbl:SetFont("BarFont2")
	-- 	lbl:SetColor(Color(255,255,255))
	-- 	lbl:SizeToContents()
	-- 	lbl:SetPos(0,125)
	-- 	lbl:CenterHorizontal()
	-- 	local lbl = vgui.Create("DLabel",p)
	-- 	lbl:SetText(rank)
	-- 	lbl:SetFont("BarFont")
	-- 	lbl:SetColor(Color(255,255,255))
	-- 	lbl:SizeToContents()
	-- 	lbl:SetPos(p:GetWide()/4,148)
	-- 	local ic = vgui.Create("DImage",p)
	-- 	ic:SetImage("icon16/chart_bar.png")
	-- 	ic:SetSize(16,16)
	-- 	ic:SetPos(lbl:GetPos()-20,146)
	-- 	local lbl = vgui.Create("DLabel",p)
	-- 	if i <= levelmenu_getCurrentRank(LocalPlayer():GetLevel()) then
	-- 		lbl:SetText(reward)
	-- 	else
	-- 		lbl:SetText("??????")
	-- 	end
	-- 	lbl:SetFont("BarFont")
	-- 	lbl:SetColor(Color(255,255,255))
	-- 	lbl:SizeToContents()
	-- 	lbl:SetPos(p:GetWide()/1.5,148)
	-- 	local ic = vgui.Create("DImage",p)
	-- 	ic:SetImage("icon16/coins_add.png")
	-- 	ic:SetSize(16,16)
	-- 	ic:SetPos(lbl:GetPos()-20,146)
	-- 	if curlevel then
	-- 		local pp = vgui.Create("DPanel",p)
	-- 		pp:SetSize(p:GetWide()-20,25)
	-- 		pp:SetPos(10,170)
	-- 		function pp:Paint(w,h)
	-- 			draw.RoundedBox(0,0,0,w,h,Color(50,205,50,levelmenu_transArrow()))
	-- 			surface.SetDrawColor(85,85,85,200)
	-- 			surface.DrawOutlinedRect(1,1,w-1,h-2)
	-- 		end
	-- 		local lbl = vgui.Create("DLabel",pp)
	-- 		lbl:SetText("Current rank")
	-- 		lbl:SizeToContents()
	-- 		lbl:SetColor(Color(255,255,255))
	-- 		lbl:Center()
	-- 	end
	-- 	levelpnl:AddPanel(p)
	-- end
	-- local xp = 0
	-- function levelmenu:Paint(w,h)
	-- 	draw.RoundedBox(0,0,0,w,h,Color(236,240,241))
	-- 	surface.SetDrawColor(149,165,166)
	-- 	surface.DrawOutlinedRect(0,0,w,h)
	-- 	surface.DrawOutlinedRect(0,0,w,25)
	-- 	surface.SetDrawColor(200,200,200,200)
	-- 	surface.SetMaterial(background)
	-- 	surface.DrawTexturedRect(-10,0,w+20,h+20)
	-- 	draw.RoundedBox(0,0,0,w,25,Color(189,195,199))
	-- 	local xpFrac = math.Remap( LocalPlayer():GetXP(), levels.XPFromLevel( LocalPlayer():GetLevel() ), levels.XPFromLevel( LocalPlayer():GetLevel() + 1 ), 0, 1 )
	-- 	local target = math.Clamp( xpFrac, 0, 1 )
	-- 	xp = Lerp( 2.5 * FrameTime(), xp, target )
	-- 	draw.RoundedBox(0,62,278,598,20,Color(38,61,75))
	-- 	draw.RoundedBox(0,65,280,596*xp,15,Color(39,174,96))
	-- 	local curXP = (  LocalPlayer():GetXP() - levels.XPFromLevel( LocalPlayer():GetLevel() ) )
	-- 	local nextXP = ( levels.XPFromLevel( LocalPlayer():GetLevel() + 1 ) - levels.XPFromLevel( LocalPlayer():GetLevel() ) )
	-- 	draw.SimpleText( math.abs( curXP ) .. "/" .. nextXP, "BarFont", 620, 300, Color(0,0,0))
	-- 	draw.SimpleText( LocalPlayer():GetLevel(), "BarFont4", 62,255, Color(0,0,0))
	-- 	draw.SimpleText( LocalPlayer():GetLevel() + 1, "BarFont4", 650, 255, Color(0,0,0))
	-- end
end)