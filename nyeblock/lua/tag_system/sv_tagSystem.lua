local meta = FindMetaTable("Player")

util.AddNetworkString("tagSystem_panel")
util.AddNetworkString("nyeblock_createTag")
util.AddNetworkString("nyeblock_removeTag")
util.AddNetworkString("nyeblock_returnRemoveTag")
util.AddNetworkString("nyeblock_returnTagInfo")
util.AddNetworkString("nyeblock_createClan")
util.AddNetworkString("nyeblock_returnCreateClanInfo")
util.AddNetworkString("nyeblock_getClans")
util.AddNetworkString("nyeblock_returnClans")
util.AddNetworkString("nyeblock_joinClan")
util.AddNetworkString("nyeblock_returnJoinClanInfo")
util.AddNetworkString("nyeblock_getClanData")
util.AddNetworkString("nyeblock_returnClanData")
util.AddNetworkString("nyeblock_removeClanMember")
util.AddNetworkString("nyeblock_leaveClan")
util.AddNetworkString("nyeblock_returnLeaveClanInfo")
util.AddNetworkString("nyeblock_updateClanInfo")
util.AddNetworkString("nyeblock_deleteClan")
util.AddNetworkString("nyeblock_successfullyDeletedClan")
util.AddNetworkString("nyeblock_resetTagNWStrings")
util.AddNetworkString("nyeblock_checkClanExpired")
util.AddNetworkString("nyeblock_returnClanExpired")


concommand.Add("tag_panel",function(ply)
	local queries = {
		string.format([[
			SELECT *
			FROM nyeblock_tags
			WHERE userId = %i
		]],ply:GetNWInt("nyeblock_userId")),
		string.format([[
			SELECT *
			FROM nyeblock_clans
			WHERE userId = %i
		]],ply:GetNWInt("nyeblock_userId"))
	}
	NYEBLOCK.DATABASES.NB_MULTI_QUERY("nyeblock",queries,function(data)
		if #data[1] > 0 then
			ply:SetNWBool("nyeblock_hasTag",true)
			ply:SetNWString("nyeblock_tag",util.TableToJSON(data[1][1]))
			if data[1][1].clanId != nil then
				ply:SetNWBool("nyeblock_inClan",true)
			else
				ply:SetNWBool("nyeblock_inClan",false)
			end
			if #data[2] > 0 then
				ply:SetNWBool("nyeblock_hasClan",true)
			else
				ply:SetNWBool("nyeblock_hasClan",false)
			end
			timer.Simple(.5,function()
				net.Start("tagSystem_panel")
					net.WriteTable(data[1][1])
				net.Send(ply)
			end)
		else
			ply:SetNWBool("nyeblock_hasTag",false)
			timer.Simple(.5,function()
				net.Start("tagSystem_panel")
					net.WriteTable({})
				net.Send(ply)
			end)
		end
	end)

	local qs = [[
		SELECT *
		FROM nyeblock_tags
		WHERE userId = %i
	]]
	NYEBLOCK.DATABASES.NB_QUERY("nyeblock",string.format(qs,ply:GetNWInt("nyeblock_userId")),function(exists)
		if #exists > 0 then
			net.Start("tagSystem_panel")
				net.WriteTable(exists[1])
			net.Send(ply)
			ply:SetNWBool("nyeblock_hasTag",true)
			ply:SetNWString("nyeblock_tag",util.TableToJSON(exists[1]))
			if exists[1].clanId != nil then
				ply:SetNWBool("nyeblock_inClan",true)
			end
		else
			net.Start("tagSystem_panel")
				net.WriteTable({})
			net.Send(ply)
			ply:SetNWBool("nyeblock_hasTag",false)
			ply:SetNWString("nyeblock_tag","")
			ply:SetNWBool("nyeblock_inClan",false)
		end
	end)
end)

