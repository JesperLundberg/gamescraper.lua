local steam_api = require("steam_api")
local database = require("database.raw_data")

-- Get the raw json data from the Steam API
local raw_json = steam_api.get_raw_data_2_weeks()

-- Initialize the database
database.setup()

-- Get todays date in string format
local date = os.date("%Y-%m-%d")

-- Insert the raw json data into the database
database.insert_raw_data(date, raw_json)
