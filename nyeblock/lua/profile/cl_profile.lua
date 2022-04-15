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
local unsavedChanges
local function center(i,y)
	i:SetPos(pagepanel:GetWide()/2-i:GetWide()/2,y)
end

local function editProfile()
    local mottoValue = NYEBLOCK.PROFILE.motto
	local signatureValue = NYEBLOCK.PROFILE.signature
    local links = NYEBLOCK.PROFILE.links
	local signatureEnabled = false

	pagepanel:AlphaTo(255,.5,0)
	local function refreshProfilePage()
		local motto
		local signature
		local ypos = 50

		pagepanel:Clear()
		local lbl = vgui.Create("DLabel",pagepanel)
		lbl:SetText("Profile Preview")
		lbl:SetFont("oswald_28")
		lbl:SetColor(Color(52,73,94))
		lbl:SizeToContents()
		center(lbl,15)
		local showSignature = vgui.Create("DCheckBoxLabel",pagepanel)
		showSignature:SetPos(lbl.x+125,23)
		showSignature:SetText("Show signature")
		showSignature:SetChecked(signatureEnabled)
		showSignature:SetTextColor(Color(52,73,94))
		function showSignature:OnChange(checked)
			signatureEnabled = checked
			refreshProfilePage()
		end
		local profile = vgui.Create("DPanel",pagepanel)
		profile:SetSize(325,95)
		center(profile,ypos)
		function profile:Paint(w,h)
			draw.RoundedBox(0,0,0,w,h,Color(236,240,241))
			draw.RoundedBox(0,0,0,15,h,Color(149,165,166))
			surface.SetDrawColor(149,165,166)
			surface.DrawOutlinedRect(0,0,w,h)
			surface.DrawOutlinedRect(24,9,77,77)
		end
		local avatar = vgui.Create("AvatarImage",profile)
		avatar:SetSize(75,75)
		avatar:SetPos(25,10)
		avatar:SetPlayer(LocalPlayer(),184)
        function avatar:Think()
            if avatar:IsHovered() then
                if avatar.hoverPanel == nil then
                	local x,y = pagepanel:CursorPos()

                    avatar.hoverPanel = vgui.Create("AvatarPopup",pagepanel)
                    avatar.hoverPanel:SetWide(125)
                    avatar.hoverPanel:SetPos(x-10,y-(avatar.hoverPanel:GetTall()-25))
					avatar.hoverPanel:SetLinks(links,LocalPlayer():SteamID64(),LocalPlayer():GetNWInt("nyeblock_userId"))
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
		local nick = vgui.Create("DLabel",profile)
		nick:SetSize(205,25)
		nick:SetText(LocalPlayer():Nick())
		nick:SetFont("oswald_28")
		nick:SetColor(Color(52,73,94))
		if NYEBLOCK.PROFILE.motto != "" then
			nick:SetPos(110,10)
		else
			nick:SetPos(110,20)
		end
		local group = vgui.Create("DLabel",profile)
		group:SetText(NYEBLOCK.FUNCTIONS.getUlxGroupName(NYEBLOCK.PROFILE.ulxGroup))
		group:SetFont("oswald_24")
		if NYEBLOCK.FUNCTIONS.isUlxGroupVIP(NYEBLOCK.PROFILE.ulxGroup) then
			function group:Think()
				group:SetColor(Color(255*math.abs(math.sin(CurTime())),255*math.abs(math.sin(CurTime()+1.8)),255*math.abs(math.sin(CurTime()+2.6))))
			end
		else
			group:SetColor(NYEBLOCK.FUNCTIONS.getUlxGroupColor(NYEBLOCK.PROFILE.ulxGroup))
		end
		group:SizeToContents()
		group:SetPos(110,nick.y+25)
		if mottoValue != "" then
			motto = vgui.Create("DLabel",profile)
			motto:SetSize(205,25)
			motto:SetText(mottoValue)
			motto:SetFont("oswald_20")
			motto:SetColor(Color(52,73,94))
			motto:SetPos(110,60)
		end
		ypos = ypos + 100
		if signatureEnabled then
			ypos = ypos - 5
			local signaturePanel = vgui.Create("DPanel",pagepanel)
			signaturePanel:SetSize(profile:GetWide(),50)
			center(signaturePanel,ypos)
			function signaturePanel:Paint(w,h)
				draw.RoundedBox(0,0,0,w,h,Color(236,240,241))
				surface.SetDrawColor(149,165,166)
				surface.DrawOutlinedRect(0,-1,w,h+1)
			end
			signature = vgui.Create("DLabel",signaturePanel)
			signature:SetWide(signaturePanel:GetWide()-20)
			signature:SetPos(10,5)
			signature:SetColor(Color(52,73,94,255))
			signature:SetFont("roboto_15")
			signature:SetAutoStretchVertical(true)
			signature:SetText(WrapText(signatureValue,signature:GetWide(),"roboto_15"))
			signature:SizeToContentsY()
			if signature:GetTall() > 75 then
				signaturePanel:SetTall(95)
			else
				signaturePanel:SetTall(signature:GetTall()+20)
			end
			ypos = ypos + signaturePanel:GetTall() + 10
		end
		local lbl = vgui.Create("DLabel",pagepanel)
		lbl:SetText("Edit Profile")
		lbl:SetFont("oswald_28")
		lbl:SetColor(Color(52,73,94))
		lbl:SizeToContents()
		center(lbl,ypos)
		ypos = ypos + 35
		local lbl = vgui.Create("DLabel",pagepanel)
		lbl:SetText("Edit Motto")
		lbl:SetFont("roboto_15")
		lbl:SetColor(Color(52,73,94))
		lbl:SizeToContents()
		center(lbl,ypos)
		ypos = ypos + 25
		local mottoLetterCount = vgui.Create("DLabel",pagepanel)
		mottoLetterCount:SetText("")
		mottoLetterCount:SetColor(Color(52,73,94))
		local mottoField = vgui.Create("DTextEntry",pagepanel)
		mottoField:SetSize(250,35)
		mottoField:SetValue(mottoValue)
		center(mottoField,ypos)
		ypos = ypos + 45
		function mottoField:OnChange()
			if string.len(mottoField:GetValue()) > 0 then
				mottoLetterCount:SetText("("..string.len(mottoField:GetValue()).." / 30)")
				mottoLetterCount:SetFont("roboto_15")
				mottoLetterCount:SizeToContents()
				mottoLetterCount:SetPos(mottoField.x+200,mottoField.y+35)
			else
				mottoLetterCount:SetText("")
			end
			motto:SetText(mottoField:GetValue())
			mottoValue = mottoField:GetValue()
			unsavedChanges = true
		end
		local lbl = vgui.Create("DLabel",pagepanel)
		lbl:SetText("Edit Signature")
		lbl:SetFont("roboto_15")
		lbl:SetColor(Color(52,73,94))
		lbl:SizeToContents()
		center(lbl,ypos)
		ypos = ypos + 25
		local signatureLetterCount = vgui.Create("DLabel",pagepanel)
		signatureLetterCount:SetText("")
		signatureLetterCount:SetColor(Color(52,73,94))
		local signatureField = vgui.Create("DTextEntry",pagepanel)
		signatureField:SetSize(250,75)
		signatureField:SetMultiline(true)
		signatureField:SetValue(signatureValue)
		signatureField:SetVerticalScrollbarEnabled(true)
		center(signatureField,ypos)
		ypos = ypos + 95
		function signatureField:OnChange()
			if string.len(signatureField:GetValue()) > 0 then
				signatureLetterCount:SetText("("..string.len(signatureField:GetValue()).." / 200)")
				signatureLetterCount:SetFont("roboto_15")
				signatureLetterCount:SizeToContents()
				signatureLetterCount:SetPos(signatureField.x+200,signatureField.y+75)
			else
				signatureLetterCount:SetText("")
			end
			if IsValid(signature) then
				signature:SetText(WrapText(signatureField:GetValue(),signature:GetWide(),"roboto_15"))
				if signature:GetTall() > 75 then
					signature:GetParent():SetTall(95)
				else
					signature:GetParent():SetTall(signature:GetTall()+20)
				end
			end
			signatureValue = signatureField:GetValue()
			unsavedChanges = true
		end
        local lbl = vgui.Create("DLabel",pagepanel)
		lbl:SetText("Links")
		lbl:SetFont("roboto_15")
		lbl:SetColor(Color(52,73,94))
		lbl:SizeToContents()
		center(lbl,ypos)
        local addLink = vgui.Create("DButton",pagepanel)
        addLink:SetSize(75,25)
        addLink:SetText("+ Add Link")
        addLink:SetColor(Color(52,73,94))
		if links != nil and table.Count(links) == 3 then
			addLink:SetVisible(false)
		end
        addLink:SetFont("roboto_15")
        addLink:SetPos(lbl.x + lbl:GetWide()+5,ypos-5)
        function addLink:Paint(w,h)
            draw.RoundedBox(0,0,0,w,h,Color(236,240,241))
			surface.SetDrawColor(149,165,166)
			surface.DrawOutlinedRect(0,0,w,h)
        end
        function addLink:DoClick()
            local options = DermaMenu()
            local linksAdded = {}

            if links != nil then
                for k,v in pairs(links) do
                    table.insert(linksAdded,v.linkType)
                end
            end
            if !table.HasValue(linksAdded,"website") then
                options:AddOption("Website", function()
                    local box = vgui.Create("ModalPanel",pagepanel)
					box:SetSize(260,135)
                    box:SetPos(0,pagepanel:GetVBar():GetScroll()+pagepanel:GetTall()/2-box:GetTall()/2)
					box:SetTitle("Add Website Link")
					box:SetHeader("Please enter your website url below")
                    box:CenterHorizontal()
                    local link = vgui.Create("DTextEntry",box)
                    link:SetSize(150,25)
                    link:SetPos(0,60)
                    link:CenterHorizontal()
                    local submit = vgui.Create("DButton",box)
                    submit:SetSize(75,30)
                    submit:SetText("Add")
                    submit:SetFont("roboto_15")
                    submit:SetColor(Color(52,73,94))
                    submit:SetPos(0,95)
                    submit:CenterHorizontal()
                    function submit:Paint(w,h)
                        draw.RoundedBox(0,0,0,w,h,Color(236,240,241))
                        surface.SetDrawColor(149,165,166)
                        surface.DrawOutlinedRect(0,0,w,h)
                    end
                    function submit:DoClick()
                        submit:SetEnabled(false)
                        if string.len(link:GetValue()) > 50 then
                            NYEBLOCK.FUNCTIONS.createPopup("You have entered too many characters!",2)
                            submit:SetEnabled(true)
                        else
                            if links == nil then
                                links = {
                                    {
                                        linkType = "website",
                                        value = link:GetValue()
                                    }
                                }
                            else
                                table.insert(links,{
                                    linkType = "website",
                                    value = link:GetValue()
                                })
                            end
                            refreshProfilePage()
							unsavedChanges = true
                        end
                    end
                end)
            end
            if !table.HasValue(linksAdded,"youtube") then
                options:AddOption("Youtube", function()
					local box = vgui.Create("ModalPanel",pagepanel)
					box:SetSize(280,135)
                    box:SetPos(0,pagepanel:GetVBar():GetScroll()+pagepanel:GetTall()/2-box:GetTall()/2)
					box:SetTitle("Add Youtube Channel")
					box:SetHeader("Please enter your youtube channel name below")
                    box:CenterHorizontal()
                    local link = vgui.Create("DTextEntry",box)
                    link:SetSize(150,25)
                    link:SetPos(0,60)
                    link:CenterHorizontal()
                    local submit = vgui.Create("DButton",box)
                    submit:SetSize(75,30)
                    submit:SetText("Add")
                    submit:SetFont("roboto_15")
                    submit:SetColor(Color(52,73,94))
                    submit:SetPos(0,95)
                    submit:CenterHorizontal()
                    function submit:Paint(w,h)
                        draw.RoundedBox(0,0,0,w,h,Color(236,240,241))
                        surface.SetDrawColor(149,165,166)
                        surface.DrawOutlinedRect(0,0,w,h)
                    end
                    function submit:DoClick()
                        if string.len(link:GetValue()) > 50 then
                            NYEBLOCK.FUNCTIONS.createPopup("You have entered too many characters!",2)
                        else
                            if links == nil then
                                links = {
                                    {
                                        linkType = "youtube",
                                        value = link:GetValue()
                                    }
                                }
                            else
                                table.insert(links,{
                                    linkType = "youtube",
                                    value = link:GetValue()
                                })
                            end
                            refreshProfilePage()
							unsavedChanges = true
                        end
                    end
                end)
            end
            if !table.HasValue(linksAdded,"twitch") then
                options:AddOption("Twitch", function()
					local box = vgui.Create("ModalPanel",pagepanel)
					box:SetSize(280,135)
                    box:SetPos(0,pagepanel:GetVBar():GetScroll()+pagepanel:GetTall()/2-box:GetTall()/2)
					box:SetTitle("Add Twitch Channel")
					box:SetHeader("Please enter your twitch channel name below")
                    box:CenterHorizontal()
                    local link = vgui.Create("DTextEntry",box)
                    link:SetSize(150,25)
                    link:SetPos(0,60)
                    link:CenterHorizontal()
                    local submit = vgui.Create("DButton",box)
                    submit:SetSize(75,30)
                    submit:SetText("Add")
                    submit:SetFont("roboto_15")
                    submit:SetColor(Color(52,73,94))
                    submit:SetPos(0,95)
                    submit:CenterHorizontal()
                    function submit:Paint(w,h)
                        draw.RoundedBox(0,0,0,w,h,Color(236,240,241))
                        surface.SetDrawColor(149,165,166)
                        surface.DrawOutlinedRect(0,0,w,h)
                    end
                    function submit:DoClick()
                        if string.len(link:GetValue()) > 50 then
                            NYEBLOCK.FUNCTIONS.createPopup("You have entered too many characters!",2)
                        else
                            if links == nil then
                                links = {
                                    {
                                        linkType = "twitch",
                                        value = link:GetValue()
                                    }
                                }
                            else
                                table.insert(links,{
                                    linkType = "twitch",
                                    value = link:GetValue()
                                })
                            end
                            refreshProfilePage()
							unsavedChanges = true
                        end
                    end
                end)
            end
            options:Open()
        end
		ypos = ypos + 20
        local linksDisplay = vgui.Create("DPanel",pagepanel)
        linksDisplay:SetSize(300,0)
        center(linksDisplay,ypos)
        function linksDisplay:Paint() end
		if links != nil and table.Count(links) > 0 then
			for k,v in pairs(links) do
				local link = vgui.Create("DPanel",linksDisplay)
				link:SetSize(linksDisplay:GetWide()-20,40)
				link:SetPos(10,((k-1)*40)+(5*k))
				function link:Paint(w,h)
					draw.RoundedBox(0,0,0,w,h,Color(236,240,241))
					draw.RoundedBox(0,0,0,10,h,Color(149,165,166))
					surface.SetDrawColor(149,165,166)
					surface.DrawOutlinedRect(0,0,w,h)
				end
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
				icon:SetPos(20,0)
				icon:CenterVertical()
				local value = v.value
				if string.len(value) > 40 then
					value = string.sub(value, 0, 40).."..."
				end
				local lbl = vgui.Create("DLabel",link)
				lbl:SetText(value)
				lbl:SetColor(Color(52,73,94))
				lbl:SizeToContents()
				lbl:SetPos(55,0)
				lbl:CenterVertical()
				local edit = vgui.Create("DImageButton",link)
				edit:SetImage("icon16/pencil.png")
				edit:SetSize(16,16)
				edit:SetPos(link:GetWide()-52,0)
				edit:CenterVertical()
				edit:SetTooltip("Edit Link")
				function edit:DoClick()
					if v.linkType == "website" then
						local box = vgui.Create("ModalPanel",pagepanel)
						box:SetSize(260,135)
						box:SetPos(0,pagepanel:GetVBar():GetScroll()+pagepanel:GetTall()/2-box:GetTall()/2)
						box:SetTitle("Update Website Link")
						box:SetHeader("Please enter your website url below")
						box:CenterHorizontal()
						local link = vgui.Create("DTextEntry",box)
						link:SetSize(150,25)
						link:SetPos(0,60)
						link:SetValue(v.value)
						link:CenterHorizontal()
						local submit = vgui.Create("DButton",box)
						submit:SetSize(75,30)
						submit:SetText("Update")
						submit:SetFont("roboto_15")
						submit:SetColor(Color(52,73,94))
						submit:SetPos(0,95)
						submit:CenterHorizontal()
						function submit:Paint(w,h)
							draw.RoundedBox(0,0,0,w,h,Color(236,240,241))
							surface.SetDrawColor(149,165,166)
							surface.DrawOutlinedRect(0,0,w,h)
						end
						function submit:DoClick()
							submit:SetEnabled(false)
							if string.len(link:GetValue()) > 50 then
								NYEBLOCK.FUNCTIONS.createPopup("You have entered too many characters!",2)
								submit:SetEnabled(true)
							else
								for k,v in pairs(links) do
									if v.linkType == "website" then
										v.value = link:GetValue()
									end
								end
								refreshProfilePage()
								unsavedChanges = true
							end
						end
					elseif v.linkType == "youtube" then
						local box = vgui.Create("ModalPanel",pagepanel)
						box:SetSize(280,135)
						box:SetPos(0,pagepanel:GetVBar():GetScroll()+pagepanel:GetTall()/2-box:GetTall()/2)
						box:SetTitle("Update Youtube channel")
						box:SetHeader("Please enter your youtube channel name below")
						box:CenterHorizontal()
						local link = vgui.Create("DTextEntry",box)
						link:SetSize(150,25)
						link:SetPos(0,60)
						link:SetValue(v.value)
						link:CenterHorizontal()
						local submit = vgui.Create("DButton",box)
						submit:SetSize(75,30)
						submit:SetText("Update")
						submit:SetFont("roboto_15")
						submit:SetColor(Color(52,73,94))
						submit:SetPos(0,95)
						submit:CenterHorizontal()
						function submit:Paint(w,h)
							draw.RoundedBox(0,0,0,w,h,Color(236,240,241))
							surface.SetDrawColor(149,165,166)
							surface.DrawOutlinedRect(0,0,w,h)
						end
						function submit:DoClick()
							submit:SetEnabled(false)
							if string.len(link:GetValue()) > 50 then
								NYEBLOCK.FUNCTIONS.createPopup("You have entered too many characters!",2)
								submit:SetEnabled(true)
							else
								for k,v in pairs(links) do
									if v.linkType == "youtube" then
										v.value = link:GetValue()
									end
								end
								refreshProfilePage()
								unsavedChanges = true
							end
						end
					elseif v.linkType == "twitch" then
						local box = vgui.Create("ModalPanel",pagepanel)
						box:SetSize(280,135)
						box:SetPos(0,pagepanel:GetVBar():GetScroll()+pagepanel:GetTall()/2-box:GetTall()/2)
						box:SetTitle("Edit Twitch Channel")
						box:SetHeader("Please enter your twitch channel name below")
						box:CenterHorizontal()
						local link = vgui.Create("DTextEntry",box)
						link:SetSize(150,25)
						link:SetPos(0,60)
						link:SetValue(v.value)
						link:CenterHorizontal()
						local submit = vgui.Create("DButton",box)
						submit:SetSize(75,30)
						submit:SetText("Update")
						submit:SetFont("roboto_15")
						submit:SetColor(Color(52,73,94))
						submit:SetPos(0,95)
						submit:CenterHorizontal()
						function submit:Paint(w,h)
							draw.RoundedBox(0,0,0,w,h,Color(236,240,241))
							surface.SetDrawColor(149,165,166)
							surface.DrawOutlinedRect(0,0,w,h)
						end
						function submit:DoClick()
							if string.len(link:GetValue()) > 50 then
								NYEBLOCK.FUNCTIONS.createPopup("You have entered too many characters!",2)
							else
								for k,v in pairs(links) do
									if v.linkType == "twitch" then
										v.value = link:GetValue()
									end
								end
								refreshProfilePage()
								unsavedChanges = true
							end
						end
					end
				end
				local remove = vgui.Create("DImageButton",link)
				remove:SetImage("icon16/cross.png")
				remove:SetSize(16,16)
				remove:SetPos(link:GetWide()-26,0)
				remove:CenterVertical()
				remove:SetTooltip("Remove Link")
				function remove:DoClick()
					for k2,v2 in pairs(links) do
						if v2.linkType == v.linkType then
							table.remove(links,k2)
						end
					end
					if table.Count(links) == 0 then
						links = nil
					end
					refreshProfilePage()
					unsavedChanges = true
				end
			end
			linksDisplay:SizeToChildren(false,true)
			linksDisplay:SetTall(linksDisplay:GetTall()+5)
			ypos = ypos + linksDisplay:GetTall() + 10
		else
			local lbl = vgui.Create("DLabel",pagepanel)
			lbl:SetText("You haven't added any links yet.")
			lbl:SetColor(Color(52,73,94))
			lbl:SizeToContents()
			center(lbl,ypos+5)
			ypos = ypos + 30
		end
		local update = vgui.Create("DButton",pagepanel)
		update:SetSize(150,35)
		update:SetText("Update Profile")
		update:SetFont("roboto_15")
		update:SetColor(Color(52,73,94))
		center(update,ypos)
		function update:Paint(w,h)
			draw.RoundedBox(0,0,0,w,h,Color(236,240,241))
			surface.SetDrawColor(149,165,166)
			surface.DrawOutlinedRect(0,0,w,h)
		end
		function update:DoClick()
			if string.len(motto:GetValue()) > 30 then
				NYEBLOCK.FUNCTIONS.createPopup("The 'Edit Motto' field can only have 30 characters max!",2)
			elseif string.len(signatureField:GetValue()) > 200 then
				NYEBLOCK.FUNCTIONS.createPopup("The 'Edit Signature' field can only have 200 characters max!",2)
			else
				local tbl = {
					motto = mottoField:GetValue(),
					signature = signatureField:GetValue(),
					links = links
				}

				net.Start("nyeblock_updateProfile")
					net.WriteTable(tbl)
				net.SendToServer()
				NYEBLOCK.PROFILE.motto = mottoField:GetValue()
				NYEBLOCK.PROFILE.signature = signatureField:GetValue()
				NYEBLOCK.PROFILE.links = links
				NYEBLOCK.FUNCTIONS.createPopup("Profile successfully updated!",1)
				mottoValue = mottoField:GetValue()
				signatureValue = signatureField:GetValue()
				refreshProfilePage()
				unsavedChanges = false
			end
		end
	end
	refreshProfilePage()
