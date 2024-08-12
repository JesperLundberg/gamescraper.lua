local M = {}

local http_request = require("http.request")
local lunajson = require("lunajson")

local config = require("config_local")

function M.get_raw_data_2_weeks()
	local call_to_uri = http_request.new_from_uri(
		"https://api.steampowered.com/IPlayerService/GetRecentlyPlayedGames/v0001/?key="
			.. config.steam_api_key
			.. "&steamid="
			.. config.steam_user_id
			.. "&format=json"
	)

	local headers, stream = assert(call_to_uri:go())

	if headers:get(":status") ~= "200" then
		error("HTTP request failed: " .. headers:get(":status"))
	end

	local body = assert(stream:get_body_as_string())
	local decoded_body = lunajson.decode(body)

	for _, v in ipairs(decoded_body.response.games) do
		print(v.name)
	end

	return body
end

return M
