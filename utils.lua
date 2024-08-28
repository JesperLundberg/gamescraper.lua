local M = {}

local lunajson = require("lunajson")

--- Table inspector
--- @param tbl table The table to inspect
--- @param indent? number The indentation level
function M.tprint(tbl, indent)
	if not indent then
		indent = 0
	end
	local toprint = string.rep(" ", indent) .. "{\r\n"
	indent = indent + 2
	for k, v in pairs(tbl) do
		toprint = toprint .. string.rep(" ", indent)
		if type(k) == "number" then
			toprint = toprint .. "[" .. k .. "] = "
		elseif type(k) == "string" then
			toprint = toprint .. k .. "= "
		end
		if type(v) == "number" then
			toprint = toprint .. v .. ",\r\n"
		elseif type(v) == "string" then
			toprint = toprint .. '"' .. v .. '",\r\n'
		elseif type(v) == "table" then
			toprint = toprint .. M.tprint(v, indent + 2) .. ",\r\n"
		else
			toprint = toprint .. '"' .. tostring(v) .. '",\r\n'
		end
	end
	toprint = toprint .. string.rep(" ", indent - 2) .. "}"
	return toprint
end

--- Convert a JSON string to a table
--- @param json string The JSON string to convert
--- @return table The table
function M.json_to_table(json)
	if not json then
		error("No JSON string provided")
	end

	return lunajson.decode(json).response
end

--- Flatten the table into a table with each row being a table
function M.flatten_gamedata(tab)
	local flattened_table = {}

	for _, v in pairs(tab) do
		table.insert(flattened_table, v)
	end

	return flattened_table
end

--- Get the configuration from the config_local.lua file if it exists, otherwise get the configuration from the config.lua file
--- @return configuration|LazyCoreConfig
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
