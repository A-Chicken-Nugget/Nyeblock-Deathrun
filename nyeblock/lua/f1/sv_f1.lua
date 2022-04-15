util.AddNetworkString("nyeblock_f1Menu")

hook.Add("ShowHelp","openF1",function(ply)
	net.Start("nyeblock_f1Menu")
	net.Send(ply)
end)