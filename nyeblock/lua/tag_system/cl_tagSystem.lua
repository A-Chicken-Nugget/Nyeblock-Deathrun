surface.CreateFont("oswald_20",{font="Oswald",extended=false,size=20,weight=500})
surface.CreateFont("oswald_24",{font="Oswald",extended=false,size=24,weight=500})
surface.CreateFont("oswald_28",{font="Oswald",extended=false,size=28,weight=500})
surface.CreateFont("oswald_30",{font="Oswald",extended=false,size=30,weight=5000})
surface.CreateFont("roboto_30",{font="Roboto Black",extended=false,size=30,weight=500})
surface.CreateFont("roboto_25",{font="Roboto Black",extended=false,size=25,weight=500})
surface.CreateFont("roboto_20",{font="Roboto Black",extended=false,size=20,weight=500})
surface.CreateFont("roboto_15",{font="Roboto Black",extended=false,size=15,weight=500})
surface.CreateFont("regular_20",{font="",extended=false,size=20,weight=500})
surface.CreateFont("regular_15",{font="",extended=false,size=15,weight=500})

local panel
local pagepanel
local tagData = nil
local clanData = {}
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
local function center(i,y)
	i:SetPos(pagepanel:GetWide()/2-i:GetWide()/2,y)
end
local function secondsToDhms(seconds)
	seconds = tonumber(seconds)
	local d = math.floor(seconds / (3600*24))
	local h = math.floor(seconds % (3600*24) / 3600)
	local m = math.floor(seconds % 3600 / 60)
	local s = math.floor(seconds % 60)
	local dDisplay = d > 0 and d..(d == 1 and " day, " or " days, ") or ""
	local hDisplay = h > 0 and h..(h == 1 and " hour, " or " hours, ") or ""
	local mDisplay = m > 0 and m..(m == 1 and " minute, " or " minutes, ") or ""
	local sDisplay = s > 0 and s..(s == 1 and " second" or " seconds") or ""

	return dDisplay..hDisplay..mDisplay..sDisplay;
end

