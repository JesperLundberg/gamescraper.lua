local raw_layer = require("logic.create_raw_data_layer")
local bronze_layer = require("logic.create_bronze_layer")

-- Get todays date in string format
local date = os.date("%Y-%m-%d")

-- Create the raw data layer for todays date
raw_layer.create_raw_data_layer(date)

-- Create the bronze layer for todays date
bronze_layer.create_bronze_layer(date)

print("Done!")