end
local function stats()
    pagepanel:AlphaTo(255,.5,0)
	local lbl = vgui.Create("DLabel",pagepanel)
	lbl:SetText("Loading...")
	lbl:SetFont("nameFont2")
	lbl:SetColor(Color(52,73,94))
	lbl:SizeToContents()
	center(lbl,25)
	net.Start("nyeblock_getUserStats")
	net.SendToServer()
	net.Receive("nyeblock_returnUserStats",function()
		if IsValid(lbl) then
			local stats = net.ReadTable()

			pagepanel:Clear()
			local lbl = vgui.Create("DLabel",pagepanel)
			lbl:SetText("My Stats")
			lbl:SetFont("oswald_28")
			lbl:SetColor(Color(52,73,94))
			lbl:SizeToContents()
			center(lbl,15)
			local statsLayout = vgui.Create("DIconLayout",pagepanel)
			statsLayout:SetWide(pagepanel:GetWide()-40)
			statsLayout:SetPos(20,50)
			statsLayout:SetSpaceX(10)
			statsLayout:SetSpaceY(10)
			for k,v in pairs(stats) do
				local pnl = statsLayout:Add("DPanel")
				pnl:SetSize(197,60)
				function pnl:Paint(w,h)
					draw.RoundedBox(0,0,0,w,h,Color(189,195,199))
					draw.RoundedBox(0,0,0,w,25,Color(236,240,241))
					surface.SetDrawColor(149,165,166)
					surface.DrawOutlinedRect(0,0,w,h)
				end
				local text = vgui.Create("DLabel",pnl)
				text:SetText(v.text)
				text:SetColor(Color(52,73,94))
				text:SetFont("oswald_24")
				text:SizeToContents()
				text:SetPos(0,1)
				text:CenterHorizontal()
				local value = vgui.Create("DLabel",pnl)
				value:SetText(string.Comma(v.value))
				value:SetColor(Color(52,73,94))
				value:SetFont("oswald_30")
				value:SizeToContents()
				value:SetPos(0,28)
				value:CenterHorizontal()
			end
		end
	end)
