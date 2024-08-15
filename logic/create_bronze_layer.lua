local database_raw_data = require("database.raw_data")
local database_bronze_layer = require("database.bronze_layer")

local M = {}

--- Create a bronze layer
--- @param date osdate|string The date of the bronze layer
function M.create_bronze_layer(date)
	-- Get the raw data by sent in date or todays date
	local raw_data = database_raw_data.get_raw_data_by_date(date or os.date("%Y-%m-%d"))

	-- Create the bronze layer
	local bronze_layer = {
		date = raw_data.date,
		appid = raw_data.appid,
		name = raw_data.name,
		playtime_2weeks = raw_data.playtime_2weeks,
		playtime_forever = raw_data.playtime_forever,
		img_icon_url = raw_data.img_icon_url,
		playtime_windows_forever = raw_data.playtime_windows_forever,
		playtime_mac_forever = raw_data.playtime_mac_forever,
		playtime_linux_forever = raw_data.playtime_linux_forever,
		playtime_deck_forever = raw_data.playtime_deck_forever,
	}

	-- Insert the bronze layer
	database_bronze_layer.insert_bronze_layer(bronze_layer)
end

return M
