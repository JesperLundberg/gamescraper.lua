local M = {}

local shared = require("database.shared")

-- The database
local db = shared.setup("raw_data.db")

--- Get a record from the database by date
--- @param date osdate|string The date of the record
--- @return table {date = osdate|string, json = string} The record
function M.get_raw_data_by_date(date)
	-- Find the record
	local record = db.raw_data:get({ where = { date = date } })

	local raw_data = {}

	if next(record) ~= nil then
		raw_data = {
			date = record[1].date,
			json = record[1].json,
		}
	end

	-- Return the data or an empty table
	return raw_data
end

--- Update a record in the database
--- @param date osdate|string The date of the record
--- @param json string The JSON data to update
function M.update_raw_data(date, json)
	-- Find the record and update it
	db.raw_data:update({
		where = { date = date },
		set = { json = json },
	})
end

--- Insert a new record into the database
--- @param date osdate|string The date of the record
--- @param json string The JSON data to insert
function M.insert_raw_data(date, json)
	-- Find out if the record already exists
	if next(M.get_raw_data_by_date(date)) then
		-- If it does, update it
		M.update_raw_data(date, json)

		-- Log the update
		print(date .. " Raw data was updated.")

		-- Exit early
		return
	end

	-- Log the insert
	print(date .. " Raw data was inserted.")

	-- Otherwise, insert it
	db.raw_data:insert({
		date = date,
		json = json,
	})
end

return M
