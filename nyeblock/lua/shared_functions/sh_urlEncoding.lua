local char_to_hex = function(c)
	return string.format("%%%02X", string.byte(c))
end

function NYEBLOCK.FUNCTIONS.encodeURL(url)
	if url != nil then
		url = url:gsub("\n", "\r\n")
		url = url:gsub("([^%w _ %- . ~])", char_to_hex)
		url = url:gsub(" ", "+")
		return url
	end
end

local hex_to_char = function(x)
	return string.char(tonumber(x, 16))
end

function NYEBLOCK.FUNCTIONS.decodeURL(url)
	if url != nil then
		url = url:gsub("+", " ")
		url = url:gsub("%%(%x%x)", hex_to_char)
		return url
	end
end