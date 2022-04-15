util.AddNetworkString("nyeblock_getProfileData")
util.AddNetworkString("nyeblock_returnProfileData")
util.AddNetworkString("nyeblock_viewProfile")

net.Receive("nyeblock_getProfileData",function(_,ply)
    local userId = net.ReadString()

    net.Start("nyeblock_viewProfile")
    net.Send(ply)
    if userId != "nil" then
        userId = tonumber(userId)
        
        local qs = [[
            SELECT *
            FROM nyeblock_users
            WHERE id = %i
        ]]
        NYEBLOCK.DATABASES.NB_QUERY("nyeblock",string.format(qs,userId),function(userData)
            if table.Count(userData) > 0 then
                local queries = {
                    string.format([[
                        SELECT tag, color
                        FROM nyeblock_tags
                        WHERE userId = %i
                    ]],userId),
                    string.format([[
                        SELECT MIN(timestamp) as firstJoin, MAX(timestamp) as lastJoin
                        FROM nyeblock_joinLogs
                        WHERE userId = %i
                    ]],userId)
                }

                if userData[1].uniqueId != nil then
                    table.insert(queries,string.format([[
                        SELECT points
                        FROM pointshop_data
                        WHERE uniqueid = %i
                    ]],userData[1].uniqueId))
                end
                NYEBLOCK.DATABASES.NB_MULTI_QUERY("nyeblock",queries,function(data)
                    local level = util.GetPData(util.SteamIDFrom64(userData[1].steamid64),"xp",-1)
                    local prestige = util.GetPData(util.SteamIDFrom64(userData[1].steamid64),"prestige",0)
                    local hoursPlayedFile = "timekeeper_users/"..string.gsub(util.SteamIDFrom64(userData[1].steamid64), ":","_")..".txt"
                    local hoursPlayed = 0

                    if level == -1 then
                        level = 1
                    else
                        level = levels.LevelFromXP(level)
                    end
            
                    if file.Exists( hoursPlayedFile, "DATA" ) then
                        hoursPlayed = math.Round(util.JSONToTable( file.Read( hoursPlayedFile, "DATA" ))["server_hours"])
                    end

                    local tbl = {
                        tagData = data[1][1],
                        joinData = {
                            firstJoin = data[2][1].firstJoin,
                            lastJoin = data[2][1].lastJoin
                        },
                        points = data[3][1] != nil and data[3][1].points or nil,
                        hoursPlayed = hoursPlayed,
                        profileData = userData[1],
                        levelData = {
                            level = level,
                            prestige = prestige
                        },
                        displayPoints = userData[1].displayPoints,
                        displayPlayTime = userData[1].displayPlayTime
                    }

                    net.Start("nyeblock_returnProfileData")
                        net.WriteBool(true)
                        net.WriteTable(tbl)
                    net.Send(ply)
                end)
            end
        end)
    else
        net.Start("nyeblock_returnProfileData")
            net.WriteBool(false)
        net.Send(ply)
    end
end)