end
local function settings()
	pagepanel:AlphaTo(255,.5,0)
	local lbl = vgui.Create("DLabel",pagepanel)
	lbl:SetText("Loading...")
	lbl:SetFont("nameFont2")
	lbl:SetColor(Color(52,73,94))
	lbl:SizeToContents()
	center(lbl,25)
	net.Start("nyeblock_getUserSettings")
	net.SendToServer()
	net.Receive("nyeblock_returnUserSettings",function()
		if IsValid(lbl) then
			pagepanel:Clear()
			local userSettings = net.ReadTable()

			local lbl = vgui.Create("DLabel",pagepanel)
			lbl:SetText("Settings")
			lbl:SetFont("oswald_28")
			lbl:SetColor(Color(52,73,94))
			lbl:SizeToContents()
			center(lbl,15)
			local settingsLayout = vgui.Create("DIconLayout",pagepanel)
			settingsLayout:SetWide(pagepanel:GetWide()-40)
			settingsLayout:SetPos(20,50)
			settingsLayout:SetSpaceX(10)
			settingsLayout:SetSpaceY(10)
			local profilePrivacy = settingsLayout:Add("DButton")
			profilePrivacy:SetSize(197,50)
			profilePrivacy:SetText("Profile Privacy")
			profilePrivacy:SetColor(Color(52,73,94))
			profilePrivacy:SetFont("roboto_20")
			function profilePrivacy:Paint(w,h)
				draw.RoundedBox(0,0,0,w,h,Color(236,240,241))
				surface.SetDrawColor(149,165,166)
				surface.DrawOutlinedRect(0,0,w,h)
			end
			function profilePrivacy:DoClick()
				local box = vgui.Create("ModalPanel",pagepanel)
				box:SetSize(400,280)
				box:SetPos(0,pagepanel:GetVBar():GetScroll()+pagepanel:GetTall()/2-box:GetTall()/2)
				box:SetTitle("Profile Privacy")
				box:SetHeader("Here you can enable/disable things displayed on your profile.")
				box:CenterHorizontal()
				local layoutScroll = vgui.Create("DScrollPanel",box)
				layoutScroll:SetSize(box:GetWide()-20,box:GetTall()-70)
				layoutScroll:SetPos(10,60)
				local optionsLayout = vgui.Create("DIconLayout",layoutScroll)
				optionsLayout:SetWide(layoutScroll:GetWide()-120)
				optionsLayout:SetPos(60,0)
				optionsLayout:SetSpaceY(10)
				//Points
				local points = optionsLayout:Add("DButton")
				points:SetSize(optionsLayout:GetWide(),50)
				points:SetText("")
				function points:Paint(w,h)
					draw.RoundedBox(0,0,0,w,h,Color(236,240,241))
					surface.SetDrawColor(149,165,166)
					surface.DrawOutlinedRect(0,0,w,h)
				end
				local pointsInfo = vgui.Create("DImageButton",points)
				pointsInfo:SetImage("icon16/information.png")
				pointsInfo:SetSize(15,15)
				pointsInfo:SetTooltip("The amount of points you have on the server")
				pointsInfo:SetPos(points:GetWide()-pointsInfo:GetWide()-5,5)
				local lbl = vgui.Create("DLabel",points)
				lbl:SetText("Points")
				lbl:SetColor(Color(52,73,94))
				lbl:SetFont("roboto_20")
				lbl:SizeToContents()
				lbl:SetPos(0,5)
				lbl:CenterHorizontal()
				local pointsStatus = vgui.Create("DLabel",points)
				pointsStatus:SetText(tobool(userSettings.displayPoints) and "Enabled" or "Disabled")
				pointsStatus:SetFont("roboto_15")
				pointsStatus:SetPos(0,27)
				pointsStatus:SetColor(tobool(userSettings.displayPoints) and Color(0,255,0) or Color(255,0,0))
				pointsStatus:SizeToContents()
				pointsStatus:CenterHorizontal()
				function points:DoClick()
					userSettings.displayPoints = (tobool(userSettings.displayPoints) and 0 or 1)
					net.Start("nyeblock_updateSettings")
						net.WriteTable(userSettings)
					net.SendToServer()
					pointsStatus:SetText(tobool(userSettings.displayPoints) and "Enabled" or "Disabled")
					pointsStatus:SetColor(tobool(userSettings.displayPoints) and Color(0,255,0) or Color(255,0,0))
					pointsStatus:SizeToContents()
					pointsStatus:CenterHorizontal()
				end
				//Play time
				local playTime = optionsLayout:Add("DButton")
				playTime:SetSize(optionsLayout:GetWide(),50)
				playTime:SetText("")
				function playTime:Paint(w,h)
					draw.RoundedBox(0,0,0,w,h,Color(236,240,241))
					surface.SetDrawColor(149,165,166)
					surface.DrawOutlinedRect(0,0,w,h)
				end
				local playTimeInfo = vgui.Create("DImageButton",playTime)
				playTimeInfo:SetImage("icon16/information.png")
				playTimeInfo:SetSize(15,15)
				playTimeInfo:SetTooltip("The amount of time you have played on the server")
				playTimeInfo:SetPos(points:GetWide()-pointsInfo:GetWide()-5,5)
				local lbl = vgui.Create("DLabel",playTime)
				lbl:SetText("Play Time")
				lbl:SetColor(Color(52,73,94))
				lbl:SetFont("roboto_20")
				lbl:SizeToContents()
				lbl:SetPos(0,5)
				lbl:CenterHorizontal()
				local playTimeStatus = vgui.Create("DLabel",playTime)
				playTimeStatus:SetText(tobool(userSettings.displayPlayTime) and "Enabled" or "Disabled")
				playTimeStatus:SetFont("roboto_15")
				playTimeStatus:SetPos(0,27)
				playTimeStatus:SetColor(tobool(userSettings.displayPlayTime) and Color(0,255,0) or Color(255,0,0))
				playTimeStatus:SizeToContents()
				playTimeStatus:CenterHorizontal()
				function playTime:DoClick()
					userSettings.displayPlayTime = (tobool(userSettings.displayPlayTime) and 0 or 1)
					net.Start("nyeblock_updateSettings")
						net.WriteTable(userSettings)
					net.SendToServer()
					playTimeStatus:SetText(tobool(userSettings.displayPlayTime) and "Enabled" or "Disabled")
					playTimeStatus:SetColor(tobool(userSettings.displayPlayTime) and Color(0,255,0) or Color(255,0,0))
					playTimeStatus:SizeToContents()
					playTimeStatus:CenterHorizontal()
				end
			end
		end
	end)
