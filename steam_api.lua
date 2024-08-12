-- package.path = package.path .. ";local/share/lua/5.4/?.lua"

local M = {}

local http_request = require("http.request")
local lunajson = require("lunajson")

function M.send_request()
	local call_to_uri = http_request.new_from_uri(
		"https://api.steampowered.com/IPlayerService/GetRecentlyPlayedGames/v0001/?key=117C47BC5FE8BEE05760813F7E724193&steamid=76561198051655301&format=json"
	)

	local headers, stream = assert(call_to_uri:go())

	if headers:get(":status") ~= "200" then
		error("HTTP request failed: " .. headers:get(":status"))
	end

	local body = assert(stream:get_body_as_string())
	print(body)
	local decoded_body = lunajson.decode(body)

	for _, v in ipairs(decoded_body.response.games) do
		print(v)
	end
end

return M
