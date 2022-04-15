local PANEL = {}

function PANEL:Init()
	local pnl = self

	self:Center()
	self.close = vgui.Create("DImageButton",self)
	self.close:SetSize(15,15)
	self.close:SetImage("icon16/cross.png")
	self.close:SetPos(self:GetWide()-self.close:GetWide()-10,10)
	function self.close:DoClick()
		pnl:Remove()
	end
	self.title = vgui.Create("DLabel",self)
	self.title:SetText("New Modal")
	self.title:SetFont("roboto_25")
	self.title:SetColor(Color(52,73,94))
	self.title:SizeToContents()
	self.title:SetPos(0,10)
	self.title:CenterHorizontal()
	self.header = vgui.Create("DLabel",self)
	self.header:SetText("Header Text")
	self.header:SetFont("roboto_15")
	self.header:SetColor(Color(52,73,94))
	self.header:SizeToContents()
	self.header:SetPos(0,40)
	self.header:CenterHorizontal()
end

function PANEL:PerformLayout()
	self.close:SetPos(self:GetWide()-self.close:GetWide()-10,10)
	self.title:SizeToContents()
	self.title:SetPos(0,10)
	self.title:CenterHorizontal()
	if IsValid(self.header) then
		self.header:SizeToContents()
		self.header:SetPos(0,40)
		self.header:CenterHorizontal()
	end
end

function PANEL:SetTitle(title)
	self.title:SetText(title)
end

function PANEL:SetHeader(text)
	if text == nil then
		self.header:Remove()
	else
		self.header:SetText(text)
	end
end

function PANEL:Paint(w,h)
	draw.RoundedBox(0,0,0,w,h,Color(236,240,241))
	surface.SetDrawColor(149,165,166)
	surface.DrawOutlinedRect(0,0,w,h)
	return true
end

vgui.Register("ModalPanel",PANEL,"DPanel")