net.Receive("nyeblock_createTag",function(_,ply)
	local data = net.ReadTable()

	local qs = [[
		SELECT *
		FROM nyeblock_tags
		WHERE tag = '%s'
	]]
	NYEBLOCK.DATABASES.NB_QUERY("nyeblock",string.format(qs,NYEBLOCK.DATABASES.NB:escape(data.tag)),function(exists)
		if #exists > 0 then
			net.Start("nyeblock_returnTagInfo")
				net.WriteBool(false)
				net.WriteString("The entered tag has already been used!")
			net.Send(ply)
		else
			if NYEBLOCK.TAG_LENGTH_PRICES[data.length] != nil then
				if ply:PS_HasPoints(NYEBLOCK.TAG_LENGTH_PRICES[data.length]) then
					local qs = [[
						SELECT *
						FROM nyeblock_tags
						WHERE userId = %i
					]]
					NYEBLOCK.DATABASES.NB_QUERY("nyeblock",string.format(qs,ply:GetNWInt("nyeblock_userId")),function(tag)
						if #tag == 0 then
							local length

							if data.length == "1 Week" then
								length = 604800
							elseif data.length == "1 Month" then
								length = 2592000
							elseif data.length == "6 Months" then
								length = 15552000
							elseif data.length == "1 Year" then
								length = 31536000
							elseif data.length == "Permanent" then
								length = 0
							end
							local qs = [[
								INSERT INTO nyeblock_tags (userId,length,created,tag,color)
								VALUES (%i,%i,%i,'%s','%s')
							]]
							NYEBLOCK.DATABASES.NB_QUERY("nyeblock",string.format(qs,ply:GetNWInt("nyeblock_userId"),length,os.time(),NYEBLOCK.DATABASES.NB:escape(data.tag),NYEBLOCK.DATABASES.NB:escape(data.color)),function()
								ply:PS_TakePoints(NYEBLOCK.TAG_LENGTH_PRICES[data.length])
								ply:SetNWBool("nyeblock_hasTag",true)
								local qs = [[
									SELECT *
									FROM nyeblock_tags
									WHERE userId = %i
								]]
								NYEBLOCK.DATABASES.NB_QUERY("nyeblock",string.format(qs,ply:GetNWInt("nyeblock_userId")),function(tagData)
									ply:SetNWString("nyeblock_tag",util.TableToJSON(tagData[1]))
									net.Start("nyeblock_returnTagInfo")
										net.WriteBool(true)
										net.WriteTable(tagData[1])
									net.Send(ply)
								end)
							end)
						else
							net.Start("nyeblock_returnTagInfo")
								net.WriteBool(false)
								net.WriteString("You already have a tag! Please close and reopen this menu.")
							net.Send(ply)
						end
					end)
				end
			end
		end
	end)
end)
net.Receive("nyeblock_removeTag",function(_,ply)
	local qs = [[
		SELECT *
		FROM nyeblock_tags
		WHERE userId = %i
	]]
	NYEBLOCK.DATABASES.NB_QUERY("nyeblock",string.format(qs,ply:GetNWInt("nyeblock_userId")),function(tag)
		if #tag > 0 then
			local qs = [[
				DELETE
				FROM nyeblock_tags
				WHERE userId = %i
			]]
			NYEBLOCK.DATABASES.NB_QUERY("nyeblock",string.format(qs,ply:GetNWInt("nyeblock_userId")),function()
				ply:SetNWBool("nyeblock_hasTag",false)
				ply:SetNWString("nyeblock_tag","")
				ply:SetNWBool("nyeblock_inClan",false)
				ply:SetNWBool("nyeblock_hasClan",false)
				timer.Simple(.5,function()
					net.Start("nyeblock_returnRemoveTag")
						net.WriteBool(true)
					net.Send(ply)
				end)
			end)
		else
			net.Start("nyeblock_returnRemoveTag")
				net.WriteBool(false)
				net.WriteString("Unexpected error! Refreshing page.")
			net.Send(ply)
		end
	end)
end)
net.Receive("nyeblock_createClan",function(_,ply)
	if ply:PS_HasPoints(NYEBLOCK.CLAN_PRICE) then
		local data = net.ReadTable()

		local queries = {
			string.format([[
				SELECT *
				FROM nyeblock_tags
				WHERE userId = %i
			]],ply:GetNWInt("nyeblock_userId")),
			string.format([[
				SELECT *
				FROM nyeblock_clans
				WHERE userId = %i
			]],ply:GetNWInt("nyeblock_userId"))
		}
		NYEBLOCK.DATABASES.NB_MULTI_QUERY("nyeblock",queries,function(plyData)	
			if #plyData[2] == 0 then
				if data.password == "" then
					local qs = [[
						INSERT INTO nyeblock_clans (tagId,userId,created,message,memberCount)
						VALUES (%i,%i,%i,'%s',1)
					]]
					NYEBLOCK.DATABASES.NB_QUERY("nyeblock",string.format(qs,plyData[1][1].id,ply:GetNWInt("nyeblock_userId"),os.time(),NYEBLOCK.DATABASES.NB:escape(data.message)),function()
						ply:PS_TakePoints(NYEBLOCK.CLAN_PRICE)
						ply:SetNWBool("nyeblock_hasClan",true)
						ply:SetNWBool("nyeblock_inClan",true)
						timer.Simple(.5,function()
							net.Start("nyeblock_returnCreateClanInfo")
								net.WriteBool(true)
								net.WriteString("Clan successfully created!")
							net.Send(ply)
						end)
					end)
				else
					local qs = [[
						INSERT INTO nyeblock_clans (tagId,userId,password,created,message,memberCount)
						VALUES (%i,%i,'%s',%i,'%s',1)
					]]
					NYEBLOCK.DATABASES.NB_QUERY("nyeblock",string.format(qs,plyData[1][1].id,ply:GetNWInt("nyeblock_userId"),NYEBLOCK.DATABASES.NB:escape(data.password),os.time(),NYEBLOCK.DATABASES.NB:escape(data.message)),function()
						ply:SetNWBool("nyeblock_hasClan",true)
						ply:SetNWBool("nyeblock_inClan",true)
						timer.Simple(.5,function()
							net.Start("nyeblock_returnCreateClanInfo")
								net.WriteBool(true)
								net.WriteString("Clan successfully created!")
							net.Send(ply)
						end)
					end)
				end
			else
				net.Start("nyeblock_returnCreateClanInfo")
					net.WriteBool(false)
					net.WriteString("Unable to create clan! You are already in a clan!")
				net.Send(ply)
			end
		end)
	end
end)
net.Receive("nyeblock_getClans",function(_,ply)
	local qs = [[
		SELECT *
		FROM nyeblock_clans
	]]
	NYEBLOCK.DATABASES.NB_QUERY("nyeblock",qs,function(clans)
		if #clans > 0 then
			local returnData = {}
			local queries = {}

			for k,v in pairs(clans) do
				table.insert(queries,string.format([[
					SELECT *
					FROM nyeblock_tags
					WHERE id = %i 
				]],v.tagId))
				returnData[v.tagId] = {}
				returnData[v.tagId]["clanData"] = v
				if v.password != nil then
					returnData[v.tagId]["clanData"].password = true
				else
					returnData[v.tagId]["clanData"].password = false
				end
			end
			NYEBLOCK.DATABASES.NB_MULTI_QUERY("nyeblock",queries,function(tags)
				for k,v in pairs(tags) do
					local v = v[1]
					returnData[v.id]["tagData"] = v
				end
				net.Start("nyeblock_returnClans")
					net.WriteTable(returnData)
				net.Send(ply)
			end)
		else
			net.Start("nyeblock_returnClans")
				net.WriteTable({})
			net.Send(ply)
		end
	end)
end)
net.Receive("nyeblock_joinClan",function(_,ply)
	local clanData = net.ReadTable()
	local tryPassword = net.ReadBool()

	local queries = {
		string.format([[
			SELECT *
			FROM nyeblock_tags
			WHERE id = %i
		]],clanData.tagId),
		string.format([[
			SELECT *
			FROM nyeblock_clans
			WHERE id = %i
		]],clanData.clanId)
	}
	NYEBLOCK.DATABASES.NB_MULTI_QUERY("nyeblock",queries,function(data)
		if #data[1] > 0 then
			if data[2][1].memberCount < 5 then
				local canJoin = true
				local joinError = false

				if data[2][1].password != nil and !tryPassword then
					joinError = true
				end
				if tryPassword then
					if clanData.password != data[2][1].password then
						canJoin = false
					end
				end
				if !joinError then
					if canJoin then
						local qs = [[
							INSERT INTO nyeblock_tags (userId,length,created,tag,color,clanId)
							VALUES (%i,%i,%i,'%s','%s',%i)
						]]
						NYEBLOCK.DATABASES.NB_QUERY("nyeblock",string.format(qs,ply:GetNWInt("nyeblock_userId"),data[1][1].length,data[1][1].created,data[1][1].tag,data[1][1].color,data[2][1].id),function()
							ply:PS_TakePoints(NYEBLOCK.CLAN_JOIN_PRICE)
							local qs = [[
								UPDATE nyeblock_clans
								SET memberCount = (memberCount + 1)
								WHERE id = %i
							]]
							NYEBLOCK.DATABASES.NB_QUERY("nyeblock",string.format(qs,clanData.clanId))
							ply:SetNWBool("nyeblock_hasTag",true)
							ply:SetNWString("nyeblock_tag",util.TableToJSON(data[1][1]))
							ply:SetNWBool("nyeblock_inClan",true)
							data[1][1].userId = ply:GetNWInt("nyeblock_userId")
							data[1][1].clanId = clanData.clanId
							net.Start("nyeblock_returnJoinClanInfo")
								net.WriteBool(true)
								net.WriteString("Joined "..data[1][1].tag.." successfully!")
								net.WriteTable(data[1][1])
							net.Send(ply)
						end)
					else
						net.Start("nyeblock_returnJoinClanInfo")
							net.WriteBool(false)
							net.WriteString("Incorrect password entered!")
						net.Send(ply)
					end
				else
					net.Start("nyeblock_returnJoinClanInfo")
						net.WriteBool(false)
						net.WriteString("Error joining clan. Please refresh the clans page!")
					net.Send(ply)
				end
			else
				net.Start("nyeblock_returnJoinClanInfo")
					net.WriteBool(false)
					net.WriteString("Unable to join clan! No member spots are available!")
				net.Send(ply)
			end
		else
			net.Start("nyeblock_returnJoinClanInfo")
				net.WriteBool(false)
				net.WriteString("Unable to join clan! It is no longer active!")
			net.Send(ply)
		end
	end)
end)
net.Receive("nyeblock_getClanData",function(_,ply)
	local qs = [[
		SELECT *
		FROM nyeblock_clans
		WHERE userId = %i
	]]
	NYEBLOCK.DATABASES.NB_QUERY("nyeblock",string.format(qs,ply:GetNWInt("nyeblock_userId")),function(clanData)
		if #clanData > 0 then
			local qs = [[
				SELECT *
				FROM nyeblock_tags
				WHERE clanId = %i
			]]
			NYEBLOCK.DATABASES.NB_QUERY("nyeblock",string.format(qs,clanData[1].id),function(tagsData)
				if #tagsData > 0 then
					local memberIdsString = ""

					for k,v in pairs(tagsData) do
						if memberIdsString == "" then
							memberIdsString = "id = "..v.userId
						else
							memberIdsString = memberIdsString.." OR id = "..v.userId
						end
					end
					local qs = [[
						SELECT *
						FROM nyeblock_users
						WHERE %s
					]]
					NYEBLOCK.DATABASES.NB_QUERY("nyeblock",string.format(qs,memberIdsString),function(membersData)
						local tbl = {
							members = membersData,
							clanData = clanData[1]
						}

						net.Start("nyeblock_returnClanData")
							net.WriteBool(true)
							net.WriteTable(tbl)
						net.Send(ply)
					end)
				else
					local tbl = {
						members = {},
						clanData = clanData[1]
					}

					net.Start("nyeblock_returnClanData")
						net.WriteBool(true)
						net.WriteTable(tbl)
					net.Send(ply)
				end
			end)
		else
			ply:SetNWBool("nyeblock_hasTag",false)
			ply:SetNWString("nyeblock_tag","")
			ply:SetNWBool("nyeblock_hasClan",false)
			ply:SetNWBool("nyeblock_inClan",false)
			timer.Simple(.5,function()
				net.Start("nyeblock_returnClanData")
					net.WriteBool(false)
				net.Send(ply)
			end)
		end
	end)
end)
net.Receive("nyeblock_removeClanMember",function(_,ply)
	local userId = tonumber(net.ReadString())

	local qs = [[
		SELECT *
		FROM nyeblock_clans
		WHERE userId = %i
	]]
	NYEBLOCK.DATABASES.NB_QUERY("nyeblock",string.format(qs,ply:GetNWInt("nyeblock_userId")),function(clanData)
		if #clanData > 0 then
			local qs = [[
				SELECT clanId
				FROM nyeblock_tags
				WHERE userId = %i
			]]
			NYEBLOCK.DATABASES.NB_QUERY("nyeblock",string.format(qs,userId),function(isInClan)
				if #isInClan > 0 then
					if isInClan[1].clanId == clanData[1].id then
						local qs = [[
							DELETE
							FROM nyeblock_tags
							WHERE userId = %i
						]]
						NYEBLOCK.DATABASES.NB_QUERY("nyeblock",string.format(qs,userId))
						local qs = [[
							UPDATE nyeblock_clans
							SET memberCount = (memberCount - 1)
							WHERE id = %i
						]]
						NYEBLOCK.DATABASES.NB_QUERY("nyeblock",string.format(qs,clanData[1].id))
					end
				end
			end)
		end
	end)
end)
net.Receive("nyeblock_leaveClan",function(_,ply)
	local qs = [[
		SELECT *
		FROM nyeblock_tags
		WHERE userId = %i
	]]
	NYEBLOCK.DATABASES.NB_QUERY("nyeblock",string.format(qs,ply:GetNWInt("nyeblock_userId")),function(tagData)
		if #tagData > 0 then
			if tagData[1].clanId != nil then
				local qs = [[
					DELETE
					FROM nyeblock_tags
					WHERE userId = %i
				]]
				NYEBLOCK.DATABASES.NB_QUERY("nyeblock",string.format(qs,ply:GetNWInt("nyeblock_userId")))
				local qs = [[
					UPDATE nyeblock_clans
					SET memberCount = (memberCount - 1)
					WHERE id = %i
				]]
				NYEBLOCK.DATABASES.NB_QUERY("nyeblock",string.format(qs,tagData[1].clanId))
				ply:SetNWBool("nyeblock_hasTag",false)
				ply:SetNWString("nyeblock_tag","")
				ply:SetNWBool("nyeblock_inClan",false)
				timer.Simple(.5,function()
					net.Start("nyeblock_returnLeaveClanInfo")
						net.WriteBool(true)
					net.Send(ply)
				end)
			else
				ply:SetNWBool("nyeblock_inClan",false)
				net.Start("nyeblock_returnLeaveClanInfo")
					net.WriteBool(false)
					net.WriteString("Unexpected error! Refreshing page.")
				net.Send(ply)
			end
		else
			ply:SetNWBool("nyeblock_hasTag",false)
			ply:SetNWBool("nyeblock_inClan",false)
			timer.Simple(.5,function()
				net.Start("nyeblock_returnLeaveClanInfo")
					net.WriteBool(false)
					net.WriteString("Unexpected error! Refreshing page.")
				net.Send(ply)	
			end)
		end
	end)
end)
net.Receive("nyeblock_updateClanInfo",function(_,ply)
	local data = net.ReadTable()

	local qs = [[
		SELECT id
		FROM nyeblock_clans
		WHERE userId = %i
	]]
	NYEBLOCK.DATABASES.NB_QUERY("nyeblock",string.format(qs,ply:GetNWInt("nyeblock_userId")),function(clanData)
		if #clanData > 0 then
			if data.password != "" then
				local qs = [[
					UPDATE nyeblock_clans
					SET message = '%s', password = '%s'
					WHERE id = %i
				]]
				NYEBLOCK.DATABASES.NB_QUERY("nyeblock",string.format(qs,NYEBLOCK.DATABASES.NB:escape(data.message),NYEBLOCK.DATABASES.NB:escape(data.password),clanData[1].id))
			else
				local qs = [[
					UPDATE nyeblock_clans
					SET message = '%s', password = NULL
					WHERE id = %i
				]]
				NYEBLOCK.DATABASES.NB_QUERY("nyeblock",string.format(qs,NYEBLOCK.DATABASES.NB:escape(data.message),clanData[1].id))
			end
		end
	end)
end)
net.Receive("nyeblock_deleteClan",function(_,ply)
	local qs = [[
		SELECT id
		FROM nyeblock_clans
		WHERE userId = %i
	]]
	NYEBLOCK.DATABASES.NB_QUERY("nyeblock",string.format(qs,ply:GetNWInt("nyeblock_userId")),function(clanData)
		if #clanData > 0 then
			local qs = [[
				DELETE
				FROM nyeblock_clans
				WHERE id = %i
			]]
			NYEBLOCK.DATABASES.NB_QUERY("nyeblock",string.format(qs,clanData[1].id),function()
				ply:SetNWBool("nyeblock_inClan",false)
				ply:SetNWBool("nyeblock_hasClan",false)
				timer.Simple(.5,function()
					net.Start("nyeblock_successfullyDeletedClan")
					net.Send(ply)
				end)
			end)
			local qs = [[
				DELETE
				FROM nyeblock_tags
				WHERE clanId = %i
			]]
			NYEBLOCK.DATABASES.NB_QUERY("nyeblock",string.format(qs,clanData[1].id))
		end
	end)
end)
net.Receive("nyeblock_resetTagNWStrings",function(_,ply)
	ply:SetNWBool("nyeblock_hasTag",false)
	ply:SetNWString("nyeblock_tag","")
	ply:SetNWBool("nyeblock_hasClan",false)
	ply:SetNWBool("nyeblock_inClan",false)
end)
net.Receive("nyeblock_checkClanExpired",function(_,ply)
	local tagId = tonumber(net.ReadString())

	local qs = [[
		SELECT *
		FROM nyeblock_tags
		WHERE id = %i
	]]
	NYEBLOCK.DATABASES.NB_QUERY("nyeblock",string.format(qs,tagId),function(tagData)
		if #tagData > 0 then
			if tagData[1].length != 0 then
				if (tagData[1].length + tagData[1].created) - os.time() < 2 then
					local qs = [[
						DELETE
						FROM nyeblock_clans
						WHERE tagId = %i
					]]
					NYEBLOCK.DATABASES.NB_QUERY("nyeblock",string.format(qs,tagId))
					net.Start("nyeblock_returnClanExpired")
					net.Send(ply)
				end
			end
		end
	end)
end)

