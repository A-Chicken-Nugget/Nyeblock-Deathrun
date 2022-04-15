util.AddNetworkString("nyeblock_roundPopup")

concommand.Add("test_popup",function(ply)
    net.Start("nyeblock_roundPopup")
        net.WriteString("runner")
    net.Send(ply)
end)

-- hook.Add("OnRoundSet","displayPopup",function(round,winner)
--     if round == ROUND_ENDING then
--         net.Start("nyeblock_roundPopup")
--         if winner == TEAM_RUNNER then
--             net.WriteString("runner")
--         end
--         if winner == TEAM_DEATH then
--             net.WriteString("death")
--         end
--         if winner == 123 then
--             net.WriteString("nobody")
--         end
--         net.Send(player.GetAll())
--     end
-- end)