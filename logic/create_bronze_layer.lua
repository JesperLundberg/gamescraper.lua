local database_raw_data = require("database.raw_data")
local database_bronze_layer = require("database.bronze_layer")
local utils = require("utils")

local M = {}

--- Create a bronze layer
--- @param date osdate|string The date of the bronze layer
function M.create_bronze_layer(date)
	-- Get the raw data by sent in date or todays date
	local raw_data = database_raw_data.get_raw_data_by_date(date or os.date("%Y-%m-%d"))

	-- Make the raw json into a table
	local bronze_layer = utils.json_to_table(raw_data.json)

	-- Flatten the structure into a table with each row being a table
	bronze_layer = utils.flatten_gamedata(bronze_layer.games)

	-- Insert the bronze layer into the database (or update if it already exists)
	for _, v in pairs(bronze_layer) do
		database_bronze_layer.insert_bronze_data({
			date = date,
			appid = v.appid,
			name = v.name,
			playtime_2weeks = v.playtime_2weeks,
			playtime_forever = v.playtime_forever,
			img_icon_url = v.img_icon_url,
			playtime_windows_forever = v.playtime_windows_forever,
			playtime_mac_forever = v.playtime_mac_forever,
			playtime_linux_forever = v.playtime_linux_forever,
			playtime_deck_forever = v.playtime_deck_forever,
		})
	end
end

return M