local function myTag()
	pagepanel:AlphaTo(255,.5,0)

	local lbl = vgui.Create("DLabel",pagepanel)
	lbl:SetText("My Tag")
	lbl:SetFont("oswald_28")
	lbl:SetColor(Color(52,73,94))
	lbl:SizeToContents()
	center(lbl,15)

	if !LocalPlayer():GetNWBool("nyeblock_hasTag",false) then
		local lbl = vgui.Create("DLabel",pagepanel)
		lbl:SetText("You currently do not have a tag. Click button below to create one!")
		lbl:SetFont("roboto_15")
		lbl:SetColor(Color(52,73,94))
		lbl:SizeToContents()
		center(lbl,55)
		local create = vgui.Create("DButton",pagepanel)
		create:SetSize(100,30)
		create:SetText("Create tag")
		create:SetFont("roboto_15")
		create:SetColor(Color(52,73,94))
		center(create,85)
		function create:Paint(w,h)
			draw.RoundedBox(0,0,0,w,h,Color(236,240,241))
			surface.SetDrawColor(149,165,166)
			surface.DrawOutlinedRect(0,0,w,h)
		end
		function create:DoClick()
			create:SetEnabled(false)

			local box = vgui.Create("DPanel",pagepanel)
			box:SetSize(400,380)
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
				create:SetEnabled(true)
			end
			local lbl = vgui.Create("DLabel",box)
			lbl:SetText("Create Tag")
			lbl:SetFont("roboto_25")
			lbl:SetColor(Color(52,73,94))
			lbl:SizeToContents()
			lbl:SetPos(0,10)
			lbl:CenterHorizontal()
			local lbl = vgui.Create("DLabel",box)
			lbl:SetText("Please enter the tag you would like")
			lbl:SetFont("roboto_15")
			lbl:SetColor(Color(52,73,94))
			lbl:SizeToContents()
			lbl:SetPos(0,40)
			lbl:CenterHorizontal()
			local tag = vgui.Create("DTextEntry",box)
			tag:SetSize(75,25)
			tag:SetPos(0,65)
			tag:CenterHorizontal()
			local lbl = vgui.Create("DLabel",box)
			lbl:SetText("Please select the color you would like")
			lbl:SetFont("roboto_15")
			lbl:SetColor(Color(52,73,94))
			lbl:SizeToContents()
			lbl:SetPos(0,100)
			lbl:CenterHorizontal()
			local textColor = vgui.Create("DLabel",box)
			textColor:SetText("Color Preview")
			textColor:SetFont("roboto_15")
			textColor:SizeToContents()
			textColor:SetPos(0,120)
			textColor:CenterHorizontal()
			local color = vgui.Create("DColorCube",box)
			color:SetSize(100,100)
			color:SetPos(0,140)
			color:CenterHorizontal(0.45)
			local colorPicker = vgui.Create("DRGBPicker",box)
			colorPicker:SetSize(25,100)
			colorPicker:SetPos(0,140)
			colorPicker:CenterHorizontal(0.65)
			function colorPicker:OnChange(col)
				local h = ColorToHSV( col )
				local _, s, v = ColorToHSV( color:GetRGB() )

				col = HSVToColor(h,s,v)
				color:SetColor(col)
				textColor:SetColor(Color(col.r,col.g,col.b))
			end
			function color:OnUserChanged(col)
				textColor:SetColor(Color(col.r,col.g,col.b))
			end
			textColor:SetColor(color:GetRGB())
			local lbl = vgui.Create("DLabel",box)
			lbl:SetText("How long would you like the tag")
			lbl:SetFont("roboto_15")
			lbl:SetColor(Color(52,73,94))
			lbl:SizeToContents()
			lbl:SetPos(0,250)
			lbl:CenterHorizontal()
			local length = vgui.Create("DComboBox",box)
			length:SetSize(100,25)
			length:SetPos(0,275)
			length:CenterHorizontal()
			length:AddChoice("1 Week",NYEBLOCK.TAG_LENGTH_PRICES["1 Week"])
			length:AddChoice("1 Month",NYEBLOCK.TAG_LENGTH_PRICES["1 Month"])
			length:AddChoice("6 Months",NYEBLOCK.TAG_LENGTH_PRICES["6 Months"])
			length:AddChoice("1 Year",NYEBLOCK.TAG_LENGTH_PRICES["1 Year"])
			length:AddChoice("Permanent",NYEBLOCK.TAG_LENGTH_PRICES["Permanent"])
			local price = vgui.Create("DLabel",box)
			price:SetText("...")
			price:SetFont("roboto_15")
			price:SetColor(Color(52,73,94))
			price:SizeToContents()
			price:SetPos(0,310)
			price:CenterHorizontal()
			function length:OnSelect(index,value,data)
				price:SetText("This tag will cost: "..string.Comma(data).." points")
				price:SizeToContents()
				price:CenterHorizontal()
			end
			local create = vgui.Create("DButton",box)
			create:SetSize(100,30)
			create:SetText("Create")
			create:SetFont("roboto_15")
			create:SetColor(Color(52,73,94))
			create:SetPos(0,335)
			create:CenterHorizontal()
			function create:Paint(w,h)
				draw.RoundedBox(0,0,0,w,h,Color(236,240,241))
				surface.SetDrawColor(149,165,166)
				surface.DrawOutlinedRect(0,0,w,h)
			end
			function create:DoClick()
				local function checkBlacklistedWords()
					local pass = true

					for k,v in pairs(NYEBLOCK.BLOCKED_WORDS) do
						if string.find(string.lower(tag:GetValue()),v) then
							pass = false
						end
					end
					for k,v in pairs(NYEBLOCK.BLOCKED_SYMBOLS) do
						if string.find(string.lower(tag:GetValue()),v,1,true) then
							pass = false
						end
					end
					return pass
				end

				if tag:GetValue() == "" then
					NYEBLOCK.FUNCTIONS.createPopup("Please enter a tag!",2)
				elseif string.len(tag:GetValue()) > 8 then
					NYEBLOCK.FUNCTIONS.createPopup("The tag can only have a max of 8 characters!",2)
				elseif length:GetValue() == "" then
					NYEBLOCK.FUNCTIONS.createPopup("Please select a length!",2)
				elseif !LocalPlayer():PS_HasPoints(NYEBLOCK.TAG_LENGTH_PRICES[length:GetValue()]) then
					NYEBLOCK.FUNCTIONS.createPopup("You do not have enough points!",2)
				elseif !checkBlacklistedWords() then
					NYEBLOCK.FUNCTIONS.createPopup("Unable to create tag! Please use a different tag.",2)
				else
					create:SetEnabled(false)
					local tagColor = color:GetRGB()
					local revisedTag = tag:GetValue()
					local function removeSpace()
						if string.find(revisedTag," ",string.len(revisedTag)) then
							revisedTag = string.sub(revisedTag,1,string.len(revisedTag)-1)
							removeSpace()
						end
					end
					removeSpace()

					net.Start("nyeblock_createTag")
						net.WriteTable({
							tag = revisedTag,
							color = tagColor.r.." "..tagColor.g.." "..tagColor.b.." 255",
							length = length:GetValue()
						})
					net.SendToServer()
					net.Receive("nyeblock_returnTagInfo",function()
						local success = net.ReadBool()

						if success then
							local data = net.ReadTable()

							box:Remove()
							NYEBLOCK.FUNCTIONS.createPopup("Tag successfully created!",1)
							tagData = data
							pagepanel:Clear()
							pagepanel:SetAlpha(0)
							myTag()
						else
							create:SetEnabled(true)
							local message = net.ReadString()

							NYEBLOCK.FUNCTIONS.createPopup(message,2)
						end
					end)
				end
			end
		end
	else
		local lbl = vgui.Create("DLabel",pagepanel)
		lbl:SetText(tagData.tag)
		lbl:SetFont("roboto_30")
		lbl:SetColor(string.ToColor(tagData.color))
		lbl:SizeToContents()
		center(lbl,55)
		local timeLeft = vgui.Create("DLabel",pagepanel)
		timeLeft:SetText("")
		timeLeft:SetFont("roboto_15")
		timeLeft:SetColor(Color(52,73,94))
		if tagData.length != 0 then
			local hasExpired = false
			function timeLeft:Think()
				local diff = (tagData.length + tagData.created) - os.time()

				if diff > 0 then
					timeLeft:SetText("Tag expires in: "..secondsToDhms(diff))
					timeLeft:SizeToContents()
					timeLeft:CenterHorizontal()
				else
					if !hasExpired then
						hasExpired = true
						net.Start("nyeblock_resetTagNWStrings")
						net.SendToServer()
						tagData = nil
						pagepanel:Clear()
						pagepanel:SetAlpha(0)
						myTag()
					end
				end
			end
		else
			timeLeft:SetText("Tag expires: Never")
		end
		timeLeft:SizeToContents()
		center(timeLeft,95)
		local remove = vgui.Create("DButton",pagepanel)
		remove:SetSize(100,30)
		remove:SetText("Remove tag")
		remove:SetFont("roboto_15")
		remove:SetColor(Color(52,73,94))
		center(remove,125)
		function remove:Paint(w,h)
			draw.RoundedBox(0,0,0,w,h,Color(236,240,241))
			surface.SetDrawColor(149,165,166)
			surface.DrawOutlinedRect(0,0,w,h)
		end
		function remove:DoClick()
			if !LocalPlayer():GetNWBool("nyeblock_hasClan",false) then
				if !LocalPlayer():GetNWBool("nyeblock_inClan",false) then
					remove:SetEnabled(false)

					local box = vgui.Create("DPanel",pagepanel)
					box:SetSize(400,120)
					center(box,pagepanel:GetTall()/2-box:GetTall()/2)
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
						remove:SetEnabled(true)
					end
					local lbl = vgui.Create("DLabel",box)
					lbl:SetText("Are you sure?")
					lbl:SetFont("buttonFont")
					lbl:SetColor(Color(52,73,94))
					lbl:SizeToContents()
					lbl:SetPos(0,10)
					lbl:CenterHorizontal()
					local lbl = vgui.Create("DLabel",box)
					lbl:SetText("Are you sure you want to remove your tag?")
					lbl:SetFont("buttonFont3")
					lbl:SetColor(Color(52,73,94))
					lbl:SizeToContents()
					lbl:SetPos(0,40)
					lbl:CenterHorizontal()
					local lbl = vgui.Create("DLabel",box)
					lbl:SetText("This cannot be undone and you will not be refunded!")
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
						net.Start("nyeblock_removeTag")
						net.SendToServer()
						net.Receive("nyeblock_returnRemoveTag",function()
							local success = net.ReadBool()

							if success then
								NYEBLOCK.FUNCTIONS.createPopup("Tag successfully removed!",1)
								tagData = nil
								pagepanel:Clear()
								pagepanel:SetAlpha(0)
								myTag()
							else
								local message = net.ReadString()

								NYEBLOCK.FUNCTIONS.createPopup(message,1)
								tagData = nil
								pagepanel:Clear()
								pagepanel:SetAlpha(0)
								myTag()
							end
						end)
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
						remove:SetEnabled(true)
					end
				else
					remove:SetEnabled(false)

					local box = vgui.Create("DPanel",pagepanel)
					box:SetSize(400,120)
					center(box,pagepanel:GetTall()/2-box:GetTall()/2)
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
						remove:SetEnabled(true)
					end
					local lbl = vgui.Create("DLabel",box)
					lbl:SetText("Are you sure?")
					lbl:SetFont("buttonFont")
					lbl:SetColor(Color(52,73,94))
					lbl:SizeToContents()
					lbl:SetPos(0,10)
					lbl:CenterHorizontal()
					local lbl = vgui.Create("DLabel",box)
					lbl:SetText("Are you sure you want to leave your clan?")
					lbl:SetFont("buttonFont3")
					lbl:SetColor(Color(52,73,94))
					lbl:SizeToContents()
					lbl:SetPos(0,40)
					lbl:CenterHorizontal()
					local lbl = vgui.Create("DLabel",box)
					lbl:SetText("This cannot be undone and you will not be refunded!")
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
						net.Start("nyeblock_leaveClan")
						net.SendToServer()
						net.Receive("nyeblock_returnLeaveClanInfo",function()
							local success = net.ReadBool()

							if success then
								NYEBLOCK.FUNCTIONS.createPopup("You have successfully left your clan!",1)
								tagData = nil
								pagepanel:Clear()
								pagepanel:SetAlpha(0)
								myTag()
							else
								local message = net.ReadString()

								NYEBLOCK.FUNCTIONS.createPopup(message,2)
								pagepanel:Clear()
								pagepanel:SetAlpha(0)
								myTag()
							end
						end)
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
						remove:SetEnabled(true)
					end
				end
			else
				NYEBLOCK.FUNCTIONS.createPopup("You must delete your clan before removing your tag!",2)
			end
		end
	end
