//
// Return if usergroup is a staff usergroup
//
function NYEBLOCK.FUNCTIONS.isStaff(group)
	if table.HasValue(NYEBLOCK.STAFFGROUPS,group) then
		return true
	else
		return false
	end
end
//
// Return name of ulx group passed in
//
function NYEBLOCK.FUNCTIONS.getUlxGroupName(group)
	if group == "vipmod" then
		return "VIP Moderator"
	elseif group == "donatormod" then
		return "Donator Moderator"
	elseif group == "superadmin" then
		return "Super Admin"
	elseif group == "jukeboxervip" then
		return "VIP Jukeboxer"
	elseif group == "jukeboxerdonator" then
		return "Donator Jukeboxer"
	elseif group == "user" then
		return "User"
	elseif group == "vip" then
		return "VIP"
	elseif group == "donator" then
		return "Donator"
	elseif group == "jukeboxer" then
		return "Jukeboxer"
	else
		return group
	end
end
//
// Return if the given ulx group is a vip group
//
function NYEBLOCK.FUNCTIONS.isUlxGroupVIP(group)
	local groups = {"vip","vipmod","jukeboxervip"}
	if table.HasValue(groups,group) then
		return true
	else
		return false
	end
end
//
// Return color for the given ulx group
//
function NYEBLOCK.FUNCTIONS.getUlxGroupColor(group)
	if group == "superadmin" then
		return Color(255,100,0)
	elseif table.HasValue({"donatormod","Moderator"},group) then
		return Color(143,138,138)
	elseif table.HasValue({"jukeboxer","jukeboxerdonator"},group) then
		return Color(170,244,66)
	elseif group == "donator" then
		return Color(233,246,9)
	else
		return Color(255,255,255)
	end
end
//
// Create popup with specified text / type
//
local popupTimeoutActive = false
function NYEBLOCK.FUNCTIONS.createPopup(text,type)
	if !popupTimeoutActive then
		local popup = vgui.Create("DPanel")
		local lbl = vgui.Create("DLabel",popup)
		lbl:SetText(text)
		lbl:SetFont("buttonFont")
		lbl:SizeToContents()
		popup:SetSize(lbl:GetWide()+80,40)
		popup:SetPos(ScrW()/2-popup:GetWide()/2,ScrH())
		popup:MoveTo(ScrW()/2-popup:GetWide()/2,ScrH()-popup:GetTall()-5,.5,0,1)
		lbl:SetColor(Color(52,73,94))
		lbl:Center()
		function popup:Think()
			popup:MoveToFront()
		end
		function popup:Paint(w,h)
			draw.RoundedBox(0,0,0,w,h,Color(236,240,241))
			surface.SetDrawColor(149,165,166)
			surface.DrawOutlinedRect(0,0,w,h)
		end
		local icon = vgui.Create("DImage",popup)
		if type == 1 then
			icon:SetImage("icon16/tick.png")
		elseif type == 2 then
			icon:SetImage("icon16/error.png")
		elseif type == 3 then
			icon:SetImage("icon16/cross.png")
		end
		icon:SetSize(15,15)
		icon:SetPos(15,13)
		timer.Simple(5,function()
			popup:MoveTo(ScrW()/2-popup:GetWide()/2,ScrH(),.5,0,1)
			timer.Simple(2,function()
				popup:Remove()
			end)
		end)
		popupTimeoutActive = true
		timer.Simple(2,function()
			popupTimeoutActive = false
		end)
	end
end