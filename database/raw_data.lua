local M = {}

local shared = require("database.shared")

-- The database
local db

--- Get a record from the database by date
--- @param date osdate|string The date of the record
--- @return table {date = osdate|string, json = string} The record
function M.get_raw_data_by_date(date)
	-- Setup the database
	db = shared.setup()

	-- Find the record
	return db.raw_data:get({ where = { date = date } })
end

--- Update a record in the database
--- @param date osdate|string The date of the record
--- @param json string The JSON data to update
function M.update_raw_data(date, json)
	-- Setup the database
	db = shared.setup()

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
	-- Setup the database
	db = shared.setup()

	-- Find out if the record already exists
	if M.get_raw_data_by_date(date) then
		-- If it does, update it
		M.update_raw_data(date, json)

		-- Exit early
		return
	end

	-- Otherwise, insert it
	db.raw_data:insert({
		date = date,
		json = json,
	})
end

return M
