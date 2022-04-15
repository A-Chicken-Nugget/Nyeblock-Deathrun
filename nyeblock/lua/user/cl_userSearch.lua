surface.CreateFont("oswald_20",{font="Oswald",extended=false,size=20,weight=500})
surface.CreateFont("oswald_24",{font="Oswald",extended=false,size=24,weight=500})
surface.CreateFont("oswald_28",{font="Oswald",extended=false,size=28,weight=500})
surface.CreateFont("oswald_30",{font="Oswald",extended=false,size=30,weight=5000})
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
net.Receive("nyeblock_userSearch",function()
	if IsValid(panel) then panel:Close() end
	local usersData = net.ReadTable()

	panel = vgui.Create("DFrame")
	panel:SetSize(900,600)
	panel:Center()
	panel:SetTitle("")
	panel:SetDraggable(false)
	panel:ShowCloseButton(false)
	panel:MakePopup()
	function panel:Paint(w,h)
		draw.RoundedBox(0,0,40,w,h-40,Color(189,195,199))
		surface.SetDrawColor(149,165,166)
		surface.DrawOutlinedRect(0,40,w,h-40)
	end
	local close = vgui.Create("DButton",panel)
	close:SetSize(100,30)
	close:SetText("CLOSE")
	close:SetColor(Color(52,73,94))
	close:SetFont("oswald_20")
	close:SetPos(panel:GetWide()-close:GetWide(),0)
	function close:Paint(w,h)
		draw.RoundedBox(0,0,0,w,h,Color(236,240,241))
		surface.SetDrawColor(149,165,166)
		surface.DrawOutlinedRect(0,0,w,h)
	end
	function close:DoClick()
		panel:Close()
	end
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
	lbl:SetText("User Search")
	lbl:SetFont("oswald_30")
	lbl:SetColor(Color(52,73,94))
	lbl:SizeToContents()
	lbl:SetPos(95,0)
	lbl:CenterVertical()
    pagepanel = vgui.Create("DScrollPanel",panel)
	pagepanel:SetSize(panel:GetWide()-40,455)
	pagepanel:SetPos(20,125)
	function pagepanel:Paint(w,h)
		draw.RoundedBox(0,0,0,w,h,Color(236,240,241))
		surface.SetDrawColor(149,165,166)
		surface.DrawOutlinedRect(0,0,w,h)
	end
	local lbl = vgui.Create("DLabel",pagepanel)
	lbl:SetText("User Search")
	lbl:SetFont("oswald_28")
	lbl:SetColor(Color(52,73,94))
	lbl:SizeToContents()
	center(lbl,15)
	local lbl = vgui.Create("DLabel",pagepanel)
	lbl:SetText("Enter either the users name, steam id or steam 64 id")
	lbl:SetFont("roboto_15")
	lbl:SetColor(Color(52,73,94))
	lbl:SizeToContents()
	center(lbl,50)
	local searchField = vgui.Create("DTextEntry",pagepanel)
	searchField:SetSize(150,25)
	center(searchField,75)
	local searchButton = vgui.Create("DButton",pagepanel)
	searchButton:SetSize(75,30)
	searchButton:SetText("Search")
	searchButton:SetFont("roboto_15")
	searchButton:SetColor(Color(52,73,94))
	center(searchButton,110)
	function searchButton:Paint(w,h)
		draw.RoundedBox(0,0,0,w,h,Color(236,240,241))
		surface.SetDrawColor(149,165,166)
		surface.DrawOutlinedRect(0,0,w,h)
	end
	local titleText = vgui.Create("DLabel",pagepanel)
	titleText:SetText("Players Currently Online")
	titleText:SetFont("oswald_28")
	titleText:SetColor(Color(52,73,94))
	titleText:SizeToContents()
	center(titleText,150)
	local playerLayout = vgui.Create("DIconLayout",pagepanel)
	playerLayout:SetWide(pagepanel:GetWide()-450)
	playerLayout:SetSpaceY(10)
	center(playerLayout,185)
	for k,v in pairs(usersData) do
		local pnl = playerLayout:Add("DPanel")
		pnl:SetSize(playerLayout:GetWide(),40)
		function pnl:Paint(w,h)
			draw.RoundedBox(0,0,0,w,h,Color(236,240,241))
			draw.RoundedBox(0,0,0,10,h,Color(149,165,166))
			surface.SetDrawColor(149,165,166)
			surface.DrawOutlinedRect(0,0,w,h)
		end
		local avatar = vgui.Create("AvatarImage",pnl)
		avatar:SetSize(30,30)
		avatar:SetPos(15,0)
		avatar:CenterVertical()
		avatar:SetSteamID(v.steamid64,184)
		function avatar:Think()
            if avatar:IsHovered() then
                if avatar.hoverPanel == nil then
                	local x,y = panel:CursorPos()

                    avatar.hoverPanel = vgui.Create("AvatarPopup",panel)
                    avatar.hoverPanel:SetWide(125)
                    avatar.hoverPanel:SetPos(x-10,y-(avatar.hoverPanel:GetTall()-25))
					avatar.hoverPanel:SetLinks(v.links,v.steamid64,v.id)
                    function avatar.hoverPanel:Paint(w,h)
                        draw.RoundedBox(0,0,0,w,h,Color(236,240,241))
                        surface.SetDrawColor(149,165,166)
                        surface.DrawOutlinedRect(0,0,w,h)
                    end
                end
            else
                if avatar.hoverPanel != nil then
                    local isHovered = false

                    if avatar.hoverPanel:IsHovered() then
                        isHovered = true
                    end
                    for k,v in pairs(avatar.hoverPanel:GetChildren()) do
                        if v.linkHover:IsHovered() or IsValid(v.linkHover.subOption) then
                            isHovered = true
                        end
                    end
                    if !isHovered then
                        avatar.hoverPanel:Remove()
                        avatar.hoverPanel = nil
                    end
                end
            end
        end
		local name = vgui.Create("DLabel",pnl)
		name:SetSize(pnl:GetWide()-150,30)
		name:SetPos(55,0)
		name:CenterVertical()
		name:SetColor(Color(52,73,94))
		name:SetFont("roboto_20")
		name:SetText(v.name)
		local viewProfile = vgui.Create("DButton",pnl)
		viewProfile:SetSize(85,30)
		viewProfile:SetText("View Profile")
		viewProfile:SetFont("roboto_15")
		viewProfile:SetColor(Color(52,73,94))
		viewProfile:SetPos(name.x+name:GetWide()+5,0)
		viewProfile:CenterVertical()
		function viewProfile:Paint(w,h)
			draw.RoundedBox(0,0,0,w,h,Color(236,240,241))
			surface.SetDrawColor(149,165,166)
			surface.DrawOutlinedRect(0,0,w,h)
		end
		function viewProfile:DoClick()
			net.Start("nyeblock_getProfileData")
				net.WriteString(v.id)
			net.SendToServer()
		end
	end
	function searchButton:DoClick()
		if string.len(searchField:GetValue()) > 40 then
			NYEBLOCK.FUNCTIONS.createPopup("The search field can only have a max of 40 characters!",2)
		else
			titleText:SetText("Search Results")
			titleText:SizeToContents()
			center(titleText,150)
			playerLayout:Clear()
			local lbl = playerLayout:Add("DLabel")
			lbl:SetSize(playerLayout:GetWide(),20)
			lbl:SetText("Loading...")
			lbl:SetFont("roboto_15")
			lbl:SetColor(Color(52,73,94))
			lbl:SetContentAlignment(5)
			net.Start("nyeblock_findSearchedUsers")
				net.WriteString(searchField:GetValue())
			net.SendToServer()
			net.Receive("nyeblock_returnSearchedUsers",function()
				playerLayout:Clear()
				local results = net.ReadTable()

				if table.Count(results) > 0 then
					for k,v in pairs(results) do
						local pnl = playerLayout:Add("DPanel")
						pnl:SetSize(playerLayout:GetWide(),40)
						function pnl:Paint(w,h)
							draw.RoundedBox(0,0,0,w,h,Color(236,240,241))
							draw.RoundedBox(0,0,0,10,h,Color(149,165,166))
							surface.SetDrawColor(149,165,166)
							surface.DrawOutlinedRect(0,0,w,h)
						end
						local avatar = vgui.Create("AvatarImage",pnl)
						avatar:SetSize(30,30)
						avatar:SetPos(15,0)
						avatar:CenterVertical()
						avatar:SetSteamID(v.steamid64,184)
						function avatar:Think()
							if avatar:IsHovered() then
								if avatar.hoverPanel == nil then
									local x,y = panel:CursorPos()

									avatar.hoverPanel = vgui.Create("AvatarPopup",panel)
									avatar.hoverPanel:SetWide(125)
									avatar.hoverPanel:SetPos(x-10,y-(avatar.hoverPanel:GetTall()-25))
									avatar.hoverPanel:SetLinks(v.links,v.steamid64,v.id)
									function avatar.hoverPanel:Paint(w,h)
										draw.RoundedBox(0,0,0,w,h,Color(236,240,241))
										surface.SetDrawColor(149,165,166)
										surface.DrawOutlinedRect(0,0,w,h)
									end
								end
							else
								if avatar.hoverPanel != nil then
									local isHovered = false

									if avatar.hoverPanel:IsHovered() then
										isHovered = true
									end
									for k,v in pairs(avatar.hoverPanel:GetChildren()) do
										if v.linkHover:IsHovered() or IsValid(v.linkHover.subOption) then
											isHovered = true
										end
									end
									if !isHovered then
										avatar.hoverPanel:Remove()
										avatar.hoverPanel = nil
									end
								end
							end
						end
						local name = vgui.Create("DLabel",pnl)
						name:SetSize(pnl:GetWide()-150,30)
						name:SetPos(55,0)
						name:CenterVertical()
						name:SetColor(Color(52,73,94))
						name:SetFont("roboto_20")
						name:SetText(v.name != nil and v.name or "N/A")
						local viewProfile = vgui.Create("DButton",pnl)
						viewProfile:SetSize(85,30)
						viewProfile:SetText("View Profile")
						viewProfile:SetFont("roboto_15")
						viewProfile:SetColor(Color(52,73,94))
						viewProfile:SetPos(name.x+name:GetWide()+5,0)
						viewProfile:CenterVertical()
						function viewProfile:Paint(w,h)
							draw.RoundedBox(0,0,0,w,h,Color(236,240,241))
							surface.SetDrawColor(149,165,166)
							surface.DrawOutlinedRect(0,0,w,h)
						end
						function viewProfile:DoClick()
							net.Start("nyeblock_getProfileData")
								net.WriteString(v.id)
							net.SendToServer()
						end
					end
				else
					local lbl = playerLayout:Add("DLabel")
					lbl:SetSize(playerLayout:GetWide(),20)
					lbl:SetText("No players found")
					lbl:SetFont("roboto_15")
					lbl:SetColor(Color(52,73,94))
					lbl:SetContentAlignment(5)
				end
			end)
		end
	end
end)