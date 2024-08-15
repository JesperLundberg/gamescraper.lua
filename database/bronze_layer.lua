local M = {}

local shared = require("database.shared")

-- The database
local db

--- Get a record from the database by date
--- @param date osdate|string The date of the record
--- @param appid number The appid of the record
--- @return table|boolean The record or false
function M.get_bronze_data_by_date(date, appid)
	-- Setup the database
	db = shared.setup()

	-- Find the record
	-- return db.bronze_layer:get({ where = { { date = date }, { appid = appid } } }) -- NOTE: NEED to have appid in the where clause as well
	return db:eval("SELECT * FROM bronze_layer WHERE date = " .. date .. " AND appid =" .. appid)
end

--- Update a record in the database
--- @param date osdate|string The date of the record
--- @param appid number The appid of the record
--- @param bronze_data table The table to update
function M.update_bronze_layer(date, appid, bronze_data)
	-- Setup the database
	db = shared.setup()

	-- Find the record and update it
	db.bronze_layer:update({
		where = { date = date and { appid = appid } },
		set = { bronze_layer = bronze_data },
	})
end

--- Insert a new record into the database
--- @param bronze_data table The table to insert
function M.insert_bronze_data(bronze_data)
	-- Setup the database
	db = shared.setup()

	for k, v in pairs(bronze_data) do
		print(k, v)
	end

	-- Find out if the record already exists
	if M.get_bronze_data_by_date(bronze_data.date, bronze_data.appid) then
		-- If it does, update it
		M.update_bronze_layer(bronze_data.date, bronze_data.appid, bronze_data)

		-- Exit early
		return
	end

	print("Inserting bronze data")

	-- Otherwise, insert it
	db.bronze_layer:insert({
		bronze_layer = bronze_data,
	})
end

return M
