local M = {}

local shared = require("database.shared")

-- The database
local db = shared.setup("played_layer.sqlite")

--- Get a record from the database by date
--- @param date osdate|string The date of the record
--- @param appid number The appid of the record
--- @return table The record
function M.get_played_data_by_date_and_appid(date, appid)
	-- Find the record
	return db.played_layer:get({ where = { date_fetched = date, appid = appid } })
end

--- Get all games played on a specific date
--- @param date osdate|string The date to get
--- @return table The records
function M.get_played_data_by_date(date)
	-- Find the record
	return db.played_layer:select({ where = { date_fetched = date } })
end

--- Get the last run date
--- @return string|osdate The last run date
function M.get_last_run()
	-- Get the last run date from the database
	local last_run = db.last_run:get()[1]

	-- If there is no last run date, set it to a date in the past
	if last_run == nil or next(last_run) == nil then
		last_run = {}
		last_run.timestamp = "2024-08-01"
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
--- @param played_data table The table to update
function M.update_played_layer(date, appid, played_data)
	-- Find the record and update it
	db.played_layer:update({
		where = { date_fetched = date, appid = appid },
		set = {
			date_fetched = played_data.date,
			appid = played_data.appid,
			name = played_data.name,
			playtime_forever = played_data.playtime_forever,
		},
	})
end

--- Insert a new record into the database
--- @param played_data table The table to insert
function M.insert_played_data(played_data)
	-- Find out if the record already exists
	if next(M.get_played_data_by_date_and_appid(played_data.date, played_data.appid)) then
		-- If it does, update it
		M.update_played_layer(played_data.date, played_data.appid, played_data)

		-- Log the update
		print(played_data.date .. " " .. played_data.name .. " was updated in the played layer.")

		-- Exit early
		return
	end

	-- Otherwise, insert it
	db.played_layer:insert({
		date_fetched = played_data.date,
		appid = played_data.appid,
		name = played_data.name,
		playtime_forever = played_data.playtime_forever,
	})

	print(played_data.date .. " " .. played_data.name .. " was inserted into the played layer.")
end

return M
