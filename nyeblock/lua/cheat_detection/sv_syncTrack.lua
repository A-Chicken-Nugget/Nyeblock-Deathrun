local playerSync = {}

function NYEBLOCK.FUNCTIONS.getPlayerSync(ply)
	local sync = nil

	if playerSync[ply] != nil then
		sync = playerSync[ply].percentage
	end
	return sync
end

hook.Add("SetupMove","blah",function(ply,mv,cmd)
	local mouse_x = cmd:GetMouseX()
	local pressedButton = mv:GetButtons()

	if playerSync[ply] == nil then
		playerSync[ply] = {
			lastDiff = 0,
			latestDiffs = {},
			average = 0,
			percentage = 0,
			lastMouseDirection = nil,
			lastMouseMovement = {},
			lastKeyPress = {},
			pressedLeft = false,
			pressedRight = false
		}
	end

	if mouse_x != 0 then
		if mouse_x < 0 then
			if !playerSync[ply].pressedLeft and playerSync[ply].lastMouseDirection != "left" then
				playerSync[ply].lastMouseMovement = {
					direction = "left",
					curTime = CurTime(),
					completed = false
				}
				playerSync[ply].pressedLeft = true
				playerSync[ply].lastMouseDirection = "left"
			end
		else
			if !playerSync[ply].pressedRight and playerSync[ply].lastMouseDirection != "right" then
				playerSync[ply].lastMouseMovement = {
					direction = "right",
					curTime = CurTime(),
					completed = false
				}
				playerSync[ply].pressedRight = true
				playerSync[ply].lastMouseDirection = "right"
			end
		end
	else
		playerSync[ply].pressedLeft = false
		playerSync[ply].pressedRight = false
	end
	if pressedButton == 512 or pressedButton == 520 then
		if !ply:GetNWBool("sync_leftKeyDown",false) then
			ply:SetNWBool("sync_leftKeyDown",true)
			playerSync[ply].lastKeyPress = {
				direction = "left",
				curTime = CurTime()
			}
		else
			playerSync[ply].lastKeyPress = {
				direction = "left",
				curTime = CurTime()
			}
		end
	elseif pressedButton == 1024 or pressedButton == 1032 then
		if !ply:GetNWBool("sync_rightKeyDown",false) then
			ply:SetNWBool("sync_rightKeyDown",true)
			playerSync[ply].lastKeyPress = {
				direction = "right",
				curTime = CurTime()
			}
		else
			playerSync[ply].lastKeyPress = {
				direction = "right",
				curTime = CurTime()
			}
		end
	else
		ply:SetNWBool("sync_rightKeyDown",false)
		ply:SetNWBool("sync_leftKeyDown",false)
	end

	if mouse_x != 0 then
		if playerSync[ply] != nil then
			if (playerSync[ply].lastMouseMovement and playerSync[ply].lastKeyPress != nil) and (!playerSync[ply].lastMouseMovement.completed and !playerSync[ply].lastKeyPress.completed) then
				if playerSync[ply].lastMouseMovement.direction == "left" and playerSync[ply].lastKeyPress.direction == "left" then
					local diff = math.abs(playerSync[ply].lastMouseMovement.curTime - playerSync[ply].lastKeyPress.curTime)

					if diff <= 3 then
						playerSync[ply].lastdiff = diff
						playerSync[ply].lastMouseMovement.completed = true
						playerSync[ply].lastKeyPress.completed = true
						table.insert(playerSync[ply].latestDiffs,playerSync[ply].lastdiff)
					end
				elseif playerSync[ply].lastMouseMovement.direction == "right" and playerSync[ply].lastKeyPress.direction == "right" then
					local diff = math.abs(playerSync[ply].lastMouseMovement.curTime - playerSync[ply].lastKeyPress.curTime)

					if diff <= 3 then
						playerSync[ply].lastdiff = diff
						playerSync[ply].lastMouseMovement.completed = true
						playerSync[ply].lastKeyPress.completed = true
						table.insert(playerSync[ply].latestDiffs,playerSync[ply].lastdiff)
					end
				end
			end
			if table.Count(playerSync[ply].latestDiffs) > 20 then
				local total = 0
				
				table.remove(playerSync[ply].latestDiffs,1)
				for k,v in pairs(playerSync[ply].latestDiffs) do
					total = total + v
				end
				playerSync[ply].percentage = 100-((total/20)*100)
			end
		end
	end
end)