hook.Add("PlayerInitialSpawn","setTag",function(ply)
	timer.Simple(5,function()
		local qs = [[
			SELECT *
			FROM nyeblock_tags
			WHERE userId = %i
		]]
		NYEBLOCK.DATABASES.NB_QUERY("nyeblock",string.format(qs,ply:GetNWInt("nyeblock_userId")),function(tagData)
			if #tagData > 0 then
				ply:SetNWString("nyeblock_tag",util.TableToJSON(tagData[1]))
			end
		end)
	end)
end)
hook.Add("Initialize","startTimer",function()
	timer.Create("tagSystem_checkTags",15,0,function()
		local removeString = ""
		local tagIdString = ""
		local expiredTagUsers = {}

		local qs = [[
			SELECT *
			FROM nyeblock_tags
		]]
		NYEBLOCK.DATABASES.NB_QUERY("nyeblock",qs,function(tagData)
			for k,v in pairs(tagData) do
				if v.length != 0 then
					if (v.length + v.created) - os.time() < 0 then
						if removeString == "" then
							removeString = "id = "..v.id
							tagIdString = "tagId = "..v.id
						else
							removeString = removeString.." OR id = "..v.id
							tagIdString = tagIdString.." OR tagId = "..v.id
						end
						table.insert(expiredTagUsers,v.userId)
					end
				end
			end
			if removeString != "" then
				local qs = [[
					DELETE
					FROM nyeblock_tags
					WHERE %s
				]]
				NYEBLOCK.DATABASES.NB_QUERY("nyeblock",string.format(qs,removeString))
				local qs = [[
					DELETE
					FROM nyeblock_clans
					WHERE %s
				]]
				NYEBLOCK.DATABASES.NB_QUERY("nyeblock",string.format(qs,tagIdString))
			end
			for k,v in pairs(player.GetAll()) do
				if table.HasValue(expiredTagUsers,v:GetNWInt("nyeblock_userId")) then
					v:SetNWBool("nyeblock_hasTag",false)
					v:SetNWString("nyeblock_tag","")
					v:SetNWBool("nyeblock_hasClan",false)
					v:SetNWBool("nyeblock_inClan",false)
				end
			end
		end)
	end)
end)