local M = {}

local steam_api = require("http.steam_api")
local database_raw_data = require("database.raw_data")

--- Create the raw data layer for the given date
--- @param date osdate|string The date in the format "YYYY-MM-DD"
function M.create_raw_data_layer(date)
	-- Get the raw json data from the Steam API
	local raw_json = steam_api.get_raw_data_2_weeks()

	-- Insert the raw json data into the database
	database_raw_data.insert_raw_data(date, raw_json)
end

return M
