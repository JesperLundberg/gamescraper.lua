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
	return db.report_layer:get({ where = { date = date, appid = appid } })
end

--- Get all games played on a specific date
--- @param date osdate|string The date to get
--- @return table The records
function M.get_report_data_by_date(date)
	-- Find the record
	return db.report_layer:select({ where = { date = date } })
end

--- Get all record between two dates
--- @param start_date osdate|string The start date
--- @param end_date osdate|string The end date
--- @return table The records
function M.get_report_data_between_dates(start_date, end_date)
	-- Find the record
	return db.report_layer:select({ where = { date = { "BETWEEN", start_date, end_date } } })
end

--- Update a record in the database
--- @param date osdate|string The date of the record
--- @param appid number The appid of the record
--- @param report_data table The table to update
function M.update_report_layer(date, appid, report_data)
	-- Find the record and update it
	db.report_layer:update({
		where = { date = date, appid = appid },
		set = {
			date = report_data.date,
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
		date = report_data.date,
		appid = report_data.appid,
		name = report_data.name,
		playtime_forever = report_data.playtime_forever,
	})

	print(report_data.date .. " " .. report_data.name .. " was inserted into the report layer.")
end

return M
