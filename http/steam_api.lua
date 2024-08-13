local M = {}

local http_request = require("http.request")
local lunajson = require("lunajson")

local utils = require("utils")
local config = utils.get_config()

--- Get the raw data from the Steam API for the last two weeks
--- @return string The raw data from the Steam API (in json format)
function M.get_raw_data_2_weeks()
	-- Create a new HTTP request
	local call_to_uri = http_request.new_from_uri(
		"https://api.steampowered.com/IPlayerService/GetRecentlyPlayedGames/v0001/?key="
			.. config.steam_api_key
			.. "&steamid="
			.. config.steam_user_id
			.. "&format=json"
	)

	-- Perform the HTTP request
	local headers, stream = assert(call_to_uri:go())

	-- Check if the HTTP request was successful
	if headers:get(":status") ~= "200" then
		error("HTTP request failed: " .. headers:get(":status"))
	end

	-- Get the body of the HTTP response as a string
	local body = assert(stream:get_body_as_string())

	-- NOTE: Temporary, remove this
	local decoded_body = lunajson.decode(body)
	for _, v in ipairs(decoded_body.response.games) do
		print(v.name)
	end

	-- Return the body (in json format)
	return body
end

return M
