local M = {}

local shared = require("database.shared")

-- The database
local db = shared.setup("report_layer.sqlite")

--- Get a record from the database by date
--- @param date osdate|string The date of the record
--- @param appid number The appid of the record
--- @return table The record
function M.get_report_data_by_date_and_appid(date, appid)
	-- Find the record
	return db.report_layer:get({ where = { date_fetched = date, appid = appid } })
end

--- Get all games played on a specific date
--- @param date osdate|string The date to get
--- @return table The records
function M.get_report_data_by_date(date)
	-- Find the record
	return db.report_layer:select({ where = { date_fetched = date } })
end

-- TODO: This needs to be moved, it should not be here, it should be in the logic layer
-- TODO: Create a timestamp for the last run date (get and update)
function M.create_report_data_to_today()
	-- Get the last run date
	local last_run = db.last_run:get()[1]

	if next(last_run) == nil then
		last_run.timestamp = "2020-01-01"
	end

	print(last_run.timestamp)

	-- if the last run date is today, do nothing
	if last_run.timestamp == os.date("%Y-%m-%d") then
		return
	end

	-- For each date between the last run date and today (inclusive),
	-- run create_report_layer(date)
	local current_date = last_run.timestamp

	while current_date ~= os.date("%Y-%m-%d") do
		create_report_layer.create_report_layer(current_date)

		-- Increment the current date by one day (86400 seconds is one day)
		current_date = os.date(
			"%Y-%m-%d",
			os.time({
				year = tonumber(current_date:sub(1, 4)),
				month = tonumber(current_date:sub(6, 7)),
				day = tonumber(current_date:sub(9, 10)),
			} + 86400)
		)
	end

	-- Update the last run date
	db.last_run:update({
		where = { timestamp = last_run.timestamp },
		set = { timestamp = os.date("%Y-%m-%d") },
	})
end

--- Update a record in the database
--- @param date osdate|string The date of the record
--- @param appid number The appid of the record
--- @param report_data table The table to update
function M.update_report_layer(date, appid, report_data)
	-- Find the record and update it
	db.report_layer:update({
		where = { date_fetched = date, appid = appid },
		set = {
			date_fetched = report_data.date,
			appid = report_data.appid,
			name = report_data.name,
			playtime_forever = report_data.playtime_forever,
		},
	})
end

--- Insert a new record into the database
--- @param report_data table The table to insert
function M.insert_report_data(report_data)
	-- Find out if the record already exists
	if next(M.get_report_data_by_date_and_appid(report_data.date, report_data.appid)) then
		-- If it does, update it
		M.update_report_layer(report_data.date, report_data.appid, report_data)

		-- Log the update
		print(report_data.date .. " " .. report_data.name .. " was updated in the report layer.")

		-- Exit early
		return
	end

	-- Otherwise, insert it
	db.report_layer:insert({
		date_fetched = report_data.date,
		appid = report_data.appid,
		name = report_data.name,
		playtime_forever = report_data.playtime_forever,
	})

	print(report_data.date .. " " .. report_data.name .. " was inserted into the report layer.")
end

return M
