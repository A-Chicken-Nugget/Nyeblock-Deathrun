function nyeblock_getCurrentSeason()
	local currentMonth = tonumber(os.date("%m", os.time()))
	local currentDay = tonumber(os.date("%d", os.time()))

	//Christmas
	if currentMonth == 12 and (currentDay >= 20 and currentDay <= 26) then
		return "christmas"
	//Halloween
	elseif currentMonth == 10 and (currentDay >= 25 and currentDay <= 31) then
		return "halloween"
	//Thanksgiving
	-- elseif currentMonth == 11 and (currentDay >= 23 and currentDay <= 30) then
	elseif currentMonth == 12 and (currentDay >= 1 and currentDay <= 3) then
		return "thanksgiving"
	end
end
function nyeblock_getSeasonMenuInfo(season)
	if NYEBLOCK.SEASONS[season] != nil then
        return NYEBLOCK.SEASONS[season]
    end
end