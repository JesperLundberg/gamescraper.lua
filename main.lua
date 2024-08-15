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

-- for k, v in pairs(bronze_layer.games) do
-- 	for k2, v2 in pairs(v) do
-- 		print(k2, v2)
-- 	end
-- end

bronze_layer = utils.flatten_gamedata(bronze_layer.games)

database_bronze_layer.insert_bronze_data({
	date = date,
	appid = bronze_layer.appid,
	name = bronze_layer.name,
	playtime_2weeks = bronze_layer.playtime_2weeks,
	playtime_forever = bronze_layer.playtime_forever,
	img_icon_url = bronze_layer.img_icon_url,
	playtime_windows_forever = bronze_layer.playtime_windows_forever,
	playtime_mac_forever = bronze_layer.playtime_mac_forever,
	playtime_linux_forever = bronze_layer.playtime_linux_forever,
	playtime_deck_forever = bronze_layer.playtime_deck_forever,
})
