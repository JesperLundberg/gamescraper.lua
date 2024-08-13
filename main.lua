local steam_api = require("steam_api")
local database = require("database")

local raw_json = steam_api.get_raw_data_2_weeks()

-- print("From main.lua: " .. raw_json)

database.setup()