end
local function clans()
	pagepanel:AlphaTo(255,.5,0)

	local lbl = vgui.Create("DLabel",pagepanel)
	lbl:SetText("Clans")
	lbl:SetFont("oswald_28")
	lbl:SetColor(Color(52,73,94))
	lbl:SizeToContents()
	center(lbl,15)
	if LocalPlayer():GetNWBool("nyeblock_hasTag",false) then
		if !LocalPlayer():GetNWBool("nyeblock_hasClan",false) and !LocalPlayer():GetNWBool("nyeblock_inClan",false) then
			local create = vgui.Create("DButton",pagepanel)
			create:SetSize(100,30)
			create:SetPos(pagepanel:GetWide()-create:GetWide()-15,15)
			create:SetText("+ Create Clan")
			create:SetFont("roboto_15")
			create:SetColor(Color(52,73,94))
			function create:Paint(w,h)
				draw.RoundedBox(0,0,0,w,h,Color(236,240,241))
				surface.SetDrawColor(149,165,166)
				surface.DrawOutlinedRect(0,0,w,h)
			end
			function create:DoClick()
				create:SetEnabled(false)

				local box = vgui.Create("DPanel",pagepanel)
				box:SetSize(400,330)
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
					create:SetEnabled(true)
				end
				local lbl = vgui.Create("DLabel",box)
				lbl:SetText("Create Clan")
				lbl:SetFont("roboto_25")
				lbl:SetColor(Color(52,73,94))
				lbl:SizeToContents()
				lbl:SetPos(0,10)
				lbl:CenterHorizontal()
				local lbl = vgui.Create("DLabel",box)
				lbl:SetText("Clans allow users to have the same tag. For the duration of your tag")
				lbl:SetFont("roboto_15")
				lbl:SetColor(Color(52,73,94))
				lbl:SizeToContents()
				lbl:SetPos(0,40)
				lbl:CenterHorizontal()
				local lbl = vgui.Create("DLabel",box)
				lbl:SetText("your clan will be active and other users can join for some points.")
				lbl:SetFont("roboto_15")
				lbl:SetColor(Color(52,73,94))
				lbl:SizeToContents()
				lbl:SetPos(0,55)
				lbl:CenterHorizontal()
				local lbl = vgui.Create("DLabel",box)
				lbl:SetText("Once your tag has expired the clan and its members will be removed.")
				lbl:SetFont("roboto_15")
				lbl:SetColor(Color(52,73,94))
				lbl:SizeToContents()
				lbl:SetPos(0,70)
				lbl:CenterHorizontal()
				local lbl = vgui.Create("DLabel",box)
				lbl:SetText("Please enter a clan message")
				lbl:SetFont("roboto_15")
				lbl:SetColor(Color(52,73,94))
				lbl:SizeToContents()
				lbl:SetPos(0,100)
				lbl:CenterHorizontal()
				local messageLetterCount = vgui.Create("DLabel",box)
				messageLetterCount:SetText("")
				messageLetterCount:SetColor(Color(52,73,94))
				local message = vgui.Create("DTextEntry",box)
				message:SetSize(250,55)
				message:SetMultiline(true)
				message:SetPos(0,120)
				message:CenterHorizontal()
				function message:OnChange()
					if string.len(message:GetValue()) > 0 then
						messageLetterCount:SetText("("..string.len(message:GetValue()).." / 300)")
						messageLetterCount:SetFont("roboto_15")
						messageLetterCount:SizeToContents()
						messageLetterCount:SetPos(message.x+200,message.y+55)
					else
						messageLetterCount:SetText("")
					end
				end
				local lbl = vgui.Create("DLabel",box)
				lbl:SetText("Clan Password (Leave blank for no password)")
				lbl:SetFont("roboto_15")
				lbl:SetColor(Color(52,73,94))
				lbl:SizeToContents()
				lbl:SetPos(0,190)
				lbl:CenterHorizontal()
				local passwordLetterCount = vgui.Create("DLabel",box)
				passwordLetterCount:SetText("")
				passwordLetterCount:SetColor(Color(52,73,94))
				local password = vgui.Create("DTextEntry",box)
				password:SetSize(250,25)
				password:SetPos(0,210)
				password:CenterHorizontal()
				function password:OnChange()
					if string.len(password:GetValue()) > 0 then
						passwordLetterCount:SetText("("..string.len(password:GetValue()).." / 20)")
						passwordLetterCount:SetFont("roboto_15")
						passwordLetterCount:SizeToContents()
						passwordLetterCount:SetPos(password.x+200,password.y+25)
					else
						passwordLetterCount:SetText("")
					end
				end
				local lbl = vgui.Create("DLabel",box)
				lbl:SetText("Price to create clan: "..string.Comma(NYEBLOCK.CLAN_PRICE).." points")
				lbl:SetFont("roboto_15")
				lbl:SetColor(Color(52,73,94))
				lbl:SizeToContents()
				lbl:SetPos(0,250)
				lbl:CenterHorizontal()
				local create = vgui.Create("DButton",box)
				create:SetSize(100,30)
				create:SetPos(0,280)
				create:CenterHorizontal()
				create:SetText("Create")
				create:SetFont("roboto_15")
				create:SetColor(Color(52,73,94))
				function create:Paint(w,h)
					draw.RoundedBox(0,0,0,w,h,Color(236,240,241))
					surface.SetDrawColor(149,165,166)
					surface.DrawOutlinedRect(0,0,w,h)
				end
				function create:DoClick()
					if !LocalPlayer():PS_HasPoints(NYEBLOCK.CLAN_PRICE) then
						NYEBLOCK.FUNCTIONS.createPopup("You do not have enough points!",2)
					elseif string.len(message:GetValue()) > 300 then
						NYEBLOCK.FUNCTIONS.createPopup("The clan message field can only have a max of 300 characters!",2)
					elseif string.len(password:GetValue()) > 20 then
						NYEBLOCK.FUNCTIONS.createPopup("The password field can only have a max of 20 characters!",2)
					else
						local tbl = {
							message = message:GetValue(),
							password = password:GetValue()
						}

						net.Start("nyeblock_createClan")
							net.WriteTable(tbl)
						net.SendToServer()
						net.Receive("nyeblock_returnCreateClanInfo",function()
							local success = net.ReadBool()
							local message = net.ReadString()

							if success then
								NYEBLOCK.FUNCTIONS.createPopup(message,1)
								pagepanel:Clear()
								pagepanel:SetAlpha(0)
								clans()
							else
								NYEBLOCK.FUNCTIONS.createPopup(message,2)
							end
						end)
					end
				end
			end
		else
			if tagData.clanId == nil then
				local manage = vgui.Create("DButton",pagepanel)
				manage:SetSize(100,30)
				manage:SetPos(pagepanel:GetWide()-manage:GetWide()-15,15)
				manage:SetText("Manage Clan")
				manage:SetFont("roboto_15")
				manage:SetColor(Color(52,73,94))
				function manage:Paint(w,h)
					draw.RoundedBox(0,0,0,w,h,Color(236,240,241))
					surface.SetDrawColor(149,165,166)
					surface.DrawOutlinedRect(0,0,w,h)
				end
				function manage:DoClick()
					local clanData = {}

					net.Start("nyeblock_getClanData")
					net.SendToServer()
					local box = vgui.Create("DPanel",pagepanel)
					box:SetSize(400,370)
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
					lbl:SetText("Manage Clan")
					lbl:SetFont("roboto_25")
					lbl:SetColor(Color(52,73,94))
					lbl:SizeToContents()
					lbl:SetPos(0,10)
					lbl:CenterHorizontal()
					local lbl = vgui.Create("DLabel",box)
					lbl:SetText("Members")
					lbl:SetFont("roboto_15")
					lbl:SetColor(Color(52,73,94))
					lbl:SizeToContents()
					lbl:SetPos(0,40)
					lbl:CenterHorizontal()
					local playerScroll = vgui.Create("DScrollPanel",box)
					playerScroll:SetSize(box:GetWide()-20,100)
					playerScroll:SetPos(0,60)
					playerScroll:CenterHorizontal()
					local playerList = vgui.Create("DIconLayout",playerScroll)
					playerList:SetWide(playerScroll:GetWide()-40)
					playerList:SetPos(playerScroll:GetWide()/2-playerList:GetWide()/2,0)
					playerList:SetSpaceY(10)
					local lbl = playerList:Add("DLabel")
					lbl:SetSize(playerList:GetWide(),25)
					lbl:SetContentAlignment(5)
					lbl:SetText("Loading...")
					lbl:SetColor(Color(52,73,94))
					lbl:SetFont("roboto_15")
					local lbl = vgui.Create("DLabel",box)
					lbl:SetText("Message")
					lbl:SetFont("roboto_15")
					lbl:SetColor(Color(52,73,94))
					lbl:SizeToContents()
					lbl:SetPos(0,170)
					lbl:CenterHorizontal()
					local messageLetterCount = vgui.Create("DLabel",box)
					messageLetterCount:SetText("")
					messageLetterCount:SetColor(Color(52,73,94))
					local message = vgui.Create("DTextEntry",box)
					message:SetSize(250,55)
					message:SetMultiline(true)
					message:SetPos(0,190)
					message:SetValue("Loading...")
					message:CenterHorizontal()
					function message:OnChange()
						if string.len(message:GetValue()) > 0 then
							messageLetterCount:SetText("("..string.len(message:GetValue()).." / 300)")
							messageLetterCount:SetFont("roboto_15")
							messageLetterCount:SizeToContents()
							messageLetterCount:SetPos(message.x+200,message.y+55)
						else
							messageLetterCount:SetText("")
						end
					end
					local lbl = vgui.Create("DLabel",box)
					lbl:SetText("Password (Leave blank for no password)")
					lbl:SetFont("roboto_15")
					lbl:SetColor(Color(52,73,94))
					lbl:SizeToContents()
					lbl:SetPos(0,255)
					lbl:CenterHorizontal()
					local passwordLetterCount = vgui.Create("DLabel",box)
					passwordLetterCount:SetText("")
					passwordLetterCount:SetColor(Color(52,73,94))
					local password = vgui.Create("DTextEntry",box)
					password:SetSize(250,25)
					password:SetPos(0,275)
					password:SetValue("Loading...")
					password:CenterHorizontal()
					function password:OnChange()
						if string.len(password:GetValue()) > 0 then
							passwordLetterCount:SetText("("..string.len(password:GetValue()).." / 20)")
							passwordLetterCount:SetFont("roboto_15")
							passwordLetterCount:SizeToContents()
							passwordLetterCount:SetPos(password.x+200,password.y+25)
						else
							passwordLetterCount:SetText("")
						end
					end
					local function layoutData()
						playerList:Clear()
						if clanData.members != nil and #clanData.members > 0 then
							for k,v in pairs(clanData.members) do
								local pnl = playerList:Add("DPanel")
								pnl:SetSize(playerList:GetWide(),35)
								function pnl:Paint(w,h)
									draw.RoundedBox(0,0,0,w,h,Color(236,240,241))
									surface.SetDrawColor(149,165,166)
									surface.DrawOutlinedRect(0,0,w,h)
									draw.RoundedBox(0,0,0,15,h,Color(149,165,166))
								end
								local name = vgui.Create("DLabel",pnl)
								name:SetSize(285,25)
								name:SetPos(20,0)
								name:CenterVertical()
								name:SetText("Loading name...")
								name:SetColor(Color(52,73,94))
								name:SetFont("roboto_20")
								steamworks.RequestPlayerInfo(v.steamid64,function(steamName)
									name:SetText(steamName)
								end)
								local remove = vgui.Create("DImageButton",pnl)
								remove:SetImage("icon16/cross.png")
								remove:SetSize(16,16)
								remove:SetPos(pnl:GetWide()-26,0)
								remove:SetToolTip("Remove player from clan")
								remove:CenterVertical()
								function remove:DoClick()
									box:SetVisible(false)

									local box2 = vgui.Create("DPanel",pagepanel)
									box2:SetSize(400,120)
									center(box2,pagepanel:GetTall()/2-box2:GetTall()/2)
									function box2:Paint(w,h)
										draw.RoundedBox(0,0,0,w,h,Color(236,240,241))
										surface.SetDrawColor(149,165,166)
										surface.DrawOutlinedRect(0,0,w,h)
									end
									box2:SetPos(0,pagepanel:GetVBar():GetScroll()+pagepanel:GetTall()/2-box2:GetTall()/2)
									box2:CenterHorizontal()
									local close = vgui.Create("DImageButton",box2)
									close:SetSize(15,15)
									close:SetImage("icon16/cross.png")
									close:SetPos(box2:GetWide()-close:GetWide()-10,10)
									function close:DoClick()
										box2:Remove()
									end
									local lbl = vgui.Create("DLabel",box2)
									lbl:SetText("Are you sure?")
									lbl:SetFont("buttonFont")
									lbl:SetColor(Color(52,73,94))
									lbl:SizeToContents()
									lbl:SetPos(0,10)
									lbl:CenterHorizontal()
									local lbl = vgui.Create("DLabel",box2)
									lbl:SetText("Are you sure you want to remove this user from the clan?")
									lbl:SetFont("buttonFont3")
									lbl:SetColor(Color(52,73,94))
									lbl:SizeToContents()
									lbl:SetPos(0,40)
									lbl:CenterHorizontal()
									local lbl = vgui.Create("DLabel",box2)
									lbl:SetText("This cannot be undone and the user will not be refunded their points!")
									lbl:SetFont("buttonFont3")
									lbl:SetColor(Color(52,73,94))
									lbl:SizeToContents()
									lbl:SetPos(0,55)
									lbl:CenterHorizontal()
									local yes = vgui.Create("DButton",box2)
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
										net.Start("nyeblock_removeClanMember")
											net.WriteString(v.id)
										net.SendToServer()
										table.remove(clanData.members,k)
										layoutData()
										box2:Remove()
										box:SetVisible(true)
									end
									local no = vgui.Create("DButton",box2)
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
										box2:Remove()
										box:SetVisible(true)
									end
								end
							end
						else
							local lbl = playerList:Add("DLabel")
							lbl:SetSize(playerList:GetWide(),25)
							lbl:SetContentAlignment(5)
							lbl:SetText("No members found!")
							lbl:SetColor(Color(52,73,94))
							lbl:SetFont("roboto_15")
						end
						if clanData.clanData != nil then
							message:SetValue(clanData.clanData.message)
							password:SetValue(clanData.clanData.password == nil and "" or clanData.clanData.password)
						else
							message:SetValue("")
							password:SetValue("")
						end
					end
					local update = vgui.Create("DButton",box)
					update:SetSize(100,30)
					update:SetPos(0,320)
					update:CenterHorizontal()
					update:SetEnabled(false)
					update:SetText("Update")
					update:SetFont("roboto_15")
					update:SetColor(Color(52,73,94))
					function update:Paint(w,h)
						draw.RoundedBox(0,0,0,w,h,Color(236,240,241))
						surface.SetDrawColor(149,165,166)
						surface.DrawOutlinedRect(0,0,w,h)
					end
					function update:DoClick()
						if string.len(message:GetValue()) > 300 then
							NYEBLOCK.FUNCTIONS.createPopup("The clan message field can only have a max of 300 characters!",2)
						elseif string.len(password:GetValue()) > 20 then
							NYEBLOCK.FUNCTIONS.createPopup("The password field can only have a max of 20 characters!",2)
						else
							local tbl = {
								message = message:GetValue(),
								password = password:GetValue()
							}

							net.Start("nyeblock_updateClanInfo")
								net.WriteTable(tbl)
							net.SendToServer()
							if clanData.clanData == nil then
								clanData.clanData = {}
							end
							clanData.clanData.message = message:GetValue()
							clanData.clanData.password = password:GetValue()
							NYEBLOCK.FUNCTIONS.createPopup("Clan info successfully updated!",1)
						end
					end
					local delete = vgui.Create("DButton",box)
					delete:SetSize(80,23)
					delete:SetPos(box:GetWide()-delete:GetWide()-10,322)
					delete:SetText("Delete clan")
					delete:SetFont("roboto_15")
					delete:SetColor(Color(52,73,94))
					function delete:Paint(w,h)
						draw.RoundedBox(0,0,0,w,h,Color(236,240,241))
						surface.SetDrawColor(149,165,166)
						surface.DrawOutlinedRect(0,0,w,h)
					end
					function delete:DoClick()
						box:SetVisible(false)

						local box2 = vgui.Create("DPanel",pagepanel)
						box2:SetSize(400,120)
						center(box2,pagepanel:GetTall()/2-box:GetTall()/2)
						function box2:Paint(w,h)
							draw.RoundedBox(0,0,0,w,h,Color(236,240,241))
							surface.SetDrawColor(149,165,166)
							surface.DrawOutlinedRect(0,0,w,h)
						end
						box2:SetPos(0,pagepanel:GetVBar():GetScroll()+pagepanel:GetTall()/2-box2:GetTall()/2)
						box2:CenterHorizontal()
						local close = vgui.Create("DImageButton",box2)
						close:SetSize(15,15)
						close:SetImage("icon16/cross.png")
						close:SetPos(box2:GetWide()-close:GetWide()-10,10)
						function close:DoClick()
							box2:Remove()
							box:SetVisible(true)
						end
						local lbl = vgui.Create("DLabel",box2)
						lbl:SetText("Are you sure?")
						lbl:SetFont("buttonFont")
						lbl:SetColor(Color(52,73,94))
						lbl:SizeToContents()
						lbl:SetPos(0,10)
						lbl:CenterHorizontal()
						local lbl = vgui.Create("DLabel",box2)
						lbl:SetText("Are you sure you want to delete your clan?")
						lbl:SetFont("buttonFont3")
						lbl:SetColor(Color(52,73,94))
						lbl:SizeToContents()
						lbl:SetPos(0,40)
						lbl:CenterHorizontal()
						local lbl = vgui.Create("DLabel",box2)
						lbl:SetText("This cannot be undone and you and its members will not be refunded!")
						lbl:SetFont("buttonFont3")
						lbl:SetColor(Color(52,73,94))
						lbl:SizeToContents()
						lbl:SetPos(0,55)
						lbl:CenterHorizontal()
						local yes = vgui.Create("DButton",box2)
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
							net.Start("nyeblock_deleteClan")
							net.SendToServer()
							net.Receive("nyeblock_successfullyDeletedClan",function()
								NYEBLOCK.FUNCTIONS.createPopup("You have successfully deleted your clan!",1)
								pagepanel:Clear()
								pagepanel:SetAlpha(0)
								clans()
							end)
						end
						local no = vgui.Create("DButton",box2)
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
							box2:Remove()
							box:SetVisible(true)
						end
					end
					net.Receive("nyeblock_returnClanData",function()
						local success = net.ReadBool()

						if success then
							clanData = net.ReadTable()
							update:SetEnabled(true)
							layoutData()
						else
							pagepanel:Clear()
							pagepanel:SetAlpha(0)
							clans()
						end
					end)
				end
			end
		end
	end
	local clanLayout = vgui.Create("DIconLayout",pagepanel)
	clanLayout:SetWide(pagepanel:GetWide()-40)
	clanLayout:SetSpaceX(10)
	clanLayout:SetSpaceY(10)
	center(clanLayout,60)
	local lbl = clanLayout:Add("DLabel")
	lbl:SetSize(clanLayout:GetWide(),25)
	lbl:SetContentAlignment(5)
	lbl:SetText("Loading...")
	lbl:SetColor(Color(52,73,94))
	lbl:SetFont("roboto_15")
	net.Start("nyeblock_getClans")
	net.SendToServer()
	net.Receive("nyeblock_returnClans",function()
		clanData = net.ReadTable()
		
		if #table.GetKeys(clanData) > 0 then
			clanLayout:Clear()
			for k,v in pairs(clanData) do
				local pnl = clanLayout:Add("DPanel")
				pnl:SetSize(196,65)
				function pnl:Paint(w,h)
					draw.RoundedBox(0,0,0,w,h,Color(236,240,241))
					surface.SetDrawColor(149,165,166)
					surface.DrawOutlinedRect(0,0,w,h)
				end
				local name = vgui.Create("DLabel",pnl)
				name:SetSize(pnl:GetWide()-10,30)
				name:SetPos(0,5)
				name:CenterHorizontal()
				name:SetText(v.tagData.tag)
				name:SetColor(string.ToColor(v.tagData.color))
				name:SetFont("roboto_25")
				name:SetContentAlignment(5)
				if tagData != nil then
					if v.clanData.id == tagData.clanId then
						local img = vgui.Create("DImage",pnl)
						img:SetImage("icon16/tick.png")
						img:SetSize(16,16)
						img:SetPos(pnl:GetWide()-img:GetWide()-5,5)
					end
				end
				local option = vgui.Create("DPanel",pnl)
				option:SetWide(pnl:GetWide())
				option:SetPos(0,32)
				function option:Paint() end
				local innerOptionPanel = vgui.Create("DPanel",option)
				function innerOptionPanel:Paint() end
				local img = vgui.Create("DImage",innerOptionPanel)
				img:SetImage("icon16/group.png")
				img:SetSize(16,16)
				img:CenterVertical()
				local lbl = vgui.Create("DLabel",innerOptionPanel)
				lbl:SetText(v.clanData.memberCount.."/5 Members")
				lbl:SetFont("roboto_15")
				lbl:SetColor(Color(52,73,94))
				lbl:SizeToContents()
				lbl:SetPos(img.x+img:GetWide()+5,0)
				lbl:CenterVertical()
				innerOptionPanel:SizeToChildren(true,true)
				innerOptionPanel:Center()
				option:SizeToChildren(false,true)
				if v.clanData.password then
					local option = vgui.Create("DPanel",pnl)
					option:SetWide(pnl:GetWide())
					option:SetPos(0,52)
					function option:Paint() end
					local innerOptionPanel = vgui.Create("DPanel",option)
					function innerOptionPanel:Paint() end
					local img = vgui.Create("DImage",innerOptionPanel)
					img:SetImage("icon16/lock.png")
					img:SetSize(16,16)
					img:CenterVertical()
					local lbl = vgui.Create("DLabel",innerOptionPanel)
					lbl:SetText("Password Protected")
					lbl:SetFont("roboto_15")
					lbl:SetColor(Color(52,73,94))
					lbl:SizeToContents()
					lbl:SetPos(img.x+img:GetWide()+5,0)
					lbl:CenterVertical()
					innerOptionPanel:SizeToChildren(true,true)
					innerOptionPanel:Center()
					option:SizeToChildren(false,true)
				else
					local option = vgui.Create("DPanel",pnl)
					option:SetWide(pnl:GetWide())
					option:SetPos(0,52)
					function option:Paint() end
					local innerOptionPanel = vgui.Create("DPanel",option)
					function innerOptionPanel:Paint() end
					local img = vgui.Create("DImage",innerOptionPanel)
					img:SetImage("icon16/lock_open.png")
					img:SetSize(16,16)
					img:CenterVertical()
					local lbl = vgui.Create("DLabel",innerOptionPanel)
					lbl:SetText("Open")
					lbl:SetFont("roboto_15")
					lbl:SetColor(Color(52,73,94))
					lbl:SizeToContents()
					lbl:SetPos(img.x+img:GetWide()+5,0)
					lbl:CenterVertical()
					innerOptionPanel:SizeToChildren(true,true)
					innerOptionPanel:Center()
					option:SizeToChildren(false,true)
				end
				pnl:SizeToChildren(false,true)
				pnl:SetHeight(pnl:GetTall()+15)
				local buttonClick = vgui.Create("DButton",pnl)
				buttonClick:SetSize(pnl:GetWide(),pnl:GetTall())
				buttonClick:SetText("")
				function buttonClick:Paint() end
				function buttonClick:DoClick()
					buttonClick:SetEnabled(false)
				
					local box = vgui.Create("DPanel",pagepanel)
					box:SetSize(400,370)
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
						buttonClick:SetEnabled(true)
					end
					local lbl = vgui.Create("DLabel",box)
					lbl:SetText("Clan Info")
					lbl:SetFont("roboto_25")
					lbl:SetColor(Color(52,73,94))
					lbl:SizeToContents()
					lbl:SetPos(0,10)
					lbl:CenterHorizontal()
					local lbl = vgui.Create("DLabel",box)
					lbl:SetText("Name")
					lbl:SetFont("roboto_15")
					lbl:SetColor(Color(52,73,94))
					lbl:SizeToContents()
					lbl:SetPos(0,40)
					lbl:CenterHorizontal()
					local lbl = vgui.Create("DLabel",box)
					lbl:SetSize(box:GetWide(),30)
					lbl:SetPos(0,50)
					lbl:SetContentAlignment(5)
					lbl:SetText(v.tagData.tag)
					lbl:SetFont("roboto_15")
					lbl:SetColor(string.ToColor(v.tagData.color))
					local lbl = vgui.Create("DLabel",box)
					lbl:SetText("Members")
					lbl:SetFont("roboto_15")
					lbl:SetColor(Color(52,73,94))
					lbl:SizeToContents()
					lbl:SetPos(0,80)
					lbl:CenterHorizontal()
					local lbl = vgui.Create("DLabel",box)
					lbl:SetText(5-v.clanData.memberCount.." member spots available")
					lbl:SetFont("roboto_15")
					lbl:SetColor(Color(52,73,94))
					lbl:SizeToContents()
					lbl:SetPos(0,95)
					lbl:CenterHorizontal()
					local lbl = vgui.Create("DLabel",box)
					lbl:SetText("Clan Expires")
					lbl:SetFont("roboto_15")
					lbl:SetColor(Color(52,73,94))
					lbl:SizeToContents()
					lbl:SetPos(0,120)
					lbl:CenterHorizontal()
					local lbl = vgui.Create("DLabel",box)
					lbl:SetText("")
					lbl:SetFont("roboto_15")
					lbl:SetColor(Color(52,73,94))
					if v.tagData.length != 0 then
						local hasExpired = false

						function lbl:Think()
							local diff = (v.tagData.length + v.tagData.created) - os.time()

							if diff > 0 then
								lbl:SetText(secondsToDhms(diff))
								lbl:SizeToContents()
								lbl:SetPos(0,135)
								lbl:CenterHorizontal()
							else
								if !hasExpired then
									hasExpired = true
									net.Start("nyeblock_checkClanExpired")
										net.WriteString(v.tagData.id)
									net.SendToServer()
									net.Receive("nyeblock_returnClanExpired",function()
										pagepanel:Clear()
										pagepanel:SetAlpha(0)
										clans()
									end)
								end
							end
						end
					else
						lbl:SetText("Never")
						lbl:SizeToContents()
						lbl:SetPos(0,135)
						lbl:CenterHorizontal()
					end
					local lbl = vgui.Create("DLabel",box)
					lbl:SetText("Message")
					lbl:SetFont("roboto_15")
					lbl:SetColor(Color(52,73,94))
					lbl:SizeToContents()
					lbl:SetPos(0,160)
					lbl:CenterHorizontal()
					local messageScroll = vgui.Create("DScrollPanel",box)
					messageScroll:SetSize(box:GetWide()-20,80)
					messageScroll:SetPos(0,180)
					messageScroll:CenterHorizontal()
					local lbl = vgui.Create("DLabel",messageScroll)
					lbl:SetWide(messageScroll:GetWide())
					lbl:SetPos(0,2)
					lbl:SetAutoStretchVertical(true)
					lbl:SetWrap(true)
					lbl:SetText(v.clanData.message)
					lbl:SetFont("roboto_15")
					lbl:SetColor(Color(52,73,94))
					if !LocalPlayer():GetNWBool("nyeblock_inClan",false) then
						if !LocalPlayer():GetNWBool("nyeblock_hasClan",false) then
							local lbl = vgui.Create("DLabel",box)
							lbl:SetText("When the clan expires your tag will be removed and no refunds!")
							lbl:SetFont("roboto_15")
							lbl:SetColor(Color(52,73,94))
							lbl:SizeToContents()
							lbl:SetPos(0,275)
							lbl:CenterHorizontal()
							local lbl = vgui.Create("DLabel",box)
							lbl:SetText("Price to join clan: "..string.Comma(NYEBLOCK.CLAN_JOIN_PRICE).." points")
							lbl:SetFont("roboto_15")
							lbl:SetColor(Color(52,73,94))
							lbl:SizeToContents()
							lbl:SetPos(0,290)
							lbl:CenterHorizontal()
							local join = vgui.Create("DButton",box)
							join:SetSize(100,30)
							join:SetPos(0,320)
							join:CenterHorizontal()
							join:SetText("Join")
							join:SetFont("roboto_15")
							join:SetColor(Color(52,73,94))
							function join:Paint(w,h)
								draw.RoundedBox(0,0,0,w,h,Color(236,240,241))
								surface.SetDrawColor(149,165,166)
								surface.DrawOutlinedRect(0,0,w,h)
							end
							function join:DoClick()
								join:SetEnabled(false)

								if LocalPlayer():GetNWInt("nyeblock_userId") == v.clanData.userId then
									NYEBLOCK.FUNCTIONS.createPopup("You cannot join your own clan!",2)
								elseif !LocalPlayer():PS_HasPoints(NYEBLOCK.CLAN_JOIN_PRICE) then
									NYEBLOCK.FUNCTIONS.createPopup("You do not have enough points!",2)
								elseif 5-v.clanData.memberCount == 0 then
									NYEBLOCK.FUNCTIONS.createPopup("There are no member slots available!",2)
								elseif LocalPlayer():GetNWBool("nyeblock_hasTag",false) then
									NYEBLOCK.FUNCTIONS.createPopup("You already have a tag! Please remove it before joining a clan.",2)
								else
									if v.clanData.password then
										box:SetVisible(false)

										local box2 = vgui.Create("DPanel",pagepanel)
										box2:SetSize(400,145)
										center(box2,pagepanel:GetTall()/2-box2:GetTall()/2)
										function box2:Paint(w,h)
											draw.RoundedBox(0,0,0,w,h,Color(236,240,241))
											surface.SetDrawColor(149,165,166)
											surface.DrawOutlinedRect(0,0,w,h)
										end
										box2:SetPos(0,pagepanel:GetVBar():GetScroll()+pagepanel:GetTall()/2-box2:GetTall()/2)
										box2:CenterHorizontal()
										local close = vgui.Create("DImageButton",box2)
										close:SetSize(15,15)
										close:SetImage("icon16/cross.png")
										close:SetPos(box2:GetWide()-close:GetWide()-10,10)
										function close:DoClick()
											box2:Remove()
											box:SetVisible(true)
											join:SetEnabled(true)
										end
										local lbl = vgui.Create("DLabel",box2)
										lbl:SetText("Whats the clan password?")
										lbl:SetFont("buttonFont")
										lbl:SetColor(Color(52,73,94))
										lbl:SizeToContents()
										lbl:SetPos(0,10)
										lbl:CenterHorizontal()
										local password = vgui.Create("DTextEntry",box2)
										password:SetSize(150,25)
										password:SetPos(0,50)
										password:CenterHorizontal()
										local submit = vgui.Create("DButton",box2)
										submit:SetSize(100,30)
										submit:SetPos(0,95)
										submit:CenterHorizontal()
										submit:SetText("Submit")
										submit:SetFont("playerCount")
										submit:SetColor(Color(52,73,94))
										function submit:Paint(w,h)
											draw.RoundedBox(0,0,0,w,h,Color(236,240,241))
											surface.SetDrawColor(149,165,166)
											surface.DrawOutlinedRect(0,0,w,h)
										end
										function submit:DoClick()
											submit:SetEnabled(false)
											local tbl = {
												clanId = v.clanData.id,
												tagId = v.tagData.id,
												password = password:GetValue()
											}

											net.Start("nyeblock_joinClan")
												net.WriteTable(tbl)
												net.WriteBool(true)
											net.SendToServer()
											net.Receive("nyeblock_returnJoinClanInfo",function()
												local success = net.ReadBool()
												local message = net.ReadString()

												if success then
													NYEBLOCK.FUNCTIONS.createPopup(message,1)
													local data = net.ReadTable()
													tagData = data
													pagepanel:Clear()
													pagepanel:SetAlpha(0)
													clans()
												else
													NYEBLOCK.FUNCTIONS.createPopup(message,2)
													submit:SetEnabled(true)
												end
											end)
										end
									else
										local tbl = {
											clanId = v.clanData.id,
											tagId = v.tagData.id
										}

										net.Start("nyeblock_joinClan")
											net.WriteTable(tbl)
											net.WriteBool(false)
										net.SendToServer()
										net.Receive("nyeblock_returnJoinClanInfo",function()
											local success = net.ReadBool()
											local message = net.ReadString()

											if success then
												NYEBLOCK.FUNCTIONS.createPopup(message,1)
												local data = net.ReadTable()
												tagData = data
												pagepanel:Clear()
												pagepanel:SetAlpha(0)
												clans()
											else
												NYEBLOCK.FUNCTIONS.createPopup(message,2)
												join:SetEnabled(true)
											end
										end)
									end
								end
							end
						else
							box:SetHeight(280)
						end
					else
						if v.clanData.id == tagData.clanId then
							box:SetHeight(325)

							local leave = vgui.Create("DButton",box)
							leave:SetSize(100,30)
							leave:SetPos(0,275)
							leave:CenterHorizontal()
							leave:SetText("Leave clan")
							leave:SetFont("roboto_15")
							leave:SetColor(Color(52,73,94))
							function leave:Paint(w,h)
								draw.RoundedBox(0,0,0,w,h,Color(236,240,241))
								surface.SetDrawColor(149,165,166)
								surface.DrawOutlinedRect(0,0,w,h)
							end
							function leave:DoClick()
								box:SetVisible(false)

								local box2 = vgui.Create("DPanel",pagepanel)
								box2:SetSize(400,120)
								center(box2,pagepanel:GetTall()/2-box:GetTall()/2)
								function box2:Paint(w,h)
									draw.RoundedBox(0,0,0,w,h,Color(236,240,241))
									surface.SetDrawColor(149,165,166)
									surface.DrawOutlinedRect(0,0,w,h)
								end
								box2:SetPos(0,pagepanel:GetVBar():GetScroll()+pagepanel:GetTall()/2-box2:GetTall()/2)
								box2:CenterHorizontal()
								local close = vgui.Create("DImageButton",box2)
								close:SetSize(15,15)
								close:SetImage("icon16/cross.png")
								close:SetPos(box2:GetWide()-close:GetWide()-10,10)
								function close:DoClick()
									box2:Remove()
									box:SetVisible(true)
								end
								local lbl = vgui.Create("DLabel",box2)
								lbl:SetText("Are you sure?")
								lbl:SetFont("buttonFont")
								lbl:SetColor(Color(52,73,94))
								lbl:SizeToContents()
								lbl:SetPos(0,10)
								lbl:CenterHorizontal()
								local lbl = vgui.Create("DLabel",box2)
								lbl:SetText("Are you sure you want to leave your clan?")
								lbl:SetFont("buttonFont3")
								lbl:SetColor(Color(52,73,94))
								lbl:SizeToContents()
								lbl:SetPos(0,40)
								lbl:CenterHorizontal()
								local lbl = vgui.Create("DLabel",box2)
								lbl:SetText("This cannot be undone and you will not be refunded!")
								lbl:SetFont("buttonFont3")
								lbl:SetColor(Color(52,73,94))
								lbl:SizeToContents()
								lbl:SetPos(0,55)
								lbl:CenterHorizontal()
								local yes = vgui.Create("DButton",box2)
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
									net.Start("nyeblock_leaveClan")
									net.SendToServer()
									net.Receive("nyeblock_returnLeaveClanInfo",function()
										local success = net.ReadBool()

										if success then
											NYEBLOCK.FUNCTIONS.createPopup("You have successfully left your clan!",1)
											tagData = nil
											pagepanel:Clear()
											pagepanel:SetAlpha(0)
											clans()
										else
											local message = net.ReadString()

											NYEBLOCK.FUNCTIONS.createPopup(message,2)
											pagepanel:Clear()
											pagepanel:SetAlpha(0)
											clans()
										end
									end)
								end
								local no = vgui.Create("DButton",box2)
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
									box2:Remove()
									box:SetVisible(true)
								end
							end
						else
							box:SetHeight(280)
						end
					end
				end
			end
		else
			clanLayout:Clear()
			local lbl = clanLayout:Add("DLabel")
			lbl:SetSize(clanLayout:GetWide(),25)
			lbl:SetContentAlignment(5)
			lbl:SetText("There are no active clans!")
			lbl:SetColor(Color(52,73,94))
			lbl:SetFont("roboto_15")
		end
	end)
