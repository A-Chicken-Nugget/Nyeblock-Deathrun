//Receive profile and update global var
net.Receive("nyeblock_setProfile",function()
	local profile = net.ReadTable()
	NYEBLOCK.PROFILE = profile[1]
end)