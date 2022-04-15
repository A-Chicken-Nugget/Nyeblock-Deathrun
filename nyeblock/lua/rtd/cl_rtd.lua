net.Receive("nyeblock_rtdPrintAll",function()
	local message = net.ReadString()
	
	chat.AddText(Color(60,244,255),"[RTD] ",Color(79,123,122),message)
end)
net.Receive("nyeblock_rtdRandomTaunt",function()
	local taunt = net.ReadString()

	if GetConVar("nyeblock_unmuteRTD"):GetBool() then
		surface.PlaySound(taunt)
	end
end)
net.Receive("nyeblock_rtdBlind",function()
	local duration = tonumber(net.ReadString())
	local timestamp = os.time()

	local panel = vgui.Create("DPanel")
	panel:SetSize(ScrW(),ScrH())
	function panel:Paint(w,h)
		draw.RoundedBox(0,0,0,w,h,Color(0,0,0))
	end
	local lbl = vgui.Create("DLabel",panel)
	lbl:SetText("You are blinded! You will be able to see again in "..duration.." seconds.")
	lbl:SetColor(Color(255,255,255))
	lbl:SetFont("DermaLarge")
	lbl:SizeToContents()
	lbl:SetPos(0,10)
	lbl:CenterHorizontal()
	function lbl:Think()
		lbl:SetText("You are blinded! You will be able to see again in "..(duration-(os.time()-timestamp)).." seconds.")
		lbl:SizeToContents()
		lbl:CenterHorizontal()
	end
	timer.Simple(duration,function()
		panel:Remove()
	end)
end)