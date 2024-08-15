local M = {}

local lunajson = require("lunajson")

--- Convert a JSON string to a table
--- @param json string The JSON string to convert
--- @return table The table
function M.json_to_table(json)
	return lunajson.decode(json).response
end

--- Flatten the table into a table with each row being a table
function M.flatten_gamedata(tab)
	local flattened_table = {}

	for k, v in pairs(tab) do
		table.insert(flattened_table, v)
	end

	return flattened_table
end

--- Get the configuration from the config_local.lua file if it exists, otherwise get the configuration from the config.lua file
function M.get_config()
	-- Check if the config_local.lua file exists
	local status, config = pcall(require, "config_local")

	-- If the config_local.lua file exists, return the configuration from that file
	if status then
		return config
	end

	-- Return the configuration from the config.lua file as a fallback
	return require("config")
end

return M
