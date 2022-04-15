surface.CreateFont("oswald_20",{font="Oswald",extended=false,size=20,weight=500})
surface.CreateFont("oswald_25",{font="Oswald",extended=false,size=25,weight=500})
surface.CreateFont("oswald_28",{font="Oswald",extended=false,size=28,weight=500})
surface.CreateFont("oswald_30",{font="Oswald",extended=false,size=30,weight=500})
surface.CreateFont("oswald_35",{font="Oswald",extended=false,size=35,weight=500})
surface.CreateFont("roboto_30",{font="Roboto Black",extended=false,size=30,weight=500})
surface.CreateFont("roboto_25",{font="Roboto Black",extended=false,size=25,weight=500})
surface.CreateFont("roboto_20",{font="Roboto Black",extended=false,size=20,weight=500})
surface.CreateFont("roboto_15",{font="Roboto Black",extended=false,size=15,weight=500})
surface.CreateFont("regular_20",{font="",extended=false,size=20,weight=500})

local panel
local pagepanel
local function center(i,y)
	i:SetPos(pagepanel:GetWide()/2-i:GetWide()/2,y)
end

net.Receive("nyeblock_viewProfile",function()
	if IsValid(panel) then panel:Close() end
	local userId = net.ReadString()

	panel = vgui.Create("DFrame")
	panel:SetSize(700,400)
	panel:Center()
	panel:SetTitle("")
	panel:SetDraggable(false)
	panel:ShowCloseButton(false)
	panel:MakePopup()
	function panel:Paint(w,h)
		draw.RoundedBox(0,0,0,w,h,Color(189,195,199))
		surface.SetDrawColor(149,165,166)
		surface.DrawOutlinedRect(0,40,w,h-40)
	end
	local header = vgui.Create("DPanel",panel)
	header:SetSize(panel:GetWide(),65)
	header:SetPos(0,0)
	function header:Paint(w,h)
		draw.RoundedBox(0,0,0,w,h,Color(236,240,241))
		surface.SetDrawColor(149,165,166)
		surface.DrawOutlinedRect(0,0,w,h)
	end
	local close = vgui.Create("DButton",header)
	close:SetSize(100,30)
	close:SetText("CLOSE")
	close:SetColor(Color(52,73,94))
	close:SetFont("oswald_20")
	close:SetPos(header:GetWide()-close:GetWide()-10,18)
	function close:Paint(w,h)
		draw.RoundedBox(0,0,0,w,h,Color(236,240,241))
		surface.SetDrawColor(149,165,166)
		surface.DrawOutlinedRect(0,0,w,h)
	end
	function close:DoClick()
		panel:Close()
	end
	local logo = vgui.Create("DImage",header)
	logo:SetImage("materials/nb/logo.png")
	logo:SetSize(100,100)
	logo:SetPos(0,-17)
	local lbl = vgui.Create("DLabel",header)
	lbl:SetText("Player Profile")
	lbl:SetFont("oswald_30")
	lbl:SetColor(Color(52,73,94))
	lbl:SizeToContents()
	lbl:SetPos(95,0)
	lbl:CenterVertical()
	pagepanel = vgui.Create("DScrollPanel",panel)
	pagepanel:SetSize(panel:GetWide()-40,panel:GetTall()-105)
	pagepanel:SetPos(20,85)
	function pagepanel:Paint(w,h)
		draw.RoundedBox(0,0,0,w,h,Color(236,240,241))
		surface.SetDrawColor(149,165,166)
		surface.DrawOutlinedRect(0,0,w,h)
	end
	local lbl = vgui.Create("DLabel",pagepanel)
	lbl:SetText("Loading...")
	lbl:SetColor(Color(52,73,94))
	lbl:SetFont("oswald_25")
	lbl:SizeToContents()
	center(lbl,pagepanel:GetTall()/2-lbl:GetTall()/2)
	net.Receive("nyeblock_returnProfileData",function()
		local exists = net.ReadBool()

		if IsValid(pagepanel) then
			pagepanel:Clear()
			if exists then
				local userData = net.ReadTable()
				local isOnline = false

				for k,v in pairs(player.GetAll()) do
					if v:SteamID64() == userData.profileData.steamid64 then
						isOnline = true
					end
				end
				local profileOutline = vgui.Create("DPanel",pagepanel)
				profileOutline:SetSize(125,125)
				profileOutline:SetPos(10,10)
				function profileOutline:Paint(w,h)
					draw.RoundedBox(0,0,0,w,h,Color(149,165,166))
				end
				local avatar = vgui.Create("AvatarImage",profileOutline)
				avatar:SetSize(121,121)
				avatar:SetPos(2,2)
				avatar:SetSteamID(userData.profileData.steamid64,184)
				local profileClick = vgui.Create("DButton",profileOutline)
				profileClick:SetSize(121,121)
				profileClick:SetPos(2,2)
				profileClick:SetText("")
				function profileClick:DoClick()
					gui.OpenURL("http://steamcommunity.com/profiles/"..userData.profileData.steamid64)
				end
				function profileClick:Paint() end
				local nameText = userData.profileData.name
				if nameText != nil and string.len(nameText) > 44 then
					nameText = string.sub(nameText,44).."..."
				end
				local name = vgui.Create("DLabel",pagepanel)
				name:SetText(nameText != nil and nameText or "N/A")
				name:SetFont("oswald_35")
				name:SetColor(Color(52,73,94))
				name:SizeToContents()
				name:SetPos(150,5)
				local lbl = vgui.Create("DLabel",pagepanel)
				lbl:SetText("Level "..userData.levelData.level..(tonumber(userData.levelData.prestige) == 0 and "" or " Prestige "..userData.levelData.prestige))
				lbl:SetFont("oswald_20")
				lbl:SetColor(Color(52,73,94,200))
				lbl:SizeToContents()
				lbl:SetPos(name.x+name:GetWide()+5,16)
				if userData.levelData.level >= 100 and userData.levelData.prestige >= 10 then
					function lbl:Think()
						lbl:SetColor(Color(255*math.abs(math.sin(CurTime())),255*math.abs(math.sin(CurTime()+1.8)),255*math.abs(math.sin(CurTime()+2.6))))
					end
				end
				local lbl = vgui.Create("DLabel",pagepanel)
				lbl:SetText(NYEBLOCK.FUNCTIONS.getUlxGroupName(userData.profileData.ulxGroup))
				lbl:SetFont("oswald_25")
				lbl:SizeToContents()
				lbl:SetPos(150,35)
				if NYEBLOCK.FUNCTIONS.isUlxGroupVIP(userData.profileData.ulxGroup) then
					function lbl:Think()
						lbl:SetColor(Color(255*math.abs(math.sin(CurTime())),255*math.abs(math.sin(CurTime()+1.8)),255*math.abs(math.sin(CurTime()+2.6))))
					end
				else
					lbl:SetColor(NYEBLOCK.FUNCTIONS.getUlxGroupColor(userData.profileData.ulxGroup))
				end
				local lbl = vgui.Create("DLabel",pagepanel)
				if isOnline then
					lbl:SetText("Currently Online")
					lbl:SetColor(Color(0,255,0))
				else
					lbl:SetText("Last online "..os.date("%m/%d/%Y",userData.joinData.lastJoin))
					lbl:SetColor(Color(52,73,94))
				end
				lbl:SetFont("oswald_25")
				lbl:SizeToContents()
				lbl:SetPos(150,55)
				local mottoPanel = vgui.Create("DPanel",pagepanel)
				mottoPanel:SetSize(pagepanel:GetWide()-275,50)
				mottoPanel:SetPos(275,50)
				function mottoPanel:Paint() end
				local lbl = vgui.Create("DLabel",mottoPanel)
				lbl:SetSize(mottoPanel:GetWide(),30)
				lbl:SetText(userData.profileData.motto)
				lbl:SetColor(Color(52,73,94))
				lbl:SetFont("oswald_25")
				lbl:SetContentAlignment(5)
				local isDisplayed = false
				if tobool(userData.displayPoints) then
					local lbl = vgui.Create("DLabel",pagepanel)
					if userData.points == nil then
						lbl:SetText("N/A points")
					else
						lbl:SetText(tobool(userData.profileData.displayPoints) and string.Comma(userData.points).." points" or "N/A points")
					end
					lbl:SetColor(Color(52,73,94))
					lbl:SetFont("oswald_25")
					lbl:SizeToContents()
					lbl:SetPos(10,135)
					isDisplayed = true
				end
				if tobool(userData.displayPlayTime) then
					local lbl = vgui.Create("DLabel",pagepanel)
					lbl:SetText(userData.hoursPlayed.." hours played")
					lbl:SetColor(Color(52,73,94))
					lbl:SetFont("oswald_25")
					lbl:SizeToContents()
					lbl:SetPos(10,isDisplayed and 155 or 135)
				end
				local lbl = vgui.Create("DLabel",pagepanel)
				lbl:SetText("First joined on "..os.date("%m/%d/%Y",userData.joinData.firstJoin))
				lbl:SetColor(Color(52,73,94))
				lbl:SetFont("oswald_25")
				lbl:SizeToContents()
				lbl:SetPos(10,pagepanel:GetTall()-lbl:GetTall()-5)
			else
				local lbl = vgui.Create("DLabel",pagepanel)
				lbl:SetText("User does not exists in the database.")
				lbl:SetColor(Color(52,73,94))
				lbl:SetFont("oswald_25")
				lbl:SizeToContents()
				center(lbl,pagepanel:GetTall()/2-lbl:GetTall()/2)
			end
		end
	end)
end)