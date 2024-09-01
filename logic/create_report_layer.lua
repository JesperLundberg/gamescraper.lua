local database_raw_data = require("database.raw_data")
local database_report_layer = require("database.report_layer")
local utils = require("utils")

local M = {}

--- Create a report layer
--- @param date osdate|string The date of the report layer
function M.create_report_layer(date)
	-- Get the raw data by sent in date or todays date
	local raw_data = database_raw_data.get_raw_data_by_date(date or os.date("%Y-%m-%d"))

	-- If there is no raw data, return nil to indicate that nothing was done
	if not next(raw_data) then
		return nil
	end

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
			playtime_forever = v.playtime_forever,
		})
	end
end

function M.create_report_data_to_today()
	-- Get the last run date
	local last_run = database_report_layer.get_last_run()

	-- if the last run date is today, do nothing
	if last_run == os.date("%Y-%m-%d") then
		return
	end

	-- For each date between the last run date and today, run create_report_layer(date)
	local current_date = last_run

	while current_date ~= os.date("%Y-%m-%d") do
		print("Creating report layer for " .. current_date)

		-- Create the report layer for the current date
		M.create_report_layer(current_date)

		-- Get the next day in the loop
		current_date = utils.get_next_day(current_date)
	end

	-- Update the last run date to today
	database_report_layer.update_last_run(last_run)
end

return M