end

net.Receive("nyeblock_profileMenu",function()
    local menuselected = 1
	local headerButtons = {}
	local headerButtonArrows = {}
	local buttonSubmenus = {}
	local function closeDropdowns()
		for k,v in pairs(buttonSubmenus) do
			v:SetVisible(false)
			headerButtonArrows[k]:SetText("⯅")
		end
	end
	if IsValid(panel) then panel:Close() end

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
		if unsavedChanges then
			local box = vgui.Create("ModalPanel",pagepanel)
			box:SetSize(400,120)
			box:SetPos(0,pagepanel:GetVBar():GetScroll()+pagepanel:GetTall()/2-box:GetTall()/2)
			box:SetTitle("Are you sure?")
			box:SetHeader(nil)
			box:CenterHorizontal()
			local lbl = vgui.Create("DLabel",box)
			lbl:SetText("Are you sure you want to close the menu?")
			lbl:SetFont("buttonFont3")
			lbl:SetColor(Color(52,73,94))
			lbl:SizeToContents()
			lbl:SetPos(0,40)
			lbl:CenterHorizontal()
			local lbl = vgui.Create("DLabel",box)
			lbl:SetText("All of your unsaved changes will be erased!")
			lbl:SetFont("buttonFont3")
			lbl:SetColor(Color(52,73,94))
			lbl:SizeToContents()
			lbl:SetPos(0,55)
			lbl:CenterHorizontal()
			local yes = vgui.Create("DButton",box)
			yes:SetSize(100,30)
			yes:SetPos(65,77)
			yes:SetText("Yes")
			yes:SetFont("playerCount")
			yes:SetColor(Color(52,73,94))
			function yes:Paint(w,h)
				draw.RoundedBox(0,0,0,w,h,Color(236,240,241))
				surface.SetDrawColor(149,165,166)
				surface.DrawOutlinedRect(0,0,w,h)
			end
			function yes:DoClick()
				panel:Close()
			end
			local no = vgui.Create("DButton",box)
			no:SetSize(100,30)
			no:SetPos(235,77)
			no:SetText("No")
			no:SetFont("playerCount")
			no:SetColor(Color(52,73,94))
			function no:Paint(w,h)
				draw.RoundedBox(0,0,0,w,h,Color(236,240,241))
				surface.SetDrawColor(149,165,166)
				surface.DrawOutlinedRect(0,0,w,h)
			end
			function no:DoClick()
				box:Remove()
			end
		else
			panel:Close()
		end
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
	lbl:SetText("My Profile")
	lbl:SetFont("oswald_30")
	lbl:SetColor(Color(52,73,94))
	lbl:SizeToContents()
	lbl:SetPos(95,0)
	lbl:CenterVertical()
	headerButtons[1] = vgui.Create("DButton",header)
	headerButtons[1]:SetSize(160,header:GetTall())
	headerButtons[1]:SetPos(190,0)
	headerButtons[1]:SetText("Edit Profile")
	headerButtons[1]:SetFont("buttonFont")
	headerButtons[1]:SetColor(Color(52,73,94))
	headerButtons[1].Paint = function(_,w,h)
		draw.RoundedBox(0,0,0,w,h,Color(189,195,199))
		surface.SetDrawColor(149,165,166)
		surface.DrawOutlinedRect(0,0,w,h)
	end
	headerButtons[1].DoClick = function()
		if unsavedChanges then
			local box = vgui.Create("ModalPanel",pagepanel)
			box:SetSize(400,120)
			box:SetPos(0,pagepanel:GetVBar():GetScroll()+pagepanel:GetTall()/2-box:GetTall()/2)
			box:SetTitle("Are you sure?")
			box:SetHeader(nil)
			box:CenterHorizontal()
			local lbl = vgui.Create("DLabel",box)
			lbl:SetText("Are you sure you want refresh the page?")
			lbl:SetFont("buttonFont3")
			lbl:SetColor(Color(52,73,94))
			lbl:SizeToContents()
			lbl:SetPos(0,40)
			lbl:CenterHorizontal()
			local lbl = vgui.Create("DLabel",box)
			lbl:SetText("All of your unsaved changes will be erased!")
			lbl:SetFont("buttonFont3")
			lbl:SetColor(Color(52,73,94))
			lbl:SizeToContents()
			lbl:SetPos(0,55)
			lbl:CenterHorizontal()
			local yes = vgui.Create("DButton",box)
			yes:SetSize(100,30)
			yes:SetPos(65,77)
			yes:SetText("Yes")
			yes:SetFont("playerCount")
			yes:SetColor(Color(52,73,94))
			function yes:Paint(w,h)
				draw.RoundedBox(0,0,0,w,h,Color(236,240,241))
				surface.SetDrawColor(149,165,166)
				surface.DrawOutlinedRect(0,0,w,h)
			end
			function yes:DoClick()
				unsavedChanges = false
				pagepanel:Clear()
				pagepanel:SetAlpha(0)
				editProfile()
				menuselected = 1
				for k,v in pairs(headerButtons) do
					headerButtons[k].Paint = function(_,w,h)
						draw.RoundedBox(0,0,0,w,h,Color(236,240,241))
						surface.SetDrawColor(149,165,166)
						surface.DrawOutlinedRect(0,0,w,h)
					end
				end
				headerButtons[menuselected].Paint = function(_,w,h)
					draw.RoundedBox(0,0,0,w,h,Color(189,195,199))
					surface.SetDrawColor(149,165,166)
					surface.DrawOutlinedRect(0,0,w,h)
				end
			end
			local no = vgui.Create("DButton",box)
			no:SetSize(100,30)
			no:SetPos(235,77)
			no:SetText("No")
			no:SetFont("playerCount")
			no:SetColor(Color(52,73,94))
			function no:Paint(w,h)
				draw.RoundedBox(0,0,0,w,h,Color(236,240,241))
				surface.SetDrawColor(149,165,166)
				surface.DrawOutlinedRect(0,0,w,h)
			end
			function no:DoClick()
				box:Remove()
			end
		else
			pagepanel:Clear()
			pagepanel:SetAlpha(0)
			editProfile()
			menuselected = 1
			for k,v in pairs(headerButtons) do
				headerButtons[k].Paint = function(_,w,h)
					draw.RoundedBox(0,0,0,w,h,Color(236,240,241))
					surface.SetDrawColor(149,165,166)
					surface.DrawOutlinedRect(0,0,w,h)
				end
			end
			headerButtons[menuselected].Paint = function(_,w,h)
				draw.RoundedBox(0,0,0,w,h,Color(189,195,199))
				surface.SetDrawColor(149,165,166)
				surface.DrawOutlinedRect(0,0,w,h)
			end
		end
	end
    headerButtons[2] = vgui.Create("DButton",header)
	headerButtons[2]:SetSize(160,header:GetTall())
	headerButtons[2]:SetPos(350,0)
	headerButtons[2]:SetText("My Stats")
	headerButtons[2]:SetFont("buttonFont")
	headerButtons[2]:SetColor(Color(52,73,94))
	headerButtons[2].Paint = function(_,w,h)
		draw.RoundedBox(0,0,0,w,h,Color(236,240,241))
        surface.SetDrawColor(149,165,166)
        surface.DrawOutlinedRect(0,0,w,h)
	end
	headerButtons[2].DoClick = function()
		if unsavedChanges then
			local box = vgui.Create("ModalPanel",pagepanel)
			box:SetSize(400,120)
			box:SetPos(0,pagepanel:GetVBar():GetScroll()+pagepanel:GetTall()/2-box:GetTall()/2)
			box:SetTitle("Are you sure?")
			box:SetHeader(nil)
			box:CenterHorizontal()
			local lbl = vgui.Create("DLabel",box)
			lbl:SetText("Are you sure you want to leave this page?")
			lbl:SetFont("buttonFont3")
			lbl:SetColor(Color(52,73,94))
			lbl:SizeToContents()
			lbl:SetPos(0,40)
			lbl:CenterHorizontal()
			local lbl = vgui.Create("DLabel",box)
			lbl:SetText("All of your unsaved changes will be erased!")
			lbl:SetFont("buttonFont3")
			lbl:SetColor(Color(52,73,94))
			lbl:SizeToContents()
			lbl:SetPos(0,55)
			lbl:CenterHorizontal()
			local yes = vgui.Create("DButton",box)
			yes:SetSize(100,30)
			yes:SetPos(65,77)
			yes:SetText("Yes")
			yes:SetFont("playerCount")
			yes:SetColor(Color(52,73,94))
			function yes:Paint(w,h)
				draw.RoundedBox(0,0,0,w,h,Color(236,240,241))
				surface.SetDrawColor(149,165,166)
				surface.DrawOutlinedRect(0,0,w,h)
			end
			function yes:DoClick()
				unsavedChanges = false
				pagepanel:Clear()
				pagepanel:SetAlpha(0)
				stats()
				menuselected = 2
				for k,v in pairs(headerButtons) do
					headerButtons[k].Paint = function(_,w,h)
						draw.RoundedBox(0,0,0,w,h,Color(236,240,241))
						surface.SetDrawColor(149,165,166)
						surface.DrawOutlinedRect(0,0,w,h)
					end
				end
				headerButtons[menuselected].Paint = function(_,w,h)
					draw.RoundedBox(0,0,0,w,h,Color(189,195,199))
					surface.SetDrawColor(149,165,166)
					surface.DrawOutlinedRect(0,0,w,h)
				end
			end
			local no = vgui.Create("DButton",box)
			no:SetSize(100,30)
			no:SetPos(235,77)
			no:SetText("No")
			no:SetFont("playerCount")
			no:SetColor(Color(52,73,94))
			function no:Paint(w,h)
				draw.RoundedBox(0,0,0,w,h,Color(236,240,241))
				surface.SetDrawColor(149,165,166)
				surface.DrawOutlinedRect(0,0,w,h)
			end
			function no:DoClick()
				box:Remove()
			end
		else
			pagepanel:Clear()
			pagepanel:SetAlpha(0)
			stats()
			menuselected = 2
			for k,v in pairs(headerButtons) do
				headerButtons[k].Paint = function(_,w,h)
					draw.RoundedBox(0,0,0,w,h,Color(236,240,241))
					surface.SetDrawColor(149,165,166)
					surface.DrawOutlinedRect(0,0,w,h)
				end
			end
			headerButtons[menuselected].Paint = function(_,w,h)
				draw.RoundedBox(0,0,0,w,h,Color(189,195,199))
				surface.SetDrawColor(149,165,166)
				surface.DrawOutlinedRect(0,0,w,h)
			end
		end
	end
	headerButtons[3] = vgui.Create("DButton",header)
	headerButtons[3]:SetSize(160,header:GetTall())
	headerButtons[3]:SetPos(510,0)
	headerButtons[3]:SetText("Settings")
	headerButtons[3]:SetFont("buttonFont")
	headerButtons[3]:SetColor(Color(52,73,94))
	headerButtons[3].Paint = function(_,w,h)
		draw.RoundedBox(0,0,0,w,h,Color(236,240,241))
        surface.SetDrawColor(149,165,166)
        surface.DrawOutlinedRect(0,0,w,h)
	end
	headerButtons[3].DoClick = function()
		if unsavedChanges then
			local box = vgui.Create("ModalPanel",pagepanel)
			box:SetSize(400,120)
			box:SetPos(0,pagepanel:GetVBar():GetScroll()+pagepanel:GetTall()/2-box:GetTall()/2)
			box:SetTitle("Are you sure?")
			box:SetHeader(nil)
			box:CenterHorizontal()
			local lbl = vgui.Create("DLabel",box)
			lbl:SetText("Are you sure you want to leave this page?")
			lbl:SetFont("buttonFont3")
			lbl:SetColor(Color(52,73,94))
			lbl:SizeToContents()
			lbl:SetPos(0,40)
			lbl:CenterHorizontal()
			local lbl = vgui.Create("DLabel",box)
			lbl:SetText("All of your unsaved changes will be erased!")
			lbl:SetFont("buttonFont3")
			lbl:SetColor(Color(52,73,94))
			lbl:SizeToContents()
			lbl:SetPos(0,55)
			lbl:CenterHorizontal()
			local yes = vgui.Create("DButton",box)
			yes:SetSize(100,30)
			yes:SetPos(65,77)
			yes:SetText("Yes")
			yes:SetFont("playerCount")
			yes:SetColor(Color(52,73,94))
			function yes:Paint(w,h)
				draw.RoundedBox(0,0,0,w,h,Color(236,240,241))
				surface.SetDrawColor(149,165,166)
				surface.DrawOutlinedRect(0,0,w,h)
			end
			function yes:DoClick()
				unsavedChanges = false
				pagepanel:Clear()
				pagepanel:SetAlpha(0)
				settings()
				menuselected = 3
				for k,v in pairs(headerButtons) do
					headerButtons[k].Paint = function(_,w,h)
						draw.RoundedBox(0,0,0,w,h,Color(236,240,241))
						surface.SetDrawColor(149,165,166)
						surface.DrawOutlinedRect(0,0,w,h)
					end
				end
				headerButtons[menuselected].Paint = function(_,w,h)
					draw.RoundedBox(0,0,0,w,h,Color(189,195,199))
					surface.SetDrawColor(149,165,166)
					surface.DrawOutlinedRect(0,0,w,h)
				end
			end
			local no = vgui.Create("DButton",box)
			no:SetSize(100,30)
			no:SetPos(235,77)
			no:SetText("No")
			no:SetFont("playerCount")
			no:SetColor(Color(52,73,94))
			function no:Paint(w,h)
				draw.RoundedBox(0,0,0,w,h,Color(236,240,241))
				surface.SetDrawColor(149,165,166)
				surface.DrawOutlinedRect(0,0,w,h)
			end
			function no:DoClick()
				box:Remove()
			end
		else
			pagepanel:Clear()
			pagepanel:SetAlpha(0)
			settings()
			menuselected = 3
			for k,v in pairs(headerButtons) do
				headerButtons[k].Paint = function(_,w,h)
					draw.RoundedBox(0,0,0,w,h,Color(236,240,241))
					surface.SetDrawColor(149,165,166)
					surface.DrawOutlinedRect(0,0,w,h)
				end
			end
			headerButtons[menuselected].Paint = function(_,w,h)
				draw.RoundedBox(0,0,0,w,h,Color(189,195,199))
				surface.SetDrawColor(149,165,166)
				surface.DrawOutlinedRect(0,0,w,h)
			end
		end
	end
    pagepanel = vgui.Create("DScrollPanel",panel)
	pagepanel:SetSize(panel:GetWide()-40,455)
	pagepanel:SetPos(20,125)
	function pagepanel:Paint(w,h)
		draw.RoundedBox(0,0,0,w,h,Color(236,240,241))
		surface.SetDrawColor(149,165,166)
		surface.DrawOutlinedRect(0,0,w,h)
	end
    editProfile()
end)