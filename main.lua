local steam_api = require("http.steam_api")
local database_raw_data = require("database.raw_data")
local bronze_layer = require("logic.create_bronze_layer")

-- Get the raw json data from the Steam API
local raw_json = steam_api.get_raw_data_2_weeks()

-- Get todays date in string format
local date = os.date("%Y-%m-%d")

-- Insert the raw json data into the database
database_raw_data.insert_raw_data(date, raw_json)

-- Create the bronze layer for todays date
bronze_layer.create_bronze_layer(date)

print("Done!")
