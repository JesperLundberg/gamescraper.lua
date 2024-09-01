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

--- Get the last run date
--- @return string|osdate The last run date
function M.get_last_run()
	-- Get the last run date from the database
	local last_run = db.last_run:get()[1]

	-- If there is no last run date, set it to a date in the past
	if last_run == nil or next(last_run) == nil then
		last_run = {}
		last_run.timestamp = "2024-08-20"
	end

	return last_run.timestamp
end

--- Update the last run date
--- @param to_update osdate|string The date to update
function M.update_last_run(to_update)
	-- Update the last run date
	db.last_run:update({
		where = { timestamp = to_update },
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
