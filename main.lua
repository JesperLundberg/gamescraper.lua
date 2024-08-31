local raw_layer = require("logic.create_raw_data_layer")
local report_layer = require("logic.create_report_layer")

-- Create the report layer for all dates between the last run date and today
report_layer.create_report_data_to_today()

-- Get todays date in string format
local date = os.date("%Y-%m-%d")

-- Create the raw data layer for todays date
raw_layer.create_raw_data_layer(date)

-- Create the report layer for todays date
report_layer.create_report_layer(date)

print("Done!")