end

net.Receive("tagSystem_panel",function()
	local data = net.ReadTable()
	if data.tag != nil then
		tagData = data
	else
		if tagData != nil then
			net.Start("nyeblock_resetTagNWStrings")
			net.SendToServer()
			tagData = nil
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
	lbl:SetText("Custom Tag System")
	lbl:SetFont("oswald_30")
	lbl:SetColor(Color(52,73,94))
	lbl:SizeToContents()
	lbl:SetPos(95,0)
	lbl:CenterVertical()
	headerButtons[1] = vgui.Create("DButton",header)
	headerButtons[1]:SetSize(160,header:GetTall())
	headerButtons[1]:SetPos(260,0)
	headerButtons[1]:SetText("My Tag")
	headerButtons[1]:SetFont("buttonFont")
	headerButtons[1]:SetColor(Color(52,73,94))
	headerButtons[1].Paint = function(_,w,h)
		draw.RoundedBox(0,0,0,w,h,Color(189,195,199))
		surface.SetDrawColor(149,165,166)
		surface.DrawOutlinedRect(0,0,w,h)
	end
	headerButtons[1].DoClick = function()
		pagepanel:Clear()
		pagepanel:SetAlpha(0)
		myTag()
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
	headerButtons[2] = vgui.Create("DButton",header)
	headerButtons[2]:SetSize(160,header:GetTall())
	headerButtons[2]:SetPos(420,0)
	headerButtons[2]:SetText("Clans")
	headerButtons[2]:SetFont("buttonFont")
	headerButtons[2]:SetColor(Color(52,73,94))
	headerButtons[2].Paint = function(_,w,h)
		draw.RoundedBox(0,0,0,w,h,Color(236,240,241))
		surface.SetDrawColor(149,165,166)
		surface.DrawOutlinedRect(0,0,w,h)
	end
	headerButtons[2].DoClick = function()
		pagepanel:Clear()
		pagepanel:SetAlpha(0)
		clans()
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

	pagepanel = vgui.Create("DScrollPanel",panel)
	pagepanel:SetSize(panel:GetWide()-40,455)
	pagepanel:SetPos(20,125)
	function pagepanel:Paint(w,h)
		draw.RoundedBox(0,0,0,w,h,Color(236,240,241))
		surface.SetDrawColor(149,165,166)
		surface.DrawOutlinedRect(0,0,w,h)
	end

	myTag()
end)