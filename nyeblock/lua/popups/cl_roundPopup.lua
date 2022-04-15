surface.CreateFont("coolvetica_30",{font="coolvetica",size=30,weight=500})

net.Receive("nyeblock_roundPopup",function()
	local roundWinner = net.ReadString()

	if roundWinner == "runner" then
		local panel = vgui.Create("DPanel")
		panel:SetSize(350,300)
		panel:Center()
		panel:SetAlpha(0)
		function panel:Paint() end
		function panel:Think()
			panel:Center()
		end
		local icon = vgui.Create("DImage",panel)
		icon:SetImage("materials/winpics/runnerswin.png")
		icon:SetSize(275,233)
		icon:CenterVertical(0.4)
		icon:CenterHorizontal()
		function icon:Think()
			icon:CenterVertical(0.4)
			icon:CenterHorizontal()
		end
		local lbl = vgui.Create("DLabel",panel)
		lbl:SetText(LocalPlayer():Team() == 1 and "You have won the round!" or "The Runner have won the round!")
		lbl:SetFont("coolvetica_30")
		lbl:SetColor(Color(255,255,255))
		lbl:SizeToContents()
		lbl:SetPos(0,icon.y+icon:GetTall()+10)
		lbl:CenterHorizontal()
		function lbl:Think()
			lbl:SetPos(0,icon.y+icon:GetTall()+10)
			lbl:CenterHorizontal()
		end
		panel:SetSize(0,0)
		panel:AlphaTo(255,.5,0)
		panel:SizeTo(350,300,.5,0,1)

		timer.Simple(3,function()
			panel:Remove()
		end)
	end
end)