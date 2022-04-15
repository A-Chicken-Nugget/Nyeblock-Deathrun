util.AddNetworkString("nyeblock_hintPopup")

hook.Add("PlayerInitialSpawn","startHintPopup",function(ply)
	net.Start("nyeblock_hintPopup")
	net.Send(ply)
end)