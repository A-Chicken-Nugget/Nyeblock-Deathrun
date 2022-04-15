local PANEL = {}

function PANEL:SetLinks(links,steamid64,userId)
	local optionCount = 0
		
	if links != nil and table.Count(links) > 0 then
		for k,v in pairs(links) do
			local link = vgui.Create("DPanel",self)
			link:SetSize(125,35)
			link:SetPos(0,((k-1)*35))
			local icon = vgui.Create("DImage",link)
			if v.linkType == "website" then
				icon:SetImage("materials/nb/profile/website.png")
				icon:SetSize(25,24)
			elseif v.linkType == "youtube" then
				icon:SetImage("materials/nb/profile/youtube.png")
				icon:SetSize(25,18)
			elseif v.linkType == "twitch" then
				icon:SetImage("materials/nb/profile/twitch.png")
				icon:SetSize(25,25)
			end
			icon:SetPos(5,0)
			icon:CenterVertical()
			local value = v.value
			if string.len(value) > 15 then
				value = string.sub(value, 0, 15).."..."
			end
			local lbl = vgui.Create("DLabel",link)
			lbl:SetText(value)
			lbl:SetColor(Color(52,73,94))
			lbl:SizeToContents()
			lbl:SetPos(35,0)
			lbl:CenterVertical()
			link.linkHover = vgui.Create("DButton",link)
			link.linkHover:SetSize(link:GetWide(),link:GetTall())
			link.linkHover:SetText("")
			function link.linkHover:Paint() end
			function link:Paint(w,h)
				if self.linkHover:IsHovered() then
					draw.RoundedBox(0,0,0,w,h,Color(189,195,199))
					surface.SetDrawColor(149,165,166)
					surface.DrawOutlinedRect(0,0,w,h+1)
				else
					draw.RoundedBox(0,0,0,w,h,Color(236,240,241))
					surface.SetDrawColor(149,165,166)
					surface.DrawOutlinedRect(0,0,w,h+1)
				end
			end
			function link.linkHover:DoClick()
				link.linkHover.subOption = DermaMenu()

				if v.linkType == "website" then
					link.linkHover.subOption:AddOption("Go to", function()
						gui.OpenURL(v.value)
					end):SetIcon("icon16/world_go.png")
					link.linkHover.subOption:AddOption("Copy", function()
						SetClipboardText(v.value)
						NYEBLOCK.FUNCTIONS.createPopup("Website url copied to clipboard!",1)
					end):SetIcon("icon16/paste_plain.png")
				elseif v.linkType == "youtube" then
					link.linkHover.subOption:AddOption("Copy", function()
						SetClipboardText(v.value)
						NYEBLOCK.FUNCTIONS.createPopup("Youtube channel name copied to clipboard!",1)
					end):SetIcon("icon16/paste_plain.png")
				elseif v.linkType == "twitch" then
					link.linkHover.subOption:AddOption("Copy", function()
						SetClipboardText(v.value)
						NYEBLOCK.FUNCTIONS.createPopup("Twitch channel name copied to clipboard!",1)
					end):SetIcon("icon16/paste_plain.png")
				end
				link.linkHover.subOption:Open()
			end
			optionCount = optionCount + 1
		end
	end
	//Steam profile
	local link = vgui.Create("DPanel",self)
	link:SetSize(125,35)
	link:SetPos(0,optionCount*35)
	local icon = vgui.Create("DImage",link)
	icon:SetImage("materials/nb/profile/steam.png")
	icon:SetSize(25,25)
	icon:SetPos(5,0)
	icon:CenterVertical()
	local lbl = vgui.Create("DLabel",link)
	lbl:SetText("Steam Profile")
	lbl:SetColor(Color(52,73,94))
	lbl:SizeToContents()
	lbl:SetPos(35,0)
	lbl:CenterVertical()
	link.linkHover = vgui.Create("DButton",link)
	link.linkHover:SetSize(link:GetWide(),link:GetTall())
	link.linkHover:SetText("")
	function link.linkHover:Paint() end
	function link:Paint(w,h)
		if self.linkHover:IsHovered() then
			draw.RoundedBox(0,0,0,w,h,Color(189,195,199))
			surface.SetDrawColor(149,165,166)
			surface.DrawOutlinedRect(0,0,w,h+1)
		else
			draw.RoundedBox(0,0,0,w,h,Color(236,240,241))
			surface.SetDrawColor(149,165,166)
			surface.DrawOutlinedRect(0,0,w,h+1)
		end
	end
	function link.linkHover:DoClick()
		link.linkHover.subOption = DermaMenu()

		link.linkHover.subOption:AddOption("Go to", function()
			gui.OpenURL("http://steamcommunity.com/profiles/"..steamid64)
		end):SetIcon("icon16/world_go.png")
		link.linkHover.subOption:AddOption("Copy", function()
			SetClipboardText("http://steamcommunity.com/profiles/"..steamid64)
			NYEBLOCK.FUNCTIONS.createPopup("Steam profile url copied to clipboard!",1)
		end):SetIcon("icon16/paste_plain.png")
		link.linkHover.subOption:Open()
	end
	optionCount = optionCount + 1
	//NyeBlock Profile
	local link = vgui.Create("DPanel",self)
	link:SetSize(125,35)
	link:SetPos(0,optionCount*35)
	local icon = vgui.Create("DImage",link)
	icon:SetImage("materials/nb/chat/logo.png")
	icon:SetSize(25,25)
	icon:SetPos(5,0)
	icon:CenterVertical()
	local lbl = vgui.Create("DLabel",link)
	lbl:SetText("NyeBlock Profile")
	lbl:SetColor(Color(52,73,94))
	lbl:SizeToContents()
	lbl:SetPos(35,0)
	lbl:CenterVertical()
	link.linkHover = vgui.Create("DButton",link)
	link.linkHover:SetSize(link:GetWide(),link:GetTall())
	link.linkHover:SetText("")
	function link.linkHover:Paint() end
	function link:Paint(w,h)
		if self.linkHover:IsHovered() then
			draw.RoundedBox(0,0,0,w,h,Color(189,195,199))
			surface.SetDrawColor(149,165,166)
			surface.DrawOutlinedRect(0,0,w,h+1)
		else
			draw.RoundedBox(0,0,0,w,h,Color(236,240,241))
			surface.SetDrawColor(149,165,166)
			surface.DrawOutlinedRect(0,0,w,h+1)
		end
	end
	function link.linkHover:DoClick()
		link.linkHover.subOption = DermaMenu()

		link.linkHover.subOption:AddOption("Open Profile", function()
			net.Start("nyeblock_getProfileData")
				net.WriteString(userId != nil and userId or "nil")
			net.SendToServer()
		end):SetIcon("icon16/user_go.png")
		link.linkHover.subOption:Open()
	end
	self:SizeToChildren(false,true)
	self:SetTall(self:GetTall()+1)
end
vgui.Register("AvatarPopup",PANEL,"Panel")