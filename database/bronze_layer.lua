local M = {}

local shared = require("database.shared")

-- The database
local db = shared.setup()

--- Get a record from the database by date
--- @param date osdate|string The date of the record
--- @param appid number The appid of the record
--- @return table The record
function M.get_bronze_data_by_date_and_appid(date, appid)
	-- Find the record
	return db.bronze_layer:get({ where = { date = date, appid = appid } })
end

--- Update a record in the database
--- @param date osdate|string The date of the record
--- @param appid number The appid of the record
--- @param bronze_data table The table to update
function M.update_bronze_layer(date, appid, bronze_data)
	-- Find the record and update it
	db.bronze_layer:update({
		where = { date = date, appid = appid },
		set = {
			date = bronze_data.date,
			appid = bronze_data.appid,
			name = bronze_data.name,
			playtime_2weeks = bronze_data.playtime_2weeks,
			playtime_forever = bronze_data.playtime_forever,
			img_icon_url = bronze_data.img_icon_url,
			playtime_windows_forever = bronze_data.playtime_windows_forever,
			playtime_mac_forever = bronze_data.playtime_mac_forever,
			playtime_linux_forever = bronze_data.playtime_linux_forever,
			playtime_deck_forever = bronze_data.playtime_deck_forever,
		},
	})
end

--- Insert a new record into the database
--- @param bronze_data table The table to insert
function M.insert_bronze_data(bronze_data)
	-- Find out if the record already exists
	if M.get_bronze_data_by_date_and_appid(bronze_data.date, bronze_data.appid) ~= {} then
		-- If it does, update it
		M.update_bronze_layer(bronze_data.date, bronze_data.appid, bronze_data)

		-- Log the update
		print(bronze_data.name .. " was updated in the bronze layer.")

		-- Exit early
		return
	end

	-- Otherwise, insert it
	db.bronze_layer:insert({
		date = bronze_data.date,
		appid = bronze_data.appid,
		name = bronze_data.name,
		playtime_2weeks = bronze_data.playtime_2weeks,
		playtime_forever = bronze_data.playtime_forever,
		img_icon_url = bronze_data.img_icon_url,
		playtime_windows_forever = bronze_data.playtime_windows_forever,
		playtime_mac_forever = bronze_data.playtime_mac_forever,
		playtime_linux_forever = bronze_data.playtime_linux_forever,
		playtime_deck_forever = bronze_data.playtime_deck_forever,
	})

	print(bronze_data.name .. " was inserted into the bronze layer.")
end

return M
