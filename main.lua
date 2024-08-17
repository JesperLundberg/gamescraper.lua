local steam_api = require("http.steam_api")
local database_raw_data = require("database.raw_data")
local database_bronze_layer = require("database.bronze_layer")
local utils = require("utils")

-- Get the raw json data from the Steam API
local raw_json = steam_api.get_raw_data_2_weeks()

-- Get todays date in string format
local date = os.date("%Y-%m-%d")

-- Insert the raw json data into the database
database_raw_data.insert_raw_data(date, raw_json)

-- Make the raw json into a table
local bronze_layer = utils.json_to_table(raw_json)

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

	print("Inserted: " .. v.name)
end

print("Done!")
