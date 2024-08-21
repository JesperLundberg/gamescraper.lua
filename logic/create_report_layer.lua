local database_raw_data = require("database.raw_data")
local database_report_layer = require("database.report_layer")
local utils = require("utils")

local M = {}

--- Create a report layer
--- @param date osdate|string The date of the report layer
function M.create_report_layer(date)
	-- Get the raw data by sent in date or todays date
	local raw_data = database_raw_data.get_raw_data_by_date(date or os.date("%Y-%m-%d"))

	-- Make the raw json into a table
	local report_layer = utils.json_to_table(raw_data.json)

	-- Flatten the structure into a table with each row being a table
	report_layer = utils.flatten_gamedata(report_layer.games)

	-- Insert the report layer into the database (or update if it already exists)
	for _, v in pairs(report_layer) do
		database_report_layer.insert_report_data({
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
